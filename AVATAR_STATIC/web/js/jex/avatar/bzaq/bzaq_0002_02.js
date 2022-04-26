/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : bzaq_0002_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/bzaq
 * @author         : 김별 (  )
 * @Description    : 연락처 상세 조회
 * @History        : 20200213162255, 김별
 * </pre>
 **/
$(function(){
	iWebAction("changeTitle",{"_title" : "연락처 상세", "_type" : "2"});
	_thisPage.onload();
	
	//mic button
	$(document).on('click', '.btn_mic', function(){
		$(".m_cont").css("display", "none");
		iWebAction("fn_voice_recog", {"_callback":"fn_voice_recog_result", "_cancel_callback":"fn_cancel"});
	});
	$(document).on("click", "tbody tr:eq(1) td", function(){
		iWebAction("phoneCall",{"_type" : "1", "_phone_num" : $(this).text().replace(/-/g, "")});
	});
	$(document).on("click", "tbody tr:eq(0) td", function(){
		if($(this).text() == "")
			return;
		else
			iWebAction("phoneCall",{"_type" : "1", "_phone_num" : $(this).text().replace(/-/g, "")});
	});
});

var _thisPage = {
		onload : function(){
			_thisPage.searchData();
		},
		searchData : function(){
			var input = {};
			input["CNPL_NO"] = $("#CNPL_NO").val();
			avatar.common.callJexAjax("bzaq_0002_02_r001", input, _thisPage.fn_callback, "true", "");
			
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
			namehtml = '';
			namehtml += '<span class="elipsis">'+data.REC[0].CNPL_NM+'</span>';
			$(".left .tit").html(namehtml);
			
			contenthtml = '';
			contenthtml +='<tr>';
			contenthtml +='	<th>집</th>';
			contenthtml +='	<td>'+avatar.common.phoneFomatter(avatar.common.null2void(data.REC[0].BIZ_TEL_NO))+'</td>';
			contenthtml +='</tr>';
			contenthtml +='<tr>';
			contenthtml +='	<th>핸드폰</th>';
			contenthtml +='	<td>'+avatar.common.phoneFomatter(avatar.common.null2void(data.REC[0].CLPH_NO))+'</td>';
			contenthtml +='</tr>';
			contenthtml +='<tr>';
			contenthtml +='	<th>주소</th>';
			contenthtml +='	<td>'+avatar.common.null2void(data.REC[0].ADRS)+'</td>';
			contenthtml +='</tr>';
			contenthtml +='<tr>';
			contenthtml +='	<th>메모</th>';
			contenthtml +='	<td>'+avatar.common.null2void(data.REC[0].MEMO)+'</td>';
			contenthtml +='</tr>';
			$(".list_dv_tbl tbody").html(contenthtml);
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

function fn_back(){
	iWebAction("closePopup");
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