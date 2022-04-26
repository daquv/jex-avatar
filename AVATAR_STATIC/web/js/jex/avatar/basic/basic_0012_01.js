/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0012_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 박지은 (  )
 * @Description    : 프로필-서비스탈퇴
 * @History        : 20210726095637, 박지은
 * </pre>
 **/
var cancelYn=false;
$(function(){
	_thisPage.onload();
	//탈퇴취소
	$("#cancel_btn").on("click",function(){
		cancelYn = true;
		fn_back();
	});
	
	//탈퇴하기
	$("#trmn_btn").on("click",function(){
		cancelYn = true;
		$("#modaloverlay02").show();
	});
	
	//탈퇴완료
	$("#comp_btn").on("click",function(){
		cancelYn = false;
		fn_logOut();
	});
	
	// 탈퇴취소 팝업
	$("#pop_cancel_btn").on("click",function(){
		cancelYn = true;
		$("#modaloverlay02").hide();
	});
	
	// 탈퇴확인 팝업
	$("#pop_trmn_btn").on("click",function(){
		cancelYn = false;
		$("#modaloverlay02").hide();
		fn_trmn();
	});
});

var _thisPage={
	onload : function(){
		iWebAction("changeTitle",{"_title" : "서비스 탈퇴","_type" : "2"});
		iWebAction("fn_display_mic_button",{"_display_yn":"N"});
	}
}
function fn_trmn(){
	var jexAjax = jex.createAjaxUtil("basic_0012_01_c001");
	jexAjax.execute(function(data){
		if(data.RSLT_CD == "0000"){
			$("#modaloverlay01").show();
			setTimeout(function(){
				//탈퇴 성공 후 로그아웃
				fn_logOut();
			}, 5000);	
		}else{
			alert("탈퇴 처리 중 오류가 발생하였습니다.\n잠시후 다시 시도해주세요.");
		}
	});
}

function fn_logOut(){
	$("#modaloverlay01").hide();
	// 회원탈퇴
	iWebAction("resignMemeber");
}

function fn_back(){
	if(cancelYn){
		iWebAction("closePopup",{_callback:"fn_popCallback"});
	} else {
		iWebAction("closePopup");
	}
}