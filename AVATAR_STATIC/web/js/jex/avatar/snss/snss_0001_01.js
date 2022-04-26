/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : snss_0001_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/snss
 * @author         : 박지은 (  )
 * @Description    : 
 * @History        : 20210721162430, 박지은
 * </pre>
 **/
$(function(){
	_thisPage.onload();
	
	// 계정 클릭
	$(".delivery_appList").on("click",function(){
		var shop_cd = $(this).attr("shop_cd");
		var shop_nm = $(this).attr("shop_nm");
		
		realTimeFnshYn(shop_cd, shop_nm)
	});
	
	// 안내창 닫기
	$("#pop_btn01").on("click",function(){
		$("#modaloverlay1").hide();
	});
});

var _thisPage={
	onload : function(){
		iWebAction("changeTitle",{"_title" : "온라인 매출 연결하기","_type" : "2"});
		$(".m_cont").show();
		_thisPage.searchData();
	},
	searchData : function(){
		avatar.common.callJexAjax("snss_0001_01_r001","",_thisPage.searchCallback);
	},
	searchCallback : function(data){
		if(avatar.common.null2void(data.RSLT_CD)=="9999"){
			alert(data.RSLT_MSG);
			return;
		}
		
		// 연결완료 태그 전체 제거
		$(".delivery_appList").removeClass("on");	
		$(".Compt").hide();	
		
		// 계정 연결여부 조회 (배민:sellBaemin, 쿠팡이츠:sellCoupangeats, 요기요:sellYogiyo)
		if(data.REC.length>0){
			$.each(data.REC,function(i,v){
				//$("div[shop_cd="+v.SHOP_CD+"]").attr("style","border:1px solid #b395f8;");
				$("div[shop_cd="+v.SHOP_CD+"]").addClass("on");
				$("div[shop_cd="+v.SHOP_CD+"] .Compt").show();
				/*
				if(v.SHOP_CD == "sellBaemin"){
					$("div[shop_cd=sellBaemin]").addClass("on");
					$("div[shop_cd=sellBaemin] .Compt").show();
				}else if(v.SHOP_CD == "sellCoupangeats"){
					$("div[shop_cd=sellCoupangeats]").addClass("on");
					$("div[shop_cd=sellCoupangeats] .Compt").show();
				}else if(v.SHOP_CD == "sellYogiyo"){
					$("div[shop_cd=sellYogiyo]").addClass("on");
					$("div[shop_cd=sellYogiyo] .Compt").show();
				}
				*/
			});
		}
		
		// 실시간 조회중인 계정이 있는 경우 연결완료 테두리 제거
		if(data.RT_REC.length>0){
			$.each(data.RT_REC,function(i,v){
				$("div[shop_cd="+v.SHOP_CD+"]").attr("style","border:0px;");
			});
		}
	}
}

// 실시간 조회종료 여부 
function realTimeFnshYn(shop_cd, shop_nm){
	
	var jexAjax = jex.createAjaxUtil("basic_0002_01_r002");
	jexAjax.set("TASK_GB", "5");
	jexAjax.set("BANK_CD", shop_cd);
	jexAjax.execute(function(data){
		// 실시간 조회중일 경우
		if(data.FNSH_YN == "N"){
			$("#modaloverlay1").show();
		}else{
			// 선택한 쇼핑몰 계정화면으로 이동
			var pageUrl = "snss_0002_01.act?";
			var pageParam = "SHOP_CD="+shop_cd;
			pageParam += "&SHOP_NM="+shop_nm;
			iWebAction("openPopup",{"_url":pageUrl, "_param" : pageParam});
		}
	});
	
}

function fn_backPopCallback(){
	iWebAction("closePopup",{_callback:"fn_popCallback"});
}

function fn_back(){
	iWebAction("closePopup",{_callback:"fn_popCallback"});
}

function fn_popCallback(){
	_thisPage.searchData();
}