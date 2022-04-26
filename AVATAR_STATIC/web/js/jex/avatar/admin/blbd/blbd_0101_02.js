/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : blbd_0101_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/blbd
 * @author         : 김별 (  )
 * @Description    : 공지사항등록화면
 * @History        : 20200828142750, 김별
 * </pre>
 **/
$(function(){
	if($("input[name=BLBD_DIV]").val() == "03"){
		getDsdlCd("CTGR_CD","BLBD_CTGR_CD");
	}
	_thisPage.onload();
	$("#cmdList").on("click", function(){
		var result = confirm("작성 중인 글이 있습니다. 목록으로 돌아가시겠습니까?");
		if(result==true){
			if($("input[name=BLBD_DIV]").val() == "02"){
				location.href = "blbd_0101_01.act";
			} else if($("input[name=BLBD_DIV]").val() == "03"){
				location.href = "blbd_0201_01.act";
			}
		} 
	});
	$("#cmdReg").on("click", function(){
		var result = confirm("게시하시겠습니까?");
		if(result==true){
			if(fintech.common.null2void($("input[name=BLBD_NO]").val()) != ""){
				_thisPage.fn_update();
			} else{
				_thisPage.fn_save();
			}
		} 
	});
	$(".cmdFileUpload").on("click", function(){
		$(this).prev().click();
	});
	$(".ATT_FILE").bind('change', function(){
		FileUpload($(this).attr("id"));
	});
	$(document).on("click", ".btnFiledelete", function(){
		var $this = $(this).closest("li").find(".file_down");
		fn_deleteFile($this, $this.data("save_file_nm"), $this.data("file_path"));
	});
	$(document).on("click", ".file_down", function(){
		fileDownload($(this).data("save_file_nm") , $(this).data("file_path"), $(this).text());
	});
	$(window).on("beforeunload", function(){
		$(".fileList ul").each(function(i, v){
			fn_deleteFile($(v), $(v).data("save_file_nm"), $(v).data("file_path"))
		});

    });


})

var _thisPage = {
	onload : function(){
		if(fintech.common.null2void($("input[name=BLBD_NO]").val())!="")
			_thisPage.fn_setData();
	},
	fn_setData : function(){
		//질문 SET
		var jexAjax = jex.createAjaxUtil("blbd_0101_01_r001");   //PT_ACTION 웹 서비스 호출
		input = {};
		input["BLBD_NO"] = $("input[name='BLBD_NO']").val();
		input["BLBD_DIV"]	= $("input[name=BLBD_DIV]").val();
		jexAjax.set(input);
		jexAjax.execute(function(dat){
			var rec = dat.REC[0];
			$("#BLBD_TITL").val(rec.BLBD_TITL);
			$("#CTGR_CD").val(rec.BLBD_CTGR_CD);
			$("#CHNL_CD").val(rec.BLBD_CHNL);
			var iframe 		= 	$("iframe#tx_canvas_wysiwyg").contents();
			$(iframe).find("body.tx-content-container").html(rec.BLBD_CTT);
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
						fileHtml +=		"<a class='btnFiledelete' data-file_path="+v.FILE_PATH+" data-save_file_nm="+v.SAVE_FILE_NM+" style='background-image: url(/admin/img/ico/x_span.png);padding: 0px 0px 0px 11px; margin-left: 5px; background-repeat: no-repeat;'></a>"
						fileHtml +=	"</li>";
						$("#fileList ul").append(fileHtml);
					});
				});
			}
		});
	},
	fn_save : function(){
		var BLBD_CTT 		= "";
		
		var iframe 	= $("iframe#tx_canvas_wysiwyg").contents();
		BLBD_CTT 	= $(iframe).find("body.tx-content-container").html();
		var _fileList = [];
		$('#fileList ul li').each(function(){
			_fileList.push({
				ORG_FILE_NM    : $(this).find(".file_down").text(),
				SAVE_FILE_NM   : $(this).find(".file_down").attr("data-save_file_nm"),
				FILE_PATH   : $(this).find(".file_down").attr("data-file_path")
			});
			
		});
		
		var input = {};
		input["FILE_REC"] = _fileList;
		input["BLBD_DIV"]	= $("input[name=BLBD_DIV]").val();
		input["BLBD_TITL"]	= $("#BLBD_TITL").val();
		input["BLBD_CTT"]	= BLBD_CTT;
		input["BLBD_CTGR_CD"]	= $("#CTGR_CD").val();
		input["BLBD_CHNL"]		= $("#CHNL_CD").val();
		input["FILE_YN"]	= $("#fileList li").length>0? "Y" : "N";
		
		console.log(input);
		var jexAjax = jex.createAjaxUtil("blbd_0101_02_c001");   	//PT_ACTION 웹 서비스 호출
		//jexAjax.set("FILE_REC"          , _fileList); 		// FILE_REC 
		
		jexAjax.set(input);
		jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
		
		jexAjax.execute(function(data){
			if(data.RSLT_CD=="0000"){
				alert("정상적으로 저장되었습니다.");
				if($("input[name=BLBD_DIV]").val() == "02"){
					location.href = "blbd_0101_01.act";
				} else if($("input[name=BLBD_DIV]").val() == "03"){
					location.href = "blbd_0201_01.act";
				}
			} else {
				alert("Error occurred");
			}
		});
	},
	fn_update : function(){
		var BLBD_CTT 		= "";
		
		var iframe 	= $("iframe#tx_canvas_wysiwyg").contents();
		BLBD_CTT 	= $(iframe).find("body.tx-content-container").html();
		var _fileList = [];
		$('#fileList ul li').each(function(){
			_fileList.push({
				ORG_FILE_NM    : $(this).find(".file_down").text(),
				SAVE_FILE_NM   : $(this).find(".file_down").attr("data-save_file_nm"),
				FILE_PATH   : $(this).find(".file_down").attr("data-file_path")
			});
			
		});
		
		var input = {};
		input["FILE_REC"] = _fileList;
		input["BLBD_DIV"]	= $("input[name=BLBD_DIV]").val();
		input["BLBD_NO"]	= $("input[name=BLBD_NO]").val();
		input["BLBD_TITL"]	= $("#BLBD_TITL").val();
		input["BLBD_CTGR_CD"]	= $("#CTGR_CD").val();
		input["BLBD_CHNL"]		= $("#CHNL_CD").val();
		input["BLBD_CTT"]	= BLBD_CTT;
		input["FILE_YN"]	= $("#fileList li").length>0? "Y" : "N";
		
		console.log(input);
		var jexAjax = jex.createAjaxUtil("blbd_0101_02_u001");   	//PT_ACTION 웹 서비스 호출
		//jexAjax.set("FILE_REC"          , _fileList); 		// FILE_REC 
		
		jexAjax.set(input);
		jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
		
		jexAjax.execute(function(data){
			if(data.RSLT_CD=="0000"){
				alert("정상적으로 저장되었습니다.");
				if($("input[name=BLBD_DIV]").val() == "02"){
					location.href = "blbd_0101_01.act";
				} else if($("input[name=BLBD_DIV]").val() == "03"){
					location.href = "blbd_0201_01.act";
				}
			} else {
				alert("Error occurred");
			}
		});
	}
}

