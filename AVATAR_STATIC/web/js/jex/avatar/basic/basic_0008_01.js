/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0008_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 김별 (  )
 * @Description    : FAQ 화면
 * @History        : 20210121101120, 김별
 * </pre>
 **/
var totlcnt = 0;
var pageno = 1;
var pagecnt = 15;
$(function(){
	_thisPage.onload();
	iWebAction("changeTitle",{"_title" : "FAQ","_type" : "2"});
	$(document).on("click", ".togle_list dt", function(){
		if($(this).closest("dl").hasClass("on")){
			$(this).closest("dl").removeClass("on");			
		} else{
			$(this).closest("dl").addClass("on");
		}
	});

	$(".sch_bx_in").find("input[type=text]").keydown(function (key) {
		if(key.keyCode == 13){
			_thisPage.onload();
		}
    });

	$(window).scroll(function() {
	    if (Math.floor($(window).scrollTop())+5 >= Math.floor($(document).height() - $(window).height())) {
	    	if((pageno)*pagecnt < totlcnt){	
	    		pageno++;
	    		_thisPage.searchData();
	    	}
	    }
	  });
});

var _thisPage = {
		onload: function(){
			_thisPage.searchData($(".sch_bx_in").find("input[type=text]").val());
		},
		searchData : function(srch_wd){
			if(srch_wd){
				pageno = 1;
				$(".togle_list").empty();
			}
			var jexAjax = jex.createAjaxUtil("basic_0006_01_r001");   //PT_ACTION 웹 서비스 호출
			input = {};
			input["BLBD_DIV"] = "03";
			input["SRCH_WD"]  = srch_wd;
			input["PAGE_NO"] = pageno;
			input["PAGE_CNT"] = pagecnt;
			jexAjax.set(input);
			jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
			jexAjax.execute(function(dat) {
				console.log(dat);
				totlcnt = dat.CNT;
				//$(".togle_list").empty();
				if(dat.REC.length > 0){
					
					var tempHtml;
					$.each(dat.REC, function(idx, rec){
						if(rec.BLBD_TITL.indexOf(srch_wd) > -1){
							rec.BLBD_TITL = rec.BLBD_TITL.replaceAll(srch_wd, '<span class="c_blue">'+srch_wd+'</span>');
						}
						tempHtml = "";
						tempHtml += "<dl> <!-- 열고/닫기 class='on' 제어 -->";
						tempHtml += "	<dt><em class='tx_tit' style='/* width:100%; */white-space: pre-line;word-break: break-word;'>["+rec.BLBD_CTGR_NM+"] </em>"+rec.BLBD_TITL+"</dt>";
						tempHtml += "	<dd  style='/* width:100%; */white-space: pre-line;word-break: break-word;'>"+rec.BLBD_CTT+"</dd>";
						tempHtml += "</dl>";
						
						$(".togle_list").append(tempHtml);
					});
					$(".notibx_wrap").hide();
				} else {
					$(".notibx_wrap").show();
				}
			});
		}
		
}
function fn_back(){
	if($(".sch_bx_in").find("input[type=text]").val() != ""){
		$(".sch_bx_in").find("input[type=text]").val('');
		_thisPage.searchData();
	} else {
		iWebAction("closePopup");
	}
}
