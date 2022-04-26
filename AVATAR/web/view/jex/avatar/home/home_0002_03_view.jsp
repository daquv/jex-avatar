<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="jex.web.util.WebCommonUtil"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.util.date.DateTime"%>
<%
	// 공통 Util생성
	WebCommonUtil util = WebCommonUtil.getInstace(request, response);

	// Action 결과 추출
	String _CURR_DATETIME = DateTime.getInstance().getDate("yyyymmddhh24miss");
%>
<%
	/**
	 * <pre>
	 * (__SHARP__)
	 * JEXSTUDIO PROJECT
	 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
	 *
	 * @File Name        : home_0002_03_view.jsp
	 * @File path        : AVATAR/web/view/jex/avatar/home
	 * @author           : 김별 (  )
	 * @Description      : 
	 * @History          : 20210511103625, 김별
	 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/home/home_0002_03.js
	 * @JavaScript Url   : /js/jex/avatar/home/home_0002_03.js
	 * </pre>
	 **/
%>
<!DOCTYPE html>
<html lang="ko" class="leaf">
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
<title>ask avatar</title>
<meta http-equiv="Cache-Control" content="No-Cache">
<meta http-equiv="Pragma" content="No-Cache">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="title" content="에스크아바타| AI 경영비서">
<meta name="description"
	content="우리회사, 우리가게 경영관리는 음성인식 AI비서 아바타와 함께! 검색하지 말고 아바타에게 물어보세요.">
<meta name="keywords"
	content="에스크아바타, ASKAVATAR, 애스크아바타, askavatar, 다큐브, AI, 경리프로그램, 세무관리, 매입매출, 음성비서, 가게매출, AI플랫폼, 사장님비서, AI 경영비서">
<!-- The Open Graph protocol -->
<meta property="og:type" content="website">
<meta property="og:title" content="에스크아바타는 당신만의 AI경영비서입니다.">
<meta property="og:description" content="매일 보는 경영정보, 아바타에게 물어보세요.">
<meta property="og:url"
	content="https://m.askavatar.ai/home_0002_03.act">
<meta property="og:image"
	content="https://m.askavatar.ai/home/img/og_image.png">
<!-- [D]리얼경로로 변경하세요 -->
<meta name="naver-site-verification"
	content="af5eefb31c811f5854a8cacfcc7cf83880a48cd4" />
<!-- //The Open Graph protocol -->
<link rel="SHORTCUT ICON"
	href="https://m.askavatar.ai/home/img/16x16-C.ico">
<!-- [D]리얼경로로 변경하세요 -->
<link rel="stylesheet" type="text/css"
	href="../home/css/jquery.mCustomScrollbar.css">
<link rel="stylesheet" type="text/css" href="../home/css/swipper.css">
<link rel="stylesheet" type="text/css"
	href="../home/css/avatar.css?<%=_CURR_DATETIME%>">
</script>
<script type="text/javascript" src="../home/js/jquery-1.8.3.min.js"></script>
<script type="text/javascript"
	src="../home/js/jquery.mCustomScrollbar.concat.min.js"></script>
<script type="text/javascript" src="../home/js/swiper-bundle.min.js"></script>
<script type="text/javascript"
	src="../home/js/publishing.ui.library.1.0.0.js"></script>
<script type="text/javascript" src="../home/js/cmd.js"></script>
<script type="text/javascript"
	src="/js/jex/avatar/home/home_0002_03.js?<%=_CURR_DATETIME%>"></script>
<!-- Naver Log Analysis Script -->
<%@include file="/view/jex/avatar/include/naver_log_analysis.jsp"%>	
</head>


