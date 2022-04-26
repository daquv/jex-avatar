<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String NE_DAY = StringUtil.null2void(request.getParameter("NE_DAY"));
    String NE_B_YEAR = StringUtil.null2void(request.getParameter("NE_B_YEAR"));
    String NE_B_MONTH = StringUtil.null2void(request.getParameter("NE_B_MONTH"));
    String NE_B_DATE = StringUtil.null2void(request.getParameter("NE_B_DATE"));
    String NE_DATEFROM = StringUtil.null2void(request.getParameter("NE_DATEFROM"));
    String NE_DATETO = StringUtil.null2void(request.getParameter("NE_DATETO"));
    
    String inteInfo = StringUtil.null2void(request.getParameter("INTE_INFO"),"{}");
    
    //GET SESSION
    JexDataCMO UserSession = SessionManager.getSession(request, response);
    String _APP_ID = StringUtil.null2void((String)UserSession.get("APP_ID"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_0014_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 박지은 (  )
 * @Description      : 
 * @History          : 20210928135525, 박지은
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0014_01.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0014_01.js
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
<%-- <script>
var NE_DAY = decodeURIComponent('<%=NE_DAY%>');
var NE_B_YEAR = decodeURIComponent('<%=NE_B_YEAR%>');
var NE_B_MONTH = decodeURIComponent('<%=NE_B_MONTH%>');
var NE_B_DATE = decodeURIComponent('<%=NE_B_DATE%>');
var NE_DATEFROM = decodeURIComponent('<%=NE_DATEFROM%>');
var NE_DATETO = decodeURIComponent('<%=NE_DATETO%>');
</script> --%>
<script>
	var inteInfo = <%=inteInfo%>;
	var _APP_ID = '<%=_APP_ID%>';
</script>
<script type="text/javascript" src="/js/jex/avatar/ques/ques_0014_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5"><!-- (modify)20210729 -->

<!-- content -->
<div class="content">
	<span data-type="" id="RESULT_TTS" style="display:none;">등록된 메모는 총 <span id="MEMO_CNT"></span>개 입니다.</span>
	<div class="m_cont pdt12">
		<!-- 메모 - 목록 -->
		<div class="ques_Bx type2">
			<div class="ques_Bx_in">
				<!-- <dl>
					<dt>
						<div class="tit"></div>
					</dt>
					<dd>
						<div class="ques_Bx_cn">
							<ul>
								<li>
									<div class="left">
										<p></p>
									</div>
								</li>
							</ul>
						</div>
					</dd>
				</dl> -->
			</div>
		</div>
		
		<!-- 메모 -->
		<div class="memoSaveBx" style="display:none;">
			<div class="memoSaveBx_inn">
				<dl>
					<dt class="h29"><img src="../img/ico_memo3.png" alt="메모"></dt>
					<dd>
						<p>
							<span class="c_793FFB">“오후 1시 미팅 메모해줘”</span> 라고 말해보세요.<br>
							음성으로 메모를 저장하고 검색할 수 있어요!
						</p>
					</dd>
				</dl>
			</div>
		</div>
		<!-- //메모 -->
	</div>
	<!-- //메모 - 목록 -->


</div>
<!-- //content -->

</body>
</html>