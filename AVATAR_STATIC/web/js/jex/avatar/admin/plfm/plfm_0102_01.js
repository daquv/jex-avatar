/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : plfm_0102_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/plfm
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200710142338, 김별
 * </pre>
 **/
$(function(){
	_thisPage.fn_init();
	
	//전체 선택
	$(".btn_search_tb").on("click", function(){
		_thisPage.fn_init();
	});
	$("#cmdNew").on("click", function(){
		_thisPage.fn_regi();
	});
	$(document).on("click",".click_detail",function() {
		const data = {BIZ_NO : $(this).data("biz_no")};
		_thisPage.fn_detail(data);
	  });
});

var _thisPage = {
		fn_init : function(){
			_thisPage.fn_grid();
			_thisPage.fn_search();
		},
		fn_grid: function(){
			let list = [];
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"BSNN_NM",				VIEW_NM:"회사명",			VIEW_STYLE : "width=200px;",
					   ONCLICKYN:"Y", 
					   ONCLICK:"click_detail", 
					   ONCLICKDATA: "BIZ_NO"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"BIZ_NO",				VIEW_NM:"사업자번호",		VIEW_STYLE : "width=150px;", 	FORMATTER:"formatter.corpNum"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"RPPR_NM",				VIEW_NM:"대표자",			VIEW_STYLE : "width=100px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"TEL_NO",				VIEW_NM:"대표번호",		VIEW_STYLE : "width=150px;", 	FORMATTER:"formatter.phone"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"REG_DTM",				VIEW_NM:"등록일자",		VIEW_STYLE : "width=150px;", 	FORMATTER:"formatter.datetime"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"STTS",					VIEW_NM:"상태",			VIEW_STYLE : "width=100px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:""   , VIEW_NM:""});
			
			view_stgup.fn_search(false, "TABLE", list);
			view_stgup.makeTable("tbl_title", false, _thisPage.fn_search, false, false);
			_paging = $("#tbl_paging").tablePaging("tbl1", _thisPage.fn_search, _thisPage.cb_search, "1", "15", "Y", null);
			_paging.initPage();
			
		},
		fn_search : function(pageNo){
			var pageIndex = fintech.common.null2void(pageNo, "1");
			_pageNo = pageIndex;
			
			//페이지 처리와 검색을 수행시 상태값 체크값과 검색어 값을 수집하여 변수에 저장
			var jexAjax = jex.createAjaxUtil("plfm_0102_01_r001");   //PT_ACTION 웹 서비스 호출
			//가입일자, 상태, 검색대상
			input = {};
			input["SRCH_WD"] = $("#SRCH_WD").val();
			input["SRCH_CD"] = $("#SRCH_CD").val();
			var STTS = "";
			var stts = [];
			$('input.STTS:checked').each(function() {		
				stts.push(this.value);
			});
			STTS =  stts + "";
			input["STTS"] = STTS;
			input["PAGE_NO"] = pageIndex;
			input["PAGE_CNT"] = _paging.getPageSz();
			jexAjax.set(input);
			jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
			jexAjax.execute(function(data) {
				_paging.setTotDataSize(data.TOT_CNT);
				_paging.setPageNo(pageIndex);    	// 페이지 인덱스
				_paging.setPaging(data.REC);     	// 레코드 데이터 정보
				// 조회조건을 바꾸고 페이징 조회 호출하는 것 방지
				_paging.setParam(jexAjax, pageIndex);
			});
		},
		cb_search : function(tbl, rec){
			var tbl_title = $("#tbl_title");
			var tbl_content = $("#tbl_content");
			
			$(tbl_content).find("colgroup").remove();
			$(tbl_title).find("colgroup").clone().prependTo($(tbl_content));
			$(tbl_content).find("tfoot").remove();
			$(tbl_content).find("tbody").find("tr").remove();
			
			//paging 변경
			if($("#pagesizeList").find("li:eq(1)>a").attr("data-count")!=50){
				$("#pagesizeList").offset({top: $("#pagesizeList").offset().top+23});	
			}
			
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
				var page_index = $(".pag_num>a[class='on']").text()-0;
				var num_row 	=  $(".btn_combo_down>#pageSize").text()-0;
				var sHtml = "";		
				
				$.each(rec, function(i, v) {
					v.REG_DTM = fintech.common.formatDtm(v.REG_DTM);
					if(v.STTS == "1") {
						v.STTS = "정상";
					} else if(v.STTS == "9") {
						v.STTS = "해지";
					}
					
					sHtml += `<tr class='text-dot' trIdx='${i}'>`;
					sHtml += 	view_stgup.makeTableTbody(v,i);
					sHtml += "</tr>";
				});	
				$(tbl_content).find("tbody").append(sHtml);
			}
		}, 
		fn_regi : function(){
			smartOpenPop({href: "plfm_0102_02.act", width:792, height:475, scrolling:false, target:window});
		},
		fn_detail : function(data){
			var $form = $("<form method='post'></form>");
			//$form.append("<input name='BIZ_NO'	value='" + data.BIZ_NO +"'>");
			$form.append(`<input name='BIZ_NO'	value='${data.BIZ_NO}'>`);
			smartOpenPop({href: "plfm_0102_02.act", width:792, height:475, scrolling:false, target:window, frm:$form});
		}
}
function __fn_init(){
	$("#plfm_0102_01").parents("div").addClass("on");
}