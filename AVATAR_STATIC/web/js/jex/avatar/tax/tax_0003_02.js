/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : tax_0003_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/tax
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200120161648, 김별
 * </pre>
 **/
$(function(){
	if($("#BILL_TYPE").val() == "1")
		iWebAction("changeTitle",{"_title" : "증빙상세", "_type" : "2"});
	else if($("#BILL_TYPE").val() == "2")
		iWebAction("changeTitle",{"_title" : "증빙상세", "_type" : "2"});
	_thisPage.onload();
	
	//mic button
	$(document).on('click', '.btn_mic', function(){
		$(".m_cont").css("display", "none");
		iWebAction("fn_voice_recog", {"_callback":"fn_voice_recog_result", "_cancel_callback":"fn_cancel"});
	});
});

var _thisPage = {
		onload : function(){
			_thisPage.searchData();
			
		},
		searchData : function(){
			var input = {};
			input["BILL_TYPE"]	= $("#BILL_TYPE").val();
			input["ISSU_ID"]	= $("#ISSU_ID").val();
			avatar.common.callJexAjax("tax_0003_02_r001", input, _thisPage.fn_callback, "true", "");
			
		},
		updateData : function(intent, ctt){
			var input = {};
			input["INTE_CD"] = intent;		//fn_voice_recog_result 에서 인텐트 코드 가져오기
			input["QUES_CTT"] = ctt;
			avatar.common.callJexAjax("ques_0001_01_u001", input,"", "", "");
		},
		fn_callback : function(data){
			if(data.REC.length == 0){
				$(".data_y").hide();
				$(".data_n").show();
			} else{
				$("table:eq(0) .break").html(data.REC[0].ISSU_ID);
				$(".txbl_tb_layout .b_no:eq(0)").html(avatar.common.corpno_format(data.REC[0].SELR_CORP_NO));
				$(".txbl_tb_layout .b_no:eq(1)").html(avatar.common.corpno_format(data.REC[0].BUYR_CORP_NO));
				$(".txbl_tb_layout .b_cd:eq(0)").html(data.REC[0].SELR_CODE);
				$(".txbl_tb_layout .b_cd:eq(1)").html(data.REC[0].BUYR_CODE);
				
				$(".txbl_tb_layout tr:eq(2) td div:eq(0)").html(data.REC[0].SELR_CORP_NM);
				$(".txbl_tb_layout tr:eq(2) td div:eq(1)").html(data.REC[0].SELR_CEO);
				$(".txbl_tb_layout tr:eq(2) td div:eq(2)").html(data.REC[0].BUYR_CORP_NM);
				$(".txbl_tb_layout tr:eq(2) td div:eq(3)").html(data.REC[0].BUYR_CEO);
				
				$(".txbl_tb_layout tr:eq(3) td div:eq(0)").html(data.REC[0].SELR_ADDR);
				$(".txbl_tb_layout tr:eq(3) td div:eq(1)").html(data.REC[0].BUYR_ADDR);
				
				$(".txbl_tb_layout tr:eq(4) td div:eq(0)").html(data.REC[0].SELR_BUSS_CONS);
				$(".txbl_tb_layout tr:eq(4) td div:eq(1)").html(data.REC[0].SELR_BUSS_TYPE);
				$(".txbl_tb_layout tr:eq(4) td div:eq(2)").html(data.REC[0].BUYR_BUSS_CONS);
				$(".txbl_tb_layout tr:eq(4) td div:eq(3)").html(data.REC[0].BUYR_BUSS_TYPE);
				
				$(".txbl_tb_layout tr:eq(5) td div:eq(0)").html(data.REC[0].SELR_CHRG_EMAIL);
				$(".txbl_tb_layout tr:eq(5) td div:eq(1)").html(data.REC[0].BUYR_CHRG_EMAIL1);
				$(".txbl_tb_layout tr:eq(6) td div:eq(0)").html(data.REC[0].BUYR_CHRG_EMAIL2);
				
				$(".txbl_trans1:eq(1) td:eq(0)").html(avatar.common.date_format(data.REC[0].WRTG_DT));
				$(".txbl_trans1:eq(1) td:eq(1)").html(avatar.common.comma(data.REC[0].SPLY_TOTL_AMT, true));
				$(".txbl_trans1:eq(1) td:eq(2)").html(avatar.common.comma(data.REC[0].TAX_AMT, true));
				$(".txbl_trans1:eq(1) td:eq(3)").html(data.REC[0].MODY_CODE);
				var rmrk2="";
				var rmrk3="";
				if(avatar.common.null2void(data.REC[0].RMRK2) != "")
					rmrk2 = ", "+data.REC[0].RMRK2;
				if(avatar.common.null2void(data.REC[0].RMRK2) != "")
					rmrk3 = ", "+data.REC[0].RMRK2;
				$(".txbl_trans1:eq(1) td:eq(4)").html(data.REC[0].RMRK1 + rmrk2 + rmrk3);
				
				$(".txbl_trans1:eq(3) .space40").html(data.REC[0].POPS_CODE);
				
				$(".txbl_trans1:eq(3) td:eq(1) div").html(avatar.common.comma(data.REC[0].TOTL_AMT,true));
				$(".txbl_trans1:eq(3) td:eq(2) div").html(avatar.common.comma(data.REC[0].PAMT_AMT1,true));
				$(".txbl_trans1:eq(3) td:eq(3) div").html(avatar.common.comma(data.REC[0].PAMT_AMT2,true));
				$(".txbl_trans1:eq(3) td:eq(4) div").html(avatar.common.comma(data.REC[0].PAMT_AMT3,true));
				$(".txbl_trans1:eq(3) td:eq(5) div").html(avatar.common.comma(data.REC[0].PAMT_AMT4,true));
				
				$.each(data.REC_DT, function(idx, rec){
					html ='';
					html += '<tr>';
					html += '	<td class="tac"><div>'+avatar.common.null2void(rec.TRNS_DT).substr(0,2)+'</div></td>';
					html += '	<td class="tac"><div>'+avatar.common.null2void(rec.TRNS_DT).substr(2,2)+'</div></td>';
					html += '	<td class="tal"><div>'+avatar.common.null2void(rec.ITEM_NM)+'</div></td>';
					html += '	<td class="tac"><div>'+avatar.common.null2void(rec.ITEM_INFM)+'</div></td>';
					html += '	<td class="tac"><div>'+avatar.common.null2void(rec.ITEM_QUNT)+'</div></td>';
					html += '	<td class="tar"><div>'+avatar.common.comma(avatar.common.null2void(rec.UNIT_PRCE),true)+'</div></td>';
					html += '	<td class="tar"><div>'+avatar.common.comma(avatar.common.null2void(rec.SPLY_AMT),true)+'</div></td>';
					html += '	<td class="tar"><div>'+avatar.common.comma(avatar.common.null2void(rec.ITEM_TAX),true)+'</div></td>';
					html += '	<td class="tac"><div></div></td>';
					html += '</tr>';
					
					$(".txbl_trans1:eq(2) tr:eq(0)").after(html);
				})
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
			
		}
		
}


/* Webaction callbackFun */
function fn_back(){
	iWebAction("closePopup");
	history.back();
}
function fn_voice_recog_result(data){
	var INTE_INFO = data;
	var url = "ques_comm_01.act?INTE_INFO="+INTE_INFO;
	iWebAction("openPopup",{"_url" : url});
	
	$(".m_cont").css("display", "block");
}

function fn_cancel(){
	$(".m_cont").css("display", "block");
}