<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);

    // Action 결과 추출
    String SHOP_CD = StringUtil.null2void(request.getParameter("SHOP_CD"), "sellBaemin");
    String SHOP_NM = StringUtil.null2void(request.getParameter("SHOP_NM"), "배달의민족");
    
    if(SHOP_NM.equals("")){
    	if(SHOP_CD.equals("sellBaemin")){
    		SHOP_NM = "배달의민족";
    	}else if(SHOP_CD.equals("sellYogiyo")){
    		SHOP_NM = "요기요";
    	}else if(SHOP_CD.equals("sellCoupangeats")){
    		SHOP_NM = "쿠팡이츠";
    	}
    }
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : snss_0002_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/snss
 * @author           : 박지은 (  )
 * @Description      : 온라인 매출 쇼핑몰 계정
 * @History          : 20210722085521, 박지은
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/snss/snss_0002_01.js
 * @JavaScript Url   : /js/jex/avatar/snss/snss_0002_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/snss/snss_0002_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5">
<input type="hidden" id="shop_nm" value="<%=SHOP_NM%>"/>
<input type="hidden" id="shop_cd" value="<%=SHOP_CD%>"/>
<input type="hidden" id="sub_shop_cd" value=""/>
	<!-- content -->
<div class="content">

	<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
		<div class="cont_pd">
			<!-- 타이틀 -->
			<div class="tit_wrap mgb0">
				<h2 class="delivery_titLogo">
				<%if(SHOP_CD.equals("sellBaemin")){ %>
					<img src="../img/delivery_titLogo_01.png" alt="배달의민족">
				<%}else if(SHOP_CD.equals("sellYogiyo")){ %>
					<img src="../img/delivery_titLogo_02.png" alt="요기요">
				<%}else if(SHOP_CD.equals("sellCoupangeats")){ %>
					<img src="../img/delivery_titLogo_03.png" alt="쿠팡이츠">
				<%} %>
				</h2>
				
			</div>
			<!-- //타이틀 -->
			<!-- 입력영역 -->
			<div class="frm_login">
				<dl>
					<dt><%=SHOP_NM%> 아이디</dt>
					<dd>
						<div class="input_type"><!-- [D]disabled -->
							<input type="text" id="web_id" placeholder="아이디 입력">
						</div>
					</dd>
					<dt><%=SHOP_NM%> 비밀번호</dt>
					<dd>
						<div class="input_type"><!-- [D]disabled -->
							<input type="password" id="web_pwd" placeholder="비밀번호 입력">
						</div>
					</dd>
				</dl>
			</div>
			<!-- //입력영역 -->
		</div>
	</div>

	<!-- 토스트 팝업 -->
	<div class="toast_pop type1" style="display: none;">
		<div class="inner">
			<span>아이디를 입력하세요.</span>
		</div>
	</div>
	<!-- //토스트 팝업 -->
	
	<!-- 하단 fix버튼 -->
	<div class="btn_fix_botm type4">
		<div class="inner">
			<a id="reg_btn"><%=SHOP_NM%> 연결하기</a>
		</div>
	</div>
	<div class="btn_fix_botm type4 btn_both" style="display: none;">
		<div class="inner">
			<a id="del_btn" class="off">삭제</a>
			<a id="confirm_btn">확인</a>
		</div>
	</div>
	<!-- //하단 fix버튼 -->

</div>
<!-- //content -->

</body>
</html>