/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : snss_0002_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/snss
 * @author         : 박지은 (  )
 * @Description    : 온라인 매출 쇼핑몰 계정
 * @History        : 20210722085521, 박지은
 * </pre>
 **/
$(function(){
	_thisPage.onload();
	
	// 연결하기 버튼
	$("#reg_btn").on("click",function(){
		_thisPage.chkVal();
	});
	
	// 확인버튼
	$("#confirm_btn").on("click",function(){
		fn_back();
	});
	
	// 삭제
	$("#del_btn").on("click",function(){
		fn_deleteSnss();
	});
	
	// 아이디 이벤트
	$("#web_id").on("keyup", function(e) {
		if(e.keyCode == 13){
			$("#inp_pass").focus().click();
		}
	});
	
	// 비밀번호 클릭
	$("#web_pwd").on("click",function(){
		// 비밀번호 입력 액션 호출
		iWebAction("secureKeypad",{
			   _menu_id: ""
			  ,_type:"2"
			  ,_title:"온라인 매출 연결하기"
		   	  ,_callback:"callbackFunc"
		   	  ,_desc:[$("#shop_nm").val()+" 비밀번호를 입력하세요."]
		      ,_data:{
		    	   _min_length:"5"  
				  ,_max_length :"30"
		      }
		});
	});
});

