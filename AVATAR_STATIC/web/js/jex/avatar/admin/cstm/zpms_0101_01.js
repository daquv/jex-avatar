/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : zpms_0101_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/cstm
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20210714152903, 김별
 * </pre>
 **/

var _grid;
$(function(){
	//alert("준비 중");
	_thisPage.setCalendar();
	_thisPage.fn_init();
	
	$(".btn_search_tb").on("click", function(){
		_thisPage.fn_init();
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
			var jexAjax = jex.createAjaxUtil("zpms_0101_01_r001");   //PT_ACTION 웹 서비스 호출
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
				$("#TOTL_NCNT").html(formatter.number(parseInt(dat.REC[0]? dat.REC[0].CNT : 0), 0));
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
					v.SMALL_FEE = fintech.common.null2void(v.SMALL_FEE)===""?"": fintech.common.null2void(v.SMALL_FEE)+"%";
					sHtml += "<tr class='text-dot' trIdx=\""+i+"\">";
					sHtml += view_stgup.makeTableTbody(v,i);
					sHtml += "</tr>";
				});	
				$(tbl_content).find("tbody").append(sHtml);
			}
		},
		fn_grid: function(){
			
			var list = [];
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"REG_DTM",				VIEW_NM:"등록일자",			VIEW_STYLE : "width=90px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"AFLT_MANAGEMENT_NO",	VIEW_NM:"가맹점관리번호",		VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"MEST_BIZ_NO",			VIEW_NM:"사업자등록번호",		VIEW_STYLE : "width=120px;", 	FORMATTER:"formatter.corpNum"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"MEST_NM",				VIEW_NM:"가맹점명",			VIEW_STYLE : "width=150px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"AFLT_OWNER_NM",		VIEW_NM:"대표자명",			VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"MEST_TEL_NO",			VIEW_NM:"가맹점전화번호",		VIEW_STYLE : "width=120px;", 	FORMATTER:"formatter.phone"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"MARKET_NM",			VIEW_NM:"시장명",				VIEW_STYLE : "width=150px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"MEST_ADDR",			VIEW_NM:"주소",				VIEW_STYLE : "width=250px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"TPBS",					VIEW_NM:"업종",				VIEW_STYLE : "width=100px;", VIEW_CLASS:"_text-dot", TITLE_YN : "Y"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"BIZ_TYPE_CD",			VIEW_NM:"업종코드",			VIEW_STYLE : "width=90px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"SMALL_FEE",			VIEW_NM:"수수료율",			VIEW_STYLE : "width=100px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"POINT_NM",				VIEW_NM:"결제가능상품권",		VIEW_STYLE : "width=250px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:""   , VIEW_NM:""});
			
			view_stgup.fn_search(true, "TABLE", list);
			view_stgup.makeTable("tbl_title", false, _thisPage.fn_search, false, false);
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
}

function __fn_init(){
	$("#zpms_0101_01").parents("div").addClass("on");
}
