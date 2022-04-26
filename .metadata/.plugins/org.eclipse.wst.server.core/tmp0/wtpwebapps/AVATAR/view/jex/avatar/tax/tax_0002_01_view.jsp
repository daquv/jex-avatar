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
 * @File Name        : tax_0002_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/tax
 * @author           : 김태훈 (  )
 * @Description      : 홈텍스 공인인증서 조회화면
 * @History          : 20200131141200, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/tax/tax_0002_01.js
 * @JavaScript Url   : /js/jex/avatar/tax/tax_0002_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/tax/tax_0002_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
	<!-- content -->
	<div class="content">

		<div class="m_cont"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<div class="set_bx_wrap">
				<dl>
				<dt><div class="tit">등록된 공동인증서</div></dt>
					<dd>
						<div class="certi01">
							<span class="ico"></span>
							<div class="left" id="div_cert">
<!-- 								<div class="tit"> -->
<!-- 									<em>가나상사</em> -->
<!-- 									<span class="no">112233445566778899112233</span> -->
<!-- 								</div> -->
<!-- 								<div class="txt"> -->
<!-- 									<p>범용기업 / 금융결제원</p> -->
<!-- 									<p><span class="date">만료일</span><span class="c_red">2018.10.31(잔여 15일)</span></p> -->
<!-- 								</div> -->
							</div>
							<!-- (modify)20210517 -->
							<div class="cerStatus">
								<span class="cerEnd" style="display:none;">인증서만료</span>
								<span class="cerChange" id="a_change">교체</span>
							</div>
							<!-- //(modify)20210517 -->
						</div>
					</dd>
				</dl>
			</div>
		</div>

		<!-- 토스트 팝업 -->
		<div class="toast_pop" style="display: none;">
			<div class="inner">
				<span>삭제되었습니다.</span>
			</div>
		</div>
		<!-- //토스트 팝업 -->
		
		<!-- 하단 fix버튼 -->
		<div class="btn_fix_botm btn_both"><!-- 버튼 2개인 경우 btn_both 클래스 추가 -->
			<div class="inner">
				<a class="off" id="a_del">삭제</a>
				<a id="a_enter">확인</a>
			</div>
		</div>
		<!-- //하단 fix버튼 -->

	</div>
	<!-- //content -->

</body>
</html>