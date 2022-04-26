var fintech;
if(!fintech) fintech={};
if(!fintech.common) fintech.common={};

// 도움말 레이어
fintech.common.helpLayer = function(msg, btnId, layerId) {
	var html = "";
	html += '<div class="layertype1" id="' + layerId + '" style="top:-36px;left:743px;width:200px;">';
	html += '	<div class="toptail_layer">';
	html += '		<span class="tail2" style="left:40px;"></span>';
	html += '		<div style="padding:8px 9px 9px 9px;line-height:18px;">';
	html += '			<p style="font-size:11px;color:#555;">' + msg + '</p>';
	html += '		</div>';
	html += '	</div>';
	html += '</div>';
	$("body").append(html);
	fintech.common.moveLayer($("#" + btnId), $("#" + layerId), "top");
}
// 파일 확장자 체크
fintech.common.chkFile = function( fileName ) {
	var fileExt = fileName.substring(fileName.lastIndexOf(".")+1);
    //if(fileExt.toUpperCase() == "PNG" || fileExt.toUpperCase() == "JPG" || fileExt.toUpperCase() == "GIF" || fileExt.toUpperCase() == "PNG") {
	if(fileExt.toUpperCase() == "PDF" || fileExt.toUpperCase() == "GIF" || fileExt.toUpperCase() == "PNG" || fileExt.toUpperCase() == "JPG" || fileExt.toUpperCase() == "JPE" || fileExt.toUpperCase() == "JPEG" || fileExt.toUpperCase() == "TIF" || fileExt.toUpperCase() == "TIFF") {
    	return true;
    } else {
    	return false;
    }
}
// 페이지 이동
fintech.common.location =  function( url ) {
	if(url.indexOf(".act") > -1) {
		location.href = url;	
	} else {
		location.href = url + ".act";
	}
};
// 페이지 이동(서브밋)
fintech.common.submit =  function( $form, url, target ) {
	var locUrl = "";
	if(url.indexOf(".act") > -1 || url.indexOf(".jct") > -1) {
		locUrl = url;	
	} else {
		locUrl = url + ".act";
	}

	if(target == null || target == undefined) target = "_self";

	$form.attr("target", target);
	$form.attr("action", locUrl);
	$form.submit();
};
//
//
//// API서비스 추가 팝업
//fintech.common.newLayerApiSvcInfo = function(form, id, callback) {
//	var options      = {};
//    options.url      = "cmweb_com1_07.act";
//    options.applyId  = form;
//    options.dataType = "html";
//    options.data     = {callBackFn : callback}
//    options.success  = function(html) {
//    	$(html).modalCon({
//    		autoLoad       : true,
//    		owner          : $("#"+id),
//    		callbackBefore : function(e){}
//    	});
//    };
//
//    // 데이타 키값은 각화면에 있는 페이지 코드 확인하셔서 변경해주시면 됩니다.
//    $.ajax(options);
//};
//
//// OPENAPI 추가 팝업
//fintech.common.newLayerOpenApiInfo = function(form, id, data, callback) {
//
//	var options      = {};
//    options.url      = "cmweb_com1_04.act";
//    options.applyId  = form;
//    options.dataType = "html";
//    options.data     = {callBackFn : callback, SVC_PTRN : data.SVC_PTRN}
//    options.success  = function(html) {
//    	$(html).modalCon({
//    		autoLoad       : true,
//    		owner          : $("#"+id),
//    		callbackBefore : function(e){}
//    	});
//    };
//    // 데이타 키값은 각화면에 있는 페이지 코드 확인하셔서 변경해주시면 됩니다.
//    $.ajax(options);
//};

/**
 * $btn을 클릭했을때 $btn을 기준으로 특정 layer(특정div영역)의 위치를 변경 할 수 있습니다.
 * @param  $btn : layer위치의 기준이 되는 버튼
 * @param  $layer : 화면에 보여줄 영역
 * @parma3 position : left,right,top,bottom을 사용하여 $btn의 왼쪽, 오른쪽, 위, 아래에 layer가 오도록 설정
 * @example $("#A1").click(function(){ fintech.common.moveLayer($(this),$("#SELECT_LAYER"), "left"); });
 */
