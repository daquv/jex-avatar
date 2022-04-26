/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : acct_0001_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/acct
 * @author         : 김태훈 (  )
 * @Description    : 은행별 계좌 목록 화면
 * @History        : 20200116151257, 김태훈
 * </pre>
 **/
$(function(){
	_thisPage.onload();
	$(document).on("click","li[name=ACCT] .left",function(){
		var tmp = $(this).parents("li").data("tmp");
		tmp = decodeURIComponent(tmp);
		tmp = avatar.common.null2void(tmp)==""?"":JSON.parse(tmp);
		var input = {};
		input["BANK_NM"]			=tmp.BANK_NM;
		input["BANK_CD"]			=tmp.BANK_CD;
		input["BANK_GB"]			=tmp.BANK_GB;
		input["ACCT_NICK_NM"]		=tmp.ACCT_NICK_NM;
		input["FNNC_RPSN_INFM"]		=tmp.FNNC_RPSN_INFM;
		input["FNNC_UNQ_NO"]		=tmp.FNNC_UNQ_NO;
		input["FNNC_INFM_NO"]		=tmp.FNNC_INFM_NO;
		input["ACCT_DV"]			=tmp.ACCT_DV;
		input["CERT_NM"]			=encodeURIComponent(tmp.CERT_NM);
		avatar.common.pageMove("acct_0001_02.act",input);
	});
	// 토글 on/off
	$(document).on("click","li[name=ACCT] .btn_switch",function(){
		if($(this).hasClass('on')){
			$(this).removeClass('on');
			_thisPage.acctStts('off', $(this).closest("li").find(".acc_txt").data("fnnc_unq_no"));
		}
		else{
			$(this).addClass('on');
			_thisPage.acctStts('on', $(this).closest("li").find(".acc_txt").data("fnnc_unq_no"));
		}
	});
	//확인
	$("#a_enter").on("click",function(){
		fn_back(); 
	});
	
});
var _thisPage = {
		onload : function (){
			iWebAction("changeTitle",{"_title" : "은행데이터 관리","_type" : "2"});
			_thisPage.searchList();
		},
		searchList : function(){
			var input = {};
			input["BANK_CD"]=$("#BANK_CD").val();
			avatar.common.callJexAjax("acct_0001_01_r001",input,_thisPage.searchListCallback);
		},
		searchListCallback : function(data){
			if(avatar.common.null2void(data.RSLT_CD)=="9999"){
				alert(data.RSLT_MSG);
				return;
			}
			//계좌 목록
			if(data.REC.length>0){
				var acctHtml = '';
				var acctDv = '';
				$.each(data.REC,function(i,v){
					if(v.ACCT_DV == '01'){
						acctDv = '입출금';
					}else if(v.ACCT_DV == '02'){
						acctDv = '예적금';
					}else if(v.ACCT_DV == '03'){
						acctDv = '대출금';
					}
					//v.ACCT_DV =acctDv;
					
					acctHtml += '<li data-tmp='+encodeURIComponent(JSON.stringify(v))+' name="ACCT">';
					acctHtml += '	<div class="left noneArrow">';
					acctHtml += '		<div class="acc_tit">';
					acctHtml += avatar.common.null2void(v.BANK_NM) + (avatar.common.null2void(v.ACCT_NICK_NM)==""?"":"("+avatar.common.null2void(v.ACCT_NICK_NM)+")");
					//설계에는 없지만 퍼블에는 있는부분....
//					if((v.HIS_LST_STTS != "00000000" && v.HIS_LST_STTS != "0000" && v.HIS_LST_STTS != "42110000")
//						|| (v.BAL_LST_STTS != "00000000" && v.BAL_LST_STTS != "0000" && v.BAL_LST_STTS != "42110000")
//					){
//						acctHtml += '			<span class="cntalign"><a class="btn_t01 on">조회실패</a></span>';
//					}
					acctHtml += '		</div>';
					acctHtml += '		<div class="acc_txt" data-fnnc_unq_no = '+avatar.common.null2void(v.FNNC_UNQ_NO)+'>';
					acctHtml += '			<span class="c_793FFB">['+acctDv+']</span>'+ avatar.common.null2void(v.FNNC_RPSN_INFM);
					acctHtml += '		</div>';
					acctHtml += '	</div>';
					if(v.ACCT_STTS == "7"){
						acctHtml += '	<div class="btn"><a class="btn_switch"></a></div>';
					} else {
						acctHtml += '	<div class="btn"><a class="btn_switch on"></a></div>';
					}
					if(v.CERT_DT == "EXP"){
						acctHtml += '<div class="cerStatus"><span class="cerEnd">만료예정</span></div>';
					} else if(v.CERT_DT == "EXPED"){
						acctHtml += '<div class="cerStatus"><span class="cerEnd">인증서만료</span></div>';
					}
					//acctHtml += '	<div class="btn"><a class="btn_arr"></a></div>';
					acctHtml += '</li>';
				});
				$("#ul_list").html(acctHtml);
			}else{
				fn_popCallback();
			}
		},
		acctStts : function(menuDv, FNNC_UNQ_NO){
			var input = {};
			var acctStts = "";
			if(menuDv == "on") acctStts = "1";
			else acctStts = "7";
			input["ACCT_STTS"]=acctStts;
			input["FNNC_UNQ_NO"]=FNNC_UNQ_NO;
			avatar.common.callJexAjax("acct_0001_01_u001",input,_thisPage.acctSttsCallback);
		},
		acctSttsCallback : function(data){
			if(data.RSLT_CD == "0000"){
				
			} else {
				alert("처리 중 오류가 발생하였습니다.");
			}
		}
}
//백버튼?
function fn_back(){
	iWebAction("closePopup");
}

//웹액션 콜백 (fn_cert_list){
function fn_popCallback(){
	iWebAction("closePopup",{_callback:"fn_popCallback"});
}