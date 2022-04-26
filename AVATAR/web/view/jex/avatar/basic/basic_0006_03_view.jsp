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
	String CLPH_NO = StringUtil.null2void((String)UserSession.get("CLPH_NO"));
	
	String BLBD_NO = StringUtil.null2void(request.getParameter("BLBD_NO"));
	String BLBD_DIV = StringUtil.null2void(request.getParameter("BLBD_DIV"));
//     String BSNN_NM = StringUtil.null2void((String)UserSession.get("BSNN_NM"));
    
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : basic_0006_03_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200820160911, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0006_03.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0006_03.js
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
	<script type="text/javascript" src="/js/jex/avatar/basic/basic_0006_03.js?<%=_CURR_DATETIME%>"></script>
	<style>
		img{
			max-width: 100%; height: auto;
		}
	</style>
</head>
<body>
<input type="hidden" id="BLBD_NO" value="<%=BLBD_NO%>" />
<input type="hidden" id="BLBD_DIV" value="<%=BLBD_DIV%>" />
	<!-- content -->
	<div class="content">

		<div class="m_cont"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<!-- 컨텐츠 영역 -->
			<div class="inquiry_warp" id="cont_inq">
				<!-- 고객질문 -->
				<div class="qw_cont">
					<div class="qdetail">
						<div class="left">
							<div class="qtit"></div>
							<div class="inner">
								<span class="name"><%=CUST_NM %></span>
								<span class="date" ></span>
							</div>
						</div>
						<div class="right">
							<span class="answer end"></span>
						</div>
					</div>
					<div class="qcont" style="/* width:100%; */white-space: pre-line;word-break: break-word;">
						
					</div>
					<div class="addfile" style="display:none;">
						<p>첨부 파일</p>
						<ul class="filelist">
							
						</ul>
					</div>
				</div>
				<!-- //고객질문 -->
				<!-- 고객지원팀 답변 -->
				<div class="aw_cont" style="display:none;">
					<div class="cs_team">
						<div class="csname">고객지원팀</div>
						<div class="asdate"></div>
					</div>
					<div class="cs_cont" style="/* width:100%; */white-space: pre-line;word-break: break-word;">
					</div>
					<div class="addfile" style="display:none;">
						<p>첨부 파일</p>
						<ul class="filelist">
							<!-- <li class="down"><a href="#none">Screenshot_20200729-1 175856.jpg</a></li> -->
						</ul>
					</div>
				</div>
				<!-- //고객지원팀 답변 -->
			</div>
			<!-- //컨텐츠 영역 -->
			
			<div class="cont_pd10" id="cont_noti">
				<div class="noti_area">
					<ul>
						<li>
							<div class="tit full">
								<p class="ntit"></p>
								<p class="date"></p>
							</div>
						</li>
						<div class="noti_cont" style="/* width:100%; */white-space: pre-line;word-break: break-word;"></div>
					</ul>
					<div class="addfile" style="display:none;">
						<p>첨부 파일</p>
						<ul class="filelist">
							<!-- <li class="down"><a href="#none">Screenshot_20200729-1 175856.jpg</a></li>
							<li class="down"><a href="#none">Screenshot_20200729-1 175856.jpg</a></li>		 -->
						</ul>
					</div>
				</div>
			</div>
			
			

		</div>

	</div>
	<!-- //content -->

</body>
</html>