fintech.common.moveLayer = function($btn, $layer, position) {
    $layer.show();

    var layerWidth = $layer.width();
    var layerHeight = $layer.height();
    var btnWidth = $btn.width();
    var btnHeight = $btn.height();

    if(position != undefined && position != null && position != "") {
        if(position == "left") {
            $layer.offset({left : ($btn.offset().left - layerWidth), top : $btn.offset().top});
        } else if(position == "right") {
            $layer.offset({left :($btn.offset().left + btnWidth), top : $btn.offset().top});
        } else if(position == "top") {
            $layer.offset({left :($btn.offset().left + (Math.round(btnWidth/2)) - (Math.round(layerWidth/2))), top : ($btn.offset().top - layerHeight)});
        } else if(position == "bottom") {
            $layer.offset({left : ($btn.offset().left + (Math.round(btnWidth/2)) - (Math.round(layerWidth/2))), top : ($btn.offset().top + btnHeight )});
        }
    }

    // 레이어 팝업 포커스
    //$layer.eq(0).focus();
    $layer.find("a:first").focus();

    // 마지막 엘리먼트에서 tab 이벤트
   	$layer.find("a:last").bind("keydown", function(e) {
   		if(e.shiftKey) {
   			if(e.which == 9) {
   				$layer.find("a:first").focus();
   				e.preventDefault();
   			}
   		} else {
   			if(e.which == 9) {
   				$layer.eq(0).focus();
   				e.preventDefault();
   			}
   		}
	});

   	// 첫번째 엘리먼트에서 shift tab 이벤트
   	$layer.find("a:first").bind("keydown", function(e) {
		if(e.shiftKey && e.which == 9) {
			$layer.find("a:last").focus();
			e.preventDefault();
		}
	});
}
/**
 * 파일레이어를 호출함
 * @param thisObj
 * @param data
 */
fintech.common.fileListLayer = function(thisObj, data) {
	var jexAjax = jex.createAjaxUtil('cmweb_com1_01_l002');
	jexAjax.set("_LODING_BAR_YN_", "Y"                    ); // 로딩바 출력여부
	$.each(data, function(key,val) {
		jexAjax.set(key      , val                  ); // 연계키1	
	});
	jexAjax.execute(function(dat) {
		var rec = dat.REC1;
		var html = "";
		$(".fileLayer").remove();

		html += "<div class=\"view_set_pop fileLayer\" style=\"position: absolute; width: ; top:; z-index: 99999;\">";
		html += "    <div class=\"pop_header\">";
		html += "        <h1>첨부파일</h1>";
		html += "        <a href=\"javascript:\" onclick=\"fintech.common.closeFileLayer();return false;\" class=\"btn_popclose\"><img src=\"/img/btn/btn_popclose.gif\" alt=\"팝업닫기\"></a>";
		html += "    </div>";
		html += "    <div class=\"pop_container\">";
		html += "        <div class=\"view_setting_lst mgt5\">";
		html += "            <ul>";
		if(rec.length > 0) {
			for(var idx=0; idx<rec.length; idx++) {
				html += "        <li><a href=\"javascript:void(0);\" onclick=\"fintech.common.fileDown('"+rec[idx].ATCH_SQNO+"','"+rec[idx].STRG_PATH+"','"+rec[idx].LNKD_KEY1+"');return false;\" class=\"underline\">"+rec[idx].ATCH_NM+"</a></li>";
			}	
		} else {
			html += "            <li>첨부파일이 존재하지 않습니다.</li>";
		}
		html += "            </ul>";
		html += "        </div>";
		html += "    </div>";
		html += "</div>";

		$("body").append(html);

		fintech.common.moveLayer($(thisObj), $(".fileLayer"), "left");

		$(document).click(function() {
			if($(".fileLayer").length > 0) {
				$(".fileLayer").remove();	
			}
		}); 
		$(document).on("click", ".fileLayer", function(e) {
			e.stopPropagation(); 
		});
	});
};
/**
 * 파일레이어 종료
 */
fintech.common.closeFileLayer = function() {
	$(".fileLayer").remove();
}
/**
 * 파일다운로드
 * @param strgPath
 * @param atchSqno
 * @param lnkdKey1
 */
