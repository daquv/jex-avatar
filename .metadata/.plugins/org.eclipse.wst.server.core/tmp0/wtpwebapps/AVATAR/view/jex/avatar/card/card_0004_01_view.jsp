<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String RSLT_CD = StringUtil.null2void(request.getParameter("RSLT_CD"));
    String RSLT_MSG = StringUtil.null2void(request.getParameter("RSLT_MSG"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : card_0004_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/card
 * @author           : 김태훈 (  )
 * @Description      : 카드매출가져오기 완료화면
 * @History          : 20200121163430, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/card/card_0004_01.js
 * @JavaScript Url   : /js/jex/avatar/card/card_0004_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/card/card_0004_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5">
<input type="hidden" id="RSLT_CD" name="RSLT_CD" value="<%=RSLT_CD %>">

	<!-- content -->
	<div class="content">

	<%if(RSLT_CD.equals("00000000")){ %>
		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<!-- 컨텐츠 영역 -->
			<div class="notibx_wrap type2">
				<div class="inner fixH2">
					
					<div class="noti_tit">
						여신금융협회 인증<span class="c_blue">완료</span>
					</div>
					<div class="ico ico_ipr02"></div>
					<div class="noti_tit">
						여신금융협회에서<br>
						<span class="c_blue">최근 일주일 카드승인내역, 카드사입금내역</span><br>
						데이터를 가져옵니다.
					</div>
					<div class="noti_txt">
						*데이터 양에 따라 시간이 소요될 수 있으며<br>
						익일 데이터 수집 후 최대 3개월치 데이터 조회가<br>
						가능합니다.
					</div>
				</div>
			</div>
			<!-- //컨텐츠 영역 -->
		</div>
	<%}else{%>
		<div class="m_cont pdt12"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			<!-- 질의 답변 탑영역 -->
			<div class="impBankDataMsg_wrap">
				<div class="impBankDataMsg_inn">
					<dl>
						<dt><img src="../img/ico_point01.png" alt=""></dt>
						<dd>
							<p>
								카드매출 데이터 가져오기가<br>
								<span class="c_793FFB">실패</span>하였습니다.
							</p>
						</dd>
					</dl>
				</div>
			</div>
			<!-- //질의 답변 탑영역 -->
	
			<!-- 컨텐츠 영역 -->
			<div class="notibx2_wrap">
				<div class="inner">
					<div class="noti_tit">오류메시지를 확인해주세요.</div>
					<div class="noti_cnErr">
						[<%=RSLT_CD%>] <%=RSLT_MSG%><br>
						다시 확인해주세요.
					</div>
				</div>
			</div>
			<!-- //컨텐츠 영역 -->
		</div>
	<%}%>
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