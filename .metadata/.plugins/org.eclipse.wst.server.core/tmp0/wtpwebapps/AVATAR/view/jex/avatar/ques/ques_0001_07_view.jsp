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
 * @File Name        : ques_0001_07_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 박지은 (  )
 * @Description      : 배너_아바타잘쓰는법
 * @History          : 20210819144731, 박지은
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0001_07.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0001_07.js
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
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_0001_07.js?<%=_CURR_DATETIME%>"></script>
</head>

<body>

<!-- content -->
<div class="content pdb0">

	<div class="m_cont">
		<div class="s_chat">
			<div class="s_titBx type2 bg_caseAsk">
				<div class="tit_wrap detailView">
					<h2 class="type2">이럴 때, 이렇게 물어보세요</h2>
				</div>
			</div>
			<div class="sect_caseAsk">
				<div>
					<div class="imBx">
						<img src="../img/im_case_ask.png" alt="">
					</div>
				</div>
			</div>
			<div class="sect_chat">
				<div class="sect_inn">
					<p>상황에 따라, 이렇게 사용해보세요</p>
					<div class="tit_chat">
						<h3>매출확인하기</h3>
					</div>
					<div class="chat_im mgt25">
						<img src="../img/im_chat_05.png" alt="">
					</div>
				</div>
			</div>
			<div class="sect_chat bg_F5F5F5">
				<div class="sect_inn">
					<div class="tit_chat">
						<h3>세금납부하기</h3>
					</div>
					<div class="chat_im mgt25">
						<img src="../img/im_chat_06.png" alt="">
					</div>
				</div>
			</div>
			<div class="sect_chat bg_793FFB">
				<div class="sect_inn labelBar">
					<p>
						<span>일하는 사람들을 위한 AI비서</span>
						에스크아바타
					</p>
				</div>
			</div>
		</div>
	</div>

	<!-- 연결하기 버튼 fixed -->

	<!--// 연결하기 버튼 fixed -->

</div>
<!-- //content -->

</body>
</html>