/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : ques_0014_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/ques
 * @author         : 박지은 (  )
 * @Description    : 
 * @History        : 20210928135525, 박지은
 * </pre>
 **/
var _STR_IDX = 0;
var _PAGE_CNT = 15;
var isMore = true; 
var lastdate='';
var index = -1;
$(function(){
	_thisPage.onload();
	// html 클릭시 모든 레이어 닫기
	$(document).on("click", "html", function(e){
		var _target = $(e.target);
		$('.off').hide();
		$('._on').removeClass('_on');
		if($('.ques_Bx_cn').find(e.target).length>0){
			let _li = $(e.target).prop('tagName')==='LI'?$(e.target):$(e.target).closest('li');
			_li.find(".off").show();
			_li.addClass('_on');
		}
		
	});
	
	$(document).on("click", "ul li", function(){
		// 삭제모드로 변환 - 휴지통 아이콘 show
		$(this).find(".off").show();
		$(this).addClass('_on');
	});
	
	//휴지통 아이콘 click(삭제)
	$(document).on("click", ".off", function(){
		if(confirm("메모를 삭제하시겠습니까?")){
			let data = {};
			data.MEMO_DTM = $(this).data('memo_dtm');
			_thisPage.deleteMemo(data);
			$(this).closest('li').hide();
		}
	});

	// 스크롤 이동
    $(window).scroll(function(){
    	// 스크롤 맨밑으로 이동시 조회 
    	if (Math.floor($(window).scrollTop()) >= Math.floor($(document).height() - $(window).height())) {
			if(isMore == true){
				_STR_IDX = _STR_IDX+_PAGE_CNT;
    			_thisPage.searchData(isMore);
    		}
    	}
    }); 
})

