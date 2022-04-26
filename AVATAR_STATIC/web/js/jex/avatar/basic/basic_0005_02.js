/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0005_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 김태훈 (  )
 * @Description    : 경리나라 연결하기 완료 화면
 * @History        : 20200603150653, 김태훈
 * </pre>
 **/
$(function(){
	iWebAction("changeTitle",{"_title" : "경리나라 연결하기","_type" : "4"});
	//확인버튼
	$("#a_enter").on("click",function(){
		fn_back();
	});
});

//백버튼
function fn_back(){
	if($("#RSLT_CD").val() == "0000"){
		iWebAction("closePopup",{_callback:"fn_popCallback"});
	} else {
		iWebAction("closePopup",{_callback:"fn_popCallback2"});
	}
	/*var referrer = $("#REFERRER").val(); 
	if(referrer.indexOf("ques_0001_03.act")>-1 && $("#RSLT_CD").val() == "0000"){
		
	} else {
		
	}*/
//	location.href="basic_0005_01.act";
}