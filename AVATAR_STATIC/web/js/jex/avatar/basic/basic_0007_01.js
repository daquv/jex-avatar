/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0007_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20201117141748, 김별
 * </pre>
 **/

//
$(function(){
	iWebAction("changeTitle",{"_title" : "앱정보","_type" : "2"});
	$(document).on("click", ".app_info li:eq(1)", function(){
		// 서비스 이용약관
		var url = "join_0004_01.act";
		iWebAction("openPopup",{"_url" : url});
	})
	$(document).on("click", ".app_info li:eq(2)", function(){
		// 개인정보 처리방침
		var url = "join_0005_02.act";
		iWebAction("openPopup",{"_url" : url});
	});
	$(document).on("click", ".app_info li:eq(3)", function(){
		// 개인정보 제3자 제공 동의
		var url = "join_0004_03.act";
		iWebAction("openPopup",{"_url" : url});
	});
	$(document).on("click", ".app_info li:eq(4)", function(){
		// 마케팅 정보 수신 동의
		var url = "join_0004_04.act";
		iWebAction("openPopup",{"_url" : url});
	});
	$(document).on("click", ".app_info li:eq(5)", function(){
		if(avatar.common.null2void($("#LGIN_APP").val()).indexOf("SERP") > -1){
			// 경리나라 개인정보 수집 및 이용 동의
			var url = "join_0004_09.act";
			iWebAction("openPopup",{"_url" : url});
		} else if($("#LGIN_APP").val() == "ZEROPAY"){
			// 제로페이 개인정보 수집 및 이용 동의
			var url = "join_0004_12.act";
			iWebAction("openPopup",{"_url" : url});
		}
	});
	$(document).on("click", ".app_info li:eq(6)", function(){
		if($("#LGIN_APP").val() == "SERP"){
			// 경리나라 제3자 정보 제공 동의
			var url = "join_0004_10.act";
			iWebAction("openPopup",{"_url" : url});
		}
		else if($("#LGIN_APP").val() == "ZEROPAY"){
			// 제로페이 제3자 정보 제공 동의
			var url = "join_0004_13.act";
			iWebAction("openPopup",{"_url" : url});
		}
	});
	
});

function fn_back(){
	iWebAction("closePopup");	
}