/**
 * MAIN стр с автооризацией
**/


$(function() {
    $("body").mChSBanners();

    $('.cla .cla-name').click(function() {
      $(this).siblings(".cla .cla-list").slideToggle();
    });

    $('.cla-item .cla-item-name').click(function() {
      $(this).siblings(".cla-item .cla-item-data").slideToggle();
    });

    $('.hl-item .hl-item-name').click(function() {
      $(this).siblings(".hl-item .hl-item-data").slideToggle();
    });
    
});
