/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_0000_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200804102751, 김별
 * </pre>
 **/
$(function(){
	iWebAction("changeTitle",{"_title" : "질의", "_type" : "2"});
	$(".content").show();
	if (MENU_DV ==="TXOF"){
		if(_APP_ID == "SERP") iWebAction("getStorage",{_key : "keyWebResultTTS_SERP", _call_back : "fn_getWebResultTTS"}); 
		else if(_APP_ID == "KTSERP") iWebAction("getStorage",{_key : "keyWebResultTTS_KTSERP", _call_back : "fn_getWebResultTTS"}); 
		else iWebAction("getStorage",{_key : "keyWebResultTTS", _call_back : "fn_getWebResultTTS"});
	} else encounterMessage(bzaqNm, MENU_DV);
	
	
	$(document).on("click", ".btn_s01", function(){
			var INTE_INFO ="{'recog_txt':'','recog_data' : {'Intent':'ASP002','appInfo' : {}} }" ;
			var url = "ques_comm_01.act?INTE_INFO="+INTE_INFO;
			iWebAction("openPopup",{"_url" : url});
	});
});

function encounterMessage(name, menu_dv){
	
	var adj = checkBatchimEnding(name)?'은':'는';
	if(menu_dv === "BZAQ"){
		$(".noti_tit").html("'"+name+"'"+adj+"<br> 등록된 거래처가 아닙니다.");
	} else if(menu_dv === "FRAN"){
		$(".noti_tit").html("'"+name+"'"+adj+"<br> 등록된 가맹점이 아닙니다.");
	} else if(menu_dv === "COMM"){
		$(".noti_tit").html("'"+name+"'"+adj+"<br> 등록된 정보가 아닙니다.");
	}
	//iWebAction("getStorage",{_key : "keyWebResultTTS", _call_back : "fn_getWebResultTTS"});
	if(_APP_ID == "SERP") iWebAction("getStorage",{_key : "keyWebResultTTS_SERP", _call_back : "fn_getWebResultTTS"}); 
	else if(_APP_ID == "KTSERP") iWebAction("getStorage",{_key : "keyWebResultTTS_KTSERP", _call_back : "fn_getWebResultTTS"}); 
	else iWebAction("getStorage",{_key : "keyWebResultTTS", _call_back : "fn_getWebResultTTS"});
}

function fn_getWebResultTTS(data){
	avatar.common.null2void(data)==""?data="Y":data=data;
	if(data == "Y"){
		//alert("webResultTTS_TXT : "+avatar.common.null2void($("#RESULT_TTS").text()));
		iWebAction("webResultTTS",{"_data" : avatar.common.null2void($("#RESULT_TTS").text())});
	}
}

function checkBatchimEnding(word) {
	if (typeof word !== 'string') return null;
 
	var lastLetter = word[word.length - 1];
	var uni = lastLetter.charCodeAt(0);
 
	if (uni < 44032 || uni > 55203) return null;
 
	return (uni - 44032) % 28 != 0;
}


function fn_back(){
	iWebAction("closePopup", {"_callback" : "fn_popCallback2"});
}