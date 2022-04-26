<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%@page import="com.avatar.session.SessionManager"%>
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
 * @File Name        : ques_0001_09_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김예지 (  )
 * @Description      : 질의예시목록(제로페이)
 * @History          : 20211223172913, 김예지
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0001_09.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0001_09.js
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
    <style>
    	.banner_slideMN:after{height:unset;}
    </style>
</head>


<body  class="bg_F5F5F5" >

<!-- content -->
<div class="content m_cont_pd25">
 <!-- style="display:none;" -->
	
	<!-- 제로페이 -->
	<!-- 질문 -->
	<div class="askAvatar_mBx type1 mgt20">
		<ul>
			<li>
				<a href="#none" class="disable">
					<span class="ic ic_03"></span>
					<span class="tx">제로페이 질문</span>
				</a>
				<div class="askAvatar_sub" id="zpQues" name="quesList">
					<ul>
						<li intent="ZNN001"><a>"제로페이 결제금액은?"</a></li>
						<li intent="ZNN002"><a>"제로페이 결제내역은?"</a></li>
						<li intent="ZNN008"><a>"제로페이 상품권 결제 내역은?"</a></li>
						<li intent="ZNN004"><a>"제로페이 결제취소금액은?"</a></li>
						<li intent="ZNN005"><a>"제로페이 결제취소내역은?"</a></li>
						<li intent="ZNN009"><a>"제로페이 상품권 결제 취소내역은?"</a></li>
						<li intent="ZNN006"><a>"제로페이 입금액은?"</a></li>
						<li intent="ZNN007"><a>"제로페이 입금 내역은?"</a></li>
						<li intent="AZN002"><a>"결제 가능한 상품권은?"</a></li>
						<li intent="ZNN003"><a>"제로페이 결제수수료는?"</a></li>
						<li intent="ASP003"><a>"제로페이 가맹점 보여줘"</a></li>
						<li intent="ASP004"><a>"제로페이 가맹점 목록은?"</a></li>
						<li intent="AZN001"><a>"QR코드는?"</a></li>
						<!-- <li intent="ZNN010"><a>"제로페이 콜센터 전화해줘"</a></li> -->
					</ul>
				</div>
			</li>
		</ul>
	</div>
	<!-- //질문 -->
	<!-- //제로페이 -->
</div>
<!-- //content -->

	
</body>
</html>