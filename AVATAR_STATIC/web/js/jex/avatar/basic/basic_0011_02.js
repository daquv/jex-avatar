/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0011_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 김별 (  )
 * @Description    : 브리핑 설정
 * @History        : 20210818153203, 김별
 * </pre>
 **/
$(function(){
	/* Time Picker */
	/* //Time Picker */
	_thisPage.onload();
	$(document).on("click", "#voiceBrief .btn_switch", function(){
		if($(this).hasClass("on")){
			if(_APP_ID.indexOf("SERP") == -1) iWebAction("setStorage",{"_key" : "keyVoiceBrief", "_value" : "N"});
			$(this).removeClass("on");
		} else {
			if(_APP_ID.indexOf("SERP") == -1) iWebAction("setStorage",{"_key" : "keyVoiceBrief", "_value" : "Y"});
			$(this).addClass("on");
		}
	});
	$(document).on("click", "#zpBrief .btn_switch", function(){
		if($(this).hasClass("on")){
			$("#zpBrief .timePIcker_wrap").hide();
			$(this).removeClass("on");
		} else {
			$("#zpBrief .timePIcker_wrap").show();
			$(this).addClass("on");
		}
	});
	$(document).on("click", "#cardBrief .btn_switch", function(){
		if($(this).hasClass("on")){
			$("#cardBrief .timePIcker_wrap").hide();
			$(this).removeClass("on");
		} else {
			$("#cardBrief .timePIcker_wrap").show();
			$(this).addClass("on");
		}
	});
});

