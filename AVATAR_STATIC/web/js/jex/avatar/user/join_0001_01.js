/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : join_0001_01.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/user
 * @author         : 김별 (  )
 * @Description    : 회원가입_약관동의화면
 * @History        : 20200129100522, 김별
 * </pre>
 **/

$(function(){
	
	iWebAction('changeTitle', {_title:'약관동의',_type:'1'});
	/*if($("#USE_INTT_ID").val()){
		iWebAction('fn_app_finish');
	}*/
	//다음 버튼
	$('#nextBtn').on('click', function(){
		if( $('input[name=checkAll]').is(':checked') ){
			// 이동
			location.href = "/join_0001_02.act";
		}
	});
	$('input[name=checkAll]').on('click', function(){
		
		if($(this).is(':checked')){
			$('input[name=check]').prop('checked', true);
			$('input[name=check]').addClass('on');
			$('#nextBtn').removeClass('off');
		}else{
			$('input[name=check]').prop('checked', false);
			$('input[name=check]').removeClass('on');
			$('#nextBtn').addClass('off');
		}
		fn_checkboxConfirm();
	});
	
	$('input[name=check]').on('click', function(){
		if($(this).is(':checked')){
			$(this).addClass('on')
		}else{
			$(this).removeClass('on')
		}
		fn_checkboxConfirm();
	});
	
	$(document).on("click", ".clause_wrap li:eq(0) .btn", function(){
		var url = "join_0002_01.act";
		iWebAction("openPopup",{"_url" : url});
	})
	$(document).on("click", ".clause_wrap li:eq(1) .btn", function(){
		var url = "join_0002_02.act";
		iWebAction("openPopup",{"_url" : url});
	});
	$(document).on("click", ".clause_wrap li:eq(2) .btn", function(){
		var url = "join_0002_03.act";
		iWebAction("openPopup",{"_url" : url});
	});
});

function fn_checkboxConfirm(){
	var checkboxCnt = $(".clause_wrap ul").find('input[type=checkbox]').length;
	var checkedCnt = $(".clause_wrap ul").find('input[type=checkbox]:checked').length;

	if(checkboxCnt == checkedCnt){
		$('input[name=checkAll]').prop("checked", true)
		$('input[name=checkAll]').addClass('on');
		$('#nextBtn').removeClass('off');
	}else{
		$('input[name=checkAll]').prop("checked", false)
		$('input[name=checkAll]').removeClass('on');
		$('#nextBtn').addClass('off');
	}
}
function fn_back(){
		iWebAction("fn_app_finish");
}
