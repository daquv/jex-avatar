/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : plfm_0102_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/plfm
 * @author         : 김별 (  )
 * @Description    : 플랫폼회사등록화면
 * @History        : 20200710144815, 김별
 * </pre>
 **/
var getBizNo = "";
$(function(){
	getBizNo = $("#BIZ_NO_BASE").val();
	_thisPage.onload();
	$(".cmdSave").on("click",function(){
		_thisPage.fn_create();
	});
	$(".popupClose").on("click", function(){
		_thisPage.fn_close();
	});
});

var _thisPage = { 
		onload : function(){
			if(getBizNo){
				_thisPage.fn_searchData(getBizNo);
			}
		},
		fn_searchData : function(getBizNo){
			var jexAjax = jex.createAjaxUtil('plfm_0102_01_r001');
			jexAjax.set("BIZ_NO", getBizNo);
			jexAjax.execute(function(dat) {
				_thisPage.fn_setData(dat.REC[0]);
			});
		},
		fn_setData : function(rec){
			$("input:radio[name='stts']:radio[value="+rec.STTS+"]").prop('checked', true);
			$("#BSNN_NM").val(rec.BSNN_NM);
			$("#BIZ_NO").text(formatter.corpNum(rec.BIZ_NO));
			$("#RPPR_NM").val(rec.RPPR_NM);
			$("#TEL_NO").val(rec.TEL_NO);
			$("#BSST").val(rec.BSST);
			$("#TPBS").val(rec.TPBS);
			$("#ZPCD").val(rec.ZPCD);
			$("#ADRS").val(rec.ADRS);
			$("#DTL_ADRS").val(rec.DTL_ADRS);
			$("#BSNN_INFO").val(rec.BSNN_INFO);
			$("#OFLV").val(rec.OFLV);
		},
		fn_create : function(){
			if(!_thisPage.fn_save_valid()){
				return false;
			}
			var input = {};
			input["BSNN_NM"]  		= $("#BSNN_NM").val();
			input["BIZ_NO"]  		= $("#BIZ_NO").val();
			input["BIZ_NO_BASE"]	= getBizNo
			input["RPPR_NM"]  		= $("#RPPR_NM").val();
			input["TEL_NO"]  		= $("#TEL_NO").val().replace(/-/g, "");
			input["BSST"]  			= $("#BSST").val();
			input["TPBS"]  			= $("#TPBS").val();
			input["ZPCD"]  			= $("#ZPCD").val();
			input["ADRS"]  			= $("#ADRS").val();
			input["DTL_ADRS"]	  	= $("#DTL_ADRS").val();
			input["BSNN_INFO"]  	= $("#BSNN_INFO").val();
			input["ZPCD"]  			= $("#ZPCD").val();
			input["STTS"] 	 		= $("input[name=stts]:checked").val();

			var jexAjax = jex.createAjaxUtil('plfm_0102_02_c001');
			jexAjax.set(input);
			jexAjax.execute(function(dat) {
				if (dat.RSLT_CD == "0000") {
					alert("저장되었습니다.");
					parent.smartClosePop("_thisPage.fn_search");
				}else if (dat.RSLT_CD == "9999") {
					alert("처리 중 오류가 발생하였습니다.");
				}
			});
		},
		fn_save_valid : function(){
			result = true;
			$(".point").closest("tr").find("td div").children().each(function(){
				if(""==fintech.common.null2void($(this).val())){
					var alert_msg = "필수입력 항목이 누락되었습니다.";
					alert("["+$(this).closest("tr").find("th div").text()+"] "+alert_msg);
					$(this).focus();
					result = false;
					return false;
				}
			});
			return result;
		},
		fn_close : function(){
			parent.smartClosePop("_thisPage.onload");
		}
}