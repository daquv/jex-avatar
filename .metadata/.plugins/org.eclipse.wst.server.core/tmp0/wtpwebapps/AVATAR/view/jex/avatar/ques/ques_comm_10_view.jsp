<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="jex.json.parser.JSONParser"%>
<%@page import="jex.json.JSONObject"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
	String inteInfo = StringUtil.null2void(request.getParameter("INTE_INFO"),"{}");
	String userCi = StringUtil.null2void(request.getParameter("USER_CI"),"");
	String prevYn = StringUtil.null2void(request.getParameter("PREV_YN"),"N");
	
	JexDataCMO UserSession = SessionManager.getSession(request, response);
    String APP_ID = StringUtil.null2void((String)UserSession.get("APP_ID"), "ZEROPAY");
    String LGIN_APP = StringUtil.null2void((String)UserSession.get("LGIN_APP"), "ZEROPAY");
    
    String devYn = JexSystem.getProperty("JEX.id").indexOf("_DEV") > -1 ? "Y": "N";
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_comm_10_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김예지 (  )
 * @Description      : 
 * @History          : 20211209084827, 김예지
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_comm_10.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_comm_10.js
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
    <script>
    var inteInfo = <%=inteInfo%>;
	var _thisCont = {
		PAGE_NO : 1,
		PAGE_CNT : 25,
		INTE_INFO : <%=inteInfo%>, 
	}
	var userCi = '<%=userCi%>';
	var prevYn = '<%=prevYn%>';
	var LGIN_APP = '<%=LGIN_APP%>';
	</script>
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_comm_10.js?<%=_CURR_DATETIME%>"></script>
   <%--  <% if(!"".equals(StringUtil.null2void(inteCd))) { %>
    	<script type="text/javascript" src="/js/jex/avatar/ques/ques_0199_<%=inteCd%>.js?<%=_CURR_DATETIME%>" onerror=""></script>
    <% } %> --%>
</head>
<body>

	<!-- Header Title 영역 -->
		<div class="zero_Avatar">
		 	<div class="sect_zero_Avatar bg_ECF4FF">
				<div class="tit_zero_Avatar mgt15">
					<div class="tit">
						<div class="tit_wrap">
							<h2>
								<strong class="type2" id="INTE_NM"></strong>
							</h2>
						</div>
					</div>
				</div>
			</div>
		</div>
	<!-- //Header Title 영역 -->
		
	<!-- content -->
	<input type="hidden" class="CNT" id="TAX_CNT" value="">
	<input type="hidden" class="CNT" id="SALE_CNT" value="">
	<input type="hidden" class="CNT" id="_MEST_CNT" value="">
	<input type="hidden" id="BZAQ_REC">
	
		<div class="content" style="display:none;" >
			<!-- (modify)20210517 -->
			<div class="m_cont loading_bx" id="REALTIME" style="display:none;"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
				<dl>
					<dt>
						<div class="lds-spinner"><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div></div>
					</dt>
					<dd>
						<span>데이터 처리중 입니다.</span>
						<span>잠시만 기다려주세요.</span>
					</dd>
				</dl>
			</div>
			<div class="m_cont pdt12" id="MAIN" style="display:none;"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
				<%//Admin에서 등록한 html 내용을 표시 할 영역 %>
				
	
			</div>
		</div>
		<!-- //content -->
	<!-- webResultTTS :: <span style="display:none;" id="DEV_TEST"></span> -->


</body>
</html>