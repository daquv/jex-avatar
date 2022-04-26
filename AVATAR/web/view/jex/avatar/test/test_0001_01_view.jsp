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
 * @File Name        : test_0001_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/test
 * @author           : 신승환 (  )
 * @Description      : 
 * @History          : 20200115085653, 신승환
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/test/test_0001_01.js
 * @JavaScript Url   : /js/jex/avatar/test/test_0001_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/test/test_0001_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
<div id="wrap">
	<div class="header">
		<a class="btn back left" href="">뒤로가기</a>
		<h1>TEST</h1>
		<a class="btn home right" href="">홈</a>
	</div>
	<div class="grey_area container">
		<div>
			<ul class="card_list">
				<li>
					<div class="card_list_box">
						<h2 class="card_name">테스트</h2>
						<div class="card_info">
							<p>Admin에서 등록한 카드 상세 정보가 노출됩니다</p>
							<p>Admin에서 등록한 카드 상세 정보가 노출됩니다</p>
						</div>
					</div>
				</li>
			</ul>
			<div class="btn_more">
				<a href="javascript:void(0);">더보기</a>
			</div>
		</div>
	</div>
</div>
</body>
</html>