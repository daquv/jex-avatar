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
 * @File Name        : join_0004_11_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/user
 * @author           : 박지은 (  )
 * @Description      : 개인정보 제3자 정보 제공 동의
 * @History          : 20210415170317, 박지은
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/user/join_0004_11.js
 * @JavaScript Url   : /js/jex/avatar/user/join_0004_11.js
 * </pre>
 **/
%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ASK AVATAR</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="user-scalable=yes, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width">
<link rel="stylesheet" href="/css/swipper.css"><!-- (add)20210323 -->
<link rel="stylesheet" href="/css/jquery.mCustomScrollbar.css"><!-- (add)20210414 -->
<link rel="stylesheet" href="/css/avatar.css">
<script type="text/javascript" src="/js/jqueryPlugin/jquery-1.8.3.min.js"></script><!-- (add)20210323 -->
<script type="text/javascript" src="/js/jqueryPlugin/jquery.mCustomScrollbar.concat.min.js"></script><!-- (add)20210414 -->
<script type="text/javascript" src="/js/jqueryPlugin/swiper-bundle.min.js"></script><!-- (add)20210323 -->
<script type="text/javascript" src="/js/jqueryPlugin/publishing.ui.library.1.0.0.js"></script><!-- (add)20210415 -->
<script type="text/javascript" src="/js/jex/avatar/user/join_0004_11.js?"></script>
<script>
$(window.document).on("contextmenu" , function(event){return false;});	//우클릭방지
$(window.document).on("selectstart" , function(event){return false;});	//더블클릭을 통한 선택방지
$(window.document).on("dragstart"	, function(event){return false;});	//드래그

function getUserAgent() {
	var agent = navigator.userAgent.toLowerCase();
	if (agent.indexOf("iphone") > -1 || agent.indexOf("ipad") > -1
			|| agent.indexOf("ipod") > -1) {
		return "ios";
	} else if (agent.match('android') != null) {
		return "android";
	} else {
		return "pc";
	}
}

function iWebAction(actionCode, actionData) {
	
	var action = {
		_action_code : actionCode
	};
	if (actionData == null || actionData == undefined) {
	} else {
		action._action_data = actionData;
	}
	
	if (getUserAgent() == "ios") {
		alert("iWebAction:" + JSON.stringify(action));
	} else if (getUserAgent() == "android") {
		window.BrowserBridge.iWebAction(JSON.stringify(action));
	}else{
		if(actionCode == "popup_webview"){
			location.href = actionData._url;
		}
	}
}
</script>
</head>
<body><!-- (modify)20210416 -->

