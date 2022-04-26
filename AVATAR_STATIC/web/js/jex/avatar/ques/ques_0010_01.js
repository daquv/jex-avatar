/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_0010_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 김별 (  )
 * @Description    : 거래처 화면
 * @History        : 20200207162613, 김별
 * </pre>
 **/
$(function(){
	iWebAction("changeTitle",{"_title" : "질의", "_type" : "2"});
	_thisPage.onload();
	
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
			if($("#NE_COUNTERPARTNAME").val() == "")
				_thisPage.setData();
			else _thisPage.searchData($("#NE_COUNTERPARTNAME").val());
			
		},
		setData : function(){
			//거래처명 없이 검색 : 거래처에서 가장 상위에 있는 값으로 거래처 검색하기
			var jexAjax = jex.createAjaxUtil("ques_0010_01_r002"); // search default bzaq_nm
			jexAjax.execute(function(data) {
				if(avatar.common.null2void(data.BZAQ_NM)==''){
					$(".data_y").hide();
					$(".data_n").show();
				}else{
					_thisPage.searchData(data.BZAQ_NM);
				}
					
				
			});
			
		},
		searchData : function(bzaq_nm){
			var input = {};
			var replaceString = ['(주)', '(주 )', '( 주)', '( 주 )', '㈜' , '주식회사',
				'(유)', '(유 )', '( 유)', '( 유 )', '유한회사', '유한책임회사',
				'(합)', '(합 )', '( 합)', '( 합 )', '합명회사', '합자회사',
				'(사)', '(사 )', '( 사)', '( 사 )', '사단법인',
				'(재)', '(재 )', '( 재)', '( 재 )', '재단법인',
				'(인)', '(인 )', '( 인)', '( 인 )', '인적회사',
				'(물)', '(물 )', '( 물)', '( 물 )', '물적회사'];
			$.each(replaceString, function(i, v){
			    if(bzaq_nm.includes(v))
			    	bzaq_nm = bzaq_nm.replace(v, '');
			});
			console.log(bzaq_nm);
			input["BZAQ_NM"] = bzaq_nm;
			//input["TRNS_DT"] = avatar.common.getToday().repace(/-/g, "");
			avatar.common.callJexAjax("ques_0010_01_r001", input, _thisPage.fn_callback, "true", "");
			
		},
		updateData : function(intent, ctt){
			var input = {};
			input["INTE_CD"] = intent;		//fn_voice_recog_result 에서 인텐트 코드 가져오기
			input["QUES_CTT"] = ctt;
			avatar.common.callJexAjax("ques_0001_01_u001", input,"", "", "");
		},
		fn_callback : function(dat){
			var totlAmt = 0;
			if(dat.REC2[0].TOTL_CNT==0){
				$(".data_y").hide();
				$(".data_n").show();
			} else{
				$(".data_n").hide();
				$(".data_y").show();
				$.each(dat.REC, function(idx, rec){
					
					//$(".c_blue").text($("#NE_COUNTERPARTNAME").val());
					//$(".elipsis").text($("#NE_COUNTERPARTNAME").val());
					$(".c_blue").text(avatar.common.null2void(rec.BZAQ_NM));
					$(".elipsis").text(avatar.common.null2void(rec.BZAQ_NM));
					
					html= '';
					html += '<tr>';
					html += '	<th>대표이사</th>';
					html += '	<td>'+avatar.common.null2void(rec.RPPR_NM)+'</td>';
					html += '</tr>';
					html += '<tr>';
					html += '	<th>사업자번호</th>';
					html += '	<td>'+avatar.common.corpno_format(avatar.common.null2void(rec.BIZ_NO))+'</td>';
					html += '</tr>';
					html += '<tr>';
					html += '	<th>주소</th>';
					html += '	<td>'+avatar.common.null2void(rec.ADRS)+'</td>';
					html += '</tr>';
					
					$(".list_dv_tbl tbody").append(html);
				});
				if(dat.SEL_REC){
					$.each(dat.SEL_REC, function(idx, rec){
						sel_html = '';
						sel_html += '<dd>';
						sel_html += avatar.common.date_format2(avatar.common.null2void(rec.WRTG_DT)).substr(5,5);
						sel_html +='<div class="right">';
						sel_html += avatar.common.comma(rec.TOTL_AMT, true)+'원';
						sel_html += '</div>';
						sel_html += '</dd>';
						$(".aias_list dt:eq(1)").after(sel_html);
					});
				}
				if(dat.BUY_REC){
					$.each(dat.BUY_REC, function(idx, rec){
						buy_html = '';
						buy_html += '<dd>';
						buy_html += avatar.common.date_format2(avatar.common.null2void(rec.WRTG_DT)).substr(5,5);
						buy_html +='<div class="right">';
						buy_html += avatar.common.comma(rec.TOTL_AMT, true)+'원';
						buy_html += '</div>';
						buy_html += '</dd>';
						$(".aias_list dt:eq(0)").after(buy_html);
					});
				}
				
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