<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    String inteInfo = StringUtil.null2void(request.getParameter("INTE_INFO"),"{}");
    
    //GET SESSION
    JexDataCMO UserSession = SessionManager.getSession(request, response);
    String _APP_ID = StringUtil.null2void((String)UserSession.get("APP_ID"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_0014_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김별 (  )
 * @Description      : 질의_메모해줘
 * @History          : 20211001083718, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0014_02.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0014_02.js
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
	var _APP_ID = '<%=_APP_ID%>';
</script>
<script type="text/javascript" src="/js/jex/avatar/ques/ques_0014_02.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5"><!-- (modify)20210729 -->

<!-- content -->
<div class="content">

	<div class="m_cont pdt12">
		<!-- 메모 -->
		<div class="memoSaveBx">
			<div class="memoSaveBx_inn">
				<dl>
					<dt class="h41"><img src="../img/ico_memo1.png" alt="메모"></dt>
					<dd>
						<p>
							어떤 내용으로 메모할까요?
						</p>
					</dd>
				</dl>
			</div>
		</div>
		<!-- //메모 -->
	</div>

</div>
<!-- //content -->

</body>
</html>