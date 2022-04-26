/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name	 : blbd_0301_01.js
 * @File path	 : AVATAR_STATIC/web/js/jex/avatar/admin/blbd
 * @author		: 김별 (  )
 * @Description	: 
 * @History		: 20210504171836, 김별
 * </pre>
 **/
 var _grid;
 var totCnt;
 $(function(){
	_thisPage.setCalendar();
	_thisPage.fn_init();
	
	$(".btn_search_tb").on("click", function(){
		_thisPage.fn_init();
	});
	$(document).on("click", "#tbl_content tbody tr", function(){
		var CNSL_NO = $(this).data("cnsl_no");
		location.href = "blbd_0301_02.act?CNSL_NO="+CNSL_NO;
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
			var jexAjax = jex.createAjaxUtil("blbd_0301_01_r001");	//PT_ACTION 웹 서비스 호출
			//가입일자, 상태, 검색대상
			input = {};
			input["SRCH_WD"] = document.getElementById("SRCH_WD").value; //$("#SRCH_WD").val();
			input["SRCH_CD"] = document.getElementById("SRCH_CD").value; //$("#SRCH_CD").val();
			input["STR_DT"] = document.getElementById("STR_DT").value.replace(/-/g, ""); //$("#STR_DT").val().replace(/-/g, "");
			input["END_DT"] = document.getElementById("END_DT").value.replace(/-/g, ""); //$("#END_DT").val().replace(/-/g, "");
			
			var STTS = "";
			var stts = [];
			$('input.STTS:checked').each(function() {		
			  stts.push(this.value);
			});
			STTS =  stts + "";
			input["STTS"] = STTS;
			input["CNSL_DIV"] = $("#CNSL_DIV").val();

			input["PAGE_NO"] = pageIndex;
			input["PAGE_CNT"] = _paging.getPageSz();
			
			jexAjax.set(input);
			jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
			jexAjax.execute(function(dat) {
			  totCnt = dat.REC[0]? dat.REC[0].CNT : 0
			  _paging.setTotDataSize(totCnt); 		// 전체 데이터 건수
			  _paging.setPageNo(pageIndex);		// 페이지 인덱스
			  _paging.setPaging(dat.REC);		// 레코드 데이터 정보
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
			  sHtml += '	<tr class="no_hover" style="display:table-row;">';
			  sHtml += '		<td colspan="'+$("#tbl_content").find("colgroup").find("col").length+'" class="no_info"><div>내용이 없습니다.</div></td>';
			  sHtml += '	</tr>';
			  sHtml += '</tfoot>';
			  $(tbl_content).prepend(sHtml);
			}
			else{
			  var page_index = $(".pag_num>a[class='on']").text()-0;
			  var num_row =  $(".btn_combo_down>#pageSize").text()-0;
			  var sHtml = "";		
			  
			  $.each(rec, function(i, v) {
				if(v.CNSL_STTS == "0") {
				v.CNSL_STTS = "대기";
				} else if(v.CNSL_STTS == "1") {
				v.CNSL_STTS = "접수";
				} else if(v.CNSL_STTS == "2") {
				v.CNSL_STTS = "완료";
				}

				if(v.CNSL_DIV == "1") v.CNSL_DIV = "협력문의";
				v.NO = totCnt - (i+ ((num_row * page_index) - num_row));
				sHtml += "<tr class='text-dot' trIdx=\""+i+"\" data-cnsl_no=\""+v.CNSL_NO+"\">";
				sHtml += view_stgup.makeTableTbody(v,i);
				sHtml += "</tr>";
			  });	
			  $(tbl_content).find("tbody").append(sHtml);
			}
		},
		fn_grid: function(){
			
			var list = [];
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"NO"				,VIEW_NM:"NO"			,VIEW_STYLE : "width=50px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"RQST_DT"			,VIEW_NM:"신청일자"		,VIEW_STYLE : "width=110px;"		,FORMATTER:"formatter.date"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"RQST_BSNN_NM"		,VIEW_NM:"회사명"			,VIEW_STYLE : "width=150px;"		,VIEW_CLASS:"click_detail"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"RQST_BIZ_NO"		,VIEW_NM:"사업자번호"		,VIEW_STYLE : "width=150px;"		,FORMATTER:"formatter.corpNum"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"RQST_CUST_NM"		,VIEW_NM:"이름"			,VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"RQST_CLPH_NO"		,VIEW_NM:"연락처"			,VIEW_STYLE : "width=150px;"		,FORMATTER:"formatter.phone"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"RQST_EML"			,VIEW_NM:"이메일"			,VIEW_STYLE : "width=150px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CNSL_DIV"			,VIEW_NM:"신청구분	"		,VIEW_STYLE : "width=110px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CNSL_STTS"			,VIEW_NM:"상태"			,VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:""	, VIEW_NM:""});
			
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
		}, 
 }
 
 function __fn_init(){
	$("#blbd_0301_01").parents("div").addClass("on");
 }
 