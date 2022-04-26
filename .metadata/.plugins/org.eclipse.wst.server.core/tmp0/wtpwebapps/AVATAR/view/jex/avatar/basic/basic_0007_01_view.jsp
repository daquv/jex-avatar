<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%@page import="com.avatar.session.SessionManager"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
     String userAgent = request.getHeader("User-Agent");
        System.out.println("#############");
        System.out.println(userAgent);
        
        String userAgentInfo[] = userAgent.split(";");
        String APP_VER = "";
        String APP_LAST_VER = "";
        for(int i=0 ; i<userAgentInfo.length ; i++)
        {
        	if(userAgentInfo[i].indexOf("nma-app-ver") > -1){
        		int idx = userAgentInfo[i].indexOf("=");
        		APP_VER = userAgentInfo[i].substring(idx+1).replaceAll("[\\[\\]]", "");
        		System.out.println("APP VER : "+APP_VER);
        	} else if(userAgentInfo[i].indexOf("nma-app-last-ver") > -1){
        		int idx = userAgentInfo[i].indexOf("=");
        		APP_LAST_VER = userAgentInfo[i].substring(idx+1).replaceAll("[\\[\\]]", "");
        		System.out.println("APP VER : "+APP_LAST_VER);
        	} 
            
        }
        System.out.println("#############");
        
        
      	//GET SESSION
    	JexDataCMO UserSession = SessionManager.getSession(request, response);
        String APP_ID = StringUtil.null2void((String)UserSession.get("APP_ID"));
        String LGIN_APP = StringUtil.null2void((String)UserSession.get("LGIN_APP")); // 로그인한 앱
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : basic_0007_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20201117141748, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0007_01.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0007_01.js
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
    <script type="text/javascript" src="/js/jex/avatar/basic/basic_0007_01.js?<%=_CURR_DATETIME%>"></script>
    <style>
    .on{
    	display : block !important;
    }
    </style>
</head>
<body class="bg_F5F5F5">
<input type="hidden" id="LGIN_APP" value="<%=LGIN_APP %>">
<!-- content -->
	<div class="content">

		<div class="m_cont pdt12"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<!-- 컨텐츠 영역 -->
			<div class="" style="">
				<div class="app_info type1">
					<ul>
						<li>
							<h2>앱버전</h2>
							<div class="right">
								<span class="c_blue">현재 <span id="APP_LAST_VER"><%=APP_LAST_VER %></span> / 최신 <span id="APP_VER"><%=APP_VER %></span></span>
								<!-- <a href="#none" class="btn_arr"></a> -->
							</div>
						</li>
						<li>
							<h2>서비스 이용약관</h2>
							<div class="right">
								<a href="#none" class="btn_arr"></a>
							</div>
						</li>
						<li>
							<h2>개인정보 처리방침</h2>
							<div class="right">
								<a href="#none" class="btn_arr"></a>
							</div>
						</li>
						<li>
							<h2>개인정보 제3자 제공 동의</h2>
							<div class="right">
								<a href="#none" class="btn_arr"></a>
							</div>
						</li>
						<li>
							<h2>마케팅 정보 수신 동의</h2>
							<div class="right">
								<a href="#none" class="btn_arr"></a>
							</div>
						</li>
						<% if("SERP".equals(LGIN_APP)) {%>
				    		<li>
								<h2>경리나라 개인정보 수집 및 이용 동의</h2>
								<div class="right">
									<a href="#none" class="btn_arr"></a>
								</div>
							</li>
							<li>
								<h2>경리나라 제3자 정보 제공 동의</h2>
								<div class="right">
									<a href="#none" class="btn_arr"></a>
								</div>
							</li>
		    			<% } else if("ZEROPAY".equals(LGIN_APP)) {%>
<!-- 				    		<li> -->
<!-- 								<h2>제로페이 개인정보 수집 및 이용 동의</h2> -->
<!-- 								<div class="right"> -->
<!-- 									<a href="#none" class="btn_arr"></a> -->
<!-- 								</div> -->
<!-- 							</li> -->
<!-- 							<li> -->
<!-- 								<h2>제로페이 제3자 정보 제공 동의</h2> -->
<!-- 								<div class="right"> -->
<!-- 									<a href="#none" class="btn_arr"></a> -->
<!-- 								</div> -->
<!-- 							</li> -->
		    			
		    			<% } else {}%>
						
					</ul>
				</div>
			</div>
			<!-- //컨텐츠 영역 -->
		</div>

	</div>
	<!-- //content -->

</body>
</html>