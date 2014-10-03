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
        height: "70%",        
	    	zIndex:0
	    });
      f = $("header#site-header nav");
      e = $(window),
      i = function() {
        return $("button.navbar-toggle").is(":visible") ? 40 : 80;
      };
      h = function() {
      	console.log("f.length:"+f,length)
        if (f.length) {
          var a = e.scrollTop(),
            b = i();
            console.log("sticking")
          a > b && !f.hasClass("sticky") ? f.addClass("sticky") : b > a && f.hasClass("sticky") && !f.data("is-showing") && f.removeClass("sticky")
        }
      };
			e.on("scroll", debounce(h, 100, false)); 
