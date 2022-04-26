/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : sttc_0202_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/sttc
 * @author         : 김태훈 (  )
 * @Description    : 어드민 데이터가져오기등록현황 화면
 * @History        : 20200309140954, 김태훈
 * </pre>
 **/
var _grid;
var bill_stts = "";
$(function(){
	_thisPage.setCalendar();
	
	_thisPage.fn_init();
	
	$(".btn_search_tb").on("click", function(){
		_thisPage.fn_init();
	});
	$("#btnExceldown").click(function(){
		
		_thisPage.fn_ExcelExp();
	});
});

var _thisPage = {
		fn_init: function(){
			_thisPage.fn_grid();
			_thisPage.fn_getInttInfm();
			_thisPage.fn_search();
		},
		fn_search : function(pageNo){
			var pageIndex = fintech.common.null2void(pageNo, "1");
			_pageNo = pageIndex;
			
			//페이지 처리와 검색을 수행시 상태값 체크값과 검색어 값을 수집하여 변수에 저장
			var jexAjax = jex.createAjaxUtil("sttc_0202_01_r001");   //PT_ACTION 웹 서비스 호출
			//가입일자, 상태, 검색대상
			input = {};
			input["SRCH_WD"] 	= $("#searchValue").val();
			input["SRCH_CD"] 	= $("#select_02 option:selected").val();
			input["INQ_TRCN"] 	= $("#select_01 option:selected").val();
			input["STR_DT"] 	= $("#STR_DT").val().replace(/-/g, "");
			input["END_DT"] 	= $("#END_DT").val().replace(/-/g, "");
			
			var STTS = "";
			var stts = [];
			$('input[name=STTS]:checked').each(function() {		
				stts.push(this.value);
			});
			STTS =  stts + "";
			input["STTS"] = STTS;
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
				var sHtml = "";		
				
				$.each(rec, function(i, v) {
					v.REG_DTM = fintech.common.formatDate(v.REG_DTM.substr(0,8));
					v.BSNN_NM = "";
//					v.HOME_CNT = v.HOME_CNT=="0"?v.HOME_CNT="X":"O"; 
					v.PRCH_CNT = v.PRCH_CNT=="0"?v.PRCH_CNT="X":"O";
					v.CASH_CNT = v.CASH_CNT=="0"?v.CASH_CNT="X":"O";
					v.SALE_CNT = v.SALE_CNT=="0"?v.SALE_CNT="X":"O";
					v.ACCT_CNT = formatter.number(parseInt(v.ACCT_CNT), 0);
					v.CARD_CNT = formatter.number(parseInt(v.CARD_CNT), 0);
					sHtml += "<tr class='text-dot' trIdx=\""+i+"\">";
					sHtml += view_stgup.makeTableTbody(v,i);
					sHtml += "</tr>";
				});	
				$(tbl_content).find("tbody").append(sHtml);
			}
		},
		fn_ExcelExp: function(){
			var pageIndex = fintech.common.null2void("", "1");
			_pageNo = pageIndex;
			
			var jexAjax = jex.createAjaxUtil("sttc_0202_01_r001");   //PT_ACTION 웹 서비스 호출
			input = {};
			input["SRCH_WD"] 	= $("#searchValue").val();
			input["SRCH_CD"] 	= $("#select_02 option:selected").val();
			input["INQ_TRCN"] 	= $("#select_01 option:selected").val();
			input["STR_DT"] 	= $("#STR_DT").val().replace(/-/g, "");
			input["END_DT"] 	= $("#END_DT").val().replace(/-/g, "");
			
			var STTS = "";
			var stts = [];
			$('input[name=STTS]:checked').each(function() {		
				stts.push(this.value);
			});
			STTS =  stts + "";
			input["STTS"] = STTS;
			jexAjax.set(input);
			jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
			_thisPage.fn_excelGrid();

			jexAjax.execute(function(dat){
				var rec = dat.REC;
				
				$.each(rec, function(i,v){
					v.REG_DTM = fintech.common.formatDate(v.REG_DTM.substr(0,8));
//					v.BSNN_NM = "";
					v.PRCH_CNT = v.PRCH_CNT=="0"?v.PRCH_CNT="X":"O";
					v.CASH_CNT = v.CASH_CNT=="0"?v.CASH_CNT="X":"O";
					v.SALE_CNT = v.SALE_CNT=="0"?v.SALE_CNT="X":"O";
					v.ACCT_CNT = formatter.number(parseInt(v.ACCT_CNT), 0);
					v.CARD_CNT = formatter.number(parseInt(v.CARD_CNT), 0);
				});
				 _grid.dataMgr.set(rec);
    			 _excelDownload(_grid, "데이터가져오기현황");    
			});
		},
		fn_excelGrid: function(){
			if(_grid!=null) _grid.destroy();
			//그리드 옵션 설정
			var gridOptions = smart.grid.getDefaultOptions();
			$("body").append("<div id='grid' style='display:none'></div>");
			//Jex Grid Column
			var columns = [];
			
	        columns = [
	        	{key : "REG_DTM"				, name : "가입일자"			, width : "100px"  , style : "text-align:center" },
	            {key : "CUST_NM"				, name : "고객명"				, width : "100px"  , style : "text-align:center" },
	            {key : "USE_INTT_ID"			, name : "고객번호"			, width : "150px" , style : "text-align:center" },
	            {key : "CLPH_NO"		      	, name : "휴대폰번호"			, width : "150px" , style : "text-align:center" },
	        	{key : "STTS_NM"	    		, name : "상태"				, width : "90px" , style : "text-align:center" },
	            {key : "ACCT_CNT"				, name : "은행"				, width : "90px" , style : "text-align:right" },
	            {key : "PRCH_CNT"		      	, name : "전자(세금)계산서"		, width : "105px" , style : "text-align:center" },
	            {key : "CASH_CNT"		      	, name : "현금영수증"			, width : "90px" , style : "text-align:center" },
	            {key : "SALE_CNT"				, name : "카드매출"			, width : "90px" , style : "text-align:center" },
	            {key : "CARD_CNT"				, name : "카드매입"			, width : "90px" , style : "text-align:right" },
	          ];

			_grid = JGM.create("Grid", {container:document.getElementById("grid"), colDefs:columns, options:gridOptions});
		},
		fn_grid: function(){
			
			var list = [];
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"REG_DTM",				VIEW_NM:"가입일자",			VIEW_STYLE : "width=110px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CUST_NM",				VIEW_NM:"고객명",				VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"USE_INTT_ID",			VIEW_NM:"고객번호",			VIEW_STYLE : "width=150px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CLPH_NO",          	VIEW_NM:"휴대폰번호",			VIEW_STYLE : "width=150px;", 	FORMATTER:"formatter.phone"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"STTS_NM",    			VIEW_NM:"상태",				VIEW_STYLE : "width=70px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"ACCT_CNT",				VIEW_NM:"은행",				VIEW_STYLE : "width=110px;",	VIEW_CLASS : "tar"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"PRCH_CNT",				VIEW_NM:"전자(세금)계산서",		VIEW_STYLE : "width=120px;",	VIEW_CLASS : "tac"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CASH_CNT",				VIEW_NM:"현금영수증",			VIEW_STYLE : "width=110px;",	VIEW_CLASS : "tac"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"SALE_CNT",				VIEW_NM:"카드매출",			VIEW_STYLE : "width=110px;",	VIEW_CLASS : "tac"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CARD_CNT",				VIEW_NM:"카드매입",			VIEW_STYLE : "width=110px;",	VIEW_CLASS : "tar"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:""   , VIEW_NM:""});
			
			view_stgup.fn_search(true, "TABLE", list);
			view_stgup.makeTable("tbl_title", false, _thisPage.fn_search, false, false);
			_paging = $("#tbl_paging").tablePaging("tbl1", _thisPage.fn_search, _thisPage.cb_search, "1", "15", "Y", null);
			_paging.initPage();
			
		},
		fn_detail : function(data){
			//상세정보화면.. 팝업? 페이지 이동?
			//location.href = "cstm_0201_02.act?USE_INTT_ID="+ fintech.common.null2void(data.USE_INTT_ID)
		},
		setCalendar: function(){
			// 조회일자 시작일
			datePicker.setCalendar("#STR_DT");		
			$("#STR_DT").val(fintech.common.getDate("yyyy-mm-dd","M",-1)  );						// 조회기간 시작일
			// 조회일자 종료일
			datePicker.setCalendar("#END_DT");		
			$("#END_DT").val(fintech.common.getDate("yyyy-mm-dd"));
			//날짜 조정
			$("#BASE_DT").on("click", function(){
				$("#STR_DT").val("2019-01-01");
				$("#END_DT").val(fintech.common.getDate("yyyy-mm-dd"));
			});
			$("#TODAY_DT").on("click", function(){
				var today = new Date();
				var dd = today.getDate();
				var mm = today.getMonth()+1; //January is 0!
				var yyyy = today.getFullYear();

				if(dd<10) dd='0'+dd; 
				if(mm<10) mm='0'+mm; 

				today = yyyy+'-'+mm+'-'+dd;
				
				$("#STR_DT").val(today);
				$("#END_DT").val(today);
			});	
		}, 
		fn_getInttInfm: function(){	//가입일자만 적용
			var jexAjax = jex.createAjaxUtil("sttc_0202_01_r002");   //PT_ACTION 웹 서비스 호출
			var input = {};
			input["STR_DT"] = $("#STR_DT").val().replace(/-/g, "");
			input["END_DT"] = $("#END_DT").val().replace(/-/g, "");
			jexAjax.set(input);
			jexAjax.execute(function(data){
				$("#TOTL_NCNT").html(formatter.number(parseInt(data.TOTL_NCNT)+parseInt(data.TRMN_NCNT)+parseInt(data.SPNC_NCNT), 0)+" 개");
				$("#NORM_NCNT").html(formatter.number(parseInt(data.TOTL_NCNT), 0)+" 개");
				$("#TRMN_NCNT").html(formatter.number(parseInt(data.TRMN_NCNT)+parseInt(data.SPNC_NCNT),0)+"("+formatter.number(parseInt(data.TRMN_NCNT), 0)+"/"+formatter.number(parseInt(data.SPNC_NCNT), 0)+")개");
				$("#HOME_NCNT").html(formatter.number(parseInt(data.HOME_NCNT), 0)+" 개");
				$("#SALE_NCNT").html(formatter.number(parseInt(data.SALE_NCNT), 0)+" 개");
				$("#ACCT_NCNT").html(formatter.number(parseInt(data.ACCT_NCNT), 0)+" 개");
				$("#CARD_NCNT").html(formatter.number(parseInt(data.CARD_NCNT), 0)+" 개");
			});
		
		}
}

function __fn_init(){
	$("#scct_0202_00").parents("div").addClass("on");
}
