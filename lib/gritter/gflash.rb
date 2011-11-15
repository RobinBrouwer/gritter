module Gritter
  module Gflash
    def gflash *args
      session[:gflash] ||= {}
      options = args.extract_options!
      options.each do |key, value|
        if value.is_a?(Hash)
          gflash_value = value
          gflash_value[:value] = gflash_text(key, gflash_value[:value]) if gflash_value.has_key?(:value)
        else
          gflash_value = gflash_text(key, value)
        end
        
        if session[:gflash].has_key?(key)
          session[:gflash][key].push(gflash_value)
        else
          session[:gflash][key] = [gflash_value]
        end
      end
    end
  
  private
    
    def gflash_text(key, value)
      value == true ? I18n.t("gflash.#{params[:controller]}.#{params[:action]}.#{key}") : value
    end
  end
end