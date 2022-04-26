/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0003_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/comm
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200529141340, 김별
 * </pre>
 **/

$(function(){
	iWebAction("changeTitle",{"_title" : "금융", "_type" : "2"});
	//계좌
	$(document).on('click', '.inner li', function(){
		var $this = $(this).find(".tit");
		var url = "acct_0002_01.act?BANK_CD="+$this.attr("BANK_CD")+"&FNNC_UNQ_NO="+$this.attr("FNNC_UNQ_NO")+"&BANK_NM="+$this.attr("BANK_NM")+"&FNNC_INFM_NO="+$this.attr("FNNC_INFM_NO");
		iWebAction("openPopup",{"_url":url});
		//location.href="acct_0002_01.act?BANK_CD="+$(this).attr("BANK_CD")+"&FNNC_UNQ_NO="+$(this).attr("FNNC_UNQ_NO")+"&BANK_NM="+$(this).attr("BANK_NM")+"&FNNC_INFM_NO="+$(this).attr("FNNC_INFM_NO");
	});
	$(".btn_add").on("click",function(){
		var url = "basic_0002_01.act";
		iWebAction("openPopup",{_url:url});
	});
	_thisPage.onload();
})

var _thisPage = {
	onload : function(){
		_thisPage.searchData();
	},
	searchData : function(){
		avatar.common.callJexAjax("basic_0003_02_r001", "", _thisPage.fn_callback, "false","c");
	},
	fn_callback : function(data){
		if(data.REC.length == 0){
			$(".data_n").show();
			$(".data_y").hide()
		} else{
			$(".data_y").show();
			$(".data_n").hide();
			if(avatar.common.null2void(data.REC[0].HIS_LST_DTM) == ""){
				$(".date").html(avatar.common.getDate());
			} else{
				$(".date").html(avatar.common.datetime_format2(data.REC[0].HIS_LST_DTM));				
			}
			var acctHtml = '';
			$.each(data.REC, function(i,v){
				acctHtml += '<li><span class="tit" BANK_NM = "'+v.BANK_NM+'" BANK_CD="'+avatar.common.null2void(v.BANK_CD)+'" FNNC_UNQ_NO="'+avatar.common.null2void(v.FNNC_UNQ_NO)+'" FNNC_INFM_NO="'+avatar.common.null2void(v.FNNC_INFM_NO)+'">'+avatar.common.null2void(v.BANK_NM)+' '+avatar.common.null2void(v.FNNC_INFM_NO)+'</span><a class="btn_r"></a></li>';
			});
			$(".inner").find("ul").html(acctHtml);
		}
		
	}
	
	
}

function fn_back(){
	iWebAction("closePopup");
}