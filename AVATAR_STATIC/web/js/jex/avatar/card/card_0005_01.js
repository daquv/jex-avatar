/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : card_0005_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/card
 * @author         : 김태훈 (  )
 * @Description    : 카드매입-카드사선택화면
 * @History        : 20200128155412, 김태훈
 * </pre>
 **/
$(function(){
	_thisPage.onload();
	//카드매입탭 관리하기 클릭
	
	$(document).on("click", ".ico_bank", function(){
		realTimeFnshYn("2", this);
		/*
		var $temp = $(this).find('div:eq(0)');
		var url = '';
		if($(this).find('.right a').hasClass('off')){
			url = "card_0007_01.act?BANK_CD="+$temp.attr("id")+"&BANK_NM="+$temp.find("span").text();
		} else if($(this).find('.right a').hasClass('on')){
			url = "card_0005_02.act?CARD_CD="+$temp.attr("id")+"&CARD_NM="+$temp.find("span").text();
		}
		iWebAction("openPopup",{_url:url});
		*/
	});
	// 안내창 닫기
	$(document).on("click","#pop_btn01",function(){
		$("#modaloverlay1").hide();
	});
	/*$(document).on("click",".ico_bank .right a.off",function(){
		var $temp = $(this).parent("div").prev("div");
		var url = "card_0007_01.act?BANK_CD="+$temp.attr("id")+"&BANK_NM="+$temp.find("span").text();
		iWebAction("openPopup",{_url:url});
	});
	$(document).on("click",".ico_bank .right a.on",function(){
		var $temp = $(this).parent("div").prev("div");
		var url = "card_0005_02.act?CARD_CD="+$temp.attr("id")+"&CARD_NM="+$temp.find("span").text();
		iWebAction("openPopup",{_url:url});
	});*/
	/*//은행 클릭
	$("li").on("click", function(e) {
		$("#a_next").removeClass("off");
		$(this).closest("ul").find("li").removeClass("on");
		$(this).addClass("on");
	});
	//다음 버튼
	$("#a_next").on("click", function(e) {
		if($(this).hasClass("off")){
			return;
		}
		var chk = 0;
		var cardInfm = {};
		$(".bank_area").find("ul").find("li").each(function(){
			if($(this).hasClass("on")){
				chk++;
				cardInfm["CARD_CD"]=$(this).attr("id");
				cardInfm["CARD_NM"]=fn_getCardNm(cardInfm.CARD_CD);
			}
		});
		if(chk!=1){
			alert("하나의 카드사를 선택하세요.");
			return;
		}
		avatar.common.pageMove("card_0005_02.act",cardInfm);
	});*/
});
var _thisPage = {
		onload : function(){
			iWebAction("changeTitle",{"_title" : "카드사 데이터","_type" : "2"});
			_thisPage.searchData();
		},
		searchData : function(){
			avatar.common.callJexAjax("card_0005_01_r001","",_thisPage.searchCallback);
		}, 
		searchCallback : function(data){
			// 초기화
			$(".ico_bank a").removeClass("off").addClass("on");
			$(".ico_bank a").text("연결하기");
			//카드목록
			if(data.REC.length>0){
				
				var cardHtml = '';
				$.each(data.REC,function(i,v){
					//console.log(fn_getCardCd(v.BANK_CD));
					$("."+fn_getCardCd(v.BANK_CD)).siblings(".right").find("a").addClass(v.BANK_CD);
					$("."+v.BANK_CD).removeClass("on").addClass("off");
					$("."+v.BANK_CD).text($("."+v.BANK_CD).text().replace(/연결하기/g,"관리하기"));
					/*$("."+v.BANK_CD).attr("BANK_CD", v.BANK_CD);
					$("."+v.BANK_CD).attr("BANK_NM", v.BANK_NM);*/
				});
				/*$("#ul_card").html(cardHtml);*/
			}
		}
}

function fn_getCardCd(dsdl_cd){
	var card_cd = "";
	if(dsdl_cd == "30000021"){
		card_cd = "card001";
	} else if(dsdl_cd == "30000001"){
		card_cd = "card002";
	} else if(dsdl_cd == "30000003"){
		card_cd = "card003";
	} else if(dsdl_cd == "30000008"){
		card_cd = "card004";
	} else if(dsdl_cd == "30000002"){
		card_cd = "card005";
	} else if(dsdl_cd == "30000017" || dsdl_cd == "30000019"){
		card_cd = "card006";
	} else if(dsdl_cd == "30000015"){
		card_cd = "card007";
	} else if(dsdl_cd == "30000018"){
		card_cd = "card008";
	} else if(dsdl_cd == "30000064" || dsdl_cd == "30000063" || dsdl_cd == "30000060" || dsdl_cd == "30000061" || dsdl_cd == "30000062" || dsdl_cd == "30000006"){ 
		card_cd = "card009";
	}
	return card_cd;
}
function fn_getCardNm(card_cd){
	var card_nm = ""; 
	if(card_cd == "060"){
		card_nm = "비씨기업";
	}else if(card_cd == "064"){
		card_nm = "비씨SC";
	}else if(card_cd == "061"){
		card_nm = "비씨대구";
	}else if(card_cd == "062"){
		card_nm = "비씨부산";
	}else if(card_cd == "063"){
		card_nm = "비씨경남";
	}else if(card_cd == "021"){
		card_nm = "NH농협카드";
	}else if(card_cd == "001"){
		card_nm = "KB국민카드";
	}else if(card_cd == "003"){
		card_nm = "삼성카드";
	}else if(card_cd == "008"){
		card_nm = "신한카드";
	}else if(card_cd == "002"){
		card_nm = "현대카드";
	}else if(card_cd == "019"){
		card_nm = "롯데카드";
	}else if(card_cd == "015"){
		card_nm = "하나카드";
	}else if(card_cd == "018"){
		card_nm = "우리카드";
	}else if(card_cd == "009"){
		card_nm = "씨티카드";
	}else if(card_cd == "051"){
		card_nm = "K뱅크";
	}else if(card_cd == "006"){
		card_nm = "비씨카드";
	}
	return encodeURIComponent(card_nm);
}

//실시간 조회여부 
function realTimeFnshYn(task_gb, _that){
	var $temp = $(_that).find('div:eq(0)');
	
	var jexAjax = jex.createAjaxUtil("basic_0002_01_r002");
	jexAjax.set("TASK_GB", task_gb);
	jexAjax.set("BANK_CD", "30000"+$temp.attr("id"));
	jexAjax.execute(function(data){
		if(data.FNSH_YN == "N"){
			$("#modaloverlay1").show();
		}else{
			
			var url = '';
			if($(_that).find('.right a').hasClass('off')){
				url = "card_0007_01.act?BANK_CD="+$temp.attr("id")+"&BANK_NM="+$temp.find("span").text();
			} else if($(_that).find('.right a').hasClass('on')){
				url = "card_0005_02.act?CARD_CD="+$temp.attr("id")+"&CARD_NM="+$temp.find("span").text();
			}
			iWebAction("openPopup",{_url:url});
		}
	});	
}

function fn_popBackCallback(){
	iWebAction("closePopup",{_callback:"fn_popCallback"});
}

function fn_back(){
	iWebAction("closePopup",{_callback:"fn_popCallback"});
}
function fn_popCallback(){
	_thisPage.searchData();
}