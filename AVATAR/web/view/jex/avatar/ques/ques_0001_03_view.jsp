<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    //GET SESSION 
	JexDataCMO UserSession = SessionManager.getSession(request, response);
    String APP_ID = StringUtil.null2void((String)UserSession.get("APP_ID"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_0001_03_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20201117165249, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0001_03.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0001_03.js
 * </pre>
 **/
%>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="user-scalable=yes, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width">
    <meta name="format-detection" content="telephone=no">
    <title></title>
    <%@include file="/view/jex/avatar/include/page_import_head.jsp"%>
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_0001_03.js?<%=_CURR_DATETIME%>"></script>
</head>

<body class="bg_F5F5F5"><!-- (modify)20210323 -->

<!-- content -->
<div class="content pdb0"><!-- (mnodify)20210517 -->

	<div class="m_cont">
		<div class="s_cont">
			<div class="b_titBx top">
				<div class="tit_wrap">
					<h2 class="tTit"><span class="blind">경리나라 AVATAR</span></h2>
				</div>
				<div class="dsc_wrap mgt20">
					<p>경리나라도! 텍스트로 조회하지 말고 물어보세요!</p>
				</div>
			</div>
			<div class="grp_cont">
				<div class="tit_wrap">
					<h3>
						모바일경리나라<small>(경리나라m)</small>에서<br>
						아바타를 사용해보세요!
					</h3>
				</div>
				<div class="imgcont">
					<div class="b043_1"><span class="blind"></span></div>
				</div>
				<div class="dsc_wrap mgt32">
					<p>
						경리나라에 등록된 금융정보, 매출/매입정보,<br>
						거래처 정보를 기반으로 아바타가 즉시 답을 줍니다.
					</p>
				</div>
			</div>
			<div class="b_titBx">
				<div class="tit_wrap">
					<h4>
						<small>입력하지 마세요. 직원에게 물어보지 마세요.</small><br>
						경리나라m에서 아바타에게 물어보세요.
					</h4>
				</div>
			</div>
			<div class="grp_cont type1">
				<div class="tit_wrap round">
					<h3>
						“자금 현황은?”
					</h3>
				</div>
				<div class="imgcont">
					<div class="b043_2"><span class="blind"></span></div>
				</div>
				<div class="dsc_wrap mgt15">
					<p>
						계좌잔액과 거래내역을 기반으로<br>
						자금현황에 대한 정보를 받을 수 있습니다.
					</p>
				</div>
			</div>
			<div class="grp_cont type1">
				<div class="tit_wrap round">
					<h3>
						“현재 미수금 얼마야?”
					</h3>
				</div>
				<div class="imgcont">
					<div class="b043_3"><span class="blind"></span></div>
				</div>
				<div class="dsc_wrap mgt32">
					<p>
						경리나라에 수집된<br>
						거래처별 미수금, 미지급금 정보를 받을 수 있습니다.
					</p>
				</div>
			</div>
			<div class="grp_cont type1">
				<div class="tit_wrap round">
					<h3>
						“국민상사 거래처 보여줘”
					</h3>
				</div>
				<div class="imgcont">
					<div class="b043_4"><span class="blind"></span></div>
				</div>
				<div class="dsc_wrap mgt32">
					<p>
						거래처의 대표자, 사업자번호, 회사주소, 전화번호 등의<br>
						회사 정보를 받을 수 있습니다.
					</p>
				</div>
			</div>
			<div class="grp_cont type1">
				<div class="tit_wrap round">
					<h3>
						“일일시재 보여줘”
					</h3>
				</div>
				<div class="imgcont">
					<div class="b043_5"><span class="blind"></span></div>
				</div>
				<div class="dsc_wrap mgt32">
					<p>
						경리나라에서 자동 작성된 시재 보고서에 관한<br>
						정보를 받을 수 있습니다.
					</p>
				</div>
			</div>
			<div class="grp_cont type1 last">
				<div class="tit_wrap type2">
					<h3>
						[슬기로운 아바타 사용법]
					</h3>
					<h4 class="mgt10">
						아바타를 사용하면<br>
						귀하의 업무스타일이 바뀝니다.
					</h4>
				</div>
				<div class="imgcont">
					<div class="b043_6"><span class="blind"></span></div>
				</div>
				<% if(APP_ID.indexOf("SERP") == -1) {%>
				<div class="b43_bg">
					<dl>
						<dt>경리나라를 사용해 본 적이 없으신가요?</dt>
						<dd>
							경리업무를 확~ 줄여주는<br>
							국내 최초 경리 전문 소프트웨어<br>
							<strong>경리나라</strong>를 지금 바로 체험해보세요.
						</dd>
					</dl>
					<div class="btn_wrap">
						<div class="inner">
							<a href="#none" class="on">경리나라 신청하기</a>
						</div>
					</div>
				</div>
				<% } %>
			</div>
		</div>
	</div>
	<% if(APP_ID.indexOf("SERP") == -1) {%>
	<!-- 연결하기 버튼 fixed -->
	<div class="btn_fix_botm type3">
		<div class="inner">
			<a class="on"><span class="kym"></span>설치하기</a>
		</div>
	</div>
	<!--// 연결하기 버튼 fixed -->
	<% } %>

</div>
<!-- //content -->

</body>
</html>