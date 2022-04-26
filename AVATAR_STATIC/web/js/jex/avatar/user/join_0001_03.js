/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : join_0001_03.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/user
 * @author         : 김별 (  )
 * @Description    : 회원가입_가입완료화면
 * @History        : 20200129100814, 김별
 * </pre>
 **/

$(function(){
	var cust_ci = $("#CUST_CI").val();
	iWebAction('changeTitle', {_title:'',_type:'0'});
	$(document).on("click", ".btn_fix_botm", function(){
		iWebAction("fn_complete_join", {"cust_ci" : cust_ci});
	});
	$(document).on("click", ".btn_fix_topr", function(){
		iWebAction("fn_complete_join", {"cust_ci" : cust_ci});
	});
});

var _thisPage = {
		onload : function(){
			
		},
		
}
function fn_back(){
	var cust_ci = $("#CUST_CI").val();
	iWebAction("fn_complete_join", {"cust_ci" : cust_ci});
	//location.href = "ques_0001_01.act";
}