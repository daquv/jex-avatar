<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String DV = StringUtil.null2void(request.getParameter("DV"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : basic_0014_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 박지은 (  )
 * @Description      : 제로페이 연결 화면
 * @History          : 20210805165420, 박지은
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0014_01.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0014_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/basic/basic_0014_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5">
<input type="hidden" id="DV" value="<%=DV%>"/>

<!-- content -->
<div id="cont_str" class="content" style="display:none;">
	<div class="m_cont loading_bx" id="REALTIME" style="display:none;"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
			<dl>
				<dt>
					<div class="lds-spinner"><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div></div>
				</dt>
				<dd>
					<span>제로페이 연결 중 입니다.</span>
					<span>잠시만 기다려주세요.</span>
				</dd>
			</dl>
	</div>
		
	<div class="m_cont m_cont_pd" id="MAIN"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
		<!-- 컨텐츠 영역 -->
		<div class="miBx">
			<div class="inner">
				<div class="miBx_img"><img src="../img/im_d102.png" alt="제로페이 가맹점 정보"></div>
				<div class="miBx_txt">
					제로페이에 가입된 가맹점 정보를<br>
					연결할 수 있어요!
				</div>
			</div>
		</div>
		<!-- //컨텐츠 영역 -->
	</div>

	<!-- 하단 fix버튼 -->
	<div class="btn_fix_botm type4">
		<div class="inner">
			<a id="link_btn">지금 가맹점 연결하기</a>
		</div>
	</div>
	<!-- //하단 fix버튼 -->

</div>
<!-- //content -->


<!-- content -->
<div id="cont_mest" class="content" style="display:none;">
	<div class="m_cont pdt12"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
		<!-- 질의 답변 탑영역 -->
		<div class="aias_news type3 nobg">
			<table>
				<colgroup><col></colgroup>
				<tbody>
					<tr>
						<td>
							<strong class="diInlineBlock c_357EE7">제로페이 가맹점</strong>이 정상적으로<br>
							조회되었습니다.
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<!-- //질의 답변 탑영역 -->

		<!-- 질의 답변영역 -->
		<div class="aias_list type1">
			<div class="aias_list_cn">
				<dl id="mest_list">
				<!-- 
					<dd>
						<span class="tit">제로마트</span>
						<div class="right">
							<em>1234567890</em>
						</div>
					</dd>
					<dd>
						<span class="tit">점보떡볶이</span>
						<div class="right">
							<em>1230000890</em>
						</div>
					</dd>
				-->
				</dl>
			</div>
		</div>
		<!-- //질의 답변영역 -->

		<!-- 하단문구 -->
		<div class="info_txt4">
			<p>가맹점 정보를 받고싶지 않으면 데이터 연결 > 제로페이 가맹점을 OFF로 설정해주세요.</p>
		</div>
		<!-- //하단문구 -->
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