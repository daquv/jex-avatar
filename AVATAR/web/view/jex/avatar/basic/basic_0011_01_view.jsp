<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    //GET SESSION
	JexDataCMO UserSession = SessionManager.getSession(request, response);
    String APP_ID = StringUtil.null2void((String)UserSession.get("APP_ID"));
    String LGIN_APP = StringUtil.null2void((String)UserSession.get("LGIN_APP"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : basic_0011_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20210617103025, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0011_01.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0011_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/basic/basic_0011_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<style>
	a {
	-webkit-tap-highlight-color: rgba(0,0,0,0);
	-webkit-tap-highlight-color: transparent;
	},
</style>
<script>
	var _APP_ID = '<%=APP_ID%>';
	var LGIN_APP = '<%=LGIN_APP%>';
</script>
<body class="bg_F5F5F5">

<!-- content -->
<div class="content">

	<div class="m_cont pdt12">
		<div class="m_bx_wrap">
			<!-- 리스트 영역 -->
			<div class="m_prp_list type3">
				<ul>
					<li>
						<h2 class="prp05">음성 받기</h2>
						<div class="right">
							<a href="#none" class="btn_switch on"><span class="blind">활성</span></a>
							<!--<a href="#none" class="btn_switch"><span class="blind">비활성</span></a>-->
						</div>
					</li>
				</ul>
				<p class="desTxt">아바타앱에서 질의한 답변을 음성으로 받아볼 수 있어요!</p>
			</div>
			<!-- //리스트 영역 -->
		</div>
	</div>

</div>
<!-- //content -->
</body>

</html>
