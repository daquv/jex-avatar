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
 * @File Name        : sstm_0102_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/sstm
 * @author           : 김태훈 (  )
 * @Description      : 어드민 배치서비스관리 메인
 * @History          : 20200306143444, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/sstm/sstm_0102_01.js
 * @JavaScript Url   : /js/jex/avatar/admin/sstm/sstm_0102_01.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
	<title>코드관리</title>
	
	  <%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
	  <script type="text/javascript" src="/js/jex/avatar/admin/sstm/sstm_0102_01.js?<%=DateTime.getInstance().getDate("yyyymmddhh24miss")%>"></script> 
	 
	 <style>
		.invalid{border:1px solid #f00! important;}
	</style>
</head>

<body>
            	<form id="form1" name="form1"  method="post">
            		<input type="hidden" id="menuId" name="BLBD_DIV" value="">
            		
            		<!-- 타이틀/검색 영역 -->
	                <div class="title_wrap">
	                    <!-- (PARK)20161005 -->
	                    <div class="left" style="position:relative;z-index:-16;">
	                    	<div class="left"><h1>코드관리</h1></div>
	                    </div>
	                    <div class="right" style="z-index:100007;">
	                    </div>
	                </div>
	                <!-- //타이틀/검색 영역 -->
	                
	                <!-- 상세검색테이블 -->
                <div class="table_wrap" style="display:block;">
                    <div class="tbl_srch">
                        <table class="">
                            <caption></caption>
                            <colgroup>
                            <col style="width:20px;">
                            <col style="width:60px;">
                            <col style="width:20px;">
                            <col style="width:60px;">
                            <col style="width:20px;">
                            <col style="width:160px;">
                            <col style="width:20px;">
                            </colgroup>
                            <tbody>
                                <tr>
                                    
                                    <th scope="row"><div>코드종류</div></th>
                                    <td>
                                        <div>
                                            <select id="select_01" style="width:130px;">
                                            	<option value="">전체</option>
												<option value="S">시스템</option>
												<option value="B">업무용</option>
												<option value="U">사용자</option>
                                            </select>
                                            
                                        </div>
                                    </td>
                                    
                                    <th scope="row"><div></div></th>
                                    <td>
                                        <div>
                                           
                                        </div>
                                    </td>
                                    
                                    <th scope="row"><div></div></th>
                                    <td>
                                        <div>
                                            
                                            
                                        </div>
                                    </td>
                                    
                                    <td><a href="#none" class="btn_search_tb cmdSearch"><span>조회</span></a></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- //상세검색테이블 -->
                
                <!-- 타이틀/검색 영역 -->
                <div  class="cboth mgb10 mgt10"> 
                	<div class="left" style="position:relative;z-index:16;">
                           <a href="#none" class="btn_style1" id="btnAddGroup"><span>그룹코드등록</span></a>
<!--                            <a href="#none" class="btn_style1" id="btnAddItem"><span>세부코드등록</span></a> -->
                	</div>
                	<div class="right" style="z-index:100007;">
                       
                    </div>
                    
                </div>
                <!-- //타이틀/검색 영역 -->
                
                <!-- table result -->
                <div class="">
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
                     <div class="tbl_layout" style="height:509px;min-width:100%;overflow-y:auto;overflow-x:hidden;">
	                    <table class="tbl_result" summary="" id="tbl_content">
	                        <caption></caption>
	                        <colgroup></colgroup>
	                        <tfoot style="display:none;">
	                            <tr class="no_hover" style="display:table-row;">
	                                <td colspan="9" class="no_info"><div>내용이 없습니다.</div></td>
	                            </tr>
	                        </tfoot>
	                        <tbody><tr></tr></tbody>
	                    </table>
	                </div>
	              </div>
                <!-- ---------- -->
                
                 <!-- Paging wrap -->
                <div class="paging_wrap">
                    <div class="f_left n_paging_size"></div>
                    <div class="paging" id="tbl_paging" style="border-top:0px;"></div>
                </div>
                <!-- //Paging wrap -->
                
            	</form>

<%@include file="/view/jex/avatar/admin/include/com_bottom.jsp"%>
<%@include file="/view/jex/avatar/admin/include/view_stgup.jsp"%>
</body>
</html>