<body class="">
	<!-- add this class dimShow when dim layer show -->
	<!-- [D]약관보기 할 경우 overflow:hidden; -->

	<!-- wrap -->
	<div class="wrap idx">
		<!-- header -->
		<div class="header idx fixed">
			<div class="header_inn">
				<div class="left">
					<a href="#" class="bt_menu"><span class="blind">전체메뉴</span></a>
					<div class="logo">
						<h1>
							<a href="#none"><span class="blind">ASK AVATAR</span></a>
						</h1>
					</div>
				</div>
				<div class="right">
					<a
						href="https://play.google.com/store/apps/details?id=com.webcash.avatar"
						target="_blank" class="bt_playStore" onclick="javascript:logAnalysis();"><span class="blind">Play
							Store</span></a> <a href="https://apps.apple.com/app/id1562976203"
						target="_blank" class="bt_appStore" onclick="javascript:logAnalysis();"><span class="blind">App
							Store</span></a>
				</div>
			</div>
		</div>
		<!-- //header -->

		<!-- gnb menu -->
		<div class="gnbMenu_wrap" style="display: none;">
			<div class="menu_dimm"></div>
			<div class="gnbMenu">
				<div class="logo">
					<h1>
						<a href="#none"><span class="blind">ASK AVATAR</span></a>
					</h1>
				</div>
				<div class="depthOne">
					<a href="/home_0002_01.act" class="depthOneNode noSub"><h3>
							<strong>ask avatar</strong> (아바타)는?
						</h3></a>
					<!-- [D]선택일 경우 class="on" -->
				</div>
				<div class="depthOne">
					<a href="#none" class="depthOneNode depthOneNode_click"><h3>
							<strong>avatar</strong> 연결 데이터
						</h3></a>
					<div class="depthTwo">
						<ul>
							<li><a href="/home_0002_02.act#sect1" class="depthTwoNode">은행</a>
							</li>
							<li><a href="/home_0002_02.act#sect2" class="depthTwoNode">홈택스</a>
							</li>
							<li><a href="/home_0002_02.act#sect5" class="depthTwoNode">여신금융협회</a>
							</li>
							<li><a href="/home_0002_02.act#sect4" class="depthTwoNode">카드사</a>
							</li>
							<li><a href="/home_0002_02.act#sect6" class="depthTwoNode">온라인매출</a>
							</li>
							<li><a href="/home_0002_02.act#sect8" class="depthTwoNode">거래처</a>
							</li>
							<li><a href="#" class="depthTwoNode">제로페이(준비중)</a>
							</li>
							<li><a href="/home_0002_02.act#sect10" class="depthTwoNode">경리나라</a>
							</li>
						</ul>
					</div>
				</div>
				<div class="depthOne">
					<a href="/home_0002_03.act" class="depthOneNode noSub"><h3>
							<strong>avatar</strong> 제휴
						</h3></a>
				</div>
			</div>
		</div>
		<!-- //gnb menu -->

		<hr>

		<!-- container -->
		<div class="container sub">
			<!-- content -->
			<div class="content">
				<!-- sect -->
				<div class="sect top_sect">
					<div class="sect_inn">
						<div class="mv_sub_tit2">
							<h5>아바타와 제휴하면</h5>
						</div>
						<div class="affAvatar_grp">
							<div class="icon ic01"></div>
							<div class="tit">
								<h3>
									귀 사의 서비스는<br> 음성인식 AI경영비서 APP이 됩니다.
								</h3>
							</div>
							<div class="dsc">
								<p>
									귀 사의 서비스는 Text를 입력하는<br> 스마트폰 인터페이스를 제공하셨습니까?<br> 이제
									음성인식 기반의 Voice &amp; Touch<br> 인터페이스를 고객에게 제공해보세요.
								</p>
							</div>
						</div>
						<div class="affAvatar_grp">
							<div class="icon ic02"></div>
							<div class="tit">
								<h3>
									귀 사의 서비스는<br> 종합경영서비스가 됩니다.
								</h3>
							</div>
							<div class="dsc">
								<p>
									귀 사의 서비스에<br> 종합경영서비스를 더해보세요.<br> 고객에게 아바타가 학습한 경영정보를<br>
									함께 제공할 수 있습니다.
								</p>
							</div>
						</div>
					</div>
				</div>
				<!-- //sect -->

				<hr>

				<!-- sect -->
				<div class="sect">
					<div class="sect_inn">
						<div class="mfrm_wrap">
							<div class="tit">
								<h4>협력문의</h4>
							</div>
							<div class="mfrmIpt">
								<div class="mfrm_grp">
									<label for="" id="" class="point">회사(기관)명</label> <input
										type="text" id="RQST_BSNN_NM" placeholder="정식 명칭으로 입력하세요."
										value="" maxlength="100">
								</div>
								<div class="mfrm_grp">
									<label for="" id="" class="point">사업자번호</label> <input
										type="tel" id="RQST_BIZ_NO" onKeyup="inputCorpNum(this);"
										maxlength="12" placeholder="사업자번호를 입력하세요" value="">
								</div>
								<div class="mfrm_grp">
									<label for="" id="" class="point">이름</label> <input type="text"
										id="RQST_CUST_NM" placeholder="이름을 입력하세요" maxlength="100"
										value="">
								</div>
								<div class="mfrm_grp">
									<label for="" id="" class="point">연락처</label> <input type="tel"
										id="RQST_CLPH_NO" onKeyup="inputPhoneNumber(this);"
										maxlength="13" placeholder="연락처를 입력하세요" value="">
								</div>
								<div class="mfrm_grp">
									<label for="" id="">이메일</label> <input type="text"
										id="RQST_EML" placeholder="이메일을 입력하세요" maxlength="50" value="">
								</div>
								<div class="mfrm_grp">
									<label for="" id="">내용</label>
									<textarea name="" id="RQST_CTT" cols="30" rows="10"
										placeholder="100자 이내" maxlength="100"></textarea>
								</div>
								<div class="magr_grp">
									<div class="agr_head">
										<input type="radio" name="agrm_chk" id="agrm_chk"><i></i>
										<label for="" class="point">개인정보 수집 및 이용에 동의합니다.</label> <a
											href="#none" class="js_click"></a>
									</div>
									<div class="magr_layer">
										<p>다큐브 주식회사는 아래의 목적으로 개인정보를 수집 및 이용하며, 회원의 개인정보를 안전하게
											취급하는데 최선을 다하고 있습니다.</p>
										<ol>
											<li>1. 목적: 제휴 제안에 따른 연락처 정보 확인</li>
											<li>2. 항목: 회사(기관)명, 사업자번호, 이름 ,연락처</li>
											<li>3. 보유기간: 제휴 제안 사항 상담서비스를 위해 검토 완료 후 3개월 간 보관하며, 이후
												해당 정보를 지체 없이 파기합니다.</li>
										</ol>
										<p>위 정보 수집에 대한 동의를 거부할 권리가 있으며, 동의 거부 시에는 제휴 제안 접수가 제한될 수
											있습니다. 더 자세한 내용에 대해서는 [개인정보처리방침]을 참고하시길 바랍니다.</p>
									</div>
								</div>
							</div>
							<div class="tac">
								<a href="#none" class="bt_b1">문의하기</a>
							</div>
						</div>
					</div>
				</div>
				<!-- //sect -->
			</div>
			<!-- //content -->
		</div>
		<!-- //container -->

		<hr>

		<!-- footer -->
		<div class="footer">
			<div class="footer_inn">
				<div class="social">
					<ul>
						<li><a
							href="https://www.youtube.com/channel/UCxZzQUdbwkFQoIX3tpSsk-g"
							target="_blank" class="sc_yt"><span class="blind">youtube</span></a></li>
						<li><a href="https://blog.naver.com/askavatar"
							target="_blank" class="sc_blog"><span class="blind">blog</span></a></li>
						<li><a href="https://www.facebook.com/ASKAVATAR/"
							target="_blank" class="sc_fb"><span class="blind">facebook</span></a></li>
						<li><a href="https://www.instagram.com/askavatar/"
							target="_blank" class="sc_inst"><span class="blind">instagram</span></a></li>
					</ul>
				</div>
				<div class="addr">
					<h5>다큐브(주)</h5>
					<div class="footer_menu">
						<ul>
							<li><a href="javascript:void(0)">약관동의</a></li>
							<li><a href="javascript:void(0)">개인정보처리방침</a></li>
						</ul>
					</div>
					<p>
						<span>서울시 영등포구 여의나루로 67 신송빌딩 12층</span>
						 <span>대표이사 진주영</span> 
						 <span>사업자등록번호 763-87-02018</span>
						 <span>통신판매신고 2021-서울영등포-3040</span>
						  <span>Copyrightⓒ 2021 DAQUV. All rights
							reserved.</span>
					</p>
				</div>
			</div>
		</div>
		<!-- //footer -->

		<!-- (button)gotoTop -->
		<div class="btn_totop_wrap">
			<a href="#none" class="btn_gotoTop"><span class="blind">go
					to Top</span></a>
		</div>
		<!-- //(button)gotoTop -->

		<!-- content -->
		<div class="content termFixed" style="display: none;">
			<div class="popLayer">
				<div class="popLayer_dim"></div>
				<div class="popLayer_inner">
					<div class="popLayer_title">
						<h3 class="tit">개인정보처리방침</h3>
						<a href="#none" class="btn_close"><img
							src="../home/img/btn_popLayer_close.png" alt="Close"></a>
					</div>
					<!-- -->
					<div class="popLayer_body" id="term_now">
						<div class="popLayer_content">
							<div>
								<h3 class="popTitle_first" id="TOP">ASK AVATAR 개인정보 수집 및 이용
									동의</h3>
								<div class="servTerm">
									<p class="pFirst">다큐브㈜(이하 “회사”)는 정보통신망 이용촉진 및 정보보호 등에 관한
										법률(이하 “정보통신망법”), 개인정보보호법, 통신비밀보호법, 전기통신사업법 등 정보통신서비스제공자가 준수하여야
										할 관련 법령상의 개인정보보호 규정을 준수하며, 관련 법령에 의거한 개인정보처리방침을 정하여 ASK AVATAR
										(이하 “AVATAR”)의 서비스 이용자(이하 “회원”) 개인정보의 보호와 권익 보호에 최선을 다하고 있습니다.</p>
									<p>본 개인정보처리방침은 “회사”에서 제공하는 AVATAR 서비스(이하 “서비스”)에 적용되며 다음과
										같은 내용을 담고 있습니다.</p>
									<dl>
										<dt>1. 수집하는 개인정보의 항목 및 수집방법</dt>
										<dd>
											<ol>
												<li>① 수집하는 개인정보의 항목<br> 회사는 회원가입, 고객상담, 서비스 신청,
													서비스 이용 등을 위해 아래와 같은 개인정보를 수집하고 있습니다.
													<ul>
														<li>가. 수집 항목
															<div class="servTerm_tbl">
																<table summary="">
																	<caption></caption>
																	<colgroup>
																		<col style="width: 25%;">
																		<col>
																		<col style="width: 25%;">
																	</colgroup>
																	<thead>
																		<tr>
																			<th><div>수집/이용 목적</div></th>
																			<th><div>개인정보 항목(필수 동의 항목)</div></th>
																			<th><div>필수수집여부</div></th>
																		</tr>
																	</thead>
																	<tbody>
																		<tr>
																			<th><div>회원가입</div></th>
																			<td><div>이름, 생년월일, 휴대폰번호, 기기식별번호(디바이스 아이디
																					또는 IMEI)</div></td>
																			<th><div>필수사항</div></th>
																		</tr>
																		<tr>
																			<th><div>계좌 거래내역 조회 서비스</div></th>
																			<td><div>공동인증서(은행용 또는 범용인증정보) 및 비밀번호,
																					계좌번호, 거래정보 등</div></td>
																			<th><div>필수사항</div></th>
																		</tr>
																		<tr>
																			<th><div>카드매출 조회 서비스</div></th>
																			<td><div>여신금융협회 ID 및 비밀번호, 카드매출정보, 매출입금정보
																					등</div></td>
																			<th><div>필수사항</div></th>
																		</tr>
																		<tr>
																			<th><div>카드정보 조회 서비스</div></th>
																			<td><div>카드번호, 카드사 공동인증서 및 비밀번호, 카드사 ID 및
																					비밀번호, 결제일, 사용내역, 청구내역, 한도내역 등</div></td>
																			<th><div>필수사항</div></th>
																		</tr>
																		<tr>
																			<th><div>매출/매입정보 및 거래처정보 조회 서비스</div></th>
																			<td><div>국세청 공동인증서 및 비밀번호, 매입/매출 세금계산서,
																					현금영수증 내역, 세금 내역, 거래처명, 거래처 주소, 거래처 대표자명, 거래처 사업자번호
																					등</div></td>
																			<th><div>필수사항</div></th>
																		</tr>
																		<tr>
																			<th><div>경리나라 정보 조회 서비스</div></th>
																			<td>
																				<div>
																					1. 회원가입을 위한 수집 정보<br> : 아이디(ID), 고객관리번호, 사업자정보
																					(사업자등록번호, 사업장명, 대표자명, 업태, 업종, 우편번호, 주소, 상세주소, 대표
																					전화번호)<br> <br> 2. 서비스 이용을 위한 정보 조회<br>
																					: 거래처 정보, 거래처 미수/미지급내역, 매출/매입 증빙자료, 급여자료, 계좌 입/출내역,
																					수납/지급내역, 이체내역, 어음내역 등
																				</div>
																			</td>
																			<th><div>필수사항</div></th>
																		</tr>
																		<tr>
																			<th><div>온라인 매출 조회 서비스</div></th>
																			<td><div>배달앱 ID 및 비밀번호(배달의민족, 요기요, 쿠팡이츠),
																					매출내역, 정산내역</div></td>
																			<th><div>필수사항</div></th>
																		</tr>
																	</tbody>
																</table>
															</div>
														</li>
														<li>ㅇ 서비스 이용 및 업무 처리 과정에서 아래와 같은 정보들이 입력 또는 생성되어 수집될
															수 있습니다.<br> - 신규 서비스 계정 정보 및 요청 내역, 서비스 이용기록,
															조회/알림서비스 설정 정보, 접속로그, 접속IP정보, 쿠키 정보, 불량이용기록 등
														</li>
														<li>나. 개인정보 수집방법</li>
														<li>ㅇ 회사는 다음과 같은 방법으로 개인정보를 수집합니다.<br> - 서비스 실행
															또는 사용함으로써 자동으로 수집<br> - 서비스 가입이나 이용 중 회원의 자발적 제공을 통한
															수집<br> - 협력회사로부터의 제공<br> - 홈페이지, 서면양식, 팩스, 전화,
															상담게시판, 이메일, 이벤트 응모 등을 통한 수집
														</li>
													</ul>
												</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>2. 개인정보의 수집 및 이용 목적</dt>
										<dd>
											<ol>
												<li>① 회원 관리<br> - 서비스 이용에 대한 본인확인, 개인식별, 불량회원의 부정
													이용방지와 비인가 사용방지, 가입의사 확인, 분쟁 조정을 위한 기록보존, 불만처리 등 민원처리, 고지사항
													전달, 회원탈퇴 의사의 확인
												</li>
												<li>② 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산<br> - 컨텐츠
													제공, 특정 맞춤 서비스 제공, 청구서 등 발송, 본인인증, 요금 결제, 요금추심
												</li>
												<li>③ 신규 서비스 개발 및 서비스 통계ㆍ마케팅ㆍ광고 활용<br> - 신규 서비스 개발
													및 맞춤 서비스 제공, 통계학적 특성에 따른 서비스 제공, 서비스의 유효성 확인, 이벤트 및 참여기회
													제공, 접속빈도 파악, 회원의 서비스 이용에 대한 통계
												</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>3. 개인정보의 공유 및 제공</dt>
										<dd>
											<p class="pFirstNext">회사는 회원들의 개인정보를 “2. 개인정보의 수집 및 이용
												목적”에서 고지한 범위 내에서 사용하며, 회원의 사전 동의 없이는 동 범위를 초과하여 이용하거나 원칙적으로
												회원의 개인정보를 외부에 공개하지 않습니다. 다만, 아래의 경우에는 예외로 합니다.</p>
											<ol>
												<li>① 회원들이 사전에 동의한 경우</li>
												<li>② 서비스의 제공에 관한 계약의 이행을 위하여 필요한 개인정보로서 경제적/기술적인 사유로
													통상의 동의를 받는 것이 현저히 곤란한 경우</li>
												<li>③ 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의
													요구가 있는 경우</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>4. 개인정보 처리의 위탁</dt>
										<dd>
											<p class="pFirst">회사는 위탁계약 체결 시 『개인정보보호법』 제 26 조 에 따라
												위탁업무 수행목적 외 개인정보 처리금지, 기술적/관리적 보호조치, 수탁자에 대한 관리/감독, 손해배상 등
												책임에 관한 사항을 계약서 등 문서에 명시하고, 수탁자가 개인정보를 안전하게 처리하는지를 감독하고 있습니다.
												위탁업무의 내용이나 수탁자가 변경될 경우에는 지체 없이 본 개인정보 처리방침을 통하여 공개하도록 하겠습니다.</p>
											<p>회사의 개인정보 처리 위탁기관 및 위탁업무 내용은 아래와 같습니다.</p>
											<div class="servTerm_tbl">
												<table summary="">
													<caption></caption>
													<colgroup>
														<col>
														<col>
														<col style="width: 30%;">
													</colgroup>
													<thead>
														<tr>
															<th><div>수탁사</div></th>
															<th><div>위탁업무</div></th>
															<th><div>개인정보 보유 및 이용기간</div></th>
														</tr>
													</thead>
													<tbody>
														<tr>
															<th><div>(주)쿠콘</div></th>
															<td><div class="tac">전산설비의 운영, 정보 스크래핑</div></td>
															<td rowspan="4"><div class="tac">회원 탈퇴시 혹은 위탁
																	계약 종료시까지</div></td>
														</tr>
														<tr>
															<th><div>웹케시㈜</div></th>
															<td><div class="tac">AVATAR서비스의 개발 및 운영</div></td>
														</tr>
														<tr>
															<th><div>웹케시씨앤에스㈜</div></th>
															<td><div class="tac">고객 상담, 불만 처리</div></td>
														</tr>
														<tr>
															<th><div>금융결제원</div></th>
															<td><div class="tac">금융결제원 자동이체</div></td>
														</tr>
													</tbody>
												</table>
											</div>
										</dd>
									</dl>
									<dl>
										<dt>5. 개인정보의 제 3자 제공 동의 안내</dt>
										<dd>
											<p class="pFirst">서비스 이용에 따른 본인확인 및 개인식별, 컨텐츠 제공, 회원의
												불만처리 등의 서비스 이용에 필요한 목적을 위해 회원의 개인정보에 대해서 제 3자에게 제공되고 있습니다. 이
												경우 별도로 이용자의 동의 여부를 확인한 후 제공하고 있으며, 별도로 고지된 개인정보의 이용 목적, 제공
												개인정보 항목, 이용 기간 내에서만 이용됩니다.</p>
										</dd>
									</dl>
									<dl>
										<dt>6. 개인정보의 보유 및 이용기간</dt>
										<dd>
											<p class="pFirstNext">회원의 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이
												달성되면 지체 없이 파기합니다. 단, 상법, 전자상거래 등에서의 소비자보호에 관한 법률 등 관계법령의 규정에
												의하여 보존할 필요가 있는 경우 회사는 관계법령에서 정한 일정한 기간 동안 회원정보를 보관합니다. 이 경우
												회사는 보관하는 정보를 그 보관의 목적으로만 이용하며 보존기간은 아래와 같습니다.</p>
											<ul class="inDepth">
												<li>- 계약 또는 청약철회 등에 관한 기록<br> 보존 이유 : 전자상거래 등에서의
													소비자보호에 관한 법률<br> 보존 기간 : 5년
												</li>
												<li>- 대금결제 및 재화 등의 공급에 관한 기록<br> 보존 이유 : 전자상거래
													등에서의 소비자보호에 관한 법률<br> 보존 기간 : 5년
												</li>
												<li>- 소비자의 불만 또는 분쟁처리에 관한 기록<br> 보존 이유 : 전자상거래
													등에서의 소비자보호에 관한 법률<br> 보존 기간 : 3년
												</li>
												<li>- 방문에 관한 기록<br> 보존 이유 : 통신비밀보호법<br> 보존 기간
													: 3개월
												</li>
											</ul>
										</dd>
									</dl>
									<dl>
										<dt>7. 개인정보 파기절차 및 방법</dt>
										<dd>
											<p class="pFirstNext">회원의 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이
												달성되면 지체 없이 파기합니다. 회사의 개인정보 파기절차 및 방법은 다음과 같습니다.</p>
											<ol>
												<li>① 파기절차<br> - 회원이 회원가입 등을 위해 입력한 정보는 목적이 달성된 후
													별도의 DB로 옮겨져 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간
													참조)일정 기간 저장된 후 파기됩니다.<br> - 동 개인정보는 법률에 의한 경우가 아니고서는
													보유되는 이유 이외의 다른 목적으로 이용되지 않습니다.
												</li>
												<li>② 파기방법<br> - 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여
													파기합니다.<br> - 전자적 파일 형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을
													사용하여 삭제합니다.
												</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>8. 회원 및 법정대리인의 권리와 그 행사방법</dt>
										<dd>
											<ol>
												<li>① 회원 및 법정대리인은 언제든지 등록되어 있는 자신의 개인정보를 조회하거나 수정할 수
													있으며 가입해지를 요청할 수도 있습니다.</li>
												<li>② 회원의 개인정보 조회/수정을 위해서는 '개인정보변경(또는 '회원정보수정'등)을,
													가입해지(동의철회)를 위해서는 "회원탈퇴"를 통해 직접 열람, 정정 및 탈퇴가 가능합니다.</li>
												<li>③ 개인정보관리책임자에게 서면, 전화 또는 이메일로 연락하시면 지체 없이 조치하겠습니다.</li>
												<li>④ 회원이 개인정보의 오류에 대한 정정을 요청하신 경우에는 정정을 완료하기 전까지 개인정보를
													이용 또는 제공하지 않습니다. 또한 잘못된 개인정보를 제3자에게 이미 제공한 경우에는 정정 처리결과를
													제3자에게 지체 없이 통지하여 정정이 이루어지도록 하겠습니다.</li>
												<li>⑤ 회사는 회원 혹은 법정 대리인의 요청에 의해 해지 또는 삭제된 개인정보는 "6.
													개인정보의 보유 및 이용기간"에 명시된 바에 따라 처리하고 그 외의 용도로 열람 또는 이용할 수 없도록
													처리하고 있습니다.</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>9. 개인정보 자동 수집장치의 설치/운영 및 거부에 관한 사항</dt>
										<dd>
											<p class="pFirst">회사는 개인정보를 생성하기 위해 회원이 서비스 실행 시
												기기식별번호(디바이스 아이디 또는 IMEI)를 자동으로 수집하게 됩니다. 회원이 기기식별번호를 자동으로
												수집하는 것을 거부하는 경우 서비스를 이용할 수 없습니다.</p>
										</dd>
									</dl>
									<dl>
										<dt>10. 개인정보의 안정성 확보 조치</dt>
										<dd>
											<p class="pFirst">회사는 「정보통신망법」 제28조, 「개인정보보호법」 제29조에 의거하여
												회원의 개인정보를 처리함에 있어 개인정보가 분실, 도난, 누출, 변조 또는 훼손되지 않도록 안전성 확보를
												위하여 다음과 같은 기술적/관리적/물리적 대책을 강구하고 있습니다.</p>
											<ol>
												<li>① 내부관리계획의 수립 및 시행<br> 회사는 ‘개인정보의 안전성 확보조치 기준’에
													의거하여 내부관리계획을 수립, 시행합니다.
												</li>
												<li>② 개인정보처리자 지정의 최소화 및 교육<br> 개인정보처리자의 지정을 최소화하고
													정기적인 교육을 시행하고 있습니다.
												</li>
												<li>③ 개인정보에 대한 접근 제한<br> 개인정보를 처리하는 데이터베이스시스템에 대한
													접근권한의 부여, 변경, 말소를 통하여 개인정보에 대한 접근을 통제하고, 침입차단시스템과 침입방지시스템을
													이용하여 외부로부터의 무단 접근을 통제하고 있으며, 권한 부여, 변경 또는 말소에 대한 내역을 기록하고,
													그 기록을 최소 3년간 보관하고 있습니다.
												</li>
												<li>④ 접속기록의 보관 및 위변조 방지<br> 개인정보처리시스템에 접속한 기록을 보관
													관리하고 있으며, 접속 기록이 위변조 및 도난, 분실되지 않도록 관리하고 있습니다.
												</li>
												<li>⑤ 개인정보의 암호화<br> 회원의 개인정보는 암호화 되어 저장 및 관리되고
													있습니다. 또한 중요한 데이터는 저장 및 전송 시 암호화하여 사용하는 등의 별도 보안기능을 사용하고
													있습니다.
												</li>
												<li>⑥ 해킹 등에 대비한 기술적 대책<br> 회사는 해킹이나 컴퓨터 바이러스 등에 의한
													개인정보 유출 및 훼손을 막기 위하여 보안프로그램을 설치하고 주기적인 갱신ㆍ점검을 하며 외부로부터 접근이
													통제된 구역에 시스템을 설치하고 기술적, 물리적으로 감시 및 차단하고 있습니다.
												</li>
												<li>⑦ 비인가자에 대한 출입 통제<br> 개인정보를 보관하고 있는 개인정보시스템의
													물리적 보관 장소를 별도로 두고 이에 대해 출입통제 절차를 수립, 운영하고 있습니다.
												</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>11. 개인정보보호책임자 및 담당자</dt>
										<dd>
											<p class="pFirst">회사는 개인정보를 보호하고 개인정보와 관련된 사항을 처리하기 위하여
												아래와 같이 개인정보 보호책임자와 실무담당자를 지정하고 있습니다. 회사는 회원의 개인정보와 관련된 민원 및
												고충사항에 대하여 신속하게 처리하겠습니다.</p>
											<div class="servTerm_tbl">
												<table summary="">
													<caption></caption>
													<colgroup>
														<col style="width: 70px;">
														<col>
														<col style="width: 70px;">
														<col>
													</colgroup>
													<thead>
														<tr>
															<th colspan="2"><div>개인정보 관리책임자</div></th>
															<th colspan="2"><div>개인정보 보호담당자</div></th>
														</tr>
													</thead>
													<tbody>
														<tr>
															<th><div>성명</div></th>
															<td><div>박정은</div></td>
															<th><div>성명</div></th>
															<td><div>김선영</div></td>
														</tr>
														<tr>
															<th><div>담당부서</div></th>
															<td><div>AVATAR TEAM</div></td>
															<th><div>담당부서</div></th>
															<td><div>AVATAR TEAM</div></td>
														</tr>
														<tr>
															<th><div>전화</div></th>
															<td><div>02-889-8422</div></td>
															<th><div>전화</div></th>
															<td><div>02-889-8423</div></td>
														</tr>
														<tr>
															<th><div>이메일</div></th>
															<td><div>pje@askavatar.ai</div></td>
															<th><div>이메일</div></th>
															<td><div>sy@askavatar.ai</div></td>
														</tr>
													</tbody>
												</table>
											</div>
											<p class="pFirstNext mgt5">기타 개인정보침해에 대한 신고나 상담이 필요하신
												경우에는 아래 기관에 문의하시기 바랍니다.</p>
											<ul class="inDepth">
												<li>- 개인정보침해 신고센터<br> (privacy.kisa.or.kr/118)
												</li>
												<li>- 개인정보 분쟁조정위원회<br>
													(www.kopico.go.kr/1833-6972)
												</li>
												<li>- 정보보호마크인증위원회<br>
													(www.eprivacy.or.kr/02-550-9531~2)
												</li>
												<li>- 경찰청 사이버안전국<br> (cyber.go.kr/182)
												</li>
											</ul>
										</dd>
									</dl>
									<dl>
										<dt>12. 고지의 의무</dt>
										<dd>
											<p class="pFirst">현 개인정보처리방침의 내용 추가, 삭제 및 수정이 있을 시에는 시행일자
												최소 7일전부터 “서비스”내 공지사항 화면을 통해 공고할 것입니다.</p>
											<p>- 공고일자: 2021년 08월 19일</p>
											<p>- 시행일자: 2021년 08월 26일</p>
										</dd>
									</dl>
									<dl>
										<!--<dt></dt>-->
										<dd>
											<a href="#none" class="servTermGo">이전 개인정보처리방침 바로가기</a>
										</dd>
									</dl>
								</div>
							</div>
						</div>
					</div>
					<div class="popLayer_body" id="term_prev" style="display: none;">
						<div class="popLayer_content">
							<div>
								<h3 class="popTitle_first">ASK AVATAR 개인정보 수집 및 이용 동의</h3>
								<div class="servTerm">
									<p class="pFirst">다큐브㈜(이하 “회사”)는 정보통신망 이용촉진 및 정보보호 등에 관한
										법률(이하 “정보통신망법”), 개인정보보호법, 통신비밀보호법, 전기통신사업법 등 정보통신서비스제공자가 준수하여야
										할 관련 법령상의 개인정보보호 규정을 준수하며, 관련 법령에 의거한 개인정보처리방침을 정하여 ASK AVATAR
										(이하 “AVATAR”)의 서비스 이용자(이하 “회원”) 개인정보의 보호와 권익 보호에 최선을 다하고 있습니다.</p>
									<p>본 개인정보처리방침은 “회사”에서 제공하는 AVATAR 서비스(이하 “서비스”)에 적용되며 다음과
										같은 내용을 담고 있습니다.</p>
									<dl>
										<dt>1. 수집하는 개인정보의 항목 및 수집방법</dt>
										<dd>
											<ol>
												<li>① 수집하는 개인정보의 항목<br> 회사는 회원가입, 고객상담, 서비스 신청,
													서비스 이용 등을 위해 아래와 같은 개인정보를 수집하고 있습니다.
													<ul>
														<li>가. 수집 항목</li>
														<li>ㅇ 회원가입<br> - 이름, 생년월일, 휴대폰번호, 기기식별번호(디바이스
															아이디 또는 IMEI)
														</li>
														<li>ㅇ 계좌 거래내역 조회 서비스<br> - 필수사항 : 공동인증서(은행용 또는
															범용인증정보) 및 비밀번호, 계좌번호, 거래정보
														<li>ㅇ 카드매출 조회 서비스<br> - 필수사항 : 여신금융협회 ID 및 비밀번호,
															카드매출정보, 매출입금정보
														<li>ㅇ 카드정보 조회 서비스<br> - 필수사항 : 카드번호, 카드사 공동인증서 및
															비밀번호, 카드사 ID 및 비밀번호, 결제일, 사용내역, 청구내역, 한도내역 등
														<li>ㅇ 매출/매입정보 및 거래처정보 조회 서비스<br> - 필수사항 : 국세청
															공동인증서 및 비밀번호, 매입/매출 세금계산서, 현금영수증 내역, 거래처명, 거래처 주소, 거래처
															대표자명, 거래처 사업자번호 등
														<li>ㅇ 경리나라 정보 조회 서비스
															<div class="servTerm_tbl">
																<table summary="">
																	<caption></caption>
																	<colgroup>
																		<col style="width: 35%;">
																		<col>
																	</colgroup>
																	<thead>
																		<tr>
																			<th><div>수집/이용 목적</div></th>
																			<th><div>개인정보 항목(필수 동의 항목)</div></th>
																		</tr>
																	</thead>
																	<tbody>
																		<tr>
																			<th><div>회원가입을 위한 수집 정보</div></th>
																			<td><div>아이디(ID), 고객관리번호, 사업자정보(사업자등록번호,
																					사업장명, 대표자명, 업태, 업종, 우편번호, 주소, 상세주소, 대표 전화번호)</div></td>
																		</tr>
																		<tr>
																			<th><div>서비스 이용을 위한 정보 조회</div></th>
																			<td><div>거래처 정보, 거래처 미수/미지급내역, 매출/매입 증빙자료,
																					급여자료, 계좌 입/출내역, 수납/지급내역, 이체내역, 어음</div></td>
																		</tr>
																	</tbody>
																</table>
															</div>
														</li>
														<li>ㅇ 서비스 이용 및 업무 처리 과정에서 아래와 같은 정보들이 입력 또는 생성되어 수집될
															수 있습니다.<br> - 신규 서비스 계정 정보 및 요청 내역, 서비스 이용기록,
															조회/알림서비스 설정 정보, 접속로그, 접속IP정보, 쿠키 정보, 불량이용기록 등
														</li>
														<li>나. 개인정보 수집방법</li>
														<li>ㅇ 회사는 다음과 같은 방법으로 개인정보를 수집합니다.<br> - 서비스 실행
															또는 사용함으로써 자동으로 수집<br> - 서비스 가입이나 이용 중 회원의 자발적 제공을 통한
															수집<br> - 홈페이지, 서면양식, 팩스, 전화, 상담게시판, 이메일, 이벤트 응모 등을
															통한 수집
														</li>
													</ul>
												</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>2. 개인정보의 수집 및 이용목적</dt>
										<dd>
											<ol>
												<li>① 회원 관리<br> - 서비스 이용에 대한 본인확인, 개인식별, 불량회원의 부정
													이용방지와 비인가 사용방지, 가입의사 확인, 분쟁 조정을 위한 기록보존, 불만처리 등 민원처리, 고지사항
													전달, 회원탈퇴 의사의 확인
												</li>
												<li>② 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산<br> - 컨텐츠
													제공, 특정 맞춤 서비스 제공, 청구서 등 발송, 본인인증, 요금 결제, 요금추심
												</li>
												<li>③ 신규 서비스 개발 및 서비스 통계ㆍ마케팅ㆍ광고 활용<br> - 신규 서비스 개발
													및 맞춤 서비스 제공, 통계학적 특성에 따른 서비스 제공, 서비스의 유효성 확인, 이벤트 및 참여기회
													제공, 접속빈도 파악, 회원의 서비스 이용에 대한 통계
												</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>3. 개인정보의 공유 및 제공</dt>
										<dd>
											<p class="pFirstNext">회사는 회원들의 개인정보를 “2. 개인정보의 수집목적 및
												이용목적”에서 고지한 범위 내에서 사용하며, 회원의 사전 동의 없이는 동 범위를 초과하여 이용하거나
												원칙적으로 회원의 개인정보를 외부에 공개하지 않습니다. 다만, 아래의 경우에는 예외로 합니다.</p>
											<ol>
												<li>① 회원들이 사전에 동의한 경우</li>
												<li>② 서비스의 제공에 관한 계약의 이행을 위하여 필요한 개인정보로서 경제적/기술적인 사유로
													통상의 동의를 받는 것이 현저히 곤란한 경우</li>
												<li>③ 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의
													요구가 있는 경우</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>4. 개인정보 처리의 위탁</dt>
										<dd>
											<p class="pFirst">회사는 위탁계약 체결 시 『개인정보보호법』 제 26 조 에 따라
												위탁업무 수행목적 외 개인정보 처리금지, 기술적/관리적 보호조치, 수탁자에 대한 관리/감독, 손해배상 등
												책임에 관한 사항을 계약서 등 문서에 명시하고, 수탁자가 개인정보를 안전하게 처리하는지를 감독하고 있습니다.
												위탁업무의 내용이나 수탁자가 변경될 경우에는 지체 없이 본 개인정보 처리방침을 통하여 공개하도록 하겠습니다.</p>
											<p>회사의 개인정보 처리 위탁기관 및 위탁업무 내용은 아래와 같습니다.</p>
											<div class="servTerm_tbl">
												<table summary="">
													<caption></caption>
													<colgroup>
														<col>
														<col>
														<col style="width: 30%;">
													</colgroup>
													<thead>
														<tr>
															<th><div>수탁사</div></th>
															<th><div>위탁업무</div></th>
															<th><div>개인정보 보유 및 이용기간</div></th>
														</tr>
													</thead>
													<tbody>
														<tr>
															<th><div>(주)쿠콘</div></th>
															<td><div class="tac">전산설비의 운영, 정보 스크래핑</div></td>
															<td rowspan="5"><div class="tac">회원 탈퇴시 혹은 위탁
																	계약 종료시까지</div></td>
														</tr>
														<tr>
															<th><div>웹케시㈜</div></th>
															<td><div class="tac">AVATAR서비스의 개발 및 운영</div></td>
														</tr>
														<tr>
															<th><div>웹케시네트웍스(주)</div></th>
															<td><div class="tac">고객 상담, 불만 처리</div></td>
														</tr>
														<tr>
															<th><div>비즈플레이 주식회사</div></th>
															<td><div class="tac">푸시발송 서비스 이용</div></td>
														</tr>
														<tr>
															<th><div>금융결제원</div></th>
															<td><div class="tac">금융결제원 자동이체</div></td>
														</tr>
													</tbody>
												</table>
											</div>
										</dd>
									</dl>
									<dl>
										<dt>5. 개인정보의 제 3자 제공 동의 안내</dt>
										<dd>
											<p class="pFirst">서비스 이용에 따른 본인확인 및 개인식별, 컨텐츠 제공, 회원의
												불만처리 등의 서비스 이용에 필요한 목적을 위해 회원의 개인정보에 대해서 제 3자에게 제공되고 있습니다. 이
												경우 별도로 이용자의 동의 여부를 확인한 후 제공하고 있으며, 별도로 고지된 개인정보의 이용 목적, 제공
												개인정보 항목, 이용 기간 내에서만 이용됩니다.</p>
										</dd>
									</dl>
									<dl>
										<dt>6. 개인정보의 보유 및 이용기간</dt>
										<dd>
											<p class="pFirstNext">회원의 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이
												달성되면 지체 없이 파기합니다. 단, 상법, 전자상거래 등에서의 소비자보호에 관한 법률 등 관계법령의 규정에
												의하여 보존할 필요가 있는 경우 회사는 관계법령에서 정한 일정한 기간 동안 회원정보를 보관합니다. 이 경우
												회사는 보관하는 정보를 그 보관의 목적으로만 이용하며 보존기간은 아래와 같습니다.</p>
											<ul class="inDepth">
												<li>- 계약 또는 청약철회 등에 관한 기록<br> 보존 이유 : 전자상거래 등에서의
													소비자보호에 관한 법률<br> 보존 기간 : 5년
												</li>
												<li>- 대금결제 및 재화 등의 공급에 관한 기록<br> 보존 이유 : 전자상거래
													등에서의 소비자보호에 관한 법률<br> 보존 기간 : 5년
												</li>
												<li>- 소비자의 불만 또는 분쟁처리에 관한 기록<br> 보존 이유 : 전자상거래
													등에서의 소비자보호에 관한 법률<br> 보존 기간 : 3년
												</li>
												<li>- 방문에 관한 기록<br> 보존 이유 : 통신비밀보호법<br> 보존 기간
													: 3개월
												</li>
											</ul>
										</dd>
									</dl>
									<dl>
										<dt>7. 개인정보 파기절차 및 방법</dt>
										<dd>
											<p class="pFirstNext">회원의 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이
												달성되면 지체 없이 파기합니다. 회사의 개인정보 파기절차 및 방법은 다음과 같습니다.</p>
											<ol>
												<li>① 파기절차<br> - 회원이 회원가입 등을 위해 입력한 정보는 목적이 달성된 후
													별도의 DB로 옮겨져 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간
													참조)일정 기간 저장된 후 파기됩니다.<br> - 동 개인정보는 법률에 의한 경우가 아니고서는
													보유되는 이유 이외의 다른 목적으로 이용되지 않습니다.
												</li>
												<li>② 파기방법<br> - 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여
													파기합니다.<br> - 전자적 파일 형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을
													사용하여 삭제합니다.
												</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>8. 회원 및 법정대리인의 권리와 그 행사방법</dt>
										<dd>
											<ol>
												<li>① 회원 및 법정대리인은 언제든지 등록되어 있는 자신의 개인정보를 조회하거나 수정할 수
													있으며 가입해지를 요청할 수도 있습니다.</li>
												<li>② 회원의 개인정보 조회/수정을 위해서는 '개인정보변경(또는 '회원정보수정'등)을,
													가입해지(동의철회)를 위해서는 "회원탈퇴"를 통해 직접 열람, 정정 및 탈퇴가 가능합니다.</li>
												<li>③ 개인정보관리책임자에게 서면, 전화 또는 이메일로 연락하시면 지체 없이 조치하겠습니다.</li>
												<li>④ 회원이 개인정보의 오류에 대한 정정을 요청하신 경우에는 정정을 완료하기 전까지 개인정보를
													이용 또는 제공하지 않습니다. 또한 잘못된 개인정보를 제3자에게 이미 제공한 경우에는 정정 처리결과를
													제3자에게 지체 없이 통지하여 정정이 이루어지도록 하겠습니다.</li>
												<li>⑤ 회사는 회원 혹은 법정 대리인의 요청에 의해 해지 또는 삭제된 개인정보는 "6.
													개인정보의 보유 및 이용기간"에 명시된 바에 따라 처리하고 그 외의 용도로 열람 또는 이용할 수 없도록
													처리하고 있습니다.</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>9. 개인정보 자동 수집장치의 설치/운영 및 거부에 관한 사항</dt>
										<dd>
											<p class="pFirst">회사는 개인정보를 생성하기 위해 회원이 서비스 실행 시
												기기식별번호(디바이스 아이디 또는 IMEI)를 자동으로 수집하게 됩니다. 회원이 기기식별번호를 자동으로
												수집하는 것을 거부하는 경우 서비스를 이용할 수 없습니다.</p>
										</dd>
									</dl>
									<dl>
										<dt>10. 개인정보의 안정성 확보 조치</dt>
										<dd>
											<p class="pFirst">회사는 「정보통신망법」 제28조, 「개인정보보호법」 제29조에 의거하여
												회원의 개인정보를 처리함에 있어 개인정보가 분실, 도난, 누출, 변조 또는 훼손되지 않도록 안전성 확보를
												위하여 다음과 같은 기술적/관리적/물리적 대책을 강구하고 있습니다.</p>
											<ol>
												<li>① 내부관리계획의 수립 및 시행<br> 회사는 ‘개인정보의 안전성 확보조치 기준’에
													의거하여 내부관리계획을 수립, 시행합니다.
												</li>
												<li>② 개인정보처리자 지정의 최소화 및 교육<br> 개인정보처리자의 지정을 최소화하고
													정기적인 교육을 시행하고 있습니다.
												</li>
												<li>③ 개인정보에 대한 접근 제한<br> 개인정보를 처리하는 데이터베이스시스템에 대한
													접근권한의 부여, 변경, 말소를 통하여 개인정보에 대한 접근을 통제하고, 침입차단시스템과 침입방지시스템을
													이용하여 외부로부터의 무단 접근을 통제하고 있으며, 권한 부여, 변경 또는 말소에 대한 내역을 기록하고,
													그 기록을 최소 3년간 보관하고 있습니다.
												</li>
												<li>④ 접속기록의 보관 및 위변조 방지<br> 개인정보처리시스템에 접속한 기록을 보관
													관리하고 있으며, 접속 기록이 위변조 및 도난, 분실되지 않도록 관리하고 있습니다.
												</li>
												<li>⑤ 개인정보의 암호화<br> 회원의 개인정보는 암호화 되어 저장 및 관리되고
													있습니다. 또한 중요한 데이터는 저장 및 전송 시 암호화하여 사용하는 등의 별도 보안기능을 사용하고
													있습니다.
												</li>
												<li>⑥ 해킹 등에 대비한 기술적 대책<br> 회사는 해킹이나 컴퓨터 바이러스 등에 의한
													개인정보 유출 및 훼손을 막기 위하여 보안프로그램을 설치하고 주기적인 갱신ㆍ점검을 하며 외부로부터 접근이
													통제된 구역에 시스템을 설치하고 기술적, 물리적으로 감시 및 차단하고 있습니다.
												</li>
												<li>⑦ 비인가자에 대한 출입 통제<br> 개인정보를 보관하고 있는 개인정보시스템의
													물리적 보관 장소를 별도로 두고 이에 대해 출입통제 절차를 수립, 운영하고 있습니다.
												</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>11. 개인정보보호책임자 및 담당자</dt>
										<dd>
											<p class="pFirst">회사는 개인정보를 보호하고 개인정보와 관련된 사항을 처리하기 위하여
												아래와 같이 개인정보 보호책임자와 실무담당자를 지정하고 있습니다. 회사는 회원의 개인정보와 관련된 민원 및
												고충사항에 대하여 신속하게 처리하겠습니다.</p>
											<div class="servTerm_tbl">
												<table summary="">
													<caption></caption>
													<colgroup>
														<col style="width: 70px;">
														<col>
														<col style="width: 70px;">
														<col>
													</colgroup>
													<thead>
														<tr>
															<th colspan="2"><div>개인정보 관리책임자</div></th>
															<th colspan="2"><div>개인정보 보호담당자</div></th>
														</tr>
													</thead>
													<tbody>
														<tr>
															<th><div>성명</div></th>
															<td><div>박정은</div></td>
															<th><div>성명</div></th>
															<td><div>김선영</div></td>
														</tr>
														<tr>
															<th><div>담당부서</div></th>
															<td><div>AVATAR TEAM</div></td>
															<th><div>담당부서</div></th>
															<td><div>AVATAR TEAM</div></td>
														</tr>
														<tr>
															<th><div>전화</div></th>
															<td><div>02-889-8422</div></td>
															<th><div>전화</div></th>
															<td><div>02-889-8423</div></td>
														</tr>
														<tr>
															<th><div>이메일</div></th>
															<td><div>pje@webcash.co.kr</div></td>
															<th><div>이메일</div></th>
															<td><div>joli0318@gmail.com</div></td>
														</tr>
													</tbody>
												</table>
											</div>
											<p class="pFirstNext mgt5">기타 개인정보침해에 대한 신고나 상담이 필요하신
												경우에는 아래 기관에 문의하시기 바랍니다.</p>
											<ul class="inDepth">
												<li>- 개인정보침해 신고센터<br> (privacy.kisa.or.kr/118)
												</li>
												<li>- 개인정보 분쟁조정위원회<br>
													(www.kopico.go.kr/1833-6972)
												</li>
												<li>- 정보보호마크인증위원회<br>
													(www.eprivacy.or.kr/02-550-9531~2)
												</li>
												<li>- 경찰청 사이버안전국<br> (cyber.go.kr/182)
												</li>
											</ul>
										</dd>
									</dl>
									<dl>
										<dt>12. 고지의 의무</dt>
										<dd>
											<p class="pFirst">현 개인정보처리방침의 내용 추가, 삭제 및 수정이 있을 시에는 시행일자
												최소 7일전부터 “서비스”내 공지사항 화면을 통해 공고할 것입니다.</p>
											<p>- 공고 및 시행일자 : 2021 년 04 월 15 일</p>
										</dd>
									</dl>
								</div>
							</div>
						</div>
					</div>
					<!--// -->
					<!-- (add)20211001 -->
					<div class="popLayer_bt">
						<div class="popLayer_bt_inn">
							<a href="#none" class="bt_w1">확인</a>
						</div>
					</div>
					<!-- //(add)20211001 -->
				</div>
			</div>
		</div>
		<!-- //content -->
		<!-- content -->
		<div class="content termFixed" style="display: none;">
			<div class="popLayer">
				<div class="popLayer_dim"></div>
				<div class="popLayer_inner">
					<div class="popLayer_title">
						<h3 class="tit">약관동의</h3>
						<a href="#none" class="btn_close"><img
							src="../home/img/btn_popLayer_close.png" alt="Close"></a>
					</div>
					<!-- -->
					<div class="popLayer_body">
						<div class="popLayer_content">
							<div>
								<h3 class="popTitle_first">ASK AVATAR 이용약관</h3>
								<div class="servTerm">
									<dl>
										<dt>제 1조. (목적)</dt>
										<dd>
											<p class="pFirst">본 약관은 다큐브㈜(이하 “회사”)가 ASKAVATAR (이하
												“AVATAR”)에서 제공하는 AVATAR 서비스(이하 “서비스”)의 이용에 관련한 기본적인 사항을 규정함을
												목적으로 합니다.</p>
										</dd>
									</dl>
									<dl>
										<dt>제 2조. (용어의 정의)</dt>
										<dd>
											<p class="pFirstNext">본 약관에서 사용하는 용어의 정의는 다음과 같습니다.</p>
											<ol>
												<li>1) “서비스”라 함은 “회사”가 “AVATAR” 상에서 “회원”의 각종 금융정보와 실물정보
													알림 및 다양한 어플리케이션의 기능을 제공하는 제반 서비스를 의미합니다.</li>
												<li>2) “회원”이라 함은 AVATAR에 접속하여 본 약관에 따라 “회사”와 이용계약을 체결하고
													“회사”가 제공하는 “서비스”를 이용하는 개인 및 사업자를 의미합니다.</li>
												<li>3) “이용수수료”라 함은 본 “서비스”를 이용할 때 “회원”에게 부과되는 월납수수료를
													말합니다.</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>제 3조. (약관의 효력과 개정)</dt>
										<dd>
											<ol>
												<li>1) 본 약관은 “서비스”를 이용하기 위해 “회원”이 본 서비스에 접속하여 약관의 내용에
													동의를 한 다음 회원가입 신청을 하고 “회사”가 이러한 신청에 대하여 승낙함으로써 효력을 발휘합니다.</li>
												<li>2) “회사”는 본 약관의 내용을 “회원”이 쉽게 알 수 있도록 서비스 화면을 통해
													게시합니다.</li>
												<li>3) “회사”는 새로운 “서비스”의 적용, 보안체계의 향상 및 유지, 정부 등 공공기관에
													의한 시정명령의 이행, 기타 “회사”의 필요에 의하여 약관을 변경하여야 할 필요가 있다고 판단 될 경우
													관계법령을 위반 하지 않는 범위 내에서 본 약관을 개정할 수 있습니다.</li>
												<li>4) “회사”는 본 약관을 개정하는 경우, 개정 약관의 적용일자 및 개정사유를 명시하여
													현행약관과 함께 공지사항에 게시하는 방법으로 “회원”이 사전에 인지할 수 있도록 약관적용 30일 전부터
													적용 전일까지 공지합니다. 단, 신속히 개정 약관을 적용하여야 할 부득이한 사유가 있는 경우에는 7일
													이상의 기간 동안 공지한 후 개정 약관을 적용할 수 있습니다.</li>
												<li>5) “회사”가 전항에 따라 개정사항을 공지한 날로부터 개정약관 시행일까지 거부의사를
													표시하지 아니하면 개정약관 적용에 동의한 것으로 본다는 뜻을 명확히 고지하였음에도 “회원”이 거부의사를
													표시하지 않는 경우 개정약관 적용에 동의한 것으로 봅니다.</li>
												<li>6) “회원”이 개정 약관의 적용에 동의하지 않는 경우, “회사”는 해당 “회원”에게 개정
													약관을 적용할 수 없으며, 이 경우 해당 “회원” 또는 “회사” 중 어느 일방은 “서비스” 이용(또는
													제공)을 해지(또는 중지)할 수 있습니다.</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>제 4조. (서비스의 내용)</dt>
										<dd>
											<ol>
												<li>1) “회사”가 “회원”에게 제공하는 “서비스”는 다음과 같습니다.
													<ul>
														<li>가. 어플리케이션 : 각종 금융정보 알림 및 금융 업무의 기반을 이용하기위해 “회원”이
															직접 등록관리를 할 수 있는 모바일 상 어플리케이션 서비스</li>
														<li>나. 웹사이트 : “회원”이 공인인증서를 관리할 수 있는 온라인 상의 별도 페이지</li>
													</ul>
												</li>
												<li>2) “회사”가 “회원”에게 제공하는 “어플리케이션”에 대한 주요 서비스 상세는 다음과
													같습니다.
													<ul>
														<li>가. 어플리케이션 메뉴 : 질의, 알림, 더보기 및 관리/설정 등</li>
														<li>나. 기본서비스 : 계좌정보 / 신용카드정보 / 홈택스정보 / 여신금융협회정보 기반의
															조회 서비스, 음성인식 기반의 데이터 조회 서비스 등</li>
														<li>다. 부가서비스 : 제휴서비스 또는 부가서비스 업무에 맞추어 서비스 제공</li>
													</ul>
												</li>
												<li>3) “회사”는 “서비스” 개선을 위하여 필요한 경우 “어플리케이션” 종류를 추가하거나
													변경할 수 있습니다.</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>제 5조(회원 정보의 수집 및 분석)</dt>
										<dd>
											<ol>
												<li>1) “회사”는 이용계약을 위하여 “회원”이 제공한 정보 외에도 수집목적 또는 이용목적을
													밝혀 “회원”으로부터 필요한 관련 정보를 수집할 수 있습니다.</li>
												<li>2) “회사”가 정보 수집을 위하여 “회원”의 동의를 받는 경우, “회사”는 수집하는 정보의
													항목 및 수집방법, 수집목적 및 이용목적, 정보의 보유 및 이용기간, 제3자에 대한 정보제공 사항을
													개인정보처리방침으로 미리 명시하거나 고지합니다.</li>
												<li>3) “회사”는 “회원”의 수집된 정보를 분석하여 “회원”에게 혜택 정보 및 최적화된 맞춤형
													정보 등을 제공할 수 있습니다.</li>
												<li>4) “회원”의 개인정보의 처리 및 보호에 관한 사항은 개인정보처리방침에서 정한 바에
													따릅니다.</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>제 6조. (이용수수료)</dt>
										<dd>
											<ol>
												<li>1) “회사”는 “회원”에게 이용수수료를 부과할 수 있으며, 수수료는 서비스 페이지 등을
													통해 고지합니다. 본 약관이 정한 서비스 외 추가 서비스를 제공하기 위해 회원에게 별도 또는 추가적인
													가입절차를 요청할 수 있으며, 회원이 추가 서비스를 이용할 경우 각 서비스 별로 추가되는 이용약관이 본
													약관보다 우선 적용됩니다.</li>
												<li>2) 본 서비스의 “이용수수료”는 서비스 이용약정일 익월 요금 출금일에 “회원”이 지정한
													수수료 출금계좌에서 자동 출금하여 납부됩니다.</li>
												<li>3) “이용수수료”를 변경할 경우 시행일 1개월 전까지 “회원”에게 서면, 이메일 또는
													서비스 화면 등에 공지하여 통지하기로 합니다.</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>제 7조. (서비스 해지 및 중지)</dt>
										<dd>
											<ol>
												<li>1) “회원”이 “서비스”를 해지하고자 하는 때에는 “회원”이 사전에 가입한 채널을 통해
													해지할 수 있으며, “회원”이 가입채널에 이용해지 신청을 제출 또는 해지 신청절차를 완료한 시점부터 계약이
													종료됩니다.</li>
												<li>2) “회사”는 “회원”에게 다음 각 호에 해당하는 상황이 발생 할 경우 사전 통보 없이
													“서비스”의 제공을 중지할 수 있습니다.
													<ul>
														<li>가. 수수료출금은행의 인터넷뱅킹 서비스가 해지 또는 정지된 경우</li>
														<li>나. 수수료출금계좌가 해지되거나 거래중지 된 경우</li>
														<li>다. “이용수수료”를 결제하지 않고 3개월이 경과한 경우</li>
														<li>라. 1년간 서비스 사용을 하지 않은 경우</li>
														<li>마. 사업자등록이 휴·폐업된 경우</li>
														<li>바. 기타 정상적인 “서비스”운영에 방해가 된다고 “회사”가 판단한 경우</li>
													</ul>
												</li>
												<li>3) “회사”는 “회원”에게 다음 각 호에 해당하는 상황이 발생 할 경우 이 서비스
													이용계약을 해지할 수 있습니다.
													<ul>
														<li>가. “회원”이 서비스 이용 해지를 요청하는 경우</li>
														<li>나. “회원”이 본 약관상의 의무를 위반한 경우</li>
														<li>다. 타인의 명의 또는 인적사항을 도용한 경우</li>
														<li>라. 서비스의 안정적 운영을 고의로 방해한 경우</li>
														<li>마. 제2항 각호의 서비스 중지사유가 발생 후, 정당한 이유 없이 1년이 경과한 경우</li>
														<li>바. 서비스의 이용과 관련하여 건전한 이용을 저해하는 행위를 하거나, 기타 관계법령을
															위반한 경우</li>
													</ul>
												</li>
												<li>4) 환불은 서비스를 이용한 일수를 제외하고 일할 계산으로 진행됩니다. 월 이용료를 해당월
													총 일수(28 ~ 31일)로 나눈 금액을 말합니다.</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>제 8조. (서비스 이용시간)</dt>
										<dd>
											<ol>
												<li>1) “서비스”의 이용시간은 “회사”의 업무상 또는 기술상의 특별한 지장이 없는 한
													연중무휴, 1일 24시간을 원칙으로 합니다.</li>
												<li>2) 금융기관 등과 관련되는 거래는 해당 금융기관의 정책 및 사정에 따라 변경 또는 제한 될
													수 있습니다.</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>제 9조. (회사의 의무)</dt>
										<dd>
											<ol>
												<li>1) “회사”는 특별한 사정이 없는 한 “회사”가 제공하는 “서비스”를 계속적이고 안정적으로
													제공하기 위하여 최선을 다하여 노력합니다.</li>
												<li>2) “회사”는 “서비스”의 제공 설비를 항상 운용 가능한 상태로 유지보수하며, 설비에
													장애나 오류가 발생한 경우 지체 없이 이를 수리 복구할 수 있도록 최선을 다하여 노력합니다.</li>
												<li>3) “회사”는 “회원”으로부터 제기되는 의견이나 불만이 정당한 것으로 인정될 경우 또는
													“회사” 스스로 오류가 있음을 확인한 때에는 신속히 처리하여야 합니다. 다만, 신속한 처리가 곤란한 경우
													“회원”에게 그 사유와 처리 일정을 이메일 또는 “서비스” 공지사항, 전화 등의 기타 방법으로 통지합니다.</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>제 10조. (회원의 의무)</dt>
										<dd>
											<ol>
												<li>1) “회원”은 본 약관 및 관계 법령을 준수하여야 하며, 기타 “회사”의 업무 수행에
													지장을 초래하는 행위를 하여서는 안됩니다.</li>
												<li>2) “회원”은 본 약관 이외의 이용하는 “서비스”와 관련하여 “회사”가 통지하는 사항을
													준수하여야 합니다.</li>
												<li>3) “회원”은 다음 각 호에 해당하는 행위를 하여서는 안됩니다.
													<ul>
														<li>가. 신청 및 등록 또는 변경 시 허위 내용의 등록</li>
														<li>나. 타인의 정보 도용</li>
														<li>다. “회사” 또는 제3자의 지식재산권에 대한 침해</li>
														<li>라. “회사” 또는 제3자의 명예 훼손 및 업무방해</li>
														<li>마. 음란한 부호, 문자, 음향, 화상, 영상, 기타 공서양속에 반하는 정보의 공개 또는
															게시</li>
														<li>바. “회사”의 동의 없이 영리 목적의 복제, 전송, 출판, 배포, 방송, 기타 방법에
															의하여 이용하거나 제3자에게 전달 이용</li>
														<li>사. 기타 불법하고 부당한 행위</li>
													</ul>
												</li>
												<li>4) “회원”은 자신의 명의가 도용되거나 제 3자에게 부정하게 사용된 것을 인지한 경우 즉시
													그 사실을 회사에 통보하여야 합니다.</li>
												<li>5) “회원”은 “서비스” 이용 시 로그인 패턴, 휴대폰 본인인증번호에 대한 관리책임이
													있으며, 이를 제3자에게 제공, 누설하거나 이와 유사한 행위를 하여서는 안 됩니다.</li>
												<li>6) “서비스” 이용 시 결제와 관련하여 회원이 입력한 정보 및 그 정보와 관련하여 발생한
													책임과 불이익은 전적으로 회원이 부담하여야 합니다.</li>
												<li>7) “회사”는 “회원”이 제10조 제3 항의 의무를 위반하는 내용을 담고 있는 게시물을
													게시한 경우 그 게시물에 대하여 수정 또는 삭제할 권한을 갖습니다.</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>제 11조. (손해배상)</dt>
										<dd>
											<ol>
												<li>1) “회사” 또는 “회원”은 어느 일방이 본 약관에서 정한 의무를 위반함에 따라 상대방에게
													손해가 발생한 경우 귀책당사자에게 손해배상을 청구할 수 있습니다.</li>
												<li>2) 본 약관에서 정한 의무 위반 등으로 인하여 제3자와의 사이에 분쟁 발생 시 귀책 사유가
													있는 일방 당사자는 자신의 책임과 비용으로 상대방을 면책시키고, 그로 인한 상대방의 모든 손해를 배상하여야
													합니다.</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>제 12조. (면책사항)</dt>
										<dd>
											<ol>
												<li>1) “회사”는 전시, 사변 등 국가비상사태, 천재지변, 기간통신사업자의 서비스제공 중단,
													한전으로부터의 전력공급 중단, 해커의 침입, 컴퓨터 바이러스, 기타 이와 유사한 사정으로 인한 서비스
													시스템의 작동불능 등 “회사”에게 책임을 물을 수 없는 사유로 인하여 “서비스”를 제공할 수 없는 경우에는
													“서비스”제공에 관한 책임이 면책됩니다.</li>
												<li>2) “회사”는 “서비스”의 이용과 관련하여 개인정보처리방침에서 정하는 내용에 해당하지 않는
													사항에 대하여 책임을 부담하지 않습니다.</li>
												<li>3) “회사”는 “회원”의 귀책사유로 인하여 발생하는 손해에 대하여 어떠한 책임도 부담하지
													않습니다.</li>
												<li>4) “회사”는 “회원” 상호간, “회원”과 제휴사 또는 제3자 상호간에 “서비스”를 매개로
													발생한 분쟁에 대해서는 개입할 의무가 없으며 이로 인한 손해를 배상할 책임이 없습니다.</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>제 13조. (지식재산권 등)</dt>
										<dd>
											<ol>
												<li>1) 본 약관을 통해 “회사”는 “회원”에게 “서비스”에 대한 사용권만을 부여하며,
													“회사”가 작성하여 제공하는 “서비스”에 관한 소유권 및 지식재산권은 “회사”에 귀속됩니다. 단,
													“서비스” 중 “회사”와 제휴를 통해 제휴사가 제공하는 기술에 대한 소유권 및 지식재산권은 제휴사에
													귀속됩니다.
												<li>2) “회원”은 “회사”가 제공하는 “서비스”를 “회사”의 사전 동의 없이 영리 목적으로
													복제, 전송, 출판, 배포, 방송, 기타 방법에 의하여 이용하거나 제3자에게 이용하게 하여서는 안됩니다.
												
												<li>3) “회원”이 “서비스”에 게재한 게시물, 자료에 관한 권리와 책임은 게시한 “회원”에게
													있습니다. “회원”은 게재한 게시물, 자료에 대하여 “서비스” 내의 게재권을 가지며, “회사”는 게재한
													“회원”의 동의 없이 이를 영리적인 목적으로 사용하지 않습니다.
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>제 14조. (분쟁해결 및 관할 법원)</dt>
										<dd>
											<ol>
												<li>1) “회사”와 “회원”은 “서비스”와 관련하여 발생한 분쟁을 원만하게 해결하기 위하여
													필요한 모든 노력을 하여야 합니다.</li>
												<li>2) “서비스” 이용에 관해 발생한 분쟁이 원만하게 해결되지 아니한 경우 관련 소송의 관할은
													민사소송법에 따른 관할법원의 판결에 따르기로 합니다.</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>제 15조. (기타)</dt>
										<dd>
											<ol>
												<li>1) “회사”는 본 “서비스”의 원활한 제공을 위하여 전산설비 운영, 상담 업무 등을
													제3자에게 위탁할 수 있습니다.</li>
												<li>2) 본 약관에서 정하지 않은 사항 및 내용 해석상의 이견이 있을 경우에는 일반상관습에
													따르기로 합니다.</li>
												<li>3) “회사”와 “회원” 사이에 개별적으로 합의한 사항이 이 약관에 정한 사항과 다를 때에는
													그 합의사항을 이 약관에 우선하여 적용합니다.</li>
											</ol>
										</dd>
									</dl>
									<dl>
										<dt>[부칙]</dt>
										<dd>
											<ul>
												<li>본 약관은 2021 년 04 월 15 일부터 적용됩니다.</li>
											</ul>
										</dd>
									</dl>
								</div>
							</div>
						</div>
					</div>
					<!--// -->
					<!-- (add)20211001 -->
					<div class="popLayer_bt">
						<div class="popLayer_bt_inn">
							<a href="#none" class="bt_w1">확인</a>
						</div>
					</div>
					<!-- //(add)20211001 -->
				</div>
			</div>
		</div>
		<!-- //content -->

		<!-- pop_wrap -->
		<div id="pop_msg" class="pop_wrap flexDisplay" style="display: none;">
			<div class="pop_inn">
				<div class="pop_container">
					<div class="pop_msg">
						<p id="pop_alert"></p>
					</div>
					<div class="pop_bt">
						<div class="pop_bt_inn">
							<a id="pop_btn" class="bt_w1">확인</a>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- //pop_wrap -->

	</div>
	<!-- //wrap -->

</body>
</html>