/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : srvc_0102_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/srvc
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200306181500, 김별
 * </pre>
 **/
$(function(){
	_thisPage.onload();
	$(".cmdSave").on("click",function(){
		_thisPage.fn_update();
		/*if(quesCtt != "")
			_thisPage.fn_update(quesCtt);
		else
			_thisPage.fn_create();*/
	});
	$(".popupClose").on("click", function(){
		_thisPage.fn_close();
	});
	//인텐트 값 가져오기, popupclose 이미지 넣기, 
});

var _thisPage = { 
		onload : function(){
			getDsdlCd("CTGR_CD", "B2001");
			//_thisPage.getInte();
 			if(fintech.common.null2void($("#API_ID_BASE").val()) != "" && fintech.common.null2void($("#APP_ID_BASE").val()) != "")
				_thisPage.setData();
				
		},
		setData : function(){
			var input = {};
			input["APP_ID"]		= fintech.common.null2void($("#APP_ID_BASE").val());
			input["API_ID"]		= fintech.common.null2void($("#API_ID_BASE").val());
			
			var jexAjax = jex.createAjaxUtil('srvc_0102_02_r002');
			jexAjax.set(input);
			jexAjax.execute(function(dat){
				var rec = dat.REC[0];
				$("#APP_ID").text(rec.APP_NM);
				$("#API_ID").text(rec.API_ID);
				$("#CTGR_CD").text(rec.CTGR_CD_NM);
				$("input:radio[name='STTS'][value="+rec.STTS+"]").prop("checked", true);
				if(fintech.common.null2void(rec.INTE_CD) == "")
					$("#INTE_CD").text("");
				else{
					var jexAjax = jex.createAjaxUtil('srvc_0102_02_r001');
					jexAjax.set("INTE_CD", rec.INTE_CD)
					jexAjax.execute(function(data) {
						$("#INTE_CD").text(data.REC[0].INTE_NM);
					});
				}
			});
		},
		getInte : function(inte_cd){
			var jexAjax = jex.createAjaxUtil('srvc_0102_02_r001');
			jexAjax.set("INTE_CD", inte_cd)
			jexAjax.execute(function(data) {
				inte_nm = data.REC[0].INTE_NM;
			});
		},
		fn_callback_dv : function(){
			$.each(dat.REC, function(idx, rec){
				var tmpHtml = '<option value="">전체</option>';
				$.each(data.REC,function(i,v){
					tmpHtml +='<option value="'+v.DSDL_ITEM_CD+'">'+v.DSDL_ITEM_NM+'</option>';	
				});
				$("#INTE_DV").html(tmpHtml);
			});
		},
		fn_create : function(){
			if(!_thisPage.fn_save_valid()){
				return false;
			}
			var input = {};
			//input["QUES_NO"]  		= $("#QUES_NO").val();
			input["QUES_CTT"] 		= $("#QUES_CTT").val();
			//input["INTE_DV"]		= $("#INTE_DV").val();
			input["INTE_CD"]  		= $("#INTE_CD").val();
			input["MEMO"]			= $("#MEMO").val();

			var jexAjax = jex.createAjaxUtil('srvc_0102_02_c001');
			jexAjax.set(input);
			jexAjax.execute(function(dat) {
				if (dat.ERR_CD == "0000") {
					alert("저장되었습니다.");
					parent.smartClosePop("_thisPage.fn_search");
					
				}else if (dat.ERR_CD == "9999") {
					alert("처리 중 오류가 발생하였습니다.");
				}
			});
		},
		fn_update : function(){
			
			var datelist = new Array();
			datelist.push({
				API_ID	: $("#API_ID_BASE").val(),
				APP_ID : $("#APP_ID_BASE").val(),
				STTS : $("input:radio[name='STTS']:checked").val()
			});
			var jexAjax  = jex.createAjaxUtil('srvc_0102_01_u001');
			console.log(datelist);
			jexAjax.set("REC"        , datelist); // REC
			jexAjax.set("_LODING_BAR_YN_", "Y"                           ); // 로딩바 출력여부
			
			jexAjax.execute(function(dat) {
				if(dat.RSLT_CD=="0000"){
					alert("정상적으로 처리되었습니다.");
					parent.smartClosePop("_thisPage.fn_search");
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
			parent.smartClosePop();
		}
}
function getDsdlCd(loct, grp_cd, item_cd, item_nm){
	var jexAjax = jex.createAjaxUtil("srvc_0103_01_r002");   //PT_ACTION 웹 서비스 호출
	jexAjax.set("DSDL_GRP_CD", grp_cd);
	jexAjax.set("DSDL_ITEM_CD", item_cd);
	jexAjax.set("DSDL_ITEM_NM", item_nm);
	jexAjax.execute(function(dat) {
		var html = "<option value=''>전체</option>";
		$.each(dat.REC, function(i, v) {
			html += "<option value="+v.DSDL_ITEM_CD+">"+v.DSDL_ITEM_NM+"</option>";
		});
		var location = "#"+loct+"";
		$(location).append(html);
	});
}