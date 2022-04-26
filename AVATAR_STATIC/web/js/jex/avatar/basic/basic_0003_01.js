/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0003_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 김별 (  )
 * @Description    : 데이터_데이터목록화면
 * @History        : 20200129105915, 김별
 * </pre>
 **/


/*UNFINISHED TASKS
* 1. 
* 2. 
*/

$(function(){
	iWebAction("changeTitle",{"_title" : "데이터", "_type" : "2"});
	_thisPage.onload();
	//mic button
	$(document).on('click', '.btn_mic', function(){
		$(".m_cont").css("display", "none");
		iWebAction("fn_voice_recog", {"_callback":"fn_voice_recog_result", "_cancel_callback":"fn_cancel"});
	});

	$(document).on("click", ".mn1", function(){
		iWebAction("openPopup", {"_url": "basic_0003_02.act"});
	});
	$(document).on("click", ".mn2", function(){
		iWebAction("openPopup", {"_url": "basic_0003_03.act"})
	});
	$(document).on("click", ".mn3", function(){
		iWebAction("openPopup", {"_url": "basic_0003_04.act"})
	});
	$(document).on("click", ".mn4", function(){
		iWebAction("openPopup", {"_url": "bzaq_0001_01.act"})
	});
	$(document).on("click", ".mn5", function(){
		iWebAction("openPopup", {"_url": "bzaq_0002_01.act"})
	});
	
	/*
	//데이터 가져오기
	$(document).on('click', '.c_blue', function(){
		location.href="basic_0002_01.act";
	})
	//계좌
	$(document).on('click', 'li:eq(0) .sub .card', function(){
		if($(this).find(".c_blue").is('visible')==true){
			return false;
		} else{
			var url = "acct_0002_01.act?BANK_CD="+$(this).attr("BANK_CD")+"&FNNC_UNQ_NO="+$(this).attr("FNNC_UNQ_NO")+"&BANK_NM="+$(this).attr("BANK_NM")+"&FNNC_INFM_NO="+$(this).attr("FNNC_INFM_NO");
			iWebAction("openPopup",{"_url":url});
			//location.href="acct_0002_01.act?BANK_CD="+$(this).attr("BANK_CD")+"&FNNC_UNQ_NO="+$(this).attr("FNNC_UNQ_NO")+"&BANK_NM="+$(this).attr("BANK_NM")+"&FNNC_INFM_NO="+$(this).attr("FNNC_INFM_NO");
		}
		
	});
	//매출세금계산서
	$(document).on('click', 'li:eq(1) .sub .card:eq(0)', function(){
		if($(this).find(".c_blue").is(':visible')==true){
			return false;
		} else{
			var url = "tax_0003_01.act?BILL_TYPE=1";
			iWebAction("openPopup",{_url:url});
			//location.href="tax_0003_01.act?BILL_TYPE=1";
		}
	});
	//매출카드
	$(document).on('click', 'li:eq(1) .sub .card:eq(1)', function(){
		if($(this).find(".c_blue").is(':visible')==true){
			return false;
		} else{
			var url = "card_0001_01.act";
			iWebAction("openPopup",{_url:url});
			//location.href="card_0001_01.act";
		}
	});
	//매출현금영수증
	$(document).on('click', 'li:eq(1) .sub .card:eq(2)', function(){
		if($(this).find(".c_blue").is(':visible')==true){
			return false;
		} else{
			var url = "tax_0005_01.act";
			iWebAction("openPopup",{_url:url});
		}
	});
	//매입세금계산서
	$(document).on('click', 'li:eq(2) .sub .card:eq(0)', function(){
		if($(this).find(".c_blue").is(':visible')==true){
			return false;
		} else{
			//location.href="tax_0003_01.act?BILL_TYPE=2";
			var url = "tax_0003_01.act?BILL_TYPE=2";
			iWebAction("openPopup",{_url:url});
		}
	});
	//매입카드
	$(document).on('click', 'li:eq(2) .sub .card:eq(1)', function(){
		if($(this).find(".c_blue").is(':visible')==true){
			return false;
		} else{
			var url = "card_0002_01.act";
			iWebAction("openPopup",{_url:url});
		}
	});
	//매입현금영수증
	$(document).on('click', 'li:eq(2) .sub .card:eq(2)', function(){
		if($(this).find(".c_blue").is(':visible')==true){
			return false;
		} else{
			var url = "tax_0006_01.act";
			iWebAction("openPopup",{_url:url});
		}
	});
	//거래처
	$(document).on('click', 'li:eq(3)', function(){
		if($(this).find(".c_blue").is(':visible')==true){
			return false;
		} else{
			var url = "bzaq_0001_01.act";
			iWebAction("openPopup",{_url:url});
			//location.href="bzaq_0001_01.act";
		}
	});
	//연락처
	$(document).on('click', 'li:eq(4)', function(){
		if($(this).find(".c_blue").is(':visible')==true){
			return false;
		} else{
			var url = "bzaq_0002_01.act";
			iWebAction("openPopup",{_url:url});
			//location.href="bzaq_0002_01.act";
		}
	});
	*/
	//
});

