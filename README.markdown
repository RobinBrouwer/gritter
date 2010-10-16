# gritter

	version 0.3
	Robin Brouwer
	Daniël Zwijnenburg
	45north

This Ruby on Rails plugin allows you to easily add Growl-like notifications to your application using a JQuery plugin called 'gritter'.

## Installation

Install the plugin with the following command:

	script/plugin install git://github.com/RobinBrouwer/gritter.git

Start your server and you'll see that three folders are added to your /javascripts, /stylesheets and /images folders.
Now you can use gritter inside your Rails application.

Now add the following to your head-tag inside the layout:

	<%= include_gritter %>

If you also want to add JQuery together with gritter (from googleapis.com) you can use the following helper:

	<%= include_gritter_and_jquery %>

You can pass extra arguments to these functions to set the default options for gritter.

	:fade_in_speed => "medium"            # => Allows you to set the fade-in-speed. Can be string or integer (in ms).
	:fade_out_speed => 1000               # => Allows you to set the fade-out-speed. Must be an integer (in ms).
	:time => 8000                         # => Allows you to set the time the notification stays. Must be an integer (in ms).


## Usage

There are several helpers you can use with gritter. All of them print out javascript code without script-tags.

	add_gritter
	remove_gritter
	extend_gritter
	
To add the script-tags we added another function called 'js'. It allows you to easily add script-tags around your javascript.
It can be used in combination with gritter, but also other javascript you want to output. 
It automatically adds a semicolon (;) at the end of the script-tag, so you don't have to worry about that.

Since version 0.3 we also added a gflash helper. You can read more about this helper below.


### add_gritter

The add_gritter helper allows you to add a gritter notification to your application. It works like this in the link_to_function helper:

	<%= link_to_function "Notify", add_gritter("This is a notification just for you!") %>

The add_gritter helper allows you to easily set the text for the notification. 
When you want to change the title, just pass the :title argument to the helper:

	<%= link_to_function "Notify", add_gritter("This is a notification just for you!", :title => "Please pay attention!") %>

There are many more arguments you can pass to the helper:

	:title => "This is a title"            # => Allows you to set the title for the notification.
	:image => "/images/rails.png"          # => Allows you to add an image to the notification.
	:sticky => true                        # => Allows you to make the notification sticky.
	:time => 4000                          # => Allows you to set the time when the notification disappears (in ms)
	:class_name => "gritter"               # => Allows you to set a different classname.
	:before_open => "alert('Opening!');"   # => Execute javascript before opening.
	:after_open => "alert('Opened!');"     # => Execute javascript after opening.
	:before_close => "alert('Closing!');"  # => Execute javascript before closing.
	:after_close => "alert('Closed!');"    # => Execute javascript after closing.

The :image argument also allows you to easily set five different images:

	:success
	:warning
	:notice
	:error
	:progress

It works like this in combination with flash[:notice] and the 'js' helper:

	<%= js gritter(flash[:notice], :image => :notice, :title => "Pay attention!", :sticky => true) %>

And that's it! You just added Growl-like notifications to your Rails application.
It's great for all kinds of notifications, including the flash notifications you want to show to your users.


### remove_gritter

The remove_gritter helper removes all gritter notifications from the screen. 

	<%= link_to_function "Remove notifications", remove_gritter %>

You can pass two extra arguments to this helper.

	:before_close => "alert('Closing!');"  # => Execute javascript before closing.
	:after_close => "alert('Closed!');"    # => Execute javascript after closing.

You can also use the 'js' helper to add script-tags around this helper.


### extend_gritter

The extend_gritter helper allows you to set the default gritter options, just like you can do with the include_gritter helpers. 
To see what arguments you can pass to this helper just check the include_gritter helper.

You can also use the 'js' helper to add script-tags around this helper.


### gflash

The gflash helper is a different kind of flash[:notice] message. It uses the add_gritter helper and the default images used in this plugin.
It uses a session to remember the flash messages. Add the following inside your controller action:

	def create
		...
		gflash :success => "The product has been successfully created!"
		...
	end

Now you can add the following to your layout view inside the body-tag:

	<%= gflash %>
	
The flash-message will be shown with 'success.png' as the image and 'Success' as the title.
To change the title you can add the following to the gflash helper inside the layout:

	<%= gflash :success => "It has been successful!" %>
	
Now the default title will be overwritten. You can use the following gflash options:

	:success
	:warning
	:notice
	:error
	:progress

Each uses the corresponding image and title. You can also add multiple gritter notifications at once:

	def create
		...
		gflash :success => "The product has been successfully created!", :notify => "This product doesn't have a category."
		...
	end

Just remember that you can only set the gflash message inside the controller. 
The gflash helper inside the views will show the notification and change the title. It will not change the message.


## Special Thanks

We'd like to express our gratitude to the following people:

Many thanks to Jordan Boesch, creator of the AWESOME JQuery plugin gritter.
http://boedesign.com/blog/2009/07/11/growl-for-jquery-gritter/

Also special thanks to Liam McKay for creating the awesome icons!
http://wefunction.com/2008/07/function-free-icon-set/