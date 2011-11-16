module Gritter
  class LocaleGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    
    def copy_gritter_locale
      copy_file "gritter.en.yml", "config/locales/gritter.en.yml"
    end
  end
end