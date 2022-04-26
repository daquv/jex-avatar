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
 * @File Name        : basic_0003_01_view.jsp
 * @File path        : AVATAR/web/view/jex/avatar/basic
 * @author           : 김별 (  )
 * @Description      : 데이터_데이터목록화면
 * @History          : 20200129105915, 김별
 * @Javascript Path  : AVATAR_STATIC/web/js/jex/avatar/basic/basic_0003_01.js
 * @JavaScript Url   : /js/jex/avatar/basic/basic_0003_01.js
 * </pre>
 **/
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width">
    <meta name="format-detection" content="telephone=no">
    <title></title>
    <%@include file="/view/jex/avatar/include/page_import_head.jsp"%>
    <script type="text/javascript" src="/js/jex/avatar/basic/basic_0003_01.js?<%=_CURR_DATETIME%>"></script>
</head>
<body>
<!-- content -->
<div class="content">

		<div class="m_cont"><!-- 하단 버튼 있는경우 m_cont_pd 추가 -->

			<div class="cont_pd20">
				<!-- 데이터 메인 -->
				<div class="data_mainw">
					<div class="inner">
						<table>
							<colgroup><col><col style="width:10px;"><col></colgroup>
							<tbody>
								<tr>
									<td><a class="mn mn1"><span class="ico"></span><span class="txt">금융</span></a></td>
									<td></td>
									<td><a class="mn mn2"><span class="ico"></span><span class="txt">매출</span></a></td>
								</tr>
								<tr>
									<td><a class="mn mn3"><span class="ico"></span><span class="txt">매입</span></a></td>
									<td></td>
									<td><a class="mn mn4"><span class="ico"></span><span class="txt">거래처</span></a></td>
								</tr>
								<tr>
									<td><a class="mn mn5"><span class="ico"></span><span class="txt">연락처</span></a></td>
									<td></td>
									<td></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- //데이터 메인 -->
			</div>

		</div>

		<!-- 마이크 버튼영역 -->
		<!-- <div class="btn_fix_r">
			<a class="btn_mic"></a>
		</div> -->
		<!-- //마이크 버튼영역 -->

	</div>
	
	<!-- 
	<div class="content">

		<div class="m_cont m_cont_pd">하단 버튼 있는경우 m_cont_pd 추가
			더보기 리스트영역
			<div class="set_list">
				<ul>
					<li>
						<div class="card">
							<h2>금융</h2>
							<div class="right">
								<a class="c_blue">가져오기</a>
							</div>
						</div>
						서브리스트
						<div class="sub" style="display:none;">
							<div class="card">
								<h2>기업 691-014272-01-015</h2>
								<div class="right">
									<a class="btn_arr"></a>
								</div>
							</div>
							<div class="card">
								<h2>국민 1123-4558-451-2</h2>
								<div class="right">
									<a class="btn_arr"></a>
								</div>
							</div>
						</div>
						//서브리스트
					</li>
					<li>
						<div class="card">
							<h2>매출</h2>
						</div>
						데이터 가져오기 클릭시 sub 클래스 display: block;
						서브리스트
						<div class="sub" style="display:;">
							<div class="card">
								<h2 class="c_gr">(세금)계산서</h2>
								<div class="right">
									<a class="c_blue">가져오기</a>
									<a class="btn_arr" style="display:none;"></a>
								</div>
							</div>
							<div class="card">
								<h2 class="c_gr">카드매출</h2>
								<div class="right">
									<a class="c_blue">가져오기</a>
									<a class="btn_arr" style="display:none;"></a>
								</div>
							</div>
							<div class="card">
								<h2 class="c_gr">현금영수증</h2>
								<div class="right">
									<a class="c_blue">가져오기</a>
									<a class="btn_arr" style="display:none;"></a>
								</div>
							</div>
						</div>
						//서브리스트
					</li>
					<li>
						<a>
							<div class="card">
								<h2>매입</h2>
							</div>
						</a>
						데이터 가져오기 클릭시 sub 클래스 display: block;
						서브리스트
						<div class="sub" style="display:;">
							<div class="card">
								미인증 데이터는 c_gr 클래스 추가
								<h2 class="c_gr">(세금)계산서</h2>
								<div class="right">
									<a class="c_blue">가져오기</a>
									<a class="btn_arr" style="display:none;"></a>
								</div>
							</div>
							<div class="card">
								<h2 class="c_gr">카드매입</h2>
								<div class="right">
									<a class="c_blue">가져오기</a>
									<a class="btn_arr" style="display:none;"></a>
								</div>
							</div>
							<div class="card">
								<h2 class="c_gr">현금영수증</h2>
								<div class="right">
									<a class="c_blue">가져오기</a>
									<a class="btn_arr" style="display:none;"></a>
								</div>
							</div>
						</div>
						//서브리스트
					</li>
					<li>
						<a>
							<div class="card">
								<h2>거래처</h2>
								<div class="right">
									<a class="c_blue">가져오기</a>
									<a class="btn_arr" style="display:none;"></a>
								</div>
							</div>
						</a>
					</li>
					<li>
						<a>
							<div class="card">
								<h2>연락처</h2>
								<div class="right">
									<a class="c_blue" >가져오기</a>
									<a class="btn_arr" style="display: none;"></a>style="display:none;" 

								</div>
							</div>
						</a>
					</li>
				</ul>
			</div>
			//더보기 리스트영역


		</div>

		마이크 버튼영역
		<div class="btn_fix_r">
			<a class="btn_mic"></a>
		</div>
		//마이크 버튼영역

	</div> -->
	<!-- //content -->

</body>
</html>