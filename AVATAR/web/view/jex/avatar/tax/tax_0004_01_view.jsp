<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                      
    // Action 결과 추출
    String TAX_GB = StringUtil.null2void(request.getParameter("TAX_GB"),"etaxcash");
  
    //GET SESSION
  	JexDataCMO UserSession = SessionManager.getSession(request, response);
    String USE_INTT_ID = StringUtil.null2void((String)UserSession.get("USE_INTT_ID"));
    
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : tax_0004_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/tax
 * @author           : 박지은 (  )
 * @Description      : 홈택스 증빙 화면
 * @History          : 20210521152255, 박지은
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/tax/tax_0004_01.js
 * @JavaScript Url   : /js/jex/avatar/tax/tax_0004_01.js
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
	 <script>
    var _USE_INTT_ID = '<%=USE_INTT_ID%>';
	</script>
	<script type="text/javascript" src="/js/jex/avatar/tax/tax_0004_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5">
<input type="hidden" id="TAX_GB" name="TAX_GB" value="<%=TAX_GB %>">
<!-- content -->
<div class="content">

	<div class="tabs_wrap">
		<div class="tabs_header type2">
			<ul class="full cboth">
				<li class="cols60 js_tabclickDp2"><a href="#none"><span>세금계산서∙현금영수증</span></a></li>
				<li class="cols40 js_tabclickDp2"><a href="#none"><span>세액 내역</span></a></li>
			</ul>
		</div>
		<div class="tabs_body_wrap">
			<!-- 세금계산서∙현금영수증 -->
			<div id="etaxcash_tab" class="tabs_body type2 cboth" style="display:none;">
				<div id="etaxcash_none" class="tab_cnt" style="display:none;">
					<div class="m_cont">
						<div class="set_bx_wrap type2">
							<dl>
								<dt><p class="tit">※  공동인증서 등록이 필요합니다.</p></dt>
							</dl>
						</div>
					</div>

					<!-- 버튼영역 -->
					<div id="etaxcash_reg_btn" class="btn_add2 mgt200">
						<a class="btn_s01 type2">공동인증서 등록하기</a>
					</div>
					<!-- //버튼영역 -->
				</div>
				<div id="etaxcash_info" class="tab_cnt" style="display:none;">
					<div class="m_cont">
						<div class="set_bx_wrap type2">
							<dl>
								<dt><p class="tit">등록된 공동 인증서</p></dt>
								<dd>
									<div class="certi01">
										<span class="ico"></span>
										<div class="left" id="etaxcash_cert">
										</div>
										<div class="cerStatus">
											<span id="etaxcash_end" style="display:none;"></span>
											<span class="cerChange" id="etaxcash_change">교체</span>
										</div>
									</div>
								</dd>
							</dl>
						</div>
					</div>

					<!-- 토스트 팝업 -->
					<div id="etaxcash_toast" class="toast_pop" style="display:none;">
						<div class="inner">
							<span>삭제되었습니다.</span>
						</div>
					</div>
					<!-- //토스트 팝업 -->

					<!-- 하단 fix버튼 -->
					<div class="btn_fix_botm btn_both">
						<div class="inner">
							<a id="etaxcash_del_btn" class="off">삭제</a>
							<a id="etaxcash_confirm_btn">확인</a>
						</div>
					</div>
					<!-- //하단 fix버튼 -->
				</div>
			</div>
			<!-- //세금계산서∙현금영수증 -->

			<!-- 세액 내역 -->
			<div id="paytax_tab" class="tabs_body type2 cboth" style="display:none;">
				<div id="paytax_none" class="tab_cnt" style="display:none;">
					<div class="m_cont">
						<div class="set_bx_wrap type2">
							<dl>
								<dt><p class="tit">※ 공동인증서 등록이 필요합니다.</p></dt>
							</dl>
						</div>
					</div>

					<!-- 버튼영역 -->
					<div id="paytax_reg_btn" class="btn_add2 mgt200">
						<a class="btn_s01 type2 btn_dCon1">공동인증서 등록하기</a>
					</div>
					<!-- //버튼영역 -->
				</div>
				
				<div id="paytax_info" class="tab_cnt" style="display:none;">
					<div class="m_cont">
						<div class="set_bx_wrap type2">
							<dl>
								<dt><p class="tit">등록된 공동 인증서</p></dt>
								<dd>
									<div class="certi01">
										<span class="ico"></span>
										<div class="left" id="paytax_cert">
										</div>
										<div class="cerStatus">
											<span class="cerEnd" id="paytax_end" style="display:none;"></span>
											<span class="cerChange" id="paytax_change">교체</span>
										</div>
									</div>
								</dd>
							</dl>
						</div>
					</div>

					<!-- 토스트 팝업 -->
					<div id="paytax_toast" class="toast_pop" style="display:none;">
						<div class="inner">
							<span>삭제되었습니다.</span>
						</div>
					</div>
					<!-- //토스트 팝업 -->

					<!-- 하단 fix버튼 -->
					<div class="btn_fix_botm btn_both">
						<div class="inner">
							<a id="paytax_del_btn" class="off">삭제</a>
							<a id="paytax_confirm_btn">확인</a>
						</div>
					</div>
					<!-- //하단 fix버튼 -->
				</div>
			</div>
			<!-- //세액 내역 -->
		</div>
	</div>
</div>
<!-- //content -->
</body>
</html>