fintech.common.fileDown = function(atchSqno, strgPath, lnkdKey1) {
	$("body").find("#fileDownForm"    ).remove();
	$("body").find("#ifrmFileDownProc").remove();
	$("body").append("<form id=\"fileDownForm\" name=\"fileDownForm\" method=\"post\"><input type='hidden' class='fileDownClass' id='LNKD_KEY1' name='LNKD_KEY1' value='" + lnkdKey1 + "' /><input type='hidden' class='fileDownClass' id='ATCH_SQNO' name='ATCH_SQNO' value='" + atchSqno + "' /><input type='hidden' class='fileDownClass' id='STRG_PATH' name='STRG_PATH' value='" + strgPath + "' /></form>");
	$("body").append("<iframe id=\"ifrmFileDownProc\" name=\"ifrmFileDownProc\" frameborder=\"0\" scrolling=\"auto\" width=\"0\" height=\"0\" style=\"height:0px;\"></iframe>");

	fintech.common.submit($("#fileDownForm"), "cmweb_com1_06.act", "ifrmFileDownProc");
}
/**
 * value가 false로 평가되는 값(undefined, null, "")이면 ""로 반환한다.
 * 
 * @param value
 * @def def : value가 false로 평가되는 값일경우, def가 있으면 def를 반환한다.
 * 
 */
fintech.common.null2void = function(value, def) {
	if (!value)
		return !def ? "" : def;
	else
		return $.trim(value);
};
fintech.common.isValidEmail = function(str){
	 var format = /^((\w|[\-\.])+)@((\w|[\-\.])+)\.([A-Za-z]+)$/;
	    if (str.search(format) == -1) {
	       return false;
	    }
	    return true;
};
fintech.common.getLastDate = function(yyyy, mm)
{
	if( yyyy==undefined || String(yyyy).length!=4 || mm==undefined || String(mm).length>2 )
		return 0;
	else
		return new Date(new Date(yyyy, mm, '1')-(60*60*24*1000)).getDate();
};
fintech.common.setNowLoding = function( input ){
	try{
		var lodingBarYn = fintech.common.null2void(input["_LODING_BAR_YN_"],"N");
		if(lodingBarYn == "Y"){
			var loding = jex.plugin.get("JEX_LODING");
			loding.start();
		}		
	}catch(e){};
};
fintech.common.removeLoding = function( input ) {
	try{
		var loding = jex.plugin.get("JEX_LODING");
		if(loding)
			loding.stop();	
	}catch(e){};
};
fintech.common.isValidDate = function( param ) {
    try {
        param = param.replace(/-/g,''); // 자리수가 맞지않을때
        if( isNaN(param) || param.length!=8 ) {
            return false;
        }
        var year  = Number(param.substring(0, 4));
        var month = Number(param.substring(4, 6));
        var day   = Number(param.substring(6, 8));
        var dd    = day / 0;

        if( month<1 || month>12 ) {
            return false;
        }

        var maxDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        var maxDay         = maxDaysInMonth[month-1]; // 윤년 체크
        if( month==2 && ( year%4==0 && year%100!=0 || year%400==0 ) ) {
            maxDay = 29;
        }
        if( day<=0 || day>maxDay ) {
            return false;
        }
        return true;
    } catch (err) {
        return false;
    }
};
/**
 * 인증키 파일다운로드
 * @param fintechApsno
 * @param hostNm
 * @param srvrIp
 * @param sqno
 */
fintech.common.atkFileDown = function(fintechApsno, hostNm, srvrIp, sqno) {
	$("body").find("#atkFileDownForm"    ).remove();
	$("body").find("#ifrmAtkFileDownProc").remove();
	$("body").append("<form id=\"atkFileDownForm\" name=\"atkFileDownForm\" method=\"post\"><input type='hidden' class='arkFilDownClass' id='HOST_NM' name='HOST_NM' value='" + hostNm + "' /><input type='hidden' class='arkFilDownClass' id='FINTECH_APSNO' name='FINTECH_APSNO' value='" + fintechApsno + "' /><input type='hidden' class='arkFilDownClass' id='SRVR_IP' name='SRVR_IP' value='" + srvrIp + "' /><input type='hidden' class='arkFilDownClass' id='SQNO' name='SQNO' value='" + sqno + "' /></form>");
	$("body").append("<iframe id=\"ifrmAtkFileDownProc\" name=\"ifrmAtkFileDownProc\" frameborder=\"0\" scrolling=\"auto\" width=\"0\" height=\"0\" style=\"height:0px;\"></iframe>");

	fintech.common.submit($("#atkFileDownForm"), "cmweb_com1_13.act", "ifrmAtkFileDownProc");
}

