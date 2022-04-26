/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : cstm_0101_00.js
 * @File path      : SEMOADMIN_STATIC/web/js/jex/semoadmin/cstm
 * @author         : sophearoth ( rothkakvey@gmail.com )
 * @Description    : 기관약정관리
 * @History        : 20190124140806, sophearoth
 * </pre>
 **/




new (Jex.extend({
	onload:function() {
		_this = this;
		resize_frame("ifrm_page");
		
	}, event:function() {
	
	}
}))();

function __fn_init(){
	$("#cstm_0101_00").parents("div").addClass("on");
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
//		frm.style.height = contentHeight + 400 + "px"; // 23px for IE7
		console.log(contentHeight);
		console.log(frm.style.height);
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