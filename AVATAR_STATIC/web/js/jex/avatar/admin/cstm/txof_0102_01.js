/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : txof_0102_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/cstm
 * @author         : 김별 (  )
 * @Description    : 세무사DB 일괄등록
 * @History        : 20210715151653, 김별
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
		fileDownload(excelFileNm,excelFilePath,"세무사DB일괄등록_양식.xlsx");
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
			console.log(data.REC);
			$.each(data.REC, function (i,v) {
				if(Object.keys(v).length === 0)
					return false;
				//오류건 , 정상건 구분
				var isErr = false;
				var iHtml  = "<tr>";     
				
				// 사업자번호
				if(fintech.common.null2void(v.BIZ_NO) == ""){
					isErr=true;
					iHtml += "<td gb=\"BIZ_NO\" title=\"사업자번호는 필수입력값입니다.\"><div><span style=\"\" class=\"bg_line err\">"+formatter.corpNum(fintech.common.null2void(v.BIZ_NO))+"</span></div></td>";
				}else if (fintech.common.null2void(v.RSLT_CD) == "9999"){
					isErr=true;
					iHtml += "<td gb=\"BIZ_NO\" title=\"KEY(사업자번호/세무사전화번호)가 중복되었습니다.\"><div><span style=\"\" class=\"bg_line err\">"+formatter.corpNum(fintech.common.null2void(v.BIZ_NO))+"</span></div></td>";
				}else {
					iHtml += "<td gb=\"BIZ_NO\" code=\""+v.BIZ_NO+"\"><div><span class=\"bg_line\" style=\"\">"+formatter.corpNum(fintech.common.null2void(v.BIZ_NO))+"</span></div></td>";	
				}
				
				// 사업장명
				iHtml += "<td gb=\"BSNN_NM\" code=\""+fintech.common.null2void(v.BSNN_NM)+"\"><div><span style=\"\" class=\"bg_line\">"+fintech.common.null2void(v.BSNN_NM)+"</span></div></td>";
				
				// 대표자명
				iHtml += "<td gb=\"RPPR_NM\" code=\""+fintech.common.null2void(v.RPPR_NM)+"\"><div><span style=\"\" class=\"bg_line\">"+fintech.common.null2void(v.RPPR_NM)+"</span></div></td>";
				
				// 업태
				iHtml += "<td gb=\"BSST\" code=\""+fintech.common.null2void(v.BSST)+"\"><div><span style=\"\" class=\"bg_line\">"+fintech.common.null2void(v.BSST)+"</span></div></td>";
				
				// 업종
				iHtml += "<td gb=\"TPBS\" code=\""+fintech.common.null2void(v.TPBS)+"\"><div><span style=\"\" class=\"bg_line\">"+fintech.common.null2void(v.TPBS)+"</span></div></td>";
				
				// 전화번호
				iHtml += "<td gb=\"TEL_NO\" code=\""+fintech.common.null2void(v.TEL_NO)+"\"><div><span style=\"\" class=\"bg_line\">"+formatter.phone(fintech.common.null2void(v.TEL_NO))+"</span></div></td>";
				
				// 우편번호
				iHtml += "<td gb=\"ZPCD\" code=\""+fintech.common.null2void(v.ZPCD)+"\"><div><span style=\"\" class=\"bg_line\">"+fintech.common.null2void(v.ZPCD)+"</span></div></td>";
				
				// 주소
				iHtml += "<td gb=\"ADRS\" code=\""+fintech.common.null2void(v.ADRS)+"\"><div><span style=\"\" class=\"bg_line\">"+fintech.common.null2void(v.ADRS)+"</span></div></td>";
				
				// 상세주소
				iHtml += "<td gb=\"DTL_ADRS\" code=\""+fintech.common.null2void(v.DTL_ADRS)+"\"><div><span style=\"\" class=\"bg_line\">"+fintech.common.null2void(v.DTL_ADRS)+"</span></div></td>";
				
				// 전문분야
				iHtml += "<td gb=\"MAJR_SPHR\" code=\""+fintech.common.null2void(v.MAJR_SPHR)+"\"><div><span style=\"\" class=\"bg_line\">"+fintech.common.null2void(v.MAJR_SPHR)+"</span></div></td>";
				
				// 세무사명
				iHtml += "<td gb=\"CHRG_NM\" code=\""+fintech.common.null2void(v.CHRG_NM)+"\"><div><span style=\"\" class=\"bg_line\">"+fintech.common.null2void(v.CHRG_NM)+"</span></div></td>";
				
				// 세무사전화번호
				if(fintech.common.null2void(v.CHRG_TEL_NO) == ""){
					isErr=true;
					iHtml += "<td gb=\"CHRG_TEL_NO\" title=\"세무사전화번호는 필수입력값입니다.\"><div><span style=\"\" class=\"bg_line err\">"+formatter.phone(fintech.common.null2void(v.CHRG_TEL_NO))+"</span></div></td>";
				} else if (fintech.common.null2void(v.RSLT_CD) == "9999"){
					isErr=true;
					iHtml += "<td gb=\"CHRG_TEL_NO\" title=\"KEY(사업자번호/세무사전화번호)가 중복되었습니다.\"><div><span style=\"\" class=\"bg_line err\">"+formatter.phone(fintech.common.null2void(v.CHRG_TEL_NO))+"</span></div></td>";
				} else {
					iHtml += "<td gb=\"CHRG_TEL_NO\" code=\""+fintech.common.null2void(v.CHRG_TEL_NO)+"\"><div><span style=\"\" class=\"bg_line\">"+formatter.phone(fintech.common.null2void(v.CHRG_TEL_NO))+"</span></div></td>";
				}
				
				
				// 개인정보제공동의일자
				iHtml += "<td gb=\"COSN_DT\" code=\""+fintech.common.null2void(v.COSN_DT)+"\"><div><span style=\"\" class=\"bg_line\">"+formatter.date(fintech.common.null2void(v.COSN_DT))+"</span></div></td>";
				
				// 사업장연결수
				if (fintech.common.null2void(v.BIZ_LINK_CNT).length > 5){
					isErr=true;
					iHtml += "<td gb=\"BIZ_LINK_CNT\" title=\"사업장 연결수 입력 최대 범위 초과\"><div><span style=\"\" class=\"bg_line err\">"+formatter.corpNum(fintech.common.null2void(v.BIZ_LINK_CNT))+"</span></div></td>";
				}else {
					iHtml += "<td gb=\"BIZ_LINK_CNT\" code=\""+fintech.common.null2void(v.BIZ_LINK_CNT)+"\"><div><span style=\"\" class=\"bg_line\">"+formatter.date(fintech.common.null2void(v.BIZ_LINK_CNT))+"</span></div></td>";
				}
				
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
				jsonREC["RPPR_NM"		] = $this.find("td[gb='RPPR_NM']").attr("code");
				jsonREC["BSST"			] = $this.find("td[gb='BSST']").attr("code");
				jsonREC["TPBS"			] = $this.find("td[gb='TPBS']").attr("code");
				jsonREC["TEL_NO"		] = $this.find("td[gb='TEL_NO']").attr("code");
				jsonREC["ZPCD"			] = $this.find("td[gb='ZPCD']").attr("code");
				jsonREC["ADRS"			] = $this.find("td[gb='ADRS']").attr("code");
				jsonREC["DTL_ADRS"		] = $this.find("td[gb='DTL_ADRS']").attr("code");
				jsonREC["MAJR_SPHR"		] = $this.find("td[gb='MAJR_SPHR']").attr("code");
				jsonREC["CHRG_NM"		] = $this.find("td[gb='CHRG_NM']").attr("code");
				jsonREC["CHRG_TEL_NO"	] = $this.find("td[gb='CHRG_TEL_NO']").attr("code");
				jsonREC["COSN_DT"		] = $this.find("td[gb='COSN_DT']").attr("code");
				jsonREC["BIZ_LINK_CNT"	] = $this.find("td[gb='BIZ_LINK_CNT']").attr("code");
				
				jsonREC["LOCA_NO"		] = getLocaNo($this.find("td[gb='TEL_NO']").attr("code"));
				
				recArray.push(jsonREC); 
				cnt ++;
			});
			var jexAjax = jex.createAjaxUtil("txof_0102_01_c001");
			jexAjax.set("INSERT_REC",recArray);
			jexAjax.set('async',false);
			jexAjax.execute(function(dat) {
				if(dat.RSLT_CD=="0000"){
					alert("저장되었습니다.");
					location.href = "/txof_0101_01.act";	
				} else if(dat.RSLT_CD=="9999") {
					alert("처리중 오류가 발생하였습니다.");
				}
			});
			
		}
}

function getLocaNo(tel){
    let locaNo = "";
    if(tel.startsWith("02")){
        locaNo = "02";
    } else {
        locaNo = tel.substring(0,3);
    }
    return locaNo;
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
    var jexAjax = jex.createAjaxUtil("txof_0102_01_r001");
	jexAjax.set("SRCH_WD", filePath+"/"+fileName);
	jexAjax.execute( function( dat ) {
		if(dat.RSLT_CD == "0000"){
			_thisPage.printFile(dat);
		}
	});
}

function __fn_init(){
	$("#txof_0101_01").parents("div").addClass("on");
}