<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String ctgrCd = StringUtil.null2void(request.getParameter("CTGR_CD"));
    String menuDv = StringUtil.null2void(request.getParameter("MENU_DV"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_0001_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20201111111356, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0001_02.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0001_02.js
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
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_0001_02.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
<input type="hidden" name="CTGR_CD" value="<%=ctgrCd.trim() %>">
<input type="hidden" name="MENU_DV" value="<%=menuDv.trim() %>">
<!-- content -->
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 --> 

			<!-- 전체 질의 탭 영역 -->
			<div class="bntap_area mgt0">
				<div class="bntap">
					<ul>
						<li class="icon bnco01 on" id="1000" data-menu=""><a href="#none">금융</a></li>
						<li class="icon bnco02" id="2000" data-menu=""><a href="#none">매출</a></li>
						<li class="icon bnco03" id="3000" data-menu=""><a href="#none">매입</a></li>
						<li class="icon bnco04" id="4000" data-menu=""><a href="#none">거래처</a></li>
						<li class="icon bnco05" id="" data-menu="serp"><a href="#none">경리나라</a></li>
					</ul>
				</div>
			</div>
			<!-- //전체 질의 탭 영역 -->

			<div class="cont_pd20">

				<!-- 질의 리스트영역 -->
				<div class="ai_list_v type2 inner">
					<dl>
						<dd>
							<ul>
								<!-- <li><a>"회사 통장 잔고는?" <span class="icon_new"><img src="../img/ico_new.png" alt=""></span></a></li>
								<li><a>"입금 내역은?"</a></li>
								<li><a>"매출액은"</a></li>
								<li><a>"카드 사용 금액은?"</a></li>
								<li><a>"세금계산서 매출은?"</a></li>
								<li><a>"자금 현황은?"</a></li>
								<li><a>"출금 내역은?"</a></li>
								<li><a>"카드 매출 입금 예정액은?"</a></li>
								<li><a>"카드 결제 금액은?"</a></li>
								<li><a>"세금계산서 매출은?"</a></li> -->
							</ul>
						</dd>
					</dl> 
				</div>
				<!-- //질의 리스트영역 -->

			</div>

		</div>

	</div>
	<!-- //content -->

</body>
</html>