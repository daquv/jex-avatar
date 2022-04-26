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
    String LGIN_APP = StringUtil.null2void((String)UserSession.get("LGIN_APP"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_0001_08_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20210929160410, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0001_08.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0001_08.js
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
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_0001_08.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>

<!-- content -->
<div class="content pdb0">

	<div class="m_cont">
		<div class="zero_Avatar">
			<div class="sect_zero_Avatar bg_F9FEFD">
				<div class="sect_inn pd_T50_B40">
					<div class="zero_avatar_im">
						<img src="../img/im_zero_avatar_01.png" alt="">
					</div>
					<div class="tit_zero_Avatar mgt35">
						<div class="tit">
							<div class="tit_wrap">
								<h2>
									바쁜 점심시간,<br>
									<strong class="type1">음성으로 실시간</strong><br>
									제로페이 결제 내역을 알려줘요!
								</h2>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="sect_zero_Avatar bg_ECF4FF">
				<div class="sect_inn pd_T50_B40">
					<div class="zero_avatar_im">
						<img src="../img/im_zero_avatar_02.png" alt="">
					</div>
					<div class="tit_zero_Avatar mgt15">
						<div class="tit">
							<div class="tit_wrap">
								<h2>
									영업 종료 후<br>
									오늘 제로페이 매출액을<br>
									<strong class="type2">음성으로 알려드릴게요!</strong>
								</h2>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="sect_zero_Avatar bg_F8F6FE">
				<div class="sect_inn pd_T25_B85">
					<div class="zero_avatar_im">
						<img src="../img/im_zero_avatar_03.png" alt="">
					</div>
					<div class="tit_zero_Avatar">
						<div class="tit">
							<div class="tit_wrap type1">
								<h2>
									<strong class="type3">음성 매출 브리핑으로</strong><br>
									어제 매출액과<br>
									오늘 입금 예정액을 받아보세요!
								</h2>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<% if("AVATAR".equals(LGIN_APP)) {%>
	<!-- 연결하기 버튼 fixed -->
	<div class="btn_fix_botm type3" style="z-index:30;">
		<div class="inner">
			<a href="#none" class="on"><span class="zero_pay"></span>설치하기</a>
		</div>
	</div>
	<%}%><!--// 연결하기 버튼 fixed -->

</div>
<!-- //content -->

</body>
</html>