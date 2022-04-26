/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : tax_0001_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/tax
 * @author         : 박지은 (  )
 * @Description    : 홈텍스실시간조회 화면
 * @History        : 20210120162450, 박지은
 * </pre>
 **/
$(function(){
	iWebAction("changeTitle",{"_title" : "홈택스 가져오기","_type" : "2"});
	// 확인버튼
	$("#a_enter").on("click",function(){
		fn_back();
	});
});

//백버튼?
function fn_back(){
	//성공
	iWebAction("closePopup",{_callback:"fn_popCallback"});
}