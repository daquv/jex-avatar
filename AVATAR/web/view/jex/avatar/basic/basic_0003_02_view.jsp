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
 * @File Name        : basic_0003_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/comm
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200529141340, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/comm/basic_0003_02.js
 * @JavaScript Url   : /js/jex/avatar/comm/basic_0003_02.js
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
    <script type="text/javascript" src="/js/jex/avatar/basic/basic_0003_02.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>

	<!-- content -->
	<div class="content">
		<div class="data_y">
		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<div class="cont_pd20">
				<!-- 리스트 박스형 -->
				<div class="list_gbx_w">
					<div class="inner">
						<p class="date"></p>
						<ul>
							<!-- <li><span class="tit">기업 691-014272-01-015</span><a class="btn_r"></a></li> -->
						</ul>
					</div>
				</div>
				<!-- //리스트 박스형 -->
			</div>

		</div>
		</div>
		
		<div class="data_n" style="display:none;">
		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			
			<!-- 컨텐츠 영역 -->
			<div class="notibx_wrap type2">
				<div class="inner">
					<div class="ico ico4"></div>
					<div class="noti_tit">질의에 대한 데이터가 없습니다</div>
					<div class="noti_cn2">
						데이터 가져오기 버튼을 탭하여<br>
						데이터 가져오기를 진행하여 주십시요
					</div>
				</div>
			</div>
			<!-- //컨텐츠 영역 -->

		</div>

		<!-- 버튼영역 -->
		<div class="btn_add">
			<a class="btn_s01">데이터 가져오기</a>
		</div>
		<!-- //버튼영역 -->
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