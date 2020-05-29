// (function(){
//
//    var current = 0;
//
//    var max = 0;
//
//    var container;
//
//    var interval;
//
//    var xml;
//
//    var animateTarget = null;
//
//    function init(){
//
//      container = jQuery(".slide ul");
//
//      max = container.children().size;
//
//      console.log(max);
//
//      events();
//
//      interval = setInterval(next, 3000);
//
//  }
//
//  // 무한 롤링 셋팅
//
//  function setting(){
//
//    container.css("margin-left","-600px");
//
//    container.prepend(container.children()[max-1]);
//
//  }
//
//  function events(){
//
//    jQuery("button.prev").on("click", prev);
//
//    jQuery("button.next").on("click", next);
//
//    jQuery(window).on("keydown", keydown);
//
//  }
//
//  function prev( e ){
//
//    current--;
//
//    if( current < 0 )  current = max-1;
//
//    animate("prev");    // pram
//
//  }
//
//  function next( e ){
//
//    current++;
//
//    if( current > max-1 ) current = 0;
//
//    animate("next");    // pram 
//
//  }
//
//  function animate( $direction ){
//
//    if( animateTarget !=null ){
//
//      TweenMax.killTweensOf( animateTarget );
//
//      animateTarget.css("margin-left","0");
//
//    }
//
//    if( $direction == "next"){
//
//      jQuery(container.children()[1]).css("margin-left","600px");
//
//      container.append( container.children()[0] );
//
//    } else if( $direction == "prev"){
//
//      container.prepend( container.children()[max-1] );
//
//      jQuery(container.children()[0]).css("margin-left","-600px");
//
//    }
//
//    animateTarget = jQuery(container.children()[0]);
//
//    TweenMax.to( animateTarget, 0.8, { marginLeft:0, ease:Expo.easeOut });
//
//    clearInterval(interval);  // 누적된어 있는것을 클리어 함
//
//    interval = setInterval(next, 3000);  // Interval 누적됨
//
//  }
//
//  function keydown( e ){
//
//    //console.log(e); 키보드 이벤트 로그
//
//    if( e.which == 39 /*right*/ ){
//
//        next();
//
//    }else if( e.which == 37 /*left*/ ){
//
//        prev();
//
//    }
//
//  }
//
//  jQuery( document ).ready( init );
//
//})();
//
