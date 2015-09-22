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

      unless data.key?("scan_info")
        logger.error "ERROR: no 'scan_info' field present in the provided "\
                     "data. Are you sure you uploaded a Brakeman file?"
        exit(-1)
      end

      # choose a different parent based on the application path?
      scan_info = template_service.process_template(template: 'scan_info', data: data['scan_info'])
      content_service.create_note text: scan_info

      logger.info { "#{data['warnings'].count} Warnings\n===========" }

      data['warnings'].each do |warning|
        logger.info { "* [#{warning['warning_type']}] #{warning['message']}" }

        warning_info = template_service.process_template(template: 'warning', data: warning)
        content_service.create_issue text: warning_info, id: warning['warning_code']
      end

    end
  end
end
