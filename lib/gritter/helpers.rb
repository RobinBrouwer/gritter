module Gritter
  module Helpers
    SUCCESS = "/images/gritter/success.png"
    WARNING = "/images/gritter/warning.png"
    ERROR = "/images/gritter/error.png"
    NOTICE = "/images/gritter/notice.png"
    PROGRESS = "/images/gritter/progress.gif"
    
    def include_gritter
      "#{stylesheet_link_tag "gritter/jquery.gritter.css"}\n#{javascript_include_tag "gritter/jquery.gritter.min.js"}"
    end
    
    def include_gritter_and_jquery
      "#{stylesheet_link_tag "gritter/jquery.gritter.css"}\n#{javascript_include_tag "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"}\n#{javascript_include_tag "gritter/jquery.gritter.min.js"}"
    end
    
    def gritter flash, *args
      options = args.extract_options!
      title = options[:title].present? ? options[:title] : "Notification"
      if options[:image].present?
        options[:image] = SUCCESS if options[:image] == :success
        options[:image] = WARNING if options[:image] == :warning
        options[:image] = ERROR if options[:image] == :error
        options[:image] = NOTICE if options[:image] == :notice
        options[:image] = PROGRESS if options[:image] == :progress
      end
      "<script type=\"text/javascript\">\n
      $.gritter.add({\n
      	#{"image: '#{options[:image]}',\n" if options[:image].present?}
      	#{"sticky: #{options[:sticky]},\n" if options[:sticky].present?}
      	#{"time: #{options[:time]},\n" if options[:time].present?}
      	#{"class_name: '#{options[:class_name]}',\n" if options[:class_name].present?}
    	  #{"before_open: function(){\n
      		#{options[:before_open]}\n
      	},\n" if options[:before_open].present?}
      	#{"after_open: function(e){\n
      		#{options[:after_open]}\n
      	},\n" if options[:after_open].present?}
      	#{"before_close: function(e){\n
      		#{options[:before_close]}\n
      	},\n" if options[:before_close].present?}
      	#{"after_close: function(){\n
      		#{options[:after_close]}\n
      	},\n" if options[:after_close].present?}
        
        title: '#{title}',\n
        text: '#{flash}'\n
      });\n
      </script>" if flash.present?
    end
    
    def remove_gritter *args
      options = args.extract_options!
      "<script type=\"text/javascript\">\n
      $.gritter.removeAll({\n
        #{"before_close: function(e){\n
      		#{options[:before_close]}\n
      	},\n" if options[:before_close].present?}\n
      	#{"after_close: function(){\n
      		#{options[:after_close]}\n
      	},\n" if options[:after_close].present?}\n
      });\n
      </script>"
    end
  end
end