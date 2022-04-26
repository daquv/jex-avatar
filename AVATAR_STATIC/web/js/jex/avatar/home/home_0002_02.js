/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : home_0002_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/home
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20210511164640, 김별
 * </pre>
 **/

$(function(){
	$(document).on("click", ".footer_menu li:eq(0)", function(){
		$(".termFixed:eq(1)").show();
	})
	$(document).on("click", ".footer_menu li:eq(1)", function(){
		$(".termFixed:eq(0)").show();
	});
	$(document).on("click", ".btn_close,.popLayer_bt_inn", function(){
		$("#term_prev1").hide();
		$("#term_prev2").hide();
		$("#term_now").show();
		$(".popLayer_body").animate({scrollTop:0}, 7);
		setTimeout(function() {
			$(".termFixed").hide();
		}, 15)
	})
	
	$(document).on("click", ".prev_2", function(){
		$("#term_now").hide();
		$("#term_prev1").hide();
		$("#term_prev2").show();
	})
	
	$(document).on("click", ".prev_1", function(){
		$("#term_now").hide();
		$("#term_prev2").hide();
		$("#term_prev1").show();
	})
})