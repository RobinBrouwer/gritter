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
      
      if args.present?
        args.each do |key|
          gflash_push(key, gflash_translation(key))
        end
      end
      
      options.each do |key, value|
        if value.is_a?(Hash)
          if value.has_key?(:value)
            value[:value] = gflash_text(key, value[:value])
          else
            value[:value] = gflash_translation(key)
          end
        else
          value = gflash_text(key, value)
        end
        gflash_push(key, value)
      end
    end
  
  private
    
    def gflash_text(key, value)
      value == true ? gflash_translation(key) : value
    end
    
    def gflash_push(key, value)
      session[:gflash][key] ||= []
      session[:gflash][key].push(value)
    end
    
    def gflash_translation(key)
      i18n_key = "gflash.#{params[:controller]}.#{params[:action]}.#{key}"
      I18n.t(i18n_key.gsub(/\//, "."), :default => i18n_key.to_sym)
    end
  end
end