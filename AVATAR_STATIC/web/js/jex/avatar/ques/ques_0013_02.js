/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_0013_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20210812084411, 김별
 * </pre>
 **/
$(function(){
	$("#CHRG_TEL_NO").text(formatter.phone(CHRG_TEL_NO));
	iWebAction("changeTitle",{"_title" : "세무사 추천","_type" : "2"});
	if(_APP_ID == "SERP") iWebAction("getStorage",{_key : "keyWebResultTTS_SERP", _call_back : "fn_getWebResultTTS"}); 
	else if(_APP_ID == "KTSERP") iWebAction("getStorage",{_key : "keyWebResultTTS_KTSERP", _call_back : "fn_getWebResultTTS"});
	else if(_APP_ID == "ZEROPAY") iWebAction("getStorage",{_key : "keyWebResultTTS_ZEROPAY", _call_back : "fn_getWebResultTTS"});
	else iWebAction("getStorage",{_key : "keyWebResultTTS", _call_back : "fn_getWebResultTTS"});
	//iWebAction("getAppData",{"_key" : "_txofInfm", "_call_back" : "fn_gettxoflist"});
	
	$(document).on("click", "#btn_back", function(){
		fn_back();
	});
});
function fn_gettxoflist(data){
	jArr_txofInfm = data;
}
function fn_getWebResultTTS(data){
	avatar.common.null2void(data)==""?data="Y":data=data;
	//무조건 on
	$.each($("#RESULT_TTS").children(), function(i, v){
		if(avatar.common.null2void($(v).attr("data-type"))!="" && $(v).attr("data-type").indexOf("dateday")>-1){
			$(v).text(formatter.datekr($(v).text().replace(/\./g, '').replace(/ /g, '').replace(/\([ㄱ-힣]\)/, '')));
		}
	});
	if(data == "Y"){
		//cb_getWebResultTTS();
		iWebAction("webResultTTS",{"_data" : avatar.common.null2void($("#RESULT_TTS").text()), "_call_back" : "cb_getWebResultTTS"});
	} else {
		setTimeout(function() {
			cb_getWebResultTTS();
		}, 3000)
	}
}
function cb_getWebResultTTS(){
	iWebAction("phoneCall",{"_type" : "0", "_phone_num" : CHRG_TEL_NO});
	iWebAction("setAppData",{"_key" : "_isPhoneCall", "_value" : "true"});
	var _temp_txofInfm = {};
	//var jArr_txofInfm = [];
	_temp_txofInfm.chrg_nm = CHRG_NM;
	_temp_txofInfm.chrg_tel_no = CHRG_TEL_NO;
	_temp_txofInfm.biz_no = avatar.common.null2void(BIZ_NO);
	_temp_txofInfm.seq_no = avatar.common.null2void(SEQ_NO);
	iWebAction("setAppData",{"_key" : "_temp_txofInfm", "_value" : encodeURIComponent(JSON.stringify(_temp_txofInfm))});
	fn_back();
}
function cb_checkPermission(data){
	if(data == "Y"){
		iWebAction("phoneCall",{"_type" : "1", "_phone_num" : CHRG_TEL_NO});
		iWebAction("setAppData",{"_key" : "_isPhoneCall", "_value" : "true"});
		var _temp_txofInfm = {};
		//var jArr_txofInfm = [];
		_temp_txofInfm.chrg_nm = CHRG_NM;
		_temp_txofInfm.chrg_tel_no = CHRG_TEL_NO;
		_temp_txofInfm.biz_no = avatar.common.null2void(BIZ_NO);
		_temp_txofInfm.seq_no = avatar.common.null2void(SEQ_NO);
		iWebAction("setAppData",{"_key" : "_temp_txofInfm", "_value" : encodeURIComponent(JSON.stringify(_temp_txofInfm))});
		fn_back();
	} else {
		$("body").append(_modal1.fn_makeModal1());
	}
	
}

function fn_back(){
	if(decodeURIComponent(PREV_YN) === "N"){
		iWebAction("closePopup",{_callback:"fn_popCallback2"});
	} else {
		iWebAction("closePopup");
	}
}
function modalClose1() {
	$("#modal1").hide();
	fn_back();
}
let _modal1 = {
		fn_makeModal1 : function() {
			var modal1 = ''
			modal1+='<div class="modaloverlay" id="modal1">';
			modal1+='	<div class="lytb"><div class="lytb_row"><div class="lytb_td"><div class="layer_style3">';
			modal1+='		<div class="layer_po">';
			modal1+='			<div class="cont">';
			modal1+='				<p class="lyp_txt1">';
			modal1+='					접근 권한 거부로 해당 기능을 사용할 수 없습니다.';
			modal1+='				</p>';
			modal1+='			</div>';
			modal1+='		</div>';
			modal1+='		<div class="ly_btn_fix_botm type1"><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->';
			modal1+='			<a href="#none" onclick="modalClose1()">확인</a>';
			modal1+='		</div>';
			modal1+='	</div></div></div></div>';
			modal1+='</div>';
			return modal1;
		},
}
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