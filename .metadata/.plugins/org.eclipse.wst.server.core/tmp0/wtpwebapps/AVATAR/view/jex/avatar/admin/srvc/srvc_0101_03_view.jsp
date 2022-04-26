<%@page import="com.avatar.session.AdminSessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="java.net.URLDecoder"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
	String _sLocalTime_comm = DateTime.getInstance().getDate("yyyymmddhh24miss");
                        
    // Action 결과 추출
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : srvc_0101_03_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/srvc
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200708105526, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/srvc/srvc_0101_03.js
 * @JavaScript Url   : /js/jex/avatar/admin/srvc/srvc_0101_03.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title></title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/admin/js/include/smart.grid.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript" src="/js/jex/avatar/admin/srvc/srvc_0101_03.js?<%=_sLocalTime_comm %>"></script>
</head>
<body>
	<div class="pop_wrap" style="width:750px;">
		<!-- 팝업 헤더 -->
		<div class="pop_header">
			<h1>API 검색</h1>
			<a href="#none" class="btn_popclose popupClose"><img src="../img/btn_popclose.gif" alt="popup close"></a>
		</div>
		<!-- //팝업 헤더 -->

		<!-- 팝업 컨텐츠 -->
		<div class="pop_container">

			<!-- 상세검색테이블 -->
			<div class="table_wrap mgb10" style="display:block;border-top:1px solid #b4b4b4;">
				<div class="tbl_srch">
					<table class="" style="display:;">
						<caption></caption>
						<colgroup>
						<col style="width:70px;">
						<col>
						</colgroup>
						<tbody>
							<tr>
								<th>
									<div>계정찾기</div>
								</th>
								<td>
									<div>
										<input type="text" id="SRCH_WD" style="width:90%;" placeholder="이름, 회사명">
									</div>
								</td>
								<td class="v_middle"><a href="#none"class="btn_search_tb cmdSearch"><span>조회</span></a></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<!-- //상세검색테이블 -->
			<!-- 리스트 테이블 -->
			 <div class="table_layout">
                        <table class="tbl_result" id="tbl_title">
                            <caption></caption>
                            <colgroup></colgroup>
                            <thead>
                                <tr></tr>
                            </thead>
                            <!-- <tbody id="recList"></tbody> -->
                        </table>
                    </div>
                    
                    <!--  new add -->
                     <div class="tbl_layout" style="height:237px;min-width:100%;overflow-y:auto;overflow-x:auto;">
				<table class="tbl_result" summary="" id="tbl_content">
					<caption></caption>
					<tbody>
						<tr class='text-dot'>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- //리스트 테이블 -->
			<!-- Paging wrap -->
        <div class="paging_wrap">
			<div class="f_left n_paging_size" style="display:none;" ></div>
            <div class="paging" id="tbl_paging" style="border-top:0px;"></div>
        </div>
        <!-- //Paging wrap -->
			<!-- 하단버튼 -->
			<div class="tac">
				<a href="#none" class="btn_style1_b cmdSave" id="cmdSave"><span>저장</span></a>
				<a href="#none" class="btn_style1 popupClose" id="popupClose"><span>닫기</span></a>
			</div>
			<!-- //하단버튼 -->

	</div>
	<!-- //팝업 컨텐츠 -->

</div>
	<%@include file="/view/jex/avatar/admin/include/view_stgup.jsp"%>    
</body>
</html>