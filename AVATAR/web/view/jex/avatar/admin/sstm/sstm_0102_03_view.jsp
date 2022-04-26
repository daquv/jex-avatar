<%@page import="java.net.URLDecoder"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String dsdl_grp_cd = request.getParameter("DSDL_GRP_CD");
	String dsdl_grp_nm = StringUtil.null2void(URLDecoder.decode(request.getParameter("DSDL_GRP_NM"), "UTF-8"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : sstm_0102_03_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/sstm
 * @author           : 김태훈 (  )
 * @Description      : 
 * @History          : 20200306160652, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/sstm/sstm_0102_03.js
 * @JavaScript Url   : /js/jex/avatar/admin/sstm/sstm_0102_03.js
 * </pre>
 **/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<title>Hello</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="Cache-Control" content="No-Cache" />
<meta http-equiv="Pragma" content="No-Cache" />

<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/js/jex/avatar/admin/sstm/sstm_0102_03.js?<%=DateTime.getInstance().getDate("yyyymmddhh24miss")%>"></script>
<style>
	.invalid{border:1px solid #f00! important;}
</style>
</head>
<body style="">
	<input type="hidden" value="<%=dsdl_grp_cd  %>" id="_DSDL_GRP_CD" />
	<div class="pop_wrap" id="pop-view01" style="width:auto;">
		<!-- 팝업 헤더 -->
		<div class="pop_header">
			<h1>세부코드관리</h1>
			<a href="javascript:"  class="btn_popclose popupClose" id="btnCloseImg">
				<img alt="팝업닫기" src="../admin/img/btn/btn_popclose.gif"/>
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
						<col style="width: 140px;"/>
						<col/>
						<col style="width: 140px;"/>
						<col/>
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><div>그룹코드</div></th>
							<td class="ipt">
								<% if(dsdl_grp_nm != null && !dsdl_grp_nm.isEmpty()){  %>
								<div  id="DSDL_GRP_CD">
									<%=dsdl_grp_cd %> - (<%=dsdl_grp_nm %>)									
								</div>
								<% } else{ %>
								<div  id="DSDL_GRP_CD">
									<%=dsdl_grp_cd %>
								</div>
								<%} %>
							</td>	
							<th scope="row"><div>그룹코드명</div></th>
							<td class="ipt">
								<div id="DSDL_GRP_NM">		
								<%=dsdl_grp_nm %>							
								</div>
							</td>						
						</tr>
						<tr>
							<th scope="row"><div>세부코드*</div></th>
							<td class="ipt">
								<div id="action_create">
									<input id="DSDL_ITEM_CD" type="text" value="" maxlength="20" style="width: 192px;"/>
								</div>
								<div id="action_update">
									<div id="DSDL_ITEM_CD_UPDATE"></div>
								</div>
							</td>
							<th scope="row"><div>세부코드명*</div></th>
							<td class="ipt">
								<div>
									<input id="DSDL_ITEM_NM" type="text" value="" maxlength="50" style="width: 192px;"/>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row"><div>사용여부*</div></th>
							<td class="ipt">
								<div>
									<select id="ACVT_STTS" style="width: 100px;">
										<option value="Y">사용</option>
										<option value="N">사용안함</option>
									</select>
								</div>
							</td>
							
							<th scope="row"><div>출력순서</div></th>
							<td class="ipt">
								<div>
									<input id="OTPT_SQNC" type="text" value="" maxlength="5"
										style="width: 192px;" />
								</div>
							</td>							
						</tr>
						<tr>
							 <th scope="row" style="height: 60px;"><div>설명</div></th>
                             <td colspan="3">
	                             <div>
	                                 <textarea id="RMRK" type="text" value="" placeholder="기타사항" maxlength="100"
	                                      style="width: 100%; height: 60px;"></textarea>
	                             </div>
                             </td>
							
						</tr>
						
					</tbody>
				</table>
			</div>
			<!-- //table input -->

			<!-- 초기화/저장/삭제 영역 -->
			<div class="title_wrap mgb20">
				<div class="right">
					<a href="#none" class="btn_style1_b" id="btnReset"><span>초기화</span></a> 
					<a href="#none" class="btn_style1_b" id="btnSave"><span>저장</span></a> 
					<a href="#none" class="btn_style1_b" id="btnDelete"><span>삭제</span></a>
				</div>
			</div>
			<!-- //저장/취소 영역 -->		
			
			<!-- table result -->
			
			 <div class="list_scroll_top" style="overflow:hidden;">
                    <table class="tbl_result table_header" summary="" id="tbl_title_1">
                        <caption></caption>
                        <colgroup></colgroup>
                        <thead><tr></tr></thead>
                    </table>
                </div>
                <div class="tbl_layout table_body" style="min-height: 180px;min-width:100%;overflow-y:auto;overflow-x:auto;">
                    <table class="tbl_result" summary="" id="tbl_content_1">
                        <caption></caption>
                        <colgroup></colgroup>
                        <tfoot style="display:none;">
                            <tr class="no_hover" style="display:table-row;">
                                <td colspan="5" class="no_info"><div>내용이 없습니다.</div></td>
                            </tr>
                        </tfoot>
                        <tbody ><tr></tr></tbody>
                    </table>
                </div>
		
			<!-- //table result -->
			
			<!-- 닫기 -->
			<div class="title_wrap mgb20" style="margin-top: 15px">
				<div class="right">
					<a href="#none" class="btn_style1" id="btnClose"><span>닫기</span></a> 				
				</div>
			</div>
			<!-- 닫기 -->
		</div>
		<!-- //팝업 컨텐츠 -->	
	  
	</div>

</body>

</html>
