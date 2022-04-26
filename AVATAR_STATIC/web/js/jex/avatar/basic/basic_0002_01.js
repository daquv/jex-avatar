/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0002_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 김태훈 (  )
 * @Description    : 데이터가져오기화면
 * @History        : 20200129103618, 김태훈
 * </pre>
 **/
$(function(){
	if($("#MENU_DV").val() == 'cert'){
		$(".ico_d03").addClass("prem").off("click");
		$(".ico_d04").addClass("prem").off("click");
		$(".ico_d05").addClass("prem").off("click");
	}
	if($("#DATA_DIV").val()){
		if($("#DATA_DIV").val() == "BANK")	realTimeFnshYn("1", $(this).parent());
		if($("#DATA_DIV").val() == "CARD")	{var url = "card_0005_01.act";iWebAction("openPopup",{_url:url});}
		if($("#DATA_DIV").val() == "TAX")	realTimeFnshYn("3", $(this).parent());
		if($("#DATA_DIV").val() == "SALE")	realTimeFnshYn("4", $(this).parent());
		if($("#DATA_DIV").val() == "SERP")	{var url = "basic_0009_01.act?PAGE_DV=SERP";iWebAction("openPopup",{_url:url});}
		if($("#DATA_DIV").val() == "ZEROPAY")	{var url = "basic_0014_01.act";iWebAction("openPopup",{_url:url});}
		if($("#DATA_DIV").val() == "SNSS")	{var url = "snss_0001_01.act";iWebAction("openPopup",{_url:url});}
	}
	_thisPage.onload();
	//데이터 가져오기 클릭
	$("dl[name=a_data]").on("click",function(){
		var ctgr = $(this).parent().attr("ctgr");
		if(!$(this).hasClass("prem")){
			if(ctgr=="acct"){
				realTimeFnshYn("1", $(this).parent());
			} else if(ctgr=="tax"){
				realTimeFnshYn("3", $(this).parent());
			} else if(ctgr=="sale"){
				realTimeFnshYn("4", $(this).parent());
			} else if(ctgr=="card"){
				var url = "card_0005_01.act";
				iWebAction("openPopup",{_url:url});
			} else if(ctgr=="call"){
				iWebAction("getContact");
			} else if(ctgr=="cert"){
				iWebAction("fn_cert_manage");
			} else if(ctgr=="snss"){
				var url = "snss_0001_01.act";
				iWebAction("openPopup",{_url:url});
			} else if(ctgr=="zeropay"){
				// 제로페이 연결 안되어 있는 경우
				var url = "basic_0014_01.act";
				var exist = $(".ico_d07").attr("data-exist_dv");
				
				// 제로페이 연결되어 있는 경우 가맹점 목록 
				if(exist == 'true'){
					url = "basic_0015_01.act";
				}
				iWebAction("openPopup",{_url:url});
			} else if(ctgr=="serp"){
				//var url = "basic_0005_01.act";
				var url = "basic_0009_01.act?PAGE_DV=SERP";
				iWebAction("openPopup",{_url:url});
			} else if(ctgr=="allConn"){
				iWebAction("fn_cert_list",{"_menu_id":"1",_title:"인증서로 한 번에 연결하기","_call_back": "callbackFunc"});
			}
		}

	});
	// 은행 데이터 가져오기 checkbox 클릭
	$("input:checkbox[name=acct_chk]").on("click",function(e){
		e.stopPropagation();
		if($("div[ctgr=acct]").attr("data-exist_dv") != 'true'){
			alert("데이터를 연결해주세요.");
			return false;
		}
		var acct_chk_id = $(this).attr("id");
		$("input:checkbox[name=acct_chk]").removeClass("on");
		$("input:checkbox[name=acct_chk]").attr("checked", false);
		$(this).addClass("on");
		
		$("#pop_tit").text("은행 데이터 수집");
		$("#evdc_gb").val("01");
		$("#use_pric").val($("#acct_price").val());
		$("#price").text(formatter.number($("#use_pric").val()));
		if(acct_chk_id == "acct_chk_n"){
			$('input:checkbox[id="price_n"]').attr("checked", true);
			$('input:checkbox[id="price_y"]').attr("checked", false);
			$("#pay_yn").val("N");
		}else{
			$('input:checkbox[id="price_y"]').attr("checked", true);
			$('input:checkbox[id="price_n"]').attr("checked", false);
			$("#pay_yn").val("Y");
		}
		
		$("#modaloverlay2").show();
	});
	
	// 홈텍스 데이터 가져오기 checkbox 클릭
	$("input:checkbox[name=tax_chk]").on("click",function(e){
		e.stopPropagation();
		if($("div[ctgr=tax]").attr("data-exist_dv") != 'true'){
			alert("데이터를 연결해주세요.");
			return false;
		}
		
		var tax_chk_id = $(this).attr("id");
		$("input:checkbox[name=tax_chk]").removeClass("on");
		$("input:checkbox[name=tax_chk]").attr("checked", false);
		$(this).addClass("on");
		
		$("#pop_tit").text("홈택스 데이터 수집");
		$("#evdc_gb").val("02");
		$("#use_pric").val($("#tax_price").val());
		$("#price").text(formatter.number($("#use_pric").val()));
		if(tax_chk_id == "tax_chk_n"){
			$('input:checkbox[id="price_n"]').attr("checked", true);
			$('input:checkbox[id="price_y"]').attr("checked", false);
			$("#pay_yn").val("N");
		}else{
			$('input:checkbox[id="price_y"]').attr("checked", true);
			$('input:checkbox[id="price_n"]').attr("checked", false);
			$("#pay_yn").val("Y");
		}
		
		$("#modaloverlay2").show();
	});
	
	// 카드사 데이터 가져오기 checkbox 클릭
	$("input:checkbox[name=card_chk]").on("click",function(e){
		e.stopPropagation();
		if($("div[ctgr=card]").attr("data-exist_dv") != 'true'){
			alert("데이터를 연결해주세요.");
			return false;
		}
		var card_chk_id = $(this).attr("id");
		$("input:checkbox[name=card_chk]").removeClass("on");
		$("input:checkbox[name=card_chk]").attr("checked", false);
		$(this).addClass("on");
		
		$("#pop_tit").text("카드사 데이터 수집");
		$("#evdc_gb").val("03");
		$("#use_pric").val($("#card_price").val());
		$("#price").text(formatter.number($("#use_pric").val()));
		if(card_chk_id == "card_chk_n"){
			$('input:checkbox[id="price_n"]').attr("checked", true);
			$('input:checkbox[id="price_y"]').attr("checked", false);
			$("#pay_yn").val("N");
		}else{
			$('input:checkbox[id="price_y"]').attr("checked", true);
			$('input:checkbox[id="price_n"]').attr("checked", false);
			$("#pay_yn").val("Y");
		}
		$("#modaloverlay2").show();
	});
	
	// 온라인매출 데이터 가져오기 checkbox 클릭
	$("input:checkbox[name=snss_chk]").on("click",function(e){
		e.stopPropagation();
		if($("div[ctgr=snss]").attr("data-exist_dv") != 'true'){
			alert("데이터를 연결해주세요.");
			return false;
		}
		var snss_chk_id = $(this).attr("id");
		$("input:checkbox[name=snss_chk]").removeClass("on");
		$("input:checkbox[name=snss_chk]").attr("checked", false);
		$(this).addClass("on");
		
		$("#pop_tit").text("온라인매출 데이터 수집");
		$("#evdc_gb").val("11");
		$("#use_pric").val($("#snss_price").val());
		$("#price").text(formatter.number($("#use_pric").val()));
		if(snss_chk_id == "snss_chk_n"){
			$('input:checkbox[id="price_n"]').attr("checked", true);
			$('input:checkbox[id="price_y"]').attr("checked", false);
			$("#pay_yn").val("N");
		}else{
			$('input:checkbox[id="price_y"]').attr("checked", true);
			$('input:checkbox[id="price_n"]').attr("checked", false);
			$("#pay_yn").val("Y");
		}
		$("#modaloverlay2").show();
	});
	
	// 데이터 가져오기 유료/무료 서비스 변경 취소할 경우 기존 선택 영역으로 변경하기
	$("#pop_cancel_btn").on("click",function(){
		resetPayYn();
	});
	
	// 데이터 가져오기 유료/무료 서비스 변경
	$("#pop_confirm_btn").on("click",function(){
		membershipYn($("#evdc_gb").val(), $("#pay_yn").val(), $("#use_pric").val());
	});
	
	// 안내창 닫기
	$(document).on("click","#pop_btn01",function(){
		$("#modaloverlay1").hide();
	});
	
});
var _thisPage={
		onload : function(){
			iWebAction("changeTitle",{"_title" : "데이터 연결","_type" : "2"});
			iWebAction("fn_display_mic_button",{"_display_yn":"N"});
			$(".m_cont").show();
			
			_thisPage.searchData();
			_thisPage.searchCertData();
		},
		searchData : function(){
			avatar.common.callJexAjax("basic_0002_01_r001","",_thisPage.searchCallback);
		},
		searchCallback : function(data){
			if(avatar.common.null2void(data.RSLT_CD)=="9999"){
				alert(data.RSLT_MSG);
				return;
			}
			$("#ul_acct").empty();
			$("#ul_card").empty();
			/*
			$(".ico_d01").removeClass("on");
			$(".ico_d02").removeClass("on");
			$(".ico_d03").removeClass("on");
			$(".ico_d04").removeClass("on");
			$(".ico_d05").removeClass("on");
			*/
			
			//계좌 목록
			if(data.ACCT_REC.length>0){
				$("div[ctgr=acct]").attr("data-exist_dv", true);
				$("div[ctgr=acct]").addClass("on");
				$("div[ctgr=acct] .conCompt").show();
			}else{
				$("div[ctgr=acct]").attr("data-exist_dv", false);
				$("div[ctgr=acct]").removeClass("on");
				$("div[ctgr=acct] .conCompt").hide();
				$("input:checkbox[name=acct_chk]").attr("checked", false);
				$("input:checkbox[name=acct_chk]").removeClass("on");
			}
			
			//카드목록
			if(data.CARD_REC.length>0){
				$("div[ctgr=card]").attr("data-exist_dv", true);
				$("div[ctgr=card]").addClass("on");
				$("div[ctgr=card] .conCompt").show();
			}else{
				$("div[ctgr=card]").attr("data-exist_dv", false);
				$("div[ctgr=card]").removeClass("on");
				$("div[ctgr=card] .conCompt").hide();
				$("input:checkbox[name=card_chk]").attr("checked", false);
				$("input:checkbox[name=card_chk]").removeClass("on");
			}
			
			//홈텍스:tax,카드매출:sale,인증서:cert,온라인매출:snss
			if(data.EVDC_REC.length>0){
				$.each(data.EVDC_REC,function(i,v){
					if(avatar.common.null2void(v.GB)!="cert" && avatar.common.null2zero(v.CNT)!="0" ){
						$("div[ctgr="+v.GB+"]").attr("data-exist_dv", true);
						$("div[ctgr="+v.GB+"]").addClass("on");
						$("div[ctgr="+v.GB+"] .conCompt").show();
					} else {
						$("div[ctgr="+v.GB+"]").attr("data-exist_dv", false);
						$("div[ctgr="+v.GB+"]").removeClass("on");
						$("div[ctgr="+v.GB+"] .conCompt").hide();
						
						if(v.GB == "tax"){
							$("input:checkbox[name=tax_chk]").attr("checked", false);
							$("input:checkbox[name=tax_chk]").removeClass("on");
						}else if(v.GB == "sale"){
							$("input:checkbox[id=sale_chk_n]").attr("checked", false);
							$("input:checkbox[id=sale_chk_n]").removeClass("on");
						}else if(v.GB == "snss"){
							$("input:checkbox[name=snss_chk]").attr("checked", false);
							$("input:checkbox[name=snss_chk]").removeClass("on");						
						}
					}
				});
			}
			
			// 실시간 조회 스크래핑 결과
			if(data.RT_REC.length>0){
				$.each(data.RT_REC,function(i,v){
					if(avatar.common.null2void(v.TASK_GB) == "1" 
						&& avatar.common.null2void(v.TASK_STTS) == "0"
						&& $("div[ctgr=acct]").attr("data-exist_dv") == 'true'){
						// 은행 항목에 체크
						$(".ico_d01").removeClass("on");
					}	
					else if(avatar.common.null2void(v.TASK_GB) == "3" 
						&& avatar.common.null2void(v.TASK_STTS) == "0"
						&& $("div[ctgr=tax]").attr("data-exist_dv") == 'true'){
						// 홈택스 항목에 체크
						$(".ico_d02").removeClass("on");
					}
					else if(avatar.common.null2void(v.TASK_GB) == "4" 
						&& avatar.common.null2void(v.TASK_STTS) == "0" 
						&& $("div[ctgr=sale]").attr("data-exist_dv") == 'true'){
						// 여신 항목에 체크
						$(".ico_d03").removeClass("on");
					}
					else if(avatar.common.null2void(v.TASK_GB) == "2" 
						&& avatar.common.null2void(v.TASK_STTS) == "0" 
						&& $("div[ctgr=card]").attr("data-exist_dv") == 'true'){
						// 카드 항목에 체크
						$(".ico_d04").removeClass("on");
					}
					else if(avatar.common.null2void(v.TASK_GB) == "5" 
						&& avatar.common.null2void(v.TASK_STTS) == "0" 
							&& $("div[ctgr=snss]").attr("data-exist_dv") == 'true'){
							// 온라인 매출에 체크
							$(".ico_d06").removeClass("on");
						}
				});
			}
			
			// 계정별 유료서비스 여부
			if(data.PAY_REC.length>0){
				$.each(data.PAY_REC,function(i,v){
					if(avatar.common.null2void(v.EVDC_GB) == "01" 
						&& avatar.common.null2void(v.PAY_YN) == "Y"
						&& $("div[ctgr=acct]").attr("data-exist_dv") == 'true'){
						// 은행 매시간 항목에 체크
						$("#acct_chk_y").addClass("on");
					}	
					else if(avatar.common.null2void(v.EVDC_GB) == "02" 
						&& avatar.common.null2void(v.PAY_YN) == "Y"
						&& $("div[ctgr=tax]").attr("data-exist_dv") == 'true'){
						// 홈택스 매시간 항목에 체크
						$("#tax_chk_y").addClass("on");
					}
					else if(avatar.common.null2void(v.EVDC_GB) == "03" 
						&& avatar.common.null2void(v.PAY_YN) == "Y"
						&& $("div[ctgr=card]").attr("data-exist_dv") == 'true'){
						// 카드 매시간 항목에 체크
						$("#card_chk_y").addClass("on");
					}
					else if(avatar.common.null2void(v.EVDC_GB) == "11" 
						&& avatar.common.null2void(v.PAY_YN) == "Y"
						&& $("div[ctgr=snss]").attr("data-exist_dv") == 'true'){
						// 온라인매출 매시간 항목에 체크
						$("#snss_chk_y").addClass("on");
					}
				});	
			}
			
			if(!$("#acct_chk_y").hasClass("on") && $("div[ctgr=acct]").attr("data-exist_dv") == 'true'){
				$("#acct_chk_n").addClass("on");
			}
			if(!$("#tax_chk_y").hasClass("on") && $("div[ctgr=tax]").attr("data-exist_dv") == 'true'){
				$("#tax_chk_n").addClass("on");
			}
			if(!$("#card_chk_y").hasClass("on") && $("div[ctgr=card]").attr("data-exist_dv") == 'true'){
				$("#card_chk_n").addClass("on");
			}
			if(!$("#snss_chk_y").hasClass("on") && $("div[ctgr=snss]").attr("data-exist_dv") == 'true'){
				$("#snss_chk_n").addClass("on");
			}
			if($("div[ctgr=sale]").attr("data-exist_dv") == 'true'){
				$("#sale_chk_n").addClass("on");
			}
			
			// 경리나라 항목 초기화
			$(".ico_d05").removeClass("on");
			$("div[ctgr=serp] .conCompt").hide();
			
			// 제로페이 항목 초기화
			$(".ico_d07").removeClass("on");
			$("div[ctgr=zeropay] .conCompt").hide();
			$("div[ctgr=zeropay]").attr("data-exist_dv", false);
			
			// 연계된 계정 조회
			if(data.LINK_REC.length>0){
				$.each(data.LINK_REC,function(i,v){
					if(avatar.common.null2void(v.LINK_NM) == "SERP" 
						&& avatar.common.null2void(v.LINK_YN) == "Y"){
						// 경리나라 항목에 체크
						$(".ico_d05").addClass("on");
						$("div[ctgr=serp] .conCompt").show();
					}	
					else if(avatar.common.null2void(v.LINK_NM) == "ZEROPAY" 
						&& avatar.common.null2void(v.LINK_YN) == "Y"){
						// 제로페이 항목에 체크
						$(".ico_d07").addClass("on");
						$("div[ctgr=zeropay] .conCompt").show();
						$("div[ctgr=zeropay]").attr("data-exist_dv", true);
					}
				});	
			}
			
			
			iWebAction("fn_syncLoginInfo",{"BSNN_NM" : data.BSNN_NM});
		}
		, searchCertData : function(){
			avatar.common.callJexAjax("basic_0002_01_r003", "", _thisPage.searchCertCallback);
		}
		, searchCertCallback : function(data){
			if(data.ACCT_CERT.CERT_EXP == "Y"){
				$("div[ctgr=acct] .cerEnd").show();
				$("div[ctgr=acct] .cerEnd").text("인증서만료");
			} else if(data.ACCT_CERT.CERT_EXP == "E"){
				$("div[ctgr=acct] .cerEnd").show();
				$("div[ctgr=acct] .cerEnd").text("만료예정");
			} else {
				$("div[ctgr=acct] .cerEnd").hide();
			}
			
			if(data.TAX_CERT.CERT_EXP == "Y"){
				$("div[ctgr=tax] .cerEnd").show();
				$("div[ctgr=tax] .cerEnd").text("인증서만료");
			} else if(data.TAX_CERT.CERT_EXP == "E"){
				$("div[ctgr=tax] .cerEnd").show();
				$("div[ctgr=tax] .cerEnd").text("만료예정");
			} else {
				$("div[ctgr=tax] .cerEnd").hide();
			}
			
		}
}

