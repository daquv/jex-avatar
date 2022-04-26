/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : sstm_0201_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/sstm
 * @author         : 김태훈 (  )
 * @Description    : 어드민 고객별결과조회 팝업 화면
 * @History        : 20200410151324, 김태훈
 * </pre>
 **/
_thisPage = {
		fn_init: function(){
			_thisPage.fn_grid();
			_thisPage.fn_search();
		}
		,fn_search : function(pageNo){
			
			var jexAjax = jex.createAjaxUtil("sstm_0201_02_r001");   //PT_ACTION 웹 서비스 호출
			jexAjax.set("DV_CD", $('input:radio[name="DV_CD"]:checked').val());
			jexAjax.set("STTS", $('input:radio[name="STTS"]:checked').val());
			jexAjax.set("USE_INTT_ID", $("#USE_INTT_ID").val());
			
			jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
			jexAjax.execute(function(dat) {

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
					if(v.HIS_LST_DT){
						v.HIS_LST_DT = fintech.common.formatDtm(v.HIS_LST_DT);
					}
					
					if(v.REG_DTM){
						v.REG_DTM = fintech.common.formatDtm(v.REG_DTM);
					}

					sHtml += "<tr class='text-dot' trIdx=\""+i+"\">";
					sHtml += view_stgup.makeTableTbody(v,i);
					sHtml += "</tr>";
				});	
				$(tbl_content).find("tbody").append(sHtml);
			}
		},
		fn_grid: function(){
			var list = [];
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"GB",				VIEW_NM:"데이터가져오기",		VIEW_STYLE : "width=120px; text-align=center;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"PROC_RSLT_NM",		VIEW_NM:"등록정보",			VIEW_STYLE : "width=200px; text-align=center;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"HIS_LST_DT",		VIEW_NM:"최종조회일시",			VIEW_STYLE : "width=130px; text-align=center;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"HIS_LST_STTS_NM",	VIEW_NM:"수집상태",			VIEW_STYLE : "width=80px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"HIS_LST_STTS",		VIEW_NM:"수집결과코드",			VIEW_STYLE : "width=90px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"HIS_LST_MSG",		VIEW_NM:"수집결과메시지",		VIEW_STYLE : "width=180px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"REG_DTM",			VIEW_NM:"작업일시",			VIEW_STYLE : "width=130px;"});
			
			view_stgup.fn_search(true, "TABLE", list);
			view_stgup.makeTable("tbl_title", false, _thisPage.fn_search, false, false);
			_paging = $("#tbl_paging").tablePaging("tbl1", _thisPage.fn_search, _thisPage.cb_search, "1", "15", "Y", null);
			_paging.initPage();
		}
}


$(function(){
	
	_thisPage.fn_init();
	$("input[type='radio'").click(function(e) {
		_thisPage.fn_init();
	});
	
	//취소
	$(".popupClose, #btn_popclose").on("click", function(){
		parent.smartClosePop();
	});
	
});