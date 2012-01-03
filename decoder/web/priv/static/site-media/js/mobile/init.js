var myScroll,
	hoverClassRegEx = new RegExp('(^|\\s)iScrollHover(\\s|$)'),
	removeClass = function () {
		if (this.hoverTarget) {
			clearTimeout(this.hoverTimeout);
			this.hoverTarget.className = this.hoverTarget.className.replace(hoverClassRegEx, '');
			this.target = null;
		}
	};
function loaded() {
	myScroll = new iScroll('content', {
		onBeforeScrollStart: function (e) {
			var target = e.target;

			clearTimeout(this.hoverTimeout);

			while (target.nodeType != 1) target = target.parentNode;

			this.hoverTimeout = setTimeout(function () {
				if (!hoverClassRegEx.test(target.className)) target.className = target.className ? target.className + ' iScrollHover' : 'iScrollHover';
			}, 80);

			this.hoverTarget = target;
			
			e.preventDefault();
		},
		onScrollMove: removeClass,
		onBeforeScrollEnd: removeClass,
        zoomMin: 1
	});
}

document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
document.addEventListener('DOMContentLoaded', loaded, false);


$(function() {

    $('.cla .cla-name').click(function() {
        $(this).siblings(".cla .cla-list").show();
    });

    $('.cla-item .cla-item-name').click(function() {
        $(this).siblings(".cla-item .cla-item-data").show();
    });

    $('.hl-item .hl-item-name').click(function() {
        $(this).siblings(".hl-item .hl-item-data").show();
    });
    
});