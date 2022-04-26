<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                    
    // Action 결과 추출
    String _sLocalTime_comm = DateTime.getInstance().getDate("yyyymmddhh24miss");
    String CNSL_NO = StringUtil.null2void(request.getParameter("CNSL_NO")); 
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : blbd_0301_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/blbd
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20210506104434, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/blbd/blbd_0301_02.js
 * @JavaScript Url   : /js/jex/avatar/admin/blbd/blbd_0301_02.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title>협력문의</title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/admin/js/include/smart.excel.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript" src="/admin/js/include/smart.grid.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript" src="/js/jex/avatar/admin/blbd/blbd_0301_02.js?<%=_sLocalTime_comm %>"></script>
<style>
.title_wrap .right{position:absolute;top:0;right:0;}
</style>
</head>
<body>
<form method="post" enctype="multipart/form-data" id="frm">
<input type="hidden" name="CNSL_NO" value="<%=CNSL_NO %>" />
		<div class="wrap">
			<!-- Container -->
    		<div class="container">
				<jsp:include page="/view/jex/avatar/admin/include/com_menu.jsp">
					<jsp:param name="MENU" value="hmpg"/>
				</jsp:include>
				<!-- Container -->
				<div class="content">
					<div class="content fold">
						<div class="content_wrap">
							<!-- 타이틀/검색 영역 -->
							<div class="title_wrap">
								<div class="left"><h1>협력문의</h1></div>
							</div>
							<!-- //타이틀/검색 영역 -->
							<!-- 테이블 영역 -->
                            <div class="cboth mgb10 mgt10">
								<div class="left" style="z-index: 100007;"></div>
								<div class="right" style="position: relative; z-index: 16; float: right;">
                                <a href="javascript:void(0);" class="btn_style1_b cmdSave"><span>저장</span></a>
							    <a href="javascript:void(0);" class="btn_style1_b btnCancel"><span>목록</span></a>
								</div>
							</div>
						    <div class="mgb10">
							    <div class="title2nd_wrap"> 
								    <div class="left"> 
									    <div class="title"> 
										    <strong class="tx_title txt_b">[<span>고객정보문의</span>]</strong> 
    									</div> 
	    							</div> 
		    					</div>
			    				<table class="tbl_input2 noline" summary="">
				    				<caption></caption>
					    			<colgroup>
						    			<col style="width:140px;"><col>
								    	<col style="width:140px;"><col>
    								</colgroup>
	    							<tbody>
		    							<tr>
			    							<th scope="row"><div>문의일시</div></th>					
				    						<td>
					    						<div>
						    						<span id="RQST_DT"></span>
							    				</div>
								    		</td>
									    	<th scope="row"><div>연락처 * </div></th>					
										    <td>
    											<div>
	    											<span id="RQST_CLPH_NO"></span>
		    									</div>
			    							</td>
				    					</tr>
                                        <tr>
						    				<th scope="row"><div>회사명 * </div></th>					
							    			<td>
								    			<div>
									    			<span id="RQST_BSNN_NM"></span>
										    	</div>
    										</td>
	    									<th scope="row"><div>이메일</div></th>					
		    								<td>
			    								<div>
				    								<span id="RQST_EML"></span>
					    						</div>
						    				</td>
							    		</tr>
                                        <tr>
									    	<th scope="row"><div>사업자번호 *</div></th>					
										    <td>
    											<div>
	    											<span id="RQST_BIZ_NO"></span>
		    									</div>
			    							</td>
				    						<th scope="row"><div>신청구분</div></th>					
					    					<td>
						    					<div>
							    					<span id="CNSL_DIV"></span>
								    			</div>
									    	</td>
    									</tr>
                                        <tr>
		    								<th scope="row"><div>이름 *</div></th>					
			    							<td colspan="3">
				    							<div>
					    							<span id="RQST_CUST_NM"></span>
						    					</div>
							    			</td>
								    	</tr>
									    <tr style="height:100px;">
    										<th scope="row"><div><span>내용</span></div></th>									
	    									<td colspan="3">
		    									<div>
			    									<span id="RQST_CTT"></span>
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
							    			<strong class="tx_title txt_b">[<span>상담정보</span>]</strong> 
								    	</div> 
    								</div> 
	    						</div>
		    					<table class="tbl_input2 noline" summary="">
			    					<caption></caption>
				    				<colgroup>
                                        <col style="width:140px;"><col>
                                        <col style="width:140px;"><col>
							    	</colgroup>
								    <tbody>
									    <tr>
										    <th scope="row"><div>상태</div></th>					
    										<td>
	    										<div >
		    										<select id="CNSL_STTS" style="width:100px;background: white !important;">
			    										<option value="0">대기</option>
				    									<option value="1">접수</option>
					    								<option value="2">완료</option>
						    						</select>
							    				</div>
								    		</td>
                                            <th scope="row"><div>상담일자</div></th>					
										    <td>
    											<div >
                                                    <input type="text" style="width:71px;padding-left:5px; margin-right:5px;" id="CNSL_DT" value="" readonly="readonly">
		    									</div>
			    							</td>
				    					</tr>
					    				<tr style="height:150px;">
						    				<th scope="row"><div><span>내용</span></div></th>									
								    		<td colspan="3">
									    		<div>
										    		<textarea id="CNSL_CTT" maxlength='20000'style="height:150px; width:95%;"></textarea>
											    </div>
    										</td>
	    								</tr>
		    						</tbody>
			    				</table>
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