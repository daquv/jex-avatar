/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name	  : home_0002_03.js
 * @File path	  : AVATAR_STATIC/web/js/jex/avatar/home
 * @author		 : 김별 (  )
 * @Description	: 
 * @History		: 20210511103625, 김별
 * </pre>
 **/

$(function(){
	$(document).on("click", ".bt_b1", function(){
		consultingSave(); 
	});
	$(document).on("click", ".footer_menu li:eq(0)", function(){
		$(".termFixed:eq(1)").show();
	})
	$(document).on("click", ".footer_menu li:eq(1)", function(){
		$(".termFixed:eq(0)").show();
	});
	$(document).on("click", ".btn_close,.popLayer_bt_inn", function(){
		$("#term_prev").hide();
		$("#term_now").show();
		$(".popLayer_body").animate({scrollTop:0}, 5);
		setTimeout(function() {
			$(".termFixed").hide();
		}, 15)
	})
	$(document).on("click", ".servTermGo", function(){
		$("#term_now").hide();
		$("#term_prev").show();
	})
});

function consultingSave(){
	
	if($("#RQST_BSNN_NM").val() == ""){
		//alert("회사명을 입력하세요.");
		$("#pop_alert").text("회사명을 입력하세요.");
		$("#pop_msg").show();
		$("#pop_btn").on("click",function(){
			$("#pop_msg").hide();
			$("#RQST_BSNN_NM").focus();
		});
		return;
	}
	if($("#RQST_BIZ_NO").val().replace(/-/g, "").length != 10 || !isBusinessNo($("#RQST_BIZ_NO").val().replace(/-/g, ""))){
		//alert("올바르지 않은 사업자번호입니다.");
		//$("#RQST_BIZ_NO").focus();
		$("#pop_alert").text("올바르지 않은 사업자번호입니다.");
		$("#pop_msg").show();
		$("#pop_btn").on("click",function(){
			$("#pop_msg").hide();
			$("#RQST_BIZ_NO").focus();
		});
		return;
	}
	if($("#RQST_CUST_NM").val() == ""){
		//alert("이름을 입력하세요.");
		//$("#RQST_CUST_NM").focus();
		$("#pop_alert").text("이름을 입력하세요.");
		$("#pop_msg").show();
		$("#pop_btn").on("click",function(){
			$("#pop_msg").hide();
			$("#RQST_CUST_NM").focus();
		});
		return;
	}
	if($("#RQST_CLPH_NO").val() == ""){
		//alert("연락처를 입력하세요.");
		//$("#RQST_CLPH_NO").focus();
		$("#pop_alert").text("연락처를 입력하세요.");
		$("#pop_msg").show();
		$("#pop_btn").on("click",function(){
			$("#pop_msg").hide();
			$("#RQST_CLPH_NO").focus();
		});
		return;
	}
	var id = $('input[name="agrm_chk"]:checked').attr('id');
	if(id!="agrm_chk"){
		//alert("개인정보 수집 및 이용에 동의해주세요.");
		$("#pop_alert").text("개인정보 수집 및 이용에 동의해주세요.");
		$("#pop_msg").show();
		$("#pop_btn").on("click",function(){
			$("#pop_msg").hide();
		});
		return;
	}
	
	var params = {};
	params["RQST_BSNN_NM"] = $("#RQST_BSNN_NM").val();
	params["RQST_CUST_NM"] = $("#RQST_CUST_NM").val();
	params["RQST_CLPH_NO"] = $("#RQST_CLPH_NO").val().replace(/-/g, "");
	params["RQST_BIZ_NO"] = $("#RQST_BIZ_NO").val().replace(/-/g, "");
	params["RQST_EML"] = $("#RQST_EML").val();
	params["RQST_CTT"] = $("#RQST_CTT").val().replace("/\n/g","<br>");
	params["CNSL_DIV"] = "1";
	params["CNSL_STTS"] = "0";
	
	console.log(params);
	$.ajax({
		type:"POST",
		url:"/home_0002_03_c001.jct",
		data:params,
		success:function(data){
			if(data.RSLT_CD == '0000'){
				//alert("등록완료되었습니다.");
				$("#pop_alert").text("등록완료되었습니다.");
				$("#pop_msg").show();
				$("#pop_btn").on("click",function(){
					// 입력 데이터 초기화
					$("#RQST_BSNN_NM").val("");
					$("#RQST_BIZ_NO").val("");
					$("#RQST_CUST_NM").val("");
					$("#RQST_CLPH_NO").val("");
					$("#RQST_EML").val("");
					$("#RQST_CTT").val("");
					$("#agrm_chk").prop('checked', false);
				});
				
				$(".mfrmIpt .mfrm_grp .right").each(function(i, v){
					$(v).children().val("");
				});
				return;
			}else{
				alert("처리 중 오류가 발생하였습니다.")
			}
		}
	});

}
//사업자번호 검증
function isBusinessNo(businessNo) {
	if(!businessNo || businessNo.length != 10) return false;
	var sum = 0;
	var chkValue = new Array(10);

	for(var i = 0; i < 10; i++){
		chkValue[i] = parseInt(businessNo.charAt(i));
	}
	var multipliers = [1,3,7,1,3,7,1,3];
	for (i = 0; i < 8; i++){
		sum += (chkValue[i] *= parseInt(multipliers[i]));
	}

	var chkTemp = chkValue[8] * 5 + '0';
	chkValue[8] = parseInt(chkTemp.charAt(0)) + parseInt(chkTemp.charAt(1));
	var chkLastid = (10 - (((sum % 10) + chkValue[8]) % 10)) % 10;

	if (chkValue[9] != chkLastid) {
		return false;
	}
	return true;
}
//핸드폰번호 자동format
function inputPhoneNumber(obj) {
	var number = obj.value.replace(/[^0-9]/g, "");
	var phone = "";

	if(number.length < 4) {
		return number;
	} else if(number.length < 7) {
		phone += number.substr(0, 3);
		phone += "-";
		phone += number.substr(3);
	} else if(number.length < 11) {
		phone += number.substr(0, 3);
		phone += "-";
		phone += number.substr(3, 3);
		phone += "-";
		phone += number.substr(6);
	} else {
		phone += number.substr(0, 3);
		phone += "-";
		phone += number.substr(3, 4);
		phone += "-";
		phone += number.substr(7);
	}
	obj.value = phone;
}
//사업자 번호 자동 format
function inputCorpNum(obj) {
	var number = obj.value.replace(/[^0-9]/g, "");
	var corpNum = "";

	if(number.length < 4) {
		return number;
	} else if(number.length < 5) {
		corpNum += number.substr(0, 3);
		corpNum += "-";
		corpNum += number.substr(3);
	} else if(number.length < 10) {
		corpNum += number.substr(0, 3);
		corpNum += "-";
		corpNum += number.substr(3, 1);
		corpNum += "-";
		corpNum += number.substr(4);
	} else {
		corpNum += number.substr(0, 3);
		corpNum += "-";
		corpNum += number.substr(3, 2);
		corpNum += "-";
		corpNum += number.substr(5);
	}
	obj.value = corpNum;
}