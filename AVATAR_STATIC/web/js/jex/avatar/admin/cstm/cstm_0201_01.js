/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : cstm_0201_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/cstm
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200417171303, 김별
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
	$(document).on("click",".click_detail",function() {
		 var data;
		 data = {BLBD_NO : $(this).data("blbd_no")};
		 _thisPage.fn_detail(data);
	  });
	
	$("#btnExceldown").click(function(){
		_thisPage.fn_ExcelExp();
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
			var jexAjax = jex.createAjaxUtil("cstm_0201_01_r001");   //PT_ACTION 웹 서비스 호출
			//가입일자, 상태, 검색대상
			input = {};
			input["SRCH_WD"] = document.getElementById("SRCH_WD").value; //$("#SRCH_WD").val();
			input["SRCH_CD"] = document.getElementById("SRCH_CD").value; //$("#SRCH_CD").val();
			input["STR_DT"] = document.getElementById("STR_DT").value.replace(/-/g, ""); //$("#STR_DT").val().replace(/-/g, "");
			input["END_DT"] = document.getElementById("END_DT").value.replace(/-/g, ""); //$("#END_DT").val().replace(/-/g, "");
			input["STTS"] = document.getElementById("STTS").value;
			input["APP_ID"] = document.getElementById("APP_ID").value;
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
					//v.REG_DTM = fintech.common.formatDate(v.REG_DTM.substr(0,8));
					
					if(v.STTS == "0") {
						v.STTS = "대기";
					} else if(v.STTS == "1") {
						v.STTS = "접수";
					} else if(v.STTS == "2") {
						v.STTS = "완료";
					}
					if(v.FILE_YN == "Y"){
						v.FILE_YN = "<img src='/admin/img/ico/ico_file.png'>";
					} else{
						v.FILE_YN = "";
					}
					if(v.APP_ID == "AVATAR"){
						v.APP_ID = "아바타";
					} else if(v.APP_ID == "SERP"){
						v.APP_ID = "경리나라";
					} else if(v.APP_ID == "KTSERP"){
						v.APP_ID = "KT경리나라";
					}
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
			
			var jexAjax = jex.createAjaxUtil("cstm_0201_01_r001");   //PT_ACTION 웹 서비스 호출
			input = {};
			input["SRCH_WD"] = $("#SRCH_WD").val();
			input["SRCH_CD"] = $("#SRCH_CD").val();
			input["STR_DT"] = $("#STR_DT").val().replace(/-/g, "");
			input["END_DT"] = $("#END_DT").val().replace(/-/g, "");
			input["STTS"] = $("#STTS").val();
			input["APP_ID"] = $("#APP_ID").val();
			
			_thisPage.fn_excelGrid();
			jexAjax.set(input);
			jexAjax.execute(function(dat){
				var rec = dat.REC;
				$.each(rec, function(i,v){
					v.REG_DTM = fintech.common.formatDate(v.REG_DTM.substr(0,8));
					
					if(v.STTS == "0") {
						v.STTS = "대기";
					} else if(v.STTS == "1") {
						v.STTS = "접수";
					} else if(v.STTS == "2") {
						v.STTS = "완료";
					}
					if(v.APP_ID == "AVATAR"){
						v.APP_ID = "아바타";
					} else if(v.APP_ID == "SERP"){
						v.APP_ID = "경리나라";
					} else if(v.APP_ID == "KTSERP"){
						v.APP_ID = "KT경리나라";
					}
					//v.REG_DTM = fintech.common.formatDate(fintech.common.null2void(v.LOGIN_LST_DTM).substr(0,8));
					v.TEL_NO = formatter.phone(v.TEL_NO);
				});
				 _grid.dataMgr.set(rec);
    			 _excelDownload(_grid, "기능개선문의");    
			});
		},
		fn_excelGrid: function(){
			if(_grid!=null) _grid.destroy();
			//그리드 옵션 설정
			var gridOptions = smart.grid.getDefaultOptions();
			$("body").append("<div id='grid' style='display:none'></div>");
			var columns = [];
	        columns = [
	        	{key : "REG_DTM"		, name : "작성일"		, width : "90px"  , style : "text-align:center" },
	        	{key : "APP_ID"	    	, name : "구분"		, width : "100px" , style : "text-align:center" },
	            {key : "BLBD_TITL"		, name : "제목"		, width : "90px"  , style : "text-align:center" },
	        	{key : "STTS"	    	, name : "상태"		, width : "100px" , style : "text-align:center" },
	            {key : "FILE_YN"		, name : "첨부"		, width : "100px" , style : "text-align:center" },
	            {key : "CUST_NM"	  	, name : "작성자"		, width : "400px" , style : "text-align:center" },
	            {key : "USE_INTT_ID"	, name : "고객번호"	, width : "150px" , style : "text-align:center" },
	            {key : "TEL_NO"			, name : "휴대폰번호"	, width : "150px" , style : "text-align:center" },
	            {key : "REGR_NM"		, name : "처리자"		, width : "100px" , style : "text-align:center" },
	          ];

			_grid = JGM.create("Grid", {container:document.getElementById("grid"), colDefs:columns, options:gridOptions});
		},
		fn_grid: function(){
			
			var list = [];
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"REG_DTM",		VIEW_NM:"작성일",			VIEW_STYLE : "width=110px;", 	FORMATTER:"formatter.date"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"APP_ID",		VIEW_NM:"구분",			VIEW_STYLE : "width=110px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"BLBD_TITL",	VIEW_NM:"제목",			VIEW_STYLE : "width=400px;",
					   ONCLICKYN:"Y", 
					   ONCLICK:"click_detail", 
					   ONCLICKDATA: "BLBD_NO"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"STTS",			VIEW_NM:"상태",			VIEW_STYLE : "width=70px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"FILE_YN",		VIEW_NM:"첨부",			VIEW_STYLE : "width=70px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CUST_NM",		VIEW_NM:"작성자",			VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"USE_INTT_ID",	VIEW_NM:"고객번호",		VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"TEL_NO",		VIEW_NM:"휴대폰번호",		VIEW_STYLE : "width=120px;", 	FORMATTER:"formatter.phone"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"REGR_NM",		VIEW_NM:"처리자",			VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:""   , VIEW_NM:""});
			
			view_stgup.fn_search(true, "TABLE", list);
			view_stgup.makeTable("tbl_title", false, _thisPage.fn_search, false, false);
			_paging = $("#tbl_paging").tablePaging("tbl1", _thisPage.fn_search, _thisPage.cb_search, "1", "15", "Y", null);
			_paging.initPage();
			
		},
		fn_detail : function(data){
			//상세정보화면.. 팝업? 페이지 이동?
			location.href="cstm_0201_02.act?BLBD_NO="+fintech.common.null2void(data.BLBD_NO);
		},
		setCalendar: function(){
			// 조회일자 시작일
			datePicker.setCalendar("#STR_DT");		
			$("#STR_DT").val(fintech.common.getDate("yyyy-mm-dd","M",-1)  );						// 조회기간 시작일
			// 조회일자 종료일
			datePicker.setCalendar("#END_DT");		
			$("#END_DT").val(fintech.common.getDate("yyyy-mm-dd"));
		}, 
}

function __fn_init(){
	$("#cstm_0201_01").parents("div").addClass("on");
}
