<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String BANK_CD = StringUtil.null2void(request.getParameter("BANK_CD"));
    String BANK_NM = StringUtil.null2void(request.getParameter("BANK_NM"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : acct_0001_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/acct
 * @author           : 김태훈 (  )
 * @Description      : 은행별 계좌 목록 화면
 * @History          : 20200116151257, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/acct/acct_0001_01.js
 * @JavaScript Url   : /js/jex/avatar/acct/acct_0001_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/acct/acct_0001_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5">
<input type="hidden" id="BANK_CD" value="<%=BANK_CD%>" />
<input type="hidden" id="BANK_NM" value="<%=BANK_NM%>" />
	<!-- content -->
	<div class="content pdb0">

		<div class="m_cont"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<!-- 계좌 리스트 -->
			<div class="acc_cbx">
				<div class="acc_cbx_in">
					<dl>
						<dt>
							<div class="tit"><%=BANK_NM %></div>
						</dt>
						<dd>
							<div class="acc_cbx_cn">
								<ul class="cbx_switch" id="ul_list">
									<%--
									<li>
										<div class="left">
											<div class="acc_tit">
												기업은행(기업용계좌)
											</div>
											<div class="acc_txt">1234-5678-12345-12</div>
										</div>
										<div class="btn"><a class="btn_arr"></a></div>
									</li>
									<li>
										<div class="left">
											<div class="acc_tit">
												NH농협(사업자전용계좌)
												<span class="cntalign">
													<a class="btn_t01 on">조회실패</a>
												</span>
											</div>
											<div class="acc_txt">1234-5678-12345-12</div>
										</div>
										<div class="btn"><a class="btn_arr"></a></div>
									</li>
									<li>
										<div class="left">
											<div class="acc_tit">
												NH농협(NH성공파트너통장)
											</div>
											<div class="acc_txt">1234-5678-12345-12</div>
										</div>
										<div class="btn"><a class="btn_arr"></a></div>
									</li>
									 --%>
								</ul>
							</div>
						</dd>
					</dl>
				</div>
			</div>
			<!-- //계좌 리스트 -->

		</div>
		
		<!-- 하단 fix버튼 -->
		<div class="btn_fix_botm"><!-- 버튼 2개인 경우 btn_both 클래스 추가 -->
			<div class="inner">
				<a id="a_enter">확인</a>
			</div>
		</div>
		<!-- //하단 fix버튼 -->

	</div>
	<!-- //content -->

</body>
</html>