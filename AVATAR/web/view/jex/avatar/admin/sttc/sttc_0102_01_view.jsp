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
 * @File Name        : sttc_0102_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/sttc
 * @author           : 김태훈 (  )
 * @Description      : 어드민 질의 현황 화면
 * @History          : 20200309140508, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/sttc/sttc_0102_01.js
 * @JavaScript Url   : /js/jex/avatar/admin/sttc/sttc_0102_01.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title>질의현황</title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="admin/js/include/smart.excel.js?<%=DateTime.getInstance().getDate("yyyymmddhh24miss") %>"></script>
<script type="text/javascript" src="admin/js/include/smart.grid.js?<%=DateTime.getInstance().getDate("yyyymmddhh24miss") %>"></script>
<script type="text/javascript" src="/js/jex/avatar/admin/sttc/sttc_0102_01.js?<%=DateTime.getInstance().getDate("yyyymmddhh24miss") %>"></script>
<style>
.tbl_show_count{border-top:1px solid #ccc; border-bottom:1px solid #ccc;}
.tbl_show_count tr{border-bottom: 1px solid #ccc;}
.tbl_show_count tr td, .tbl_show_count tr th{padding:10px;}
.tbl_show_count tr th{text-align: left;}
</style>
</head>

<body>
<!-- 검색 목록 유지 데이터 -->

	 <!-- Container -->
         
            	<form id="form1" name="form1"  method="post">

            	<!-- 타이틀/검색 영역 -->
                <div class="title_wrap">
                    <div class="left"><h1>질의현황</h1></div>
                </div>
                <!-- //타이틀/검색 영역 -->
            	
            	<!-- 검색테이블-->
                <div class="table_wrap mgb10">
                    <div class="tbl_srch">
                        <table summary="">
                            <colgroup>
                            <col style="width:100px;">
                            <col style="width:330px;">
                            <col style="width:100px;">
                            <col style="width:210px;">
                            <col style="width:100px;">
                            <col style="width:210px;">
                            <col style="width:110px;">
                            <col style="width:210px;">
                            <col>
                            <col style="width:200px;">
                            </colgroup>
                            <tbody>
								<tr>
                                  	<td colspan="2">
			                            <div>
			                                <select id="select_01" style="width:71px;">
												<option value="0">월별</option>
												<option value="1">기간별</option>
												<option value="2">일별</option>
											</select>
											<input type="text" style="width:71px;padding-left:5px; margin-right:5px;" id="START_DT" value="" readonly="readonly">
											<span style="display: none;" class="end_dt">~</span>
											<input type="text" style="width:71px;padding-left:5px; margin-right:5px; display: none;" id="END_DT" class="end_dt" value="" readonly="readonly">
											<select id="YEAR" class="none" style="width:60px; display: none;"></select>&nbsp;<span class="none" style="display: none;"> 년</span>&nbsp;
											<select id="MONTH" class="none" style="width:42px; display: none;"></select>&nbsp;<span class="none" style="display: none;"> 월</span>
			                            </div>
			                        </td>
			                        <th scope="row" style="text-align:right;padding-right:10px;"><div>질의 채널</div></th>
                                    <td>
                                        <div>
                                            <select id="APP_ID" style="width:200px;">
		                                        <option value="">전체</option>
		                                        <option value="AVATAR">아바타</option>
		                                        <option value="SERP">경리나라</option>
		                                        <option value="ZEROPAY">제로페이</option>
		                                        <option value="KTSERP">KT경리나라</option>
                                            </select>
                                        </div>
                                    </td>
                                    <th scope="row" style="text-align:right;padding-right:10px;"><div>카테고리</div></th>
                                    <td>
                                        <div>
                                            <select id="select_02" style="width:200px;">
		                                        <option value="">전체</option>
                                            </select>
                                        </div>
                                    </td>
                                    <th scope="row" style="text-align:right;padding-right:10px;"><div>인텐트</div></th>
                                    <td>
                                        <div>
                                            <select id="select_03" style="width:200px;">
		                                        <option value="">전체</option>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                	<th scope="row" style="padding-left: 3px;"><div>검색대상</div></th>
                                    <td>
                                        <div>
                                            <select id="select_04" style="width:100px;">
                                               <option value="">전체</option>
                                                <option value="CUST">고객명</option>
                                                <option value="PHONE">핸드폰번호</option>
                                            </select>
                                            <input id="searchValue" type="text" value="" placeholder="" style="width:202px;">
                                        </div>
                                    </td>
                                    <th scope="row" style="text-align:right;padding-right:10px;"><div>학습 상태</div></th>
                                    <td  colspan="5">
                                        <div>
                                            <select id="LRN_STTS" style="width:200px;">
		                                        <option value="">전체</option>
		                                        <option value="8">학습대기</option>
		                                        <option value="9">학습미처리</option>
		                                        <option value="1">학습완료</option>
                                            </select>
                                        </div>
                                    </td>
                                    <td style="padding-left:100px;"><a href="#none" class="btn_search_tb"><span>조회</span></a></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- //검색테이블 -->
                 <!-- 타이틀/검색 영역 -->
                <div  class="cboth mgb10 mgt10" style="z-index: 1;">  
                	<div class="left" style="float:left;" >
                		<a href="javascript:" class="btn_style1_b" id="btnExceldown" style="display:inline-block;"><span>엑셀저장</span></a>
                	</div>
                	<div class="right" style="float:right;">
                        <div class="cntalign">
								<a href="javascript:void(0);" class="btn_style1_b cmdChangeLrnStts" data-val="8"><span>학습대기</span></a>
								<a href="javascript:void(0);" class="btn_style1_b cmdChangeLrnStts" data-val="9"><span>학습미처리</span></a>
								<a href="javascript:void(0);" class="btn_style1_r cmdChangeLrnStts" data-val="1"><span>학습완료</span></a>
							</div>
                    </div>
                    
                </div>
                <!-- //타이틀/검색 영역 -->
                </form>
                <!-- table result -->
                <div class="" style="overflow-y:auto;overflow-x:auto;">
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
	                                <td colspan="8" class="no_info"><div>내용이 없습니다.</div></td>
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
                     

<%@include file="/view/jex/avatar/admin/include/com_bottom.jsp"%>
<%@include file="/view/jex/avatar/admin/include/view_stgup.jsp"%>              

</body>
</html>
