/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : acct_0002_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/acct
 * @author         : 김별 (  )
 * @Description    : 데이터_계좌거래내역화면
 * @History        : 20200116174911, 김별
 * </pre>
 **/
var pageno = 1;
var pagecnt = 30;
var totlcnt = 0;
$(function(){
	var title = $("#BANK_NM").val()+" "+$("#FNNC_INFM_NO").val();
	iWebAction("changeTitle",{"_title" : title, "_type" : "2"});
	_thisPage.onload();
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
			input["BANK_CD"]	=  $("#BANK_CD").val();
			input["FNNC_UNQ_NO"]	=  $("#FNNC_UNQ_NO").val();
			avatar.common.callJexAjax("acct_0002_01_r001", input, _thisPage.fn_callback, "true", "");
			
		},
		updateData : function(intent, ctt){
			//use_cnt +1
			//use_hstr에 질의 내역 추가
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
				$.each(dat.REC, function(idx, rec){
					if(rec.INOT_DSNC == '1')
						sign = 'c_blue';
					else if(rec.INOT_DSNC == '2')
						sign = 'c_red';
					var html = '';
					html +='<li>';
					html +='	<div class="left">';
					html +='		<span class="acc_tit">'+avatar.common.null2void(rec.SMR)+'</span>';
					html +='		<span class="acc_date">'+avatar.common.date_format2(rec.TRNS_DT)+' '+avatar.common.time_format(avatar.common.null2void(rec.TRNS_TIME))+'</span>';
					html +='	</div>';
					html +='	<div class="right">';
					html +='		<span class="acc_won"><em class="won '+sign+'">'+avatar.common.comma(rec.TRNS_AMT, true)+'</em>원</span>';
					html +='		<span class="acc_won type2"><span class="acc_tp">잔액</span><em class="won">'+avatar.common.comma(rec.BAL_AMT, true)+'</em>원</span>'
					html +='	</div>';
					html +='</li>';
					$(".row2").append(html);
				});
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

function fn_back(){
	iWebAction("closePopup");
	
}
function fn_voice_recog_result(data){
	var INTE_INFO = data;
	var url = "ques_comm_01.act?INTE_INFO="+INTE_INFO;
	alert(url);
	iWebAction("openPopup",{"_url" : url});
	
	$(".m_cont").css("display", "block");
}

function fn_cancel(){
	$(".m_cont").css("display", "block");
}