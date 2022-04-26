<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="jex.web.util.WebCommonUtil"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="com.avatar.session.SessionManager"%>
<%
	// 공통 Util생성
	WebCommonUtil util = WebCommonUtil.getInstace(request, response);

	// Action 결과 추출
	String inteInfo = StringUtil.null2void(request.getParameter("INTE_INFO"),"{}");
	String SAVE_FILE_LIST = StringUtil.null2void(request.getParameter("SAVE_FILE_LIST"),"[]");
	String PRE_INTENT = StringUtil.null2void(request.getParameter("PRE_INTENT"),"");
	
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
	 * @File Name        : ques_comm_11_view.jsp
	 * @File path        : AVATAR/web/view/jex/avatar/ques
	 * @author           : 하준태 (  )
	 * @Description      : 
	 * @History          : 20220331163213, 하준태
	 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_comm_11.js
	 * @JavaScript Url   : /js/jex/avatar/ques/ques_comm_11.js
	 * </pre>
	 **/
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>ASK AVATAR</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="user-scalable=yes, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width">
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
	<script type="text/javascript"
			src="/js/jex/avatar/ques/ques_comm_11.js?<%=_CURR_DATETIME%>2"></script>
</head>

<body class="bg_F5F5F5"><!-- (modify)20210622 -->
	<!-- content -->
	<div class="content" style="display: none;">
	</div>
	<!-- //content -->
</body>
</html>