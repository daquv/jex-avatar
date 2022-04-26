/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : plfm_0101_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/plfm
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200709160328, 김별
 * </pre>
 **/
var isDup = true;
var getUserId = "";
$(function(){
	getUserId = $("#USER_ID_BASE").val();
	_thisPage.onload();
	$("#btn_search").on("click", function(){
		_thisPage.fn_srchBiz();
	});
	$("#btn_chk").on("click", function(){
		_thisPage.fn_dupChk($("#USER_ID").val());
	});
	$(".cmdSave").on("click",function(){
		_thisPage.fn_create();
	});
	$(".popupClose").on("click", function(){
		_thisPage.fn_close();
	});
	$("#USER_ID").on("change keyup paste", function() {
		isDup = true;
	});

});

var _thisPage = { 
		onload : function(){
			if(getUserId){
				isDup = false;
				_thisPage.fn_searchData(getUserId);
			}
		},
		fn_searchData : function(getUserId){
			var jexAjax = jex.createAjaxUtil('srvc_0101_03_r001');
			jexAjax.set("USER_ID", getUserId);
			jexAjax.execute(function(dat) {
				console.log(dat);
				_thisPage.fn_setData(dat.REC[0]);
			});
		},
		fn_setData : function(rec){
			$("input:radio[name='stts']:radio[value="+rec.STTS+"]").prop('checked', true);
			$("input:radio[name='useAtht']:radio[value="+rec.USE_ATHT+"]").prop('checked', true);
			$("input:radio[name='userGb']:radio[value="+rec.USER_GB+"]").prop('checked', true);
			$("#USER_NM").val(rec.USER_NM);
			$("#USER_ID").text(rec.USER_ID);
			$("#EMAL").val(rec.EMAL);
			$("#CLPH_NO").val(rec.CLPH_NO);
			$("#BSNN_NM").val(rec.BSNN_NM);
			$("#DEPT_NM").val(rec.DEPT_NM);
			$("#OFLV").val(rec.OFLV);
		},
		fn_create : function(){
			if(!_thisPage.fn_save_valid()){
				return false;
			}
			var input = {};
			input["USER_NM"]  		= $("#USER_NM").val();
			input["USER_ID"]  		= $("#USER_ID").val();
			input["USER_ID_BASE"]	= getUserId
			input["EMAL"]  			= $("#EMAL").val();
			input["CLPH_NO"]  		= $("#CLPH_NO").val().replace(/-/g, "");
			input["DEPT_NM"]  		= $("#DEPT_NM").val();
			input["BIZ_NO"]  		= $("#BSNN_NM").data("biz_no");
			input["OFLV"]  			= $("#OFLV").val();
			input["STTS"] 	 		= $("input[name=stts]:checked").val();
			input["USE_ATHT"]  		= $("input[name=useAtht]:checked").val();
			input["USER_GB"]  		= $("input[name=userGb]:checked").val();

			var jexAjax = jex.createAjaxUtil('plfm_0101_02_c001');
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
			if(isDup){
				alert("아이디 중복 확인 필요");
				return false;
			}
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
		fn_dupChk : function(USER_ID){
			var jexAjax = jex.createAjaxUtil('plfm_0101_02_r001');
			jexAjax.set('USER_ID', USER_ID);
			jexAjax.execute(function(dat) {
				if (dat.TOT_CNT == 0) {
					alert("중복되지 않은 아이디입니다.");
					isDup = false;
				}else if (dat.TOT_CNT > 0) {
					alert("이미 사용되고 있는 아이디 입니다.");
					isDup = true;
				}
			});
		},
		fn_srchBiz : function(){
			var html = "";
			html +='<form method="post" name="biz_pop" id="biz_pop">';
			html +='</form>';
			$("body").append(html);
			fintech.common.winPop("didcs_pop",{"sizeW":"650","sizeH":"500","action":"/plfm_0101_04.act", "target" : "biz_pop"});
		},
		fn_close : function(){
			parent.smartClosePop("_thisPage.onload");
		}
}