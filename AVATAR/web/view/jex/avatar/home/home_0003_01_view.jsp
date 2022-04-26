<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    // WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : home_0003_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/home
 * @author           : 김예지 (  )
 * @Description      : 네이버 로그분석 스크립트 
 * @History          : 20211029111019, 김예지
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/home/home_0003_01.js
 * @JavaScript Url   : /js/jex/avatar/home/home_0003_01.js
 * </pre>
 **/
%>

<!-- Naver Log Analysis Script -->
<script type="text/javascript" src="//wcs.naver.net/wcslog.js"></script>  
<script type="text/javascript">
function logAnalysis() {
	var userAgent = getUserAgent();
	if(userAgent.indexOf("android") > -1 || userAgent.indexOf("iphone") > -1 || userAgent.indexOf("ipad") > -1 || document.location.host.indexOf("m.askavatar") > -1){
		var _nasa={};
		if(window.wcs) _nasa["cnv"] = wcs.cnv("1","10"); // 전환유형, 전환가치 설정해야함. 설치매뉴얼 참고
		return true;		
	}
}
</script> 
<script type="text/javascript">
	var userAgent = getUserAgent();
	if(userAgent.indexOf("android") > -1 || userAgent.indexOf("iphone") > -1 || userAgent.indexOf("ipad") > -1 || document.location.host.indexOf("m.askavatar") > -1){
		if (!wcs_add) var wcs_add={};
		wcs_add["wa"] = "s_55a427dc3395";
		if (!_nasa) var _nasa={};
		if(window.wcs){
			wcs.inflow();
			wcs_do(_nasa);
		}
	}
</script>
