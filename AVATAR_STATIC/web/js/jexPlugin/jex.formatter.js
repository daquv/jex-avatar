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
    number : function(dat, trunc) {
        if(typeof dat == "number")  dat = String(dat);
        if(dat == null || dat == undefined || dat == "" || isNaN(dat)) return dat;

        if(trunc == null || trunc == undefined || trunc == true) dat = dat.split(".")[0]; //소수점버리기
        
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
    	if(typeof(dat)!='string')
    		dat = dat+'';
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
        date = String(date).replace(/[^0-9]/g,"");

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
     * 1234567.908의 숫자를 "12,345,67.908"형식으로 포매팅한다.
     */
    point : function(dat) {
        if(typeof dat == "number")  dat = String(dat);

        var reg = /(^[+-]?\d+)(\d{3})/;                 // 정규식(3자리마다 ,를 붙임)
        dat += '';                                      // ,를 찍기 위해 숫자를 문자열로 변환
        while (reg.test(dat)) {                         // dat값의 첫째자리부터 마지막자리까지
            dat = dat.replace(reg, '$1' + ',' + '$2');  // 인자로 받은 dat 값을 ,가 찍힌 값으로 변환시킴
        }

        return dat;                               // 바뀐 dat 값을 반환.
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
        	 bar = foo.substr(0, 4) + "-" + foo.substr(4, 4) + "-****-" + foo.substr(12, 4);
        } else {
        	bar = foo;
        }

        return bar;
    }
    ,
    /**
     * 카드번호 포매팅 & 마스킹
     */
    maskCard2 : function(foo){
        var bar;
        if(foo == null || foo == undefined || foo == "" || foo == "undefined") {
        	bar = "";
        } else {
        	bar = "("+foo.substring(foo.length-4)+")"
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
        
        if(dat.length==8){
        	return dat.replace(/(\d{4})(\d{4})/, '$1-$2');
    	} else {
    		return dat.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");    		
    	}
    },
    phone2: function(dat){
		var rtel = [];
		var tel = "";
		
		if(dat == null || dat == undefined || dat == "" || dat == "undefined") {
            return "";
        } else {
        	dat = $.trim(dat);
			tel = dat.split("-").join("");
			
			if( tel.length == 9 ) {
				rtel[0] = tel.substring(0,2);
				rtel[1] = tel.substring(2,5);
				rtel[2] = tel.substring(5,9);
				tel = rtel[0] + "-" + rtel[1] + "-" + rtel[2];
			} else if( tel.length == 10 ) {
				if( tel.substring(0,2) == '02' ) {
					rtel[0] = tel.substring(0,2); 
					rtel[1] = tel.substring(2,6); 
					rtel[2] = tel.substring(6,10);
				} else {
					rtel[0] = tel.substring(0,3); 
					rtel[1] = tel.substring(3,6);
					rtel[2] = tel.substring(6,10);
				}
				tel = rtel[0] + "-" + rtel[1] + "-" + rtel[2];
			} else if( tel.length == 11 ) {
				rtel[0] = tel.substring(0,3);
				rtel[1] = tel.substring(3,7);
				rtel[2] = tel.substring(7,11);
				tel = rtel[0] + "-" + rtel[1] + "-" + rtel[2];
			} else {
				rtel = tel;
			}
        }
		
		return tel;
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
        	var dat2 = dat.split("-");
        	dat2[1] = dat2[1].substring(0,1)+"**";
        	dat2[2] = "**"+dat2[2].substring(2);
        	dat = dat2.join("-");
        } else if (dat.split("-")[1] != undefined && dat.split("-")[1].length == 4) {
        	var dat2 = dat.split("-");
        	dat2[1] = dat2[1].substring(0,2)+"**";
        	dat2[2] = "**"+dat2[2].substring(2);
        	dat = dat2.join("-");
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
    }
    /**
     * 날짜 포맷팅 한글
     */
    ,
    datekr : function(date){
    	date = date+"";
    	if(date.length === 8){
    		var year = date.substr(0,4)+"년 ";
        	var month = date.substr(4,2)+"월 ";
        	var day = date.substr(6,2)+"일 ";
        	return year+month+day;
    	} else if(date.length === 6){
    		var year = date.substr(0,4)+"년 ";
        	var month = date.substr(4,2)+"월 ";
        	return year+month;
    	} else if (date.length === 4){
    		var month = date.substr(0,2)+"월 ";
        	var day = date.substr(2,4)+"일 ";
        	return month+day;
    	}
    	/*
    	
    	if(!date.substr(6,2)){
    		if(!date.substr(4,2))	date_kr = year;
    	    else	date_kr = year+month;
    	} else { date_kr = year+month+day; }
    	return date_kr;*/
    }
    ,
    /**
     * 큰 금액 포매팅
     * -1,000,000 초과 시 10,000 단위 이하 절삭 및 ‘만원’으로 표기
     *  예) 2,300,000 -> 230만원
     * -100,000,000 초과 시 1,000,000원 단위 이하 절삭 및 ‘억원＇으로 표기
     *  예) 563,600,000->5.63억원
     */
    bignumber : function(dat, trunc) {
        if(typeof dat == "number")  dat = String(dat);
        if(dat == null || dat == undefined || dat == "" || isNaN(dat)) return dat;

        if(trunc == null || trunc == undefined || trunc == true) dat = dat.split(".")[0]; //소수점버리기
        
        if(dat > 100000000){
        	return formatter.number(Math.floor(dat/1000000)/100, false)+'억';
        } else if((dat > 100000) && (dat <= 100000000)){
        	return formatter.number(Math.floor(dat/10000), false)+'만';
        } else {
        	return formatter.number(dat);
        }
    }
    ,
    /**
     * 만원 이하 절삭 
     * (천원 단위 반올림처리하여) 만원단위까지만 처리
     */
    bignumber2 : function(dat, trunc) {
    	if(dat.indexOf(',')>0) dat = dat.replace(/,/g, '');
    	var onlyNum = /^-?\d*\.?\d*$/;
    	if(!onlyNum.test(dat)){
    		return dat;
    	}
        if(typeof dat == "number")  dat = String(dat);
        if(dat == null || dat == undefined || dat == "" || isNaN(dat)) return dat;

        if(trunc == null || trunc == undefined || trunc == true) dat = dat.split(".")[0]; //소수점버리기
        
        if(Math.abs(dat) > 10000){
        	/*
        	var num = Math.round(dat/10000)+"";
        	// 1억단위
  	       	if(num.length == 5){
  	       		num = num.substring(0,1)+"억"+num.substring(1);
  	       	}
  	       	// 10단위
  	       	else if(num.length == 6){
  	       		num = num.substring(0,2)+"억"+num.substring(2);
  	       	}
  	       	// 100억
  	       	else if(num.length == 7){
  	       		num = num.substring(0,3)+"억"+num.substring(3);
  	       	}
  	       	// 1000억
  	       	else if(num.length == 8){
  	       		num = num.substring(0,4)+"억"+num.substring(4);
  	       	}
  	       	// 1조
  	       	else if(num.length == 9){
  	       		num = num.substring(0,1)+"조"+num.substring(1,5)+"억"+num.substring(5);
  	       	}
  	       	return num+'만';
  	       	*/
            //return formatter.number(Math.round(dat/10000), false)+'만';
        	 if(dat<0){
        		return formatter.number(Math.ceil(dat/1000)*1000, false);
        	} else{
        		return formatter.number(Math.floor(dat/1000)*1000, false);
        	}
        } else{
        	return formatter.number(dat);
        }
    }
    ,
    /**
     * 날짜형식 포매팅 (yyyy. mm. dd (요일))
     */
    dateday : function(date){
    	
    	var pattern_special = /[~!@\#$%<>^&*\()\-=+_\’]/gi, 
    		pattern_kor = /[ㄱ-ㅎ가-힣]/g,
    		pattern_eng = /[A-za-z]/g;

    	if (pattern_special.test(date) || pattern_kor.test(date) || pattern_eng.test(date)) {
    		return date.replace(/[^0-9]/g, "");
    	} 
    	var week = ['일', '월', '화', '수', '목', '금', '토'];
    	let dayOfWeek;
    	if(date.length === 4){
    		dayOfWeek = week[new Date(formatter.datetime(new Date().getFullYear() + date, 'yyyy-mm-dd')).getDay()]
    	} else {
    		dayOfWeek = week[new Date(formatter.datetime(date, 'yyyy-mm-dd')).getDay()];
    	}
    	//safari에서는 new Date('yyyy-mm-dd')로만 들어가야 함
    	
    	if($.trim(date).length == 8){
    		return formatter.datetime(date, 'yyyy. mm. dd')+" ("+dayOfWeek+")";
    	} else if($.trim(date).length == 6){
    		return formatter.datetime(date, 'yyyy. mm');
    	} else if($.trim(date).length == 4){ 
    		return formatter.datetime(new Date().getFullYear() +date, 'mm. dd'+" ("+dayOfWeek+")");
    	} else return date;
    	
    }
}))();