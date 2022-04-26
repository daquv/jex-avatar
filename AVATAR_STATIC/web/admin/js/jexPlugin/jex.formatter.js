/**
 * Formatter를 정의합니다.
 */
var formatter = new (Class.extend({
    init : function()
    {
    
    }
    ,
    /**
     * 금액 포매팅
     */
    number : function(dat) {
        if(typeof dat == "number")  dat = String(dat);
        if(dat == null || dat == undefined || dat == "" || isNaN(dat)) return "";

        var reg = /(^[+-]?\d+)(\d{3})/;                 // 정규식(3자리마다 ,를 붙임)
        dat += '';                                      // ,를 찍기 위해 숫자를 문자열로 변환
        while (reg.test(dat)) {                          // dat값의 첫째자리부터 마지막자리까지
            dat = dat.replace(reg, '$1' + ',' + '$2');  // 인자로 받은 dat 값을 ,가 찍힌 값으로 변환시킴
        }

        return dat;                                     // 바뀐 dat 값을 반환.
    }
    ,
    /**
     * 날짜형식 포매팅
     */
    date : function(dat) {
        if(dat == null || dat == undefined || dat == "undefined" || dat == "null") {
        	return "";
        } else {
        	if($.trim(dat).length == 6) {
        		dat = dat.substring(0,4)+"-"+dat.substring(4,6);
        	} else if($.trim(dat).length == 8) {
        		dat = dat.substring(0,4)+"-"+dat.substring(4,6)+"-"+dat.substring(6,8);
        	} else if($.trim(dat).length > 8 && $.trim(dat).length < 15){
        		dat = dat.substring(0,4)+"-"+dat.substring(4,6)+"-"+dat.substring(6,8);
        	}
        }

        return dat;
    }
    ,
    /**
     * "hhmmdd" 형식의 문자열을 "hh:mm:dd"로 포매팅한다.
     */
    time : function(dat) {
        if(dat == null || dat == undefined || dat == "null" || dat == "undefined") {
        	return "";
        } else {
        	if($.trim(dat).length == 4) {
        		dat = dat.substring(0,2)+":"+dat.substring(2,4);
        	} else if($.trim(dat).length == 6) {
        		dat = dat.substring(0,2)+":"+dat.substring(2,4)+":"+dat.substring(4,6);
        	}
        }
        return dat;
    }
    ,
    /**
     * "yyyymmddhhmmdd" 형식의 문자열을 "hh:mm:dd"로 포매팅한다.
     */
    yyyymmddtime : function(dat) {
        if(dat == null || dat == undefined || dat == "null" || dat == "undefined") {
        	return "";
        } else {
        	if($.trim(dat).length == 14) {
        		dat = dat.substring(8,14);	
        	}        	
        	if($.trim(dat).length == 4) {
        		dat = dat.substring(0,2)+":"+dat.substring(2,4);
        	} else if($.trim(dat).length == 6) {
        		dat = dat.substring(0,2)+":"+dat.substring(2,4)+":"+dat.substring(4,6);
        	}
        }
        return dat;
    }
    ,
    /**
     * 날짜+시간
     */
    datetime : function(date, format) {
        if(format == null || format == undefined) {
        	format = "yyyy-mm-dd hh24:mi:ss";
        }

        if(date == null || date == undefined || date == "null" || date == "undefined") {
        	return fintech.common.null2void(date);
        }

        // 이미 포맷팅 되어있는값을 삭제한다.
        date = date.replace(/[^0-9]/g,"");

        // 입력된 날짜의 길이가 포맷팅되어야 하는 길이보다 작으면 뒤에 0을 붙인다.
        var formatLength = format.replace(/[^a-z]/g, "").length;
        var dateLength = date.length;
        for(var i=0 ; i<formatLength-dateLength ; i++){
            date += '0';
        }

        if(format.replace(/[^a-z]/g, "")=="hhmiss" && date.length==6)
        {
            date = "00000000"+date;
        }

        var idx = format.indexOf("yyyy");
        if( idx > -1 ){
            format = format.replace("yyyy", date.substring(0,4));
        }
        idx = format.indexOf("yy");
        if( idx > -1 ){
            format = format.replace("yy", date.substring(2,4));
        }
        idx = format.indexOf("mm");
        if( idx > -1 ){
            format = format.replace("mm", date.substring(4,6));
        }
        idx = format.indexOf("dd");
        if( idx > -1 ){
            format = format.replace("dd", date.substring(6,8));
        }
        idx = format.indexOf("hh24");
        if( idx > -1 ){
            format = format.replace("hh24", date.substring(8,10));
        }
        idx = format.indexOf("hh");
        if( idx > -1 ){
            var hours = date.substring(8,10);
            hours = parseInt(hours,10)<=12?hours:"0"+String(parseInt(hours,10)-12);
            format = format.replace("hh", hours);
        }
        idx = format.indexOf("mi");
        if( idx > -1 ){
            format = format.replace("mi", date.substring(10, 12));
        }
        idx = format.indexOf("ss");
        if( idx > -1 ){
            format = format.replace("ss", date.substring(12));
        }
        idx = format.indexOf("EEE");
        if( idx > -1 ){
            var weekstr='일월화수목금토'; // 요일 스트링

            var day = weekstr.substr(new Date(date.substring(0,4), new Number(date.substring(4,6))-1, date.substring(6,8)).getDay(), 1);
            format = format.replace("EEE", day);
        }

        return format;
    }
    ,
    /**
     * 계좌번호 포맷팅
     * 사용예) formatter.account( "0123456789" , [3,3,4]) ==>결과 : "012-345-6789"
     */
    account : function(dat, arg) {
        if(!dat) return dat;
    
		if(dat == "undefined"){
			return "";
		}

        //arg가 없을때 기본포맷을 설정하고자 할 경우, 여기에서 arg에 기본포맷을 할당하면됨
        //예)if(!arg||!arg.length) arg=[3,3,4];
		
		/*if(dat.length == 11) {
            arg = [3,2,6];
        }
        else if(dat.length == 12) {
            arg = [4,2,6];
        }
        else if(dat.length == 13) {
            arg = [3,4,4,3];
        }
        else if(dat.length == 15) {
            arg = [6,3,6];
        }*/
		
		if(dat.length == 13) {
            arg = [3,4,4,2];
        }else if(dat.length == 14){
        	arg = [6,2,6];
        }else if(dat.length == 17){
        	arg = [7,3,7];
        }
		
        if(!arg||!arg.length) return dat;



        if(typeof dat == "number") {
        	dat = String(dat);
        } else if(/[^0-9]/g.test(dat)) {
            dat = dat.replace(/[^0-9]/g, "");
        }

        var rArr = [];
        var startIdx = 0;
        for(var i=0 ; i<arg.length ; i++) {
            if( !!dat.substr(startIdx, arg[i]) ) {
            	rArr.push(dat.substr(startIdx, arg[i]));
            }

            startIdx += arg[i];
        }

        if( !!dat.substr(startIdx) ) {
            rArr.push( dat.substr(startIdx) );
        }

        var result = "";
        for(var i=0 ; i<rArr.length ; i++) {
            if(i==0) result = rArr[i];
            else     result += "-"+rArr[i];
        }

        return result;
    }
    ,
    /**
     * 1234567.908의 숫자를 "12,345,67.908"형식으로 포매팅한다.
     */
    currency : function(dat) {
        if(typeof dat == "number")  dat = String(dat);

        if(jex.isNull(dat)) dat = "0";

        var reg = /(^[+-]?\d+)(\d{3})/;                 // 정규식(3자리마다 ,를 붙임)
        dat += '';                                      // ,를 찍기 위해 숫자를 문자열로 변환
        while (reg.test(dat))                           // dat값의 첫째자리부터 마지막자리까지
            dat = dat.replace(reg, '$1' + ',' + '$2');  // 인자로 받은 dat 값을 ,가 찍힌 값으로 변환시킴

        return dat + "원";                                  // 바뀐 dat 값을 반환.
    }
    ,
    /**
     * 1234567.908의 숫자를 "12,345,67.908%"형식으로 포매팅한다.
     */
    percent : function(dat) {
        if(typeof dat == "number")  dat = String(dat);

        var reg = /(^[+-]?\d+)(\d{3})/;                 // 정규식(3자리마다 ,를 붙임)
        dat += '';                                      // ,를 찍기 위해 숫자를 문자열로 변환
        while (reg.test(dat)) {                         // dat값의 첫째자리부터 마지막자리까지
            dat = dat.replace(reg, '$1' + ',' + '$2');  // 인자로 받은 dat 값을 ,가 찍힌 값으로 변환시킴
        }

        return dat + "%";                               // 바뀐 dat 값을 반환.
    }
    ,
    /**
     * 사업자 번호 포맷팅
     */
    corpNum : function(dat){
        if(!dat) return dat;

        if(typeof dat == "number")
            dat = String(dat);
        else if(/[^0-9]/g.test(dat))
            dat = dat.replace(/[^0-9]/g, "");

        if(dat.length == 10){
            dat = dat.substring(0,3)+"-"+dat.substring(3,5)+"-"+dat.substring(5,10);
        }
        return dat;
    }
    ,
    /**
     * 카드번호 포매팅
     */
    card : function(foo){
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
    },
    /**
     * 카드번호 포매팅 & 마스킹
     */
    maskCard : function(foo){
        var bar;

        if(foo.length == 16) {
            bar = foo.substr(0, 4) + "-****-****-" + foo.substr(12, 4);
        } else {
        	bar = foo;
        }

        return bar;
    }
    ,
    /**
     * 전화번호 포매팅
     */
    phone : function(dat) {
        if(dat == null || dat == undefined || dat == "" || dat == "undefined") {
            return "";
        } else {
            dat = $.trim(dat);
        }
        return dat.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
    },
    /**
     * 전화번호 포매팅 & 마스킹
     */
    maskPhone : function(dat) {
        if(dat == null || dat == undefined || dat == "" || dat == "undefined") {
            return "";
        } else {
            dat = $.trim(dat);
        }
        dat = dat.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
        if (dat.split("-")[1] != undefined && dat.split("-")[1].length == 3) {
        	dat = dat.replace(dat.split("-")[1], "***");
        } else if (dat.split("-")[1] != undefined && dat.split("-")[1].length == 4) {
        	dat = dat.replace(dat.split("-")[1], "****");
        }
        return dat;
    }
    ,
    /**
     * 우편번호
     */
    post : function(dat) {
    	if(dat == null || dat == undefined || dat == "") {
            return "";
        } else {
            dat = $.trim(dat);
        }
    	if(dat.length == 6) return dat.substring(0,3) + "-" + dat.substring(3);
    	else return dat;
    }
    ,
    /**
     * 법인번호
     */
    corpNo : function(dat) {
        if(dat == null || dat == undefined || dat == "" || dat == "undefined") {
            return "";
        } else {
            dat = $.trim(dat);
        }
        if(dat.length == 10) {
        	return dat.substring(0,5) + "-" + dat.substring(5);
        } else if (dat.length == 13) {
        	return dat.substring(0,6) + "-" + dat.substring(6);
        } else {
        	return dat;
        }
    },
    date_kr : function(date){
    	var year = date.substr(0,4)+"년 ";
    	var month = date.substr(4,2)+"월 ";
    	var day = date.substr(6,2)+"일 ";
    	
    	if(!date.substr(6,2)){
    		if(!date.substr(4,2))	date_kr = year;
    	    else	date_kr = year+month;
    	} else { date_kr = year+month+day; }
    	return date_kr;
    }
    
}))();