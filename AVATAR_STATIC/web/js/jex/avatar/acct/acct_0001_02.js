/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : acct_0001_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/acct
 * @author         : 김태훈 (  )
 * @Description    : 계좌 인증서 화면
 * @History        : 20200116151746, 김태훈
 * </pre>
 **/
$(function(){
	_thisPage.onload();
	//교체
	$(".cerChange").on("click",function(){
		_thisPage.searchBizList();
	});
	//삭제
	$("#a_del").on("click",function(){
		// 같은 계좌번호로 다른 계좌유형이 존재하는지 확인
		//fn_acctDvSearch();
		// 계좌번호는 한개밖에 등록이 안됨.
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
			iWebAction("changeTitle",{"_title" : "은행데이터 관리","_type" : "2"});
			_thisPage.searchCert();
		},
		searchCert : function(){
			var input = {};
			input["FNNC_UNQ_NO"]=$("#FNNC_UNQ_NO").val();
			avatar.common.callJexAjax("acct_0001_02_r001",input,_thisPage.searchCertCallback);
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
			if(data.CERT_EXPI_STTS == "E"){
				expi_text=avatar.common.date_format2(data.CERT_DT)+"(잔여 "+fn_dateDiff(avatar.common.date_format2(data.CERT_DT))+"일)";
				expi_color="c_red";
				$("#cerEnd_exp").show();
			}
			// 만료됨
			else if(data.CERT_EXPI_STTS == "Y"){
				//expi_text=avatar.common.date_format2(data.CERT_DT)+"(만료되었습니다.)";
				expi_text=avatar.common.date_format2(data.CERT_DT);
				expi_color="c_red";
				$("#cerEnd").show();
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
			certHtml += '	<p class="mgt5"><span class="date '+expi_color+'">만료일</span><span class="'+expi_color+'">'+expi_text+'</span></p>';
			certHtml += '</div>';
			
			$("#div_cert").html(certHtml);
		},
		deleteAcct : function(){
			var input={};
			input["FNNC_UNQ_NO"]	=$("#FNNC_UNQ_NO").val();
			input["FNNC_INFM_NO"]	=$("#FNNC_INFM_NO").val();
			input["BANK_CD"]		=$("#BANK_CD").val();
			input["BANK_GB"]		=$("#BANK_GB").val();
			input["CERT_NM"]		=$("#CERT_NM").val();
			input["ACCT_DV"]		=$("#ACCT_DV").val();
			iWebAction("showIndicator");
			avatar.common.callJexAjax("acct_0001_02_d001",input,_thisPage.deleteAcctCallback);
		},
		deleteAcctCallback : function(data){
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
			input["BANK_CD"]=$("#BANK_CD").val();
			avatar.common.callJexAjax("acct_0001_02_r002",input,_thisPage.searchBizListCallback);
		},
		searchBizListCallback : function(data){
			if(avatar.common.null2void(data.RSLT_CD)=="9999"){
				alert(data.RSLT_MSG);
				return;
			}
			_thisInfo["BIZ_LIST"]=data.BIZ_REC;
			//검색조건 추가
			_thisInfo.BIZ_LIST[0].FNNC_UNQ_NO=$("#FNNC_UNQ_NO").val();
			iWebAction("fn_cert_list",
			{
				"_menu_id" 		: "3"
				,"_callback" 	: "fn_certListCallback"	//웹 액션 후 페이지 어딘지 확인하고..
				,"_data"	:
				{
					"_before_cert_name" : _thisInfo.CERT_NM
					,"_cert_date" 		: _thisInfo.CERT_DT
					,"_biz_list" 		: _thisInfo.BIZ_LIST
				}
			});
		}
}
//웹액션 콜백 (fn_cert_list)
function fn_certListCallback(data){
	//성공시 현재페이지 리로드~
	fn_setSuccessModal();
	_thisPage.searchCert();
}
//날짝계산
function fn_dateDiff(dataStr){
	var today = new Date();  
	var dateArray = dataStr.split(".");  
  
	var dateObj = new Date(dateArray[0], Number(dateArray[1])-1, dateArray[2]);  
	var betweenDay = (dateObj.getTime() - today.getTime())/1000/60/60/24;  
  
	return Math.ceil(betweenDay);
}
// 같은 계좌유형이 존재하는지 확인
function fn_acctDvSearch(){
	var jexAjax = jex.createAjaxUtil("acct_0001_02_r003");
	jexAjax.set("FNNC_UNQ_NO", $("#FNNC_UNQ_NO").val());
	jexAjax.execute(function(data){
		var arr = $.parseJSON(data.ACCT_DV_STR);
		var acct_dv = "";
		
		for (var i = 0; i < arr.length; i++) {
			if(arr[i] == "1") acct_dv +="입출금";
			else if(arr[i] == "2") acct_dv +="예적금";
			else if(arr[i] == "3") acct_dv +="대출금";
			
			if((arr.length-1) != i) acct_dv +=", ";
		}
		
		if(acct_dv != ""){
			var modalHtml='';
			modalHtml +='<div class="modaloverlay">';
			modalHtml +='	<div class="lytb"><div class="lytb_row"><div class="lytb_td">';
			modalHtml +='	<div class="layer_style1">';
			modalHtml +='		<div class="layer_po">';
			modalHtml +='			<div class="cont">';
			modalHtml +='				<p class="lyp_tit">';
			modalHtml +='					('+acct_dv+') 계좌가 존재합니다.<br>';
			modalHtml +='					그래도 계좌를 <strong class="c_blue">삭제</strong>하시겠습니까?<br>';
			modalHtml +='				</p>';
			modalHtml +='			</div>';
			modalHtml +='		</div>';
			modalHtml +='		<div class="ly_btn_fix_botm btn_both">';
			modalHtml +='			<a class="off" onClick="fn_removeModal()">취소</a>';
			modalHtml +='			<a onClick="_thisPage.deleteAcct()">확인</a>';
			modalHtml +='		</div>';
			modalHtml +='	</div>';
			modalHtml +='	</div></div></div>';
			modalHtml +='</div>';
			$('body').append(modalHtml);
		}else{
			fn_setModal();
		}
		
	});
}

//모달 만들기
function fn_setModal(){
	var modalHtml='';
	modalHtml +='<div class="modaloverlay">';
	modalHtml +='	<div class="lytb"><div class="lytb_row"><div class="lytb_td">';
	modalHtml +='	<div class="layer_style1">';
	modalHtml +='		<div class="layer_po">';
	modalHtml +='			<div class="cont">';
	modalHtml +='				<p class="lyp_txt3 c_blue mgb10">';
	modalHtml +=				$("#BANK_NM").val()+' '+$("#FNNC_RPSN_INFM").val();
	modalHtml +='				</p>';
	modalHtml +='				<div class="lyp_txt3 mgb5">';
	modalHtml +='					<span>기존 거래내역이 모두 삭제되며<br>';
	modalHtml +='					계좌 정보가 삭제됩니다.</span>';
	modalHtml +='				</div>';
	modalHtml +='				<p class="lyp_tit">삭제하시겠습니까?</p>';
	modalHtml +='			</div>';
	modalHtml +='		</div>';
	modalHtml +='		<div class="ly_btn_fix_botm btn_both"><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->';
	modalHtml +='			<a class="off" onClick="fn_removeModal()">취소</a>';
	modalHtml +='			<a onClick="_thisPage.deleteAcct()">확인</a>';
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
function fn_setErrModal2(){
	var modalHtml='';
	modalHtml +='<div class="modaloverlay">';
	modalHtml +='	<div class="lytb"><div class="lytb_row"><div class="lytb_td">';
	modalHtml +='	<!-- layerpopup -->';
	modalHtml +='	<div class="layer_style1">';
	modalHtml +='		<div class="layer_po">';
	modalHtml +='			<div class="cont">';
	modalHtml +='				<p class="lyp_tit mgb20" style="margin:0 0 7px;">검증이 실패하였습니다.</p>';
	modalHtml +='				<div class="lyp_stxt">다시 시도하시기 바랍니다.</div>';
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
function fn_setSuccessModal(){
	var modalHtml='';
	modalHtml +='<div class="modaloverlay">';
	modalHtml +='	<div class="lytb"><div class="lytb_row"><div class="lytb_td">';
	modalHtml +='	<!-- layerpopup -->';
	modalHtml +='	<div class="layer_style1">';
	modalHtml +='		<div class="layer_po">';
	modalHtml +='			<div class="cont">';
	modalHtml +='				<p class="lyp_tit mgb5">';
	modalHtml +='					검증이 완료되었습니다.<br>';
	modalHtml +='					공동인증서 교체가 완료되었습니다.';
	modalHtml +='				</p>';
	modalHtml +='				<div class="lyp_stxt">';
	modalHtml +='					이후에는 교체된 인증서로 거래내역을 가져옵니다.';
	modalHtml +='				</div>';
	modalHtml +='			</div>';
	modalHtml +='		</div>';
	modalHtml +='		<div class="ly_btn_fix_botm">';
	modalHtml +='			<a onClick="fn_removeModal()">확인</a>';
	modalHtml +='		</div>';
	modalHtml +='	</div>';
	modalHtml +='	<!-- //layerpopup -->';
	modalHtml +='	</div></div></div>';
	modalHtml +='</div>';
	$('body').append(modalHtml);
}
//모달 닫기
function fn_removeModal(){
	$(".modaloverlay").remove();
}
//백버튼
function fn_back(){
	location.href="/acct_0001_01.act?BANK_CD="+$("#BANK_CD").val()+"&BANK_NM="+$("#BANK_NM").val();
}