// 계정별 유료서비스 가입/해지
function membershipYn(evdc_gb, pay_yn, use_pric){
	
	var jexAjax = jex.createAjaxUtil("basic_0002_01_c001");
	jexAjax.set("EVDC_GB", evdc_gb); 	// 01:은행, 02:홈택스, 03:카드, 11:온라인매출
	jexAjax.set("PAY_YN", pay_yn);		// Y:유료, N:무료
	jexAjax.set("USE_PRIC", use_pric);	// 계정별 가격(ex.1000)
	jexAjax.execute(function(data){
		$("#modaloverlay2").hide();
		if(data.RSLT_CD == "WSND0003"){
			resetPayYn();
			alert("데이터를 연결해주세요.");
		}else if(data.RSLT_CD != "0000"){
			// 실패 : 기존 체크 영역 재 선택
			resetPayYn();
			alert("유료/무료 이용서비스 변경에 실패하였습니다.");
		}
	});
	
}

// 실시간 조회여부 
function realTimeFnshYn(task_gb, _that){
	
	var jexAjax = jex.createAjaxUtil("basic_0002_01_r002");
	jexAjax.set("TASK_GB", task_gb);
	jexAjax.execute(function(data){
		if(data.FNSH_YN == "N"){
			$("#modaloverlay1").show();
		}else{
			if(task_gb == "1"){
				// 은행등록 화면으로 이동
				fn_moveAcct(_that);
			}else if(task_gb == "3"){
				// 홈택스등록 화면으로 이동
				fn_moveTax(_that);
			}else if(task_gb == "4"){
				// 여신등록 화면으로 이동
				var url = "card_0003_01.act";
				iWebAction("openPopup",{_url:url});
			}
			
		}
	});
	
}

