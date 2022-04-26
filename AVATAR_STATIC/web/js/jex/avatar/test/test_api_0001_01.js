/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : test_api_0001_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/test
 * @author         : 김태훈 (  )
 * @Description    : 
 * @History        : 20200205111721, 김태훈
 * </pre>
 **/
$(function(){
	$("button").on("click",function(){
		var actId = $("#API_NM").val();
		var req = JSON.parse($('#req').val());
		if(avatar.common.null2void(actId)==""){
			alert("입력값 없음");
			return;
		}
		avatar.common.callJexAjax(actId, req, callbackFn);
	});
});
function callbackFn(data){
	$('#res').val(JSON.stringify(data));
}