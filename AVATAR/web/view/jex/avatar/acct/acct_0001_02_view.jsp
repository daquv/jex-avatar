<%@page import="java.net.URLDecoder"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String BANK_NM 			= StringUtil.null2void(request.getParameter("BANK_NM"));
    String BANK_CD 			= StringUtil.null2void(request.getParameter("BANK_CD"));
    String BANK_GB 			= StringUtil.null2void(request.getParameter("BANK_GB"));
    String ACCT_NICK_NM 	= StringUtil.null2void(request.getParameter("ACCT_NICK_NM"));
    String FNNC_RPSN_INFM 	= StringUtil.null2void(request.getParameter("FNNC_RPSN_INFM"));
    String ACCT_DV 			= StringUtil.null2void(request.getParameter("ACCT_DV"));
    String FNNC_UNQ_NO 		= StringUtil.null2void(request.getParameter("FNNC_UNQ_NO"));
    String FNNC_INFM_NO 	= StringUtil.null2void(request.getParameter("FNNC_INFM_NO"));
    String CERT_NM 			= URLDecoder.decode(StringUtil.null2void(request.getParameter("CERT_NM")));
    
    String ACCT_DV_STR = "";
    if(ACCT_DV.equals("01")){
    	ACCT_DV_STR = "입출금";
	}else if(ACCT_DV.equals("02")){
		ACCT_DV_STR = "예적금";
	}else if(ACCT_DV.equals("03")){
		ACCT_DV_STR = "예적금";
	}
    
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : acct_0001_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/acct
 * @author           : 김태훈 (  )
 * @Description      : 계좌 인증서 화면
 * @History          : 20200116151746, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/acct/acct_0001_02.js
 * @JavaScript Url   : /js/jex/avatar/acct/acct_0001_02.js
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
	<script type="text/javascript" src="/js/jex/avatar/acct/acct_0001_02.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
<input type="hidden" id="FNNC_UNQ_NO" 		value="<%=FNNC_UNQ_NO %>"/>
<input type="hidden" id="FNNC_INFM_NO" 		value="<%=FNNC_INFM_NO %>"/>
<input type="hidden" id="FNNC_RPSN_INFM" 	value="<%=FNNC_RPSN_INFM %>"/>
<input type="hidden" id="CERT_NM" 			value="<%=CERT_NM %>"/>
<input type="hidden" id="BANK_CD" 			value="<%=BANK_CD %>"/>
<input type="hidden" id="BANK_GB" 			value="<%=BANK_GB %>"/>
<input type="hidden" id="BANK_NM" 			value="<%=BANK_NM %>"/>
<input type="hidden" id="ACCT_DV" 			value="<%=ACCT_DV %>"/>
	<!-- content -->
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			<!-- 계좌정보 -->
			<div class="set_bx_tbl type2">
				<table>
					<colgroup><col style="width:86px;"><col></colgroup>
					<tbody>
						<tr>
							<th>은행</th>
							<td class="tit"><%=BANK_NM %></td>
						</tr>
						<tr>
							<th>예금유형</th>
							<td><%=ACCT_NICK_NM %></td>
						</tr>
						<tr>
							<th>계좌번호</th>
							<td><%=FNNC_RPSN_INFM %></td>
						</tr>
						<tr>
							<th>계좌종류</th>
							<td><%=ACCT_DV_STR %></td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- //계좌정보 -->

			<!-- 설정영역 -->
			<div class="set_bx_wrap type2">
				<dl><!-- <dl style="margin-top:13px;"> -->
					<dt class="btmLine"><div class="tit">등록된 공동인증서</div></dt>
					<dd>
						<div class="certi01">
							<span class="ico on"></span>
							<div class="left" id="div_cert">
								<%--
								<div class="tit">
									<em>가나상사</em>
									<span class="no">112233445566778899112233</span>
								</div>
								<div class="txt">
									<p>은행법인 / 금융결제원</p>
									<p><span class="date">만료일</span><span class="c_red">2019.10.31 (잔여3일)</span></p>
								</div>
								 --%>
							</div>
							<!-- (modify)20210517 -->
							<div class="cerStatus">
								<span class="cerEnd" id="cerEnd" style="display:none;">인증서만료</span>
								<span class="cerEnd" id="cerEnd_exp" style="display:none;">만료예정</span>
								<span class="cerChange">교체</span>
							</div>
							<!-- //(modify)20210517 -->
						</div>
					</dd>
				</dl>
			</div>
			<!-- //설정영역 -->

		</div>

		<!-- 토스트 팝업 -->
		<div class="toast_pop" style="display: none;">
			<div class="inner">
				<span>삭제되었습니다.</span>
			</div>
		</div>
		<!-- //토스트 팝업 -->

		<!-- 하단 fix버튼 -->
		<div class="btn_fix_botm btn_both"><!-- 버튼 2개인 경우 btn_both 클래스 추가 -->
			<div class="inner">
				<a class="off" id="a_del">삭제</a>
				<a id="a_enter">확인</a>
			</div>
		</div>
		<!-- //하단 fix버튼 -->

	</div>
	<!-- //content -->

</body>
</html>