/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_0001_03.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20201117165249, 김별
 * </pre>
 **/

$(function(){
	iWebAction("changeTitle",{"_title" : "경리나라아바타 잘 쓰는 법","_type" : "2"});
	$(document).on("click", ".btn_fix_botm a", function(){
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
		
		/*var url = "basic_0009_01.act";
		iWebAction("openPopup",{"_url" : url});*/
	});
	
	$(document).on("click", ".btn_wrap .inner", function(){
		iWebAction("phoneCall",{"_type" : "0", "_phone_num" : "16703636"});
		/*var url = "https://www.serp.co.kr/home/home_8400.html";
		iWebAction("webBrowser", {"_url" : url});
*/		
	});
});

function fn_back() {
	iWebAction("closePopup");
}

function fn_popCallback(){
	fn_back();
}