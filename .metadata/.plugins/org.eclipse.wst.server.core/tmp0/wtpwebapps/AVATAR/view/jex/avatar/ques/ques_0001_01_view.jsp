<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%@page import="com.avatar.session.SessionManager"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    
    //GET SESSION
	JexDataCMO UserSession = SessionManager.getSession(request, response);
    String APP_ID = StringUtil.null2void((String)UserSession.get("APP_ID"));
    String LGIN_APP = StringUtil.null2void((String)UserSession.get("LGIN_APP"), "AVATAR");
    String CLPH_NO = StringUtil.null2void((String)UserSession.get("CLPH_NO"));
    String CUST_NM = StringUtil.null2void((String)UserSession.get("CUST_NM"));
    //LGIN_APP = "ZEROPAY";
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_0001_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김별 (  )
 * @Description      : 질의예시목록
 * @History          : 20200203095309, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0001_01.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0001_01.js
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
    <script type="text/javascript" src="/js/jex/avatar/ques/ques_0001_01.js?<%=_CURR_DATETIME%>"></script>
    <script type="text/javascript" src="/js/jex/avatar/comm/slide_slick.js?<%=_CURR_DATETIME%>"></script>
    <style>
    	.banner_slideMN:after{height:unset;}
    </style>
</head>
<script>
	var _APP_ID = '<%=APP_ID%>';
	var LGIN_APP = '<%=LGIN_APP%>';
	var CLPH_NO = '<%=CLPH_NO%>';
	var CUST_NM = '<%=CUST_NM%>';
</script>

<body  class="bg_F5F5F5" >

