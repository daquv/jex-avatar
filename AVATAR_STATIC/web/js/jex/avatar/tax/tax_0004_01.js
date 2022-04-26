/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : tax_0004_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/tax
 * @author         : 박지은 (  )
 * @Description    : 홈택스 증빙 화면
 * @History        : 20210521152255, 박지은
 * </pre>
 **/
$(function(){
	_thisPage.onload();
	
	// 세금계산서∙현금영수증 탭선택
	$(".cols60").on("click",function(){
		$(".cols60").addClass("on");
		$(".cols40").removeClass("on");
		$("#etaxcash_tab").show();
		$("#paytax_tab").hide();
	});
	
	// 부가가치세∙종합소득세 탭선택
	$(".cols40").on("click",function(){
		$(".cols40").addClass("on");
		$(".cols60").removeClass("on");
		$("#paytax_tab").show();
		$("#etaxcash_tab").hide();
	});
	
	// 세금계산서∙현금영수증 등록
	$("#etaxcash_reg_btn").on("click",function(){
		iWebAction("fn_cert_list",{
			"_menu_id":"2",
			"_title":"국세청 홈택스",
			"_callback":"callbackFunc"
		});
	});
	
	// 부가가치세∙종합소득세 등록
	$("#paytax_reg_btn").on("click",function(){
		iWebAction("fn_cert_list",{
			"_menu_id":"2",
			"_title":"국세청 홈택스",
			"_callback":"callbackFuncPayTax"
		});
	});
	
	// 세금계산서∙현금영수증 삭제
	$("#etaxcash_del_btn").on("click",function(){
		fn_setModal();
	});
	
	// 부가가치세∙종합소득세 삭제
	$("#paytax_del_btn").on("click",function(){
		fn_setModal();
	});
	
	// 확인
	$("#etaxcash_confirm_btn, #paytax_confirm_btn").on("click",function(){
		fn_back();
	});
	
	// 세금계산서∙현금영수증 인증서 교체
	$("#etaxcash_change").on("click",function(){
		_thisPage.searchBizList("etaxcash");
	});
	
	// 부가가치세∙종합소득세 인증서 교체
	$("#paytax_change").on("click",function(){
		_thisPage.searchBizList("paytax");
	});
	
});

