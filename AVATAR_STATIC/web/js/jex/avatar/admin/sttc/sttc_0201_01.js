/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : sttc_0201_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/sttc
 * @author         : 김태훈 (  )
 * @Description    : 어드민 로그인현황화면
 * @History        : 20200309140629, 김태훈
 * </pre>
 **/

var _grid;
var _thisInfm = {};
_thisPage = {
		fn_init: function(){
			_thisPage.fn_grid();
			_thisPage.fn_search();
			_thisPage.fn_getInttInfm();
		}
		,fn_search : function(pageNo){
			var pageIndex = fintech.common.null2void(pageNo, "1");
			_pageNo = pageIndex;
			
			var STTS = "";
			var stts = [];
			$('input[name=STTS]:checked').each(function() {		
				stts.push(this.value);
			});
			STTS =  stts + "";
			
			var jexAjax = jex.createAjaxUtil("sttc_0201_01_r001");   //PT_ACTION 웹 서비스 호출
			jexAjax.set("INQ_DT_DV_CD"	, $("#select_01 option:selected").val()); //기간코드 
			jexAjax.set("INQ_YM"		, $("#YEAR option:selected").val()+$("#MONTH option:selected").val());	//조회년월
			jexAjax.set("INQ_TRCN"		, $("#select_02 option:selected").val());	// 검색대상
			jexAjax.set("INQ_TRCN_CTT"	, $('#searchValue').val());	// 내용
			jexAjax.set("INQ_STR_DT"	, $("#START_DT").val().replace(/-/g,''));
			jexAjax.set("INQ_END_DT"	, $("#END_DT").val().replace(/-/g,''));
			jexAjax.set("LOGIN_CD"		, $("#select_03 option:selected").val());	// 로그인횟수(없음,이상,이하)
			jexAjax.set("LOGIN_CNT"		, $('#searchValueLogin').val());	// 로그인횟수
			jexAjax.set("DUP_YN"		, $("#DUP_YN").is(':checked'));	// 중복일 제거 yn
			jexAjax.set("STTS"			, STTS);
			
			jexAjax.set("PAGE_NO"        , pageIndex); 				// 페이지 번호
			jexAjax.set("PAGE_SIZE"      , _paging.getPageSz());	// 페이지 크기
			
			jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
			jexAjax.execute(function(dat) {
				var cnt = dat.CNT; 
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
				//조회기간 넣어둠
				_thisInfm.INQ_DT_DV_CD = $("#select_01 option:selected").val();
				_thisInfm.INQ_YM = $("#YEAR option:selected").val()+$("#MONTH option:selected").val();
				_thisInfm.INQ_STR_DT = $("#START_DT").val();
				_thisInfm.INQ_END_DT = $("#END_DT").val();
				_thisInfm.INQ_TRCN = $("#select_02 option:selected").val();
				var sHtml = "";		
				$.each(rec, function(i, v) {
					if($("#DUP_YN").is(":checked")){
						v.LOGIN_CNT = v.LOGIN_CNT_DUP;
					}
					if(v.REG_DTM){
						v.REG_DT = fintech.common.formatDate(v.REG_DTM.substring(0,8));
					}
					if(v.LOGIN_LST_DTM=="00000000000000"){
						v.LOGIN_LST_DTM = "";
					} else if(v.LOGIN_LST_DTM){
						v.LOGIN_LST_DTM = fintech.common.formatDtm(v.LOGIN_LST_DTM);
					}
					if(v.STTS!="1"){
						v.LOGIN_LST_DTM = "";
						v.LOGIN_CNT = "";
					}
					if(v.LOGIN_CNT=="0"){
						v.LOGIN_CNT = "";
					} else {
						v.LOGIN_CNT = formatter.number(parseInt(v.LOGIN_CNT));
					}
					
					sHtml += "<tr class='text-dot' trIdx=\""+i+"\">";
					sHtml += view_stgup.makeTableTbody(v,i);
					sHtml += "</tr>";
				});	
				$(tbl_content).find("tbody").append(sHtml);
			}
		},
		fn_grid: function(){
			var list = [];
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"REG_DT",     		VIEW_NM:"가입일자",     	VIEW_STYLE : "width=100px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"USE_INTT_ID",     	VIEW_NM:"고객번호",    	VIEW_STYLE : "width=120px"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CUST_NM",     		VIEW_NM:"고객명",    		VIEW_STYLE : "width=100px;",	VIEW_CLASS : "tac"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CLPH_NO",     		VIEW_NM:"핸드폰번호", 		VIEW_STYLE : "width=100px;",	VIEW_CLASS : "tac", 	FORMATTER:"formatter.phone"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"STTS_NM",     		VIEW_NM:"상태",     		VIEW_STYLE : "width=100px;",	VIEW_CLASS : "tac"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"LOGIN_CNT",   		VIEW_NM:"로그인횟수",       	VIEW_STYLE : "width=100px;",	ONCLICKYN:"Y", ONCLICK:"click_dtl",
				ONCLICKDATA:"USE_INTT_ID,LOGIN_CNT,CUST_NM,LOGIN_CNT_DUP",	VIEW_CLASS : "tar"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"LOGIN_LST_DTM",   	VIEW_NM:"최종로그인일시",       VIEW_STYLE : "width=200px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:""   , VIEW_NM:""});
			
			view_stgup.fn_search(true, "TABLE", list);
			view_stgup.makeTable("tbl_title", false, _thisPage.fn_search, false, false);
			_paging = $("#tbl_paging").tablePaging("tbl1", _thisPage.fn_search, _thisPage.cb_search, "1", "15", "Y", null);
			_paging.initPage();
			
		},
		fn_dwnExcel: function(){
			var STTS = "";
			var stts = [];
			$('input[name=STTS]:checked').each(function() {		
				stts.push(this.value);
			});
			STTS =  stts + "";
			var jexAjax = jex.createAjaxUtil("sttc_0201_01_r001");   //PT_ACTION 웹 서비스 호출
			jexAjax.set("INQ_DT_DV_CD"	, $("#select_01 option:selected").val()); //기간코드 
			jexAjax.set("INQ_YM"		, $("#YEAR option:selected").val()+$("#MONTH option:selected").val());	//조회년월
			jexAjax.set("INQ_TRCN"		, $("#select_02 option:selected").val());	// 검색대상
			jexAjax.set("INQ_TRCN_CTT"	, $('#searchValue').val());	// 내용
			jexAjax.set("INQ_STR_DT"	, $("#START_DT").val().replace(/-/g,''));
			jexAjax.set("INQ_END_DT"	, $("#END_DT").val().replace(/-/g,''));
			jexAjax.set("LOGIN_CD"		, $("#select_03 option:selected").val());	// 로그인횟수(없음,이상,이하)
			jexAjax.set("LOGIN_CNT"		, $('#searchValueLogin').val());	// 로그인횟수
			jexAjax.set("DUP_YN"		, $("#DUP_YN").is(':checked'));	// 중복일 제거 yn
			jexAjax.set("STTS"			, STTS);
			
			jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
			
			_thisPage.fn_makeExcGrid();
			
			jexAjax.execute(function(dat) {
				
				var rec = dat.REC;
    			$.each(rec, function(i, v) {
    				v.CLPH_NO = formatter.phone(v.CLPH_NO);
    				if($("#DUP_YN").is(":checked")){
    					v.LOGIN_CNT = v.LOGIN_CNT_DUP;
					} 
    				if(v.REG_DTM){
						v.REG_DT = fintech.common.formatDate(v.REG_DTM.substring(0,8));
					}
					if(v.LOGIN_LST_DTM=="00000000000000"){
						v.LOGIN_LST_DTM = "";
					} else if(v.LOGIN_LST_DTM){
						v.LOGIN_LST_DTM = fintech.common.formatDtm(v.LOGIN_LST_DTM);
					}
					if(v.STTS!="1"){
						v.LOGIN_LST_DTM = "";
						v.LOGIN_CNT = "";
					}
					if(v.LOGIN_CNT=="0"){
						v.LOGIN_CNT = "";
					} else {
						v.LOGIN_CNT = formatter.number(parseInt(v.LOGIN_CNT));
					}
    			});	
				 _grid.dataMgr.set(rec);
    			 _excelDownload(_grid, "로그인현황조회");
				
			});
		}
		,fn_makeExcGrid: function(){
			if(_grid!=null) _grid.destroy();
		    //그리드 옵션 설정
		    var gridOptions = smart.grid.getDefaultOptions();
		    $("body").append("<div id='grid' style='display:none'></div>");
		    //Jex Grid Column
		    var columns = [];
		    
			columns = [
				{key : "REG_DT" , 			name : "가입일자" , 		width : "100px" , 	style : "text-align:center"  },
				{key : "USE_INTT_ID" , 		name : "고객번호" , 		width : "230px" , 	style : "text-align:center"  },
				{key : "CUST_NM" , 			name : "고객명" , 		width : "100px" , 	style : "text-align:center"  },
				{key : "CLPH_NO" , 			name : "핸드폰번호" , 		width : "100px" , 	style : "text-align:center"  },
				{key : "STTS_NM" , 			name : "상태" , 			width : "100px" , 	style : "text-align:center"  },
				{key : "LOGIN_CNT" , 		name : "로그인횟수" , 		width : "100px" , 	style : "text-align:center"  },
				{key : "LOGIN_LST_DTM" , 	name : "최종로그인일시" , 	width : "80px" , 	style : "text-align:center"  }
		    ];
		  
		    _grid = JGM.create("Grid", {container:document.getElementById("grid"), colDefs:columns, options:gridOptions});
		},
		fn_getInttInfm: function(){
			var jexAjax = jex.createAjaxUtil("sttc_0201_01_r002");   //PT_ACTION 웹 서비스 호출
			jexAjax.set("INQ_DT_DV_CD"	, $("#select_01 option:selected").val()); //기간코드 
			jexAjax.set("INQ_YM"		, $("#YEAR option:selected").val()+$("#MONTH option:selected").val());	//조회년월
			jexAjax.set("INQ_STR_DT"	, $("#START_DT").val().replace(/-/g,''));
			jexAjax.set("INQ_END_DT"	, $("#END_DT").val().replace(/-/g,''));
			jexAjax.execute(function(data){
				$("#TOTL_NCNT").html(formatter.number(parseInt(data.TOTL_NCNT)+parseInt(data.TRMN_NCNT)+parseInt(data.SPNC_NCNT), 0)+" 개");
				$("#NORM_NCNT").html(formatter.number(parseInt(data.TOTL_NCNT), 0)+" 개");
				$("#TRMN_NCNT").html(formatter.number(parseInt(data.TRMN_NCNT)+parseInt(data.SPNC_NCNT),0)+"("+formatter.number(parseInt(data.TRMN_NCNT), 0)+"/"+formatter.number(parseInt(data.SPNC_NCNT), 0)+")개");
				$("#LOGIN_NCNT").html(formatter.number(parseInt(data.LOGIN_CNT), 0)+" 개");
				$("#TOTL_LOGIN_NCNT").html(formatter.number(parseInt(data.LOGIN_SUM_CNT), 0)+" 회");
				$("#AVRG_NCNT").html(formatter.number(parseInt(data.LOGIN_SUM_CNT)/parseInt(data.LOGIN_CNT), 0)+" 회");
			});
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
		fn_detail: function(form, id, data){
			var $form = $("<form method='post'></form>");
			$form.append("<input name='USE_INTT_ID' value='"+data.USE_INTT_ID+"'>");
			$form.append("<input name='CUST_NM' 	value='"+data.CUST_NM+"'>");
			//$form.append("<input name='LOGIN_CNT' 	value='"+data.LOGIN_CNT+"'>");
			$form.append("<input name='INQ_DT_DV_CD' value='"+_thisInfm.INQ_DT_DV_CD+"'>");
			$form.append("<input name='INQ_END_DT' 	value='"+_thisInfm.INQ_END_DT+"'>");
			$form.append("<input name='INQ_STR_DT' 	value='"+_thisInfm.INQ_STR_DT+"'>");
			$form.append("<input name='INQ_YM' 		value='"+_thisInfm.INQ_YM+"'>");
			$form.append("<input name='LOGIN_CNT_DUP'value='"+data.LOGIN_CNT_DUP+"'>");
			var dt_txt = "";
			if(_thisInfm.INQ_DT_DV_CD=="2"){
				dt_txt = "일별: " + _thisInfm.INQ_STR_DT;
			} else if(_thisInfm.INQ_DT_DV_CD=="1"){
				dt_txt = _thisInfm.INQ_STR_DT+" ~ "+_thisInfm.INQ_END_DT;
			} else if(_thisInfm.INQ_DT_DV_CD=="0"){
				dt_txt = "월별: " +  _thisInfm.INQ_YM.substring(0,4)+"-"+_thisInfm.INQ_YM.substring(4,6);
			}
			dt_txt = encodeURIComponent(dt_txt)
			$form.append("<input name='DATE_VAL' value='"+dt_txt+"'>");
			
			smartOpenPop({href: "sttc_0201_02.act", width:920, height:700, scrolling:false, target:window, frm:$form});
		}
		
		
}

$(function(){
	
	_thisPage.fn_setCalendar();
	_thisPage.fn_getYearSelect();
	_thisPage.fn_getMonthSelect();
	_thisPage.fn_init();
	
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
	
	// EVENT
	
	$("#searchBtn").click(function(){
		_thisPage.fn_init();
	});
	
	$("#btnExceldown").click(function(){
		_thisPage.fn_dwnExcel();
	});
	//출력순서 입력 제한
	$("#searchValueLogin").on("keyup", function(){
		var maxlength = $(this).attr("maxlength");
		var str = $(this).val().replace(/[^0-9]/gi,"");		// 숫자만 입력 가능
		if(str.length > maxlength){
	    	$(this).val(str.slice(0,maxlength));
	    }else{
	    	$(this).val(str);	
	    }		    
	});
});




function __fn_init(){
	
	$("#START_DT").css("display","none");
	$("div img:nth-child(3)").css("display","none");
	$(".end_dt").css("display","none");
	$("div img:nth-child(6)").css("display","none");
	$(".none").css("display","inline-block");
	$("#sttc_0201_01").parents("div").addClass("on");
	
	$(".click_dtl").live("click", function(){
		// set value to Hidden input
		var useInttId 	= $(this).attr("data-USE_INTT_ID");
		var bsnnNm		=  $(this).attr("data-BSNN_NM");
		
		$("#POP_USE_INTT_ID").val(useInttId);
		$("#POP_BSNN_NM").val(bsnnNm);
		$("#TITLE").val($("title").text());
		$("#POP_SEARCH_GB").val("");
		
		var dataList = {
				USE_INTT_ID		: $(this).attr("data-USE_INTT_ID"),
				CUST_NM			: $(this).attr("data-CUST_NM"),
				LOGIN_CNT_DUP	: $(this).attr("data-LOGIN_CNT_DUP"),
		};
		
	    _thisPage.fn_detail("form1", "click_dtl", dataList);
	});
}