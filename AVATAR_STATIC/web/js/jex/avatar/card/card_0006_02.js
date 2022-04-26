/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : card_0006_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/card
 * @author         : 박지은 (  )
 * @Description    : 카드승인실시간조회 화면
 * @History        : 20210125091430, 박지은
 * </pre>
 **/
$(function(){
	iWebAction("changeTitle",{"_title" : "카드매입 가져오기","_type" : "2"});
	// 확인버튼
	$("#a_enter").on("click",function(){
		fn_back();
	});
});

//백버튼
function fn_back(){
	iWebAction("closePopup",{_callback:"fn_popCallback"});
}