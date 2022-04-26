var avatar;
if(!avatar) avatar={};
if(!avatar.common) avatar.common={};

avatar.common.pageMove = function(url, data){
	var form = $('<form></form>').submit(function () {
		if(data != null && data != undefined ){
			$.each(data,function(key, value){
				$("<input>").attr({
					'type':'hidden',
					'name':key
				}).val(value).appendTo(form);
			});
		}
	});
	form.attr('action', url);
    form.attr('method', 'post');
	form.appendTo('body');
	form.submit();
	
}
avatar.common.gapReturn = function (iStr) {
	var i = parseInt(iStr)
	var str = "";
	for (var j = 0; j < i; j++) {
		str += "0";
	}
	return str;
}
//날짜형식 (YYYY-MM-DD)
avatar.common.date_format = function(str) {
    if (avatar.common.null2void(str) == "")  return str;
	return str.replace(/(\d{4})(\d{2})(\d{2})/, "$1-$2-$3");
};
//날짜형식 (YYYY-MM-DD)
avatar.common.date_format2 = function(str) {
    if (avatar.common.null2void(str) == "")  return str;
	return str.replace(/(\d{4})(\d{2})(\d{2})/, "$1.$2.$3");
};
// 시간형식 (HH : MM)
avatar.common.time_format = function(str) {
	return str.substring(0, 4).replace(/(\d{2})(\d{2})/, "$1:$2");
};
// 시간형식 (HH : MM : SS)
avatar.common.time_format2 = function(str) {
	return str.substring(0, 6).replace(/(\d{2})(\d{2})(\d{2})/, "$1:$2:$3");
};
// 날짜 + 시간 형식 (YYYY-MM-DD HH:mm)
avatar.common.datetime_format = function(str) {
	if (avatar.common.null2void(str) == "")  return str;
    return str.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, "$1-$2-$3 $4:$5");
};
// 날짜 + 시간 형식 (YYYY-MM-DD HH:mm:ss)
avatar.common.datetime_format2 = function(str) {
	if (avatar.common.null2void(str) == "")  return str;
    return str.replace(/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, "$1-$2-$3 $4:$5:$6");
};
// 사업자번호형식
avatar.common.corpno_format = function(str) {
	return str.replace(/(\d{3})(\d{2})(\d{5})/, "$1-$2-$3");
};
// 핸드폰형식
avatar.common.phoneFomatter = function(num,type) {
	var formatNum = '';

	if(num.length==11){
		if(type==0){
			formatNum = num.replace(/(\d{3})(\d{4})(\d{4})/, '$1-****-$3');
		}else{
			formatNum = num.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
		}
	}else if(num.length==8){
		formatNum = num.replace(/(\d{4})(\d{4})/, '$1-$2');
	}else{
		if(num.indexOf('02')==0){
			if(type==0){
				formatNum = num.replace(/(\d{2})(\d{4})(\d{4})/, '$1-****-$3');
			}else{
				formatNum = num.replace(/(\d{2})(\d{4})(\d{4})/, '$1-$2-$3');
			}
		}else{
			if(type==0){
				formatNum = num.replace(/(\d{3})(\d{3})(\d{4})/, '$1-***-$3');
			}else{
				formatNum = num.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
			}
		}
	}
	return formatNum;
};
// 카드 MASK 형식
avatar.common.formatCardNumberStar = function(foo) {
	var bar;

	if(foo.length == 16) {
		bar = foo.substr(0, 4) + "-" + foo.substr(4, 4) + "-" + "****" + "-" + foo.substr(12, 4);
	}
	else if(foo.length == 15) {
		bar = foo.substr(0, 4) + "-" + foo.substr(4, 4) + "-" + "****" + "-" + foo.substr(12, 3);
	}
	else if(foo.length == 14) {
		bar = foo.substr(0, 4) + "-" + foo.substr(4, 6) + "-" + "****";
	}else{
		bar = foo;
	}
	
	return bar;
};
// 카드번호
avatar.common.formatCardNumber = function(foo) {
	// 9430030192869921 카드번호로 parseInt 버그 있음...
	// return gw.number.format(str, "####-####-####-####");
	var bar;

	if(foo.length == 16) {
		bar = foo.substr(0, 4) + "-" + foo.substr(4, 4) + "-" + foo.substr(8, 4) + "-" + foo.substr(12, 4);
	}
	else if(foo.length == 15) {
		bar = foo.substr(0, 4) + "-" + foo.substr(4, 6) + "-" + foo.substr(10, 5);
	}
	else if(foo.length == 14) {
		bar = foo.substr(0, 4) + "-" + foo.substr(4, 6) + "-" + foo.substr(10, 4);
	}else{
		bar = foo;
	}
	
	return bar;
};
// 콤마찍기 (trunc : ture 소수점 버리기, false 소수점 유지)
avatar.common.comma = function(dat, trunc) {
	if(typeof dat == "number")  dat = String(dat);
    if(dat == null || dat == undefined || dat == "" || isNaN(dat)) return "0";

    if(trunc == null || trunc == undefined || trunc == true) dat = dat.split(".")[0]; //소수점버리기
    
    var reg = /(^[+-]?\d+)(\d{3})/;                 // 정규식(3자리마다 ,를 붙임)
    dat += '';                                      // ,를 찍기 위해 숫자를 문자열로 변환
    while (reg.test(dat)) {                          // dat값의 첫째자리부터 마지막자리까지
        dat = dat.replace(reg, '$1' + ',' + '$2');  // 인자로 받은 dat 값을 ,가 찍힌 값으로 변환시킴
    }

    return dat;                                     // 바뀐 dat 값을 반환.
};
// 콤마풀기
avatar.common.uncomma = function(str) {
    str = String(str);
    if(str.substring(0,1)=="-"){															// 음수이면
        return "-" + str.replace(/[^\d]+/g, '').replace(/^0/g, '');
	}else{
        return str.replace(/[^\d]+/g, '').replace(/^0/g, '');
	}
};
// 이메일 유효성 검사
avatar.common.emailChk = function(email){
    var regex = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
    if(regex.test(email)==false){
    	return false;
    }else{
    	return true;
	}
};
//null to void
avatar.common.null2void = function(str) {
	if(str === null || str === "null" || str === undefined) str = '';
	return str;
};
//null to zero
avatar.common.null2zero = function(str) {
	if(str == null) str = '0';
	if(str == "") str = '0';
	if(isNaN(str.toString().replace(/,/g, ""))) str = '0';
	return str;
};
// zero to void
avatar.common.zero2void = function (str) {
    if(str == 0) str = '';
    return str;
};
// 사업자번호 검증
avatar.common.isCorpNo = function (corpNo) {
    // corpNo 숫자만 10자리로 해서 문자열로 넘긴다.
    var checkID = new Array(1, 3, 7, 1, 3, 7, 1, 3, 5, 1);
    var tmpCorpNo, i, chkSum=0, c2, remander;
    corpNo = corpNo.replace(/-/gi,'');

    for (i=0; i<=7; i++) chkSum += checkID[i] * corpNo.charAt(i);
    c2 = "0" + (checkID[8] * corpNo.charAt(8));
    c2 = c2.substring(c2.length - 2, c2.length);
    chkSum += Math.floor(c2.charAt(0)) + Math.floor(c2.charAt(1));
    remander = (10 - (chkSum % 10)) % 10 ;

    if (Math.floor(corpNo.charAt(9)) == remander) return true ; // OK!
    return false;
};
//오늘 날짜 YYYY-MM-DD형식
avatar.common.getToday = function(){
	var _date	= new Date();
	var d		= _date.getDate();
	var day		= (d < 10) ? '0' + d : d;
	var m		= _date.getMonth() + 1;
	var month	= (m < 10) ? '0' + m : m;
	var yy		= _date.getYear();
	var year	= (yy < 1000) ? yy + 1900 : yy;

	var hh0		= _date.getHours();
	var hh		= (hh0<10)?'0'+hh0:hh0;
	var mi0		= _date.getMinutes();
	var mi		= (mi0<10)?'0'+mi0:mi0;
	var ss0		= _date.getSeconds();
	var ss		= (ss0<10)?'0'+ss0:ss0;

	var ms0		= _date.getMilliseconds();
	var ms		= (ms0<10)?'000'+ms0:(ms0<100)?'00'+ms0:(ms0<100)?'0'+ms0:ms0;

	return year+"-"+month+"-"+day;
};
//자동 콤마
avatar.common.numberWithCommas = function(str) {
	var regex=/^[-]?\d*$/g
	if(regex.test(x.toString())){
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}else{
		if(x.toString().substring(0,1)=='-'){
			return '-' + x.toString().replace(/-/g,'').replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}else{
			return x.toString().replace(/-/g,'').replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
		
	}
};
//입력받은 메세지의 길이를 바이트로 계산하여 리턴한다.
avatar.common.getByteLength = function(message){
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
 * jexajax
 * @param actId 액션명(ex.test_0001_01_r001)
 * @param param	파라미터 {}형식 or ""
 * @param callbackFn 콜백함수
 * @param async true or false or 호출 x
 * @param log c=콘솔,a=얼럿
 */
avatar.common.callJexAjax = function(actId,param,callbackFn,async,log){
	var resultData;
	if(!async || typeof(async)!="boolean") async=true;
	
	var jexAjax = jex.createAjaxUtil(actId);
	if(!avatar.common.isEmpty(param)){
		jexAjax.set(param);
	}
	jexAjax.setAsync(async);
	jexAjax.execute(function(data) {
		if(!avatar.common.isEmpty(log)){
			if("c"==log){
				console.log(actId+"\ninput  ::"+JSON.stringify(param));
				console.log("result  ::"+JSON.stringify(data));
			} else if("a"==log){
				alert(actId+"\ninput  ::"+JSON.stringify(param) +"\n"+"result  ::"+JSON.stringify(data));
			}
		}
		if(avatar.common.isEmpty(data)){
			resultData = {};
			resultData.RSLT_CD="9999";
			resultData.RSLT_MSG="처리중 오류가 발생하였습니다.";
		} else {
			resultData=data;
		}
		if($.isFunction(callbackFn)){
			callbackFn(resultData);
		}
	}); 
}
//빈 객체 검증
avatar.common.isEmpty = function(pValue) {
	if(avatar.common.null2void(String(pValue)).trim() == "") {
        return true;
    }
    return false;
}
//모바일 input type=number 에서 maxlength가 동작하지 않을때 직접 자르기 
avatar.common.numInpCheck = function(object){
	if (object.value.length >= object.maxLength){ 
		object.value = object.value.slice(0, object.maxLength);
	}
	$(object).val($(object).val().replace(/[^0-9]/g,""));
}
//숨기기,보이기
avatar.common.showHide = function (obj) {
	if(obj.css("display")=="none"){
		obj.show();
	} else {
		obj.hide();
	}
}

avatar.common.getDate = function(format, c, i, sdate) {
	var currentDate;
	if (sdate) {
		currentDate = new Date(formatter.datetime(sdate, "yyyy"), parseInt(
				formatter.datetime(sdate, "mm"), 10), formatter.datetime(sdate,
				"dd"));
	} else {
		currentDate = new Date();
	}

	var _tmpDate;
	if (avatar.common.null2void(c) != "") {
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
			var lastDate = avatar.common.getLastDate(_tmpDate.getFullYear(),
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
					.getMonth(), currentDate.getDate() + i);
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
avatar.common.getLastDate = function(yyyy, mm)
{
	if( yyyy==undefined || String(yyyy).length!=4 || mm==undefined || String(mm).length>2 )
		return 0;
	else
		return new Date(new Date(yyyy, mm, '1')-(60*60*24*1000)).getDate();
};
/*
 * 월,일 날짜 구하기
 * str = 날짜
 * i = i주전
 */
avatar.common.fn_getWeek = function(str, i){
	var value=[];
	var formatDate=function(date){
		var _month = date.getMonth()+1;
		var _weekDay = date.getDate();
		
		var addZero = function(num){
			if(num<10)	num = "0"+num;
			return num;
		}
		var _date = addZero(_month) + addZero(_weekDay);
		return _date;
	}
	var date = parseDate(str);
	var dayOfWeek = date.getDay();
	var day = date.getDate();
	var month = date.getMonth();
	var year = date.getYear();
	year += (year<2000) ? 1900 : 0;
	var weekStartDt = new Date(year, month, day-dayOfWeek+1-(i*7));
	var weekEndDt = new Date(year, month, day+(7-dayOfWeek)-(i*7));
	value.push(year+formatDate(weekStartDt));
	value.push(year+formatDate(weekEndDt));
	
	return value;
}
