/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0006_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200820132754, 김별
 * </pre>
 **/

$(function(){
	_thisPage.onload();
	iWebAction("changeTitle",{"_title" : "1:1 문의하기","_type" : "2"});
	iWebAction("fn_display_mic_button",{"_display_yn":"N"});
	$(document).on("click", ".chk_circle", function(){
		if($(this).hasClass("on")){
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
		}
	});

	$(document).on("click", ".addfile .btn_add", function(){
		//fn_imageCallback(JSON.stringify(testBase64));
		iWebAction("getImage",{"_type":"G", "_callback":"fn_imageCallback"});
	});
	$(document).on("click", ".btn_fix_botm a", function(){
		_thisPage.fn_regi();
	});
	
	$(document).on("click", ".btn_down", function(){
		iWebAction("downloadFile"
								,{"_file_url":document.URL.substring(0,document.URL.lastIndexOf('/'))+"/file/img/"+$(this).data("save_file_nm"),
								  "_file_name":$(this).data("org_file_nm")
								  }
					);
		//fileDownload($(this).data("save_file_nm") , $(this).data("file_path"), $(this).data("org_file_nm"));
	});
	$(document).on("click", '.btn_del', function(){
		fn_deleteFile($(this), $(this).data("save_file_nm"), $(this).data("file_path"));
	});
});

var _thisPage = {
		onload : function(){
			$("#TEL_NO").text(avatar.common.phoneFomatter($("#CLPH_NO").val()));
			/*if(JSON.parse(SAVE_FILE_LIST).length>0){
				iWebAction("getAppData",{"_key":"_QUES_CTT", "_call_back" : "fn_setCaptureQuesCtt"});
				iWebAction("getAppData",{"_key":"_INTE_NM", "_call_back" : "fn_setCaptureInteNm"});
				
				var fileData = JSON.parse(SAVE_FILE_LIST);
				var SAVE_FILE_NM = fileData[0].SAVE_FILE_NM;
				var ORG_FILE_NM = fileData[0].ORG_FILE_NM;
				var SAVE_FILE_PATH = fileData[0].SAVE_FILE_PATH;
				console.log("SAVE_FILE_NM :: "+SAVE_FILE_NM);
				console.log("ORG_FILE_NM :: "+ORG_FILE_NM);
				console.log("FILE_PATH :: "+SAVE_FILE_PATH);
				fn_fileuploadCallback(SAVE_FILE_NM,ORG_FILE_NM,SAVE_FILE_PATH);
			}*/
			if($("#BLBD_CONT").val()){
				$("#BLBD_TITL").val("1:1 문의하기 자동 입력");
				$("#BLBD_CTT").html("다음과 같은 음성 입력 값을 처리하는데 실패하였습니다. \n\n 내용 : ")
				$("#BLBD_CTT").append($("#BLBD_CONT").val());
			}
		},
		fn_regi : function(){
			if(_thisPage.fn_regi_valid()){
				var jexAjax = jex.createAjaxUtil("basic_0006_02_c001");   //PT_ACTION 웹 서비스 호출
				var recArray = [];
				$.each($(".btn_down"), function(i){
					var $this = $(this);
					var jsonREC = {};
					jsonREC["BLBD_DIV"		] = "01";
					//jsonREC["BLBD_NO"		] = $this.find("td[gb='CUPN_NO']").text();
					jsonREC["ORG_FILE_NM"	] = $this.data("org_file_nm");
					jsonREC["SAVE_FILE_NM"	] = $this.data("save_file_nm");
					jsonREC["FILE_PATH"		] = $this.data("file_path");
					
					recArray.push(jsonREC);
				});
				input = {};
				input["BLBD_DIV"]	= "01";
				//input["BLBD_CTGR_CD"]	= $("#BLBD_CTGR_CD").val();
				input["BLBD_TITL"]	= $("#BLBD_TITL").val();
				input["BLBD_CTT"]	= $("#BLBD_CTT").val().replace("/\r\n/","<br>");
				input["FILE_YN"]	= $(".filelist li").length>0? "Y" : "N";
				input["STTS"]		= "0";
				input["TEL_NO"]		= $("#CLPH_NO").val();
				jexAjax.set(input);
				jexAjax.set("INSERT_REC",recArray);
				jexAjax.set('async',false);
				jexAjax.execute(function(dat) {
						if(dat.RSLT_CD=="0000"){
							if($("#BLBD_CONT").val() || JSON.parse(SAVE_FILE_LIST).length>0){
								iWebAction("fn_main");
							} else {
								iWebAction("closePopup",{_callback:"fn_popCallback"});
							}
						} else if(dat.RSLT_CD=="9999") {
							alert("처리중 오류가 발생하였습니다.");
						}
					});
			}
		}, 
		fn_regi_valid : function(){
			/*if(avatar.common.null2void($("#BLBD_CTGR_CD").val())==""){
				fn_toast_pop('문의유형을 선택해주세요');
				return false;
			}*/
			if(avatar.common.null2void($("#BLBD_TITL").val())==""){
				fn_toast_pop('제목을 입력해주세요');
				return false;
			}
			if(avatar.common.null2void($("#BLBD_CTT").val())==""){
				fn_toast_pop('문의 내용을 입력해주세요');
				return false;
			}
			if(!$(".chk_circle").hasClass("on")){
				fn_toast_pop('개인정보 수집 및 이용에 동의해주세요');
				return false;
			}
			return true;
		},
}
function fn_setCaptureInteNm(data){
	$("#BLBD_TITL").val(data + " 개선 요청");
}
function fn_setCaptureQuesCtt(data){
	$("#BLBD_CTT").html(data)
	$("#BLBD_CTT").append($("#BLBD_CONT").val());
}
function fn_back(){
	$(".btn_del").each(function(i, v){
		fn_deleteFile($(v), $(v).data("save_file_nm"), $(v).data("file_path"));
	});
	iWebAction("closePopup",{_callback:"fn_popCallback2"}); 
}

