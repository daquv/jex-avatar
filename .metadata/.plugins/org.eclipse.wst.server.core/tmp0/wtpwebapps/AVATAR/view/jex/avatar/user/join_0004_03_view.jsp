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
 * @File Name        : join_0004_03_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/user
 * @author           : 김별 (  )
 * @Description      : 회원가입_약관동의(3.ASKAVATAR-개인정보제3자제공동의)
 * @History          : 20210414133022, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/user/join_0004_03.js
 * @JavaScript Url   : /js/jex/avatar/user/join_0004_03.js
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
    <script type="text/javascript" src="/js/jex/avatar/user/join_0004_03.js?<%=_CURR_DATETIME%>"></script>
</head>
<body><!-- (modify)20210416 -->

<!-- content -->
<div class="content termFixed"><!-- (modify)20210416 -->

	<!-- (add)20210414 -->
	<div class="popLayer_wrap" style="display:block;">
		<div class="popLayer_inn">
			<div class="tit_wrap">
				<h3 class="pop_tit">ASK AVATAR 개인정보 제3자 제공 동의</h3>
				<a href="#none" class="btn_close"><img src="../img/btn_popLayer_close.png" alt="Close"></a>
			</div>
			<!-- -->
			<div class="pop_cnt mCustomScrollbar" style="max-height:100%;">
				<div class="pop_cnt_inn">
					<div>
						<h3 class="popTitle_first">ASK AVATAR 개인정보 제3자 제공 동의</h3><!-- (add)20210414(r4) -->
						<div class="servTerm">
							<p class="pFirst mgb5">주식회사 케이티가 제공하는 GiGA Genie 서비스(이하 “서비스”라 한다)와 관련하여, 본인은 동의내용을 숙지하였으며, 이에 따라 본인의 개인정보를 귀사(주식회사 케이티)가 수집 및 이용하는 것에 대해 동의합니다.</p>
							<div class="servTerm_tbl">
								<table summary="">
									<caption></caption>
									<colgroup>
									<col>
									<col>
									<col>
									</colgroup>
									<thead>
										<tr>
											<th><div>수집/이용 목적</div></th>
											<th><div>개인정보 항목(필수동의 항목)</div></th>
											<th><div>보유 및 이용기간</div></th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>
												<div>
													<ul>
														<li>서비스 제공 및 서비스 품질 향상</li>
														<li>서비스 품질제고를 위한 인구통계학적분석 및 이용 형태/선호도 분석</li>
													</ul>
												</div>
											</td>
											<td><div>서비스 실행을 위한 사용자 음성명령 언어 정보, 서비스 요청/실행/접속 로그, 서비스 이용시간/이용기록, 기기고유정보</div></td>
											<td><div class="tac">서비스 이용 기간</div></td>
										</tr>
									</tbody>
								</table>
							</div>
							<ul class="mgt20">
								<li>※ 서비스 제공을 위해서 필요한 최소한의 개인정보이므로 동의를 해주셔야 서비스를 이용하실 수 있습니다.</li>
								<li>※ 원칙적으로 귀하께서 서비스를 이용하시는 기간 동안 동의하신 정보(로그기록, 서비스 이용계약 이행과정에서 자동적으로 생성되는 정보)들은 수집, 저장되고 서비스 운영 및 서비스 이용현황 분석, 통계분석 데이터 활용을 통한 서비스 개선개발을 위하여 이용됩니다. 또한 귀하께서 서비스의 이용 기록 삭제를 하시는 경우에는 지체 없이 관련 정보들은 파기됩니다. 다만, 관계법령의 규정에 의하여 개인정보를 보유할 필요가 있는 경우에는 해당 법령에서 정한 일정 기간 동안 정보를 보관할 수 있습니다.</li>
								<li>※ 법령에 따른 개인정보의 수집/이용, 계약의 이행/편의 증진을 위한 개인정보 처리위탁 및 개인정보 처리와 관련된 일반 사항은 서비스의 개인정보 처리방침에 따릅니다.</li>
								<li>※ 서비스 이용 과정에서 수집되는 음성 정보의 경우에는 음성인식에 기반한 서비스에서 음성명령을 더욱 정확하게 인식하여 보다 향상된 기능을 제공하기 위한 목적으로만 사용되며, 24개월 동안 암호화 되어 서버에 저장되고 이후 삭제됩니다.</li>
							</ul>
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