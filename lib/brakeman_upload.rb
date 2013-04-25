# BrakemanUpload

require 'brakeman_upload/filters'
require 'brakeman_upload/meta'

module BrakemanUpload
  class Configuration < Core::Configurator
    configure :namespace => 'brakeman_upload'

    setting :category, :default => 'Plugin output'
    setting :author, :default => 'Brakeman Scanner plugin'
    setting :parent_node, :default => 'plugin.output'
  end
end

# This includes the upload plugin module in the Dradis upload plugin repository
module Plugins
  module Upload 
    include BrakemanUpload
  end
end
