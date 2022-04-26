/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : tax_0002_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/tax
 * @author         : 김태훈 (  )
 * @Description    : 홈텍스 공인인증서 조회화면
 * @History        : 20200131141200, 김태훈
 * </pre>
 **/
$(function(){
	_thisPage.onload();
	//교체
	$("#a_change").on("click",function(){
		_thisPage.searchBizList();
	});
	//삭제
	$("#a_del").on("click",function(){
		fn_setModal();
	});
	//확인
	$("#a_enter").on("click",function(){
		//우선 백버튼과 같은 동작
		fn_back();	//임시 
	});
	
});
var _thisInfo = {};
var _thisPage = {
		onload : function (){
			iWebAction("changeTitle",{"_title" : "홈택스 관리","_type" : "2"});		
			_thisPage.searchCert();
		},
		searchCert : function(){
			var input = {};
			input["EVDC_DIV_CD1"]	="20";
			input["EVDC_DIV_CD2"]	="21";
			//input["EVDC_DIV_CD3"]	="22";
			avatar.common.callJexAjax("tax_0002_01_r001",input,_thisPage.searchCertCallback);
		},
		searchCertCallback : function(data){
			if(avatar.common.null2void(data.RSLT_CD)=="9999"){
				alert(data.RSLT_MSG);
				return;
			}
			_thisInfo.CERT_NM=data.CERT_NM;
			_thisInfo.CERT_DT=data.CERT_DT;
			//인증서 구분
			var cert_dsnc_org = "";
			if(avatar.common.null2void(data.CERT_USAG_DIV) != ""){
				if(data.CERT_USAG_DIV == "0"){
					cert_dsnc_org = "개인";
				}else if(data.CERT_USAG_DIV == "1"){
					cert_dsnc_org = "기업";
				}else{
					cert_dsnc_org = "";
				}
			}
			if(avatar.common.null2void(data.CERT_DSNC_NM) != ""){
				if(cert_dsnc_org != ""){
					cert_dsnc_org += "/";
				}
				cert_dsnc_org += data.CERT_DSNC_NM;
			}
			//날짜 계산
			var expi_text='';
			var expi_color='';
			// 만료예정
			if(data.CERT_DT_STTS == "E"){
				expi_text=avatar.common.date_format2(data.CERT_DT)+"(잔여 "+fn_dateDiff(avatar.common.date_format2(data.CERT_DT))+"일)";
				expi_color="c_red";
				
			}
			// 만료됨
			else if(data.CERT_DT_STTS == "Y"){
				//expi_text=avatar.common.date_format2(data.CERT_DT)+"(만료되었습니다.)";
				expi_text=avatar.common.date_format2(data.CERT_DT);
				expi_color="c_red";
			}
			// 정상
			else{
				expi_text=avatar.common.date_format2(data.CERT_DT);
			}
			
			//인증서 정보
			var certHtml='';
			certHtml += '<div class="tit">';
			certHtml += '	<em>'+data.CERT_NM.substring(0,data.CERT_NM.lastIndexOf(")")+1)+'</em>';
			certHtml += '	<span class="no">'+data.CERT_NM.substring(data.CERT_NM.lastIndexOf(")")+1)+'</span>';
			certHtml += '</div>';
			certHtml += '<div class="txt">';
			certHtml += '	<p>'+cert_dsnc_org+'</p>';
			certHtml += '	<p><span class="date">만료일</span><span class="'+expi_color+'">'+expi_text+'</span></p>';
			certHtml += '</div>';
			
			$("#div_cert").html(certHtml);
		},
		deleteTax : function(){
			var input={};
			input["CERT_NAME"]		=_thisInfo.CERT_NM;
			input["USE_YN"]			="N";
			input["EVDC_DIV_CD1"]	="20";
			input["EVDC_DIV_CD2"]	="21";
			//input["EVDC_DIV_CD3"]	="22";
			iWebAction("showIndicator");
			avatar.common.callJexAjax("tax_0002_01_d001",input,_thisPage.deleteTaxCallback);
		},
		deleteTaxCallback : function(data){
			if(avatar.common.null2void(data.RSLT_CD)=="9999"){
				alert(data.RSLT_MSG);
				return;
			}
			fn_removeModal();
			if(data.RSLT_CD == "00000000"){
				$('.toast_pop').css('display', 'block');
				$('a').off("click");
				setTimeout(function(){
					//삭제 처리 후 데이터 가져오기 화면으로 이동
					iWebAction("closePopup",{_callback:"fn_popCallback"});
				}, 2000);
				
			}else{
				fn_setErrModal();
			}
			iWebAction("hideIndicator");
		},
		searchBizList : function(){
			var input = {};
			input["CERT_NM"]=_thisInfo.CERT_NM;
			input["BANK_CD"]="HOMETAX";
			avatar.common.callJexAjax("acct_0001_02_r002",input,_thisPage.searchBizListCallback);
		},
		searchBizListCallback : function(data){
			if(avatar.common.null2void(data.RSLT_CD)=="9999"){
				alert(data.RSLT_MSG);
				return;
			}
			_thisInfo["BIZ_LIST"]=data.BIZ_REC;
			iWebAction("fn_cert_list",
			{
				"_menu_id" 		: "3"
				,"_callback" 	: "fn_certListCallback"	//웹 액션 후 페이지 어딘지 확인하고..
				,"_data"	:
				{
					"_before_cert_name" : _thisInfo.CERT_NM
					,"_cert_date" 		: _thisInfo.CERT_DT
					//,"_biz_list" 		: JSON.stringify(_thisInfo.BIZ_LIST)		//엑션 파라미터 확인하고..
					,"_biz_list" 		: _thisInfo.BIZ_LIST		//엑션 파라미터 확인하고..
				}
			});
		}
}
function fn_certExp (){
	var jexAjax = jex.createAjaxUtil("ques_comm_01_r006"); // PT_ACTION
	jexAjax.set("MENU_DV", "TAX");
	jexAjax.execute(function(data) {
		if(data.CERT_EXP_DT_YN == "Y"){
			$(".cerEnd").show();
		} else $(".cerEnd").hide();
	});
}
//날짝계산
function fn_dateDiff(dataStr){
	var today = new Date();  
	var dateArray = dataStr.split(".");  
  
	var dateObj = new Date(dateArray[0], Number(dateArray[1])-1, dateArray[2]);  
	var betweenDay = (dateObj.getTime() - today.getTime())/1000/60/60/24;  
  
	return Math.ceil(betweenDay);
}
//모달 만들기
function fn_setModal(){
	var modalHtml='';
	modalHtml +='<div class="modaloverlay">';
	modalHtml +='	<div class="lytb"><div class="lytb_row"><div class="lytb_td">';
	modalHtml +='	<div class="layer_style1">';
	modalHtml +='		<div class="layer_po">';
	modalHtml +='			<div class="cont">';
	modalHtml +='				<p class="lyp_txt3 mgb5">';
	modalHtml +='				홈택스자료 가져오기 정보를 삭제하면<br>';
	modalHtml +='				홈택스데이터 정보를 조회할 수 없습니다.';
	modalHtml +='				</p>';
	modalHtml +='				<div class="lyp_tit">삭제하시겠습니까?</div>';
	modalHtml +='			</div>';
	modalHtml +='		</div>';
	modalHtml +='		<div class="ly_btn_fix_botm btn_both"><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->';
	modalHtml +='			<a class="off" onClick="fn_removeModal()">취소</a>';
	modalHtml +='			<a onClick="_thisPage.deleteTax()">확인</a>';
	modalHtml +='		</div>';
	modalHtml +='	</div>';
	modalHtml +='	</div></div></div>';
	modalHtml +='</div>';
	$('body').append(modalHtml);
}
function fn_setErrModal(){
	var modalHtml='';
	modalHtml +='<div class="modaloverlay">';
	modalHtml +='	<div class="lytb"><div class="lytb_row"><div class="lytb_td">';
	modalHtml +='	<!-- layerpopup -->';
	modalHtml +='	<div class="layer_style1">';
	modalHtml +='		<div class="layer_po">';
	modalHtml +='			<div class="cont">';
	modalHtml +='				<p class="lyp_tit">';
	modalHtml +='					삭제 실패 되었습니다.';
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
//백버튼?
function fn_back(){
	iWebAction("closePopup", {_callback:"fn_popCallback"});
}
//인증서 수정 후 페이지 이동
function fn_certListCallback(data){
	var url = "tax_0001_01.act?RSLT_CD=00000000";
	location.href=url;
}