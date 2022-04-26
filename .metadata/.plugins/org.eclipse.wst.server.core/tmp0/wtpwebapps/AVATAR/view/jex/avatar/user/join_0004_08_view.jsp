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
 * @File Name        : join_0004_08_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/user
 * @author           : 박지은 (  )
 * @Description      : 고유식별정보처리 동의
 * @History          : 20210415170220, 박지은
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/user/join_0004_08.js
 * @JavaScript Url   : /js/jex/avatar/user/join_0004_08.js
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
    <script type="text/javascript" src="/js/jex/avatar/user/join_0004_08.js?<%=_CURR_DATETIME%>"></script>
</head>
<body><!-- (modify)20210416 -->

<!-- content -->
<div class="content termFixed"><!-- (modify)20210416 -->

	<!-- (add)20210415 -->
	<div class="popLayer_wrap" style="display:block;">
		<div class="popLayer_inn">
			<div class="tit_wrap">
				<h3 class="pop_tit">고유식별정보처리 동의</h3>
				<a href="#none" class="btn_close"><img src="../img/btn_popLayer_close.png" alt="Close"></a>
			</div>
			<!-- -->
			<div class="pop_cnt mCustomScrollbar" style="max-height:100%;">
				<div class="pop_cnt_inn">
					<div>
						<h3 class="popTitle_first">고유식별정보처리 동의</h3>
						<div class="servTerm">
							<h3 class="tit_h3 pFirst">[(주)케이티 귀중]</h3>
							<p>주)케이티 (이하 "본인확인기관")가 코리아크레딧뷰로(주) (이하 "회사")을 통해 제공하는 휴대폰 본인확인 서비스 관련하여 이용자로부터 수집한 고유식별정보를 이용하거나 타인에게 제공할 때에는 '정보통신망 이용촉진 및 정보보호 등에 관한 법률'(이하 "정보통신망법")에 따라 이용자의 동의를 얻어야 합니다.</p>
							<dl>
								<dt>제 1 조 [고유식별정보의 처리 동의]</dt>
								<dd>
									<p class="pFirst">"본인확인기관"은 정보통신망법 제23조의2 제2항에 따라 인터넷상에서 주민등록번호를 입력하지 않고도 본인임을 확인할 수 있는 휴대폰 본인확인서비스를 제공하기 위해 고유식별정보를 처리합니다.</p>
								</dd>
							</dl>
							<dl>
								<dt>제 2 조 [고유식별정보의 제공 동의]</dt>
								<dd>
									<p class="pFirstNext">"본인확인기관 지정 등에 관한 기준(방송통신위원회 고시)"에 따라 "회사"와 계약한 정보통신서비스 제공자 의 연계서비스 및 중복가입확인을 위해 아래와 같이 본인의 고유식별정보를 '다른 본인확인기관'에 제공하는 것에 동의합니다.</p>
									<ol>
										<li>
											1. 제공자(본인확인기관)<br>
											(주)케이티
										</li>
										<li>
											2. 제공 받는자(본인확인기관)<br>
											코리아크레딧뷰로㈜, SCI평가정보㈜
										</li>
										<li>
											3. 제공하는 항목<br>
											주민등록번호(내국인), 외국인등록번호(국내거주외국인)
										</li>
										<li>
											4. 제공 목적<br>
											CI(연계정보), DI(중복가입확인정보)의 생성 및 전달
										</li>
										<li>
											5. 보유 및 이용기간<br>
											CI(연계정보), DI(중복가입확인정보) 생성 즉시 폐기
										</li>
										<li>6. 위 개인정보 제공에 동의하지 않으실 경우, 서비스를 이용할 수 없습니다.</li>
									</ol>
								</dd>
							</dl>
							<h3 class="tit_h3">[LG유플러스(주) 귀중]</h3>
							<p>LG유플러스(주)(이하 ‘회사’)가 휴대폰본인확인서비스(이하 ‘서비스’)를 제공하기 위해 고유식별정보를 다음과 같이 제3자에게 제공 및 처리 하는 데에 동의합니다.</p>
							<dl>
								<dt></dt>
								<dd>
									<ol>
										<li>
											1. 고유식별정보를 제공받는자<br>
											- NICE평가정보㈜, SCI평가정보(주)
										</li>
										<li>
											2. 고유식별정보를 제공받는자의 목적<br>
											- 연계정보(CI)와 중복가입확인정보(DI)의 생성 및 ‘회사’ 제공<br>
											- 부정 이용 방지 및 민원 처리<br>
										</li>
										<li>3. 고유식별정보 제공 항목: ‘회사’가 보유하고 있는 고객의 주민등록번호와 외국인등록번호</li>
										<li>4. 고유식별정보를 제공받는 자의 보유 및 이용기간: 연계정보(CI) 및 중복가입확인정보(DI) 생성 후 6개월</li>
										<li>5. 상기 고유식별정보 처리에 대한 내용에 동의하지 않으실 경우, ‘서비스’를 이용할 수 없습니다.</li>
									</ol>
									<ul>
										<li>상기와 같이 고유식별정보 이용 및 처리에 동의합니다.</li>
									</ul>
								</dd>
							</dl>
							<h3 class="tit_h3">[SK텔레콤 귀중]</h3>
							<p>본인은 SK텔레콤(주)(이하 ‘회사’라 합니다)가 제공하는 본인확인서비스(이하 ‘서비스’라 합니다)를 이용하기 위해, 다음과 같이 본인의 개인정보를 회사가 아래 기재된 제3자에게 제공하는 것에 동의합니다.</p>
							<dl>
								<!--<dt></dt>-->
								<dd>
									<ol>
										<li>
											1. 개인정보를 제공받는 자<br>
											- NICE평가정보(주), SCI평가정보(주)
										</li>
										<li>
											2. 개인정보를 제공받는 자의 개인정보 이용목적<br>
											- 연계정보(CI)/중복가입확인정보(DI) 생성 및 회사에 제공<br>
											- 부정 이용 방지 및 민원 처리
										</li>
										<li>
											3. 제공하는 개인정보 항목<br>
											- 회사가 보유하고 있는 이용자의 주민등록번호 및 외국인등록번호
										</li>
										<li>
											4. 개인정보를 제공받는 자의 개인정보 보유 및 이용기간<br>
											- 연계정보(CI)/중복가입확인정보(DI) 생성 후 6개월
										</li>
										<li>5. 위 개인정보 제공에 동의하지 않으실 경우, 서비스를 이용할 수 없습니다.</li>
									</ol>
								</dd>
							</dl>
							<h3 class="tit_h3">&lt;코리아크레딧뷰로㈜ 귀중&gt;</h3>
								<p>귀사가 에스케이텔레콤㈜, ㈜케이티, LG유플러스㈜ 등 통신사로부터 위탁 받아 제공하는 휴대폰본인확인서비스 이용과 관련하여, 본인의 개인정보를 수집·이용하고자 하는 경우 「개인정보보호법」 제17조, 제22조, 제24조, 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」 제24조의2에 따라 제3자에게 제공할 경우 본인의 사전동의를 얻어야 합니다. 이에 귀사가 아래와 같이 본인의 고유식별정보를 처리하는 것에 동의 합니다.</p>
								<dl>
									<dt>□ 수집·이용 및 제공 목적</dt>
									<dd>
										<ol>
											<li>① 정보통신망법 제23조의2 제2항에 따라 인터넷상에서 주민등록번호를 입력하지 않고도 본인임을 확인할 수 있는 휴대폰 본인인증 서비스를 제공하기 위해 고유식별정보를 이용</li>
											<li>② ''본인확인기관 지정 등에 관한 기준(방송통신위원회 고시)''에 따라 "회사"와 계약한 정보통신서비스 제공자의 연계서비스 및 중복가입확인을 위해 필요한 경우, 다른 본인확인기관이 아래의 고유식별정보를 제공받아 처리하기 위함.</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>□ 수집·이용 및 제공하는 고유식별정보 항목</dt>
									<dd>
										<ol>
											<li>① 주민등록번호(내국인)</li>
											<li>② 외국인등록번호(국내거주외국인)</li>
										</ol>
									</dd>
								</dl>
								<dl>
									<dt>□ 고유식별정보 보유 및 이용기간</dt>
									<dd>
										<p class="pFirstNext">
											고유식별정보의 수집 · 이용 및 제공 목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다.<br>
											다만, 전자상거래 등에서의 소비자보호에 관한 법률 등 관련법령의 규정에 의하여 일정기간 보유하여야 할 필요가 있을 경우에는 일정기간 보유합니다.
										</p>
										<ul>
											<li>- 계약 또는 청약철회 등에 관한 기록 : 5년</li>
											<li>- 대금결제 및 재화등의 공급에 관한 기록 : 5년</li>
											<li>- 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년</li>
											<li>- 기타 다른 법률의 규정에 의하여 보유가 허용되는 기간</li>
										</ul>
									</dd>
								</dl>
								<dl>
									<dt>□ 동의거부 및 거부시 불이익</dt>
									<dd>
										<p class="pFirst">고유식별정보 수집·이용 및 제공에 대한 동의는 거부할 수 있으며, 동의 후에도 철회 가능합니다. 다만, 동의 거부 및 철회 시에는 서비스 이용이 제한될 수 있습니다.</p>
									</dd>
								</dl>
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
	<!-- //(add)20210415 -->

</div>
<!-- //content -->

</body>
</html>