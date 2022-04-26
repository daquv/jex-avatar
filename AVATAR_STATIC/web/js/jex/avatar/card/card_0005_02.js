/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : card_0005_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/card
 * @author         : 김태훈 (  )
 * @Description    : 카드매입-카드정보입력화면
 * @History        : 20200128155442, 김태훈
 * </pre>
 **/
$(function(){
	_thisPage.onload();
	//카드번호 숫자
	$("#CARD_NO").on("keyup", function(e){
		avatar.common.numInpCheck(this);
		if(e.keyCode == 13){
        	$("#WEB_ID").focus();
        }
	});
	$("#WEB_ID").on("keyup", function(e){
		var regExp = /[^a-z0-9!@#$%^()+-=]/gi;
		$(this).val( $(this).val().replace(regExp,"") );
		if(e.keyCode == 13){
			$("#WEB_PWD").focus().click();
		}
	});
	
	$("#WEB_PWD").on("click",function(){
		// 비밀번호 입력 액션 호출
		iWebAction( "secureKeypad",{
			   _menu_id: ""
			  ,_type:"2"
			  ,_title:"카드매입 가져오기"
		   	  ,_callback:"callbackFunc"
		   	  ,_desc:["카드사 비밀번호를 입력하세요."]
//			  ,_input_label:["라벨1","라벨2"]
//			  ,_input_hintl:["힌트1","힌트2"]
		      ,_data:{
		    	   _min_length:"3"  
				  ,_max_length :"20"
		      }
		});
	});
	
	$("#a_next").on("click",function(){
		// 카드번호 입력 여부 
		if(avatar.common.null2void($("#CARD_NO").val()) == ""){
			$(".toast_pop").find('span').text("카드번호를 입력해주세요.");
			$(".toast_pop").css("display","block");
			$(".toast_pop").fadeOut(5000);
			return;
		}
		// 카드사 아이디
		else if(avatar.common.null2void($("#WEB_ID").val()) == ""){
			$(".toast_pop").find('span').text("아이디를 입력해주세요.");
			$(".toast_pop").css("display","block");
			$(".toast_pop").fadeOut(5000);
			return;
		}
		// 카드사 비밀번호
		else if(avatar.common.null2void($("#WEB_PWD").val()) == ""){
			$(".toast_pop").find('span').text("비밀번호를 입력해주세요.");
			$(".toast_pop").css("display","block");
			$(".toast_pop").fadeOut(5000);
			return;
		}
		else{
			// 기업신용카드 등록
			_thisPage.cardSave();
		}
	});
	
	$("#CARD_NO, #WEB_ID").blur(function(){
		// 모든항목 입력 시
        if($("#CARD_NO").val() != "" 
        	&& $("#WEB_ID").val() != ""
        	&& $("#WEB_PWD").val() != ""){
        	$("#a_next").removeClass("off");
        }else{
        	$("#a_next").addClass("off");
        }
	});
});
var _thisInfm={};
var _thisPage={
		onload : function(){
			iWebAction("changeTitle",{"_title" : "카드매입 가져오기","_type" : "2"});
		},
		cardSave : function(){
//			iWebAction("showProgress");
			var input={};
			input["BANK_CD"]	=$("#CARD_CD").val();
			input["BANK_NM"]	=$("#CARD_NM").val();
			input["CARD_NO"]	=$("#CARD_NO").val();
			input["WEB_ID"]		=$("#WEB_ID").val();
			input["WEB_PWD"]	=_thisInfm.WEB_PWD_H;
//			input["SCQKEY"]		=$("#_CIPHER_KEY").val();
			iWebAction("showIndicator");
			avatar.common.callJexAjax("card_0005_02_c001",input,_thisPage.cardSaveCallback);
		},
		cardSaveCallback : function(data){
//			iWebAction("hideProgress");
			var CARD_LIST = [];
			CARD_LIST.push({
				  'BANK_CD':'30000'+$("#CARD_CD").val()
				  ,'BANK_NM':$('#CARD_NM').val()
				  ,'CARD_NO':$('#CARD_NO').val()
				  ,'WEB_ID':$("#WEB_ID").val()
				  ,'WEB_PWD':_thisInfm.WEB_PWD_H
		          ,'RESULT_CD':data.RSLT_CD
		          ,'RESULT_MG':data.RSLT_MSG
		    });
			
			var input={};
			input["CARD_LIST"]=encodeURIComponent(JSON.stringify(CARD_LIST));
			avatar.common.pageMove("card_0006_01.act", input);
			iWebAction("hideIndicator");
		}
}
function callbackFunc(backData){
	var pwData = JSON.parse(backData);
	var pwData1 = pwData._pwd;
	_thisInfm["WEB_PWD_H"]=pwData1.encrypt_data;
    $('#WEB_PWD').val(avatar.common.gapReturn(pwData1.length));
	
	// 모든항목 입력 시
    if($("#CARD_NO").val() != "" 
    	&& $("#WEB_ID").val() != ""
    	&& $("#WEB_PWD").val() != ""){
    	$("#a_next").removeClass("off");
    }else{
    	$("#a_next").addClass("off");
    }
}
function fn_back(){
	iWebAction("closePopup");
}
function fn_popCallback(){
	iWebAction("closePopup",{_callback:"fn_popCallback"});
}