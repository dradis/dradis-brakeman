module Dradis
  module Plugins
    module Brakeman
    end
  end
end

require 'dradis/plugins/brakeman/engine'
require 'dradis/plugins/brakeman/field_processor'
require 'dradis/plugins/brakeman/importer'
require 'dradis/plugins/brakeman/version'

# This is required while we transition the Upload Manager to use
# Dradis::Plugins only
module Dradis
  module Plugins
    module Brakeman
      module Meta
        NAME = "Brakeman Static Analysis output (.json) upload"
        EXPECTS = "Expects Brakeman JSON output, use: brakeman -f json -o results.json"
        
        module VERSION
          include Dradis::Plugins::Brakeman::VERSION
        end
      end
    end
  end
end
