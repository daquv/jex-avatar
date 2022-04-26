/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : srvc_0201_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/srvc
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200707180752, 김별
 * </pre>
 **/

$(function(){
	_thisPage.fn_init();
	$(document).on("click","#btnNew",function() {
		location.href = "srvc_0101_02.act?MENU_DV=21";
	});
	$(document).on("click",".click_detail",function() {
		location.href = "srvc_0101_02.act?APP_ID="+ fintech.common.null2void($(this).data("app_id"))+"&MENU_DV=20";
	});
});

var _thisPage = {
		fn_init : function(){
			_thisPage.fn_grid();
			_thisPage.fn_search();
		},
		fn_grid: function(){
			var list = [];
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"APP_NM",				VIEW_NM:"앱명",				VIEW_STYLE : "width=120px;",
					   ONCLICKYN:"Y", 
					   ONCLICK:"click_detail", 
					   ONCLICKDATA: "APP_ID"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"APP_ID",				VIEW_NM:"앱코드",				VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"INTF_DV",				VIEW_NM:"인터페이스",			VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"DATA_TYPE",			VIEW_NM:"데이터형식",			VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"HOST",					VIEW_NM:"HOST",				VIEW_STYLE : "width=400px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:""   , VIEW_NM:""});
			
			view_stgup.fn_search(true, "TABLE", list);
			view_stgup.makeTable("tbl_title", false, _thisPage.fn_search, false, false);
			_paging = $("#tbl_paging").tablePaging("tbl1", _thisPage.fn_search, _thisPage.cb_search, "1", "15", "Y", null);
			_paging.initPage();
			
		},
		fn_search : function(pageNo){
			var pageIndex = fintech.common.null2void(pageNo, "1");
			_pageNo = pageIndex;
			
			//페이지 처리와 검색을 수행시 상태값 체크값과 검색어 값을 수집하여 변수에 저장
			var jexAjax = jex.createAjaxUtil("srvc_0101_01_r001");   //PT_ACTION 웹 서비스 호출
			//상태, 검색대상, 카테고리
			input = {};
			input["PAGE_NO"] = pageIndex;
			input["PAGE_CNT"] = _paging.getPageSz();
			
			jexAjax.set(input);
			jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
			jexAjax.execute(function(dat) {
				var cnt = 0;
				dat.REC.length == 0 ? cnt = 0 : cnt = dat.REC[0].APP_CNT;
				_paging.setTotDataSize(cnt); 		// 전체 데이터 건수
				_paging.setPageNo(pageIndex);    	// 페이지 인덱스
				_paging.setPaging(dat.REC);     	// 레코드 데이터 정보
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
					sHtml += "<tr class='text-dot' trIdx=\""+i+"\">";
					sHtml += 	view_stgup.makeTableTbody(v,i);
					sHtml += "</tr>";
				});	
				$(tbl_content).find("tbody").append(sHtml);
			}
		},
		fn_detail : function(data){
			location.href = "srvc_0101_02.act?APP_ID="+ fintech.common.null2void(data.APP_ID)+"&MENU_DV=2";
		}
}

function __fn_init(){
	$("#srvc_0201_01").parents("div").addClass("on");
}