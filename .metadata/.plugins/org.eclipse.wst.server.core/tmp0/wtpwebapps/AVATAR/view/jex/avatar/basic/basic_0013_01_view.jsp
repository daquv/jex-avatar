<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>

<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String MENU_DV = StringUtil.null2void(request.getParameter("MENU_DV"));
    
    //GET SESSION
    JexDataCMO UserSession = SessionManager.getSession(request, response);
    String CLPH_NO = StringUtil.null2void((String)UserSession.get("CLPH_NO"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : basic_0013_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20210730134419, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0013_01.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0013_01.js
 * </pre>
 **/
%>
<!doctype html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title></title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="user-scalable=yes, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width">
	<%@include file="/view/jex/avatar/include/page_import_head.jsp"%>
	<script type="text/javascript" src="/js/jex/avatar/basic/basic_0013_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<script type="text/javascript">
	var MENU_DV = '<%=MENU_DV%>';
	var CLPH_NO = '<%=CLPH_NO%>';
</script>
<body class="bg_F5F5F5">

<!-- content -->
<div class="content">

	<div class="m_cont"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
		<div class="ques_Bx">
			<div class="ques_Bx_in">
				<!-- <dl>
					<dt>
						<div class="tit">6월 29일</div>
					</dt>
					<dd>
						<div class="ques_Bx_cn">
							<ul>
								<li>
									<div class="left">
										<p>“오늘 매출액은?”</p>
									</div>
								</li>
								<li>
									<div class="left">
										<p>“오늘 잔고는?”</p>
									</div>
								</li>
							</ul>
						</div>
					</dd>
				</dl>
				 -->
			</div>
		</div>
		<!-- //질문 모아보기 -->
	</div>

</div>
<!-- //content -->

</body>
</html>