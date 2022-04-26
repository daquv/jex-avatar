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
    String FLD_NM = "";
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : srvc_0202_03_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/srvc
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200907173745, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/srvc/srvc_0202_03.js
 * @JavaScript Url   : /js/jex/avatar/admin/srvc/srvc_0202_03.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title></title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/js/jex/avatar/admin/srvc/srvc_0202_03.js?<%=_sLocalTime_comm %>"></script>
</head>
<script>
	REC_NO = '<%=request.getParameter("REC_NO")%>';
	FLD_NM = '<%=request.getParameter("FLD_NM")%>';
	FLD_ID = '<%=request.getParameter("FLD_ID")%>';
	REC_DATA = '<%=request.getParameter("REC_DATA")%>';
</script>
<body>
	<div class="pop_wrap" style="width:792px;">
		<!-- 팝업 헤더 -->
		<div class="pop_header">
			<h1>반복부정보관리</h1>
			<a href="#none" class="btn_popclose popupClose"><img src="../img/btn_popclose.gif" alt="popup close"></a>
		</div>
		<!-- //팝업 헤더 -->

		<!-- 팝업 컨텐츠 -->
		<div class="pop_container">
			<div class="tbl_input2 mgb20">
				<table summary="">
					<caption></caption>
					<colgroup>
						<col style="width: 150px;">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><div>RECORD ID</div></th>
							<td class="ipt">
								<div>
									<input id="REC_ID" type="text" value="" maxlength="20" style="width: 90%;">
								</div>
								
							</td>
						</tr>
						<tr>
							<th scope="row"><div>RECORD NAME</div></th>
							<td class="ipt">
								<div id="">		
									<input id="REC_NM" type="text" value="" maxlength="100" style="width: 90%;">
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<div class="div_body">
				<div class="title2nd_wrap  mgb5">
					<div class="left" style="float:left;">
					</div>
					<div class="right" style="float:right;">
						<a class="btn_style1 btnAdd_field"><span>필드추가</span></a>
					</div>
				</div>
				<div class="" style="overflow-y:none;overflow-x:none;min-height:238px;">
			<!-- <div class="line"></div> 스크롤발생시 추가되는 태그 -->
				<div class="table_layout">
					<table class="tbl_result" id="tbl_title">
						<caption></caption>
						<colgroup>
							<col width="200px;">
							<col width="230px;">
							<col width="100px;">
							<col width="100px;">
							<col width="70px;">
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
								<th></th>
							</tr>
						<!-- <tbody id="recList"></tbody> -->
					</table>
				</div>
				
				<!--  new add -->
				<div class="tbl_layout" style="min-width:100%;overflow-y:scroll;overflow-x:none;">
					<table class="tbl_result table_response tbl_content" summary="" id="tbl_content">
						<colgroup>
							<col width="200px;">
							<col width="230px;">
							<col width="100px;">
							<col width="100px;">
							<col width="70px;">
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
								<td>
									<a id='btn_minus' class='btn_style3 btn_minus' ><span style='min-width:15px !important;'>-</span></a>
								</td>
							</tr>
							
							
						</tbody>
					</table>
				</div>
			</div>
		</div>
			
		<!-- 하단버튼 -->
		<div class="tac mgt10">
			<a href="javascript:void(0);" class="btn_style1_b cmdSave"><span>저장</span></a>
			<a href="javascript:void(0);" class="btn_style1 popupClose"><span>취소</span></a>
		</div>
		<!-- //하단버튼 -->

	</div>
	<!-- //팝업 컨텐츠 -->

</div>
</body>
</html>