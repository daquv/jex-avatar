<%@page import="com.avatar.session.AdminSessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="java.net.URLDecoder"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
	String _sLocalTime_comm = DateTime.getInstance().getDate("yyyymmddhh24miss");
                        
    // Action 결과 추출
    String USER_ID = StringUtil.null2void(request.getParameter("USER_ID"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : plfm_0101_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/plfm
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200709160328, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/plfm/plfm_0101_02.js
 * @JavaScript Url   : /js/jex/avatar/admin/plfm/plfm_0101_02.js
 * </pre>
 **/
%>
<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title></title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/js/jex/avatar/admin/plfm/plfm_0101_02.js?<%=_sLocalTime_comm %>"></script>
</head>
<script>
	USER_ID = '<%=request.getParameter("USER_ID")%>';
</script>
<body>
<input type="hidden" id="USER_ID_BASE" value="<%=USER_ID%>" />
	<div class="pop_wrap" style="width:792px;">
		<!-- 팝업 헤더 -->
		<div class="pop_header">
			<h1>사용자정보관리</h1>
			<a href="#none" class="btn_popclose popupClose"><img src="../img/btn_popclose.gif" alt="popup close"></a>
		</div>
		<!-- //팝업 헤더 -->

		<!-- 팝업 컨텐츠 -->
		<div class="pop_container">
			<div class="title2nd_wrap"> 
				<div class="left"> 
					<div class="title"> 
						<strong class="tx_title txt_b"><span>사용자 가입형태 및 이용권한</span></strong> 
					</div> 
				</div> 
			</div>
			<div class="tbl_input2 mgb20">
				<table summary="">
					<caption></caption>
					<colgroup>
						<col style="width: 140px;">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><div>가입상태</div></th>
							<td class="ipt">
								<div>
									<input type="radio" name="stts" value="2" id="stts2" /><label for="stts2">  신청대기  </label>
									<input type="radio" name="stts" value="3" id="stts3" /><label for="stts3">  승인대기  </label>
									<input type="radio" name="stts" value="1" id="stts1" /><label for="stts1">  정상  </label>
									<input type="radio" name="stts" value="9" id="stts9" /><label for="stts9">  해지  </label>
								</div>
							</td>	
						</tr>
						<tr>
							<th scope="row"><div>이용권란</div></th>
							<td class="ipt">
								<div id="action_create">
									<input type="radio" name="useAtht" value="1" id="useAtht1" /><label for="useAtht1">  관리자  </label>
									<input type="radio" name="useAtht" value="2" id="useAtht2" /><label for="useAtht2">  정보제공자  </label>
								</div>
						</tr>
						<tr>
							<th scope="row"><div>사용자구분</div></th>
							<td class="ipt">
								<div>
									<input type="radio" name="userGb" value="1" id="userGb1" /><label for="userGb1">  플랫폼  </label>
									<input type="radio" name="userGb" value="2" id="userGb2" /><label for="userGb2">  정보제공자  </label>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="title2nd_wrap"> 
				<div class="left"> 
					<div class="title"> 
						<strong class="tx_title txt_b"><span>사용자 가입정보</span></strong> 
					</div> 
				</div> 
			</div>			
			<div class="tbl_input2 mgb20">
				<table summary="">
					<caption></caption>
					<colgroup>
						<col style="width: 100px;">
						<col>
						<col style="width: 100px;">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th scope="row"><div>성명</div></th>
							<td class="ipt">
								<div>
									<input id="USER_NM" type="text" value="" maxlength="100" style="width: 60%;">
								</div>
								
							</td>
							<th scope="row"><div>아이디</div></th>
							<td class="ipt">
								<div id="">
									<% if("".equals(StringUtil.null2void(USER_ID))){  %>
										<input id="USER_ID" type="text" value="" maxlength="100" style="width: 60%;">
										<a style="margin-left:8px;" id="btn_chk"class="btn_style3" ><span>중복확인</span></a>
									<%} else if (!"".equals(StringUtil.null2void(USER_ID))){%>
										<span id="USER_ID"></span>
									<%} %>
									
								</div>
							</td>		
													
						</tr>
						<tr>
							<th scope="row"><div>이메일</div></th>
							<td class="ipt">
								<div id="">		
									<input id="EMAL" type="text" value="" maxlength="100" style="width: 60%;">
								</div>
							</td>
							<th scope="row"><div>휴대폰</div></th>
							<td class="ipt">
								<div>
									<input id="CLPH_NO" type="text" value="" maxlength="100" style="width: 60%;">
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row"><div>회사명</div></th>
							<td class="ipt">
								<div>
									<input id="BSNN_NM" type="text" value="" maxlength="100" style="width: 60%;" disabled>
									<a style="margin-left:8px;" id="btn_search"class="btn_style3" ><span>검색</span></a>
								</div>
							</td>
							
							<th scope="row"><div>부서명</div></th>
							<td class="ipt">
								<div>
									<input id="DEPT_NM" type="text" value="" maxlength="100" style="width: 60%;">
								</div>
							</td>							
						</tr>
						<tr>
							 <th scope="row" ><div>직급</div></th>
                             <td>
	                             <div>
	                                 <input id="OFLV" type="text" value="" maxlength="100" style="width: 60%;">
	                             </div>
                             </td>
							
						</tr>
						
					</tbody>
				</table>
			</div>
			
		<!-- 하단버튼 -->
		<div class="tac">
			<a href="javascript:void(0);" class="btn_style1_b cmdSave"><span>저장</span></a>
			<a href="javascript:void(0);" class="btn_style1 popupClose"><span>취소</span></a>
		</div>
		<!-- //하단버튼 -->

	</div>
	<!-- //팝업 컨텐츠 -->

</div>
</body>
</html>