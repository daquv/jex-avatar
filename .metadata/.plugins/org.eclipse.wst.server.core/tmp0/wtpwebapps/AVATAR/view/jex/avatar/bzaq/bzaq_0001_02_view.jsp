<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String BZAQ_NO = StringUtil.null2void(request.getParameter("BZAQ_NO"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : bzaq_0001_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/bzaq
 * @author           : 김별 (  )
 * @Description      : 거래처 상세 조회
 * @History          : 20200211144539, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/bzaq/bzaq_0001_02.js
 * @JavaScript Url   : /js/jex/avatar/bzaq/bzaq_0001_02.js
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
    <script type="text/javascript" src="/js/jex/avatar/bzaq/bzaq_0001_02.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
<input type="hidden" id="BZAQ_NO" value="<%=BZAQ_NO%>" />
<!-- content -->
	<div class="content">

		<div class="m_cont m_cont_pd">
			<!-- 거래처상세 -->
			<div class="list_dv_wrap">
				<div class="list_dv_top">
					<div class="left">
						<span class="tit"></span>
					</div>
				</div>
				<div class="list_dv_cn b_btm">
					<!-- 상세정보 -->
					<div class="list_dv_tbl">
						<table>
							<colgroup><col style="width:100px;"><col></colgroup>
							<tbody>
								
							</tbody>
						</table>
					</div>
					<!-- //상세정보 -->

				</div>

			</div>
			<!-- //거래처상세 -->
		</div>
		
	</div>
	<!-- //content -->
	</body>
	</html>