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
    String QUES_CTT = StringUtil.null2void(request.getParameter("QUES_CTT"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : plfm_0101_03_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/plfm
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200709165351, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/plfm/plfm_0101_03.js
 * @JavaScript Url   : /js/jex/avatar/admin/plfm/plfm_0101_03.js
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
<script type="text/javascript" src="/js/jex/avatar/admin/plfm/plfm_0101_03.js?<%=_sLocalTime_comm %>"></script>
</head>
<script>
	REC = '<%=request.getParameter("updateData")%>';
</script>
<body>
	<div class="pop_wrap" style="width:500px;">
		<!-- 팝업 헤더 -->
		<div class="pop_header">
			<h1>사용자상태관리</h1>
			<a href="#none" class="btn_popclose popupClose"><img src="../img/btn_popclose.gif" alt="popup close"></a>
		</div>
		<!-- //팝업 헤더 -->

		<!-- 팝업 컨텐츠 -->
		<div class="pop_container">
			<div class="tbl_input2 mgb20">
				<table summary="">
					<caption></caption>
					<colgroup>
						<col style="width: 140px;">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><div>가입상태</div></th>
							<td class="ipt">
								<div>
									<select id="STTS">
										<option value="-1">선택하세요</option>
										<option value="2">신청대기</option>
										<option value="3">승인대기</option>
										<option value="1">정상</option>
										<option value="9">해지</option>
									</select>
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