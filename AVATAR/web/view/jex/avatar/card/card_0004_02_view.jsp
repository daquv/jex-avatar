<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : card_0004_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/card
 * @author           : 박지은 (  )
 * @Description      : 카드매출실시간조회 화면
 * @History          : 20210121081915, 박지은
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/card/card_0004_02.js
 * @JavaScript Url   : /js/jex/avatar/card/card_0004_02.js
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
	<script type="text/javascript" src="/js/jex/avatar/card/card_0004_02.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
	<!-- content -->
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<!-- 컨텐츠 영역 -->
			<div class="notibx_wrap type2">
				<div class="inner fixH2">
					<div class="ico ico_ipr02"></div>
					<div class="noti_tit">
						여신금융협회에서<br />
						<span class="c_blue">최근 일주일 카드승인내역, 카드사입금내역</span><br />
						데이터를 가져옵니다
					</div>
					<div class="noti_txt">
						* 데이터 양에 따라 수분에서 수십 분까지 걸릴 수 있으며<br />
						약 10분 뒤부터 서비스 이용이 가능합니다.
					</div>
					<div class="noti_txt">
						초기 연결 후 다음날 부터는<br />
						<span class="c_blue">자동으로 새벽</span>에 데이터를 <span class="c_blue">업데이트</span>합니다.
					</div>
				</div>
			</div>
			<!-- //컨텐츠 영역 -->

		</div>

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