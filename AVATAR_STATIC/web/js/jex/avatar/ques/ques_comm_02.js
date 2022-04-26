/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_comm_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200323180543, 김별
 * </pre>
 **/
var sum = 0;
$(function(){
	iWebAction("changeTitle",{"_title" : "질의","_type" : "2"});
	_thisPage.onload();
	$(document).on("click", "a[name=a-data]", function(){
		var ctgr = $(this).attr("ctgr");
		if(ctgr=="acct"){
			if($("#ACCT_CNT").val()>0){
				_thisPage.fn_change($(this), "db");
			} else{
				iWebAction("fn_cert_list",{_menu_id : "1",_title:"은행데이터 가져오기",_callback : "fn_popCallback"});
			}
		} else if(ctgr=="tax"){
			if($("#CASH_CNT").val()> 0 || $("#PRCH_CNT").val()>0){
				_thisPage.fn_change($(this), "db");
			} else{
				fn_moveTax(this);
			}
		} else if(ctgr=="sale"){
			if($("#SALE_CNT").val()> 0){
				_thisPage.fn_change($(this), "db");
			} else{
				var url = "card_0003_01.act";
				iWebAction("openPopup",{_url:url});
			}
		} else if(ctgr=="card"){
			if($("#CARD_CNT").val()> 0){
				_thisPage.fn_change($(this), "db");
			} else{
				var url = "card_0005_01.act";
				iWebAction("openPopup",{_url:url});
			}
		} else if(ctgr=="serp"){
			/*
			 * i) 	APP등록 X -> 경리나라 등록 페이지
			 * ii) 	APP등록 O / API등록 X -> API create 
			 */
			if($("#APP_CNT").val() > 0){
				_thisPage.fn_change($(this), "api");
			} else {
				var url = "basic_0005_01.act";
				iWebAction("openPopup",{_url:url});
			}
		}
	});
	
});