function resetPayYn(){
	if($("#evdc_gb").val() == "01"){
		$("input:checkbox[name=acct_chk]").attr("checked", false);
		$("input:checkbox[name=acct_chk]").removeClass("on");
		if($("#pay_yn").val() == "Y"){
			$("#acct_chk_n").addClass("on");
		}else{
			$("#acct_chk_y").addClass("on");
		}
	}else if($("#evdc_gb").val() == "02"){
		$("input:checkbox[name=tax_chk]").attr("checked", false);
		$("input:checkbox[name=tax_chk]").removeClass("on");
		if($("#pay_yn").val() == "Y"){
			$("#tax_chk_n").addClass("on");
		}else{
			$("#tax_chk_y").addClass("on");
		}
	}else if($("#evdc_gb").val() == "03"){
		$("input:checkbox[name=card_chk]").attr("checked", false);
		$("input:checkbox[name=card_chk]").removeClass("on");
		if($("#pay_yn").val() == "Y"){
			$("#card_chk_n").addClass("on");
		}else{
			$("#card_chk_y").addClass("on");
		}
	}else if($("#evdc_gb").val() == "11"){
		$("input:checkbox[name=snss_chk]").attr("checked", false);
		$("input:checkbox[name=snss_chk]").removeClass("on");
		if($("#pay_yn").val() == "Y"){
			$("#snss_chk_n").addClass("on");
		}else{
			$("#snss_chk_y").addClass("on");
		}
	}
	$("#evdc_gb").val("");
	$("#pay_yn").val("");
	$("#use_pric").val("");
	$("#modaloverlay2").hide();
}

