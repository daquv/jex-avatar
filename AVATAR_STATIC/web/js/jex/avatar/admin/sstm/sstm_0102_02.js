/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : sstm_0102_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/sstm
 * @author         : 김태훈 (  )
 * @Description    : 
 * @History        : 20200306160552, 김태훈
 * </pre>
 **/
var _thisInfm = {};
var _thisPage = {
		onload : function(){
			if(_thisInfm.MOD=="Y") _thisPage.searchInfm();
		}, searchInfm : function(){
			$("#ACVT_STTS").val(_thisInfm.ACVT_STTS);
			$("#RMRK").val(decodeURIComponent(_thisInfm.RMRK));
		}, updateInfm : function(){
			var jexAjax = jex.createAjaxUtil("sstm_0102_02_u001");   //PT_ACTION 웹 서비스 호출
			
			jexAjax.set("OTPT_SQNC"   , $("#OTPT_SQNC").val());    // 출력순서
			jexAjax.set("ACVT_STTS"   , $("#ACVT_STTS option:selected").val());    // 사용여부
			jexAjax.set("RMRK" 		  , $("#RMRK").val());    // 설명
			jexAjax.set("DSDL_GRP_CD" , _thisInfm.DSDL_GRP_CD);     // 구분자그룹코드
			jexAjax.set("DSDL_GRP_NM" ,  _thisInfm.DSDL_GRP_NM);    // 그룹코드명
			
			jexAjax.execute(function(data){
				if(data.ERR_CD == "0000"){
					parent.smartClosePop("_thisPage.fn_search");
				} else {
					alert(data.ERR_CD);
				}
			});
		}, saveInfm : function(){
			var jexAjax = jex.createAjaxUtil("sstm_0102_02_c001");   //PT_ACTION 웹 서비스 호출
			
			jexAjax.set("OTPT_SQNC"   , $("#OTPT_SQNC").val());    					// 출력순서
			jexAjax.set("ACVT_STTS"   , $("#ACVT_STTS option:selected").val());     // 사용여부
			jexAjax.set("RMRK" 		  , $("#RMRK").val());    						// 설명
			jexAjax.set("DSDL_GRP_CD" , $("#DSDL_GRP_CD").val());     				// 구분자그룹코드
			jexAjax.set("DSDL_GRP_NM" , $("#DSDL_GRP_NM").val());    				// 그룹코드명
			jexAjax.set("DSDL_KND_CD" , $("#DSDL_KND_CD option:selected").val());   // 코드종류
			
			jexAjax.execute(function(data){
				if(data.ERR_CD == "8888"){
					alert("사용할 수 없는 그룹코드 입니다.");
				} else if (data.ERR_CD == "0000"){
					parent.smartClosePop("_thisPage.fn_search");
				} else {
					alert(data.ERR_CD);
				}
			});
		}, deleteInfm : function(){
			var jexAjax = jex.createAjaxUtil("sstm_0102_02_d001");  //ACTION 그룹코드관리
			jexAjax.set("DSDL_GRP_CD"	, _thisInfm.DSDL_GRP_CD);     // 구분자그룹코드
			jexAjax.execute(function(data){
				if(data.ERR_CD == "0000"){
					parent.smartClosePop("_thisPage.fn_search");
				} else {
					alert(data.ERR_CD);
				}
			});
		}
}
$(function(){
	//입력 제한
	$("input[type=text]").on("keyup", function(){
		var maxlength = $(this).attr("maxlength");
		var str = $(this).val();
		//출력순서 숫자만 입력
		str = $(this).attr("id")=="OTPT_SQNC"?str.replace(/[^0-9]/gi,""):str;
	    if(str.length > maxlength){
	    	$(this).val(str.slice(0,maxlength));
	    }else{
	    	$(this).val(str);	
	    }
	});
	//취소
	$("#btnCancel, .btn_popclose").on("click", function(){
		parent.smartClosePop();
	});
	
	//저장
	$("#btnAdd").on("click", function(){
		if (fn_validate_input()){
			if(_thisInfm.MOD=="Y"){
				_thisPage.updateInfm();
			} else {
				_thisPage.saveInfm();
			}
		}							
	});
	// 삭제
	$("#btnDel").on("click",function(){
		_thisPage.deleteInfm();
	});
});
function fn_validate_input(){
	if(_thisInfm.MOD=="Y"){
		if(!validateNull("DSDL_GRP_NM"))
			return false;
	} else {
		if( !validateNull("DSDL_GRP_CD") )	
			return false;
		else if(!validateNull("DSDL_GRP_NM"))		
			return false;
	}
	return true;
}

//validate null value
function validateNull(cls){
	
	var value = $("#"+cls).val();
	if(value == null || value.trim() == ''){
		$("#"+cls).addClass("invalid");
		$("#"+cls).focus();
		return false;
	}else{
		$("#"+cls).removeClass("invalid");
		return true;
	}
}