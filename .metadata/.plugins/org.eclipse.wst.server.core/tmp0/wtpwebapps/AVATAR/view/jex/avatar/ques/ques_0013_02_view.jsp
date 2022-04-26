<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
	JexDataCMO UserSession = SessionManager.getSession(request, response);
                        
    // Action 결과 추출
    //GET SESSION
    String CHRG_NM = StringUtil.null2void(request.getParameter("NE-PERSON"));
    String CHRG_TEL_NO = StringUtil.null2void(request.getParameter("CHRG_TEL_NO"));
    String BIZ_NO = StringUtil.null2void(request.getParameter("BIZ_NO"));
    String SEQ_NO = StringUtil.null2void(request.getParameter("SEQ_NO"));
    String PREV_YN = StringUtil.null2void(request.getParameter("PREV_YN"));
    String APP_ID = StringUtil.null2void((String)UserSession.get("APP_ID"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_0013_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20210812084411, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0013_02.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0013_02.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width">
    <meta name="format-detection" content="telephone=no">
    <title></title>
    <%@include file="/view/jex/avatar/include/page_import_head.jsp"%>
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_0013_02.js?<%=_CURR_DATETIME%>"></script>
</head>
<script>
var CHRG_NM = decodeURIComponent('<%=CHRG_NM%>');
var CHRG_TEL_NO = '<%=CHRG_TEL_NO%>';
var BIZ_NO = '<%=BIZ_NO%>';
var SEQ_NO = '<%=SEQ_NO%>';
var PREV_YN = '<%=PREV_YN%>';
var _APP_ID = '<%=APP_ID%>';
</script>
<script type="text/javascript">

</script>

<body class="bg_F9F9F9">
	<!-- content -->
	<div class="content">
		<div class="m_cont pdt12">
			<span data-type="" id="RESULT_TTS" style="display:none;" class="noti_tit">
				<%=CHRG_NM %>세무사에게 전화를 연결하겠습니다.
			</span>
			<!-- 전화연결 -->
			<div class="telConnectBx">
				<div class="telConnectBx_inn">
					<dl>
						<dt><img src="../img/ico_telConnect.png" alt="전화연결"></dt>
						<dd>
							<p>
								<strong id="" class="c_793FFB"><%=CHRG_NM %> 세무사</strong>에게 전화를 연결하겠습니다.
							</p>
						</dd>
					</dl>
				</div>
			</div>
			<!-- //전화연결 -->
	
			<!-- 전화연결(정보) -->
			<div class="telConnectBx_info">
				<div class="telConnectBx_info_inn">
					<dl>
						<dt><p id=""><%=CHRG_NM %></p></dt>
						<dd><p id="CHRG_TEL_NO"></p></dd>
					</dl>
				</div>
			</div>
			<!-- //전화연결(정보) -->
	
			<!-- 버튼 -->
			<div class="btn_add3 mgt32">
				<div class="btn_add3_inn">
					<a href="#none" class="btn_inSmall" id="btn_back">취소</a>
				</div>
			</div>
			<!-- //버튼 -->
		</div>
	</div>
	<!-- //content -->
</body>

</html>