var _thisPage = {
		onload : function(){
			_thisPage.setData();
		},
		setData: function(){
			var input = {};
			input["INTE_CD"] = $("#INTE_CD").val();
			avatar.common.callJexAjax("ques_comm_02_r001", input, _thisPage.fn_callback, "true", "");
		},
		fn_callback : function(data){
			$(".m_cont").html(data.REC[0].SMPL_HTML);
			
			var cntSum = 0;
			
			$.each(avatar.common.null2void(data.REC_CNT[0]), function(idx, item){
				//cntSum += parseInt(avatar.common.null2zero(item));
				$("#"+idx).val(item);
			});
			$("#BZAQ_CNT").val(data.TOTL_CNT);
			$("#APP_CNT").val(data.APP_CNT);
			$("#API_CNT").val(data.API_CNT);
			$('.PAGE_CTGR').each(function(i, v){
				$(".CNT[ctgr="+$(v).val()+"]").each(function(idx, item){
 					cntSum += parseInt(avatar.common.null2zero($(item).val()));
				});
			});
			
			if(avatar.common.null2zero(cntSum) == 0){
				$(".tit span").text("데이터 연결이 필요합니다.");
			} else{
				$(".tit span").text("데이터 연결을 변경할 수 있습니다.");
				if((data.API_CNT > 0) && (data.STTS == "3")){
					$("a[name=a-data][ctgr=serp]").addClass("color3");
					$("a[name=a-data][ctgr=serp]").bind("click", false);
				} else{
					$(".CNT").each(function(idx, item){
						//alert($(item).attr("id") + " :: "+ $(item).val());
						if($(item).val() > 0){
							
							var key = $(item).attr("ctgr");
							$("a[name=a-data][ctgr="+key+"]").addClass("color3");
							$("a[name=a-data][ctgr="+key+"]").bind("click", false);
						}
					});
				}
			}
			
			
		},
		fn_change : function($this, key){
			if(key == "api"){
				var input = {};
				input["INTE_CD"] = $("#INTE_CD").val();
				avatar.common.callJexAjax("ques_comm_02_c001", input, '', "true", "");
			} else if(key == "db"){
				var input = {};
				input["INTE_CD"] = $("#INTE_CD").val();
				avatar.common.callJexAjax("ques_comm_02_d001", input, '', "true", "");
			}
			$this.addClass('color3')
			$this.bind("click", false);
			$(".btnbx").find("a[type!="+$this.attr('type')+"]").unbind('click', false);
			$(".btnbx").find("a[type!="+$this.attr('type')+"]").removeClass('color3');
			
			fn_toast_pop('데이터 연결이 변경되었습니다.');
			_thisPage.onload();
			fn_setSettingModal(key);
		}, 
		fn_changeAll : function(key){
			/*
			 * SELECT A.APP_ID, API_ID, INTE_CD
  			FROM QUES_API_INFM A
  			LEFT JOIN CUST_LINK_SYS_INFM B ON A.APP_ID = B.APP_ID
 			WHERE USE_INTT_ID = 'A039900001'
 			-> CREATE CUST_INTE_LINK_INFM FROM THESE INFO.
			 * */
			if(key == "api"){
				var input = {};
				input["MENU_DV"] = "ALL";
				avatar.common.callJexAjax("ques_comm_02_c001", input, '', "true", "");
			} else if(key == "db"){
				var input = {};
				input["MENU_DV"] = "ALL";
				avatar.common.callJexAjax("ques_comm_02_d001", input, '', "true", "");
			}
			$(".btnbx a").removeClass("color3");
			$(".btnbx a").unbind("click", false);
			var $this = $(".btnbx").find("a[type='"+key+"']");
			$this.addClass('color3')
			$this.bind("click", false);
			fn_removeModal();
			fn_toast_pop('데이터 연결이 변경되었습니다.');
			/*$(".btnbx").find("a[type!="+$this.attr('type')+"]").unbind('click', false);
			$(".btnbx").find("a[type!="+$this.attr('type')+"]").removeClass('color3');*/
			/*$this.addClass('color3')
			$this.bind("click", false);
			$(".btnbx").find("a[type!="+$this.attr('type')+"]").unbind('click', false);
			$(".btnbx").find("a[type!="+$this.attr('type')+"]").removeClass('color3');
			
			
			_thisPage.onload();*/
		}
		
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
// 홈택스 증빙설정정보 등록
function fn_evdcReg(data){
	avatar.common.callJexAjax("tax_0001_01_u001",data,fn_evdcRegCallback);
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
	_thisPage.searchData();
}
//인증서 등록 되어있다면 홈텍스 인증서 페이지로 이동 아니면 인증서 등록 웹액션 호출
function fn_moveTax(_that){
	var exist = isNaN(_that)?"":$(_that).text(); 
	if(exist.indexOf("관리하기")==-1){
		iWebAction("fn_cert_list",{
			"_menu_id":"2",
			"_title":"국세청 홈택스",
			"_callback":"callbackFunc"
		});
	} else {
		var url="tax_0002_01.act";
		iWebAction("openPopup",{_url:url});
	}
}
//계좌등록 콜백함수

function fn_popCallback(){
	_thisPage.onload();
}
function fn_popCallback_tax(){
	//홈텍스 인증서 조회 실패 - 재전송 요청 시
	fn_moveTax();
}

function fn_back(){
	if($(".btnbx a").hasClass("color3")){
		if($("#INTE_CD").val().charAt(0) == "A" && $("#BZAQ_CNT").val()==0){
			iWebAction("closePopup", {"_callback" : "fn_popCallback2"});
		}
		else{	//back and reload
			iWebAction("closePopup", {"_callback" : "fn_popCallback1"});
		}
	} else{//둘다 설정 안되어 있을 떄 -> comm_01에서 메인으로 바로 back
		iWebAction("closePopup", {"_callback" : "fn_popCallback2"});
	}
	/*if(sum > 0){
		
	} else{
		
	}*/
	
}
function fn_toast_pop(msg){
	$('#toast_msg').text(msg);
	$('.toast_pop').css('display','block');
	setTimeout(function(){
		$('.toast_pop').css('display', 'none');
	}, 3000);
}

function fn_setSettingModal(key){
	var modalHtml='';
	modalHtml +="<div class='modaloverlay'>";
	modalHtml +="	<div class='lytb'><div class='lytb_row'><div class='lytb_td'>";
	modalHtml +="	<div class='layer_style1'>";
	modalHtml +="		<div class='layer_po'>";
	modalHtml +="			<div class='cont'>";
	modalHtml +="				<p class='lyp_txt3 c_blue' style='margin-top:0;'>";
	modalHtml +="				</p>";
	modalHtml +="				<div class='lyp_txt3'>";
	modalHtml +="					<span>다른 질의의 데이터 연결도<br>";
	modalHtml +="					모두 변경 하시겠습니까?</span>";
	modalHtml +="				</div>";
	modalHtml +="			</div>";
	modalHtml +="		</div>";
	modalHtml +="		<div class='ly_btn_fix_botm btn_both'><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->";
	modalHtml +="			<a class='off' onClick='fn_removeModal()'>취소</a>";
	modalHtml +="			<a onClick='_thisPage.fn_changeAll(\""+key+"\")'>확인</a>";
	modalHtml +="		</div>";
	modalHtml +="	</div>";
	modalHtml +="	</div></div></div>";
	modalHtml +="</div>";
	$('body').append(modalHtml);
}
//모달 닫기
function fn_removeModal(){
	$(".modaloverlay").remove();
}