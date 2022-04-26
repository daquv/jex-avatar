/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_0000_03.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 김별 (  )
 * @Description    : 질의오류_공통화면(시간값) - 시간값 오류, 유료
 * @History        : 20210302134649, 김별
 * </pre>
 **/

$(function(){
	iWebAction("changeTitle",{"_title" : "질의", "_type" : "2"});
	_thisPage.onload();
});

var _thisPage = {
		onload : function(){
			_thisPage.setData();
			encounterMessage(INTE_NM);
			//iWebAction("getStorage",{_key : "keyWebResultTTS", _call_back : "fn_getWebResultTTS"});
			if(_APP_ID == "SERP") iWebAction("getStorage",{_key : "keyWebResultTTS_SERP", _call_back : "fn_getWebResultTTS"}); 
			else if(_APP_ID == "KTSERP") iWebAction("getStorage",{_key : "keyWebResultTTS_KTSERP", _call_back : "fn_getWebResultTTS"}); 
			else iWebAction("getStorage",{_key : "keyWebResultTTS", _call_back : "fn_getWebResultTTS"});
		},
		setData : function(){
			var guideDate = [];
			var inteCd1 = ",BWN001,BDN001,BDW002,ASN001,PCT001,SCT001,SPN001,PON001,PTN001,PCN002,SON001,STN001,SCN001,SCN002,";
			var inteCd2 = ",BDW001,BDW004,";
			var inteCd3 = ",BDW003,";
			var inteCd4 = ",SCT002,";
			var inteCd5 = ",BDW005,";
			var inteCd6 = ",SPN002,BST001,BPT001,";
			if(inteCd1.indexOf(INTE_CD)>-1){
				guideDate =["전일","이번 분기","3월 31일","21년","주간","상반기"];
			}else if(inteCd2.indexOf(INTE_CD)>-1){
				guideDate =["전일","30일","2021년 3월 31일","21년","2021년 3월","3월 31일"];
			}else if(inteCd3.indexOf(INTE_CD)>-1){
				guideDate =["전일","이번주","주간","전월","21년","이번 분기"];
			}else if(inteCd4.indexOf(INTE_CD)>-1){
				guideDate =["이번주","주간","상반기","21년","이번 분기","3월"];
			}else if(inteCd5.indexOf(INTE_CD)>-1){
				guideDate =["21년","상반기","하반기","2021년","1분기","4분기"];
			}else if(inteCd6.indexOf(INTE_CD)>-1){
				guideDate =["전일","이번주","이번달","이번 분기","21년","상반기"];
			}
			$(".btn_rolling p").each(function(i,v){
				$(v).find(".guideDate").text(guideDate[i]);
			});
		},
		
}

function encounterMessage(name){
	var adj = checkBatchimEnding(name)?'은':'는';
	$(".inteTxt").text(" "+name+adj);
	//$(".inteStr").text("“어제 "+name+adj+"?”");
}

function fn_getWebResultTTS(data){
	avatar.common.null2void(data)==""?data="Y":data=data;
	if(data == "Y"){
		//$("#RESULT_TTS").text("거래처");
		//alert($("#RESULT_TTS").text())
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
	iWebAction("closePopup",{_callback:"fn_popCallback_back"});
}