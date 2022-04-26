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
    String APP_ID = StringUtil.null2void(request.getParameter("APP_ID"));
    String API_ID = StringUtil.null2void(request.getParameter("API_ID"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : srvc_0102_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/srvc
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200306181500, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/srvc/srvc_0102_02.js
 * @JavaScript Url   : /js/jex/avatar/admin/srvc/srvc_0102_02.js
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
<script type="text/javascript" src="/js/jex/avatar/admin/srvc/srvc_0102_02.js?<%=_sLocalTime_comm %>"></script>
</head>
<body>
	<input type="hidden" id="APP_ID_BASE" value="<%=APP_ID%>" />
	<input type="hidden" id="API_ID_BASE" value="<%=API_ID%>" />
	<div class="pop_wrap" style="width:792px;">
		<!-- 팝업 헤더 -->
		<div class="pop_header">
			<h1>질의API관리</h1>
			<a href="#none" class="btn_popclose popupClose"><img src="../img/btn_popclose.gif" alt="popup close"></a>
		</div>
		<!-- //팝업 헤더 -->

		<!-- 팝업 컨텐츠 -->
		<div class="pop_container">

			<!-- 테이블 -->
			<table class="tbl_input2 mgb15" summary="">
				<caption></caption>
				<colgroup>
					<col style="width:150px;" />
					<col style="width:550px;" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><div>앱명<em class="point"></em></div></th>
						<td class="ipt">
							<div>
								<!-- <input type="text" class="" placeholder="" value="" id="APP_ID" style="width:90%;" maxlength="20" /> -->
								<span id="APP_ID"></span>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row"><div>API ID<em class="point"></em></div></th>
						<td class="ipt">
							<div>
								<span id="API_ID"></span>
								<!-- <input type="text" class="" placeholder="" value="" id="API_ID" style="width:30%;" maxlength="50" />
								<a style="margin-left:8px;" id="btn_chk"class="btn_style3" ><span>중복확인</span></a> -->
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row"><div>카테고리<em class="point"></em></div></th>
						<td class="ipt">
							<div>
								<span id="CTGR_CD"></span>
								<!-- <select class="" style="" id="CTGR_CD"></select> -->
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row"><div>상태<em class="point"></em></div></th>
						<td class="ipt">
							<div>
								<label><input type="radio" name="STTS" value="1" disabled/> 승인대기  </label>
								<label><input type="radio" name="STTS" value="2" disabled/> 배포대기 </label>
								<label><input type="radio" name="STTS" value="3" /> 배포중  </label>
								<label><input type="radio" name="STTS" value="4" /> 배포중지  </label>
								<label><input type="radio" name="STTS" value="5" disabled/> 반려  </label>
								<label><input type="radio" name="STTS" value="0" /> 임시정지 </label>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row"><div>인텐트<em class="point"></em></div></th>
						<td class="ipt">
							<div>
								<span id="INTE_CD"></span>
								<!-- <select class="" style="" id="INTE_CD"></select> -->
							</div>
						</td>
					</tr>
					<tr style="height:90px;">
						<th scope="row"><div>설명</div></th>
						<td class="ipt">
							<div>
								<textarea id="QUES_DESC" type="text" value="" placeholder="" maxlength="4000" style="width: 90%; height: 60px;" disabled></textarea>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			<!-- //테이블 -->

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