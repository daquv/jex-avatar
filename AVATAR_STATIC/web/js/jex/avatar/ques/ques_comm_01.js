/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_comm_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 신승환 (  )
 * @Description    : 
 * @History        : 20200309143043, 신승환
 * </pre>
 **/ 
var sum = 0;
var isMore;				//스크롤 다운 후 데이터 유무 확인 
var trnsDt = "";		//날짜 별로 내역 표시 
var dataYn = "";		//데이터 연결 여부
var apiYn = "";			//API 연결 여부 
var isQuesDv ="";		//질의 출처 여부 및 조회 
var inteNm = "";		//인텐트명
var testUser =  ",01028602673,01099994486,01038698349,01041212036,01031687616,01053013762,01073677899,01045541465,01025396636,01012341234,01025999667,01072349760";		//맞춤질의사용자 
var _intent = _thisCont.INTE_INFO.recog_data.Intent;
var jArr_txofInfm = [];	//제외된세무사목록
let totCnt = 0;

$(function(){
	_thisPage.onload();
    
    //질의 목록 선택 시 이동( TODO : 확인 후 삭제)
	$(document).on("click", "#QUES_LIST a", function(){
		_INTE_INFO = "{'recog_txt':'"+$(this).text()+"','recog_data' : {'Intent':'"+$(this).attr('intent')+"','appInfo' : {}} }" ;
		var url = "ques_comm_01.act?INTE_INFO="+_INTE_INFO;
		iWebAction("openPopup",{"_url" : url});
	});
	
    //예적금, 대출금 popup
	$(document).on('click', '#noti_pop', function(){
		alert("데이터 정보가 일치하지 않는 경우\n공인인증서 또는 계좌를 등록해주세요.");
	});
	
	// 배달앱 정산내역 요기요 !아이콘 클릭
	$(document).on('click', '.ic_i', function(){
		$("#snss_modal").show();
	});
	
    //거래처,매출처,매입처 
	$(document).on('click', '.BZAQ_LIST', function(){
		var encComponent = encodeURIComponent("{'recog_txt':'"+$(this).find("#BZAQ_NM").text()+"','recog_data':{'Intent':'ASP001',appInfo:{'NE-COUNTERPARTNAME':'"+$(this).find("#BZAQ_NM").text()+"', 'BZAQ_KEY':'"+$(this).find("#BZAQ_KEY").text()+"', 'PREV_YN' : 'N'}}}");
		var url = "ques_comm_01.act?INTE_INFO="+encComponent;
		iWebAction("openPopup",{"_url" : url});
	});
	
    //가맹점목록 
	$(document).on('click', '.FRCH_LIST', function(){
		//PRE_INTENT = avatar.common.null2void(PRE_INTENT)===""?'ASP003':PRE_INTENT;		/* multiple cases : 결제가능상품권,QR코드 */
		var encComponent = encodeURIComponent("{'recog_txt':'"+$(this).find("#MEST_NM").text()+"','recog_data':{'Intent':'ASP003',appInfo:{'NE-COUNTERPARTNAME':'"+$(this).find("#MEST_NM").text()+"','AFLT_MANAGEMENT_NO':'"+$(this).find("#AFLT_MANAGEMENT_NO").text()+"','MEST_BIZ_NO':'"+$(this).find("#MEST_BIZ_NO").text()+"','SER_BIZ_NO':'"+$(this).find("#SER_BIZ_NO").text()+"', 'PREV_YN' : 'N'}}}");
		var url = "ques_comm_01.act?INTE_INFO="+encComponent;
		iWebAction("openPopup",{"_url" : url});
	});
	
    //세무사 목록 
	$(document).on('click', '.taxerList', function(){
		if(_intent == "NNN019"){
			var pageUrl = "ques_0013_01.act?";
			var pageParam = "BIZ_NO="+encodeURIComponent($(this).find("#BIZ_NO").text())+"&SEQ_NO="+encodeURIComponent($(this).find("#SEQ_NO").text())+"&PREV_YN="+encodeURIComponent('N');
			iWebAction("openPopup",{"_url":pageUrl, "_param" : pageParam});
			return false;
		} else if(_intent == "NNN020"){
			var pageUrl = "ques_0013_02.act?";
			var pageParam = "NE-PERSON="+$(this).find("#CHRG_NM").text()+"&CHRG_TEL_NO="+$(this).find("#CHRG_TEL_NO").text()+"&BIZ_NO="+$(this).find("#BIZ_NO").text()+"&SEQ_NO="+$(this).find("#SEQ_NO").text();
			iWebAction("openPopup",{"_url":pageUrl, "_param" : pageParam});
			return false;
		}
	});

	//데이터 미연결 상태 화면 (I-010-I-023)
	$(document).on("click", "a[name=a-data]", function(){
		var ctgr = $(this).attr("ctgr");
		if(ctgr=="acct"){
			iWebAction("fn_cert_list",{_menu_id : "1",_title:"은행데이터 가져오기",_callback : "fn_popCallback"});
		} else if(ctgr=="tax2"){
			fn_moveTax(this, 'paytax');
		} else if(ctgr=="tax"){
			fn_moveTax(this, 'etaxcash');
		} else if(ctgr=="sale"){
			var url = "card_0003_01.act";
			iWebAction("openPopup",{_url:url});
		} else if(ctgr=="card"){
			var url = "card_0005_01.act";
			iWebAction("openPopup",{_url:url});
		} else if(ctgr=="snss"){
			var url = "snss_0001_01.act";
			iWebAction("openPopup",{_url:url});
		} else if(ctgr=="zero"){
			var url = "basic_0014_01.act?DV=QUES";
			iWebAction("openPopup",{_url:url});
		} 
	});
	
    //제로페이결제내역, 제로페이결제취소내역 (ZNN002, ZNN005) click -> detail show/hide
	if(_thisCont.INTE_INFO["recog_data"]["Intent"] === 'ZNN002' || _thisCont.INTE_INFO["recog_data"]["Intent"] === 'ZNN005'){
		$(document).on("click", "#SQL2 tr", function(){
			$("#detailModal #_STTS").text($(this).find("#STTS").text());
			$("#detailModal #_DTM").text($(this).find("#SETL_DT").text()+" "+$(this).find("#OTRAN_TIME").text());
			$("#detailModal #_TRAN_ID").text($(this).find("#TRAN_ID").text());
			$("#detailModal #_TRNS_AMT").text($(this).find("#TRNS_AMT").text());
			$("#detailModal #_ADD_TAX_AMT").text($(this).find("#ADD_TAX_AMT").text());
			$("#detailModal #_FEE").text($(this).find("#FEE").text());
			$("#detailModal #_SRV_FEE").text($(this).find("#SRV_FEE").text());
			$("#detailModal #_BIZ_CD").text($(this).find("#BIZ_CD").text());
			$("#detailModal").show();
		})
	}
	$(document).on("click", "#detailModal .btn_recept_popX", function(){
		$("#detailModal").hide();
	});
    
	//스크롤 다운 - 더보기 
	$(window).scroll(function() {
//		if (Math.floor($(window).scrollTop()) >= Math.floor($(document).height() - $(window).height())) {
			if(_thisCont.PAGE_NO == avatar.common.null2zero(_thisCont.PAGE_NO_RENDER) && isMore == true){
				_thisPage.searchData(true);
			}
//		}
	});
	
})

