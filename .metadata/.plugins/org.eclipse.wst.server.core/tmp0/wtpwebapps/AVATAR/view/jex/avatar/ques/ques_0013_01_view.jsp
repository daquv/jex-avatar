<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%@page import="com.avatar.session.SessionManager"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
//	JexData result = util.getResultData();
//	String html = StringUtil.null2void(result.getString("HTML")); 
 	
	//GET SESSION
	JexDataCMO UserSession = SessionManager.getSession(request, response);
    String CHRG_NM = StringUtil.null2void(request.getParameter("NE-PERSON"));
    String PREV_YN = StringUtil.null2void(request.getParameter("PREV_YN"));
    String CHRG_TEL_NO = StringUtil.null2void(request.getParameter("CHRG_TEL_NO"));
    String BIZ_NO = StringUtil.null2void(request.getParameter("BIZ_NO"));
    String SEQ_NO = StringUtil.null2void(request.getParameter("SEQ_NO"));
    String INTE_CD = StringUtil.null2void(request.getParameter("INTE_CD"));
    String APP_ID = StringUtil.null2void((String)UserSession.get("APP_ID"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : ques_0013_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/ques
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20210803130849, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/ques/ques_0013_01.js
 * @JavaScript Url   : /js/jex/avatar/ques/ques_0013_01.js
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
<script>
var CHRG_NM = decodeURIComponent('<%=CHRG_NM%>');
var CHRG_TEL_NO = '<%=CHRG_TEL_NO%>';
var PREV_YN = '<%=PREV_YN%>';
var BIZ_NO = '<%=BIZ_NO%>';
var SEQ_NO = '<%=SEQ_NO%>';
var INTE_CD = '<%=INTE_CD%>';
var _APP_ID = '<%=APP_ID%>';
</script>
<script type="text/javascript" src="/js/jex/avatar/ques/ques_0013_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5">
<!-- content -->
<div class="content">
	<div class="m_cont pdt12"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->
		<!-- 질문 -->
		<div class="askAvatar_que">
			<p id="" class="askAvatar_queWord"><!-- “세무사 추천해줘” --></p>
		</div>
		<span data-type="" id="RESULT_TTS" style="display:none;" class="noti_tit">
				추천된 세무사입니다. 전화연결을 원하시면 하단 문구를 참고해주세요.
		</span>
		<!-- //질문 -->
		<div class="taxAccBx">
			<div class="inner">
				<div class="taxAcc_top">
					<dl>
						<dt><div class="taxAcc_prof"><img src="../img/im_acc_profile.png" alt=""></div></dt>
						<dd>
							<h4 id="CHRG_NM"></h4>
							<p id="BSNN_NM"></p>
						</dd>
					</dl>
				</div>
				<div class="taxAcc_body">
					<div class="taxAcc_cn">
						<!-- 상세정보 -->
						<div class="taxAcc_infor_tbl">
							<table>
								<colgroup><col style="width:70px;"><col></colgroup>
								<tbody>
									<tr>
										<th><div>연락처</div></th>
										<td><div><a class="diBlock" id="CHRG_TEL_NO"></a></div></td>
									</tr>
									<tr>
										<th><div>위치</div></th>
										<td><div id="ADRS"></div></td>
									</tr>
									<tr>
										<th><div>전문분야</div></th>
										<td><div id="MAJR_SPHR"></div></td>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- //상세정보 -->
					</div>
					<!-- 하단문구 -->
					<div class="info_txt3">
						<p>전화연결을 원하시면 마이크 버튼을 터치 후 “OOO 세무사 전화해줘” 라고 말해보세요!</p>
					</div>
					<!-- //하단문구 -->
				</div>
			</div>
		</div>
	</div>
</div>
<!-- //content -->

</body>
</html>