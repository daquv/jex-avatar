<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.web.util.WebCommonUtil"%>
<%@page import="jex.exception.IJexExceptionInfo"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>

<%
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
    Throwable tt = util.getThrowable();
    String strCode    = StringUtil.null2void(request.getParameter("code"), "500");
    String strMessage = StringUtil.null2void(request.getParameter("msg"), "프로그램 오류가 발생하였습니다.");

    if("500".equals(strCode) && tt instanceof IJexExceptionInfo) {
        IJexExceptionInfo je = (IJexExceptionInfo)tt;
        strCode    = je.getCode();
        strMessage = je.getMessage();
        
        if("SES001".equals(strCode)) {
            strMessage = "연결이 끊어졌습니다. 앱을 종료합니다.";
        }
    }

    if((tt != null)&& (tt.getMessage()!=null)){
	    if((tt.getMessage().indexOf("Session DisConnected") > 0) ||(tt.getMessage().indexOf("Session Disconnect") > 0)){
	    	strCode = "Session Disconnect";
	    }
    }
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
	try{ iWebAction("changeTitle",{"_title" : "안내", "_type" : "4"}); 	}catch(e){}
	
	function fn_back(){
		iWebAction("fn_app_finish");
	}
	</script>
	
</head>
<body>

	<!-- content -->
	<div class="content">
		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			<!-- 컨텐츠 영역 -->
			<div class="notibx_wrap type2">
				<div class="inner">
					<div class="ico ico4"></div>
					<div class="noti_cn2">
						<%=strMessage %>
					</div>
				</div>
			</div>
			<!-- //컨텐츠 영역 -->

		</div>
		
		<!-- 버튼영역 -->
		<div class="btn_add">
			<a class="btn_s01" href="javascript:fn_back();">확인</a>
		</div>
		<!-- //버튼영역 -->
		
	</div>
	<!-- //content -->
	
</body>
</html>