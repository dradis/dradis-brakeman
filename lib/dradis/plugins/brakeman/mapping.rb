module Dradis::Plugins::Brakeman
  module Mapping

    def self.component_name
      'brakeman'
    end

    def self.default_mapping
      {
        'scan-info' => {
          'Title' => 'Brakeman scan information',
          'Application' => '{{ brakeman[scan_info.app_path] }}',
          'BrakemanVersion' => '{{ brakeman[scan_info.brakeman_version] }}',
          'RailsVersion' => '{{ brakeman[scan_info.rails_version] }}',
          'WarningCount' => '{{ brakeman[scan_info.security_warnings] }}'
        },
        'warning' => {
          'Title' => '{{ brakeman[warning.message] }}',
          'Type' => '{{ brakeman[warning.warning_type] }}',
          'Confidence' => '{{ brakeman[warning.confidence] }}',
          'Path' => '{{ brakeman[warning.file] }}#{{ brakeman[warning.line] }}',
          'Code' => 'bc.. {{ brakeman[warning.code] }}',
          'References' => '{{ brakeman[warning.link] }}'
        }      
      }
    end
  end
end
