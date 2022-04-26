/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_0001_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20201111111356, 김별
 * </pre>
 **/
$(function(){
	_thisPage.onload();
	$(document).on("click", ".bntap li", function(){
		$(".bntap li").removeClass("on");
		$(this).addClass("on");
		_thisPage.searchData();
	});
	$(document).on("click", "dl li", function(){
		var INTE_INFO ="{'recog_txt':'"+$(this).text()+"','recog_data' : {'Intent':'"+$(this).attr('intent')+"','appInfo' : {}} }" ;
		var INTE_INFO_create = '{"recog_txt":'+$(this).find("a").text()+',"recog_data" : {"Intent":"'+$(this).attr('intent')+'","appInfo" : { }} }';
		_thisPage.fn_create(INTE_INFO_create);
		var url = "ques_comm_01.act?INTE_INFO="+INTE_INFO;
		iWebAction("openPopup",{"_url" : url});
	});
});
var _thisPage = {
		onload : function(){
			iWebAction("changeTitle",{"_title" : "질의", "_type" : "2"});
			_thisPage.setData();
			_thisPage.searchData();
		},
		setData : function(){
			var menuDv = $("input[name='MENU_DV']").val();
			var ctgrCd = $("input[name='CTGR_CD']").val();
			if(menuDv || ctgrCd){
				$(".bntap li").removeClass("on");
				$(".bntap ul").find("li[id="+ctgrCd+"][data-menu="+menuDv+"]").addClass("on");
			}
		},
		searchData : function() {
			var input = {};
			input["MENU_DV"] = $(".bntap ul").find(".on").attr("data-menu"); 
			input["CTGR_CD"] = $(".bntap ul").find(".on").attr("id"); 
			avatar.common.callJexAjax("ques_0001_02_r002", input, _thisPage.fn_callback, "true", "");
		},
		fn_callback : function(data){
			$(".ai_list_v ul").html("");
			$.each(data.REC_TOTAL, function(idx, rec){
				var totalHtml= '';
				totalHtml += '<li intent = "'+rec.INTE_CD+'"><a>'+'\"'+rec.QUES_CTT+'\"';
				//NEW 표시 이미지 추가
				if(rec.NEW_DV == "Y"){
					totalHtml += '<span class="icon_new"><img src="../img/ico_new.png" alt=""></span>';
				}
				
				totalHtml += '</a></li>';
				$(".ai_list_v ul").append(totalHtml);
			});
		},
		fn_create : function(INTE_INFO){
			var jexAjax = jex.createAjaxUtil("ques_comm_01_u001"); // PT_ACTION
			jexAjax.set("VOIC_DATA", INTE_INFO);
			jexAjax.execute(function(data) {
				
			});
		},
}

function fn_back(){
	iWebAction("closePopup",{_callback:"fn_popCallback2"});	
}