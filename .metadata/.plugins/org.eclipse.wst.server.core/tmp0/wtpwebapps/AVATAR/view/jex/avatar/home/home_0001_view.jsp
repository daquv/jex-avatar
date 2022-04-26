<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.util.date.DateTime"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String _CURR_DATETIME = DateTime.getInstance().getDate("yyyymmddhh24miss");
    
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : home_0001_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/home
 * @author           : 신승환 (  )
 * @Description      : 
 * @History          : 20200217093047, 신승환
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/home/home_0001.js
 * @JavaScript Url   : /js/jex/avatar/home/home_0001.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ask avatar</title>
<meta http-equiv="Cache-Control" content="No-Cache">
<meta http-equiv="Pragma" content="No-Cache">
<meta http-equiv="Cache-Control" content="No-Cache">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="title" content="에스크아바타| AI 경영비서">
<meta name="description" content="우리회사, 우리가게 경영관리는 음성인식 AI비서 아바타와 함께! 검색하지 말고 아바타에게 물어보세요.">
<meta name="keywords" content="에스크아바타, ASKAVATAR, 애스크아바타, askavatar, 다큐브, AI, 경리프로그램, 세무관리, 매입매출, 음성비서, 가게매출, AI플랫폼, 사장님비서, AI 경영비서">
<!-- The Open Graph protocol -->
<meta property="og:type" content="website">
<meta property="og:title" content="에스크아바타는 당신만의 AI경영비서입니다.">
<meta property="og:description" content="매일 보는 경영정보, 아바타에게 물어보세요.">
<meta property="og:url" content="https://askavatar.ai/">
<meta property="og:image" content="https://m.askavatar.ai/home/img/og_image.png"><!-- [D]리얼경로로 변경하세요 -->
<meta name="naver-site-verification" content="af5eefb31c811f5854a8cacfcc7cf83880a48cd4" />
<!-- //The Open Graph protocol -->
<link rel="SHORTCUT ICON" href="https://m.askavatar.ai/home/img/16x16-C.ico"><!-- [D]리얼경로로 변경하세요 -->
<link rel="stylesheet" href="../css/reset.css">
<link rel="stylesheet" href="../css/content.css">
<!-- 
<script type="text/javascript" src="../js/1.10.2.jquery.min.js"></script>
<script type="text/javascript" src="../js/moaModal.js"></script>
<script type="text/javascript" src="../js/jquery.placeholder.min.js"></script>
<script type="text/javascript" src="../js/collection.fn.1.0.0.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
-->
<script type="text/javascript" src="/js/jex/semo/home/home_0001.js?<%=_CURR_DATETIME%>"></script>
<script>
/*
$(function(){
	// Invoke the plugin
	$('input, textarea').placeholder({customClass:'my-placeholder'});
});
*/
</script>
</head>

<body>

<div class="wrap">

	<!-- header -->
	<div class="header">
		<!-- header_inner -->
		<div class="header_inner cboth">
			<!-- logo -->
			<div class="flt">
				<div class="logo"><a href="#none"><h1 class="blind">AVATAR</h1></a></div>
			</div>
			<!-- //logo -->
			<!-- (add)20210527 -->
			<!-- link -->
			<div class="frt">
				<div class="mPageMove"><a href="https://m.askavatar.ai/?utm_source=homepage&utm_medium=referral&utm_campaign=homepage_button" class="btn_blue3">모바일 홈페이지 보기</a></div>
			</div>
			<!-- //link -->
			<!-- //(add)20210527 -->
		</div>
		<!-- //header_inner -->
	</div>
	<!-- //header -->

	<!-- container -->
	<iframe id="certi_content1" src="https://cert.bizplay.co.kr/avatar" id="embeded-content" frameborder="0" scrolling="no" width="100%" height="100%" style="min-height:1100px;"></iframe>
	<!-- //container -->

	<hr>

	<!-- footer -->
	<div class="footer">
		<div class="footer_inner">
			<!-- footer_contact_info -->
			<div class="footer_cnt_info">
				<!-- (modify)20210308 -->
				<p>
					<strong class="tx_black">다큐브(주)</strong>
					<span>서울시 영등포구 여의나루로 67 신송빌딩 12층</span><br>
					<span>대표이사 진주영</span><em>|</em><span>사업자 등록번호 763-87-02018</span><br>
					<span>이메일 help@askavatar.ai</span><br>
					<span>Copyrightⓒ 2021 DAQUV. All rights reserved.</span>
				</p>
				<!-- //(modify)20210308 -->
			</div>
			<!-- //footer_contact_info -->
		</div>
	</div>
	<!-- //footer -->

	<hr>

	<!-- (button)goto -->
	<!--<div class="btn_totop_wrap">
		<a href="#none" class="btn_gotoTop"><span class="blind">go to Top</span></a>
	</div>-->
	<!-- //(button)goto -->

</div>

</body>
</html>