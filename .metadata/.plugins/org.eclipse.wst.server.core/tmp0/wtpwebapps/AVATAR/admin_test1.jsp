<%@page contentType="text/html;charset=UTF-8" %>
<%
	if(request.getServerName().toLowerCase().indexOf("dev") > -1){
		response.sendRedirect("/gw/weauth.jsp?CNTS_IDNT_ID=AVATAR_CSTM&RDM_KEY=test"); //고객관리
	}
%>
