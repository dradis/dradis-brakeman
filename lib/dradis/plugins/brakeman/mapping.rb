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

    SOURCE_FIELDS = {
      scan_info: [
        'scan_info.app_path',
        'scan_info.rails_version',
        'scan_info.security_warnings',
        'scan_info.start_time',
        'scan_info.end_time',
        'scan_info.duration',
        'scan_info.number_of_controllers',
        'scan_info.number_of_models',
        'scan_info.number_of_templates',
        'scan_info.ruby_version',
        'scan_info.brakeman_version'
      ],
      warning: [
        'warning.warning_type',
        'warning.warning_code',
        'warning.fingerprint',
        'warning.message',
        'warning.file',
        'warning.line',
        'warning.link',
        'warning.code',
        'warning.render_path',
        'warning.location_type',
        'warning.location_class',
        'warning.location_method',
        'warning.user_input',
        'warning.confidence'
      ]
    }.freeze
  end
end
