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
 * @File Name        : ques_0001_06_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 박지은 (  )
 * @Description      : 배너_배달앱매출
 * @History          : 20210819144534, 박지은
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0001_06.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0001_06.js
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
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_0001_06.js?<%=_CURR_DATETIME%>"></script>
</head>

<body>

<!-- content -->
<div class="content pdb0">

	<div class="m_cont">
		<div class="s_chat">
			<div class="s_titBx bg_upInfo">
				<div class="tit_wrap detailView">
					<h2>업데이트 안내</h2>
				</div>
			</div>
			<div class="sect_chat">
				<div class="sect_inn pdt35 pdb0">
					<div class="tit_chat">
						<span class="num">01</span>
						<div class="tit">
							<div class="tit_wrap detailView">
								<h2>배달앱 매출만 확인하고 싶을 때</h2>
							</div>
							<div class="desc">
								<p class="tal">이렇게 물어보세요.</p>
							</div>
						</div>
					</div>
					<div class="chat_im">
						<img src="../img/im_chat_01.png" alt="">
					</div>
				</div>
			</div>
			<div class="sect_chat bg_F5F5F5">
				<div class="sect_inn pdt35 pdb0">
					<div class="tit_chat">
						<span class="num">02</span>
						<div class="tit">
							<div class="tit_wrap detailView">
								<h2 class="type2">바로 연락하고 싶을 때</h2>
							</div>
							<div class="desc">
								<p class="tal">이렇게 물어보세요.</p>
							</div>
						</div>
					</div>
					<div class="chat_im">
						<img src="../img/im_chat_02.png" alt="">
					</div>
				</div>
			</div>
			<div class="sect_chat">
				<div class="sect_inn pdt35 pdb0">
					<div class="tit_chat">
						<span class="num">03</span>
						<div class="tit">
							<div class="tit_wrap detailView">
								<h2>세무전문가의 도움이 필요할 때</h2>
							</div>
							<div class="desc">
								<p class="tal">이렇게 물어보세요.</p>
							</div>
						</div>
					</div>
					<div class="chat_im">
						<img src="../img/im_chat_03.png" alt="">
					</div>
				</div>
			</div>
			<div class="sect_chat bg_F5F5F5" style="display: none;">
				<div class="sect_inn pdt35 pdb0">
					<div class="tit_chat">
						<span class="num">04</span>
						<div class="tit">
							<div class="tit_wrap detailView">
								<h2 class="type2">저번에 물어본 질문이 생각나지 않을 때</h2>
							</div>
							<div class="desc">
								<p class="tal">이렇게 확인하세요.</p>
							</div>
						</div>
					</div>
					<div class="chat_im">
						<img src="../img/im_chat_04.png" alt="">
					</div>
				</div>
			</div>
		</div>
	</div>

</div>
<!-- //content -->

</body>
</html>