<!-- content -->
<div class="content m_cont_pd25">
 <!-- style="display:none;" -->
	<% if("AVATAR".equals(LGIN_APP)) {%>
	<div class="m_cont pdb100"><!-- 하단 버튼 있는경우 m_cont_pd 추가 --><!-- 하단에 마이크버튼 있는경우 pdb100 추가 -->
		<!-- 데이터 연결 -->
		<div class="banner_aAWrap" style="display:none;">
			<div class="banner_aAinner">
				<h2>
					<span id=""><%=CUST_NM %></span>님의<br>
					어제 매출은 얼마일까요?
				</h2>
				<a href="#none" id="dataConnect">데이터 연결하기</a>
			</div>
		</div>
		<!-- 데이터 연결 -->
		
		<!-- 개인 맞춤 영역 -->
		<!-- <div id="ques_dv1" class="banner_slide_freQues swiper-container" data-app_id="AVATAR">
			<div class="swiper-wrapper">
			
				<div class="sect_freQues1 swiper-slide">
					<div class="cont_pd type4">
						<div class="inter_area type3" id="myFreqQues">
							<strong class="type1">내가 자주하는 질문</strong>
							<ul name="quesList"></ul>
						</div>
					</div>
				</div>
 							
				<div class="sect_freQues2 swiper-slide">
					<div class="cont_pd type4">
						<div class="inter_area type3" id="myRecentQues">
							<strong class="type2">질문 모아보기</strong>
							<ul>
							</ul>
							<div class="right"><a href="#none" class="bt_more">더보기</a></div>
						</div>
					</div>
				</div>
				<div class="sect_freQues3 swiper-slide">
					<div class="cont_pd type4">
						<div class="inter_area type3" id="myUnansweredQues">
							<strong class="type3">답변받지 못한 질문</strong>
							<ul>
							</ul>
							<div class="right"><a href="#none" class="bt_more">더보기</a></div>
						</div>
					</div>
				</div>
			</div>
			Pagination
			<div class="swiper-pagination"></div>
			Pagination
		</div> -->
		<!-- //개인 맞춤 영역 -->
		<!-- 배너 영역 -->
		<div class="banner_slideMN slideMN30 swiper-container banner_dataY"  data-app_id="AVATAR" style="display:none;">
			<div class="swiper-wrapper">
				<div class="sectMN31 swiper-slide">
					<div class="sect_inn">
						<a href="#none" id="AVATAR_banner1_1"><img src="../img/m_bnnrMN310.png" alt=""></a>
					</div>
				</div>
				<div class="sectMN32 swiper-slide">
					<div class="sect_inn">
						<a href="#none" id="AVATAR_banner1_3"><img src="../img/m_bnnrMN320.png" alt=""></a>
					</div>
				</div>
			</div>
			<!-- Pagination -->
			<div class="swiper-pagination"></div>
			<!-- Pagination -->
		</div>
		<!-- //배너 영역 -->
		<!-- 음성으로 업무을 간편하게! -->
		<div id="ques_dv3" class="ai_list_v type4" data-app_id="AVATAR" style="display:none;">
			<div class="tit">
				<div class="left">
					<p><span class="c_793FFB">음성</span>으로 업무을 간편하게!</p>
				</div>
				<div class="right"></div>
			</div>
			<div class="briefing_linkBx" id="AVATAR_bref">
				<a href="#none" class="bt_briefing">
					<p class="txt">
						카드 매출 브리핑 받기
					</p>
				</a>
			</div>
			<ul id="call_cont" class="allQues2 type3 caseTop">
				<li>
					<dl>
						<dt>
							<p><img src="../img/ic_tel2.png" alt="전화"></p>
						</dt>
						<dd>
							<ul>
								<li id="call_move"><a href="#">“전화해줘”</a></li>
								<li id="sms_move"><a href="#">“문자보내줘”</a></li>
							</ul>
						</dd>
					</dl>
				</li>
			</ul>
		</div>
		<!-- //음성으로 업무을 간편하게! -->
		
		<!-- 질문 -->
		<!-- <div id="ques_dv2" class="askAvatar_mBx type1" data-app_id="ZEROPAY" style="display:none;">
			<ul>
				<li style="display:none;">
					<a href="#none" class="disable">
						<span class="ic ic_02"></span>
						<span class="tx">자주 찾는 질문을 말해보세요!</span>
					</a>
					<div class="askAvatar_sub" id="freqQues" name="quesList">
						<ul></ul>
					</div>
				</li>
				<li>
					<a href="#none" class="disable">
						<span class="ic ic_03"></span>
						<span class="tx">제로페이 질문</span>
					</a>
					<div class="askAvatar_sub" id="zpQues" name="quesList">
						<ul>
						</ul>
					</div>
				</li>
				<li style="display:none;">
					<a href="#none" class="disable">
						<span class="ic ic_05"></span>
						<span class="tx">경리나라 질문</span>
					</a>
					<div class="askAvatar_sub2" id="serpQues" name="quesList">
						<ul>
						</ul>
						<div class="center"><a href="#none" class="bt_more"><span>더보기</span></a></div>
					</div>
				</li>
			</ul>
		</div> -->
		<!-- //질문 -->	
		
		<!-- 질의 리스트영역 -->
		<div class="ai_list_v type4" data-app_id="AVATAR" style="display:none;">
			<div class="tit">
				<div class="left">
					<p>전체 질문 보기</p>
				</div>
				<div class="right"></div>
			</div>
			<ul class="allQues2 type3 allQues" name="quesList" data-ctgr_cd="1000" id="1000">
				<li>
					<dl>
						<dt>
							<p><img src="../img/ic_bank2.png" alt=""></p>
							<p>은행</p>
						</dt>
						<dd>
							<ul></ul>
						</dd>
					</dl>
				</li>
			</ul>
			<ul class="allQues2 type3 allQues" name="quesList" data-ctgr_cd="2000" id="2000">
				<li>
					<dl>
						<dt>
							<p><img src="../img/ic_tax2.png" alt=""></p>
							<p>세금계산서</p>
						</dt>
						<dd>
							<ul></ul>
						</dd>
					</dl>
				</li>
			</ul>
			<ul class="allQues2 type3 allQues" name="quesList" data-ctgr_cd="3000" id="3000">
				<li>
					<dl>
						<dt>
							<p><img src="../img/ic_cash_recpt2.png" alt=""></p>
							<p>현금영수증</p>
						</dt>
						<dd>
							<ul></ul>
						</dd>
					</dl>
				</li>
			</ul>
			<ul class="allQues2 type3 allQues" name="quesList" data-ctgr_cd="4000" id="4000">
				<li>
					<dl>
						<dt>
							<p><img src="../img/ic_corp2.png" alt=""></p>
							<p>법인카드</p>
						</dt>
						<dd>
							<ul></ul>
						</dd>
					</dl>
				</li>
			</ul>
			<ul class="allQues2 type3 allQues" name="quesList" data-ctgr_cd="5000" id="5000">
				<li>
					<dl>
						<dt>
							<p><img src="../img/ic_cred_card2.png" alt=""></p>
							<p>신용카드</p>
						</dt>
						<dd>
							<ul></ul>
						</dd>
					</dl>
				</li>
			</ul>
			<ul class="allQues2 type3 allQues" name="quesList" data-ctgr_cd="6000" id="6000">
				<li>
					<dl>
						<dt>
							<p><img src="../img/ic_sales2.png" alt=""></p>
							<p>매출/매입</p>
						</dt>
						<dd>
							<ul></ul>
						</dd>
					</dl>
				</li>
			</ul>
			<ul class="allQues2 type3 allQues" name="quesList" data-ctgr_cd="6100" id="6100">
				<li>
					<dl>
						<dt>
							<p><img src="../img/ic_online2.png" alt=""></p>
							<p>온라인매출</p>
						</dt>
						<dd>
							<ul></ul>
						</dd>
					</dl>
				</li>
			</ul>
			<ul class="allQues2 type3 allQues" name="quesList" data-ctgr_cd="8000" id="8000">
				<li>
					<dl>
						<dt>
							<p><img src="../img/ic_taxation2.png" alt=""></p>
							<p>세무</p>
						</dt>
						<dd>
							<ul></ul>
						</dd>
					</dl>
				</li>
			</ul>
			<ul class="allQues2 type3 allQues" name="quesList" data-ctgr_cd="7000" id="7000">
				<li>
					<dl>
						<dt>
							<p><img src="../img/ic_account2.png" alt=""></p>
							<p>거래처</p>
						</dt>
						<dd>
							<ul></ul>
						</dd>
					</dl>
				</li>
			</ul>
			<ul class="allQues2 type3 allQues" name="quesList" data-ctgr_cd="9998" style="display:none">
				<li>
					<dl>
						<dt>
							<p><img src="../img/ic_custom2.png" alt=""></p>
							<p>맞춤질의</p>
						</dt>
						<dd>
							<ul></ul>
						</dd>
					</dl>
				</li>
			</ul>
		</div>
		<!-- //질의 리스트영역 -->
		<!-- 배너 영역 -->
		<div class="banner_slideMN slideMN20 swiper-container MN20 mgt30"  data-app_id="AVATAR" style="display:none;">
			<div class="swiper-wrapper MN20">
<!-- 				<div class="sectMN22 swiper-slide"> -->
<!-- 					<div class="sect_inn" id="AVATAR_banner2_2"> -->
<!-- 						<a href="#none"><img src="../img/m_bnnrMN220.png" alt="사장님, 이렇게 물어보세요. - “제로페이 매출액 얼마야?”"></a> -->
<!-- 					</div> -->
<!-- 				</div> -->
				<div class="sectMN21 swiper-slide">
					<div class="sect_inn" id="AVATAR_banner2_1">
						<a href="#none"><img src="../img/m_bnnrMN210.png" alt="“오늘 돈 들어왔어?” - 실시간 매출이 궁금하다면? 물어봐! 경리나라 avatar"></a>
					</div>
				</div>
			</div>
			<!-- Pagination -->
			<div class="swiper-pagination"></div>
			<!-- Pagination -->
		</div>
		<!-- //배너 영역 -->
	</div>
	
	<% } else if(LGIN_APP.indexOf("SERP") > -1) { %>
	<!-- 경리나라 -->
	<div class="m_cont pdb100"><!-- 하단 버튼 있는경우 m_cont_pd 추가 --><!-- 하단에 마이크버튼 있는경우 pdb100 추가 -->
		<div class="banner_outBx" data-app_id="SERP" >
			<div class="banner_kyungrinara">
				<a>
					<div class="bk_inn">
						<div class="left">
							<span class="tx_tip">Tip</span>
							<h3>
								<small>경리나라 고객을 위한</small><br>
								<span class="bg">아바타</span> 잘 쓰는 법~!
							</h3>
							<span class="bt_more">지금 보러가기</span>
						</div>
						<div class="right"></div>
					</div>
				</a>
			</div>
		</div>
		<!-- //배너 영역 -->
		
		<div class="ai_list_v type3 bbn" data-app_id="SERP" >
			<div class="tit">
				<div class="left">
					<p>이렇게 질문해보세요</p>
				</div>
				<div class="right">
				</div>
			</div>
			<div class="sub first" id="serpQues_SERP">
				<ul id="SERP">
				</ul>
			</div>
		</div>
	</div>
	<!-- //경리나라 -->
	<!-- 제로페이 -->
	<% } else if("ZEROPAY".equals(LGIN_APP)){ %>
	<!-- 배너 영역 -->
	<div class="banner_slideMN slideMN30 swiper-container">
		<div class="swiper-wrapper">
			<div class="sectMN33 swiper-slide">
				<div class="sect_inn">
					<a href="#none" id="AVATAR_banner2_2"><img src="../img/m_bnnrMN330.png" alt=""></a>
				</div>
			</div>
		</div>
		<!-- Pagination -->
		<div class="swiper-pagination"></div>
		<!-- Pagination -->
	</div>
	<!-- //배너 영역 -->
	<!-- 음성으로 업무을 간편하게! -->
	<div id="ques_dv3" class="ai_list_v type4">
		<div class="tit">
			<div class="left">
				<p><span class="c_793FFB">음성</span>으로 업무을 간편하게!</p>
			</div>
			<div class="right"></div>
		</div>
		<div class="briefing_linkBx" id="AVATAR_bref">
			<a href="#none" class="bt_briefing">
				<p class="txt">
					제로페이 매출 브리핑 받기
				</p>
			</a>
		</div>
		<ul class="allQues2 type3 caseTop">
				<li>
					<dl>
						<dt>
							<p><img src="../img/ic_tel2.png" alt="전화"></p>
						</dt>
						<dd name="quesList">
							<ul>
								<li intent="NNN019"><a href="#">“세무사 추천/연결해줘”</a></li>
								<li intent="NNN020"><a href="#">“000 세무사 전화해줘”</a></li>
							</ul>
						</dd>
					</dl>
				</li>
			</ul>
	</div>
	<!-- //음성으로 업무을 간편하게! -->
	<!-- 질문 -->
	<div class="askAvatar_mBx type1 mgt10">
		<ul>
			<li>
				<a href="#none" class="disable">
					<span class="ic ic_03"></span>
					<span class="tx">제로페이 질문</span>
				</a>
				<div class="askAvatar_sub" id="zpQues" name="quesList">
					<ul>
					</ul>
				</div>
			</li>
		</ul>
	</div>
	<!-- //질문 -->
	<!-- //제로페이 -->
	<% } %>
