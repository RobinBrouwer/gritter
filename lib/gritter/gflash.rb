module Gritter
  module Gflash
    def gflash *args
      session[:gflash] ||= {}
      options = args.extract_options!
      options.each do |option|
        session[:gflash][option[0]] = option[1] 
      end
    end
  end
end