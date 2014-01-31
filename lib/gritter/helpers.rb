module Gritter
  module Helpers
    def add_gritter text, *args
      options = args.extract_options!
      options[:title] = "Notification" if options[:title].blank?
      options[:image] = asset_path("#{options[:image]}#{options[:image].to_s == 'progress' ? '.gif' : '.png'}") if %w(success warning error notice progress).include?(options[:image].to_s)
      notification = Array.new
      notification.push("jQuery(function(){") if options[:nodom_wrap].blank?
      notification.push("jQuery.gritter.add({")
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
      notification.push("});") if options[:nodom_wrap].blank?
      text.present? ? notification.join.html_safe : nil
    end
    
    def remove_gritter *args
      options = args.extract_options!
      removed = ["jQuery.gritter.removeAll({"]
      removed.push("before_close:function(e){#{options[:before_close]}},") if options[:before_close].present?
      removed.push("after_close:function(e){#{options[:after_close]}},") if options[:after_close].present?
      removed.push("});")
      removed.join.html_safe
    end
    
    def extend_gritter *args
      options = args.extract_options!
      options[:fade_in_speed] = "'#{options[:fade_in_speed]}'" if options[:fade_in_speed].is_a?(String)
      options[:fade_out_speed] = "'#{options[:fade_out_speed]}'" if options[:fade_out_speed].is_a?(String)
      options[:position] = "'#{options[:position].to_s.gsub("_", "-")}'" if options[:position]
      extended = ["jQuery.extend($.gritter.options,{"]
      extended.push("fade_in_speed:#{options[:fade_in_speed]},") if options[:fade_in_speed].present?
      extended.push("fade_out_speed:#{options[:fade_out_speed]},") if options[:fade_out_speed].present?
      extended.push("time:#{options[:time]},") if options[:time].present?
      extended.push("position:#{options[:position]}") if options[:position].present?
      extended.push("});")
      extended.join.html_safe
    end
    
    def gflash *args
      if session[:gflash].present?
        options = args.extract_options!
        nodom_wrap = options[:nodom_wrap]
        options.delete(:nodom_wrap)
        
        titles = gflash_titles(options)
        flashes = []
        session[:gflash].each do |key, value|
          value.each do |gflash_value|
            gritter_options = { :image => key, :title => titles[key], :nodom_wrap => nodom_wrap }
            if gflash_value.is_a?(Hash)
              text = gflash_value.has_key?(:value) ? (gflash_value[:value] and gflash_value.delete(:value)) : nil
              gritter_options.merge!(gflash_value)
            else
              text = gflash_value
            end
            flashes.push(add_gritter(text, gritter_options))
          end
        end
        session[:gflash] = nil
        options[:js] ? flashes.join("\n") : js(flashes).html_safe
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