</div>
<!-- //content -->

<!-- modal overlay -->
<div class='modaloverlay' id='cert_modal' style="display : none;">
	<div class='lytb'><div class='lytb_row'><div class='lytb_td'>
	<div class='layer_style1'>
		<div class='layer_po'>
			<div class='cont'>
				<div class='lyp_tit'>
					공동인증서 유효기간이 만료일부터<br /><span class='c_red'><span id='cert_dt'>30</span>일</span> 남았습니다.<br />
					공동인증서는 유효기간 만료일 30일전<br />부터 갱신이 가능합니다.
				</div>
			</div>
		</div>
		<div class='ly_btn_fix_botm btn_both'><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->
			<a class='btn_pop off' onClick='certClose1()'>닫기</a>
			<a class='btn_pop' onClick='certClose1()'>오늘 하루 보지 않기</a>
			<!-- <a class='btn_pop' onClick='certWeekClose1()'>일주일 간 보지 않기</a> -->
		</div>
	</div>
	</div></div></div>
</div>
<!-- //modal overlay -->
	
<!-- modal overlay -->
<div class='modaloverlay' id='cert_modal2' style="display : none;">
	<div class='lytb'><div class='lytb_row'><div class='lytb_td'>
	<div class='layer_style1'>
		<div class='layer_po'>
			<div class='cont'>
				<div class='lyp_tit'>
					[공동인증서 유효기간 <span class='c_red'>만료</span>]<br /><br />
					정확한 데이터 조회를 위해<br />
					공동인증서를 갱신해주세요!
				</div>
			</div>
		</div>
		<div class='ly_btn_fix_botm btn_both'><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->
			<a class='btn_pop off' onClick='certClose2()'>닫기</a>
			<a class='btn_pop' onClick='_thisPage.fn_reCert()'>인증서 갱신하기</a>
		</div>
	</div>
	</div></div></div>
