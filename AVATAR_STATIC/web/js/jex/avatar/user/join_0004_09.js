/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : join_0004_09.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/user
 * @author         : 김별 (  )
 * @Description    : 회원가입_약관동의(5.경리나라-개인(신용)정보수집이용동의)
 * @History        : 20210414153124, 김별
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