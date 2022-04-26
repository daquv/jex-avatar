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
 * @File Name        : basic_0015_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 박지은 (  )
 * @Description      : 제로페이 가맹점 관리 화면
 * @History          : 20210805165524, 박지은
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0015_01.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0015_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/basic/basic_0015_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5"> 

<!-- content -->
<div id="cont" class="content" style="display:none;">

	<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
		<!-- 리스트 -->
		<div class="acc_cbx">
			<div class="acc_cbx_in">
				<dl>
					<dt>
						<div class="tit"><p>가맹점별 데이터 수집 상태를 설정할 수 있습니다</p></div>
					</dt>
					<dd>
						<div class="acc_cbx_cn">
							<ul id="mest_list" class="cbx_switch">
							<!-- 
								<li>
									<div class="left noneArrow">
										<div class="acc_tit">
											제로마트
										</div>
										<div class="acc_txt">
											111-12-123456
										</div>
									</div>
									<div class="btn"><a class="btn_switch on"></a></div>
									<div class="cerStatus miPosition">
										<span class="cerEnd">해지</span>
									</div>
								</li>
							-->
							</ul>
						</div>
					</dd>
				</dl>
			</div>
		</div>
		<!-- //리스트 -->
	</div>

	<!-- 하단 fix버튼 -->
	<div class="btn_fix_botm type4">
		<div class="inner">
			<a class="confirm_btn">확인</a>
		</div>
	</div>
	<!-- //하단 fix버튼 -->

</div>
<!-- //content -->

<!-- content -->
<div id="cont_none" class="content" style="display:none;">

	<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

		<!-- 컨텐츠 영역 -->
		<div class="notibx_wrap type2">
			<div class="inner">
				<div class="ico"></div>
				<div class="noti_tit">제로페이 가맹점이 조회되지 않습니다.</div>
				<div class="noti_txt">
					아직 제로페이 가맹점이 아니라면,<br>
					가맹 후 이용해주세요!
				</div>
			</div>
		</div>
		<!-- //컨텐츠 영역 -->

	</div>

	<!-- 하단 fix버튼 -->
	<div class="btn_fix_botm type4">
		<div class="inner">
			<a class="confirm_btn">확인</a>
		</div>
	</div>
	<!-- //하단 fix버튼 -->

</div>
<!-- //content -->

</body>
</html>