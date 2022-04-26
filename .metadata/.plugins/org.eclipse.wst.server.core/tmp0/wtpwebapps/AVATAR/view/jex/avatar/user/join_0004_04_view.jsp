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
 * @File Name        : join_0004_04_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/user
 * @author           : 김별 (  )
 * @Description      : 회원가입_약관동의(4.ASKAVATAR-마케팅이벤트정보수집동의)
 * @History          : 20210414133410, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/user/join_0004_04.js
 * @JavaScript Url   : /js/jex/avatar/user/join_0004_04.js
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
    <script type="text/javascript" src="/js/jex/avatar/user/join_0004_04.js?<%=_CURR_DATETIME%>"></script>
</head>

<body><!-- (modify)20210416 -->

<!-- content -->
<div class="content termFixed"><!-- (modify)20210416 -->

	<!-- (add)20210414 -->
	<div class="popLayer_wrap" style="display:block;">
		<div class="popLayer_inn">
			<div class="tit_wrap">
				<h3 class="pop_tit">ASK AVATAR 마케팅, 이벤트 정보 수집 동의</h3>
				<a href="#none" class="btn_close"><img src="../img/btn_popLayer_close.png" alt="Close"></a>
			</div>
			<!-- -->
			<div class="pop_cnt mCustomScrollbar" style="max-height:100%;">
				<div class="pop_cnt_inn">
					<div>
						<h3 class="popTitle_first">ASK AVATAR 마케팅, 이벤트 정보 수집 동의</h3><!-- (add)20210414(r4) -->
						<div class="servTerm">
							<p class="pFirst mgb5">다큐브 주식회사(이하 ‘회사’라 한다)가 제공하는 서비스의 원활한 이용을 위하여, 다음과 같이 ‘회사’가 마케팅 목적으로 본인의 개인정보를 수집/이용하는 것에 동의합니다.</p>
							<div class="servTerm_tbl">
								<table summary="">
									<caption></caption>
									<colgroup>
									<col>
									<col>
									<col>
									</colgroup>
									<thead>
										<tr>
											<th><div>이용목적</div></th>
											<th><div>수집항목</div></th>
											<th><div>보유기간</div></th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><div class="tac">이벤트 등 광고성 메시지 또는 SNS 수신, 마케팅, 서비스 이용 설문</div></td>
											<td><div class="tac">성명, 연락처</div></td>
											<td><div class="tac">이용 신청 해지 시 까지</div></td>
										</tr>
									</tbody>
								</table>
							</div>
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