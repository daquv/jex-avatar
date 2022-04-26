/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0010_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 김별 (  )
 * @Description    : 유료이용서비스 화면
 * @History        : 20210325175801, 김별
 * </pre>
 **/

$(function(){
	iWebAction("changeTitle",{"_title" : "유료 이용 서비스","_type" : "2"});
});

function fn_back(){
	iWebAction("closePopup");
}