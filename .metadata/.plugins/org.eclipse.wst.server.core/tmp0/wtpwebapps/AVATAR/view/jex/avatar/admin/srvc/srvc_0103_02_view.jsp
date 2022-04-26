<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%@page import="java.net.URLDecoder"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String INTE_CD = StringUtil.null2void(request.getParameter("INTE_CD"));
    String _sLocalTime_comm = DateTime.getInstance().getDate("yyyymmddhh24miss");
%>

<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : srvc_0103_02_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/admin/srvc
 * @author           : 김별 (  )
 * @Description      : 
 * @History          : 20200309165447, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/admin/srvc/srvc_0103_02.js
 * @JavaScript Url   : /js/jex/avatar/admin/srvc/srvc_0103_02.js
 * </pre>
 **/
%>

<!DOCTYPE html>
<html lang="ko" xml:lang="ko">
<head>
<title>질의센터관리</title>
<%@include file="/view/jex/avatar/admin/include/com_import.jsp" %>
<script type="text/javascript" src="/admin/js/include/smart.excel.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript" src="/admin/js/include/smart.grid.js?<%=_sLocalTime_comm %>"></script>
<script type="text/javascript" src="/js/jex/avatar/admin/srvc/srvc_0103_02.js?<%=_sLocalTime_comm %>"></script>
<style>
	#tbl_view td{
		border-top:none;
	}
	.tbl_api1 td{
		border-lfet: 1px solid #ddd !important;
	}
	.tab-content .tbl_input2 td{
		border-top:1px solid #ddd !important;
	}
	 tr.text-dot td div{
	  width : 80%;
	  overflow:hidden;
	  /* display:inline-block; */
	  text-overflow: ellipsis;
	  white-space: nowrap;
	}
	.tabs tbody input[type=radio] {
		top: -9999px;
		left: -9999px;
		
	}
	input[name='tabs'] {
		position: absolute;
		top: -9999px;
		left: -9999px;
		visibility : hidden;
	}
      .tabs {
        float: none;
        list-style: none;
        position: relative;
        padding: 0;
      
      }
      .tabs li{
        float: left;
      }
      .tabs label {
        display: block;
	    padding: 10px 50px;
	    border-radius: 2px 2px 0 0;
	    color: #b7b7b7;
	    font-size: 14px;
	    font-weight: normal;
	    background: #f0f1f3;
	    cursor: pointer;
	    position: relative;
	    font-weight: bold;
	    height: 13px;
	    
	    border: 1px solid #ababab;
	    border-radius: 3px;
      }
      .tabs label:hover {
        background: #e2e2e2;
        color: #696969;
      }
       
      [id^=tab]:checked + label {
        background: #cccccc;
   		border: 1px solid #525252;
    	color: black;     
      }
       
      [id^=tab]:checked ~ [id^=tab-content] {
          display: block;
      }
      .tab-content{
        z-index: 2;
        display: none;
        text-align: left;
        width: 100%;
        line-height: 140%;   
        /* padding: 15px 0 15px 0; */
        position: absolute;
        top: 33px;
        left: 0;
        box-sizing: border-box;
        border-top: 2px solid #828282
      }
      
      .rmng-pnt{
      	color:blue;
      	
      }
      
      
      .show_text{
      	color:#00f !important;
      	text-decoration:underline !important;
      }
      .btn_lr{
      	text-align: center;
      	padding: 20px;
      }
