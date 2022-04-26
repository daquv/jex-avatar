/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : plfm_0101_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/plfm
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200709143748, 김별
 * </pre>
 **/
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
	$("#cmdNew").on("click", function(){
		_thisPage.fn_regi();
	});
	$("#cmdStts").on("click", function(){
		var jsonData = new Array();
		if($('input[name="chkOne"]:checked').length>0){
			$("#tbl_content").find('input[name=chkOne]:checked').each(function(i,v){
				var jsonObject = new Object();
				jsonObject.USER_ID =  $(this).data("user_id");
				jsonData.push(jsonObject);
			});
			_thisPage.fn_sttsEdit(JSON.stringify(jsonData));
		} else{
			alert("내역을 선택하세요.");
		}
	});
	$(document).on("click",".click_detail",function() {
		var data;
		data = {USER_ID : $(this).data("user_id")};
		_thisPage.fn_detail(data);
	  });
});

var _thisPage = {
		fn_init : function(){
			
			_thisPage.fn_grid();
			_thisPage.fn_search();
		},
		fn_grid: function(){
			var list = [];
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"USER_ID",				VIEW_NM:"아이디",			VIEW_STYLE : "width=200px;",
					   ONCLICKYN:"Y", 
					   ONCLICK:"click_detail", 
					   ONCLICKDATA: "USER_ID"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"USER_NM",				VIEW_NM:"성명",			VIEW_STYLE : "width=150px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"BSNN_NM",				VIEW_NM:"회사명",			VIEW_STYLE : "width=100px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"DEPT_NM",				VIEW_NM:"부서명",			VIEW_STYLE : "width=150px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"OFLV",					VIEW_NM:"직급",			VIEW_STYLE : "width=150px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"USE_ATHT",				VIEW_NM:"이용권한",		VIEW_STYLE : "width=100px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"USER_GB",				VIEW_NM:"사용자구분",		VIEW_STYLE : "width=100px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"REG_DTM",				VIEW_NM:"가입일자",		VIEW_STYLE : "width=250px;", 	FORMATTER:"formatter.datetime"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"STTS",					VIEW_NM:"가입상태",		VIEW_STYLE : "width=100px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:""   , VIEW_NM:""});
			
			view_stgup.fn_search(true, "TABLE", list);
			view_stgup.makeTable("tbl_title", true, _thisPage.fn_search, false, false);
			_paging = $("#tbl_paging").tablePaging("tbl1", _thisPage.fn_search, _thisPage.cb_search, "1", "15", "Y", null);
			_paging.initPage();
			
		},
		fn_search : function(pageNo){
			var pageIndex = fintech.common.null2void(pageNo, "1");
			_pageNo = pageIndex;
			
			//페이지 처리와 검색을 수행시 상태값 체크값과 검색어 값을 수집하여 변수에 저장
			var jexAjax = jex.createAjaxUtil("srvc_0101_03_r001");   //PT_ACTION 웹 서비스 호출
			//가입일자, 상태, 검색대상
			input = {};
			input["SRCH_WD"] = $("#SRCH_WD").val();
			input["SRCH_CD"] = $("#SRCH_CD").val();
			//카테고리 
			input["END_DT"] = $("#END_DT").val().replace(/-/g, "");
			input["STR_DT"] = $("#STR_DT").val().replace(/-/g, "");
			
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
			jexAjax.execute(function(data) {
				var cnt = 0;
				data.REC.length == 0 ? cnt = 0 : cnt = data.REC[0].TOT_CNT;
				_paging.setTotDataSize(cnt);
				_paging.setPageNo(pageIndex);    	// 페이지 인덱스
				_paging.setPaging(data.REC);     	// 레코드 데이터 정보
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
					if(v.STTS == "1") {
						v.STTS = "정상";
					} else if(v.STTS == "9") {
						v.STTS = "해지";
					} else if(v.STTS == "2") {
						v.STTS = "신청대기";
					} else if(v.STTS == "3") {
						v.STTS = "승인대기";
					}
					if(v.USE_ATHT == "1") v.USE_ATHT = "관리자";
					else if(v.USE_ATHT == "2") v.USE_ATHT = "정보제공자";
					
					if(v.USER_GB == "1") v.USER_GB = "플랫폼";
					else if(v.USER_GB == "2") v.USER_GB = "정보제공자";
					
					sHtml += "<tr class='text-dot' trIdx=\""+i+"\">";
					sHtml += '	<td><div><span><input type="checkbox" name="chkOne" data-user_id="'+v.USER_ID+'"></span></div></td>';
					sHtml += 	view_stgup.makeTableTbody(v,i);
					sHtml += "</tr>";
				});	
				$(tbl_content).find("tbody").append(sHtml);
			}
		},
		setCalendar: function(){
			datePicker.setCalendar("#STR_DT");		
			$("#STR_DT").val(fintech.common.getDate("yyyy-mm-dd","M",-1)  );						// 조회기간 시작일
			datePicker.setCalendar("#END_DT");		
			$("#END_DT").val(fintech.common.getDate("yyyy-mm-dd"));
		}, 
		fn_regi : function(){
			smartOpenPop({href: "plfm_0101_02.act", width:792, height:500, scrolling:false, target:window});
		},
		fn_sttsEdit : function(data){
			var $form = $("<form method='post'></form>");
			$form.append("<input name='updateData'	value='" + data +"'>");
			smartOpenPop({href: "plfm_0101_03.act", width:500, height:180, scrolling:false, target:window, frm:$form});
		},
		fn_detail : function(data){
			var $form = $("<form method='post'></form>");
			$form.append("<input name='USER_ID'	value='" + data.USER_ID +"'>");
			smartOpenPop({href: "plfm_0101_02.act", width:792, height:500, scrolling:false, target:window, frm:$form});
		}
		
}
function __fn_init(){
	$("#plfm_0101_01").parents("div").addClass("on");
}