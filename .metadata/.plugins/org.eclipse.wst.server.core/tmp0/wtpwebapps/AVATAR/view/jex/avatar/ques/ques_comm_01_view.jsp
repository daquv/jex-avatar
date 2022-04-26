<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%@page import="com.avatar.session.SessionManager"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
//	JexData result = util.getResultData();
//	String html = StringUtil.null2void(result.getString("HTML")); 
	String inteInfo = StringUtil.null2void(request.getParameter("INTE_INFO"),"{}");
	String SAVE_FILE_LIST = StringUtil.null2void(request.getParameter("SAVE_FILE_LIST"),"[]");
	String PRE_INTENT = StringUtil.null2void(request.getParameter("PRE_INTENT"),"");
	//test data
 	/* String inteInfo = "{\"recog_txt\":\"매출 데이타 ?\", \"recog_data\":{\"Intent\":\"ASP001_PRE\",\"appInfo\":{\"NE-DAY\":\"\", \"NE-COUNTERPARTNAME\" :\"비즈플레이\"}} }"; */ 
 	
	//GET SESSION
	JexDataCMO UserSession = SessionManager.getSession(request, response);
    String APP_ID = StringUtil.null2void((String)UserSession.get("APP_ID"));
    String LGIN_APP = StringUtil.null2void((String)UserSession.get("LGIN_APP"));
	String USE_INTT_ID = StringUtil.null2void((String)UserSession.get("USE_INTT_ID"));
    String sCLPH_NO = StringUtil.null2void((String)UserSession.get("CLPH_NO"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_comm_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 신승환 (  )
 * @Description      : 
 * @History          : 20200309143043, 신승환
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_comm_01.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_comm_01.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width">
    <meta name="format-detection" content="telephone=no">
    <title></title>
    <%@include file="/view/jex/avatar/include/page_import_head.jsp"%>
    <script>
    var inteInfo = <%=inteInfo%>;
	var _thisCont = {
		PAGE_NO : 1,
		PAGE_CNT : 25,
		INTE_INFO : <%=inteInfo%>,
		SAVE_FILE_LIST : <%=SAVE_FILE_LIST%>,
	}
	var _APP_ID = '<%=APP_ID%>';
	var _USE_INTT_ID = '<%=USE_INTT_ID%>';
	var CLPH_NO = '<%=sCLPH_NO%>';
	var PRE_INTENT = '<%=PRE_INTENT%>';
	let LGIN_APP = '<%=LGIN_APP%>';
	</script>
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_comm_01.js?<%=_CURR_DATETIME%>1"></script>
</head>
<body>
<!-- content -->
<input type="hidden" id="sCLPH_NO" value="<%=sCLPH_NO%>">
<input type="hidden" class="CNT" id="ACCT_CNT" value="">
<input type="hidden" class="CNT" id="TAX_CNT" value="">
<input type="hidden" class="CNT" id="TAX2_CNT" value=""> <!-- 세액내역 -->
<input type="hidden" class="CNT" id="CASH_CNT" value="">
<input type="hidden" class="CNT" id="SALE_CNT" value="">
<input type="hidden" class="CNT" id="CARD_CNT" value="">
<input type="hidden" class="CNT" id="SNSS_CNT" value="">
<input type="hidden" class="CNT" id="_BZAQ_CNT" value="">
<input type="hidden" class="CNT" id="_MEST_CNT" value="">
<input type="hidden" id="BZAQ_REC">
	<div class="content" style="display:none;" >
		<!-- (modify)20210517 -->
		<div class="m_cont loading_bx" id="REALTIME" style="display:none;"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			<dl>
				<dt>
					<div class="lds-spinner"><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div></div>
				</dt>
				<dd>
					<span>데이터 처리중 입니다.</span>
					<span>잠시만 기다려주세요.</span>
				</dd>
			</dl>
		</div>
		<div class="m_cont pdt12" id="MAIN" style="display:none;"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			<%//Admin에서 등록한 html 내용을 표시 할 영역 %>
			

		</div>
	</div>
	<!-- //content -->
<!-- webResultTTS :: <span style="display:none;" id="DEV_TEST"></span> -->

	<!-- modal overlay -->
	<div class="modaloverlay" style="display:none;" id="cert_modal">
		<div class="lytb"><div class="lytb_row"><div class="lytb_td">
		<!-- layerpopup -->
		<div class="layer_style3">
			<div class="layer_po">
				<div class="cont">
					<p class="lyp_txt1">
						최신 데이터가 아닌 경우<br>
					공동인증서 또는 계좌를 <strong>업데이트</strong>해주세요.
					</p>
				</div>
			</div>
			<div class="ly_btn_fix_botm type1"><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->
				<a href="#none" onclick="certClose1()">확인</a>
			</div>
		</div>
		<!-- //layerpopup -->
		</div></div></div>
	</div>
	<!-- //modal overlay -->
	
	<!-- modal overlay -->
	<div class="modaloverlay" style="display:none;" id="snss_modal">
		<div class="lytb"><div class="lytb_row"><div class="lytb_td">
		<!-- layerpopup -->
		<div class="layer_style3">
			<div class="layer_po">
				<div class="cont">
					<p class="lyp_txt1">
						<strong>요기요는 1개</strong> 사업장 정산내역만<br>
						조회 가능합니다<br>
						사업자번호 : <strong id="compno">000-0000-000</strong>
					</p>
				</div>
			</div>
			<div class="ly_btn_fix_botm type1"><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->
				<a href="#none" onclick="snssClose()">확인</a>
			</div>
		</div>
		<!-- //layerpopup -->
		</div></div></div>
	</div>
	<!-- //modal overlay -->
</body>
</html>