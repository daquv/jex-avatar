/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : bzaq_0002_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/bzaq
 * @author         : 김별 (  )
 * @Description    : 연락처 목록 화면
 * @History        : 20200213152738, 김별
 * </pre>
 **/
var pageno = 1;
var pagecnt = 15;
var totlcnt = 0;
$(function(){
	iWebAction("changeTitle",{"_title" : "연락처", "_type" : "2"});
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
	$(document).on("click", ".m_info_bx li span", function(){
		var url = "bzaq_0002_02.act?CNPL_NO="+$(this).attr("cnplNo");
		iWebAction("openPopup", {"_url":url});
	});
	$(document).on("click", ".phone", function(){
		iWebAction("phoneCall",{"_type" : "1", "_phone_num" : $(this).parent().find(".txt").attr("clphno")});
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
			/*alert("paging test2 { \n window.scrolltop :: "+$(window).scrollTop()+", \n document height :: "+$(document).height()+", \n window height :: "+ $(window).height()+" \n }");*/
			var input = {};
			input["PAGE_NO"]	= pageno;
			input["PAGE_CNT"]	= pagecnt;
			input["SRCH_WD"]	= $(".SRCH_WD").val();
			avatar.common.callJexAjax("bzaq_0002_01_r001", input, _thisPage.fn_callback, "true", "");
			
		},
		fn_callback : function(dat){
			totlcnt = dat.TOTL_CNT;
			if(dat.TOTL_CNT == 0){
/*				$(".data_y").hide();
				$(".data_n").show();*/
			} else{
				$.each(dat.REC, function(idx, rec){
					html = '';
					html += '<li><span class="txt elipsis"  cnplNo='+rec.CNPL_NO+' clphNo = '+rec.CLPH_NO+'>'+rec.CNPL_NM+'</span><a class="btn phone" ></a></li>';
					$(".m_info_bx ul").append(html);
				});
			}
		},
		
}

function fn_back(){
	iWebAction("closePopup");
}
function fn_cancel(){
	$(".m_cont").css("display", "block");
}