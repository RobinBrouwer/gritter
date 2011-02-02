module Gritter
  module Gflash
    def gflash *args
      session[:gflash] ||= {}
      options = args.extract_options!
      options.each do |key, value|
        session[:gflash][key] = value == true ? I18n.t("gflash.#{params[:controller]}.#{params[:action]}.#{key}") : value
      end
    end
  end
end