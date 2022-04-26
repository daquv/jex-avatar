<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String PAGE_DV = StringUtil.null2void(request.getParameter("PAGE_DV"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : basic_0009_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 박지은 (  )
 * @Description      : 경리나라 이용안내 화면
 * @History          : 20210325104540, 박지은
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0009_01.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0009_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/basic/basic_0009_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
<!-- content -->
<div class="content">
<% if("SERP".equals(PAGE_DV)) {%>
	<div>
		<!-- data connect -->
		<div class="ky_ws_wrap">
			<div class="inner">
				<div class="icoKy"></div><!-- (modify)20211022 -->
				<div class="ky_ws_tit">
					모바일에서 이용 가능합니다.
				</div>
				<div class="ky_ws_cn">
					<strong>경리나라 가입 문의</strong>
					<a href="tel:1670-3636">1670-3636</a>
				</div>
			</div>
		</div>
		<!-- //data connect -->
	</div>

	<!-- 버튼영역 -->
	<div class="btn_fix_botm btn_both type5">
		<div class="inner">
			<a href="#none" id="close_btn" class="btn_g40">닫기</a>
			<a href="#none" id="serp_btn" class="btn_b40">바로가기</a>
		</div>
	</div>
	<!-- //버튼영역 -->
<% } else if("ZEROPAY".equals(PAGE_DV)) {%>
	<div>
		<!-- data connect -->
		<div class="ky_ws_wrap">
			<div class="inner">
				<div class="icozP"></div>
				<div class="ky_ws_tit">
					제로페이 가맹점에서 이용해주세요!
				</div>
				<div class="ky_ws_cn">
					<strong>제로페이 가입 문의</strong>
					<a href="tel:1670-0582">1670-0582</a>
				</div>
			</div>
		</div>
		<!-- //data connect -->
	</div>

	<!-- 버튼영역 -->
	<div class="btn_fix_botm btn_both type5">
		<div class="inner">
			<a href="#none" id="close_btn" class="btn_g40">닫기</a>
			<a href="#none" id="zeropay_btn" class="btn_b41">바로가기</a>
		</div>
	</div>
	<!-- //버튼영역 -->
<% }%>
</div>

<!-- //content -->

</body>
</html>