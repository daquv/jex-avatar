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
    String BIZ_NO = StringUtil.null2void(request.getParameter("BIZ_NO"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : plfm_0102_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/plfm
 * @author           : 김별 (  )
 * @Description      : 플랫폼회사등록화면
 * @History          : 20200710144815, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/plfm/plfm_0102_02.js
 * @JavaScript Url   : /js/jex/avatar/admin/plfm/plfm_0102_02.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title></title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/admin/js/include/smart.excel.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript" src="/admin/js/include/smart.grid.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript" src="/js/jex/avatar/admin/plfm/plfm_0102_02.js?<%=_sLocalTime_comm %>"></script>
</head>
<body>
<input type="hidden" id="BIZ_NO_BASE" value="<%=BIZ_NO%>" />
	<div class="pop_wrap" style="width:792px;">
		<!-- 팝업 헤더 -->
		<div class="pop_header">
			<h1>회사정보관리</h1>
			<a href="#none" class="btn_popclose popupClose"><img src="../img/btn_popclose.gif" alt="popup close"></a>
		</div>
		<!-- //팝업 헤더 -->

		<!-- 팝업 컨텐츠 -->
		<div class="pop_container">
			<div class="tbl_input2 mgb20">
				<table summary="">
					<caption></caption>
					<colgroup>
						<col style="width: 100px;">
						<col>
						<col style="width: 100px;">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><div>회사명</div></th>
							<td class="ipt">
								<div>
									<input id="BSNN_NM" type="text" value="" maxlength="100" style="width: 80%;">
								</div>
								
							</td>
							<th scope="row"><div>사업자번호</div></th>
							<td class="ipt">
								<div id="">
									<% if("".equals(StringUtil.null2void(BIZ_NO))){  %>
										<input id="BIZ_NO" type="text" value="" maxlength="20" style="width: 80%;">
									<%} else if (!"".equals(StringUtil.null2void(BIZ_NO))){%>
										<span id="BIZ_NO"></span>
									<%} %>
								</div>
							</td>		
													
						</tr>
						<tr>
							<th scope="row"><div>대표자명</div></th>
							<td class="ipt">
								<div id="">		
									<input id="RPPR_NM" type="text" value="" maxlength="100" style="width: 80%;">
								</div>
							</td>
							<th scope="row"><div>대표전화</div></th>
							<td class="ipt">
								<div>
									<input id="TEL_NO" type="text" value="" maxlength="30" style="width: 80%;">
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row"><div>업태</div></th>
							<td class="ipt">
								<div>
									<input id="BSST" type="text" value="" maxlength="100" style="width: 80%;">
								</div>
							</td>
							
							<th scope="row"><div>업종</div></th>
							<td class="ipt">
								<div>
									<input id="TPBS" type="text" value="" maxlength="100" style="width: 80%;">
								</div>
							</td>							
						</tr>
						<tr>
							 <th scope="row" ><div>주소</div></th>
                             <td colspan="3">
	                             <div>
	                                 <input id="ZPCD" type="text" value="" maxlength="6" style="width: 30%;">
	                                 <br>
	                                 <input id="ADRS" type="text" value="" maxlength="200" style="width: 90%;">
	                                 <br>
	                                 <input id="DTL_ADRS" type="text" value="" maxlength="100" style="width: 90%;">
	                             </div>
                             </td>
							
						</tr>
						<tr>
							 <th scope="row" ><div>회사소개</div></th>
                             <td colspan="3">
	                             <div>
	                                 <textarea id="BSNN_INFO" type="text" value="" placeholder="" maxlength="1000" style="width: 90%; height: 60px;"></textarea>
	                             </div>
	                             
                             </td>
							
						</tr>
						<tr>
							 <th scope="row" ><div>상태</div></th>
                             <td colspan="3">
	                             <div>
	                             	<input type="radio" name="stts" value="1" id="stts1" /><label for="stts1">  정상  </label>
									<input type="radio" name="stts" value="9" id="stts9" /><label for="stts9">  해지  </label>
	                             </div>
                             </td>
							
						</tr>
						
					</tbody>
				</table>
			</div>
			
		<!-- 하단버튼 -->
		<div class="tac">
			<a href="javascript:void(0);" class="btn_style1_b cmdSave"><span>저장</span></a>
			<a href="javascript:void(0);" class="btn_style1 popupClose"><span>취소</span></a>
		</div>
		<!-- //하단버튼 -->

	</div>
	<!-- //팝업 컨텐츠 -->

</div>
</body>
</html>