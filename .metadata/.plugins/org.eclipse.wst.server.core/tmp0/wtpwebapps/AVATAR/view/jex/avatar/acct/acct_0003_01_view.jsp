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
 * @File Name        : acct_0003_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/acct
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20201119111557, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/acct/acct_0003_01.js
 * @JavaScript Url   : /js/jex/avatar/acct/acct_0003_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/acct/acct_0003_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5">

	<!-- content 
		
	 ->
	<div class="content">

		<div class="m_cont"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<div class="cont_pd20">
				<div class="data_cnt">
					<h3>은행 연결하기</h3>
					<div class="right"><a class="on" style="color: #793ffb;">연결하기</a></div>
				</div>
				<!-- 데이터 -->
				<div class="data_wbx" style="display: none;">
					<div class="ico_bank">
						<div class="bank001">기업은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="bank002">국민은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="bank003">신한은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="bank004">우리은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="bank005">DGB대구은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="bank006">농협은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="bank007">씨티은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="bank008">SC제일은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="bank009">하나은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="bank010">산업은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="bank011">수협은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="bank012">부산은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="bank013">광주은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="bank014">제주은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="bank015">전북은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="bank016">경남은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="bank017">새마을은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="bank018">신협은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
					<div class="ico_bank">
						<div class="bank019">우체국은행</div>
						<div class="right"><a class="off">관리하기</a></div>
					</div>
				</div>
				<!-- 데이터 -->
			</div>

		</div>


	</div>
	<!-- //content -->

</body>
</html>