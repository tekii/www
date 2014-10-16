var debounce = function (func, threshold, execAsap) {
	var timeout;
	return function debounced () {
	    var obj = this, args = arguments;
	    function delayed () {
	        if (!execAsap)
	            func.apply(obj, args);
	        timeout = null; 
	    };

	    if (timeout)
	        clearTimeout(timeout);
	    else if (execAsap)
	        func.apply(obj, args);

	    timeout = setTimeout(delayed, threshold || 100); 
	};
}
/* aca se cambia la proporcion del video pablito */
$('#hero-wrapper').videoBG({
	mp4:'/videos/home.mp4',
	ogv:'/videos/home.ogv',
	webm:'/videos/home.webm',
	poster:'/videos/home.jpg',
	scale:true,
	width: "100%",
	height: "90%",        
	zIndex:0
});

f = $("header#site-header nav");
e = $(window),
i = function() {
	return $("button.navbar-toggle").is(":visible") ? 40 : 80;
};
h = function() {
	if (f.length) {
  		var a = e.scrollTop(),
    	b = i();
  		a > b && !f.hasClass("sticky") ? f.addClass("sticky") : b > a && f.hasClass("sticky") && !f.data("is-showing") && f.removeClass("sticky")
	}
};
k = function() {
	f.length && f.on("show.bs.collapse", function() {
	  f.data("is-showing", !0), f.hasClass("sticky") || f.addClass("sticky");
	  var a = e.height() - f.height() - 10;
	  $("div.navbar-collapse").css("max-height", a + "px")
	}).on("hide.bs.collapse", function() {
	  f.data("is-showing", !1);
	  var a = e.scrollTop(),
	    b = i();
	  b > a && f.hasClass("sticky") && f.removeClass("sticky")
	})
};
e.on("scroll", debounce(h, 100, false)); 
k();
