/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0014_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 박지은 (  )
 * @Description    : 제로페이 연결 화면
 * @History        : 20210805165420, 박지은
 * </pre>
 **/
var _link_yn = "";
$(function(){
	_thisPage.onload();
	
	// 가맹점 연결
	$("#link_btn").on("click",function(){
		//alert("제로페이 가맹점 연결");
		$("#REALTIME").show();
		$("#MAIN").hide();
		$(".btn_fix_botm").hide();
		avatar.common.callJexAjax("basic_0014_01_c001","",_thisPage.searchCallback);
	});
	
	// 확인
	$(".confirm_btn").on("click",function(){
		fn_back();
	});
	
});
var _thisPage={
	onload : function(){
		// 질의 결과에서 들어온 경우
		if($("#DV").val() == "QUES"){
			// 가맹점 연결 여부
			avatar.common.callJexAjax("basic_0014_01_r001","",_thisPage.linkCallback);
		}else{
			iWebAction("changeTitle",{"_title" : "제로페이 가맹점 정보","_type" : "2"});
			iWebAction("fn_display_mic_button",{"_display_yn":"N"});
			$("#cont_str").show();
			$("#REALTIME").hide();
		}
	},
	searchCallback : function(data){
		$("#REALTIME").hide();
		$("#MAIN").show();
		$(".btn_fix_botm").show();
		
		$("#cont_str").hide();
		if(data.RSLT_CD != "0000"){
			$("#cont_mest").hide();
			$("#cont_none").show();
		}else{
			$("#mest_list").empty();
			var mest_html = "";
			
			//가맹점 목록
			if(data.REC.length>0){
				$.each(data.REC,function(i,v){
					mest_html += "<dd>";
					mest_html += "	<span class=\"tit\">"+v.MEST_NM+"</span>";
					mest_html += "	<div class=\"right\">";
					mest_html += "		<em>"+v.MEST_BIZ_NO+"</em>";
					mest_html += "	</div>";
					mest_html += "</dd>";
				});
				
				$("#mest_list").html(mest_html);
				$("#cont_none").hide();
				$("#cont_mest").show();
			}else{
				$("#cont_mest").hide();
				$("#cont_none").show();
			}
			_link_yn = "Y";
		}
	},
	linkCallback : function(data){
		// 연결되어 있음
		if(data.LINK_CNT != "0"){
			location.href = "basic_0015_01.act";
		}else{
			iWebAction("changeTitle",{"_title" : "제로페이 가맹점 정보","_type" : "2"});
			iWebAction("fn_display_mic_button",{"_display_yn":"N"});
			$("#cont_str").show();
		}
	}
}

//백버튼
function fn_back(){
	iWebAction("closePopup",{_callback:"fn_popCallback",_data:_link_yn});		
}

function fn_popCallback(){
	_thisPage.onload();
}