/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_0002_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 김별 (  )
 * @Description    : 통장잔액화면/조회
 * @History        : 20200122165149, 김별
 * </pre>
 **/

/*UNFINISHED TASKS
* 1. 
* 2. 
*/
var date = "";
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
	//1. 뒤로가기 버튼, 처리
	//2. 질의 버튼
	//3. 하단부 버튼 클릭 시
});

var _thisPage = {
		onload : function(){
			
			_thisPage.fn_calDate();
			_thisPage.searchData();
			
		},
		searchData : function(){
			var input = {};
			input["TRNS_DT"] = date;
			avatar.common.callJexAjax("ques_0002_01_r001", input, _thisPage.fn_callback, "true", "");
			
		},
		updateData : function(intent, ctt){
			var input = {};
			input["INTE_CD"] = intent;		//fn_voice_recog_result 에서 인텐트 코드 가져오기
			input["QUES_CTT"] = ctt;
			avatar.common.callJexAjax("ques_0001_01_u001", input,"", "", "");
		},
		fn_callback : function(dat){
			var totlAmt = 0;
			if(dat.REC2.length == 0){
				$(".data_y").hide();
				$(".data_n").show();
			}
			else{
				$(".data_n").hide();
				$(".data_y").show();
				if(dat.REC.length == 0){
					$(".aias_news .c_blue").html('0원');
					if(avatar.common.null2void(date1)!="")
						$(".aias_news strong").html(date_format_kr(date)+" ~ " + date_format_kr(date1));
					else{
						$(".aias_news strong").html(date_format_kr(date));
					}
				}
				else {
					$.each(dat.REC, function(idx, rec){
						html= '';
						html+='<dd>';
						html+='	<span class="'+findBankIco(rec.BANK_CD)+'" bankCd="'+rec.BANK_CD+'">'+rec.BANK_NM+'</span>';
						html+=rec.FNNC_INFM_NO;
						html+='	<div class="right">';
						html+=avatar.common.comma(rec.BAL_AMT,true)+'원';
						html+='	</div>';
						html+='</dd>';
						
						$(".aias_list dt").after(html);
						var bal_amt = avatar.common.null2void(rec.BAL_AMT);
						if(bal_amt =="")
							bal_amt = parseInt(bal_amt + 0);
						else
							bal_amt = parseInt(bal_amt);
						totlAmt += bal_amt;
					});
					$(".aias_news span:eq(0)").html(avatar.common.comma(totlAmt,true)+"원")
					$(".aias_news strong").html(date_format_kr(date));
					//$(".aias_news strong").html( avatar.common.getDate("yyyymmdd","D",-1));
				}
			}
		},
		fn_calDate : function(){
			if($("#NE_DAY").val())	{
				day = $("#NE_DAY").val();
				if(day == "당일" || day =="전일" || day == "금주" || day == "금월") 
					date = avatar.common.getDate("yyyymmdd","D",-1);
				else if(day == "전주"){
					date = avatar.common.fn_getWeek(avatar.common.getDate("yyyymmdd"), 1)[1];
				}
				else if(day=="전월")
					date = avatar.common.getDate("yyyymmdd","M",-1);
			} else if($("#NE_BMONTH").val() || $("#NE_BDAY").val()){
				var month = $("#NE_BMONTH").val().substr(0, $("#NE_BMONTH").val().length-1);
				if(month <10)	month = "0"+month;
				var day = $("#NE_BDAY").val().substr(0,$("#NE_BDAY").val().length-1);
				if (day < 10)	day = "0"+day;
				
				if($("#NE_BMONTH").val() && $("#NE_BDAY").val()){
					if(month+day > avatar.common.getDate("mmdd"))
						date = avatar.common.getDate("yyyymmdd", "Y", -1);
					else
						date = avatar.common.getDate("yyyy")+month+day;
				} 
				else{
					if($("#NE_BMONTH").val()){
						if(avatar.common.getDate("mm") == month)
							date = avatar.common.getDate("yyyymmdd","D",-1);
						else if(avatar.common.getDate("mm")>month){
							_month =avatar.common.getDate("yyyy")+month;
							_day = avatar.common.getLastDate(avatar.common.getDate("yyyy"),month);
							date = _month+_day;
						} else if(avatar.common.getDate("mm")<month){
							_month =avatar.common.getDate("yyyy","Y",-1)+month;
							_day = avatar.common.getLastDate(avatar.common.getDate("yyyy"),month);
							date = _month+month+_day;
						}
					}
					else if($("#NE_BDAY").val()){
						if(avatar.common.getDate("dd")<day)
							date = avatar.co0mmon.getDate("yyyymm", "M", -1)+day;
						else
							date = avatar.common.getDate("yyyymm")+day;
					}
				}
			} else{
				date = avatar.common.getDate("yyyymmdd", "D", -1)
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
function findBankIco(bank_cd){
	if(bank_cd == '003') ico = 'ico01';
	else if(bank_cd == '004') ico = 'ico03';
	else if(bank_cd == '020') ico = 'ico05';
	else if(bank_cd == '088') ico = 'ico06';
	else if(bank_cd == '081') ico = 'ico07';
	else if(bank_cd == '023') ico = 'ico08';
	else if(bank_cd == '011') ico = 'ico09';
	else if(bank_cd == '071') ico = 'ico10';
	else if(bank_cd == '027') ico = 'ico11';
	else if(bank_cd == '031') ico = 'ico12';
	else if(bank_cd == '032') ico = 'ico13';
	else if(bank_cd == '045') ico = 'ico15';
	else if(bank_cd == '050') ico = 'ico17';
	else if(bank_cd == '064') ico = 'ico23';
	return ico;
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
function fn_back(){
	history.back();
	//history.back();
}
function fn_cancel(){
	$(".m_cont").css("display", "block");
}