<%@page import="com.avatar.session.AdminSessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="java.net.URLDecoder"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
	String _sLocalTime_comm = DateTime.getInstance().getDate("yyyymmddhh24miss");
                        
    // Action 결과 추출
    String QUES_CTT = StringUtil.null2void(request.getParameter("QUES_CTT"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : plfm_0101_04_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/plfm
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200710112316, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/plfm/plfm_0101_04.js
 * @JavaScript Url   : /js/jex/avatar/admin/plfm/plfm_0101_04.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title></title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/admin/js/include/smart.grid.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript" src="/js/jex/avatar/admin/plfm/plfm_0101_04.js?<%=_sLocalTime_comm %>"></script>
</head>
<body>
	<div class="pop_wrap" style="width:650px;">
		<!-- 팝업 컨텐츠 -->
		<div class="pop_container">
		<!-- 상단 타이틀/버튼 -->
			<div class="title_wrap">
				<div class="left">
					<h1>회사검색</h1>
				</div>
			</div>
				<!-- //상단 타이틀/버튼 -->
			<!-- 검색테이블 -->
			<div class="table_wrap mgb10">
				<div class="tbl_srch">
					<table class="">
						<caption></caption>
						<colgroup>
							<col style="width:85px;">
							<col style="width:500px;">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row"><div>검색</div></th>									
								<td><div><input type="text" placeholder="회사명" style="width:200px;" id="SRCH_WD"></div></td>
								<td><div><span style="float:right"><a href="#none" class="btn_search_tb" id=""><span>조회</span></a></span></div></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<!-- //검색테이블 -->
			
			<!-- 리스트 테이블 -->
			<!-- table result -->
			<div class="" style="overflow-y:auto;overflow-x:auto;">
			<!-- 스크롤발생시 추가되는 클래스 scroll_padding -->
			<!-- <div class="line"></div> 스크롤발생시 추가되는 태그 -->
				<div class="table_layout">
					<table class="tbl_result" id="tbl_title">
						<caption></caption>
						<colgroup></colgroup>
						<thead>
						<tr></tr>
						</thead>
						<!-- <tbody id="recList"></tbody> -->
					</table>
				</div>
				
				<!--  new add -->
				<div class="tbl_layout" style="min-height:240px;min-width:100%;overflow-y:none;overflow-x:none;">
					<table class="tbl_result" summary="" id="tbl_content">
						<caption></caption>
						<colgroup></colgroup>
						<tfoot style="display:none;">
							<tr class="no_hover" style="display:table-row;">
								<td colspan="9" class="no_info"><div>내용이 없습니다.</div></td>
							</tr>
						</tfoot>
						<tbody><tr></tr></tbody>
					</table>
				</div>
			</div>
			<!-- table result -->
			
			<!-- Paging wrap -->
			<div class="paging_wrap">
				<div class="f_left n_paging_size"></div>
				<div class="paging" id="tbl_paging" style="border-top:0px;"></div>
			</div>
			<!-- //Paging wrap -->

			<!-- 버튼영역 -->
			<div class="tar mgt15">			
				<a href="#none" class="btn_style1 popupClose"><span>취소</span></a>
			</div>
			<!-- //버튼영역 -->

	</div>
	<!-- //팝업 컨텐츠 -->

</div>
	<%@include file="/view/jex/avatar/admin/include/view_stgup.jsp"%>    
</body>
</html>