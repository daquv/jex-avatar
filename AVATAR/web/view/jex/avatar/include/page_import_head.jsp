<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="jex.util.date.DateTime"%>
<%@page import="jex.sys.JexSystem"%>
<%
	String _CURR_DATETIME = DateTime.getInstance().getDate("yyyymmdd");
	
	if(JexSystem.getProperty("JEX.id").indexOf("_DEV") > -1){
		_CURR_DATETIME = DateTime.getInstance().getDate("yyyymmddhh24miss");
	}

%>
	<meta charset="UTF-8">
	<meta http-equiv="Cache-Control" content="No-Cache" />
	<meta http-equiv="Pragma" content="No-Cache" />

<%-- 	<link rel="stylesheet" href="/css/swiper.min.css?<%=_CURR_DATETIME%>" /> --%>
	<link rel="stylesheet" href="/css/swipper.css?<%=_CURR_DATETIME%>" />
	<link rel="stylesheet" href="/css/avatar.css?<%=_CURR_DATETIME%>" />
	<link rel="stylesheet" type="text/css" href="/css/jquery.mCustomScrollbar.css?<%=_CURR_DATETIME%>" />
<%-- 	<link rel="stylesheet" href="/css/style.css?<%=_CURR_DATETIME%>" /> --%>
<%-- 	<link rel="stylesheet" type="text/css" href="/css/calendar.css?<%=_CURR_DATETIME%>" /> --%>
<%-- 	<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css?<%=_CURR_DATETIME%>"/> --%>
<%-- 	<link rel="stylesheet" type="text/css" href="/css/jquery-ui-1.8.16.custom.css?<%=_CURR_DATETIME%>" /> --%>
	<script type="text/javascript" src="/js/jqueryPlugin/jquery-1.8.3.min.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/jqueryPlugin/jquery.picker.min.js?<%=_CURR_DATETIME%>"></script> 
	<script type="text/javascript" src="/js/jqueryPlugin/swiper-bundle.min.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/jqueryPlugin/jquery-1.8.1.min.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/jqueryPlugin/jquery.inherit-1.3.2.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/jqueryPlugin/jquery.cookie.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/jqueryPlugin/jquery.modal.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/jqueryPlugin/jquery.maskedinput.min.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/jqueryPlugin/jquery-ui-1.11.0.min.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/jqueryPlugin/jquery.livequery.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/jqueryPlugin/jquery.ui.datepicker-ko.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/jqueryPlugin/jquery.mCustomScrollbar.concat.min.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/jqueryPlugin/jquery.placeholder.min.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/jqueryPlugin/publishing.ui.library.1.0.0.js?<%=_CURR_DATETIME%>"></script>

	<script type="text/javascript" src="/js/jexPlugin/jex.core.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/jexPlugin/jex.calendar.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/jexPlugin/jex.div.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/jexPlugin/jex.loading.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/jexPlugin/jex.formatter.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/jexPlugin/jex.msg.js?<%=_CURR_DATETIME%>"></script>

	<script type="text/javascript" src="/js/lib/json2.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/lib/toastr.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/lib/moment.min.js?<%=_CURR_DATETIME%>"></script>
	<script src="/js/comm/avatar.common.js?<%=_CURR_DATETIME%>"></script>
	
	<style>
