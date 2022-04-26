/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : srvc_0103_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/srvc
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200309165447, 김별
 * </pre>
 **/
var isClicked = false;
var isNew = false;
getDsdlCd("CTGR_CD","B2001");
getDsdlCd("QUES_LVL","B2003");
getDsdlCd("QUES_RSLT_TYPE","B2002");
getAppId();
$(function(){
	_thisPage.onload();
	//등록 및 수정
	$(document).on("click", ".cmdSave", function(){
		if(confirm("저장하시겠습니까? 변경 후 복구가 어려울 수 있습니다.")){
			_thisPage.fn_create();
		} else {
		}
	});
	
	$(document).on("click", ".apiSearch", function(){
		//alert("api search popup");
		_apiPage.fn_searchPopUp();
	})
	$(document).on("click", ".apiDelete", function(){
		//alert("api search popup");
		_apiPage.fn_apiDelete();
	})
	//미리보기
	$(document).on("click", ".btn_preview", function(){
		_thisPage.fn_preview($(this).closest("tr").prev().find(".html"));
	});
	$(document).on("change", "#_APP_ID", function(){
		alert("APP ID 변경 시 정상 작동하지 않을 수 있습니다.");
	})
	$(document).on("click", ".tbl_result tr", function(){
		if(!$(this).hasClass("on")){
			$(this).addClass("on");
			$(this).css("background-color", "#f4f4f4");
		} else {
			$(this).removeClass("on");
			$(this).css("background-color", "inherit");
		}
	});
	
});

