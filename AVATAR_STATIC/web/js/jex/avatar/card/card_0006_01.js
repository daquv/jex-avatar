/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : card_0006_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/card
 * @author         : 김태훈 (  )
 * @Description    : 카드매입-카드정보완료화면
 * @History        : 20200128155825, 김태훈
 * </pre>
 **/
$(function(){
	_thisPage.onload();
	//확인버튼
	$("#c_enter").on("click",function(){
		fn_back();
	});
	
	//데이터 가져오기 버튼
	$("#a_enter").on("click",function(){
		fn_confirm();
	});
	
});
var _thisInfm={};
var _thisPage={
		onload : function(){
			iWebAction("changeTitle",{"_title" : "카드매입 가져오기","_type" : "2"});
			fn_setData();
		}
}
function fn_setData(){
	var CARD_REC = $("#CARD_LIST").val();
	CARD_REC = JSON.parse(decodeURIComponent(CARD_REC));
	var cardListHtml = "";
	var succYn = "N";
	$.each(CARD_REC, function(idx, rec){
		_thisInfm["RESULT_CD"]=rec.RESULT_CD;
		if(rec.RESULT_CD == "00000000"){
			succYn = "Y";
			$("#succ_dv").show();
		}else{
			$("#fail_dv").show();
		}
		cardListHtml += '	<div class="tit">';
		cardListHtml += '		<h2>';
		cardListHtml += '			<span>['+rec.BANK_NM+']</span> 총 <em>1</em>카드';
		cardListHtml += '		</h2>';
		cardListHtml += '	</div>';
		cardListHtml += '	<div class="sub">';
		cardListHtml += '		<div class="card">';
		cardListHtml += '			<h3>';
		if(rec.CARD_NO.length == 16){
			cardListHtml += '			<span class="tx_cateNum">'+rec.CARD_NO.substring(0, 4)+"-"+rec.CARD_NO.substring(4, 8)+"-"+rec.CARD_NO.substring(8, 12)+"-"+rec.CARD_NO.substring(12)+'</span>';
		}else if(rec.CARD_NO.length == 15){
			cardListHtml += '			<span class="tx_cateNum">'+rec.CARD_NO.substring(0, 4)+"-"+rec.CARD_NO.substring(4, 10)+"-"+rec.CARD_NO.substring(10, 15)+'</span>';
		}else{
			cardListHtml += '			<span class="tx_cateNum">'+rec.CARD_NO+'</span>';
		}
		cardListHtml += '			</h3>';
		cardListHtml += '			<div class="right">';
		if(rec.RESULT_CD == "00000000"){
			cardListHtml += '			<span class="tx_succ">완료</span>';
		}else{
			cardListHtml += '			<span class="tx_fail2">실패</span>';
		}
		cardListHtml += '			</div>';
		cardListHtml += '		</div>';
		cardListHtml += '	</div>';
		
	});
	
	if(succYn == "Y"){
		fn_realTimeSearch();
		$("#a_enter").show();
	}else{
		$("#c_enter").show();
	}
	$(".impBankData_lst").find('li').html(cardListHtml);
	$(".content").show();
}

function fn_confirm(){
	fn_back();
}

//카드승인내역 실시간 조회
function fn_realTimeSearch(){
	var CARD_REC = $("#CARD_LIST").val();
	CARD_REC = JSON.parse(decodeURIComponent(CARD_REC));
	
	var jexAjax = jex.createAjaxUtil("card_0006_02_c001");
	jexAjax.set("CARD_LIST", CARD_REC);
	jexAjax.execute();
}

function fn_back(){
	if("00000000"==_thisInfm.RESULT_CD){
		//성공
		iWebAction("closePopup",{_callback:"fn_popBackCallback"});
	} else {
		iWebAction("closePopup");
	}
}