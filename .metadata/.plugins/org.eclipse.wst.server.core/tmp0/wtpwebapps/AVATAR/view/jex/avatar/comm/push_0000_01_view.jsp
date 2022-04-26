<%@page import="java.net.URLEncoder"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);

	String intent = StringUtil.null2void(request.getParameter("INTENT"),"");
	String pageUrl = "";
	// 제로페이매출
	if("ZSN001".equals(intent)){
		pageUrl = "ques_comm_01.act?INTE_INFO="+URLEncoder.encode("{'recog_txt':'\"제로페이 매출 브리핑\"','recog_data':{'Intent':'ZSN001','appInfo':{}}}","UTF-8");
		
    }
	// 카드매출
	else if("ZSC001".equals(intent)){
		pageUrl = "ques_comm_01.act?INTE_INFO="+URLEncoder.encode("{'recog_txt':'\"카드매출브리핑\"','recog_data':{'Intent':'ZSC001','appInfo':{}}}","UTF-8");
	}
	
	if(!"".equals(pageUrl)){
		response.sendRedirect(pageUrl);
	}
    
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : push_0000_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/comm
 * @author           : 박지은 (  )
 * @Description      : 
 * @History          : 20210909082037, 박지은
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/comm/push_0000_01.js
 * @JavaScript Url   : /js/jex/avatar/comm/push_0000_01.js
 * </pre>
 **/
%>
