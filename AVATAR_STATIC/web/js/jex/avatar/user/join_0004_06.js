/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : join_0004_06.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/user
 * @author         : 박지은 (  )
 * @Description    : 본인확인서비스 이용약관
 * @History        : 20210415170027, 박지은
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