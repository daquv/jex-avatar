/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : cstm_0201_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/cstm
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200824151650, 김별
 * </pre>
 **/
var isNew = true;
$(function(){
	_thisPage.onload();
	$(document).on("click", ".file_down", function(){
		fileDownload($(this).data("save_file_nm") , $(this).data("file_path"), $(this).text());
	});
	$(document).on("click", ".btnFileadd", function(){
		$('#ATT_FILE').click();
	});
	$("#ATT_FILE").bind('change', function(){
		FileUpload();
	});
	$(document).on("click", ".btnFiledelete", function(){
		var $this = $(this).closest("li").find(".file_down");
		fn_deleteFile($this, $this.data("save_file_nm"), $this.data("file_path"));
	});
	$(document).on("click", ".btnCancel", function(){
		location.href="cstm_0201_01.act";
	});
	$(document).on("click", ".cmdSave", function(){
		_thisPage.fn_save();
	})
});

var _thisPage = {
		onload(){
			_thisPage.setData();
		},
		setData(){
			//질문 SET
			var jexAjax = jex.createAjaxUtil("cstm_0201_01_r001");   //PT_ACTION 웹 서비스 호출
			input = {};
			input["BLBD_NO"] = $("input[name='BLBD_NO']").val();
			jexAjax.set(input);
			jexAjax.execute(function(dat){
				var rec = dat.REC[0];
				$("#REG_DTM").text(fintech.common.formatDate(rec.REG_DTM.substr(0,8)));
				$("#CUST_NM").text(rec.CUST_NM);
				$("#BLBD_TITL").text(rec.BLBD_TITL);
				$("#BLBD_CTT").text(rec.BLBD_CTT);
				$("#STTS").val(rec.STTS);
				if(rec.FILE_YN == "Y"){
					var jexAjax = jex.createAjaxUtil("cstm_0202_01_r001");   //PT_ACTION 웹 서비스 호출
					input = {};
					input["BLBD_NO"] = $("input[name='BLBD_NO']").val();
					jexAjax.set(input);
					jexAjax.execute(function(dat){
						var fileHtml;
						$.each(dat.REC, function(i, v) {
							
							fileHtml = "";
							fileHtml += "<li><span style='background-image: url(/admin/img/ico/ico_file.png);padding: 2px 7px 2px 9px;background-repeat: no-repeat;'></span>";
							fileHtml +=		"<a class='file_down' data-file_path="+v.FILE_PATH+" data-save_file_nm="+v.SAVE_FILE_NM+">"+v.ORG_FILE_NM+"</a>";
							fileHtml +=	"</li>";
							$("#BLBD_FILE").append(fileHtml);
						});
					});
				}
			});
			
			//답변 SET
			var jexAjax = jex.createAjaxUtil("cstm_0201_02_r001");   //PT_ACTION 웹 서비스 호출
			input = {};
			input["BLBD_NO"] = $("input[name='BLBD_NO']").val();
			jexAjax.set(input);
			jexAjax.execute(function(dat){
				if(dat.RPLY_NO){
					isNew = false;
					$("#RPLY_CTT").attr("data-rply_no", dat.RPLY_NO);
				}
				$("#RPLY_CTT").text(dat.RPLY_CTT);
				if(dat.FILE_YN == "Y"){
					var fileHtml;
					$.each(dat.REC, function(i, v) {
						fileHtml = "";
						fileHtml += "<li><span style='background-image: url(/admin/img/ico/ico_file.png);padding: 2px 7px 2px 9px;background-repeat: no-repeat;'></span>";
						fileHtml +=		"<a class='file_down' data-rply_no="+v.RPLY_NO+" data-file_path="+v.FILE_PATH+" data-save_file_nm="+v.SAVE_FILE_NM+">"+v.ORG_FILE_NM+"</a>";
						fileHtml +=		"<a class='btnFiledelete' data-file_path="+v.FILE_PATH+" data-save_file_nm="+v.SAVE_FILE_NM+" style='background-image: url(/admin/img/ico/x_span.png);padding: 0px 0px 0px 11px; margin-left: 5px; background-repeat: no-repeat;'></a>"
						fileHtml +=	"</li>";
						$("#RPLY_FILE").append(fileHtml);
					});
				}
			});
			
		}, 
		fn_save(){
			if(_thisPage.fn_regi_valid()){
				var jexAjax = jex.createAjaxUtil("cstm_0202_01_c001");   //PT_ACTION 웹 서비스 호출
				
				var recArray = [];
				$.each($("#RPLY_FILE li .file_down"), function(i){
					var $this = $(this);
					if(fintech.common.null2void($(this).data("rply_no"))== ""){
						var jsonREC = {};
						jsonREC["BLBD_DIV"		] = "01";
						jsonREC["BLBD_NO"]		  = $("input[name='BLBD_NO']").val();
						jsonREC["ORG_FILE_NM"	] = $this.text();
						jsonREC["SAVE_FILE_NM"	] = $this.data("save_file_nm");
						jsonREC["FILE_PATH"		] = $this.data("file_path");
						recArray.push(jsonREC);
					}
				});
				
				input = {};
				input["MENU_DV"] = isNew+"";
				input["BLBD_DIV"] = "01";
				input["STTS"] = $("#STTS").val();
				input["BLBD_NO"] = $("input[name='BLBD_NO']").val();
				if(!isNew)
					input["RPLY_NO"] = $("#RPLY_CTT").data("rply_no");
				input["RPLY_CTT"] = $("#RPLY_CTT").val();
				input["FILE_YN"] = $("#RPLY_FILE li").length>0? "Y" : "N";
				jexAjax.set(input);
				jexAjax.set("INSERT_REC",recArray);
				jexAjax.set('async',false);
				jexAjax.execute(function(dat) {
					if(dat.RSLT_CD=="0000"){
						alert("저장되었습니다.");
						location.href="cstm_0201_01.act";
					} else if(dat.RSLT_CD=="9999") {
						alert("처리중 오류가 발생하였습니다.");
					}
				});
				
			}
		},
		fn_regi_valid : function(){
			return true;
		}
}
function fileDownload(SAVE_FILE_NM, FILE_PATH, ORG_FILE_NM){
	$("#frmFiledownload").remove();
	var html = "";
	html +='<form action="filedownload_0001_01.act" style="display:none;" method="post" id="frmFiledownload">';
	html +='<input type="hidden" name="ORG_FILE_NM" value="'+ORG_FILE_NM+'"/>';
	html +='<input type="hidden" name="FILE_PATH" value="'+FILE_PATH+'"/>';
	html +='<input type="hidden" name="SAVE_FILE_NM" value="'+SAVE_FILE_NM+'"/>';
	html +='</form>';
	$("body").append(html);
	$("#frmFiledownload").submit();
}

