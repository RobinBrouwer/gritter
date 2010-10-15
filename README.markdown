# gritter

	version 0.1
	Robin Brouwer
	Daniël Zwijnenburg
	45north

This plugin allows you to easily add the Growl-like notification plugin for JQuery called 'gritter'.

## Installation

Install the plugin with the following command:

	script/plugin install git://github.com/RobinBrouwer/gritter.git


## Start server

Start your server and you'll see that three folders are added to your /javascripts, /stylesheets and /images folders.
Now you can use gritter inside your Rails application.


## Include Javascripts and Stylesheets

Add the following to your head-tag inside the layout:

	<%= include_gritter %>

If you also want to add JQuery together with gritter (from googleapis.com) you can use the following helper:

	<%= include_gritter_and_jquery %>


## Usage

To use gritter just use the following helper:

	<%= gritter("This is a notification just for you!") %>

The gritter helper allows you to easily set the text for the notification. 
When you want to change the title, just pass the :title argument to the helper:

	<%= gritter("This is a notification just for you!", :title => "Please pay attention!") %>

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

It works like this in combination with flash[:notice]:

	<%= gritter(flash[:notice], :image => :notice, :title => "Pay attention!", :sticky => true) %>

And that's it! You just added Growl-like notifications to your Rails application.
It's great for all the different flash notifications you want to show to your users.

Have fun with it!


## Special Thanks

We'd like to express our gratitude to the following people:

Many thanks to Jordan Boesch, creator of the AWESOME JQuery plugin gritter.
http://boedesign.com/blog/2009/07/11/growl-for-jquery-gritter/

Also special thanks to Liam McKay for creating the awesome icons!
http://wefunction.com/2008/07/function-free-icon-set/