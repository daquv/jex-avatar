<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String RSLT_CD = StringUtil.null2void(request.getParameter("RSLT_CD"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : card_0003_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/card
 * @author           : 김태훈 (  )
 * @Description      : 
 * @History          : 20200121144600, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/card/card_0003_01.js
 * @JavaScript Url   : /js/jex/avatar/card/card_0003_01.js
 * </pre>
 **/
%>
<!doctype html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title></title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="user-scalable=yes, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width">
	<%@include file="/view/jex/avatar/include/page_import_head.jsp"%>
	<script type="text/javascript" src="/js/jex/avatar/card/card_0003_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
<input type="hidden" id="RSLT_CD" name="RSLT_CD" value="<%=RSLT_CD %>">
	<!-- content -->
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<div class="cont_pd" style="padding-top:14px;">
				<!-- 타이틀 -->
				<div class="tit_wrap">
					<h2 class="c_bl">여신금융협회 아이디/비밀번호</h2>
				</div>
				<!-- //타이틀 -->
				<!-- 입력영역 -->
				<div class="wrbx_w">
					<dl>
						<dt>아이디</dt>
						<dd>
							<div class="input_type">
								<input id="inp_id" type="email" placeholder="아이디(영문, 숫자 6~20자)" value="" maxlength="20">
							</div>
						</dd>
						<dt>비밀번호</dt>
						<dd>
							<div class="input_type">
								<input id="inp_pass" type="password" placeholder="비밀번호(영문, 숫자 8~15자)" value="" maxlength="15" readonly="readonly">
							</div>
						</dd>
					</dl> 
				</div>
				<!-- //입력영역 -->
			</div>
		</div>

		<!-- 토스트 팝업 -->
		<div class="toast_pop" style="display: none;">
			<div class="inner">
				<span>아이디를 입력하세요.</span>
			</div>
		</div>
		<!-- //토스트 팝업 -->

		<!-- 하단 fix버튼 -->
		<div class="btn_fix_botm">
			<div class="inner">
				<a class="off" id="a_cancel">취소</a>
			</div>
		</div>
		<div class="btn_fix_botm btn_both" style="display: none;">
			<div class="inner">
				<a class="off" id="a_del">삭제</a>
				<a class="" id="a_enter">확인</a>
			</div>
		</div>
		<!-- //하단 fix버튼 -->

	</div>
	<!-- //content -->

</body>
</html>