// 입력받은 메세지의 길이를 바이트로 계산하여 리턴한다.
fintech.common.getByteLength = function (message) {
    var nbytes = 0;

    for(var i=0; i<message.length; i++) {
        var ch = message.charAt(i);

        if(escape(ch).length > 4) {
            nbytes += 2;
        } else if(ch == '\n') {
            if(message.charAt(i-1) != '\r') {
                nbytes += 1;
            }
        } else if (ch == '<' || ch == '>') {
            nbytes += 4;
        } else {
            nbytes += 1;
        }
    }

    return nbytes;
}

/**
 * 텍스트박스 글자byte 체크
 * @param form
 * @param objId
 * @param limit
 * @param msg
 * @param evt1
 * @param evt2
 * ex> (<span id="박스id_TXTCNT" >0</span>/제한길이Byte)
 */
fintech.common.txtAreaLmtChk = function (form, objId, limit, msg, evt1, evt2) {
	if (evt1 == undefined){
		evt1 = true;
	} else if (evt1 == false) {
		evt1 = false;
	} else {
		evt1 = true;
	}
	if (evt2 == undefined){
		evt2 = true;
	} else if (evt2 == false) {
		evt2 = false;
	} else {
		evt2 = true;
	}
	if (msg == undefined || msg == ""){
		msg = "Byte 내로 입력해주십시오.";
	}
	var areaObj = $(form).find("#"+objId);
	var tmpVal = "";
	if (evt1 == true) {
		$(areaObj).bind("keyup", function(e) {
			if(fintech.common.getByteLength($(this).val()) > limit){
				alert(limit+msg);	
				this.value = tmpVal;
			} else {
				$("#"+objId+"_TXTCNT").html(fintech.common.getByteLength($(this).val()));
				tmpVal = $(this).val();
			}
			
		});
	}
}

/**
 * IP 유효성 체크
 * @param param
 * @returns {Boolean}
 * ex> fintechc.common.ipChk("1.23.245.111");
 */
fintech.common.ipChk = function( param ) {
	//var ipChkFn = /^(1|2)?\d?\d([.](1|2)?\d?\d){3}$/;
	//return ipChkFn.test(param)
	var rtn = true;
	if (fintech.common.null2void(param) == "") {
		rtn = false;
		return rtn;
	}
	var tmpIpList = param.split(".");
	if (tmpIpList.length != 4) {
		rtn = false;
		return rtn;
	}
	$.each(tmpIpList, function(i, v){
		if (Number(v) > 255) {
			rtn = false;
		}
	});
	return rtn
};
/**
 * MAC address 유효성 체크
 * @param param
 * @returns
 */
fintech.common.macChk = function( param ) {
	if (fintech.common.null2void(param) == "") {
		return false;
	}
	if (param.length != 12) {
		return false;
	}
	//var macChkFn = /^([0-9A-F]{2}[:-]?){5}([0-9A-F]{2})$/;
	var macChkFn = /^([0-9A-F]{2}[:-]?){5}([0-9A-F]{2})$/;
	return macChkFn.test(param)
};
/**
 * 한글입력(자음모음조합 상관없이) 체크
 * @param param
 * @returns
 */
fintech.common.hanChk = function( param ) {
	var hanChkFn = /[가-힣]/;
	return hanChkFn.test(param)
};
/**
 * 한글만입력(자음모음조합만 가능) 체크
 * @param param
 * @returns {Boolean}
 */
fintech.common.onlyHanChk = function(param) {
	var n = fintech.common.null2void(param);
    var vAsc = "";
	for (var i=0;i<n.length;i++) {
        vAsc = n.charCodeAt(i);
        // 한글허용
        if (((vAsc > 44031 ) && (vAsc < 55198)) || (vAsc == 8 ) || (vAsc == 9 ) || (vAsc == 229 ) || (vAsc == 16 )){
        }else{
            return false;
        }
    }
    return true;
}
/**
 * 한글 개별자음,모음 허용불가 체크
 * @param param
 * @returns {Boolean}
 */
fintech.common.hanFullChk = function(param) {
	var n = fintech.common.null2void(param);
    var vAsc = "";
	for (var i=0;i<n.length;i++) {
        vAsc = n.charCodeAt(i);
        // 자음, 모음 외 모두 허용
        if (((vAsc > 12592) && (vAsc < 12644))){
            return false;
        }
    }
	return true;
}
/**
 * 한글입력 체크(키코드값으로 체크)
 * @param param
 * @returns {Boolean}
 */
