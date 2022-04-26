/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0011_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20210617103025, 김별
 * </pre>
 **/

$(function(){
	_thisPage.onload();
	$(".btn_switch").on("click",function(){
		if($(".btn_switch").hasClass("on")){
			if(LGIN_APP == "SERP") iWebAction("setStorage",{"_key" : "keyWebResultTTS_SERP", "_value" : "N"});
			else if(LGIN_APP == "AVATAR"){iWebAction("setStorage",{"_key" : "keyWebResultTTS", "_value" : "N"});}
			else if(LGIN_APP == "ZEROPAY"){iWebAction("setStorage",{"_key" : "keyWebResultTTS_ZEROPAY", "_value" : "N"});}
			else if(LGIN_APP == "KTSERP"){iWebAction("setStorage",{"_key" : "keyWebResultTTS_KTSERP", "_value" : "N"});}
			
			$(".btn_switch").removeClass("on")
		} else {
			if(LGIN_APP == "SERP") iWebAction("setStorage",{"_key" : "keyWebResultTTS_SERP", "_value" : "Y"});
			else if(LGIN_APP == "AVATAR") iWebAction("setStorage",{"_key" : "keyWebResultTTS", "_value" : "Y"});
			else if(LGIN_APP == "ZEROPAY") iWebAction("setStorage",{"_key" : "keyWebResultTTS_ZEROPAY", "_value" : "Y"});
			else if(LGIN_APP == "KTSERP") iWebAction("setStorage",{"_key" : "keyWebResultTTS_KTSERP", "_value" : "Y"});
			
			$(".btn_switch").addClass("on")
		}
	});
})

var _thisPage = {
	onload : function(){
		iWebAction("changeTitle",{"_title" : "음성 설정","_type" : "2"});
		if(LGIN_APP == "SERP") iWebAction("getStorage",{_key : "keyWebResultTTS_SERP", _call_back : "fn_getWebResultTTS"});
		else if(LGIN_APP == "AVATAR") iWebAction("getStorage",{_key : "keyWebResultTTS", _call_back : "fn_getWebResultTTS"});
		else if(LGIN_APP == "ZEROPAY") iWebAction("getStorage",{_key : "keyWebResultTTS_ZEROPAY", _call_back : "fn_getWebResultTTS"});
		else if(LGIN_APP == "KTSERP") iWebAction("getStorage",{_key : "keyWebResultTTS_KTSERP", _call_back : "fn_getWebResultTTS"});
	}
}
function fn_getWebResultTTS(data){
	if(avatar.common.null2void(data)===""){
		if(LGIN_APP == "SERP") iWebAction("setStorage",{"_key" : "keyWebResultTTS_SERP", "_value" : "Y"});
		else if(LGIN_APP == "AVATAR") iWebAction("setStorage",{"_key" : "keyWebResultTTS", "_value" : "Y"});
		else if(LGIN_APP == "ZEROPAY") iWebAction("setStorage",{"_key" : "keyWebResultTTS_ZEROPAY", "_value" : "Y"});
		else if(LGIN_APP == "KTSERP") iWebAction("setStorage",{"_key" : "keyWebResultTTS_KTSERP", "_value" : "Y"});
	}
	avatar.common.null2void(data)==""?data="Y":data=data;
	if(data == "Y"){
		$(".btn_switch").addClass("on");
	} else{
		$(".btn_switch").removeClass("on");
	}
}
function fn_back(){
	iWebAction("closePopup");
}