/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : srvc_0202_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/srvc
 * @author         : 김별 (  )
 * @Description    : 질의 API 관리_상세화면
 * @History        : 20200810141056, 김별
 * </pre>
 **/
var isDup = true;
var i= 0;
$(function(){
	_thisPage.onload();
	getDsdlCd("CTGR_CD","B2001");
	getAppId();
	if($("#API_ID").val() == API_ID){
		isDup = false;
	}
	$(document).on("click",".cmdSave",function() {
		if(confirm("저장 시 매핑변수는 초기화 됩니다.")){
			_thisPage.fn_save();
		}
	});
	$(document).on("click",".cmdCancel",function() {
		location.href = "srvc_0202_01.act";
	});
	$(document).on("click","#btn_chk",function() {
		if($("#API_ID").val() == "")
			alert("id를 입력하세요.")
		else {
			if($("#API_ID").val() == API_ID){
				alert("현재 사용하고 있는 ID입니다.");
			} else{
				_thisPage.fn_dupChk($("#API_ID").val());
			}
		}
	});
	$(document).on("click","#btn_type",function() {
		_thisPage.fn_type();
	});
	$("#API_ID").on("change keyup paste", function() {
		isDup = true;
	});
	$(document).on("click", ".btn_minus", function(){
		$(this).closest("tr").remove();
	});
	$(document).on("click", ".btnAdd_header", function(){
		$(".table_header").append(_thisHtml.header);
	});
	$(document).on("click", ".btnAdd_field", function(){
		$(this).closest(".div_body").find(".tbl_content").append(_thisHtml.field);
	});
	$(document).on("click", ".btnAdd_record", function(){
		$(this).closest(".div_body").find(".tbl_content").append(_thisHtml.inputRecord(i));
		i++;
	});
	$(document).on("click", ".new_rec", function(){
		$("#frm1").remove();
		var $form = $("<form id='frm1' method='post'></form>");
		$form.append("<input name='REC_NO'	value='" + $(this).attr("data-rec_no") +"'>");
		$form.append("<input name='REC_DATA'	value='"+fintech.common.null2void($(this).attr("data-rec_data"))+"'>");
		$form.append("<input name='FLD_NM'	value='" + fintech.common.null2void($(this).attr("data-fld_nm")) +"'>");
		$form.append("<input name='FLD_ID'	value='" + fintech.common.null2void($(this).attr("data-fld_id")) +"'>");
		smartOpenPop({href: "srvc_0202_03.act", width:792, height:495, scrolling:false, target:window, frm:$form});
	});
});

