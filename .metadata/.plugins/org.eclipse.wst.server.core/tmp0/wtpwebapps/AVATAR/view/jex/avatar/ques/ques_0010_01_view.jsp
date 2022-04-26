<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String NE_COUNTERPARTNAME = StringUtil.null2void(request.getParameter("NE_COUNTERPARTNAME"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_0010_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김별 (  )
 * @Description      : 거래처 화면
 * @History          : 20200207162613, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0010_01.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0010_01.js
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
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_0010_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
<input type="hidden" id="NE_COUNTERPARTNAME" value="<%=NE_COUNTERPARTNAME%>" />
<!-- content -->
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<!-- 질의 답변 탑영역 -->
			<div class="aias_news data_y"  style="display:none;">
				<table>
					<colgroup><col></colgroup>
					<tr>
						<td>
							<span class="c_blue"></span>에 대한 조회 결과 입니다.
						</td>
					</tr>
				</table>
			</div>
			<!-- //질의 답변 탑영역 -->

			<!-- 거래처상세 -->
			<div class="list_dv_wrap data_y"  style="display:none;">
				<div class="list_dv_top">
					<div class="left">
						<span class="tit"><span class="elipsis"><!-- 우리축산물 --></span></span>
					</div>
				</div>
				<div class="list_dv_cn b_btm">
					<!-- 상세정보 -->
					<div class="list_dv_tbl">
						<table>
							<colgroup><col style="width:100px;"><col></colgroup>
							<tbody>
								<!-- <tr>
									<th>대표이사</th>
									<td>이태선</td>
								</tr>
								<tr>
									<th>사업자번호</th>
									<td>305-81-98316</td>
								</tr>
								<tr>
									<th>주소</th>
									<td>서울시 영등포구 영신로 220</td>
								</tr> -->
							</tbody>
						</table>
					</div>
					<!-- //상세정보 -->

				</div>

			</div>
			<!-- //거래처상세 -->
			
			<!-- 질의 답변영역 -->
			<div class="aias_list dtbg data_y"  style="display:none;">
				<dl>
					<dt>매출</dt>
					<!-- <dd>
						12.01 지엠아이
						<div class="right">
							300,000원
						</div>
					</dd> -->
					
					<dt>매입</dt>
					<!-- <dd>
						12.01 지엠아이
						<div class="right">
							300,000원
						</div>
					</dd> -->
					
				</dl>
			</div>
			<!-- //질의 답변영역 -->

			<!-- 컨텐츠 영역 -->
			<div class="notibx_wrap type2 data_n" style="display:none;">
				<div class="inner">
					<div class="ico ico4"></div>
					<div class="noti_tit">질의에 대한 데이터가 없습니다</div>
					<div class="noti_cn2">
						데이터 가져오기 버튼을 탭하여<br>
						데이터 가져오기를 진행하여 주십시요
					</div>
				</div>
			</div>
			<!-- //컨텐츠 영역 -->
		</div>
		<div class="btn_add data_n" style="display:none;">
			<a class="btn_s01">데이터 가져오기</a>
		</div>
		<!-- //버튼영역 -->
		<!-- 마이크 버튼영역 -->
		<div class="btn_fix_r data_y">
			<a class="btn_mic"></a>
		</div>
		<!-- //마이크 버튼영역 -->

	</div>
	<!-- //content -->
	</body>
	</html>