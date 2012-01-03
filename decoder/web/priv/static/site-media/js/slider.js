/**
 * 	Fade Slider 0.1 - jQuery plugin
 *	    written by Ilya w-495 Nikitin
 *	
 *	Copyright (c) 2011 Ilya w-495 Nikitin (http://w-495.ru)
 *	Licensed under BSD-like license.
 *
 *	Built for jQuery library
 *	http://jquery.com
**/

/* ---------------------------------------------------------------------------
    <div id="slider">
        <ul class="slider-items">
            ...
            <li class="active">
                <a href="#">
                    <img src="/images/slide.png" />
                    <span class="slider-item-capture">
                        Capture
                    </span>
                </a>
            </li>
            ...
        </ul>
        <div class="slider-bord">
            <span id="slider-prev" class="slider-button">&lt;&lt;</span>
            <span class="slider-circle">&bull;<span>&bull;</span>&bull;</span>
            <span id="slider-next" class="slider-button">&gt;&gt;</span>
        </div>
    </div>
    ---------------------------------------------------------------------------
*/

(function($) {
    var stoped = false;
    
    $.fn.fadeSliderSwitch = function(a_options){
        if(!stoped){
            var defaults = {
                next:	true,
                speed:  20,
                min:    0.0,
                max:    1.0
            };
            var options = $.extend(defaults, a_options);
            var obj = $(this);
            var active = $("li.active", obj);
            if (!active.length )
                if(options.next)
                    active = $("li:last", obj);
                else
                    active = $("li:first", obj);
            var next = null;
            if(active.next().length)
                next = active.next();
            else
                if(options.next)
                    next = $("li:first", obj);
                else
                    next = $("li:last", obj);
            active.addClass("last-active");
            next.css({opacity: options.min})
            next.addClass("active")

            stoped = true;
            next.animate({opacity: options.max}, options.speed, 'swing',function() {
                active.removeClass("active last-active");
                stoped = false;
            });
        }
    }
    
// ---------------------------------------------------------------------------
    $.fn.fadeSlider = function(a_options){
        var obj = $(this);
        var defaults = {
            move : {
                next:	true,
                speed:  1000,
                min:    0.0,
                max:    1.0                
            },
            interval:   5000
		};
        var options = $.extend(defaults, a_options);
        
        $("#slider-next", obj).click(function(){
            $("ul.slider-items", obj).fadeSliderSwitch(options.move);
        });
        $("#slider-prev", obj).click(function(){
            $("ul.slider-items", obj).fadeSliderSwitch(options.move);
        });
        
        if(options.interval){
            _setInterval = function(){
                return setInterval( function(){$("ul.slider-items", obj)
                    .fadeSliderSwitch(options.move);}, options.interval);
            }
            var refreshIntervalId = _setInterval()
            $(this).mouseover(function(){
                clearInterval(refreshIntervalId);
            }).mouseout(function(){
                stoped = false;
                refreshIntervalId = _setInterval();
            });
        }        
    }
})(jQuery);

