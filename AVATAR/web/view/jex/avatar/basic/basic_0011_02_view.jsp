<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%@page import="com.avatar.session.SessionManager"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    JexDataCMO UserSession = SessionManager.getSession(request, response);
    String APP_ID = StringUtil.null2void((String)UserSession.get("APP_ID"));
    String LGIN_APP = StringUtil.null2void((String)UserSession.get("LGIN_APP"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : basic_0011_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 김별 (  )
 * @Description      : 브리핑 설정
 * @History          : 20210818153203, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0011_02.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0011_02.js
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
	<script type="text/javascript" src="/js/jqueryPlugin/jquery.picker.min.js?<%=_CURR_DATETIME%>"></script>
	<script type="text/javascript" src="/js/jex/avatar/basic/basic_0011_02.js?<%=_CURR_DATETIME%>"></script>
</head>
<script>
	var _APP_ID = '<%=APP_ID%>';
	var _LGIN_APP = '<%=LGIN_APP%>';
</script>
<body class="bg_F5F5F5">

<!-- content -->
<div class="content">

	<div class="m_cont pdt12">
		<div class="m_bx_wrap">
		<!-- 
			<div class="br_sList" id="voiceBrief">
				<div class="m_prp_list type4">
					<ul>
						<li>
							<h2>제로페이 보이스 브리핑 </h2>
							<p>제로페이 앱에서 결제승인,취소,입금예정액 발생 시 푸시 알림과 음성으로 동시에 알려드릴게요.</p>
							<div class="right">
								<a href="#none" class="btn_switch on"><span class="blind">활성</span></a>
							</div>
						</li>
					</ul>
				</div>
			</div>
		-->
			<div class="br_sList" id="zpBrief" style="display:none;">
				<!-- 리스트 영역 -->
				<div class="m_prp_list type4">
					<ul>
						<li>
							<h2>제로페이 매출 브리핑</h2>
							<p>매일 설정한 시간대에 전일 제로페이 매출액, 입금 예정액을 푸시 알림과 음성으로 동시에 알려드릴게요.</p>
							<div class="right">
								<a href="#none" class="btn_switch on"><span class="blind">활성</span></a>
								<!--<a href="#none" class="btn_switch"><span class="blind">비활성</span></a>-->
							</div>
						</li>
					</ul>
				</div>
				<!-- //리스트 영역 -->
				<!-- Time Picker -->
				<div class="timePIcker_wrap">
					<!-- 
					<div class="timeType" style="display:none;">
						<a href="#none" class="btn_prev disabled"><span class="blind">prev</span></a>
						<div class="pickerLy">
							<select class="picker_select" style="display:none;">
								<option value="set_am" selected>오전</option>
								<option value="set_pm">오후</option>
							</select>
						</div>
						<a href="#none" class="btn_next"><span class="blind">next</span></a>
					</div>
					-->
					<div class="timeSelect" style="margin-left:0;">
						<a href="#none" class="btn_prev"><span class="blind">prev</span></a>
						<div class="pickerLy">
							<select class="picker_select" style="display:none;">
								<!-- 
								<option>01&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>02&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>03&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>04&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>05&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>06&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								-->
								<option>07&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>08&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option selected>09&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>10&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>11&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>12&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>13&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>14&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>15&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>16&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>17&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>18&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>19&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>20&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>21&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>22&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>23&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
							</select>
						</div>
						<a href="#none" class="btn_next"><span class="blind">next</span></a>
					</div>
				</div>
				<!--//Time Picker -->
			</div>
			<div class="br_sList" id="cardBrief" style="display:none;">
				<!-- 리스트 영역 -->
				<div class="m_prp_list type4">
					<ul>
						<li>
							<h2>카드 매출 브리핑</h2>
							<p>매일 설정한 시간대에 전일 신용카드 매출액, 입금 예정액을 푸시 알림과 음성으로 동시에 알려드릴게요.</p>
							<div class="right">
								<a href="#none" class="btn_switch on"><span class="blind">활성</span></a>
								<!--<a href="#none" class="btn_switch"><span class="blind">비활성</span></a>-->
							</div>
						</li>
					</ul>
				</div>
				<!-- //리스트 영역 -->
				<!-- Time Picker -->
				<div class="timePIcker_wrap">
				<!-- 
					<div class="timeType"  style="display:none;">
						<a href="#none" class="btn_prev disabled"><span class="blind">prev</span></a>
						<div class="pickerLy">
							<select class="picker_select" style="display:none;">
								<option value="set_am" selected>오전</option>
								<option value="set_pm">오후</option>
							</select>
						</div>
						<a href="#none" class="btn_next"><span class="blind">next</span></a>
					</div>
				 -->
					<div class="timeSelect" style="margin-left:0;">
						<a href="#none" class="btn_prev"><span class="blind">prev</span></a>
						<div class="pickerLy">
							<select class="picker_select" style="display:none;">
								<!-- 
								<option>01&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>02&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>03&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>04&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>05&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>06&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								-->
								<option>07&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>08&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option selected>09&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>10&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>11&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>12&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>13&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>14&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>15&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>16&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>17&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>18&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>19&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>20&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>21&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>22&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
								<option>23&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;00</option>
							</select>
						</div>
						<a href="#none" class="btn_next"><span class="blind">next</span></a>
					</div>
				</div>
				<!--//Time Picker -->
			</div>
		</div>
	</div>

</div>
<!-- //content -->

<script type="application/javascript">
/* Time Picker */
/* 
$('.timeType .picker_select').drum({
	classes:{'drum-viewport':'drum-2'},
	change:function(event, data){
		$(this).css({"transition":"all 0.13s ease 0.13s"});
		var currentIndex = $(".timeType .drum-item-current").index(".timeType .drum-item");
		$(".timeType .btn_prev").removeClass("disabled");
		if(currentIndex == timeTypeLeth-1){
			$(".timeType .btn_next").addClass("disabled");
		}else{
			if(currentIndex == 0){
				$(".timeType .btn_prev").addClass("disabled");
				$(".timeType .btn_next").removeClass("disabled");
			}else{
				$(".timeType .btn_next").removeClass("disabled");
			}
		}
	}
});
var timeTypeLeth = $(".timeType .drum-item").length;
$(".timeType:eq[0] .btn_next").click(function(){
	var currentIndex = $(".timeType .drum-item-current").index(".timeType .drum-item")+1;
	var positionPick = $(".timeType .drum-item").outerHeight()*currentIndex;
	if(currentIndex != timeTypeLeth){
		$(".timeType .drum-item").removeClass("drum-item-current");
		$(".timeType .drum-item").eq(currentIndex).addClass("drum-item-current");
		$(".timeType .drum-drum").css({"transition":".13s ease .13s",transform:"translate(0,-"+positionPick+"px)"});
		$(".timeType .btn_prev").removeClass("disabled");
		if(currentIndex == timeTypeLeth-1){
			$(this).addClass("disabled");
		}
	}
});
$(".timeType:eq[0] .btn_prev").click(function(){
	var currentIndex = $(".timeType .drum-item-current").index(".timeType .drum-item");
	var positionPick = $(".timeType .drum-item").outerHeight()*(currentIndex-1);
	if(currentIndex != 0){
		$(".timeType .drum-item").removeClass("drum-item-current");
		$(".timeType .drum-item").eq(currentIndex-1).addClass("drum-item-current");
		$(".timeType .drum-drum").css({"transition":".13s ease .13s",transform:"translate(0,-"+positionPick+"px)"});
		$(".timeType .btn_next").removeClass("disabled");
		if(currentIndex == 1){
			$(this).addClass("disabled");
		}
	}
});

//시간
$('.timeSelect .picker_select').drum({
	classes:{'drum-viewport':'drum-2'},
	change:function(event, data){
		$(this).css({"transition":"all 0.13s ease 0.13s"});
		var currentIndex = $(".timeSelect .drum-item-current").index(".timeSelect .drum-item");
		if(currentIndex == timeLeth-1){
			$(".timeSelect .btn_prev").addClass("disabled");
			$(".timeSelect .btn_next").removeClass("disabled");
		}else{
			if(currentIndex == 0){
				 $(".timeSelect .btn_next").addClass("disabled");
				 $(".timeSelect .btn_prev").removeClass("disabled");
			}else{
				$(".timeSelect .btn_prev").removeClass("disabled");
				$(".timeSelect .btn_next").removeClass("disabled");
			}
		}
	}
});

var timeLeth = $(".timeSelect .drum-item").length;

$(".timeSelect .btn_next").click(function(){
	var currentIndex = $(".timeSelect .drum-item-current").index(".timeSelect .drum-item");
	var positionPick = $(".timeSelect .drum-item").outerHeight()*(currentIndex-1);
	if(currentIndex != 0){
		$(".timeSelect .drum-item").removeClass("drum-item-current");
		$(".timeSelect .drum-item").eq(currentIndex-1).addClass("drum-item-current");
		$(".timeSelect .drum-drum").css({"transition":".13s ease .13s",transform:"translate(0,-"+positionPick+"px)"});
		$(".timeSelect .btn_prev").removeClass("disabled");
		if(currentIndex == 1){
			$(this).addClass("disabled");
		}
	}else{

	}
});

$(".timeSelect .btn_prev").click(function(){
	var currentIndex = $(".timeSelect .drum-item-current").index(".timeSelect .drum-item")+1;
	var positionPick = $(".timeSelect .drum-item").outerHeight()*currentIndex;
	if(currentIndex != timeLeth){
		$(".timeSelect .drum-item").removeClass("drum-item-current");
		$(".timeSelect .drum-item").eq(currentIndex).addClass("drum-item-current");
		$(".timeSelect .drum-drum").css({"transition":".13s ease .13s",transform:"translate(0,-"+positionPick+"px)"});
		$(".timeSelect .btn_next").removeClass("disabled");
		if(currentIndex == timeLeth-1){
			$(this).addClass("disabled");
		}
	}else{
	}
}); */
const timeTypeLeth = 2;
$('.timeType .picker_select').drum({
	classes:{'drum-viewport':'drum-2'},
	change:function(event, data){
		
		let _timeType = $(this).parents(".timeType");
		$(this).css({"transition":"all 0.13s ease 0.13s"});
		var currentIndex = $(_timeType).find(".drum-item-current").index();
		$(_timeType).find(".btn_prev").removeClass("disabled");
		if(currentIndex == timeTypeLeth-1){
			$(_timeType).find(".btn_prev").removeClass("disabled");
			$(_timeType).find(".btn_next").addClass("disabled");
		}else if(currentIndex == 0){
				$(_timeType).find(".btn_prev").addClass("disabled");
				$(_timeType).find(".btn_next").removeClass("disabled");
		}else{
			$(_timeType).find(".btn_prev").removeClass("disabled");
			$(_timeType).find(".btn_next").removeClass("disabled");
		}
	}
});
$(".timeType .btn_next").click(function(){
	let _timeType = $(this).parent();
	let currentIndex = $(_timeType).find(".drum-item-current").index()+1;
	let positionPick = $(_timeType).find(".drum-item").outerHeight()*currentIndex;
	if(currentIndex != timeTypeLeth){
		$(_timeType).find(".drum-item").removeClass("drum-item-current");
		$(_timeType).find(".drum-item").eq(currentIndex).addClass("drum-item-current");
		$(_timeType).find(".drum-drum").css({"transition":".13s ease .13s",transform:"translate(0,-"+positionPick+"px)"});
		$(_timeType).find(".btn_prev").removeClass("disabled");
		if(currentIndex == timeTypeLeth-1){
			$(this).addClass("disabled");
		}else{
			$(this).removeClass("disabled");
		}
	}
});
$(".timeType .btn_prev").click(function(){
	let _timeType = $(this).parent();
	let currentIndex = $(_timeType).find(".drum-item-current").index();
	let positionPick = $(_timeType).find(".drum-item").outerHeight()*(currentIndex-1);
	if(currentIndex != 0){
		$(_timeType).find(".drum-item").removeClass("drum-item-current");
		$(_timeType).find(".drum-item").eq(currentIndex-1).addClass("drum-item-current");
		$(_timeType).find(".drum-drum").css({"transition":".13s ease .13s",transform:"translate(0,-"+positionPick+"px)"});
		$(_timeType).find(" .btn_next").removeClass("disabled");
		if(currentIndex == 1){
			$(this).addClass("disabled");
		}else{
			$(this).removeClass("disabled");
		}
	}
});

//시간
const timeLeth = 17; 
$('.timeSelect .picker_select').drum({
	classes:{'drum-viewport':'drum-2'},
	change:function(event, data){
		let _timeSelect = $(this).parents(".timeSelect");
		$(this).css({"transition":"all 0.13s ease 0.13s"});
		var currentIndex = $(_timeSelect).find(".drum-item-current").index();
		if(currentIndex == timeLeth-1){
			$(_timeSelect).find(".btn_prev").addClass("disabled");
			$(_timeSelect).find(".btn_next").removeClass("disabled");
		}else{
			if(currentIndex == 0){
				$(_timeSelect).find(".btn_next").addClass("disabled");
				$(_timeSelect).find(".btn_prev").removeClass("disabled");
			}else{
				$(_timeSelect).find(".btn_prev").removeClass("disabled");
				$(_timeSelect).find(".btn_next").removeClass("disabled");
			}
		}
	}
});
$(".timeSelect .btn_next").click(function(){
	let _timeSelect = $(this).parent();
	let currentIndex = $(_timeSelect).find(".drum-item-current").index();
	let positionPick = $(".timeSelect .drum-item").outerHeight()*(currentIndex-1);
	if(currentIndex !== 0){
		$(_timeSelect).find(".drum-item").removeClass("drum-item-current");
		$(_timeSelect).find(".drum-item").eq(currentIndex-1).addClass("drum-item-current");
		$(_timeSelect).find(".drum-drum").css({"transition":".13s ease .13s",transform:"translate(0,-"+positionPick+"px)"});
		$(_timeSelect).find(".btn_prev").removeClass("disabled");
		if(currentIndex === 1){
			$(this).addClass("disabled");
		}
	}
})
$(".timeSelect .btn_prev").click(function(){
	let _timeSelect = $(this).parent();
	let currentIndex = $(_timeSelect).find(".drum-item-current").index()+1;
	let positionPick = $(".timeSelect .drum-item").outerHeight()*(currentIndex);
	if(currentIndex != timeLeth){
		$(_timeSelect).find(".drum-item").removeClass("drum-item-current");
		$(_timeSelect).find(".drum-item").eq(currentIndex).addClass("drum-item-current");
		$(_timeSelect).find(".drum-drum").css({"transition":".13s ease .13s",transform:"translate(0,-"+positionPick+"px)"});
		$(_timeSelect).find(".btn_next").removeClass("disabled");
		if(currentIndex == timeLeth-1){
			$(this).addClass("disabled");
		}
	}else{
	}
});
/* //Time Picker */

</script>

</body>
</html>
