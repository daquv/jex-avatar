/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0009_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20210401143053, 김별
 * </pre>
 **/
$(function(){
	iWebAction("changeTitle",{"_title" : "질의", "_type" : "2"});
	_thisPage.onload();
});

var _thisPage={
	onload : function(){
		if(_APP_ID == "SERP") iWebAction("getStorage",{_key : "keyWebResultTTS_SERP", _call_back : "fn_getWebResultTTS"}); 
		else if(_APP_ID == "KTSERP") iWebAction("getStorage",{_key : "keyWebResultTTS_KTSERP", _call_back : "fn_getWebResultTTS"}); 
		else iWebAction("getStorage",{_key : "keyWebResultTTS", _call_back : "fn_getWebResultTTS"});
	}
}
function fn_getWebResultTTS(data){
	avatar.common.null2void(data)==""?data="Y":data=data;
	if(data == "Y"){
		iWebAction("webResultTTS",{"_data" : avatar.common.null2void($("#RESULT_TTS").text())});
	}
}
function fn_back(){
		iWebAction("closePopup",{_callback:"fn_popCallback2"});
}