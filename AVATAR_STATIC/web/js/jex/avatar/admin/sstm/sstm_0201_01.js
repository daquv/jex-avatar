/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : sstm_0201_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/sstm
 * @author         : 김태훈 (  )
 * @Description    : 어드민 고객별결과조회 화면
 * @History        : 20200410151224, 김태훈
 * </pre>
 **/
var _grid;
$(function(){
	_thisPage.fn_getInfm();
	_thisPage.fn_getInttInfm();
	_thisPage.fn_init();
	
	$(".btn_search_tb").on("click", function(){
		_thisPage.fn_init();
	});
	$("#btnExceldown").click(function(){
		_thisPage.fn_ExcelExp();
	});
	$(".click_dtl1").live("click", function(){
		var datelist = {
				USE_INTT_ID : $(this).attr("data-USE_INTT_ID"),
				CUST_NM		: $(this).attr("data-CUST_NM"),
				GB			: 'ACCT'
		};
	   _thisPage.fn_detail("form1", "click_dtl1", datelist);
	});
	$(".click_dtl2").live("click", function(){
		var datelist = {
				USE_INTT_ID : $(this).attr("data-USE_INTT_ID"),
				CUST_NM		: $(this).attr("data-CUST_NM"),
				GB			: 'EVDC'
		};
		_thisPage.fn_detail("form1", "click_dtl1", datelist);
	});
	$(".click_dtl3").live("click", function(){
		var datelist = {
				USE_INTT_ID : $(this).attr("data-USE_INTT_ID"),
				CUST_NM		: $(this).attr("data-CUST_NM"),
				GB			: 'MECR'
		};
		_thisPage.fn_detail("form1", "click_dtl1", datelist);
	});
	$(".click_dtl4").live("click", function(){
		var datelist = {
				USE_INTT_ID : $(this).attr("data-USE_INTT_ID"),
				CUST_NM		: $(this).attr("data-CUST_NM"),
				GB			: 'CARD'
		};
		_thisPage.fn_detail("form1", "click_dtl1", datelist);
	});
	$(".click_dtl5").live("click", function(){
		var datelist = {
				USE_INTT_ID : $(this).attr("data-USE_INTT_ID"),
				CUST_NM		: $(this).attr("data-CUST_NM"),
				GB			: 'RCV'
		};
		_thisPage.fn_detail("form1", "click_dtl1", datelist);
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
			var STTS = $('input[name=STTS]:checked').length==0 || $('input[name=STTS]:checked').length==2 ? "": $('input[name=STTS]:checked').val();
			//페이지 처리와 검색을 수행시 상태값 체크값과 검색어 값을 수집하여 변수에 저장
			var jexAjax = jex.createAjaxUtil("sstm_0201_01_r001");   //PT_ACTION 웹 서비스 호출
			jexAjax.set("NEW_BR_NO"	, $("#select_01 option:selected").val()); //데이터코드 
			jexAjax.set("INQ_TRCN"		, $("#SRCH_CD option:selected").val());	// 검색대상
			jexAjax.set("INQ_TRCN_CTT"	, $('#SRCH_WD').val());	// 내용
			jexAjax.set("STTS"		, STTS);	//수집상태
			
			jexAjax.set("PAGE_NO"        , pageIndex); 				// 페이지 번호
			jexAjax.set("PAGE_SIZE"      , _paging.getPageSz());	// 페이지 크기
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
			var STTS = $('input[name=STTS]:checked').length==0 || $('input[name=STTS]:checked').length==2 ? "": $('input[name=STTS]:checked').val(); 
			var jexAjax = jex.createAjaxUtil("sstm_0201_01_r001");   //PT_ACTION 웹 서비스 호출
			jexAjax.set("NEW_BR_NO"	, 	$("#select_01 option:selected").val()); //데이터코드 
			jexAjax.set("INQ_TRCN"		, $("#SRCH_CD option:selected").val());	// 검색대상
			jexAjax.set("INQ_TRCN_CTT"	, $('#SRCH_WD').val());	// 내용
			jexAjax.set("INTT_STTS"		, STTS);	//수집상태
			
			_thisPage.fn_excelGrid();

			jexAjax.execute(function(dat){
				var rec = dat.REC;
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
                {key : "USE_INTT_ID"			, name : "고객번호"			, width : "100px"  , style : "text-align:center" },
                {key : "CUST_NM"		      	, name : "고객명"				, width : "90px"   , style : "text-align:center" },
	        	{key : "ACCT_STTS"				, name : "은행"				, width : "150px"  , style : "text-align:center" },
	            {key : "ELEC_TXBL_STTS"			, name : "전자(세금)계산서"		, width : "150px"  , style : "text-align:center" },
	            {key : "RCPT_STTS"		      	, name : "현금영수증"			, width : "150px"  , style : "text-align:center" },
	            {key : "CARD_APV_STTS"		    , name : "카드매입"			, width : "150px"  , style : "text-align:center" },
	        	{key : "RCV_STTS"	    		, name : "카드매출"			, width : "150px"   , style : "text-align:center" },
	          ];

			_grid = JGM.create("Grid", {container:document.getElementById("grid"), colDefs:columns, options:gridOptions});
		},
		fn_grid: function(){
			
			var list = [];
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"USE_INTT_ID",     	VIEW_NM:"고객번호",    	VIEW_STYLE : "width=150px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CUST_NM",     		VIEW_NM:"고객명",     	VIEW_STYLE : "width=150px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"ACCT_STTS",   		VIEW_NM:"은행",    		VIEW_STYLE : "width=120px;",	VIEW_CLASS : "tac"
				,ONCLICKYN:"Y", ONCLICK:"click_dtl1",
				ONCLICKDATA:"USE_INTT_ID,CUST_NM"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"ELEC_TXBL_STTS",   VIEW_NM:"전자(세금)계산서", VIEW_STYLE : "width=110px;",		VIEW_CLASS : "tac"
				,ONCLICKYN:"Y", ONCLICK:"click_dtl2",
				ONCLICKDATA:"USE_INTT_ID,CUST_NM"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"RCPT_STTS",   		VIEW_NM:"현금영수증",    	VIEW_STYLE : "width=80px;",		VIEW_CLASS : "tac"
				,ONCLICKYN:"Y", ONCLICK:"click_dtl3",
				ONCLICKDATA:"USE_INTT_ID,CUST_NM"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CARD_APV_STTS",    VIEW_NM:"카드매입",    	VIEW_STYLE : "width=80px;",		VIEW_CLASS : "tac"
				,ONCLICKYN:"Y", ONCLICK:"click_dtl4",
				ONCLICKDATA:"USE_INTT_ID,CUST_NM"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"RCV_STTS",    		VIEW_NM:"카드매출",    	VIEW_STYLE : "width=80px;",		VIEW_CLASS : "tac"
				,ONCLICKYN:"Y", ONCLICK:"click_dtl5",
				ONCLICKDATA:"USE_INTT_ID,CUST_NM"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:""   , VIEW_NM:""});
			
			view_stgup.fn_search(true, "TABLE", list);
			view_stgup.makeTable("tbl_title", false, _thisPage.fn_search, false, false);
			_paging = $("#tbl_paging").tablePaging("tbl1", _thisPage.fn_search, _thisPage.cb_search, "1", "15", "Y", null);
			_paging.initPage();
			
		},
		fn_getInfm: function(){	//가입일자만 적용
			var jexAjax = jex.createAjaxUtil("sttc_0102_01_r001");   //PT_ACTION 웹 서비스 호출
			jexAjax.set("DSDL_GRP_CD","U1009");
			jexAjax.setAsync(false);
			jexAjax.execute(function(data){
				fn_setOption("select_01",data.CTGR_REC);
			});
		
		},fn_detail: function(form, id, data){
			$("#POP_USE_INTT_ID").val(data.USE_INTT_ID);
			$("#POP_SEARCH_GB").val(data.GB);
			var $form = $("<form method='post'></form>");
			$form.append("<input name='POP_USE_INTT_ID' value='"+data.USE_INTT_ID+"'>");
			$form.append("<input name='POP_GB' value='"+data.GB+"'>");
			$form.append("<input name='POP_CUST_NM' value='"+data.CUST_NM+"'>");
			smartOpenPop({href: "sstm_0201_02.act", width:980, height:518, scrolling:false, target:window, frm:$form});
		},
		fn_getInttInfm: function(){	//가입일자만 적용
			var jexAjax = jex.createAjaxUtil("sttc_0201_01_r002");   //PT_ACTION 웹 서비스 호출
//			var input = {};
//			input["STR_DT"] = $("#STR_DT").val().replace(/-/g, "");
//			input["END_DT"] = $("#END_DT").val().replace(/-/g, "");
//			jexAjax.set(input);
			jexAjax.execute(function(data){
				$("#TOTL_NCNT").html(formatter.number(parseInt(data.TOTL_NCNT)+parseInt(data.TRMN_NCNT)+parseInt(data.SPNC_NCNT), 0)+" 개");
				$("#NORM_NCNT").html(formatter.number(parseInt(data.TOTL_NCNT), 0)+" 개");
				$("#TRMN_NCNT").html(formatter.number(parseInt(data.TRMN_NCNT)+parseInt(data.SPNC_NCNT),0)+"("+formatter.number(parseInt(data.TRMN_NCNT), 0)+"/"+formatter.number(parseInt(data.SPNC_NCNT), 0)+")개");
			});
		
		}
}
function fn_setOption(id,data){
	var _selectBox = $("select[id="+id+"]");
	var optionHtml = '';
	optionHtml += '<option value="">전체</option>';
	if(data.length==0){
	} else {
//		optionHtml += '<option value="">전체</option>';
		$.each(data,function(i,v){
			optionHtml += '<option value="'+v.KEY+'">'+v.VALUE+'</option>';
		});
	}
	_selectBox.html(optionHtml);
}

function __fn_init(){
	$("#scct_0201_00").parents("div").addClass("on");
}
