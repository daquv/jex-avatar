/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0009_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 박지은 (  )
 * @Description    : 경리나라 이용안내 화면
 * @History        : 20210325104540, 박지은
 * </pre>
 **/
$(function(){
	_thisPage.onload();
	
	// 경리나라 바로가기
	$("#serp_btn").on("click",function(){
		// 경리나라M 실행해야됨
		var app_id = "";
		var app_scheme = "";
		var store_url = "";
		if(getUserAgent() == "android") {
			app_id = "com.webcash.serp3_0";
			app_scheme = "webcash://serp3_0";
			store_url = "https://play.google.com/store/apps/details?id=com.webcash.serp3_0";
		}else if(getUserAgent() == "ios"){
			app_id = "serpm";
			app_scheme = "serpm://";
			store_url = "https://apps.apple.com/app/id1435283481";
		}else{
			alert("모바일에서만 실행 가능 합니다.");
			return false;
		}
		
		iWebAction("startAppByScheme",{"_app_id" : app_id, "_app_scheme" : app_scheme, "_store_url": store_url});
	});
	$("#zeropay_btn").on("click", function(){
		// 경리나라M 실행해야됨
		var app_id = "";
		var app_scheme = "";
		var store_url = "";
		if(getUserAgent() == "android") {
			app_id = "kr.or.zeropay.zip";
			app_scheme = "zeropayzip://";
			store_url = "https://play.google.com/store/apps/details?id=kr.or.zeropay.zip";
		}else if(getUserAgent() == "ios"){
			app_id = "kr.or.zeropay.zip";
			app_scheme = "zeropayzip://";
			store_url = "";
		}else{
			alert("모바일에서만 실행 가능 합니다.");
			return false;
		}
		
		iWebAction("startAppByScheme",{"_app_id" : app_id, "_app_scheme" : app_scheme, "_store_url": store_url});
	})
	// 닫기
	$("#close_btn").on("click",function(){
		fn_back();
	});
});

var _thisPage={
	onload : function(){
		iWebAction("changeTitle",{"_title" : "","_type" : "9"});
	}
}

function fn_back(){
		iWebAction("closePopup",{_callback:"fn_popCallback2"});
}