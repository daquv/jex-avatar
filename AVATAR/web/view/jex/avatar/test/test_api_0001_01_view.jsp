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
 * @File Name        : test_api_0001_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/test
 * @author           : 김태훈 (  )
 * @Description      : 
 * @History          : 20200205111721, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/test/test_api_0001_01.js
 * @JavaScript Url   : /js/jex/avatar/test/test_api_0001_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/test/test_api_0001_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
	<!-- content -->
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<div class="cont_pd" style="padding-top:14px;">
				<!-- 입력영역 -->
				<div class="wrbx_w">
					<dl>
						<dt>ACT NAME</dt>
						<dd>
							<div class="input_type">
								<input type="text" id="API_NM"/>
							</div>
						</dd>
						<dt>INPUT</dt>
						<dd>
							<div>
								<textarea id="req" style="width: 100%;height: 500px"></textarea>
							</div>
							<button>전송</button>
						</dd>
						<dt>OUTPUT</dt>
						<dd>
							<div>
								<textarea id="res" style="width: 100%;height: 500px"></textarea>
							</div>
						</dd>
					</dl> 
				</div>
				<!-- //입력영역 -->
			</div>
		</div>
	</div>
	<!-- //content -->
</body>
</html>