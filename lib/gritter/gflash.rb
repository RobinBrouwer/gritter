module Gritter
  module Gflash
    def gflash *args
      session[:gflash] ||= {}
      options = args.extract_options!
      options.each do |option|
        session[:gflash][option.first] = option.second
      end
    end
  end
end