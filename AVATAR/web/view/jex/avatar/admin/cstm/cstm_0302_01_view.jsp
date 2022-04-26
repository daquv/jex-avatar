<%@page import="jex.sys.JexSystemConfig"%>
<%@page import="java.net.URLDecoder"%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="jex.web.util.WebCommonUtil"%>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
	String _sLocalTime_comm = DateTime.getInstance().getDate("yyyymmddhh24miss");
                        
    // Action 결과 추출
    String excelFilePath = JexSystemConfig.get("FileStorage","path")+"bzaq/excelform";
	String excelFileNm = "excelform_bzaqHead.xlsx";
	
	String strFileSavePath = "bzaq";
	String strCallBackFn = "fn_fileuploadCallback";
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : cstm_0302_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/cstm
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20210407170634, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/cstm/cstm_0302_01.js
 * @JavaScript Url   : /js/jex/avatar/admin/cstm/cstm_0302_01.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title>거래처관리</title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/admin/js/include/smart.grid.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript" src="/admin/js/include/smart.excel.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript" src="/js/jex/avatar/admin/cstm/cstm_0302_01.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript">
	excelFilePath = '<%=excelFilePath%>';
	excelFileNm = '<%=excelFileNm%>';
</script>
<style>
	.bg_line {display:block;min-height:16px;padding:3px 0 2px;border:1px solid #fff;}
	.bg_line.ipt {padding:3px 2px 2px;border:1px solid #cbcbcb;}
	.bg_line.err {padding:3px 2px 2px;border:1px solid #f00 !important;}
	.bg_line input[type=text] {padding:0;border:0;color:#000;}
	.editbtn_top_box ul.tab {text-align: left;padding: 15px 0 0;position: relative;}
	.editbtn_top_box ul.tab li:first-child {padding-left: 0;background: 0;}
	.editbtn_top_box ul.tab li {float: left;padding: 0 9px 0 10px;}
</style>
</head>
<body class=""><!-- [D] (PARK)20161012 : 메뉴영역(접기 : class="fold") -->
	<form method="post" enctype="multipart/form-data" id="frm">
		<input type="hidden" name="FILE_SAVE_PATH" value="<%=strFileSavePath%>"/>
		<input type="hidden" name="CALLBACK_FN" value="<%=strCallBackFn%>"/>
		<div class="wrap">
		<!-- Container -->
			<div class="container"><!-- [D] (PARK)20161012 : 메뉴영역(접기 : class="fold") -->
				<jsp:include page="/view/jex/avatar/admin/include/com_menu.jsp">
					<jsp:param name="MENU" value="srvc"/>
				</jsp:include>
				<!-- content wrap -->
				<div class="content">
					<div class="content fold"><!-- [D] (PARK)20161012 : 메뉴영역(접기 : class="fold") -->

						<div class="content_wrap">

							<!-- 타이틀/검색 영역 -->
							<div class="title_wrap">
								<div class="left" style="position:relative;z-index:100006;">
									<h1>독음관리(등록)</h1>
								</div>
							</div>
							<!-- //타이틀/검색 영역 -->

							<!-- 공지사항 -->
							<div class="top_infobox3 mgt20">
								엑셀양식을 다운받아 작성규칙에 맞게 작성해 주시기 바랍니다.<br>
								※ <em class="point"></em> 컬럼은 필수 항목입니다. 필수 항목이 입력되어 있지않은 경우 저장되지 않습니다.<br>
								※ 첫번째행은 제목으로 간주하여 등록되지 않습니다.<br>
							</div>
							<!-- //공지사항 -->

							<div class="file_wrap tac mgt50" name="divFileSvae">
								<!-- <input type="text" style="width:300px;"> -->
								
								<div>
									<input type="file" size="30" name="ATT_FILE_bzaq" id="ATT_FILE" style="height: 23px; display:none;" />
									<a href="#" class="btn_style1_b" id="btnOpen"><span>파일열기</span></a>
									<a href="#none" class="btn_style1" id="btnFile"><span class="normal">양식 다운로드</span></a>
								</div>
								
								
							</div>
							
							<div class="editbtn_top_box" style="display: none;" name="divResult">
								<ul class="tab">
									<li class=""><a href="#none" style="display: inline-block;color:blue;" id="clearData">정상<span class="no txt_blue">(1)</span></a></li><!-- 활성화클래스 on -->
									<li><a href="#none" style="display: inline-block;color:red;" id="errData">오류<span class="no txt_r">(2)</span></a></li>
								</ul>
							</div>
					
							<!-- 리스트 테이블 -->
							<div class="tbl_layout"style="display: none;"  name="divResult">
								<table class="tbl_result" summary="" id="tbl_title" >
									<caption></caption>
									<colgroup>
										<col style="width:120px;">
										<col style="width:250px;">
										<col style="width:200px;">
										<col style="width:200px;">
										<col>
									</colgroup>
									<thead style="display:;">
										<tr>
											<th scope="col"><div>사업자번호</div></th>
											<th scope="col"><div>거래처명</div></th>
											<th scope="col"><div>표제어</div></th>
											<th scope="col"><div>독음</div></th>
											<th></th>
										</tr>
									</thead>
									<tfoot style="display: none;">
										<tr class="no_hover" style="display:none;"><!-- [D] style="display:table-row;" -->
											<td colspan="7" class="no_info"><div style="line-height:57px;">조회 내역이 없습니다.</div></td><!-- (modify)20170524 -->
										</tr>
									</tfoot>
									<tbody id="tbl_content_s">
										<tr>
											<td><div>201906_001</div></td>
											<td><div class="tar">100,000</div></td>
											<td><div>2019-07-01</div></td>
											<td><div>2021-07-01</div></td>
											<td><div>경리나라 실무교육 e</div></td>
											<td><div></div></td>
										</tr>
									
									</tbody>
									<tbody id="tbl_content_e">
										<tr>
											<td><div>201906_001</div></td>
											<td><div class="tar">100,000</div></td>
											<td><div>2019-07-01</div></td>
											<td><div>2021-07-01</div></td>
											<td><div>경리나라 실무교육</div></td>
											<td><div></div></td>
										</tr>
										
									</tbody>
								</table>
							</div>
							<!-- //리스트 테이블 -->
							
							<div class="tac mgt15" style="display: none;" name="divResult">
								<a href="#none" class="btn_style1_b" id="btnSave"><span>저장</span></a>
							</div>
					
						</div>

					</div>
					<!-- //content wrap -->
				</div>
			</div>
			<!-- //Container -->

		</div>
		<%@include file="/view/jex/avatar/admin/include/com_footer.jsp"%>
	</form>
	<%@include file="/view/jex/avatar/admin/include/com_bottom.jsp"%>
<%@include file="/view/jex/avatar/admin/include/view_stgup.jsp"%>
</body>
</html>