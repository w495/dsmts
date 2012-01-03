(function($) {
    $.fn.mChSBanners = function(a_options){
        var obj = $(this);
        var defaults = {};
        var options = $.extend(defaults, a_options);
        
        $.get("/!/Banners/", function(data) {
            if(data){
              var pair_of_banners = data.values;
              if(pair_of_banners){
                  Banners = {}
                  for (var banner in pair_of_banners) {
                     Banners[pair_of_banners[banner].banner_place] = pair_of_banners[banner]
                  }
                  if(Banners.right){
                        $("#game-body-link", obj).attr("href", Banners.right.ref);
                        $("#game-body-img", obj).attr("src", "/" + Banners.right.url);
                  }
                  
                  if(Banners.bottom){
                        $("#bottom-banner-container", obj).show();
                        
                        $("#bottom-banners-container", obj).show();
                        
                        $("#bottom-banner-link", obj).attr("href", Banners.bottom.ref);
                        $("#bottom-banner-img", obj).attr("src", "/" + Banners.bottom.url);
                  }
              }
            }
        });
    }
})(jQuery);