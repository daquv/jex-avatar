/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_0013_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20210803130849, 김별
 * </pre>
 **/
$(function(){
	_thisPage.onload();
});

var _thisPage = {
	onload : function() {
		iWebAction("changeTitle",{"_title" : "세무사 추천","_type" : "2"})
		if(_APP_ID == "SERP") iWebAction("getStorage",{_key : "keyWebResultTTS_SERP", _call_back : "fn_getWebResultTTS"}); 
		else if(_APP_ID == "KTSERP") iWebAction("getStorage",{_key : "keyWebResultTTS_KTSERP", _call_back : "fn_getWebResultTTS"});
		else if(_APP_ID == "ZEROPAY") iWebAction("getStorage",{_key : "keyWebResultTTS_ZEROPAY", _call_back : "fn_getWebResultTTS"});
		else iWebAction("getStorage",{_key : "keyWebResultTTS", _call_back : "fn_getWebResultTTS"});
		_thisPage.setData();
	}, 
	setData : function() {
		var input = {};
		input["CHRG_NM"]=CHRG_NM;
		input["CHRG_TEL_NO"]=CHRG_TEL_NO;
		input["BIZ_NO"]=BIZ_NO;
		input["SEQ_NO"]=SEQ_NO;
		avatar.common.callJexAjax("ques_0013_01_r001",input,_thisPage.fn_callback);
	},
	fn_callback : function(data) {
		if(avatar.common.null2void(data.RSLT_CD)==="9999"){
			alert(data.RSLT_MSG);
			return;
		}
		if(avatar.common.null2void(data.IMG_PATH)!=="")
			$(".taxAcc_prof img").attr("src", data.IMG_PATH);
		$("#CHRG_NM").text(data.CHRG_NM);
		$("#BSNN_NM").text(data.BSNN_NM);
		$("#CHRG_TEL_NO").text(formatter.phone(data.CHRG_TEL_NO));
		$("#ADRS").text(data.ADRS);
		$("#MAJR_SPHR").text(data.MAJR_SPHR);
		
	},
}
function fn_getWebResultTTS(data){
	avatar.common.null2void(data)==""?data="Y":data=data;
	if(data == "Y"){
		$.each($("#RESULT_TTS").children(), function(i, v){
			if(avatar.common.null2void($(v).attr("data-type"))!="" && $(v).attr("data-type").indexOf("dateday")>-1){
				$(v).text(formatter.datekr($(v).text().replace(/\./g, '').replace(/ /g, '').replace(/\([ㄱ-힣]\)/, '')));
			}
		});
		iWebAction("webResultTTS",{"_data" : avatar.common.null2void($("#RESULT_TTS").text())});
	}
}
function fn_back(){
	/*iWebAction("closePopup",{_callback:"fn_popCallback2"});*/
	if(decodeURIComponent(PREV_YN) === "Y"){
		iWebAction("closePopup",{_callback:"fn_popCallback_back"});
	} else {
		iWebAction("closePopup");
	}
}