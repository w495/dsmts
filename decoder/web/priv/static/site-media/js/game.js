

/**
 * Различные функции для стр с автооризацией
 * TODO: разнести не несколько функций
**/

(function($) {
    
    $.fn.gameLoad = function(a_options){
        var obj = $(this);
        var defaults = {};
        var options = $.extend(defaults, a_options);

        var flashvars = {
            xml: "/static/site-media/flash/visuals.xml",
            db: "/static/site-media/flash/db.xml"
        };
        
        var params = {
            menu: "false",
            scale: "noScale",
            allowFullscreen: "true",
            allowScriptAccess: "always",
            bgcolor: "",
            wmode: "direct"
        };
        
        var attributes = {
            id:"game"
        };
/*        
        swfobject.embedSWF(
            "/static/site-media/flash/game.swf", "game-content",
            "1000", "600", "10.0.0",
            "/static/site-media/flash/expressInstall.swf",
            flashvars, params, attributes, function(e) {console.log("e = ", e)});
        
*/        
        swfobject.registerObject("o-game-content", "10.0.0", "/static/site-media/flash/expressInstall.swf");

        $(".game-start").click(function(){
            var obj = swfobject.getObjectById("o-game-content");
            obj.newGame("",  "/static/site-media/flash/db.xml");
            return false;
        })
        
    }
})(jQuery);