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
 * @File Name        : join_0004_10_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/user
 * @author           : 김별 (  )
 * @Description      : 회원가입_약관동의(6.경리나라-개인(신용)정보조회에관한사항)
 * @History          : 20210414153201, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/user/join_0004_10.js
 * @JavaScript Url   : /js/jex/avatar/user/join_0004_10.js
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
    <script type="text/javascript" src="/js/jex/avatar/user/join_0004_10.js?<%=_CURR_DATETIME%>"></script>
</head>
<body><!-- (modify)20210416 -->

<!-- content -->
<div class="content termFixed"><!-- (modify)20210416 -->

	<!-- (add)20210414 -->
	<div class="popLayer_wrap" style="display:block;">
		<div class="popLayer_inn">
			<div class="tit_wrap">
				<h3 class="pop_tit">개인(신용)정보 조회에 관한 사항</h3>
				<a href="#none" class="btn_close"><img src="../img/btn_popLayer_close.png" alt="Close"></a>
			</div>
			<!-- -->
			<div class="pop_cnt mCustomScrollbar" style="max-height:100%;">
				<div class="pop_cnt_inn">
					<div>
						<h3 class="popTitle_first">개인(신용)정보 조회에 관한 사항</h3><!-- (add)20210414(r4) -->
						<div class="servTerm">
							<ul>
								<li>■ 조회할 개인(신용) 정보 : 거래처 정보, 거래처 미수/미지급내역, 매출/매입 증빙자료, 급여자료, 계좌 입/출내역, 수납/지급내역, 이체내역, 어음</li>
								<li>■ 조회 목적 : 서비스 가입ㆍ유지ㆍ이행ㆍ관리ㆍ개선</li>
								<li>■ 조회 동의 효력기간 : 귀하기 상기 동의서를 제출한 시점부터 당해 거래 종료일까지 상기 동의의 효력이 유지됩니다. 다만, 서비스 종료가 완료된 시점부터는 동의의 효력은 소멸합니다.</li>
							</ul>
						</div>
					</div>
				</div>
			</div>
			<!--// -->
			<!-- -->
			<div class="footer">
				<div class="btn_fix_botm">
					<div class="inner">
						<a href="#none" class="btn_w3">확인</a>
					</div>
				</div>
			</div>
			<!--// -->
		</div>
	</div>
	<!-- //(add)20210414 -->

</div>
<!-- //content -->

</body>
</html>