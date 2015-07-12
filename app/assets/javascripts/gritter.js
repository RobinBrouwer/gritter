/*
 * Gritter for jQuery
 * http://www.boedesign.com/
 *
 * Copyright (c) 2011 Jordan Boesch
 * Dual licensed under the MIT and GPL licenses.
 *
 * Date: March 29, 2011
 * Version: 1.7.1
 */

// Modernizr for CSS3 support check.
window.Modernizr = function (a, b, c) {
   function A(a, b) {
       var c = a.charAt(0).toUpperCase() + a.substr(1),
           d = (a + " " + m.join(c + " ") + c).split(" ");
       return z(d, b)
   }
   function z(a, b) {
       for (var d in a) if (j[a[d]] !== c) return b == "pfx" ? a[d] : !0;
       return !1
   }
   function y(a, b) {
       return !!~ ("" + a).indexOf(b)
   }
   function x(a, b) {
       return typeof a === b
   }
   function w(a, b) {
       return v(prefixes.join(a + ";") + (b || ""))
   }
   function v(a) {
       j.cssText = a
   }
   var d = "2.0.6",
       e = {},
       f = b.documentElement,
       g = b.head || b.getElementsByTagName("head")[0],
       h = "modernizr",
       i = b.createElement(h),
       j = i.style,
       k, l = Object.prototype.toString,
       m = "Webkit Moz O ms Khtml".split(" "),
       n = {},
       o = {},
       p = {},
       q = [],
       r = function (a, c, d, e) {
           var g, i, j, k = b.createElement("div");
           if (parseInt(d, 10)) while (d--) j = b.createElement("div"), j.id = e ? e[d] : h + (d + 1), k.appendChild(j);
           g = ["&shy;", "<style>", a, "</style>"].join(""), k.id = h, k.innerHTML += g, f.appendChild(k), i = c(k, a), k.parentNode.removeChild(k);
           return !!i
       },
       s, t = {}.hasOwnProperty,
       u;
   !x(t, c) && !x(t.call, c) ? u = function (a, b) {
       return t.call(a, b)
   } : u = function (a, b) {
       return b in a && x(a.constructor.prototype[b], c)
   }, n.rgba = function () {
       v("background-color:rgba(150,255,150,.5)");
       return y(j.backgroundColor, "rgba")
   }, n.borderradius = function () {
       return A("borderRadius")
   };
   for (var B in n) u(n, B) && (s = B.toLowerCase(), e[s] = n[B](), q.push((e[s] ? "" : "no-") + s));
   v(""), i = k = null, e._version = d, e._domPrefixes = m, e.testProp = function (a) {
       return z([a])
   }, e.testAllProps = A, e.testStyles = r;
   return e
}(this, this.document);

