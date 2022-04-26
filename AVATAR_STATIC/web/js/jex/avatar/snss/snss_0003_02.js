/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : snss_0003_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/snss
 * @author         : 박지은 (  )
 * @Description    : 온라인매출실시간조회 화면
 * @History        : 20210722151641, 박지은
 * </pre>
 **/
$(function(){
	iWebAction("changeTitle",{"_title" : "온라인매출 연결하기","_type" : "2"});
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