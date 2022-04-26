<%@page import="java.io.File"%>
<%@page import="java.util.ArrayList"%>
<%@page import="jex.data.JexData"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String _sLocalTime_comm = DateTime.getInstance().getDate("yyyymmddhh24miss");
    
    File dir = new File("/NAS_DATA/avatar_filedata/file/img");
    File files[] = dir.listFiles();
    String str = "";
    for(int i = 0; i < files.length; i++){
    	str += "'" + files[i] + "',";
    }
    
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : image_0000_00_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/test
 * @author           : 하준태 (  )
 * @Description      : 
 * @History          : 20220111164150, 하준태
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/test/image_0000_00.js
 * @JavaScript Url   : /js/jex/avatar/test/image_0000_00.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title>고객관리</title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/js/jex/avatar/test/image_0000_00.js?<%=_sLocalTime_comm %>"></script>
<script>
var ary = [<%=str%>]
</script>

<style>
.tbl_show_count{border-top:1px solid #ccc; border-bottom:1px solid #ccc;}
.tbl_show_count tr{border-bottom: 1px solid #ccc;}
.tbl_show_count tr td, .tbl_show_count tr th{padding:10px;}
.tbl_show_count tr th{text-align: left;}
.title_wrap .right{position:absolute;top:0;right:0;}
</style>
</head>
<body>
	<form id="form1" name="fomr1" method="post">
		<div class="wrap">
			<!-- Container -->
    		<div class="container">
    		<%--  <jsp:include page="/view/jex/avatar/admin/include/com_menu.jsp">
					<jsp:param name="MENU" value="cstm"/>
			</jsp:include> --%>
				<!-- Container -->
				<div class="content">
					<div class="content fold">
						<div class="content_wrap">
							<!-- 타이틀/검색 영역 -->
							<div class="title_wrap">
								<div class="left"><h1>이미지</h1></div>
							</div>
							<!-- //타이틀/검색 영역 -->
							
							<!-- 검색테이블--> <!-- 가입일자, 상태, 검색대상 -->
							<div class="table_wrap mgb10">
								<div class="tbl_srch">
									<table summary="">
										<colgroup>
											<col style="width:80px">
											<col style="width:200px;">
											<col style="width:60px;">
											<col style="width:200px;">
											<col style="width:80px;">
											<col style="width:400px;">
											<col>
										</colgroup>
										<tbody>
											<tr>
												<th scope="row"><div>검색대상</div></th>
												<td>
													<div>
														<select id="SRCH_CD" style="width:100px;">
															<option value="">전체</option>
															<option value="01">내용+제목</option>
														</select>
														<input id="SRCH_WD" type="text" value="" placeholder="" style="width:215px;">
													</div>
												</td>
												<td>
												<a href="javascript:void(0);" class="btn_search_tb cmdSearch" colspan="1">
												<span>조회</span>
												</a>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<!-- 타이틀/검색 영역 -->
							<div class="cboth mgb10 mgt10">
								<div class="left" style="position: relative; z-index: 16;">
									<tr>
										<td class="txt-contents" style="height: 100px;">
										<div class="left" style="position: relative; z-index: 16; float: right; display: table;">
											<form id="form_file" name="form2" method="post">
												<input type="text" name="file_div" value="img" style="display:none;"/>
												<input type="file" size="30" name="ATT_FILE_img" class="ATT_FILE" style="height: 23px; display:none;" id="file" />
												<a href="javascript:void(0);" class="btn_style1_b cmdFileUpload" id="cmdNew" style="display: table-cell; float: center;">
												<span class="fwb">&nbsp; 파일첨부 &nbsp;</span></a>&nbsp;&nbsp;
											</form>
										</div>
									</td>
									<td>
										<a href="javascript:" class="btn_style1_b" id="btnDel" style="display: inline-block;"><span>삭제</span></a>
									</td>
									</tr>
								</div>
								<div class="right" style="z-index: 100007;"></div>
							</div>
							<!-- //타이틀/검색 영역 -->
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
								<div class="tbl_layout" style="min-height:509px;min-width:100%;overflow-y:none;overflow-x:none;">
									<table class="tbl_result" summary="" id="tbl_content">
										<caption></caption>
										<colgroup></colgroup>
										<tfoot style="display:none;">
											<tr class="no_hover" style="display:table-row;">
												<td colspan="6" class="no_info"><div>내용이 없습니다.</div></td>
											</tr>
										</tfoot>
										<tbody><tr></tr></tbody>
									</table>
								</div>
							</div>
							<!-- table result -->
							
							<!-- Paging wrap -->
							<div class="paging_wrap">
								<div class="f_left n_paging_size"></div>
								<div class="paging" id="tbl_paging" style="border-top:0px;"></div>
							</div>
							<!-- //Paging wrap -->
							
						</div>
					</div>
				</div>
				<!-- Container -->
			</div>
			<%@include file="/view/jex/avatar/admin/include/com_footer.jsp"%>
		</div>
	</form>
	<%@include file="/view/jex/avatar/admin/include/com_bottom.jsp"%>
	<%@include file="/view/jex/avatar/admin/include/view_stgup.jsp"%>              

</body>
</html>