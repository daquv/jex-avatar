<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    JexDataCMO UserSession = SessionManager.getSession(request, response);
    String APP_ID = StringUtil.null2void((String)UserSession.get("APP_ID"));
    String MENU_DV = StringUtil.null2void(request.getParameter("MENU_DV"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : basic_0009_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20210401143053, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0009_02.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0009_02.js
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
	<script type="text/javascript" src="/js/jex/avatar/basic/basic_0009_02.js?<%=_CURR_DATETIME%>"></script>
	<script>
    var _APP_ID = '<%=APP_ID%>';
    var MENU_DV = '<%=MENU_DV%>';
	</script>
</head>
<body class="bg_F5F5F5">
	<!-- content -->
	<div class="content">

		<!-- (modify)20210323 -->
		<div class="m_cont"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			<!-- 컨텐츠 영역 -->
			<div class="notibx_wrap type5">
				<% if("NATIVE".equals(MENU_DV)) {%>
					<div class="inner" style="min-height:0;padding-bottom:30px;">
						<span data-type="" id="RESULT_TTS" style="display:none;">
							이렇게 물어보세요
						</span>
						<div class="ico ico8"></div>
						<div class="noti_tit">
							이렇게 물어보세요!
						</div>
						<div class="noti_cn2">
						"전화 걸어줘"<br>
						"문자 보내줘"
						</div>
					</div>
				<% } else {%>
					<div class="inner" style="min-height:0;padding-bottom:30px;">
						<span data-type="" id="RESULT_TTS" style="display:none;">
							보다 나은 서비스를 위해 답변을 준비하고 있어요. 답변이 준비되면 알려드릴게요.
						</span>
						<div class="ico ico8"></div>
						<div class="noti_tit">
						서비스를 준비중입니다.
						</div>
						<div class="noti_cn2">
						보다 나은 서비스 제공을 위하여<br>
						준비중에 있습니다.
						</div>
					</div>
				<% } %>
			</div>
			<!-- //컨텐츠 영역 -->
		</div>
		<!-- //(modify)20210323 -->
	</div>
	<!-- //content -->

</body>
</html>