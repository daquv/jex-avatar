<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    //GET SESSION
	JexDataCMO UserSession = SessionManager.getSession(request, response);
    String CUST_NM = StringUtil.null2void((String)UserSession.get("CUST_NM"));
    String CLPH_NO = StringUtil.null2void((String)UserSession.get("CLPH_NO"));
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
 * @File Name        : basic_0004_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 김태훈 (  )
 * @Description      : 더보기-프로필
 * @History          : 20200205091934, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0004_01.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0004_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/basic/basic_0004_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<style>
	a {
	-webkit-tap-highlight-color: rgba(0,0,0,0);
	-webkit-tap-highlight-color: transparent;
	},
</style>
<body class="bg_F5F5F5">
<input type="hidden" value="<%=CLPH_NO.trim() %>">
	<!-- content -->
	<div class="content">

		<div class="m_cont pdt12" id="main">
			<div class="m_bx_wrap">
				<!-- 더보기 상단 -->
<!-- 					<div class="m_prp_topBx"> -->
<!-- 						<div class="inner"> -->
<!-- 							<ul> -->
<!-- 								<li> -->
<!-- 									<a href="#none"> -->
<!-- 										<dl> -->
<!-- 											<dt><img src="../img/ico_m_prp_topBx_01.png" alt=""></dt> -->
<!-- 											<dd><p>질문 모아보기</p></dd> -->
<!-- 										</dl> -->
<!-- 									</a> -->
<!-- 								</li> -->
<!-- 								<li> -->
<!-- 									<a href="#none"> -->
<!-- 										<dl> -->
<!-- 											<dt><img src="../img/ico_m_prp_topBx_02.png" alt=""></dt> -->
<!-- 											<dd><p>답변 받지 못한 질문</p></dd> -->
<!-- 										</dl> -->
<!-- 									</a> -->
<!-- 								</li> -->
<!-- 							</ul> -->
<!-- 						</div> -->
<!-- 					</div> -->
				<!-- //더보기 상단 -->
				<!-- 리스트 영역 -->
				<div class="m_prp_list nobline type2">
					<ul>
						<!-- (add)20210517 -->
						<% //if(!"SERP".equals(APP_ID)) {%>
						<% if("AVATAR".equals(LGIN_APP)) {%>
							<li>
								<h2 class="prp05">암호사용</h2>
								<div class="right">
									<a href="#none" class="btn_switch on"><span class="blind">활성</span></a>
									<!--<a href="#none" class="btn_switch"><span class="blind">비활성</span></a>-->
								</div>
							</li>
						<% } else {}%>
						<!-- //(add)20210517 -->
						<li id="a_cust_nm">
							<h2 class="prp05">이름</h2>
							<div class="right">
								<a hre4f="#none" class="btn_arr"><%="".equals(CUST_NM)?"이름을 입력하세요":CUST_NM %></a>
							</div>
						</li>
						<li id="a_clph_no">
							<h2 class="prp02">휴대폰번호</h2>
							<div class="right">
								<a href="#none" class="btn_arr"><%=CLPH_NO.trim() %></a>
							</div>
						</li>
						<!-- 2021-01-06 -->
						<li id="a_bsnn_nm">
							<h2 class="prp01">회사명</h2>
							<div class="right">
								<a href="#none" class="btn_arr"></a>
							</div>
						</li>
						<!-- //2021-01-06 -->
						<% //if(!"SERP".equals(APP_ID)) {%>
						<% if("AVATAR".equals(LGIN_APP)) {%>
				    		<li id="a_patten">
								<h2 class="prp03">패턴재설정</h2>
								<div class="right">
									<a href="#none" class="btn_arr"></a>
								</div>
							</li>
							<!-- 
							<li id="a_logout">
								<h2 class="prp04">로그아웃</h2>
								<div class="right">
									<a href="#none" class="btn_arr"></a>
								</div>
							</li>
							-->
						<% } else {}%>
							<li id="a_trmn">
								<h2 class="prp04">서비스탈퇴</h2>
								<div class="right">
									<a href="#none" class="btn_arr"></a>
								</div>
							</li>
		    			
		    			<% if("01025999667".equals(CLPH_NO) || "01028602673".equals(CLPH_NO)) {%>
							<!-- <li id="_TEST">
								<h2 class="prp04">메모_테스트</h2>
								<div class="right">
									<a href="#" class="btn_arr"></a>
								</div>
							</li> -->
						<% } else {}%>
					</ul>
				</div>
				<!-- //리스트 영역 -->

			</div>
		</div>
		
		<div class="m_cont m_cont_pd cont_custNm" name="mod_pop" style="display: none;"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<div class="cont_pd" style="padding-top:14px;">
				<!-- 타이틀 -->
				<div class="tit_wrap">
					<h2>이름을 입력해주세요.</h2>
				</div>
				<!-- //타이틀 -->
				<!-- 입력영역 -->
				<div class="input_wrap" style="margin:-6px 0 0;">
					<table>
						<colgroup><col></colgroup>
						<tbody>
							<tr>
								<td>
									<div class="input_type"><!-- 활성화클래스 on -->
										<input type="text" placeholder="" value="<%=CUST_NM %>" maxlength="15" id="inp_custNm">
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- //입력영역 -->
				<!-- 하단문구 -->
				<p class="info_txt2 add_ico"><span class="ico">※</span> 이름은 최대 15자입니다.</p>
				<!-- //하단문구 -->
			</div>
		</div>

		<!-- 하단 fix버튼 -->
		<div class="btn_fix_botm cont_custNm" name="mod_pop" style="display: none;">
			<div class="inner">
				<a id="a_mod">변경하기</a>
			</div>
		</div>
		<!-- //하단 fix버튼 -->


		<div class="m_cont m_cont_pd cont_bsnnNm" name="mod_pop" style="display: none;"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<div class="cont_pd" style="padding-top:14px;">
				<!-- 타이틀 -->
				<div class="tit_wrap">
					<h2>회사명을 입력해주세요.</h2>
				</div>
				<!-- //타이틀 -->
				<!-- 입력영역 -->
				<div class="input_wrap" style="margin:-6px 0 0;">
					<table>
						<colgroup><col></colgroup>
						<tbody>
							<tr>
								<td>
									<div class="input_type"><!-- 활성화클래스 on -->
										<input type="text" placeholder="" maxlength="15" id="inp_bsnnNm">
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- //입력영역 -->
				<!-- 하단문구 -->
				<p class="info_txt2 add_ico"><span class="ico">※</span> 회사명은 최대 15자입니다.</p>
				<!-- //하단문구 -->
			</div>
		</div>

		<!-- 하단 fix버튼 -->
		<div class="btn_fix_botm cont_bsnnNm" name="mod_pop" style="display: none;">
			<div class="inner">
				<a id="a_mod">변경하기</a>
			</div>
		</div>
		<!-- //하단 fix버튼 -->
	</div>
	<!-- //content -->

</body>
</html>