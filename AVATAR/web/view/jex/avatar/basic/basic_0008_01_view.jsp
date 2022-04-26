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
 * @File Name        : basic_0008_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 김별 (  )
 * @Description      : FAQ 화면
 * @History          : 20210121101120, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0008_01.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0008_01.js
 * </pre>
 **/
%><!doctype html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title></title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="user-scalable=yes, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width">
	<%@include file="/view/jex/avatar/include/page_import_head.jsp"%>
	<script type="text/javascript" src="/js/jex/avatar/basic/basic_0008_01.js?<%=_CURR_DATETIME%>"></script>
	<style>
		dl dd img{
			max-width: 100%; height: auto;
		}
		.togle_list dd {
			    padding: 0px 15px 18px 15px !important;
		}
	</style>
</head>
<script type="text/javascript">
</script>
<body class="bg_F9F9F9">

	<!-- content -->
	<div class="content">

		<div class="m_cont"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<!-- 검색영역 style2 -->
			<div class="sch_bx2 type1">
				<div class="sch_bx_in">
					<span class="ico"></span>
					<input type="text" placeholder="검색어를 입력하세요." value="">
				</div>
			</div>
			<!-- //검색영역 style2 -->

			<!-- 컨텐츠 영역 -->
			<div class="togle_list type1">
				<dl class="on"> <!-- 열고/닫기 class="on" 제어 -->
					
				</dl>
			</div>
			<!-- //컨텐츠 영역 -->


			<!-- 컨텐츠 영역 -->
			<div class="notibx_wrap type2" style="display:none;">
				<div class="inner">
					<div class="ico ico4"></div>
					<div class="noti_tit">검색어와 일치하는 내용이 없습니다.</div>
				</div>
			</div>
			<!-- //컨텐츠 영역 -->

		</div>

	</div>
	<!-- //content -->

</body>
</html>