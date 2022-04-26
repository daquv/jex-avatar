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
 * @File Name        : basic_0003_04_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200529155650, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0003_04.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0003_04.js
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
    <script type="text/javascript" src="/js/jex/avatar/basic/basic_0003_04.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
	<!-- content -->
	<div class="content">
		<div class="m_cont"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<div class="cont_pd20">
				<!-- 리스트 박스형 -->
				<div class="list_gbx_w type2">
					<div class="inner">
						<p class="date"></p>
						<ul>
							<li><span class="tit">(세금)계산서</span><a class="btn_r"></a> <a class="btn_add" style="display:none;">데이터 연결하기</a></li>
							<li><span class="tit">카드매입</span><a class="btn_r"></a> <a class="btn_add" style="display:none;">데이터 연결하기</a></li> 
							<li><span class="tit">현금영수증</span><a class="btn_r"></a> <a class="btn_add" style="display:none;">데이터 연결하기</a></li>
						</ul>
					</div>
				</div>
				<!-- //리스트 박스형 -->
			</div>
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