//홈텍스 인증서 호출 후 콜백
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
	// 인증서 데이터 복호화
}

//홈텍스 인증서 호출 후 콜백
function callbackFuncTax007(backData){
	var key 	 = backData.substring(0, 10);
	var sec_flag = backData.substring(10, 11);
	var data 	 = backData.substring(11);
	var input = {};
	input["KEY"]=key;
	input["SEC_FLAG"]=sec_flag;
	input["DATA"]=data;
	iWebAction("showIndicator");
	avatar.common.callJexAjax("tax_0001_01_r001",input,taxCallback007);
	// 인증서 데이터 복호화
}

function taxCallback(data){
	if(avatar.common.null2void(data.RSLT_CD)=="9999"){
		alert(data.RSLT_MSG);
		return;
	}
	var cert_name = avatar.common.null2void(data.CERT_NAME);			// 인증서 이름
	var cert_pwd = avatar.common.null2void(data.CERT_PWD);				// 인증서 비밀번호
	var cert_org = avatar.common.null2void(data.CERT_ORG);				// 인증서 발급기관
//	var cert_org_nm = avatar.common.null2void(data.CERT_DSNC_NM);		// 인증서 발급기관명
	var cert_date = avatar.common.null2void(data.CERT_DATE);			// 인증서 만료일자
	var reg_type = avatar.common.null2void(data.REG_TYPE);				// 인증서 유형(0:휴대폰인증서, 1:등록인증서)
	var cert_folder = avatar.common.null2void(data.CERT_FOLDER);		// 인증서 경로명
	var cert_data = avatar.common.null2void(data.CERT_DATA);			// 인증서데이터
	var cert_gb = avatar.common.null2void(data.CERT_GB);				// 인증서 구분
	var cert_usag_div = avatar.common.null2void(data.CERT_USAG_DIV);	// 인증서용도 구분 (0:개인용, 1:기업용)
	var cert_usag_div_nm = "";											// 인증서용도 구분명
	var cert_issu_dt = avatar.common.null2void(data.CERT_ISSU_DT); 	// 인증서 발행 일자
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
	input["OTHER_STTS"]="";
	input["EVDC_DIV_CD1"]="20"; 			// 20:전자(세금)계산서
	input["EVDC_DIV_CD2"]="21"; 			// 21:현금영수증
	//input["EVDC_DIV_CD3"]="22"; 			// 22:부가가치세/종합소득세
	fn_evdcReg(input);
}

