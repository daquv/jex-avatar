/**+
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : sttc_0102_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/sttc
 * @author         : 김태훈 (  )
 * @Description    : 어드민 질의 현황 화면
 * @History        : 20200309140508, 김태훈
 * </pre>
 **/
var _grid;
$(function(){
	_thisPage.fn_setCalendar();
	_thisPage.fn_getYearSelect();
	_thisPage.fn_getMonthSelect();
	_thisPage.fn_getInfm();
	_thisPage.fn_init();
	
	$(".btn_search_tb").on("click", function(){
		_thisPage.fn_init();
	});
	
	$("#select_01").on("change", function(){
		if($("#select_01 option:selected").val() == "1"){
			$("#START_DT").css("display","inline-block");
			$("div img:nth-child(3)").css("display","inline-block");
			$(".end_dt").css("display","inline-block");
			$("div img:nth-child(6)").css("display","inline-block");
			$(".none").css("display","none");
			
			_thisPage.fn_setCalendar2();
		}else if($("#select_01 option:selected").val() == "0"){
			$("#START_DT").css("display","none");
			$("div img:nth-child(3)").css("display","none");
			$(".end_dt").css("display","none");
			$("div img:nth-child(6)").css("display","none");
			$(".none").css("display","inline-block");
		}else{
			$("#START_DT").css("display","inline-block");
			$("div img:nth-child(3)").css("display","inline-block");
			$(".end_dt").css("display","none");
			$("div img:nth-child(6)").css("display","none");
			$(".none").css("display","none");
			_thisPage.fn_setCalendar();
		}
	});
	$("#btnExceldown").click(function(){
		_thisPage.fn_ExcelExp();
	});
	
	//전체 선택
	$(document).on("click", "#checkboxAll", function(){
    	if($('#checkboxAll').is(":checked")){
    		$('input[name="chkOne"]').each(function(){ //
    			if(!$(this).prop("disabled")){ //비활성화가 아니라면
    				$(this).prop('checked', true); //체크 실행
    			}
    		});
    	} else {
    		$('input:checkbox[name="chkOne"]').attr('checked',false);
    	}
    		
    });
	
	$(document).on("click", ".cmdChangeLrnStts", function(){
		if($('input:checkbox[name="chkOne"]:checked').length>0){
			_thisPage.fn_changeLrnStts($(this).data("val"));
    	} else {
    		alert("선택된 질의가 없습니다.");
    	}
	})
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
			var jexAjax = jex.createAjaxUtil("sttc_0102_01_r002");   //PT_ACTION 웹 서비스 호출
			jexAjax.set("INQ_DT_DV_CD"	, $("#select_01 option:selected").val()); //기간코드 
			jexAjax.set("INQ_YM"		, $("#YEAR option:selected").val()+$("#MONTH option:selected").val());	//조회년월
			jexAjax.set("INQ_TRCN"		, $("#select_04 option:selected").val());	// 검색대상코드
			jexAjax.set("INQ_TRCN_CTT"	, $('#searchValue').val());	// 검색내용
			jexAjax.set("INQ_STR_DT"	, $("#START_DT").val().replace(/-/g,''));
			jexAjax.set("INQ_END_DT"	, $("#END_DT").val().replace(/-/g,''));
			jexAjax.set("CTGR_CD"		, $("#select_02 option:selected").val());	// 카테고리
			jexAjax.set("INTE_CD"		, $("#select_03 option:selected").val());	// 인텐트
			jexAjax.set("APP_ID"		, $("#APP_ID option:selected").val());	// 질의채널
			jexAjax.set("LRN_STTS"		, $("#LRN_STTS option:selected").val());	// 학습상태
			
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
					
					if(fintech.common.null2void(v.INTE_CD) != ""){
						v.INTE_CD = fintech.common.null2void(v.INTE_NM)+"("+v.INTE_CD+")";
					}
					
					if(fintech.common.null2void(v.APP_ID) == "AVATAR"){v.APP_ID="아바타"}
					else if(fintech.common.null2void(v.APP_ID) == "SERP"){v.APP_ID="경리나라"}
					else if(fintech.common.null2void(v.APP_ID) == "ZEROPAY"){v.APP_ID="제로페이"}
					else if(fintech.common.null2void(v.APP_ID) == "KTSERP"){v.APP_ID="KT경리나라"}
					v.PUSH_SEND_DTM = fintech.common.formatDtm(v.PUSH_SEND_DTM);
					sHtml += "<tr class='text-dot' trIdx=\""+i+"\">";
					if(v.INTE_CD != ""){
						sHtml += '	<td><div><span><input type="checkbox" name="chkOne" disabled></span></div></td>';
					} else{
						sHtml += '	<td><div><span><input type="checkbox" name="chkOne" data-use_intt_id="'+v.USE_INTT_ID+'" data-ques_dtm="'+v.QUES_DTM+'" data-voic_ctt="'+v.QUES_CTT+'" ></span></div></td>';
					}
					v.QUES_DTM = fintech.common.formatDtm(v.QUES_DTM);
					sHtml += view_stgup.makeTableTbody(v,i);
					sHtml += "</tr>";
				});	
				$(tbl_content).find("tbody").append(sHtml);
			}
		},
		fn_ExcelExp: function(){
			var pageIndex = fintech.common.null2void("", "1");
			_pageNo = pageIndex;
			
			var jexAjax = jex.createAjaxUtil("sttc_0102_01_r002");   //PT_ACTION 웹 서비스 호출
			jexAjax.set("INQ_DT_DV_CD"	, $("#select_01 option:selected").val()); //기간코드 
			jexAjax.set("INQ_YM"		, $("#YEAR option:selected").val()+$("#MONTH option:selected").val());	//조회년월
			jexAjax.set("INQ_TRCN"		, $("#select_04 option:selected").val());	// 검색대상코드
			jexAjax.set("INQ_TRCN_CTT"	, $('#searchValue').val());	// 내용
			jexAjax.set("INQ_STR_DT"	, $("#START_DT").val().replace(/-/g,''));
			jexAjax.set("INQ_END_DT"	, $("#END_DT").val().replace(/-/g,''));
			jexAjax.set("CTGR_CD"		, $("#select_02 option:selected").val());	// 카테고리
			jexAjax.set("INTE_CD"		, $("#select_03 option:selected").val());	// 인텐트코드
			jexAjax.set("APP_ID"		, $("#APP_ID option:selected").val());	// 질의채널
			_thisPage.fn_excelGrid();

			jexAjax.execute(function(dat){
				var rec = dat.REC;
				$.each(rec, function(i,v){
					v.QUES_DTM = fintech.common.formatDtm(v.QUES_DTM);
					if(fintech.common.null2void(v.INTE_CD) != ""){
						v.INTE_CD = fintech.common.null2void(v.INTE_NM)+"("+v.INTE_CD+")";
					}
					if(fintech.common.null2void(v.APP_ID) == "AVATAR"){v.APP_ID="아바타"}
					else if(fintech.common.null2void(v.APP_ID) == "SERP"){v.APP_ID="경리나라"}
					else if(fintech.common.null2void(v.APP_ID) == "ZEROPAY"){v.APP_ID="제로페이"}
					else if(fintech.common.null2void(v.APP_ID) == "KTSERP"){v.APP_ID="KT경리나라"}
					v.PUSH_SEND_DTM = fintech.common.formatDtm(v.PUSH_SEND_DTM);
				});
				 _grid.dataMgr.set(rec);
    			 _excelDownload(_grid, "질의현황");    
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
	        	{key : "QUES_DTM"				, name : "질의일시"			, width : "150px"  , style : "text-align:center" },
	        	{key : "APP_ID"					, name : "구분"			, width : "200px"  , style : "text-align:center" },
	            {key : "QUES_CTT"				, name : "질의내용"			, width : "200px"  , style : "text-align:center" },
	            {key : "INTE_CD"		      	, name : "인텐트"				, width : "150px"  , style : "text-align:center" },
	        	{key : "CTGR_NM"	    		, name : "카테고리"			, width : "90px"   , style : "text-align:center" },
	            {key : "USE_INTT_ID"			, name : "고객번호"			, width : "100px"  , style : "text-align:center" },
	            {key : "CUST_NM"		      	, name : "고객명"				, width : "90px"   , style : "text-align:center" },
	            {key : "CLPH_NO"		      	, name : "핸드폰번호"			, width : "90px"   , style : "text-align:center" },
	            {key : "LRN_STTS"		      	, name : "학습상태"			, width : "90px"   , style : "text-align:center" },
	            {key : "PUSH_SEND_DTM"	      	, name : "푸시발송일시"			, width : "90px"   , style : "text-align:center" },
	            {key : "ENC_CUST_CI"	      	, name : "고객CI"			, width : "90px"   , style : "text-align:center" },
	          ];

			_grid = JGM.create("Grid", {container:document.getElementById("grid"), colDefs:columns, options:gridOptions});
		},
		fn_grid: function(){
			
			var list = [];
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"QUES_DTM",				VIEW_NM:"질의일시",			VIEW_STYLE : "width=150px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"APP_ID",				VIEW_NM:"구분",				VIEW_STYLE : "width=150px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"QUES_CTT",				VIEW_NM:"질의내용",			VIEW_STYLE : "width=300px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"INTE_CD",          	VIEW_NM:"인텐트",				VIEW_STYLE : "width=200px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CTGR_NM",    			VIEW_NM:"카테고리",			VIEW_STYLE : "width=90px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"USE_INTT_ID",			VIEW_NM:"고객번호",			VIEW_STYLE : "width=100px;",	VIEW_CLASS : "tac"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CUST_NM",				VIEW_NM:"고객명",				VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CLPH_NO",				VIEW_NM:"핸드폰번호",			VIEW_STYLE : "width=90px;", 	FORMATTER:"formatter.phone"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"LRN_STTS",				VIEW_NM:"학습상태",			VIEW_STYLE : "width=90px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"PUSH_SEND_DTM",		VIEW_NM:"푸시발송일시",			VIEW_STYLE : "width=150px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:""   , VIEW_NM:""});
			
			view_stgup.fn_search(true, "TABLE", list);
			view_stgup.makeTable("tbl_title", true, _thisPage.fn_search, false, false);
			_paging = $("#tbl_paging").tablePaging("tbl1", _thisPage.fn_search, _thisPage.cb_search, "1", "15", "Y", null);
			_paging.initPage();
			
		},
		fn_setCalendar: function(){
			// 조회일자 시작일
			datePicker.setCalendar("#START_DT");
			$("#START_DT").val(fintech.common.getDate("yyyy-mm-dd", "D", 1));	//전일
			$("#END_DT").val($("#START_DT").val());
			
		},
		fn_setCalendar2: function(){
			// 조회일자 시작일
			datePicker.setCalendar("#START_DT");
			$("#START_DT").val(fintech.common.getDate("yyyy-mm-dd","M",-3));	//이전3개월
			// 조회일자 종료일
			datePicker.setCalendar("#END_DT");
			$("#END_DT").val(fintech.common.getDate("yyyy-mm-dd"));	//현재일자	
		},
		fn_getYearSelect: function(){
			var today = new Date();
			var year = "";
			for( var i=today.getFullYear(); i>=today.getFullYear()-10; i-- ) {
				if(today.getFullYear() != i){
					year += "<option value='"+i+"'>"+i+"</option>"
				}else{
					year += "<option value='"+i+"' selected='selected'>"+i+"</option>"
				}
			}
			$("#YEAR").html(year);
		},
		fn_getMonthSelect: function(){
			var today = new Date();
			var month = "";
			for(var i=1; i<=12; i++ ){
				if(today.getMonth()+1 != i){
					if(i < 10){
						month += "<option value='0"+i+"'>0"+i+"</option>"
					}else{
						month += "<option value='"+i+"'>"+i+"</option>"
					}
				}else{
					if(i < 10){
						month += "<option value='0"+i+"' selected='selected'>0"+i+"</option>"
					}else{
						month += "<option value='"+i+"' selected='selected'>"+i+"</option>"
					}
				}
			}
			$("#MONTH").html(month);
		},
		fn_getInfm: function(){	//가입일자만 적용
			var jexAjax = jex.createAjaxUtil("sttc_0102_01_r001");   //PT_ACTION 웹 서비스 호출
			jexAjax.set("DSDL_GRP_CD","B2001");
			jexAjax.setAsync(false);
			jexAjax.execute(function(data){
				fn_setOption("select_02",data.CTGR_REC);
				fn_setOption("select_03",data.INTE_REC);
			});
		},
		fn_changeLrnStts : function(dv){
			
			var checkList = $("#tbl_content").find("input:checkbox[name=chkOne]:checked").map(function(){
				var $this = $(this);
				
				return {
					USE_INTT_ID : $this.data("use_intt_id"),
					QUES_DTM : $this.data("ques_dtm"),
					VOIC_CTT : $this.data("voic_ctt"),
					LRN_STTS : dv
				}
			}).get();
			
			console.log(checkList);
			
			var jexAjax  = jex.createAjaxUtil('sttc_0102_01_u002');
			
			jexAjax.set("INSERT_REC"        , checkList); // REC
			jexAjax.set("_LODING_BAR_YN_", "Y"                           ); // 로딩바 출력여부
			
			jexAjax.execute(function(dat) {
				if(dat.RSLT_CD=="0000"){
					alert("학습상태가 변경되었습니다.");
					$('input:checkbox[name="chkOne"]').attr('checked',false);
					$('#checkboxAll').attr('checked',false);
					_thisPage.fn_search();
				} else {
					alert("오류가 발생하였습니다.")
				}
			});
			
		}
}

function __fn_init(){
	$("#START_DT").css("display","none");
	$("div img:nth-child(3)").css("display","none");
	$(".end_dt").css("display","none");
	$("div img:nth-child(6)").css("display","none");
	$(".none").css("display","inline-block");
	$("#scct_0102_00").parents("div").addClass("on");
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
		optionHtml += '<option value="no">해당없음</option>';
	}
	_selectBox.html(optionHtml);
}