<!-- content -->
<div class="content termFixed"><!-- (modify)20210416 -->

	<!-- (add)20210415 -->
	<div class="popLayer_wrap" style="display:block;">
		<div class="popLayer_inn">
			<div class="tit_wrap">
				<h3 class="pop_tit">개인정보 제3자 제공 동의</h3>
				<a href="#none" class="btn_close"><img src="../img/btn_popLayer_close.png" alt="Close"></a>
			</div>
			<!-- -->
			<div class="pop_cnt mCustomScrollbar" style="max-height:100%;">
				<div class="pop_cnt_inn">
					<div class="tabs_header">
						<ul class="cboth">
							<li class="js_tabclickDp2 on cols50"><a href="#none"><span>KT</span></a></li>
							<li class="js_tabclickDp2 cols50"><a href="#none"><span>LGU+</span></a></li>
						</ul>
					</div>
					<div class="tabs_body_wrap">
						<!-- [D]KT -->
						<div class="tabs_body">
							<h3 class="popTitle_first">개인정보 제3자 제공 동의</h3>
							<div class="servTerm">
								<p class="pFirst">"알뜰폰(MVNO)"사업자는 다음과 같이 개인정보를 제3자에게 제공하고 있습니다.</p>
								<dl>
									<dt>제1조 (알뜰폰(MVNO) 사업자)</dt>
									<dd>
										<p class="pFirst">㈜케이티의 알뜰폰(MVNO) 사업자는 CJ헬로비전, KT파워텔, 홈플러스, 씨엔커뮤니케이션, 에넥스텔레콤, 에스원, 위너스텔, 에이씨앤코리아, 세종텔레콤, KT텔레캅, 프리텔레콤, 이지모바일, 착한통신, kt M모바일, 앤텔레콤, 에스원(안심폰), 아이즈비전, 제이씨티, 머천드코리아, 장성모바일, 유니컴즈, 아이원, (주)파인디지털, (주)미니게이트, (주)핀플레이, (주)드림라인 입니다.</p>
									</dd>
								</dl>
								<dl>
									<dt>제2조 (제공목적)</dt>
									<dd>
										<p class="pFirst">본 동의는 본인확인 서비스를 제공하기 위하여 본인확인기관인 ㈜케이티와 본인확인서비스 이용자간 본인확인서비스 이용에 필요한 고객정보를 위탁하여 본인확인서비스를 제공 하는 것에 대해 동의합니다.</p>
									</dd>
								</dl>
								<dl>
									<dt>제3조 (제공정보)</dt>
									<dd>
										<p class="pFirst">휴대폰 본인확인 서비스 제공에 필요한 개인정보로 성명, 휴대폰번호, 생년월일, 내.외국인구분, 성별 정보입니다.</p>
									</dd>
								</dl>
								<dl>
									<dt>제4조 (제공받는자)</dt>
									<dd>
										<p class="pFirst">㈜케이티</p>
									</dd>
								</dl>
								<dl>
									<dt>제5조 (제공기간)</dt>
									<dd>
										<p class="pFirst">이동통신사에서 보유중인 정보로서 별도 이용기간은 없습니다. "본인"은 정보제공에 동의하지 않으실 수 있으며, 동의하지 않으실 경우 휴대폰 본인 확인 서비스를 이용 하실 수 없습니다.</p>
									</dd>
								</dl>
							</div>
						</div>
						<!-- //[D]KT -->

						<!-- [D]LGU+ -->
						<div class="tabs_body" style="display:none;">
							<h3 class="popTitle_first">개인정보 제3자 제공 동의</h3>
							<div class="servTerm">
								<p class="pFirst">"알뜰폰(MVNO)"사업자는 다음과 같이 개인정보를 제3자에게 제공하고 있습니다.</p>
								<dl>
									<dt>제1조 (알뜰폰(MVNO) 사업자)</dt>
									<dd>
										<p class="pFirst">엘지유플러스의 알뜰폰(MVNO) 사업자는 (주)미디어로그, (주)인스코비, 머천드코리아, (주)엠티티텔레콤, 홈플러스(주), (주)알뜰폰, 이마트, 서경방송, 울산방송, 푸른방송, 남인천방송, 금강방송, 제주방송, 여유텔레콤, 에이씨앤코리아 입니다.</p>
									</dd>
								</dl>
								<dl>
									<dt>제2조 (제공목적)</dt>
									<dd>
										<p class="pFirst">본 동의는 본인확인 서비스를 제공하기 위하여 본인확인기관인 ㈜엘지유플러스와 본인확인서비스 이용자간 본인확인서비스 이용에 필요한 고객정보를 위탁하여 본인확인서비스를 제공 하는 것에 대해 동의합니다.</p>
									</dd>
								</dl>
								<dl>
									<dt>제3조 (제공정보)</dt>
									<dd>
										<p class="pFirst">휴대폰 본인확인 서비스 제공에 필요한 개인정보로 성명, 휴대폰번호, 생년월일, 내.외국인구분, 성별 정보입니다.</p>
									</dd>
								</dl>
								<dl>
									<dt>제4조 (제공받는자)</dt>
									<dd>
										<p class="pFirst">㈜엘지유플러스</p>
									</dd>
								</dl>
								<dl>
									<dt>제5조 (제공기간)</dt>
									<dd>
										<p class="pFirst">이동통신사에서 보유중인 정보로서 별도 이용기간은 없습니다. "본인"은 정보제공에 동의하지 않으실 수 있으며, 동의하지 않으실 경우 휴대폰 본인 확인 서비스를 이용 하실 수 없습니다.</p>
									</dd>
								</dl>
							</div>
						</div>
						<!-- //[D]LGU+ -->
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
	<!-- //(add)20210415 -->

</div>
<!-- //content -->

<!-- (add)20210415 -->
<script>
$(document).ready(function(){
	$(".pop_cnt").tabs({
		wrapClass:".pop_cnt",
		clickClass:".js_tabclickDp2",
		showClass:".tabs_body",
		animate:false,
		fade:false,
		speed:500
	});
});
</script>
<!-- (add)20210415 -->

</body>
</html>