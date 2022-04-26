<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String quesGb = StringUtil.null2void(request.getParameter("QUES_DIV"));
    String jsonData = StringUtil.null2void(request.getParameter("JSONDATA"));
    //String quesList = StringUtil.null2void(request.getParameter("REC_QUES"));
    
	System.out.println("quesGb > " + quesGb);
	//System.out.println("bzaqList > " + bzaqList);
	JexDataCMO UserSession = SessionManager.getSession(request, response);
    String APP_ID = StringUtil.null2void((String)UserSession.get("APP_ID"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_0000_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김별 (  )
 * @Description      : 질의_데이터없음 화면
 * @History          : 20200224162752, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0000_01.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0000_01.js
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
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_0000_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<script type="text/javascript">
	var jsonData = '<%=jsonData%>';
	var quesGb = '<%=quesGb%>';
	var _APP_ID = '<%=APP_ID%>';
	<%-- var quesList = '<%=quesList%>'; --%>
</script>
<body class="bg_F5F5F5">
<!-- content -->
	<div class="content">
		<% if("02".equals(quesGb)) {%>
			<div class="m_cont"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			<span data-type="" id="RESULT_TTS" style="display:none;">
				오류가 발생하였습니다. 일시적인 현상이거나 네트워크 문제일 수 있으니, 잠시 후 다시 시도하세요.
			</span>
			<!-- 컨텐츠 영역 -->
			<div class="notibx_wrap type5">
				<div class="inner">
					<div class="ico ico8"></div>
					<div class="noti_tit">오류가 발생하였습니다.</div>
					<div class="noti_cn2">
						오류가 발생하였습니다. 일시적인 현상이거나 네트워크 문제일 수<br>
						있으니, 잠시 후 다시 시도하세요.
					</div>
				</div>
			</div>
			<!-- //컨텐츠 영역 -->

			</div>

			<!-- 버튼영역 -->
			<!-- <div class="btn_add type1 tip">
				<p class="btn_s04">“고객센터”</p>
			</div> -->
			<!-- //버튼영역 -->
		
		<% } else { %>
			<!-- (modify)20210517 -->
			<div class="m_cont"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
				<span data-type="" id="RESULT_TTS" style="display:none;">
				팁 질문을 참고해서 다시 물어봐주세요.
				</span>
				<!-- 컨텐츠 영역 -->
				<div class="notibx_wrap type5">
					<div class="inner">
						<div class="ico ico5"></div>
						<div class="noti_tit">
							혹시 이걸 물어보려 하셨나요?
						</div>
					</div>
				</div>
				<!-- //컨텐츠 영역 -->
			</div>
		
			<!-- 버튼영역 -->
			<div class="btn_add type1 tip slideTip">
				<div class="rolling_wrap" ><!-- style="overflow:unset;" -->
					<ul class="btn_rolling">
					</ul>
				</div>
			</div>
			<!-- //버튼영역 -->
			<!-- //(modify)20210517 -->
		<% } %>
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
	
	if($(".btn_rolling li").length > 1){
		$(".btn_rolling").rolling({
			speed:2000,
			directFrom:1/* 1 or -1 */
		});
	}
});


</script>
<!-- //(add)20210408 -->
</body>
</html>