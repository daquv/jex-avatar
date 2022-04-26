<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String BLBD_NO = StringUtil.null2void(request.getParameter("BLBD_NO"));
    String BLBD_DIV = StringUtil.null2void(request.getParameter("BLBD_DIV"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : blbd_0101_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/blbd
 * @author           : 김별 (  )
 * @Description      : 공지사항등록화면
 * @History          : 20200828142750, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/blbd/blbd_0101_02.js
 * @JavaScript Url   : /js/jex/avatar/admin/blbd/blbd_0101_02.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title>게시물관리</title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp"%>
<script src="/admin/daumopeneditor/js/editor_loader.js" type="text/javascript" charset="utf-8" ></script>
<script type="text/javascript" src="/js/jex/avatar/admin/blbd/blbd_0101_02.js?<%=DateTime.getInstance().getDate("yyyymmddhh24miss") %>"></script>
<style>
.tx-canvas{height:350px;}
.valid{border:1px solid #f00! important;}
	.required{color:#f00; font-weight:bold;}
	
	.tbl_input2 td div:first-child {
		padding: 0 !important;
		padding-left: 2px !important;
	}
	
	.tbl_input2 td {
		padding: 8px 0px 8px 8px;
	}
	tr.text-dot td div{
	  width : 90%;
	  overflow:hidden;
	  display:inline-block;
	  text-overflow: ellipsis;
	  white-space: nowrap;
	}
	table#tbl_title thead tr th:nth-child(1){ width:70px;}
	table#tbl_title thead tr th:nth-child(2){ width:100px;}
	table#tbl_title thead tr th:nth-child(3){ width:280px;}
	table#tbl_title thead tr th:nth-child(4){ width:100px;}
	table#tbl_title thead tr th:nth-child(5){ width:100px;text-align:center;}	
	
	
	table#tbl_content tbody tr td:nth-child(1){ width:70px;}
	table#tbl_content tbody tr td:nth-child(2){ width:100px;}
	table#tbl_content tbody tr td:nth-child(3){ width:280px;}
	table#tbl_content tbody tr td:nth-child(4){ width:100px;}
	table#tbl_content tbody tr td:nth-child(5){ width:100px;text-align:center;}
</style>
</head>

<body>
	<!-- <form method="post" enctype="multipart/form-data" id="frm"> -->
		<input type="hidden" name="BLBD_NO" value="<%=BLBD_NO %>" />
		<input type="hidden" name="BLBD_DIV" value="<%=BLBD_DIV %>" />
		<div class="wrap">
			<!-- Container -->
    		<div class="container">
				<jsp:include page="/view/jex/avatar/admin/include/com_menu.jsp">
					<jsp:param name="MENU" value="cstm"/>
				</jsp:include>
				<!-- Container -->
				<div class="content">
					<div class="content fold">
						<div class="content_wrap">
							<form method="post" enctype="multipart/form-data" id="frm">
							<input type="hidden" name="BLBD_NO" value="<%=BLBD_NO %>" />
							<input type="hidden" name="BLBD_DIV" value="<%=BLBD_DIV %>" />
							<!-- 타이틀/검색 영역 -->
							<div class="title_wrap">
								<!-- (PARK)20161005 -->
								<div class="left" style="position: relative; z-index: -16;">
									<div class="left">
										<% if("02".equals(StringUtil.null2void(BLBD_DIV))){  %>
											<h1>공지사항</h1>
										<%} else if ("03".equals(StringUtil.null2void(BLBD_DIV))){%>
											<h1>FAQ</h1>
										<%} %>
									</div>
								</div>
								<div class="right" style="z-index: 100007;"></div>
							</div>
							<!-- //타이틀/검색 영역 -->
					
							<!-- 타이틀/검색 영역 -->
							<div class="cboth mgb10 mgt10">
								<div class="left" style="z-index: 100007;"></div>
								<div class="right"style="position: relative; z-index: 16; float: right;">
									<a href="javascript:void(0);" class="btn_style1_b cmdReg" id="cmdReg"><span class="fwb">&nbsp; 게시 &nbsp;</span></a> 
									<a href="javascript:void(0);" class="btn_style1_b cmdList" id="cmdList"><span class="fwb">&nbsp; 목록 &nbsp;</span></a>
								</div>
							</div>
							<!-- //타이틀/검색 영역 -->
							</form>
							<!-- 컨텐츠 영역 -->
							<div class="mgb20">
								<table class="tbl_input2" style="width:98% !important">
									<colgroup>
										<col style="width: 8%;">
										<col style="width: 80%;">
										<col style="width: 10%;">
									</colgroup>
						
									<tbody>
										<% if("03".equals(StringUtil.null2void(BLBD_DIV))){  %>
											<tr class="for_dynamic">
												<th scope="row"><div>채널</div></th>
												<td colspan="2">
													<div id="">
														<select id="CHNL_CD" style="width:100px;">
															<option value="00">통합</option>
															<option value="01">아바타</option>
															<option value="02">경리나라</option>
															<option value="03">제로페이</option>
															<option value="04">KT경리나라</option>
														</select>
													</div>
												</td>
											</tr>
											<tr class="for_dynamic">
												<th scope="row"><div>카테고리</div></th>
												<td colspan="2">
													<div id="">
														<select id="CTGR_CD" style="width:100px;">
														<!-- <option value="0">전체</option> -->
														</select>
													</div>
												</td>
											</tr>
										<%}%>
										<tr class="for_dynamic">
											<th scope="row"><div>제목</div></th>
											<td colspan="2">
												<div id="">
													<input type="text" style="width: 99.5%;" class="POPU_TITL" id="BLBD_TITL">
												</div>
											</td>
										</tr>
										<tr class="for_dynamic">
											<th scope="row"><div>내용</div></th>
											<td class="txt-contents" style="height: 425px;" colspan="2">
												<!-- daum editor 영역 -->
												<div style="position: relative; height: 425px; width: 100%;"class="txt-contents">
													<div id="" style="padding: 0 !important; position: absolute; width: 100%">
														<form id="EditorForm" name="EditorForm" method="post" class="BLBD_CTT">
															<jsp:include page="/view/jex/avatar/admin/include/editor.jsp">
																<jsp:param name="contentWidth" value="" />
																<jsp:param name="contentHeight" value="" />
															</jsp:include>
						
														</form>
													</div>
						
													<div class="wall_box"
														style="position: absolute; width: 98%; height: 100%; background: #a8a8a8; opacity: 0.1; z-index: 999; display: none;">
						
													</div>
												</div> <!-- //daum editor 영역 -->
											</td>
										</tr>
										<tr class="for_dynamic">
											<th scope="row"><div>첨부파일</div></th>
											<td class="txt-contents" style="height: 100px;">
												<div id="fileList">
													<ul>
													</ul>
													<!-- <a href="javascript:void(0);" ><span class="fwb">&nbsp; fileNm &nbsp;</span></a>&nbsp;&nbsp;<a href="javascript:void(0);" class="btn_style1_b" ><span class="fwb">삭제</span></a>&nbsp; -->
												</div>
											</td>
											<td class="txt-contents" style="height: 100px;">
												<div class="left" style="position: relative; z-index: 16; float: right; display: table;">
												<form id="form_file" name="form2" method="post">
													<input type="text" name="file_div" value="img" style="display:none;"/>
													<input type="file" size="30" name="ATT_FILE_blbd" class="ATT_FILE" style="height: 23px; display:none;" id="file" />
													<a href="javascript:void(0);" class="btn_style1_b cmdFileUpload" id="cmdNew" style="display: table-cell; float: center;">
													<span class="fwb">&nbsp; 파일첨부 &nbsp;</span></a>&nbsp;&nbsp;
												</form>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
								<br />
							</div>
							<!-- //컨텐츠 영역 -->
						</div>
					</div>
				</div>
			</div>
			<%@include file="/view/jex/avatar/admin/include/com_footer.jsp"%>
		</div>
<%@include file="/view/jex/avatar/admin/include/com_bottom.jsp"%>
<%@include file="/view/jex/avatar/admin/include/view_stgup.jsp"%>
</body>
</html>