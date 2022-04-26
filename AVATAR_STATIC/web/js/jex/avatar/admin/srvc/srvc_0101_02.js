/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : srvc_0101_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/srvc
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200706151135, 김별
 * </pre>
 **/
var isDup = true;
$(function(){
	_thisPage.onload();
	$(document).on("click","#cmdSave",function() {
		_thisPage.fn_save();
	});
	$(document).on("click","#cmdEdit",function() {
		location.href = "srvc_0101_02.act?APP_ID="+ fintech.common.null2void($("#APP_ID").val())+"&MENU_DV=22";
	});
	$(document).on("click", "#cmdDelete", function() {
		_thisPage.fn_delete();
	})
	$(document).on("click","#btn_chk",function() {
		var APP_ID = $("#APP_ID").val();
		_thisPage.fn_checkDuplicate(APP_ID);
	});
	$(document).on("click","#btn_add",function() {
		_thisPage.fn_searchChrg();
	});
	$(document).on("click",".btn_minus",function() {
		$(this).closest("tr").remove();
	});
	$("#APP_ID").on("change keyup paste", function() {
		isDup = true;
	});
})

var _thisPage = {
	onload : function(){
		if($("input[name=APP_ID_BASE]").val()){
			if($("input[name=MENU_DV]").val() == "1" || $("input[name=MENU_DV]").val() == "20"){
				$("input[type=text]").each(function(i, v){
					$(v).css("border", "0px");
					$(v).attr("disabled", true);
				});
			} else if($("input[name=MENU_DV]").val() == "22"){
				$("#APP_ID").css("border", "0px").attr("disabled", true);
				$("#HOST").css("border", "0px").attr("disabled", true);
			} else {
				$("input[type=text]").each(function(i, v){
					$(v).css("border", "0px").attr("disabled", true);
				});
				//$("#APP_ID").css("border", "0px").attr("disabled", true);
				//$("#HOST").css("border", "0px").attr("disabled", true);
			}
			_thisPage.fn_setData();
		}
	},
	fn_setData : function(){
		var jexAjax = jex.createAjaxUtil("srvc_0101_01_r001");   //PT_ACTION 웹 서비스 호출
		//상태, 검색대상, 카테고리
		input = {};
		input["APP_ID"] = $("input[name=APP_ID_BASE]").val();
		jexAjax.set(input);
		jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
		jexAjax.execute(function(dat) {
			console.log(dat);
			$("#BSNN_NM").val(dat.REC[0].BSNN_NM);
			if($("input[name=MENU_DV]").val() == "22"){
				$("#VRFC_TYPE").val(dat.REC[0].VRFC_TYPE).attr("selected", "selected");
			} else{
				$("#VRFC_TYPE").text(dat.REC[0].VRFC_TYPE_NM);
			}
			$("#APP_NM").val(dat.REC[0].APP_NM);
			$("#APP_ID").val(dat.REC[0].APP_ID);
			$("#HOST").val(dat.REC[0].HOST);
			$("#SVC_KEY").val(dat.REC[0].SVC_KEY);
			$("#INTF_DV").val(dat.REC[0].INTF_DV);
			$("#DATA_TYPE").val(dat.REC[0].DATA_TYPE);
			$("#PARA_ID").val(dat.REC[0].PARA_ID);
		});
		
		var jexAjax = jex.createAjaxUtil("srvc_0101_02_r001");   //PT_ACTION 웹 서비스 호출
		jexAjax.set(input);
		jexAjax.execute(function(dat){
			_thisPage.fn_setChrg(dat.REC);
		});
	},
	fn_searchChrg : function(){
		var $form = $("<form method='post'></form>");
		smartOpenPop({href: "srvc_0101_03.act", width:750, height:495, scrolling:false, target:window, frm:$form});
	},
	fn_setChrg : function(jsonArr){
		var $admin_list = "";
		$.each(jsonArr, function(i, v){
			$admin_list += "<tr>"
				+"<td class='' scope='col'><div id='USER_ID'>"+fintech.common.null2void(v.USER_ID)+"</div></td>"
				+"<td class='' scope='col'><div>"+fintech.common.null2void(v.USER_NM)+"</div></td>"
				+"<td class='' scope='col'><div>"+fintech.common.null2void(v.CLPH_NO)+"</div></td>"
				+"<td class='' scope='col'><div>"+fintech.common.null2void(v.TEL_NO)+"</div></td>"
				+"<td class='' scope='col'><div>"+fintech.common.null2void(v.BSNN_NM)+"</div></td>"
				if($("input[name=MENU_DV]").val() =="22" || $("input[name=MENU_DV]").val() =="21"){
					+"<td class='' scope='col' style='text-align: right;'><div><a id='btn_minus' class='btn_style3 btn_minus' ><span style='min-width:15px !important;'>-</span></a></div></td>"
				}
				+"</tr>";
		});
		$("#admin_list").html($admin_list);
	},
	fn_checkDuplicate : function(APP_ID){
		var jexAjax = jex.createAjaxUtil('srvc_0101_01_r001');
		jexAjax.set("APP_ID", APP_ID);
		jexAjax.execute(function(dat){
			if(dat.REC.length== 0){
				isDup = false;
				alert("Unused code");
			} else{
				isDup = true;
				alert("Duplicate code. Check it again");
			}
		});
	},
	fn_save : function(){
		if(!_thisPage.fn_save_valid()){
			return false;
		}
		var input = {};
		if(fintech.common.null2void($("#SVC_KEY").val()) == ""){
			srvcKey = "2";
		} else srvcKey = "1";
		/*basic*/
		input["APP_ID_BASE"] = 	$("input[name=APP_ID_BASE]").val();
		input["APP_NM"] = 		$("#APP_NM").val(); 
		input["VRFC_TYPE"] = 	$("#VRFC_TYPE").val(); 
		input["APP_ID"] = 		$("#APP_ID").val();
		input["HOST"] = 		$("#HOST").val();
		input["VRFC_TYPE"] = 	srvcKey;
		input["SVC_KEY"] = 		$("#SVC_KEY").val();
		input["INTF_DV"] =		$("#INTF_DV").val();
		input["DATA_TYPE"] =	$("#DATA_TYPE").val();
		input["PARA_ID"] =		$("#PARA_ID").val();
		
		/*chrg*/
		var recArray = [];
		$.each($("#admin_list tr"), function(i, v){
			var $this = $(this);
			var jsonREC = {};
			jsonREC["USER_ID"] = $this.find("#USER_ID").text();
			jsonREC["APP_ID"] = $("#APP_ID").val();
			recArray.push(jsonREC);
		});
		
		/*save*/
		var jexAjax = jex.createAjaxUtil('srvc_0101_02_c001');
		jexAjax.set(input);
		jexAjax.set("INSERT_REC",recArray);
		jexAjax.execute(function(dat){
			if(dat.RSLT_CD == "0000"){
				alert("저장되었습니다.");
				location.href="srvc_0201_01.act";
			} else if(dat.RSLT_CD == "9999"){
				alert("처리 중 오류가 발생하였습니다.");
			} else if(dat.RSLT_CD == "8888") {
			}
		});
	},
	fn_save_valid : function(){
		var result = true;
		if($("input[name=APP_ID_BASE]").val() == $("#APP_ID").val()) isDup = false;
		if(isDup){
			alert("앱코드 중복 확인 필요")
			return false;
		}
		$(".rq").each(function(){
			if(""==fintech.common.null2void($(this).val())){
				var alert_msg = "필수입력 항목이 누락되었습니다.";
				alert("["+$(this).closest("tr").find("th span").text()+"] "+alert_msg);
				$(this).focus();
				result = false;
				return false;
			}
		})
		return result;
	},
	fn_delete : function(){
		var result = confirm("Are you sure you want to delete?");
		if(result){
			var jexAjax = jex.createAjaxUtil('srvc_0101_02_d001');
			jexAjax.set("APP_ID", $("input[name=APP_ID_BASE]").val());
			jexAjax.execute(function(dat){
				if(dat.RSLT_CD == "0000"){
					alert("Successfully deleted.");
					location.href="srvc_0201_01.act";
				} else if(dat.RSLT_CD == "9999"){
					alert("Error occured");
				}
			});
			//delete
		}
	}
}
function __fn_init(){
	if(	$("input[name=MENU_DV]").val() =="1"|| $("input[name=MENU_DV]").val() == ""){
		$("#srvc_0101_01").parents("div").addClass("on");
	}
	else if($("input[name=MENU_DV]").val() == "21" || $("input[name=MENU_DV]").val() == "20"){
		$("#srvc_0201_01").parents("div").addClass("on");
	}
}