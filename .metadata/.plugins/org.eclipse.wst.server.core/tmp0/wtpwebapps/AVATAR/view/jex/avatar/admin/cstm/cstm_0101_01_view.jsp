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

%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : cstm_0101_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/cstm
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200417171303, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/cstm/cstm_0101_01.js
 * @JavaScript Url   : /js/jex/avatar/admin/cstm/cstm_0101_01.js
 * </pre>
 **/
%>



<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title>가입자관리</title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/admin/js/include/smart.grid.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript" src="/admin/js/include/smart.excel.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript" src="/js/jex/avatar/admin/cstm/cstm_0101_01.js?<%=_sLocalTime_comm %>"></script>
<style>
.tbl_show_count{border-top:1px solid #ccc; border-bottom:1px solid #ccc;}
.tbl_show_count tr{border-bottom: 1px solid #ccc;}
.tbl_show_count tr td, .tbl_show_count tr th{padding:10px;}
.tbl_show_count tr th{text-align: left;}
.title_wrap .right{position:absolute;top:0;right:0;}

._text-dot div{
	width : 90%;
	overflow:hidden;
	display:inline-block;
	text-overflow: ellipsis;
	white-space: nowrap;
}

</style>
</head>

<body>
	<form id="form1" name="fomr1" method="post">
		<div class="wrap">
			<!-- Container -->
    		<div class="container">
				<jsp:include page="/view/jex/avatar/admin/include/com_menu.jsp">
					<jsp:param name="MENU" value="cstm"/>
				</jsp:include>

				<!-- Content -->
				<div class="content">
					<div class="content fold">
						
						<div class="content_wrap">
							<!-- 타이틀/검색 영역 -->
							<div class="title_wrap">
								<div class="left"><h1>가입자관리</h1></div>
							</div>
							<!-- //타이틀/검색 영역 -->
							
							
							<!-- 검색테이블--> <!-- 가입일자, 상태, 검색대상 -->
							<div class="table_wrap mgb10">
								<div class="tbl_srch">
									<table summary="">
										<colgroup>
											<col style="width:80px">
											<col style="width:400px;">
											<col style="width:80px;">
											<col style="width:180px;">
											<col style="width:80px;">
											<col style="width:200px;">
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
														<a href="#none" class="btn_style3" id="BASE_DT"><span>전체</span></a>
														<a href="#none" class="btn_style3" id="TODAY_DT"><span>당일</span></a>
													</div>
												</td>
												<th scope="row"><div>유입채널</div></th>
												<td>
													<div>
														<select id="FST_JOIN_APP" style="width:100px;">
															<option value="">전체</option>
															<option value="AVATAR">아바타</option>
															<option value="SERP">경리나라</option>
															<option value="ZEROPAY">제로페이</option>
															<option value="KTSERP">KT경리나라</option>
														</select>
													</div>
												</td>
												<th scope="row" style="text-align:right;padding-right:10px;"><div>상태</div></th>
												<td>
													<div>
														<label for="STTS_01"><input type="checkbox" name="STTS" class="STTS" value="1"> 정상</label>
														<label for="STTS_02"><input type="checkbox" name="STTS" class="STTS" value="9"> 해지</label>
														<label for="STTS_03"><input type="checkbox" name="STTS" class="STTS" value="8"> 정지</label> 
													</div>
												</td>
												<th scope="row"><div>검색대상</div></th>
												<td>
													<div>
														<select id="SRCH_CD" style="width:100px;">
															<option value="0">전체</option>
															<option value="1">고객명</option>
															<option value="2">휴대폰번호</option>
															<option value="3">사업자번호</option>
														</select>
														<input id="SRCH_WD" type="text" value="" placeholder="" style="width:215px;">
													</div>
												</td>
												<td style=""><a href="javascript:void(0);" class="btn_search_tb cmdSearch" colspan="1"><span>조회</span></a></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<!-- //검색테이블 -->
							
							<!-- table input(1) -->
							<div class="tbl_input1 mgb10">
								<table summary="" class="tbl_show_count">
									<caption></caption>
									<colgroup>
										<col style="width:210px;">
										<col style="width:90px;">
										<col>
										<col style="width:210px;">
										<col style="width:200px;">
										<col>
									</colgroup>
									<tbody>
										<tr>
											<th scope="row"><div>전체</div></th>
											<td><div class="tar" id="TOTL_NCNT">1</div></td>
											<td><div></div></td>
											<th scope="row"><div>정상</div></th>
											<td><div class="tar" id="NORM_NCNT">1</div></td>
											<td><div></div></td>
											<th scope="row"><div>해지(중지/해지)</div></th>
											<td><div class="tar" id="TRMN_NCNT">1</div></td>
											<td><div></div></td>
										</tr>
									</tbody>
								</table>
							</div>
							<!-- //table input(1) -->
							
							<!-- 타이틀/검색 영역 -->
							<div  class="cboth mgb10 mgt10"> 
								<div class="left" style="position:relative;z-index:16;">
								</div>
								<div class="right" style="z-index:100007;">
									<a href="javascript:" class="btn_style1_b" id="btnExceldown" style="display:inline-block;"><span>엑셀저장</span></a>
								</div>
							</div>
							<!-- //타이틀/검색 영역 -->
							
							<!-- table result -->
							<div class="" style="overflow-y:auto;overflow-x:auto;">
								<div class="table_layout">
									<table class="tbl_result" id="tbl_title">
										<caption></caption>
										<colgroup></colgroup>
										<thead>
											<tr></tr>
										</thead>
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
							<!-- //table result -->

							<!-- Paging wrap -->
							<div class="paging_wrap">
								<div class="f_left n_paging_size"></div>
								<div class="paging" id="tbl_paging" style="border-top:0px;"></div>
							</div>
							<!-- //Paging wrap -->
						</div>
					</div>
				</div>
				<!-- //Content -->
			</div>
			<!-- //Container -->
			<%@include file="/view/jex/avatar/admin/include/com_footer.jsp"%>
		</div>
	</form>

<%@include file="/view/jex/avatar/admin/include/com_bottom.jsp"%>
<%@include file="/view/jex/avatar/admin/include/view_stgup.jsp"%>              

</body>
</html>


