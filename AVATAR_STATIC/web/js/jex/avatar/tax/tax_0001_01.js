/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : tax_0001_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/tax
 * @author         : 김태훈 (  )
 * @Description    : 홈텍스가져오기 화면
 * @History        : 20200117174647, 김태훈
 * </pre>
 **/
$(function(){
	iWebAction("changeTitle",{"_title" : "홈택스 가져오기","_type" : "2"});
	
	if("00000000"==$("#RSLT_CD").val()){
		// 데이터 가져오기
		fn_realTimeSearch();
	}
	
	//확인버튼
	$("#a_enter").on("click",function(){
		fn_confirm();
	});
});

function fn_confirm(){
	if("00000000"==$("#RSLT_CD").val()){
		/*
		if($("#TAX_GB").val() == "etaxcash"){
			location.href = "tax_0001_02.act";	
		}else{
			location.href = "tax_0001_03.act";
		}
		*/
		//성공
		iWebAction("closePopup",{_callback:"fn_popCallback"});
	} else {
		//iWebAction("closePopup",{_callback:"fn_popCallback_tax"});
		location.href = "tax_0004_01.act?TAX_GB="+$("#TAX_GB").val();
	}
}

// 홈택스 내역 실시간 조회
function fn_realTimeSearch(){
	var jexAjax = jex.createAjaxUtil("tax_0001_02_c001");
	if($("#TAX_GB").val() == "etaxcash"){
		jexAjax.set("TASK_GB", "0206");	// 0206:전자세금계산서/현금영수증
	}else{
		jexAjax.set("TASK_GB", "07");	// 07 : 세액
	}
	jexAjax.execute();
}

// 백버튼
function fn_back(){
	if("00000000"==$("#RSLT_CD").val()){
		//성공
		iWebAction("closePopup",{_callback:"fn_popCallback"});
	} else {
		iWebAction("closePopup",{_callback:"fn_popCallback_tax"});
	}
}