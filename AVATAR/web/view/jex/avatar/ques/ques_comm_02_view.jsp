<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.JexData"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
//	JexData result = util.getResultData();
//	String html = StringUtil.null2void(result.getString("HTML")); 

	String inteCd = StringUtil.null2void(request.getParameter("INTE_CD"),"{}");
	String apiYn = StringUtil.null2void(request.getParameter("API_YN"),"{}");

	//test data
	 
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_comm_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 신승환 (  )
 * @Description      : 
 * @History          : 20200309143043, 신승환
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_comm_01.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_comm_01.js
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
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_comm_02.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
<!-- content -->
<input type="hidden" id="INTE_CD" value="<%=inteCd%>" />
<input type="hidden" id="API_YN" value="<%=apiYn%>" />

<input type="hidden" class="CNT" id="ACCT_CNT" ctgr="acct" value="">
<input type="hidden" class="CNT" id="CARD_CNT" ctgr="card" value="">
<input type="hidden" class="CNT" id="CASH_CNT" ctgr="tax" value="">
<input type="hidden" class="CNT" id="SALE_CNT" ctgr="sale" value="">
<input type="hidden" class="CNT" id="PRCH_CNT" ctgr="tax" value="">
<input type="hidden" class="CNT" id="BZAQ_CNT" ctgr="bzaq" value="">

<input type="hidden" class="CNT" id="API_CNT" value="" ctgr="api">
<input type="hidden" class="CNT" id="APP_CNT" value="">
<input type="hidden" id="API_STTS" value="">


<input type="hidden" class="CNT" id="BZAQ_CNT" value="">
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			
			<%//Admin에서 등록한 html 내용을 표시 할 영역 %>
			

		</div>

		<!-- 마이크 버튼영역 -->
		<!-- <div class="btn_fix_r">
			<a class="btn_mic"></a>
		</div> -->
		<!-- //마이크 버튼영역 -->
		
		
		<div class="notibx_wrap type2" style="display:none;">
			<div class="inner">
				<div class="ico ico4"></div>
				<div class="noti_tit">질의에 대한 데이터가 없습니다</div>
				<div class="noti_cn2">
					데이터 가져오기 버튼을 탭하여<br>
					데이터 가져오기를 진행하여 주십시요
				</div>
			</div>
		</div> 
		<!-- 토스트 팝업 -->
		<div class="toast_pop" style="display:none;">
			<div class="inner">
				<span id="toast_msg">이름을 입력해주세요.</span>
			</div>
		</div>
		<!-- //토스트 팝업 -->

	</div>
	<!-- //content -->
</body>
</html>