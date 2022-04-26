/**
 * <pre>
 *  PROJECT
 * @COPYRIGHT (c) 2009-2015 WebCash, Inc. All Right Reserved.
 *
 * @File Name      : sstm_0102_03.js
 * @File path      : AVATAR_STATIC/web/js/jex/avatar/admin/sstm
 * @author         : 김태훈 (  )
 * @Description    : 
 * @History        : 20200306160652, 김태훈
 * </pre>
 **/

var _gu, _me;

var _thisPage = {
	fn_init: function(){
		_thisPage.fn_loadGrdDtl();
	}
	,fn_loadGrdDtl: function(){ // Load_Grid_Detail
		
		// CHAGNE FROM dsdl_0002_01_r001 TO sstm_0103_03_r001
		var jexAjax = jex.createAjaxUtil("sstm_0102_03_r001");   //ACTION 세부코드관리
		jexAjax.set("DSDL_GRP_CD", $("#_DSDL_GRP_CD").val());
			
		jexAjax.execute(function(data){
			
			if(data.ERR_CD=="0000"){
				_thisPage.cb_fn_loadGrdDtl(data.REC);    
			}
		});
		
	}
	,cb_fn_loadGrdDtl: function(rec){
		var tbl_title_1 = $("#tbl_title_1");
		var tbl_content_1 = $("#tbl_content_1");
		
		var hHtml  = "<tr>";
			hHtml += "<th scope='col' style='width:50px !important;'></th>";
			hHtml += "<th scope='col'><div>세부코드</div></th>";
			hHtml += "<th scope='col'><div>세부코드명</div></th>";
			hHtml += "<th scope='col' style='text-align:center'><div>출력순서</div></th>";
			hHtml += "<th scope='col'><div>설명</div></th>";
			hHtml += "<th scope='col' style='text-align:center'><div>세부코드</div></th>";		
			hHtml += "</tr>";
		
		tbl_title_1.find("thead").html(hHtml);
		
		$(tbl_content_1).find("colgroup").remove();
		$(tbl_title_1).find("colgroup").clone().prependTo($(tbl_content_1));
		$(tbl_content_1).find("tfoot").remove();
		$(tbl_content_1).find("tbody").find("tr").remove();
		
		if(rec.length == 0) {
			var sHtml = "";		
			sHtml += '<tfoot>';
			sHtml += '    <tr class="no_hover" style="display:table-row;">';
			sHtml += '        <td colspan="'+$("#tbl_content_1").find("colgroup").find("col").length+'" class="no_info"><div>내용이 없습니다.</div></td>';
			sHtml += '    </tr>';
			sHtml += '</tfoot>';
			$(tbl_content_1).prepend(sHtml);
		}
		else {
			var sHtml = "";	
			$.each(rec, function(i, v) {
				
				sHtml += "<tr class='text-dot group-item-list' trIdx=\""+i+"\" >";
				sHtml += _thisPage.fn_makeTbody(v);
				sHtml += "</tr>";
			
			});	
			$(tbl_content_1).prepend(sHtml);
		}
		
	}
	, fn_makeTbody : function(v){
		
		var useYn = "";
		if(v.ACVT_STTS == "Y"){
			useYn = "사용";
		}else{
			useYn = "사용안함";
		}
		
		var td = "<td style='text-align:center;width:50px !important;'><div><span><input type='radio' name='dsdlItem' class='dsdlItem' " +
				" data-dsdl_item_cd=\""+fintech.common.null2void(v.DSDL_ITEM_CD)+"\" data-dsdl_item_nm=\""+fintech.common.null2void(v.DSDL_ITEM_NM)+"\" " +
				" data-otpt_sqnc=\""+fintech.common.null2void(v.OTPT_SQNC)+"\" data-rmrk=\""+fintech.common.null2void(v.RMRK)+"\" " +
				" data-use_yn=\""+fintech.common.null2void(v.ACVT_STTS)+"\"/></span></div></td>";
		td += "<td><div><span>"+fintech.common.null2void(v.DSDL_ITEM_CD)+"</span></div></td>"; 
		td += "<td><div><span>"+fintech.common.null2void(v.DSDL_ITEM_NM)+"</span></div></td>"; 
		td += "<td style='text-align:center'><div><span>"+fintech.common.null2void(v.OTPT_SQNC)+"</span></div></td>"; 
		td += "<td><div><span>"+fintech.common.null2void(v.RMRK)+"</span></div></td>"; 
		td += "<td style='text-align:center'><div><span>"+fintech.common.null2void(useYn)+"</span></div></td>"; 
		return td;
	}
	,fn_createItem: function(){
		
		//var jexAjax = jex.createAjaxUtil("cstm_0102_02_r001");
		var jexAjax = jex.createAjaxUtil("sstm_0102_03_c001");
		jexAjax.set("DSDL_GRP_CD",	$("#_DSDL_GRP_CD").val());  //그룹코드	
		jexAjax.set("DSDL_ITEM_CD", $("#DSDL_ITEM_CD").val());  //새 세부코드				
		jexAjax.set("DSDL_ITEM_NM", $("#DSDL_ITEM_NM").val());  //세부코드명
		jexAjax.set("RMRK", $("#RMRK").val()+"");  //설명
		jexAjax.set("ACVT_STTS", $("#ACVT_STTS option:selected").val());  //사용여부
		jexAjax.set("OTPT_SQNC", $("#OTPT_SQNC").val()+"");  //출력순서
		jexAjax.set("_LODING_BAR_YN_", "Y");
		
		jexAjax.execute(function(data){
			if(data.ERR_CD == "0000"){
				
				_thisPage.fn_loadGrdDtl();
				_thisPage.fn_clearInput();
				
				//No need to close popup we can add more
				parent.fn_allCallbackFnc();
				
			}else if(data.ERR_CD == "8888"){
				alert("사용할 수 없는 세부코드입니다.");
			}else {
				alert(data.ERR_CD);
			}
		});
	}, fn_updateItem: function(){
				
		// change from dsdl_0002_01_u001 to sstm_0103_03_u001
		var jexAjax = jex.createAjaxUtil("sstm_0102_03_u001");
		jexAjax.set("_LODING_BAR_YN_", "Y");
		
		jexAjax.set("DSDL_ITEM_NM", $("#DSDL_ITEM_NM").val());  //세부코드명
		jexAjax.set("ACVT_STTS", $("#ACVT_STTS option:selected").val());  //사용여부
		jexAjax.set("OTPT_SQNC", $("#OTPT_SQNC").val());  //출력순서
		//jexAjax.set("DSDL_DESC", $("#DSDL_DESC").val());  //설명
		jexAjax.set("DSDL_GRP_CD", $("#_DSDL_GRP_CD").val());  //그룹코드				
		jexAjax.set("DSDL_ITEM_CD", _gData.DSDL_ITEM_CD);  //세부코드
		jexAjax.set("RMRK",  $("#RMRK").val());
		jexAjax.execute(function(data){
			if(data.ERR_CD == "0000"){
				_thisPage.fn_loadGrdDtl();
				_thisPage.fn_clearInput();
				
				// WE can use 1 of 3 function below
				//parent.smartClosePop("_thisPage.fn_search");
				// parent.smartClosePop("fn_allCallbackFnc");
				window.parent.fn_allCallbackFnc();
				
			} else {
				alert(data.ERR_CD);
			}
		});
		
	}, fn_deleteItem: function(){
		
		// change from dsdl_0002_01_d001 => sstm_0103_03_d001
		var jexAjax = jex.createAjaxUtil("sstm_0102_03_d001");   
		jexAjax.set("DSDL_GRP_CD" 	, $("#_DSDL_GRP_CD").val());    // 그룹코드
		jexAjax.set("DSDL_ITEM_CD"	, _gData.DSDL_ITEM_CD);  //세부코드
		
		jexAjax.execute(function(data){
			if(data.ERR_CD == "0000"){
				_thisPage.fn_loadGrdDtl();
				_thisPage.fn_clearInput();
				
				// WE can use 1 of 3 function below
				//parent.smartClosePop("_thisPage.fn_search");
				//parent.smartClosePop("fn_allCallbackFnc");
				window.parent.fn_allCallbackFnc();
				
			} else {
				alert(data.ERR_CD);
			}
		});
		
	}, fn_validate_create : function(){
		if(! _thisPage.validateNull("DSDL_ITEM_CD"))
			return false;
		else if(! _thisPage.validateNull("DSDL_ITEM_NM"))
			return false;
		else if(! _thisPage.validateNull("ACVT_STTS")) 
			return false;
		return true;
		
	}
	, fn_validate_update: function(){
		if(!_thisPage.validateNull("DSDL_ITEM_NM"))
			return false;
		return true;
		
	}
	, validateNull: function(cls){
		var value = $("#"+cls).val();
		if(value == null || value.trim() == ''){
			$("#"+cls).addClass("invalid");
			$("#"+cls).focus();
			return false;
		}else{
			$("#"+cls).removeClass("invalid");
			return true;
		}
	}, fn_clearInput: function(){
		$(".tbl_input2  .invalid").removeClass("invalid");
		$("#action_update").css("display", "none");
		$("#action_create").css("display", "block");
		$("#DSDL_ITEM_CD").val("");
		$("#DSDL_ITEM_NM").val("");
		$("#OTPT_SQNC").val("");
		$("#RMRK").val("");
		$("#ACVT_STTS").val("Y");
		
	}, fn_validateMaxLengthStr :function(element){
		var maxlength = $(element).attr("maxlength");
		var str = $(element).val();
		
	    if(str.length > maxlength){
	    	$(element).val(str.slice(0,maxlength));
	    }else{
	    	$(element).val(str);	
	    }
	}
	
	
	
	
	
	
}



