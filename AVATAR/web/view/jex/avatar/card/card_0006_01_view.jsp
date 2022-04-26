<%@page import="java.net.URLDecoder"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
                        
    // Action 결과 추출
    String CARD_LIST = StringUtil.null2void(request.getParameter("CARD_LIST"));
//    	CARD_LIST = URLDecoder.decode(CARD_LIST, "UTF-8") ;
%>
<%
/**
 * <pre>
 * (__SHARP__)
 * JEXSTUDIO PROJECT
 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
 *
 * @File Name        : card_0006_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/card
 * @author           : 김태훈 (  )
 * @Description      : 카드매입-카드정보완료화면
 * @History          : 20200128155825, 김태훈
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/card/card_0006_01.js
 * @JavaScript Url   : /js/jex/avatar/card/card_0006_01.js
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
	<script type="text/javascript" src="/js/jex/avatar/card/card_0006_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body class="bg_F5F5F5">
<input type="hidden" id="CARD_LIST" 	name="CARD_LIST" value="<%=CARD_LIST%>">
	<!-- content -->
	<div class="content" style="display: none;">

		<div class="m_cont pdt12"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<div class="impBankDataMsg_wrap" id="fail_dv" style="display:none;">
				<div class="impBankDataMsg_inn">
					<dl>
						<dt><img src="../img/ico_point01.png" alt=""></dt>
						<dd>
							<p>
								카드매입 데이터 가져오기가<br>
								<span class="c_793FFB">실패</span>하였습니다.
							</p>
						</dd>
					</dl>
				</div>
			</div>
		
			<!-- 상단문구 -->
			<div class="notibx_wrap type2" id="succ_dv" style="display:none;">
				<div class="inner fixH2">
					<div class="noti_tit">
						카드사 인증<span class="c_blue">완료</span>
					</div>
					<div class="ico ico_ipr04"></div>
					<div class="noti_tit">
						카드사에서<br>
						<span class="c_blue">최근 일주일 승인내역</span><br>
						데이터를 가져옵니다.
					</div>
					<div class="noti_txt">
						*데이터 양에 따라 시간이 소요될 수 있으며<br>
						익일 데이터 수집 후 최대 3개월치 데이터 조회가<br>
						가능합니다.
					</div>
				</div>
			</div>
			<!-- //상단문구 -->

			<!--
			<div class="tbl_acc_list" style="margin-top:27px;margin-bottom:8px;">
				<table>
					<colgroup><col><col style="width:65px;"></colgroup>
					<tbody>
						<%--
						<tr class="on"><!-- 활성화클래스 on -->
							<th>
								<div class="acc_tit">[비씨카드] 총 1건</div>
								<div class="acc_no">1234-****-****-1212</div>
							</th>
							<td>
								<div class="acc_r">완료</div>
							</td>
						</tr>
						<tr>
							<th>
								<div class="acc_tit">[비씨카드] 총 1건</div>
								<div class="acc_no">1234-****-****-1212</div>
								<div class="acc_txt"><span class="ico"></span>확인 후 다시 등록하세요.</div>
							</th>
							<td>
								<div class="acc_r">실패</div>
							</td>
						</tr>
						 --%>
					</tbody>
				</table>
			</div>
			-->
			<div class="impBankData_lst">
				<ul>
					<li>
					<!-- 
						<div class="tit">
							<h2>
								<span>[국민은행]</span>
								총 <em>1</em>개좌
							</h2>
						</div>
						<div class="sub">
							<div class="card">
								<h3>
									<span class="tx_cateNum">1005002156351</span>
								</h3>
								<div class="right">
									<span class="tx_succ">완료</span>
								</div>
							</div>
						</div>
					-->
					</li>
				</ul>
			</div>
		</div>

		<!-- 하단 fix버튼 -->
		<div class="btn_fix_botm">
			<div class="inner">
				<a style="display:none;" id="a_enter">확인</a>
				<a style="display:none;" id="c_enter">확인</a>
			</div>
		</div>
		<!-- //하단 fix버튼 -->

	</div>
	<!-- //content -->

</body>
</html>