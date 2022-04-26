/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0006_03.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200820160911, 김별
 * </pre>
 **/
$(function(){
	if($("#BLBD_DIV").val() == "01"){
		iWebAction("changeTitle",{"_title" : "고객문의","_type" : "2"});
	} else if($("#BLBD_DIV").val() == "02"){
		iWebAction("changeTitle",{"_title" : "공지사항","_type" : "2"});
	}
	_thisPage.onload();
	$(document).on("click", ".btn_down", function(){
		var file_url = "";
		if($("#BLBD_DIV").val() == "01"){
			file_url = document.URL.substring(0,document.URL.lastIndexOf('/'))+"/file/img/"+$(this).data("save_file_nm");
		} else if($("#BLBD_DIV").val() == "02"){
			file_url = document.URL.substring(0,document.URL.lastIndexOf('/'))+"/file/blbd/"+$(this).data("save_file_nm");
		}
		//alert("FILE_PATH :: "+document.URL.substring(0,document.URL.lastIndexOf('/'))+"/file/img/"+$(this).data("save_file_nm"));
		//alert("FILE_NAME :: "+$(this).text());
		iWebAction("downloadFile"
								,{"_file_url":file_url,
								  "_file_name":$(this).text()
								  }
					);
	});
});

var _thisPage = {
		onload : function(){
			if($("#BLBD_DIV").val() == "01"){
				$("#cont_inq").show();
				$("#cont_noti").hide();
			} else if($("#BLBD_DIV").val() == "02"){
				$("#cont_noti").show();
				$("#cont_inq").hide();
			}
			_thisPage.setData();
		},
		setData : function(){
			var jexAjax = jex.createAjaxUtil("basic_0006_03_r001");   //PT_ACTION 웹 서비스 호출
			//상태, 검색대상, 카테고리
			input = {};
			input["BLBD_NO"] = $("#BLBD_NO").val();
			input["BLBD_DIV"] = $("#BLBD_DIV").val();
			jexAjax.set(input);
			jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
			jexAjax.execute(function(dat) {
				
				if($("#BLBD_DIV").val() == "01"){
					var rec_blbd = dat.REC_BLBD[0];
					$(".qtit").text(rec_blbd.BLBD_TITL);
					$(".qdetail .date").text(avatar.common.datetime_format2(rec_blbd.REG_DTM));
					if(rec_blbd.STTS == "2"){
						$(".answer").text("답변완료");
						$(".answer").addClass("end");
					}
					else{
						$(".answer").removeClass("end");
						$(".answer").text("처리중");
					}
					var blbd_ctt = rec_blbd.BLBD_CTT;
					$(".qcont").text(rec_blbd.BLBD_CTT);
					if(dat.REC_FILE.length>0){
						$(".qw_cont .addfile").show();
						var fileHtml;
						$.each(dat.REC_FILE, function(idx, rec){
							fileHtml = "";
							fileHtml += "<li class='down'><a href='#none' class='btn_down' data-save_file_nm="+rec.SAVE_FILE_NM+">"+rec.ORG_FILE_NM+"</a></li>";
							
							$(".qw_cont .filelist").append(fileHtml);
						});
					}
					
					if(!jQuery.isEmptyObject(dat.REC_RPLY)){
						$(".aw_cont").show();
						var rec_rply = dat.REC_RPLY;
						$(".asdate").text(avatar.common.datetime_format2(rec_rply.REG_DTM));
						$(".cs_cont").text(rec_rply.RPLY_CTT);
						if(dat.REC_RPLY_FILE.length>0){
							$(".aw_cont .addfile").show();
							var fileHtml;
							$.each(dat.REC_RPLY_FILE, function(idx, rec){
								fileHtml = "";
								fileHtml += "<li class='down'><a href='#none' class='btn_down'  data-save_file_nm="+rec.SAVE_FILE_NM+">"+rec.ORG_FILE_NM+"</a></li>";
								
								$(".aw_cont .filelist").append(fileHtml);
							});
						}
					}
				} else if($("#BLBD_DIV").val() == "02"){
					var rec_blbd = dat.REC_BLBD[0];
					$(".ntit").text(rec_blbd.BLBD_TITL);
					$(".noti_area .date").text(avatar.common.datetime_format2(rec_blbd.REG_DTM));
					var blbd_ctt = rec_blbd.BLBD_CTT;
					console.log(rec_blbd.BLBD_CTT)
					$(".noti_cont").html(rec_blbd.BLBD_CTT);
					if(dat.REC_FILE.length>0){
						$(".noti_area .addfile").show();
						var fileHtml;
						$.each(dat.REC_FILE, function(idx, rec){
							fileHtml = "";
							fileHtml += "<li class='down'><a href='#none' class='btn_down' data-save_file_nm="+rec.SAVE_FILE_NM+">"+rec.ORG_FILE_NM+"</a></li>";
							
							$(".noti_area .filelist").append(fileHtml);
						});
					}
				}
				
			});
		}
}
function fn_back(){
	iWebAction("closePopup");
}