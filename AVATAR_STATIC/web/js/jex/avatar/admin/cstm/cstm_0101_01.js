var _grid;
var totCnt;
$(function(){
	_thisPage.setCalendar();
	
	_thisPage.fn_init();
	
	$(".btn_search_tb").on("click", function(){
		_thisPage.fn_init();
	});
	$(document).on("click",".click_detail",function() {
		 var data;
		 data = {USE_INTT_ID : $(this).data("use_intt_id")};
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
			var jexAjax = jex.createAjaxUtil("cstm_0101_01_r001");   //PT_ACTION 웹 서비스 호출
			//가입일자, 상태, 검색대상
			input = {};
			input["SRCH_WD"] = document.getElementById("SRCH_WD").value; //$("#SRCH_WD").val();
			input["SRCH_CD"] = document.getElementById("SRCH_CD").value; //$("#SRCH_CD").val();
			input["STR_DT"] = document.getElementById("STR_DT").value.replace(/-/g, ""); //$("#STR_DT").val().replace(/-/g, "");
			input["END_DT"] = document.getElementById("END_DT").value.replace(/-/g, ""); //$("#END_DT").val().replace(/-/g, "");
			
			input["FST_JOIN_APP"] = document.getElementById("FST_JOIN_APP").value;
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
			jexAjax.execute(function(dat) {
				totCnt = dat.REC[0]? dat.REC[0].CNT : 0
				_paging.setTotDataSize(totCnt); 		// 전체 데이터 건수
				_paging.setPageNo(pageIndex);    	// 페이지 인덱스
				_paging.setPaging(dat.REC);     	// 레코드 데이터 정보
				// 조회조건을 바꾸고 페이징 조회 호출하는 것 방지
				_paging.setParam(jexAjax, pageIndex);
				$("#TOTL_NCNT").html(formatter.number(parseInt(dat.TOTL_NCNT), 0)+" 개");
				$("#NORM_NCNT").html(formatter.number(parseInt(dat.NORM_NCNT), 0)+" 개");
				$("#TRMN_NCNT").html(formatter.number(parseInt(dat.TRMN_NCNT)+parseInt(dat.SPNC_NCNT),0)+"("+formatter.number(parseInt(dat.SPNC_NCNT), 0)+"/"+formatter.number(parseInt(dat.TRMN_NCNT), 0)+")개");
				
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
				var num_row =  $(".btn_combo_down>#pageSize").text()-0;
				var sHtml = "";		
				
				$.each(rec, function(i, v) {
					v.REG_DTM = fintech.common.formatDate(v.REG_DTM.substr(0,8));
					
					if(v.STTS == "1") {
						v.STTS = "정상";
					} else if(v.STTS == "9") {
						v.STTS = "해지";
					} else if(v.STTS == "8") {
						v.STTS = "정지";
					}
					
					v.BIZ_NO = formatter.corpNum(fintech.common.null2void(v.BIZ_NO));
					
					v.LOGIN_LST_DTM = fintech.common.formatDate(fintech.common.null2void(v.LOGIN_LST_DTM).substr(0,8));
					v.DATA_YN = "은행("+v.ACCT_CNT+") / 홈택스("+v.HTAX_YN+") / 카드매출("+v.SALE_YN+") / 카드매입("+v.CARD_CNT+") / 온라인매출("+v.SNNS_YN+") / 경리나라("+v.SERP_YN+") / 제로페이("+v.ZP_YN+") / KT경리나라("+v.KTSERP_YN+")";
					v.AGRM_YN = "아바타("+v.A_AGRM_YN+") / 경리나라("+v.S_AGRM_YN+") / 제로페이("+v.Z_AGRM_YN+")";
					v.CORC_DTM = fintech.common.formatDtm(v.CORC_DTM);

					if(v.FST_JOIN_APP=="AVATAR"){
						v.FST_JOIN_APP = "아바타";
					} else if(v.FST_JOIN_APP=="SERP"){
						v.FST_JOIN_APP = "경리나라";
					} else if(v.FST_JOIN_APP=="ZEROPAY"){
						v.FST_JOIN_APP = "제로페이";
					} else if(v.FST_JOIN_APP=="KTSERP"){
						v.FST_JOIN_APP = "KT경리나라";
					}
					v.NO = totCnt - (i+ ((num_row * page_index) - num_row));
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
			
			var jexAjax = jex.createAjaxUtil("cstm_0101_01_r001");   //PT_ACTION 웹 서비스 호출
			input = {};
			input["SRCH_WD"] = $("#SRCH_WD").val();
			input["SRCH_CD"] = $("#SRCH_CD").val();
			input["STR_DT"] = $("#STR_DT").val().replace(/-/g, "");
			input["END_DT"] = $("#END_DT").val().replace(/-/g, "");
			input["FST_JOIN_APP"] = document.getElementById("FST_JOIN_APP").value;
			var STTS = "";
			var stts = [];
			$('input.STTS:checked').each(function() {		
				stts.push(this.value);
			});
			STTS =  stts + "";
			input["STTS"] = STTS;
			
			_thisPage.fn_excelGrid();
			jexAjax.set(input);
			jexAjax.execute(function(dat){
				var page_index = $(".pag_num>a[class='on']").text()-0;
				var num_row =  $(".btn_combo_down>#pageSize").text()-0;
				var rec = dat.REC;
				$.each(rec, function(i,v){
					v.REG_DTM = fintech.common.formatDate(v.REG_DTM.substr(0,8));
					
					if(v.STTS == "1") {
						v.STTS = "정상";
					} else if(v.STTS == "9") {
						v.STTS = "해지";
					} else if(v.STTS == "8") {
						v.STTS = "정지";
					}
					if(fintech.common.null2void(v.MEST_BIZ_NO)!=="") v.BIZ_NO = v.MEST_BIZ_NO;
					else v.BIZ_NO = formatter.corpNum(fintech.common.null2void(v.BIZ_NO));
					v.NO = totCnt - (i+ ((num_row * page_index) - num_row));
					v.LOGIN_LST_DTM = fintech.common.formatDate(fintech.common.null2void(v.LOGIN_LST_DTM).substr(0,8));
					v.DATA_YN = "은행("+v.ACCT_CNT+") / 홈택스("+v.HTAX_YN+") / 카드매출("+v.SALE_YN+") / 카드매입("+v.CARD_CNT+") / 온라인매출("+v.SNNS_YN+") / 경리나라("+v.SERP_YN+") / 제로페이("+v.ZP_YN+") / KT경리나라("+v.KTSERP_YN+")";
					v.AGRM_YN = "아바타("+v.A_AGRM_YN+") / 경리나라("+v.S_AGRM_YN+") / 제로페이("+v.Z_AGRM_YN+")";
					if(v.FST_JOIN_APP=="AVATAR"){
						v.FST_JOIN_APP = "아바타";
					} else if(v.FST_JOIN_APP=="SERP"){
						v.FST_JOIN_APP = "경리나라";
					} else if(v.FST_JOIN_APP=="ZEROPAY"){
						v.FST_JOIN_APP = "제로페이";
					} else if(v.FST_JOIN_APP=="KTSERP"){
						v.FST_JOIN_APP = "KT경리나라";
					}
					v.CORC_DTM = fintech.common.formatDtm(v.CORC_DTM);
					
				});
				
				 _grid.dataMgr.set(rec);
    			 _excelDownload(_grid, "가입자관리");    
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
	        	{key : "NO"						, name : "NO"				, width : "90px"  , style : "text-align:center" },
	        	{key : "FST_JOIN_APP"			, name : "유입채널"			, width : "90px"  , style : "text-align:center" },
	        	{key : "REG_DTM"				, name : "가입일자"			, width : "90px"  , style : "text-align:center" },
	            {key : "CUST_NM"				, name : "고객명"				, width : "90px"  , style : "text-align:center" },
	            {key : "BIZ_NO"					, name : "사업자번호"			, width : "150px" , style : "text-align:center" },
	            {key : "USE_INTT_ID"			, name : "고객번호"			, width : "150px" , style : "text-align:center" },
	            {key : "CLPH_NO"		      	, name : "휴대폰번호"			, width : "150px" , style : "text-align:center" },
	        	{key : "STTS"	    			, name : "상태"				, width : "100px" , style : "text-align:center" },
	            {key : "LOGIN_LST_DTM"			, name : "최종사용일자"			, width : "100px" , style : "text-align:center" },
	            {key : "DATA_YN"		      	, name : "데이터가져오기"		, width : "450px" , style : "text-align:center" },
	            {key : "AGRM_YN"		      	, name : "선택동의사항"		, width : "300px" , style : "text-align:center" },
	            {key : "CORC_DTM"				, name : "최종변경일시"			, width : "100px" , style : "text-align:center" },
	          ];

			_grid = JGM.create("Grid", {container:document.getElementById("grid"), colDefs:columns, options:gridOptions});
		},
		fn_grid: function(){
			
			var list = [];
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"NO",					VIEW_NM:"NO",				VIEW_STYLE : "width=50px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"FST_JOIN_APP",			VIEW_NM:"유입채널",			VIEW_STYLE : "width=70px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"REG_DTM",				VIEW_NM:"가입일자",			VIEW_STYLE : "width=90px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CUST_NM",				VIEW_NM:"고객명",				VIEW_STYLE : "width=90px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"BIZ_NO",				VIEW_NM:"사업자번호",			VIEW_STYLE : "width=125px;"		, VIEW_CLASS :"_text-dot"		, TITLE_YN : "Y"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"USE_INTT_ID",			VIEW_NM:"고객번호",			VIEW_STYLE : "width=125px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CLPH_NO",          	VIEW_NM:"휴대폰번호",			VIEW_STYLE : "width=150px;", 	FORMATTER:"formatter.phone"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"STTS",    				VIEW_NM:"상태",				VIEW_STYLE : "width=70px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"LOGIN_LST_DTM",		VIEW_NM:"최종사용일자",			VIEW_STYLE : "width=110px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"DATA_YN",          	VIEW_NM:"데이터가져오기",		VIEW_STYLE : "width=450px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"AGRM_YN",          	VIEW_NM:"선택동의사항",			VIEW_STYLE : "width=200px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CORC_DTM",          	VIEW_NM:"최종변경일시",			VIEW_STYLE : "width=150px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:""   , VIEW_NM:""});
			
			view_stgup.fn_search(false, "TABLE", list);
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
			var jexAjax = jex.createAjaxUtil("cstm_0101_01_r002");   //PT_ACTION 웹 서비스 호출
			var input = {};
			input["STR_DT"] = $("#STR_DT").val().replace(/-/g, "");
			input["END_DT"] = $("#END_DT").val().replace(/-/g, "");
			jexAjax.set(input);
			jexAjax.execute(function(data){
				$("#TOTL_NCNT").html(formatter.number(parseInt(data.TOTL_NCNT), 0)+" 개");
				$("#NORM_NCNT").html(formatter.number(parseInt(data.NORM_NCNT), 0)+" 개");
				$("#TRMN_NCNT").html(formatter.number(parseInt(data.TRMN_NCNT)+pareseInt(data.SPNC_NCNT),0)+"("+formatter.number(parseInt(data.TRMN_NCNT), 0)+"/"+formatter.number(parseInt(data.SPNC_NCNT), 0)+")개");
			});
		
		}
}

function __fn_init(){
	$("#cstm_0101_01").parents("div").addClass("on");
}
