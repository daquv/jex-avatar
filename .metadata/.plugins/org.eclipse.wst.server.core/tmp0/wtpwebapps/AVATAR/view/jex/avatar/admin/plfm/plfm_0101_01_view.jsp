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
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : plfm_0101_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/plfm
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200709143748, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/plfm/plfm_0101_01.js
 * @JavaScript Url   : /js/jex/avatar/admin/plfm/plfm_0101_01.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title>플랫폼회원관리</title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/admin/js/include/smart.excel.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript" src="/admin/js/include/smart.grid.js?<%=_sLocalTime_comm %>"></script>


<script type="text/javascript" src="/js/jex/avatar/admin/plfm/plfm_0101_01.js?<%=_sLocalTime_comm %>"></script>
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
					<jsp:param name="MENU" value="plfm"/>
				</jsp:include>

				<!-- Container -->
				<div class="content">
					<div class="content fold">
						
						<div class="content_wrap">
		
							<!-- 타이틀/검색 영역 -->
							<div class="title_wrap">
								<div class="left"><h1>회원관리</h1></div>
							</div>
							<!-- //타이틀/검색 영역 -->
							
							<!-- 검색테이블--> <!-- 가입일자, 상태, 검색대상 -->
							<div class="table_wrap mgb10">
								<div class="tbl_srch">
									<table summary="">
										<colgroup>
											<col style="width:80px">
											<col style="width:240px;">
											<col style="width:80px;">
											<col style="width:400px;">
											<col style="width:80px;">
											<col style="width:400px;">
											<col>
										</colgroup>
										<tbody>
											<tr>
												<th scope="row"><div>가입일자</div></th>
												<td>
													<div>
														<input type="text" style="width:71px;padding-left:5px; margin-right:5px;" id="STR_DT" value="" readonly="readonly">
															~
														<input type="text" style="width:71px;padding-left:5px; margin-right:5px;" id="END_DT" value="" readonly="readonly">
													</div>
												</td>
												<th scope="row"><div>검색대상</div></th>
												<td>
													<div>
														<select id="SRCH_CD" style="width:100px;">
															<option value="0">전체</option>
															<option value="1">성명</option>
															<option value="2">회사명</option>
														</select>
														<input id="SRCH_WD" type="text" value="" placeholder="" style="width:215px;">
													</div>
												</td>
												
												<th scope="row" style="text-align:right;padding-right:10px;"><div>상태</div></th>
												<td>
													<div>
														<label for="STTS_01"><input type="checkbox" name="STTS" class="STTS" value="2"> 신청대기</label>
														<label for="STTS_01"><input type="checkbox" name="STTS" class="STTS" value="3"> 승인대기</label>
														<label for="STTS_02"><input type="checkbox" name="STTS" class="STTS" value="1"> 정상</label>
														<label for="STTS_02"><input type="checkbox" name="STTS" class="STTS" value="9"> 해지</label>
													</div>
												</td>
												
												<th scope="row"><div></div></th>
												<td><div></div></td>
												<td style="float: right;"><a href="javascript:void(0);" class="btn_search_tb cmdSearch" colspan="1"><span>조회</span></a></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<!-- //검색테이블 -->
							<!-- 타이틀/검색 영역 -->
							<div  class="title_wrap type2 cboth mgb10 mgt10"> 
								<div class="left" style="position:relative;z-index:16;">
									<a href="javascript:" class="btn_style1_b" id="cmdStts" style="display:inline-block;"><span>상태변경</span></a>
									<a href="javascript:" class="btn_style1_b" id="cmdNew" style="display:inline-block;"><span>신규등록</span></a>
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