/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : srvc_0202_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/srvc
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200807141024, 김별
 * </pre>
 **/
$(function(){
	getDsdlCd("CTGR_CD","B2001");
	_thisPage.fn_init();
	$(document).on("click","#btnNew",function() {
		location.href = "srvc_0202_02.act";
	});
	$(document).on("click",".click_detail",function() {
		location.href = "srvc_0202_02.act?APP_ID="+ fintech.common.null2void($(this).data("app_id"))+"&API_ID="+fintech.common.null2void($(this).data("api_id"));
	});
	$(document).on("click", ".cmdSearch", function(){
		_thisPage.fn_init();
	})
	
});

var _thisPage = {
		fn_init : function(){
			_thisPage.fn_grid();
			_thisPage.fn_search();
		},
		fn_grid: function(){
			var list = [];
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"QUES_CTT"	,VIEW_NM:"질의명",	VIEW_STYLE : "width=250px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CTGR_CD_NM"	,VIEW_NM:"카테고리",	VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"EDIT"			,VIEW_NM:"서비스",	VIEW_STYLE : "width=120px;",
					   ONCLICKYN:"Y", 
					   ONCLICK:"click_detail", 
					   ONCLICKDATA: "APP_ID,API_ID"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"STTS"		,VIEW_NM:"상태",		VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"APP_NM"	,VIEW_NM:"정보공급처",	VIEW_STYLE : "width=120px;"});
			/*list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"SHOW"		,VIEW_NM:"미리보기",	VIEW_STYLE : "width=400px;"});*/
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
			var jexAjax = jex.createAjaxUtil("srvc_0103_03_r001");   //PT_ACTION 웹 서비스 호출
			//상태, 검색대상, 카테고리
			input = {};
			input["PAGE_NO"] = pageIndex;
			input["PAGE_CNT"] = _paging.getPageSz();
			input["SRCH_WD"] = $("#SRCH_WD").val();
			input["CTGR_CD"] = $("#CTGR_CD").val();
			
			jexAjax.set(input);
			jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
			jexAjax.execute(function(dat) {
				var cnt = 0;
				_paging.setTotDataSize(dat.API_CNT); 		// 전체 데이터 건수
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
					var edit = "[수정]";
					v.EDIT = edit;
					
					var show = "<a class='btn_style1' href='' data-inte_cd=''><span>보기</span></a>";
					v.SHOW = show;
					
					if(v.STTS == "1") {
						v.STTS = "승인대기";
					} else if(v.STTS == "2") {
						v.STTS = "배포대기";
					} else if(v.STTS == "3") {
						v.STTS = "배포중";
					} else if(v.STTS == "4") {
						v.STTS = "배포중지";
					} else if(v.STTS == "5") {
						v.STTS = "반려";
					} else if(v.STTS == "9") {
						v.STTS = "삭제";
					} else if(v.STTS == "0") {
						v.STTS = "임시저장";
					}
					
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
	$("#srvc_0202_01").parents("div").addClass("on");
}

function getDsdlCd(loct, grp_cd,item_cd, item_nm){
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