var _thisInfo = {};		// 전자세금계산서/현금영수증 정보
var _thisTaxInfo = {};	// 부가가치세/종합소득세 정보
var _thisPage = {
		onload : function (){
			iWebAction("changeTitle",{"_title" : "국세청 홈택스","_type" : "2"});		
			_thisPage.searchCert();
			_thisPage.searchTaxCert();
			
			if($("#TAX_GB").val() == "etaxcash"){
				$(".cols60").addClass("on");
				$("#etaxcash_tab").show();
			}else{
				$(".cols40").addClass("on");
				$("#paytax_tab").show();
			}
		},
		searchCert : function(){
			// 전자세금계산서/현금영수증 인증서 정보
			var input = {};
			input["EVDC_DIV_CD1"]	="20";
			input["EVDC_DIV_CD2"]	="21";
			avatar.common.callJexAjax("tax_0002_01_r001",input,_thisPage.searchCertCallback);
		},
		searchTaxCert : function(){
			// 부가가치세/종합소득세 인증서 정보
			var input = {};
			input["EVDC_DIV_CD"]	="22";
			avatar.common.callJexAjax("tax_0002_01_r002",input,_thisPage.searchTaxCertCallback);
		},
		searchCertCallback : function(data){
			if(avatar.common.null2void(data.RSLT_CD)=="9999"){
				alert(data.RSLT_MSG);
				return;
			}
			
			$("#etaxcash_none").hide();
			$("#etaxcash_info").hide();
			
			// 등록된 전자세금계산서/ 현금영수증이 없을 경우
			if(avatar.common.null2void(data.CERT_NM) == ""){
				$("#etaxcash_none").show();
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
			var expi_text=expi_text=avatar.common.date_format2(data.CERT_DT);
			var expi_color='';
			// 만료예정
			if(data.CERT_DT_STTS == "E"){
				$("#etaxcash_end").addClass("cerEnd");
				$("#etaxcash_end").text("만료예정");
				$("#etaxcash_end").show();
				expi_color="c_red";
			}
			// 만료됨
			else if(data.CERT_DT_STTS == "Y"){
				$("#etaxcash_end").addClass("cerEnd");
				$("#etaxcash_end").text("인증서만료");
				$("#etaxcash_end").show();
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
			certHtml += '	<p class="mgt5"><span class="date '+expi_color+'">만료일</span><span class="'+expi_color+'">'+expi_text+'</span></p>';
			certHtml += '</div>';
			
			$("#etaxcash_cert").html(certHtml);
			$("#etaxcash_info").show();
		},
		searchTaxCertCallback : function(data){
			if(avatar.common.null2void(data.RSLT_CD)=="9999"){
				alert(data.RSLT_MSG);
				return;
			}

			$("#paytax_none").hide();
			$("#paytax_info").hide();
			
			// 부가가치세/종합소득세가 없을 경우
			if(avatar.common.null2void(data.CERT_NM) == ""){
				$("#paytax_none").show();
				return;
			}
			
			_thisTaxInfo.CERT_NM=data.CERT_NM;
			_thisTaxInfo.CERT_DT=data.CERT_DT;
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
			var expi_text=expi_text=avatar.common.date_format2(data.CERT_DT);
			var expi_color='';
			// 만료예정
			if(data.CERT_DT_STTS == "E"){
				$("#paytax_end").addClass("cerEnd");
				$("#paytax_end").text("만료예정");
				$("#paytax_end").show();
				expi_color="c_red";
			}
			// 만료됨
			else if(data.CERT_DT_STTS == "Y"){
				$("#paytax_end").addClass("cerEnd");
				$("#paytax_end").text("인증서만료");
				$("#paytax_end").show();
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
			certHtml += '	<p class="mgt5"><span class="date '+expi_color+'">만료일</span><span class="'+expi_color+'">'+expi_text+'</span></p>';
			certHtml += '</div>';
			
			$("#paytax_cert").html(certHtml);
			$("#paytax_info").show();
		},
		deleteTax : function(){
			var tax_gb = "paytax";
			if($(".cols60").hasClass("on")){
				tax_gb = "etaxcash"
			}
			if(tax_gb != "etaxcash"){
				// 부가가치세/종합소득세 삭제
				var input={};
				input["CERT_NAME"]		=_thisTaxInfo.CERT_NM;
				input["USE_YN"]			="N";
				input["EVDC_DIV_CD"]	="22";
				iWebAction("showIndicator");
				avatar.common.callJexAjax("tax_0002_01_d002",input,_thisPage.deletePayTaxCallback);
			}else{
				// 전자세금계산서/현금영수증 삭제
				var input={};
				input["CERT_NAME"]		=_thisInfo.CERT_NM;
				input["USE_YN"]			="N";
				input["EVDC_DIV_CD1"]	="20";
				input["EVDC_DIV_CD2"]	="21";
				iWebAction("showIndicator");
				avatar.common.callJexAjax("tax_0002_01_d001",input,_thisPage.deleteTaxCallback);
			}
			
		},
		deleteTaxCallback : function(data){
			if(avatar.common.null2void(data.RSLT_CD)=="9999"){
				alert(data.RSLT_MSG);
				return;
			}
			fn_removeModal();
			if(data.RSLT_CD == "00000000"){
				$('#etaxcash_toast').css('display', 'block');
				
				setTimeout(function(){
					// 삭제 처리 후 등록화면이동
					$("#etaxcash_toast").css('display', 'none');
					$("#etaxcash_info").hide();
					$("#etaxcash_none").show();
				}, 2000);
				
			}else{
				fn_setErrModal();
			}
			iWebAction("hideIndicator");
		},
		deletePayTaxCallback : function(data){
			if(avatar.common.null2void(data.RSLT_CD)=="9999"){
				alert(data.RSLT_MSG);
				return;
			}
			fn_removeModal();
			if(data.RSLT_CD == "00000000"){
				$('#paytax_toast').css('display', 'block');
				
				setTimeout(function(){
					// 삭제 처리 후 등록화면이동
					$("#paytax_toast").css('display', 'none');
					$("#paytax_info").hide();
					$("#paytax_none").show();
				}, 2000);
				
			}else{
				fn_setErrModal();
			}
			iWebAction("hideIndicator");
		},
		searchBizList : function(tax_gb){
			var input = {};
			input["BANK_CD"]="HOMETAX";
			if(tax_gb != "etaxcash"){
				input["CERT_NM"]=_thisTaxInfo.CERT_NM;
				avatar.common.callJexAjax("acct_0001_02_r002",input,_thisPage.searchTaxBizListCallback);
			}else{
				input["CERT_NM"]=_thisInfo.CERT_NM;
				avatar.common.callJexAjax("acct_0001_02_r002",input,_thisPage.searchBizListCallback);
			}
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
					,"_biz_list" 		: _thisInfo.BIZ_LIST		//엑션 파라미터 확인하고..
				}
			});
		},
		searchTaxBizListCallback : function(data){
			if(avatar.common.null2void(data.RSLT_CD)=="9999"){
				alert(data.RSLT_MSG);
				return;
			}
			_thisTaxInfo["BIZ_LIST"]=data.BIZ_REC;
			iWebAction("fn_cert_list",
			{
				"_menu_id" 		: "3"
				,"_callback" 	: "fn_certListTaxCallback"	//웹 액션 후 페이지 어딘지 확인하고..
				,"_data"	:
				{
					"_before_cert_name" : _thisTaxInfo.CERT_NM
					,"_cert_date" 		: _thisTaxInfo.CERT_DT
					,"_biz_list" 		: _thisTaxInfo.BIZ_LIST		//엑션 파라미터 확인하고..
				}
			});
		}
}

