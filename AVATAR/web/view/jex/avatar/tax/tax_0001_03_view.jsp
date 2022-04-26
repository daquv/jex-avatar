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
 * @File Name        : tax_0001_03_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/tax
 * @author           : 박지은 (  )
 * @Description      : 홈텍스실시간조회 화면(세액내역)
 * @History          : 20210520165516, 박지은
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/tax/tax_0001_03.js
 * @JavaScript Url   : /js/jex/avatar/tax/tax_0001_03.js
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
	<script type="text/javascript" src="/js/jex/avatar/tax/tax_0001_03.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
	<!-- content -->
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			<!-- 컨텐츠 영역 -->
			<div class="notibx_wrap type2">
				<div class="inner fixH2">
					<div class="ico ico_ipr01"></div>
					<div class="noti_tit">
						홈택스에서<br>
						<span class="c_blue">납부할 세액 내역</span><br><!-- (modify)20210521 -->
						데이터를 가져옵니다.
					</div>
					<div class="noti_txt">
						* 데이터 연결 이후 10분 뒤에 서비스 이용이 가능하며,<br>
						다음날 부터는 자동으로 업데이트 됩니다.
					</div>
					<div class="noti_txt">
					<!-- 
						초기 연결 후 다음날 부터는<br>
						<span class="c_blue">자동으로 새벽</span>에 데이터를 <span class="c_blue">업데이트</span>합니다.
					-->
					</div>
				</div>
			</div>
			<!-- //컨텐츠 영역 -->
		</div>

		<!-- 하단 fix버튼 -->
		<div class="btn_fix_botm">
			<div class="inner">
				<a id="a_enter">확인</a>
			</div>
		</div>
		<!-- //하단 fix버튼 -->
	</div>
	<!-- //content -->

</body>
</html>