/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : cstm_0302_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/cstm
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20210407170634, 김별
 * </pre>
 **/
var excelFilePath;	//샘플 파일 경로
var excelFileNm;	//샘플 파일명 
var FILE_NM;
$(function(){
	_thisPage.onload();
	//정상,오류 탭
	$("#clearData").on("click",function(){
		$(this).css({"font-weight":"bold"});
		$("#errData").css({"font-weight":"normal"});
		$("#tbl_content_e").hide();
		$("#tbl_content_s").show();
	});
	$("#errData").on("click",function(){
		$(this).css({"font-weight":"bold"});
		$("#clearData").css({"font-weight":"normal"});
		$("#tbl_content_e").show();
		$("#tbl_content_s").hide();
	});
	//저장
	$("#btnSave").on("click",function(){
		if($("#tbl_content_s").find("tr").length==0){
			alert("등록할 내역이 없습니다.");
			return false;
		}
		var errCnt	= $("#tbl_content_e").find("tr").length>0?$("#tbl_content_e").find("tr").length:0;
		if(errCnt>0){
			if(!confirm("수정하지 않은 오류가 남아있습니다.\n제외하고 저장하시겠습니까?")){
				return false;
			}
			_thisPage.fn_saveAll(); // 일괄등록
			return false;
		}
		if(confirm('등록하시겠습니까?')){
			_thisPage.fn_saveAll(); // 일괄등록
		}
	});
	//양식 다운로드
	$("#btnFile").on("click",function(){
		fileDownload(excelFileNm,excelFilePath,"거래처일괄등록_양식.xlsx");
	});
	$("#btnOpen").on("click",function(){
		$('#ATT_FILE').click();
	});
	$("#ATT_FILE").bind('change', function(){
		FileUpload();
	});

});

var _thisPage = {
		onload : function() {
		},
		printFile : function(data){
			$("#tbl_content_s").html("");
			$("#tbl_content_e").html("");
			
			$.each(data.REC, function (i,v) {
				//오류건 , 정상건 구분
				var isErr = false;
				var iHtml  = "<tr>";     
				
				// 사업자번호
				if(fintech.common.null2void(v.BIZ_NO) == ""){
					isErr=true;
					iHtml += "<td gb=\"BIZ_NO\" title=\"사업자번호는 필수입력값입니다.\"><div><span style=\"\" class=\"bg_line err\">"+formatter.corpNum(fintech.common.null2void(v.BIZ_NO))+"</span></div></td>";
				}else if (fintech.common.null2void(v.RSLT_CD) == "9999"){
					isErr=true;
					iHtml += "<td gb=\"BIZ_NO\" title=\"중복된 사업자번호입니다.\"><div><span style=\"\" class=\"bg_line err\">"+formatter.corpNum(fintech.common.null2void(v.BIZ_NO))+"</span></div></td>";
				}else {
					iHtml += "<td gb=\"BIZ_NO\" code=\""+v.BIZ_NO+"\"><div><span class=\"bg_line\" style=\"\">"+formatter.corpNum(fintech.common.null2void(v.BIZ_NO))+"</span></div></td>";	
				}
				
				// 업체명
				/*if(fintech.common.null2void(v.BSNN_NM) == ""){
					isErr=true;
					iHtml += "<td gb=\"USE_INTT_NM\" title=\"존재 하지 않는 업체입니다.\"><div class=\"\"><span style=\"\" class=\"bg_line err\">"+fintech.common.null2void(v.USE_INTT_NM)+"</span></div></td>";
				}else{*/
					iHtml += "<td gb=\"BSNN_NM\" code=\""+fintech.common.null2void(v.BSNN_NM)+"\"><div><span style=\"\" class=\"bg_line\">"+fintech.common.null2void(v.BSNN_NM)+"</span></div></td>";	
				//}
				
				// 표제어
				iHtml += "<td gb=\"HEAD_WD\" code=\""+fintech.common.null2void(v.HEAD_WD)+"\"><div><span class=\"bg_line\" style=\"\">"+fintech.common.null2void(v.HEAD_WD)+"</span></div></td>";
				
				// 독음
				iHtml += "<td gb=\"READ_SD\" code=\""+fintech.common.null2void(v.READ_SD)+"\"><div><span class=\"bg_line\" style=\"\">"+fintech.common.null2void(v.READ_SD)+"</span></div></td>";
				iHtml += "<td></td>"
				if(isErr){
					//오류
					$("#tbl_content_e").append(iHtml);
				} else {
					//정상
					$("#tbl_content_s").append(iHtml);
				}

			});
			//정상,오류 tab 설정
			var clearCnt 	= $("#tbl_content_s").find("tr").length>0?$("#tbl_content_s").find("tr").length:0; 
			var errCnt		= $("#tbl_content_e").find("tr").length>0?$("#tbl_content_e").find("tr").length:0;
			
			$("#clearData").text("정상("+clearCnt+")");
			$("#errData").text("오류("+errCnt+")");
			
			if(errCnt>0){
				$("#errData").css({"font-weight":"bold"});
				$("#tbl_content_e").show();
				$("#tbl_content_s").hide();
			} else {
				$("#clearData").css({"font-weight":"bold"});    	
				$("#tbl_content_e").hide();
				$("#tbl_content_s").show();
			}
			//show&hide
			$("div[name=divFileSvae]").hide();
			$("div[name=divResult]").show();
		},
		fn_saveAll : function() {
			var recArray = [];
			var cnt = 0;
			var sum = 0;
			$.each($("#tbl_content_s tr"), function(i){
				var $this = $(this);
				var jsonREC = {};
				jsonREC["BIZ_NO"		] = $this.find("td[gb='BIZ_NO']").attr("code");
				jsonREC["BSNN_NM"		] = $this.find("td[gb='BSNN_NM']").attr("code");
				jsonREC["HEAD_WD"		] = $this.find("td[gb='HEAD_WD']").attr("code");
				jsonREC["READ_SD"		] = $this.find("td[gb='READ_SD']").attr("code");
				
				recArray.push(jsonREC); 
				cnt ++;
			});
			var jexAjax = jex.createAjaxUtil("cstm_0302_01_c001");
			jexAjax.set("INSERT_REC",recArray);
			jexAjax.set('async',false);
			jexAjax.execute(function(dat) {
				if(dat.RSLT_CD=="0000"){
					alert("저장되었습니다.");
					location.href = "/cstm_0301_01.act";	
				} else if(dat.RSLT_CD=="9999") {
					alert("처리중 오류가 발생하였습니다.");
				}
			});
			
		}
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
			if(data.RESP_CD == "0000"){
				var fileName = data.RESP_DATA;
				var filePath = data.FILE_PATH;
				var originFileNm = data.ORIGIN_FILENM; 	//원본파일명
				FILE_NM = data.ORIGIN_FILENM;
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

/**
 * 파일 다운로드
 * @param filename
 * @param filepath
 */
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

/**
 * 파일 업로드 콜백 함수
 * @param data
 */
function fn_fileuploadCallback(fileName,originFileNm,originFileSz,filePath){
    $("#SRCH_VAL").val(originFileNm);
    var jexAjax = jex.createAjaxUtil("cstm_0302_01_r001");
	jexAjax.set("SRCH_WD", filePath+"/"+fileName);
	jexAjax.execute( function( dat ) {
		if(dat.RSLT_CD == "0000"){
			_thisPage.printFile(dat);
		}
	});
}

function __fn_init(){
	$("#cstm_0301_01").parents("div").addClass("on");
}