/* 	a { -webkit-tap-highlight-color:transparent;} */
	</style>
	
	<script>
	$(window.document).on("contextmenu" , function(event){return false;});	//우클릭방지
	$(window.document).on("selectstart" , function(event){return false;});	//더블클릭을 통한 선택방지
	$(window.document).on("dragstart"	, function(event){return false;});	//드래그
	
	function getUserAgent() {
		var agent = navigator.userAgent.toLowerCase();
		if (agent.indexOf("iphone") > -1 || agent.indexOf("ipad") > -1
				|| agent.indexOf("ipod") > -1) {
			return "ios";
		} else if (agent.match('android') != null) {
			return "android";
		} else {
			return "pc";
		}
	}
	
	function iWebAction(actionCode, actionData) {
		
		console.log("iWebAction : " + actionCode + " ::: " + JSON.stringify(actionData));
		
		var action = {
			_action_code : actionCode
		};
		if (actionData == null || actionData == undefined) {
		} else {
			action._action_data = actionData;
		}
		
		// value에 &이 들어올 경우 오류가 발생할수 있음. 오류나는 인텐트는 예외처리해야됨.(거래처이름에 "&"이 들어가있으면 split오류남.)
		if(actionCode == "openPopup"){
			var url = actionData._url;
			
			//if(url.indexOf("NE-COUNTERPARTNAME") < 0 && url.indexOf("NE-FRANCHISENAME") < 0 ){
			if(url.indexOf("NE-COUNTERPARTNAME") < 0){
				if(url.indexOf("?") > -1){
					var idx = url.indexOf("?");
					var urlT = "";
					var paramT = "";
					
					urlT = url.substring(0, idx);
					paramT = url.substring(idx+1, url.length);
					
					var urlParamArr = paramT.split("&");
					
					var encUrl = ""; 
					for(var i=0; i< urlParamArr.length; i++){
						var urlParamValArr = urlParamArr[i].split("=");
						encUrl += urlParamValArr[0]+"="+encodeURIComponent(urlParamValArr[1]);
						if(i != urlParamArr.length-1){
							encUrl += "&";
						}
					}
					/*
					if(urlParamArr.length == 0){
						var urlParamValArr = paramT.split("=");
						encUrl += urlParamValArr[0]+"="+encodeURIComponent(urlParamValArr[1]);
					}
					*/
					encUrl = urlT+"?"+encUrl;
					actionData._url = encUrl;
					console.log("encUrl :"+encUrl);
				}
			}
		}
		
		if (getUserAgent() == "ios") {
			alert("iWebAction:" + JSON.stringify(action));
		} else if (getUserAgent() == "android") {
			window.BrowserBridge.iWebAction(JSON.stringify(action));
		}else{
			if(actionCode == "popup_webview"){
				location.href = actionData._url;
			}
		}
	}
	
	//Native Back 버튼 선택
	/* function fn_back(){
		//history.back();
	} */
	
	//음성인식 결과 전달
	function fn_voice_recog(data){
		alert("음성인식 결과 : " + data);
	}
	
	//마이크 표시여부
	try{
		var _micYn = "N";
		var _micViews = "ques_";
		//_micViews += "|basic_";
		_micViews += "|basic_0009_02";
		
		var _nomicViews =  "|ques_0001_03";
		_nomicViews += "|ques_0001_04";
		_nomicViews += "|ques_0001_05";
		_nomicViews += "|ques_0013_02";
		_nomicViews += "|ques_0001_08";
		
		//사용 X
		/* _micViews += "|acct_0002_01";_micViews += "|tax_0003_01";_micViews += "|tax_0003_02";_micViews += "|card_0001_01";_micViews += "|tax_0005_01";_micViews += "|tax_0003_02";_micViews += "|card_0002_01";_micViews += "|tax_0006_01";_micViews += "|bzaq_0001_01";_micViews += "|bzaq_0001_02";_micViews += "|bzaq_0002_01";_micViews += "|bzaq_0002_02"; */
		
		if(location.href.match(_micViews).index > 0){
			_micYn = "Y";
		}
		if(location.href.match("ques_0001_03") || location.href.match("ques_0001_04") || location.href.match("ques_0001_05") || location.href.match("ques_0013_02") || location.href.match("ques_0001_08") || location.href.match("ques_0001_06") || location.href.match("ques_0001_07")){
			_micYn = "N";
		}
		var _noWebAction = /(ques_0000_0[5-7]|ques_comm_10|ques_0001_09)/g;
		if(location.href.match(_noWebAction)) {
		} else {
			iWebAction("fn_display_mic_button",{"_display_yn":_micYn});			
		}
		
	}catch(e){}
	
	//세무사 연결 
	var chrg_nm='', chrg_tel_no='', biz_no='', seq_no='';
	var _txofList = [];
	$(function(){
		$(document).on("click", "#modal1 .btn_both a:eq(0)", function(){
			//세무사 연결 x
			$("#modal1").remove();
			$("body").append(_modal.fn_makeModal2());
		})
		$(document).on("click", "#modal1 .btn_both a:eq(1)", function(){
			//세무사 연결 o - tel_link_cnt 
			_modal.fn_updateCnt();
		})
		$(document).on("click", "#modal2 .btn_both a:eq(0)", function(){
			$("#modal2").remove();
		})
		$(document).on("click", "#modal2 .btn_both a:eq(1)", function(){
			iWebAction("getAppData",{"_key" : "_txofInfm", "_call_back" : "fn_gettxoflist"});
			setTimeout(function() {
				var reformattedTxofList = _txofList.map(function(obj){
					return obj.chrg_tel_no;
				});
				//다른 세무사 추천
				var pageUrl = "ques_comm_01.act?";
				var pageParam = "INTE_INFO={'recog_txt':'세무사 목록','recog_data':{'Intent':'NNN020','appInfo':{'TXOF_LIST':'"+encodeURIComponent(JSON.stringify(reformattedTxofList))+"'}}}";
				iWebAction("openPopup",{"_url":pageUrl, "_param" : pageParam});
				
				$("#modal2").remove();
			}, 500)
			
		})
	});
	
	function fn_app_foreground(){
		iWebAction("getAppData",{"_key" : "_isPhoneCall", "_call_back" : "isPhoneCall"});
		iWebAction("getAppData",{"_key" : "_temp_txofInfm", "_call_back" : "fn_getTemp"});
		//iWebAction("getAppData",{"_key" : "_txofInfm", "_call_back" : "fn_gettxoflist"});
		setTimeout(function() {
			if(_isPhoneCall ==="true"){
				$("body").append(_modal.fn_makeModal1());
				iWebAction("setAppData",{"_key" : "_isPhoneCall", "_value" : "false"});
				iWebAction("setAppData",{"_key" : "_temp_txofInfm", "_value" : ""});
			}
		}, 750);
	}
	function isPhoneCall(data){
		_isPhoneCall = data;
	}
	function fn_getTemp(data){
		//alert('temp :: ' + decodeURIComponent(data));
		data = JSON.parse(decodeURIComponent(data));
		if(Object.keys(data).length > 0){
			chrg_nm		 = data.chrg_nm;
			chrg_tel_no	 = data.chrg_tel_no;
			biz_no		 = data.biz_no;
			seq_no		 = data.seq_no;
		}
		_temp_txofInfm = data;
	}
	
	function fn_gettxoflist(data){
		avatar.common.null2void(data)==""?_txofList = []:_txofList = decodeURIComponent(data);
		if(typeof(_txofList) === "string") _txofList=JSON.parse(_txofList);
		_txofList.push(_temp_txofInfm);
		iWebAction("setAppData",{"_key" : "_txofInfm", "_value" : encodeURIComponent(JSON.stringify(_txofList))});
	}
	let _modal = {
			fn_makeModal1 : function() {
				var modal1 = ''
				modal1+='<div class="modaloverlay" id="modal1">';
				modal1+='	<div class="lytb"><div class="lytb_row"><div class="lytb_td"><div class="layer_style1">';
				modal1+='		<div class="layer_po">';
				modal1+='			<div class="cont">';
				modal1+='				<div class="ic_taxAcc_connc"></div>';
				modal1+='				<p class="lyp_tit">';
				modal1+='					<span id="">'+chrg_nm+'</span> 세무사와<br>통화 연결이 되었나요?';
				modal1+='				</p>';
				modal1+='			</div>';
				modal1+='		</div>';
				modal1+='		<div class="ly_btn_fix_botm btn_both"><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->';
				modal1+='			<a href="#none" class="off rows2" id="modal1_off">전화 연결<br>되지 않았어요</a>';
				modal1+='			<a href="#none" id="modal1_on">전화를 잘 마쳤어요</a>';
				modal1+='		</div>';
				modal1+='	</div></div></div></div>';
				modal1+='</div>';
				return modal1;
			},
			fn_makeModal2 : function() {
				var modal2 = '';
				modal2+='<div class="modaloverlay" id="modal2">';
				modal2+='	<div class="lytb"><div class="lytb_row"><div class="lytb_td"><div class="layer_style1">';
				modal2+='		<div class="layer_po">';
				modal2+='			<div class="cont">';
				modal2+='				<div class="ic_taxAcc_connc"></div>';
				modal2+='				<p class="lyp_tit">다른 세무사 연결을<br>도와드릴까요?</p>';
				modal2+='			</div>';
				modal2+='		</div>';
				modal2+='		<div class="ly_btn_fix_botm btn_both"><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->';
				modal2+='			<a href="#none" class="off" id="modal2_off">아니오</a>';
				modal2+='			<a href="#none" id="modal2_on">네</a>';
				modal2+='		</div>';
				modal2+='	</div></div></div></div>';
				modal2+='</div>';
				return modal2;
			},
			fn_updateCnt : function(){
				var input = {};
				input["CHRG_TEL_NO"] = chrg_tel_no;
				input["BIZ_NO"] = biz_no;
				input["SEQ_NO"] = seq_no;
				avatar.common.callJexAjax("ques_comm_01_u003", input, _modal.fn_callback, "false", "");
			},
			fn_callback : function(data){
				if(data.RSLT_CD == "0000"){
					$("#modal1").remove();
				} else {
					alert("ERROR OCCURRED. PLEASE CONTACT CUSTOMER SERVICE.");
					
				}
			}
			
	}

	//-----------------------TEST
	
	</script>