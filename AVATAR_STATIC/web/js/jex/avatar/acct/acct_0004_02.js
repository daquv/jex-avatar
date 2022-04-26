/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : acct_0004_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/acct
 * @author         : 박지은 (  )
 * @Description    : 계좌실시간조회 화면
 * @History        : 20210121094801, 박지은
 * </pre>
 **/
$(function(){
	iWebAction("changeTitle",{"_title" : "은행데이터 가져오기","_type" : "2"});
	// 확인버튼
	$("#a_enter").on("click",function(){
		fn_back();
	});
});

//백버튼
function fn_back(){
	// 연결된 계좌 화면으로 이동
	location.href = "acct_0003_01.act";
}