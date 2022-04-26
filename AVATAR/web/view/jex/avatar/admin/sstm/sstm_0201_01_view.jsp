<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String _sLocalTime_comm = DateTime.getInstance().getDate("yyyymmddhh24miss");
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : sstm_0201_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/sstm
 * @author           : 김태훈 (  )
 * @Description      : 어드민 고객별결과조회 화면
 * @History          : 20200410151224, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/sstm/sstm_0201_01.js
 * @JavaScript Url   : /js/jex/avatar/admin/sstm/sstm_0201_01.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title>고객별결과조회</title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/admin/js/include/smart.excel.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript" src="/admin/js/include/smart.grid.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript" src="/js/jex/avatar/admin/sstm/sstm_0201_01.js?<%=_sLocalTime_comm %>"></script>
<style>
.tbl_show_count{border-top:1px solid #ccc; border-bottom:1px solid #ccc;}
.tbl_show_count tr{border-bottom: 1px solid #ccc;}
.tbl_show_count tr td, .tbl_show_count tr th{padding:10px;}
.tbl_show_count tr th{text-align: left;}
.title_wrap .right{position:absolute;top:0;right:0;}
</style>
</head>

<body>

<!-- 검색 목록 유지 데이터 -->

	 <!-- Container -->
         
            	<form id="form1" name="form1"  method="post">
            	<!--  -->

				<!-- 검색 목록 유지 데이터 -->
				<%-- <input type="hidden" id="SELECT_01" name="SELECT_01" value="<%=SELECT_01%>" />
				<input type="hidden" id="SEARCHVALUE" name="SEARCHVALUE" value="<%=SEARCHVALUE%>" />
				<input type="hidden" id="SELECT_02" name="SELECT_02" value="<%=SELECT_02%>" />
				<input type="hidden" id="start_dt" name="start_dt" value="<%=start_dt%>" />
				<input type="hidden" id="end_dt" name="end_dt" value="<%=end_dt%>" />
				<input type="hidden" id="intt_stts" name="intt_stts" value="<%=intt_stts%>" />
				<input type="hidden" id="bill_stts" name="bill_stts" value="<%=bill_stts%>" />
				<input type="hidden" id="setl_div" name="setl_div" value="<%=setl_div%>" />
				<input type="hidden" id="setl_reg_yn" name="setl_reg_yn" value="<%=setl_reg_yn%>" />
				<input type="hidden" id="acpt_agrm_yn" name="acpt_agrm_yn" value="<%=acpt_agrm_yn%>" />
				<input type="hidden" id="new_br_no" name="new_br_no" value="<%=new_br_no%>" /> --%>
            	<!-- 타이틀/검색 영역 -->
                <div class="title_wrap">
                    <div class="left"><h1>고객별결과조회</h1></div>
                </div>
                <!-- //타이틀/검색 영역 -->
            	
            	<!-- 검색테이블--> <!-- 가입일자, 상태, 검색대상 -->
                <div class="table_wrap mgb10">
                    <div class="tbl_srch">
                        <table summary="">
                            <colgroup>
                            <col style="width:110px">
                            <col style="width:330px;">
                            <col style="width:80px;">
                            <col style="width:240px;">
                            <col style="width:80px;">
                            <col style="width:400px;">
                            <col>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row"><div>데이터가져오기</div></th>
                                    <td>
                                        <div>
                                            <select id="select_01" style="width:130px;">
                                            	<option value="">전체</option>
                                            </select>
                                            
                                        </div>
                                    </td>
                                    
                                    <th scope="row" style="text-align:right;padding-right:10px;"><div>수집상태</div></th>
                                    <td>
                                        <div>
                                        	<label for="STTS_01"><input type="checkbox" id="STTS_01" name="STTS" class="STTS" value="0000"> 정상</label>
                                        	<label for="STTS_02"><input type="checkbox" id="STTS_02" name="STTS" class="STTS" value="9999"> 실패</label>
                                        </div>
                                    </td>
                                    <th scope="row"><div>검색대상</div></th>
                                    <td>
                                        <div>
                                            <select id="SRCH_CD" style="width:100px;">
                                               <option value="">전체</option>
                                                <option value="CUST">고객명</option>
                                                <option value="PHONE">휴대폰번호</option>
                                            </select>
                                            <input id="SRCH_WD" type="text" value="" placeholder="" style="width:215px;">
                                        </div>
                                    </td>
									<th scope="row"><div></div></th>
									<td><div></div></td>
									<td style="float: right;"><a href="javascript:void(0);" class="btn_search_tb cmdSearch" colspan="1"><span>조회</span></a></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- //검색테이블 -->
                </form>
                
                <!-- table input(1) -->
                <div class="tbl_input1 mgb10">
                    <table summary="" class="tbl_show_count">
                        <caption></caption>
                        <colgroup>
                        <col style="width:210px;">
                        <col style="width:90px;">
                        <col>
                        <col style="width:210px;">
                        <col style="width:200px;">
                        <col>
                        </colgroup>
                        <tbody>
                            <tr>
				                <th scope="row"><div>전체</div></th>
				                <td><div class="tar" id="TOTL_NCNT">1</div></td>
				                <td><div></div></td>
				                <th scope="row"><div>정상</div></th>
				                <td><div class="tar" id="NORM_NCNT">1</div></td>
				                <td><div></div></td>
				                <th scope="row"><div>해지(중지/해지)</div></th>
				                <td><div class="tar" id="TRMN_NCNT">1</div></td>
				                <td><div></div></td>
				            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //table input(1) -->
                
                <!-- 타이틀/검색 영역 -->
                <div  class="cboth mgb10 mgt10"> 
                	<div class="left" style="position:relative;z-index:16;">
                	</div>
                	<div class="right" style="z-index:100007;">
                        <a href="javascript:" class="btn_style1_b" id="btnExceldown" style="display:inline-block;"><span>엑셀저장</span></a>
                    </div>
                    
                </div>
                <!-- //타이틀/검색 영역 -->
                
                
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
                     <div class="tbl_layout" style="min-height:509px;min-width:100%;overflow-y:none;overflow-x:none;">
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

<%@include file="/view/jex/avatar/admin/include/com_bottom.jsp"%>
<%@include file="/view/jex/avatar/admin/include/view_stgup.jsp"%>              

</body>
</html>