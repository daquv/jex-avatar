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
 * @File Name        : sttc_0202_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/sttc
 * @author           : 김태훈 (  )
 * @Description      : 어드민 데이터가져오기등록현황 화면
 * @History          : 20200309140954, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/sttc/sttc_0202_01.js
 * @JavaScript Url   : /js/jex/avatar/admin/sttc/sttc_0202_01.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title>데이터가져오기등록현황</title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="admin/js/include/smart.excel.js?<%=DateTime.getInstance().getDate("yyyymmddhh24miss") %>"></script>
<script type="text/javascript" src="admin/js/include/smart.grid.js?<%=DateTime.getInstance().getDate("yyyymmddhh24miss") %>"></script>
<script type="text/javascript" src="/js/jex/avatar/admin/sttc/sttc_0202_01.js?<%=DateTime.getInstance().getDate("yyyymmddhh24miss") %>"></script>
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
                    <div class="left"><h1>데이터가져오기등록현황</h1></div>
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
                            <col style="width:240px;">
                            <col style="width:110px;">
                            <col style="width:240px;">
                            <col>
                            <col style="width:200px;">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row"><div>가입일자</div></th>
                                    <td>
                                        <div>
                                            <input type="text" style="width:71px;padding-left:5px; margin-right:5px;" id="STR_DT" value="" readonly="readonly">
                                            ~
                                            <input type="text" style="width:71px;padding-left:5px; margin-right:5px;" id="END_DT" value="" readonly="readonly">
                                            <a href="#none" class="btn_style3" id="BASE_DT"><span>전체</span></a>
                            				<a href="#none" class="btn_style3" id="TODAY_DT"><span>당일</span></a>
                                        </div>
                                    </td>
                                    <th scope="row" style="text-align:right;padding-right:10px;"><div>상태</div></th>
                                    <td>
                                        <div>
                                            <label for="NORM"><input type="checkbox" name="STTS" id="NORM" value="1"> 정상</label>
                                            <label for="SPNC"><input type="checkbox" name="STTS" id="SPNC" value="8"> 정지</label>
                                            <label for="TRMN"><input type="checkbox" name="STTS" id="TRMN" value="9"> 해지</label>
                                        </div>
                                    </td>
                                    <th scope="row" style="text-align:right;padding-right:10px;"><div>데이터가져오기</div></th>
                                    <td colspan="3">
                                        <div>
                                            <select id="select_01" style="width:100px;">
		                                        <option value="">전체</option>
		                                        <option value="ACCT">은행</option>
		                                        <option value="HOME">홈택스</option>
		                                        <option value="SALE">카드매출</option>
		                                        <option value="CARD">카드매입</option>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                	<th scope="row"><div>검색대상</div></th>
                                    <td colspan="5">
                                        <div>
                                            <select id="select_02" style="width:100px;">
                                               <option value="">전체</option>
                                                <option value="CUST">고객명</option>
                                                <option value="PHONE">휴대폰번호</option>
                                            </select>
                                            <input id="searchValue" type="text" value="" placeholder="" style="width:202px;">
                                        </div>
                                    </td>
                                    <td style="padding-left:100px;"><a href="#none" class="btn_search_tb"><span>조회</span></a></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- //검색테이블 -->
                </form>
               	<!-- 타이틀/검색 영역 -->
               	<div  class="cboth mgb10 mgt10"> 
               		<div class="left" style="position:relative;z-index:16;"></div>
               		<div class="right" style="z-index:100007;">
               			<a href="javascript:" class="btn_style1_b" id="btnExceldown" style="display:inline-block;"><span>엑셀저장</span></a>
               		</div>
               	</div>
                <!-- //타이틀/검색 영역 -->
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
				            <tr>
				                <th scope="row"><div>홈택스</div></th>
				                <td><div class="tar" id="HOME_NCNT">1</div></td>
				                <td><div></div></td>
				                <th scope="row"><div>여신금융</div></th>
				                <td><div class="tar" id="SALE_NCNT">1</div></td>
				                <td><div></div></td>
				                <th scope="row"><div>은행</div></th>
				                <td><div class="tar" id="ACCT_NCNT">1</div></td>
				                <td><div></div></td>
				             </tr>
				             <tr>
				                <th scope="row"><div>카드</div></th>
				                <td><div class="tar" id="CARD_NCNT">1</div></td>
				                <td colspan="7"><div></div></td>
				             </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //table input(1) -->
                
            	
            	<!-- 타이틀/검색 영역 -->
<!--                 <div  class="cboth mgb10 mgt10">  -->
<!--                 	<div class="left" style="position:relative;z-index:16;"> -->
                           
<!--                            <a href="javascript:" class="btn_style1 icon_excel" id="btnExceldown" style="display:inline-block;"><span>엑셀저장</span></a> -->
<!--                 	</div> -->
<!--                 	<div class="right" style="z-index:100007;"> -->
                       
<!--                     </div> -->
                    
<!--                 </div> -->
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


