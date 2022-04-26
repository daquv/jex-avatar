/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_0009_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 김별 (  )
 * @Description    : 손익화면/조회
 * @History        : 20200123093248, 김별
 * </pre>
 **/
var date = "";
var date1 = "";
$(function(){
	iWebAction("changeTitle",{"_title" : "질의", "_type" : "2"});
	_thisPage.onload();
	//mic button
	$(document).on('click', '.btn_mic', function(){
		$(".m_cont").css("display", "none");
		iWebAction("fn_voice_recog", {"_callback":"fn_voice_recog_result", "_cancel_callback":"fn_cancel"});
	});
	
	//데이터가져오기
	$(document).on("click",".btn_s01", function(){
		location.href = "basic_0002_01.act";
	});
});

var _thisPage = {
		onload : function(){
			_thisPage.fn_calDate();	
			_thisPage.searchData();
		},
		searchData : function(){
			var input = {};
			input["STR_DT"]		= date;
			input["END_DT"]		= date1;
			avatar.common.callJexAjax("ques_0009_01_r001", input, _thisPage.fn_callback, "", "c");
		},
		updateData : function(intent, ctt){
			var input = {};
			input["INTE_CD"] = intent;		//fn_voice_recog_result 에서 인텐트 코드 가져오기
			input["QUES_CTT"] = ctt;
			avatar.common.callJexAjax("ques_0001_01_u001", input,"", "", "");
		},
		fn_callback : function(data){
			if((data.REC2.length==0)&&(data.REC3[0].CNT==0)&&(data.REC3[1].CNT==0)){
				$(".data_y").hide();
				$(".data_n").show();
			} else {
				$(".data_n").hide();
				$(".data_y").show();
				if(data.REC2.legth==0)
					$(".set_list li:eq(1) .sub .card:eq(1)").children().addClass("c_gr");
				if(data.REC3[0].CNT==0){
					$(".set_list li:eq(1) .sub .card:eq(0)").children().addClass("c_gr");
					$(".set_list li:eq(1) .sub .card:eq(2)").children().addClass("c_gr");
					$(".set_list li:eq(0) .sub .card:eq(0)").children().addClass("c_gr");
					$(".set_list li:eq(0) .sub .card:eq(2)").children().addClass("c_gr");
				}
				if(data.REC3[1].CNT==0)
					$(".set_list li:eq(0) .sub .card:eq(1)").children().addClass("c_gr");
				
				$(".sub:eq(0) .right:eq(0)").html(avatar.common.comma(data.SEL_REC[0].TXBL_AMT,true)+" 원");
				$(".sub:eq(0) .right:eq(1)").html(avatar.common.comma(data.SEL_REC[0].CARD_AMT,true)+" 원");
				$(".sub:eq(0) .right:eq(2)").html(avatar.common.comma(data.SEL_REC[0].CASH_AMT,true)+" 원");
				var selAmt = parseInt(data.SEL_REC[0].TXBL_AMT)+parseInt(data.SEL_REC[0].CARD_AMT)+parseInt(data.SEL_REC[0].CASH_AMT);
				$("li:eq(0) .card:eq(0) .right").html(avatar.common.comma(selAmt,true)+" 원");
				
				$(".sub:eq(1) .right:eq(0)").html(avatar.common.comma(data.BUY_REC[0].TXBL_AMT,true)+" 원");
				$(".sub:eq(1) .right:eq(1)").html(avatar.common.comma(data.BUY_REC[0].CARD_AMT,true)+" 원");
				$(".sub:eq(1) .right:eq(2)").html(avatar.common.comma(data.BUY_REC[0].CASH_AMT,true)+" 원");
				var buyAmt = parseInt(data.BUY_REC[0].TXBL_AMT)+parseInt(data.BUY_REC[0].CARD_AMT)+parseInt(data.BUY_REC[0].CASH_AMT);
				$("li:eq(1) .card:eq(0) .right").html(avatar.common.comma(buyAmt,true)+" 원");
				if(selAmt-buyAmt >= 0){
					$(".c_red").hide();
					$(".c_blue").show();
					$(".c_blue .big").html(avatar.common.comma(selAmt-buyAmt, true)+"원");
				}
				else{
					$(".c_blue").hide();
					$(".c_red").show();
					$(".c_red .big").html(avatar.common.comma(selAmt-buyAmt, true)+"원");
				}
				if(avatar.common.null2void(date1)!="")
					$(".aias_news strong").html(date_format_kr(date)+" ~ " + date_format_kr(date1) +"예상손익은");
				else{
					$(".aias_news strong").html(date_format_kr(date) +"예상손익은");
				}
			}
		},
		fn_calDate : function(){
			if($("#NE_DAY").val())	{
				day = $("#NE_DAY").val();
				if(day == "당일" || day =="전일"){
					date=avatar.common.getDate("yyyymmdd", "D", -1);
				}
				else if(day == "전주"){
					date = avatar.common.fn_getWeek(avatar.common.getDate("yyyymmdd"), 1)[0];
					date1 = avatar.common.fn_getWeek(avatar.common.getDate("yyyymmdd"), 1)[1];
				}
				else if(day == "금주"){
					date = avatar.common.fn_getWeek(avatar.common.getDate("yyyymmdd"), 0)[0];
					date1 = avatar.common.fn_getWeek(avatar.common.getDate("yyyymmdd"), 0)[1];
				}
				else if(day == "전월"){
					date = avatar.common.getDate("yyyymm", "M", -1)+"01";
					date1 = avatar.common.getDate("yyyymm", "M", -1)+avatar.common.getLastDate(avatar.common.getDate("yyyy"), avatar.common.getDate("mm", "M", -1));
				}
				else if(day == "금월"){
					date = avatar.common.getDate("yyyymm")+"01";
					date1 = avatar.common.getDate("yyyymm")+avatar.common.getLastDate(avatar.common.getDate("yyyy"), avatar.common.getDate("mm"));
				}
			} else if($("#NE_BMONTH").val() || $("#NE_BDAY").val()){
				var month = $("#NE_BMONTH").val().substr(0, $("#NE_BMONTH").val().length-1);
				if(month <10)	month = "0"+month;
				var day = $("#NE_BDAY").val().substr(0,$("#NE_BDAY").val().length-1);
				if (day < 10)	day = "0"+day;
				
				if($("#NE_BMONTH").val() && $("#NE_BDAY").val()){
					/*
					 * A월 B일
					 * A월 B일>당일 -> 작년
					 */
					if(month+day > avatar.common.getDate("mmdd"))
						date = avatar.common.getDate("yyyy", "Y", -1) +month+day;
					else
						date = avatar.common.getDate("yyyy")+month+day;
				} 
				else{
					if($("#NE_BMONTH").val()){
						/* 
						 * A월
						 * 1.금월>A월 올해기준
						 * 2.금월<A월 작년
						 */
						 if(avatar.common.getDate("mm")>=month){
							_month=avatar.common.getDate("yyyy")+month;
							date = _month;
						} else if(avatar.common.getDate("mm")<month){
							_month=avatar.common.getDate("yyyy","Y",-1)+month;
							date = _month;
						}
					}
					else if($("#NE_BDAY").val()){
						/* 
						 * B일
						 * 1.당일<B일 전월 B일
						 * 2.당일>=B일 금월 B일
						 */
						if(avatar.common.getDate("dd")<day)
							date = avatar.common.getDate("yyyymm", "M", -1)+day;
						else
							date = avatar.common.getDate("yyyymm")+day;
					}
				}
			} else{
				date = String(avatar.common.getDate("yyyymm"));
			}
		},
		pageMove : function(intent, appinfo){
			var jexAjax = jex.createAjaxUtil("ques_0001_02_r001"); // PT_ACTION
			jexAjax.set("INTE_CD", intent);
			var NE_DAY = avatar.common.null2void(appinfo["NE-DAY"]);
			var NE_BMONTH = avatar.common.null2void(appinfo["NE-B-Month"]);
			var NE_BDAY = avatar.common.null2void(appinfo["NE-B-date"]);
			var NE_COUNTERPARTNAME = avatar.common.null2void(appinfo["NE-COUNTERPARTNAME"]);
			jexAjax.execute(function(data) {
				if(avatar.common.null2void(data.RSLT_PAGE_URL)==""){
					var url =  "ques_0000_01.act";
					iWebAction("openPopup",{"_url" : url});
					//location.href = "ques_0000_01.act";
				}
				else{
					var url = data.RSLT_PAGE_URL+"?NE_DAY="+NE_DAY+"&NE_BMONTH="+NE_BMONTH+"&NE_BDAY="+NE_BDAY+"&NE_COUNTERPARTNAME="+NE_COUNTERPARTNAME;
					iWebAction("openPopup",{"_url" : url});
					//location.href = data.RSLT_PAGE_URL+"?NE_DAY="+NE_DAY+"&NE_BMONTH="+NE_BMONTH+"&NE_BDAY="+NE_BDAY+"&NE_COUNTERPARTNMAE="+NE_COUNTERPARTNAME;
				}
					
			});			
		},
}
function date_format_kr(date){
	var year = date.substr(0,4)+"년 ";
	var month = date.substr(4,2)+"월 ";
	var day = date.substr(6,2)+"일 ";
	
	if(!date.substr(6,2)){
		if(!date.substr(4,2))	date_kr = year;
	    else	date_kr = year+month;
	} else { date_kr = year+month+day; }
	return date_kr;
}
function parseDate(str) {
    var y = str.substr(0, 4);
    var m = str.substr(4, 2);
    var d = str.substr(6, 2);
    return new Date(y,m-1,d);
}
/* Webaction callbackFun */
function fn_back(){
	iWebAction("closePopup");
}
function fn_voice_recog_result(data){
	var dat = JSON.parse(data);
	var dataTxt = dat.recog_txt;
	var dataDat = avatar.common.null2void(dat.recog_data);	
	var dataIntent = avatar.common.null2void(dataDat.Intent);
	var dataRslt = avatar.common.null2void(dataDat.appInfo);
	_thisPage.updateData(dataIntent, dataTxt)
	_thisPage.pageMove(dataIntent, dataRslt);
}
function fn_cancel(){
	$(".m_cont").css("display", "block");
}