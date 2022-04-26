/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : srvc_0103_03.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/srvc
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20200603172827, 김별
 * </pre>
 **/
getDsdlCd("CTGR_CD","B2001");
var _thisPage = {
	onload : function(){
		_thisPage.fn_makeTable();
		_thisPage.fn_search();
	},
	fn_makeTable : function(){
		var list = [];
		list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"NO"			, VIEW_NM:"NO" 		, VIEW_STYLE:"width=35px;"});
		list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"CTGR_CD"		, VIEW_NM:"카테고리" 	, VIEW_STYLE:"width=100px;"});
		list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"API_ID"		, VIEW_NM:"API ID"	, VIEW_STYLE:"width=110px;"});
		list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"QUES_CTT" 		, VIEW_NM:"질의명"	, VIEW_STYLE:"width=180px;"});
		list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"STTS" 			, VIEW_NM:"상태"		, VIEW_STYLE:"width=100px;"});
		list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"APP_ID"  		, VIEW_NM:"정보공급처"	, VIEW_STYLE:"width=100px;"});
		list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_NM:""});
		view_stgup.fn_search(true, "TABLE", list);
		view_stgup.makeTable("tbl_title", false, _thisPage.fn_search, true, false);
		_paging = $("#tbl_paging").tablePaging("tbl1", _thisPage.fn_search, _thisPage.cb_search, "1", "7", "Y", null);
		_paging.initPage();
	},
	fn_search : function(pageno){
		var pageIndex = fintech.common.null2void(pageno, "1");
		_pageNo = pageIndex;
		
		var input = {};
		input["CTGR_CD"]  		= $("#CTGR_CD").val();		//검색값
		input["PAGE_NO"] = pageIndex;
		input["PAGE_CNT"] = _paging.getPageSz();
		var jexAjax = jex.createAjaxUtil("srvc_0103_03_r001"); // PT_ACTION
		jexAjax.set(input);
		jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
		jexAjax.execute(function(data) {
			console.log(data.API_CNT);
			_paging.setTotDataSize(data.API_CNT);
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
				v.NO = (i+1)+ ((num_row * page_index) - num_row);
				if(v.STTS == "1") v.STTS ="승인대기";
				else if(v.STTS == "2") v.STTS ="배포대기";
				else if(v.STTS == "3") v.STTS ="배포중";
				else if(v.STTS == "4") v.STTS ="배포중지";
				else if(v.STTS == "5") v.STTS ="반려";
				else if(v.STTS == "9") v.STTS ="삭제";
				else if(v.STTS == "0") v.STTS ="임시저장";
				
				
				sHtml += '<tr>';
				sHtml += '	<td><div><span><input type="radio" name="apiChk" data-api_id="'+v.API_ID+'" data-app_id="'+v.APP_ID+'" data-ques_ctt="'+v.QUES_CTT+'"></span></div></td>';
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
	fn_save : function(apiVal, appVal, quesVal){
		var input = {};
		input["API_ID"]		= apiVal;
		input["APP_ID"]		= appVal;
		input["QUES_CTT"]	= quesVal;
		parent.smartClosePop("_apiPage.fn_searchData",input);
	},
}
$(function(){
	_thisPage.onload();
	
	$(".popupClose").on("click", function(){
		_thisPage.fn_close();
	});
	$(".cmdSearch").on("click", function(){
		_thisPage.fn_search();
	})
	
	$('.cmdSave').on("click", function () {
		var apiVal = $('input[name="apiChk"]:checked').data("api_id");
		var appVal = $('input[name="apiChk"]:checked').data("app_id");
		var quesVal = $('input[name="apiChk"]:checked').data("ques_ctt");
		_thisPage.fn_save(apiVal, appVal, quesVal);
	});
	
	$('.cmdDelete').on("click", function () {
		_thisPage.fn_save('', '', '');
	});
});

function getDsdlCd(loct, grp_cd, item_cd, item_nm){
	var jexAjax = jex.createAjaxUtil("srvc_0103_01_r002");   //PT_ACTION 웹 서비스 호출
	jexAjax.set("DSDL_GRP_CD", grp_cd);
	jexAjax.set("DSDL_ITEM_CD", item_cd);
	jexAjax.set("DSDL_ITEM_NM", item_nm);
	jexAjax.execute(function(dat) {
		var html = "<option value=''>선택하세요</option>";
		$.each(dat.REC, function(i, v) {
			html += "<option value="+v.DSDL_ITEM_CD+">"+v.DSDL_ITEM_NM+"</option>";
		});
		var location = "#"+loct+"";
		$(location).append(html);
	});
}