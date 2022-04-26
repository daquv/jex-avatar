/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_0001_11.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 하준태 (  )
 * @Description    : IBKCRM앱 발화 응답화면(공통)
 * @History        : 20220401105034, 하준태
 * </pre>
 **/


var result;
var isSerpModalOn = true;
var testUser =  ",01028602673,01099994486,01038698349,01041212036,01031687616,01053013762,01073677899,01025999667,01045541465,01025396636,01012341234,01072349760";
var certModalDate = "";
var limite2 = 3;

$(function(){
	_thisPage.onload();
	$(document).on("click", "[name=quesList]  ul li", function(){
		var nativeIntent = ",NNN014," 
		if(nativeIntent.indexOf($(this).attr('intent'))>-1){
			var url = "basic_0009_02.act";
			iWebAction("openPopup",{"_url" : url});
		} else if("NNN014".indexOf($(this).attr('intent')) >-1){
			// 전화해줘 Native화면으로 이동
			iWebAction("openPhoneCall");
		} else {
			//학습완료된 질의만 이동 .replace(/\'/g, '\"')
			var appInfo = $(this).attr('data-appInfo')?$(this).attr('data-appInfo'):"{}";
			var INTE_INFO ="{'recog_txt':'\""+$(this).find("a").text().split("\"")[1]+"\"','recog_data' : {'Intent':'"+$(this).attr('intent')+"','appInfo' : "+appInfo+"} }" ;
			var _appInfo = $(this).attr('data-appInfo')?$(this).attr('data-appInfo').replace(/\'/g, '\"'):"{}";
			var INTE_INFO_create = '{"recog_txt":\"'+$(this).find("a").text().split("\"")[1]+'\","recog_data" : {"Intent":"'+$(this).attr('intent')+'","appInfo" : '+_appInfo+'} }';
			//encodeURIComponent(INTE_INFO);
			if(_appInfo.indexOf("NE-COUNTERPARTNAME")>0){
				INTE_INFO = encodeURIComponent(INTE_INFO);
			}
			console.log('질의 리스트(ex. 매출액) 클릭된 인텐트 값: ' + INTE_INFO);
			_thisPage.fn_create(INTE_INFO_create);
			
			var url = "ques_comm_11.act?INTE_INFO="+INTE_INFO;
			iWebAction("openPopup",{"_url" : url});
		}
	});
	
	//전화걸기 이동
	$(document).on("click", "#call_move", function(){
		// 전화해줘 Native화면으로 이동
		iWebAction("openPhoneCall");
	});
	
	//문자보내줘 이동 
	$(document).on("click", "#sms_move", function(){
		// 문자보내줘 Native화면으로 이동
		iWebAction("openTextMessage");
	});
	
	//경리나라-아바타 경리나라 배너
	$(document).on("click", ".banner_kyungrinara", function(){
		let url = "ques_0001_03.act";
		iWebAction("openPopup",{"_url" : url});
	});
	//아바타 잘 쓰는 법 배너
	$(document).on("click", "#AVATAR_banner1_1", function(){
		//let url = "ques_0001_04.act";
		let url = "ques_0001_07.act";
		iWebAction("openPopup",{"_url" : url});
	});
	//내 배달앱 매출 한 눈에 보기 배너
	$(document).on("click", "#AVATAR_banner1_3", function(){
		let url = "ques_0001_06.act";
		iWebAction("openPopup",{"_url" : url});
	});
	//경리나라 배너
	$(document).on("click", "#AVATAR_banner2_1", function(){
		let url = "ques_0001_03.act";
		iWebAction("openPopup",{"_url" : url});
	});
	//제로페이 배너
	$(document).on("click", "#AVATAR_banner2_2", function(){
		let url = "ques_0001_08.act";
		iWebAction("openPopup",{"_url" : url});
	});
	$(document).on("click", "#AVATAR_banner1_2", function(){
		let url = "ques_0001_08.act";
		iWebAction("openPopup",{"_url" : url});
	});
	//매출 브리핑 설정 화면으로 이동
	$(document).on("click", "#AVATAR_bref", function(){
		let url = "basic_0011_02.act";
		iWebAction("openPopup",{"_url" : url});
	});
	
	$(document).on("click", "#SERP li", function(){
		//if(_APP_ID != "SERP"){
		if(_APP_ID == "AVATAR"){
			let url = "basic_0009_01.act?PAGE_DV=SERP";
			iWebAction("openPopup",{"_url" : url});
		} else {
			var INTE_INFO ="{'recog_txt':'\""+$(this).find("a").text().split("\"")[1]+"\"','recog_data' : {'Intent':'"+$(this).attr('intent')+"','appInfo' : {}} }" ;
			var INTE_INFO_create = '{"recog_txt":\"'+$(this).find("a").text().split("\"")[1]+'\","recog_data" : {"Intent":"'+$(this).attr('intent')+'","appInfo" : { }} }';
			//encodeURIComponent(INTE_INFO);
			_thisPage.fn_create(INTE_INFO_create);
			var url = "ques_comm_11.act?INTE_INFO="+INTE_INFO;
			iWebAction("openPopup",{"_url" : url});
			
			/*var INTE_INFO ="{'recog_txt':'"+$(this).text()+"','recog_data' : {'Intent':'"+$(this).attr('intent')+"','appInfo' : {}} }" ;
			var INTE_INFO_create = '{"recog_txt":'+$(this).find("a").text()+',"recog_data" : {"Intent":"'+$(this).attr('intent')+'","appInfo" : { }} }';
			_thisPage.fn_create(INTE_INFO_create);
			var url = "ques_comm_01.act?INTE_INFO="+INTE_INFO;
			iWebAction("openPopup",{"_url" : url});*/
		}
	});
	
	var limite = 5;
	$('.askAvatar_sub2 ul li').each(function(i){
		if(i > limite-1){
			$('.askAvatar_sub2 ul li').eq(i).hide();
		}
	})
	$(".askAvatar_sub2 .bt_more").click(function(){
		$(".askAvatar_sub2 .bt_more span").toggleClass("fold");
		$('.askAvatar_sub2 ul li').each(function(i){
			if(i > limite-1){
				$('.askAvatar_sub2 ul li').eq(i).toggle();
			}
		});
	});
	$('.js_limite').each(function(a){
		$('.js_limite').eq(a).find("li").each(function(i){
			if(i > limite2-1){
				$('.js_limite').eq(a).find("li").eq(i).hide();
			}
		});
	});

	$(document).on("click", ".allQues .bt_more", function(){
		var thisPrev = $(this).prev();
		$(this).toggleClass("close");
		$(this).prev().find("li").each(function(i){
			if(i > limite2-1){
				thisPrev.find("li").eq(i).toggle();
			}
		});
	});

})

var _thisPage = {
	onload : function(){
		if(LGIN_APP.indexOf("SERP") > -1){
			iWebAction("changeTitle",{"_title" : "질의","_type" : "106"});
		} else if(LGIN_APP === "ZEROPAY"){
			iWebAction("changeTitle",{"_title" : "질의","_type" : "106"});
		} else {
			iWebAction("changeTitle",{"_title" : "질의","_type" : "105"});
		}
		if(LGIN_APP.indexOf("SERP") > -1){
			$(".content").addClass("pdb0");
		} else if(LGIN_APP==="AVATAR"){
			//$(".ai_list_v[name=SERP]").addClass("mgt6");
			//_thisPage.loadMyQ(); //상단 탭 3개 사용 안함 (호출x)
		}
		_thisPage.loadAllQ();
		_thisPage.searchData();
	},
	//데이터 유무 조회 및 팝업 창 확인 
	searchData : function(){
		//avatar.common.callJexAjax("ques_0001_01_r001", "", _thisPage.fn_callback, "true", "");
		console.log('02 : 질의 클릭시 ques_0001_01_r002 호춯');
		avatar.common.callJexAjax("ques_0001_01_r002", "", _thisPage.fn_setData, "true", "");
		if(LGIN_APP === "AVATAR"){
			console.log("LGIN_APP값: " + LGIN_APP );
			iWebAction("getStorage",{"_key" :"voicSettModal", "_call_back" : "fn_getVoicSettModal"});
		}
	},
	//전체 질의 
	loadAllQ : function(){
		console.log('01 : 질의 클릭시 ques_0001_01_r001 호춯');
		avatar.common.callJexAjax("ques_0001_01_r001", "", _thisPage.fn_callbackAllQ, "true", "");
	}, 
	//개인 맞춤 질의(상단 탭3개)
	loadMyQ: function(){
		avatar.common.callJexAjax("ques_0001_01_r003", "", _thisPage.fn_callbackMyQ, "true", "");
	},
	fn_setData : function(data){
		if(data.DATA_YN==="N"){
			$("[data-app_id=AVATAR].banner_slideMN").hide();
			$(".banner_aAWrap").show();
		} else $(".banner_aAWrap").hide();
		
		if(LGIN_APP == "AVATAR"){
			if(avatar.common.null2void(data.LEFT_DT) != ""){
				if(data.LEFT_DT > 0){
					$("#cert_dt").text(data.LEFT_DT);
					iWebAction("getStorage",{"_key" : "dateDayModal1", "_call_back" : "fn_getdateDayModal1"});
				} else {
					iWebAction("getStorage",{"_key" : "dateDayModal2", "_call_back" : "fn_getdateDayModal2"});
				}
			} else{
				$("#cert_modal").hide();
				$("#cert_modal2").hide();
			}
		}
		/*
		if(avatar.common.null2void(data.POPUP_CNFM_YN) != "Y"){
			$("#info_modal").show();
		} else{
			$("#info_modal").hide();
		}
		*/	
		if(avatar.common.null2void(data.AUTH_RSLT) != "0000"){
			$("#auth_modal").show();
			isSerpModalOn = off;
		} else{
			$("#auth_modal").hide();
		}
	},
	fn_callbackAllQ : function(data){
		console.log("03 : 질의 클릭시 ques_0001_01_r001 호춯 후 받아 온 데이터 확인(인텐트값)");
		console.log(data);
		if(LGIN_APP === "AVATAR"){
			//자주하는 질의_전체(이렇게 물어보세요)
//			$("#freqQues ul").empty();
//			var topTotHtml = '';
//			$.each(data.REC_TOT_TOP, function(idx, rec){
//				topTotHtml+= '<li intent="'+rec.INTE_CD+'" ><a>'+"\""+rec.QUES_CTT+"\""+'</a></li>'
//			});
//			$("#freqQues ul").append(topTotHtml);
			
			//전체 질의
			$(".allQues ul").empty();
			$(".allQues .bt_more").remove();
			//$("#zpQues ul").empty();
			$.each(data.REC_TOTAL, function(idx, rec){
				if(avatar.common.null2void(rec.CTGR_CD) != ''){
//					if(rec.CTGR_CD === "9997"){
//						let totalHtml = '';
//						totalHtml += '<li intent = "'+rec.INTE_CD+'"><a>\"'+rec.QUES_CTT+'\"';
//						$("#zpQues ul").append(totalHtml);
//					}else {
						var totalHtml= '';
						if(rec.CTGR_RANK>3){
							totalHtml += '<li intent = "'+rec.INTE_CD+'" style="display:none;"><a>\"'+rec.QUES_CTT+'\"';
						} else {
							totalHtml += '<li intent = "'+rec.INTE_CD+'"><a>\"'+rec.QUES_CTT+'\"';
						}
						if(rec.NEW_DV == 'Y'){
							totalHtml += '<em class="ic_new">New</em>';
						}
						totalHtml += 	'</a></li>';
						$(".allQues[data-ctgr_cd="+avatar.common.null2void(rec.CTGR_CD)+"] ul").append(totalHtml);
//					}
				}
			});
			$.each($(".allQues ul"), function(i, v){
				if($(v).find("li").length > 3){
					$(v).after(`<a href="#none" class="bt_more open"><span class="blind">더보기</span></a>`);
				}
				$(v).addClass("js_limite");
			});
			//맞춤질의 카테고리
			if (testUser.indexOf(CLPH_NO) > -1) { $("[data-ctgr_cd=9998]").show(); }
			if ("01028602673".indexOf(CLPH_NO) > -1) { $("#memo_cont").show(); }
			
//			//경리나라 질의
//			$("#serpQues ul").empty();
//			$.each(data.REC_SERP_TOT, function(idx, rec){
//				if(avatar.common.null2void(rec.CTGR_CD) != ''){
//					if(avatar.common.null2void(rec.APP_ID) == 'SERP' || avatar.common.null2void(rec.INTE_CD) == "BNN001"){
//						var SERPHtml= '';
//						SERPHtml += '<li intent = "'+rec.INTE_CD+'"><a>\"'+rec.QUES_CTT+'\"';
//						if(rec.NEW_DV_SERP == 'Y'){
//							SERPHtml += '<em class="ic_new">New</em>';
//						}
//						SERPHtml += 	'</a></li>';
//						$("#serpQues ul").append(SERPHtml);
//					}
//				}
//			});
		} else if(LGIN_APP.indexOf("SERP") > -1){  //SERP, KTSERP
			$("#SERP li").empty();
			$.each(data.REC_SERP_TOT, function(idx, rec){
				if(avatar.common.null2void(rec.CTGR_CD) != ''){
					if(avatar.common.null2void(rec.APP_ID) == LGIN_APP || avatar.common.null2void(rec.INTE_CD) == "BNN001"){
						var SERPHtml= '';
						SERPHtml += '<li intent = "'+rec.INTE_CD+'"><a>\"'+rec.QUES_CTT+'\"';
						if(rec.NEW_DV_SERP == 'Y'){
							SERPHtml += '<em class="ic_new">New</em>';
						}
						SERPHtml += 	'</a></li>';
						$(".ai_list_v[data-app_id=SERP] #SERP").append(SERPHtml);
					}
				}
			});
		}
		else if(LGIN_APP==="ZEROPAY") {
			$("#zpQues li").empty();
			$.each(data.REC_TOTAL, function(idx, rec){
				if(avatar.common.null2void(rec.CTGR_CD) != ''){
					let totalHtml = '';
					totalHtml += '<li intent = "'+rec.INTE_CD+'"><a>\"'+rec.QUES_CTT+'\"';
					$("#zpQues ul").append(totalHtml);
				}
			});
				
		}
		if(LGIN_APP === "KTSERP") {
			$("[data-app_id=SERP]").show();
		} else {
			$("[data-app_id="+LGIN_APP+"]").show();			
		}
		
//		if(LGIN_APP === "AVATAR"){
//			// 아바타로 로그인 시
//			$("#ques_dv2").hide();
//		}else if(LGIN_APP === "ZEROPAY"){
//			// 제로페이로 로그인 시
//			$("#banner_1").hide();
//			$("#ques_dv1").hide();
//			$("#freqQues").hide();
//			$("#serpQues").hide();
//			$("#ques_dv4").hide();
//			$("#memo_cont").hide();
//			$("#call_cont").hide();
//			$(".content").removeClass("m_cont_pd25");
//		}
		setTimeout(function(){
			_thisPage.bannerPaging();
		},100);
	}, 
	fn_callbackMyQ : function(data) {
		if(data.DATA_YN === "N"){
			$(".banner_aAWrap").remove();
			let noDataHtml = '';
			noDataHtml += '<div class="banner_aAWrap" name="AVATAR">';
			noDataHtml += '	<div class="banner_aAinner">';
			noDataHtml += '		<h2><span id="">'+CUST_NM+'</span>님의<br>어제 매출은 얼마일까요?</h2>';
			noDataHtml += '		<a href="#none" id="dataConnect">데이터 연결하기</a>';
			noDataHtml += '	</div>';
			noDataHtml += '</div>';
			$(".m_cont").prepend(noDataHtml);
			$(".banner_slide_freQues").hide();
		} else {
			//내가 자주하는 질의 (myFreqQues)
			$("#myFreqQues ul").empty();
			let topFreqHtml = '';
			if(data.REC_INDI_TOP.length == 0){
				$(".sect_freQues1 .cont_pd .inter_area").remove();
				topFreqHtml+='<div class="inter_area type3 noLst ic_fQ1">';
				topFreqHtml+='	<strong class="type1">내가 자주하는 질문이에요!</strong>';
				topFreqHtml+='	<p>아바타가 <span id="">'+CUST_NM+'</span>님이 자주하는<br>	질문을 알려드릴게요!</p>';
				topFreqHtml+='</div>';
				$(".sect_freQues1 .cont_pd").append(topFreqHtml);
			} else {
				$.each(data.REC_INDI_TOP, function(idx, rec){
					var appInfo = '';
					/*if(rec.VOIC_DATA){
						appInfo=JSON.stringify(JSON.parse(rec.VOIC_DATA).recog_data.appInfo);
						if(appInfo)
							appInfo=appInfo.replace(/\"/g, '\'');
					}
					topHtml+= `<li intent="${rec.INTE_CD}" data-appInfo="${appInfo}" ><a>"${rec.QUES_CTT}"</a></li>`;*/
					topFreqHtml+= `<li intent="${rec.INTE_CD}" ><a>"${rec.QUES_CTT}"</a></li>`;
				});
				$("#myFreqQues ul").append(topFreqHtml);
			}
			//질문모아보기 (myRecentQues)
			$("#myRecentQues ul").empty(); 
			var topRecentHtml = '';
			if(data.REC_INDI_RCNT.length == 0){
				$(".sect_freQues2 .cont_pd .inter_area").remove();
				topRecentHtml+='<div class="inter_area type3 noLst ic_fQ2" id="myRecentQues" >';
				topRecentHtml+='	<strong class="type2">질문 모아보기</strong>';
				topRecentHtml+='	<p>아바타에게 질문한 리스트를<br>확인하실 수 있어요!</p>';
				topRecentHtml+='	<div class="right"><a href="#none" class="bt_more">더보기</a></div>';
				topRecentHtml+='</div>';
				$(".sect_freQues2 .cont_pd").append(topRecentHtml);
			} else {
				$.each(data.REC_INDI_RCNT, function(idx, rec){
					var appInfo = '';
					/*if(rec.VOIC_DATA){
						appInfo = JSON.stringify(JSON.parse(rec.VOIC_DATA).recog_data.appInfo);
						if(appInfo)
							appInfo=appInfo.replace(/\"/g, '\'');
					}
					topHtml+= `<li intent="${rec.INTE_CD}" data-appInfo="${appInfo}" ><a>"${rec.QUES_CTT}"</a></li>`;*/
					topRecentHtml+= `<li intent="${rec.INTE_CD}" ><a>"${rec.QUES_CTT}"</a></li>`;
				});
				$("#myRecentQues ul").append(topRecentHtml);
			}
			
			//답변받지 못한 질문 (myUnansweredQues)
			$("#myUnansweredQues ul").empty(); 
			var topUnansweredHtml = '';
			if(data.REC_INDI_UNAN.length == 0){
				$(".sect_freQues3 .cont_pd .inter_area").remove();
				topUnansweredHtml+='<div class="inter_area type3 noLst ic_fQ3" id="myUnansweredQues" >';
				topUnansweredHtml+='	<strong class="type3">답변받지 못한 질문</strong>';
				topUnansweredHtml+='	<p>답변을 받지 못하였다구요?<br>아바타가 학습 후 알려드릴게요!</p>';
				topUnansweredHtml+='	<div class="right"><a href="#none" class="bt_more">더보기</a></div>';
				topUnansweredHtml+='</div>';
				$(".sect_freQues3 .cont_pd").append(topUnansweredHtml);
			} else {
				$.each(data.REC_INDI_UNAN, function(idx, rec){
					var appInfo = '';
					if(rec.LRN_STTS === "1"){
						topUnansweredHtml+= `<li intent="${rec.INTE_CD}" data-appInfo="${appInfo}" ><a class="badge">"${rec.QUES_CTT}"</a><span>학습완료</span></li>`;
					} else {
						topUnansweredHtml+= `<li intent="${rec.INTE_CD}" data-appInfo="${appInfo}" ><a>"${rec.QUES_CTT}"</a></li>`;
					}
				});
				$("#myUnansweredQues ul").append(topUnansweredHtml);
			}
			$(".banner_slide_freQues").show();
		}
	}, 
	bannerPaging : function(){
		$(".js_controll ul").css({"max-height":"164px","overflow":"hidden"});
		$(".btn_drop.open").click(function(){
			if($(this).hasClass("open")){
				$(this).addClass("close");
				$(this).removeClass("open");
				$(".js_controll ul").css("max-height","100%");
			}else{
				$(this).addClass("open");
				$(this).removeClass("close");
				$(".js_controll ul").css("max-height","164px");
			}
		});
		
/*		var swiper1 = new Swiper('.banner_slide_freQues', {
			pagination:{
				el: '.swiper-pagination',
				clickable: true,
			},
			on:{
				init: function () {
				const numberOfSlides = this.slides.length;
					if(numberOfSlides == 1){
						$(this).find(".swiper-pagination").hidden();
					}
				}
			},
			autoplay : {},
		});*/
		
		var swiper = new Swiper('.banner_slideMN', {
			pagination:{
				el: '.swiper-pagination',
				clickable: true,
			},
			on:{
				init: function () {
				const numberOfSlides = this.slides.length;
					if(numberOfSlides == 1 && $(this).find(".swiper-pagination").length){
						$(this).find(".swiper-pagination").hidden();
					}
				}
			},
			autoplay:{
				delay:2500,
			},
		});
	},
	fn_create : function(INTE_INFO){
		var jexAjax = jex.createAjaxUtil("ques_comm_01_u001"); // PT_ACTION
		jexAjax.set("VOIC_DATA", INTE_INFO);
		jexAjax.execute(function(data) {
		});
	},
	fn_reCert : function(){
		iWebAction("setStorage",{"_key" : "dateDayModal2", "_value" : avatar.common.getDate("yyyymmdd", "D", 1)});
		var url = "basic_0002_01.act?MENU_DV='cert'";
		iWebAction("openPopup",{"_url" : url});
	},
	fn_reSerp : function(){
		setCookie( "ncookie2", "done" , 1 );
		var url = "basic_0005_01.act";
		iWebAction("openPopup",{"_url" : url});
	},
	fn_voicSett : function(){
		iWebAction("setStorage",{"_key" : "voicSettModal", "_value" : "limit"});
		$("#info_voic").hide();
		var url = "basic_0011_01.act";
		iWebAction("openPopup",{"_url" : url});
	},

}

function fn_getdateDayModal1(data){
	if(avatar.common.null2void(data)!= '' && avatar.common.null2void(data) != 'Y' && avatar.common.getDate("yyyymmdd")<data){
		//오늘날짜<data(내일날짜) : 닫음
		certClose1();
	}  else {
		//노출
		$("#cert_modal").show();
	} 
}
function fn_getdateWeekModal1(data){
	if(avatar.common.null2void(data)!= '' && avatar.common.null2void(data) != 'Y' && avatar.common.getDate("yyyymmdd")<data){
		//오늘날짜<data(일주일 후 날짜) : 닫음
		certClose1();
	}  else {
		//노출
		$("#cert_modal").show();
	}
}
function fn_getdateDayModal2(data){
	if(avatar.common.null2void(data)!= '' && avatar.common.null2void(data) != 'Y' && avatar.common.getDate("yyyymmdd")<data){
		//오늘날짜<data(내일날짜) : 닫음
		certClose2();
	}  else {
		//노출, dateDayModal2 key에 내일날짜 넣음
		$("#cert_modal2").show();
	}
}


function fn_getVoicSettModal(data){
	if(avatar.common.null2void(data) != "limit"){
		$("#info_voic").show();
	}else{
		$("#info_voic").hide();
	}
}

function certClose1() {
	iWebAction("setStorage",{"_key" : "dateDayModal1", "_value" : avatar.common.getDate("yyyymmdd", "D", 1)});
	$("#cert_modal").hide();
}
function certWeekClose1() {
	iWebAction("setStorage",{"_key" : "dateWeekModal1", "_value" : avatar.common.getDate("yyyymmdd", "W", 1)});
	$("#cert_modal").hide();
}
function certClose2(){
	iWebAction("setStorage",{"_key" : "dateDayModal2", "_value" : avatar.common.getDate("yyyymmdd", "D", 1)});
	$("#cert_modal2").hide();	
}
function voicClose(){
	iWebAction("setStorage",{"_key" : "voicSettModal", "_value" : "limit"});
	$("#info_voic").hide();	
}
function voicSelClose(){
	iWebAction("setStorage",{"_key" : "voicSelSettModal", "_value" : "limit"});
	$("#selInfo_voic").hide();
}
function infoCloseWin() { 
	var jexAjax = jex.createAjaxUtil("ques_comm_01_u002");
	jexAjax.execute(function(data) {
		$("#info_modal").hide();
	});
}

function serpClose() {
	setCookie( "ncookie2", "done" , 1 );
	$("#serp_modal").hide();
}

function fn_popCallback2(){
	_thisPage.onload();
}
function fn_back(){
	iWebAction("fn_app_finish");
}