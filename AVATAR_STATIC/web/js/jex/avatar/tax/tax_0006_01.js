/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : tax_0006_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/tax
 * @author         : 김별 (  )
 * @Description    : 데이터_매입현금영수증목록화면
 * @History        : 20200131165208, 김별
 * </pre>
 **/
var pageno = 1;
var pagecnt = 30;
var totlcnt = 0;
var lastdate='';
var index = -1;
$(function(){iWebAction("changeTitle",{"_title" : "매입현금영수증", "_type" : "2"});
	_thisPage.onload();
	//mic button
	$(document).on('click', '.btn_mic', function(){
		$(".m_cont").css("display", "none");
		iWebAction("fn_voice_recog", {"_callback":"fn_voice_recog_result", "_cancel_callback":"fn_cancel"});
	});
	
	$(window).scroll(function() {
	    if (Math.floor($(window).scrollTop())+2 >= Math.floor($(document).height() - $(window).height())) {
	    	if((pageno)*pagecnt < totlcnt){	
	    		pageno++;
	    		_thisPage.searchData();
	    	}
	    }
	  });
});

var _thisPage = {
		onload : function(){
			_thisPage.searchData();
		},
		searchData : function(){
			var input = {};
			input["PAGE_NO"]	= pageno;
			input["PAGE_CNT"]	= pagecnt;
			avatar.common.callJexAjax("tax_0006_01_r001", input, _thisPage.fn_callback, "true", "");
			
		},
		updateData : function(intent, ctt){
			var input = {};
			input["INTE_CD"] = intent;		//fn_voice_recog_result 에서 인텐트 코드 가져오기
			input["QUES_CTT"] = ctt;
			avatar.common.callJexAjax("ques_0001_01_u001", input,"", "", "");
		},
		fn_callback : function(dat){
			totlcnt = dat.TOTL_CNT;
			if(dat.TOTL_CNT == 0){
				$(".data_y").hide();
				$(".data_n").show();
			} else{
				/* 날짜별 */
				var trnsDt = [];
				var k = 0;
				trnsDt[0] = dat.REC[0].TRNS_DT;
				for(i=0; i<dat.REC.length-1 ; i++){
					
					if(dat.REC[i].TRNS_DT != dat.REC[i+1].TRNS_DT){
						trnsDt[i+1] = dat.REC[i+1].TRNS_DT;
					} else{
						trnsDt[i+1] = '';
					}
				}
				$.each(dat.REC, function(idx, rec){
					var tempHtml = '';
					var tempHtml2 = '';
					
					if(dat.REC[idx].TRNS_DT == trnsDt[idx] && lastdate != dat.REC[idx].TRNS_DT){
						tempHtml += '<tr class="row1">';
						tempHtml += '	<td colspan="3">';
						tempHtml += '		<div class="tbl_list type2">';
						tempHtml += '			<table id="temp">';
						tempHtml += '				<colgroup>';
						tempHtml += '					<col style="width:44px;"><col><col style="width:120px;">';
						tempHtml += '				</colgroup>';
						tempHtml += '				<tbody id="test">';
						tempHtml += '					<tr>';
						tempHtml += '						<th>'+ avatar.common.date_format2(rec.TRNS_DT).substring(5) +'</th>';
						tempHtml += '						<td><span class="elipsis">'+rec.MEST_NM+'('+rec.MEST_BIZ_NO.substr(rec.MEST_BIZ_NO.length-4, rec.MEST_BIZ_NO.length)+')</span></td>';
						tempHtml += '						<td class="won"><em>'+avatar.common.comma(rec.TOTL_AMT,true)+'</em>원</td>';
						tempHtml += '					</tr>';
						tempHtml += '			</table>';
						tempHtml += '		</div>';
						tempHtml += '	</td>';
						tempHtml += '</tr>';
						
						$(".tbl_list:eq(0)").find("tbody:eq(0)").append(tempHtml);
						index++;
					}
					else if(dat.REC[idx].TRNS_DT != trnsDt[idx] || lastdate == dat.REC[idx].TRNS_DT){
						tempHtml2 += '					<tr>';
						tempHtml2 += '						<th></th>';
						tempHtml2 += '						<td><span class="elipsis">'+rec.MEST_NM+'('+rec.MEST_BIZ_NO.substr(rec.MEST_BIZ_NO.length-4, rec.MEST_BIZ_NO.length)+')</span></td>';
						tempHtml2 += '						<td class="won"><em>'+avatar.common.comma(rec.TOTL_AMT,true)+'</em>원</td>';
						tempHtml2 += '					<tr>';
						
						$("tbody #test:eq("+(index)+")").append(tempHtml2);
					}
				});
				for(i=trnsDt.length-1; i>0; i--){
			        if(trnsDt[i] != ''){
			        	lastdate = trnsDt[i]
			            break;
			        }
			    }
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

/* Webaction callbackFun */
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