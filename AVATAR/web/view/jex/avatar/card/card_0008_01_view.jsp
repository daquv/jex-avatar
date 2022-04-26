<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String BANK_NM			=StringUtil.null2void(request.getParameter("BANK_NM"));
	String BANK_CD			=StringUtil.null2void(request.getParameter("BANK_CD"));
	String BANK_GB			=StringUtil.null2void(request.getParameter("BANK_GB"));
	String CARD_NICK_NM		=StringUtil.null2void(request.getParameter("CARD_NICK_NM"));
	String CARD_RPSN_INFM	=StringUtil.null2void(request.getParameter("CARD_RPSN_INFM"));
	String CARD_NO			=StringUtil.null2void(request.getParameter("CARD_NO"));
	String WEB_ID			=StringUtil.null2void(request.getParameter("WEB_ID"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : card_0008_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/card
 * @author           : 김태훈 (  )
 * @Description      : 카드매입관리-수정정보확인
 * @History          : 20200128162759, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/card/card_0008_01.js
 * @JavaScript Url   : /js/jex/avatar/card/card_0008_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/card/card_0008_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
<input type="hidden" id="BANK_NM" 			value="<%=BANK_NM %>" />
<input type="hidden" id="BANK_CD" 			value="<%=BANK_CD %>" />
<input type="hidden" id="BANK_GB" 			value="<%=BANK_GB %>" />
<input type="hidden" id="CARD_NICK_NM" 		value="<%=CARD_NICK_NM %>" />
<input type="hidden" id="CARD_RPSN_INFM" 	value="<%=CARD_RPSN_INFM %>" />
<input type="hidden" id="CARD_NO" 			value="<%=CARD_NO %>" />
<input type="hidden" id="WEB_ID" 			value="<%=WEB_ID %>" />
	<!-- content -->
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			<!-- 계좌정보 -->
			<div class="set_bx_tbl">
				<table>
					<colgroup><col style="width:70px;"><col></colgroup>
					<tbody>
						<tr>
							<th>카드사</th>
							<td class="tit"><%=BANK_NM %>(기업)</td>
						</tr>
						<tr>
							<th>카드번호</th>
							<td><%=CARD_RPSN_INFM %></td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- //계좌정보 -->
			
			<div class="cont_pd">
				<!-- 입력영역 -->
				<div class="wrbx_w" style="margin-top:20px;">
					<dl>
						<dt>카드사 아이디/비밀번호</dt>
						<dd>
							<div class="user">
								<span class="id"><%=WEB_ID %></span>
								<div class="input_type">
									<input type="password" readonly value="12345678">
								</div>
								<div class="right">
									<a id="a_change">변경</a>
								</div>
							</div>
						</dd>
					</dl> 
				</div>
				<!-- //입력영역 -->
			</div>

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