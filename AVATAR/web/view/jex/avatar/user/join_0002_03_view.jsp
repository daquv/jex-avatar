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
 * @File Name        : join_0002_03_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/user
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20201207093513, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/user/join_0002_03.js
 * @JavaScript Url   : /js/jex/avatar/user/join_0002_03.js
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
    <script type="text/javascript" src="/js/jex/avatar/user/join_0002_02.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>

	<!-- content -->
	<div class="content">

		<div class="m_cont"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<!-- 컨텐츠 영역 -->
			<div class="cont_pd">
				<div class="service_terms">
					<h3>개인정보 제3자 제공 동의</h3>
					<p>주식회사 케이티가 제공하는 GiGA Genie 서비스(이하 “서비스”라 한다)와 관련하여, 본인은 동의내용을 숙지하였으며, 이에 따라 본인의 개인정보를 귀사(주식회사 케이티)가 수집 및 이용하는 것에 대해 동의합니다.</p>
					<div class="tbl_per mgt10">
						<table>
							<caption></caption>
							<colgroup><col><col width="50%"><col></colgroup>
							<thead>
								<tr>
									<th>수집/이용 목적</th>
									<th>개인정보 항목(필수동의 항목)</th>
									<th>보유 및 이용기간</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>서비스 제공 및 서비스 품질 향상 <br />
									서비스 품질제고를 위한 인구통계학적분석 및 이용 형태/선호도 분석, 개인맞춤형 서비스 제공</td>
									<td>서비스 실행을 위한 사용자 음성명령 언어 정보, 서비스 요청/실행/접속 로그, 서비스 이용시간/이용기록, 기기고유정보, 서비스 이용과정에서 필요한 정보 (개인별 성향정보, 설정정보, 주소, 전화번호, 주소록, 일정, 선호 버스정류장 정보 등 버스관련정보, 이용컨텐츠정보, 지니뮤직 ID, 홈 IoT 이용 KT ID, 기가지니아파트 서비스 이용을 위한 홈네트워크 ID)</td>
									<td>서비스 이용 기간</td>
								</tr>
							</tbody>
						</table>
					</div>
					<ul class="mgt10">
						<li>※ 서비스 제공을 위해서 필요한 최소한의 개인정보이므로 동의를 해주셔야 서비스를 이용하실 수 있습니다.</li>
						<li >※ 원칙적으로 귀하께서 서비스를 이용하시는 기간 동안 동의하신 정보(로그기록, 서비스 이용계약 이행과정에서 자동적으로 생성되는 정보)들은 수집, 저장되고 서비스 운영 및 서비스 이용현황 분석, 통계분석 데이터 활용을 통한 서비스 개선개발을 위하여 이용됩니다. 또한 귀하께서 서비스의 이용 기록 삭제를 하시는 경우에는 지체 없이 관련 정보들은 파기됩니다. 다만, 관계법령의 규정에 의하여 개인정보를 보유할 필요가 있는 경우에는 해당 법령에서 정한 일정 기간 동안 정보를 보관할 수 있습니다.</li>
						<li>※ 법령에 따른 개인정보의 수집/이용, 계약의 이행/편의 증진을 위한 개인정보 처리위탁 및 개인정보 처리와 관련된 일반 사항은 서비스의 개인정보 처리방침에 따릅니다.</li>
						<li>※ 서비스 이용 과정에서 수집되는 음성 정보의 경우에는 음성인식에 기반한 서비스에서 음성명령을 더욱 정확하게 인식하여 보다 향상된 기능을 제공하기 위한 목적으로만 사용되며, 24개월 동안 암호화 되어 서버에 저장되고 이후 삭제됩니다.</li>
					</ul>
				</div>
			</div>
			<!-- //컨텐츠 영역 -->

		</div>

	</div>
	<!-- //content -->

</body>
</html>