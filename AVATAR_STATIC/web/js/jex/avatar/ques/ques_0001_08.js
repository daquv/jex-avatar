/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_0001_08.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20210929160410, 김별
 * </pre>
 **/

$(function(){
	iWebAction("changeTitle",{"_title" : "제로페이 아바타 잘 쓰는 법","_type" : "2"});
	$(document).on("click", ".btn_fix_botm a", function(){
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
	});
});

function fn_back() {
	iWebAction("closePopup");
}

function fn_popCallback(){
	fn_back();
}