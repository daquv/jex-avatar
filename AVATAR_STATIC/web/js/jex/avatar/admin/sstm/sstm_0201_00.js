/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : sstm_0201_00.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/sstm
 * @author         : 김태훈 (  )
 * @Description    : 어드민_데이터수집현황조회
 * @History        : 20200323164129, 김태훈
 * </pre>
 **/
$(function(){
	_thisPage.onload();
});
var _thisPage = {
		onload : function(){
			resize_frame("ifrm_page");
		}
}
function __fn_init(){
	$("#sstm_0201_00").parents("div").addClass("on");
}
//페이지 이동
function fn_pageSet(url){
	$("#ifrm_page").css("height","805px");
	$("#ifrm_page").attr("src", url);
}
//iframe size 조절
function resize_frame(id) {
	
	
	var frm = document.getElementById(id);
	function resize() {
		frm.style.height = "auto"; // set default height for Opera
		contentHeight = frm.contentWindow.document.documentElement.scrollHeight;
		frm.style.height = contentHeight + 23 + "px"; // 23px for IE7
	}
	if (frm.addEventListener) {
		frm.addEventListener('load', resize, false);
	} else {
		frm.attachEvent('onload', resize);
	}
}

function resize_frame_b(id){
	var frm = document.getElementById(id);
	frm.style.height = "auto"; // set default height for Opera
	contentHeight = frm.contentWindow.document.documentElement.scrollHeight;
	alert(contentHeight);
	frm.style.height = contentHeight + 23 + "px"; // 23px for IE7
}
