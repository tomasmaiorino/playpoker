function scroolTo(ele) { 
    $('html, body').animate({
        scrollTop: $(ele).offset().top
    }, 2000);
    //$(window).scrollTop(ele.offset().top).scrollLeft(ele.offset().left);
   //}
 }