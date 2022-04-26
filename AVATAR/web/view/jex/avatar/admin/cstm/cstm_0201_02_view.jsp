<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
	String _sLocalTime_comm = DateTime.getInstance().getDate("yyyymmddhh24miss");
	String BLBD_NO = StringUtil.null2void(request.getParameter("BLBD_NO"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : cstm_0201_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/cstm
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200824151650, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/cstm/cstm_0201_02.js
 * @JavaScript Url   : /js/jex/avatar/admin/cstm/cstm_0201_02.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title>고객관리</title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/admin/js/include/smart.excel.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript" src="/admin/js/include/smart.grid.js?<%=_sLocalTime_comm %>"></script>


<script type="text/javascript" src="/js/jex/avatar/admin/cstm/cstm_0201_02.js?<%=_sLocalTime_comm %>"></script>
<style>
.tbl_show_count{border-top:1px solid #ccc; border-bottom:1px solid #ccc;}
.tbl_show_count tr{border-bottom: 1px solid #ccc;}
.tbl_show_count tr td, .tbl_show_count tr th{padding:10px;}
.tbl_show_count tr th{text-align: left;}
.title_wrap .right{position:absolute;top:0;right:0;}
</style>
</head>
<body>
<form method="post" enctype="multipart/form-data" id="frm">
<input type="hidden" name="BLBD_NO" value="<%=BLBD_NO %>" />
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
							<!-- 타이틀/검색 영역 -->
							<div class="title_wrap">
								<div class="left"><h1>기능개선문의</h1></div>
							</div>
							<!-- //타이틀/검색 영역 -->
							<!-- 테이블 영역 -->
							
						<div class="mgb10">
							<div class="title2nd_wrap"> 
								<div class="left"> 
									<div class="title"> 
										<strong class="tx_title txt_b">[<span>문의</span>]</strong> 
									</div> 
								</div> 
							</div>
							<table class="tbl_input2 noline" summary="">
								<caption></caption>
								<colgroup>
									<col style="width:140px;"><col>
									<!-- <col style="width:140px;"><col> -->
									<col style="width:140px;"><col>
									<!-- <col style="width:140px;"><col> -->
								</colgroup>
								<tbody>
									<tr>
										<th scope="row"><div>문의일시</div></th>					
										<td>
											<div>
												<span id="REG_DTM"></span>
											</div>
										</td>
										<th scope="row"><div>작성자</div></th>					
										<td>
											<div>
												<span id="CUST_NM"></span>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row"><div><span>제목</span></div></th>									
										<td colspan="3">
											<div>
												<span id="BLBD_TITL"></span>
											</div>
										</td>
									</tr>
									<tr style="height:150px;">
										<th scope="row"><div><span>문의내용</span></div></th>									
										<td colspan="3">
											<div>
												<span id="BLBD_CTT"></span>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row"><div><span>첨부파일</span></div></th>									
										<td colspan="3">
											<div>
												<ul id="BLBD_FILE"></ul>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- //테이블 영역 -->
						
						<div class="mgb10">
							<div class="title2nd_wrap"> 
								<div class="left"> 
									<div class="title"> 
										<strong class="tx_title txt_b">[<span>답변</span>]</strong> 
									</div> 
								</div> 
							</div>
							<table class="tbl_input2 noline" summary="">
								<caption></caption>
								<colgroup>
									<col style="width:140px;"><col>
									<!-- <col style="width:140px;"><col> -->
								</colgroup>
								<tbody>
									<tr>
										<th scope="row"><div>처리</div></th>					
										<td>
											<div >
												<select id="STTS" style="width:100px;background: white !important;">
													<option value="0">대기</option>
													<option value="1">접수</option>
													<option value="2">완료</option>
												</select>
											</div>
										</td>
									</tr>
									<tr style="height:150px;">
										<th scope="row"><div><span>답변내용</br>(1000자 이내)</span></div></th>									
										<td>
											<div>
												<textarea id="RPLY_CTT" maxlength='1000'style="height:150px; width:95%;"></textarea>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row"><div><span>첨부파일</span> </div></th>									
										<td>
											<div>
												<input type="file" size="30" name="ATT_FILE_IMG" id="ATT_FILE" style="height: 23px; display:none;" />
												<a style="float:right;margin-bottom:10px;" href="javascript:void(0);" class="btn_style1 btnFileadd"><span>첨부하기</span></a>
												<ul id="RPLY_FILE"></ul>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="tac mgt10">
							<a href="javascript:void(0);" class="btn_style1_b cmdSave"><span>저장</span></a>
							<a href="javascript:void(0);" class="btn_style1 btnCancel"><span>취소</span></a>
						</div>
						
						
						</div>
					
						
					</div>
				</div>
			</div>
			<%@include file="/view/jex/avatar/admin/include/com_footer.jsp"%>
		</div>
	<%@include file="/view/jex/avatar/admin/include/com_bottom.jsp"%>
	<%@include file="/view/jex/avatar/admin/include/view_stgup.jsp"%>              
	</form>
</body>
</html>