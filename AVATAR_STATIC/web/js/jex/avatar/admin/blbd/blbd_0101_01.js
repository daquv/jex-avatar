/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : blbd_0101_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/blbd
 * @author         : 김별 (  )
 * @Description    : 공지사항목록화면
 * @History        : 20200828142706, 김별
 * </pre>
 **/
var _grid;
var bill_stts = "";
$(function(){
	_thisPage.fn_init();
	//전체 선택
	$("#checkboxAll").on("click",function(){
    	if($('#checkboxAll').is(":checked")){
    		$('input[name="chkOne"]').attr('checked',true);
    	} else {
    		$('input[name="chkOne"]').attr('checked',false);
    	}
    });
	$(".btn_search_tb").on("click", function(){
		_thisPage.fn_init();
	});
	$("#btnRegi").click(function(){
		location.href = "blbd_0101_02.act?BLBD_DIV=02";
	});
	$(document).on("click",".click_edit",function() {
		var data;
		data = {BLBD_NO : $(this).data("blbd_no")};
		location.href = "blbd_0101_02.act?BLBD_DIV=02&BLBD_NO="+data.BLBD_NO;
	});
	$("#btnDel").click(function(){
		if($('input:checkbox[name="chkOne"]:checked').length>0){
			if(confirm("선택한 글을 삭제하시겠습니까?")){
        		_thisPage.fn_delete();
        	} else {
        		$('input:checkbox[name="chkAll"]').attr('checked',false);
        		$('input:checkbox[name="chkOne"]').attr('checked',false);
        		return false;
        	}
    	} else {
    		alert("삭제할 글을 선택해 주십시오.");
    	}
	});
});

var _thisPage = {
		fn_init: function(){
			_thisPage.fn_grid();
			_thisPage.fn_search();
		},
		fn_search : function(pageNo){
			var pageIndex = fintech.common.null2void(pageNo, "1");
			_pageNo = pageIndex;
			
			//페이지 처리와 검색을 수행시 상태값 체크값과 검색어 값을 수집하여 변수에 저장
			var jexAjax = jex.createAjaxUtil("blbd_0101_01_r001");   //PT_ACTION 웹 서비스 호출
			//가입일자, 상태, 검색대상
			input = {};
			input["SRCH_WD"] 	= $("#SRCH_WD").val();
			input["SRCH_CD"] 	= $("#SRCH_CD").val();
			input["BLBD_DIV"]	= "02"; 	//공지사항

			input["PAGE_NO"] = pageIndex;
			input["PAGE_CNT"] = _paging.getPageSz();
			
			jexAjax.set(input);
			jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
			jexAjax.execute(function(dat) {
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
					sHtml += "<tr class='text-dot' trIdx=\""+i+"\">";
					sHtml += '	<td><div><span><input type="checkbox" name="chkOne" data-blbd_no="'+v.BLBD_NO+'"></span></div></td>';
					sHtml += view_stgup.makeTableTbody(v,i);
					sHtml += "</tr>";
				});	
				$(tbl_content).find("tbody").append(sHtml);
			}
		},
		fn_grid: function(){
			
			var list = [];
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"NO",			VIEW_NM:"NO",		VIEW_STYLE : "width=50px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"BLBD_TITL",	VIEW_NM:"제목",		VIEW_STYLE : "width=400px;",
					   ONCLICKYN:"Y", 
					   ONCLICK:"click_edit", 
					   ONCLICKDATA: "BLBD_NO"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"REG_DTM",    	VIEW_NM:"작성일",		VIEW_STYLE : "width=200px;", FORMATTER : "formatter.date"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"REGR_ID",		VIEW_NM:"작성자",		VIEW_STYLE : "width=100px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:""   , VIEW_NM:""});
			
			view_stgup.fn_search(true, "TABLE", list);
			view_stgup.makeTable("tbl_title", true, _thisPage.fn_search, false, false);
			_paging = $("#tbl_paging").tablePaging("tbl1", _thisPage.fn_search, _thisPage.cb_search, "1", "15", "Y", null);
			_paging.initPage();
			
		},
		fn_detail : function(data){
			//상세정보화면.. 팝업? 페이지 이동?
			//location.href = "cstm_0201_02.act?USE_INTT_ID="+ fintech.common.null2void(data.USE_INTT_ID)
		},
		fn_delete : function(){
			var datalist = new Array();
			$("#tbl_content").find("tr").each(function(){
				if($(this).find("input").is(":checked")){
					datalist.push({
						BLBD_NO		: $(this).find("input").attr("data-blbd_no"),
						BLBD_DIV	: "02",
						DEL_YN		: "Y"
					});
				}
			});

			var jexAjax  = jex.createAjaxUtil('blbd_0101_01_d001');
			
			jexAjax.set("REC"        , datalist); // REC
			jexAjax.set("_LODING_BAR_YN_", "Y"                           ); // 로딩바 출력여부
			
			jexAjax.execute(function(dat) {
				if(dat.RSLT_CD=="0000"){
					alert("정상적으로 삭제되었습니다.");
					$('input:checkbox[name="chkOne"]').attr('checked',false);
					_thisPage.fn_search();
				} 
			});
		}
}

function __fn_init(){
	$("#blbd_0101_01").parents("div").addClass("on");
}