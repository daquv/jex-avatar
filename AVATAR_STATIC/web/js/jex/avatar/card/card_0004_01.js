/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : card_0004_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/card
 * @author         : 김태훈 (  )
 * @Description    : 카드매출가져오기 완료화면
 * @History        : 20200121163430, 김태훈
 * </pre>
 **/
$(function(){
	iWebAction("changeTitle",{"_title" : "카드매출 가져오기","_type" : "4"});
	
	if("00000000"==$("#RSLT_CD").val()){
		// 데이터가져오기
		fn_realTimeSearch();
	}
	
	//확인버튼
	$("#a_enter").on("click",function(){
		fn_confirm();
	});
});

function fn_confirm(){
	if("00000000"==$("#RSLT_CD").val()){
		//location.href = "card_0004_02.act";
		iWebAction("closePopup",{_callback:"fn_popCallback"});
	} else {
		iWebAction("closePopup",{_callback:"fn_popCallback_tax"});
	}
}

//카드매출 내역 실시간 조회
function fn_realTimeSearch(){
	var jexAjax = jex.createAjaxUtil("card_0004_02_c001");
	jexAjax.execute();
}

//백버튼
function fn_back(){
//	iWebAction("closePopup",{_callback:"fn_popCallback"});
	//location.href="card_0003_01.act?RSLT_CD="+$("#RSLT_CD").val();
	
	if($("#RSLT_CD").val() == "00000000"){
		iWebAction("closePopup",{_callback:"fn_popCallback"});
	} else {
		iWebAction("closePopup");
	}
}