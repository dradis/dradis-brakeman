module Dradis::Plugins::Brakeman
  class Importer < Dradis::Plugins::Upload::Importer
    # The framework will call this function if the user selects this plugin from
    # the dropdown list and uploads a file.
    # @returns true if the operation was successful, false otherwise
    def import(params={})

      file_content = File.read( params[:file] )

      # Parse the uploaded file into a Ruby Hash
      logger.info { "Parsing Brakeman output from #{ params[:file] }..." }
      data = MultiJson.decode(file_content)
      logger.info { 'Done.' }

      scan_info = "#[Title]#\nBrakeman scan information\n\n"
      scan_info << "#[Application]#\n#{data['scan_info']['app_path']}\n\n"
      scan_info << "#[ChecksPerformed]#\n#{data['scan_info']['checks_performed'].join(', ')}\n\n"
      scan_info << "#[BrakemanVersion]#\n#{data['scan_info']['brakeman_version']}\n\n"

      # choose a different parent based on the application path?
      content_service.create_note text: scan_info

      logger.info { "#{data['warnings'].count} Warnings\n===========" }

      # Keep a reference to the node holding each warning type
      sorted_warnings = {}

      data['warnings'].each do |warning|
        logger.info { "* [#{warning['warning_type']}] #{warning['message']}" }

        warning_info =<<EOW
#[Title]#
#{warning['message']}

#[Type]#
#{warning['type']}

#[Confidence]#
#{warning['confidence']}

#[Path]#
#{warning['file']}##{warning['line']}

#[Code]#
bc.. #{warning['code']}

#[References]#
#{warning['link']}
EOW

        content_service.create_issue text: warning_info, id: warning['warning_code']
      end

    end
  end
end
