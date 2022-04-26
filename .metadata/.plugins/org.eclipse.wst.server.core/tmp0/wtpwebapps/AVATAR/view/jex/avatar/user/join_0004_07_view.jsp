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
 * @File Name        : join_0004_07_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/user
 * @author           : 박지은 (  )
 * @Description      : 개인정보 수집/이용/취급 위탁동의
 * @History          : 20210415170140, 박지은
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/user/join_0004_07.js
 * @JavaScript Url   : /js/jex/avatar/user/join_0004_07.js
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
<script type="text/javascript" src="/js/jex/avatar/user/join_0004_07.js?"></script>
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
				<h3 class="pop_tit">개인정보 수집/이용/취급 위탁동의</h3>
				<a href="#none" class="btn_close"><img src="../img/btn_popLayer_close.png" alt="Close"></a>
			</div>
			<!-- -->
			<div class="pop_cnt mCustomScrollbar" style="max-height:100%;">
				<div class="pop_cnt_inn">
					<div class="tabs_header">
						<ul class="cboth">
							<li class="js_tabclickDp2 on"><a href="#none"><span>SKT</span></a></li>
							<li class="js_tabclickDp2"><a href="#none"><span>KT</span></a></li>
							<li class="js_tabclickDp2"><a href="#none"><span>LGU+</span></a></li>
						</ul>
					</div>
					<div class="tabs_body_wrap">
						<!-- [D]SKT -->
						<div class="tabs_body">
							<h3 class="popTitle_first">개인정보 수집/이용/취급 위탁동의</h3>
							<div class="servTerm">
								<h3 class="tit_h3 pFirst">SK텔레콤 귀중</h3>
								<p>본인은 SK텔레콤(주)(이하 ‘회사’라 합니다)가 제공하는 본인확인서비스(이하 ‘서비스’라 합니다)를 이용하기 위해, 다음과 같이 ‘회사’가 본인의 개인정보를 수집/이용하고, 개인정보의 취급을 위탁하는 것에 동의합니다.</p>
								<dl>
									<dt>1. 수집항목</dt>
									<dd>
										<ul>
											<li>- 이용자의 성명,이동전화번호, 가입한 이동전화 회사, 생년월일, 성별</li>
											<li>- 연계정보(CI), 중복가입확인정보(DI)</li>
											<li>- 이용자가 이용하는 웹사이트 또는 Application 정보, 이용일시</li>
											<li>- 내외국인 여부</li>
											<li>- 가입한 이동전화회사 및 이동전화브랜드</li>
										</ul>
									</dd>
								</dl>
								<dl>
									<dt>2. 이용목적</dt>
									<dd>
										<ol>
											<li>- 이용자가 웹사이트 또는 Application에 입력한 본인확인정보의 정확성 여부 확인(본인확인서비스 제공)</li>
											<li>- 해당 웹사이트 또는 Application에 연계정보(CI)/중복가입확인정보(DI) 전송</li>
											<li>- 서비스 관련 상담 및 불만 처리 등</li>
											<li>- 이용 웹사이트/Application 정보 등에 대한 분석 및 세분화를 통한, 이용자의 서비스 이용 선호도 분석</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>3. 개인정보의 보유기간 및 이용기간</dt>
									<dd>
										<ol>
											<li>- 이용자가 서비스를 이용하는 기간에 한하여 보유 및 이용. 다만, 아래의 경우는 제외</li>
											<li>- 법령에서 정하는 경우 해당 기간까지 보유(상세 사항은 회사의 개인정보취급방침에 기재된 바에 따름)</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>4. 본인확인서비스 제공을 위한 개인정보의 취급위탁</dt>
									<dd>
										<div class="servTerm_tbl">
											<table summary="">
												<caption></caption>
												<colgroup>
												<col style="width:25%;">
												<col>
												</colgroup>
												<tbody>
													<tr>
														<th><div>수탁자</div></th>
														<td><div>NICE평가정보(주),(주)다날,(주)드림시큐리티,SCI평가정보(주),NHN한국사이버결제(주),(주)KG모빌리언스,코리아크레딧뷰로(주),한국모바일인증(주)</div></td>
													</tr>
													<tr>
														<th><div>취급위탁 업무</div></th>
														<td><div>본인확인정보의 정확성 여부 확인(본인확인서비스 제공), 연계정보(CI)/중복가입확인정보(DI) 생성 및 전송, 서비스 관련 상담 및 불만 처리, 휴대폰인증보호 서비스, 이용자의 서비스 이용 선호도 분석정보 제공관련 시스템 구축 광고매체 연동 및 위탁영업 등</div></td>
													</tr>
												</tbody>
											</table>
										</div>
										<p>※수탁자의 상세 개인정보 취급 위탁 내용은 각 수탁자가 정하는 절차와 방법에 따라 수탁자 홈페이지 등에 게시된 수탁자의 개인정보 취급방침 및 제3자 제공 동의 방침 등에 따릅니다.</p>
									</dd>
								</dl>
								<dl>
									<dt>5. 위 개인정보 수집·이용 및 취급위탁에 동의하지 않으실 경우, 서비스를 이용하실 수 없습니다.</dt>
									<dd>
										<p class="pFirstNext">* 회사가 제공하는 서비스와 관련된 개인정보의 취급과 관련된 사항은, 회사의 개인정보취급방침(회사 홈페이지 www.sktelecom.com )에 따릅니다.</p>
										<ul>
											<li>본인은 위 내용을 숙지하였으며 이에 동의합니다.</li>
										</ul>
									</dd>
								</dl>
								<h3 class="tit_h3">&lt;코리아크레딧뷰로㈜ 귀중&gt;</h3>
								<p>귀사가 통신사(에스케이텔레콤㈜, ㈜케이티, LG유플러스㈜)로부터 위탁 받아 제공하는 휴대폰본인확인서비스 이용과 관련하여 본인의 개인정보를 수집·이용 및 제공하고자 하는 경우에는 「개인정보보호법」 제15조, 제22조, 제24조, 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」 제22조에 따라 본인의 동의를 얻어야 합니다. 이에 본인은 귀사가 아래와 같이 본인의 개인정보를 수집 · 이용 및 제공 하는데 동의합니다.</p>
								<dl>
									<dt>□ 개인정보의 수집 및 이용목적</dt>
									<dd>
										<ol>
											<li>
												① 주민등록번호 대체서비스 제공<br>
												개인정보보호법 제24조 2항에 의해 온라인 또는 오프라인상에서 회원가입, 글쓰기, 포인트적립 등 주민등록번호를 사용하지 않고도 본인임을 확인할 수 있는 개인정보보호 서비스(휴대폰본인확인서비스) 제공
											</li>
											<li>② 에스케이텔레콤(주), (주)케이티, LG유플러스(주) 등 통신사에 이용자 정보를 전송하여 본인확인 및 휴대폰 정보의 일치 여부 확인</li>
											<li>③ 휴대폰 사용자 확인을 위한 SMS(또는 LMS) 인증번호 전송</li>
											<li>④ 부정 이용 방지 및 수사의뢰</li>
											<li>⑤ 이용자 본인 요청에 의한 본인확인 이력정보 제공, 민원처리, 추후 분쟁조정을 위한 기록보존, 고지사항 전달 등</li>
											<li>⑥ 휴대폰번호보호서비스 가입여부 확인(서비스 가입자에 한함)</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>□ 수집할 개인정보</dt>
									<dd>
										<ol>
											<li>① 이용자가 가입한 이동통신사, 휴대폰번호, 성명, 성별, 생년월일, 내/외국인 구분</li>
											<li>② 중복가입확인정보(발급자의 웹사이트 중복가입 여부를 확인할 수 있는 정보)</li>
											<li>③ 연계정보(온/오프라인 사업자간 제휴 등 연계서비스가 가능하도록 특정 개인을 식별할 수 있는 정보)</li>
											<li>④ 인증처 및 사이트 URL</li>
											<li>⑤ 인증일시</li>
											<li>⑥ IP주소</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>□ 개인정보의 제공</dt>
									<dd>
										<ol>
											<li>
												① 휴대폰본인확인서비스 제공
												<ul>
													<li>- 제공 받는자: SK텔레콤(주), (주)케이티, ㈜엘지유플러스</li>
													<li>- 제공 목적: 업무대행(본인확인정보 및 연계정보 전송 및 서비스 관련 업무 상담 및 불만처리 등)</li>
													<li>- 제공 항목: 생년월일, 성명, 성별, 내/외국인 구분, 휴대폰번호, 이동통신사</li>
													<li>- 보유 기간: “제공받는 자”의 이용목적 달성 시 까지 보관하며, 세부사항은 각 사업자의 개인정보처리방침을 따름</li>
												</ul>
											</li>
											<li>
												② 휴대폰본인확인서비스 문자발송
												<ul>
													<li>- 제공 받는자: SK텔레콤(주), (주)케이티, ㈜엘지유플러스</li>
													<li>- 제공 목적: 휴대폰본인확인서비스 점유확인을 위한 문자발송</li>
													<li>- 제공 항목: 휴대폰번호</li>
													<li>- 보유 기간: “제공받는 자”의 이용목적 달성 시 까지 보관하며, 세부사항은 각 사업자의 개인정보처리방침을 따름</li>
												</ul>
											</li>
											<li>
												③ 휴대폰본인확인서비스 제공 (서비스 이용 사업자)
												<ul>
													<li>- 제공 받는자: 휴대폰본인확인서비스 이용 회사(코리아크레딧뷰로㈜(이하 “회사”)와 계약된 사업자)</li>
													<li>- 제공 목적: 휴대폰본인확인서비스 제공</li>
													<li>- 제공 항목: 생년월일, 성명, 성별, 내/외국인 구분, 휴대폰번호, 이동통신사, IP주소, 중복가입확인정보(DI), 연계정보(CI)</li>
													<li>- 보유 기간: “회사”와 계약한 사업자의 이용목적 달성시 까지 보관하며, 세부사항은 각 사업자의 개인정보처리방침을 따름</li>
												</ul>
											</li>
											<li>
												④ 휴대폰인증보호서비스 안내(광고성정보 수신동의 선택 시)
												<ul>
													<li>- 제공 받는자: ㈜민앤지, ㈜한국인증플랫폼즈</li>
													<li>- 제공 목적: 휴대폰인증보호서비스(휴대폰번호도용방지서비스) 안내</li>
													<li>- 제공 항목: 휴대폰번호, 통신</li>
													<li>- 보유 기간: 목적달성 후 폐기(동의 철회 시)</li>
												</ul>
											</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>□ 개인정보의 보유 및 이용기간</dt>
									<dd>
										<p class="pFirstNext">개인정보는 원칙적으로 개인정보의 수집목적 또는 제공받은 목적이 소멸되면 파기됩니다. 단, “개인정보보호법”, “정보통신망 이용 촉진 및 정보보호 등에 관한 법률”, “신용정보의 이용 및 보호에 관한 법률”, ” 본인확인기관 지정 및 관리에 관한 지침”, ”방송통신위원회 고시” 등 기타 관련법령의 규정에 의하여 법률관계의 확인 등을 이유로 특정한 기간 동안 보유하여야 할 필요가 있을 경우에는 아래에 정한 기간 동안 보유합니다.</p>
										<ol>
											<li>
												① 방송통신위원회 정기점검 이행조치 및 회사내부 방침에 의한 정보보유 사유로 본인확인 이력보관<br>
												-부정이용 방지 및 민원처리 : 1년 이내
											</li>
											<li>
												② 관계법령에 의한 정보보호 사유<br>
												-소비자의 불만 또는 분쟁처리에 관한 기록 : 3년
											</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>□ 동의거부권리 및 거부에 따른 불이익 내용</dt>
									<dd>
										<p class="pFirst">개인정보 수집·이용 및 제공 에 따른 동의는 거부할 수 있으며, 동의 후에도 언제든지 철회 가능합니다. 다만, 동의 거부 시에는 서비스 이용이 제한될 수 있습니다.</p>
									</dd>
								</dl>
							</div>
						</div>
						<!-- //[D]SKT -->

						<!-- [D]KT -->
						<div class="tabs_body" style="display:none;">
							<h3 class="popTitle_first">개인정보 수집/이용/취급 위탁동의</h3>
							<div class="servTerm">
								<h3 class="tit_h3 pFirst">(주)케이티 귀중</h3>
								<p>(주)케이티(이하 ‘회사’라 함)가 제공하는 본인확인서비스를 이용하기 위해, 다음과 같이 ‘회사’가 본인의 개인정보를 수집 및 이용하고, 개인정보의 취급을 위탁하는 것에 동의합니다.</p>
								<dl>
									<dt>1. 수집항목</dt>
									<dd>
										<ul>
											<li>- 이용자가 가입한 이동통신사, 휴대폰번호, 성명, 성별, 생년월일, 내/외국인 구분</li>
											<li>- 연계정보(CI), 중복가입확인정보(DI)</li>
											<li>- 이용자가 본인확인을 요청한 서비스명 및 URL정보, 본인확인 이용일시, IP 주소</li>
										</ul>
									</dd>
								</dl>
								<dl>
									<dt>2. 이용목적</dt>
									<dd>
										<ol>
											<li>- 인터넷사업자의 서비스(회원가입, ID/PW찾기 등) 이용에 필요한 이용자 본인확인 여부 및 정보 전달(※ 이용자가 본인확인을 요청한 인터넷사업자에 한합니다.)</li>
											<li>- (주)케이티 등 이동통신사에 이용자 정보를 전송하여 본인확인 및 휴대폰 정보의 일치 여부 확인</li>
											<li>- 휴대폰 사용자 확인을 위한 SMS 인증번호 전송</li>
											<li>- 부정 이용 방지</li>
											<li>- 이용자 본인 요청에 의한 본인확인 이력정보 제공</li>
											<li>- 휴대폰번호보호서비스 가입여부 확인(서비스 가입자에 한함)</li>
											<li>- 기타 법률에서 정한 목적</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>3.개인정보의 보유 및 이용기간</dt>
									<dd>
										<p class="pFirstNext">"회사"는 이용자의 개인정보를 이용목적이 달성되거나 보유 및 보존기간이 종료하면 해당 정보를 지체없이 파기 하며 별도의 보관을 하지 않습니다. 단, 아래의 경우는 제외합니다.</p>
										<ul>
											<li>- 법령에서 정하는 경우 해당 기간까지 보유(상세 사항은 회사의 개인정보처리방침에 기재된 바에 따름</li>
										</ul>
									</dd>
								</dl>
								<dl>
									<dt>4.본인확인서비스 제공을 위한 개인정보의 취급 위탁</dt>
									<dd>
										<div class="servTerm_tbl">
											<table summary="">
												<caption></caption>
												<colgroup>
												<col style="width:25%;">
												<col>
												</colgroup>
												<tbody>
													<tr>
														<th><div>수탁자</div></th>
														<td><div>코리아크레딧뷰로(주)</div></td>
													</tr>
													<tr>
														<th><div>취급위탁 업무</div></th>
														<td><div>본인확인정보의 정확성 여부 확인, 연계정보(CI) 및 중복가입확인정보(DI) 전송, 서비스 관련 상담 및 불만 처리 등</div></td>
													</tr>
												</tbody>
											</table>
										</div>
									</dd>
								</dl>
								<dl>
									<dt>5. 상기 개인정보 수집 및 이용과 취급위탁에 동의하지 않는 경우, 서비스를 이용할 수 없습니다.</dt>
									<dd>
										<p class="pFirstNext">‘회사’가 제공하는 서비스의 개인정보 취급과 관련된 사항은 아래의 ‘회사’ 홈페이지에 기재된 개인정보취급방침에 따릅니다.</p>
										<ul>
											<li>- (주)케이티 : www.kt.com</li>
										</ul>
									</dd>
								</dl>
								<h3 class="tit_h3">&lt;코리아크레딧뷰로㈜ 귀중&gt;</h3>
								<p>귀사가 통신사(에스케이텔레콤㈜, ㈜케이티, LG유플러스㈜)로부터 위탁 받아 제공하는 휴대폰본인확인서비스 이용과 관련하여 본인의 개인정보를 수집·이용 및 제공하고자 하는 경우에는 「개인정보보호법」 제15조, 제22조, 제24조, 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」 제22조에 따라 본인의 동의를 얻어야 합니다. 이에 본인은 귀사가 아래와 같이 본인의 개인정보를 수집 · 이용 및 제공 하는데 동의합니다.</p>
								<dl>
									<dt>□ 개인정보의 수집 및 이용목적</dt>
									<dd>
										<ol>
											<li>
												① 주민등록번호 대체서비스 제공<br>
												개인정보보호법 제24조 2항에 의해 온라인 또는 오프라인상에서 회원가입, 글쓰기, 포인트적립 등 주민등록번호를 사용하지 않고도 본인임을 확인할 수 있는 개인정보보호 서비스(휴대폰본인확인서비스) 제공
											</li>
											<li>② 에스케이텔레콤(주), (주)케이티, LG유플러스(주) 등 통신사에 이용자 정보를 전송하여 본인확인 및 휴대폰 정보의 일치 여부 확인</li>
											<li>③ 휴대폰 사용자 확인을 위한 SMS(또는 LMS) 인증번호 전송</li>
											<li>④ 부정 이용 방지 및 수사의뢰</li>
											<li>⑤ 이용자 본인 요청에 의한 본인확인 이력정보 제공, 민원처리, 추후 분쟁조정을 위한 기록보존, 고지사항 전달 등</li>
											<li>⑥ 휴대폰번호보호서비스 가입여부 확인(서비스 가입자에 한함)</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>□ 수집할 개인정보</dt>
									<dd>
										<ol>
											<li>① 이용자가 가입한 이동통신사, 휴대폰번호, 성명, 성별, 생년월일, 내/외국인 구분</li>
											<li>② 중복가입확인정보(발급자의 웹사이트 중복가입 여부를 확인할 수 있는 정보)</li>
											<li>③ 연계정보(온/오프라인 사업자간 제휴 등 연계서비스가 가능하도록 특정 개인을 식별할 수 있는 정보)</li>
											<li>④ 인증처 및 사이트 URL</li>
											<li>⑤ 인증일시</li>
											<li>⑥ IP주소</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>□ 개인정보의 제공</dt>
									<dd>
										<ol>
											<li>
												① 휴대폰본인확인서비스 제공
												<ul>
													<li>- 제공 받는자: SK텔레콤(주), (주)케이티, ㈜엘지유플러스</li>
													<li>- 제공 목적: 업무대행(본인확인정보 및 연계정보 전송 및 서비스 관련 업무 상담 및 불만처리 등)</li>
													<li>- 제공 항목: 생년월일, 성명, 성별, 내/외국인 구분, 휴대폰번호, 이동통신사</li>
													<li>- 보유 기간: “제공받는 자”의 이용목적 달성 시 까지 보관하며, 세부사항은 각 사업자의 개인정보처리방침을 따름</li>
												</ul>
											</li>
											<li>
												② 휴대폰본인확인서비스 문자발송
												<ul>
													<li>- 제공 받는자: SK텔레콤(주), (주)케이티, ㈜엘지유플러스</li>
													<li>- 제공 목적: 휴대폰본인확인서비스 점유확인을 위한 문자발송</li>
													<li>- 제공 항목: 휴대폰번호</li>
													<li>- 보유 기간: “제공받는 자”의 이용목적 달성 시 까지 보관하며, 세부사항은 각 사업자의 개인정보처리방침을 따름</li>
												</ul>
											</li>
											<li>
												③ 휴대폰본인확인서비스 제공 (서비스 이용 사업자)
												<ul>
													<li>- 제공 받는자: 휴대폰본인확인서비스 이용 회사(코리아크레딧뷰로㈜(이하 “회사”)와 계약된 사업자)</li>
													<li>- 제공 목적: 휴대폰본인확인서비스 제공</li>
													<li>- 제공 항목: 생년월일, 성명, 성별, 내/외국인 구분, 휴대폰번호, 이동통신사, IP주소, 중복가입확인정보(DI), 연계정보(CI)</li>
													<li>- 보유 기간: “회사”와 계약한 사업자의 이용목적 달성시 까지 보관하며, 세부사항은 각 사업자의 개인정보처리방침을 따름</li>
												</ul>
											</li>
											<li>
												④ 휴대폰인증보호서비스 안내(광고성정보 수신동의 선택 시)
												<ul>
													<li>- 제공 받는자: ㈜민앤지, ㈜한국인증플랫폼즈</li>
													<li>- 제공 목적: 휴대폰인증보호서비스(휴대폰번호도용방지서비스) 안내</li>
													<li>- 제공 항목: 휴대폰번호, 통신</li>
													<li>- 보유 기간: 목적달성 후 폐기(동의 철회 시)</li>
												</ul>
											</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>□ 개인정보의 보유 및 이용기간</dt>
									<dd>
										<p class="pFirstNext">개인정보는 원칙적으로 개인정보의 수집목적 또는 제공받은 목적이 소멸되면 파기됩니다. 단, “개인정보보호법”, “정보통신망 이용 촉진 및 정보보호 등에 관한 법률”, “신용정보의 이용 및 보호에 관한 법률”, ” 본인확인기관 지정 및 관리에 관한 지침”, ”방송통신위원회 고시” 등 기타 관련법령의 규정에 의하여 법률관계의 확인 등을 이유로 특정한 기간 동안 보유하여야 할 필요가 있을 경우에는 아래에 정한 기간 동안 보유합니다.</p>
										<ol>
											<li>
												① 방송통신위원회 정기점검 이행조치 및 회사내부 방침에 의한 정보보유 사유로 본인확인 이력보관<br>
												-부정이용 방지 및 민원처리 : 1년 이내
											</li>
											<li>
												② 관계법령에 의한 정보보호 사유<br>
												-소비자의 불만 또는 분쟁처리에 관한 기록 : 3년
											</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>□ 동의거부권리 및 거부에 따른 불이익 내용</dt>
									<dd>
										<p class="pFirst">개인정보 수집·이용 및 제공 에 따른 동의는 거부할 수 있으며, 동의 후에도 언제든지 철회 가능합니다. 다만, 동의 거부 시에는 서비스 이용이 제한될 수 있습니다.</p>
									</dd>
								</dl>
							</div>
						</div>
						<!-- //[D]KT -->

						<!-- [D]LGU+ -->
						<div class="tabs_body" style="display:none;">
							<h3 class="popTitle_first">개인정보 수집/이용/취급 위탁동의</h3>
							<div class="servTerm">
								<h3 class="tit_h3 pFirst">LGU플러스(주) 귀중</h3>
								<p>LGU플러스(주) (이하 ‘회사’라 함)가 제공하는 본인확인서비스를 이용하기 위해, 다음과 같이 ‘회사’가 본인의 개인정보를 수집 및 이용하고, 개인정보의 취급을 위탁하는 것에 동의합니다.</p>
								<dl>
									<dt>1. 수집항목</dt>
									<dd>
										<ul>
											<li>- 고객의 생년월일, 이동전화번호, 성명, 성별, 내/외국인 구분</li>
											<li>- 연계정보(CI), 중복가입확인정보(DI)</li>
											<li>- 고객이 이용하는 웹사이트 등</li>
										</ul>
									</dd>
								</dl>
								<dl>
									<dt>2. 이용목적</dt>
									<dd>
										<ol>
											<li>- 고객이 웹사이트 또는 Application 등에 입력한 본인확인정보의 정확성 여부 확인</li>
											<li>- 해당 웹사이트 또는 Application 등에 연계정보(CI)와 중복가입확인정보)DI) 전송</li>
											<li>- 서비스 관련 상담 및 불만 처리</li>
											<li>- 기타 법룰에서 정한 목적</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>3. 개인정보의 보유 및 이용기간</dt>
									<dd>
										<ol>
											<li>- 고객이 서비스를 이용하는 기간에 한하여 보유 및 이용을 원칙으로 하되, 법률에서 정하는 경우 해당 기간까지 보유 및 이용(세부사항은 ‘회사’의 개인정보취급방침에 따름)</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>4. 본인확인서비스 제공을 위한 개인정보의 취급 위탁</dt>
									<dd>
										<ul>
											<li>
												-수탁자 : 코리아크레딧뷰로㈜<br>
												-위탁업무내용: 본인확인 서비스 중계 업무 제공
											</li>
											<li>
												-수탁자 : CS리더, LB휴넷, 아이알링크 주식회사, (주)씨에스원파트너<br>
												-위탁업무내용: 고객센터 운영
											</li>
											<li>
												-수탁자 : 미디어로그<br>
												-위탁업무내용: PASS 어플리케이션 및 웹사이트 운영/관리
											</li>
											<li>
												-수탁자 : 아톤<br>
												-위탁업무내용: PASS 서비스 장애 및 VOC처리
											</li>
										</ul>
									</dd>
								</dl>
								<dl>
									<dt>5. 상기 개인정보 수집 및 이용과 취급위탁에 동의하지 않는 경우, 서비스를 이용할 수 없습니다.</dt>
									<dd>
										<p class="pFirstNext">‘회사’가 제공하는 서비스의 개인정보 취급과 관련된 사항은 아래의 ‘회사’ 홈페이지에 기재된 개인정보취급방침에 따릅니다.</p>
										<ul>
											<li>- LGU플러스(주) : www.lguplus.co.kr</li>
										</ul>
									</dd>
								</dl>
								<h3 class="tit_h3">&lt;코리아크레딧뷰로㈜ 귀중&gt;</h3>
								<p>귀사가 통신사(에스케이텔레콤㈜, ㈜케이티, LG유플러스㈜)로부터 위탁 받아 제공하는 휴대폰본인확인서비스 이용과 관련하여 본인의 개인정보를 수집·이용 및 제공하고자 하는 경우에는 「개인정보보호법」 제15조, 제22조, 제24조, 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」 제22조에 따라 본인의 동의를 얻어야 합니다. 이에 본인은 귀사가 아래와 같이 본인의 개인정보를 수집 · 이용 및 제공 하는데 동의합니다.</p>
								<dl>
									<dt>□ 개인정보의 수집 및 이용목적</dt>
									<dd>
										<ol>
											<li>
												① 주민등록번호 대체서비스 제공<br>
												개인정보보호법 제24조 2항에 의해 온라인 또는 오프라인상에서 회원가입, 글쓰기, 포인트적립 등 주민등록번호를 사용하지 않고도 본인임을 확인할 수 있는 개인정보보호 서비스(휴대폰본인확인서비스) 제공
											</li>
											<li>② 에스케이텔레콤(주), (주)케이티, LG유플러스(주) 등 통신사에 이용자 정보를 전송하여 본인확인 및 휴대폰 정보의 일치 여부 확인</li>
											<li>③ 휴대폰 사용자 확인을 위한 SMS(또는 LMS) 인증번호 전송</li>
											<li>④ 부정 이용 방지 및 수사의뢰</li>
											<li>⑤ 이용자 본인 요청에 의한 본인확인 이력정보 제공, 민원처리, 추후 분쟁조정을 위한 기록보존, 고지사항 전달 등</li>
											<li>⑥ 휴대폰번호보호서비스 가입여부 확인(서비스 가입자에 한함)</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>□ 수집할 개인정보</dt>
									<dd>
										<ol>
											<li>① 이용자가 가입한 이동통신사, 휴대폰번호, 성명, 성별, 생년월일, 내/외국인 구분</li>
											<li>② 중복가입확인정보(발급자의 웹사이트 중복가입 여부를 확인할 수 있는 정보)</li>
											<li>③ 연계정보(온/오프라인 사업자간 제휴 등 연계서비스가 가능하도록 특정 개인을 식별할 수 있는 정보)</li>
											<li>④ 인증처 및 사이트 URL</li>
											<li>⑤ 인증일시</li>
											<li>⑥ IP주소</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>□ 개인정보의 제공</dt>
									<dd>
										<ol>
											<li>
												① 휴대폰본인확인서비스 제공
												<ul>
													<li>- 제공 받는자: SK텔레콤(주), (주)케이티, ㈜엘지유플러스</li>
													<li>- 제공 목적: 업무대행(본인확인정보 및 연계정보 전송 및 서비스 관련 업무 상담 및 불만처리 등)</li>
													<li>- 제공 항목: 생년월일, 성명, 성별, 내/외국인 구분, 휴대폰번호, 이동통신사</li>
													<li>- 보유 기간: “제공받는 자”의 이용목적 달성 시 까지 보관하며, 세부사항은 각 사업자의 개인정보처리방침을 따름</li>
												</ul>
											</li>
											<li>
												② 휴대폰본인확인서비스 문자발송
												<ul>
													<li>- 제공 받는자: SK텔레콤(주), (주)케이티, ㈜엘지유플러스</li>
													<li>- 제공 목적: 휴대폰본인확인서비스 점유확인을 위한 문자발송</li>
													<li>- 제공 항목: 휴대폰번호</li>
													<li>- 보유 기간: “제공받는 자”의 이용목적 달성 시 까지 보관하며, 세부사항은 각 사업자의 개인정보처리방침을 따름</li>
												</ul>
											</li>
											<li>
												③ 휴대폰본인확인서비스 제공 (서비스 이용 사업자)
												<ul>
													<li>- 제공 받는자: 휴대폰본인확인서비스 이용 회사(코리아크레딧뷰로㈜(이하 “회사”)와 계약된 사업자)</li>
													<li>- 제공 목적: 휴대폰본인확인서비스 제공</li>
													<li>- 제공 항목: 생년월일, 성명, 성별, 내/외국인 구분, 휴대폰번호, 이동통신사, IP주소, 중복가입확인정보(DI), 연계정보(CI)</li>
													<li>- 보유 기간: “회사”와 계약한 사업자의 이용목적 달성시 까지 보관하며, 세부사항은 각 사업자의 개인정보처리방침을 따름</li>
												</ul>
											</li>
											<li>
												④ 휴대폰인증보호서비스 안내(광고성정보 수신동의 선택 시)
												<ul>
													<li>- 제공 받는자: ㈜민앤지, ㈜한국인증플랫폼즈</li>
													<li>- 제공 목적: 휴대폰인증보호서비스(휴대폰번호도용방지서비스) 안내</li>
													<li>- 제공 항목: 휴대폰번호, 통신</li>
													<li>- 보유 기간: 목적달성 후 폐기(동의 철회 시)</li>
												</ul>
											</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>□ 개인정보의 보유 및 이용기간</dt>
									<dd>
										<p class="pFirstNext">개인정보는 원칙적으로 개인정보의 수집목적 또는 제공받은 목적이 소멸되면 파기됩니다. 단, “개인정보보호법”, “정보통신망 이용 촉진 및 정보보호 등에 관한 법률”, “신용정보의 이용 및 보호에 관한 법률”, ” 본인확인기관 지정 및 관리에 관한 지침”, ”방송통신위원회 고시” 등 기타 관련법령의 규정에 의하여 법률관계의 확인 등을 이유로 특정한 기간 동안 보유하여야 할 필요가 있을 경우에는 아래에 정한 기간 동안 보유합니다.</p>
										<ol>
											<li>
												① 방송통신위원회 정기점검 이행조치 및 회사내부 방침에 의한 정보보유 사유로 본인확인 이력보관<br>
												-부정이용 방지 및 민원처리 : 1년 이내
											</li>
											<li>
												② 관계법령에 의한 정보보호 사유<br>
												-소비자의 불만 또는 분쟁처리에 관한 기록 : 3년
											</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>□ 동의거부권리 및 거부에 따른 불이익 내용</dt>
									<dd>
										<p class="pFirst">개인정보 수집·이용 및 제공 에 따른 동의는 거부할 수 있으며, 동의 후에도 언제든지 철회 가능합니다. 다만, 동의 거부 시에는 서비스 이용이 제한될 수 있습니다.</p>
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