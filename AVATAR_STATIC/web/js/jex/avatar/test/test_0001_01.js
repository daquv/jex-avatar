/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : test_0001_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/test
 * @author         : 신승환 (  )
 * @Description    : 
 * @History        : 20200115085653, 신승환
 * </pre>
 **/


var _thisPage = {
		 PAGE_NO : 1
		,PAGE_CNT : 4
}


new (Jex.extend({
    onload:function() {
        _this = this;
        
        //iWebAction("changeAppTitle",{"_title" : "거래내역 조회","_type" : "1"});
        
        listSet();
        
    }, event:function() {
        
    	//더보기
        this.addEvent('.btn_more', 'click', function(){
        	_thisPage.PAGE_NO = _thisPage.PAGE_NO+1;
        	listSet();
        });
    }
    
}))();

function listSet(){
	var jexAjax = jex.createAjaxUtil('test_0001_01_r001');
	jexAjax.set("PAGE_NO", _thisPage.PAGE_NO);
	jexAjax.set("PAGE_CNT", _thisPage.PAGE_CNT);
	jexAjax.execute(function(dat) {
		
		if(_thisPage.PAGE_NO == 1) {
			$(".card_list").empty();
		}
		
		$.each(dat.REC, function(idx, rec){ 
			var html = '';
			html += '<li>';
			html += '	<div class="card_list_box">';
			html += '		<h2 class="card_name">'+rec.DSDL_GRP_CD+'</h2>';
			html += '		<div class="card_info">';
			html += '			<p>'+rec.DSDL_GRP_NM+'</p>';
			html += '		</div>';
			html += '	</div>';
			html += '</li>';
			
			$(".card_list").append(html);
			$(".card_list").find("li:last").data("REC", rec);
			
		});
	});
}

// 상세페이지 화면 호출
function detailView(obj){

	console.log(obj);
	
//	location.href = "/.act?TRNS_YN="+$("#TRNS_YN").val();
	
//	var pageUrl = "test_0001_02.act?";
//	var pageParam = "CUST_NO="+$("#CUST_NO").val(); 

	//iWebAction("popup_webview",{_url:pageUrl+pageParam,"_zoom_yn" : "N"});
	/*
	var frm = document.getElementById("form1");
	window.open('','testDetail');
	frm.action = "test_0001_02.act";
	frm.target = "testDetail";
	frm.method = "post";
	frm.submit();
	*/
}

//뒤로가기
function fn_page_back(){
//	if($("#VIEW_TYP").val() == "ACCT"){
//    	location.href = "/.act?TRNS_YN="+$("#TRNS_YN").val();
//    }else{
//    	location.href = "/.act";
//    }
}
