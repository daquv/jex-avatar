<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
	String NE_DAY = StringUtil.null2void(request.getParameter("NE_DAY"));
	String NE_BMONTH = StringUtil.null2void(request.getParameter("NE_BMONTH"));
	String NE_BDAY = StringUtil.null2void(request.getParameter("NE_BDAY"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_0004_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200122143612, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0004_01.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0004_01.js
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
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_0004_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
<input type="hidden" id="NE_DAY" value="<%=NE_DAY%>" />
<input type="hidden" id="NE_BMONTH" value="<%=NE_BMONTH%>" />
<input type="hidden" id="NE_BDAY" value="<%=NE_BDAY%>" />
<!-- content -->
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<!-- 질의 답변 탑영역 -->
			<div class="aias_news data_y" style="display:none;">
				<table>
					<colgroup><col></colgroup>
					<tr>
						<td>
							<strong></strong><br>
							총 <span class="big c_blue"></span> 입니다.
						</td>
					</tr>
				</table>
			</div>
			<!-- //질의 답변 탑영역 -->
			
			<!-- 질의 답변영역 -->
			<div class="aias_list data_y" style="display:none;">
				<dl>
					<dd>
						(세금)계산서
						<div class="right">
							
						</div>
					</dd>
					<dd>
						카드매출
						<div class="right">
							
						</div>
					</dd>
					<dd>
						현금영수증
						<div class="right">
							
						</div>
					</dd>
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
		<!-- 버튼영역 -->
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