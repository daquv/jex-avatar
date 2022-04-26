<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
	String BANK_CD = StringUtil.null2void(request.getParameter("BANK_CD"));
	String BANK_NM = StringUtil.null2void(request.getParameter("BANK_NM"));
	String FNNC_UNQ_NO = StringUtil.null2void(request.getParameter("FNNC_UNQ_NO"));
	String FNNC_INFM_NO = StringUtil.null2void(request.getParameter("FNNC_INFM_NO"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : acct_0002_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/acct
 * @author           : 김별 (  )
 * @Description      : 데이터_계좌거래내역화면
 * @History          : 20200116174911, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/acct/acct_0002_01.js
 * @JavaScript Url   : /js/jex/avatar/acct/acct_0002_01.js
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
    <script type="text/javascript" src="/js/jex/avatar/acct/acct_0002_01.js?<%=_CURR_DATETIME%>" charset="utf-8"></script>
</head>
<body>
<input type="hidden" id="BANK_CD" value="<%=BANK_CD%>" />
<input type="hidden" id="BANK_NM" value="<%=BANK_NM%>" />
<input type="hidden" id="FNNC_UNQ_NO" value="<%=FNNC_UNQ_NO%>" />
<input type="hidden" id="FNNC_INFM_NO" value="<%=FNNC_INFM_NO%>" />
	<!-- content -->
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			<!-- 거래내역조회 -->
			<div class="pr_acc_cbx data_y">

				<!-- 거래내역조회 내역 -->
				<div class="pr_cbx_cn">
					<ul class="row2">
						<!-- <li>
							<div class="left">
								<span class="acc_tit">㈜하하회사</span>
								<span class="acc_date">2018.12.12 13:00</span>
							</div>
							<div class="right">
								<span class="acc_won"><em class="won c_red">40,000</em>원</span>
								<span class="acc_won type2"><span class="acc_tp">잔액</span><em class="won">340,000</em>원</span>
							</div>
						</li> -->
					</ul>
				</div>
				<!--// 거래내역조회 내역 -->
			</div>
			<!-- //거래내역조회 -->
			<!-- 컨텐츠 영역 -->
			<div class="notibx_wrap type2 data_n" style="display:none;">
				<div class="inner">
					<div class="ico ico4"></div>
					<div class="noti_tit">계좌 입출금 데이터가 없습니다.</div>
				</div>
			</div>
		<!-- //컨텐츠 영역 -->
			
			
		</div>
		
		
		
		

	</div>
	<!-- //content -->
</body>
</html>