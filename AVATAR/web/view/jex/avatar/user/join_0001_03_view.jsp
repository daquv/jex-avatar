<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String CUST_NM = StringUtil.null2void(request.getParameter("CUST_NM"));
    String CLPH_NO = StringUtil.null2void(request.getParameter("CLPH_NO"));
    String CUST_CI = StringUtil.null2void(request.getParameter("CUST_CI"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : join_0001_03_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/user
 * @author           : 김별 (  )
 * @Description      : 회원가입_가입완료화면
 * @History          : 20200129100814, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/user/join_0001_03.js
 * @JavaScript Url   : /js/jex/avatar/user/join_0001_03.js
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
    <script type="text/javascript" src="/js/jex/avatar/user/join_0001_03.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
<input type="hidden" id="CUST_NM" value="<%=CUST_NM%>" />
<input type="hidden" id="CLPH_NO" value="<%=CLPH_NO%>" />
<input type="hidden" id="CUST_CI" value="<%=CUST_CI%>" />
<!-- content -->
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<!-- 상단문구 -->
			<div class="notibx_wrap type2">
				<div class="inner">
					<div class="ico join"></div>
					<div class="join_tit">가입이 완료되었습니다.</div>
					<div class="join_stit">데이터를 연결하고 <br>이제 우리회사 경영정보를<br>아바타에게 물어보세요.</div>
				</div>
			</div>
			<!-- //상단문구 -->

		</div>

		<!-- 상단 닫기버튼 -->
		<div class="btn_fix_topr">
			<a>닫기</a>
		</div>
		<!-- //상단 닫기버튼 -->

		<!-- 하단 fix버튼 -->
		<div class="btn_fix_botm">
			<div class="inner">
				<a>확인</a>
			</div>
		</div>
		<!-- //하단 fix버튼 -->

	</div>
	<!-- //content -->
</body>
</html>