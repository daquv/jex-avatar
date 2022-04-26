<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    
	String DSDL_GRP_CD 	= StringUtil.null2void(request.getParameter("DSDL_GRP_CD"));    
	String DSDL_GRP_NM 	= StringUtil.null2void(request.getParameter("DSDL_GRP_NM"));
	String DSDL_KND_CD 	= StringUtil.null2void(request.getParameter("DSDL_KND_CD"));
	String OTPT_SQNC 	= StringUtil.null2void(request.getParameter("OTPT_SQNC"));
	String RMRK 		= StringUtil.null2void(request.getParameter("RMRK"));
	String ACVT_STTS 	= StringUtil.null2void(request.getParameter("ACVT_STTS"));
	String MOD 			= StringUtil.null2void(request.getParameter("MOD"));    
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : sstm_0102_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/sstm
 * @author           : 김태훈 (  )
 * @Description      : 
 * @History          : 20200306160552, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/sstm/sstm_0102_02.js
 * @JavaScript Url   : /js/jex/avatar/admin/sstm/sstm_0102_02.js
 * </pre>
 **/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<title>그룹코드관리</title>

<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="Cache-Control" content="No-Cache" />
<meta http-equiv="Pragma" content="No-Cache" />

<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/js/jex/avatar/admin/sstm/sstm_0102_02.js?<%=DateTime.getInstance().getDate("yyyymmddhh24miss")%>"></script>
<script type="text/javascript">
_thisInfm.MOD 			= '<%=MOD%>';
_thisInfm.DSDL_GRP_CD 	= '<%=DSDL_GRP_CD%>';
_thisInfm.DSDL_GRP_NM 	= '<%=DSDL_GRP_NM%>';
_thisInfm.OTPT_SQNC 	= '<%=OTPT_SQNC%>';
_thisInfm.RMRK 			= '<%=RMRK%>';
_thisInfm.ACVT_STTS 	= '<%=ACVT_STTS%>';
$(function(){_thisPage.onload();});
</script>

<style>
	.invalid{border:1px solid #f00! important;}
	.pop_wrap .pop_container{
	    padding: 20px 20px 30px 20px;
	    border: 0;
	}
</style>
</head>

<body >

<div class="pop_wrap" id="pop-view01" style="width:auto;">

    <!-- 팝업 헤더 -->
   <div class="pop_header">
		<h1>그룹코드등록</h1>
		<a href="javascript:" class="btn_popclose popupClose">
			<img alt="팝업닫기" src="../admin/img/btn/btn_popclose.gif"/>
		</a>
	</div>
    <!-- //팝업 헤더 -->

    <!-- 팝업 컨텐츠 -->
    <div class="pop_container">
				<div class="tbl_input2 mgb20">
					<table summary="">
						<caption></caption>
						<colgroup>
							<col style="width: 140px;" />
							<col />
							<col style="width: 140px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row"><div>코드종류*</div></th>
								<td class="ipt">
									<%if("N".equals(MOD)){ %>
									<div>
										<select id="DSDL_KND_CD" style="width: 100px;">
											<option value="">선택하세요.</option>
											<option value="S">시스템 (S)</option>
											<option value="B">업무 (B)</option>
											<option value="U">사용자 (U)</option>
										</select>
									</div>
									<%}else {%>
									<div  id="DSDL_KND_CD">
										<%="S".equals(DSDL_KND_CD)?"시스템 (S)":"U".equals(DSDL_KND_CD)?"사용자 (U)":"업무 (B)" %>
									</div>
									<%} %>
								</td>							
							</tr>
							<tr>
								<th scope="row"><div>그룹코드*</div></th>
								<td class="ipt">
									<%if("N".equals(MOD)){ %>
									<div>
										<input id="DSDL_GRP_CD" type="text" value="" maxlength="20"
											style="width: 192px;"/> 
									</div>
									<%}else {%>
									<div id="DSDL_GRP_CD">
										<%=DSDL_GRP_CD%>
									</div>
									<%} %>
								</td>
								<th scope="row"><div>그룹코드명*</div></th>
								<td class="ipt">
									<div>
										<input id="DSDL_GRP_NM" type="text" value="<%=DSDL_GRP_NM%>" maxlength="50"
											style="width: 192px;"/>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row"><div>출력순서</div></th>
								<td class="ipt">
									<div>
										<input id="OTPT_SQNC" type="text" value="<%=OTPT_SQNC %>" maxlength="5"
											style="width: 192px;" />
									</div>
								</td>
								<th scope="row"><div>사용여부</div></th>
								<td class="ipt">
									<div>
										<select id="ACVT_STTS" style="width: 100px;">
											<option value="Y">사용</option>
											<option value="N">사용안함</option>
	
										</select>
									</div>
								</td>
							</tr>
							<tr>
								 <th scope="row" style="height: 60px;"><div>설명</div></th>
	                             <td colspan="3">
		                             <div>
		                                 <textarea id="RMRK"   placeholder="기타사항" maxlength="100"
		                                      style="width: 100%; height: 60px;"></textarea>
		                             </div>
	                             </td>
								
							</tr>
							
						</tbody>
					</table>
				</div>
				<!-- //table input -->
	
				<!-- 저장/취소 영역 -->
				<div class="title_wrap mgb20">
					<div class="right">
						<a href="javascript:;" class="btn_style1_b" id="btnAdd"><span>저장</span></a>
						<%if("Y".equals(MOD)){ %> 
						<a href="javascript:;" class="btn_style1_b" id="btnDel"><span>삭제</span></a>
						<%} %> 
						<a href="javascript:;" class="btn_style1" id="btnCancel"><span>취소</span></a>
					</div>
				</div>
				<!-- //저장/취소 영역 -->
		
    </div>
    <!-- //팝업 컨텐츠 -->


</div>

</body>
</html>