module Dradis
  module Plugins
    module Brakeman
      class Engine < ::Rails::Engine
        isolate_namespace Dradis::Plugins::Brakeman

        include ::Dradis::Plugins::Base
        description 'Processes Brakeman JSON output, use: brakeman -f json -o results.json'
        provides :upload
      end
    end
  end
end