</div>
<!-- //modal overlay -->

<!-- modal overlay -->
<div class='modaloverlay' id='serp_modal' style="display : none;">
	<div class='lytb'><div class='lytb_row'><div class='lytb_td'>
	<div class='layer_style1'>
		<div class='layer_po'>
			<div class='cont'>
				<div class='lyp_tit'>
					경리나라 연결 정보가 변경되어<br /> 연결이 해제되었습니다.<br />
					<span class='c_blue'>경리나라 연결하기</span>를 통해<br /> 다시 연결해 주시기 바랍니다. 
				</div>
			</div>
		</div>
		<div class='ly_btn_fix_botm btn_both'><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->
			<a class='btn_pop off' onClick='serpClose()'>취소</a>
			<a class='btn_pop' onClick='_thisPage.fn_reSerp()'>경리나라 연결하기</a>
		</div>
	</div>
	</div></div></div>
</div>
<!-- //modal overlay -->

<!-- modal overlay -->
<div class='modaloverlay' id='info_modal' style="display : none;">
	<div class='lytb'><div class='lytb_row'><div class='lytb_td'>
	<div class='layer_style1'>
		<div class='layer_po'>
			<div class='cont'>
				<div class='lyp_tit'>
					본인신용정보관리업 관련 법 시행에 따라<br /><span class='c_blue'>개인뱅킹</span> 계좌 조회가 중지됩니다.<br /><br />
					<span class='c_blue'>기업뱅킹</span> 계좌는 정상적으로 조회되오니<br />
					서비스 이용에 참고 부탁 드립니다.<br />
					감사합니다.
				</div>
			</div>
		</div>
		<div class='ly_btn_fix_botm'>
			<a class='btn_pop' onClick='infoCloseWin()'>확인</a>
		</div>
	</div>
	</div></div></div>