var _thisInfm = {WEB_ID:"",WEB_PWD:"",PAGE_NO:""};
var _thisPage = {
		onload : function(){
			_thisPage.searchData();
		},
		searchData : function(){
			var input = {};
			input["SHOP_CD"]	=$("#shop_cd").val();
			input["SUB_SHOP_CD"]=$("#sub_shop_cd").val();
			avatar.common.callJexAjax("snss_0002_01_r001",input,_thisPage.searchDataCallback, "", "c");
		},
		searchDataCallback : function(data){
			iWebAction("changeTitle",{"_title" : "온라인 매출 연결하기","_type" : "2"});
			_thisInfm.STTS = avatar.common.null2void(data.STTS);
			if(_thisInfm.STTS == ""){
				// 등록 정보 없음
				_thisInfm.PAGE_NO = "0";
			}else if(_thisInfm.STTS == "9"){
				// 해지
				_thisInfm.PAGE_NO = "1";
			}else{
				// 등록된 계정정보
				_thisInfm.PAGE_NO = "1";
				_thisInfm.WEB_ID = data.WEB_ID;
				$("#web_id").val(data.WEB_ID);
				$("#web_id").attr("readonly",true).attr("disabled",true);
				$("#web_id").parent().addClass("disabled");
				var tmp_pwd = "";
				for(var i=0; i<data.WEB_PWD.length; i++){
					tmp_pwd += "0";
				}
				$("#web_pwd").val(tmp_pwd);
				fn_setBtn();
			}
		},
		//유효값 체크
		chkVal : function(){
			var web_id = $("#web_id").val();
			var web_pwd = $("#web_pwd").val();
			var page_no = _thisInfm.PAGE_NO;

			if(web_id.length==0){
				$(".toast_pop").find('span').text("아이디를 입력해주세요.");
				$(".toast_pop").css("display", "block");
				$(".toast_pop").fadeOut(5000);
				return false;
			}
			/*
			else if(web_id.length < 5 || web_id.length > 20){
				$(".toast_pop").find('span').text("아이디는 5자리~20자리 입니다.");
				$(".toast_pop").css("display", "block");
				$(".toast_pop").fadeOut(5000);
				return false;
			}
			*/
			if(web_pwd.length==0){
				$(".toast_pop").find('span').text("비밀번호를 입력해주세요.");
				$(".toast_pop").css("display", "block");
				$(".toast_pop").fadeOut(5000);
				return false;
			}
			/*
			else if(web_pwd.length < 8 || web_pwd.length > 15){
				$(".toast_pop").find('span').text("비밀번호는 8자리~15자리 입니다.");
				$(".toast_pop").css("display", "block");
				$(".toast_pop").fadeOut(5000);
				return false;
			}
			*/
			
			// 0:신규, 1:수정
			if(page_no=="0"){
				_thisPage.regSnss(web_id,_thisInfm.WEB_PWD);
			} else {
				_thisPage.modSnss(web_id, web_pwd, _thisInfm.WEB_PWD);
			}
		},
		//등록
		regSnss : function(web_id,web_pw){
			var input = {};
			input["SHOP_CD"]	= $("#shop_cd").val();
			input["SUB_SHOP_CD"]= $("#sub_shop_cd").val();
			input["WEB_ID"]		= web_id;
			input["WEB_PWD"]	= web_pw;
			iWebAction("showIndicator");
			avatar.common.callJexAjax("snss_0002_01_c001", input, _thisPage.regSnssCallback, "", "c");
		},
		//등록 후 콜백
		regSnssCallback : function(data){
			iWebAction("hideIndicator");
			
			//완료화면으로 이동처리
			var pageUrl = "snss_0003_01.act?";
			var pageParam = "RSLT_CD="+data.RSLT_CD;
			pageParam += "&RSLT_MSG="+data.RSLT_MSG;
			pageParam += "&SHOP_CD="+$("#shop_cd").val();
			pageParam += "&SUB_SHOP_CD="+$("#sub_shop_cd").val();
			pageParam += "&SHOP_NM="+$("#shop_nm").val();
			iWebAction("openPopup",{"_url":pageUrl, "_param" : pageParam});
			
			//var url = "snss_0003_01.act?RSLT_CD="+data.RSLT_CD+"&RSLT_MSG="+data.RSLT_MSG;
			//iWebAction("openPopup",{_url:url});
		},
		//수정
		modSnss :function(web_id, web_pwd, web_pwd_h){
			var input = {};
			input["SHOP_CD"]		= $("#shop_cd").val();
			input["SUB_SHOP_CD"]	= $("#sub_shop_cd").val();
			input["WEB_ID"]			= web_id;
			input["WEB_PWD"]		= web_pwd;
			input["WEB_PWD_CHK"]	= web_pwd_h;
			input["STTS"]			= _thisInfm.STTS;
			iWebAction("showIndicator");
			var callbackfn = _thisInfm.PAGE_NO="1"?_thisPage.regSnssCallback:_thisPage.modSnssCallback;
			avatar.common.callJexAjax("snss_0002_01_u001", input, callbackfn, "", "c");
		},
		//수정 콜백
		modSnssCallback : function(data){
			iWebAction("hideIndicator");
			var input = {};
			input["RSLT_CD"]	= avatar.common.null2void(data.RSLT_CD);
			input["RSLT_MSG"]	= avatar.common.null2void(data.RSLT_MSG);
			if(data.RSLT_CD == "00000000"){// 성공
				fn_successSnss();
			}else{
				fn_failSnss(data.RSLT_CD,data.RSLT_MSG);
			}
		},
		//삭제
		deleteSnss :function(){
			var input = {};
			input["SHOP_CD"]	= $("#shop_cd").val();
			input["SUB_SHOP_CD"]= $("#sub_shop_cd").val();
			input["WEB_ID"]		= _thisInfm.WEB_ID;
			avatar.common.callJexAjax("snss_0002_01_d001", input, _thisPage.deleteSnssCallback, "", "c");
		},
		//삭제 콜백 함수
		deleteSnssCallback : function(data){
			fn_removeModal();
			if(data.RSLT_CD == "00000000"){// 성공
				$(".toast_pop").find('span').text("삭제되었습니다.");
				$('.toast_pop').css('display', 'block');
				setTimeout(function(){
					//삭제 처리 후 데이터 가져오기 화면으로 이동
					iWebAction("closePopup",{_callback:"fn_popCallback"});
				}, 2000);	
			}
			iWebAction("hideIndicator");
		}
}

// 조회 결과에 따른 버튼 제어
function fn_setBtn(){
	$(".btn_fix_botm").eq(0).hide();
	$(".btn_fix_botm").eq(1).show();
}

//비밀번호 입력 완료 후 콜백함수
function callbackFunc(backData){
	var JData = JSON.parse(backData);
	var JDataPwd1 = JData._pwd;  
	var hPWD = JDataPwd1.encrypt_data;
	var PWD = avatar.common.gapReturn(JDataPwd1.length);
	_thisInfm.WEB_PWD=hPWD;
	$('#web_pwd').val(PWD);
	
	var page_no = _thisInfm.PAGE_NO;
	// 0:신규, 1:수정
	if(page_no=="1"){
		_thisPage.chkVal();
	}else{
		$("#reg_btn").click();
	}
}

