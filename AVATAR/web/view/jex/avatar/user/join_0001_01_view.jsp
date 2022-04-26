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
	/* JexDataCMO UserSession = SessionManager.getSession(request, response); */
    /* String USE_INTT_ID = StringUtil.null2void((String)UserSession.get("USE_INTT_ID")); */
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : join_0001_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/user
 * @author           : 김별 (  )
 * @Description      : 회원가입_약관동의화면
 * @History          : 20200129100522, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/user/join_0001_01.js
 * @JavaScript Url   : /js/jex/avatar/user/join_0001_01.js
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
    <script type="text/javascript" src="/js/jex/avatar/user/join_0001_01.js?<%=_CURR_DATETIME%>"></script>
    <style>
    .cont_pd.on{
    	display : block !important;
    }
    </style>
</head>
<body>
<%-- <input type="hidden" id="USE_INTT_ID" value="<%=USE_INTT_ID %>"> --%>
<!-- content -->
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			
			<div class="cont_pd on" style="display: none;">

				<!-- 이용약관 -->
				<div class="clause_wrap" style="padding-top:35px;">
					<dl>
						<dt><input name="checkAll" type="checkbox"> 전체 동의하기</dt>
						<dd>
							<ul>
								<!-- 선택시 on 클래스 추가 -->
								<li><input type="checkbox"  name="check"> AVATAR for CEO 이용약관(필수) <a class="btn"></a></li>
								<li><input type="checkbox" name="check"> 개인정보 수집 및 이용동의 (필수) <a class="btn"></a></li>
								<li><input type="checkbox" name="check"> 개인정보 제3자 제공 동의 (필수)<a class="btn"></a></li>
								<!-- <li><input type="checkbox" name="check"> 본인확인 서비스 이용 동의 (필수)<a class="btn"></a></li>
								<li><input type="checkbox" name="check"> 통신사 이용 약관 동의 (필수)<a class="btn"></a></li> -->
							</ul>
						</dd>
					</dl>
				</div>
				<!-- //이용약관 -->
			</div>
		</div>
		
		
			

		<!-- 하단 fix버튼 -->
		<div class="btn_fix_botm">
			<div class="inner">
				<a class="off" id="nextBtn">다음</a>
			</div>
		</div>
		<!-- //하단 fix버튼 -->

	</div>
	<!-- //content -->
</body>
</html>