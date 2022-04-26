<%@page import="jex.json.JSONObject"%>
<%@page import="jex.json.parser.JSONParser"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
	//Action 결과 추출
	String inteInfo = StringUtil.null2void(request.getParameter("INTE_INFO"),"{}");
	String userCi = StringUtil.null2void(request.getParameter("USER_CI"),"");
	
	//JSONObject inteInfoJson = (JSONObject)JSONParser.parser(inteInfo);
	//JSONObject recog_data = (JSONObject) inteInfoJson.get("recog_data");
	//String inteCd = (String) recog_data.get("Intent");
	
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_comm_99_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김예지 (  )
 * @Description      : 질의 
 * @History          : 20211202204757, 김예지
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_comm_99.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_comm_99.js
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
    <script>
    var inteInfo = <%=inteInfo%>;
	var _thisCont = {
		PAGE_NO : 1,
		PAGE_CNT : 25,
		INTE_INFO : <%=inteInfo%>
	}
	 
	</script>
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_comm_99.js?<%=_CURR_DATETIME%>"></script>
    <%-- <% if(!"".equals(StringUtil.null2void(inteCd))) { %>
    	<script type="text/javascript" src="/js/jex/avatar/ques/ques_0199_<%=inteCd%>.js?<%=_CURR_DATETIME%>"></script>
    <% } %> --%>
</head>
<body>
<!-- content -->
<input type="hidden" class="CNT" id="ACCT_CNT" value="">
<input type="hidden" class="CNT" id="TAX_CNT" value="">
<input type="hidden" class="CNT" id="TAX2_CNT" value=""> <!-- 세액내역 -->
<input type="hidden" class="CNT" id="CASH_CNT" value="">
<input type="hidden" class="CNT" id="SALE_CNT" value="">
<input type="hidden" class="CNT" id="CARD_CNT" value="">
<input type="hidden" class="CNT" id="SNSS_CNT" value="">
<input type="hidden" class="CNT" id="_BZAQ_CNT" value="">
<input type="hidden" class="CNT" id="_MEST_CNT" value="">
<input type="hidden" id="BZAQ_REC">
	<div class="content" style="display:none;" >
		<!-- (modify)20210517 -->
		<div class="m_cont loading_bx" id="REALTIME" style="display:none;"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			<dl>
				<dt>
					<div class="lds-spinner"><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div></div>
				</dt>
				<dd>
					<span>데이터 처리중 입니다.</span>
					<span>잠시만 기다려주세요.</span>
				</dd>
			</dl>
		</div>
		<div class="m_cont pdt12" id="MAIN" style="display:none;"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			<%//Admin에서 등록한 html 내용을 표시 할 영역 %>
			

		</div>
	</div>
	<!-- //content -->

</body>
</html>