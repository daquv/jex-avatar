/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : bzaq_0001_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/bzaq
 * @author         : 김별 (  )
 * @Description    : 거래처 상세 조회
 * @History        : 20200211144539, 김별
 * </pre>
 **/
$(function(){
	iWebAction("changeTitle",{"_title" : "거래처 상세", "_type" : "2"});
	_thisPage.onload();
	
});

var _thisPage = {
		onload : function(){
			_thisPage.searchData();
		},
		searchData : function(){
			var input = {};
			input["BZAQ_NO"] = $("#BZAQ_NO").val();
			avatar.common.callJexAjax("bzaq_0001_02_r001", input, _thisPage.fn_callback, "true", "");
			
		},
		fn_callback : function(data){
			console.log(data);
			namehtml = '';
			namehtml += '<span class="elipsis">'+data.REC[0].BZAQ_NM+'</span>';
			$(".left .tit").html(namehtml);
			
			contenthtml = '';
			contenthtml +='<tr>';
			contenthtml +='	<th>대표이사</th>';
			contenthtml +='	<td>'+avatar.common.null2void(data.REC[0].RPPR_NM)+'</td>';
			contenthtml +='</tr>';
			contenthtml +='<tr>';
			contenthtml +='	<th>사업자번호</th>';
			contenthtml +='	<td>'+avatar.common.corpno_format(avatar.common.null2void(data.REC[0].BIZ_NO))+'</td>';
			contenthtml +='</tr>';
			contenthtml +='<tr>';
			contenthtml +='	<th>주소</th>';
			contenthtml +='	<td>'+avatar.common.null2void(data.REC[0].ADRS)+'</td>';
			contenthtml +='</tr>';
			contenthtml +='<tr>';
			contenthtml +='	<th>연락처</th>';
			contenthtml +='	<td>'+avatar.common.phoneFomatter(avatar.common.null2void(data.REC[0].TEL_NO))+'</td>';
			contenthtml +='</tr>';
			$(".list_dv_tbl tbody").html(contenthtml);
		},
		
}


function fn_back(){
	iWebAction("closePopup");
}