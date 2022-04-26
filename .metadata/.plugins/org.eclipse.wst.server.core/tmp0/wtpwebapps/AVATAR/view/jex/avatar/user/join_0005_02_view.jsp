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
 * @File Name        : join_0005_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/user
 * @author           : 김별 (  )
 * @Description      : 회원가입_약관동의(2.ASKAVATAR-개인정보수집및이용동의)v3
 * @History          : 20211022131947, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/user/join_0005_02.js
 * @JavaScript Url   : /js/jex/avatar/user/join_0005_02.js
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
    <script type="text/javascript" src="/js/jex/avatar/user/join_0005_02.js?<%=_CURR_DATETIME%>"></script>
</head>
<body><!-- (modify)20210416 -->

<!-- content -->
<div class="content termFixed"><!-- (modify)20210416 -->

	<!-- (add)20210414 -->
	<div class="popLayer_wrap" style="display:block;">
		<div class="popLayer_inn">
			<div class="tit_wrap">
				<h3 class="pop_tit">ask avatar 개인정보 수집 및 이용 동의</h3>
				<a href="#none" class="btn_close"><img src="../img/btn_popLayer_close.png" alt="Close"></a>
			</div>
			<!-- -->
			<div class="pop_cnt mCustomScrollbar" style="max-height:100%;">
				<div class="pop_cnt_inn">
					<div>
						<h3 class="popTitle_first">ask avatar 개인정보 수집 및 이용 동의</h3>
						<div class="servTerm">
							<p class="pFirst">다큐브㈜(이하 “회사”)는 정보통신망 이용촉진 및 정보보호 등에 관한 법률(이하 “정보통신망법”), 개인정보보호법, 통신비밀보호법, 전기통신사업법 등 정보통신서비스제공자가 준수하여야 할 관련 법령상의 개인정보보호 규정을 준수하며, 관련 법령에 의거한 개인정보처리방침을 정하여 ask avatar(이하 “avatar”)의 서비스 이용자(이하 “회원”) 개인정보의 보호와 권익 보호에 최선을 다하고 있습니다.</p>
							<p>본 개인정보처리방침은 “회사”에서 제공하는 avatar 서비스(이하 “서비스”)에 적용되며 다음과 같은 내용을 담고 있습니다.</p>
							<dl>
								<dt>1. 수집하는 개인정보의 항목 및 수집방법</dt>
								<dd>
									<ol>
										<li>
											① 수집하는 개인정보의 항목<br>
											회사는 회원가입, 고객상담, 서비스 신청, 서비스 이용 등을 위해 아래와 같은 개인정보를 수집하고 있습니다.
											<ul>
												<li>
													가. 수집 항목
													<div class="servTerm_tbl">
														<table summary="">
															<caption></caption>
															<colgroup>
															<col style="width:25%;">
															<col>
															<col style="width:25%;">
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
																	<td><div>이름, 생년월일, 휴대폰번호, 기기식별번호(디바이스 아이디 또는 IMEI)</div></td>
																	<th><div>필수사항</div></th>
																</tr>
																<tr>
																	<th><div>계좌 거래내역 조회 서비스</div></th>
																	<td><div>공동인증서(은행용 또는 범용인증정보) 및 비밀번호, 계좌번호, 거래정보 등</div></td>
																	<th><div>필수사항</div></th>
																</tr>
																<tr>
																	<th><div>카드매출 조회 서비스</div></th>
																	<td><div>여신금융협회 ID 및 비밀번호, 카드매출정보, 매출입금정보 등</div></td>
																	<th><div>필수사항</div></th>
																</tr>
																<tr>
																	<th><div>카드정보 조회 서비스</div></th>
																	<td><div>카드번호, 카드사 공동인증서 및 비밀번호, 카드사 ID 및 비밀번호, 결제일, 사용내역, 청구내역, 한도내역 등</div></td>
																	<th><div>필수사항</div></th>
																</tr>
																<tr>
																	<th><div>매출/매입정보 및 거래처정보 조회 서비스</div></th>
																	<td><div>국세청 공동인증서 및 비밀번호, 매입/매출 세금계산서, 현금영수증 내역, 세금 내역, 거래처명, 거래처 주소, 거래처 대표자명, 거래처 사업자번호 등</div></td>
																	<th><div>필수사항</div></th>
																</tr>
																<tr>
																	<th><div>경리나라 정보 조회 서비스</div></th>
																	<td><div>아이디(ID), 비밀번호</div></td>
																	<th><div>필수사항</div></th>
																</tr>
																<tr>
																	<th><div>온라인 매출 조회 서비스</div></th>
																	<td><div>배달앱 ID 및 비밀번호(배달의민족, 요기요, 쿠팡이츠), 매출내역, 정산내역</div></td>
																	<th><div>필수사항</div></th>
																</tr>
															</tbody>
														</table>
													</div>
												</li>
												<li>
													ㅇ 서비스 이용 및 업무 처리 과정에서 아래와 같은 정보들이 입력 또는 생성되어 수집될 수 있습니다.<br>
													- 신규 서비스 계정 정보 및 요청 내역, 서비스 이용기록, 조회/알림서비스 설정 정보, 접속로그, 접속IP정보, 쿠키 정보, 불량이용기록 등
												</li>
												<li>나. 개인정보 수집방법</li>
												<li>
													ㅇ 회사는 다음과 같은 방법으로 개인정보를 수집합니다.<br>
													- 서비스 실행 또는 사용함으로써 자동으로 수집<br>
													- 서비스 가입이나 이용 중 회원의 자발적 제공을 통한 수집<br>
													- 협력회사로부터의 제공<br>
													- 홈페이지, 서면양식, 팩스, 전화, 상담게시판, 이메일, 이벤트 응모 등을 통한 수집
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
										<li>
											① 회원 관리<br>
											- 서비스 이용에 대한 본인확인, 개인식별, 불량회원의 부정 이용방지와 비인가 사용방지, 가입의사 확인, 분쟁 조정을 위한 기록보존, 불만처리 등 민원처리, 고지사항 전달, 회원탈퇴 의사의 확인
										</li>
										<li>
											② 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산<br>
											- 컨텐츠 제공, 특정 맞춤 서비스 제공, 청구서 등 발송, 본인인증, 요금 결제, 요금추심
										</li>
										<li>
											③ 신규 서비스 개발 및 서비스 통계 활용<br>
											- 신규 서비스 개발 및 맞춤 서비스 제공, 통계학적 특성에 따른 서비스 제공, 서비스의 유효성 확인, 이벤트 및 참여기회 제공, 접속빈도 파악, 회원의 서비스 이용에 대한 통계
										</li>
									</ol>
								</dd>
							</dl>
							<dl>
								<dt>3. 개인정보의 공유 및 제공</dt>
								<dd>
									<p class="pFirstNext">회사는 회원들의 개인정보를 “2. 개인정보의 수집 및 이용 목적”에서 고지한 범위 내에서 사용하며, 회원의 사전 동의 없이는 동 범위를 초과하여 이용하거나 원칙적으로 회원의 개인정보를 외부에 공개하지 않습니다. 다만, 아래의 경우에는 예외로 합니다.</p>
									<ol>
										<li>① 회원들이 사전에 동의한 경우</li>
										<li>② 서비스의 제공에 관한 계약의 이행을 위하여 필요한 개인정보로서 경제적/기술적인 사유로 통상의 동의를 받는 것이 현저히 곤란한 경우</li>
										<li>③ 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우</li>
									</ol>
								</dd>
							</dl>
							<dl>
								<dt>4. 개인정보 처리의 위탁</dt>
								<dd>
									<p class="pFirst">회사는 위탁계약 체결 시 『개인정보보호법』 제 26 조 에 따라 위탁업무 수행목적 외 개인정보 처리금지, 기술적/관리적 보호조치, 수탁자에 대한 관리/감독, 손해배상 등 책임에 관한 사항을 계약서 등 문서에 명시하고, 수탁자가 개인정보를 안전하게 처리하는지를 감독하고 있습니다. 위탁업무의 내용이나 수탁자가 변경될 경우에는 지체 없이 본 개인정보 처리방침을 통하여 공개하도록 하겠습니다.</p>
									<p>회사의 개인정보 처리 위탁기관 및 위탁업무 내용은 아래와 같습니다.</p>
									<div class="servTerm_tbl">
										<table summary="">
											<caption></caption>
											<colgroup>
											<col>
											<col>
											<col style="width:30%;">
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
													<td rowspan="5"><div class="tac">회원 탈퇴시 혹은 위탁 계약 종료시까지</div></td>
												</tr>
												<tr>
													<th><div>웹케시㈜</div></th>
													<td><div class="tac">AVATAR 서비스의 개발 및 운영</div></td>
												</tr>
												<tr>
													<th><div>비즈플레이 주식회사</div></th>
													<td><div class="tac">푸시발송 서비스</div></td>
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
									<p class="pFirst">서비스 이용에 따른 본인확인 및 개인식별, 컨텐츠 제공, 회원의 불만처리 등의 서비스 이용에 필요한 목적을 위해 회원의 개인정보에 대해서 제 3자에게 제공되고 있습니다. 이 경우 별도로 이용자의 동의 여부를 확인한 후 제공하고 있으며, 별도로 고지된 개인정보의 이용 목적, 제공 개인정보 항목, 이용 기간 내에서만 이용됩니다.</p>
								</dd>
							</dl>
							<dl>
								<dt>6. 개인정보의 보유 및 이용기간</dt>
								<dd>
									<p class="pFirstNext">회원의 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다. 단, 상법, 전자상거래 등에서의 소비자보호에 관한 법률 등 관계법령의 규정에 의하여 보존할 필요가 있는 경우 회사는 관계법령에서 정한 일정한 기간 동안 회원정보를 보관합니다. 이 경우 회사는 보관하는 정보를 그 보관의 목적으로만 이용하며 보존기간은 아래와 같습니다.</p>
									<ul class="inDepth">
										<li>
											- 계약 또는 청약철회 등에 관한 기록<br>
											보존 이유 : 전자상거래 등에서의 소비자보호에 관한 법률<br>
											보존 기간 : 5년
										</li>
										<li>
											- 대금결제 및 재화 등의 공급에 관한 기록<br>
											보존 이유 : 전자상거래 등에서의 소비자보호에 관한 법률<br>
											보존 기간 : 5년
										</li>
										<li>
											- 소비자의 불만 또는 분쟁처리에 관한 기록<br>
											보존 이유 : 전자상거래 등에서의 소비자보호에 관한 법률<br>
											보존 기간 : 3년
										</li>
										<li>
											- 방문에 관한 기록<br>
											보존 이유 : 통신비밀보호법<br>
											보존 기간 : 3개월
										</li>
									</ul>
								</dd>
							</dl>
							<dl>
								<dt>7. 개인정보 파기절차 및 방법</dt>
								<dd>
									<p class="pFirstNext">회원의 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다. 회사의 개인정보 파기절차 및 방법은 다음과 같습니다.</p>
									<ol>
										<li>
											① 파기절차<br>
											- 회원이 회원가입 등을 위해 입력한 정보는 목적이 달성된 후 별도의 DB로 옮겨져 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조)일정 기간 저장된 후 파기됩니다.<br>
											- 동 개인정보는 법률에 의한 경우가 아니고서는 보유되는 이유 이외의 다른 목적으로 이용되지 않습니다.
										</li>
										<li>
											② 파기방법<br>
											- 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.<br>
											- 전자적 파일 형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.
										</li>
									</ol>
								</dd>
							</dl>
							<dl>
								<dt>8. 회원 및 법정대리인의 권리와 그 행사방법</dt>
								<dd>
									<ol>
										<li>① 회원 및 법정대리인은 언제든지 등록되어 있는 자신의 개인정보를 조회하거나 수정할 수 있으며 가입해지를 요청할 수도 있습니다.</li>
										<li>② 회원의 개인정보 조회/수정을 위해서는 '개인정보변경(또는 '회원정보수정'등)을, 가입해지(동의철회)를 위해서는 "회원탈퇴"를 통해 직접 열람, 정정 및 탈퇴가 가능합니다.</li>
										<li>③ 개인정보관리책임자에게 서면, 전화 또는 이메일로 연락하시면 지체 없이 조치하겠습니다.</li>
										<li>④ 회원이 개인정보의 오류에 대한 정정을 요청하신 경우에는 정정을 완료하기 전까지 개인정보를 이용 또는 제공하지 않습니다. 또한 잘못된 개인정보를 제3자에게 이미 제공한 경우에는 정정 처리결과를 제3자에게 지체 없이 통지하여 정정이 이루어지도록 하겠습니다.</li>
										<li>⑤ 회사는 회원 혹은 법정 대리인의 요청에 의해 해지 또는 삭제된 개인정보는 "6. 개인정보의 보유 및 이용기간"에 명시된 바에 따라 처리하고 그 외의 용도로 열람 또는 이용할 수 없도록 처리하고 있습니다.</li>
									</ol>
								</dd>
							</dl>
							<dl>
								<dt>9. 개인정보 자동 수집장치의 설치/운영 및 거부에 관한 사항</dt>
								<dd>
									<p class="pFirst">회사는 개인정보를 생성하기 위해 회원이 서비스 실행 시 기기식별번호(디바이스 아이디 또는 IMEI)를 자동으로 수집하게 됩니다. 회원이 기기식별번호를 자동으로 수집하는 것을 거부하는 경우 서비스를 이용할 수 없습니다.</p>
								</dd>
							</dl>
							<dl>
								<dt>10. 개인정보의 안정성 확보 조치</dt>
								<dd>
									<p class="pFirst">회사는 「정보통신망법」 제28조, 「개인정보보호법」 제29조에 의거하여 회원의 개인정보를 처리함에 있어 개인정보가 분실, 도난, 누출, 변조 또는 훼손되지 않도록 안전성 확보를 위하여 다음과 같은 기술적/관리적/물리적 대책을 강구하고 있습니다.</p>
									<ol>
										<li>
											① 내부관리계획의 수립 및 시행<br>
											회사는 ‘개인정보의 안전성 확보조치 기준’에 의거하여 내부관리계획을 수립, 시행합니다.
										</li>
										<li>
											② 개인정보처리자 지정의 최소화 및 교육<br>
											개인정보처리자의 지정을 최소화하고 정기적인 교육을 시행하고 있습니다.
										</li>
										<li>
											③ 개인정보에 대한 접근 제한<br>
											개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여, 변경, 말소를 통하여 개인정보에 대한 접근을 통제하고, 침입차단시스템과 침입방지시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있으며, 권한 부여, 변경 또는 말소에 대한 내역을 기록하고, 그 기록을 최소 3년간 보관하고 있습니다.
										</li>
										<li>
											④ 접속기록의 보관 및 위변조 방지<br>
											개인정보처리시스템에 접속한 기록을 보관 관리하고 있으며, 접속 기록이 위변조 및 도난, 분실되지 않도록 관리하고 있습니다.
										</li>
										<li>
											⑤ 개인정보의 암호화<br>
											회원의 개인정보는 암호화 되어 저장 및 관리되고 있습니다. 또한 중요한 데이터는 저장 및 전송 시 암호화하여 사용하는 등의 별도 보안기능을 사용하고 있습니다.
										</li>
										<li>
											⑥ 해킹 등에 대비한 기술적 대책<br>
											회사는 해킹이나 컴퓨터 바이러스 등에 의한 개인정보 유출 및 훼손을 막기 위하여 보안프로그램을 설치하고 주기적인 갱신ㆍ점검을 하며 외부로부터 접근이 통제된 구역에 시스템을 설치하고 기술적, 물리적으로 감시 및 차단하고 있습니다.
										</li>
										<li>
											⑦ 비인가자에 대한 출입 통제<br>
											개인정보를 보관하고 있는 개인정보시스템의 물리적 보관 장소를 별도로 두고 이에 대해 출입통제 절차를 수립, 운영하고 있습니다.
										</li>
									</ol>
								</dd>
							</dl>
							<dl>
								<dt>11. 개인정보보호책임자 및 담당자</dt>
								<dd>
									<p class="pFirst">회사는 개인정보를 보호하고 개인정보와 관련된 사항을 처리하기 위하여 아래와 같이 개인정보 보호책임자와 실무담당자를 지정하고 있습니다. 회사는 회원의 개인정보와 관련된 민원 및 고충사항에 대하여 신속하게 처리하겠습니다.</p>
									<div class="servTerm_tbl">
										<table summary="">
											<caption></caption>
											<colgroup>
											<col style="width:70px;">
											<col>
											<col style="width:70px;">
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
									<p class="pFirstNext mgt5">기타 개인정보침해에 대한 신고나 상담이 필요하신 경우에는 아래 기관에 문의하시기 바랍니다.</p>
									<ul class="inDepth">
										<li>
											- 개인정보침해 신고센터<br>
											(privacy.kisa.or.kr/118)
										</li>
										<li>
											- 개인정보 분쟁조정위원회<br>
											(www.kopico.go.kr/1833-6972)
										</li>
										<li>
											- 정보보호마크인증위원회<br>
											(www.eprivacy.or.kr/02-550-9531~2)
										</li>
										<li>
											- 경찰청 사이버안전국<br>
											(cyber.go.kr/182)
										</li>
									</ul>
								</dd>
							</dl>
							<dl>
								<dt>12. 고지의 의무</dt>
								<dd>
									<p class="pFirst">현 개인정보처리방침의 내용 추가, 삭제 및 수정이 있을 시에는 시행일자 최소 7일전부터 “서비스”내 공지사항 화면을 통해 공고할 것입니다.</p>
									<p>- 공고일자: 2021년 10월 19일</p>
									<p>- 시행일자: 2021년 10월 26일</p>
								</dd>
							</dl>
							<dl>
								<!--<dt></dt>-->
								<dd>
									<a href="#none" class="servTermGo">이전 개인정보처리방침 바로가기(2021.08.26)</a><br>
									<a href="#none" class="servTermGo">이전 개인정보처리방침 바로가기(2021.04.15)</a>
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
	<!-- //(add)20210414 -->

</div>
<!-- //content -->

</body>
</html>