var _thisPage = {
	onload : function(){
		iWebAction("changeTitle",{"_title" : "나의 음성 메모","_type" : "2"});
		
		_thisPage.searchData();
	}, 
	searchData : function(moreData){
		
		let appInfo = inteInfo["recog_data"]["appInfo"];
		var input = {};
		input["STR_IDX"] = _STR_IDX;
		input["PAGE_CNT"] = _PAGE_CNT;

		input["NE_DAY"] = appInfo["NE-DAY"];
		input["NE_B_YEAR"] = appInfo["NE-B-YEAR"];
		input["NE_B_MONTH"] = appInfo["NE-B-MONTH"];
		input["NE_B_DATE"] = appInfo["NE-B-DATE"];
		input["NE_DATEFROM"] = appInfo["NE-DATEFROM"];
		input["NE_DATETO"] = appInfo["NE-DATETO"];
		/*input["MEMO_CTT"] = appInfo["NE-MEMO-CTT"];*/
		
		avatar.common.callJexAjax("ques_0014_01_r001",input,_thisPage.fn_callback);
	},
	fn_callback : function(dat) {
		console.log(dat);
		// 최초 조회일때 메모 내역이 없는 경우 
		if(dat.REC.length === 0){
			isMore = false;
			if(_STR_IDX === 0){
				$(".ques_Bx").hide();
				$(".memoSaveBx").show();
			}
		}
		if(isMore){
			if(_STR_IDX === 0){
				$("#MEMO_CNT").text(dat.REC[0].MEMO_CNT);
				if(_APP_ID =="SERP") iWebAction("getStorage",{_key : "keyWebResultTTS_SERP", _call_back : "fn_getWebResultTTS"});
				else if(_APP_ID =="KTSERP") iWebAction("getStorage",{_key : "keyWebResultTTS_KTSERP", _call_back : "fn_getWebResultTTS"});
				else iWebAction("getStorage",{_key : "keyWebResultTTS", _call_back : "fn_getWebResultTTS"});
			}
			/* 날짜별 */
			var MEMO_DT = [];
			//var k = 0;
			MEMO_DT[0] = dat.REC[0].MEMO_DT;
			for(i=0; i<dat.REC.length-1 ; i++){
				if(dat.REC[i].MEMO_DT != dat.REC[i+1].MEMO_DT){
					MEMO_DT[i+1] = dat.REC[i+1].MEMO_DT;
				} else{
					MEMO_DT[i+1] = '';
				}
			}
			$.each(dat.REC, function(idx, rec){
				var tempHtml = '';
				var tempHtml2 = '';
				if(dat.REC[idx].MEMO_DT == MEMO_DT[idx] && lastdate != dat.REC[idx].MEMO_DT){
					tempHtml += '<dl>';
					tempHtml += '	<dt>';
					tempHtml += '		<div class="tit">'+ formatter.dateday(rec.MEMO_DT)+'</div>';
					tempHtml += '	</dt>';
					tempHtml += '	<dd>';
					tempHtml += '		<div class="ques_Bx_cn">';
					tempHtml += '			<ul>';
					tempHtml += '				<li>';
					tempHtml += '					<div class="left">';
					tempHtml += '						<p>'+avatar.common.null2void(rec.MEMO_CTT)+'</p>';
					tempHtml += '					</div>';
					tempHtml += '					<div class="ico_bank"><div class="right" style="top: -45px;z-index: 1000001;"><a class="off" style="display:none;" data-memo_dtm="'+avatar.common.null2void(rec.MEMO_DTM)+'"></a></div></div>';
					tempHtml += '				</li>';
					tempHtml += '			</ul>';
					tempHtml += '		</div>';
					tempHtml += '	</dd>';
					tempHtml += '</dl>';
					$(".ques_Bx_in").append(tempHtml);
					index++;
				}
				else if(dat.REC[idx].MEMO_DT != MEMO_DT[idx] || lastdate == dat.REC[idx].MEMO_DT){
					tempHtml2 += '				<li>';
					tempHtml2 += '					<div class="left">';
					tempHtml2 += '						<p>'+avatar.common.null2void(rec.MEMO_CTT)+'</p>';
					tempHtml2 += '					</div>';
					tempHtml2 += '					<div class="ico_bank"><div class="right" style="top: -45px;z-index: 1000001;"><a class="off" style="display:none;" data-memo_dtm="'+avatar.common.null2void(rec.MEMO_DTM)+'"></a></div></div>';
					tempHtml2 += '				</li>';
					$(".ques_Bx_cn ul:eq("+(index)+")").append(tempHtml2);
				}
				
			});
			for(i=MEMO_DT.length-1; i>0; i--){
				if(MEMO_DT[i] != ''){
					lastdate = MEMO_DT[i]
					break;
				}
			}
		}
	},
	deleteMemo : function(data){
		let input = {};
		
		input["MEMO_DTM"] = data.MEMO_DTM;
		var jexAjax  = jex.createAjaxUtil('ques_0014_01_d001');
		jexAjax.set(input);
		jexAjax.execute(function(dat) {
			if(dat.RSLT_CD==="0000"){
			} else {
				alert("처리 중 오류가 발생하였습니다.");
			}
		});
	}
}

function fn_getWebResultTTS(data){
	if(avatar.common.null2void(data)===""){
		if(_APP_ID == "SERP") iWebAction("setStorage",{"_key" : "keyWebResultTTS_SERP", "_value" : "Y"});
		else if(_APP_ID == "KTSERP") iWebAction("setStorage",{"_key" : "keyWebResultTTS_KTSERP", "_value" : "Y"});
		else iWebAction("setStorage",{"_key" : "keyWebResultTTS", "_value" : "Y"});
	}
	avatar.common.null2void(data)==""?data="Y":data=data;
	if(data == "Y"){
		iWebAction("webResultTTS",{"_data" : avatar.common.null2void($("#RESULT_TTS").text())});
	}
	
}

function fn_back(){
	iWebAction("closePopup",{_callback:"fn_popCallback_back"});
}