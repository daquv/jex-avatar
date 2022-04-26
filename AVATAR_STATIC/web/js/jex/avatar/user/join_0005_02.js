/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : join_0005_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/user
 * @author         : 김별 (  )
 * @Description    : 회원가입_약관동의(2.ASKAVATAR-개인정보수집및이용동의)v3
 * @History        : 20211022131947, 김별
 * </pre>
 **/
$(function(){
	iWebAction("changeTitle",{"_title" : "이용약관", "_type" : "2"});
	
	$(document).on("click", ".btn_w3", function(){
		fn_back();
	})
	
	$(document).on("click", ".servTermGo:eq(0)", function(){
		location.href= "join_0004_02.act";
	})
	$(document).on("click", ".servTermGo:eq(1)", function(){
		location.href= "join_0002_02.act";
	})
});
function fn_back(){
	iWebAction("closePopup");
}