var _thisPage = {
		onload : function(){
			if(API_ID && APP_ID){
				isDup = false;
				_thisPage.fn_setData(API_ID, APP_ID);
			}
		},
		fn_setData : function(API_ID, APP_ID){
			var jexAjax = jex.createAjaxUtil('srvc_0202_02_r002');
			jexAjax.set('API_ID', API_ID);
			jexAjax.set('APP_ID', APP_ID);
			jexAjax.execute(function(dat) {
				var recInfm = dat.REC_INFM[0];
				$("#APP_ID").val(recInfm.APP_ID);
				$("#CTGR_CD").val(recInfm.CTGR_CD);
				$("#API_ID").val(recInfm.API_ID);
				$("#QUES_CTT").val(recInfm.QUES_CTT);
				$("input:radio[name='STTS'][value="+recInfm.STTS+"]").prop('checked', true);
				$("#API_URL").val(recInfm.API_URL);
				$(".table_header tr").remove();
				$(".table_request tr").remove();
				$(".table_response tr").remove();
				
				$.each(dat.REC_HEADER, function(idx, rec){
					$(".div_body:eq(1) .btnAdd_header").trigger("click");
				});
				var recIn=-1;
				var tmpNmInput="";
				var inputData = [];
				var inputlength = dat.REC_INPUT.length;
				$.each(dat.REC_INPUT, function(idx, rec){
					if(fintech.common.null2void(rec.UP_FLD_ID)=="" && fintech.common.null2void(rec.FLD_TYPE) == "F"){
						//field를 먼저 읽어와야 index 순서대로 뿌려줌! (ordering)
						$(".div_body:eq(2) .btnAdd_field").trigger("click");
						$(".table_request .FLD_ID:eq("+idx+")").val(rec.FLD_ID);
						$(".table_request .FLD_NM:eq("+idx+")").val(rec.FLD_NM);
						$(".table_request .DATA_TYPE:eq("+idx+")").val(rec.DATA_TYPE);
						$(".table_request .DATA_SIZE:eq("+idx+")").val(rec.DATA_SIZE);
						$(".table_request .MDTY_YN:eq("+idx+")").val(rec.MDTY_YN);
					} else if(fintech.common.null2void(rec.UP_FLD_ID) == "" && fintech.common.null2void(rec.FLD_TYPE) == "R"){
						recIn++;
						$(".div_body:eq(2) .btnAdd_record").trigger("click");
						$(".table_request .new_rec:eq("+recIn+")").attr("data-fld_id", rec.FLD_ID);
						$(".table_request .new_rec:eq("+recIn+")").attr("data-fld_nm", rec.FLD_NM);
						$(".table_request .new_rec:eq("+recIn+") font").text("REC("+$(".table_request .new_rec:eq("+recIn+")").data("fld_nm")+"/"+$(".table_request .new_rec:eq("+recOut+")").data("fld_id")+")");
					} else if(fintech.common.null2void(rec.UP_FLD_ID != "")){
						//up_fld_nm이 변경되면 a태그에 record 넣어주는 형식
						if(tmpNmInput !=rec.UP_FLD_ID){
							$("a[data-fld_id='"+tmpNmInput+"']").attr("data-rec_data", JSON.stringify(inputData));
							tmpNmInput = rec.UP_FLD_ID;
							inputData = [];
						}
						inputData.push(rec);
						if(idx == inputlength-1){
							$("a[data-fld_id='"+tmpNmInput+"']").attr("data-rec_data", JSON.stringify(inputData));
						}
						console.log(tmpNmInput);
					}
				});
				var recOut=-1;
				var tmpNmOutput="";
				var outputData = [];
				var outputlength = dat.REC_OUTPUT.length;
				$.each(dat.REC_OUTPUT, function(idx, rec){
					
					if(fintech.common.null2void(rec.UP_FLD_ID) == "" && fintech.common.null2void(rec.FLD_TYPE) == "F"){
						/*console.log(rec + " :: " + idx);*/
						$(".div_body:eq(3) .btnAdd_field").trigger("click");
						$(".table_response .FLD_ID:eq("+idx+")").val(rec.FLD_ID);
						$(".table_response .FLD_NM:eq("+idx+")").val(rec.FLD_NM);
						$(".table_response .DATA_TYPE:eq("+idx+")").val(rec.DATA_TYPE);
						$(".table_response .DATA_SIZE:eq("+idx+")").val(rec.DATA_SIZE);
						$(".table_response .MDTY_YN:eq("+idx+")").val(rec.MDTY_YN);
					} else if(fintech.common.null2void(rec.UP_FLD_ID) == "" && fintech.common.null2void(rec.FLD_TYPE) == "R"){
						recOut++;
						$(".div_body:eq(3) .btnAdd_record").trigger("click");
						$(".table_response .new_rec:eq("+recOut+")").attr("data-fld_id", rec.FLD_ID);
						$(".table_response .new_rec:eq("+recOut+")").attr("data-fld_nm", rec.FLD_NM);
						$(".table_response .new_rec:eq("+recOut+") font").text("REC("+$(".table_response .new_rec:eq("+recOut+")").data("fld_nm")+"/"+$(".table_response .new_rec:eq("+recOut+")").data("fld_id")+")");
						console.log(recOut);
					} else if(fintech.common.null2void(rec.UP_FLD_ID != "")){
						if(tmpNmOutput !=rec.UP_FLD_ID){
							$("a[data-fld_id='"+tmpNmOutput+"']").attr("data-rec_data", JSON.stringify(outputData));
							tmpNmOutput = rec.UP_FLD_ID;
							outputData = [];
						}
						outputData.push(rec);
						if(idx == outputlength-1){
							$("a[data-fld_id='"+tmpNmOutput+"']").attr("data-rec_data", JSON.stringify(outputData));
						}
						console.log(tmpNmOutput);

						//tmp_nm이 변경되면
						//jsonData.push(rec);
					}
				});
				console.log(dat);
			});
		},
		fn_save : function(){
			if(!_thisPage.fn_save_valid()){
				return false;
			}
			var headerArray = [];
			var inputArray = [];
			var outputArray = [];
			$.each($(".tbl_content"), function(index){
				var APP_ID = $("#APP_ID").val();
				var API_ID = $("#API_ID").val();
				$this = $(this);
				$.each($this.find("tr"), function(i, v){
					// field && 빈 값이 아닐 때
					if($(v).find(".FLD_ID").val() != "" && $(v).find(".FLD_TYPE").text() != "RECORD"){
						var jsonREC = {};
						jsonREC["APP_ID"] = fintech.common.null2void(APP_ID);
						jsonREC["API_ID"] = fintech.common.null2void(API_ID);
						jsonREC["FLD_ID"] = fintech.common.null2void($(this).find(".FLD_ID").val());
						jsonREC["FLD_NM"] = fintech.common.null2void($(this).find(".FLD_NM").val());
						jsonREC["UP_FLD_ID"] = "";
						jsonREC["FLD_DPTH"] = "1";
						jsonREC["FLD_TYPE"] = fintech.common.null2void($(this).find(".FLD_TYPE").data("val"));
						jsonREC["DATA_TYPE"] = fintech.common.null2void($(this).find(".DATA_TYPE").val());
						jsonREC["DATA_SIZE"] = fintech.common.null2void($(this).find(".DATA_SIZE").val());
						jsonREC["OTPT_SQNC"] = i;
						jsonREC["MDTY_YN"] = fintech.common.null2void($(this).find(".MDTY_YN").val());
						jsonREC["MPPG_VRBS"] = fintech.common.null2void($(this).find(".FLD_ID").val());
						if(index == 0){
							jsonREC["FLD_DV"] = "H";
							headerArray.push(jsonREC);
						}
						else if(index == 1){
							jsonREC["FLD_DV"] = "I";
							inputArray.push(jsonREC);
						}
						else if(index == 2){
							jsonREC["FLD_DV"] = "O";
							outputArray.push(jsonREC);
						}
					} else if($(v).find(".FLD_TYPE").text() == "RECORD"){
						//record일 경우
						if(!$(this).find(".new_rec").data("rec_data")){
							var jsonREC = {};
							jsonREC["APP_ID"] = fintech.common.null2void(APP_ID);
							jsonREC["API_ID"] = fintech.common.null2void(API_ID);
							jsonREC["FLD_TYPE"] = "R";
							jsonREC["FLD_DPTH"] = "1";
							jsonREC["UP_FLD_ID"] = "";
							jsonREC["FLD_ID"] = fintech.common.null2void($(v).find(".new_rec").attr("data-fld_id"));
							jsonREC["FLD_NM"] = fintech.common.null2void($(v).find(".new_rec").attr("data-fld_nm"));
							jsonREC["MPPG_VRBS"] = fintech.common.null2void($(v).find(".new_rec").attr("data-fld_id"));
							if(index == 1){
								jsonREC["FLD_DV"] = "I";
								inputArray.push(jsonREC);
							}
							else if(index == 2){
								jsonREC["FLD_DV"] = "O";
								outputArray.push(jsonREC);
							}
						}
						else{
							var jsonData = $(v).find(".new_rec").data("rec_data");
							for(i=0; i<jsonData.length+1; i++){
								var jsonREC2 = {};
								jsonREC2["APP_ID"] = APP_ID;
								jsonREC2["API_ID"] = API_ID;
								if(i==jsonData.length){ //record값 저장
									jsonREC2["FLD_ID"] = fintech.common.null2void($(v).find(".new_rec").attr("data-fld_id"));
									jsonREC2["FLD_NM"] = fintech.common.null2void($(v).find(".new_rec").attr("data-fld_nm"));
									jsonREC2["MPPG_VRBS"] = fintech.common.null2void($(v).find(".new_rec").attr("data-fld_id"));
									jsonREC2["UP_FLD_ID"] = "";
									jsonREC2["FLD_DPTH"] = "1";
									jsonREC2["FLD_TYPE"] = "R";
									jsonREC2["DATA_TYPE"] = "VARCHAR";
									jsonREC2["DATA_SIZE"] = "0";
								} else{ // 각각 필드 저장
									jsonREC2["FLD_ID"] = fintech.common.null2void(jsonData[i].FLD_ID);
									jsonREC2["FLD_NM"] = fintech.common.null2void(jsonData[i].FLD_NM);
									jsonREC2["UP_FLD_ID"] = fintech.common.null2void(jsonData[i].UP_FLD_ID);
									jsonREC2["FLD_DPTH"] = "1";
									jsonREC2["DATA_TYPE"] = fintech.common.null2void(jsonData[i].DATA_TYPE);
									jsonREC2["DATA_SIZE"] = fintech.common.null2void(jsonData[i].DATA_SIZE);
									jsonREC2["OTPT_SQNC"] = i;
									jsonREC2["MDTY_YN"] = fintech.common.null2void(jsonData[i].MDTY_YN);
									jsonREC2["MPPG_VRBS"] = fintech.common.null2void(jsonData[i].FLD_ID);
									jsonREC2["FLD_TYPE"] = "F";
								}
								if(index == 1){
									jsonREC2["FLD_DV"] = "I";
									inputArray.push(jsonREC2);
								}
								else if(index == 2){
									jsonREC2["FLD_DV"] = "O";
									outputArray.push(jsonREC2);
								}
							}
						}
					}
				});
			});
			
			console.log("headerArray :: "+JSON.stringify(headerArray));
			console.log("inputArray :: "+JSON.stringify(inputArray));
			console.log("outputArray :: "+JSON.stringify(outputArray));
			//create
			var jexAjax = jex.createAjaxUtil('srvc_0202_02_c001');
			jexAjax.set("APP_ID_BASE", APP_ID);
			jexAjax.set("API_ID_BASE", API_ID);
			jexAjax.set('HEADER_REC', headerArray);
			jexAjax.set('INPUT_REC', inputArray);
			jexAjax.set('OUTPUT_REC', outputArray);
			jexAjax.set("APP_ID", $("#APP_ID").val());
			jexAjax.set("API_ID", $("#API_ID").val());
			jexAjax.set("API_URL", $("#API_URL").val());
			jexAjax.set("CTGR_CD", $("#CTGR_CD").val());
			jexAjax.set("STTS", $("input:radio[name=STTS]:checked").val());
			jexAjax.set("QUES_CTT", $("#QUES_CTT").val());
			jexAjax.set("QUES_RSLT_TYPE", $("#QUES_RSLT_TYPE").val());
			jexAjax.set("QUES_DESC", $("#QUES_DESC").val());
			
			jexAjax.execute(function(dat) {
				if(dat.RSLT_CD == "0000"){
					alert("저장되었습니다.");
					location.href = "srvc_0202_01.act";
				} else if(dat.RSLT_CD == "9999"){
					alert("처리 중 오류가 생겼습니다.");
				}
				
			});
		},
		fn_save_valid : function(){
			if(isDup){
				alert("아이디 중복 확인 필요");
				return false;
			}
			result = true;
			$(".pk").each(function(){
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
		fn_dupChk : function(API_ID){
			var jexAjax = jex.createAjaxUtil('srvc_0202_02_r001');
			jexAjax.set('API_ID', API_ID);
			jexAjax.execute(function(dat) {
				if (dat.API_CNT == 0) {
					alert("중복되지 않은 아이디입니다.");
					isDup = false;
				}else if (dat.API_CNT > 0) {
					alert("해당 앱에서 이미 사용되고 있는 아이디 입니다.");
					isDup = true;
					
				}
			});
		}, 
		fn_type : function(){
			/*var $form = $("<form method='post'></form>");
			smartOpenPop({href: "srvc_0203_03.act", width:750, height:495, scrolling:false, target:window, frm:$form});*/
		}
}

function fn_recData(jsonObj){
	console.log(jsonObj);
	$(".new_rec[data-rec_no="+jsonObj.rec_no+"]").attr({
			"data-rec_data": JSON.stringify(jsonObj.rec_data),
			"data-fld_nm": jsonObj.FLD_NM,
			"data-fld_id": jsonObj.FLD_ID
	});
	$(".new_rec[data-rec_no="+jsonObj.rec_no+"] font").text("REC("+$(".new_rec[data-rec_no="+jsonObj.rec_no+"]").data("fld_nm")+")");
}
function getDsdlCd(loct, grp_cd,item_cd, item_nm){
	var jexAjax = jex.createAjaxUtil("srvc_0103_01_r002");   //PT_ACTION 웹 서비스 호출
	jexAjax.set("DSDL_GRP_CD", grp_cd);
	jexAjax.set("DSDL_ITEM_CD", item_cd);
	jexAjax.set("DSDL_ITEM_NM", item_nm);
	jexAjax.execute(function(dat) {
		var html = "<option value=''>선택하세요.</option>";
		$.each(dat.REC, function(i, v) {
			html += "<option value="+v.DSDL_ITEM_CD+">"+v.DSDL_ITEM_NM+"</option>";
		});
		var location = "#"+loct+"";
		$(location).empty();
		$(location).append(html);
	});
}
function getAppId(){
	var jexAjax = jex.createAjaxUtil("srvc_0101_01_r001");   //PT_ACTION 웹 서비스 호출
	jexAjax.execute(function(dat) {
		var html = "<option value=''>선택하세요.</option>";
		$.each(dat.REC, function(i, v) {
			html += "<option value="+v.APP_ID+">"+v.APP_NM+"</option>";
		});
		
		$("#APP_ID").empty();
		$("#APP_ID").append(html);
	});
}
function __fn_init(){
	$("#srvc_0202_01").parents("div").addClass("on");
}


var _thisHtml = {
		header : "<tr>" +
					"<td scope='col'>" +
						"<input type='text' class='FLD_ID' style='width:95%'/>" +
					"</td>" +
					"<td scope='col'>" +
						"<input type='text' class='FLD_NM' style='width:95%'/>" +
					"</td>" +
					"<td>" +
						"<a id='btn_minus' class='btn_style3 btn_minus' ><span style='min-width:15px !important;'>-</span></a>" +
					"</td>" +
				"</tr>",
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
					"<td scope='col'><span class='FLD_TYPE' data-val='F'>FIELD</span></td>" +
					"<td>" +
						"<a id='btn_minus' class='btn_style3 btn_minus' ><span style='min-width:15px !important;'>-</span></a>" +
					"</td>" +
				"</tr>",
		inputRecord : function(i){
			var record = "";
			record += "<tr>";
			record +=	"<td colspan='5' style='text-align:center;'>";
			record +=		"<a class='new_rec' data-rec_no="+i+"><font color='blue' style='text-decoration:underline'>REC</font></a>";
			record +=	"</td>";
			record +=	"<td scope='col'><span class='FLD_TYPE' data-val='R'>RECORD</span></td>";
			record +=	"<td >";
			record +=		"<a id='btn_minus' class='btn_style3 btn_minus' ><span style='min-width:15px !important;'>-</span></a>";
			record +=	"</td>" ;
			record +="</tr>";
			return record;
		}
	}