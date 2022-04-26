/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : card_0007_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/card
 * @author         : 김태훈 (  )
 * @Description    : 카드매입관리-카드정보화면
 * @History        : 20200128155853, 김태훈
 * </pre>
 **/
$(function(){
	_thisPage.onload();
	//카드 상세 클릭
	$(document).on("click","li[name=CARD]",function(){
		var tmp = $(this).data("tmp");
		tmp = decodeURIComponent(tmp);
		tmp = avatar.common.null2void(tmp)==""?"":JSON.parse(tmp);
		var input = {};
		input["BANK_NM"]			=tmp.BANK_NM;
		input["BANK_CD"]			=tmp.BANK_CD.replace("30000", "");
		input["BANK_GB"]			=tmp.BANK_GB;
		input["CARD_NICK_NM"]		=tmp.CARD_NICK_NM;
		input["CARD_RPSN_INFM"]		=tmp.CARD_RPSN_INFM;
		input["CARD_NO"]			=tmp.CARD_NO;
		input["WEB_ID"]				=tmp.WEB_ID;
		avatar.common.pageMove("card_0008_01.act",input);
	});
	//확인
	$("#a_enter").on("click",function(){
		var $temp = $(this).find('div:eq(0)');
		var url = "card_0005_02.act?CARD_CD="+$("#BANK_CD").val()+"&CARD_NM="+$("#BANK_NM").val();
		iWebAction("openPopup",{_url:url});
	});
});
var _thisPage = {
		onload : function (){
			iWebAction("changeTitle",{"_title" : "카드매입 관리","_type" : "2"});
			_thisPage.searchList();
		},
		searchList : function(){
			var input = {};
			input["BANK_CD"]="30000"+$("#BANK_CD").val();
			avatar.common.callJexAjax("card_0007_01_r001",input,_thisPage.searchListCallback);
		},
		searchListCallback : function(data){
			if(avatar.common.null2void(data.RSLT_CD)=="9999"){
				alert(data.RSLT_MSG);
				return;
			}
			//계좌 목록
			if(data.CARD_REC.length>0){
				var cardHtml = '';
				$.each(data.CARD_REC,function(i,v){
					if(i == 0){
						cardHtml += '<li class="first" data-tmp='+encodeURIComponent(JSON.stringify(v))+' name="CARD">';
					}else{
						cardHtml += '<li data-tmp='+encodeURIComponent(JSON.stringify(v))+' name="CARD">';	
					}
					cardHtml +='	<div class="left">';
					cardHtml +='		<div class="acc_tit">';
					cardHtml +=avatar.common.null2void(v.BANK_NM)+'(기업)';
					if(avatar.common.null2void(v.ERR_STTS) == "Y"){
						cardHtml +='			<span class="cntalign">';
						cardHtml +='				<a class="btn_t01 on">조회실패</a>';
						cardHtml +='			</span>';
					}
					cardHtml +='		</div>';
					cardHtml +='		<div class="acc_txt">' + avatar.common.null2void(v.CARD_RPSN_INFM)+'</div>';
					cardHtml +='	</div>';
					cardHtml +='	<div class="btn"><a class="btn_arr"></a></div>';
					cardHtml +='</li>';
				});
				$("#ul_card").html(cardHtml);
			}
		}
}

function fn_back(){
	iWebAction("closePopup");
}
function fn_popCallback(){
	iWebAction("closePopup",{_callback:"fn_popCallback"});
}