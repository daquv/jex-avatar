<%@ page contentType="text/html;charset=UTF-8" %>

<%
	out.print("{\"RESULT\":\""+request.getSession().getAttribute("_jgrid_download_result_")
		+"\",\"FILE_NAME\":\""+request.getSession().getAttribute("_file_name")
		+"\",\"ACCS_IP\":\""+request.getSession().getAttribute("_accs_ip")
		+"\"}");

%>