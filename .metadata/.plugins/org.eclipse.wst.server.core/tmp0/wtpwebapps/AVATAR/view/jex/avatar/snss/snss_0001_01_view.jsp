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
 * @File Name        : snss_0001_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/snss
 * @author           : 박지은 (  )
 * @Description      : 
 * @History          : 20210721162430, 박지은
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/snss/snss_0001_01.js
 * @JavaScript Url   : /js/jex/avatar/snss/snss_0001_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/snss/snss_0001_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5">
<input type="hidden" id="shop_nm"/>
<input type="hidden" id="shop_cd"/>
	<!-- content -->
	<div class="content">

		<div class="m_cont"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			<div class="top_cn_bx">
				<div class="data_cnt type2">
					<h3>배달앱 매출 연결하기</h3>
				</div>
				<!-- 데이터 -->
				<div class="delivery_appBx">
					<div class="delivery_appList" shop_cd="sellBaemin" shop_nm="배달의민족">
						<div class="app001">배달의민족</div>
						<div class="right Compt"><span>연결완료</span></div>
					</div>
					<div class="delivery_appList" shop_cd="sellYogiyo" shop_nm="요기요">
						<div class="app002">요기요</div>
						<div class="right Compt"><span>연결완료</span></div>
					</div>
					<div class="delivery_appList" shop_cd="sellCoupangeats" shop_nm="쿠팡이츠">
						<div class="app003">쿠팡이츠</div>
						<div class="right Compt"><span>연결완료</span></div>
					</div>
				</div>
				<!-- 데이터 -->
			</div>
		</div>
	</div>
	<!-- //content -->
	<div class="modaloverlay" id="modaloverlay1" style="display:none;">
		<div class="lytb"><div class="lytb_row"><div class="lytb_td">
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
		</div></div></div>
	</div>
</body>
</html>