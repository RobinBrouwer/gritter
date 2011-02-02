module Gritter
  module Helpers
    def include_gritter *args
      options = args.extract_options!
      includes = [stylesheet_link_tag("gritter/jquery.gritter.css"), javascript_include_tag("gritter/jquery.gritter.min.js")]
      includes.push(js(extend_gritter(options))) if options.present?
      includes.join("\n").html_safe
    end
    
    def include_gritter_and_jquery *args
      includes = [javascript_include_tag("http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"), include_gritter(*args)]
      includes.join("\n").html_safe
    end
    
    def add_gritter text, *args
      options = args.extract_options!
      options[:title] = "Notification" if options[:title].blank?
      options[:image] = "/images/gritter/#{options[:image]}.png" if %w(success warning error notice progress).include?(options[:image].to_s)
      notification = ["$.gritter.add({"]
      notification.push("image:'#{options[:image]}',") if options[:image].present?
      notification.push("sticky:#{options[:sticky]},") if options[:sticky].present?
      notification.push("time:#{options[:time]},") if options[:time].present?
      notification.push("class_name:'#{options[:class_name]}',") if options[:class_name].present?
    	notification.push("before_open:function(e){#{options[:before_open]}},") if options[:before_open].present?
      notification.push("after_open:function(e){#{options[:after_open]}},") if options[:after_open].present?
      notification.push("before_close:function(e){#{options[:before_close]}},") if options[:before_close].present?
      notification.push("after_close:function(e){#{options[:after_close]}},") if options[:after_close].present?
      notification.push("title:'#{escape_javascript(options[:title])}',")
      notification.push("text:'#{escape_javascript(text)}'")
      notification.push("});")
      text.present? ? notification.join.html_safe : nil
    end
    
    def remove_gritter *args
      options = args.extract_options!
      removed = ["$.gritter.removeAll({"]
      removed.push("before_close:function(e){#{options[:before_close]}},") if options[:before_close].present?
      removed.push("after_close:function(e){#{options[:after_close]}},") if options[:after_close].present?
      removed.push("});")
      removed.join.html_safe
    end
    
    def extend_gritter *args
      options = args.extract_options!
      options[:fade_in_speed] = "'#{options[:fade_in_speed]}'" if options[:fade_in_speed].is_a?(String)
      options[:fade_out_speed] = "'#{options[:fade_out_speed]}'" if options[:fade_out_speed].is_a?(String)
      extended = ["$.extend($.gritter.options,{"]
      extended.push("fade_in_speed:#{options[:fade_in_speed]},") if options[:fade_in_speed].present?
      extended.push("fade_out_speed:#{options[:fade_out_speed]},") if options[:fade_out_speed].present?
      extended.push("time:#{options[:time]}") if options[:time].present?
      extended.push("});")
      extended.join.html_safe
    end
    
    def gflash *args
      if session[:gflash].present?
        options = args.extract_options!
        titles = gflash_titles(options)
        flashes = session[:gflash].map { |key, value| add_gritter(value, :image => key, :title => titles[key]) }
        session[:gflash] = nil
        js(flashes).html_safe
      end
    end
    
    def js *args
      javascript_tag(args.join("\n"))
    end
    
    private
    
    def gflash_titles *args
      options = args.extract_options!
      titles = { :success => get_translation(:success), :warning => get_translation(:warning), :error => get_translation(:error), :notice => get_translation(:notice), :progress => get_translation(:progress) }
      options.each do |key, value|
        titles[key] = value if titles.has_key?(key)
      end
      titles
    end
    
    def get_translation translation
      I18n.t(translation, :scope => [:gflash, :titles])
    end
  end
end