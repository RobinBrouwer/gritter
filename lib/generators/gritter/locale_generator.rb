module Gritter
  class LocaleGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    
    def copy_gflash_locale
      copy_file "gflash.en.yml", "config/locales/gflash.en.yml"
    end
  end
end