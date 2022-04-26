<%@page import="java.net.URLDecoder"%>
<%@page import="jex.util.date.DateTime"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String useInttId 	= StringUtil.null2void(request.getParameter("POP_USE_INTT_ID"));
    String custNm 		= StringUtil.null2void(request.getParameter("POP_CUST_NM"));
	String dvCd 		= StringUtil.null2void(request.getParameter("POP_GB"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : sstm_0201_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/sstm
 * @author           : 김태훈 (  )
 * @Description      : 어드민 고객별결과조회 팝업 화면
 * @History          : 20200410151324, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/sstm/sstm_0201_02.js
 * @JavaScript Url   : /js/jex/avatar/admin/sstm/sstm_0201_02.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title>고객별결과조회 상세조회</title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/js/jex/avatar/admin/sstm/sstm_0201_02.js?<%=DateTime.getInstance().getDate("yyyymmddhh24miss")%>"></script>
<script>
	
	
</script>

</head>
<body>

	<input type="hidden" name="USE_INTT_ID" id="USE_INTT_ID" value="<%=useInttId %>" />
	<div class="pop_wrap" id="pop-view01" style="width:auto;">

	<!-- 팝업 헤더 -->
	<div class="pop_header">
	<%-- - <%=StringUtil.null2void(bsnnNm.equals("null")?"":bsnnNm)%> --%>
		<h1> 고객별결과조회 상세조회 <%-- <%=StringUtil.null2void(custNm.equals("")?"": "- " + custNm)%> --%></h1>
		<a href="javascript:"  class="btn_popclose popupClose" id="btnCloseImg">
				<img alt="팝업닫기" src="../admin/img/btn/btn_popclose.gif">
		</a>
	</div>
	<!-- //팝업 헤더 -->

	<!-- 팝업 컨텐츠 -->
	<div class="pop_container1" style="padding: 20px;">

		<!-- 검색테이블-->
		<div class="table_wrap mgb10" style="border-top:1px solid #ccc;">
			<div class="tbl_srch">
				<table class="">
					<caption></caption>
					<colgroup>
					<col style="width:50px;"><!--<col style="width:35px;">-->
					<col style="width:571px;">
					<col style="width:50px;"><!--<col style="width:35px;">-->
					<col style="width:234px;">
					<col>
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><div>구분<em class="point"></em></div></th>
							<td>
								<div>
									<label for="TOTL"><input type="radio" name="DV_CD" id="TOTL" checked 	value=""> 		전체</label>
									<label for="ACCT"><input type="radio" name="DV_CD" id="ACCT" <%=dvCd.equals("ACCT")?"checked='checked'":"" %> value="ACCT"> 	은행</label>
									<label for="EVDC"><input type="radio" name="DV_CD" id="EVDC" <%=dvCd.equals("EVDC")?"checked='checked'":"" %> value="EVDC"> 	전자세금계산서</label>
									<label for="MECR"><input type="radio" name="DV_CD" id="MECR" <%=dvCd.equals("MECR")?"checked='checked'":"" %> value=MECR> 		현금영수증</label>
									<label for="CARD"><input type="radio" name="DV_CD" id="CARD" <%=dvCd.equals("CARD")?"checked='checked'":"" %> value="CARD"> 	카드매입</label>
									<label for="RCV"> <input type="radio" name="DV_CD" id="RCV"  <%=dvCd.equals("RCV")?"checked='checked'":"" %> 	value="RCV"> 	카드매출</label>
								</div>
							</td>
							<th scope="row"><div>상태<em class="point"></em></div></th>
							<td>
								<div>
									<label for="TOTL_STTS"><input type="radio" name="STTS" id="TOTL_STTS" checked="checked" value=""> 전체</label>
									<label for="SCSS"><input type="radio" name="STTS" id="SCSS" value="0000"> 정상</label>
									<label for="FAIL"><input type="radio" name="STTS" id="FAIL" value="9999"> 실패</label>
								</div>
							</td>
							<td></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<!-- //검색테이블 -->
		
		
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
			                     <div class="tbl_layout" style="min-height:300px;min-width:100%;overflow-y:none;overflow-x:none;">
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

    	<!-- 하단버튼 -->
		<div class="tar btn_tline">
			<a href="javascript:" class="btn_style1" id=btn_popclose><span>확인</span></a>
		</div>
		<!-- //하단버튼 -->
    	
    </div>
</div>
<%@include file="/view/jex/avatar/admin/include/view_stgup.jsp"%>	
</body>
</html>
