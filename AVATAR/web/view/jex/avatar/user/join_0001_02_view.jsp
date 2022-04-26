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
 * @File Name        : join_0001_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/user
 * @author           : 김별 (  )
 * @Description      : 회원가입_정보입력화면
 * @History          : 20200129100717, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/user/join_0001_02.js
 * @JavaScript Url   : /js/jex/avatar/user/join_0001_02.js
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
    <script type="text/javascript" src="/js/jex/avatar/user/join_0001_02.js?<%=_CURR_DATETIME%>"></script>
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
						<h2 class="c_bl">회원가입을 위한 정보를 입력하여 주십시요. </h2>
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
											<input type="text" id="name" placeholder="이름" value="">
										</div>
									</td>
								</tr>
								<tr>
									<td>
										<div class="input_type">
											<input type="tel" id="birth" placeholder="생년월일(예:19900101)" value="">
										</div>
									</td>
									<td></td>
									<td>
										<div class="slt_type type2" id="gender"><!-- 선택클래스 click / 활성화클래스 on -->
											<div class="inner">
												<a class="tit" gender="1">남자</a>
											</div>
											<!-- 레이어 -->
											<div class="ly_slt_type" style="display:none;">
												<ul>
													<li value="1" class="on">남자</li>
													<li value="0" >여자</li><!-- 활성화클래스 on -->
												</ul>
											</div>
											<!-- //레이어 -->
										</div>
									</td>
								</tr>
								<tr>
									<td colspan="3">
										<div class="tel_co">
											<span><input type="radio" name="tel_co" value="01">SKT</span>
											<span><input type="radio" name="tel_co" value="02">KT</span>
											<span><input type="radio" name="tel_co" value="03">LG U+</span>
											<span><input type="checkbox" name="tel_co1" >알뜰폰</span>
											<span class="last"><input type="checkbox" name="in_frnr" checked >내국인</span>
										</div>
									</td>
								</tr>
								<tr>
									<td>
										<div class="input_type">
											<input type="tel" id="clph_no" placeholder="휴대폰번호" value="">
										</div>
									</td>
									<td></td>
									<td>
										<a class="btn_01" id="require">인증요청</a>
										<a class="btn_01" id="re_require" style="display:none;">인증재요청</a>
									</td>
								</tr>
								<tr>
									<td colspan="3">
										<div class="input_type right">
											<input type="tel" id="sms_cert_no" placeholder="인증번호(숫자 6자)" value="">
											<span class="time">03:00</span>
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
		<!-- 토스트 팝업 -->
		<div class="toast_pop" style="display:none;">
			<div class="inner">
				<span id="toast_msg">이름을 입력해주세요.</span>
			</div>
		</div>
		<!-- //토스트 팝업 -->
		<!-- 하단 fix버튼 -->
		<div class="btn_fix_botm">
			<div class="inner">
				<a class="off" id="nextBtn">다음</a>
			</div>
		</div>
		<!-- //하단 fix버튼 -->

	</div>
	<!-- //content -->
</body>
</html>