var _thisPage = {
		onload : function(){
			_infoPage.onload();
		},
		fn_create : function(){
			if(!_thisPage.fn_save_valid()){
				return false;
			}
			var input = {};
			/*infoPage*/
			input["INTE_CD_BASE"] = 	$("#INTE_CD_BASE").val(); 
			if($("#INTE_CD_BASE").val()){input["INTE_CD"] = $("#INTE_CD").text();}
			else{input["INTE_CD"] = $("#INTE_CD").val();}
			input["INTE_NM"] = 			$("#INTE_NM").val();
			input["CTGR_CD"] = 			$("#CTGR_CD option:selected").val();
			input["QUES_RSLT_TYPE"] = 	$("#QUES_RSLT_TYPE option:selected").val();
			input["QUES_LVL"] =			$("#QUES_LVL option:selected").val();
			input["STTS"] = 			$("#STTS option:selected").val();
			input["OTPT_SQNC"] = 		$("#OTPT_SQNC").val();
			input["QUES_CTT"] = 		$("#QUES_CTT").val();
			
			
			/*dbPage*/
			input["OTXT_HTML"] = $("#OTXT_HTML").val();
			input["SMPL_HTML"] = $("#SMPL_HTML").val();
			input["OTXT_SQL1"] = $("#OTXT_SQL1").val();
			input["OTXT_SQL1_TYPE"] = $("input[name='OTXT_SQL1_TYPE']:checked").val();
			input["OTXT_SQL2"] = $("#OTXT_SQL2").val();
			input["OTXT_SQL2_TYPE"] = $("input[name='OTXT_SQL2_TYPE']:checked").val();
			input["OTXT_SQL3"] = $("#OTXT_SQL3").val();
			input["OTXT_SQL3_TYPE"] = $("input[name='OTXT_SQL3_TYPE']:checked").val();
			input["OTXT_SQL4"] = $("#OTXT_SQL4").val();
			input["OTXT_SQL4_TYPE"] = $("input[name='OTXT_SQL4_TYPE']:checked").val();
			
			input["APP_ID"] = fintech.common.null2void($("#_APP_ID").val())===""?$("#APP_ID").data("app_id"):$("#_APP_ID").val();
			input["API_ID"] = $("#API_ID").text();
			
			/*apiPage*/
			var recArray = [];
			$.each($(".table_layout tbody tr"), function(i, v){
				var $this = $(this);
				var jsonREC = {};
				jsonREC["MPPG_VRBS"		    ] = $this.find("#MPPG_VRBS").val();
				jsonREC["APP_ID"			] = $("#APP_ID").data("app_id");
				jsonREC["API_ID"			] = $("#API_ID").text();
				jsonREC["FLD_DV"		    ] = $this.find("#FLD_ID").data("fld_dv");
				jsonREC["UP_FLD_ID"		    ] = $this.find("#FLD_ID").data("up_fld_id")? $this.find("#FLD_ID").data("up_fld_id") : "";
				jsonREC["FLD_ID"		    ] = $this.find("#FLD_ID").data("fld_id");
				recArray.push(jsonREC);
				console.log(recArray);
			});
			
			/*save*/
			var jexAjax = jex.createAjaxUtil('srvc_0103_02_c001');
			jexAjax.set(input);
			jexAjax.set("INSERT_REC",recArray);
			jexAjax.execute(function(dat){
				if(dat.RSLT_CD == "0000"){
					alert("저장되었습니다.");
					location.href="srvc_0103_01.act";
				} else if(dat.RSLT_CD == "9999"){
					alert("처리 중 오류가 발생하였습니다.");
				} else if(dat.RSLT_CD == "8888") {
				}
			});
			
		},
		fn_save_valid : function(){
			var result = true;
			$(".point").closest("th").next().find("div").children().each(function(){
				if(""==$(this).val()){
					var alert_msg = "필수입력 항목이 누락되었습니다.";
					alert("["+$(this).closest("td").prev().find("div").text()+"] "+alert_msg);
					$(this).focus();
					result = false;
					return false;
				}
			});
			return result;
		},
		fn_preview : function($this){
			$("#preview").ready(function(){
				$("#preview").contents().find(".m_cont").html($this.val());
			});
		},
}
var _infoPage = {
		onload : function(){
			if($("#INTE_CD_BASE").val()){
				_infoPage.fn_setData($("#INTE_CD_BASE").val());
			}
		},
		fn_setData : function(inteCd){
			var jexAjax = jex.createAjaxUtil('srvc_0103_02_r001');
			jexAjax.set("INTE_CD", inteCd);
			jexAjax.execute(function(dat){
				console.log(dat);
				var rec = dat.REC[0];
				$("#_APP_ID").val(rec.APP_ID);
				$("#APP_ID").text(rec.APP_ID);
				$("#INTE_CD").text(rec.INTE_CD);
				$("#INTE_NM").val(rec.INTE_NM);
				$("#CTGR_CD").val(rec.CTGR_CD).attr("selected", true);
				$("#QUES_LVL").val(rec.QUES_LVL);
				$("#STTS").val(rec.STTS);
				
				$("#QUES_CTT").val(rec.QUES_CTT);
				$("#OTPT_SQNC").val(rec.OTPT_SQNC);
				$("#QUES_RSLT_TYPE").val(rec.QUES_RSLT_TYPE);
				if(fintech.common.null2void(rec.RSMB_SRCH_METH)==""){
					$("#RSMB_SRCH_YN").val("9");
					$("#RSMB .cont_btn").parents("a").css("pointer-events", "none");
				}
				else{
					$("#RSMB_SRCH_YN").val("1");
					$("#RSMB .cont_btn").parents("a").css("pointer-events", "inherit");
				}
				
				$("input[name=RSMB_SRCH_METH][value='"+rec.RSMB_SRCH_METH+"']").attr("checked", true);
				$("#RSMB_SRCH_TXT").val(rec.RSMB_SRCH_TXT);
				
				if(fintech.common.null2void(dat.API_CNT)!="")
					_apiPage.onload();
				
				$("#OTXT_HTML").val(rec.OTXT_HTML);
				$("#SMPL_HTML").val(rec.SMPL_HTML);
				$("input[name=OTXT_SQL1_TYPE][value='"+rec.OTXT_SQL1_TYPE+"']").attr("checked", true);
				$("#OTXT_SQL1").val(rec.OTXT_SQL1);
				$("input[name=OTXT_SQL2_TYPE][value="+rec.OTXT_SQL2_TYPE+"]").attr("checked", true);
				$("#OTXT_SQL2").val(rec.OTXT_SQL2);
				$("input[name=OTXT_SQL3_TYPE][value="+rec.OTXT_SQL3_TYPE+"]").attr("checked", true);
				$("#OTXT_SQL3").val(rec.OTXT_SQL3);
				$("input[name=OTXT_SQL4_TYPE][value="+rec.OTXT_SQL4_TYPE+"]").attr("checked", true);
				$("#OTXT_SQL4").val(rec.OTXT_SQL4);
			});
		},
}

