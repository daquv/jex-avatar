~jQuery.fn.extend({
	/**
	 * 알고리즘은 http://blog.naver.com/bohe76?Redirect=Log&logNo=5588545 다음을 참조 하였음
	 */
	jexCalendar: function(cmd, opt) {
		var $r = $(this);
	
		var getMonLen	= [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		var getWeek		= ["일","월","화","수","목","금","토"];
		var baseDt		= {year:0000, mon:1, dt:1, week:5};	// 기준일자 0000월 1월 1일은 토요일 이었음. (기준일을 변경하면 정상 작동하지 않을수 있음.--로직변경이 필요)
		
		$r.attr("jexType","Calendar");
		$r.css("ime-mode","inactive");	

		var htmlCode= "<div id='_jex_calendar' style='display:none;position:relative'>" +
						"<div id='layer_calendar' class='layer_calendar'>"+
							"<div class='cal_bx_top'>"+
								"<a id='goToday' ><img src='/img/content/calendar/btn_cal_today.gif' alt='오늘' /></a>"+
								"<a id='closeBtn'><img src='/img/content/calendar/btn_cal_close.gif' alt='닫기' /></a>"+
							"</div>"+
							"<div class='cal_bx_middle'>"+
								"<strong class='font_year'></strong>"+
								"<a id='open_year' style='cursor:pointer;vertical-align:-5px;padding-left:5px;'><img src='/img/content/calendar/img_year_btn.gif' alt='년도 선택' /></a>"+
								"<a id='prev_mon' class='month_btn'><img src='/img/content/calendar/month_btn_l.png' alt='' /></a>"+
								"<strong style='cursor:pointer' class='font_month'></strong>"+
								"<a id='next_mon' class='month_btn'><img src='/img/content/calendar/month_btn_r.png' alt='' /></a>"+
							"</div>"+
							"<div class='cal_bx_bottom'>"+
								"<table id='dayList'>"+
									"<colgroup>"+
									"<col style='width:15%' />"+
									"<col style='width:14%' />"+
									"<col style='width:14%' />"+
									"<col style='width:14%' />"+
									"<col style='width:14%' />"+
									"<col style='width:14%' />"+
									"<col style='width:15%' />"+
									"</colgroup>"+
									"<thead>"+
										"<tr>"+
											"<th class='sun'>일</th>"+
											"<th>월</th>"+
											"<th>화</th>"+
											"<th>수</th>"+
											"<th>목</th>"+
											"<th>금</th>"+
											"<th class='sat'>토</th>"+
										"</tr>"+
									"</thead>"+
									"<tbody>"+
									"</tbody>"+
								"</table>"+
							"</div>"+
						  "</div>"+
						  
						  "<div id='layer_calendar_mon' class='layer_calendar calendar_bg2' style='display:none;position:absolute;top:0px;left:0px'>"+
							"<div class='cal_bx_top'>"+
								"<a id='closeBtn'><img src='/img/content/calendar/btn_cal_close.gif' alt='닫기' /></a>"+
							"</div>"+
							"<div class='cal_bx_middle'>"+
								"<a id='prev_year' class='month_btn'><img src='/img/content/calendar/month_btn_l.png' alt='' /></a>"+
								"<strong style='cursor:pointer' class='font_year'></strong>"+
								"<a id='next_year' class='month_btn'><img src='/img/content/calendar/month_btn_r.png' alt='' /></a>"+
							"</div>"+
							"<div class='cal_bx_bottom2'>"+
								"<table>"+
									"<colgroup>"+
									"<col style='width:25%' />"+
									"<col style='width:25%' />"+
									"<col style='width:25%' />"+
									"<col style='width:25%' />"+
									"</colgroup>"+
									"<tbody>"+
										"<tr>"+
    										"<td><a>1</a><b>월</b></td>"+
    										"<td><a>2</a><b>월</b></td>"+
    										"<td><a>3</a><b>월</b></td>"+
    										"<td><a>4</a><b>월</b></td>"+
										"</tr>"+
										"<tr>"+
    										"<td><a>5</a><b>월</b></td>"+
    										"<td><a>6</a><b>월</b></td>"+
    										"<td><a>7</a><b>월</b></td>"+
    										"<td><a>8</a><b>월</b></td>"+
    									"</tr>"+
    									"<tr>"+
        									"<td><a>9</a><b>월</b></td>"+
        									"<td><a>10</a><b>월</b></td>"+
        									"<td><a>11</a><b>월</b></td>"+
        									"<td><a>12</a><b>월</b></td>"+
        								"</tr>"+
									"</tbody>"+
								"</table>"+
							"</div>"+
						  "</div>"+
						  
						  "<div id='layer_calendar_year' class='layer_calendar calendar_bg2' style='display:none;position:absolute;top:0px;left:0px'>"+
							"<div class='cal_bx_top'>"+
								"<a id='closeBtn'><img src='/img/content/calendar/btn_cal_close.gif' alt='닫기' /></a>"+
							"</div>"+
							"<div class='cal_bx_middle'>"+
								"<a id='prev_year_list' class='month_btn'><img src='/img/content/calendar/month_btn_l.png' alt='' /></a>"+
								"<strong style='cursor:pointer' class='font_year'></strong>"+
								"<a id='next_year_list' class='month_btn'><img src='/img/content/calendar/month_btn_r.png' alt='' /></a>"+
							"</div>"+
							"<div class='cal_bx_bottom2'>"+
								"<table>"+
									"<colgroup>"+
									"<col style='width:25%' />"+
									"<col style='width:25%' />"+
									"<col style='width:25%' />"+
									"<col style='width:25%' />"+
									"</colgroup>"+
									"<tbody>"+
									"</tbody>"+
								"</table>"+
							"</div>"+
						  "</div>"+
						  
						"</div>";
                                		
		var jexCalFn={
				show:function(opt) {
					jexCalFn['drawCalendar'](opt);
					var x = $r.offset().left;
				    var y = $r.offset().top+$r.height()+3;
				    
				    if (parseInt($("#_jex_calendar").width(),10)+parseInt(x,10) >parseInt($(window.document).width(),10)) {
				    	var tmpX = parseInt($(window.document).width(),10) - (parseInt($("#_jex_calendar").width(),10)+parseInt(x,10));
				    	if (tmpX > 0) 	x = tmpX;
				    	else				x = 0;
				    }
				    	
				    $("#_jex_calendar").css("left", x+"px");
				    $("#_jex_calendar").css("top",  y+"px");
				    

					$("#_jex_calendar").fadeIn("slow");
        		},
        		hide:function(opt) {
					$("#_jex_calendar").fadeOut("slow");
        		},
        		getDate		 :function(opt) {
        			return $(this).val().replace(/-/g, "");
        		},
        		beforeDate	 :function(opt) {
        			var result = {};
        			if(opt.mon==1) {
        				result.year = opt.year - 1;
        				result.mon  = 12;
        			} else {
        				result.year = opt.year;
        				result.mon  = opt.mon -1;
        			}
        			return result;
        		},
        		nextDate 	 :function(opt) {
        			var result = {};
        			if(opt.mon==12) {
        				result.year = opt.year + 1;
        				result.mon  = 1;
        			} else {
        				result.year = opt.year;
        				result.mon  = opt.mon+1;
        			}
        			return result;
        		},
        		getToday	 :function(opt) {
					var result	= {};
					var oDate	= new Date();
					var dYear	= oDate.getFullYear();
					var dMon	= oDate.getMonth()+1;
					var dDay	= oDate.getDate	();
					
					result.year = dYear;
					result.mon  = dMon;
					result.day  = dDay;
					
					return result;
        		},
        		drawCalendar :function(opt) {
					var today = jexCalFn['getToday']();
					
					if ($("#_jex_calendar").length == 0) {
						$(document.body).append(htmlCode);
						$("#_jex_calendar").css("position",	"absolute");
						$("#_jex_calendar").css("left",		10+"px");
						$("#_jex_calendar").css("top",		10+"px");
						$("#_jex_calendar").css("z-index",	"1000");
						
						
					}
					
					
					
					
					
					
					
					
					
					
					
					$("#_jex_calendar").find("#layer_calendar").find("#closeBtn").unbind('click');
					$("#_jex_calendar").find("#layer_calendar").find("#closeBtn").click(function() {
						$("#_jex_calendar").fadeOut("slow");
					});
					
					$("#_jex_calendar").find("#layer_calendar_mon").find("#closeBtn").unbind('click');
					$("#_jex_calendar").find("#layer_calendar_mon").find("#closeBtn").click(function() {
						$("#_jex_calendar").find("#layer_calendar_mon").hide();
						$("#_jex_calendar").find("#layer_calendar").show();
					});
					
					$("#_jex_calendar").find("#layer_calendar_year").find("#closeBtn").unbind('click');
					$("#_jex_calendar").find("#layer_calendar_year").find("#closeBtn").click(function() {
						$("#_jex_calendar").find("#layer_calendar_year").hide();
						$("#_jex_calendar").find("#"+$("#_jex_calendar").find("#layer_calendar_year").data("target")).show();
					});
					
					$("#_jex_calendar").find("#goToday").unbind('click');
					$("#_jex_calendar").find("#goToday").click(function() {
						jexCalFn['drawCalendar']({year:today.year, mon:today.mon,day:today.day});
					});
					
					$("#_jex_calendar").find("#layer_calendar").find("#prev_mon").unbind('click');
					$("#_jex_calendar").find("#layer_calendar").find("#prev_mon").click(function() {
						var beforeDate = jexCalFn['beforeDate']($r.data("opt"));
						jexCalFn['drawCalendar']({year:beforeDate.year, mon:beforeDate.mon,day:-1});
					});

					$("#_jex_calendar").find("#layer_calendar").find("#next_mon").unbind('click');
					$("#_jex_calendar").find("#layer_calendar").find("#next_mon").click(function() {
						var nextDate = jexCalFn['nextDate']($r.data("opt"));
						jexCalFn['drawCalendar']({year:nextDate.year, mon:nextDate.mon,day:-1});
					});
					
					$("#_jex_calendar").find("#layer_calendar").find("#open_year").unbind('click');
					$("#_jex_calendar").find("#layer_calendar").find("#open_year").click(function() {
						$("#_jex_calendar").find("#layer_calendar" ).hide();
						$("#_jex_calendar").find("#layer_calendar_year").show();
						
						$("#_jex_calendar").find("#layer_calendar_year").data("target", "layer_calendar");
						setYearTbl(parseInt($("#_jex_calendar").find("#layer_calendar").find(".font_year").html(),10));
						
//						$("#_jex_calendar").find("#layer_calendar_mon").find(".font_year").html($("#_jex_calendar").find("#layer_calendar").find(".font_year").html());
					});
					
					$("#_jex_calendar").find("#layer_calendar").find(".font_month").unbind('click');
					$("#_jex_calendar").find("#layer_calendar").find(".font_month").click(function() {
						$("#_jex_calendar").find("#layer_calendar").hide();
						$("#_jex_calendar").find("#layer_calendar_mon").show();
						
						$("#_jex_calendar").find("#layer_calendar_mon").find(".font_year").html($("#_jex_calendar").find("#layer_calendar").find(".font_year").html());
					});
					
					$("#_jex_calendar").find("#layer_calendar_mon").find("#prev_year").unbind('click');
					$("#_jex_calendar").find("#layer_calendar_mon").find("#prev_year").click(function() {
						$("#_jex_calendar").find("#layer_calendar_mon").find(".font_year").html(parseInt($("#_jex_calendar").find("#layer_calendar_mon").find(".font_year").html(),10)-1);
					});
					
					$("#_jex_calendar").find("#layer_calendar_mon").find("#next_year").unbind('click');
					$("#_jex_calendar").find("#layer_calendar_mon").find("#next_year").click(function() {
						$("#_jex_calendar").find("#layer_calendar_mon").find(".font_year").html(parseInt($("#_jex_calendar").find("#layer_calendar_mon").find(".font_year").html(),10)+1);
					});
					
					$("#_jex_calendar").find("#layer_calendar_mon").find(".font_year").unbind('click');
					$("#_jex_calendar").find("#layer_calendar_mon").find(".font_year").click(function() {
						$("#_jex_calendar").find("#layer_calendar_mon" ).hide();
						$("#_jex_calendar").find("#layer_calendar_year").show();
						
						$("#_jex_calendar").find("#layer_calendar_year").data("target", "layer_calendar_mon");
						
						setYearTbl($("#_jex_calendar").find("#layer_calendar_mon").find(".font_year").html());
						
//						$("#_jex_calendar").find("#layer_calendar_mon").find(".font_year").html($("#_jex_calendar").find("#layer_calendar").find(".font_year").html());
					});
					
					$("#_jex_calendar").find("#layer_calendar_year").find("#prev_year_list").unbind('click');
					$("#_jex_calendar").find("#layer_calendar_year").find("#prev_year_list").click(function() {
						setYearTbl(parseInt($("#_jex_calendar").find("#layer_calendar_year").data("nYear"),10)-10);
					});
					
					$("#_jex_calendar").find("#layer_calendar_year").find("#next_year_list").unbind('click');
					$("#_jex_calendar").find("#layer_calendar_year").find("#next_year_list").click(function() {
						setYearTbl(parseInt($("#_jex_calendar").find("#layer_calendar_year").data("nYear"),10)+10);
					});
					
					$("#_jex_calendar").find("#layer_calendar_mon").find("table").find("tbody").find("tr").find("td").unbind('click');
					$("#_jex_calendar").find("#layer_calendar_mon").find("table").find("tbody").find("tr").find("td").click(function() {
						$("#_jex_calendar").find("#layer_calendar").find(".font_month").html($(this).find("a").html());
						$("#_jex_calendar").find("#layer_calendar_mon").find("#closeBtn").click();
						jexCalFn['drawCalendar']({year:parseInt($("#_jex_calendar").find("#layer_calendar_mon").find(".font_year").html()), mon:parseInt($(this).find("a").html(),10),day:-1});
					});
					
					function setYearTbl(year) {
						var strYear = parseInt(parseInt(year,10)/10)*10-1;
						var endYear = parseInt(parseInt(year,10)/10)*10+10;
						
						var titStr = strYear + "~" + endYear;
						
						$("#_jex_calendar").find("#layer_calendar_year").data("nYear",year);
						
						$("#_jex_calendar").find("#layer_calendar_year").find(".font_year").html(titStr);
						
						$("#_jex_calendar").find("#layer_calendar_year").find("table").find("tbody").find("tr").remove();
						
						var tr = $("<tr></tr>");
				
						var insYear = strYear;
						
						for (var i=0; i<12; i++) {
							var td = $("<td><a>"+(insYear+i)+"</a><b>년</b></td>");
							td.clone().appendTo(tr);
							if ((i+1)%4==0) {
								tr.clone().appendTo($("#_jex_calendar").find("#layer_calendar_year").find("table").find("tbody"));
								tr = $("<tr></tr>");
							}
						}
						
						$("#_jex_calendar").find("#layer_calendar_year").find("table").find("tbody").find("tr").find("a").unbind('click');
						$("#_jex_calendar").find("#layer_calendar_year").find("table").find("tbody").find("tr").find("a").click(function() {
							$("#_jex_calendar").find("#"+$("#_jex_calendar").find("#layer_calendar_year").data("target")).find(".font_year").html($(this).html());
							$("#_jex_calendar").find("#layer_calendar_year").find("#closeBtn").click();
						
							if ($("#_jex_calendar").find("#layer_calendar_year").data("target")=="layer_calendar") {
								var y = parseInt($("#_jex_calendar").find("#"+$("#_jex_calendar").find("#layer_calendar_year").data("target")).find(".font_year").html(),10);
								var m = parseInt($("#_jex_calendar").find("#"+$("#_jex_calendar").find("#layer_calendar_year").data("target")).find(".font_month").html(),10);
								jexCalFn['drawCalendar']({year:y, mon:m,day:-1});
							}
						});
					}

					if (opt==null || opt==undefined || opt.year==undefined) opt = jexCalFn['getToday']();
					
					$r.data("opt",opt);
					
					$("#_jex_calendar").find("#layer_calendar").find(".font_year").html(opt.year);
					$("#_jex_calendar").find("#layer_calendar").find(".font_month").html(opt.mon);
					$("#_jex_calendar").find("#layer_calendar").find("table").find("tbody").find("tr").remove();
					
					var fDt = jexCalFn['getFirstDay'  ]({year:opt.year,mon:opt.mon});
					var eDt = jexCalFn['getMonEndDate']({year:opt.year,mon:opt.mon});
				
					var tr = $("<tr></tr>");
					var dd = 0;	//일자를 보관
					var cw = 0; //요일을 보관
					
					var cs = 5*7;					// 1달이 5주
					if (fDt+eDt >= cs) cs = 6*7;	// 1달이 6주	
					
					for (var i=0;i<cs;i++) {
						var td = $("<td><a>&nbsp;</a></td>");
						if (cw==0) td.attr("class","sun");
						if (cw==6) td.attr("class","sat");
						if (i>=fDt)dd++;
						if (dd<=0 || dd>eDt) td.attr("class","none");
						if (dd>0 && dd<=eDt) td.find("a").html(dd);
						if (today.year==opt.year&&today.mon==opt.mon&&today.day==dd) td.find("a").attr("class", "today");
						if (opt.day==dd) td.attr("class", "select");
						tr.append(td);
						if (cw==6) {
							tr.clone(true).appendTo($("#_jex_calendar").find("#layer_calendar").find("table").find("tbody"));
							tr = $("<tr></tr>");
							cw=0;
							continue;
						}
						cw++;
					}
					$("#_jex_calendar").find("#layer_calendar").find("table").find("tbody").find("tr").find("td").unbind('click');
					$("#_jex_calendar").find("#layer_calendar").find("table").find("tbody").find("tr").find("td").click(function() {
						if (isNaN($(this).find("a").html())) return ;
						var mmm = (parseInt($("#_jex_calendar").find("#layer_calendar").find(".font_month").html(),10)<10)?"0"+$("#_jex_calendar").find("#layer_calendar").find(".font_month").html():$("#_jex_calendar").find("#layer_calendar").find(".font_month").html();
						var ddd = (parseInt($(this).find("a").html(),10)<10)?"0"+$(this).find("a").html():$(this).find("a").html();
						
						$r.val($("#_jex_calendar").find("#layer_calendar").find(".font_year").html()+"-"+mmm+"-"+ddd);
						if(typeof _changeJexCalender == 'function') {
							_changeJexCalender($r);
                        }
    					jexCalFn['hide']();
					});
        		},
        		getMonEndDate:function(opt) {
    				if (opt.mon==2&&(opt.year%4==0 && (opt.year%100!=0||opt.year%400==0)))	return 29;
    				else  																	return getMonLen[opt.mon-1];
        		},
        		getFirstDay:function(opt) {
        			var yearlen		= opt.year - baseDt.year;
        			var yun_yearlen = parseInt((opt.year-1)/4,10) - parseInt((opt.year-1)/100,10) + parseInt((opt.year-1)/400,10);
        			var dt_cnt		= yearlen + yun_yearlen + 1;
        			
        			for (var i=0; i<opt.mon-1; i++) { dt_cnt = dt_cnt+jexCalFn['getMonEndDate']({"year":opt.year, "mon":i+1}); }
        			var week		= (baseDt.week+dt_cnt+1)%7;
        			
        			return week; 
        		}
		};
		
		$r.focus(function() {
			/*
			var rDat = $r.val().split("-");
			var opt  = {};
			if (rDat.length > 2) {
				opt.year = parseInt(rDat[0],10);
				opt.mon  = parseInt(rDat[1],10);
				
				try {
    				opt.day  = parseInt(rDat[2],10);
				} catch (e) {
					opt.day = -1;
				}
			};
			jexCalFn['show'](opt);
			*/ 
		});
		
		$r.next().click(function() { 
			var rDat = $r.val().split("-");
			var opt  = {};
			if (rDat.length > 2) {
				opt.year = parseInt(rDat[0],10);
				opt.mon  = parseInt(rDat[1],10);
				
				try {
    				opt.day  = parseInt(rDat[2],10);
				} catch (e) {
					opt.day = -1;
				}
			};
			jexCalFn['show'](opt); 
		});
		
		$r.keypress(function(event) {
			if (!(
  				  (event.keyCode  > 47 && event.keyCode  < 58) ||
  				  //(event.keyCode >= 96 && event.keyCode <= 105) ||
				  event.keyCode == 8 || 
				  event.keyCode == 190 || 
				  event.keyCode == 9 || 
				  event.keyCode  == 46 || 
				  //event.keyCode  == 36 || 
				  //event.keyCode == 35 || 
				  event.keyCode == 16
				 )
			   )
			{
				event.preventDefault();
			}
			
			if($r.val().length >= 10){
				event.preventDefault();
			}
			
			if($r.val().length > 9 && event.keyCode != 13)	{$r.val("");	return;}
			
			if($r.val().length == 4 || $r.val().length == 7){
				$r.val($r.val() + "-");
			}
		});
		
		$r.keydown(function(event){
			if(event.keyCode  == 229){
				return false;
			}
		});		
		
		$r.blur(function(){
			var val=$r.val();
			var date=val.split("-");
			var dateSum="";
			var  month = "31,28,31,30,31,30,31,31,30,31,30,31";
		    var  yy = 0;
		    var  mm = 0;
		    var  dd = 0;
		    var  maxday =0;
		    yy = parseInt(date[0], 10);
		    mm = parseInt(date[1], 10);
		    dd = parseInt(date[2], 10);
		    mm--;
		    ll = mm + 1;

			if((val.length > 0)&&(val.length < 10))
			{
				alert("날짜 입력 형식 오류입니다.\n월,일은 두자리로 입력 하세요.");
				$r.focus();
				return;
			} 		
					
			for ( var i=0 ; i < date.length; i++)
			{
				dateSum=dateSum+date[i];
			}
			if((dateSum != null ) && (dateSum != ""))
			{	
				if ((yy <= 1900 ) || (yy >= 2099 ))
				{
					alert("잘못된 년도입니다.");
					$r.focus();
					return;
				}
				if ((ll < 0 ) || (ll > 12 )||(ll == '00'))
				{
					alert("잘못된 월입니다.");
					$r.focus();
					return;
				}
				if ((dd < 0 ) || (dd > 31 )||(dd == '00'))
				{
					alert("잘못된 일자입니다.");
					$r.focus();
					return;
				}

				if (mm == 1) 
				{
			    	if((yy % 4 == 0 && yy % 100 != 0) || yy % 400 ==0)  /* 윤달인 경우 */
			        {
			        	maxday = 29;
			        }   
				   	else    /* 윤달이 아닌 경우 */
					{
						maxday = 28;
					}	
				}else{ 
					maxday = parseInt (month.substring(mm*3,mm*3+2), 10);
				}
			    if((dd < 1) || (dd > maxday))
			    { 
					alert("잘못된 일자입니다.");
					$r.focus();
					return;
				}	
			}
		});
		
//		$r.blur (function() { jexCalFn['hide']({}); });
		if (cmd==undefined) {
			if ($.trim($r.val())==""&&$.trim($r.html())=="") {
    			var today	= jexCalFn['getToday']();
				var mmm	= (parseInt(today.mon,10)<10)?"0"+today.mon:today.mon;
				var ddd		= (parseInt(today.day,10 )<10)?"0"+today.day:today.day;
    			if ($r.get(0).tagName.toLocaleLowerCase()=="input") $r.val(today.year+"-"+mmm+"-"+ddd);
			}
			return;
		}
		
		return jexCalFn[cmd](opt);
    }
});