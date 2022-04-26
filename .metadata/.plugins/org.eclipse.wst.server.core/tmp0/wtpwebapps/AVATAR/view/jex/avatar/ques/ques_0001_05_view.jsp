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
 * @File Name        : ques_0001_05_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20210602140938, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0001_05.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0001_05.js
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
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_0001_05.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F9F9F9"><!-- (modify)20210323 -->

<!-- content -->
<div class="content pdb0">

	<div class="m_cont">
		<div class="sect_bann bg_FAF2E4">
			<div class="sect_bann_in">
				<div class="tit_bann">
					<h2>금융자산현황</h2>
				</div>
				<div class="dsc">
					<p>
						오늘의 금융 자산 현황을 물어보세요.<br>
						아바타가 계좌별 자산 현황을 정확하게<br>
						알려드려요.
					</p>
				</div>
				<div class="banner_img">
					<img src="../img/b099_1.png" alt="금융자산현황">
				</div>
			</div>
		</div>
		<div class="sect_bann bg_DFEBF5">
			<div class="sect_bann_in">
				<div class="tit_bann">
					<h2>환율</h2>
				</div>
				<div class="dsc">
					<p>
						해외 송금 하기 전,<br>
						아바타에게 오늘의 환율을 물어보세요.<br>
						주요 통화의 환율 현황을 실시간으로<br>
						알려드려요.
					</p>
				</div>
				<div class="banner_img">
					<img src="../img/b099_2.png" alt="환율">
				</div>
			</div>
		</div>
		<div class="sect_bann bg_F6F4F8">
			<div class="sect_bann_in">
				<div class="tit_bann">
					<h2>법인카드한도</h2>
				</div>
				<div class="dsc">
					<p>
						법인카드로 결제하기 전에<br>
						한도가 궁금하다면<br>
						아바타에게 물어보세요.<br>
						카드별 한도액을 바로 확인할 수 있어요.
					</p>
				</div>
				<div class="banner_img">
					<img src="../img/b099_3.png" alt="법인카드한도">
				</div>
			</div>
		</div>
		<div class="sect_bann bg_RFG5F4">
			<div class="sect_bann_in">
				<div class="tit_bann">
					<h2>세금납부액</h2>
				</div>
				<div class="dsc">
					<p>
						세금을 납부할 시기가 되었다면<br>
						아바타에게 세액이 얼마인지<br>
						물어보세요.<br>
						세목별로 친절하게 알려줍니다.
					</p>
				</div>
				<div class="banner_img">
					<img src="../img/b099_4.png" alt="세금납부액">
				</div>
			</div>
		</div>
		<div class="sect_bann bg_F8F7F7">
			<div class="sect_bann_in">
				<div class="tit_bann">
					<h2>대출금</h2>
				</div>
				<div class="dsc">
					<p>
						대출 만기가 가까워진 것 같다면<br>
						아바타에게 대출금 잔액을 물어보세요.<br>
						은행별 대출현황을 상세히 알려드려요.
					</p>
				</div>
				<div class="banner_img">
					<img src="../img/b099_5.png" alt="대출금">
				</div>
			</div>
		</div>
	</div>

</div>
<!-- //content -->

</body>
</html>