fintech.common.keyCodeHanChk = function( param ) {
	var vAsc = param;
	if (((vAsc > 44031 ) && (vAsc < 55198)) || (vAsc == 8 ) || (vAsc == 9 ) || (vAsc == 229 ) || (vAsc == 16 )){
		return true;
    }else{
    	return false;
    }
};
/**
 * 전화번호 유효성 체크
 * @param param
 * @returns
 */
fintech.common.telNoChk = function( param ) {
	var telNoChk = /^(01[016789]{1}|02|0[3-9]{1})-?[0-9]{3,4}-?[0-9]{4}$/;
	return telNoChk.test(param)
};
/**
 * 전화번호용 레이어
 * @param msg
 * @param obj
 * @param layerId
 * @param pos
 */
fintech.common.phoneLayer = function(msg, obj, layerId, pos) {
	var html = "";
	html += '<div class="layertype1" id="' + layerId + '" style="top:-36px;left:743px;width:100px;">';
	html += '	<div class="toptail_layer">';
	html += '		<span class="tail2" style="left:40px;"></span>';
	html += '		<div style="padding:8px 9px 9px 9px;line-height:18px;">';
	html += '			<p style="font-size:11px;color:#555;">' + msg + '</p>';
	html += '		</div>';
	html += '	</div>';
	html += '</div>';
	$("body").append(html);
	fintech.common.moveLayer($(obj), $("#" + layerId), pos);
}

/**
 * @param format
 *            조합 가능한 Format.. yy,yyyy : 년도 mm : 월 dd : 일 hh : 시 hh24 : 0시~23시 mi :
 *            분 ss : 초 EEE : 요일(화)
 * @param c
 *            기준 Flag('Y':년,'M':월,'W':주,'D'일)
 * @param i
 *            가감 계산값
 * @param sdate
 *            yyyymmdd를 가진 날짜 문자열
 * 
 * 예) 현재날짜 : fintech.common.getDate("yyyy-mm-dd") 현재날짜시분초까지 구하기 :
 * fintech.common.getDate("yyyy-mm-dd hh24:mi:ss") 현재날짜,요일가져오기 :
 * fintech.common.getDate("yyyy-mm-dd EEE") 현재에서 한달전 날짜 구하기 :
 * fintech.common.getDate("yyyy-mm-dd", "M", -1)
 */
fintech.common.getDate = function(format, c, i, sdate) {
	var currentDate;
	if (sdate) {
		currentDate = new Date(formatter.datetime(sdate, "yyyy"), parseInt(
				formatter.datetime(sdate, "mm"), 10), formatter.datetime(sdate,
				"dd"));
	} else {
		currentDate = new Date();
	}

	var _tmpDate;
	if (fintech.common.null2void(c) != "") {
		switch (c.toUpperCase()) {
		case "Y":
			_tmpDate = new Date(currentDate.getFullYear() + i, currentDate
					.getMonth(), currentDate.getDate());
			break;

		case "M":
			_tmpDate = new Date(currentDate.getFullYear(), currentDate
					.getMonth()
					+ i, 1);

			// beforeDate의 마지막 날짜가, 조회종료일자조건의 선택되어있는값보다 작으면
			// beforeDate의 마지막 날짜로 설정한다.
			var lastDate = fintech.common.getLastDate(_tmpDate.getFullYear(),
					_tmpDate.getMonth() + 1);
			if (lastDate < currentDate.getDate()) {
				_tmpDate.setDate(lastDate);
			} else {
				_tmpDate.setDate(currentDate.getDate());
			}

			break;

		case "W":
			_tmpDate = new Date(currentDate.getFullYear(), currentDate
					.getMonth(), currentDate.getDate() + (i * 7));
			break;

		case "D":
			_tmpDate = new Date(currentDate.getFullYear(), currentDate
					.getMonth(), currentDate.getDate() - i);
			// _tmpDate = new Date(currentDate.getFullYear(),
			// currentDate.getMonth()-1, currentDate.getDate()-i);
			break;

		default:
			alert("없는 기준 Flag입니다.(" + c + ")");
			return false;
			break;
		}
		currentDate = _tmpDate;
	}
	var year = String(currentDate.getFullYear());

	var month = currentDate.getMonth();
	month = month + 1 < 10 ? "0" + String(month + 1) : String(month + 1);

	var date = currentDate.getDate();
	date = date < 10 ? "0" + String(date) : String(date);

	var weekstr = '일월화수목금토'; // 요일 스트링

	var day = weekstr.substr(currentDate.getDay(), 1);

	var hours = currentDate.getHours();
	hours = hours < 10 ? "0" + String(hours) : String(hours);

	var minutes = currentDate.getMinutes();
	minutes = minutes < 10 ? "0" + String(minutes) : String(minutes);

	var seconds = currentDate.getSeconds();
	seconds = seconds < 10 ? "0" + String(seconds) : String(seconds);

	return formatter.datetime(year + month + date + hours + minutes + seconds,
			format);
};

