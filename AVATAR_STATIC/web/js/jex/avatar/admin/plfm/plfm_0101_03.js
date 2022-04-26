/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : plfm_0101_03.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/plfm
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200709165351, 김별
 * </pre>
 **/
$(function(){
	$(".cmdSave").on("click",function(){
		_thisPage.fn_update();
	});
	$(".popupClose").on("click", function(){
		_thisPage.fn_close();
	});
});

var _thisPage = { 
		fn_update : function(){
			if($("#STTS").val()==-1){
				alert("상태값을 선택하세요");
				return false;
			}
			
			var input = {};
			input["INSERT_REC"] = JSON.parse(REC);
			input["STTS"] = $("#STTS").val();

			var jexAjax = jex.createAjaxUtil('plfm_0101_03_u001');
			jexAjax.set(input);
			jexAjax.execute(function(dat) {
				if (dat.RSLT_CD == "0000") {
					alert("저장되었습니다.");
					parent.smartClosePop("_thisPage.fn_search");
				} else{
					alert("처리 중 오류가 발생하였습니다.");
				}
			});
		},
		fn_close : function(){
			parent.smartClosePop("_thisPage.onload");
		}
}