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
    String CUST_NM = StringUtil.null2void((String)UserSession.get("CUST_NM"));
//     String BSNN_NM = StringUtil.null2void((String)UserSession.get("BSNN_NM"));
    
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : basic_0001_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 김태훈 (  )
 * @Description      : 더보기 메인화면
 * @History          : 20200129101703, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0001_01.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0001_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/basic/basic_0001_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>

	<!-- content -->
	<div class="content">

		<div class="m_cont">
			<div class="m_bx_wrap">
				<!-- 더보기 상단 -->
				<div class="m_topbx">
					<!-- <div class="thumb"><span class="bg"><img src="../img/thumb_test.png"></span></div> -->
					<div class="thumb"><span class="bg"><img src="../img/thumb_none.png"></span></div><!-- 썸네일이미지 없는 경우 -->
<%-- 					<h2><%=CUST_NM %></h2> --%>
					<h3>
						<span class="elipsis"><%=CUST_NM %></span>
						<a class="btn_set" id="a_btn"><span class="blind">프로필 변경</span></a>
					</h3>
<%-- 					<h3><%=BSNN_NM %></h3> --%>
<!-- 					<h3>음...사업장</h3> -->
					<div class="btn">
						<a id="btn_logOut">로그아웃</a>
					</div>
				</div>
				<!-- //더보기 상단 -->

				<!-- 이미지 탭 -->
				<div class="m_tab_tbl">
					<table>
						<colgroup><col><col><col></colgroup>
						<tbody>
							<tr>
								<td><a><span class="ico ico1"></span><span class="txt" style="margin-top:14px;">데이터</span></a></td>
								<td><a class="on"><span class="ico ico2"></span><span class="txt">데이터<br>연결하기</span></a></td>
								<td><a><span class="ico ico3"></span><span class="txt" style="margin-top:14px;">개선요청</span></a></td><!-- 2020-08-18 -->
							</tr>
						</tbody>
					</table>
				</div>
				<!-- //이미지 탭 -->

			</div>
		</div>

	</div>
	<!-- //content -->

</body>
</html>