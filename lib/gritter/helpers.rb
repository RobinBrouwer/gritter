module Gritter
  module Helpers
    SUCCESS = "/images/gritter/success.png"
    WARNING = "/images/gritter/warning.png"
    ERROR = "/images/gritter/error.png"
    NOTICE = "/images/gritter/notice.png"
    PROGRESS = "/images/gritter/progress.gif"
    @@titles = { :success => "Success", :warning => "Warning", :error => "Error", :notice => "Notice", :progress => "Progress" }
    
    def include_gritter *args
      options = args.extract_options!
      includes = []
      includes.push(stylesheet_link_tag("gritter/jquery.gritter.css")+"\n")
      includes.push(javascript_include_tag("gritter/jquery.gritter.min.js")+"\n")
      includes.push(js(extend_gritter(options))) if options.present?
      includes.to_s
    end
    
    def include_gritter_and_jquery *args
      includes = []
      includes.push(javascript_include_tag("http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js")+"\n")
      includes.push(include_gritter(*args))
      includes.to_s
    end
    
    def add_gritter text, *args
      options = args.extract_options!
      title = options[:title].present? ? options[:title] : "Notification"
      if options[:image].present?
        options[:image] = SUCCESS if options[:image] == :success
        options[:image] = WARNING if options[:image] == :warning
        options[:image] = ERROR if options[:image] == :error
        options[:image] = NOTICE if options[:image] == :notice
        options[:image] = PROGRESS if options[:image] == :progress
      end
      notification = []
      notification.push("$.gritter.add({")
      notification.push("image: '#{options[:image]}',") if options[:image].present?
      notification.push("sticky: #{options[:sticky]},") if options[:sticky].present?
      notification.push("time: #{options[:time]},") if options[:time].present?
      notification.push("class_name: '#{options[:class_name]}',") if options[:class_name].present?
    	notification.push("before_open: function(){ #{options[:before_open]} },") if options[:before_open].present?
      notification.push("after_open: function(e){ #{options[:after_open]} },") if options[:after_open].present?
      notification.push("before_close: function(e){	#{options[:before_close]} },") if options[:before_close].present?
      notification.push("after_close: function(){ #{options[:after_close]} },") if options[:after_close].present?
      notification.push("title: '#{title}',")
      notification.push("text: '#{text}'")
      notification.push("})")
      text.present? ? notification.to_s : nil
    end
    
    def remove_gritter *args
      options = args.extract_options!
      removed = []
      removed.push("$.gritter.removeAll({")
      removed.push("before_close: function(e){ #{options[:before_close]} },") if options[:before_close].present?
      removed.push("after_close: function(){ #{options[:after_close]} },") if options[:after_close].present?
      removed.push("})")
      removed.to_s
    end
    
    def extend_gritter *args
      options = args.extract_options!
      fade_in_speed = (options[:fade_in_speed].is_a?(String) ? "'#{options[:fade_in_speed]}'" : options[:fade_in_speed]) if options[:fade_in_speed].present?
      extended = []
      extended.push("$.extend($.gritter.options, {")
      extended.push("fade_in_speed: #{fade_in_speed}, ") if options[:fade_in_speed].present?
      extended.push("fade_out_speed: #{options[:fade_out_speed]}, ") if options[:fade_out_speed].present?
      extended.push("time: #{options[:time]}") if options[:time].present?
      extended.push("})")
      extended.to_s
    end
    
    def gflash *args
      options = args.extract_options!
      options.each do |option|
        @@titles[option[0]] = option[1] if @@titles.has_key?(option[0])
      end
      if session[:gflash].present?
        flashes = []
        session[:gflash].each_key do |key|
          flashes.push(js add_gritter(session[:gflash][key], :image => key, :title => @@titles[key]))
        end
        session[:gflash] = nil
        flashes.to_s
      end
    end
    
    def gflash_titles *args
      options = args.extract_options!
      options.each do |option|
        @@titles[option[0]] = option[1]
      end
    end
    
    def js script
      "<script type=\"text/javascript\">//<![CDATA[\n#{script};\n//]]></script>"
    end
  end
end