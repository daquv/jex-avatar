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
 * @File Name        : tax_0005_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/tax
 * @author           : 김별 (  )
 * @Description      : 데이터_매출현금영수증목록화면
 * @History          : 20200131165131, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/tax/tax_0005_01.js
 * @JavaScript Url   : /js/jex/avatar/tax/tax_0005_01.js
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
    <script type="text/javascript" src="/js/jex/avatar/tax/tax_0005_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
<!-- content -->
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			<div class="cont_pd data_y">
				<!-- 내역 리스트 -->
				<div class="tbl_list">
					<table>
						<colgroup>
							<col style="width:44px;"><col><col style="width:120px;">
						</colgroup>
						<tbody>
							<tr class="row1">
								<td colspan="3">
									<div class="tbl_list type2">
										<table>
											<colgroup>
												<col style="width:44px;"><col><col style="width:120px;">
											</colgroup>
											<tbody>
												<!-- <tr>
													<th>12.08</th>
													<td><span class="elipsis">16521</span></td>
													<td class="won"><em>2,000,000</em>원</td>
												</tr>
												<tr>
													<th></th>
													<td><span class="elipsis">36514</span></td>
													<td class="won"><em>1,500,000</em>원</td>
												</tr> -->
											</tbody>
										</table>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- //내역 리스트 -->
			</div>
			<!-- 컨텐츠 영역 -->
			<div class="notibx_wrap type2 data_n" style="display:none;">
				<div class="inner">
					<div class="ico ico4"></div>
					<div class="noti_tit">매출현금영수증 데이터가 없습니다.</div>
				</div>
			</div>
			<!-- //컨텐츠 영역 -->
		</div>

		<!-- 마이크 버튼영역 -->
		
		<!-- //마이크 버튼영역 -->

	</div>
	<!-- //content -->

</body>
</html>