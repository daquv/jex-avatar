<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
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
	String BLBD_CONT = StringUtil.null2void(request.getParameter("BLBD_CONT"));
	String SAVE_FILE_LIST = StringUtil.null2void(request.getParameter("SAVE_FILE_LIST"),"[]");
// 	String RECOG_TXT = StringUtil.null2void(request.getParameter("RECOG_TXT"));
	System.out.println(SAVE_FILE_LIST);
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : basic_0006_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200820132754, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0006_02.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0006_02.js
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
	<script type="text/javascript" src="/js/jex/avatar/basic/basic_0006_02.js?<%=_CURR_DATETIME%>"></script>
	<script>
	var BLBD_CONT = '<%=BLBD_CONT%>';
	var SAVE_FILE_LIST = '<%=SAVE_FILE_LIST%>';
<%-- 	var RECOG_TXT = '<%=RECOG_TXT%>'; --%>
	
	</script>
</head>
<body>
<!-- content -->
<input type="hidden" id="CLPH_NO" value="<%=CLPH_NO%>" />
<input type="hidden" id="BLBD_CONT" value="<%=BLBD_CONT%>" />
<input type="hidden" id="SAVE_FILE_LIST" value="<%=SAVE_FILE_LIST%>" />
	<div class="content">

		<div class="m_cont m_cont_pd"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<!-- 컨텐츠 영역 -->
			<div class="iq_wrap">
				<!-- (modify)20210517 -->
				<div class="iq_req type1">
					<strong id=""><%=CUST_NM %></strong>
					<span id="">(<span id="TEL_NO"></span>)</span>
				</div>
				<!-- <label for="" class="select_type mgb7">
					<select id="BLBD_CTGR_CD">
						<option value="" selected>문의유형</option>
						<option value="101">질의/답변</option>
						<option value="102">탈퇴/해지</option>
						<option value="103">제휴서비스</option>
						<option value="104">기타문의</option>
					</select>
				</label> -->
				<!-- //(modify)20210517 -->
				
				<div class="input_type">
					<input type="text" placeholder="제목을 입력해 주세요. (최대 20자)" id="BLBD_TITL" maxlength="20">
				</div>
				
				<div class="tarea_type">
					<textarea placeholder="문의 내용을 입력해 주세요. (최대 800자)" id="BLBD_CTT" maxlength="800"></textarea>
				</div>
		
				<div class="addfile">
					<p>첨부 파일</p>
					<a href="#none" class="btn_add"><span>사진추가</span></a>
					<ul class="filelist">
						<!-- <li class="down"><a href="#none">Screenshot_20200729-1 175856.jpg</a> <a href="#none" class="btn_del"></a></li> -->
					</ul>
				</div>
				<div class="agree_chk">
					<label><input type="checkbox" class="chk_circle">개인정보 수집 및 이용 동의하기 <span>(필수)</span></label>
				</div>
				
			</div>
			<!-- //컨텐츠 영역 -->

		</div>
		<!-- 토스트 팝업 -->
		<div class="toast_pop" style="display:none;">
			<div class="inner">
				<span id="toast_msg">이름을 입력해주세요.</span>
			</div>
		</div>
		<!-- //토스트 팝업 -->
		<!-- 하단 fix버튼 -->
		<div class="btn_fix_botm">
			<div class="inner">
				<a>제출하기</a>
			</div>
		</div>
		<!-- //하단 fix버튼 -->

	</div>
	<!-- //content -->

</body>
</html>