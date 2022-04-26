/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : acct_0003_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/acct
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20201119111557, 김별
 * </pre>
 **/

$(function(){
	_thisPage.onload();
	//데이터 가져오기 클릭
	
	$(document).on("click", ".data_cnt .right", function(){
		iWebAction("fn_cert_list",{_menu_id : "1",_title:"은행데이터 가져오기",_callback : "fn_acct_reg_cmpl"});
	})
	/*$("div[name=a_data]").on("click",function(){
		iWebAction("fn_cert_list",{_menu_id : "1",_title:"은행데이터 가져오기",_callback : "fn_acct_reg_cmpl"});
		var ctgr = $(this).attr("ctgr");
		if(!$(this).hasClass("prem")){
			if(ctgr=="acct"){
			}
		}
		
	});*/
	//은행탭 관리하기 클릭
	$(document).on("click","div[GB=ACCT]",function(){
		//? 뒤만 인코딩
		//var text = "BANK_CD="+$(this).attr("BANK_CD")+"&BANK_NM="+$(this).find("div:eq(0)").text();
		//var url = "acct_0001_01.act?"+encodeURIComponent(text);
		
		//기존 url
		var url = "acct_0001_01.act?BANK_CD="+$(this).attr("BANK_CD")+"&BANK_NM="+$(this).find("div:eq(0)").text()
		iWebAction("openPopup",{_url:url});
	});
});

var _thisPage = {
		onload : function(){
			iWebAction("changeTitle",{"_title" : "은행 데이터","_type" : "2"});
			
			_thisPage.searchData();
		},
		searchData : function(){
			avatar.common.callJexAjax("acct_0003_01_r001","",_thisPage.searchCallback);
		},
		searchCallback : function(data){
			if(avatar.common.null2void(data.RSLT_CD)=="9999"){
				alert(data.RSLT_MSG);
				return;
			}
			$(".data_wbx").empty();
			//계좌 목록
			if(data.REC.length>0){
				var acctHtml;
				$.each(data.REC,function(i,v){
					acctHtml = '';
					acctHtml += "<div class='ico_bank' GB='ACCT' BANK_CD='"+avatar.common.null2void(v.BANK_CD)+"'>";
					acctHtml += "	<div class='bank"+getBankImgCd(v.BANK_CD)+"'>"+avatar.common.null2void(v.BANK_NM);
					if(v.CERT_EXP == "Y"){
						acctHtml += "<span class='ic_cerStopInfo'><em class='blind'></em></span>";
					}
					acctHtml += "</div>"
					acctHtml += "	<div class='right'><a class='off'>관리하기</a></div>";
					acctHtml += "<div>";
					$(".data_wbx").append(acctHtml);
				});
			}else{
				fn_back();
			}
			$(".data_wbx").show();
		}
}
//계좌 등록 후 돌아 왔을 시 콜백
function fn_acct_reg_cmpl(){
	location.href = "acct_0004_01.act";
	//_thisPage.searchData();
	
}
function getBankImgCd(bank_cd) {
	var imgCd = "";
	if(bank_cd == "003")
		imgCd = "001";
	else if(bank_cd == "004")
		imgCd = "002";
	else if(bank_cd == "088")
		imgCd = "003";
	else if(bank_cd == "020")
		imgCd = "004";
	else if(bank_cd == "031")
		imgCd = "005";
	else if(bank_cd == "011" || bank_cd == "012")
		imgCd = "006";
	else if(bank_cd == "027")
		imgCd = "007";
	else if(bank_cd == "023")
		imgCd = "008";
	else if(bank_cd == "081")
		imgCd = "009";
	else if(bank_cd == "002")
		imgCd = "010";
	else if(bank_cd == "007")
		imgCd = "011";
	else if(bank_cd == "032")
		imgCd = "012";
	else if(bank_cd == "034")
		imgCd = "013";
	else if(bank_cd == "035")
		imgCd = "014";
	else if(bank_cd == "037")
		imgCd = "015";
	else if(bank_cd == "039")
		imgCd = "016";
	else if(bank_cd == "045")
		imgCd = "017";
	else if(bank_cd == "048")
		imgCd = "018";
	else if(bank_cd == "071")
		imgCd = "019";
	return imgCd;
}

function fn_back(){
	iWebAction("closePopup",{_callback:"fn_popCallback"});
}
function fn_popCallback(){
	_thisPage.onload();
}