var _thisPage = {
		onload : function(){
			_thisPage.searchData();
		},
		searchData : function(){
			avatar.common.callJexAjax("basic_0003_01_r001", "", _thisPage.fn_callback, "false", "c");
		},
		updateData : function(intent, ctt){
			//use_cnt +1
			//use_hstr에 질의 내역 추가
			var input = {};
			input["INTE_CD"] = intent;		//fn_voice_recog_result 에서 인텐트 코드 가져오기
			input["QUES_CTT"] = ctt;
			avatar.common.callJexAjax("ques_0001_01_u001", input,"", "", "");
		},
		fn_callback : function(data){
			console.log(data);
			//계좌
			if(data.REC.length>0){
				$("li:eq(0)").find(".right:eq(0)").hide();
				$("li:eq(0)").find(".sub").show();
				var acctHtml = '';
				$.each(data.REC, function(i,v){
					acctHtml +='<div class="card" BANK_NM = "'+v.BANK_NM+'" BANK_CD="'+avatar.common.null2void(v.BANK_CD)+'" FNNC_UNQ_NO="'+avatar.common.null2void(v.FNNC_UNQ_NO)+'" FNNC_INFM_NO="'+avatar.common.null2void(v.FNNC_INFM_NO)+'">';
					acctHtml +='	<h2>'+avatar.common.null2void(v.BANK_NM)+' '+avatar.common.null2void(v.FNNC_INFM_NO)+'</h2>';
					acctHtml +='	<div class="right">';
					acctHtml +='		<a class="btn_arr"></a>';
					acctHtml +='	</div>';
					acctHtml +='</div>';
				});
				$("li:eq(0)").find(".sub").html(acctHtml);
			}
			//현금영수증, 세금계산서
			if(data.REC_CNT[0].TAX_CNT>0){
				$("li:eq(1) .sub .card:eq(0) .c_gr").removeClass('c_gr');
				$("li:eq(1) .sub .card:eq(0) .c_blue").hide();
				$("li:eq(1) .sub .card:eq(0) .btn_arr").show();
				
				$("li:eq(1) .sub .card:eq(2) .c_gr").removeClass('c_gr');
				$("li:eq(1) .sub .card:eq(2) .c_blue").hide();
				$("li:eq(1) .sub .card:eq(2) .btn_arr").show();
				
				$("li:eq(2) .sub .card:eq(0) .c_gr").removeClass('c_gr');
				$("li:eq(2) .sub .card:eq(0) .c_blue").hide();
				$("li:eq(2) .sub .card:eq(0) .btn_arr").show();
				
				$("li:eq(2) .sub .card:eq(2) .c_gr").removeClass('c_gr');
				$("li:eq(2) .sub .card:eq(2) .c_blue").hide();
				$("li:eq(2) .sub .card:eq(2) .btn_arr").show();
			}
			if(data.REC_CNT[0].SALE_CNT>0){
				$("li:eq(1) .sub .card:eq(1) .c_gr").removeClass('c_gr');
				$("li:eq(1) .sub .card:eq(1) .c_blue").hide();
				$("li:eq(1) .sub .card:eq(1) .btn_arr").show();
			}
			//카드매입
			if(data.REC_CNT[0].CARD_CNT>0){
				$("li:eq(2) .sub .card:eq(1) .c_gr").removeClass('c_gr');
				$("li:eq(2) .sub .card:eq(1) .c_blue").hide();
				$("li:eq(2) .sub .card:eq(1) .btn_arr").show();
			}
			//거래처
			if(data.REC_CNT[0].BZAQ_CNT>0){
				$("li:eq(3) .card .c_blue").hide();
				$("li:eq(3) .card .btn_arr").show();
			}
			//연락처
			if(data.REC_CNT[0].CNPL_CNT>0){
				$("li:eq(4) .card .c_blue").hide();
				$("li:eq(4) .card .btn_arr").show();
			}
		},
		pageMove : function(intent, appinfo){
			var jexAjax = jex.createAjaxUtil("ques_0001_02_r001"); // PT_ACTION
			jexAjax.set("INTE_CD", intent);
			var NE_DAY = avatar.common.null2void(appinfo["NE-DAY"]);
			var NE_BMONTH = avatar.common.null2void(appinfo["NE-B-Month"]);
			var NE_BDAY = avatar.common.null2void(appinfo["NE-B-date"]);
			var NE_COUNTERPARTNAME = avatar.common.null2void(appinfo["NE-COUNTERPARTNAME"]);
			jexAjax.execute(function(data) {
				if(avatar.common.null2void(data.RSLT_PAGE_URL)==""){
					var url =  "ques_0000_01.act";
					iWebAction("openPopup",{"_url" : url});
					//location.href = "ques_0000_01.act";
				}
				else{
					var url = data.RSLT_PAGE_URL+"?NE_DAY="+NE_DAY+"&NE_BMONTH="+NE_BMONTH+"&NE_BDAY="+NE_BDAY+"&NE_COUNTERPARTNAME="+NE_COUNTERPARTNAME;
					iWebAction("openPopup",{"_url" : url});
					//location.href = data.RSLT_PAGE_URL+"?NE_DAY="+NE_DAY+"&NE_BMONTH="+NE_BMONTH+"&NE_BDAY="+NE_BDAY+"&NE_COUNTERPARTNMAE="+NE_COUNTERPARTNAME;
				}
					
			});
			
		},
}

function fn_cancel(){
	$(".m_cont").css("display", "block");
}
function fn_back(){
	iWebAction("closePopup");
	//iWebAction("fn_app_finish");
}
function fn_voice_recog_result(data){
	var INTE_INFO = data;
	var url = "ques_comm_01.act?INTE_INFO="+INTE_INFO;
	iWebAction("openPopup",{"_url" : url});
	
	$(".m_cont").css("display", "block");
}