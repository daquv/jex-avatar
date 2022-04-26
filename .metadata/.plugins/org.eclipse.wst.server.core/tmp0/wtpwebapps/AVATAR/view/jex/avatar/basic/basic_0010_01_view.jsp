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
 * @File Name        : basic_0010_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 김별 (  )
 * @Description      : 유료이용서비스 화면
 * @History          : 20210325175801, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0010_01.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0010_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/basic/basic_0010_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5"><!-- (modify)20210323 -->

<!-- content -->
<div class="content">

	<div class="m_cont pdt12">
		<!-- 컨텐츠 영역 -->
		<!-- (modify)20210729 -->
		<div class="pay_serv_wrap">
			<div class="pay_serv_detail">
				<div class="left">
					<p class="ic"><img src="../img/ic_bank2.png" alt="은행"></p>
					<div class="pay_serv_tit">
						<a href="#none">
							은행 데이터<br>
							매시간 가져오기
						</a>
					</div>
				</div>
				<div class="right">
					<p class="nor_price">
						<span class="tx">정상가</span>
						<span class="num">월 <em>1,000</em> 원</span>
					</p>
					<p class="dis_price">
						<span class="tx">할인가</span>
						<span class="num"><em>0</em> 원</span>
					</p>
				</div>
			</div>
			<div class="pay_serv_detail">
				<div class="left">
					<p class="ic"><img src="../img/ic_tax2.png" alt="홈택스"></p>
					<div class="pay_serv_tit">
						<a href="#none">
							홈택스 데이터<br>
							매시간 가져오기
						</a>
					</div>
				</div>
				<div class="right">
					<p class="nor_price">
						<span class="tx">정상가</span>
						<span class="num">월 <em>1,000</em> 원</span>
					</p>
					<p class="dis_price">
						<span class="tx">할인가</span>
						<span class="num"><em>0</em> 원</span>
					</p>
				</div>
			</div>
			<div class="pay_serv_detail">
				<div class="left">
					<p class="ic"><img src="../img/ic_cred_card2.png" alt="카드사"></p>
					<div class="pay_serv_tit">
						<a href="#none">
							카드사 데이터<br>
							매시간 가져오기
						</a>
					</div>
				</div>
				<div class="right">
					<p class="nor_price">
						<span class="tx">정상가</span>
						<span class="num">월 <em>1,000</em> 원</span>
					</p>
					<p class="dis_price">
						<span class="tx">할인가</span>
						<span class="num"><em>0</em> 원</span>
					</p>
				</div>
			</div>
			<div class="pay_serv_detail">
				<div class="left">
					<p class="ic"><img src="../img/ic_online2.png" alt="온라인매출"></p>
					<div class="pay_serv_tit">
						<a href="#none">
							온라인매출 데이터<br>
							매시간 가져오기
						</a>
					</div>
				</div>
				<div class="right">
					<p class="nor_price">
						<span class="tx">정상가</span>
						<span class="num">월 <em>1,000</em> 원</span>
					</p>
					<p class="dis_price">
						<span class="tx">할인가</span>
						<span class="num"><em>0</em> 원</span>
					</p>
				</div>
			</div>
		</div>
		<!-- 하단문구 -->
		<div class="info_txt4 type2">
			<p>2021년말까지 무료입니다.</p>
		</div>
		<!-- //하단문구 -->
		<!-- //(modify)20210729 -->
		<!-- //컨텐츠 영역 -->
	</div>

</div>
<!-- //content -->

</body>
</html>