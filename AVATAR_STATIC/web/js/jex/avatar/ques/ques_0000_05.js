/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_0000_05.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 김예지 (  )
 * @Description    : 질의_데이터없음 화면
 * @History        : 20211222162130, 김예지
 * </pre>
 **/
$(function(){
	_thisPage.onload();
	
	if(quesGb == '01'){
		$(document).on("click", ".ai_list ul li a", function(){
			INTE_INFO = "{'recog_txt':'"+$(this).text()+"','recog_data' : {'Intent':'ASP001','appInfo' : {'NE-COUNTERPARTNAME' : '"+$(this).text()+"', 'BZAQ_KEY' : '"+$(this).attr('bzaqKey')+"'}} }" ;
			
			var url = "";
			if(LGIN_APP === "ZEROPAY") {
				url = "ques_comm_10.act?INTE_INFO="+INTE_INFO+"&USER_CI="+encodeURIComponent(USER_CI);
				location.href = url;
			} else {
				url = "ques_comm_01.act?INTE_INFO="+INTE_INFO;				
				iWebAction("openPopup",{"_url" : url});
			}
		});
	} else if (quesGb == '02'){
		$(document).on("click", ".ai_list ul li a", function(){
			INTE_INFO = "{'recog_txt':'"+$(this).text()+"','recog_data' : {'Intent':'"+$(this).attr('intent')+"','appInfo' : {}} }" ;
			var url = "";
			if(LGIN_APP === "ZEROPAY") {
				url = "ques_comm_10.act?INTE_INFO="+INTE_INFO+"&USER_CI="+encodeURIComponent(USER_CI);
				location.href = url;
			} else {
				url = "ques_comm_01.act?INTE_INFO="+INTE_INFO;				
				iWebAction("openPopup",{"_url" : url});
			}
		});
	}
	else{
		$(document).on("click", ".btn_rolling li p", function(){
			INTE_INFO = "{'recog_txt':'"+$(this).text()+"','recog_data' : {'Intent':'"+$(this).attr('intent')+"','appInfo' : {}} }" ;
			var url = "";
			if(LGIN_APP === "ZEROPAY") {
				var url = "ques_comm_10.act?INTE_INFO="+INTE_INFO+"&USER_CI="+encodeURIComponent(USER_CI);
				location.href = url;
			} else {
				var url = "ques_comm_01.act?INTE_INFO="+INTE_INFO;
				iWebAction("openPopup",{"_url" : url});				
			}
		});
	}
})
var _thisPage = {
	onload : function(){
		if(avatar.common.null2void(quesGb) == "00"){ //ques
			var quesData = JSON.parse(jsonData);
			_thisPage.setData_ques(quesData);
		} else if(avatar.common.null2void(quesGb) == "01"){ //bazaq
			var bzaqData = JSON.parse(jsonData);
			_thisPage.setData_bzaq(bzaqData);
		}
	},
	setData_bzaq : function(rec){
		console.log('bzaq');
		console.log(rec);
		$.each(rec, function(i, v){
			totalHtml= '';
			totalHtml+='<li>';
			totalHtml+='	<a class="elipsis" bzaqKey="'+v.BZAQ_KEY+'">'+v.CLASS_BZAQ_NM+'</a>';
			totalHtml+='</li>';
			
			$(".ai_list ul").append(totalHtml);
		});
	},
	setData_ques : function(rec){
		console.log(rec);
		totalHtml= '';
		$.each(rec, function(i, v){ 
			if(i%3==0){
				totalHtml += '<li class="slide">';
			}
			totalHtml+='	<p class="btn_s04" intent="'+v.INTE_CD+'">“'+v.QUES_CTT+'”</p><br>';
			// 3개씩 끊어서 묶어야됨.
			if(i%3==0 && rec.length-1 == i){
				totalHtml+='	<p class="btn_s04"></p><br>';
				totalHtml+='	<p class="btn_s04"></p><br>';
			}else if(i%3==1 && rec.length-1 == i){
				totalHtml+='	<p class="btn_s04"></p><br>';
			}
			if(i%3==2 || rec.length-1 == i){
				totalHtml += '</li>';
			}
		});
		console.log(totalHtml);
		//alert(totalHtml);
		$(".btn_rolling").append(totalHtml);
	},
	searchData : function(){
		avatar.common.callJexAjax("ques_0001_01_r001", "", _thisPage.fn_callback, "true", "");
	},
	fn_callback : function(data){
		if(data.REC_TOP.length==0){
			$.each(data.REC_TOTAL, function(idx, rec){
				totalHtml= '';
				totalHtml+='<li>';
				if(LGIN_APP === "ZEROPAY") {
					totalHtml+='	<a class="elipsis" intent="'+rec.INTE_CD+'" pageURL="'+rec.RSLT_PAGE_URL+'&USER_CI='+encodeURIComponent(USER_CI)+'">'+rec.QUES_CTT+'</a>';
				} else {
					totalHtml+='	<a class="elipsis" intent="'+rec.INTE_CD+'" pageURL="'+rec.RSLT_PAGE_URL+'">'+rec.QUES_CTT+'</a>';					
				}
				totalHtml+='</li>';
				
				$(".ai_list ul").append(totalHtml);
			});
		} else{
			$.each(data.REC_TOP, function(idx, rec){
				topHtml= '';
				topHtml+='<li>';
				if(LGIN_APP === "ZEROPAY") {
					topHtml+='	<a class="elipsis" intent="'+rec.INTE_CD+'" pageURL="'+rec.RSLT_PAGE_URL+'&USER_CI='+encodeURIComponent(USER_CI)+'">'+rec.QUES_CTT+'</a>';
				} else {
					topHtml+='	<a class="elipsis" intent="'+rec.INTE_CD+'" pageURL="'+rec.RSLT_PAGE_URL+'">'+rec.QUES_CTT+'</a>';
				}
				topHtml+='</li>';
				
				$(".ai_list ul").append(topHtml);
			});
		}
	}
}
function fn_getWebResultTTS(data){
	avatar.common.null2void(data)==""?data="Y":data=data;
	if(data == "Y"){
		iWebAction("webResultTTS",{"_data" : avatar.common.null2void($("#RESULT_TTS").text())});
	}
}
function fn_back(){
	iWebAction("closePopup",{_callback:"fn_popCallback2"});
}