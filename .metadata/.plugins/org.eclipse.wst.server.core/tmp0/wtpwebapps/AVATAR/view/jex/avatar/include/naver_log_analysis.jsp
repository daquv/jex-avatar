<%@page contentType="text/html;charset=UTF-8" %>
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
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/include/naver_log_analysis.js
 * @JavaScript Url   : /js/jex/avatar/include/naver_log_analysis.js
 * </pre>
 **/
%>

<script type="text/javascript" src="//wcs.naver.net/wcslog.js"></script>  
<script type="text/javascript">
function isMobileEnv() {
	var agent = navigator.userAgent.toLowerCase();
	if (agent.indexOf("iphone") > -1 || agent.indexOf("ipad") > -1 || agent.match('android') != null || document.location.host.indexOf("m.askavatar") > -1) {
		return true;
	} else {
		return false;
	}
} 

function logAnalysis() {
	if(isMobileEnv()){
		var _nasa={};
		if(window.wcs) _nasa["cnv"] = wcs.cnv("5","10"); // 전환유형, 전환가치 설정해야함. 설치매뉴얼 참고
		wcs_do(_nasa);
		return true;
	}
}

if(isMobileEnv()){
	if (!wcs_add) var wcs_add={};
	wcs_add["wa"] = "s_55a427dc3395";
	if (!_nasa) var _nasa={};
	if(window.wcs){
		wcs.inflow();
		wcs_do(_nasa);
	}
}
</script>
