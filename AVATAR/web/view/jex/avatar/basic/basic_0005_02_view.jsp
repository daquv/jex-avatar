<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String RSLT_CD = StringUtil.null2void(request.getParameter("RSLT_CD"));
    String RSLT_MSG = StringUtil.null2void(request.getParameter("RSLT_MSG"));
    
    if("E_1002".equals(RSLT_CD)){
    	RSLT_MSG = "경리나라 연결이 되어있지 않습니다. 경리나라 연결하기를 진행해주세요.";
    }
    
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : basic_0005_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 김태훈 (  )
 * @Description      : 경리나라 연결하기 완료 화면
 * @History          : 20200603150653, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0005_02.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0005_02.js
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
	<script type="text/javascript" src="/js/jex/avatar/basic/basic_0005_02.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
<input type="hidden" id="RSLT_CD" name="RSLT_CD" value="<%=RSLT_CD %>">

	<!-- content -->
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<!-- 컨텐츠 영역 -->
			<div class="notibx_wrap type2">
				<div class="inner">
					<%if(RSLT_CD.equals("0000")){ %>
					<div class="ico ico2"></div>
					<div class="noti_tit">경리나라 데이터 연결을<br>
					완료 하였습니다
					</div>
					<%}else{%>
					<div class="ico ico3"></div>
					<div class="noti_tit">경리나라 데이터 연결을<br> <span class="c_red">실패</span>하였습니다.</div>
					<div class="noti_cn c_bl" style="margin-top:22px;">오류메시지를 확인해주세요.</div>
					<div class="noti_cn2 c_red" style="margin-top:5px;">
						[<%=RSLT_CD%>] <%=RSLT_MSG%><br>
					</div>
					<%}%>
				</div>
			</div>
			<!-- //컨텐츠 영역 -->

		</div>

<!-- 토스트 팝업 -->
		<div class="toast_pop" style="display:none;">
			<div class="inner">
				<span id="toast_msg">이름을 입력해주세요.</span>
			</div>
		</div>
		<!-- //토스트 팝업 -->
		<!-- 하단 fix버튼 -->
		<div class="btn_fix_botm">
			<div class="inner">
				<a id="a_enter">확인</a>
			</div>
		</div>
		<!-- //하단 fix버튼 -->

	</div>
	<!-- //content -->

</body>
</html>