function getDate(a) {
	return getDate(getToday("d"), a);
}
function getDate(a, b) {
	var date;
	var pattern;
	date = a;
	pattern = b;

	var yyyy, mm, dd, hh, mi, ss, ms;
	if (date.length < 8) {
		return "잘못된 입력";
	}
	yyyy = date.substr(0, 4);
	mm = date.substr(4, 2);
	dd = date.substr(6, 2);
	if (date.length >= 14) {
		try {
			hh = date.substr(8, 2);
			mi = date.substr(10, 2);
			ss = date.substr(12, 2);
			ms = date.substr(14, 3);
		} catch (e) {
			hh = (_jex.getInstance().isNull(hh)) ? "" : hh;
			mi = (_jex.getInstance().isNull(mi)) ? "" : mi;
			ss = (_jex.getInstance().isNull(ss)) ? "" : ss;
			ms = (_jex.getInstance().isNull(ms)) ? "" : ms;
		}
	} else {
		hh = mi = ss = ms = "";
	}
	return pattern.replace(/yyyy/, yyyy).replace(/mm/, mm).replace(/dd/, dd)
			.replace(/hh/, hh).replace(/mi/, mi).replace(/ss/, ss).replace(
					/ms/, ms);
}

fintech.common.formatDate = function(param) {
	if (!param)
		return "";

	var result = getDate(param, 'yyyy-mm-dd');

	return result;
};

fintech.common.formatDtm = function(param) {
	
	if (!param)
		return "";
	var result = "";
	if (param.length == 8)
		result = getDate(param, 'yyyy-mm-dd');
	else if (param.length == 14)
		result = getDate(param, 'yyyy-mm-dd hh:mi:ss');
	else
		result = param;
	return result;
};

// ------RKV ------------
//우편번호 조회 팝업
function openPopPost(CALLBACK_PAGE) {
	fintech.common
			.winPop(
					"frm",
					{
						"sizeW" : "740",
						"sizeH" : "630",
						"action" : "https://platform.bizplay.co.kr/post_0002_01.act?POST_CALLBACK_PAGE="
								+ CALLBACK_PAGE,
						"target" : "CoopSearch"
					});
}

// End RKV

fintech.common.winPop = function(formId, options) {
	var sizeW = parseInt(options.sizeW, 10);
	var sizeH = parseInt(options.sizeH, 10);
	var nLeft = screen.width / 2 - sizeW / 2;
	var nTop = screen.height / 2 - sizeH / 2;
	var option = ",toolbar=no,menubar=no,location=no,scrollbars=yes,status=no";
	if (options.resize == undefined || options.resize == null) {
		option += ",resizable=yes";
	} else {
		option += ",resizable=" + options.resize;
	}
	var frm = document.getElementById(formId);
	var winObj;
	if (!!frm) {
		winObj = window.open('', options.target, "left=" + nLeft + ",top="
				+ nTop + ",width=" + sizeW + ",height=" + sizeH + option);
	} else {
		winObj = window.open(options.action, options.target, "left=" + nLeft
			+ ",top=" + nTop + ",width=" + sizeW + ",height=" + sizeH
			+ option);
	}

	try {
		winObj.blur();// 크롭에서 focus()만 호출할경우 작동하지 않아서 blur()를 먼저 호출한후
		// focus()호출하도록 수정함.
		winObj.focus();// 팝업이 이미 열려있는경우 앞으로 나오도록 한다.
	} catch (e) {
	}

	if (!!frm) {
		frm.method = "post";
		frm.target = options.target;

		if (!!options.action)
			frm.action = options.action;

		frm.submit();
	}
};

// ----------end RKV -----------