var _thisPage = {
	onload : function(){
		if(_thisCont.INTE_INFO["recog_data"]["Intent"] !== "ASP005"){
			// && _thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("SAMPLE") == -1 && _thisCont.INTE_INFO["recog_data"]["Intent"] !== "SAMPLE2"
			if(_thisPage.checkQuesDv()!=='true'){
				return false;
			}
		}
		if(_thisCont.INTE_INFO["recog_data"] && _thisCont.INTE_INFO["recog_data"]["Intent"]){
			if(_thisCont.INTE_INFO["recog_data"]["Intent"] == 'NNN001'){
				_thisPage.getAppInfo();
			}
			else{
				if(LGIN_APP.indexOf("SERP") === -1){
					// API 연결 여부 CHK (apiYn)
					_thisPage.checkAPIConnection();
				}
				//가맹점인지 거래처인지 chk 후 intent 분리
				if(_thisCont.INTE_INFO["recog_data"]["Intent"] === 'ASP005'){
					_thisPage.checkCounterpartName(_thisCont.INTE_INFO.recog_data.appInfo["NE-COUNTERPARTNAME"]);
				}
				
				if(_thisCont.INTE_INFO["recog_data"]["Intent"] !== 'ASP005'){
					_thisPage.isQuesDv();
					_thisPage.fn_inputSet();
				}
				
//				// 질의 출처 선택 OR 고유 질의
//				if(_thisPage.isQuesDv() != "" || apiYn != true){
//					_thisPage.fn_inputSet();
//				}
//				// 질의 출처 선택 안했을 경
//				else {
//					let INTE_INFO ="{'recog_txt':'"+_thisCont.INTE_INFO["recog_txt"]+"','recog_data' : {'Intent':'"+_thisCont.INTE_INFO["recog_data"]["Intent"]+"','appInfo' : "+JSON.stringify(_thisCont.INTE_INFO["recog_data"]["appInfo"])+"} }" ;
//					const url = "ques_0000_04.act?INTE_INFO="+INTE_INFO;
//					location.href= url;
//					iWebAction("openPopup",{"_url" : url});
//				}
			}
		}
		// 음성결과에 인텐트 없는경우
		else{
			location.href = "ques_0000_01.act?QUES_DIV=02";
		}
		
	},
	/**
	 * intent 질의 구분이 APP_ID와 일치하는지 확인
	 * 일치하지 않으면 오류페이지로 이동한다.
	 */
	checkQuesDv :function(){
		let jexAjax = jex.createAjaxUtil("ques_comm_01_r010");
		let reuslt = "";
		jexAjax.set("INTE_CD", _thisCont.INTE_INFO["recog_data"]["Intent"]);
		jexAjax.setAsync(false);
		jexAjax.execute(function(data) {
			if(data.REC.length === 0){
				_thisPage.getAppInfo();
				result = "false";
			} else {
				if(data.REC.filter(v=>v.APP_ID===LGIN_APP).length >0){
					result="true";
				} else {
					result = "false";
					let url = "";
					if(data.REC.length>1){
						url = "basic_0009_02.act";
					} else {
						if(data.REC[0].APP_ID==="AVATAR") url = "basic_0009_02.act";
						else if(data.REC[0].APP_ID.indexOf("SERP") > -1) url = "basic_0009_01.act?PAGE_DV=SERP";
						else if(data.REC[0].APP_ID==="ZEROPAY") url = "basic_0009_01.act?PAGE_DV=ZEROPAY";
					}
					iWebAction("openPopup",{"_url" : url});
				}
			}
		});
		return result;
	},
	/**
	 * intent가 ASP005인 경우 
	 * NE-CPN이 거래처인지 가맹점인지 확인 불가
	 * 연결여부에 따라 거래처/가맹점 선택
	 *
	 * 접속 app이 zeropay -> 가맹점 확인 (없으면) 거래처 확인 
	 * 접속 app이 avatar -> 거래처 확인 (없으면) 가맹점 확인 
	 */
	checkCounterpartName : function(name){
		name = name.replace(/\^/g, " ");
		if(LGIN_APP === "ZEROPAY"){
			if(_ASP005func.isFranchiseName(name)){
				_ASP005func.setFranchiseName(name);
			} else {
				var url = "ques_0000_02.act?NE-COUNTERPARTNAME="+encodeURIComponent(name)+"&PREV_YN="+encodeURIComponent('Y')+"&MENU_DV=FRAN";
				iWebAction("openPopup",{"_url" : url});
				return false;
//				if(_ASP005func.isCounterpartName(name)){
//					_ASP005func.setCounterpartName();
//				} else {
//					var url = "ques_0000_02.act?NE-COUNTERPARTNAME="+encodeURIComponent(name)+"&PREV_YN="+encodeURIComponent('Y')+"&MENU_DV=COMM";
//					iWebAction("openPopup",{"_url" : url});
//					return false;
//				}
			}
		} else{
			if(_ASP005func.isCounterpartName(name)){
				_ASP005func.setCounterpartName();
			} else {
				var url = "ques_0000_02.act?NE-COUNTERPARTNAME="+encodeURIComponent(name)+"&PREV_YN="+encodeURIComponent('Y')+"&MENU_DV=BZAQ";
				iWebAction("openPopup",{"_url" : url});
				return false;
//				if(_ASP005func.isFranchiseName(name)){
//					_ASP005func.setFranchiseName(name);
//				} else {
//					var url = "ques_0000_02.act?NE-COUNTERPARTNAME="+encodeURIComponent(name)+"&PREV_YN="+encodeURIComponent('Y')+"&MENU_DV=COMM";
//					iWebAction("openPopup",{"_url" : url});
//					return false;
//				}
			}
		}
		
	},
	/**
	 * 해당 질의에 대한 출처 확인
	 * [01 : 공통질의/아바타], [02 : 공통질의/경리나라], ["" : 공통질의/질의출처선택X], [SERP_99 : 경리나라 고유질의], [AVATAR_99 : 아바타 고유질의], [APP_99 : 그 외 APP 고유질의]
	 */
	isQuesDv :function(){
		var jexAjax = jex.createAjaxUtil("ques_comm_01_r007"); // PT_ACTION
		jexAjax.set("INTE_CD", _thisCont.INTE_INFO["recog_data"]["Intent"]);
		jexAjax.setAsync(false);
		jexAjax.execute(function(data) {
			isQuesDv = avatar.common.null2void(data.QUES_DV);
		});
		return isQuesDv;
	},
	/**
	 * 질의 API 연결 여부 확인 
	 * (API 종류와 상관없이)
	 */
	checkAPIConnection : function(){
		apiYn = false;
		var jexAjax = jex.createAjaxUtil("ques_comm_01_r005"); // PT_ACTION
		jexAjax.setAsync(false);
		jexAjax.execute(function(data) {
			console.log(data);
			if(_thisCont.INTE_INFO["recog_data"]["Intent"] == "MON001"){
				apiYn = true;
			}
			else{
				if(data.APP_CNT>0){
					apiYn = true;
				}
			}
		});
	},
	/**
	 * intent==="NNN001"일 때 화면 이동 및 처리하는 함
	 * appInfo에 있는 값들을 검색해서 유사 질의 목록 화면으로 이동 
	 */
	getAppInfo : function(){
		let appInfoList = "";
		let appInfo = [];
		$.each(_thisCont.INTE_INFO["recog_data"]["appInfo"], function(i,v){
			appInfo.push(v);
		});
		appInfoList = appInfo+"";
		
		/* ##예외처리##
		 intent 없음 && 카드명 있음 (예: 신한카드 ) 
	 	 TODO : ㅇㅇ카드 발화 시 ASP005로 넘어옴 필요한 기능인지 확인
		 */
		if(_thisCont.INTE_INFO["recog_data"]["Intent"] == 'NNN001' && avatar.common.null2void(_thisCont.INTE_INFO.recog_data.appInfo["NE-CARDNAME"]) !=""){
			appInfoList = "카드";
		}
		
		var jexAjax = jex.createAjaxUtil('ques_comm_01_r004');
		jexAjax.set('VOCA_LIST', appInfoList);
		jexAjax.execute(function(data){
			if(data.REC.length > 1){
				//결과 값이 1개 이상 -> list로 보여주기
				errorPage(JSON.stringify(data.REC), '00');
			} else if(data.REC.length == 1){
				//결과 값이 1개 -> 해당 페이지로 이동
				var _INTE_INFO ="{'recog_txt':'"+_thisCont.INTE_INFO["recog_txt"]+"','recog_data' : {'Intent':'"+data.REC[0].INTE_CD+"','appInfo' : "+JSON.stringify(_thisCont.INTE_INFO["recog_data"]["appInfo"])+"} }" ;
				var url = "ques_comm_01.act?INTE_INFO="+_INTE_INFO;
				iWebAction("openPopup",{"_url" : url});
			} else if(data.REC.length == 0){
				//결과 값이 없음 -> 오류 화면으로 이동 
				errorPage(JSON.stringify(data.REC), '02');
			}
		});
	},
	/**
	 * intent 유무, intent 이름 확인   
	 */
	fn_inputSet : function(){
		var jexAjax = jex.createAjaxUtil("ques_comm_01_r002");
		jexAjax.set("INTE_CD", _thisCont.INTE_INFO["recog_data"]["Intent"]);
		console.log("update data input:: " +JSON.stringify(inteInfo));
		jexAjax.execute(function(data) {
			console.log("updated data :: " +JSON.stringify(data));
			if(avatar.common.null2void(data.INTE_CNT) == ""){
				_thisPage.getAppInfo();
			}
			/* TODO : 메모 기능 추가 */
			 else if(_thisCont.INTE_INFO["recog_data"]["Intent"] === "_NNN02"){	//메모 보여줘
				const url = "ques_0014_01.act?INTE_INFO="+JSON.stringify(_thisCont.INTE_INFO);
				iWebAction("openPopup",{"_url" : url});
			} else if(_thisCont.INTE_INFO["recog_data"]["Intent"] === "_NNN01"){ //메모해줘
				const url = "ques_0014_02.act?INTE_INFO="+JSON.stringify(_thisCont.INTE_INFO);
				iWebAction("openPopup",{"_url" : url});
			}
			
			else{
				inteNm = data.INTE_NM;
				// NNN질의는 카테고리 없음 (NNN019, NNN020제외)
				if(_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("NNN")>-1 && !(_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("NNN019")>-1 || _thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("NNN020")>-1)) inteNm = "";
				iWebAction("changeTitle",{"_title" : inteNm, "_type" : "2"});
				_thisPage.searchData();
			}
		});
	},
	/**
	 * 전달받은 inteInfo값으로 질의 search
	 * search 전 inteInfo를 예외처리해야 하는 경우 해당 함수에서 처리한다. 
	 * @param moreData (1페이지 호출시 false, 더보기 처리시 true)
	 */
	searchData : function(moreData){ //
		if(moreData){
			_thisCont.PAGE_NO = _thisCont.PAGE_NO + 1;
		}
		var input = {};
		input["PAGE_NO"] = _thisCont.PAGE_NO;
		input["PAGE_CNT"] = _thisCont.PAGE_CNT;
		
		removeDatefromCPN();
		
		/* ##예외처리##
		 거래처 관련 질의(거래처목록,거래처,매출처,매입처)
		 NE-CPN 예외처리 사항 */ 
		if(_thisCont.INTE_INFO.recog_data.Intent == "ASN002")
			_thisCont.INTE_INFO.recog_data.appInfo["BZAQ_DV"] = "S";
		if(_thisCont.INTE_INFO.recog_data.Intent == "APN001")
			_thisCont.INTE_INFO.recog_data.appInfo["BZAQ_DV"] = "B";
		
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
		if(_thisCont.INTE_INFO.recog_data.Intent == "ZNN002" || _thisCont.INTE_INFO.recog_data.Intent == "ZNN005"){
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
		
		/* ##예외처리##
		 세무사 관련 질의(NNN019,NNN020)
		 NE-PERSON 예외처리 */  
		if (_thisCont.INTE_INFO.recog_data.appInfo["NE-COUNTERPARTNAME"]){
			_thisCont.INTE_INFO.recog_data.appInfo["NE-COUNTERPARTNAME"] = _thisCont.INTE_INFO.recog_data.appInfo["NE-COUNTERPARTNAME"].replace(/\^/g, " ");
		
			if ((_thisCont.INTE_INFO.recog_data.Intent == "NNN020" || _thisCont.INTE_INFO.recog_data.Intent == "NNN019" ) && avatar.common.null2void(_thisCont.INTE_INFO.recog_data.appInfo["NE-PERSON"]) === ""){
				_thisCont.INTE_INFO.recog_data.appInfo["NE-PERSON"] = _thisCont.INTE_INFO.recog_data.appInfo["NE-COUNTERPARTNAME"];
			}
		}
		if ((_thisCont.INTE_INFO.recog_data.Intent == "NNN020" || _thisCont.INTE_INFO.recog_data.Intent == "NNN019" )){
			var jexAjax = jex.createAjaxUtil('ques_comm_01_r009');
			jexAjax.set(input);
			jexAjax.setAsync(false);
			jexAjax.execute(function(dat){
				_thisCont.INTE_INFO.recog_data.appInfo["LATD1"] = avatar.common.null2void(dat.LATD)===""?0:dat.LATD;
				_thisCont.INTE_INFO.recog_data.appInfo["LOTD1"] = avatar.common.null2void(dat.LOTD)===""?0:dat.LOTD;
			});
		}
		if (_thisCont.INTE_INFO.recog_data.appInfo["NE-PERSON"]){
			_thisCont.INTE_INFO.recog_data.appInfo["NE-PERSON"] = _thisCont.INTE_INFO.recog_data.appInfo["NE-PERSON"].replace(/세무사/, "").replace(/세무서/, "").trim();
		}
		if (_thisCont.INTE_INFO.recog_data.Intent == "NNN020"){
			_thisCont.INTE_INFO.recog_data.Intent = "NNN019";
			iWebAction("getAppData",{"_key" : "_txofInfm", "_call_back" : "_fn_gettxoflist"});
			_intent = "NNN020";
		}
		
		/* ##예외처리##
		 세무사 전화 연결 후 제외할 세무사 목록 */ 
		var _txofList = [];
		if(_thisCont.INTE_INFO.recog_data.appInfo["TXOF_LIST"]){
			_thisCont.INTE_INFO.recog_data.appInfo["TXOF_LIST"] = JSON.parse(decodeURIComponent(_thisCont.INTE_INFO.recog_data.appInfo["TXOF_LIST"])).map(function(obj){
				return "'"+obj+"'";
			}).join();
			_thisCont.INTE_INFO.recog_data.appInfo["TXOFLIST_YN"] = 'Y'
		} else {
			_thisCont.INTE_INFO.recog_data.appInfo["TXOFLIST_YN"] = 'N';
		}
		
		
		input["INTE_INFO"] = JSON.stringify(_thisCont.INTE_INFO);
		
		/* ##예외처리##
		 실시간인 경우 로딩바를 표시한다.(BNN002)
		 callback data를 받는 시간이 오래 걸려 여기서 처리*/   
		if(_thisCont.INTE_INFO.recog_data.Intent == "BNN002"){
			$(".content").show();
			$(".m_cont#REALTIME").show();
		}
		
		avatar.common.callJexAjax("ques_comm_01_r001", input, _thisPage.fn_callback, "false", "");
	},
	/**
	 *  
	 * @param data(ques_comm_01_r001 callback data)
	 */
	fn_callback : function(data){
		let rsltJson = JSON.parse(data.RSLT_CTT);
		console.log(rsltJson);
		totCnt = rsltJson.CNT;
		if(Object.keys(rsltJson).length == 0 || rsltJson.RSLT_CD == "9999" ){
			dataYn = "N";
		}
		
		if(avatar.common.null2void(JSON.parse(data.RSLT_CTT).SQL2).length == 0 || "ASP001".indexOf(_thisCont.INTE_INFO["recog_data"]["Intent"]) > -1){
			isMore = false;
		} else isMore = true;
		
		_thisCont["PAGE_NO_RENDER"] = _thisCont.PAGE_NO;
		
		//api 연결 오류 시 - 프로세스 변경으로 사용 하지 않음 
//		if(avatar.common.null2void(rsltJson.RSLT_CD)!="0000" && avatar.common.null2void(rsltJson.RSLT_CD)!= ""){
//			if(apiYn == false){
//				var url = "ques_comm_02.act?INTE_CD="+ _thisCont.INTE_INFO["recog_data"]["Intent"]+"&API_YN="+apiYn;
//				iWebAction("openPopup",{"_url" : url});
//			} else {
//				url = "basic_0005_02.act?RSLT_CD="+rsltJson.RSLT_CD+"&RSLT_MSG="+rsltJson.RSLT_MSG;
//				iWebAction("openPopup",{"_url" : url});
//			}
//			
//		} 
		//현금영수증 매입/매출 & NE-CPN 들어오면 I-005로 이동한다. 
		if(",SON001,PON001,".indexOf(_thisCont.INTE_INFO["recog_data"]["Intent"]) > -1 && avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"])!=""){
			url = "ques_0000_03.act?ERR_CD=00000001&INTE_NM="+inteNm;
			iWebAction("openPopup",{"_url" : url});
			return false;
		}
		//NNN질의 중 API에서 사용하지 않는 NNN은 I-006으로 이동한다. 
		var APIexceptIntent = ",NNN006,NNN009,NNN014,NNN015,";//,NNN010,NNN005
		if(LGIN_APP.indexOf("SERP") > -1 && APIexceptIntent.indexOf(_thisCont.INTE_INFO["recog_data"]["Intent"]) > -1){
			var url = "basic_0009_02.act";
			iWebAction("openPopup",{"_url" : url});
			return;
		} 
		//정상적이지 않은 시간값이 들어온 경우 시간값 함수에서 ERR_CD를 내려준다.
		if ((avatar.common.null2void(rsltJson.LST_INQ_DT).indexOf("0000") > -1)){
			var ERR_CD =avatar.common.null2void(rsltJson.LST_INQ_DT);
			if(ERR_CD == "00000000"){
				url = "ques_0000_03.act?ERR_CD="+ERR_CD+"&INTE_NM="+inteNm;		//I-004
				iWebAction("openPopup",{"_url" : url});
			} else if (ERR_CD == "00000001"){
				url = "ques_0000_03.act?ERR_CD="+ERR_CD+"&INTE_CD="+_thisCont.INTE_INFO["recog_data"]["Intent"]+"&INTE_NM="+inteNm;		//I-005
				iWebAction("openPopup",{"_url" : url});
			}
		} else {
			/* ##예외처리##
			 거래처 수에 따라 화면이동 처리한다.
			*/
			if(_thisCont.INTE_INFO["recog_data"]["Intent"]==="ASP001"){
				//다수 거래처(거래처 목록)
				if(rsltJson.SQL2.length>1){
					let enc_inteInfo = "{'recog_txt':'거래처목록 조회','recog_data':{'Intent':'ASP002',appInfo:{'NE-COUNTERPARTNAME':'"+avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"])+"','SRCH_WD_YN':'Y', 'PREV_YN' : 'Y'}}}";
					let url = "ques_comm_01.act?INTE_INFO="+encodeURIComponent(enc_inteInfo);
					iWebAction("openPopup",{"_url" : url});
					return false;
				}
				//거래처 없음(I-001)
				if(rsltJson.SQL2.length===0 && avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"])!==""){
					let url = "ques_0000_02.act?NE-COUNTERPARTNAME="+encodeURIComponent(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"])+"&PREV_YN="+encodeURIComponent('Y')+"&MENU_DV=BZAQ";
					iWebAction("openPopup",{"_url" : url});
					return false;
				}
			}
			
			/* ##예외처리##
			 가맹점 수에 따라 화면이동 처리한다.
			*/
			let frchIntent = ",ASP003,AZN001,AZN002,";
			if(frchIntent.indexOf(_thisCont.INTE_INFO["recog_data"]["Intent"])>-1){
				//다수 가맹점(가맹점목록)
				if(rsltJson.SQL2.length>1){
					let enc_inteInfo = "{'recog_txt':'가맹점목록 조회','recog_data':{'Intent':'ASP004',appInfo:{'NE-COUNTERPARTNAME':'"+avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"])+"','SRCH_WD_YN':'Y', 'PREV_YN' : 'Y'}}}";
					let url = "ques_comm_01.act?INTE_INFO="+encodeURIComponent(enc_inteInfo)+"&PRE_INTENT="+_thisCont.INTE_INFO["recog_data"]["Intent"];
					iWebAction("openPopup",{"_url" : url});
					return false;
				}
				//가맹점 없음(I-001)
				if(rsltJson.SQL2.length == 0 && avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"]) != ""){
					let url = "ques_0000_02.act?NE-COUNTERPARTNAME="+encodeURIComponent(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-COUNTERPARTNAME"])+"&PREV_YN="+encodeURIComponent('Y')+"&MENU_DV=FRAN";
					iWebAction("openPopup",{"_url" : url});
					return false;
				}
				
			}
			/* ##예외처리##
			 세무사 수에 따라 화면이동 처리한다.
			*/
			let txofIntent = ",NNN019,NNN020,";
			if(txofIntent.indexOf(_thisCont.INTE_INFO["recog_data"]["Intent"]) > -1 && _thisCont.PAGE_NO === 1){
				//조회된 세무사 없음(I-001)
				if(rsltJson.SQL2.length < 1 && avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-PERSON"]) != "" ){
					let pageUrl = "ques_0000_02.act?";
					let pageParam = "NE-PERSON="+encodeURIComponent(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-PERSON"])+"&PREV_YN="+encodeURIComponent('N')+"&MENU_DV=TXOF";
					iWebAction("openPopup",{"_url":pageUrl, "_param" : pageParam});
					return false;
				} 
				else if(rsltJson.SQL2.length == 1){
					if(_intent == "NNN019"){		//세무사 상세화면(B-108)
						let pageUrl = "ques_0013_01.act?";
						let pageParam = "NE-PERSON="+encodeURIComponent(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-PERSON"])+"&PREV_YN="+encodeURIComponent('Y');
						iWebAction("openPopup",{"_url":pageUrl, "_param" : pageParam});
						return false;
					} else if(_intent == "NNN020"){		//세무사 전화연결화면(B-102)
						var pageUrl = "ques_0013_02.act?";
						var pageParam = "NE-PERSON="+rsltJson.SQL2[0].chrg_nm
						+"&CHRG_TEL_NO="+rsltJson.SQL2[0].chrg_tel_no
						+"&BIZ_NO="+rsltJson.SQL2[0].biz_no
						+"&SEQ_NO="+rsltJson.SQL2[0].seq_no
						+"&PREV_YN="+encodeURIComponent('N');
						iWebAction("openPopup",{"_url":pageUrl, "_param" : pageParam});
						
						//전화연결화면에서 해당 프로세스 수행
						//TODO :확인 후 삭제 
//						var _txofInfm = {};
//						_txofInfm.name = rsltJson.SQL2[0].chrg_nm;
//						_txofInfm.tel_no = rsltJson.SQL2[0].chrg_tel_no;
//						_txofInfm.biz_no = rsltJson.SQL2[0].biz_no;
//						_txofInfm.seq_no = rsltJson.SQL2[0].seq_no;
//						jArr_txofInfm.push(_txofInfm);
//						iWebAction("setAppData",{"_key" : "_txofInfm", "_value" : jArr_txofInfm});
//						iWebAction("setAppData",{"_key" : "_isPhoneCall", "_value" : true});
//						fn_back();
//						iWebAction("phoneCall",{"_type" : "1", "_phone_num" : rsltJson.SQL2[0].chrg_tel_no});
//						return false;
					} 
				}
			}

			//첫번째 조회시에는 html 및 유사질의데이타 조회
			if(_thisCont.PAGE_NO == 1){
				//admin에서 등록한 html 그리기-화면나오고 필요한 작업들은 이 이후에 처리.
				$(".m_cont#MAIN").html(data.OTXT_HTML);
				$(".class_type").addClass(rsltJson.CLASS_TYPE);		//class를 추가하고 싶은 경우(매출증감)
				
				//거래처,가맹점 개별항목 질의 시(예: 거래처 사업자번호)
				if(",ASP001,ASP003".indexOf(_thisCont.INTE_INFO["recog_data"]["Intent"]) > -1 && rsltJson.SQL2.length > 0){
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
					//TODO : noPageIntent 확인을 인텐트별로 처리하기
					// 잔고, 카드매출 입금, 자금현황은 페이징 처리 안되어있어서 1페이지 이상일 경우 조회안함. 데이터가 있을 경우에만 html 붙임.
					var noPageIntent = ",BDW001,SCN002,BDW003,ASP001,ASN001,BDW001_1,BDW006,BDW007,BDW008,BWN002,BCN001,BNN002,,BDW005,SCT006";
					if((_thisCont.PAGE_NO  > 1  
							&& noPageIntent.indexOf(_thisCont.INTE_INFO["recog_data"]["Intent"]) > -1) || sql_data.length == 0){
						if("ASP001".indexOf(_thisCont.INTE_INFO["recog_data"]["Intent"]) > -1){
						} else {
							if(_thisCont.PAGE_NO == 1){
								$("#"+i).children().eq(0).remove();
							}
						}
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
					if(_thisCont.PAGE_NO == 1) 
						_thisPage.setHtmlData(null, i, sql_data);
				}
			});
			
			/* ### 예외처리 ### */
			//답변 화면에서 다른 화면으로 이동 필요 시 사용한다.	(NNN005,NNN006,NNN007,NNN008,NNN009,NNN010,NNN011,NNN013,_NNN014,_NNN015)
			console.log($("#redirectURL").length);
			console.log($("#redirectURL").text());
			
			if($("#redirectURL").length>0){
				location.href = $("#redirectURL").text();
			}
			//답변 화면에서 다른 사이트로 이동 시 필요...현재는 프로세스 변경으로 해당 인텐트(NNN016) 사용하지 않음
//			if($("#webDirectURL").length>0){
//				var url = $("#webDirectURL").text();
//				iWebAction("webBrowser", {"_url" : decodeURIComponent(url)});
//				fn_back();
//			}

			//TTS 형식 변경
			$.each($('[data-tts_type=bignumber2]'), function(i, v){
				$(v).text(formatter.bignumber2($(v).text()));
			});
			$.each($('[data-tts_type=datekr2]'), function(i, v){
				alert($(v).text());
				$(v).text(formatter.datekr2($(v).text()));
				alert($(v).text());
			});
			//_HIGL로 시작하는 값이 있는 경우 하이라이트 처리	(BDW007,BDW008)
			$.each($("span[id*='_HIGL']"), function(i, v){
				if($(v).text() == "Y"){
					$(v).next().addClass("c_357EE7");
				}
			});
			// (AZN002,NNN019,ZNN008,ZNN009)
			$.each($("span[id='IMG_PATH']"), function(i, v){
				if(avatar.common.null2void($(v).text())!=="")
					$(this).prev().attr("src", $(v).text());
			});
			// (AZN001)
			if($("#QR_CD").text()){
				$(this).prev().attr("src", "https://chart.googleapis.com/chart?cht=qr&chs=200x200&chl="+$("#QR_CD").text());
			}
			// date값 추가 (MON002,MON003)
			$("span").each(function(i,v){
				if($(v).data("date")){
					$(v).text("");
					$(v).text(avatar.common.getDate("yyyy년 mm월 dd일", "D", $(v).data("date")));
				}
			});
			// 맞춤질의인 경우 선택된 사용자만 사용
			if(testUser.indexOf($("#sCLPH_NO").val()) == -1 && _thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("MON")>-1){
				$(".m_cont#MAIN").hide();
				$(".m_cont#REALTIME").hide();
				var url = "basic_0009_02.act";
				iWebAction("openPopup",{"_url" : url});
				return true;
			}
			
			/* # 인텐트별 TTS 예외처리 # */
			// 인텐트관리(admin)에서 처리하기 어려운 경우 사용
			// 예외처리 인텐트(자금현황) 인텐트
			if(_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("BDW003") >-1 
				&& $("#RESULT_TTS .CLASS_ICDC_AMT").text() == "0"
			){
				$(".NOTI_TTS").text("변동이 없습니다");
			}
			// 예외처리 인텐트(자금흐름) 인텐트
			else if(_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("BDW005") >-1 
				&& $("#RESULT_TTS .CLASS_TITLE_AMT_FLOW").text() == "0"
			){
				$(".NOTI_TTS").text("이며 변동이 없습니다");
			}
			// 예외처리 인텐트(매출증감) 인텐트
			else if(_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("SCT002") >-1 
				&& $("#RESULT_TTS .CLASS_AMT_FLOW").text() == "0"
			){
				$(".NOTI_TTS").text("은 변동이 없습니다");
			}
			// 예외처리 인텐트(예적금/대출금) 인텐트
			else if((_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("BDW007") >-1 ||_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("BDW008") >-1)){
				if($("#RESULT_TTS #PRODUCT_INFO1").text() != "" || $("#RESULT_TTS #PRODUCT_INFO2").text() != "")
					$(".NOTI_TTS").text("");
				else {$("#PRODUCT_INFO1").text(""); $("#PRODUCT_INFO2").text("");}
			}
			// 예외처리 인텐트(거래처) 인텐트
			else if((_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("ASP001") >-1 || _thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("ASP003") >-1) 
				&& $("#SCH_TIT").text() != ""
				//&& $("#SCH_TIT").text().indexOf("조회결과") == -1
			){
				if($("#SCH_VAL").text() == ""){
					var tts = $("#RESULT_TTS .SRCH_WD").text()+" "+$("#SCH_TIT").text().replace(/는/gi, "").replace(/은/gi, "")+"로 등록된 정보가 없습니다";
					$(".NOTI_TTS").text(tts);
					$(".SCH_END").text(" 없습니다.");
				}else{
					var tts = $("#RESULT_TTS .SRCH_WD").text()+" "+$("#SCH_TIT").text()+" "+$("#SCH_VAL").text()+ "입니다";
					$(".NOTI_TTS").text(tts);
				}
			}
			/* --# 인텐트별 TTS 예외처리 # */
			// 세무사 검색유무에 따라 상단 문구 변경 필요 (NNN019)
			if((_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("NNN019") >-1 || _thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("NNN020") >-1) 
				&& avatar.common.null2void(_thisCont.INTE_INFO["recog_data"]["appInfo"]["NE-PERSON"]) != ""
			){
				$("#TXOF_LIST_SELECTED").show();
				$("#TXOF_LIST").hide();
			}
			/* --### 예외처리 ### */
			
			//연결상태 확인 
			$(".CNT").each(function(i,v){
				sum +=parseInt(avatar.common.null2zero($("#"+$(v).attr("id")).text()));
			});
			//오른쪽 상단 발화내용
			$(".askAvatar_queWord").text(_thisCont.INTE_INFO["recog_txt"]);
			
			//제로페이아바타,아바타에서는 모든 질의 가능(경리나라 전용 질의 제외)
			if(_APP_ID.indexOf("SERP") == -1){
				// ZEROPAY-API인 경우(결제수수료,입금예정액,입금얘정내역,매출브리핑)
				if(",ZNN003,ZNN006,ZSN001,ZNN007,".indexOf(_thisCont.INTE_INFO["recog_data"]["Intent"]) > -1){
					$("body").addClass("bg_F5F5F5");
					$(".content").show();
					$(".m_cont#REALTIME").hide();
					$(".m_cont#MAIN").show();
					if(_APP_ID == "ZEROPAY" && !(rsltJson.RSLT_CD==="B001" || rsltJson.RSLT_CD==="ZER002")){
						$("div[name=CONTENT]").show();
						$("div[name=SETTING]").hide();
						iWebAction("getStorage",{_key : "keyWebResultTTS", _call_back : "fn_getWebResultTTS"});
					} else {
						$("div[name=CONTENT]").hide();
						$("div[name=SETTING]").show();
					}
					return false;
				}
				
				//data 없음 / NNN이 아님 : 경리나라 연결 화면으로 이동
				if((dataYn == "N" && _thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("NNN") == -1 && _thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("BNN001") == -1)
						|| ( _thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("MON")==-1 && isQuesDv=="SERP_99" ) ){
					/*if((testUser.indexOf($("#sCLPH_NO").val()) == -1 && _thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("MON")>-1) 
							|| isQuesDv=="SERP_99"){*/
						$(".m_cont#MAIN").hide();
						$(".m_cont#REALTIME").hide();
						var url = "basic_0009_01.act?PAGE_DV=SERP";
						iWebAction("openPopup",{"_url" : url});
						return false;
					/*} else {
						//return true;
					}*/
				}
				if(sum == 0){
					//거래처 질의 중간화면 없앰
					//TODO : 사용여부 확인 후 삭제
//					if(_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("ASP001") > -1){
//						$(".m_cont#MAIN").show();
//						$(".m_cont#REALTIME").hide();
//						$("body").addClass("bg_F5F5F5");
//						$("div[name=CONTENT]").hide();
//						$("div[name=SETTING]").hide();
//					}
					//환율(외부 API로 가져올 경우)
					//프로세스변경으로 사용하지 않음 (환율-DB에서 조회)
//					else if(_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("BNN001") > -1){
//						$("body").addClass("bg_EBEDED");
//						$(".m_cont#REALTIME").hide();
//						$(".m_cont#MAIN").show();
//					}
					//세액내역(실시간 이후 배치로 변경 예정)
					if(_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("BNN002") > -1){
						if(rsltJson.CERT_YN=="N"){
							$(".m_cont#REALTIME").hide();
							$(".m_cont#MAIN").show();
							$("body").addClass("bg_F5F5F5");
							$("div[name=CONTENT]").hide();
							$("div[name=SETTING]").show();
						} else {
							$(".m_cont#REALTIME").hide();
							$(".m_cont#MAIN").show();
							$("body").addClass("bg_F5F5F5");
							$("div[name=CONTENT]").show();
							$("div[name=SETTING]").hide();
							iWebAction("getStorage",{_key : "keyWebResultTTS", _call_back : "fn_getWebResultTTS"});
							
							if(rsltJson.SQL2){
								if(rsltJson.SQL2.length == 0 && _thisCont.PAGE_NO == 1){
									$("#LIST_CONTENT").hide();
									$("#TOP_CONTENT").show();
								}
							}
							
							
						}
					}
					//data 연결x  & 특정 intent 아닐 경우 : 설정화면 show
					else if(_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("MON") == -1){
						$(".m_cont#REALTIME").hide();
						$(".m_cont#MAIN").show();
						$("body").addClass("bg_F5F5F5");
						$("div[name=CONTENT]").hide();
						$("div[name=SETTING]").show();
						// 환율조회만 음성
						if(_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("BNN001") > -1 && _thisCont.PAGE_NO == 1){
							iWebAction("getStorage",{_key : "keyWebResultTTS", _call_back : "fn_getWebResultTTS"});
						}
						if(_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("NNN019") > -1 && _thisCont.PAGE_NO == 1){
							if(rsltJson["SQL2"].length !== 1)
								iWebAction("getStorage",{_key : "keyWebResultTTS", _call_back : "fn_getWebResultTTS"});
							else $(".m_cont#MAIN").hide();
						}
						
					}
					// data 연결x & 그 외 : 전체 show
					else { 
						$("body").addClass("bg_EBEDED");
						$(".m_cont#REALTIME").hide();
						$(".m_cont#MAIN").show();
					}
					/*if(isQuesDv == "01" || isQuesDv == "AVATAR_99"){
						$(".m_cont#MAIN").show();
						$("body").addClass("bg_F9F9F9");
						$("div[name=CONTENT]").hide();
						$("div[name=SETTING]").show();
					}
					if((isQuesDv == "02" && apiYn == true) || (dataYn != "N" && isQuesDv == "SERP_99")){
						$(".m_cont#MAIN").show();
						$("body").addClass("bg_F9F9F9");
						$("div[name=CONTENT]").show();
						$("div[name=SETTING]").hide();
					}*/
				}
				//연결되 data있는경우 : content show
				else{
					$("body").addClass("bg_F5F5F5");
					$(".m_cont#REALTIME").hide();
					$(".m_cont#MAIN").show();
					$("div[name=CONTENT]").show();
					if(_thisCont.PAGE_NO == 1){
						_thisPage.fn_modalData();
						iWebAction("getStorage",{_key : "keyWebResultTTS", _call_back : "fn_getWebResultTTS"});
						
					}
					if(_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("BDW006") > -1){
						if((rsltJson.SQL2 || rsltJson.SQL3 || rsltJson.SQL4)){
							if(rsltJson.SQL2.length == 0){
								$("div[name=CONTENT]:eq(2)").hide();
							}
							if(rsltJson.SQL3.length == 0){
								$("div[name=CONTENT]:eq(3)").hide();
							}
							if(rsltJson.SQL4.length == 0){
								$("div[name=CONTENT]:eq(4)").hide();
							}
						}
					}
					if(rsltJson.SQL2){
						if(rsltJson.SQL2.length == 0 && _thisCont.PAGE_NO == 1){
							$("#LIST_CONTENT").hide();
							$("#TOP_CONTENT").show();
						}
					}
				}
				if($("#TAX_CNT").text()>0 && $("#_BZAQ_CNT").text()==0 && ( _thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("ASP002") > -1 || _thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("APN001") > -1 || _thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("ASN002") > -1)){
					$(".m_cont#MAIN").show();
					$(".m_cont#REALTIME").hide();
					$("body").addClass("bg_F5F5F5");
					$("div[name=CONTENT]").hide();
					$("div[name=SETTING]").hide();
					$("div[name=NODATA]").show();
				}
				if((_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("ASP001") > -1 || (_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("ASN001") > -1)) 
						&& $("#_BZAQ_CNT").text()==0 && rsltJson.CERT_YN == "Y"){
					$(".m_cont#MAIN").show();
					$(".m_cont#REALTIME").hide();
					$("body").addClass("bg_F5F5F5");
					$("div[name=CONTENT]").hide();
					$("div[name=SETTING]").hide();
					$("div[name=NODATA]").show();
				}
				if(_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("BWN002") > -1 && rsltJson.SQL2.length == 0 && _thisCont.PAGE_NO == 1){
					$("#LIST_CONTENT").hide();
				}
			}
			else if(_APP_ID.indexOf("SERP") > -1){
				$(".SERP_CONTENT").show();
				$("#HIS_LST_DTM").text(avatar.common.getDate());
				$("body").addClass("bg_F5F5F5");
				$(".m_cont#REALTIME").hide();
				$(".m_cont#MAIN").show();
				$("div[name=CONTENT]").show();
				
				if(dataYn == "N" && (_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("NNN") == -1)/*&& APIexceptIntent.indexOf(_thisCont.INTE_INFO["recog_data"]["Intent"]) == -1*/){
					if(_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("SCT003") == -1 && _thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("PCT001") == -1){
						$(".m_cont#REALTIME").hide();
						$(".m_cont#MAIN").hide();
						var url = "basic_0009_02.act";
						iWebAction("openPopup",{"_url" : url});
					}
				} else {
					if(_thisCont.PAGE_NO == 1){
						if(_APP_ID === "SERP") iWebAction("getStorage",{_key : "keyWebResultTTS_SERP", _call_back : "fn_getWebResultTTS"});
						else if(_APP_ID === "KTSERP") iWebAction("getStorage",{_key : "keyWebResultTTS_KTSERP", _call_back : "fn_getWebResultTTS"});
					}
				}
				if(_thisCont.INTE_INFO["recog_data"]["Intent"].indexOf("BDW006") > -1){
					if((rsltJson.SQL2 || rsltJson.SQL3 || rsltJson.SQL4)){
						if(rsltJson.SQL2.length == 0){
							$("div[name=CONTENT]:eq(1)").hide();
						}
						if(rsltJson.SQL3.length == 0){
							$("div[name=CONTENT]:eq(2)").hide();
						}
						if(rsltJson.SQL4.length == 0){
							$("div[name=CONTENT]:eq(3)").hide();
						}
					}
				}
				if(rsltJson.SQL2){
					if(rsltJson.SQL2.length == 0 && _thisCont.PAGE_NO == 1){
						$("#LIST_CONTENT").hide();
						$("#TOP_CONTENT").show();
					}
				}
			}
			if(rsltJson.LIST_CONTENT_YN ==="N"){
				$("#LIST_CONTENT").hide();
			}
			if(parseInt($("[name=PM_DIV]").text().replace(/,/g, ""))<0){
				$(".PM_APPLY").addClass("c_CC0000");
				$(".PM_APPLY").removeClass("c_357EE7");
			}
			
			$("#compno").text(formatter.corpNum($("#YOGIYO_COMPNO").text().replace(/-/g, "")));
			
			$(".content").show();

			if($("#CERT_DT_STTS").text() == "Y"){
				iWebAction("getStorage",{"_key" : "dateDayModal1", "_call_back" : "fn_getdateDayModal1"});
			}
			if(LGIN_APP === "KTSERP") {
				$(".SERP_CONTENT").show();				
			} else {
				$("."+LGIN_APP+"_CONTENT").show();
			}
		}
		
/*		if(_thisCont.PAGE_NO == 1){
			_thisPage.fn_modalData();
			
			if(devUser.indexOf($("#sCLPH_NO").val()) > -1){
				$.each($("#RESULT_TTS").children(), function(i, v){
					if(avatar.common.null2void($(v).attr("data-type"))!="" && $(v).attr("data-type").indexOf("dateday")>-1){
						$(v).text(formatter.datekr($(v).text().replace(/\. /g, '').replace(/\([ㄱ-힣]\)/, '')));
					}
				});
				iWebAction("webResultTTS",{"_data" : avatar.common.null2void($("#RESULT_TTS").text())});
			}
		}*/
		//경리나라 표시 on
		/*if((isQuesDv == "02" || isQuesDv == "SERP_99") && apiYn == true &&  _APP_ID == "AVATAR"){
			serpHtml = '';
			serpHtml += `<div class="ic_dataSource kyungrinara">
							<img src="../img/ic_dataSource1.png" alt="데이터 출처 - 경리나라">
						</div>`;
			$(".top_info").after(serpHtml);
		}*/
		
	},
	setHtmlData : function(obj, key, data){
		var ele = null;
		var eleId = key.toUpperCase();
		if(obj == null){
			ele = $("#"+eleId);
			ele_nm = $("span[name='"+eleId+"']");
			if(eleId.indexOf("CLASS")>-1 || eleId.indexOf("_INQ_DT")>-1 || eleId.indexOf("SRCH_WD")>-1){
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
//				if(eleId == "HOXX_SDATE") {
//					$("#MID_DT2").show();
//					ele.html(val + " test");
//				}
//				
//				if(eleId == "HOXX_EDATE") {
//					ele.html(val + " test");
//				}
//				if(eleId == "HOXX_NAME") {
//					ele.html(val + " test");
//				}
//				if(eleId == "HOXX_BANK") {
//					ele.html(val + " test");
//				}
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
		if(eleId == "SHOP_CD"){
			// delivery_lstLogo_01 : 배달의민족  / delivery_lstLogo_02 : 요기요  / delivery_lstLogo_03 : 쿠팡이츠
			if(ele.text() == "sellBaemin")
				ele.next().find("img").attr("src", "../img/delivery_lstLogo_01.png");
			else if(ele.text() == "sellYogiyo"){
				ele.next().find("img").attr("src", "../img/delivery_lstLogo_02.png");
				// 요기요일때 ! 아이콘 노출
				ele.parent().children(".ic_i").attr("style", "display:;");
			}
			else if(ele.text() == "sellCoupangeats")
				ele.next().find("img").attr("src", "../img/delivery_lstLogo_03.png");
		}
	},
	fn_modalData : function(){
		var jexAjax = jex.createAjaxUtil("ques_comm_01_r006"); // PT_ACTION
		jexAjax.set("USE_INTT_ID", _USE_INTT_ID);
		if($("#TAX_CNT").text()){
			jexAjax.set("MENU_DV", "TAX");
		} else if($("#CASH_CNT").text()){
			jexAjax.set("MENU_DV", "CASH");
		} else if($("#ACCT_CNT").text()){
			jexAjax.set("MENU_DV", "ACCT");
		} else{return false;}
		jexAjax.execute(function(data) {
			if(data.CERT_EXP == "Y"){
				iWebAction("getStorage",{"_key" : "dateDayModal", "_call_back" : "fn_getdateDayModal"});
			}
		});
	},
}

/**
 * intent가 ASP005인 경우에만 사용한다.
 */
let _ASP005func = {
	isCounterpartName : function(name){
		let isTrue;
		let jexAjax = jex.createAjaxUtil("ques_comm_01_r008"); // PT_ACTION
		jexAjax.set("BZAQ_NM", name);
		jexAjax.set("SRCH_CD", "BZAQ");
		jexAjax.setAsync(false);
		jexAjax.execute(function(data) {
			if(data.BZAQ_CNT > 0)
				isTrue = true;
			else isTrue = false;
		});
		return Boolean(isTrue);
	},
	isFranchiseName : function(name){
		let isTrue;
		let jexAjax = jex.createAjaxUtil("ques_comm_01_r008"); // PT_ACTION
		jexAjax.set("MEST_NM", name);
		jexAjax.set("SRCH_CD", "ZERO");
		jexAjax.setAsync(false);
		jexAjax.execute(function(data) {
			if(data.ZERO_CNT > 0)
				isTrue = true;
			else isTrue = false;
		});
		return Boolean(isTrue);
	},
	setCounterpartName : function(){
		_thisCont.INTE_INFO["recog_data"]["Intent"] = 'ASP001';
	},
	setFranchiseName : function(){
		_thisCont.INTE_INFO["recog_data"]["Intent"] = 'ASP003';
	},
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

function _fn_gettxoflist(data){
	jArr_txofInfm = JSON.parse(decodeURIComponent(data));
}
function fn_setCaptureQuesCtt(data){
	alert(data);
}
function errorPage(jsonData, quesDv){
	$("#frmBzaq").remove();
	var html = "";
	html +='<form action="ques_0000_01.act" style="display:none;" method="post" id="frmBzaq">';
	html +="<input type='hidden' name='JSONDATA' value='"+jsonData+"'/>";
	html +="<input type='hidden' name='QUES_DIV' value='"+quesDv+"'/>";
	html +='</form>';
	$("body").append(html);
	$("#frmBzaq").submit();
}

//인증서 등록 되어있다면 홈텍스 인증서 페이지로 이동 아니면 인증서 등록 웹액션 호출
function fn_moveTax(_that, tax_gb){
	var url ='tax_0004_01.act?TAX_GB='+tax_gb;
	iWebAction("openPopup",{"_url" : url});
	/*var exist = isNaN(_that)?"":$(_that).text(); 
	if(exist.indexOf("관리하기")==-1){
		iWebAction("fn_cert_list",{
			"_menu_id":"2",
			"_title":"국세청 홈택스",
			"_callback":"callbackFunc"
		});
	} else {
		var url="tax_0002_01.act";
		iWebAction("openPopup",{_url:url});
	}*/
}
function fn_voice_recog_result(data){
	data = JSON.parse(decodeURIComponent(data));
	//NNN020, NNN019일때만 해당
	//data = {\"recog_txt\":\"첫번째\",\"recog_data\":{\"appInfo\":{\"NE-TURN\":\"1번\",\"NE-B-Ordinal\":\"1번\"},\"Intent\":\"NNN017\"}}
	//
	if(data.recog_data.Intent == "NNN017"){
		var turn = data.recog_data.appInfo["NE-TURN"];
		if(turn.substring(0, turn.length-1) >  _thisCont.PAGE_CNT* _thisCont.PAGE_NO || turn.substring(0, turn.length-1) > totCnt){
			alert((turn.substring(0, turn.length-1))+"번 째 세무사는 연결할 수 없습니다.");
			return false;
		}
		turn = turn.substring(0, turn.length-1)-1;
		
		if(_intent == "NNN019"){ //연결해줘 -> 해당 번호에 해당하는 세무사 상세 화면으로 이동
			var pageUrl = "ques_0013_01.act?";
			var pageParam = "BIZ_NO="+$(".taxerList:eq("+turn+")").find("#BIZ_NO").text()+"&SEQ_NO="+$(".taxerList:eq("+turn+")").find("#SEQ_NO").text()+"&PREV_YN="+encodeURIComponent('N');
			iWebAction("openPopup",{"_url":pageUrl, "_param" : pageParam});
		} else if(_intent == "NNN020"){
			var pageUrl = "ques_0013_02.act?";
			var pageParam = "NE-PERSON="+$(".taxerList:eq("+turn+")").find("#CHRG_NM").text()+"&CHRG_TEL_NO="+$(".taxerList:eq("+turn+")").find("#CHRG_TEL_NO").text()+"&PREV_YN="+encodeURIComponent('Y')+"&BIZ_NO="+$(".taxerList:eq("+turn+")").find("#BIZ_NO").text()+"&SEQ_NO="+$(".taxerList:eq("+turn+")").find("#SEQ_NO").text();
			iWebAction("openPopup",{"_url":pageUrl, "_param" : pageParam});
		} else {
			var url = "ques_0000_01?QUES_DIV=02";
			iwebAction("openPopup", {"_url":url});
		}
	}
}
function fn_getdateDayModal(data){
	if(avatar.common.null2void(data)!= '' && avatar.common.null2void(data) != 'Y' && avatar.common.getDate("yyyymmdd")<data){
		certClose1();
	}  else {
		$("#cert_modal").show();
	} 
}
function certClose1() {
	iWebAction("setStorage",{"_key" : "dateDayModal", "_value" : avatar.common.getDate("yyyymmdd", "D", 1)});
	$("#cert_modal").hide();
}
function snssClose() {
	$("#snss_modal").hide();
}
function fn_reCert(){
	var url = "tax_0002_01.act";
	iWebAction("openPopup",{"_url" : url});
}
function fn_getWebResultTTS(data){
	if(avatar.common.null2void(data)===""){
		if(LGIN_APP == "SERP") iWebAction("setStorage",{"_key" : "keyWebResultTTS_SERP", "_value" : "Y"});
		else if(LGIN_APP == "ZEROPAY") iWebAction("setStorage",{"_key" : "keyWebResultTTS_ZEROPAY", "_value" : "Y"});		
		else if(LGIN_APP == "KTSERP") iWebAction("setStorage",{"_key" : "keyWebResultTTS_KTSERP", "_value" : "Y"});		
		else iWebAction("setStorage",{"_key" : "keyWebResultTTS", "_value" : "Y"});
	}
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
		if(data == "Y"){
			$.each($("#RESULT_TTS").children(), function(i, v){
				if(avatar.common.null2void($(v).attr("data-type"))!="" && $(v).attr("data-type").indexOf("dateday")>-1){
					$(v).text(formatter.datekr($(v).text().replace(/\./g, '').replace(/ /g, '').replace(/\([ㄱ-힣]\)/, '')));
				}
			});
			iWebAction("webResultTTS",{"_data" : avatar.common.null2void($("#RESULT_TTS").text())});
		}
	}
	
}
function cb_getWebResultTTS(){
	iWebAction("phoneCall",{"_type" : "0", "_phone_num" : $("#ZP_TEL_NO").text()});
	fn_back();
}
function fn_popCallback_tax(){
	//홈텍스 인증서 조회 실패 - 재전송 요청 시
	fn_moveTax();
}
function fn_popCallback(){
	_thisPage.onload();
}
function fn_popCallbackReload(){
	location.reload();
}
function fn_popCallback2(){
	fn_back();
}
function fn_popCallback_back(){
	fn_back();
}
function fn_back(){
	if(window.location.href.indexOf("ASP001") > -1){
		if(_thisCont.INTE_INFO["recog_data"]["appInfo"]["PREV_YN"] == "N"){
			iWebAction("closePopup");
		}
		else iWebAction("closePopup",{_callback:"fn_popCallback2"}); 
	} /*else if(window.location.href.indexOf("NNN020") > -1){
		iWebAction("closePopup",{_callback:"fn_popCallbackReload"}); 
	} */else if(_thisCont.INTE_INFO["recog_data"]["appInfo"]["PREV_YN"] === "Y"){
		iWebAction("closePopup",{_callback:"fn_popCallback_back"});
	} else if(_thisCont.INTE_INFO["recog_data"]["appInfo"]["PREV_YN"] === "N"){
		iWebAction("closePopup");
	}else if((_thisCont.INTE_INFO["recog_data"]["Intent"] === 'ZNN002' || _thisCont.INTE_INFO["recog_data"]["Intent"] === 'ZNN005') && $("#detailModal").css("display")==="block"){ //영수증 팝업 show일 시
		$("#detailModal").hide();
	} else {
		iWebAction("closePopup",{_callback:"fn_popCallback2"});
	}
	//iWebAction("closePopup");
}