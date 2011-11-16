# gritter

    version 1.0.0
    Robin Brouwer
    Daniël Zwijnenburg
    45north

This Ruby on Rails gem allows you to easily add Growl-like notifications to your application using a jQuery plugin called 'gritter'.

## Note

This is a Rails 3.1 gem. Are you using Rails 3.0 or lower? Check out [the 'old' branch on Github](https://github.com/RobinBrouwer/gritter/tree/old). Want support for IE6? 
Also check out that branch, because the newer version of gritter inside this gem dropped support for it.


## Installation

You can use this gem by putting the following inside your Gemfile:

    gem "gritter", "1.0.0"

Now generate the locale for gritter:

    rails g gritter:locale

Add the following to `/app/assets/javascripts/application.js`:

    //= require gritter

And the following to `/app/assets/stylesheets/application.css`:

    *= require gritter

And that's it!

## Changes

Version 1.0.0 changes:

    - Added new version for the gritter jQuery plugin.
    - Added position option for your gritter messages.
    - Locale isn't automatically generated. You need to use the gritter:locale generator.
    - Using SCSS image_path instead of ERB image_path inside the CSS.
    - Adding locale-based gflash messages got a bit easier.
    - Gritter now only works in Rails 3.1. You should check out the 'old' branch for other Rails versions.
    - Removed everything that isn't needed for Rails 3.1.
    - Changed the README quite a bit.


## Usage

There are several helpers you can use with gritter. All of them print out Javascript code without script-tags.

    add_gritter
    remove_gritter
    extend_gritter
  
To add the script-tags we added another function called `js`. It allows you to easily add script-tags around your javascript.
It can be used in combination with gritter, but also other Javascript you want to run.

The most popular feature of this gem is `gflash`. This replaces the regular flash messages in Rails and 
automatically puts these in gritter boxes. Read further to learn more about gflash.


### add_gritter

The `add_gritter` helper allows you to add a gritter notification to your application. 
It outputs Javascript directly into your template. It works like this inside a `js.erb` file:

    <%= add_gritter("This is a notification just for you!") %>

The `add_gritter` helper allows you to easily set the text for the notification. 
When you want to change the title, just pass the `:title` argument to the helper:

    <%= add_gritter("This is a notification just for you!", :title => "Please pay attention!") %>

There are many more arguments you can pass to the helper:

    :title => "This is a title"            # => Allows you to set the title for the notification.
    :image => "/images/rails.png"          # => Allows you to add an image to the notification.
    :sticky => true                        # => Allows you to make the notification sticky.
    :time => 4000                          # => Allows you to set the time when the notification disappears (in ms).
    :class_name => "gritter"               # => Allows you to set a different classname.
    :before_open => "alert('Opening!');"   # => Execute javascript before opening.
    :after_open => "alert('Opened!');"     # => Execute javascript after opening.
    :before_close => "alert('Closing!');"  # => Execute javascript before closing.
    :after_close => "alert('Closed!');"    # => Execute javascript after closing.

The `:image` argument also allows you to easily set five different images:

    :success
    :warning
    :notice
    :error
    :progress

It works like this in combination with flash[:notice] and the `js` helper:

    <%= js add_gritter(flash[:notice], :image => :notice, :title => "Pay attention!", :sticky => true) %>

The js helper is almost the same as the javascript_tag helper. The difference is that you can pass several scripts at once.
You don't need to pass these scripts as an Array. The helper also adds a linebreak (\n) after each script.

    <%= js add_gritter("See my notification"), add_gritter("Another one") %>

It puts all the scripts inside a single script-tag.

And that's it! You just added Growl-like notifications to your Rails application.
It's great for all kinds of notifications, including the flash notifications you want to show to your users.


### remove_gritter

The `remove_gritter` helper removes all gritter notifications from the screen. You can use it inside a `js.erb` file:

    <%= remove_gritter %>

You can pass two extra arguments to this helper.

    :before_close => "alert('Closing!');"  # => Execute javascript before closing.
    :after_close => "alert('Closed!');"    # => Execute javascript after closing.

You can also use the `js` helper to add script-tags around this helper.


### extend_gritter

The `extend_gritter` helper allows you to set the default gritter options.

    <%= extend_gritter :time => 1000 %>

These are the options you can pass to `extend_gritter`:

    :fade_in_speed => "medium"            # => Allows you to set the fade-in-speed. Can be String or Integer (in ms).
    :fade_out_speed => 1000               # => Allows you to set the fade-out-speed. Can be String or Integer (in ms).
    :time => 8000                         # => Allows you to set the time the notification stays. Must be an Integer (in ms).

The :fade_in_speed and :fade_out_speed options accept the following Strings:
  
    "slow"
    "medium"
    "fast"

You can also use the `js` helper to add script-tags around this helper.


### gflash

The `gflash` helper is a different kind of `flash[:notice]` message. It uses the `add_gritter` helper and the default images used in this plugin.
It uses a session to remember the flash messages. Add the following inside your controller action:

    def create
      gflash :success => "The product has been created successfully!"
    end

Now you can add the following to your layout view inside the body-tag:

    <%= gflash %>

The flash-message will be shown with 'success.png' as the image and 'Success' as the title.
To change the title you can add the following to the `gflash` helper inside the layout:

    <%= gflash :success => "It has been successful!" %>

Now the default title will be overwritten. You can use the following gflash options:

    :success
    :warning
    :notice
    :error
    :progress

Each uses the corresponding image and title. You can also add multiple gritter notifications at once:

    def create
      gflash :success => "The product has been created successfully!", :notice => "This product doesn't have a category."
    end

Besides passing the exact text inside the controller, gflash also supports locales (both for messages and titles). 
When you start your server a new locale file will be added to /config/locales called `gflash.en.yml`.
Here you can set the locales for all your gflash messages and the titles. It works like this:

    en:
      gflash:
        titles:
          notice: "Custom notice title"
          success: "Success"
          warning: "Warning"
          error: "Error"
          progress: "Progress"
        products: # => Controller name
          create: # => Action name
            notice: "Custom notice message"

Now you can do the following inside your Controller:

    def create
      gflash :notice => true
    end

The locales for the `:notice` title and message will now be used. You can still pass a `String` to override a locale.
Since gritter version 1.0 you can also do the following to add the gritter messages:

    def create
      gflash :notice, :success, :error
    end

No need to pass `true` to each key.

You can change the default time, sticky and class_name options for each gritter message.
This is done inside the Controller and works like this:

    gflash :success => { :time => 2000, :class_name => "my_class", :sticky => true }
    gflash :success => { :value => true, :time => 2000, :class_name => "my_class", :sticky => true }
    gflash :error => { :value => "Custom error", :time => 3000, :class_name => "my_error_class", :sticky => false }

When you don't pass a `:value` it uses the locale. Same goes for when you pass `true` to `:value`.

You can also use gflash inside `js.erb` files:

    <%= gflash :js => true %>

And that's how you add gflash to your Rails application.
Just remember that you can only set which gflash message you want shown inside the controller.
The gflash helper inside the views will show the notification and change the title when you pass extra arguments. 
It will not change the message.


## Special Thanks

We'd like to express our gratitude to the following people:

Many thanks to Jordan Boesch, creator of the AWESOME jQuery plugin gritter.
http://boedesign.com/blog/2009/07/11/growl-for-jquery-gritter/

Also special thanks to Liam McKay for creating the awesome icons!
http://wefunction.com/2008/07/function-free-icon-set/