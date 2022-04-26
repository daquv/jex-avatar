/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0001_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 김태훈 (  )
 * @Description    : 더보기 메인화면
 * @History        : 20200129101703, 김태훈
 * </pre>
 **/
$(function(){
	iWebAction("changeTitle",{"_title" : "더보기","_type" : "2"});
	
	$(".m_tab_tbl").find("a").on("click",function(){
		var idx = $(".m_tab_tbl").find("a").index($(this));
		if(idx==0){
			//데이터
			var url = "basic_0003_01.act";
			iWebAction("openPopup",{_url:url});
		} else if(idx==1){
			//데이터 가져오기
			location.href = "basic_0002_01.act";	
		} else if(idx==2){
			//고객지원
			var url = "basic_0006_01.act";
			iWebAction("openPopup",{_url:url});
		}
	});
	//로그아웃
	$("#btn_logOut").on("click",function(){
		iWebAction("logout");
	});
	//프로필 이동
	$("#a_btn").on("click",function(){
		var url = "basic_0004_01.act";
		iWebAction("openPopup",{_url:url});
	});
});
function fn_back(){
//	iWebAction("fn_app_finish");
	iWebAction("closePopup");
}
function fn_popCallback(){
	location.reload();
}