/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : join_0001_02.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/user
 * @author         : 김별 (  )
 * @Description    : 회원가입_정보입력화면
 * @History        : 20200129100717, 김별
 * </pre>
 **/
var timer = null;
var minute = 3;
var second = 0;
$(function(){
	iWebAction('changeTitle', {_title:'',_type:'0'});
	//성별 선택 시
	$("#gender").on('click', function(){
		$(".ly_slt_type").toggle();
	});
	$(".ly_slt_type").on("click", function(){
		$(this).toggle(); 
	});
	$(".ly_slt_type li").on("click", function(){
		$(".ly_slt_type li").removeClass("on");
		$(this).addClass("on");
		$(".slt_type .inner a").html($(this).text());
		$(".tit").attr("gender", $(this).val());
		console.log($(".tit").attr("gender")	);
		$(this).parent().parent().toggle(); 
	})
	//통신사 선택
	$(".tel_co input[name=tel_co]").on("click", function(){
		$(".tel_co input[name=tel_co]").removeClass("on");
		$(this).addClass("on");
		console.log($(".tel_co input[name=tel_co].on").val());
	})
	//알뜰폰
	$(".tel_co input[name=tel_co1]").on("click", function(){
		if($(this).hasClass("on")){
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
		}
	})
	// 전화번호 (숫자만)
	$('#clph_no').on('keyup', function(){
		$(this).val( $(this).val().replace(/[^0-9]/g,'') );
	});
	
	// 인증번호 숫자만
	$('#crtc_srno').on('keyup', function(){
		$(this).val($(this).val().replace(/[^0-9]/g,''));
		
		if( $(this).val().length == 6 ){
			$('#nextBtn').removeClass('off');
		}
	});
	
	// 다음
	$('#nextBtn').on('click', function(){
		if(minute == 0 && second == '00'){
			fn_toast_pop('인증시간이 만료되었습니다.');
			return;
		}
		var sms_cert_no = $('#sms_cert_no').val();
		if(sms_cert_no.length == 0){
			fn_toast_pop('인증번호를 입력하세요.');
			return;
		}
		
		if(sms_cert_no.length > 0 && sms_cert_no.length > 6){
			fn_toast_pop('인증번호는 숫자 6자입니다.');
			return;
		}
		var data = {
				TRSC_UNQ_NO:$('#trsc_unq_no').val(),
				CLPH_NO:$('#clph_no').val(),
				SMS_CERT_NO:sms_cert_no
		};
		fn_certifyNumberConfirm(data);
	});
	
	// 인증번호 받기
	$('.btn_01').on('click', function(){
		// 인증번호 초기화
		$("#sms_cert_no").val("");
		var data = {
				NAME:'',
				BRDT:'',
				GNDR:'',
				IN_FRNR_DV_CD:'',
				TEL_CMM_CD:'',
				ECNMC_TEL_CMM_YN:'',
				CLPH_NO:'',
		}
		
		var name = $('#name').val(); 				// 사용자이름
		var brdt = $('#birth').val(); 				// 생년월일
		var gndr = $('#gender .tit').attr("gender"); 			// 성별
		var telCmmCd = $('input[name=tel_co]:checked').val(); // 통신사
		var ecnmcTelCmmYn = '';  					// 알뜰폰유무
		var clph_no = $('#clph_no').val() 			// 전화 번호
		
		if($('input[name=tel_co1]').attr('checked')){
			ecnmcTelCmmYn = 'Y';
		}else{
			ecnmcTelCmmYn = 'N';
		}
		// 성명 확인
		if(name.length == 0 ){
			fn_toast_pop('이름을 입력해주세요');
			return;
		}
		// 생년월일 확인
		if(brdt.length == 0 ){
			fn_toast_pop('생년월일을 입력해주세요.');
			return;
		}
		if(brdt.length > 0  && brdt.length < 6){
			fn_toast_pop('생년월일은 숫자 8자입니다.(예:19900101)');
			return;
		}
		// 전화 번호
		if(clph_no.length  == 0){
			fn_toast_pop('휴대폰번호를 입력하세요');
			return;
		}
		if(avatar.common.null2void($(".tel_co input[name=tel_co].on").val()) == ""){
			fn_toast_pop('통신사를 선택하세요');
			return;
		}
			
		
		data.NAME = name;
		data.BRDT = brdt;
		data.GNDR = gndr;
		data.TEL_CMM_CD = telCmmCd;
		data.ECNMC_TEL_CMM_YN = ecnmcTelCmmYn;
		data.CLPH_NO = clph_no;
		
		if($('input[name=in_frnr]').is(":checked")){
			data.IN_FRNR_DV_CD = "1";
		}else{
			data.IN_FRNR_DV_CD = "2";
		}
		
		$("#require").hide();
		$("#re_require").show();
		console.log(data);
		//인증번호 받기
		fn_certifyNumberCall(data);
	});
});
function fn_join(CUST_CI){
	
//	$("#frmTest").remove();
	/*tax_0003_02.act?ISSU_ID="+$(this).parent().attr("issuid")+"&BILL_TYPE="+$("#BILL_TYPE").val()
*/	//var url =  "join_0001_03.act";
	CUST_CI= CUST_CI.replace(/&/g,"%26").replace(/\+/g,"%2B");
	location.href = "join_0001_03.act?CUST_NM="+$("#name").val()+"&CLPH_NO="+$("#clph_no").val()+"&CUST_CI="+CUST_CI;
	//var url = "join_0001_03.act?CUST_NM="+$("#name").val()+"&CLPH_NO="+$("#clph_no").val()+"&CUST_CI="+CUST_CI;
	//iWebAction("openPopup",{"_url" : url/*, "_param" : {"CUST_NM" : $("#name").val(), "CLPH_NO" : $("#clph_no").val(), "CUST_CI" : CUST_CI}*/});
	
	
	/*var html = "";
	html +='<form action="join_0001_03.act" style="display:none;" method="post" id="frmTest">';
	html +='<input type="hidden" name="CUST_NM" value="'+$("#name").val()+'"/>';
	html +='<input type="hidden" name="CLPH_NO" value="'+$("#clph_no").val()+'"/>';
	html +='<input type="hidden" name="CUST_CI" value="'+CUST_CI+'"/>';
	html +='</form>';
	$("body").append(html);
	
	
	$("#frmTest").submit();*/
}
function fn_login(CUST_CI){
	
	var html = "";
	html +='<form action="ques_0001_01.act" style="display:none;" method="post" id="frmTest">';
	html +='<input type="hidden" name="CUST_CI" value="'+CUST_CI+'"/>';
	html +='</form>';
	$("body").append(html);
	$("#frmTest").submit();
}

