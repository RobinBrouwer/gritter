if defined?(Rails::Railtie)
  module Gritter
    class Railtie < Rails::Railtie
      initializer :gritter do
        Gritter.initialize
      end
    end
  end
end