<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
	// Action 결과 추출
	String inteInfo = StringUtil.null2void(request.getParameter("INTE_INFO"),"{}");
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_0000_04_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20210512143952, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0000_04.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0000_04.js
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
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_0000_04.js?<%=_CURR_DATETIME%>"></script>
</head>
<script>
	var inteInfo = <%=inteInfo%>;
</script>
<script type="text/javascript">
</script>

<body class="bg_F9F9F9">
	<!-- content -->
	<div class="content">

		<div class="m_cont"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			
			<!-- 컨텐츠 영역 -->
			<div class="notibx_wrap type5">
				<div class="inner">
					<div class="ico ico5"></div>
					<div class="noti_tit">
						어떤 데이터를 보고싶으신가요?
					</div>
					<div class="noti_cn2">
						선택한 데이터 출처로 답변이 제공됩니다.
					</div>
				</div>
			</div>
			<!-- //컨텐츠 영역 -->

		</div>
		
		<!-- 버튼영역 -->
		<div class="btn_add type1 tip slideTip tipNone">
			<div class="rolling_wrap">
				<ul class="btn_rolling swiper-wrapper">
					<li class="swiper-slide">
						<p class="btn_s04" data-ques_dv="01">“아바타 보여줘”</p><br>
						<p class="btn_s04" data-ques_dv="02">“경리나라 보여줘”</p>
					</li>
				</ul>
			</div>
		</div>
		<!-- //버튼영역 -->

	</div>
	<!-- //content -->
<!-- (add)20210408 -->
<!-- //(add)20210408 -->
</body>

</html>