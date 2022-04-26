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
 * @File Name        : card_0005_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/card
 * @author           : 김태훈 (  )
 * @Description      : 카드매입-카드사선택화면
 * @History          : 20200128155412, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/card/card_0005_01.js
 * @JavaScript Url   : /js/jex/avatar/card/card_0005_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/card/card_0005_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5">
	<!-- content -->
	<div class="content">

		<div class="m_cont"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
		
			<div class="cont_pd20">
				<!-- 데이터 -->
				<div class="data_wbx pdt12">
					<div class="ico_bank">
						<div class="card001" id="021"><span class="blind">NH농협카드</span></div>
						<div class="right"><a class="on">연결하기 </a></div>
					</div>
					<div class="ico_bank">
						<div class="card002" id="001"><span class="blind">국민카드</span></div>
						<div class="right"><a class="on">연결하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="card003" id="003"><span class="blind">삼성카드</span></div>
						<div class="right"><a class="on">연결하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="card004" id="008"><span class="blind">신한카드</span></div>
						<div class="right"><a class="on">연결하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="card005" id="002"><span class="blind">현대카드</span></div>
						<div class="right"><a class="on">연결하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="card006" id="017"><span class="blind">롯데카드</span></div>
						<div class="right"><a class="on">연결하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="card007" id="015"><span class="blind">하나카드</span></div>
						<div class="right"><a class="on">연결하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="card008" id="018"><span class="blind">우리카드</span></div>
						<div class="right"><a class="on">연결하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="card009" id="006"><span class="blind">BC카드</span></div>
						<div class="right"><a class="on">연결하기</a></div>
					</div>
				</div>
				<!-- 데이터 -->
				<ul class="card_info">
					<li>※ IBK기업, SC제일, 대구, 부산, 경남 은행은 BC카드로 등록해주세요.</li>
					<li>※ 카드사에 먼저 회원가입 후 등록해주세요.</li>
					<li>※ 네트워크 상황에 따라 수분이 소요될수 있습니다.</li>
				</ul>
			</div>
		
			<%-- <div class="top_cn_bx">
				<!-- 타이틀 -->
				<div class="top_tit_wrap">
					<h1>데이터를 가져올 카드를 선택하세요.(1개 카드사)</h1>
				</div>
				<!-- //타이틀 -->
			</div>

			<div class="cont_pd">
				<!-- 은행선택 -->
				<div class="bank_area">
					<ul>
						<li id="021" class="bank1"><a><span class="bg"><span></span></span></a></li><!-- NH농협카드 -->
						<li id="001" class="bank2"><a><span class="bg"><span></span></span></a></li><!-- KB 국민카드 -->
						<li id="003" class="bank3"><a><span class="bg"><span></span></span></a></li><!-- SAMSUNG CARD -->
						<li id="008" class="bank4"><a><span class="bg"><span></span></span></a></li><!-- 신한카드 -->
						<li id="002" class="bank5"><a><span class="bg"><span></span></span></a></li><!-- 현대카드 -->
						<li id="019" class="bank6"><a><span class="bg"><span></span></span></a></li><!-- 롯데카드 -->
						<li id="015" class="bank7"><a><span class="bg"><span></span></span></a></li><!-- 하나카드 -->
						<li id="018" class="bank8"><a><span class="bg"><span></span></span></a></li><!-- 우리카드 -->
						<li id="009" class="bank9"><a><span class="bg"><span></span></span></a></li><!-- 씨티카드 -->
						<li id="006" class="bank11"><a><span class="bg"><span></span></span></a></li><!-- BC card -->
					</ul>
				</div>
				<!-- //은행선택 -->

				<!-- 하단문구 -->
				<p class="info_txt2 add_ico">
					<span class="ico">※</span>IBK기업, SC제일, 대구, 부산, 경남 은행은 BC카드로 등록해주세요.
				</p>
				<p class="info_txt2 add_ico">
					<span class="ico">※</span>카드사에 먼저 회원가입 후 등록해주세요.
				</p>
				<p class="info_txt2 add_ico">
					<span class="ico">※</span>네트워크 상황에 따라 수분이 소요될 수 있습니다.
				</p>
				<!-- //하단문구 -->
			</div>
		</div>

		<!-- 하단 fix버튼 -->
		<div class="btn_fix_botm">
			<div class="inner">
				<a class="off" id="a_next">다음</a>
			</div>
		</div>
		<!-- //하단 fix버튼 --> --%>

	</div>
	<!-- //content -->
	<!-- modal overlay -->
	<div class="modaloverlay" id="modaloverlay1" style="display:none;">
		<div class="lytb"><div class="lytb_row"><div class="lytb_td">
		<!-- layerpopup -->
		<div class="layer_style1">
			<div class="layer_po">
				<div class="cont">
					<div class="lyp_tit">
						데이터를 수집 중입니다.<br />
						잠시 후에 다시 시도해 주세요.
					</div>
				</div>
			</div>
			<div class="ly_btn_fix_botm">
				<a id="pop_btn01">확인</a>
			</div>
		</div>
		<!-- //layerpopup -->
		</div></div></div>
	</div>
	<!-- //modal overlay -->
</body>
</html>