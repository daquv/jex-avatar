/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0006_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 김별 (  )
 * @Description    : 개선요청메인화면
 * @History        : 20200819140228, 김별
 * </pre>
 **/

$(function(){
	iWebAction("fn_display_mic_button",{"_display_yn":"N"});
	_thisPage.onload();
	if(MENU_DV == "01"){
		iWebAction("changeTitle",{"_title" : "고객문의","_type" : "2"});
	} else if(MENU_DV == "02"){
		iWebAction("changeTitle",{"_title" : "공지사항","_type" : "2"});
	}
	
	$(document).on("click", ".qdetail", function(){
		var url = "basic_0006_03.act?BLBD_NO="+$(this).data("blbd_no")+"&BLBD_DIV="+$(this).data("blbd_div");
		iWebAction("openPopup",{_url:url});
	});
	if(MENU_DV == "01"){
		$(document).on("click", ".noti_area li .tit", function(){
			var url = "basic_0006_03.act?BLBD_NO="+$(this).data("blbd_no")+"&BLBD_DIV="+$(this).data("blbd_div");
			iWebAction("openPopup",{_url:url});
		});
	}
	if(MENU_DV == "02"){
		$(document).on("click", ".noti_area li", function(){
			var url = "basic_0006_03.act?BLBD_NO="+$(this).data("blbd_no")+"&BLBD_DIV="+$(this).data("blbd_div");
			iWebAction("openPopup",{_url:url});
		});
	}
	
	//1:1문의 등록하기
	$(".btn_fix_botm a").on("click",function(){
		var url = "basic_0006_02.act";
		iWebAction("openPopup",{_url:url});
	});
});

var _thisPage = {
		onload : function(){
			
			if(MENU_DV == "01"){
				$("#cont_inq").show();
				$("#cont_noti").hide();
			} else if(MENU_DV == "02"){
				console.log("test");
				$("#cont_noti").show();
				$("#cont_inq").hide();
			}
			_thisPage.isData();
		}, 
		isData : function(){
			var jexAjax = jex.createAjaxUtil("basic_0006_01_r001");   //PT_ACTION 웹 서비스 호출
			//상태, 검색대상, 카테고리
			input = {};
			input["BLBD_DIV"] = MENU_DV;
			jexAjax.set(input);
			jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
			jexAjax.execute(function(dat) {
				if(dat.REC.length > 0){
					if(MENU_DV == "01"){
						$(".inquiry_warp dd").empty();
						var tempHtml;
						$.each(dat.REC, function(idx, rec){
							tempHtml = "";
							tempHtml += "<div class='qdetail' data-blbd_no="+rec.BLBD_NO+" data-blbd_div="+rec.BLBD_DIV+">";
							tempHtml += "	<div class='left'>";
							tempHtml += "		<div class='qtit'><a href='#none'>"+rec.BLBD_TITL+"</a></div>";
							tempHtml += "		<div class='date'>"+avatar.common.datetime_format2(rec.REG_DTM)+"</div>";
							tempHtml += "	</div>";
							tempHtml += "	<div class='right'>";
							if(rec.STTS == "2"){
								tempHtml += "		<span class='answer end'>답변완료</span>";
							}
							else{
								tempHtml += "		<span class='answer'>처리중</span>";
							}
							tempHtml += "	</div>";
							tempHtml += "</div>";
							
							$(".inquiry_warp dd").append(tempHtml);
						});
						//$(".inquiry_warp").show();
					} else if(MENU_DV == "02"){
						console.log(dat.REC);
						$(".noti_area ul").empty();
						var tempHtml;
						$.each(dat.REC, function(idx, rec){
							tempHtml = "";
							tempHtml += "<li data-blbd_no="+rec.BLBD_NO+" data-blbd_div="+rec.BLBD_DIV+">";
							tempHtml += "	<div class='tit'>";
							tempHtml += "		<p class='maxellips'>"+rec.BLBD_TITL+"</p>";
							tempHtml += "		<p class='date'>"+avatar.common.datetime_format2(rec.REG_DTM)+"</p>";
							tempHtml += "	</div>";
							tempHtml += "	<div class='btn'><a class='btn_arr'></a></div>";
							tempHtml += "</li>";
							
							$(".noti_area ul").append(tempHtml);
						});
					}
					
					$(".notibx_wrap").hide();
				} else{
					$(".notibx_wrap").show();
					$(".inquiry_warp").hide();
					$(".noti_area").hide();
				}
			});
			
		}
}
function fn_back(){
	iWebAction("closePopup");
}

function fn_popCallback(){
	_thisPage.onload();
}