</div>
<!-- //modal overlay -->

<!-- modal overlay -->
<div class='modaloverlay' id='info_voic' style="display : none;">
	<div class="lytb"><div class="lytb_row"><div class="lytb_td type3">
		<!-- layerpopup -->
		<div class="layer_style1">
			<div class="layer_po">
				<div class="cont3">
					<div class="lyp_tit3">
						<p>
							<strong>아바타</strong>에서 질문하면<br>
							<strong><span class="">음성</span>으로 답변을 받아볼 수 있어요!</strong>
						</p>
					</div>
					<div class="cboth lyp_txt5">
						<img src="../img/im_m007.png" alt="" class="imAuto">
						<p>※ 음성답변을 원치 않으시면 메뉴&gt;음성설정을 OFF로 변경해주세요!</p>
					</div>
				</div>
			</div>
			<div class="ly_btn_fix_botm type3">
				<a onClick='voicClose()'>닫기</a>
			<!-- 
				<a class='btn_pop off' onClick='voicClose()'>취소</a>
				<a class='btn_pop' onClick='_thisPage.fn_voicSett()'>설정하러 가기</a>
			-->
			</div>
		</div>
	<!-- //layerpopup -->
	</div></div></div>
</div>
<!-- //modal overlay -->

<!-- modal overlay -->
<div class="modaloverlay" id='selInfo_voic' style="display : none;">
	<div class="lytb"><div class="lytb_row"><div class="lytb_td type3">
	<!-- layerpopup -->
	<div class="layer_style1">
		<div class="layer_po">
			<div class="cont3">
				<div class="lyp_tit3">
					<p>
						사장님, 이제 <strong>전용비서 아바타</strong>가<br>
						매일 <strong><span c"">매출액</span></strong>을 알려드릴게요!
					</p>
				</div>
				<div class="cboth lyp_txt5">
					<img src="../img/im_z017.png" alt="" class="imAuto">
					<p>※ 음성답변을 원치 않으시면 메뉴&gt;음성설정을 OFF로 변경해주세요!</p>
				</div>
			</div>
		</div>
		<div class="ly_btn_fix_botm type3">
			<a onClick='voicSelClose()'>닫기</a>
		</div>
	</div>
	<!-- //layerpopup -->
	</div></div></div>
</div>
<!-- //modal overlay -->
	
</body>
<script>
/* $(document).ready(function(){
	$(".js_controll ul").css({"max-height":"164px","overflow":"hidden"});
	$(".btn_drop.open").click(function(){
		if($(this).hasClass("open")){
			$(this).addClass("close");
			$(this).removeClass("open");
			$(".js_controll ul").css("max-height","100%");
		}else{
			$(this).addClass("open");
			$(this).removeClass("close");
			$(".js_controll ul").css("max-height","164px");
		}
	});
	
	var swiper1 = new Swiper('.banner_slide_freQues', {
		pagination:{
			el: '.swiper-pagination',
			clickable: true,
		},
		on:{
			init: function () {
			const numberOfSlides = this.slides.length;
				if(numberOfSlides == 1){
					$(this).find(".swiper-pagination").hidden();
				}
			}
		},
	});
	
	var swiper = new Swiper('.banner_slideMN', {
		pagination:{
			el: '.swiper-pagination',
			clickable: true,
		},
		on:{
			init: function () {
			const numberOfSlides = this.slides.length;
				if(numberOfSlides == 1){
					$(this).find(".swiper-pagination").hidden();
				}
			}
		},
		autoplay:{
			delay:2500,
		},
	});
	
}) */
</script>
</html>
