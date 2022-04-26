/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : join_0004_08.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/user
 * @author         : 박지은 (  )
 * @Description    : 고유식별정보처리 동의
 * @History        : 20210415170220, 박지은
 * </pre>
 **/
$(function(){
	iWebAction("changeTitle",{"_title" : "통신사 이용약관", "_type" : "2"});
	$(document).on("click", ".btn_w3", function(){
		fn_back();
	})
});
function fn_back(){
	iWebAction("closePopup");
}