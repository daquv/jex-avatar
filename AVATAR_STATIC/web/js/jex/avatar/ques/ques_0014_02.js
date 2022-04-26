/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_0014_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 김별 (  )
 * @Description    : 질의_메모해줘
 * @History        : 20211001083718, 김별
 * </pre>
 **/

$(function(){
	_thisPage.onload();
})

let _thisPage = {
	//1. content가 없으면 화면 그려줌 -> 자동 호출 -> ne-content 들어오면 저장 / ne-content 안들어오면 마이크버튼 리로드
	//	-> TTS ON : tts 읽고 호출
	//	-> TTS OFF : 바로 호출
	//2. CONTENT가 있으면 바로 저장
	onload : function(){
		let appInfo = inteInfo["recog_data"]["appInfo"];
		if(avatar.common.null2void(inteInfo.recog_data.appInfo["NE-CONTENT"])!==""){
			//TODO 저장
			_thisPage.fn_save(inteInfo.recog_data.appInfo["NE-CONTENT"]);
		} else {
			//TODO 자동 마이크버튼 호출 웹액션 callback으로 content받음
			iWebAction("openPopup",{"_call_back" : "fn_memoCallback"});
			_thisPage.fn_save();
		}
	},
	fn_save : function(data){
		let input = {};
		
		input["MEMO_CTT"] = data
		var jexAjax  = jex.createAjaxUtil('ques_0014_01_c001');
		jexAjax.set(input);
		jexAjax.execute(function(dat) {
			if(dat.RSLT_CD==="0000"){
				// TODO 메모 저장 후?
				// - 저장메시지 팝업 후 목록으로 이동
				// - 저장메시지 화면으로 보여줌
			} else {
				alert("처리 중 오류가 발생하였습니다.");
			}
		});
	}
}
function fn_memoCallback(data){
	_thisPage.fn_save(data);
} 