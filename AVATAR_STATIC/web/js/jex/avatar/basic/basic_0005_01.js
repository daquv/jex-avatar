/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0005_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 김태훈 (  )
 * @Description    : 연계시스템 가져오기(경리나라) 화면
 * @History        : 20200602104653, 김태훈
 * </pre>
 **/
$(function(){
	_thisPage.onload();
	//사업자번호 엔터
	$("#inp_bsnn_no").on("keyup focus", function(e){
		if($(this).attr("readonly")){
			return false;
		}
		var maxlength = $(this).attr("maxlength");
		var str = $(this).val().replace(/[^0-9]/gi,"");		// 숫자만 입력 가능
		if(str.length > maxlength){
	    	$(this).val(str.slice(0,maxlength));
	    }else{
	    	$(this).val(str);	
	    }		    
		if(e.keyCode == 13){
			$("#inp_id").focus();
		}
	});
	//사업자번호 파싱
	$("#inp_bsnn_no").blur(function(){
		// 모든항목 입력 시
        if($(this).val().length==10){
        	$(this).val(avatar.common.corpno_format($(this).val()));
        }
	});
	//serp 아이디 엔터
	$("#inp_id").on("keyup", function(e){
		var regExp = /[^a-z0-9!@#$%^()+-=]/gi;
		$(this).val( $(this).val().replace(regExp,"") );
		if(e.keyCode == 13){
			$("#inp_pswd").focus().click();
		}
	});
	
	$("#inp_pswd").on("click",function(){
		// 비밀번호 입력 액션 호출
		iWebAction( "secureKeypad",{
			   _menu_id: ""
			  ,_type:"2"
			  ,_title:"경리나라 연결하기"
		   	  ,_callback:"callbackFunc"
		   	  ,_desc:["경리나라 비밀번호를 입력하세요."]
//			  ,_input_label:["라벨1","라벨2"]
//			  ,_input_hintl:["힌트1","힌트2"]
//		      ,_data:{
//		    	   _min_length:"8"  
//				  ,_max_length :"15"
//		      }
		});
	});
	
	$("#a_save").on("click",function(){
		if(avatar.common.null2void($("#inp_id").val()) == ""){
			$(".toast_pop").find('span').text("아이디를 입력해주세요.");
			$(".toast_pop").css("display","block");
			$(".toast_pop").fadeOut(5000);
			return;
		}
//		else if(!avatar.common.emailChk($("#inp_id").val())){
//			$(".toast_pop").find('span').text("아이디는 이메일 형식입니다.");
//			$(".toast_pop").css("display","block");
//			$(".toast_pop").fadeOut(5000);
//			return;
//		}
		else if(avatar.common.null2void(_thisInfm.WEB_PWD_H) == ""){
			$(".toast_pop").find('span').text("비밀번호를 입력해주세요.");
			$(".toast_pop").css("display","block");
			$(".toast_pop").fadeOut(5000);
			return;0
		}
		else if(avatar.common.null2void($("#inp_bsnn_no").val()) == ""){
			$(".toast_pop").find('span').text("사업자등록번호를 입력해주세요.");
			$(".toast_pop").css("display","block");
			$(".toast_pop").fadeOut(5000);
			return;
		}
		else{
			_thisInfm.SERP_USER_ID = $("#inp_id").val();
			_thisInfm.SERP_BSNN_NO = $("#inp_bsnn_no").val().replace(/-/gi,"");
			_thisPage.serpSave();
		}
	});
	//취소
	$("#a_cancel").on("click",function(){
		fn_back();
	});
	//삭제
	$("#a_del").on("click",function(){
		fn_deleteSerp();
	});
	//확인
	$("#a_enter").on("click",function(){
		iWebAction("closePopup",{_callback:"fn_popCallback"});
	});
});
var _thisInfm={};
var _thisPage={
		onload : function(){
			iWebAction("changeTitle",{"_title" : "경리나라 연결하기","_type" : "2"});
			_thisPage.searchData();
		},
		searchData : function(){
			var input={};
			input["APP_ID"]	="SERP";
			iWebAction("showIndicator");
			avatar.common.callJexAjax("basic_0005_01_r001",input,_thisPage.searchDataCallback);
		},
		searchDataCallback : function(data){
			if(avatar.common.null2void(data.USER_ID)!="" && avatar.common.null2void(data.BIZ_NO)!=""){
				_thisInfm.UP_YN 	   = "Y";
				_thisInfm.SERP_USER_ID = data.USER_ID;
				_thisInfm.SERP_BSNN_NO = data.BIZ_NO;
				
				iWebAction("changeTitle",{"_title" : "경리나라 관리","_type" : "2"});
				
				$("#inp_bsnn_no").val(avatar.common.corpno_format(data.BIZ_NO));
				$("#inp_bsnn_no").closest(".input_type").addClass("on");
				$("#inp_bsnn_no").attr("readonly",true);
				$("#inp_id").val(data.USER_ID);
				$("#inp_id").closest(".input_type").addClass("on");
				$("#inp_id").attr("readonly",true);
				$("#inp_pswd").val("********");
				//기동록의 경우 하단버튼 변경
				$("div[name=bottomBtn]").eq(0).hide();
				$("div[name=bottomBtn]").eq(1).show();
			}
			iWebAction("hideIndicator");
		},
		serpSave : function(data){
			var input={};
			input["APP_ID"]			= "SERP";
			input["SERP_USER_ID"]	= _thisInfm.SERP_USER_ID;
			input["SERP_BIZ_NO"]	= _thisInfm.SERP_BSNN_NO;
			input["SERP_PWD"]		= _thisInfm.WEB_PWD_H;
			iWebAction("showIndicator");
			avatar.common.callJexAjax("basic_0005_01_c001",input,_thisPage.serpSaveCallback);
		},
		serpSaveCallback : function(data){
//			iWebAction("hideProgress");
			iWebAction("hideIndicator");
			//등록, 수정 같은 act 사용
			if(_thisInfm.UP_YN=="Y"){
				if(data.RSLT_CD=="0000"){
					iWebAction("fn_syncLoginInfo",{"BSNN_NM" : data.BSNN_NM });
					_thisInfm["RSLT_CD"]=data.RSLT_CD;
					fn_successSerp();
				} else {
					fn_failSerp(data.RSLT_CD,data.RSLT_MSG);
				}
			} else {
				iWebAction("fn_syncLoginInfo",{"BSNN_NM" : data.BSNN_NM });
				var url = "basic_0005_02.act?RSLT_CD="+data.RSLT_CD+"&RSLT_MSG="+data.RSLT_MSG;
				iWebAction("openPopup",{"_url" : url});
			}
		},
		serpDel : function(data){
			var input={};
			input["APP_ID"]			= "SERP";
			input["SERP_USER_ID"]	= _thisInfm.SERP_USER_ID;
			input["SERP_BIZ_NO"]	= _thisInfm.SERP_BSNN_NO;
			iWebAction("showIndicator");
			avatar.common.callJexAjax("basic_0005_01_d001",input,_thisPage.serpDelCallback);
		},
		serpDelCallback : function(data){
			fn_removeModal();
			if(data.RSLT_CD == "0000"){// 성공
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
//삭제 모달 생성
function fn_deleteSerp(){
	var modalHtml='';
	modalHtml +='<div class="modaloverlay">';
	modalHtml +='	<div class="lytb"><div class="lytb_row"><div class="lytb_td">';
	modalHtml +='	<div class="layer_style1">';
	modalHtml +='		<div class="layer_po">';
	modalHtml +='			<div class="cont">';
	modalHtml +='				<p class="lyp_txt3" style="margin-top:0;">';
	modalHtml +='				경리나라 연결하기 정보를 삭제하면<br>';
	modalHtml +='				경리나라 질의를 조회할 수 없습니다.';
	modalHtml +='				</p>';
	modalHtml +='				<div class="lyp_tit" style="margin-top:17px;">삭제하시겠습니까?</div>';
	modalHtml +='			</div>';
	modalHtml +='		</div>';
	modalHtml +='		<div class="ly_btn_fix_botm btn_both"><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->';
	modalHtml +='			<a class="off" onClick="fn_removeModal()">취소</a>';
	modalHtml +='			<a onClick="_thisPage.serpDel()">확인</a>';
	modalHtml +='		</div>';
	modalHtml +='	</div>';
	modalHtml +='	</div></div></div>';
	modalHtml +='</div>';
	$('body').append(modalHtml);	
}
//정상 처리 모달 생성
function fn_successSerp(){
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
function fn_failSerp(err_cd,err_msg){
	var modalHtml='';
	modalHtml +='<div class="modaloverlay">';
	modalHtml +='	<div class="lytb"><div class="lytb_row"><div class="lytb_td">';
	modalHtml +='	<div class="layer_style1">';
	modalHtml +='		<div class="layer_po">';
	modalHtml +='			<div class="cont">';
	modalHtml +='				<p class="lyp_tit mgb20" style="margin:0 0 7px;">';
	modalHtml +='				경리나라 정보 수정이<br><strong class="c_red">실패</strong>하였습니다.<br>계정 정보를 다시 확인해주세요.';
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
function callbackFunc(backData){
	var pwData = JSON.parse(backData);
	var pwData1 = pwData._pwd;
	_thisInfm["WEB_PWD_H"]=pwData1.encrypt_data;
    $('#inp_pswd').val(avatar.common.gapReturn(pwData1.length));
    if(_thisInfm.UP_YN=="Y"){
    	_thisPage.serpSave();
    }
}
//모달 닫기
function fn_removeModal(){
	$(".modaloverlay").remove();
}
//basic_0005_02에서 호출 - main 으로 이동
function fn_popCallback(){
	iWebAction("closePopup",{_callback:"fn_popCallback"});
}
function fn_back(){
	if(avatar.common.null2void(_thisInfm.RSLT_CD)=="0000"){
		iWebAction("closePopup",{_callback:"fn_popCallback"});
	} else {
		iWebAction("closePopup");	
	}
}