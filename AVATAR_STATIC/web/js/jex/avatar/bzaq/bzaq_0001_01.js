/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : bzaq_0001_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/bzaq
 * @author         : 김별 (  )
 * @Description    : 거래처 목록 화면
 * @History        : 20200211085546, 김별
 * </pre>
 **/
var pageno = 1;
var pagecnt = 30;
var totlcnt = 0;
$(function(){
	iWebAction("changeTitle",{"_title" : "거래처", "_type" : "2"});
	_thisPage.onload();
	$("#cmdSearch").click(function(){
		pageno = 1;
		pagecnt = 30;
		$(".m_info_bx ul").empty();
		_thisPage.searchData();
	});
	//mic button
	$(document).on('click', '.btn_mic', function(){
		$(".m_cont").css("display", "none");
		iWebAction("fn_voice_recog", {"_callback":"fn_voice_recog_result", "_cancel_callback":"fn_cancel"});
	});
	$(document).on("click", ".m_info_bx li", function(){
		var url = "ques_comm_01.act?INTE_INFO={'recog_txt':'"+$(this).find('span').text()+"','recog_data' : {'Intent':'ASP001','appInfo' : {'NE-COUNTERPARTNAME' : '"+$(this).find('span').text()+"'}} }";
		//bzaq_0001_02.act?BZAQ_NO=0002
		iWebAction("openPopup", {"_url":url});
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
			input["SRCH_WD"]	= $(".SRCH_WD").val();
			avatar.common.callJexAjax("bzaq_0001_01_r001", input, _thisPage.fn_callback, "true", "");
			
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
				/*$(".data_y").hide();
				$(".data_n").show();*/
			} else{
				$.each(dat.REC, function(idx, rec){
					html = '';
					html += '<li><span class="txt elipsis" bzaqNo='+rec.BZAQ_NO+'>'+rec.BZAQ_NM+'</span><a class="btn"></a></li>';
					$(".m_info_bx ul").append(html);
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
	//iWebAction("closePopup", {"_callback" : "fn_back"});
	iWebAction("closePopup");
	/*history.back();*/
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