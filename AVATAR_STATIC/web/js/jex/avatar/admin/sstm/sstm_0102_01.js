/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : sstm_0102_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/sstm
 * @author         : 김태훈 (  )
 * @Description    : 어드민 배치서비스관리 메인
 * @History        : 20200306143444, 김태훈
 * </pre>
 **/

let _pageNo = "";

let _thisPage = {
	fn_init : function(){
		_thisPage.fn_grid();
		_thisPage.fn_search();
	}
	,fn_search : function(pageNo){
		const pageIndex = fintech.common.null2void(pageNo, "1");
		_pageNo = pageIndex;
		
		//페이지 처리와 검색을 수행시 상태값 체크값과 검색어 값을 수집하여 변수에 저장
		const DSDL_KND_CD = $("#select_01 option:selected").val();
		
		const jexAjax  = jex.createAjaxUtil('sstm_0102_01_r001');
		jexAjax.set("DSDL_KND_CD"    , DSDL_KND_CD); 			// 게시판 번호
		
		jexAjax.set("PAGE_NO"        , pageIndex); 				// 페이지 번호
		jexAjax.set("PAGE_SIZE"      , _paging.getPageSz());	// 페이지 크기
		
		jexAjax.set("_LODING_BAR_YN_", "Y"); // 로딩바 출력여부
		jexAjax.execute(function(dat) {
			
			let cnt = '';
			cnt = dat.CNT; 
			_paging.setTotDataSize(cnt); 		// 전체 데이터 건수
			_paging.setPageNo(pageIndex);    	// 페이지 인덱스
			_paging.setPaging(dat.REC);     	// 레코드 데이터 정보
			 // 조회조건을 바꾸고 페이징 조회 호출하는 것 방지
			_paging.setParam(jexAjax, pageIndex);
			// $('input:checkbox[name="dsdlAllItem"]').attr('checked',false);
			
		});
	}
	,cb_search : function(tbl, rec){
		const tbl_title = $("#tbl_title");
		const tbl_content = $("#tbl_content");
		
		$(tbl_content).find("colgroup").remove();
		$(tbl_title).find("colgroup").clone().prependTo($(tbl_content));
		$(tbl_content).find("tfoot").remove();
		$(tbl_content).find("tbody").find("tr").remove();
		
		if(rec.length == 0) {
			let sHtml = "";		
			sHtml += '<tfoot>';
			sHtml += '    <tr class="no_hover" style="display:table-row;">';
			sHtml += '        <td colspan="'+$("#tbl_content").find("colgroup").find("col").length+'" class="no_info"><div>내용이 없습니다.</div></td>';
			sHtml += '    </tr>';
			sHtml += '</tfoot>';
			$(tbl_content).prepend(sHtml);
		}
		else{
			let sHtml = "";		
			$.each(rec, function(i, v) {
				let dsdl = "";
				if(v.DSDL_KND_CD == "S"){
					dsdl = "시스템";
				}else if(v.DSDL_KND_CD == "U"){
					dsdl = "사용자";
				}else if(v.DSDL_KND_CD == "B"){
					dsdl = "업무"
				}
				
				v.DSDL_KND_CD = dsdl;
				
				var acvt_stts = "";
				
				if(v.ACVT_STTS == "Y"){
	    			acvt_stts = "사용 ("+v.ITEM_AMT+")";
				} else {
	    			acvt_stts = "<a href=\"javascript:void(0);\">사용안함 ("+v.ITEM_AMT+")</a>";
	    		}
				v.ACVT_STTS_NM = acvt_stts ;
				
				sHtml += "<tr class='text-dot' trIdx=\""+i+"\">";
				sHtml += view_stgup.makeTableTbody(v,i);
				sHtml += "</tr>";
			});	
			$(tbl_content).find("tbody").append(sHtml);
		}
	}
	,fn_grid : function(){
		let list = [];
		list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"DSDL_KND_CD",     VIEW_NM:"코드종류",    VIEW_STYLE : "width=50px; text-align=center;"});
		
		list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"DSDL_GRP_CD",     VIEW_NM:"그룹코드",     VIEW_STYLE : "width=90px;",ONCLICKYN:"Y", ONCLICK:"click_code",
				ONCLICKDATA:"DSDL_GRP_CD,DSDL_GRP_NM,DSDL_KND_CD,OTPT_SQNC,RMRK,ACVT_STTS"});
		list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"DSDL_GRP_NM",     VIEW_NM:"그룹코드명",     VIEW_STYLE : "width=100px;"});
		list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"ACVT_STTS_NM", VIEW_NM:"세부코드",     VIEW_STYLE : "width=100px;", ONCLICKYN:"Y", ONCLICK:"click_stts",
				ONCLICKDATA:"DSDL_GRP_CD,DSDL_GRP_NM,ITEM_AMT"});
		list.push({DISPLAY_YN:"Y", MDTY_YN:"N", USE_YN:"Y", VIEW_ID:"RMRK",   VIEW_NM:"설명",       VIEW_STYLE : "width=120px;"});
		
		view_stgup.fn_search(true, "TABLE", list);
		view_stgup.makeTable("tbl_title", false, _thisPage.fn_search, false, false);
		
		_paging = $("#tbl_paging").tablePaging("tbl1", _thisPage.fn_search, _thisPage.cb_search, "1", "15", "Y", null);
		_paging.initPage();

	}
	// Update Group
	,fn_addGrpCd : function(form, id, data){
		var $form = $("<form method='post'></form>");
		$form.append("<input name='DSDL_GRP_NM' value='"+data.DSDL_GRP_NM+"'>");
		$form.append("<input name='DSDL_GRP_CD' value='"+data.DSDL_GRP_CD+"'>");
		$form.append("<input name='DSDL_KND_CD' value='"+data.DSDL_KND_CD+"'>");
		$form.append("<input name='OTPT_SQNC' 	value='"+data.OTPT_SQNC+"'>");
		$form.append("<input name='RMRK' 		value='"+encodeURIComponent(data.RMRK)+"'>");
		$form.append("<input name='ACVT_STTS' 	value='"+data.ACVT_STTS+"'>");
		$form.append("<input name='MOD' 		value='Y'>");
		// change from dsdl_0001_03 to sstm_0103_02
		smartOpenPop({href: "sstm_0102_02.act", width:800, height:385, scrolling:false, target:window, frm:$form});
	}
	,cb_addGrpCd : function(rec){
		_paging.initPage();
		_thisPage.fn_search();
	}
	// Add_New and Update Group Item
	,fn_addDtlCd : function(form, id, data){ // Layer Management
	    var $form = $("<form method='post'></form>");
		$form.append("<input name='DSDL_GRP_CD' value='"+data.DSDL_GRP_CD+"'>");
		$form.append("<input name='DSDL_GRP_NM' value='"+encodeURI(data.DSDL_GRP_NM)+"'>");
		// dsdl_0002_01.act change to sstm_0103_03.act
		smartOpenPop({href: "sstm_0102_03.act", width:838, height:660, scrolling:false, target:window, frm:$form});
	}
	,cb_addDtlCd : function(rec){
		_paging.initPage();
		_thisPage.fn_search();
		
	}, fn_layerInsert: function(form, id){
		let $form = $("<form></form>");
		$form.attr('method', 'post');
		$form.append($('<input/>', {name:'MOD', value:'N'}));
		/*
	    var $form = $("<form method='post'></form>");
	    $form.append("<input name='MOD' value='N'>");
	    */// change from dsdl_0001_02 => sstm_0103_04
		smartOpenPop({href: "sstm_0102_02.act", width:838, height:376, scrolling:false, target:window, frm:$form});
		
	}, cb_layerInsert: function(rec){
		_paging.initPage();
		_thisPage.fn_search();
		
	},test: function(){
		alert(" Welcome to test parent function()");
	}
};

