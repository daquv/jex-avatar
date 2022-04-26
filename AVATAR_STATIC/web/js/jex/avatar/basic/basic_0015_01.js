/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0015_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 박지은 (  )
 * @Description    : 제로페이 가맹점 관리 화면
 * @History        : 20210805165524, 박지은
 * </pre>
 **/
$(function(){
	_thisPage.onload();
	
	// 확인
	$(".confirm_btn").on("click",function(){
		fn_back();
	});
	
	// 토글 on/off
	$(document).on("click","li .btn_switch",function(){
		var aflt_management_no = $(this).closest("li").attr("data-aflt_management_no");
		var mest_biz_no = $(this).closest("li").attr("data-mest_biz_no");
		var ser_biz_no = $(this).closest("li").attr("data-ser_biz_no");
		var acvt_stts = $(this).closest("li").attr("data-acvt_stts");
		var on_off = "on";
		
		if(acvt_stts == "9"){
			alert("해지 처리된 가맹점입니다.");
			return;
		}
		if($(this).hasClass('on')){
			$(this).removeClass('on');
			on_off = "off";
		}
		else{
			$(this).addClass('on');
		}
		// 가맹점 사용여부 변경
		_thisPage.mestStts(on_off, aflt_management_no, mest_biz_no, ser_biz_no);
	});
});
var _thisPage={
		onload : function(){
			iWebAction("changeTitle",{"_title" : "제로페이 가맹점 데이터 관리","_type" : "2"});
			iWebAction("fn_display_mic_button",{"_display_yn":"N"});
			
			_thisPage.searchData();
		},
		searchData : function(){
			avatar.common.callJexAjax("basic_0015_01_r001","",_thisPage.searchCallback);
		},
		searchCallback : function(data){
			
			$("#mest_list").empty();
			//가맹점 목록
			if(data.REC.length>0){
				var mest_html = "";
				$.each(data.REC,function(i,v){
					mest_html += "<li data-aflt_management_no=\""+avatar.common.null2void(v.AFLT_MANAGEMENT_NO)+"\"";
					mest_html += " data-mest_biz_no=\""+avatar.common.null2void(v.MEST_BIZ_NO)+"\"";
					mest_html += " data-ser_biz_no=\""+avatar.common.null2void(v.SER_BIZ_NO)+"\"";
					mest_html += " data-acvt_stts=\""+avatar.common.null2void(v.ACVT_STTS)+"\">";
					mest_html += "	<div class=\"left noneArrow\">";
					mest_html += "		<div class=\"acc_tit\">";
					mest_html += avatar.common.null2void(v.MEST_NM);
					mest_html += "		</div>";
					mest_html += "		<div class=\"acc_txt\">";
					mest_html += formatter.corpNum(avatar.common.null2void(v.MEST_BIZ_NO));
					mest_html += "		</div>";
					mest_html += "	</div>";
					mest_html += "	<div class=\"btn\">";
					if(avatar.common.null2void(v.ACVT_STTS) == "1" 
						&& avatar.common.null2void(v.USE_YN, "Y") == "Y"){
						mest_html += "		<a class=\"btn_switch on\"></a>";
					}else{
						mest_html += "		<a class=\"btn_switch\"></a>";
					}
					mest_html += "	</div>";
					if(avatar.common.null2void(v.ACVT_STTS) == "9"){
						mest_html += "	<div class=\"cerStatus miPosition\">";
						mest_html += "		<span class=\"cerEnd\">해지</span>";
						mest_html += "	</div>";
					}
					mest_html += "</li>";					
				});
				$("#mest_list").html(mest_html);
				$("#cont_none").hide();
				$("#cont").show();
			}else{
				$("#cont").hide();
				$("#cont_none").show();
			}
		},
		mestStts : function(onoff_dv, aflt_management_no, mest_biz_no, ser_biz_no){
			var input = {};
			var use_yn = "";
			if(onoff_dv == "on") use_yn = "Y";
			else use_yn = "N";
			
			input["USE_YN"]				= use_yn;
			input["AFLT_MANAGEMENT_NO"]	= aflt_management_no;
			input["MEST_BIZ_NO"]		= mest_biz_no;
			input["SER_BIZ_NO"]			= ser_biz_no;
			
			avatar.common.callJexAjax("basic_0015_01_u001",input,_thisPage.mestSttsCallback);
		},
		mestSttsCallback : function(data){
			if(data.RSLT_CD == "0000"){
				
			} else {
				alert("처리 중 오류가 발생하였습니다.");
			}
		}
}

//백버튼
function fn_back(){
	iWebAction("closePopup");		
}

function fn_popCallback(){
	_thisPage.onload();
}