function taxCallback007(data){
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
	fn_evdcTaxReg007(input);
}

// 홈택스 증빙설정정보 등록
function fn_evdcReg(data){
	avatar.common.callJexAjax("tax_0001_01_u001",data,fn_evdcRegCallback);
}

// 홈택스 부가가치세/종합소득세 등록
function fn_evdcTaxReg007(data){
	avatar.common.callJexAjax("tax_0001_01_u002",data,fn_evdcRegCallback);
}

function fn_evdcRegCallback(data){
	iWebAction("hideIndicator");
	var url = "tax_0001_01.act";
		url+="?RSLT_CD="+avatar.common.null2void(data.RSLT_CD);
		url+="&RSLT_MSG="+avatar.common.null2void(data.RSLT_MSG);
		url+="&BSNN_NM="+avatar.common.null2void(data.BSNN_NM);
		url+="&RPPR_NM="+avatar.common.null2void(data.RPPR_NM);
	if(data.RSLT_CD == "00000000"){// 성공
		url+="&REG_YN=Y";
		url+="&FST_REG_YN="+avatar.common.null2void(data.FST_REG_YN);
	}else{
		url+="&REG_YN=N";
		url+="&FST_REG_YN=N"
	}
	iWebAction("openPopup",{_url:url});
}
//계좌 등록 후 돌아 왔을 시 콜백
function fn_acct_reg_cmpl(){
	//_thisPage.searchData();
	var url="acct_0004_01.act";
	iWebAction("openPopup",{_url:url}); 
}
//인증서 등록 되어있다면 홈텍스 인증서 페이지로 이동 아니면 인증서 등록 웹액션 호출
function fn_moveTax(_that){
	/*
	var exist = $(_that).attr("data-exist_dv");
	if(exist == 'true'){
		var url="tax_0002_01.act";
		iWebAction("openPopup",{_url:url});
	} else {
		iWebAction("fn_cert_list",{
			"_menu_id":"2",
			"_title":"국세청 홈택스",
			"_callback":"callbackFunc"
		});
	}
	*/
	var url="tax_0004_01.act";
	iWebAction("openPopup",{_url:url});
}
function fn_moveAcct(_that){
	var exist = $(_that).attr("data-exist_dv");
	if(exist == 'true'){
		var url="acct_0003_01.act";
		iWebAction("openPopup",{_url:url});
	} else {
		iWebAction("fn_cert_list",{_menu_id : "1",_title:"은행데이터 가져오기",_callback : "fn_acct_reg_cmpl"});
	}
}
function certChk(){
	var jexAjax = jex.createAjaxUtil("ques_comm_01_r006"); // PT_ACTION
	jexAjax.set("USE_INTT_ID", _USE_INTT_ID);
	if($("#TAX_CNT").text()){
		jexAjax.set("MENU_DV", "TAX");
	} else if($("#CASH_CNT").text()){
		jexAjax.set("MENU_DV", "CASH");
	} else if($("#ACCT_CNT").text()){
		jexAjax.set("MENU_DV", "ACCT");
	} else{return false;}
	jexAjax.execute(function(data) {
		if(data.CERT_EXP_DT_YN == "Y"){
			$("#cert_modal").show();
		} else $("#cert_modal").hide();
	});
}