function FileUpload(){
	var formData = new FormData($('form')[0]);
	$.ajax({
		url: "/view/jex/avatar/include/upload_file.jsp",
		type: "POST",
		data : formData,
		enctype: 'multipart/form-data',
		processData : false,
		contentType : false,
		success: function(data){	
			console.log(data);
			if(data.RESP_CD == "0000"){
				var fileName = data.RESP_DATA;
				var filePath = data.FILE_PATH;
				var originFileNm = data.ORIGIN_FILENM; 	//원본파일명
				var originFileSz = data.FILE_SIZE; 		//파일사이즈
				fn_fileuploadCallback(fileName,originFileNm,originFileSz,filePath);
			}else if(data.RESP_CD == "8888"){
				alert("파일을 선택하십시오.");
			}else{
				alert("오류 업로드.");
			}
			
		}
	});
}

function fn_fileuploadCallback(fileName,originFileNm,originFileSz,filePath){
	fileHtml = "";
	fileHtml += "<li><span style='background-image: url(/admin/img/ico/ico_file.png);padding: 2px 7px 2px 9px;background-repeat: no-repeat;'></span>";
	fileHtml +=		"<a class='file_down' data-file_path="+filePath+" data-save_file_nm="+fileName+">"+originFileNm+"</a>";
	fileHtml +=		"<a class='btnFiledelete' data-file_path="+filePath+" data-save_file_nm="+fileName+" style='background-image: url(/admin/img/ico/x_span.png);padding: 0px 0px 0px 11px; margin-left: 5px; background-repeat: no-repeat;'></a>"
	fileHtml +=	"</li>";
	$("#RPLY_FILE").append(fileHtml);
	
}

function fn_deleteFile($this, SAVE_FILE_NM, FILE_PATH){
	var jexAjax = jex.createAjaxUtil("filedelete_0001_01");   	//PT_ACTION 웹 서비스 호출
	jexAjax.set("SAVE_FILE_NM"    ,SAVE_FILE_NM);  	//파일명
	jexAjax.set("FILE_PATH"    , FILE_PATH);  	//파일 경로
	
	jexAjax.execute(function(data){
		if(data.RSLT_CD=="0000"){
			$this.closest("li").remove();
		} 
	});
}
function __fn_init(){
	$("#cstm_0201_01").parents("div").addClass("on");
}
