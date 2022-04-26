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
 * @File Name        : test_0002_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/test
 * @author           : 박지은 (  )
 * @Description      : 푸시발송 테스트
 * @History          : 20210907081607, 박지은
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/test/test_0002_01.js
 * @JavaScript Url   : /js/jex/avatar/test/test_0002_01.js
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
    <script type="text/javascript" src="/js/jex/avatar/test/test_0002_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
<input type="hidden" id="trsc_unq_no" value="">
<!-- content -->
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			<div class="cont_pd">

				<div class="acc_setbx_con" style="padding-top:35px;">
					<!-- 타이틀 -->
					<div class="tit_wrap" style="margin-bottom: 18px;">
						<h2 class="c_bl">푸시발송을 위한 정보를 입력하여 주십시요. </h2>
						<h2 class="c_bl">알림종류(001:학습완료, 002:제로페이매출, 003:카드매출) </h2>
						<h2 class="c_bl">*알림종류필수, 이용기관ID or 핸드폰번호 필수*</h2>
					</div>
					<!-- //타이틀 -->
					<!-- 입력영역 -->
					<div class="input_wrap" style="margin:-2px 0 0;">
						<table>
							<colgroup><col><col style="width:10px;"><col style="width:121px;"></colgroup>
							<tbody>
								<tr>
									<td colspan="3">
										<div class="input_type">
											<input type="text" id="noti_gb" placeholder="알림종류(002:제로페이매출, 003:카드매출)" value="">
										</div>
									</td>
								</tr>
								<tr>
									<td colspan="3">
										<div class="input_type">
											<input type="text" id="clph_no" placeholder="핸드폰번호" value="">
										</div>
									</td>
								</tr>
								<tr>
									<td colspan="3">
										<div class="input_type">
											<input type="text" id="use_intt_id" placeholder="이용기관ID" value="">
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<!-- //입력영역 -->
				</div>
			</div>
		</div>
		<!-- 하단 fix버튼 -->
		<div class="btn_fix_botm">
			<div class="inner">
				<a id="sendBtn">푸시발송</a>
			</div>
		</div>
		<!-- //하단 fix버튼 -->

	</div>
	<!-- //content -->
</body>
</html>