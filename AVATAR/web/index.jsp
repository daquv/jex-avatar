<%@page contentType="text/html;charset=UTF-8" %>
<%
	if(request.getServerName().toLowerCase().indexOf("admin") > -1 || request.getServerName().toLowerCase().indexOf("app") > -1 ){
		return;
	}else if(request.getServerName().toLowerCase().indexOf("dev") == -1){
		String userAgent = request.getHeader("User-Agent").toLowerCase();
		if(userAgent.indexOf("android") > -1 || userAgent.indexOf("iphone") > -1 || userAgent.indexOf("ipad") > -1 || request.getServerName().toLowerCase().indexOf("m.askavatar") > -1 || request.getServerName().toLowerCase().indexOf("www.askavatar") > -1){
			// response.sendRedirect("https://m.askavatar.ai/home_0002_01.act");
			response.sendRedirect("http://localhost:8080/home_0002_01.act");
		}else{
			// response.sendRedirect("https://askavatar.ai/home_0001.act");	// 공인인증서 복사 페이지
			//response.sendRedirect("https://m.askavatar.ai/home_0002_01.act");
			response.sendRedirect("http://localhost:8080/home_0002_01.act");
		}
		return;
	}else if(request.getRemoteAddr().indexOf("10.254.24") == -1){
		// 다큐브 여의도 본사 IP 허용
		if(request.getRemoteAddr().indexOf("121.131.131") == -1){
			return;
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
	<style>
	.container { padding-right:15px;}
	html, body, div, ul {margin:0;padding:0;border:0;outline:0;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box;}
	ul, ol, dl {list-style:none;}
	.list li {margin:5px;padding:5px;position:relative; width:98%; margin-top:12px; background:#fff; border-radius:5px; box-shadow:0 2px 0 0 rgba(0,0,0,.05);}
	.list li.b {margin:5px;padding:5px;background-color:#99d7f5;}
	.list li.w {margin:5px;padding:5px;background-color:#fff;}
	.list li.o {margin:5px;padding:5px;background-color:#f5d099;}
	</style>
</head>
<body>
<div id="wrap">
<div class="grey_area container">
<div style="padding:7px;">개발 테스트</div>
<div>
<ul class="list">
	<li class="b"><a href="/test_0002_01.act">PUSH SEND</a></li>
	<li class="b"><a href="/test/publ_main.jsp">퍼블확인</a></li>
	<li class="b"><a href="test_0001_01.act">테스트목록조회 </a></li>
	<li class="w"><a href="/gw/auth.jsp">로그인 (test)</a></li>
	<li class="w"><a href="/gw/auth.jsp?USE_INTT_ID=A039900001">로그인 (A039900001)</a></li>
	<li class="w"><a href="/gw/auth.jsp?USE_INTT_ID=A210100001">로그인 (A210100001)</a></li>
	<li class="w"><a href="/gw/auth.jsp?USE_INTT_ID=A211000006">로그인 (A211000006)</a></li>
	<li class="w"><a href="/gw/auth.jsp?USE_INTT_ID=A200300026&LGIN_APP=AVATAR">로그인 (A200300026)</a></li>
	<li class="w"><a href="/gw/auth.jsp?USE_INTT_ID=A211000008&LGIN_APP=AVATAR">로그인 (A211000008)</a></li>
	<li class="w"><a href="join_0001_01.act">회원가입</a></li>
	<li class="w"><a href="ques_0001_01.act">질의</a></li>
	<li class="w"><a href="basic_0003_01.act">데이터</a></li>
	<li class="w"><a href="basic_0001_01.act">더보기</a></li>
	<li class="w"><a href="home_0001.act">인증서 복사</a></li>
	<!-- admin포탈에 등록 -->
	<li class="o"><a href="/gw/weauth.jsp?CNTS_IDNT_ID=AVATAR_CSTM&RDM_KEY=test" target="_blank">어드민 (AVATAR 고객관리)</a></li>
	<li class="o"><a href="/gw/weauth.jsp?CNTS_IDNT_ID=AVATAR_STTC&RDM_KEY=test" target="_blank">어드민 (AVATAR 통계보고서)</a></li>
	<li class="o"><a href="/gw/weauth.jsp?CNTS_IDNT_ID=AVATAR_HMPG&RDM_KEY=test" target="_blank">어드민 (AVATAR 홈페이지관리)</a></li>
	<li class="o"><a href="/gw/weauth.jsp?CNTS_IDNT_ID=AVATAR_SRVC&RDM_KEY=test" target="_blank">어드민 (AVATAR 서비스관리)</a></li>
	<li class="o"><a href="/gw/weauth.jsp?CNTS_IDNT_ID=AVATAR_SSTM&RDM_KEY=test" target="_blank">어드민 (AVATAR 시스템관리 )</a></li>
	<!-- admin포탈에 등록 x -->
	<li class="o"><a href="/gw/weauth.jsp?CNTS_IDNT_ID=AVATAR_SRVC2&RDM_KEY=test" target="_blank">어드민 (질의센터)</a></li>
	<li class="o"><a href="/gw/weauth.jsp?CNTS_IDNT_ID=AVATAR_PLFM&RDM_KEY=test" target="_blank">어드민 (플랫폼회원관리)</a></li>
	<li class="o"><a href="/gw/weauth.jsp?CNTS_IDNT_ID=AVATAR_BLBD&RDM_KEY=test" target="_blank">어드민 (게시물관리)</a></li>
	<li class="o"><a href="/gw/weauth.jsp?CNTS_IDNT_ID=AVATAR_CLDC&RDM_KEY=test" target="_blank">어드민 (클라우드센터)</a></li>
</ul>
</div>
</div>
</div>
</body>
</html>
