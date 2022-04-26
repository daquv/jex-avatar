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
 * @File Name        : blbd_0101_00_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/blbd
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200828142610, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/blbd/blbd_0101_00.js
 * @JavaScript Url   : /js/jex/avatar/admin/blbd/blbd_0101_00.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
	<title>게시물관리</title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/js/jex/avatar/admin/blbd/blbd_0101_00.js?<%=DateTime.getInstance().getDate("yyyymmddhh24miss")%>"></script>
</head>

<body>

<!-- 검색 목록 유지 데이터 -->


<div class="wrap">
	 <!-- Container -->
    <div class="container">
    	<jsp:include page="/view/jex/avatar/admin/include/com_menu.jsp">
			<jsp:param name="MENU" value="cstm"/>
		</jsp:include>
		
		<div class="content">	
            <div class="content_wrap">
        		<iframe src="blbd_0101_01.act" frameborder="0" width="100%" style="height:950px;" name="ifrm_page" id="ifrm_page"></iframe>  	
			</div>
		</div>
		
      
		
    </div><!-- end container -->
    <%@include file="/view/jex/avatar/admin/include/com_footer.jsp"%>
</div><!-- end wrap -->
                

<%@include file="/view/jex/avatar/admin/include/com_bottom.jsp"%>
<%@include file="/view/jex/avatar/admin/include/view_stgup.jsp"%>              

</body>
</html>


