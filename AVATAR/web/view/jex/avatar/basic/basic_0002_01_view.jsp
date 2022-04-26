<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String CALL_CERT 	= StringUtil.null2void(request.getParameter("CALL_CERT"));		//홈텍스 인증서 조회 실패 - 재전송 요청 시 
    String MENU_DV	 	= StringUtil.null2void(request.getParameter("MENU_DV"));		
    
    String DATA_DIV 	= StringUtil.null2void(request.getParameter("DATA_DIV"));		//data div
    
    JexDataCMO UserSession = SessionManager.getSession(request, response);
    String USE_INTT_ID = StringUtil.null2void((String)UserSession.get("USE_INTT_ID"));
    String CUST_NM = StringUtil.null2void((String)UserSession.get("CUST_NM"));
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : basic_0002_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 김태훈 (  )
 * @Description      : 데이터가져오기화면
 * @History          : 20200129103618, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0002_01.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0002_01.js
 * </pre>
 **/
%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="UTF-8">
	<title></title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="user-scalable=yes, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width">
	<%@include file="/view/jex/avatar/include/page_import_head.jsp"%>
	<script type="text/javascript" src="/js/jex/avatar/basic/basic_0002_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5">
<input type="hidden" id="CALL_CERT" value="<%=CALL_CERT%>" />
<input type="hidden" id="MENU_DV" value="<%=MENU_DV%>" />
<input type="hidden" id="DATA_DIV" value="<%=DATA_DIV%>" />
<input type="hidden" id="acct_price" value="1000" />
<input type="hidden" id="tax_price" value="1000" />
<input type="hidden" id="card_price" value="1000" />
<input type="hidden" id="snss_price" value="1000" />
	<!-- content -->
	<div class="content"> 
		<div class="m_cont" style="display:none;">
			<div>
			<!-- 데이터 -->
			<div class="data_wbx type1">
				<div class="ico_d01" ctgr="acct">
					<div class="cerStatus">
						<span class="conCompt">연결완료</span>
						<span class="cerEnd">인증서만료</span>
					</div>
					<dl name="a_data">
						<dt>은행</dt>
						<dd>통장 잔액 및 입출금 내역</dd>
					</dl>
					<div class="tbl_dataCol type1">
						<table>
							<colgroup>
							<col>
							<col style="width:82px;">
							<col style="width:82px">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row"><div>데이터 수집</div></th>
									<td>
										<div><label>일 1회<input name="acct_chk" id="acct_chk_n" type="checkbox"></label></div>
									</td>
									<td>
										<div><label>매 시간<input name="acct_chk" id="acct_chk_y" type="checkbox"></label></div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="ico_d02" ctgr="tax">
					<div class="cerStatus">
						<span class="conCompt">연결완료</span>
						<span class="cerEnd">인증서만료</span>
					</div>
					<dl name="a_data">
						<dt>홈택스</dt>
						<dd>국세청세금계산서, 현금영수증, 세액</dd>
					</dl>
					<div class="tbl_dataCol type1">
						<table>
							<colgroup>
							<col>
							<col style="width:82px;">
							<col style="width:82px">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row"><div>데이터 수집</div></th>
									<td>
										<div><label>일 1회<input name="tax_chk" id="tax_chk_n" type="checkbox"></label></div>
									</td>
									<td>
										<div><label>매 시간<input name="tax_chk" id="tax_chk_y" type="checkbox"></label></div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="ico_d03" ctgr="sale">
					<div class="cerStatus">
						<span class="conCompt">연결완료</span>
					</div>
					<dl name="a_data">
						<dt>여신금융협회</dt>
						<dd>신용카드 매출내역</dd>
					</dl>
					<div class="tbl_dataCol type1">
						<table>
							<colgroup>
							<col>
							<col style="width:82px;">
							<col style="width:82px">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row"><div>데이터 수집</div></th>
									<td>
										<div><label>일 1회<input id="sale_chk_n" type="checkbox" disabled></label></div>
									</td>
									<td><div></div></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="ico_d04" ctgr="card">
					<div class="cerStatus">
						<span class="conCompt">연결완료</span>
					</div>
					<dl name="a_data">
						<dt>카드사</dt>
						<dd>신용카드 사용내역</dd>
					</dl>
					<div class="tbl_dataCol type1">
						<table>
							<colgroup>
							<col>
							<col style="width:82px;">
							<col style="width:82px">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row"><div>데이터 수집</div></th>
									<td>
										<div><label>일 1회<input name="card_chk" id="card_chk_n" type="checkbox"></label></div>
									</td>
									<td>
										<div><label>매 시간<input name="card_chk" id="card_chk_y" type="checkbox"></label></div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- (add)20210721 -->
				<div class="ico_d06" ctgr="snss">
					<div class="cerStatus">
						<span class="conCompt">연결완료</span>
					</div>
					<dl name="a_data">
						<dt>온라인 매출</dt>
						<dd>배달의 민족, 요기요, 쿠팡이츠 매출내역</dd>
					</dl>
					<div class="tbl_dataCol type1">
						<table>
							<colgroup>
							<col>
							<col style="width:82px;">
							<col style="width:82px">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row"><div>데이터 수집</div></th>
									<td>
										<div><label>일 1회<input name="snss_chk" id="snss_chk_n" type="checkbox"></label></div>
									</td>
									<td>
										<div><label>매 시간<input name="snss_chk" id="snss_chk_y" type="checkbox"></label></div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- //(add)20210721 -->
				<!-- (add)20210729 -->
				<div class="ico_d07" ctgr="zeropay" style="display:none;">
					<div class="cerStatus">
						<span class="conCompt">연결완료</span>
					</div>
					<dl name="a_data">
						<dt>제로페이</dt>
						<dd>매출, 입금예정액, 가맹점데이터</dd>
					</dl>
				</div>
				<!-- //(add)20210729 -->
				<div class="ico_d05" ctgr="serp">
					<div class="cerStatus">
						<span class="conCompt">연결완료</span>
					</div>
					<dl name="a_data">
						<dt>경리나라</dt>
						<dd>거래처, 매출/매입, 금융데이터</dd>
					</dl>
				</div>
			</div>
			<!-- 데이터 -->
		</div>
			
			<!-- 
			// 2021.04.15 리뉴얼전 UI
			<div class="cont_pd20">
				<div class="data_wbx">
					<div class="ico_d01" ctgr="acct" name="a_data">
						<dl>
							<dt>은행</dt>
							<dd>통장 잔액 및 입출금 내역</dd>
						</dl>
					</div>
					<div class="ico_d02" ctgr="tax" name="a_data">
						<dl>
							<dt>홈택스</dt>
							<dd>국세청 세금계산서, 현금영수증</dd>
						</dl>
					</div>
					<div class="ico_d03" ctgr="sale" name="a_data">
						<dl>
							<dt>여신금융협회</dt>
							<dd>신용카드 매출내역</dd>
						</dl>
					</div>
					<div class="ico_d04" ctgr="card" name="a_data">
						<dl>
							<dt>카드사</dt>
							<dd>신용카드 사용내역</dd>
						</dl>
					</div>
					<div class="ico_d05" ctgr="serp" name="a_data">
						<dl>
							<dt>경리나라</dt>
							<dd>거래처, 매출/매입, 금융데이터</dd>
						</dl>
					</div>
				</div>
			</div>
			-->
		</div>

	</div>
	
	<div class="modaloverlay" id="modaloverlay1" style="display:none;">
		<div class="lytb"><div class="lytb_row"><div class="lytb_td">
		<div class="layer_style1">
			<div class="layer_po">
				<div class="cont">
					<div class="lyp_tit">
						데이터를 수집 중입니다.<br />
						잠시 후에 다시 시도해 주세요.
					</div>
				</div>
			</div>
			<div class="ly_btn_fix_botm">
				<a id="pop_btn01">확인</a>
			</div>
		</div>
		</div></div></div>
	</div>
	
	<div class="modaloverlay type2" id="modaloverlay2" style="display:none;">
		<div class="lytb">
			<div class="lytb_row">
				<div class="lytb_td type2">
					<!-- layerpopup -->
					<div class="layer_style1 type2">
						<div class="layer_po">
							<div class="cont">
								<h3 id="pop_tit"></h3>
								<input type="hidden" id="evdc_gb"/>
								<input type="hidden" id="pay_yn"/>
								<input type="hidden" id="use_pric"/>
								<div class="tbl_bankImp">
									<table>
										<colgroup>
										<col style="width:75px;">
										<col>
										<col style="width:30px;">
										</colgroup>
										<tbody>
											<tr>
												<th scope="row"><div>일 1회</div></th>
												<td><div><strong>무료</strong></div></td>
												<td><div class="tar chk"><input id="price_n" type="checkbox" disabled></div></td>
											</tr>
											<tr>
												<th scope="row"><div>매 시간</div></th>
												<td><div>월 <strong id="price"></strong> 원</div></td>
												<td><div class="tar chk"><input id="price_y" type="checkbox" disabled></div></td>
											</tr>
										</tbody>
									</table>
								</div>
								<span>2021년말까지 무료입니다.</span>
							</div>
						</div>
						<div class="ly_btn_fix_botm type2 btn_both"><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->
							<a id="pop_cancel_btn" class="off">취소</a>
							<a id="pop_confirm_btn" >확인</a>
						</div>
					</div>
					<!-- //layerpopup -->
				</div>
			</div>
		</div>
	</div>
</body>
</html>