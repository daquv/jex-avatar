/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name	  : blbd_0301_02.js
 * @File path	  : AVATAR_STATIC/web/js/jex/avatar/admin/blbd
 * @author		 : 김별 (  )
 * @Description	: 
 * @History		: 20210506104434, 김별
 * </pre>
 **/
 $(function(){
	_thisPage.onload();
	$(document).on("click", ".btnCancel", function(){
		location.href="blbd_0301_01.act";
	});
	$(document).on("click", ".cmdSave", function(){
		_thisPage.fn_save();
	})
 });
 
 var _thisPage = {
	onload(){
		datePicker.setCalendar("#CNSL_DT");
		_thisPage.setData();
	},	
	setData(){
		//문의 set
		var jexAjax = jex.createAjaxUtil("blbd_0301_01_r001");   //PT_ACTION 웹 서비스 호출
		input = {};
		input["CNSL_NO"] = $("input[name='CNSL_NO']").val();
		jexAjax.set(input);
		jexAjax.execute(function(dat){
			var rec = dat.REC[0];
			//문의 set
			$("#RQST_DT").text(formatter.date(rec.RQST_DT));
			$("#RQST_CLPH_NO").text(formatter.phone(rec.RQST_CLPH_NO));
			$("#RQST_BSNN_NM").text(rec.RQST_BSNN_NM);
			$("#RQST_EML").text(rec.RQST_EML);
			$("#RQST_BIZ_NO").text(formatter.corpNum(rec.RQST_BIZ_NO));
			if(rec.CNSL_DIV == "1")
			   $("#CNSL_DIV").text("협력문의");
			$("#RQST_CUST_NM").text(rec.RQST_CUST_NM);
			var RQST_CTT = rec.RQST_CTT.replace(/\n/g,'<br/>' );
			$("#RQST_CTT").html(RQST_CTT);
			//답변 set
			$("#CNSL_STTS").val(rec.CNSL_STTS);
			$("#CNSL_DT").val(formatter.date(rec.CNSL_DT));
			
			if(fintech.common.null2void($("#CNSL_DT").val()) == "")
			   $("#CNSL_DT").val(fintech.common.getDate("yyyy-mm-dd")  );
			$("#CNSL_CTT").text(rec.CNSL_CTT);
		});
		 
	}, 
	fn_save(){
		var jexAjax = jex.createAjaxUtil("blbd_0301_01_u001");   //PT_ACTION 웹 서비스 호출
			
			input = {};
			input["CNSL_NO"] = $("input[name='CNSL_NO']").val();
			input["CNSL_STTS"] = $("#CNSL_STTS").val();
			input["CNSL_DT"] = $("#CNSL_DT").val().replace(/-/g, '');
			input["CNSL_CTT"] = $("#CNSL_CTT").val();
			
			jexAjax.set(input);
			jexAjax.set('async',false);
			jexAjax.execute(function(dat) {
				if(dat.RSLT_CD=="0000"){
					alert("저장되었습니다.");
					location.href="blbd_0301_01.act";
				} else if(dat.RSLT_CD=="9999") {
					alert("처리중 오류가 발생하였습니다.");
				}
			});
			
	}
}
function __fn_init(){
	$("#blbd_0301_01").parents("div").addClass("on");
 }
 