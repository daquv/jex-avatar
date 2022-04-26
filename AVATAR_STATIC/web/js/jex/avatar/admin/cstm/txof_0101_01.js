/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : txof_0101_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/cstm
 * @author         : 김별 (  )
 * @Description    : 세무사 DB
 * @History        : 20210715134121, 김별
 * </pre>
 **/
var _grid;
$(function(){
	_thisPage.setCalendar();
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
	
	$("#regiExcel").on("click", function(){
		_thisPage.fn_regiExcel();
	})
	$("#deleteBtn").on("click", function(){
		if($('input:checkbox[name="chkOne"]:checked').length>0){
			if(confirm("선택된 세무사 DB를 삭제하시겠습니까?")){
        		_thisPage.fn_delete();
        	} else {
        		$('input:checkbox[name="chkAll"]').attr('checked',false);
        		$('input:checkbox[name="chkOne"]').attr('checked',false);
        		return false;
        	}
    	} else {
    		alert("삭제할 항목이 없습니다.");
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
			var jexAjax = jex.createAjaxUtil("txof_0101_01_r001");   //PT_ACTION 웹 서비스 호출
			//가입일자, 상태, 검색대상
			input = {};
			input["SRCH_WD"] = document.getElementById("SRCH_WD").value;
			input["SRCH_CD"] = document.getElementById("SRCH_CD").value;
			input["STR_DT"] = document.getElementById("STR_DT").value.replace(/-/g, "");
			input["END_DT"] = document.getElementById("END_DT").value.replace(/-/g, "");
			input["PAGE_NO"] = pageIndex;
			input["PAGE_CNT"] = _paging.getPageSz();
			
			jexAjax.set(input);
			jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
			jexAjax.execute(function(dat) {
				_paging.setTotDataSize(dat.REC[0]? dat.REC[0].CNT : 0); 		// 전체 데이터 건수
				_paging.setPageNo(pageIndex);    	// 페이지 인덱스
				_paging.setPaging(dat.REC);     	// 레코드 데이터 정보
				// 조회조건을 바꾸고 페이징 조회 호출하는 것 방지
				_paging.setParam(jexAjax, pageIndex);
				$("#TOTL_NCNT").html(formatter.number(parseInt(dat.TOTL_NCNT? dat.TOTL_NCNT : 0), 0));
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
					sHtml += "<tr class='text-dot' trIdx=\""+i+"\">";
					sHtml += '	<td><div><span><input type="checkbox" name="chkOne" data-seq_no="'+v.SEQ_NO+'" data-biz_no="'+v.BIZ_NO+'"></span></div></td>';
					sHtml += view_stgup.makeTableTbody(v,i);
					sHtml += "</tr>";
				});	
				$(tbl_content).find("tbody").append(sHtml);
			}
		},
		fn_grid: function(){
			
			var list = [];
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"COSN_DT",				VIEW_NM:"개인정보제공동의일자",	VIEW_STYLE : "width=110px;", 	FORMATTER:"formatter.date"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"BSNN_NM",				VIEW_NM:"사무소이름",			VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CHRG_NM",				VIEW_NM:"세무사",				VIEW_STYLE : "width=100px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"MAJR_SPHR",			VIEW_NM:"전문분야",			VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CHRG_TEL_NO",			VIEW_NM:"연락처",				VIEW_STYLE : "width=120px;", 	FORMATTER:"formatter.phone"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"LOCA_NM",				VIEW_NM:"지역",				VIEW_STYLE : "width=80px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"ADRS1",				VIEW_NM:"시군구",				VIEW_STYLE : "width=100px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"DTL_ADRS",				VIEW_NM:"상세주소",			VIEW_STYLE : "width=200px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"TEL_LINK_CNT",			VIEW_NM:"연결횟수",			VIEW_STYLE : "width=80px;"});
			
			view_stgup.fn_search(true, "TABLE", list);
			view_stgup.makeTable("tbl_title", true, _thisPage.fn_search, false, false);
			_paging = $("#tbl_paging").tablePaging("tbl1", _thisPage.fn_search, _thisPage.cb_search, "1", "15", "Y", null);
			_paging.initPage();
			
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
		fn_regiExcel : function(){
			var $form = $("<form id='exclReg' method='post' action='txof_0102_01.act'></form>");
			$form.appendTo('body');
			$("#exclReg").submit();
		},
		fn_delete : function() {
			var datalist = new Array();
			$("#tbl_content").find("tr").each(function(){
				if($(this).find("input").is(":checked")){
					datalist.push({
						SEQ_NO		: $(this).find("input").attr("data-seq_no"),
						BIZ_NO		: $(this).find("input").attr("data-biz_no"),
						STTS		: "9",
					});
				}
			});

			var jexAjax  = jex.createAjaxUtil('txof_0101_01_d001');
			
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
	$("#txof_0101_01").parents("div").addClass("on");
}
