if defined?(Rails::Railtie)
  module Gritter
    class Railtie < Rails::Railtie
      rake_tasks do
        load "tasks/gritter.rake"
      end

      initializer :gritter do
        Gritter.initialize
      end
    end
  end
end