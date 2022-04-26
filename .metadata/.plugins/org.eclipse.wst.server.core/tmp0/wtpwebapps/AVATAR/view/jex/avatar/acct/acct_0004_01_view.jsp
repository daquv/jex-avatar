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
 * @File Name        : acct_0004_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/acct
 * @author           : 박지은 (  )
 * @Description      : 계좌등록완료 화면
 * @History          : 20210121093849, 박지은
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/acct/acct_0004_01.js
 * @JavaScript Url   : /js/jex/avatar/acct/acct_0004_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/acct/acct_0004_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5">

	<!-- content -->
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			 
			<div class="impBankDataMsg_wrap" id="fail_dv" style="display:none;">
				<div class="impBankDataMsg_inn">
					<dl>
						<dt><img src="../img/ico_point01.png" alt=""></dt>
						<dd id="rslt_msg">
							
						</dd>
					</dl>
				</div>
			</div>
			
			<!-- 컨텐츠 영역 -->
			<!-- (modify)20210729 -->
			<div class="notibx_wrap type2" id="succ_dv" style="display:none;">
				<div class="inner fixH2">
					<div class="noti_tit">
						계좌 등록<span class="c_blue">완료</span>
					</div>
					<div class="ico ico_ipr03"></div>
					<div class="noti_tit">
						은행에서<br>
						<span class="c_blue">최근 일주일 거래내역</span><br>
						데이터를 가져옵니다.
					</div>
					<div class="noti_txt">
						*데이터 양에 따라 시간이 소요될 수 있으며<br>
						익일 데이터 수집 후 최대 3개월치 데이터 조회가<br>
						가능합니다.
					</div>
					<!--<div class="noti_txt"></div>-->
				</div>
			</div>
			<!-- //(modify)20210729 -->
			<!-- //컨텐츠 영역 -->
		</div>

		<!-- 하단 fix버튼 -->
		<div class="btn_fix_botm type3">
			<div class="inner">
				<a style="display:none;" class="on" id="a_enter">확인</a>
				<a style="display:none;" class="on" id="c_enter">확인</a>
			</div>
		</div>
		<!-- //하단 fix버튼 -->

	</div>
	<!-- //content -->

</body>
</html>