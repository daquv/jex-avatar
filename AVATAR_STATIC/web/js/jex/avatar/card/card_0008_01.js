/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : card_0008_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/card
 * @author         : 김태훈 (  )
 * @Description    : 카드매입관리-수정정보확인
 * @History        : 20200128162759, 김태훈
 * </pre>
 **/
$(function(){
//	_thisPage.onload();
	//교체
	$("#a_change").on("click",function(){
		pwdPageCall();
	});
	//삭제
	$("#a_del").on("click",function(){
		fn_setModal();
	});
	//확인
	$("#a_enter").on("click",function(){
		//우선 백버튼과 같은 동작
		fn_back(); 
	});
	
});
var _thisInfo = {};
var _thisPage = {
		onload : function (){
			iWebAction("changeTitle",{"_title" : "카드매입 관리","_type" : "2"});
//			_thisPage.searchCert();
		},
//		searchCard : function(){
//			var input = {};
//			input["BANK_CD"]=$("#BANK_CD").val();
//			input["CARD_NO"]=$("#CARD_NO").val();
//			avatar.common.callJexAjax("card_0008_01_r001",input,_thisPage.searchCardCallback);
//		},
//		searchCardCallback : function(data){
//			console.log(data);
//			if(avatar.common.null2void(data.RSLT_CD)=="9999"){
//				alert(data.RSLT_MSG);
//				return;
//			}
//		},
		deleteCard : function(){
			var input={};
			input["BANK_CD"]		="30000"+$("#BANK_CD").val();
			input["WEB_ID"]			=$("#WEB_ID").val();
			input["CARD_NO"]		=$("#CARD_NO").val();
//			iWebAction("showProgress");
			avatar.common.callJexAjax("card_0008_01_d001",input,_thisPage.deleteCardCallback);
		},
		deleteCardCallback : function(data){
			if(avatar.common.null2void(data.RSLT_CD)=="9999"){
				alert(data.RSLT_MSG);
				return;
			}
			fn_removeModal();
			if(data.RSLT_CD == "0000"){
//				iWebAction("fn_certUseYn",{
//					"_cert_use_yn"	: data.CERT_USE_YN,
//					"_cert_nm"		: _thisInfo.CERT_NM,
//	    			"_cert_dt" 		: _thisInfo.CERT_DT
//				});
				$('.toast_pop').css('display', 'block');
				$('a').off("click");
				setTimeout(function(){
					//삭제 처리 후 데이터 가져오기 화면으로 이동
					iWebAction("closePopup",{_callback:"fn_popCallback"});
				}, 2000);
				
			}else{
				fn_setMsgModal("삭제실패하였습니다.");
			}
//			iWebAction("hideProgress");
		}
}
//모달 만들기
function fn_setModal(){
	var modalHtml='';
	modalHtml +='<div class="modaloverlay">';
	modalHtml +='	<div class="lytb"><div class="lytb_row"><div class="lytb_td">';
	modalHtml +='	<div class="layer_style1">';
	modalHtml +='		<div class="layer_po">';
	modalHtml +='			<div class="cont">';
	modalHtml +='				<p class="lyp_txt3" style="margin-top:0;">';
	modalHtml +='					카드매입 가져오기 정보를 삭제하면<br>';
	modalHtml +='					카드매입 정보를 조회할 수 없습니다.';
	modalHtml +='				</p>';
	modalHtml +='				<p class="lyp_tit" style="margin-top:17px;">삭제하시겠습니까?</p>';
	modalHtml +='			</div>';
	modalHtml +='		</div>';
	modalHtml +='		<div class="ly_btn_fix_botm btn_both"><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->';
	modalHtml +='			<a class="off" onClick="fn_removeModal()">취소</a>';
	modalHtml +='			<a onClick="_thisPage.deleteCard()">확인</a>';
	modalHtml +='		</div>';
	modalHtml +='	</div>';
	modalHtml +='	</div></div></div>';
	modalHtml +='</div>';
	$('body').append(modalHtml);
}
function fn_setMsgModal(msg){
	var modalHtml='';
	modalHtml +='<div class="modaloverlay">';
	modalHtml +='	<div class="lytb"><div class="lytb_row"><div class="lytb_td">';
	modalHtml +='	<!-- layerpopup -->';
	modalHtml +='	<div class="layer_style1">';
	modalHtml +='		<div class="layer_po">';
	modalHtml +='			<div class="cont">';
	modalHtml +='				<p class="lyp_tit">';
	modalHtml += msg;
	modalHtml +='				</p>';
	modalHtml +='			</div>';
	modalHtml +='		</div>';
	modalHtml +='		<div class="ly_btn_fix_botm"><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->';
	modalHtml +='			<a onClick="fn_removeModal()">확인</a>';
	modalHtml +='		</div>';
	modalHtml +='	</div>';
	modalHtml +='	</div></div></div>';
	modalHtml +='</div>';
	$('body').append(modalHtml);
}
//모달 닫기
function fn_removeModal(){
	$(".modaloverlay").remove();
}
//비밀번호 액션 호출
function pwdPageCall(){
	iWebAction( "secureKeypad",{
		   _menu_id: ""
		  ,_type:"2"
		  ,_title:"카드매입 가져오기"
	   	  ,_callback:"callbackFunc"
	   	  ,_desc:["카드사 비밀번호를 입력하세요."]
//		  ,_input_label:["라벨1","라벨2"]
//		  ,_input_hintl:["힌트1","힌트2"]
	      ,_data:{
	    	   _min_length:"3"  
			  ,_max_length :"20"
	      }
	});
}
//웹 액션 콜백
function callbackFunc(backData){
	var JData = JSON.parse(backData);
	var JDataPwd1 = JData._pwd;
	var hPWD = JDataPwd1.encrypt_data;
	// 기업카드 웹PW 비밀번호 변경
	var input={};
//	input["SCQKEY"]		=_CIPHER_KEY;
	input["BANK_CD"]	=$("#BANK_CD").val();
	input["CARD_NO"]	=$("#CARD_NO").val();
	input["WEB_ID"]		=$("#WEB_ID").val();
	input["WEB_PWD"]	=hPWD;
	iWebAction("showIndicator");
	avatar.common.callJexAjax("card_0008_01_u001",input,callbackFuncCallBack);
}
function callbackFuncCallBack(data){
	iWebAction("hideIndicator");
	if(data.RSLT_CD == "0000"){
		// 비밀번호 변경 성공
		fn_setMsgModal("정상적으로 변경되었습니다.");
	}else{
		fn_setMsgModal("비밀번호 변경에 실패하였습니다.<br>["+fn_changeTxt(data.RSLT_MSG)+"]");
	}
}
//.을 .<br>로 변환 <마지막 . 제외>
function fn_changeTxt(txt){
	if(!txt || txt=="") return "";
	txt = txt.match(/\./g || []).length>1?txt.replace(/\./,".<br>"):txt;
	return txt;
} 
//백버튼?
function fn_back(){
	location.href="card_0007_01.act?BANK_CD="+$("#BANK_CD").val()+"&BANK_NM="+$("#BANK_NM").val();
}