/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0003_04.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200601091949, 김별
 * </pre>
 **/
$(function(){
	iWebAction("changeTitle",{"_title" : "매입", "_type" : "2"});

	_thisPage.onload();
	$(".btn_add").on("click",function(){
		var url = "basic_0002_01.act";
		iWebAction("openPopup",{_url:url});
	});
	$(document).on('click', 'li:eq(0):not(.on)', function(){
		var url = "tax_0003_01.act?BILL_TYPE=2";
		iWebAction("openPopup",{_url:url});
	});
	$(document).on('click', 'li:eq(1):not(.on)', function(){
		var url = "card_0002_01.act";
		iWebAction("openPopup",{_url:url});
	});
	$(document).on('click', 'li:eq(2):not(.on)', function(){
		var url = "tax_0006_01.act";
		iWebAction("openPopup",{_url:url});
	});
});

var _thisPage = {
		onload : function(){
			_thisPage.searchData();
		},
		searchData : function(){
			avatar.common.callJexAjax("basic_0003_03_r001", "", _thisPage.fn_callback, "false", "c");
		}, 
		fn_callback : function(data){
			console.log(data);
			if(avatar.common.null2void(data.BUY_HIS_LST_DTM) == ""){
				$(".date").html(avatar.common.getDate());
			} else{
				$(".date").html(avatar.common.datetime_format2(data.BUY_HIS_LST_DTM));				
			}
			
			for(i in data.JSON){
			    if(data.JSON[i].cnt_nm == "TAX_CNT"){
			    	if(data.JSON[i].cnt == 0){
			    		$(".inner li:eq(0)").addClass("on");
			    		$(".btn_r:eq(0)").hide();
			    		$(".btn_add:eq(0)").show();
			    	}
			    }
			    if(data.JSON[i].cnt_nm == "CARD_CNT"){
			    	if(data.JSON[i].cnt == 0){
			    		$(".inner li:eq(1)").addClass("on");
			    		$(".btn_r:eq(1)").hide();
			    		$(".btn_add:eq(1)").show();
			    	}
			    }
			    if(data.JSON[i].cnt_nm == "CASH_CNT"){
			    	if(data.JSON[i].cnt == 0){
			    		$(".inner li:eq(2)").addClass("on");
			    		$(".btn_r:eq(2)").hide();
			    		$(".btn_add:eq(2)").show();
			    	}
			    }
			}
		}
}

function fn_back(){
	iWebAction("closePopup");
}