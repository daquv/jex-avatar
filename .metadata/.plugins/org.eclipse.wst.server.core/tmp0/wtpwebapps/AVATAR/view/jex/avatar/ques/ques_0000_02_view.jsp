<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%@page import="java.net.URLDecoder"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String bzaqNm = StringUtil.null2void(request.getParameter("NE-COUNTERPARTNAME"));
    String chrgNm = URLDecoder.decode(StringUtil.null2void(request.getParameter("NE-PERSON")));
    String apiYn = StringUtil.null2void(request.getParameter("API_YN"));
    
    JexDataCMO UserSession = SessionManager.getSession(request, response);
    String APP_ID = StringUtil.null2void((String)UserSession.get("APP_ID"));
    String MENU_DV = StringUtil.null2void(request.getParameter("MENU_DV"));
    
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_0000_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200804102751, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0000_02.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0000_02.js
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
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_0000_02.js?<%=_CURR_DATETIME%>"></script>
</head>
<script type="text/javascript">
	var bzaqNm = '<%=bzaqNm%>';
	var chrgNm = '<%=chrgNm%>';
	var apiYn = '<%=apiYn%>';
	var _APP_ID = '<%=APP_ID%>';
	var MENU_DV = '<%=MENU_DV%>';
</script>
<body class="bg_F5F5F5">
<!-- content -->
	<div class="content" style="display:none;">

		<div class="m_cont"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			<span data-type="" id="RESULT_TTS" style="display:none;" >
			<% if("BZAQ".equals(MENU_DV)) {%>
				<div class="noti_tit"><%=bzaqNm%>는 등록된 거래처가 아닙니다.</div> <span class="noti_tit_tts">거래처명을 확인 후 다시 물어봐주세요.</span>
			<% } else if("FRAN".equals(MENU_DV)) {%>
				<div class="noti_tit"><%=bzaqNm%>는 등록된 거래처가 아닙니다.</div> <span class="noti_tit_tts">가맹점명을 확인 후 다시 물어봐주세요.</span>
			<% } else if("COMM".equals(MENU_DV)) {%>
				<div class="noti_tit"><%=bzaqNm%>는 등록된 거래처가 아닙니다.</div> <span class="noti_tit_tts">정보를 확인 후 다시 물어봐주세요.</span>
			<% } else if("TXOF".equals(MENU_DV)) {%>
				<%=chrgNm%> 세무사는 등록되지 않은 정보입니다. 정보를 확인 후 다시 물어봐주세요.
			<% } else {}%>
			</span>
			<!-- 컨텐츠 영역 -->
			<div class="notibx_wrap type5">
				<div class="inner">
					<div class="ico ico8"></div>
					<div class="noti_tit">
					<% if("BZAQ".equals(MENU_DV) || "FRAN".equals(MENU_DV) || "COMM".equals(MENU_DV)) {%>
						'<%=bzaqNm%>'는<br> 등록된 거래처가 아닙니다.
					<% } else if("TXOF".equals(MENU_DV)) {%>
						'<%=chrgNm%>'<span class="c_blue"> 세무사</span>는 등록되지<br> 않은 정보입니다.
					<% } else {}%>
					</div>
				</div>
			</div>
			<!-- //컨텐츠 영역 -->

		</div>

		<!-- 버튼영역 -->
		<!-- 
		<div class="btn_add type1 tip">
			<p class="btn_s04">“거래처?”</p>
		</div>
		-->
		<!-- <div class="btn_add">
			<a href="javascript:void(0);" class="btn_s01">거래처 찾아보기</a>
		</div> -->
		<div class="btn_add type1 tip slideTip">
			<div class="rolling_wrap">
				<ul class="btn_rolling swiper-wrapper">
					<li class="swiper-slide">
						<% if("BZAQ".equals(MENU_DV)) {%>
							<p class="btn_s04">“OOO 거래처 보여줘”</p><br>
							<p class="btn_s04">“거래처 OOO 보여줘”</p>
						<%} else if("FRAN".equals(MENU_DV)) {%>
							<p class="btn_s04">“OOO 가맹점 보여줘”</p><br>
							<p class="btn_s04">“가맹점 OOO 보여줘”</p>
						<%} else if("COMM".equals(MENU_DV)) {%>
							<p class="btn_s04">“OOO 가맹점 보여줘”</p><br>
							<p class="btn_s04">“OOO 거래처 보여줘”</p>
						<% } else if("TXOF".equals(MENU_DV)) {%>
							<p class="btn_s04">“세무사 추천해줘”</p><br>
							<p class="btn_s04">“세무사 연결해줘”</p>
						<% } else {}%>
						
					</li>
				</ul>
			</div>
		</div>
		<!-- //버튼영역 -->

	</div>
	<!-- //content -->
	<!-- (modify)20210413 -->
<script>
var swiper = new Swiper('.rolling_wrap', {
	direction:'vertical',
	allowTouchMove:false,
	autoplay: $('.swiper-slide').length > 1 ? true : false,
	autoplay:{delay:2500},
	loop: $('.swiper-slide').length > 1 ? true : false,
});
</script>
<!-- //(modify)20210413 -->
</body>
</html>