function FileUpload(file_dv){
	if(file_dv == "file"){
		var formData = new FormData($("form")[2]);
	} else if(file_dv == "content"){
		var formData = new FormData($("form")[1]);
	}
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
				if(file_dv == "file")
					fn_fileuploadCallback_file(fileName,originFileNm,originFileSz,filePath);
				else if(file_dv == "content")
					fn_fileuploadCallback_html(fileName,originFileNm,originFileSz,filePath);
			}else if(data.RESP_CD == "8888"){
				alert("파일을 선택하십시오.");
			}else{
				alert(data.RESP_MSG);
				//alert("오류 업로드.");
			}
			
		}
	});
}
function fn_fileuploadCallback_file(fileName,originFileNm,originFileSz,filePath){
	fileHtml = "";
	fileHtml += "<li><span style='background-image: url(/admin/img/ico/ico_file.png);padding: 2px 7px 2px 9px;background-repeat: no-repeat;'></span>";
	fileHtml +=		"<a class='file_down' data-file_path="+filePath+" data-save_file_nm="+fileName+">"+originFileNm+"</a>";
	fileHtml +=		"<a class='btnFiledelete' data-file_path="+filePath+" data-save_file_nm="+fileName+" style='background-image: url(/admin/img/ico/x_span.png);padding: 0px 0px 0px 11px; margin-left: 5px; background-repeat: no-repeat;'></a>"
	fileHtml +=	"</li>";
	$("#fileList ul").append(fileHtml);
	
}
function fn_fileuploadCallback_html(fileName,originFileNm,originFileSz,filePath){
	var url =  "/file/blbd/" + fileName;
	Editor.getCanvas().pasteContent('<p><img src=' + url + ' editor='+ fileName + ' style="clear: none; float: none; align: center;"/></p>');
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
function getDsdlCd(loct, grp_cd,item_cd, item_nm){
	var jexAjax = jex.createAjaxUtil("srvc_0103_01_r002");   //PT_ACTION 웹 서비스 호출
	jexAjax.set("DSDL_GRP_CD", grp_cd);
	jexAjax.set("DSDL_ITEM_CD", item_cd);
	jexAjax.set("DSDL_ITEM_NM", item_nm);
	jexAjax.execute(function(dat) {
		var html = "<option value=''>선택하세요</option>";
		$.each(dat.REC, function(i, v) {
			html += "<option value="+v.DSDL_ITEM_CD+">"+v.DSDL_ITEM_NM+"</option>";
		});
		var location = "#"+loct+"";
		$(location).empty();
		$(location).append(html);
	});
}
function __fn_init(){
	if($("input[name=BLBD_DIV]").val() == "02"){
		$("#blbd_0101_01").parents("div").addClass("on");
	} else if($("input[name=BLBD_DIV]").val() == "03"){
		$("#blbd_0201_01").parents("div").addClass("on");
	}
}