function fn_allCallbackFnc(){
	_paging.initPage();
	_thisPage.fn_search();
}
// ONLOAD
$(function(){
	_thisPage.fn_init();
	
	$("#tbl_content").on("click", ".click_code", function(){
		var datelist = {
    		DSDL_GRP_CD : $(this).attr("data-DSDL_GRP_CD"),
    		DSDL_GRP_NM : $(this).attr("data-DSDL_GRP_NM"),
    		DSDL_KND_CD : $(this).attr("data-DSDL_KND_CD"),
    		OTPT_SQNC 	: $(this).attr("data-OTPT_SQNC"),
    		RMRK 		: $(this).attr("data-RMRK"),
    		ACVT_STTS 	: $(this).attr("data-ACVT_STTS")
		};
		
		_thisPage.fn_addGrpCd("form1", "click_code", datelist);
	});
	
	$("#tbl_content").on("click", ".click_stts", function(){
		var datelist = {
    		DSDL_GRP_CD : $(this).attr("data-DSDL_GRP_CD"),
    		DSDL_GRP_NM : $(this).attr("data-DSDL_GRP_NM"),
    		ITEM_AMT 	: $(this).attr("data-ITEM_AMT")
		};
  
    	_thisPage.fn_addDtlCd("form1", "click_stts", datelist);
	});
	
	$("#btnAddGroup").on("click", function(){
		_thisPage.fn_layerInsert("form1", "btnAddGroup");
	});
	
	$(".btn_search_tb").on("click", function(){
		_thisPage.fn_init();
		
	});
});

function __fn_init(){
	$("#sstm_0102_01").parents("div").addClass("on");
}
