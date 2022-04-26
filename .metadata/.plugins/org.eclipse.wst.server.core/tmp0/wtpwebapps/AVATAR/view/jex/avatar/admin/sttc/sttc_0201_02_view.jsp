<%@page import="java.net.URLDecoder"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    
	String DATE_VAL 		= StringUtil.null2void(URLDecoder.decode(request.getParameter("DATE_VAL"),"UTF-8")); // 검색내용
	String USE_INTT_ID    	= StringUtil.null2void(request.getParameter("USE_INTT_ID"));								
	String CUST_NM    		= StringUtil.null2void(request.getParameter("CUST_NM"));								
	String LOGIN_CNT_DUP	= StringUtil.null2void(request.getParameter("LOGIN_CNT_DUP"));
	String INQ_DT_DV_CD    	= StringUtil.null2void(request.getParameter("INQ_DT_DV_CD"));
	String INQ_END_DT    	= StringUtil.null2void(request.getParameter("INQ_END_DT"));
	String INQ_STR_DT    	= StringUtil.null2void(request.getParameter("INQ_STR_DT"));
	String INQ_YM    		= StringUtil.null2void(request.getParameter("INQ_YM"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : sttc_0201_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/sttc
 * @author           : 김태훈 (  )
 * @Description      : 어드민 로그인현황 팝업
 * @History          : 20200309140920, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/sttc/sttc_0201_02.js
 * @JavaScript Url   : /js/jex/avatar/admin/sttc/sttc_0201_02.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/js/jex/avatar/admin/sttc/sttc_0201_02.js?<%= DateTime.getInstance().getDate("yyyymmddhh24miss") %>"></script>
</head>

<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="Cache-Control" content="No-Cache" />
<meta http-equiv="Pragma" content="No-Cache" />

<input type="hidden" id="USE_INTT_ID" 	name="USE_INTT_ID" 	value="<%=USE_INTT_ID%>" />
<input type="hidden" id="INQ_DT_DV_CD" 	name="INQ_DT_DV_CD" value="<%=INQ_DT_DV_CD%>" />
<input type="hidden" id="INQ_END_DT" 	name="INQ_END_DT" 	value="<%=INQ_END_DT%>" />
<input type="hidden" id="INQ_STR_DT" 	name="INQ_STR_DT" 	value="<%=INQ_STR_DT%>" />
<input type="hidden" id="INQ_YM" 		name="INQ_YM" 		value="<%=INQ_YM%>" />
<form id="frm" action="">
<body>

            <div class="pop_wrap">
                <!-- 팝업 헤더 -->
                <div class="pop_header">
                    <h1>로그인현황 상세조회</h1>
                    <a href="javascript:" class="btn_popclose popupClose">
						<img alt="팝업닫기" src="../admin/img/btn/btn_popclose.gif">
					</a>
                </div>
                <!-- //팝업 헤더 -->
                <!-- 팝업 컨텐츠 -->
                <div class="pop_container1" style="padding: 20px;">
                <!-- table input -->
                <div class="tbl_input2 mgb20">
                    <table summary="">
                        <caption></caption>
                        <colgroup>
                        <col style="width:140px;">
                        <col>
                        <col style="width:140px;">
                        <col>
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row"><div>고객번호</div></th>
                                <td><div><%=USE_INTT_ID%></div></td>
                                <th scope="row"><div>고객명</div></th>
                                <td><div><%=CUST_NM%></div></td>
                            </tr>
                            <tr>
                                <th scope="row"><div>조회기간</div></th>
                                <td><div><%=DATE_VAL%></div></td>
                                <th scope="row"><div>총로그인횟수</div></th>
                                <td><div><%=LOGIN_CNT_DUP%>일/총 <span id="LOGIN_CNT"></span>회</div></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //table input -->
                
                <!-- table result -->
              
			                <div class="" style="overflow-y:auto;overflow-x:auto;margin-bottom:20px;">
			                    <!-- 스크롤발생시 추가되는 클래스 scroll_padding -->
			                    <!-- <div class="line"></div> 스크롤발생시 추가되는 태그 -->
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
			                     <div class="tbl_layout" style="height:380px;min-width:100%;overflow-y:none;overflow-x:none;border-bottom:none;">
				                    <table class="tbl_result" summary="" id="tbl_content">
				                        <caption></caption>
				                        <colgroup></colgroup>
				                        <tfoot style="display:none;">
				                            <tr class="no_hover" style="display:table-row;">
				                                <td colspan="5" class="no_info"><div>내용이 없습니다.</div></td>
				                            </tr>
				                        </tfoot>
				                        <tbody><tr></tr></tbody>
				                    </table>
				                </div>
				              </div>
			                <!-- ---------- -->
			                
			                 <!-- Paging wrap -->
			                <!-- 
			                <div class="paging_wrap">
			                    <div class="f_left n_paging_size"></div>
			                    <div class="paging" id="tbl_paging" style="border-top:0px;"></div>
			                </div>
			                -->
			                <!-- //Paging wrap -->
    
                <!-- //table result -->
                
                <!-- 닫기 영역 -->
                <div class="title_wrap mgb20">
                    <div class="right">
                        <a href="#none" class="btn_style1_b"><span>닫기</span></a>
                    </div>
                </div>
                <!-- //닫기 영역 -->
                </div>
                <!-- //팝업 컨텐츠 -->
            </div>
        </form>
      	<%@include file="/view/jex/avatar/admin/include/view_stgup.jsp"%>                        
</body>

</html>