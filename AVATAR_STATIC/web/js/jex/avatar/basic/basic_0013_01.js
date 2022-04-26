/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : basic_0013_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/basic
 * @author         : 김별 (  )
 * @Description    : 
 * @History        : 20210730134419, 김별
 * </pre>
 **/

var pageno = 1;
var pagecnt = 30;
var isMore;
var lastdate='';
var index = -1;
$(function(){
	if(MENU_DV == "01"){
		iWebAction("changeTitle",{"_title" : "질문 모아보기","_type" : "2"});
	} else if(MENU_DV == "02"){
		iWebAction("changeTitle",{"_title" : "답변 받지 못한 질문","_type" : "2"});
	}
	_thisPage.onload();

	//질의 클릭 시 해당 질의로 이동
	$(document).on("click", ".ques_Bx_cn ul li", function(){
		if(MENU_DV == "01" && CLPH_NO === "01025999667"){
			//학습완료된 질의만 이동
			var INTE_INFO ="{'recog_txt':'\""+$(this).find("p").text()+"\"','recog_data' : {'Intent':'"+$(this).find("p").attr('intent')+"','appInfo' : "+$(this).find("p").attr('data-appInfo')+"} }" ;
			var INTE_INFO_create = '{"recog_txt":\"'+$(this).find("p").text()+'\","recog_data" : {"Intent":"'+$(this).find("p").attr('intent')+'","appInfo" : '+$(this).find("p").attr('data-appInfo').replace(/\'/g, '\"')+'} }';
			//encodeURIComponent(INTE_INFO);
			if($(this).find("p").attr('data-appInfo').indexOf("NE-COUNTERPARTNAME")>0){
				INTE_INFO = encodeURIComponent(INTE_INFO);
			}
			_thisPage.fn_create(INTE_INFO_create);
			
			var url = "ques_comm_01.act?INTE_INFO="+INTE_INFO;
			iWebAction("openPopup",{"_url" : url});
		}
	});
	
	$(window).scroll(function() {
	    if (Math.floor($(window).scrollTop()) >= Math.floor($(document).height() - $(window).height())) {
	    	if(isMore == true){
				_thisPage.searchData(true);
			}
	    }
	  });
});

var _thisPage = {
		onload : function(){
			_thisPage.searchData();
			
		},
		searchData : function(moreData){
			if(moreData){
				pageno = pageno + 1;
			}
			var input = {};
			input["PAGE_NO"]	= pageno;
			input["PAGE_CNT"]	= pagecnt;
			input["MENU_DV"]	= MENU_DV;
			avatar.common.callJexAjax("basic_0013_01_r001", input, _thisPage.fn_callback, "true", "");
			
		},
		fn_create : function(INTE_INFO){
			var jexAjax = jex.createAjaxUtil("ques_comm_01_u001"); // PT_ACTION
			jexAjax.set("VOIC_DATA", INTE_INFO);
			jexAjax.execute(function(data) {
			});
		},
		fn_callback : function(dat){
			if(avatar.common.null2void(dat.REC).length == 0){
				isMore = false;
			} else isMore = true;
			
			/* 날짜별 */
			var QUES_DT = [];
			var k = 0;
			QUES_DT[0] = dat.REC[0].QUES_DT;
			for(i=0; i<dat.REC.length-1 ; i++){
				if(dat.REC[i].QUES_DT != dat.REC[i+1].QUES_DT){
					QUES_DT[i+1] = dat.REC[i+1].QUES_DT;
				} else{
					QUES_DT[i+1] = '';
				}
			}
			
			$.each(dat.REC, function(idx, rec){
				var tempHtml = '';
				var tempHtml2 = '';	
				var appInfo = '';
				//인텐트 없을 경우 voic_data가 들어오지 않음
				if(rec.VOIC_DATA && MENU_DV == "01"){
					appInfo = JSON.stringify(JSON.parse(rec.VOIC_DATA).recog_data.appInfo);
					appInfo=appInfo.replace(/\"/g, '\'');
				}
				if(dat.REC[idx].QUES_DT == QUES_DT[idx] && lastdate != dat.REC[idx].QUES_DT){
					tempHtml += '<dl>';
					tempHtml += '	<dt>';
					tempHtml += '		<div class="tit">'+avatar.common.date_format2(rec.QUES_DT)+'</div>';
					tempHtml += '	</dt>';
					tempHtml += '	<dd>';
					tempHtml += '		<div class="ques_Bx_cn">';
					tempHtml += '			<ul>';
					tempHtml += '				<li>';
					tempHtml += '					<div class="left">';
					tempHtml += `						<p intent="${rec.INTE_CD}" data-appInfo="${appInfo}">${rec.QUES_CTT}</p>`;
					tempHtml += '					</div>';
					if(MENU_DV === "02" && rec.LRN_STTS === "1"){
						tempHtml += '					<div class="right leanCompt">';
						tempHtml += '						<span>학습완료</span>';
						tempHtml += '					</div>';
					}
					tempHtml += '				</li>';
					tempHtml += '			</ul>';
					tempHtml += '		</div>';
					tempHtml += '	</dd>';
					tempHtml += '</dl>';
					
					$(".ques_Bx_in").append(tempHtml);
					index++;
				}
				else if(dat.REC[idx].QUES_DT != QUES_DT[idx] || lastdate == dat.REC[idx].QUES_DT){
					tempHtml2 += '				<li>';
					tempHtml2 += '					<div class="left">';
					tempHtml2 += `						<p intent="${rec.INTE_CD}" data-appInfo="${appInfo}">${rec.QUES_CTT}</p>`;
					tempHtml2 += '					</div>';
					if(MENU_DV === "02" && rec.LRN_STTS === "1"){
						tempHtml2 += '					<div class="right leanCompt">';
						tempHtml2 += '						<span>학습완료</span>';
						tempHtml2 += '					</div>';
					}

					tempHtml2 += '				</li>';
					$(".ques_Bx_cn ul:eq("+(index)+")").append(tempHtml2);
				}
				
			});
				for(i=QUES_DT.length-1; i>0; i--){
			        if(QUES_DT[i] != ''){
			        	lastdate = QUES_DT[i]
			            break;
			        }
			    }
			
		
		},
}

/* Webaction callbackFun */
function fn_back(){
	//history.back();
	iWebAction("closePopup");
	
}

function fn_cancel(){
	$(".m_cont").css("display", "block");
}