/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0004_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 김태훈 (  )
 * @Description    : 더보기-프로필
 * @History        : 20200205091934, 김태훈
 * </pre>
 **/
var modYn=false;	//변경 내역이 있다면 뒤로가기 시 페이지 이동 
$(function(){
	_thisPage.onload();
	//이름
	$("#a_cust_nm").on("click",function(){
		avatar.common.showHide($("div[name=mod_pop].cont_custNm"));
		avatar.common.showHide($("#main"));
		if($("div[name=mod_pop].cont_custNm").css("display")!="none"){
			iWebAction("changeTitle",{"_title" : "이름 변경","_type" : "2"});
		}
	});
	//회사명
	$("#a_bsnn_nm").on("click",function(){
		avatar.common.showHide($("div[name=mod_pop].cont_bsnnNm"));
		avatar.common.showHide($("#main"));
		if($("div[name=mod_pop].const_bsnnNm").css("display")!="none"){
			iWebAction("changeTitle",{"_title" : "회사명 변경","_type" : "2"});
		}
	});
	//질문모아보기 
	$(".m_prp_topBx li:eq(0)").on("click", function(){
		//해당페이지로 이동
		var url = "basic_0013_01.act?MENU_DV=01";
		iWebAction("openPopup",{_url:url});
	});
	//답변 받지 못한 질문
	$(".m_prp_topBx li:eq(1)").on("click", function(){
		//해당페이지로 이동
		var url = "basic_0013_01.act?MENU_DV=02";
		iWebAction("openPopup",{_url:url});
	});
	//서비스탈퇴
	$("#a_trmn").on("click",function(){
		// 서비스탈퇴 안내 화면으로 이동
		var url = "basic_0012_01.act";
		iWebAction("openPopup",{_url:url});
	});
	//패턴
	$("#a_patten").on("click",function(){
		iWebAction("fn_pattern_auth",{_menu_id:"1",_callback:"fn_patternCallback"});
	});
	//로그아웃
	$("#a_logout").on("click",function(){
		fn_setLogOutMadal();
	});
	//변경
	$(".cont_custNm #a_mod").on("click",function(){
		_thisPage.modCustNm();
	});
	//변경
	$(".cont_bsnnNm #a_mod").on("click",function(){
		_thisPage.modBsnnNm();
	});
	//변경
	$(".btn_switch").on("click",function(){
		if($(".btn_switch").hasClass("on")){
			iWebAction("setPatternSetting",{_pattern_yn:"N"});
			$(".btn_switch").removeClass("on")
		} else {
			iWebAction("setPatternSetting",{_pattern_yn:"Y"});
			$(".btn_switch").addClass("on")
		}
	});
	//테스트
	$("#_TEST").on("click", function(){
		var url = "ques_comm_01.act?INTE_INFO={'recog_txt':'memo list','recog_data' : {'Intent':'_NNN02','appInfo' : {}} }";
		iWebAction("openPopup",{_url:url});
	})
});

var _thisPage={
		onload : function(){
			$("#a_clph_no").find("a").text(avatar.common.phoneFomatter($("#a_clph_no").find("a").text()));
			_thisPage.setData();
			iWebAction("changeTitle",{"_title" : "프로필 관리","_type" : "2"});
			iWebAction("getPatternSetting",{_call_back : "fn_getAppStorage"});
		},
		setData : function(){
			var input={};
			input["USE_INTT_ID"]=$("#USE_INTT_ID").val();
			avatar.common.callJexAjax("basic_0004_01_r001",input,_thisPage.setCallback);
		},
		setCallback : function(data){
			if("" == avatar.common.null2void(data.BSNN_NM)){
				$("#a_bsnn_nm .btn_arr").text("회사명을 입력하세요");
			} else{
				$("#a_bsnn_nm .btn_arr").text(avatar.common.null2void(data.BSNN_NM));
				$("#inp_bsnnNm").val(avatar.common.null2void(data.BSNN_NM));
			}
		},
		modCustNm : function(){
			var input={};
			input["CUST_NM"]=$("#inp_custNm").val();
			avatar.common.callJexAjax("basic_0004_01_u001",input,_thisPage.modCustNmCallback);
		},
		modCustNmCallback : function(data){
			if(avatar.common.null2void(data.RSLT_CD)=="9999"){
				alert(data.RSLT_MSG);
				return;
			}
			iWebAction("fn_syncLoginInfo",{"USER_NM" : $("#inp_custNm").val()});
			modYn=true;
			$("#a_cust_nm").find("a").text($("#inp_custNm").val());
			avatar.common.showHide($("div[name=mod_pop].cont_custNm"));
			avatar.common.showHide($("#main"));
		},
		modBsnnNm : function(){
			var input={};
			input["BSNN_NM"]=$("#inp_bsnnNm").val();
			avatar.common.callJexAjax("basic_0004_01_u002",input,_thisPage.modBsnnNmCallback);
		},
		modBsnnNmCallback : function(data){
			if(avatar.common.null2void(data.RSLT_CD)=="9999"){
				alert(data.RSLT_MSG);
				return;
			}
			iWebAction("fn_syncLoginInfo",{"BSNN_NM" : $("#inp_bsnnNm").val()});
			modYn=true;
			$("#a_bsnn_nm").find("a").text($("#inp_bsnnNm").val());
			avatar.common.showHide($("div[name=mod_pop].cont_bsnnNm"));
			avatar.common.showHide($("#main"));
		}
}

function fn_getAppStorage(data){
//	alert(data);
	if(data == "Y"){
		$(".btn_switch").addClass("on");
	} else{
		$(".btn_switch").removeClass("on");
	}
}
function fn_setLogOutMadal(){
	var logOutModalHtml='';
	logOutModalHtml +='<div class="modaloverlay">';
	logOutModalHtml +='	<div class="lytb"><div class="lytb_row"><div class="lytb_td">';
	logOutModalHtml +='	<div class="layer_style1">';
	logOutModalHtml +='		<div class="layer_po">';
	logOutModalHtml +='			<div class="cont">';
	logOutModalHtml +='				<div class="lyp_tit">';
	logOutModalHtml +='					로그아웃하시겠습니까?';
	logOutModalHtml +='				</div>';
	logOutModalHtml +='			</div>';
	logOutModalHtml +='		</div>';
	logOutModalHtml +='		<div class="ly_btn_fix_botm btn_both">';
	logOutModalHtml +='			<a class="btn_pop off" onClick="fn_removeModal()">취소</a>';
	logOutModalHtml +='			<a class="btn_pop" onClick="fn_logOut()">확인</a>';
	logOutModalHtml +='		</div>';
	logOutModalHtml +='	</div>';
	logOutModalHtml +='	</div></div></div>';
	logOutModalHtml +='</div>';
	$('body').append(logOutModalHtml);
}
//모달 닫기
function fn_removeModal(){
	$(".modaloverlay").remove();
}
function fn_logOut(){
	iWebAction("logout");
}
function fn_back(){
	if($("div[name=mod_pop].cont_bsnnNm").css("display") != "none" || $("div[name=mod_pop].cont_custNm").css("display") != "none"){
		$("div[name=mod_pop]").hide();
		avatar.common.showHide($("#main"));
		iWebAction("changeTitle",{"_title" : "프로필 관리","_type" : "2"});
	} else {
		if(modYn){
			iWebAction("closePopup",{_callback:"fn_popCallback"});
		} else {
			iWebAction("closePopup");
		}
	}
}

function fn_popCallback(){
	iWebAction("closePopup");
}

function fn_patternCallback(){
	iWebAction("fn_pattern_auth",{_menu_id:"2"});	
}