$(function(){
	_thisPage.fn_init();
	
	
	
	//취소
	$("#btnClose, .btn_popclose").on("click", function(){
		parent.smartClosePop();
	});
	
	//저장
	$("#btnSave").on("click", function(){
		if(!$('input:radio[class=dsdlItem]').is(':checked')) { 
			if(_thisPage.fn_validate_create()){
				_thisPage.fn_createItem();
			}		
			
		}else{	
		    if(_thisPage.fn_validate_update()){
				_thisPage.fn_updateItem();
			}
		    
		}
	});
	
	$("#btnReset").on("click", function(){
		
		_thisPage.fn_clearInput();
		_gData = {};
		$("input:radio[class=dsdlItem]").prop('checked', false);
	});
	
	
	$(document).on("click", "tr.group-item-list", function(){
		
		$("tr.group-item-list").removeClass("selected-color");
		$(this).addClass("selected-color");
		
		var inputVal = $(this).find("input:radio[class=dsdlItem]");
		inputVal.prop('checked', true);
		var data = {
			DSDL_ITEM_CD : fintech.common.null2void(inputVal.attr("data-DSDL_ITEM_CD")),
			DSDL_ITEM_NM : fintech.common.null2void(inputVal.attr("data-DSDL_ITEM_NM")),
			OTPT_SQNC : fintech.common.null2void(inputVal.attr("data-OTPT_SQNC")),
			RMRK : fintech.common.null2void(inputVal.attr("data-RMRK")),
			ACVT_STTS : fintech.common.null2void(inputVal.attr("data-ACVT_STTS"))
		};
		_gData = data;
		if(data){
			$("#action_update").css("display", "block");
			$("#action_create").css("display", "none");
			$("#DSDL_ITEM_CD_UPDATE").html(data.DSDL_ITEM_CD);
			$("#DSDL_ITEM_NM").val(data.DSDL_ITEM_NM);
			$("#OTPT_SQNC").val(data.OTPT_SQNC);
			$("#RMRK").val(data.RMRK);
			$("#ACVT_STTS").val(data.ACVT_STTS);
		}
	});
	
	//세부코드 입력 제한
	$("#DSDL_ITEM_CD").on("keyup", function(){
		var maxlength = $(this).attr("maxlength");
		//var str = $(this).val().replace(/[^0-9a-z!~*%@#$&()\\-`-_.+=|{}',/\"\[\]:;<>?]/gi,"");		
		
	    if(str.length > maxlength){
	    	$(this).val(str.slice(0,maxlength));
	    }else{
	    	$(this).val(str);	
	    }
	});
	
	//세부코드명 입력 제한
	$("#DSDL_ITEM_NM").on("keyup", function(){
		_thisPage.fn_validateMaxLengthStr(this);
	});
	
	// 출력순서 입력 제한
	$("#OTPT_SQNC").on("keyup", function(){
		
		var maxlength = $(this).attr("maxlength");
		var str = $(this).val().replace(/[^0-9]/gi,"");		// 숫자만 입력 가능
		if(str.length > maxlength){
	    	$(this).val(str.slice(0,maxlength));
	    }else{
	    	$(this).val(str);	
	    }		    
	});
	
	// 설명 입력 제한
	$("#RMRK").on("keyup", function(){
		_thisPage.fn_validateMaxLengthStr(this);
	});
	
	//삭제
	$("#btnDelete").on("click", function(){
		
		if(!$('input:radio[class=dsdlItem]').is(':checked')) { 
			alert("삭제할 세부코드를 선택하세요");
		}else{
			_thisPage.fn_deleteItem();
		}
		
	});
	
}); //end query block

