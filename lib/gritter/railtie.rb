if defined?(Rails::Railtie)
  module Gritter
    class Railtie < Rails::Railtie
      initializer :gritter do
        Gritter.initialize
      end
      config.assets.precompile += %w(error.png gritter-close.png gritter.png ie-spacer.gif notice.png progress.gif success.png warning.png)
    end
  end
end