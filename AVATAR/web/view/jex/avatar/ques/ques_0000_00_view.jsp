<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_0000_00_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200629100831, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0000_00.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0000_00.js
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
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_0000_00.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5">

<input type="hidden" class="CNT" id="BZAQ_CNT" value="">
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			
			<%//Admin에서 등록한 html 내용을 표시 할 영역 %>
			

		</div>

		<!-- 마이크 버튼영역 -->
		<!-- <div class="btn_fix_r">
			<a class="btn_mic"></a>
		</div> -->
		<!-- //마이크 버튼영역 -->
		
	</div>

	<!-- //content -->
</body>
</html>