function fn_imageCallback(data){
	var jexAjax = jex.createAjaxUtil("basic_0006_04");
	jexAjax.set("FILE_DATA", data);
	jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
	jexAjax.execute(function(dat) {

		var data = dat.RSLT_CTT;
		if(data.RESP_CD == "0000"){
			var SAVE_FILE_NM = data.RESP_DATA;
			var FILE_PATH = data.FILE_PATH;
			var ORG_FILE_NM = data.ORIGIN_FILENM; 	//원본파일명
			var originFileSz = data.FILE_SIZE; 		//파일사이즈
			fn_fileuploadCallback(SAVE_FILE_NM,ORG_FILE_NM,FILE_PATH);
		}else if(data.RESP_CD == "8888"){
			alert("파일을 선택하십시오.");
		}else{
			alert("오류 업로드.");
		}
	});
}

function fn_fileuploadCallback(SAVE_FILE_NM,ORG_FILE_NM,FILE_PATH){
	var tempHtml = "";
	tempHtml += "<li class='down'><a href='#none' class='btn_down' data-ORG_FILE_NM="+ORG_FILE_NM+" data-FILE_PATH="+FILE_PATH+" data-SAVE_FILE_NM="+SAVE_FILE_NM+">"+ORG_FILE_NM+"</a>";
	tempHtml +=		" <a href='#none' class='btn_del' data-ORG_FILE_NM="+ORG_FILE_NM+" data-FILE_PATH="+FILE_PATH+" data-SAVE_FILE_NM="+SAVE_FILE_NM+"></a></li>";
	
	$(".filelist").append(tempHtml);
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
	jexAjax.set("FILE_PATH"    , FILE_PATH);  	//파일명
	
	jexAjax.execute(function(data){
		if(data.RSLT_CD=="0000"){
			$this.closest("li").remove();
		} 
	});
}
function fn_toast_pop(msg){
	$('#toast_msg').text(msg);
	$('.toast_pop').css('display','block');
	setTimeout(function(){
		$('.toast_pop').css('display', 'none');
	}, 2000);
}

