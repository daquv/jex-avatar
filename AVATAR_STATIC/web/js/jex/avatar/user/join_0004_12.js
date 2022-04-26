/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : join_0004_12.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/user
 * @author         : 박지은 (  )
 * @Description    : 회원가입_약관동의(제로페이 개인정보 수집 및 이용 동의)
 * @History        : 20210908165350, 박지은
 * </pre>
 **/
$(function(){
	iWebAction("changeTitle",{"_title" : "이용약관", "_type" : "2"});
	$(document).on("click", ".btn_w3", function(){
		fn_back();
	})
});
function fn_back(){
	iWebAction("closePopup");
}