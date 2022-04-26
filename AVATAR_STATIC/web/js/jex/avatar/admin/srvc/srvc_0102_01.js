/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : srvc_0102_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/srvc
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200306154123, 김별
 * </pre>
 **/

$(function(){
	getDsdlCd("CTGR_CD","B2001");
	_thisPage.fn_init();
	$(".btn_search_tb").on("click", function(){
		_thisPage.fn_init();
	});
	$("#btnNew").on("click", function(){
		_thisPage.fn_regi();
	});
	$("#btnAdmit").on("click", function(){
		if($('input:checkbox[name="chkOne"]:checked').length>0){
			if(confirm("선택한 질의를 모두 승인하겠습니까?")){
				_thisPage.fn_admit();
        	} else {
        		$('#checkboxAll').attr('checked',false);
        		$('input:checkbox[name="chkOne"]').attr('checked',false);
        		return false;
        	}
    	} else {
    		alert("승인할 질의를 한 개 이상 선택하여 주십시오.");
    	}
	});
	$(document).on("click",".click_detail",function() {
		 var data;
		 data = {API_ID : $(this).data("api_id"), APP_ID : $(this).data("app_id")};
		 _thisPage.fn_detail(data);
	  });
	//전체 선택
	$("#checkboxAll").on("click",function(){
    	if($('#checkboxAll').is(":checked")){
    		$('input:checkbox[name="chkOne"]').attr('checked',true);
    	} else {
    		$('input:checkbox[name="chkOne"]').attr('checked',false);
    	}
    		
    });

});

var _thisPage = {
		fn_init : function(){
			_thisPage.fn_grid();
			_thisPage.fn_search();
		},
		fn_grid: function(){
			var list = [];
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CTGR_CD_NM",				VIEW_NM:"카테고리",			VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"API_ID",				VIEW_NM:"API ID",			VIEW_STYLE : "width=120px;"
				,	   ONCLICKYN:"Y", 
					   ONCLICK:"click_detail", 
					   ONCLICKDATA: "API_ID,APP_ID"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"QUES_CTT",				VIEW_NM:"질의명",			VIEW_STYLE : "width=400px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"STTS",					VIEW_NM:"상태",			VIEW_STYLE : "width=120px;"});
			list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"APP_NM",				VIEW_NM:"앱명",			VIEW_STYLE : "width=150px;"});
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
			var jexAjax = jex.createAjaxUtil("srvc_0102_01_r001");   //PT_ACTION 웹 서비스 호출
			//상태, 검색대상, 카테고리
			input = {};
			input["SRCH_WD"] = $("#SRCH_WD").val();
			//카테고리 
			input["CTGR_CD"] = $("#CTGR_CD").val();
			input["RSLT_CD"] = "1";
			
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
				_paging.setTotDataSize(dat.API_CNT); 		// 전체 데이터 건수
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
				var page_index = $(".pag_num>a[class='on']").text()-0;
				var num_row 	=  $(".btn_combo_down>#pageSize").text()-0;
				var sHtml = "";		
				
				$.each(rec, function(i, v) {
					if(v.STTS == "1") {
						v.STTS = "승인대기";
					} else if(v.STTS == "2") {
						v.STTS = "배포대기";
					} else if(v.STTS == "3") {
						v.STTS = "배포중";
					} else if(v.STTS == "4") {
						v.STTS = "배포중지";
					} else if(v.STTS == "5") {
						v.STTS = "반려";
					} else if(v.STTS == "9") {
						v.STTS = "삭제";
					} else if(v.STTS == "0") {
						v.STTS = "임시저장";
					}
					
					sHtml += "<tr class='text-dot' trIdx=\""+i+"\">";
					sHtml += '	<td><div><span><input type="checkbox" name="chkOne" data-api_id="'+v.API_ID+'" data-app_id="'+v.APP_ID+'"></span></div></td>';
					sHtml += view_stgup.makeTableTbody(v,i);
					sHtml += "</tr>";
				});	
				$(tbl_content).find("tbody").append(sHtml);
			}
		},
		fn_regi : function(){
			var $form = $("<form method='post'></form>");
			smartOpenPop({href: "srvc_0102_02.act", width:792, height:408, scrolling:false, target:window, frm:$form});
		},
		fn_detail : function(data){
			var $form = $("<form method='post'></form>");
			$form.append("<input name='APP_ID'       value='" + data.APP_ID +"'>");
			$form.append("<input name='API_ID'       value='" + data.API_ID +"'>");
			smartOpenPop({href: "srvc_0102_02.act", width:792, height:408, scrolling:false, target:window, frm:$form});
		},
		fn_admit : function(data){
			
			var checkList = $("#tbl_content").find("input:checkbox[name=chkOne]:checked").map(function(){
				var $this = $(this);
				
				return {
					APP_ID : $this.data("app_id"),
					API_ID : $this.data("api_id"),
					STTS : "3"
				}
			}).get();
			
			console.log(checkList);
			
			var jexAjax  = jex.createAjaxUtil('srvc_0102_01_u001');
			
			jexAjax.set("REC"        , checkList); // REC
			jexAjax.set("_LODING_BAR_YN_", "Y"                           ); // 로딩바 출력여부
			
			jexAjax.execute(function(dat) {
				if(dat.RSLT_CD=="0000"){
					alert("정상적으로 처리되었습니다.");
					$('input:checkbox[name="chkOne"]').attr('checked',false);
					$('#checkboxAll').attr('checked',false);
					_thisPage.fn_search();
				} 
			});
			
		}
		
}
function getDsdlCd(loct, grp_cd,item_cd, item_nm){
	var jexAjax = jex.createAjaxUtil("srvc_0103_01_r002");   //PT_ACTION 웹 서비스 호출
	jexAjax.set("DSDL_GRP_CD", grp_cd);
	jexAjax.set("DSDL_ITEM_CD", item_cd);
	jexAjax.set("DSDL_ITEM_NM", item_nm);
	jexAjax.execute(function(dat) {
		var html = "<option value=''>전체</option>";
		$.each(dat.REC, function(i, v) {
			html += "<option value="+v.DSDL_ITEM_CD+">"+v.DSDL_ITEM_NM+"</option>";
		});
		var location = "#"+loct+"";
		$(location).empty();
		$(location).append(html);
	});
}

function __fn_init(){
	$("#srvc_0102_01").parents("div").addClass("on");
}