/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : srvc_0202_03.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/srvc
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200907173745, 김별
 * </pre>
 **/
$(function(){
	$(document).on("click", ".btnAdd_field", function(){
		$(this).closest(".div_body").find(".tbl_content").append(_thisHtml.field);
	});
	$(document).on("click", ".btn_minus", function(){
		$(this).closest("tr").remove();
	});
	$(".popupClose").on("click", function(){
		_thisPage.fn_close();
	});
	$(".cmdSave").on("click", function(){
		_thisPage.fn_save();
	})
	_thisPage.fn_setData();
});

var _thisPage = {
	fn_setData : function(){
		$("#REC_NM").val(fintech.common.null2void(FLD_NM));
		$("#REC_ID").val(fintech.common.null2void(FLD_ID));
		console.log(REC_DATA);
		if(REC_DATA != ""){
			$(".tbl_content tr").remove();
			var JSONdata = JSON.parse(REC_DATA);
			$.each(JSONdata, function(i, v){
				$(".btnAdd_field").trigger("click");
				$(".FLD_ID:eq("+i+")").val(v.FLD_ID);
				$(".FLD_NM:eq("+i+")").val(v.FLD_NM);
				$(".DATA_SIZE:eq("+i+")").val(v.DATA_SIZE);
				$(".MDTY_YN:eq("+i+")").val(v.MDTY_YN);
				$(".DATA_TYPE:eq("+i+")").val(v.DATA_TYPE);
			})
		}
	},
	fn_save : function(){
		var jsonArr = [];
		var jsonObj = {};
		$(".tbl_layout tr").each(function(i, v){
			var i = {"UP_FLD_ID":$("#REC_ID").val(), "FLD_ID":$(v).find(".FLD_ID").val(), "FLD_NM":$(v).find(".FLD_NM").val(), "DATA_TYPE":$(v).find(".DATA_TYPE").val(), "DATA_SIZE":$(v).find(".DATA_SIZE").val(), "MDTY_YN":$(v).find(".MDTY_YN").val()};
			jsonArr.push(i);
		});
		jsonObj["FLD_ID"] = $("#REC_ID").val();
		jsonObj["FLD_NM"] = $("#REC_NM").val();
		jsonObj["rec_no"]=REC_NO;
		jsonObj["rec_data"]=jsonArr;
		/*localStorage.setItem($("#REC_ID").val(), JSON.stringify());*/
		parent.smartClosePop("fn_recData", jsonObj);
	},
	fn_close : function(){
		parent.smartClosePop();
	},
	
} 

var _thisHtml = {
		field : "<tr>" +
					"<td scope='col'>" +
						"<input type='text' class='FLD_ID' style='width:95%'/>" +
					"</td>" +
					"<td scope='col'>" +
						"<input type='text' class='FLD_NM' style='width:95%'/>" +
					"</td>" +
					"<td scope='col'>" +
						"<select class='DATA_TYPE' style='width:95%'>" +
							"<option value='VARCHAR'>VARCHAR</option>	" +
							"<option value='NUMBER'>NUMBER</option>" +
						"</select>" +
					"</td>" +
					"<td scope='col'>" +
						"<input type='text' class='DATA_SIZE' style='width:95%'/>" +
					"</td>" +
					"<td scope='col'>" +
						"<select class='MDTY_YN' style='width:95%'>" +
							"<option value='Y'>YES</option>	" +
							"<option value='N'>NO</option>" +
						"</select>" +
					"</td>" +
					"<td>" +
						"<a id='btn_minus' class='btn_style3 btn_minus' ><span style='min-width:15px !important;'>-</span></a>" +
					"</td>" +
				"</tr>",
	}