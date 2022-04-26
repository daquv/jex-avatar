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
    String APP_ID = StringUtil.null2void(request.getParameter("APP_ID"));
    String MENU_DV = StringUtil.null2void(request.getParameter("MENU_DV"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : srvc_0101_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/srvc
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200706151135, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/srvc/srvc_0101_02.js
 * @JavaScript Url   : /js/jex/avatar/admin/srvc/srvc_0101_02.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title>질의API관리</title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/admin/js/include/smart.excel.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript" src="/admin/js/include/smart.grid.js?<%=_sLocalTime_comm %>"></script>


<script type="text/javascript" src="/js/jex/avatar/admin/srvc/srvc_0101_02.js?<%=_sLocalTime_comm %>"></script>
<style>
.tbl_show_count{border-top:1px solid #ccc; border-bottom:1px solid #ccc;}
.tbl_show_count tr{border-bottom: 1px solid #ccc;}
.tbl_show_count tr td, .tbl_show_count tr th{padding:10px;}
.tbl_show_count tr th{text-align: left;}
.title_wrap .right{position:absolute;top:0;right:0;}

.tbl_input2 td div .list_scroll_top {padding:0;}
.tbl_input2 td div .tbl_result th {background:#788496;border-bottom:1px solid #626c79;}
.tbl_input2 td div .tbl_result th div {padding:7px 10px 5px 10px;color:#fff;}
.tbl_input2 td div .tbl_result td div {padding:5px 10px;}

.no_border { border : 0px; }
</style>
</head>
<body>
<input type="hidden" name="APP_ID_BASE" value="<%=APP_ID %>" />
<input type="hidden" name="MENU_DV" value="<%=MENU_DV %>" />
	<form id="form1" name="fomr1" method="post">
		<div class="wrap">
			<!-- Container -->
    		<div class="container">
    			<% if("2".contains(MENU_DV)){  %>
					<jsp:include page="/view/jex/avatar/admin/include/com_menu.jsp">
						<jsp:param name="MENU" value="srvc"/>
					</jsp:include>
				<% } else {%>
					<jsp:include page="/view/jex/avatar/admin/include/com_menu.jsp">
						<jsp:param name="MENU" value="srvc2"/>
					</jsp:include>
					
				<% } %>
				
				<!-- Container -->
				<div class="content">
					<div class="content fold">
						
						<div class="content_wrap">
		
							<!-- 타이틀/검색 영역 -->
							<div class="title_wrap">
								<div class="left"><h1>앱관리</h1></div>
								<div class="right">
								<% if("20".equals(MENU_DV)){  %>
									<a class="btn_style1" id="cmdDelete"><span>삭제</span></a>
									<a class="btn_style1" id="cmdEdit"><span>수정</span></a>
									<a href="srvc_0201_01.act" class="btn_style1"><span>목록</span></a>
								<% } else if("21".equals(MENU_DV) || "22".equals(MENU_DV)) {%>
									<a class="btn_style1" id="cmdSave"><span>저장</span></a>
									<a href="srvc_0201_01.act" class="btn_style1"><span>목록</span></a>
								<% } else {%>					
									<a href="srvc_0101_01.act" class="btn_style1"><span>목록</span></a>
								<% } %>
								</div>
							</div>
							<!-- //타이틀/검색 영역 -->
							<!-- 테이블 영역 -->
							
						<div class="mgb10">
							<div class="title2nd_wrap"> 
								<div class="left"> 
									<div class="title"> 
										<strong class="tx_title txt_b">[<span>기본정보</span>]</strong> 
									</div> 
								</div> 
							</div>
							<table class="tbl_input2 noline" summary="">
								<caption></caption>
								<colgroup><col style="width:140px;"><col></colgroup>
								<tbody>
									<% if("1".equals(MENU_DV)){  %>
										<tr>
											<th scope="row"><div>컨텐츠공급사</div></th>					
											<td>
												<div>
													<span id="BSNN_NM"></span>
												</div>
											</td>									
										</tr>
									<% } %>
									<tr>
										<th scope="row"><div><span>앱명</span><span class="txt_r">*</span></div></th>									
										<td>
											<div>
												<input type="text" id="APP_NM" style="width:20%;" maxlength="50" class="rq"/>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row"><div><span>앱코드</span><span class="txt_r">*</span></div></th>									
										<td>
											<div>
												<input type="text" id="APP_ID" style="width:20%;" maxlength="20" class="rq"/>
												<% if("21".equals(MENU_DV)  ) {%>
													<a style="margin-left:8px;" id="btn_chk"class="btn_style3" ><span>중복확인</span></a>
												<%} %>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row"><div><span>HOST</span><span class="txt_r">*</span></div></th>									
										<td>
											<div>
												<input type="text" id="HOST" style="width:50%;" maxlength="200" class="rq"/>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row"><div><span>인증방식</span></div></th>									
										<td>
											<div>
											
											<% if("22".equals(MENU_DV) || "21".equals(MENU_DV)){  %>
												<select id="VRFC_TYPE">
													<option value="0">없음</option>
													<option value="1">서비스키</option>
													<option value="2">ID/PW</option>
												</select>
											<% } else {%>
												<span id="VRFC_TYPE"></span>
											<% } %>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row"><div><span>서비스키</span><span class="txt_r"></span></div></th>									
										<td>
											<div>
												<input type="text" id="SVC_KEY" style="width:30%;" maxlength="50"/>
											</div>
										</td>
									</tr>								
									<tr>
										<th scope="row"><div><span>인터페이스 표준</span><span class="txt_r">*</span></div></th>									
										<td>
											<div>
												<input type="text" id="INTF_DV" style="width:15%;" maxlength="10" class="rq"/>
											</div>
										</td>
									</tr>								
									<tr>
										<th scope="row"><div><span>데이터 표준</span><span class="txt_r">*</span></div></th>									
										<td>
											<div>
												<input type="text" id="DATA_TYPE" style="width:15%;" maxlength="10" class="rq"/>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row"><div><span>파라미터</span></div></th>									
										<td>
											<div>
												<input type="text" id="PARA_ID" style="width:30%;" maxlength="20"/>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row"><div><span>앱 담당자</span><span class="txt_r"></span></div></th>									
										<td><div>
										<!-- 리스트 테이블 -->
										<!-- 리스트 테이블 상단 -->
											<div class="list_scroll_top" style="overflow:hidden;"><!-- 하단테이블 세로스크롤 발생시 pdr 클래스 추가 -->
												<table class="tbl_result" summary="">
													<caption></caption>
													<colgroup>
													<col style="width:205px;">
													<col style="width:150px;">
													<col style="width:150px;">
													<col style="width:205px;">
													<col style="width:150px;">
													<col >
													</colgroup>
													<thead>
														<tr>
															<th scope="col"><div>아이디</div></th>
															<th scope="col"><div>이름</div></th>
															<th scope="col"><div>휴대폰번호</div></th>
															<th scope="col"><div>전화번호</div></th>
															<th scope="col"><div>회사명</div></th>
															<% if("21".equals(MENU_DV) || "22".equals(MENU_DV) ) {%>
																<th scope="col" style="text-align: right;"><div><a id="btn_add"class="btn_style3" ><span style="min-width:15px !important;">+</span></a></div></th>
															<% }%>	
														</tr>
													</thead>
												</table>
											</div>
										<!-- //리스트 테이블 상단 -->
											<div class="list_scroll" style="height:102px;">
												<table class="tbl_result" summary="">
													<caption></caption>
													<colgroup>
													<col style="width:205px;">
													<col style="width:150px;">
													<col style="width:150px;">
													<col style="width:205px;">
													<col style="width:150px;">
													<col >
													</colgroup>
													<tfoot style="display:none;"><!-- display: none/ table-tfoot -->
														<tr class="no_hover">
															<td colspan="7" class="no_info"><div>No Data</div></td>
														</tr>
													</tfoot>
													<tbody id="admin_list">
													</tbody>
												</table>
											</div>
										<!-- //리스트 테이블 -->
									</div></td>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- //테이블 영역 -->
						</div>
					
						
					</div>
				</div>
			</div>
			<%@include file="/view/jex/avatar/admin/include/com_footer.jsp"%>
		</div>
	</form>
	<%@include file="/view/jex/avatar/admin/include/com_bottom.jsp"%>
	<%@include file="/view/jex/avatar/admin/include/view_stgup.jsp"%>              
</body>
</html>