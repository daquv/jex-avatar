/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_comm_11.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 하준태 (  )
 * @Description    : IBKCRM앱 발화 응답화면(공통)
 * @History        : 20220331163213, 하준태
 * </pre>
 **/


var sum = 0;
var isMore;				//스크롤 다운 후 데이터 유무 확인 
var trnsDt = "";		//날짜 별로 내역 표시  
var inteNm = "";		//인텐트명 
var _intent = _thisCont.INTE_INFO.recog_data.Intent;
var recElemNm = "SQL2";
let totCnt = 0;

$(function(){
	_thisPage.onload();
})

var _thisPage = {
	onload : function(){		
		var input = {};
		input["PAGE_NO"] = _thisCont.PAGE_NO;
		input["PAGE_CNT"] = _thisCont.PAGE_CNT;
		input["INTE_INFO"] = _thisCont.INTE_INFO;
		
		avatar.common.callJexAjax("ques_comm_11_r001", input, _thisPage.fn_callback, "false", "");
	},

	fn_callback : function(data) {

		let rsltJson = JSON.parse(data.RSLT_CTT);
		console.log(rsltJson);
		totCnt = rsltJson.CNT;
		if (Object.keys(rsltJson).length == 0) {
			dataYn = "N";
		}

		if (avatar.common.null2void(JSON.parse(data.RSLT_CTT).SQL2).length == 0) {
			isMore = false;
		} else isMore = true;

		_thisCont["PAGE_NO_RENDER"] = _thisCont.PAGE_NO;

		//첫번째 조회시에는 html 및 유사질의데이타 조회
		if (_thisCont.PAGE_NO == 1) {
			//admin에서 등록한 html 그리기-화면나오고 필요한 작업들은 이 이후에 처리.
			$(".content").html(data.OTXT_HTML);
			$(".content").show();
			// iWebAction("getStorage",{_key : "keyWebResultTTS", _call_back : "fn_getWebResultTTS"});
		}

		$.each(rsltJson, function(i, sql_data) {
			// // 다건
			// if(Array.isArray(sql_data)) {
			// 	$.each(sql_data, function(idx, rec) {
			// 		var $clone = $("#"+i).children().eq(0).clone();
			// 		var $_tag = "";
			// 		//날짜별 내역 조회 시 사용 / 퍼블 변경 시 아래 내용 수정 필요
			// 		if($("#SCRLL_REC").val() == "01"){
			// 			if($(".dt_scroll")){
			// 				if($clone.find(".dt_scroll tr").length > 0)
			// 					$_tag = "tr";
			// 				else if($clone.find(".dt_scroll dd").length > 0)
			// 					$_tag = "dd";
			//
			// 				$clone.find(".dt_scroll").find($_tag).not($_tag+":eq(0)").remove();
			// 			}
			// 		}
			// 		for(key in rec){
			// 			_thisPage.setHtmlData($clone, key, rec);
			// 		}
			// 	}
			// }
			//단건
			// else {
				_thisPage.setHtmlData(null, i, sql_data);
			// }
		});
	},

	setHtmlData : function(obj, key, data){
		var ele = null;
		var eleId = key.toUpperCase();
		if(obj == null){
			// 단건
			ele = $("#"+eleId);
			ele_nm = $("span[name='"+eleId+"']");
			if(eleId.indexOf("CLASS")>-1 || eleId.indexOf("_INQ_DT")>-1 || eleId.indexOf("SRCH_WD")>-1){
				ele = $("."+eleId);
			}
			var val = data;
			if(data == null){
				return false;
			}
		}else{
			// 다건
			ele = obj.find("#"+eleId);
			ele_nm = $("span[name='"+eleId+"']");
			if(eleId.indexOf("CLASS")==0 || eleId.indexOf("_INQ_DT")>-1){
				ele = $("."+eleId);
			}
			var val = avatar.common.null2void(data[key]);
		}

		try{
			var dataTye="";
			if(0==$(ele).length){
				dataType = avatar.common.null2void($(ele_nm).attr("data-type"));//.toLowerCase();
			} else{
				dataType = avatar.common.null2void($(ele).attr("data-type"));//.toLowerCase();
			}
			if(dataType){
				if(dataType == "datetime"){
					if(val){
						val = eval("formatter."+dataType+"("+val+")");
					}
					else val = avatar.common.getDate();
				}
				else{
					val = eval("formatter."+dataType+"('"+val+"')");
				}
			}
			ele.html(val);
			ele_nm.html(val);
		}catch(e){}
	}
}

function fn_getWebResultTTS(data){
	if(avatar.common.null2void(data)===""){
		iWebAction("setStorage",{"_key" : "keyWebResultTTS", "_value" : "Y"});
	}
	avatar.common.null2void(data)==""?data="Y":data=data;
	if(data == "Y"){
		$.each($("#RESULT_TTS").children(), function(i, v){
			if(avatar.common.null2void($(v).attr("data-type"))!="" && $(v).attr("data-type").indexOf("dateday")>-1){
				$(v).text(formatter.datekr($(v).text().replace(/\./g, '').replace(/ /g, '').replace(/\([ㄱ-힣]\)/, '')));
			}
		});
		iWebAction("webResultTTS",{"_data" : avatar.common.null2void($("#RESULT_TTS").text())});
	}
}