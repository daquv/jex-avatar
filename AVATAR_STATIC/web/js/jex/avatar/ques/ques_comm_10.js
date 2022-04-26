/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_comm_10.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 김예지 (  )
 * @Description    : 제로페이가맹점앱 발화 응답화면 (공통)
 * @History        : 20211209084827, 김예지
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
	fn_elemEventBinding();
});


var _thisPage = {
		onload : function(){
			// 음성결과에 인텐트코드 없는 경우
			if(!(_thisCont.INTE_INFO["recog_data"] && _thisCont.INTE_INFO["recog_data"]["Intent"])) {
				location.href = "ques_0000_05.act?QUES_DIV=02&USER_CI="+encodeURIComponent(userCi);
				return;
			}
			
			if(_thisCont.INTE_INFO["recog_data"]["Intent"] !== 'ASP005'){
				_thisPage.fn_inputSet();
			}

		},
		/**
		 * intent 유무, intent 이름 확인   
		 */
		fn_inputSet : function(){
//			var jexAjax = jex.createAjaxUtil("ques_comm_01_r002");
//			jexAjax.set("INTE_CD", _thisCont.INTE_INFO["recog_data"]["Intent"]);
//			console.log("update data input:: " +JSON.stringify(inteInfo));
//		
//			jexAjax.execute(function(data) {
//				console.log("updated data :: " +JSON.stringify(data));
//				
//				if(avatar.common.null2void(data.INTE_CNT) == ""){
//					_thisPage.getAppInfo();
//				}else{
//					inteNm = data.INTE_NM;
//					iWebAction("changeTitle",{"_title" : inteNm, "_type" : "2"});
					_thisPage.searchData();
//				}
//			});
		},
		/**
		 * 전달받은 inteInfo값으로 질의 search
		 * search 전 inteInfo를 예외처리해야 하는 경우 해당 함수에서 처리한다. 
		 * @param moreData (1페이지 호출시 false, 더보기 처리시 true)
		 */
		searchData : function(moreData){
			//
			if(moreData){
				_thisCont.PAGE_NO = _thisCont.PAGE_NO + 1;
			}
			var input = {};
			input["PAGE_NO"] = _thisCont.PAGE_NO + "";
			input["PAGE_CNT"] = _thisCont.PAGE_CNT + "";
			
			removeDatefromCPN();
			
			/* ##예외처리##
			 거래처 관련 질의(거래처목록,거래처,매출처,매입처)
			 NE-CPN 예외처리 사항 */ 
			if((avatar.common.null2void(_thisCont.INTE_INFO.recog_data.appInfo["NE-COUNTERPARTNAME"]) == ".")|| (avatar.common.null2void(_thisCont.INTE_INFO.recog_data.appInfo["NE-COUNTERPARTNAME"]) == "목록")|| (avatar.common.null2void(_thisCont.INTE_INFO.recog_data.appInfo["NE-COUNTERPARTNAME"]) == "매출")|| (avatar.common.null2void(_thisCont.INTE_INFO.recog_data.appInfo["NE-COUNTERPARTNAME"]) == "매입")){
				_thisCont.INTE_INFO.recog_data.appInfo["NE-COUNTERPARTNAME"] = "";
			}
			if((_thisCont.INTE_INFO.recog_data.Intent == "ASP002"||_thisCont.INTE_INFO.recog_data.Intent == "ASP004") 
				&& avatar.common.null2void(_thisCont.INTE_INFO.recog_data.appInfo["SRCH_WD_YN"]) != "Y"){
				_thisCont.INTE_INFO.recog_data.appInfo["NE-COUNTERPARTNAME"] = "";
			}
			
			/* ##예외처리##
			 제로페이결제내역/결제취소내역
			 NE-CPN 예외처리 사항 */
			if(",ZNN002,ZNN005,ZNN008,ZNN009".indexOf(_thisCont.INTE_INFO.recog_data.Intent) > -1){
				if(_thisCont.INTE_INFO.recog_data.appInfo["NE-COUNTERPARTNAME"]){
					if(_thisCont.INTE_INFO.recog_data.appInfo["NE-ZEROPAY_PAYERNAME"] || _thisCont.INTE_INFO.recog_data.appInfo["NE-ZEROPAY_GIFT_CERTIFICATENAME"])
						_thisCont.INTE_INFO.recog_data.appInfo["NE-COUNTERPARTNAME"] = "";
				}
			}
			
			/* ##예외처리##
			 제로페이상품권 결제내역/결제취소내역
			 NE-CPN 예외처리 사항 */ 
			if(_thisCont.INTE_INFO.recog_data.Intent == "ZNN008" || _thisCont.INTE_INFO.recog_data.Intent == "ZNN009"){
				if(_thisCont.INTE_INFO.recog_data.appInfo["NE-COUNTERPARTNAME"] && _thisCont.INTE_INFO.recog_data.appInfo["NE-ZEROPAY_GIFT_CERTIFICATENAME"]){ 
						_thisCont.INTE_INFO.recog_data.appInfo["NE-COUNTERPARTNAME"] = "";
				}
			}
			
			input["INTE_INFO"] = JSON.stringify(_thisCont.INTE_INFO);
			input["USER_CI"] = userCi;
			
			console.log(input);
			
			avatar.common.callJexAjax("ques_comm_10_r001", input, _thisPage.fn_callback, "false", "");
		},
		/**
		 *  
		 * @param data(ques_comm_01_r001 callback data)
		 */
		fn_callback : function(data){
			
			$("#INTE_NM").text(data.hasOwnProperty("INTE_NM")? data.INTE_NM : "질의");
			inteNm = data.hasOwnProperty("INTE_NM")? data.INTE_NM : "";
			
			let rsltJson = JSON.parse(data.RSLT_CTT);
			console.log(rsltJson);
			totCnt = rsltJson.CNT;

			if(rsltJson.RSLT_CD == "9998" ){
				location.href = "ques_0000_05.act?QUES_DIV=02&USER_CI="+encodeURIComponent(userCi);
			} else if(Object.keys(rsltJson).length == 0 || rsltJson.RSLT_CD == "9999" ){
				dataYn = "N";
			}

			if(rsltJson.hasOwnProperty("REC_ELEM_NM") && avatar.common.null2void(rsltJson.REC_ELEM_NM, "") != "") {
				recElemNm = rsltJson.REC_ELEM_NM;
				data.OTXT_HTML = data.OTXT_HTML.replace("SQL2", recElemNm);
				fn_elemEventBinding()
			}
			
			data.OTXT_HTML  = fn_customHtmlByInteCd(data.OTXT_HTML);
			
			var noPageIntent = ",ASP004";
			var more_yn = avatar.common.null2void(rsltJson.MORE_YN,"N");
			
			if(more_yn == "N" || noPageIntent.indexOf(_intent) > -1){
				if(avatar.common.null2void(JSON.parse(data.RSLT_CTT)[recElemNm]).length == 0){
					isMore = false;
				}
			} else isMore = true;
			
			_thisCont["PAGE_NO_RENDER"] = _thisCont.PAGE_NO;
			
			//정상적이지 않은 시간값이 들어온 경우 시간값 함수에서 ERR_CD를 내려준다.
			if ((avatar.common.null2void(rsltJson.LST_INQ_DT).indexOf("0000") > -1)){
				var ERR_CD =avatar.common.null2void(rsltJson.LST_INQ_DT);
				if(ERR_CD == "00000000"){
					url = "ques_0000_07.act?ERR_CD="+ERR_CD+"&INTE_NM="+inteNm+"&USER_CI="+encodeURIComponent(userCi)+"&LGIN_APP=ZEROPAY";		//I-004
					// iWebAction("openPopup",{"_url" : url});
				} else if (ERR_CD == "00000001"){
					url = "ques_0000_07.act?ERR_CD="+ERR_CD+"&INTE_CD="+_thisCont.INTE_INFO["recog_data"]["Intent"]+"&INTE_NM="+inteNm+"&USER_CI="+encodeURIComponent(userCi)+"&LGIN_APP=ZEROPAY";		//I-005
					// iWebAction("openPopup",{"_url" : url});
				}
				location.href = url;
			} else {
				
				/* ##예외처리##
				 거래처 수에 따라 화면이동 처리한다.
				*/
				if(_thisCont.INTE_INFO["recog_data"]["Intent"]==="ASP001"){
					//다수 거래처(거래처 목록)
					if(rsltJson[recElemNm].length>1){
						
						let enc_inteInfo = "{'recog_txt':'거래처목록 조회','recog_data':{'Intent':'ASP002',appInfo:{'NE-COUNTERPARTNAME':'"+avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"])+"','SRCH_WD_YN':'Y', 'PREV_YN' : 'Y'}}}";
						let url = "ques_comm_10.act?INTE_INFO="+encodeURIComponent(enc_inteInfo);
						location.href = url;
						// iWebAction("openPopup",{"_url" : url});
						return false;
					}
					//거래처 없음(I-001)
					if(rsltJson[recElemNm].length===0 && avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"])!==""){
						let url = "ques_0000_06.act?NE-COUNTERPARTNAME="+encodeURIComponent(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"])
									+"&PREV_YN="+encodeURIComponent('Y')
									+"&MENU_DV=BZAQ"
									+"&USER_CI="+encodeURIComponent(userCi)
									+"&LGIN_APP=ZEROPAY";
						location.href = url;
						// iWebAction("openPopup",{"_url" : url});
						return false;
					}
				}
				
				/* ##예외처리##
				 가맹점 수에 따라 화면이동 처리한다.
				*/
				let frchIntent = ",ASP003,AZN001,AZN002,";
				if(frchIntent.indexOf(_thisCont.INTE_INFO["recog_data"]["Intent"])>-1){
					//다수 가맹점(가맹점목록)
					if(rsltJson[recElemNm].length>1){
						let enc_inteInfo = "{'recog_txt':'가맹점목록 조회','recog_data':{'Intent':'ASP004',appInfo:{'NE-COUNTERPARTNAME':'"+avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"])+"','SRCH_WD_YN':'Y', 'PREV_YN' : 'Y'}}}";
						let url = "ques_comm_10.act?INTE_INFO="+encodeURIComponent(enc_inteInfo)
									+"&PRE_INTENT="+_thisCont.INTE_INFO["recog_data"]["Intent"]
									+"&USER_CI="+encodeURIComponent(userCi);
						location.href = url;
						// iWebAction("openPopup",{"_url" : url});
						return false;
					}
					//가맹점 없음(I-001)
					if(rsltJson[recElemNm].length == 0 && avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"]) != ""){
						let url = "ques_0000_06.act?NE-COUNTERPARTNAME="+encodeURIComponent(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"])
									+"&PREV_YN="+encodeURIComponent('Y')
									+"&MENU_DV=FRAN"
									+"&USER_CI="+encodeURIComponent(userCi)
									+"&LGIN_APP=ZEROPAY";
						location.href = url;
						// iWebAction("openPopup",{"_url" : url});
						return false;
					}
					
				}
				
				//첫번째 조회시에는 html 및 유사질의데이타 조회
				console.log("_thisCont.PAGE_NO  :::" , _thisCont.PAGE_NO );
				if(_thisCont.PAGE_NO == 1){
					//admin에서 등록한 html 그리기-화면나오고 필요한 작업들은 이 이후에 처리.
					$(".m_cont#MAIN").html(data.OTXT_HTML);
					
					//가맹점 개별항목 질의 시(예: 거래처 사업자번호)
					if(",ASP003".indexOf(_thisCont.INTE_INFO["recog_data"]["Intent"]) > -1 && rsltJson[recElemNm].length > 0){
						let sch_word = avatar.common.null2void(rsltJson.sch_word);
						if(sch_word == ""){
							sch_word = rsltJson.SCH_WORD;
							rsltJson.SCH_TIT = rsltJson.SCH_TIT.replace("\n","<br>");
						}
						if(sch_word == "사업자번호"){
							$("#SCH_VAL").attr("data-type", "corpNum"); 
						}else if(sch_word == "매출" || sch_word == "매입"){
							$("#SCH_VAL").attr("data-type", "number");
							$("#SCH_VAL").wrap('<span class="c_357EE7 won"></span>');
							$(".won").append('원');
							if(sch_word == "매입"){
								$(".c_357EE7").removeClass("c_357EE7").addClass("c_CC0000");
							}
						} else if(sch_word=="전화번호"){
							$("#SCH_VAL").attr("data-type", "phone");
						}
					}
				}
				
				$.each(rsltJson, function(i, sql_data){
					
					//다건
					if(Array.isArray(sql_data)){
						
						// 잔고, 카드매출 입금, 자금현황은 페이징 처리 안되어있어서 1페이지 이상일 경우 조회안함. 데이터가 있을 경우에만 html 붙임.
						if(sql_data.length == 0 && _thisCont.PAGE_NO == 1){
							$("#"+i).children().eq(0).remove();
							return true;
						}
						
						$.each(sql_data, function(idx, rec){
							var $clone = $("#"+i).children().eq(0).clone();
							
							var $_tag = "";
							//날짜별 내역 조회 시 사용 / 퍼블 변경 시 아래 내용 수정 필요
							if($("#SCRLL_REC").val() == "01"){
								if($(".dt_scroll")){
									if($clone.find(".dt_scroll tr").length > 0)
										$_tag = "tr";
									else if($clone.find(".dt_scroll dd").length > 0)
										$_tag = "dd";
									
									$clone.find(".dt_scroll").find($_tag).not($_tag+":eq(0)").remove();
								}
							}
							for(key in rec){	
								_thisPage.setHtmlData($clone, key, rec);
							}
							//날짜별 내역 조회 시 사용 / 퍼블 변경 시 아래 내용 수정 필요
							if($("#SCRLL_REC").val() == "01"){
								if(trnsDt != rec.TRSC_DT){
									trnsDt = rec.TRSC_DT;
									$("#"+i).append($clone);
								}else{
									$clone.find(".aias_vbx_top").remove();
									if($(".dt_scroll")){
										var $temp = $clone.find($_tag);
										var $parent = $_tag=="tr"?"tbody":"dl"; 
										$(".list_IO").last().find($parent).append($temp);
									} else {
										var $temp = $clone.find("tbody");
										$(".list_IO").last().find("table").append($temp);
									}
								}
							} else{
								$("#"+i).append($clone);
							}
						});
						if(_thisCont.PAGE_NO == 1){
							$("#"+i).children().eq(0).remove();
						}
					}
					//단건
					else{
						if(_thisCont.PAGE_NO == 1 && i != "TRSC_DT"){
							_thisPage.setHtmlData(null, i, sql_data);							
						}
					}
				});
				
				/* ### 예외처리 ### */
				//답변 화면에서 다른 화면으로 이동 필요 시 사용한다. (NNN005,NNN006,NNN007,NNN008,NNN009,NNN010,NNN011,NNN013,_NNN014,_NNN015)
				console.log($("#redirectURL").length);
				console.log($("#redirectURL").text());
				
				if($("#redirectURL").length>0){
					location.href = $("#redirectURL").text();
				}

				//TTS 형식 변경
				$.each($('[data-tts_type=bignumber2]'), function(i, v){
					$(v).text(formatter.bignumber2($(v).text()));
				});
				$.each($('[data-tts_type=datekr2]'), function(i, v){
					alert($(v).text());
					$(v).text(formatter.datekr2($(v).text()));
					alert($(v).text());
				});

				// 1. 가맹점 결제가능 상품권 (AZN002)
				// 2. 제로페이 상품권 결제 내역 (ZNN008)
				// 3. 제로페이 상품권 결제 취소 내역 (ZNN009)
				$.each($("span[id='IMG_PATH']"), function(i, v){
					if(avatar.common.null2void($(v).text())!=="")
						$(this).prev().attr("src", $(v).text());
				});

				// 1. 가맹점 QR코드 (AZN001)
				if($("#QR_CD").text()){
					$(this).prev().attr("src", "https://chart.googleapis.com/chart?cht=qr&chs=200x200&chl="+$("#QR_CD").text());
				}
				// date값 추가 (MON002,MON003)
//				$("span").each(function(i,v){
				
//					if($(v).data("date")){
//						$(v).text("");
//						$(v).text(avatar.common.getDate("yyyy년 mm월 dd일", "D", $(v).data("date")));
//					}
//				});
				

				// 예외처리 인텐트(거래처) 인텐트
				if((_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("ASP001") >-1 || _thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("ASP003") >-1) && $("#SCH_TIT").text() != ""){
					if($("#SCH_VAL").text() == ""){
						var tts = $("#RESULT_TTS .SRCH_WD").text()+" "+$("#SCH_TIT").text().replace(/는/gi, "").replace(/은/gi, "")+"로 등록된 정보가 없습니다";
						$(".NOTI_TTS").text(tts);
						$(".SCH_END").text(" 없습니다.");
					}else{
						var tts = $("#RESULT_TTS .SRCH_WD").text()+" "+$("#SCH_TIT").text()+" "+$("#SCH_VAL").text()+ "입니다";
						$(".NOTI_TTS").text(tts);
					}
				}
				
				/* --### 예외처리 ### */
				
				// 연결상태 확인 
				$(".CNT").each(function(i,v){
					sum +=parseInt(avatar.common.null2zero($("#"+$(v).attr("id")).text()));
				});
				// 오른쪽 상단 발화내용
				$(".askAvatar_queWord").text(_thisCont.INTE_INFO["recog_txt"]);
				
				// 1. 결제수수료(ZNN003)
				// 2. 입금예정액(ZNN006)
				// 3. 입금예정내역(ZNN007)
				// 4. 매출브리핑(ZSN001)
				// 5. 매출액(SCT001)
				var showIntent = ",ZNN003,ZNN006,ZNN007,ZSN001,SCT001,ZNN001,ZNN002,ZNN005,ZNN008,ZNN009,ZNN004";
				if(showIntent.indexOf(_thisCont.INTE_INFO["recog_data"]["Intent"]) > -1){
					$("body").addClass("bg_F5F5F5");
					$(".content").show();
					$(".m_cont#REALTIME").hide();
					$(".m_cont#MAIN").show();
					if(!(rsltJson.RSLT_CD==="B001" || rsltJson.RSLT_CD==="ZER002")){
						$("div[name=CONTENT]").show();
						$("div[name=SETTING]").hide();
					} else {
						$("div[name=CONTENT]").hide();
						$("div[name=SETTING]").show();
					}
					
					$(".ZEROPAY_CONTENT").show();
					return false;
				}

				if(sum == 0){
					$(".m_cont#REALTIME").hide();
					$(".m_cont#MAIN").show();
					$("body").addClass("bg_F5F5F5");
					$("div[name=CONTENT]").hide();
					$("div[name=SETTING]").show();
					$("div.zero_Avatar").hide();
				} else {
					$("body").addClass("bg_F5F5F5");
					$(".m_cont#REALTIME").hide();
					$(".m_cont#MAIN").show();
					$("div[name=CONTENT]").show();
					$("div[name=SETTING]").hide();
					
					if(rsltJson[recElemNm]){
						if(rsltJson[recElemNm].length == 0 && _thisCont.PAGE_NO == 1){
							$("#LIST_CONTENT").hide();
							$("#TOP_CONTENT").show();
						}
					}
				}
				
				if(rsltJson.hasOwnProperty("LIST_CONTENT_YN")){
					if(rsltJson.LIST_CONTENT_YN ==="Y"){
						$("#LIST_CONTENT").show();
					} else {
						$("#LIST_CONTENT").hide();
					}
				}
				
				$(".content").show();
				$(".ZEROPAY_CONTENT").show();
				
			}
			
		},
		setHtmlData : function(obj, key, data){
			
			var ele = null;
			var eleId = key.toUpperCase();
			if(obj == null){
				ele = $("#"+eleId);
				ele_nm = $("span[name='"+eleId+"']");
				if(eleId.indexOf("CLASS")>-1 || eleId.indexOf("_INQ_DT")>-1 || eleId.indexOf("SRCH_WD")>-1 || eleId.indexOf("_AMT")>-1){
					ele = $("."+eleId);
				}
				var val = data;	
				if(/*eleId == "TRSC_DT" && */data == null){
					return false;
				}
			}else{
				ele = obj.find("#"+eleId);
				ele_nm = $("span[name='"+eleId+"']");
				if(eleId.indexOf("CLASS")==0 || eleId.indexOf("_INQ_DT")>-1){
					ele = $("."+eleId);
				}
				var val = avatar.common.null2void(data[key]);
			}
			
			if(eleId == "INOUT_DV"){
				if(val == "1"){
					ele.addClass("c_357EE7");
					ele.removeClass("c_CC0000");
					return false;
				} else if(val == "2"){
					ele.removeClass("c_357EE7");
					ele.addClass("c_CC0000");
					return false;
				}
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
				if(eleId == "QR_CD"){
					$("#QR_CD").attr("src", "https://chart.googleapis.com/chart?cht=qr&chs=350x350&chl="+val);
				} else {
					ele.html(val);
					ele_nm.html(val);
				}
				
			}catch(e){}
			if(eleId == "FST_INQ_DT"){
				if(data){
					$("#MID_DT").show();
					$(".FST_INQ_DT").show();
				}
			}
			if(eleId == "BANK_CD"){
				ele.removeClass();
				ele.addClass("ico"+(ele.text().substring(ele.text().length-3, ele.text().length) ));
			}
		},
		
}

/**
 * 엘리먼트 이벤트 바인딩처리
 * yj TODO: webAction처리 변경 필요
 */
function fn_elemEventBinding() {

	//질의 목록 선택 시 이동( TODO : 확인 후 삭제)
	$(document).on("click", "#QUES_LIST a", function(){
		_INTE_INFO = "{'recog_txt':'"+$(this).text()+"','recog_data' : {'Intent':'"+$(this).attr('intent')+"','appInfo' : {}} }" ;
		var url = "ques_comm_10.act?INTE_INFO="+_INTE_INFO;
		location.href = url;
		// iWebAction("openPopup",{"_url" : url});
	});
	
	//거래처,매출처,매입처 
	$(document).on('click', '.BZAQ_LIST', function(){
		var encComponent = encodeURIComponent("{'recog_txt':'"+$(this).find("#BZAQ_NM").text()+"','recog_data':{'Intent':'ASP001',appInfo:{'NE-COUNTERPARTNAME':'"+$(this).find("#BZAQ_NM").text()+"', 'BZAQ_KEY':'"+$(this).find("#BZAQ_KEY").text()+"', 'PREV_YN' : 'N'}}}");
		var url = "ques_comm_10.act?INTE_INFO="+encComponent+"&USER_CI="+encodeURIComponent(userCi);
		location.href = url;
		// iWebAction("openPopup",{"_url" : url});
	});
	
	//가맹점목록 
	$(document).on('click', '.FRCH_LIST', function(){
		console.log($(this).get(0));
		
		//PRE_INTENT = avatar.common.null2void(PRE_INTENT)===""?'ASP003':PRE_INTENT;		/* multiple cases : 결제가능상품권,QR코드 */
		var encComponent = encodeURIComponent("{'recog_txt':'"+$(this).find("#AFLT_NM").text()+"','recog_data':{'Intent':'ASP003',appInfo:{'NE-COUNTERPARTNAME':'"+$(this).find("#AFLT_NM").text()+"','AFLT_MANAGEMENT_NO':'"+$(this).find("#AFLT_MANAGEMENT_NO").text()+"','MEST_BIZ_NO':'"+$(this).find("#MEST_BIZ_NO").text()+"','SER_BIZ_NO':'"+$(this).find("#SER_BIZ_NO").text()+"', 'PREV_YN' : 'N'}}}");
		var url = "ques_comm_10.act?INTE_INFO="+encComponent+"&USER_CI="+encodeURIComponent(userCi);
		location.href = url;
		// iWebAction("openPopup",{"_url" : url});
	});
	
	// yj TODO: 데이터미연결 상태화면 언제 뜨는지? 이번에 필요한 화면인지??
	//데이터 미연결 상태 화면 (I-010-I-023)
	$(document).on("click", "a[name=a-data]", function(){
		var url = "basic_0014_01.act?DV=QUES";
		location.href = url;
		// iWebAction("openPopup",{_url:url});
	});
	
	// 제로페이결제내역, 제로페이결제취소내역 (ZNN002, ZNN005) click -> detail show/hide
	//console.log("_thisCont ::::: " + thisCont.INTE_INFO["recog_data"]["Intent"]);
	
	if(_thisCont.INTE_INFO["recog_data"]["Intent"] === 'ZNN002' || _thisCont.INTE_INFO["recog_data"]["Intent"] === 'ZNN005'){
//		recElemNm = "REC"
		$(document).on("click", "#" + [recElemNm] + " tr", function(){
			$("#detailModal #_TRAN_PROC_CD").text($(this).find("#TRAN_PROC_CD").text()); // STTS => TRAN_PROC_CD 상태 수정
			$("#detailModal #_DTM").text($(this).find("#SETL_DT").text()+" "+$(this).find("#OTRAN_TIME").text());
			$("#detailModal #_TRAN_ID").text($(this).find("#TRAN_ID").text());
			$("#detailModal #_TRAN_AMT").text($(this).find("#TRAN_AMT").text());// TRNS_AMT=>TRAN_AMT 결제금액 수정
			$("#detailModal #_ADD_TAX_AMT").text($(this).find("#ADD_TAX_AMT").text());
			//$("#detailModal #_FEE").text($(this).find("#FEE").text());
			$("#detailModal #_SVC_AMT").text($(this).find("#SVC_AMT").text());// SRV_FEE => SVC_AMT 봉사료 수정
			$("#detailModal #_BIZ_CD").text($(this).find("#BIZ_CD").text());
			$("#detailModal #_POINT_NM").text($(this).find("#POINT_NM").text());
			if($(this).find("#POINT_NM").text() === "") {
				if($("#pointNm").is(':visible') === true) {
					$("#pointNm").hide();
				}
			} else {
				if($("#pointNm").is(':visible') === false) {
					$("#pointNm").show();
				}
			}
			$("#detailModal").show();
		})
	}
	
	if(_thisCont.INTE_INFO["recog_data"]["Intent"] === 'ZNN008' || _thisCont.INTE_INFO["recog_data"]["Intent"] === 'ZNN009'){
		//recElemNm = "SQL2"
		$(document).on("click", "#" + [recElemNm] + " tr", function(){
			$("#detailModal #_STTS").text($(this).find("#STTS").text()); // STTS => TRAN_PROC_CD 상태 수정
			$("#detailModal #_DTM").text($(this).find("#SETL_DT").text());
			$("#detailModal #_TRAN_ID").text($(this).find("#TRAN_ID").text());
			$("#detailModal #_TRAN_AMT").text($(this).find("#POINT_AMT").text());// TRNS_AMT=>TRAN_AMT 결제금액 수정
			$("#detailModal #_ADD_TAX_AMT").text($(this).find("#ADD_TAX_AMT").text());
			$("#detailModal #_FEE").text($(this).find("#FEE").text());
			$("#detailModal #_SRV_FEE").text($(this).find("#SRV_FEE").text());// SRV_FEE => SVC_AMT 봉사료 수정
			$("#detailModal #_BIZ_CD").text($(this).find("#BIZ_CD").text());
			$("#detailModal #_POINT_NM").text($(this).find("#POINT_NM").text());
			$("#detailModal").show();
		})
	}
	$(document).on("click", "#detailModal .btn_recept_popX", function(){
		$("#detailModal").hide();
	});
    
	//스크롤 다운 - 더보기 
	$(window).scroll(function() {
		if(_thisCont.PAGE_NO == avatar.common.null2zero(_thisCont.PAGE_NO_RENDER) && isMore == true){
			_thisPage.searchData(true);
		}
	});
	
}

/**
 * CPN에 날짜가 들어간 경우 제외한다.
 * (예 : '웹케시 거래처 사분기' 발화 시 NE-CPN에 '웹케시^사분기'가 들어가게 됨 -> '웹케시'만 남도록 처리)   
 */
function removeDatefromCPN(){
	let ne_counterpartname = avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"]);
	if(avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-B-Year"])!=""){
		if(avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"])!=""){
			ne_counterpartname = ne_counterpartname.replace(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-B-Year"], '').replace(/\^/, '').trim()
		}
	}
	if(avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-B-Month"])!=""){
		if(avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"])!=""){
			ne_counterpartname = ne_counterpartname.replace(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-B-Month"], '').replace(/\^/, '').trim()
		}
	}
	if(avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-B-date"])!=""){
		if(avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"])!=""){
			ne_counterpartname = ne_counterpartname.replace(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-B-date"], '').replace(/\^/, '').trim()
		}
	}
	if(avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-YEAR1"])!=""){
		if(avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"])!=""){
			ne_counterpartname = ne_counterpartname.replace(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-YEAR1"], '').replace(/\^/, '').trim()
		}
	}
	
	let exceptionDate = ",1분기,일분기,분기,일사분기,2분기,이분기,이사분기,3분기,삼분기,삼사분기,4분기,사분기,사사분기,그저께,전전날,엊그제,금월,이번달,이달,그뭘,월간,금주,이번주,이주,내일,다음날,뒷날,명일,다음달,내달,내월,다음분기,다음주,내주,당일,오늘,금일,현재,그밀,지금,일간,모레,내일모레,상반기,올해,금년,당년,이번해,이번년,이번년도,금년도,년도,연간,이듬해,다음해,내년,명년,익년,다음년도,이번분기,작년,전년,지난해,거년,전년도,작년도,전해,전월,지난달,저번달,전달,전일,어저께,전날,작일,자길,어제,전주,지난주,저번주,주간,지난분기,저번분기,직전분기,하반기,주,달,일일,이일,삼일,사일,오일,육일,칠일,팔일,구일,십일,십일일,십이일,십삼일,십사일,십오일,십육일,십칠일,십팔일,십구일,이십일,이십일일,이십이일,이십삼일,이십사일,이십오일,이십육일,이십칠일,이십팔일,이십구일,삼십일,삼십일일,일월,이월,삼월,사월,오월,유월,육월,칠월,팔월,구월,시월,십월,십일월,십이월,이천년,이천일년,이천이년,이천삼년,이천사년,이천오년,이천육년,이천칠년,이천팔년,이천구년,이천십년,이천십일년,이천십이년,이천십삼년,이천십사년,이천십오년,이천십육년,이천십칠년,이천십팔년,이천십구년,이천이십년,이천이십일년,이천이십이년,이천이십삼년,이천이십사년,이천이십오년,이천이십육년,이천이십칠년,이천이십팔년,이천이십구년,이천삼십년,공공년,공일년,일년,이년,삼년,사년,오년,육년,칠년,팔년,구년,십년,십일년,십이년,십삼년,십사년,십오년,십육년,십칠년,십팔년,십구년,이십년,이십일년,이십이년,이십삼년,";
	ne_counterpartname = ne_counterpartname.split('^').filter(x=>!exceptionDate.split(',').includes(x)).join(' ');
	
	_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"] = ne_counterpartname;
}

function fn_getWebResultTTS(data){
	// yj TODO: TTS 설정 YN값을 알 길이 없으니..? ZNN010인텐트 어찌 처리할지? 확인 필요
	avatar.common.null2void(data)==""?data="Y":data=data;
	if(_thisCont.INTE_INFO["recog_data"]["Intent"] === 'ZNN010'){
		if(data == "Y"){
			//cb_getWebResultTTS();
			iWebAction("webResultTTS",{"_data" : avatar.common.null2void($("#RESULT_TTS").text()), "_call_back" : "cb_getWebResultTTS"});
		} else {
			setTimeout(function() {
				cb_getWebResultTTS();
			}, 3000)
		}
	}else {
		$.each($("#RESULT_TTS").children(), function(i, v){
			if(avatar.common.null2void($(v).attr("data-type"))!="" && $(v).attr("data-type").indexOf("dateday")>-1){
				$(v).text(formatter.datekr($(v).text().replace(/\./g, '').replace(/ /g, '').replace(/\([ㄱ-힣]\)/, '')));
			}
		});
		iWebAction("webResultTTS",{"_data" : avatar.common.null2void($("#RESULT_TTS").text())});
	}
	
}

function cb_getWebResultTTS(){
	iWebAction("phoneCall",{"_type" : "0", "_phone_num" : $("#ZP_TEL_NO").text()});
	fn_back();
}

/**
 * 인텐트 코드별 html 커스텀
 * @param OTXT_HTML
 */
function fn_customHtmlByInteCd(OTXT_HTML) {
	var customHtml = "";
	
	switch(_intent) {
		case "ASP004":
			customHtml = OTXT_HTML.replace("MEST_NM", "AFLT_NM");
			break;
		default :
			customHtml = OTXT_HTML;
	}
	
	return customHtml;
	
}

