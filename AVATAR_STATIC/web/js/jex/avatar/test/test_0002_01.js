/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : test_0002_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/test
 * @author         : 박지은 (  )
 * @Description    : 푸시발송 테스트
 * @History        : 20210907081607, 박지은
 * </pre>
 **/
$(function(){
	// 알림구분 (숫자만)
	$('#noti_gb').on('keyup', function(){
		$(this).val( $(this).val().replace(/[^0-9]/g,'') );
	});
	
	// 전화번호 (숫자만)
	$('#clph_no').on('keyup', function(){
		$(this).val( $(this).val().replace(/[^0-9]/g,'') );
	});
	
	// 푸시발송
	$('#sendBtn').on('click', function(){
		var noti_gb = $('#noti_gb').val();
		var use_intt_id = $('#use_intt_id').val();
		var clph_no = $('#clph_no').val();
		if(noti_gb.length == 0){
			alert("알림구분을 입력하세요.");
			return;
		}else{
			if(noti_gb != "001" && noti_gb != "002" && noti_gb != "003"){
				alert("알림구분은 001:학습완료, 002:제로페이매출, 003:카드매출입니다.");
				return;
			}
		}
		
		if(use_intt_id.length == 0 && clph_no.length == 6){
			alert("이용기관ID나 핸드폰번호는 입력해주세요.");
			return;
		}
		
		var data = {
				NOTI_GB:noti_gb,
				USE_INTT_ID:use_intt_id,
				CLPH_NO:clph_no
		};
		
		fn_pushSend(data);
	});
	
});
function fn_pushSend(data){
	var jexAjax = jex.createAjaxUtil("test_0002_01_r001");
	jexAjax.set(data);
	jexAjax.execute(function(dat){
		
		if(dat.RSLT_CD == '0000'){
	    	alert("푸시발송 성공.");
	    } else{
	    	alert("푸시발송 실패"+dat.RSLT_CD+" : "+dat.RSLT_MSG);
	    }
	});
}