var _apiPage = {
		onload : function(){
			//ques_api_infm에 등록되어 있으면 읽어오기
			//
			_apiPage.fn_searchData();
		},
		fn_searchData : function(data){
			var jexAjax = jex.createAjaxUtil("srvc_0103_02_r003");
			jexAjax.set("INTE_CD", $("#INTE_CD_BASE").val());
			jexAjax.set(data);
			if(data)	isNew = false;
			else	isNew = true;
			jexAjax.execute(function(dat){
				_apiPage.fn_setData(dat, isNew);
			});
		},
		fn_setData : function(dat, isNew){
			console.log(dat);
			console.log(JSON.parse(dat.RSLT_CTT));
			if(dat.REC.length > 0){
				var tabIdx = 2;
				var $clone_org = $(".tabs li").last().clone();
				for(i=0; i<dat.REC.length; i++){
					if(i===0) $clone = $(".tabs li").last();
					else $clone = $clone_org;
/*					if(isNew){
					} else{
						$clone = $(".tabs input[name=tabs]:checked").parent("li");
					}
*/					

					var infoRec = dat.REC[i];
					$clone.find("#APP_ID").text(fintech.common.null2void(infoRec.APP_NM));
					$clone.find("#APP_ID").attr("data-app_id", fintech.common.null2void(infoRec.APP_ID));
					$clone.find("#API_ID").text(fintech.common.null2void(infoRec.API_ID));
					$clone.find("#QUES_CTT2").text(fintech.common.null2void(infoRec.QUES_CTT));
					
					var jsonData = JSON.parse(dat.RSLT_CTT)["RSLT"][0];
					console.log(jsonData.REC_INPUT);
					console.log($clone);
					if(jsonData.REC_INPUT.length>0){
						_apiPage.makeInputTable(jsonData.REC_INPUT, $clone);
						_apiPage.makeOutputTable(jsonData.REC_OUTPUT, $clone);
						_apiPage.makeOutputRECTable(jsonData.REC_OUTPUT_REC, $clone);
					} else {
						$clone.find("#tbl_input").find("tbody").empty()
						$clone.find("#tbl_output").find("tbody").empty()
						$clone.find(".table_output_rec").empty();
					}
					
					if(i>0) {
						tabIdx++;
						$clone.find("input#tab1").attr("id","tab" + tabIdx).val(i+1);
						$clone.find("label#tab_api").attr({"id":"tab_api" + tabIdx, "for": "tab" + tabIdx});
						$("ul.tabs").append($clone);
					}
					
				}
			}
		},
		makeInputTable : function(rec, tbl){
			var inputHtml = '';
			$.each(rec, function(idx, rec){
				inputHtml +='<tr>';
				inputHtml +='	<td><div><span>'+rec.FLD_NM+'</span></div></td>';
				inputHtml +='	<td><div><span id="FLD_ID" data-fld_id='+rec.FLD_ID+' data-fld_dv='+rec.FLD_DV+'>'+rec.FLD_ID+'</span></div></td>';
				inputHtml +='	<td><div><span>'+rec.FLD_TYPE+'</span></div></td>';
				inputHtml +='	<td><div><span>'+rec.DATA_TYPE+'</span></div></td>';
				inputHtml +='	<td><div><span>'+rec.DATA_SIZE+'</span></div></td>';
				inputHtml +='	<td><div><input type="text" id="MPPG_VRBS" value='+rec.MPPG_VRBS+'></input></div></td>';
				inputHtml +='</tr>';
			});
			tbl.find("#tbl_input").find("tbody").append(inputHtml);
			
		},
		makeOutputTable : function(rec, tbl){
			console.log(rec);
			var outputHtml = '';
			$.each(rec, function(idx, rec){
				outputHtml +='<tr>';
				outputHtml +='	<td><div><span>'+rec.FLD_NM+'</span></div></td>';
				outputHtml +='	<td><div><span id="FLD_ID" data-fld_id='+rec.FLD_ID+' data-fld_dv='+rec.FLD_DV+'>'+rec.FLD_ID+'</span></div></td>';
				outputHtml +='	<td><div><span>'+rec.FLD_TYPE+'</span></div></td>';
				outputHtml +='	<td><div><span>'+rec.DATA_TYPE+'</span></div></td>';
				outputHtml +='	<td><div><span>'+rec.DATA_SIZE+'</span></div></td>';
				outputHtml +='	<td><div><input type="text" id="MPPG_VRBS" value='+rec.MPPG_VRBS+'></input></div></td>';
				outputHtml +='</tr>';
			});
			tbl.find("#tbl_output").find("tbody").append(outputHtml);
		},
		makeOutputRECTable : function(rec, tbl){
			if(rec){
				tbl.find(".table_output_rec").show();
				var tmp_nm = "";
				var cnt = 0;
				$.each(rec, function(idx, rec){
					if(tmp_nm != rec.UP_FLD_ID){
						tmp_nm = rec.UP_FLD_ID;
						if(cnt>0){
							var outputHtml = '';
							outputHtml += '<div class="table_layout table_output_rec" style="padding-top:10px;" >';
							outputHtml += '	<table class="tbl_input2" id="">';
							outputHtml += '		<colgroup>';
							outputHtml += '			<col><col><col><col><col><col width="30%">';
							outputHtml += '		</colgroup>';
							outputHtml += '		<thead>';
							outputHtml += '			<tr>';
							outputHtml += '				<th colspan="6"><div class="rec_nm"></div></th>';
							outputHtml += '			</tr>';
							outputHtml += '		</thead>';
							outputHtml += '		<tbody><tr></tr></tbody>';
							outputHtml += '	</table>';
							outputHtml += '</div>';
							tbl.find(".table_output_rec:eq("+(cnt-1)+")").after(outputHtml);
						}
						tbl.find(".table_output_rec:eq("+cnt+") .rec_nm").text(tmp_nm);
						cnt++;
						var outputHtml = '';
						outputHtml +='<tr>';
						outputHtml +='	<td><div><span>'+rec.FLD_NM+'</span></div></td>';
						outputHtml +='	<td><div><span id="FLD_ID" data-fld_id='+rec.FLD_ID+' data-fld_dv='+rec.FLD_DV+' data-up_fld_id='+rec.UP_FLD_ID+'>'+rec.FLD_ID+'</span></div></td>';
						outputHtml +='	<td><div><span>'+rec.FLD_TYPE+'</span></div></td>';
						outputHtml +='	<td><div><span>'+rec.DATA_TYPE+'</span></div></td>';
						outputHtml +='	<td><div><span>'+rec.DATA_SIZE+'</span></div></td>';
						outputHtml +='	<td><div><input type="text" id="MPPG_VRBS" value='+rec.MPPG_VRBS+'></input></div></td>';
						outputHtml +='</tr>';
						tbl.find(".table_output_rec:eq("+(cnt-1)+")").find("tbody").append(outputHtml);
					} else {
						var outputHtml = '';
						outputHtml +='<tr>';
						outputHtml +='	<td><div><span>'+rec.FLD_NM+'</span></div></td>';
						outputHtml +='	<td><div><span id="FLD_ID" data-fld_id='+rec.FLD_ID+' data-fld_dv='+rec.FLD_DV+' data-up_fld_id='+rec.UP_FLD_ID+'>'+rec.FLD_ID+'</span></div></td>';
						outputHtml +='	<td><div><span>'+rec.FLD_TYPE+'</span></div></td>';
						outputHtml +='	<td><div><span>'+rec.DATA_TYPE+'</span></div></td>';
						outputHtml +='	<td><div><span>'+rec.DATA_SIZE+'</span></div></td>';
						outputHtml +='	<td><div><input type="text" id="MPPG_VRBS" value='+rec.MPPG_VRBS+'></input></div></td>';
						outputHtml +='</tr>';
						tbl.find(".table_output_rec:eq("+(cnt-1)+")").find("tbody").append(outputHtml);
					}
					
				})
			}
			
		},
		fn_searchPopUp : function() { //app_id 검색창
			var $form = $("<form method='post'></form>");
			smartOpenPop({href: "srvc_0103_03.act", width:750, height:495, scrolling:false, target:window, frm:$form});
		},
		fn_apiDelete : function(){
			if(confirm("등록된 api를 삭제하시겠습니까?")){
				var jexAjax = jex.createAjaxUtil("srvc_0103_01_d002");   //PT_ACTION 웹 서비스 호출
				jexAjax.set("DSDL_GRP_CD", grp_cd);
				jexAjax.set("DSDL_ITEM_CD", item_cd);
				jexAjax.set("DSDL_ITEM_NM", item_nm);
				jexAjax.execute(function(dat) {
					var html = "<option value='0'>선택하세요</option>";
					$.each(dat.REC, function(i, v) {
						html += "<option value="+v.DSDL_ITEM_CD+">"+v.DSDL_ITEM_NM+"</option>";
					});
					var location = "#"+loct+"";
					$(location).append(html);
				});
			} 
		}
}

function getDsdlCd(loct, grp_cd, item_cd, item_nm){
	var jexAjax = jex.createAjaxUtil("srvc_0103_01_r002");   //PT_ACTION 웹 서비스 호출
	jexAjax.set("DSDL_GRP_CD", grp_cd);
	jexAjax.set("DSDL_ITEM_CD", item_cd);
	jexAjax.set("DSDL_ITEM_NM", item_nm);
	jexAjax.execute(function(dat) {
		var html = "<option value='0'>선택하세요</option>";
		$.each(dat.REC, function(i, v) {
			html += "<option value="+v.DSDL_ITEM_CD+">"+v.DSDL_ITEM_NM+"</option>";
		});
		var location = "#"+loct+"";
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
		
		$("#_APP_ID").empty();
		$("#_APP_ID").append(html);
	});
}
function __fn_init(){
	$("#srvc_0103_01").parents("div").addClass("on");
}
