<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String ISSU_ID = StringUtil.null2void(request.getParameter("ISSU_ID"));
    String BILL_TYPE = StringUtil.null2void(request.getParameter("BILL_TYPE"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : tax_0003_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/tax
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200120161648, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/tax/tax_0003_02.js
 * @JavaScript Url   : /js/jex/avatar/tax/tax_0003_02.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <!-- <meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width"> -->
    <meta name="format-detection" content="telephone=no">
    <title></title>
    <%@include file="/view/jex/avatar/include/page_import_head.jsp"%>
    <script type="text/javascript" src="/js/jex/avatar/tax/tax_0003_02.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
<input type="hidden" id="ISSU_ID" value="<%=ISSU_ID%>" />
<input type="hidden" id="BILL_TYPE" value="<%=BILL_TYPE%>" />
<!-- content -->
	<div class="content">

		<div class="m_cont"><!-- 하단 고정버튼 있는 경우 m_cont_pd 클래스 추가 -->

			<!-- 전자세금계산서 -->
			<div class="txbl_fixed_wrap data_y">
				<div class="txbl_wrap">
					<!-- title/승인번호 -->
					<div class="txbl_trans1">
						<table class="title_tb" summary="전자세금계산서 승인번호" cellspacing="0" cellpadding="0">
							<colgroup>
								<col style="width:50%;">
								<col style="width:100px;">
								<col >
							</colgroup>
							<tbody>
								<tr>
									<th class="tac"><div>전자세금계산서</div></th>
									<td class="bg tac"><div>승인번호</div></td>
									<td class="bg tac"><div class="break"><!-- 20150423-70000000-42249922 --></div></td>
								</tr>
							</tbody>
						</table>
					</div>
					<!-- //title/승인번호 -->

					<!-- 공급자/공급받는자 -->
					<table class="txbl_tb_layout" summary="" cellspacing="0" cellpadding="0">
						<tr>
							<td class="v_top">
								<table  class="txbl_trans2" summary="공급자 공급받는자" cellspacing="0" cellpadding="0">
									<colgroup>
										<col style="width:3%;">
										<col style="width:8%;">
										<col style="width:11%;">
										<col style="width:6%;">
										<col style="width:8%;">
										<col>
										<col style="width:3%;">
										<col style="width:8%;">
										<col style="width:11%;">
										<col style="width:6%;">
										<col style="width:8%;">
										<col>
									</colgroup>
									<tr>
										<th class="bg_r2" rowspan="6"><div>공<br>급<br>자</div></th>
										<th class="bg_r"><div>등록<br>번호</div></th>
										<td class="bg_r" colspan="2"><div class="b_no"><!-- 119-08-28666 --></div></td>
										<th class="bg_r"><div>종사업장<br>번호</div></th>
										<td class="bg_r"><div class="b_cd"></div></td>
										<th rowspan="6"><div>공<br>급<br>받<br>는<br>자</div></th>
										<th><div>등록<br>번호</div></th>
										<td colspan="2"><div class="b_no"><!-- 119-08-28666 --></div></td>
										<th><div>종사업장<br>번호</div></th>
										<td><div class="b_cd"></div></td>
									</tr>
									<tr>
										<th class="bg_r"><div>상호<br>(법인명)</div></th>
										<td class="bg_r" colspan="2"><div><!-- 다빈치이벤트 --></div></td>
										<th class="bg_r"><div>성명</div></th>
										<td class="bg_r"><div><!-- 안인석 --></div></td>
										<th><div>상호<br>(법인명)</div></th>
										<td colspan="2"><div><!-- 다빈치이벤트 --></div></td>
										<th><div>성명</div></th>
										<td><div><!-- 안인석 --></div></td>
									</tr>
									<tr>
										<th class="bg_r"><div>사업장<br>주소</div></th>
										<td class="bg_r" colspan="4"><div></div></td>
										<th><div>사업장<br>주소</div></th>
										<td colspan="4"><div><!-- knk디지털 타워 20층 웹케시(성대원동,ksn테크노파그 테그동 409 401호) --></div></td>
									</tr>
									<tr>
										<th class="bg_r"><div>업태</div></th>
										<td class="bg_r"><div></div></td>
										<th class="bg_r"><div>종목</div></th>
										<td colspan="2" class="bg_r"><div></div></td>
										<th><div>업태</div></th>
										<td><div><!-- 소프트웨어개발및반매,임대 --></div></td>
										<th><div>종목</div></th>
										<td colspan="2"><div><!-- 소프트웨어개발및반매,임대 --></div></td>
									</tr>
									<tr>
										<th class="bg_r" style="height:50px;" rowspan="2"><div>이메일</div></th>
										<td class="bg_r" colspan="4" rowspan="2"><div><!-- ais4252@daum.net --></div></td>
										<th><div>이메일</div></th>
										<td colspan="4"><div><!-- ais4252@daum.net --></div></td>
									</tr>
									<tr>
										<th><div>이메일</div></th>
										<td colspan="4"><div><!-- ais4252@daum.net --></div></td>
									</tr>
									<tr class="last">
										<td class="bg_r" colspan="6"><div></div></td>
										<td colspan="6"><div></div></td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<!-- //공급자/공급받는자 -->

					<!-- 수탁사업자 -->
					<div class="txbl_trans3" style="display:none;">
						<table summary="수탁사업자" cellspacing="0" cellpadding="0">
							<colgroup>
								<col style="width:9%;"><col ><col style="width:9%;"><col ><col style="width:9%;"><col ><col style="width:9%;"><col >
							</colgroup>
							<thead>
								<tr>
									<th colspan="8" class="fir"><div>수탁사업자</div></th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th rowspan="2" class="fir"><div>등록<br>번호</div></th>
									<td rowspan="2"><div>214-86-35102</div></td>
									<th rowspan="2"><div>종사업자<br>번호</div></th>
									<td rowspan="2"><div></div></td>
									<th><div>사업장</div></th>
									<td colspan="3"><div>서울시 영등포구</div></td>
								</tr>
								<tr>
									<th><div>업태</div></th>
									<td><div>서비스 외</div></td>
									<th><div>종목</div></th>
									<td><div>시스템개발 외</div></td>
								</tr>
								<tr>
									<th class="fir"><div>상호</div></th>
									<td><div>웹케시(주)</div></td>
									<th><div>성명</div></th>
									<td><div>석창규, 유완수</div></td>
									<th><div>이메일</div></th>
									<td colspan="3"><div></div></td>
								</tr>
								<tr class="last">
									<td class="bg" colspan="4"><div></div></td>
									<td class="bg" colspan="4"><div></div></td>
								</tr>
							</tbody>
						</table>
					</div>
					<!-- //수탁사업자 -->

					<!-- 작성일자/공급가액/세액/수정사유 -->
					<div class="txbl_trans1">
						<table summary="공급가액" cellspacing="0" cellpadding="0" style="border-top:0;">
							<colgroup>
								<col style="width:16%;">
								<col style="width:17%;">
								<col style="width:17%;">
								<col>
							</colgroup>
							<tbody>
								<tr>
									<th class="tac"><div>작성일자</div></th>
									<th class="tac"><div>공급가액</div></th>
									<th class="tac"><div>세액</div></th>
									<th class="tac"><div>수정사유</div></th>
								</tr>
								<tr>
									<td class="tac"><div><!-- 2017/04/23 --></div></td>
									<td class="tar"><div><!-- 1,500,000 --></div></td>
									<td class="tar"><div><!-- 150,000 --></div></td>
									<td class="tal"><div><!-- 수정사유 --></div></td>
								</tr>
								<tr>
									<th class="tac"><div>비고</div></th>
									<td colspan="3" class="tal"><div><!-- 비고 --></div></td>
								</tr>
							</tbody>
						</table>
					</div>
					<!-- //작성일자/공급가액/세액/수정사유 -->

					<!-- 월일/품목/규격/수량.. -->
					<div class="txbl_trans1">
						<table summary="품목" cellspacing="0" cellpadding="0">
							<colgroup>
								<col span="2" style="width:30px;">
								<col>
								<col span="2" style="width:46px;">
								<col span="3" style="width:15%;">
								<col style="width:10%;">
							</colgroup>
							<tbody>
								<tr>
									<th class="tac"><div>월</div></th>
									<th class="tac"><div>일</div></th>
									<th class="tac"><div>품목</div></th>
									<th class="tac"><div>규격</div></th>
									<th class="tac"><div>수량</div></th>
									<th class="tac"><div>단가</div></th>
									<th class="tac"><div>공급가액</div></th>
									<th class="tac"><div>세액</div></th>
									<th class="tac"><div>비고</div></th>
								</tr>
								<!-- <tr>
									<td class="tac"><div>04</div></td>
									<td class="tac"><div>23</div></td>
									<td class="tal"><div>음향,무대,발전기</div></td>
									<td class="tac"><div>EA</div></td>
									<td class="tac"><div>1</div></td>
									<td class="tar"><div>1,500,000</div></td>
									<td class="tar"><div>1,500,000</div></td>
									<td class="tar"><div>150,000</div></td>
									<td class="tac"><div></div></td>
								</tr>
								<tr>
									<td class="tac"><div>&nbsp;</div></td>
									<td class="tac"><div>&nbsp;</div></td>
									<td class="tal"><div>&nbsp;</div></td>
									<td class="tac"><div>&nbsp;</div></td>
									<td class="tac"><div>&nbsp;</div></td>
									<td class="tar"><div>&nbsp;</div></td>
									<td class="tar"><div>&nbsp;</div></td>
									<td class="tar"><div>&nbsp;</div></td>
									<td class="tac"><div>&nbsp;</div></td>
								</tr>-->
								<tr>
									<td class="tac"><div>&nbsp;</div></td>
									<td class="tac"><div>&nbsp;</div></td>
									<td class="tal"><div>&nbsp;</div></td>
									<td class="tac"><div>&nbsp;</div></td>
									<td class="tac"><div>&nbsp;</div></td>
									<td class="tar"><div>&nbsp;</div></td>
									<td class="tar"><div>&nbsp;</div></td>
									<td class="tar"><div>&nbsp;</div></td>
									<td class="tac"><div>&nbsp;</div></td>
								</tr> 
							</tbody>
						</table>
					</div>
					<!-- //월일/품목/규격/수량.. -->

					<!-- 합계금액/현금/수표.. -->
					<div class="txbl_trans1">
						<table summary="합계금액" cellspacing="0" cellpadding="0" style="border-top:1px solid #555;">
							<colgroup>
								<col span="5" style="width:13%;">
								<col >
							</colgroup>
							<tbody>
								<tr>
									<th class="tac"><div>합계금액</div></th>
									<th class="tac"><div>현금</div></th>
									<th class="tac"><div>수표</div></th>
									<th class="tac"><div>어음</div></th>
									<th class="tac"><div>외상미수금</div></th>
									<td rowspan="2" class="tac"><div><strong>이 금액을&nbsp;&nbsp;&nbsp;(<span class="space40 tac">영수</span>)&nbsp;&nbsp;함</strong></div></td>
								</tr>
								<tr>
									<td class="tar"><div>1,650,000</div></td>
									<td class="tar"><div>1,650,000</div></td>
									<td class="tar"><div>1,650,000</div></td>
									<td class="tar"><div>1,650,000</div></td>
									<td class="tar"><div>1,650,000</div></td>
								</tr>
							</tbody>
						</table>
					</div>
					<!-- //합계금액/현금/수표.. -->
				</div>
			</div>
			<!-- //전자세금계산서 -->
		<!-- 컨텐츠 영역 -->
			<div class="notibx_wrap type2 data_n" style="display:none;">
				<div class="inner">
					<div class="ico ico4"></div>
					<div class="noti_tit">(세금)계산서 데이터가 없습니다.</div>
				</div>
			</div>
		<!-- //컨텐츠 영역 -->
		</div>

		<!-- 마이크 버튼영역 -->
		<!-- <div class="btn_fix_r data_y">
			<a class="btn_mic"></a>
		</div> -->
		<!-- //마이크 버튼영역 -->
		
	</div>
	<!-- //content -->


</body>
</html>