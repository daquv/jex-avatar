/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : srvc_0101_03.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/srvc
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200708105526, 김별
 * </pre>
 **/
var _thisPage = {
	onload : function(){
		_thisPage.fn_makeTable();
		_thisPage.fn_search();
	},
	fn_makeTable : function(){
		var list = [];
		list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_CLASS:"USER_ID" , VIEW_ID:"USER_ID"		, VIEW_NM:"아이디" 		, VIEW_STYLE:"width=150px;"});
		list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_CLASS:"USER_NM" , VIEW_ID:"USER_NM"		, VIEW_NM:"이름" 			, VIEW_STYLE:"width=80px;"});
		list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_CLASS:"CLPH_NO" , VIEW_ID:"CLPH_NO"		, VIEW_NM:"휴대폰번호"		, VIEW_STYLE:"width=150px;"});
		list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_CLASS:"TEL_NO"  , VIEW_ID:"TEL_NO" 		, VIEW_NM:"전화번호"		, VIEW_STYLE:"width=150px;"});
		list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_CLASS:"BSNN_NM" , VIEW_ID:"BSNN_NM" 		, VIEW_NM:"회사명"		, VIEW_STYLE:"width=80px;"});
		list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_NM:""});
		view_stgup.fn_search(true, "TABLE", list);
		view_stgup.makeTable("tbl_title", true, _thisPage.fn_search, false, false);
		_paging = $("#tbl_paging").tablePaging("tbl1", _thisPage.fn_search, _thisPage.cb_search, "1", "7", "Y", null);
		_paging.initPage();
	},
	fn_search : function(pageno){
		var pageIndex = fintech.common.null2void(pageno, "1");
		_pageNo = pageIndex;
		
		var input = {};
		input["SRCH_WD"]  		= $("#SRCH_WD").val();		//검색값
		input["SRCH_CD"]  		= "0";		//검색값
		input["PAGE_NO"] = pageIndex;
		input["PAGE_CNT"] = _paging.getPageSz();
		var jexAjax = jex.createAjaxUtil("srvc_0101_03_r001"); // PT_ACTION
		jexAjax.set(input);
		jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
		jexAjax.execute(function(data) {
			_paging.setTotDataSize(data.TOT_CNT);
			_paging.setPageNo(pageIndex);   
			_paging.setPaging(data.REC);     
			
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
		} else {
			var page_index = $(".pag_num>a[class='on']").text()-0;
			var num_row 	=  $(".btn_combo_down>#pageSize").text()-0;
			var sHtml = "";		
			$.each(rec, function(i, v) {
				sHtml += '<tr>';
				sHtml += '	<td><div><span><input type="checkbox" name="chkOne" data-user_id="'+v.USER_ID+'" data-biz_no="'+v.BIZ_NO+'"></span></div></td>';
				sHtml += 		view_stgup.makeTableTbody(v,i);
				sHtml += '	<td><div></div></td>'
				sHtml += '</tr>';
			});
			$(tbl_content).find("tbody").append(sHtml);
		}
	},
	fn_close : function(){
		parent.smartClosePop();
	},
	fn_save : function(jsonArr){
		parent.smartClosePop("_thisPage.fn_setChrg",jsonArr);
	},
}
$(function(){
	_thisPage.onload();
	
	$(".popupClose").on("click", function(){
		_thisPage.fn_close();
	});
	$(".cmdSearch").on("click", function(){
		_thisPage.fn_search();
	});
	$("#checkboxAll").on("click",function(){
    	if($('#checkboxAll').is(":checked")){
    		$('input:checkbox[name="chkOne"]').attr('checked',true);
    	} else {
    		$('input:checkbox[name="chkOne"]').attr('checked',false);
    	}
    		
    });
	$('.cmdSave').on("click", function () {
		var jsonArr = new Array();
		$('input[name="chkOne"]:checked').each(function(i, v) {
			var input = {};
			$(v).closest("tr").find("td").each(function(idx, item) {
				if (fintech.common.null2void($(item).attr("class")) != "")
					input[$(item).attr("class")] = $(item).find("span").text();
			});
			input["BIZ_NO"] = $(v).data("biz_no");
			jsonArr.push(input);
		});
		_thisPage.fn_save(jsonArr);
	});

});
