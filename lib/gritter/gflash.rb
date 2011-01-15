module Gritter
  module Gflash
    def gflash *args
      session[:gflash] ||= {}
      options = args.extract_options!
      options.each do |key, value|
        session[:gflash][key] = value
      end
    end
  end
end