module Gritter
  module Gflash
    def gflash *args
      session[:gflash] ||= {}
      options = args.extract_options!
      options.each do |key, value|
        gflash_value = value == true ? I18n.t("gflash.#{params[:controller]}.#{params[:action]}.#{key}") : value
        if session[:gflash].has_key?(key)
          session[:gflash][key].push(gflash_value)
        else
          session[:gflash][key] = [gflash_value]
        end
      end
    end
  end
end