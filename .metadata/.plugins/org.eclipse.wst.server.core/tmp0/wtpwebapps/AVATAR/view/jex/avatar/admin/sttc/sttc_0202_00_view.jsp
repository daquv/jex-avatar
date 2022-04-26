<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : sttc_0202_00_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/sttc
 * @author           : 김태훈 (  )
 * @Description      : 데이터가져오기등록현황
 * @History          : 20200309135336, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/sttc/sttc_0202_00.js
 * @JavaScript Url   : /js/jex/avatar/admin/sttc/sttc_0202_00.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
	<title>통계보고서</title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/js/jex/avatar/admin/sttc/sttc_0202_00.js?<%=DateTime.getInstance().getDate("yyyymmddhh24miss")%>"></script>
</head>

<body>

<!-- 검색 목록 유지 데이터 -->


<div class="wrap">
	 <!-- Container -->
    <div class="container">
    	<jsp:include page="/view/jex/avatar/admin/include/com_menu.jsp">
			<jsp:param name="MENU" value="sttc"/>
		</jsp:include>
		
		<div class="content">	
            <div class="content_wrap">
        		<iframe src="sttc_0202_01.act" frameborder="0" width="100%" style="height:950px;" scrolling="no" name="ifrm_page" id="ifrm_page"></iframe>  	
			</div>
		</div>
		
      
		
    </div><!-- end container -->
    <%@include file="/view/jex/avatar/admin/include/com_footer.jsp"%>
</div><!-- end wrap -->
                

<%@include file="/view/jex/avatar/admin/include/com_bottom.jsp"%>
<%@include file="/view/jex/avatar/admin/include/view_stgup.jsp"%>              

</body>
</html>


