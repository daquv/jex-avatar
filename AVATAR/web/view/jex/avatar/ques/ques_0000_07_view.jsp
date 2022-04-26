<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
	// Action 결과 추출
	String ERR_CD = StringUtil.null2void(request.getParameter("ERR_CD"));
	String INTE_CD = StringUtil.null2void(request.getParameter("INTE_CD"));
	String INTE_NM = StringUtil.null2void(request.getParameter("INTE_NM"));
	
	String LGIN_APP = StringUtil.null2void(request.getParameter("LGIN_APP"));
    String USER_CI = StringUtil.null2void(request.getParameter("USER_CI"),"");
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_0000_07_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김예지 (  )
 * @Description      : 질의오류_공통화면(시간값) - 시간값 오류, 유료 
(ques_0000_03과 동일한 화면. 단, session체크 안함)
 * @History          : 20211222162516, 김예지
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0000_07.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0000_07.js
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
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_0000_07.js?<%=_CURR_DATETIME%>"></script>
</head>
<script type="text/javascript">
	var ERR_CD = '<%=ERR_CD%>';
	var INTE_CD = '<%=INTE_CD%>';
	var INTE_NM = '<%=INTE_NM%>';
	var _APP_ID = '<%=LGIN_APP%>';
	var userCi = '<%=USER_CI%>';
</script>

<body class="bg_F5F5F5">
	<!-- content -->
	<div class="content">

		<div class="m_cont"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			
			<!-- 컨텐츠 영역 -->
			<div class="notibx_wrap type5">
				<div class="inner">
					<div class="ico ico5"></div>
					<% if("00000000".equals(ERR_CD)) {%>
						<span data-type="" id="RESULT_TTS" style="display:none;">
						오늘 데이터는 내일 확인할 수 있어요  데이터 수집시간을 확인해주세요
						</span>
						<div class="noti_tit">
							<span class="c_blue">AVATAR</span>에서 제공되는 데이터는<br>
							하루 한 번 자동 업데이트 됩니다
						</div>
						<div class="noti_cn2">
							오늘 데이터는 내일 확인할 수 있어요
						</div>
					<%} else if("00000001".equals(ERR_CD)) {%>
						<span data-type="" id="RESULT_TTS" style="display:none;">
						데이터가 조회되지 않습니다.팁 질문을 참고하여 다시 물어봐주세요.
						</span>
						<div class="noti_tit">
							데이터가 조회되지 않습니다.<br>
							이렇게 물어보세요!
						</div>
					<%} %>
				</div>
			</div>
			<!-- //컨텐츠 영역 -->

		</div>

		<!-- 버튼영역 -->
		<% if("00000000".equals(ERR_CD)) {%>
			<div class="btn_add type1 tip">
				<p class="btn_s04">“어제 <span class="inteTxt"><%=INTE_NM %>는</span>?”</p>
			</div>
		<%} else if("00000001".equals(ERR_CD)) {%>
			<div class="btn_add type1 tip slideTip">
				<div class="rolling_wrap">
					<ul class="btn_rolling swiper-wrapper">
						<li class="swiper-slide">
							<p class="btn_s04">“<span class="guideDate"></span><span class="inteTxt"><%=INTE_NM %>는</span>?”</p><br>
							<p class="btn_s04">“<span class="guideDate"></span><span class="inteTxt"><%=INTE_NM %>는</span>?”</p><br>
							<p class="btn_s04">“<span class="guideDate"></span><span class="inteTxt"><%=INTE_NM %>는</span>?”</p>
						</li>
						<li class="swiper-slide">
							<p class="btn_s04">“<span class="guideDate"></span><span class="inteTxt"><%=INTE_NM %>는</span>?”</p><br>
							<p class="btn_s04">“<span class="guideDate"></span><span class="inteTxt"><%=INTE_NM %>는</span>?”</p><br>
							<p class="btn_s04">“<span class="guideDate"></span><span class="inteTxt"><%=INTE_NM %>는</span>?”</p>
						</li>
					</ul>
				</div>
			</div>
		<%} %>
		
		<!-- //버튼영역 -->

	</div>
	<!-- //content -->
<!-- (add)20210408 -->
<script>
(function ($){
	$.fn.extend({
		rolling: function(options) {
			var defaults = {speed:1000,directFrom:1};
			var $this = $(this),
			slideLeng = $(this).find(".slide").length,
			slideHeight = $(this).find(".slide").height(),
			slideItems = $(this).find(".slide"),
			hslide = slideHeight * (slideLeng+2);
			$(this).css({"height":hslide});
			$this.css({"top":-slideHeight});
			slideItems.eq(0).clone().appendTo($this);
			options = $.extend(defaults, options);
			slideItems.eq(slideLeng -1).clone().prependTo($this);
			var current = 1;
			var show_slide = function(direction,slideHeight){
				if(slideLeng != 1){
					$this.animate({ top: "+=" + (-slideHeight) * direction,opacity:1}, function() {
						current += direction;
						cycle = !!(current === 0 || current > slideLeng);
						if (cycle) {
							current = (current === 0)? slideLeng : 1;
							$this.css({top: - slideHeight * current});
						}
					});
				}
			};
			var dayTimer = setInterval(function() {
				show_slide(options.directFrom,slideHeight);
			},options.speed);
		}
	});
}( jQuery ));

$(document).ready(function() {
	'use strict';
	/* rolling call */
	$(".btn_rolling").rolling({
		speed:2000,
		directFrom:1/* 1 or -1 */
	});
});


</script>
<!-- //(add)20210408 -->
</body>

</html>