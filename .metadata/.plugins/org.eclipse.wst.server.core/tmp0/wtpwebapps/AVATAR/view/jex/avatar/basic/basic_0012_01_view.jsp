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
 * @File Name        : basic_0012_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 박지은 (  )
 * @Description      : 프로필-서비스탈퇴
 * @History          : 20210726095637, 박지은
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0012_01.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0012_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/basic/basic_0012_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5">
<!-- content -->
<div class="content">


	<div class="m_cont pdt12">
		<div class="m_bx_wrap">
			<div class="sitt_wrap type1">
				<div class="sitt_innert">
					<p class="tit">
						아바타 계정 탈퇴 전 꼭 확인해주세요!
					</p>
				</div>
			</div>

			<div class="txt_infoRegBx">
				<div class="inner">
					<ul>
						<li>
							탈퇴 후에는 아바타의 모든 서비스를 이용할 수 없습니다.
						</li>
						<li>
							아바타 탈퇴 시 가입정보, 등록된 인증서 및 서비스 이용기록 등 모든 정보가 삭제됩니다.<br>
							- 단, 관계법령 및 내부 방침에 의해 보존하도록 규정된 정보는 해당기간까지 보관됩니다.
						</li>
						<li>
							탈퇴 후 재가입은 익일부터 이용 가능합니다.
						</li>
						<li>
							탈퇴 시 기존 데이터가 삭제되어 재가입을 위해서는 서비스에 필요한 데이터를 다시 연결해야 합니다.
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>

	<!-- 하단 fix버튼 -->
	<div class="btn_fix_botm type4 btn_both"><!-- 버튼 2개인 경우 btn_both 클래스 추가 -->
		<div class="inner">
			<a id="trmn_btn">탈퇴하기</a>
			<a id="cancel_btn" class="off">탈퇴 취소</a>
		</div>
	</div>
	<!-- //하단 fix버튼 -->

</div>
<!-- //content -->

	<!-- modal overlay -->
	<div class='modaloverlay' id='modaloverlay01' style="display : none;">
		<div class='lytb'><div class='lytb_row'><div class='lytb_td'>
		<div class='layer_style1'>
			<div class='layer_po'>
				<div class='cont'>
					<div class='lyp_tit'>
						탈퇴가 완료되었습니다.<br />
						이용해주셔서 감사합니다.
					</div>
				</div>
			</div>
			<div class='ly_btn_fix_botm'><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->
				<a class='btn_pop' id="comp_btn">ask avatar 종료</a>
				<!-- <a class='btn_pop' id="crtc_btn">재가입하기</a> -->
			</div>
		</div>
		</div></div></div>
	</div>
	<!-- //modal overlay -->
	
	<!-- modal overlay -->
	<div class='modaloverlay' id='modaloverlay02' style="display : none;">
		<div class='lytb'><div class='lytb_row'><div class='lytb_td'>
		<div class='layer_style1'>
			<div class='layer_po'>
				<div class='cont'>
					<div class='lyp_tit'>
						정말 탈퇴하시겠습니까?
					</div>
				</div>
			</div>
			<div class='ly_btn_fix_botm btn_both'><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->
				<a id="pop_trmn_btn" class='btn_pop'>네</a>
				<a id="pop_cancel_btn" class='btn_pop off'>아니오</a>
			</div>
		</div>
		</div></div></div>
	</div>
	<!-- //modal overlay -->
</body>
</html>