</style>
</head>
<body >
	<input type="hidden" id="INTE_CD_BASE" value='<%= INTE_CD  %>' />
	<form id="frm" action="" >
		<div class="wrap">
			<!--  Container -->
			<div class="container">
				<jsp:include page="/view/jex/avatar/admin/include/com_menu.jsp">
					<jsp:param name="MENU" value="srvc"/>
				</jsp:include>
				<div class="content">
					<div class="content fold">
						<div class="content_wrap">
			
						<!-- 타이틀/검색 영역 -->
						<div class="title_wrap mgb15">
							<div class="left" style="width: 210px;float:left"><h1>인텐트관리</h1></div>
							<div  style="float: right;">
							<a href="javascript:void(0);" class="btn_style1_b cmdSave"><span>저장</span></a>
									<a href="srvc_0103_01.act" class="btn_style1 cmdCancel"><span>취소</span></a></div>
						</div>
						
				
						<div class="div_body">
							<!-- (서브)타이틀 -->
							<div class="title2nd_wrap cboth mgb5">
								<div class="left" style="float:left;">
									<div class="title"> 
         								<strong class="tx_title txt_b">[<span>기본정보</span>]</strong> 
         							</div>
								</div>
								<div class="right" style="float:right;">
									
								</div>
							</div>
							<!-- //(서브)타이틀 -->
					
							<!-- table input(2) : -->
							<div class="tbl_input2 mgb20">
								<table summary="">
								<caption></caption>
								<colgroup>
									<col style="width:140px;">
									<col>
									<col style="width:140px;">
									<col>
								</colgroup>
									<tbody>
										<tr>
											<th scope="row"><div>인텐트
												<%if("".equals(INTE_CD)){ %>
													<em class="point"></em>
												<%} %>
												</div></th>
											<td>
												<div>
													<%if("".equals(INTE_CD)){ %>
														<input type="text" class="pk" placeholder="" value="" id="INTE_CD" style="width:229px;" maxlength="10" />
													<%} else{%>
														<span id="INTE_CD"></span>
													<%} %>
												</div>
											</td>
											<th scope="row"><div>인텐트명<em class="point"></em></div></th>
											<td>
												<div>
													<input type="text" class="pk" placeholder="" value="" id="INTE_NM" style="width:90%" maxlength="100" />
												</div>
											</td>
										</tr>
										<tr>
											<th scope="row"><div>카테고리</div></th>
											<td>
												<div>
													<select id="CTGR_CD" class="pk" style="width:150px;"></select>
												</div>
											</td>
											<th scope="row"><div>APP_ID<em class=""></em></div></th>
											<td>
												<div>
													<select id="_APP_ID" style="width:150px;"></select>
												</div>
											</td>
										</tr>
										<!-- <tr>
											<th scope="row"><div>구분</div></th>
											<td colspan="3">
												<div>
													<label><input type="checkbox" class="DIV" value="01"> 아바타</label>
													<label><input type="checkbox" class="DIV" value="02"> 경리나라</label>
													<label><input type="checkbox" class="DIV" value="03"> 제로페이</label> 
												</div>
											</td>
										</tr> -->
										<tr>
											<th scope="row"><div>결과유형<em class=""></em></div></th>
											<td>
												<div>
													<select id="QUES_RSLT_TYPE" style="width:150px;"></select>
												</div>
											</td>
											<th scope="row"><div>레벨<em class=""></em></div></th>
											<td>
												<div>
													<select id="QUES_LVL" style="width:150px;"></select>
												</div>
											</td>
										</tr>
										<tr>
											<th scope="row"><div>상태<em class="point"></em></div></th>
											<td>
												<div>
													<select id="STTS" class="pk" style="width:150px;">
														<option value="1">사용</option>
														<option value="8">중지</option>
														<option value="9">삭제</option>
													</select>
												</div>
											</td>
											<th scope="row"><div>순서</div></th>
											<td>
												<div>
													<input type="text" placeholder="" value="0" id="OTPT_SQNC" style="width:229px;" maxlength="10" />
												</div>
											</td>
										</tr>
										<tr>
											<th scope="row"><div>질의내용</div></th>
											<td colspan="3">
												<div>
													<input type="text" class="pk" placeholder="" value="" id="QUES_CTT" style="width:90%;"/>
												</div>
											</td>
										</tr>
										<tr>
											<th scope="row"><div>설명</div></th>
											<td colspan="3">
												<div>
													<textarea id="MEMO" placeholder="" maxlength="1000" style="width: 90%; height: 40px;"></textarea>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							
							<div class="cont" id="VIEW">
								<!-- (서브)타이틀 -->
								<div class="title2nd_wrap cboth mgb5">
									<div class="left" style="float:left;">
										<div class="title"> <strong class="tx_title txt_b">[<span>화면구성</span>]</strong> </div>
									</div>
								</div>
								<!-- //(서브)타이틀 -->
								<!--  -->
								<div class="cont_wrap">
									<table class="tbl_input2 mgb20" id="tbl_view" style="border-bottom:none;">
										<colgroup>
											<col style="width:5%;">
											<col style="width:5%;">
											<col style="width:60%;">
											<col>
										</colgroup>
										<tbody>
											<tr>
												<td colspan="4"><div class="title"> <strong>[<span>VIEW Html</span>]</strong> </div></td>
											</tr>
											<tr>
												<td colspan="3">
													<div><textarea id="OTXT_HTML" class="html" placeholder="" style="width:100%; height: 300px;"></textarea></div>
												</td>
												<td rowspan="5" id="test" style="height:512px; padding:10px;" >
													<iframe src="ques_0000_00.act" style="height:100%; width:100%;" id="preview"></iframe>
												</td>
											</tr>
											<tr>
												<td colspan="3">
													<div class="right" style="float:right;">
														<a href="javascript:void(0);" class="btn_style1_b btn_preview"><span>미리보기</span></a>
													</div>
												</td>
											</tr>
											<!-- <tr>
												<td colspan="4"><div class="title"> <strong>[<span>Sample Html</span>]</strong> </div></td>
											</tr>
											<tr>
												<td colspan="3">
													<div><textarea id="SMPL_HTML" class="html" placeholder="" style="width:100%; height: 300px;"></textarea></div>
												</td>
											</tr> 
											<tr>
												<td colspan="3">
													<div class="right" style="float:right;">
														<a href="javascript:void(0);" class="btn_style1_b btn_preview"><span>미리보기</span></a>
													</div>
												</td>
											</tr>
											-->
											<tr>
												<td colspan="4"><div class="title"> <strong>[<span>VIEW 요청 / 응답값 매핑</span>]</strong> </div></td>
											</tr>
											<tr>
												<td colspan="3">
													<ul class="tabs">
														<li>
															<input type="radio" checked name="tabs" id="tab0" value="1">
															<label for="tab0" id="tab_db" >DB쿼리</label>
															<div id="tab-content1" class="tab-content">	          		
																<div id="view_query">
																	<div>
																		<table class="tbl_input2 mgb20">
																			<colgroup>
																				<col style="width:5%;">
																				<col style="width:5%;">
																				<col style="width:60%;">
																			</colgroup>
																			<tbody>
																				<tr>
																					<th scope="row"><div>SQL1</div></th>
																					<th scope="row">
																						<div>
																							<input type="radio" name="OTXT_SQL1_TYPE" value="F" > Field&nbsp; 
																							<input type="radio" name="OTXT_SQL1_TYPE" value="R" > Record
																						</div>
																					</th>
																					<td><div><textarea id="OTXT_SQL1" type="text" value="" placeholder=""   style="width:100%; height: 100px;"></textarea></div></td>
																				</tr>
																				<tr>
																					<th scope="row"><div>SQL2</div></th>
																					<th scope="row">
																						<div>
																							<input type="radio" name="OTXT_SQL2_TYPE" value="F" > Field&nbsp; 
																							<input type="radio" name="OTXT_SQL2_TYPE" value="R" > Record
																						</div>
																					</th>
																					<td><div><textarea id="OTXT_SQL2" type="text" value="" placeholder=""   style="width:100%; height: 100px;"></textarea></div></td>
																				</tr>
																				<tr>
																					<th scope="row"><div>SQL3</div></th>
																					<th scope="row">
																						<div>
																							<input type="radio" name="OTXT_SQL3_TYPE" value="F" > Field&nbsp; 
																							<input type="radio" name="OTXT_SQL3_TYPE" value="R" > Record
																						</div>
																					</th>
																					<td><div><textarea id="OTXT_SQL3" type="text" value="" placeholder=""   style="width:100%; height: 100px;"></textarea></div></td>
																				</tr>
																				<tr>
																					<th scope="row"><div>SQL4</div></th>
																					<th scope="row">
																						<div>
																							<input type="radio" name="OTXT_SQL4_TYPE" value="F" > Field&nbsp; 
																							<input type="radio" name="OTXT_SQL4_TYPE" value="R" > Record
																						</div>
																					</th>
																					<td><div><textarea id="OTXT_SQL4" type="text" value="" placeholder=""   style="width:100%; height: 100px;"></textarea></div></td>
																				</tr>
																			</tbody>
																		</table>
																	</div>
																</div>
															</div>
														</li>
														<li>
															<input type="radio" name="tabs" id="tab1" value="2">
															<label for="tab1" id="tab_api">API쿼리</label>
															<div id="tab-content1" class="tab-content">
																	<div id="">
																		<div class="title"><strong>API정보</strong></div>
																		<table class="tbl_input2 mgb20" id="tbl_apiInfo">
																			<colgroup>
																				<col style="width: 10%;">
																				<col>
																				<col style="width: 10%;">
																				<col>
																			</colgroup>
																			<tbody>
																				<tr>
																					<th scope="row"><div>API ID</div></th>
																					<td><div><span id="API_ID" style="padding-right:10px;"></span><a href="javascript:void(0);" class="btn_style1_g apiSearch" id="" colspan="1"><span>검색</span></a> </div></td>
																					<th scope="row"><div>앱명</div></th>
																					<td><div><span id="APP_ID"></span></div></td>
																				</tr>
																				<tr>
																					<th scope="row"><div>질의내용</div></th>
																					<td colspan="3"><div><span id="QUES_CTT2"></span></div></td>
																				</tr>
																			</tbody>
																		</table>

																		<div class="title"style="padding: 12px 10px 9px 10px;"><strong>API INPUT</strong></div>
																		<div style="padding-bottom:10px;">
																			<div class="table_layout" style="padding:0 !important;">
																				<table class="tbl_result tbl_api" id="tbl_input">
																					<colgroup>
																						<col >
																						<col >
																						<col >
																						<col >
																						<col >
																						<col width="30%">
																					</colgroup>
																					<thead>
																						<tr>
																							<th scope="col"><div>한글명</div></th>
																							<th scope="col"><div>영문명</div></th>
																							<th scope="col"><div>필드타입</div></th>
																							<th scope="col"><div>데이터타입</div></th>
																							<th scope="col"><div>데이터크기</div></th>
																							<th scope="col"><div>매핑변수</div></th>
																						</tr>
																					</thead>
																					<tfoot style="display:none;">
																						<tr class="no_hover" style="display:table-row;">
																							<td colspan="9" class="no_info"><div>내용이 없습니다.</div></td>
																						</tr>
																					</tfoot>
																					<tbody></tbody>
																				</table>
																			</div>
																		</div>
																		<div class="title"style="padding: 12px 10px 9px 10px;"><strong>API OUTPUT</strong></div>
																		<div>
																			<div class="table_layout" style="padding:0 !important;">
																				<table class="tbl_input2 tbl_api" id="tbl_output">
																					<colgroup>
																						<col >
																						<col >
																						<col >
																						<col >
																						<col >
																						<col width="30%">
																					</colgroup>
																					<thead>
																						<tr>
																							<th scope="col"><div>한글명</div></th>
																							<th scope="col"><div>영문명</div></th>
																							<th scope="col"><div>필드타입</div></th>
																							<th scope="col"><div>데이터타입</div></th>
																							<th scope="col"><div>데이터크기</div></th>
																							<th scope="col"><div>매핑변수</div></th>
																						</tr>
																					</thead>
																					<tfoot style="display:none;">
																						<tr class="no_hover" style="display:table-row;">
																							<td colspan="9" class="no_info"><div>내용이 없습니다.</div></td>
																						</tr>
																					</tfoot>
																					<tbody></tbody>
																				</table>
																			</div>
																			
																			<div class="table_layout table_output_rec" style="padding-top:10px;display:none;" >
																				<table class="tbl_input2" id="">
																					<colgroup>
																						<col >
																						<col >
																						<col >
																						<col >
																						<col >
																						<col width="30%">
																					</colgroup>
																					<thead>
																						<tr>
																							<th  colspan="6"><div class="rec_nm"></div></th>
																						</tr>
																					</thead>
																					<tbody><tr></tr></tbody>
																				</table>
																			</div>
																		</div>
																	</div>
																</div>
														</li>
													</ul>
													
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							
						</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
	<%@include file="/view/jex/avatar/admin/include/com_bottom.jsp"%>
	<%@include file="/view/jex/avatar/admin/include/view_stgup.jsp"%>              
</body>
</html>