/**
 * 인증번호 받기
 * @param data
 * @returns
 */
function fn_certifyNumberCall(data){
	
	var jexAjax = jex.createAjaxUtil("join_0001_02_r001");
	jexAjax.set(data);
	jexAjax.execute( function( dat ) {
		if(dat.RSLT_CD != "B000"){
			fn_toast_pop('인증번호 호출을 실패 하였습니다.');
			$('#timer').html("<em class='min'>03</em> : <em class='sec'>00</em>");
			return;
		}/*
	    if( jex.isError( dat ) ) {
	    	console.log("ERROR");
	        var errCode = jexjs.getJexErrorCode( dat );
	        var errMsg = jexjs.getJexErrorMessage( dat );
	        fn_toast_pop('인증번호 호출을 실패 하였습니다.');
	        $('#timer').html("<em class='min'>03</em> : <em class='sec'>00</em>");
	        return;
	    }*/
	    console.log(dat.TRSC_UNQ_NO);
	    $('#trsc_unq_no').val(dat.TRSC_UNQ_NO);
	    fn_timerStart();
	    fn_toast_pop('인증번호를 발송하였습니다.');
	    $('#nextBtn').removeClass('off');
	    
	});
}

/**
 * 인증번호 확인
 * @param data
 * @returns
 */
function fn_certifyNumberConfirm(data){
	
	var jexAjax = jex.createAjaxUtil("join_0001_02_r002");
	jexAjax.set(data);
	jexAjax.execute(function(dat){
		
		if(dat.RSLT_CD == 'B000'){
	    	fn_toast_pop('본인인증 성공하였습니다.');
	    	iWebAction("fn_pattern_auth", {"_menu_id":"2", "_desc":["패턴을 설정하세요", "한번 더 입력하세요"],"_callback":"fn_join","_data":{"cust_ci" : dat.CUST_CI}});
	    } else{
	    	if(dat.RSLT_CD == '9999'){
		    	fn_toast_pop('가입된 휴대번호입니다.');
		    	//fn_join("+HvsPYwn5NX6Kq6l7JkL7D5sK/6iYM4zTTTvwPisLv8/pNXJWYQMWZZ/e2gAIiH9I CWixTVMN9GXoFs4jkDgQ==");
		    	iWebAction("fn_pattern_auth", {"_menu_id":"2", "_desc":["패턴을 설정하세요", "한번 더 입력하세요"],"_callback":"fn_join","_data":{"cust_ci" : dat.CUST_CI}});
	    	} else{
	    		fn_toast_pop('본인인증 실패하였습니다.');
				$('#timer').html("<em class='min'>03</em> : <em class='sec'>00</em>");
				return;
	    	}
	    	
	    }/*
	    if(dat.RSLT_CD != 'B000'){
			fn_toast_pop('본인인증 실패하였습니다.');
			$('#timer').html("<em class='min'>03</em> : <em class='sec'>00</em>");
			return;
		}*//*
	    if(jex.isError(dat)){
	        var errCode = jexjs.getJexErrorCode( dat );
	        var errMsg = jexjs.getJexErrorMessage( dat );
	        fn_toast_pop('본인인증 실패하였습니다.');
	        $('#timer').html("<em class='min'>03</em> : <em class='sec'>00</em>");
	        return;
	    }*/
	    
	});
}
//중복 회원가입 처리,,,


function fn_toast_pop(msg){
	$('#toast_msg').text(msg);
	$('.toast_pop').css('display','block');
	setTimeout(function(){
		$('.toast_pop').css('display', 'none');
	}, 2000);
}

function fn_timerStop(){
	clearInterval(timer); /* 타이머 종료 */
}

function fn_timerStart(){
	
	clearInterval(timer);
	minute = 3;
	second = 0;
	timer = setInterval(function () {
		// 설정
		if(second == 0 && minute == 0 ){
			clearInterval(timer); /* 타이머 종료 */
			timer = null;
		}else{
			second--;				
			// 분처리
			if(second < 0){
				minute--;
				second = 59;
			}
			if(second < 10 ){
			    second = "0"+second;
			}
		}
		$('.time').html("0"+minute+":"+second);
		
	}, 1000); /* millisecond 단위의 인터벌 */
    
}
function fn_back(){
	history.back();
}