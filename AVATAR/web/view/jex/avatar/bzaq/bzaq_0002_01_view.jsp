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
 * @File Name        : bzaq_0002_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/bzaq
 * @author           : 김별 (  )
 * @Description      : 연락처 목록 화면
 * @History          : 20200213152738, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/bzaq/bzaq_0002_01.js
 * @JavaScript Url   : /js/jex/avatar/bzaq/bzaq_0002_01.js
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
    <script type="text/javascript" src="/js/jex/avatar/bzaq/bzaq_0002_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<style>
}

</style>
<body>
<!-- content -->
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<!-- 검색영역(검색 전) -->
			<div class="sch_bx avt data_y" style="padding-top: 9px;">
				<div class="sch_bx_in">
					<span class="ico" id="cmdSearch"></span>
					<input type="text" placeholder="검색어를 입력하세요." value="" class="SRCH_WD">
				</div>
			</div>
			<!-- //검색영역(검색 전) -->

			<!-- 검색영역(검색 후) -->
			<div class="sch_bx avt ipt" style="display:none;">
				<div class="sch_bx_in">
					<input type="text" placeholder="" value="주식회사">
					<a href="#none" class="btn_sch_del"></a>
				</div>
				<div class="sch_r"><a>취소</a></div>
			</div>
			<!-- //검색영역(검색 후) -->

			<div class="m_info_wrap data_y">
				<div class="m_info_bx line_list">
					<ul>
						<!-- <li><span class="txt">우리축산물</span><a class="btn phone"></a></li> -->
						<!-- <li><span class="txt">유니크</span><a class="btn phone"></a></li>
						<li><span class="txt">올리브영경기광주</span><a class="btn phone"></a></li>
						<li><span class="txt">스타벅스</span><a class="btn phone"></a></li>
						<li><span class="txt">태형인형</span><a class="btn phone"></a></li>
						<li><span class="txt">오케이상사</span><a class="btn phone"></a></li>
						<li><span class="txt">코코 주식회사</span><a class="btn phone"></a></li>
						<li><span class="txt">미가엘 정보통신</span><a class="btn phone"></a></li> -->
					</ul>
				</div>
			</div>
		<!-- 컨텐츠 영역 -->
			<div class="notibx_wrap type2 data_n" style="display:none;">
				<div class="inner">
					<div class="ico ico4"></div>
					<div class="noti_tit">연락처 데이터가 없습니다.</div>
				</div>
			</div>
			<!-- //컨텐츠 영역 -->
		</div>

		<!-- 마이크 버튼영역 -->
		
		<!-- //마이크 버튼영역 -->

	</div>
	<!-- //content -->

</body>
</html>