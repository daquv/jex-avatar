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
 * @File Name        : join_0004_09_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/user
 * @author           : 김별 (  )
 * @Description      : 회원가입_약관동의(5.경리나라-개인(신용)정보수집이용동의)
 * @History          : 20210414153124, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/user/join_0004_09.js
 * @JavaScript Url   : /js/jex/avatar/user/join_0004_09.js
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
    <script type="text/javascript" src="/js/jex/avatar/user/join_0004_09.js?<%=_CURR_DATETIME%>"></script>
</head>
<body><!-- (modify)20210416 -->

<!-- content -->
<div class="content termFixed"><!-- (modify)20210416 -->

	<!-- (add)20210414 -->
	<div class="popLayer_wrap" style="display:block;">
		<div class="popLayer_inn">
			<div class="tit_wrap">
				<h3 class="pop_tit">경리나라 개인(신용)정보 수집 이용 동의</h3>
				<a href="#none" class="btn_close"><img src="../img/btn_popLayer_close.png" alt="Close"></a>
			</div>
			<!-- -->
			<div class="pop_cnt mCustomScrollbar" style="max-height:100%;">
				<div class="pop_cnt_inn">
					<div>
						<h3 class="popTitle_first">경리나라 개인(신용)정보 수집 이용 동의</h3><!-- (add)20210414(r4) -->
						<div class="servTerm">
							<ul>
								<li>※ 다큐브 주식회사가 제공하는 ASK AVATAR서비스 (이하 “서비스”)와 관련하여, 본인은 동의 내용을 숙지하였으며, 이에 따라 본인의 개인정보를 귀사(다큐브 주식회사)가 수집 및 이용하는 것에 대해 동의합니다.</li>
							</ul>
							<ul class="inDepth mgt10">
								<li>■ 개인(신용)정보의 수집•이용 목적 : 경리나라 데이터 연동을 통한 음성인식 기반 ASK AVATAR 서비스 제공</li>
								<li>■ 개인(신용)정보를 제공하는 자 : 웹케시㈜ 경리나라</li>
								<li>■ 개인(신용)정보를 제공받는 자 : 다큐브 주식회사</li>
								<li>
									■ 수집•이용할 개인(신용) 정보
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
													<td><div>ASK AVATAR 회원가입을 위한 수집 정보</div></td>
													<td><div>아이디(ID), 고객관리번호, 사업자정보(사업자등록번호, 사업장명, 대표자명, 업태, 업종, 우편번호, 주소, 상세주소, 대표 전화번호)</div></td>
													<td><div class="tac">서비스 해지 까지</div></td>
												</tr>
												<tr>
													<td><div>ASK AVATAR 서비스 이용을 위한 정보 조회</div></td>
													<td><div>거래처 정보, 거래처 미수/미지급내역, 매출/매입 증빙자료, 급여자료, 계좌 입/출내역, 수납/지급내역, 이체내역, 어음 ASK AVATAR</div></td>
													<td><div class="tac">ASK AVATAR 서비스 이용 시 정보 조회 후 즉시 삭제</div></td>
												</tr>
											</tbody>
										</table>
									</div>
								</li>
							</ul>
							<ul class="mgt5">
								<li>※ 귀하는 서비스에 대한 동의를 거부할 권리가 있으나, 동의하지 않으실 경우 ASK AVATAR 서비스 이용이 불가능합니다.</li>
								<li>※ 법령에 따른 개인정보의 수집/이용, 계약의 이행/편의 증진을 위한 개인정보 처리위탁 및 개인정보 처리와 관련된 일반 사항은 서비스의 개인정보 처리방침에 따릅니다.</li>
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