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
 * @File Name        : srvc_0202_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/srvc
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200807141024, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/srvc/srvc_0202_01.js
 * @JavaScript Url   : /js/jex/avatar/admin/srvc/srvc_0202_01.js
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


<script type="text/javascript" src="/js/jex/avatar/admin/srvc/srvc_0202_02.js?<%=_sLocalTime_comm %>"></script>
<style>
.tbl_show_count {
	border-top: 1px solid #ccc;
	border-bottom: 1px solid #ccc;
}

.tbl_show_count tr {
	border-bottom: 1px solid #ccc;
}

.tbl_show_count tr td, .tbl_show_count tr th {
	padding: 10px;
}

.tbl_show_count tr th {
	text-align: left;
}

.title_wrap .right {
	position: absolute;
	top: 0;
	right: 0;
}

</style>
</head>
<script>
	API_ID = "<%=StringUtil.null2void(request.getParameter("API_ID"))%>";
	APP_ID = "<%=StringUtil.null2void(request.getParameter("APP_ID"))%>";
</script>
<body>
	<form id="form1" name="fomr1" method="post">
		<div class="wrap">
			<!-- Container -->
    		<div class="container">
				<jsp:include page="/view/jex/avatar/admin/include/com_menu.jsp">
					<jsp:param name="MENU" value="srvc2"/>
				</jsp:include>
				<div class="content">
					<div class="content fold">
						<div class="content_wrap">
						<!-- 타이틀/검색 영역 -->
							<div class="title_wrap mgb15">
								<div class="left" style="width: 210px;float:left"><h1>질의API관리</h1></div>
								<div  style="float: right;">
								<a href="javascript:void(0);" class="btn_style1_b cmdSave"><span>저장</span></a>
										<a href="srvc_0202_01.act" class="btn_style1 cmdCancel"><span>목록</span></a></div>
							</div>
							<div class="div_body">
								<!-- (서브)타이틀 -->
								<div class="title2nd_wrap cboth mgb5">
									<div class="left" style="float:left;">
										<div class="title"> 
	         								<strong class="tx_title txt_b">[<span>기본정보</span>]</strong> 
	         							</div>
									</div>
									<div class="right" style="float:right;">
										
									</div>
								</div>
								<!-- //(서브)타이틀 -->
						
								<!-- table input(2) : -->
								<div class="tbl_input2 mgb20">
									<table summary="">
									<caption></caption>
									<colgroup>
										<col style="width:140px;">
										<col>
									</colgroup>
										<tbody>
											<tr>
												<th scope="row">
													<div>앱<em class="point"></em></div>
												</th>
												<td>
													<div>
														<select class="pk" id="APP_ID" maxlength="100" style="width:150px;"></select>
													</div>
												</td>
											</tr>
											<tr>
												<th scope="row"><div>카테고리</div></th>
												<td>
													<div>
														<select id="CTGR_CD" style="width:150px;"></select>
													</div>
												</td>
											</tr>
											<tr>
												<th scope="row"><div>API ID<em class="point"></em></div></th>
												<td>
													<div>
														<input type="text" class="pk" placeholder="" value="" id="API_ID" style="width:229px;" maxlength="50" />
														<a style="margin-left:8px;" id="btn_chk"class="btn_style3" ><span>중복확인</span></a>
													</div>
												</td>
											</tr>
											<tr>
												<th scope="row"><div>상태</div></th>
												<td>
												<div>
													<!-- <label><input type="radio" name="STTS" value="1" disabled/> 승인대기  </label>
													<label><input type="radio" name="STTS" value="2" disabled/> 배포대기 </label>
													 --><label><input type="radio" name="STTS" value="3" checked/> 배포중  </label>
													<label><input type="radio" name="STTS" value="4" /> 배포중지  </label>
													<!-- <label><input type="radio" name="STTS" value="5" disabled/> 반려  </label>
													<label><input type="radio" name="STTS" value="0" /> 임시정지 </label> -->
												</div>
												</td>
											</tr>
											<tr>
												<th scope="row"><div>질의명<em class=""></em></div></th>
												<td>
													<div>
														<input type="text" placeholder="" value="" id="QUES_CTT" style="width:229px;" maxlength="100" />
													</div>
												</td>
											</tr>
											<!-- <tr>
												<th scope="row"><div>질의결과유형<em class="point"></em></div></th>
												<td>
													<a style="margin-left:8px;" id="btn_type"class="btn_style3" ><span>유형선택</span></a>
													<span id="QUES_RSLT_TYPE"></span>
												</td>
											</tr> -->
											<tr>
												<th scope="row"><div>API URL</div></th>
												<td>
													<div>
														<input type="text" placeholder="" maxlength="100" value="" id="API_URL" style="width:90%;"/>
													</div>
												</td>
											</tr>
											<tr>
												<th scope="row"><div>설명</div></th>
												<td>
													<div>
														<textarea id="QUES_DESC" placeholder="" maxlength="4000" style="width: 90%; height: 40px;"></textarea>
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							
							
							<div class="div_body">
								<!-- (서브)타이틀 -->
								<div class="title2nd_wrap cboth mgb5" style="border-bottom:1px solid #ddd;">
									<div class="left" style="float:left;">
										<div class="title"> 
	         								<strong class="tx_title txt_b">[<span>요청헤더설정</span>]</strong> 
	         							</div>
									</div>
									<div class="right" style="float:right;">
										
									</div>
								</div>
								<!-- //(서브)타이틀 -->
								<div class="title2nd_wrap  mgb5">
									<div class="left" style="float:left;">
										<!-- <span class="btn_updw">
											<a href="#none" class="btn_up"></a>
											<a href="#none" class="btn_dw"></a>
										</span> -->
									</div>
									<div class="right" style="float:right;">
										<a class="btn_style1 btnAdd_header"><span>추가</span></a>
									</div>
								</div>
								<div class="mgb35" style="overflow-y:auto;overflow-x:auto;">
							<!-- <div class="line"></div> 스크롤발생시 추가되는 태그 -->
								<div class="table_layout">
									<table class="tbl_result" id="tbl_title">
										<caption></caption>
										<colgroup>
											<col width="400px;">
											<col width="1000px;">
											<col>
										</colgroup>
										<thead>
											<tr>
												<th scope="col">
													<div>헤드명</div>
												</th>
												<th scope="col">
													<div>설명</div>
												</th>
												<th></th>
											</tr>
										</thead>
										<!-- <tbody id="recList"></tbody> -->
									</table>
								</div>
								
								<!--  new add -->
								<div class="tbl_layout" style="min-width:100%;overflow-y:none;overflow-x:none;">
									<table class="tbl_result table_header tbl_content" summary="" id="tbl_content">
										<colgroup>
											<col width="400px;">
											<col width="1000px;">
											<col>
										</colgroup>
										<tbody>
											<tr>
												<td scope="col">
													<input type="text" class="FLD_ID" style="width:95%"/>
												</td>
												<td scope="col">
													<input type="text" class="FLD_NM" style="width:95%"/>
												</td>
												<td>
													<a id='btn_minus' class='btn_style3 btn_minus' ><span style='min-width:15px !important;'>-</span></a>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							</div>
							
							
							<div class="div_body">
								<!-- (서브)타이틀 -->
								<div class="title2nd_wrap cboth mgb5">
									<div class="left" style="float:left;">
										<div class="title"> 
	         								<strong class="tx_title txt_b">[<span>요청메시지설정</span>]</strong> 
	         							</div>
									</div>
									<div class="right" style="float:right;">
										
									</div>
								</div>
								<!-- //(서브)타이틀 -->
								<div class="title2nd_wrap  mgb5">
									<div class="left" style="float:left;">
									</div>
									<div class="right" style="float:right;">
										<a class="btn_style1 btnAdd_field"><span>필드추가</span></a>
										<a class="btn_style1 btnAdd_record"><span>반복부추가</span></a>
									</div>
								</div>
								<div class="" style="overflow-y:auto;overflow-x:auto;">
							<!-- <div class="line"></div> 스크롤발생시 추가되는 태그 -->
								<div class="table_layout">
									<table class="tbl_result" id="tbl_title">
										<caption></caption>
										<colgroup>
											<col width="300px;">
											<col width="500px;">
											<col width="150px;">
											<col width="150px;">
											<col width="150px;">
											<col width="150px;">
											<col>
										</colgroup>
										<thead>
											<tr>
												<th scope="col">
													<div>필드명</div>
												</th>
												<th scope="col">
													<div>한글명</div>
												</th>
												<th scope="col">
													<div>데이터타입</div>
												</th>
												<th scope="col">
													<div>크기</div>
												</th>
												<th scope="col">
													<div>필수여부</div>
												</th>
												<th scope="col">
													<div>필드타입</div>
												</th>
												<th></th>
											</tr>
										</thead>
										<!-- <tbody id="recList"></tbody> -->
									</table>
								</div>
								
								<!--  new add -->
								<div class="tbl_layout" style="min-width:100%;overflow-y:none;overflow-x:none;">
									<table class="tbl_result table_request tbl_content" summary="" id="tbl_content">
										<colgroup>
											<col width="300px;">
											<col width="500px;">
											<col width="150px;">
											<col width="150px;">
											<col width="150px;">
											<col width="150px;">
											<col>
										</colgroup>
										<tbody>
											<tr>
												<td scope="col">
													<input type="text" class="FLD_ID" style="width:95%"/>
												</td>
												<td scope="col">
													<input type="text" class="FLD_NM" style="width:95%"/>
												</td>
												<td scope="col">
													<select class="DATA_TYPE" style="width:95%">
														<option value="VARCHAR">VARCHAR</option>
														<option value="NUMBER">NUMBER</option>
													</select>
												</td>
												<td scope="col">
													<input type="text" class="DATA_SIZE" style="width:95%"/>
												</td>
												<td scope="col">
													<select class="MDTY_YN" style="width:95%">
														<option value="Y">YES</option>
														<option value="N">NO</option>
													</select>
												</td>
												<td scope="col">
													<span class="FLD_TYPE" data-val="F">FIELD</span>
												</td>
												<td>
													<a id='btn_minus' class='btn_style3 btn_minus' ><span style='min-width:15px !important;'>-</span></a>
												</td>
											</tr>
											
											
										</tbody>
									</table>
								</div>
							</div>
							</div>
							
							
							<div class="div_body">
								<!-- (서브)타이틀 -->
								<div class="title2nd_wrap cboth mgb5">
									<div class="left" style="float:left;">
										<div class="title"> 
	         								<strong class="tx_title txt_b">[<span>응답메시지설정</span>]</strong> 
	         							</div>
									</div>
									<div class="right" style="float:right;">
										
									</div>
								</div>
								<!-- //(서브)타이틀 -->
								<div class="title2nd_wrap  mgb5">
									<div class="left" style="float:left;">
									</div>
									<div class="right" style="float:right;">
										<a class="btn_style1 btnAdd_field"><span>필드추가</span></a>
										<a class="btn_style1 btnAdd_record"><span>반복부추가</span></a>
									</div>
								</div>
								<div class="" style="overflow-y:auto;overflow-x:auto;">
							<!-- <div class="line"></div> 스크롤발생시 추가되는 태그 -->
								<div class="table_layout">
									<table class="tbl_result " id="tbl_title">
										<caption></caption>
										<colgroup>
											<col width="300px;">
											<col width="500px;">
											<col width="150px;">
											<col width="150px;">
											<col width="150px;">
											<col width="150px;">
											<col>
										</colgroup>
										<tr>
												<th scope="col">
													<div>필드명</div>
												</th>
												<th scope="col">
													<div>한글명</div>
												</th>
												<th scope="col">
													<div>데이터타입</div>
												</th>
												<th scope="col">
													<div>크기</div>
												</th>
												<th scope="col">
													<div>필수여부</div>
												</th>
												<th scope="col">
													<div>필드타입</div>
												</th>
												<th></th>
											</tr>
										<!-- <tbody id="recList"></tbody> -->
									</table>
								</div>
								
								<!--  new add -->
								<div class="tbl_layout" style="min-width:100%;overflow-y:none;overflow-x:none;">
									<table class="tbl_result table_response tbl_content" summary="" id="tbl_content">
										<colgroup>
											<col width="300px;">
											<col width="500px;">
											<col width="150px;">
											<col width="150px;">
											<col width="150px;">
											<col width="150px;">
											<col>
										</colgroup>
										<tbody>
											<tr>
												<td scope="col">
													<input type="text" class="FLD_ID" style="width:95%"/>
												</td>
												<td scope="col">
													<input type="text" class="FLD_NM" style="width:95%"/>
												</td>
												<td scope="col">
													<select class="DATA_TYPE" style="width:95%">
														<option value="VARCHAR">VARCHAR</option>
														<option value="NUMBER">NUMBER</option>
													</select>
												</td>
												<td scope="col">
													<input type="text" class="DATA_SIZE" style="width:95%"/>
												</td>
												<td scope="col">
													<select class="MDTY_YN" style="width:95%">
														<option value="Y">YES</option>
														<option value="N">NO</option>
													</select>
												</td>
												<td scope="col">
													<span class="FLD_TYPE"  data-val="F">FIELD</span>
												</td>
												<td>
													<a id='btn_minus' class='btn_style3 btn_minus' ><span style='min-width:15px !important;'>-</span></a>
												</td>
											</tr>
											
											
										</tbody>
									</table>
								</div>
							</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

	</form>
	<%@include file="/view/jex/avatar/admin/include/com_bottom.jsp"%>
	<%@include file="/view/jex/avatar/admin/include/view_stgup.jsp"%>              
</body>
</html>