//삭제 모달 생성
function fn_deleteSnss(){
	var modalHtml='';
	modalHtml +='<div class="modaloverlay">';
	modalHtml +='	<div class="lytb"><div class="lytb_row"><div class="lytb_td">';
	modalHtml +='	<div class="layer_style1">';
	modalHtml +='		<div class="layer_po">';
	modalHtml +='			<div class="cont">';
	modalHtml +='				<p class="lyp_txt3" style="margin-top:0;">';
	modalHtml +='				온라온매출 연결하기 정보를 삭제하면<br>';
	modalHtml +='				온라온매출 정보를 조회할 수 없습니다.';
	modalHtml +='				</p>';
	modalHtml +='				<div class="lyp_tit" style="margin-top:17px;">삭제하시겠습니까?</div>';
	modalHtml +='			</div>';
	modalHtml +='		</div>';
	modalHtml +='		<div class="ly_btn_fix_botm btn_both"><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->';
	modalHtml +='			<a class="off" onClick="fn_removeModal()">취소</a>';
	modalHtml +='			<a onClick="_thisPage.deleteSnss()">확인</a>';
	modalHtml +='		</div>';
	modalHtml +='	</div>';
	modalHtml +='	</div></div></div>';
	modalHtml +='</div>';
	$('body').append(modalHtml);	
}

//정상 처리 모달 생성
function fn_successSnss(){
	var modalHtml='';
	modalHtml +='<div class="modaloverlay">';
	modalHtml +='	<div class="lytb"><div class="lytb_row"><div class="lytb_td">';
	modalHtml +='	<div class="layer_style1">';
	modalHtml +='		<div class="layer_po">';
	modalHtml +='			<div class="cont">';
	modalHtml +='				<p class="lyp_tit">';
	modalHtml +='				정상적으로 변경되었습니다.';
	modalHtml +='				</p>';
	modalHtml +='			</div>';
	modalHtml +='		</div>';
	modalHtml +='		<div class="ly_btn_fix_botm"><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->';
	modalHtml +='			<a onClick="fn_removeModal()">확인</a>';
	modalHtml +='		</div>';
	modalHtml +='	</div>';
	modalHtml +='	</div></div></div>';
	modalHtml +='</div>';
	$('body').append(modalHtml);	
}

//실패 처리 모달 생성
function fn_failSnss(err_cd,err_msg){
	var modalHtml='';
	modalHtml +='<div class="modaloverlay">';
	modalHtml +='	<div class="lytb"><div class="lytb_row"><div class="lytb_td">';
	modalHtml +='	<div class="layer_style1">';
	modalHtml +='		<div class="layer_po">';
	modalHtml +='			<div class="cont">';
	modalHtml +='				<p class="lyp_tit mgb20" style="margin:0 0 7px;">';
	modalHtml +='				온라인매출 수정 실패하였습니다.<br>계정 정보를 다시 확인해주세요.';
	modalHtml +='				</p>';
	modalHtml +='				<div class="lyp_stxt">';
	modalHtml +='				['+err_cd+'] '+err_msg;
	modalHtml +='				</div>';
	modalHtml +='			</div>';
	modalHtml +='		</div>';
	modalHtml +='		<div class="ly_btn_fix_botm"><!-- 버튼이 2개인 경우 btn_both 클래스 추가 -->';
	modalHtml +='			<a onClick="fn_removeModal()">확인</a>';
	modalHtml +='		</div>';
	modalHtml +='	</div>';
	modalHtml +='	</div></div></div>';
	modalHtml +='</div>';
	$('body').append(modalHtml);	
}

//모달 닫기
function fn_removeModal(){
	$(".modaloverlay").remove();
}

//백버튼?
function fn_back(){
	iWebAction("closePopup",{_callback:"fn_popCallback"});
}

function fn_backPopCallback(){
	iWebAction("closePopup",{_callback:"fn_backPopCallback"});
}

//팝업화면 콜백
function fn_popCallback(){
	iWebAction("closePopup",{_callback:"fn_popCallback"});
}