(function($){
  
  /**
  * Set it up as an object under the jQuery namespace
  */
  $.gritter = {};
  
  /**
  * Set up global options that the user can over-ride
  */
  $.gritter.options = {
    position: '',
    fade_in_speed: 'medium', // how fast notifications fade in
    fade_out_speed: 1000, // how fast the notices fade out
    time: 6000 // hang on the screen for...
  }
  
  /**
  * Add a gritter notification to the screen
  * @see Gritter#add();
  */
  $.gritter.add = function(params){

    try {
      return Gritter.add(params || {});
    } catch(e) {
    
      var err = 'Gritter Error: ' + e;
      (typeof(console) != 'undefined' && console.error) ? 
        console.error(err, params) : 
        alert(err);
        
    }
    
  }
  
  /**
  * Remove a gritter notification from the screen
  * @see Gritter#removeSpecific();
  */
  $.gritter.remove = function(id, params){
    Gritter.removeSpecific(id, params || {});
  }
  
  /**
  * Remove all notifications
  * @see Gritter#stop();
  */
  $.gritter.removeAll = function(params){
    Gritter.stop(params || {});
  }
  
  /**
  * CSS3 check
  */
  var gritter_item;
  var gritter_content = '[[close]][[image]]<div class="[[class_name]]"><span class="gritter-title">[[username]]</span><p>[[text]]</p></div><div style="clear:both"></div>';
  if(Modernizr.borderradius && Modernizr.rgba) {
    gritter_item = '<div class="gritter-item gritter-css3">'+ gritter_content +'</div>';
  } else {
    gritter_item = '<div class="gritter-top"></div><div class="gritter-item gritter-css2">'+ gritter_content +'</div><div class="gritter-bottom"></div>';    
  }
  
  /**
  * Big fat Gritter object
  * @constructor (not really since it's object literal)
  */
  var Gritter = {
      
    // Public - options to over-ride with $.gritter.options in "add"
    position: '',
    fade_in_speed: '',
    fade_out_speed: '',
    time: '',
      
    // Private - no touchy the private parts
    _custom_timer: 0,
    _item_count: 0,
    _is_setup: 0,
    _tpl_close: '<div class="gritter-close"></div>',
    _tpl_item: '<div id="gritter-item-[[number]]" class="gritter-item-wrapper [[item_class]]" style="display:none">'+ gritter_item +'</div>',
    _tpl_wrap: '<div id="gritter-notice-wrapper"></div>',
      
    /**
    * Add a gritter notification to the screen
    * @param {Object} params The object that contains all the options for drawing the notification
    * @return {Integer} The specific numeric id to that gritter notification
    */
    add: function(params){
      
      // We might have some issues if we don't have a title or text!
      if(!params.title || !params.text){
        throw 'You need to fill out the first 2 params: "title" and "text"'; 
      }
      
      // Check the options and set them once
      if(!this._is_setup){
        this._runSetup();
      }
      
      // Basics
      var user = params.title, 
        text = params.text,
        image = params.image || '',
        sticky = params.sticky || false,
        item_class = params.class_name || '',
        position = $.gritter.options.position,
        time_alive = params.time || '';
      
      this._verifyWrapper();
      
      this._item_count++;
      var number = this._item_count, 
        tmp = this._tpl_item;
      
      // Assign callbacks
      $(['before_open', 'after_open', 'before_close', 'after_close']).each(function(i, val){
        Gritter['_' + val + '_' + number] = ($.isFunction(params[val])) ? params[val] : function(){}
      });

      // Reset
      this._custom_timer = 0;
      
      // A custom fade time set
      if(time_alive){
        this._custom_timer = time_alive;
      }
      
      var image_str = (image != '') ? '<img src="' + image + '" class="gritter-image" />' : '',
        class_name = (image != '') ? 'gritter-with-image' : 'gritter-without-image';
      
      // String replacements on the template
      tmp = this._str_replace(
        ['[[username]]', '[[text]]', '[[close]]', '[[image]]', '[[number]]', '[[class_name]]', '[[item_class]]'],
        [user, text, this._tpl_close, image_str, this._item_count, class_name, item_class], tmp
      );
          
      this['_before_open_' + number]();
      $('#gritter-notice-wrapper').addClass(position).append(tmp);
      
      var item = $('#gritter-item-' + this._item_count);
      
      item.fadeIn(this.fade_in_speed, function(){
        Gritter['_after_open_' + number]($(this));
      });
          
      if(!sticky){
        this._setFadeTimer(item, number);
      }
      
      // Bind the hover/unhover states
      $(item).bind('mouseenter mouseleave', function(event){
        if(event.type == 'mouseenter'){
          if(!sticky){ 
            Gritter._restoreItemIfFading($(this), number);
          }
        }
        else {
          if(!sticky){
            Gritter._setFadeTimer($(this), number);
          }
        }
        Gritter._hoverState($(this), event.type);
      });
      
      return number;
      
    },
    
    /**
    * If we don't have any more gritter notifications, get rid of the wrapper using this check
    * @private
    * @param {Integer} unique_id The ID of the element that was just deleted, use it for a callback
    * @param {Object} e The jQuery element that we're going to perform the remove() action on
    * @param {Boolean} manual_close Did we close the gritter dialog with the (X) button
        */
    _countRemoveWrapper: function(unique_id, e, manual_close){
        
      // Remove it then run the callback function
      e.remove();
      this['_after_close_' + unique_id](e, manual_close);
      
      // Check if the wrapper is empty, if it is.. remove the wrapper
      if($('.gritter-item-wrapper').length == 0){
        $('#gritter-notice-wrapper').remove();
      }
    
    },
    
    /**
    * Fade out an element after it's been on the screen for x amount of time
    * @private
    * @param {Object} e The jQuery element to get rid of
    * @param {Integer} unique_id The id of the element to remove
    * @param {Object} params An optional list of params to set fade speeds etc.
    * @param {Boolean} unbind_events Unbind the mouseenter/mouseleave events if they click (X)
    */
    _fade: function(e, unique_id, params, unbind_events){

      var params = params || {},
        fade = (typeof(params.fade) != 'undefined') ? params.fade : true;
        fade_out_speed = params.speed || this.fade_out_speed,
                manual_close = unbind_events;
      
      this['_before_close_' + unique_id](e, manual_close);
      
      // If this is true, then we are coming from clicking the (X)
      if(unbind_events){
        e.unbind('mouseenter mouseleave');
      }
      
      // Fade it out or remove it
      if(fade){
        
        e.fadeOut(fade_out_speed, function(){
          e.animate({ height: 0 }, 300, function(){
            Gritter._countRemoveWrapper(unique_id, e, manual_close);
          })
        })
        
      }
      else {
        
        this._countRemoveWrapper(unique_id, e);
        
      }
    
    },
    
    /**
    * Perform actions based on the type of bind (mouseenter, mouseleave) 
    * @private
    * @param {Object} e The jQuery element
    * @param {String} type The type of action we're performing: mouseenter or mouseleave
    */
    _hoverState: function(e, type){
      
      // Change the border styles and add the (X) close button when you hover
      if(type == 'mouseenter'){
          
        e.addClass('hover');
        
        // Show close button
        e.find('.gritter-close').show();
        
        // Clicking (X) makes the perdy thing close
        e.find('.gritter-close').click(function(){
        
          var unique_id = e.attr('id').split('-')[2];
          Gritter.removeSpecific(unique_id, {}, e, true);
          
        });
      
      }
      // Remove the border styles and hide (X) close button when you mouse out
      else {
        
        e.removeClass('hover');
        
        // Hide close button
        e.find('.gritter-close').hide();
        
      }
        
    },
    
    /**
    * Remove a specific notification based on an ID
    * @param {Integer} unique_id The ID used to delete a specific notification
    * @param {Object} params A set of options passed in to determine how to get rid of it
    * @param {Object} e The jQuery element that we're "fading" then removing
    * @param {Boolean} unbind_events If we clicked on the (X) we set this to true to unbind mouseenter/mouseleave
    */
    removeSpecific: function(unique_id, params, e, unbind_events){
      
      if(!e){
        var e = $('#gritter-item-' + unique_id);
      }

      // We set the fourth param to let the _fade function know to 
      // unbind the "mouseleave" event.  Once you click (X) there's no going back!
      this._fade(e, unique_id, params || {}, unbind_events);
      
    },
    
    /**
    * If the item is fading out and we hover over it, restore it!
    * @private
    * @param {Object} e The HTML element to remove
    * @param {Integer} unique_id The ID of the element
    */
    _restoreItemIfFading: function(e, unique_id){
      
      clearTimeout(this['_int_id_' + unique_id]);
      e.stop().css({ opacity: '' });
        
    },
    
    /**
    * Setup the global options - only once
    * @private
    */
    _runSetup: function(){
    
      for(var opt in $.gritter.options){
        this[opt] = $.gritter.options[opt];
      }
      this._is_setup = 1;
        
    },
    
    /**
    * Set the notification to fade out after a certain amount of time
    * @private
    * @param {Object} item The HTML element we're dealing with
    * @param {Integer} unique_id The ID of the element
    */
    _setFadeTimer: function(e, unique_id){
      
      var timer_str = (this._custom_timer) ? this._custom_timer : this.time;
      this['_int_id_' + unique_id] = setTimeout(function(){ 
        Gritter._fade(e, unique_id); 
      }, timer_str);
    
    },
    
    /**
    * Bring everything to a halt
    * @param {Object} params A list of callback functions to pass when all notifications are removed
    */  
    stop: function(params){
      
      // callbacks (if passed)
      var before_close = ($.isFunction(params.before_close)) ? params.before_close : function(){};
      var after_close = ($.isFunction(params.after_close)) ? params.after_close : function(){};
      
      var wrap = $('#gritter-notice-wrapper');
      before_close(wrap);
      wrap.fadeOut(function(){
        $(this).remove();
        after_close();
      });
    
    },
    
    /**
    * An extremely handy PHP function ported to JS, works well for templating
    * @private
    * @param {String/Array} search A list of things to search for
    * @param {String/Array} replace A list of things to replace the searches with
    * @return {String} sa The output
    */  
    _str_replace: function(search, replace, subject, count){
    
      var i = 0, j = 0, temp = '', repl = '', sl = 0, fl = 0,
        f = [].concat(search),
        r = [].concat(replace),
        s = subject,
        ra = r instanceof Array, sa = s instanceof Array;
      s = [].concat(s);
      
      if(count){
        this.window[count] = 0;
      }
    
      for(i = 0, sl = s.length; i < sl; i++){
        
        if(s[i] === ''){
          continue;
        }
        
            for (j = 0, fl = f.length; j < fl; j++){
          
          temp = s[i] + '';
          repl = ra ? (r[j] !== undefined ? r[j] : '') : r[0];
          s[i] = (temp).split(f[j]).join(repl);
          
          if(count && s[i] !== temp){
            this.window[count] += (temp.length-s[i].length) / f[j].length;
          }
          
        }
      }
      
      return sa ? s : s[0];
        
    },
    
    /**
    * A check to make sure we have something to wrap our notices with
    * @private
    */  
    _verifyWrapper: function(){
      
      if($('#gritter-notice-wrapper').length == 0){
        $('body').append(this._tpl_wrap);
      }
    
    }
      
  }
  
})(jQuery);