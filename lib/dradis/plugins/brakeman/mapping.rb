module Dradis::Plugins::Brakeman
  module Mapping
    DEFAULT_MAPPING = {
      scan_info: {
        'Title' => 'Brakeman scan information',
        'Application' => '{{ brakeman[scan_info.app_path] }}',
        'BrakemanVersion' => '{{ brakeman[scan_info.brakeman_version] }}',
        'RailsVersion' => '{{ brakeman[scan_info.rails_version] }}',
        'WarningCount' => '{{ brakeman[scan_info.security_warnings] }}'
      },
      warning: {
        'Title' => '{{ brakeman[warning.message] }}',
        'Type' => '{{ brakeman[warning.warning_type] }}',
        'Confidence' => '{{ brakeman[warning.confidence] }}',
        'Path' => '{{ brakeman[warning.file] }}#{{ brakeman[warning.line] }}',
        'Code' => 'bc.. {{ brakeman[warning.code] }}',
        'References' => '{{ brakeman[warning.link] }}'
      }      
    }.freeze
  end
end