let _thisPage = {
		onload : function(){
			iWebAction("changeTitle",{"_title" : "브리핑 설정","_type" : "2"});
			_thisPage.setData();
		},
		setData : function(){
			avatar.common.callJexAjax("basic_0011_02_r001", "", _thisPage.cb_setData, "false", "");
		},
		cb_setData : function(data){
			let zero_push_yn = data.ZERO_PUSH_YN;
			let card_push_yn = data.CARD_PUSH_YN;
			let zero_push_time = data.ZERO_PUSH_TIME/100;
			let card_push_time = data.CARD_PUSH_TIME/100;
			
			/* zero push */
			if(avatar.common.null2void(zero_push_yn)==="N"){
				$("#zpBrief .timePIcker_wrap").hide();
				$("#zpBrief .btn_switch").removeClass("on");
			} else {
				$("#zpBrief .timePIcker_wrap").show();
				$("#zpBrief .btn_switch").addClass("on");
			}
			$("#zpBrief .drum-drum:eq(0) div").removeClass("drum-item-current");
			//$("#zpBrief .drum-drum:eq(1) div").removeClass("drum-item-current");
			/*
			if(zero_push_time > 12){
				zero_push_time -= 12;
				// 오후
				$("#zpBrief .drum-drum:eq(0) div:eq(1)").addClass("drum-item-current");
				$("#zpBrief .drum-drum:eq(0)").css({transform:"translate(0,-45px)"});
			} else {
				// 오전
				$("#zpBrief .drum-drum:eq(0) div:eq(0)").addClass("drum-item-current");
				$("#zpBrief .drum-drum:eq(0)").css({transform:"translate(0,0px)"});
			}
			*/
			// 시간
			//$("#zpBrief .drum-drum:eq(1) div:eq("+(zero_push_time-1)+")").addClass("drum-item-current");
			//$("#zpBrief .drum-drum:eq(1)").css({transform:"translate(0,-"+(45*(zero_push_time-1))+"px)"});
			//if(zero_push_time === 1) $("#zpBrief .drum-drum:eq(1)").find(".btn_next").addClass("disabled");
			//if(zero_push_time === 12) $("#zpBrief .drum-drum:eq(1)").find(".btn_prev").addClass("disabled");
			$("#zpBrief .drum-drum:eq(0) div:eq("+(zero_push_time-7)+")").addClass("drum-item-current");
			$("#zpBrief .drum-drum:eq(0)").css({transform:"translate(0,-"+(45*(zero_push_time-7))+"px)"});
			if(zero_push_time === 7) $("#zpBrief .drum-drum:eq(0)").find(".btn_next").addClass("disabled");
			if(zero_push_time === 23) $("#zpBrief .drum-drum:eq(0)").find(".btn_prev").addClass("disabled");
			/* //zero push */
			
			/* card push */
			if(avatar.common.null2void(card_push_yn)==="N"){
				$("#cardBrief .timePIcker_wrap").hide();
				$("#cardBrief .btn_switch").removeClass("on");
			} else {
				$("#cardBrief .timePIcker_wrap").show();
				$("#cardBrief .btn_switch").addClass("on");
			}
			$("#cardBrief .drum-drum:eq(0) div").removeClass("drum-item-current");
			//$("#cardBrief .drum-drum:eq(1) div").removeClass("drum-item-current");
			/*
			if(card_push_time > 12){
				card_push_time -= 12;
				// 오후
				$("#cardBrief .drum-drum:eq(0) div:eq(1)").addClass("drum-item-current");
				$("#cardBrief .drum-drum:eq(0)").css({transform:"translate(0,-45px)"});
			} else {
				// 오전
				$("#cardBrief .drum-drum:eq(0) div:eq(0)").addClass("drum-item-current");
				$("#cardBrief .drum-drum:eq(0)").css({transform:"translate(0,0px)"});
			}
			*/
			// 시간
			//$("#cardBrief .drum-drum:eq(1) div:eq("+(card_push_time-1)+")").addClass("drum-item-current");
			//$("#cardBrief .drum-drum:eq(1)").css({transform:"translate(0,-"+(45*(card_push_time-1))+"px)"});
			//if(card_push_time === 1) $("#cardBrief .drum-drum:eq(1)").find(".btn_next").addClass("disabled");
			//if(card_push_time === 12) $("#cardBrief .drum-drum:eq(1)").find(".btn_prev").addClass("disabled");
			$("#cardBrief .drum-drum:eq(0) div:eq("+(card_push_time-7)+")").addClass("drum-item-current");
			$("#cardBrief .drum-drum:eq(0)").css({transform:"translate(0,-"+(45*(card_push_time-7))+"px)"});
			if(card_push_time === 7) $("#cardBrief .drum-drum:eq(0)").find(".btn_next").addClass("disabled");
			if(card_push_time === 23) $("#cardBrief .drum-drum:eq(0)").find(".btn_prev").addClass("disabled");
			/* //card push */
			
			if(_LGIN_APP == "AVATAR"){
				$("#cardBrief").show();
			}else if(_LGIN_APP == "ZEROPAY"){
				$("#zpBrief").show();
			}
		}
}
function fn_back(){
	var jexAjax = jex.createAjaxUtil("basic_0011_02_u001");
	/*
	if($("#zpBrief .btn_switch").hasClass("on")){
		let zero_push_time;
		if(document.getElementById("zpBrief").getElementsByClassName("drum-item-current")[0].textContent==="오전"){
			zero_push_time = document.getElementById("zpBrief").getElementsByClassName("drum-item-current")[1].textContent.replace(/:/, '').replace(/\s/g, '');
		} else {
			zero_push_time = parseInt(document.getElementById("zpBrief").getElementsByClassName("drum-item-current")[1].textContent.replace(/:/, '').replace(/\s/g, ''))+1200
		}
		jexAjax.set("ZERO_PUSH_TIME", zero_push_time);
		jexAjax.set("ZERO_PUSH_YN", "Y");
	} else {
		jexAjax.set("ZERO_PUSH_YN", "N");
	}
	if($("#cardBrief .btn_switch").hasClass("on")){
		let card_push_time;
		if(document.getElementById("cardBrief").getElementsByClassName("drum-item-current")[0].textContent==="오전"){
			card_push_time = document.getElementById("cardBrief").getElementsByClassName("drum-item-current")[1].textContent.replace(/:/, '').replace(/\s/g, '');
		} else {
			card_push_time = parseInt(document.getElementById("cardBrief").getElementsByClassName("drum-item-current")[1].textContent.replace(/:/, '').replace(/\s/g, ''))+1200
		}
		jexAjax.set("CARD_PUSH_TIME", card_push_time);
		jexAjax.set("CARD_PUSH_YN", "Y");
	} else {
		jexAjax.set("CARD_PUSH_YN", "N");
	}
	*/
	
	if($("#zpBrief .btn_switch").hasClass("on")){
		let zero_push_time = document.getElementById("zpBrief").getElementsByClassName("drum-item-current")[0].textContent.replace(/:/, '').replace(/\s/g, '');
		jexAjax.set("ZERO_PUSH_TIME", zero_push_time);
		jexAjax.set("ZERO_PUSH_YN", "Y");
	} else {
		jexAjax.set("ZERO_PUSH_YN", "N");
	}
	if($("#cardBrief .btn_switch").hasClass("on")){
		let card_push_time = document.getElementById("cardBrief").getElementsByClassName("drum-item-current")[0].textContent.replace(/:/, '').replace(/\s/g, '');
		jexAjax.set("CARD_PUSH_TIME", card_push_time);
		jexAjax.set("CARD_PUSH_YN", "Y");
	} else {
		jexAjax.set("CARD_PUSH_YN", "N");
	}
	
	jexAjax.execute(function(data) {
		if(data.RSLT_CD === "0000"){
			iWebAction("closePopup");
		}
	});
}