//20200915 추가
//인증서 선택 후 콜백함수
/*function callbackFunc2(backData){
	var key 	 = backData.substring(0, 10);
	var sec_flag = backData.substring(10, 11);
	var data 	 = backData.substring(11);
	
	$('#KEY').val(key);
	$('#SEC_FLAG').val(sec_flag);
	$('#DATA').val(data);
	$('#CERT_DATA').val(backData);
	
	// 계정자동조회 호출
	fn_ac_reg();
}

// 계정자동조회 호출
function fn_ac_reg(){
	iWebAction("showProgress");
	var jexAjax = jex.createAjaxUtil("basic_0031_01_c001");
	jexAjax.set("SEC_FLAG"	, $("#SEC_FLAG").val());
	jexAjax.set("CERT_DATA"	, $("#CERT_DATA").val());
	jexAjax.set("DATA" 		, $("#DATA").val());
	jexAjax.set("KEY"		, $("#KEY").val());
	jexAjax.set("SCQKEY"	, _CIPHER_KEY);
	
	jexAjax.execute(function(data){
		iWebAction("hideProgress");
		if(data.RSLT_CD == "0000"){
			location.href = "basic_0032_01.act?MAIN="+$("#MAIN").val();
		}else{
			$(".toast_pop").css("display","block");
			$(".toast_pop").fadeOut(3000);
		}
	});
}
*/

//계좌등록 콜백함수
//백버튼?
function fn_back(){
	//ques_0001_01페이지에서 호출한 경우가 아니라면 페이지 이동, 맞다면 히스토리 백..
	var referrer=document.referrer;
	if(referrer.indexOf("ques_0001_01.act")==-1){
		iWebAction("closePopup");/*location.href="ques_0001_01.act";*/
	} else {
		iWebAction("closePopup");	
	}
	//basic_0001_01페이지에서 호출한 경우가 아니라면 페이지 이동, 맞다면 히스토리 백..
	/*var referrer=document.referrer;
	if(referrer.indexOf("basic_0001_01.act")==-1){
		iWebAction("closePopup");
		//location.href="basic_0001_01.act";
	} else {
		iWebAction("closePopup");	
	}*/
//	location.href="basic_0001_01.act";
//	history.back();
}
function fn_popCallback(){
	_thisPage.onload();
}
function fn_popCallback2(){
	fn_back();
}
function fn_popCallback_tax(){
	//홈텍스 인증서 조회 실패 - 재전송 요청 시
	fn_moveTax();
}
