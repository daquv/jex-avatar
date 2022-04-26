/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : home_0002_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/home
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20210511091942, 김별
 * </pre>
 **/
function getUserAgent() {
		var agent = navigator.userAgent.toLowerCase();
		if (agent.indexOf("iphone") > -1 || agent.indexOf("ipad") > -1
				|| agent.indexOf("ipod") > -1) {
			return "ios";
		} else if (agent.match('android') != null) {
			return "android";
		} else {
			return "pc";
		}
	}

$(function(){
	
	$(document).on("click", ".avataPro li:eq(0)", function(){
		// 아바타 실행해야됨
		var store_url = "";
		if(getUserAgent() == "android") {
			store_url = "https://play.google.com/store/apps/details?id=com.webcash.avatar";
		}else if(getUserAgent() == "ios"){
			store_url = "https://apps.apple.com/app/id1562976203";
		} else {
			store_url = "https://play.google.com/store/apps/details?id=com.webcash.avatar";
		}
		$(this).find("a").attr("href", store_url);
	})
	$(document).on("click", ".avataPro li:eq(1)", function(){
		// 제로페이 아바타 이동처리 막음
		/*
		// 제로페이 가맹점앱 호출해약됨
		var store_url = "";
		if(getUserAgent() == "android") {
			store_url = "https://play.google.com/store/apps/details?id=com.kftc.zeropaystore";
		}else if(getUserAgent() == "ios"){
			store_url = "https://apps.apple.com/kr/app/%EC%A0%9C%EB%A1%9C%ED%8E%98%EC%9D%B4-%EA%B0%80%EB%A7%B9%EC%A0%90%EC%9A%A9/id1444972486";
		} else {
			store_url = "https://play.google.com/store/apps/details?id=com.kftc.zeropaystore";
		}
		$(this).find("a").attr("href", store_url);
		*/
	})
	$(document).on("click", ".avataPro li:eq(2)", function(){
		// 경리나라M 실행해야됨
		var app_id = "";
		var app_scheme = "";
		var store_url = "";
		if(getUserAgent() == "android") {
			store_url = "https://play.google.com/store/apps/details?id=com.webcash.serp3_0";
		}else if(getUserAgent() == "ios"){
			store_url = "https://apps.apple.com/app/id1435283481";
		} else {
			store_url = "https://play.google.com/store/apps/details?id=com.webcash.serp3_0";
		}
		$(this).find("a").attr("href", store_url);
	})
	
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
		$(".popLayer_body").animate({scrollTop:0}, 5);
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
