/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_0000_04.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20210512143952, 김별
 * </pre>
 **/

$(function(){
	iWebAction("changeTitle",{"_title" : "질의", "_type" : "2"});
	$(document).on("click", ".btn_rolling li p", function(){
		var jexAjax = jex.createAjaxUtil("ques_0000_04_u001"); // PT_ACTION
		jexAjax.set("QUES_DV", $(this).data("ques_dv"));
		jexAjax.execute(function(data) {
			if(data.RSLT_CD == "0000"){
				if(Object.keys(inteInfo).length==0){
					iWebAction("fn_main");
				} else{
					var INTE_INFO ="{'recog_txt':'"+inteInfo.recog_txt+"','recog_data' : {'Intent':'"+inteInfo.recog_data["Intent"]+"','appInfo' : "+JSON.stringify(inteInfo.recog_data["appInfo"])+"} }" ;
					const url = "ques_comm_01.act?INTE_INFO="+INTE_INFO;
					iWebAction("openPopup",{"_url" : url});
				}
			} else {
				alert("처리 중 오류가 발생하였습니다.");
			}
		});
		
	})
})

function fn_back(){
	iWebAction("fn_main");
	iWebAction("closePopup");
}
function fn_popCallback2(){
	fn_back();
}