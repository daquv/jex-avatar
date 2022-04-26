<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    //GET SESSION
	JexDataCMO UserSession = SessionManager.getSession(request, response);
//     String BSNN_NM = StringUtil.null2void((String)UserSession.get("BSNN_NM"));
     String MENU_DV = StringUtil.null2void(request.getParameter("MENU_DV"));
    
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : basic_0006_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 김별 (  )
 * @Description      : 개선요청메인화면
 * @History          : 20200819140228, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0006_01.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0006_01.js
 * </pre>
 **/
%>
<!doctype html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title></title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="user-scalable=yes, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width">
	<%@include file="/view/jex/avatar/include/page_import_head.jsp"%>
	<script type="text/javascript" src="/js/jex/avatar/basic/basic_0006_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<script type="text/javascript">
	var MENU_DV = '<%=MENU_DV%>';
</script>
<body class="bg_F5F5F5">
<input type="hidden" name="MENU_DV" value="<%=MENU_DV%>">
	<!-- content -->
	<div class="content">

		<div class="m_cont pdt12">
			
			<!-- 컨텐츠 영역 -->
			<div class="inquiry_warp type1"  id="cont_inq" style="">
				<dl>
					<dt>문의 내역</dt>
					<dd>
						<!-- <div class="qdetail">
							<div class="left">
								<div class="qtit"><a href="#none">계좌 등록이 안돼요. 어떻게 해야하나요?</a></div>
								<div class="date">2017.06.27 12:16:24</div>
							</div>
							<div class="right">
								<span class="answer">처리중</span>
							</div>
						</div>-->
					</dd>
				</dl>
			</div>
			<!-- //컨텐츠 영역 -->
			
			<!-- 컨텐츠 영역 -->
			<div class="noti_area type1" >
					<ul>
						<!-- <li>
							<div class="tit">
								<p class="maxellips">[공지] 서비스 오픈서비스 오픈서비스 오픈서비스 오픈서비스 오픈서비스 오픈서비스 오픈서비스 오픈서비스 오픈서비스 오픈서비스 오픈서비스 오픈서비스 오픈서비스 오픈서비스 오픈서비스 오픈서비스 오픈서비스 오픈서비스 오픈서비스 오픈서비스 오픈 ???????</p>
								<p class="date">2020.07.27 12:16</p>
							</div>
							<div class="btn"><a class="btn_arr"></a></div>
						</li> -->
					</ul>
			</div>
			<!-- //컨텐츠 영역 -->
			
			
			<!-- 컨텐츠 영역 -->
			<div class="notibx_wrap type5" style="display:none;">
				<div class="inner">
					<div class="ico ico8"></div>
					<div class="noti_tit">
						<% if("01".equals(MENU_DV)) {%>
				    		등록한 고객문의사항이 없습니다.
		    			<% } else if("02".equals(MENU_DV)) {%>
		    				등록된 공지 사항이 없습니다.
		    			<% } else {}%>
						</td>
					</div>
				</div>
			</div>
			<!-- //컨텐츠 영역 -->
		
		</div>
		<!-- 하단 fix버튼 -->
		<% if("01".equals(MENU_DV)) {%>
			<div class="btn_fix_botm">
				<div class="inner">
					<a>1:1 문의하기</a>
				</div>
			</div>
		<% }%>
		<!-- //하단 fix버튼 -->
	</div>
	<!-- //content -->

</body>
</html>