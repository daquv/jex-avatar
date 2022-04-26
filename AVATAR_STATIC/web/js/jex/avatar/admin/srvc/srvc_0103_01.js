/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : srvc_0103_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/srvc
 * @author         : 김별 (  )
 * @Description    : 인텐트 관리 목록 화면
 * @History        : 20200309155608, 김별
 * </pre>
 **/

$(function(){
	getDsdlCd("CTGR_CD","B2001");
	_thisPage.fn_init();
	$(".btn_search_tb").on("click", function(){
		_thisPage.fn_init();
	});
	$("#btnNew").on("click", function(){
		location.href = "srvc_0103_02.act";
	});
	$(document).on("click",".click_detail",function() {
		location.href = "srvc_0103_02.act?INTE_CD=" + $(this).attr("data-INTE_CD");
	  });
	$(document).keypress(function(e){
		if(e.keyCode == 13 ) {
			_thisPage.fn_init();
		}
	});

});

var _thisPage = {
		fn_init : function(){
			_thisPage.fn_grid();
			_thisPage.fn_search();
		},
		fn_grid: function(){
			var list = [];
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"NO",					VIEW_NM:"NO",				VIEW_STYLE : "width=30px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CTGR_CD",				VIEW_NM:"카테고리",			VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"INTE_CD",				VIEW_NM:"인텐트",				VIEW_STYLE : "width=150px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"INTE_NM",				VIEW_NM:"인텐트명",				VIEW_STYLE : "width=200px;",
					   ONCLICKYN:"Y", 
					   ONCLICK:"click_detail", 
					   ONCLICKDATA: "INTE_CD"});
			/*list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"QUES_LVL",				VIEW_NM:"레벨",				VIEW_STYLE : "width=70px;"});*/
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"QUES_RSLT_TYPE",		VIEW_NM:"결과유형",				VIEW_STYLE : "width=100px;"});
			/*list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"RSMB_SRCH_METH",		VIEW_NM:"유사질의",				VIEW_STYLE : "width=90px;"});*/
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"STTS",					VIEW_NM:"상태",				VIEW_STYLE : "width=70px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"OTPT_SQNC",			VIEW_NM:"출력순서",				VIEW_STYLE : "width=70px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CORC_DTM",          	VIEW_NM:"최종변경일시",			VIEW_STYLE : "width=160px;"});
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
			var jexAjax = jex.createAjaxUtil("srvc_0103_01_r001");   //PT_ACTION 웹 서비스 호출
			//가입일자, 상태, 검색대상
			input = {};
			input["SRCH_WD"] = $("#SRCH_WD").val();
			input["SRCH_CD"] = $("#SRCH_CD").val();
			//카테고리 
			input["CTGR_CD"] = $("#CTGR_CD").val();
			
			var STTS = "";
			var stts = [];
			$('input.STTS:checked').each(function() {		
				stts.push(this.value);
			});
			STTS =  stts + "";
			input["STTS"] = STTS;
			input["PAGE_NO"] = pageIndex;
			input["PAGE_CNT"] = _paging.getPageSz();
			console.log(_paging.getPageSz());
			jexAjax.set(input);
			jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
			jexAjax.execute(function(dat) {
				console.log(dat);
				_paging.setTotDataSize(dat.CNT); 		// 전체 데이터 건수
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
					v.NO = (i+1)+ ((num_row * page_index) - num_row);
					if(v.RSMB_SRCH_METH == "1")
						v.RSMB_SRCH_METH = "검색어";
					else if(v.RSMB_SRCH_METH == "2")
						v.RSMB_SRCH_METH = "표준질의";
					v.CORC_DTM = fintech.common.formatDtm(v.CORC_DTM);
					if(v.STTS == "1") {
						v.STTS = "사용";
					} else if(v.STTS == "8") {
						v.STTS = "중지";
					} else if(v.STTS == "9") {
						v.STTS = "삭제";
					}
					
					sHtml += "<tr class='text-dot' trIdx=\""+i+"\">";
					sHtml += view_stgup.makeTableTbody(v,i);
					sHtml += "</tr>";
				});	
				$(tbl_content).find("tbody").append(sHtml);
			}
		},
		
}
function getDsdlCd(loct, grp_cd, item_cd, item_nm){
	var jexAjax = jex.createAjaxUtil("srvc_0103_01_r002");   //PT_ACTION 웹 서비스 호출
	jexAjax.set("DSDL_GRP_CD", grp_cd);
	jexAjax.set("DSDL_ITEM_CD", item_cd);
	jexAjax.set("DSDL_ITEM_NM", item_nm);
	jexAjax.execute(function(dat) {
		var html = "<option value=''>전체</option>";
		$.each(dat.REC, function(i, v) {
			html += "<option value="+v.DSDL_ITEM_CD+">"+v.DSDL_ITEM_NM+"</option>";
		});
		var location = "#"+loct+"";
		$(location).empty();
		$(location).append(html);
	});
}

function __fn_init(){
	$("#srvc_0103_01").parents("div").addClass("on");
}