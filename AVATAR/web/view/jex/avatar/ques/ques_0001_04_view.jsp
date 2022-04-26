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
 * @File Name        : ques_0001_04_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김별 (  )
 * @Description      : 배너_아바타 잘 쓰는 법
 * @History          : 20210325173011, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0001_04.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0001_04.js
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
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_0001_04.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5"><!-- (modify)20210323 -->

<!-- content -->
<div class="content">

	<div class="m_cont pdt12">
		<div class="chat_wrap">
			<div class="tit">
				<h2>
					우리 회사 경영정보, 이제 언제 어디서든 <strong class="diInlineBlock c_357EE7">ASK AVATAR</strong>가 바로 알려드릴게요!
				</h2>
			</div>
			<div class="chat_detail">
				<img src="../img/im_chat1.png" alt="">
			</div>
			<div class="chat_detail">
				<img src="../img/im_chat2.png" alt="">
			</div>
			<div class="chat_detail">
				<img src="../img/im_chat3.png" alt="">
			</div>
		</div>
	</div>

</div>
<!-- //content -->

</body>
</html>