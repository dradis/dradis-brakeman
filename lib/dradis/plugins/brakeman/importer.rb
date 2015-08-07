module Dradis::Plugins::Brakeman
  class Importer < Dradis::Plugins::Upload::Importer
    # The framework will call this function if the user selects this plugin from
    # the dropdown list and uploads a file.
    # @returns true if the operation was successful, false otherwise
    def import(params={})

      # Parse the uploaded file into a Ruby Hash
      logger.info { "Parsing Brakeman output from #{ params[:file] }..." }
      data = MultiJson.decode(file_content)
      logger.info { 'Done.' }

      scan_info = "#[Application]#\n#{data['scan_info']['app_path']}\n\n"
      scan_info << "#[ChecksPerformed]#\n#{data['scan_info']['checks_performed'].join(', ')}\n\n"
      scan_info << "#[BrakemanVersion]#\n#{data['scan_info']['brakeman_version']}\n\n"

      # choose a different parent based on the application path?
      content_service.create_note text: scan_info

      logger.info { "#{data['warnings'].count} Warnings\n===========" }

      # Keep a reference to the node holding each warning type
      sorted_warnings = {}

      data['warnings'].each do |warning|
        logger.info { "* [#{warning['warning_type']}] #{warning['message']}" }

        type = warning['warning_type']

        # Check if this is the first time we've found this warning type
        if !sorted_warnings.key?(type)
          # and create a child node to hold any warnings
          sorted_warnings[type] = @parent.children.find_or_create_by_label(type)
        end

        node_for_type = sorted_warnings[type]

        warning_info =<<EOW
#[Message]#
#{warning['message']}

#[Confidence]#
#{warning['confidence']}

#[Path]#
#{warning['file']}##{warning['line']}

#[Code]#
bc.. #{warning['code']}

#[References]#
#{warning['link']}
EOW

        content_service.create_note text: warning_info
      end

    end
  end
end
