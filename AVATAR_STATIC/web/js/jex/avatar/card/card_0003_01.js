/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : card_0003_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/card
 * @author         : 김태훈 (  )
 * @Description    : 
 * @History        : 20200121144600, 김태훈
 * </pre>
 **/
$(function(){
	_thisPage.onload();
	//취소,확인
	$("#a_cancel,#a_enter").on("click",function(){
		fn_back();
	});
	//삭제
	$("#a_del").on("click",function(){
		fn_deleteCard();
	});
	//id 필드 이벤트
	$("#inp_id").on("keyup", function(e) {
		if(e.keyCode == 13){
			$("#inp_pass").focus().click();
		}
	});
	$("#inp_pass").on("click",function(){
		// 비밀번호 입력 액션 호출
		iWebAction( "secureKeypad",{
			   _menu_id: ""
			  ,_type:"2"
			  ,_title:"카드매출 가져오기"
		   	  ,_callback:"callbackFunc"
		   	  ,_desc:["여신금융협회 비밀번호를 입력하세요."]
//			  ,_input_label:["비밀번호"]
//  		  ,_input_hintl:["힌트1","힌트2"]
		      ,_data:{
		    	   _min_length:"8"  
				  ,_max_length :"15"
		      }
		});
	});

});
var _thisInfm = {WEB_ID:"",WEB_PWD:""};
var _thisPage = {
		onload : function(){
			//결과 페이지에서 결과값을 다시 받음
			_thisInfm.RSLT_CD=$("#RSLT_CD").val();
			_thisPage.searchData();
		},
		searchData : function(){
			avatar.common.callJexAjax("card_0003_01_r001", "", _thisPage.searchDataCallback, "", "c");
		},
		searchDataCallback : function(data){
			_thisInfm.STTS=avatar.common.null2void(data.STTS);
			if(_thisInfm.STTS == ""){
				iWebAction("changeTitle",{"_title" : "카드매출 가져오기","_type" : "2"});
				// 등록 정보 없음
				_thisInfm.PAGE_NO="0";
			}else if(_thisInfm.STTS == "9"){
				iWebAction("changeTitle",{"_title" : "카드매출 가져오기","_type" : "2"});
				// 해지
				_thisInfm.PAGE_NO="1";
			}else{
				iWebAction("changeTitle",{"_title" : "카드매출 관리","_type" : "2"});
				// 등록된 계정정보
				_thisInfm.PAGE_NO="1";
				_thisInfm.WEB_ID=data.WEB_ID;
				$("#inp_id").val(data.WEB_ID);
				$("#inp_id").attr("readonly",true).attr("disabled",false);
				$("#inp_id").parent().addClass('on');
				$("#inp_pass").val("0000000000");
				fn_setBtn();
			}
		},
		//유효값 체크
		chkVal : function(){
			var web_id = $("#inp_id").val();
			var web_pwd = $("#inp_pass").val();
			var page_no = _thisInfm.PAGE_NO;

			// 최초 조회된 값과 입력된 값이 같고, 비밀번호가 변경되지 않았으면 저장 시 창 닫음
			if(web_id==_thisInfm.WEB_ID && _thisInfm.WEB_PWD.length=="0"){
//				iWebAction("back");
			}
			if(web_id.length==0){
				$(".toast_pop").find('span').text("아이디를 입력해주세요.");
				$(".toast_pop").css("display", "block");
				$(".toast_pop").fadeOut(5000);
				return false;
			}else if(web_id.length < 5 || web_id.length > 20){
				$(".toast_pop").find('span').text("아이디는 영문, 숫자 5자리~20자리 입니다.");
				$(".toast_pop").css("display", "block");
				$(".toast_pop").fadeOut(5000);
				return false;
			}
			if(web_pwd.length==0){
				$(".toast_pop").find('span').text("비밀번호를 입력해주세요.");
				$(".toast_pop").css("display", "block");
				$(".toast_pop").fadeOut(5000);
				return false;
			}else if(web_pwd.length < 8 || web_pwd.length > 15){
				$(".toast_pop").find('span').text("비밀번호는 영문, 숫자 8자리~15자리 입니다.");
				$(".toast_pop").css("display", "block");
				$(".toast_pop").fadeOut(5000);
				return false;
			}
			// 0:신규, 1:수정
			if(page_no=="0"){
				_thisPage.regCard(web_id,_thisInfm.WEB_PWD);
			} else {
				_thisPage.modCard(web_id,web_pwd,_thisInfm.WEB_PWD);
			}
		},
		//등록
		regCard :function(web_id,web_pw){
			var input = {};
			input["WEB_ID"]= web_id;
			input["WEB_PWD"]= web_pw;
			input["USE_YN"]= "Y";
			iWebAction("showIndicator");
			avatar.common.callJexAjax("card_0003_01_c001", input, _thisPage.regCardCallback, "", "c");
		},
		//등록 후 콜백
		regCardCallback : function(data){
			iWebAction("hideIndicator");
			var url = "card_0004_01.act?RSLT_CD="+data.RSLT_CD+"&RSLT_MSG="+data.RSLT_MSG;
			iWebAction("openPopup",{_url:url});
			//location.href=url;
		},
		//수정
		modCard :function(web_id, web_pwd, web_pwd_h){
			var input = {};
			input["WEB_ID"]			= web_id;
			input["WEB_PWD"]		= web_pwd;
			input["WEB_PWD_CHK"]	= web_pwd_h;
			input["USE_YN"]			= "Y";
			input["STTS"]			= _thisInfm.STTS;
			iWebAction("showIndicator");
			var callbackfn = _thisInfm.PAGE_NO="1"?_thisPage.regCardCallback:_thisPage.modCardCallback;
			avatar.common.callJexAjax("card_0003_01_u001", input, callbackfn, "", "c");
		},
		//수정 콜백
		modCardCallback : function(data){
			iWebAction("hideIndicator");
			var input = {};
			input["RSLT_CD"]	= avatar.common.null2void(data.RSLT_CD);
			input["RSLT_MSG"]	= avatar.common.null2void(data.RSLT_MSG);
			if(data.RSLT_CD == "00000000"){// 성공
				fn_successCard();
			}else{
				fn_failCard(data.RSLT_CD,data.RSLT_MSG);
			}
		},
		//삭제
		deleteCard :function(){
			var input = {};
			input["WEB_ID"]		= _thisInfm.WEB_ID;
//			input["WEB_PWD"]	= _thisInfm.WEB_PWD;
//			input["USE_YN"]		= "N";
			iWebAction("showIndicator");
			avatar.common.callJexAjax("card_0003_01_d001", input, _thisPage.deleteCardCallback, "", "c");
		},
		//삭제 콜백 함수
		deleteCardCallback : function(data){
			fn_removeModal();
			if(data.RSLT_CD == "00000000"){// 성공
				$(".toast_pop").find('span').text("삭제되었습니다.");
				$('.toast_pop').css('display', 'block');
				$('a').off("click");
				setTimeout(function(){
					//삭제 처리 후 데이터 가져오기 화면으로 이동
					iWebAction("closePopup",{_callback:"fn_popCallback"});
				}, 2000);	
			}
			iWebAction("hideIndicator");
		}
}
//조회 결과에 따른 버튼 제어
function fn_setBtn(){
	$(".btn_fix_botm").eq(0).hide();
	$(".btn_fix_botm").eq(1).show();
}
//비밀번호 입력 완료 후 콜백함수
function callbackFunc(backData){
	var JData = JSON.parse(backData);
	var JDataPwd1 = JData._pwd;  
	var hPWD = JDataPwd1.encrypt_data;
	var PWD = avatar.common.gapReturn(JDataPwd1.length);
	_thisInfm.WEB_PWD=hPWD;
	$('#inp_pass').val(PWD);
	_thisPage.chkVal();
}
//삭제 모달 생성
function fn_deleteCard(){
	var modalHtml='';
	modalHtml +='<div class="modaloverlay">';
	modalHtml +='	<div class="lytb"><div class="lytb_row"><div class="lytb_td">';
	modalHtml +='	<div class="layer_style1">';
	modalHtml +='		<div class="layer_po">';
	modalHtml +='			<div class="cont">';
	modalHtml +='				<p class="lyp_txt3" style="margin-top:0;">';
	modalHtml +='				카드매출 가져오기 정보를 삭제하면<br>';
	modalHtml +='				카드매출 정보를 조회할 수 없습니다.';
	modalHtml +='				</p>';
	modalHtml +='				<div class="lyp_tit" style="margin-top:17px;">삭제하시겠습니까?</div>';
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
//정상 처리 모달 생성
function fn_successCard(){
	var modalHtml='';
	modalHtml +='<div class="modaloverlay">';
	modalHtml +='	<div class="lytb"><div class="lytb_row"><div class="lytb_td">';
	modalHtml +='	<div class="layer_style1">';
	modalHtml +='		<div class="layer_po">';
	modalHtml +='			<div class="cont">';
	modalHtml +='				<p class="lyp_tit">';
	modalHtml +='				정상적으로 변경되었습니다.';
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
//실패 처리 모달 생성
function fn_failCard(err_cd,err_msg){
	var modalHtml='';
	modalHtml +='<div class="modaloverlay">';
	modalHtml +='	<div class="lytb"><div class="lytb_row"><div class="lytb_td">';
	modalHtml +='	<div class="layer_style1">';
	modalHtml +='		<div class="layer_po">';
	modalHtml +='			<div class="cont">';
	modalHtml +='				<p class="lyp_tit mgb20" style="margin:0 0 7px;">';
	modalHtml +='				카드매출 수정이 실패하였습니다.<br>계정 정보를 다시 확인해주세요.';
	modalHtml +='				</p>';
	modalHtml +='				<div class="lyp_stxt">';
	modalHtml +='				['+err_cd+'] '+err_msg;
	modalHtml +='				</div>';
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
//백버튼?
function fn_back(){
	iWebAction("closePopup",{_callback:"fn_popCallback"});
	/*
	if(avatar.common.null2void(_thisInfm.RSLT_CD)=="00000000"){
		iWebAction("closePopup",{_callback:"fn_popCallback"});
	} else {
		iWebAction("closePopup");
	}
	*/
}
//팝업화면 콜백
function fn_popCallback(){
	iWebAction("closePopup",{_callback:"fn_popCallback"});
}