module Gritter
  module Gflash
    def redirect_to(options = {}, response_status_and_flash = {})
      if response_status_and_flash.has_key?(:gflash)
        gflash(response_status_and_flash[:gflash])
        response_status_and_flash.delete(:gflash)
      end
      super(options, response_status_and_flash)
    end
    
    def gflash *args
      session[:gflash] ||= {}
      options = args.extract_options!
      
      if args.size == 1 && args.first.is_a?(Array)
        args = args.first
      end
      
      flash_now = args.include?(:now)
      args.delete(:now) if flash_now
      
      if args.present?
        args.each do |key|
          gflash_push(key, gflash_translation(key, options[:locals]), flash_now)
        end
      end
      
      options.except(:locals).each do |key, value|
        if value.is_a?(Hash)
          if value.has_key?(:value)
            value[:value] = gflash_text(key, value[:value], value[:locals])
          else
            value[:value] = gflash_translation(key, value[:locals])
          end
        else
          value = gflash_text(key, value, options[:locals])
        end
        gflash_push(key, value, flash_now)
      end
    end
  
  private
    
    def gflash_text(key, value, options={})
      value == true ? gflash_translation(key, options) : value
    end
    
    def gflash_push(key, value, now=false)
      session[:gflash][key] ||= []
      session[:gflash][key].push(value)
      
      if Gritter.rails_flash_fallback
        if now
          flash.now[key] ||= []
          flash.now[key].push(value.is_a?(Hash) ? value[:value] : value)
        else
          flash[key] ||= []
          flash[key].push(value.is_a?(Hash) ? value[:value] : value)
        end
      end
    end
    
    def gflash_translation(key, options)
      options ||= {}
      
      i18n_default_key = "gflash.defaults.#{key}"
      i18n_default_action_key = "gflash.defaults.#{params[:action]}.#{key}"
      i18n_key = "gflash.#{params[:controller]}.#{params[:action]}.#{key}"
      i18n_key.gsub!(/\//, ".")
      
      begin
        options[:raise] = true
        translation = I18n.t(i18n_key, options)
      rescue I18n::MissingTranslationData
        begin
          translation = I18n.t(i18n_default_action_key, options)
        rescue I18n::MissingTranslationData
          options.delete(:raise)
          translation = I18n.t(i18n_default_key, options)
        end
      end
      
      translation
    end
  end
end