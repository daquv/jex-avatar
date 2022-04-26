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
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : srvc_0201_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/srvc
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200707180752, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/srvc/srvc_0201_01.js
 * @JavaScript Url   : /js/jex/avatar/admin/srvc/srvc_0201_01.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title>질의센터</title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/admin/js/include/smart.excel.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript" src="/admin/js/include/smart.grid.js?<%=_sLocalTime_comm %>"></script>


<script type="text/javascript" src="/js/jex/avatar/admin/srvc/srvc_0201_01.js?<%=_sLocalTime_comm %>"></script>
<style>
.tbl_show_count{border-top:1px solid #ccc; border-bottom:1px solid #ccc;}
.tbl_show_count tr{border-bottom: 1px solid #ccc;}
.tbl_show_count tr td, .tbl_show_count tr th{padding:10px;}
.tbl_show_count tr th{text-align: left;}
.title_wrap .right{position:absolute;top:0;right:0;}
</style>
</head>
<body>
	<form id="form1" name="fomr1" method="post">
		<div class="wrap">
			<!-- Container -->
    		<div class="container">
				<jsp:include page="/view/jex/avatar/admin/include/com_menu.jsp">
					<jsp:param name="MENU" value="srvc2"/>
				</jsp:include>

				<!-- Container -->
				<div class="content">
					<div class="content fold">
						
						<div class="content_wrap">
		
							<!-- 타이틀/검색 영역 -->
							<div class="title_wrap">
								<div class="left"><h1>앱관리</h1></div>
							</div>
							<!-- //타이틀/검색 영역 -->
							<!-- 타이틀/검색 영역 -->
							<div  class="title_wrap type2 cboth mgb10 mgt10"> 
								<div class="left" style="position:relative;z-index:16;">
									<a href="javascript:" class="btn_style1_b" id="btnNew" style="display:inline-block;"><span>등록</span></a>
								</div>
								<div class="right" style="z-index:100007;"></div>
							</div>
							<!-- //타이틀/검색 영역 -->
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
								<div class="tbl_layout" style="min-height:509px;min-width:100%;overflow-y:none;overflow-x:none;">
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
							
						</div>
					</div>
				</div>
				<!-- Container -->
			</div>
			<%@include file="/view/jex/avatar/admin/include/com_footer.jsp"%>
		</div>
	</form>
	<%@include file="/view/jex/avatar/admin/include/com_bottom.jsp"%>
	<%@include file="/view/jex/avatar/admin/include/view_stgup.jsp"%>              

</body>
</html>