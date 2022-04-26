/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : snss_0003_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/snss
 * @author         : 박지은 (  )
 * @Description    : 온라인매출 연결하기 완료화면
 * @History        : 20210722151534, 박지은
 * </pre>
 **/
$(function(){
	iWebAction("changeTitle",{"_title" : "온라인매출 연결하기","_type" : "4"});
	
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
	iWebAction("closePopup",{_callback:"fn_backPopCallback"});
	/*
	if("00000000"==$("#RSLT_CD").val()){
		location.href = "snss_0003_02.act";
	} else {
		iWebAction("closePopup",{_callback:"fn_popCallback"});
	}
	*/
}

// 온라인매출 내역 실시간 조회
function fn_realTimeSearch(){
	var jexAjax = jex.createAjaxUtil("snss_0003_01_c001");
    jexAjax.set("SHOP_CD", $("#SHOP_CD").val());
    jexAjax.set("SUB_SHOP_CD", $("#SUB_SHOP_CD").val());
	jexAjax.execute();
}

//백버튼
function fn_back(){
	if($("#RSLT_CD").val() == "00000000"){
		iWebAction("closePopup",{_callback:"fn_backPopCallback"});
	} else {
		iWebAction("closePopup");
	}
}