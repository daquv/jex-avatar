/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : sttc_0201_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/sttc
 * @author         : 김태훈 (  )
 * @Description    : 어드민 로그인현황 팝업
 * @History        : 20200309140920, 김태훈
 * </pre>
 **/

_thisPage = {
		
		fn_init: function(){
			_thisPage.fn_grid();
			_thisPage.fn_search();
		}
		,fn_search : function(pageNo){
			
			var jexAjax = jex.createAjaxUtil("sttc_0201_02_r001");   //PT_ACTION 웹 서비스 호출
			jexAjax.set("USE_INTT_ID"	, $("#USE_INTT_ID").val());     			// 고개번호
			jexAjax.set("INQ_DT_DV_CD"	, $("#INQ_DT_DV_CD").val()); 					// 조회일자구분코드
			jexAjax.set("INQ_STR_DT"	, $("#INQ_STR_DT").val().replace(/-/g,''));	// 조회시작일자
			jexAjax.set("INQ_END_DT"	, $("#INQ_END_DT").val().replace(/-/g,''));		// 조회종료일자
			jexAjax.set("INQ_YM"		, $("#INQ_YM").val().replace(/-/g,''));	// 조회년월
			
			jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
			jexAjax.execute(function(dat) {
				$("#LOGIN_CNT").text(dat.CNT);
				_paging.setPaging(dat.REC);     	// 레코드 데이터 정보
			});
		},
		cb_search : function(tbl, rec){
			var tbl_title = $("#tbl_title");
			var tbl_content = $("#tbl_content");
			
			$(tbl_content).find("colgroup").remove();
			$(tbl_title).find("colgroup").clone().prependTo($(tbl_content));
			$(tbl_content).find("tfoot").remove();
			$(tbl_content).find("tbody").find("tr").remove();
			
			
			if(rec.length == 0) {
				var sHtml = "";		
				sHtml += '<tfoot>';
				sHtml += '    <tr class="no_hover" style="display:table-row;">';
				sHtml += '        <td colspan="'+$("#tbl_content").find("colgroup").find("col").length+'" class="no_info"><div>내용이 없습니다.</div></td>';
				sHtml += '    </tr>';
				sHtml += '</tfoot>';
				$(tbl_content).prepend(sHtml);
			}
			else{
				var sHtml = "";		
				$.each(rec, function(i, v) {
					
					if(v.LOGIN_DT){
						if(v.LOGIN_TM){
							v.LOGIN_DTM = fintech.common.formatDtm(v.LOGIN_DT+v.LOGIN_TM);
						} else {
							v.LOGIN_DTM = fintech.common.formatDate(v.LOGIN_DT);
						}
					} else {
						v.LOGIN_DTM = "";
					}
					
					sHtml += "<tr class='text-dot' trIdx=\""+i+"\" style=\"word-break: break-all;\">";
					sHtml += view_stgup.makeTableTbody(v,i);
					sHtml += "</tr>";
				});	
				$(tbl_content).find("tbody").append(sHtml);
			}
		},
		fn_grid: function(){
			var list = [];
			
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"LOGIN_DTM",    VIEW_NM:"로그인일시",   	VIEW_STYLE : "width=130px; text-align=center;"});
//			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CUST_CI",      VIEW_NM:"고객CI",    		VIEW_STYLE : "width=400px; text-align=center;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"ACCS_SVR",     VIEW_NM:"구동서버",   		VIEW_STYLE : "width=130px; text-align=center;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"ACCS_IP",     	VIEW_NM:"접속아이피",     	VIEW_STYLE : ""});
			
			view_stgup.fn_search(true, "TABLE", list);
			view_stgup.makeTable("tbl_title", false, _thisPage.fn_search, false, false);
			_paging = $("#tbl_paging").tablePaging("tbl1", _thisPage.fn_search, _thisPage.cb_search, "1", "15", "Y", null);
			_paging.initPage();
			
		},
		fn_initData: function(){
			var jexAjax = jex.createAjaxUtil("srvc_0301_02_r002");   //PT_ACTION 웹 서비스 호출
			jexAjax.set("BANK_ID", $("#bank_id").val());      // 뱅킹ID
			jexAjax.execute(function(data){

				$("#BSNN_NM").html(data.BSNN_NM);
				if( data.BSNN_NO != null && data.BSNN_NO != ''){
					$("#BSNN_NO").html(data.BSNN_NO.replace(/(\d{3})(\d{2})(\d{5})/,'$1-$2-$3'));
				}
				$("#RPPR_NM").html(data.RPPR_NM);
				$("#USER_ID").html(data.USER_ID);
				
			});
			
			$("#USER_LOGIN_CNT").html(formatter.number(parseInt($("#user_login_cnt").val())) + "회");
			if( $("#user_login_date").val() != null && $("#user_login_date").val() != ''){
				$("#USER_LOGIN_DATE").html($("#user_login_date").val());
			}
		}
}
$(function(){
	_thisPage.fn_init();
//	_thisPage.fn_initData();
	
	//EVENT
	//취소
	$(".popupClose, .btn_style1_b").on("click", function(){
		parent.smartClosePop();
	});
});