// 인증서 만료여부
function fn_certExp(){
	var jexAjax = jex.createAjaxUtil("ques_comm_01_r006"); // PT_ACTION
	jexAjax.set("MENU_DV", "TAX");
	jexAjax.execute(function(data) {
		if(data.CERT_EXP_DT_YN == "Y"){
			$(".cerEnd").show();
		} else $(".cerEnd").hide();
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
	modalHtml +='				<p class="lyp_txt3" style="margin-top:0;">';
	modalHtml +='				홈택스자료 가져오기 정보를 삭제하면<br>';
	modalHtml +='				홈택스데이터 정보를 조회할 수 없습니다.';
	modalHtml +='				</p>';
	modalHtml +='				<div class="lyp_tit" style="margin-top:17px;">삭제하시겠습니까?</div>';
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

//백버튼
function fn_back(){
	iWebAction("closePopup", {_callback:"fn_popCallback"});
}

//인증서 수정 후 페이지 이동
function fn_certListCallback(data){
	//var url = "tax_0001_01.act?RSLT_CD=00000000&TAX_GB=etaxcash";
	//location.href=url;
	location.href = "tax_0004_01.act?TAX_GB="+$("#TAX_GB").val();
}

//인증서 수정 후 페이지 이동
function fn_certListTaxCallback(data){
	//var url = "tax_0001_01.act?RSLT_CD=00000000&TAX_GB=paytax";
	//location.href=url;
	location.href = "tax_0004_01.act?TAX_GB="+$("#TAX_GB").val();
}

// 전자세금계산서∙현금영수증 인증서 호출 후 콜백
function callbackFunc(backData){
	var key 	 = backData.substring(0, 10);
	var sec_flag = backData.substring(10, 11);
	var data 	 = backData.substring(11);
	var input = {};
	input["KEY"]=key;
	input["SEC_FLAG"]=sec_flag;
	input["DATA"]=data;
	iWebAction("showIndicator");
	avatar.common.callJexAjax("tax_0001_01_r001",input,taxCallback);
}

// 부가가치세∙종합소득세 인증서 호출 후 콜백
function callbackFuncPayTax(backData){
	var key 	 = backData.substring(0, 10);
	var sec_flag = backData.substring(10, 11);
	var data 	 = backData.substring(11);
	var input = {};
	input["KEY"]=key;
	input["SEC_FLAG"]=sec_flag;
	input["DATA"]=data;
	iWebAction("showIndicator");
	avatar.common.callJexAjax("tax_0001_01_r001",input,payTaxCallback);
}

function taxCallback(data){
	if(avatar.common.null2void(data.RSLT_CD)=="9999"){
		alert(data.RSLT_MSG);
		return;
	}
	var cert_name = avatar.common.null2void(data.CERT_NAME);			// 인증서 이름
	var cert_pwd = avatar.common.null2void(data.CERT_PWD);				// 인증서 비밀번호
	var cert_org = avatar.common.null2void(data.CERT_ORG);				// 인증서 발급기관
	var cert_date = avatar.common.null2void(data.CERT_DATE);			// 인증서 만료일자
	var reg_type = avatar.common.null2void(data.REG_TYPE);				// 인증서 유형(0:휴대폰인증서, 1:등록인증서)
	var cert_folder = avatar.common.null2void(data.CERT_FOLDER);		// 인증서 경로명
	var cert_data = avatar.common.null2void(data.CERT_DATA);			// 인증서데이터
	var cert_gb = avatar.common.null2void(data.CERT_GB);				// 인증서 구분
	var cert_usag_div = avatar.common.null2void(data.CERT_USAG_DIV);	// 인증서용도 구분 (0:개인용, 1:기업용)
	var cert_usag_div_nm = "";											// 인증서용도 구분명
	var cert_issu_dt = avatar.common.null2void(data.CERT_ISSU_DT); 		// 인증서 발행 일자
	
	if(reg_type == "0"){
		reg_type = "1";		// 인증서 등록(쿠콘 API호출 시)
	}else if(reg_type == "1"){
		reg_type = "0";		// 인증서 미등록(쿠콘 API호출 시)
	}
	var input={};
	input["BEFORE_CERT_NAME"]="";
	input["CERT_NAME"]=cert_name;
	input["CERT_ORG"]=cert_org;
	input["CERT_DATE"]=cert_date;
	input["CERT_PWD"]=cert_pwd;
	input["CERT_FOLDER"]=cert_folder;
	input["CERT_DATA"]=cert_data;
	input["REG_TYPE"]=reg_type;
	input["STTS"]="";
	input["CERT_DSNC"]=cert_gb;
	input["CERT_USAG_DIV"]=cert_usag_div;
	input["CERT_ISSU_DT"]=cert_issu_dt;
	input["USE_YN"]="Y";
	input["OTHER_STTS"]="";
	input["EVDC_DIV_CD1"]="20"; 			// 20:전자(세금)계산서
	input["EVDC_DIV_CD2"]="21"; 			// 21:현금영수증
	fn_evdcReg(input);
}

function payTaxCallback(data){
	if(avatar.common.null2void(data.RSLT_CD)=="9999"){
		alert(data.RSLT_MSG);
		return;
	}
	var cert_name = avatar.common.null2void(data.CERT_NAME);			// 인증서 이름
	var cert_pwd = avatar.common.null2void(data.CERT_PWD);				// 인증서 비밀번호
	var cert_org = avatar.common.null2void(data.CERT_ORG);				// 인증서 발급기관
	var cert_date = avatar.common.null2void(data.CERT_DATE);			// 인증서 만료일자
	var reg_type = avatar.common.null2void(data.REG_TYPE);				// 인증서 유형(0:휴대폰인증서, 1:등록인증서)
	var cert_folder = avatar.common.null2void(data.CERT_FOLDER);		// 인증서 경로명
	var cert_data = avatar.common.null2void(data.CERT_DATA);			// 인증서데이터
	var cert_gb = avatar.common.null2void(data.CERT_GB);				// 인증서 구분
	var cert_usag_div = avatar.common.null2void(data.CERT_USAG_DIV);	// 인증서용도 구분 (0:개인용, 1:기업용)
	var cert_usag_div_nm = "";											// 인증서용도 구분명
	var cert_issu_dt = avatar.common.null2void(data.CERT_ISSU_DT); 		// 인증서 발행 일자
	// 인증서 등록(쿠콘 API호출 시)
	if(reg_type == "0"){
		reg_type = "1";	
	}else if(reg_type == "1"){
		reg_type = "0";	// 인증서 미등록(쿠콘 API호출 시)
	}
	var input={};
	input["BEFORE_CERT_NAME"]="";
	input["CERT_NAME"]=cert_name;
	input["CERT_ORG"]=cert_org;
	input["CERT_DATE"]=cert_date;
	input["CERT_PWD"]=cert_pwd;
	input["CERT_FOLDER"]=cert_folder;
	input["CERT_DATA"]=cert_data;
	input["REG_TYPE"]=reg_type;
	input["STTS"]="";
	input["CERT_DSNC"]=cert_gb;
	input["CERT_USAG_DIV"]=cert_usag_div;
	input["CERT_ISSU_DT"]=cert_issu_dt;
	input["USE_YN"]="Y";
	input["EVDC_DIV_CD"]="22"; 			// 22:부가가치세/종합소득세
	fn_evdcPayTaxReg(input);
}

// 홈택스  전자세금계산서/현금영수증 등록
function fn_evdcReg(data){
	avatar.common.callJexAjax("tax_0001_01_u001",data,fn_evdcRegCallback);
}

// 홈택스 부가가치세/종합소득세 등록
function fn_evdcPayTaxReg(data){
	avatar.common.callJexAjax("tax_0001_01_u002",data,fn_evdcTaxRegCallback);
}

function fn_evdcRegCallback(data){
	iWebAction("hideIndicator");
	var url = "tax_0001_01.act";
		url+="?RSLT_CD="+avatar.common.null2void(data.RSLT_CD);
		url+="&RSLT_MSG="+avatar.common.null2void(data.RSLT_MSG);
		url+="&BSNN_NM="+avatar.common.null2void(data.BSNN_NM);
		url+="&RPPR_NM="+avatar.common.null2void(data.RPPR_NM);
		url+="&TAX_GB=etaxcash";
	if(data.RSLT_CD == "00000000"){// 성공
		url+="&REG_YN=Y";
		url+="&FST_REG_YN="+avatar.common.null2void(data.FST_REG_YN);
	}else{
		url+="&REG_YN=N";
		url+="&FST_REG_YN=N"
	}
	location.href = url;
}

function fn_evdcTaxRegCallback(data){
	iWebAction("hideIndicator");
	var url = "tax_0001_01.act";
		url+="?RSLT_CD="+avatar.common.null2void(data.RSLT_CD);
		url+="&RSLT_MSG="+avatar.common.null2void(data.RSLT_MSG);
		url+="&BSNN_NM="+avatar.common.null2void(data.BSNN_NM);
		url+="&RPPR_NM="+avatar.common.null2void(data.RPPR_NM);
		url+="&TAX_GB=paytax";
	if(data.RSLT_CD == "00000000"){// 성공
		url+="&REG_YN=Y";
		url+="&FST_REG_YN="+avatar.common.null2void(data.FST_REG_YN);
	}else{
		url+="&REG_YN=N";
		url+="&FST_REG_YN=N"
	}
	location.href = url;
}