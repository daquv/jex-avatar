/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : tax_0003_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/tax
 * @author         : 김별 (  )
 * @Description    : 데이터_매출세금계산서목록화면
 * @History        : 20200120161605, 김별
 * </pre>
 **/
var pageno = 1;
var pagecnt = 30;
var totlcnt = 0;
var lastdate='';
var index = -1;
$(function(){
	if($("#BILL_TYPE").val() == "1")
		iWebAction("changeTitle",{"_title" : "매출(세금)계산서", "_type" : "2"});
	else if($("#BILL_TYPE").val() == "2")
		iWebAction("changeTitle",{"_title" : "매입(세금)계산서", "_type" : "2"});
	_thisPage.onload();

	//mic button
	$(document).on('click', '.btn_mic', function(){
		$(".m_cont").css("display", "none");
		iWebAction("fn_voice_recog", {"_callback":"fn_voice_recog_result", "_cancel_callback":"fn_cancel"});
	});
	
	//거래처명 클릭시 세금계산서 상세
	$(document).on('click', '.elipsis', function(){
		var url = "tax_0003_02.act?ISSU_ID="+$(this).parent().attr("issuid")+"&BILL_TYPE="+$("#BILL_TYPE").val();
		iWebAction("openPopup",
					{
						"_url" : url, 
						"_zoon_yn" : "Y"
					});
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
			input["BILL_TYPE"]	= $("#BILL_TYPE").val();
			avatar.common.callJexAjax("tax_0003_01_r001", input, _thisPage.fn_callback, "true", "");
			
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
					var WRTG_DT = [];
					var k = 0;
					WRTG_DT[0] = dat.REC[0].WRTG_DT;
					for(i=0; i<dat.REC.length-1 ; i++){
						if(dat.REC[i].WRTG_DT != dat.REC[i+1].WRTG_DT){
							WRTG_DT[i+1] = dat.REC[i+1].WRTG_DT;
						} else{
							WRTG_DT[i+1] = '';
						}
					}
					console.log(WRTG_DT);
					$.each(dat.REC, function(idx, rec){
						var tempHtml = '';
						var tempHtml2 = '';
						if(dat.REC[idx].WRTG_DT == WRTG_DT[idx] && lastdate != dat.REC[idx].WRTG_DT){
							tempHtml += '<tr class="row1">';
							tempHtml += '	<td colspan="3">';
							tempHtml += '		<div class="tbl_list type2">';
							tempHtml += '			<table id="temp">';
							tempHtml += '				<colgroup>';
							tempHtml += '					<col style="width:44px;"><col><col style="width:147px;">';
							tempHtml += '				</colgroup>';
							tempHtml += '				<tbody id="test">';
							tempHtml += '					<tr>';
							tempHtml += '						<th>'+ avatar.common.date_format2(rec.WRTG_DT).substring(5) +'</th>';
							if($("#BILL_TYPE").val() == "1")
								tempHtml += '						<td issuId='+rec.ISSU_ID+'><span class="elipsis">'+rec.BUYR_CORP_NM+'</span></td>';
							else if($("#BILL_TYPE").val() == "2")
								tempHtml += '						<td issuId='+rec.ISSU_ID+'><span class="elipsis">'+rec.SELR_CORP_NM+'</span></td>';
							tempHtml += '						<td class="won"><em>'+avatar.common.comma(rec.TOTL_AMT,true)+'</em>원</td>';
							tempHtml += '					</tr>';
							tempHtml += '			</table>';
							tempHtml += '		</div>';
							tempHtml += '	</td>';
							tempHtml += '</tr>';
							
							$(".tbl_list:eq(0)").find("tbody:eq(0)").append(tempHtml);
							index++;
						}
						else if(dat.REC[idx].WRTG_DT != WRTG_DT[idx] || lastdate == dat.REC[idx].WRTG_DT){
							tempHtml2 += '					<tr>';
							tempHtml2 += '						<th></th>';
							if($("#BILL_TYPE").val() == "1")
								tempHtml2 += '						<td issuId='+rec.ISSU_ID+'><span class="elipsis">'+rec.BUYR_CORP_NM+'</span></td>';
							else if($("#BILL_TYPE").val() == "2")
								tempHtml2 += '						<td issuId='+rec.ISSU_ID+'><span class="elipsis">'+rec.SELR_CORP_NM+'</span></td>';
							tempHtml2 += '						<td class="won"><em>'+avatar.common.comma(rec.TOTL_AMT,true)+'</em>원</td>';
							tempHtml2 += '					<tr>';
							/*if(avatar.common.null2void(WRTG_DT[idx],"") == ""){
								index++;
								if(lastdate == dat.REC[idx].WRTG_DT)
									console.log('next :: '+WRTG_DT[idx] + " " +dat.REC[idx].WRTG_DT+" value :: "+rec.SELR_CORP_NM);
								}*/
							$("tbody #test:eq("+(index)+")").append(tempHtml2);
						}
						
					});
					for(i=WRTG_DT.length-1; i>0; i--){
				        if(WRTG_DT[i] != ''){
				        	lastdate = WRTG_DT[i]
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
			
		}
}

/* Webaction callbackFun */
function fn_back(){
	//history.back();
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