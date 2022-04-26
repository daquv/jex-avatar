package com.avatar.comm;

import java.util.Calendar;
import java.util.Date;
import jex.util.date.DateTime;

public class SvcDateUtil {

	private static SvcDateUtil thisObj = null;

	/**
	 * 코드객체를 생성한다.
	 */
	private SvcDateUtil() {
		//this.init();
	}

	/**
	 * 코드유틸객체를 가져온다.
	 */
	public static SvcDateUtil getInstance() {
		if ( thisObj == null ) {
			thisObj = new SvcDateUtil();
		}
		return thisObj;
	}

	/**
	 * 현재날짜를 'YYYYMMDD'로 리턴
	 * 작성 날짜: (00-02-09 오후 3:40:24)
	 * 반환 형식 : "YYYYMMDD"
	 * @return java.lang.String
	 */
	public String getDate() {
		Calendar temp=Calendar.getInstance();
		int year=temp.get(Calendar.YEAR);
		int month=temp.get(Calendar.MONTH)+1;
		int day=temp.get(Calendar.DAY_OF_MONTH);
		StringBuffer today=new StringBuffer();
		today.append(year);

		if(month<10) {
			today.append("0");
		}
		today.append(month);


		if(day<10) {
			today.append("0");
		}
		today.append(day);

		return today.toString();
	}

	/**
	 * 현재날짜를 입력한 포맷에 맞게 리턴합니다.<br>
	 * 작성 날짜: (2001-11-09 오후 1:26:10)
	 * @return java.lang.String
	 */
	public String getDate(String format) {
		format = format.toLowerCase();
		int nTmp = format.indexOf("hh24");
		if (nTmp != -1)
			format = format.substring(0,nTmp)+"HH"+format.substring(nTmp+4);
		nTmp = format.indexOf("mm");
		if (nTmp != -1)
			format = format.substring(0,nTmp)+"MM"+format.substring(nTmp+2);

		nTmp = format.indexOf("mi");
		if (nTmp != -1)
			format = format.substring(0,nTmp)+"mm"+format.substring(nTmp+2);

		java.text.SimpleDateFormat simDate = new java.text.SimpleDateFormat(format);

		return simDate.format(new java.util.Date());
	}

	/**
	 * 날짜 8자리를 입력하면 YYYY-MM-DD로 반환한다.
	 */
	public String getDateForm(String rdate)
	{
		if(rdate==null||rdate.equals(" ")){
			return rdate;
		}
		rdate = rdate.trim();
		return SvcStringUtil.getInstance().putChar(rdate, "4,2", "-");
	}

	/**
	 * 날짜 8자리를 입력하면 YYYY.MM.DD로 반환한다.
	 */
	public String getDateForm2(String rdate)
	{
		if(rdate==null||rdate.equals(" ")){
			return rdate;
		}
		rdate = rdate.trim();
		return SvcStringUtil.getInstance().putChar(rdate, "4,2", ".");
	}

	/**
	 * 현재년도를 반환
	 * For example, int year = SvcDateUtil.getYear();
	 *
	 * @return current year.
	 */
	public static int getYear() {
		return getNumberByPattern("yyyy");
	}

	/**
	 * 현재월을 반환
	 * For example, int month = SvcDateUtil.getMonth();
	 *
	 * @return current month.
	 */
	public static int getMonth() {
		return getNumberByPattern("MM");
	}

	/**
	 * 현재날짜정보
	 * For example, int day = HUtil.getDay();
	 *
	 * @return current day.
	 */
	public static int getDay() {
		return getNumberByPattern("dd");
	}

	/**
	 * 현재 시:분:초 정보를 가져온다.
	 * @return String
	 */
	public String getHHMMSS() {
		Calendar temp=Calendar.getInstance();

		int hh = temp.get(Calendar.HOUR_OF_DAY);
		int mm = temp.get(Calendar.MINUTE);
		int ss = temp.get(Calendar.SECOND);

		StringBuffer today=new StringBuffer();

		if ( hh < 10 ) {	today.append("0"); }
		today.append(hh);

		if(mm<10) {	today.append("0");	}
		today.append(mm);

		if(ss<10) {	today.append("0");	}
		today.append(ss);

		return today.toString();
	}

	/**
	 * 콤보박스로 연도 만들기 - 위 아래로 5개씩..
	 */
	public String getComboYear(String Year ,String init) {
		int year = SvcStringUtil.sti(Year, 0);
		if (year < 1900) year = Integer.parseInt(getDate("YYYY"));
		String str = "";

		for(int i= year-5; i<=year+5; i++)
		{
			str += "<option value=\"" + i + "\"";
			if (i  == SvcStringUtil.sti(init, 0)) str += " selected";

			str += ">"  + i + "</option>\n";

		}

		return str;
	}

	/**
	 *  콤보박스로 월 만들기
	 */
	public String getComboMon(String init) {
		String str = "";

		for(int i= 1; i <= 12 ; i++) {
			str += "<option value=\"" ;
			if (i < 10) str += "0" + i;
			else	   str += i;

			str += "\"";


			if (i  == SvcStringUtil.sti(init, 0)) str += " selected";

			str += ">"  + i + "</option>\n";

		}
		return str;
	}

	/**
	 *  콤보박스로 일 만들기
	 */
	public String getComboDay(String  init) {
		String str = "";

		for(int i= 1; i <= 31 ; i++) {
			str += "<option value=\"" ;
			if (i < 10) str += "0" + i;
			else	   str += i;

			str += "\"";

			if (i  == SvcStringUtil.sti(init, 0)) str += " selected";

			str += ">"  + i + "</option>\n";
		}

		return str;
	}

	/**
	 * 현재 시각을 패턴으로 요청한 정보에 맞게 리턴한다.
	 *
	 * @param java.lang.String pattern  "yyyy, MM, dd, HH, mm, ss and more"
	 * @return formatted string representation of current day and time with your pattern.
	 */
	public static int getNumberByPattern(String pattern) {
		java.text.SimpleDateFormat formatter =
           new java.text.SimpleDateFormat (pattern, java.util.Locale.KOREA);
		String dateString = formatter.format(new java.util.Date());
		return Integer.parseInt(dateString);
	}

	/**
	 * For example, String time = SvcDateUtil.getFormatString("yyyyMMdd HH:mm:ss");
	 * 현재날짜와 시각을 주어진 포맷에 맞게 반환.
	 * @param java.lang.String pattern  "yyyy, MM, dd, HH, mm, ss and more"
	 * @return formatted string representation of current day and time with  your pattern.
	 */
	public static String getFormatString(String pattern) {
		java.text.SimpleDateFormat formatter =
           new java.text.SimpleDateFormat (pattern, java.util.Locale.KOREA);
		String dateString = formatter.format(new java.util.Date());
		return dateString;
	}

	/**
	 * 오늘 날짜를 반환형식에 맞추어 반환
	 * 반환 형식 : "YYYY.MM.DD (AM ,PM)  HH:MM:SS"
	 * 작성 날짜: (00-02-09 오후 3:40:24)
	 * @return java.lang.String
	 */
	public static String getToday() {
		Calendar temp=Calendar.getInstance();


		int year=temp.get(Calendar.YEAR);
		int month=temp.get(Calendar.MONTH)+1;
		int day=temp.get(Calendar.DAY_OF_MONTH);


		StringBuffer today=new StringBuffer();

		today.append(year);
		today.append(".");

		if(month<10)
			today.append("0");

		today.append(month);
		today.append(".");

		if(day<10)
			today.append("0");

		today.append(day);

		if ( temp.get(Calendar.AM_PM) > 0 )
			today.append(" 오후 ");
		else
			today.append(" 오전 ");

		if(temp.get(Calendar.HOUR) == 0) {
			today.append(12);
		}
		else {
			if (temp.get(Calendar.HOUR) < 10 )
				today.append("0");

			today.append(temp.get(Calendar.HOUR));
		}

		today.append(":");
		if (temp.get(Calendar.MINUTE) < 10 )
			today.append("0");

		today.append(temp.get(Calendar.MINUTE));
		today.append(":");

		if (temp.get(Calendar.SECOND) < 10 )
			today.append("0");

		today.append(temp.get(Calendar.SECOND));

		return today.toString();
	}

	/**
	 * 오늘 날짜를 반환형식에 맞추어 반환
	 * 반환 형식 : "YYYY.MM.DD (AM ,PM)  HH:MM:SS"
	 * 작성 날짜: (00-02-09 오후 3:40:24)
	 * @return java.lang.String
	 */
	public static String getToday1() {
		Calendar temp=Calendar.getInstance();


		int year=temp.get(Calendar.YEAR);
		int month=temp.get(Calendar.MONTH)+1;
		int day=temp.get(Calendar.DAY_OF_MONTH);


		StringBuffer today=new StringBuffer();

		today.append(year);
		today.append(".");

		if(month<10)
			today.append("0");

		today.append(month);
		today.append(".");

		if(day<10)
			today.append("0");

		today.append(day + " ");

		if(temp.get(Calendar.HOUR) == 0) {
			today.append(12);
		}
		else {
			if (temp.get(Calendar.HOUR) < 10 )
				today.append("0");

			today.append(""+temp.get(Calendar.HOUR));
		}

		today.append(":");
		if (temp.get(Calendar.MINUTE) < 10 )
			today.append("0");

		today.append(temp.get(Calendar.MINUTE));
		today.append(":");

		if (temp.get(Calendar.SECOND) < 10 )
			today.append("0");

		today.append(temp.get(Calendar.SECOND));

		if ( temp.get(Calendar.AM_PM) > 0 )
			today.append(" PM");
		else
			today.append(" AM");

		return today.toString();
	}

	/**
	 * 두 날짜사이의 일수차이 구함(입력양식 'YYYYMMDD','YYYYMMDD'
	 * Creation date: (2000-06-05 오전 11:32:41)
	 * @return int
	 * @param strYYYYMMDD1 int
	 * @param strYYYYMMDD2 int
	  * 작성자 : 서은석
	 */
	public int days_between(String strYYYYMMDD1,String strYYYYMMDD2) {
		try	{
			int year = Integer.parseInt(strYYYYMMDD1.substring(0,4));
			int month = Integer.parseInt(strYYYYMMDD1.substring(4,6));
			int day =  Integer.parseInt(strYYYYMMDD1.substring(6));

			int year2 = Integer.parseInt(strYYYYMMDD2.substring(0,4));
			int month2 = Integer.parseInt(strYYYYMMDD2.substring(4,6));
			int day2 =  Integer.parseInt(strYYYYMMDD2.substring(6));

			return days_between(year,month,day,year2,month2,day2);
		}
		catch(Exception e) {
			e.printStackTrace();
			return -1;
		}
	}

	/**
	 * 그 달의 마지막날짜를 구한다
	 * 작성 날짜: (00-05-23 오후 4:53:03)
	 * @return int
	 * @param strYyMm java.lang.String
	 */
	public int getLastDay(String strYyMm) {
		int LastDay = 0;
		int year = 0;
		int month = 0;

		year = Integer.parseInt(strYyMm.substring(0,4));

		if (strYyMm.length() != 6)
			month = Integer.parseInt(strYyMm.substring(4,5));
		else
			month = Integer.parseInt(strYyMm.substring(4,6));

		switch (month) {
			case	2:	{
				if(((year%4 == 0) && (year%100 != 0)) || (year%400 == 0))
					LastDay = 29;
				else
					LastDay = 28;
				break;
			}
			case	4: LastDay = 30;break;
			case	6: LastDay = 30;break;
			case	9: LastDay = 30;break;
			case	11: LastDay = 30;break;
			default: LastDay = 31;break;
		}
		return LastDay;
	}

	/**
	 * 요일을 가져오기(숫자형태로)
	 * 1(일요일) ~ 7(토요일)
	 * 작성 날짜: (00-05-23 오후 7:44:49)
	 * @return int
	 */
	public int getWeekDay(String strYyyyMmDd) {
		Calendar dt=Calendar.getInstance();
		int	year	=		Integer.valueOf(strYyyyMmDd.substring(0,4)).intValue();
		int	mon	=	0;
		int	day	=	0;

		if	(strYyyyMmDd.length() == 8 ) {
			mon	=		Integer.valueOf(strYyyyMmDd.substring(4,6)).intValue()-1;
			day	=		Integer.valueOf(strYyyyMmDd.substring(6,8)).intValue();
		}
		else {
			mon	=		Integer.valueOf(strYyyyMmDd.substring(4,5)).intValue()-1;
			day	=		Integer.valueOf(strYyyyMmDd.substring(5,7)).intValue();
		}
		dt.set(year,mon,day);

		return dt.get(java.util.Calendar.DAY_OF_WEEK);
	}

	/**
	 * 현재시각을 시:분:초 포맷에 맞게 리턴
	 * @return formatted string representation of current time with  "HHmmss".
	 */
	public static String getShortTimeString() {
		java.text.SimpleDateFormat formatter =
            new java.text.SimpleDateFormat ("HHmmss", java.util.Locale.KOREA);
		return formatter.format(new java.util.Date());
	}

	/**
	 * 현재날짜를 년:월:일 포맷에 맞게 리턴
	 * @return formatted string representation of current day with  "yyyyMMdd".
	 */
	public static String getShortDateString() {
		java.text.SimpleDateFormat formatter =
            new java.text.SimpleDateFormat ("yyyyMMdd", java.util.Locale.KOREA);
		return formatter.format(new java.util.Date());
	}
	
	/**
	 * 현재날짜를 년:월:일 시:분:초 포맷에 맞게 리턴
	 * @return formatted string representation of current day with  "yyyyMMddHHmmss".
	 */
	public String getDateTime() {
		/*
		Calendar calendar = Calendar.getInstance();
	    java.util.Date date = calendar.getTime();
	    String today = (new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(date));
	    return today;
	    */
		long time = System.currentTimeMillis();
		java.text.SimpleDateFormat dayTime = new java.text.SimpleDateFormat("yyyyMMddHHmmss");
		String now = dayTime.format(new Date(time));
		return now;
	}
	
	/**
	 * 주어진 14자리의 날짜를 델리미터를 포함해서 YYYY-MM-DD HH:MM:SS로 반환
	 * @param code String YYYYMMDDHHMMSS
	 * @return YYYY-MM-DD HH:MM:SS
	 */
	public String dateAlignFull(String code) {
		if (code == null) return "";
		else if (code.length() != 14){
			return code;
		}
		else{
			String temp = code.substring(0,4) + "." + code.substring(4,6) + "."
					    + code.substring(6,8) + " " + code.substring(8,10) + ":"
						+ code.substring(10,12) + ":" + code.substring(12);
			return temp;
		}
	}

	/**
	 * 넘겨준 숫자만큼 날짜를 빼거나 더해서 문자열로 넘겨준다
	 * @param iDay int 플러스(+), 마이너스(-)날짜값
	 * @param flag char 'Y' : 년도, 'M' : 월, 'W' : 주, 'D' : 일
	 * @return YYYYMMDD
	 */
	public String getDate(int iDay,char flag) {
		Calendar today=Calendar.getInstance();

		switch(flag){
			case	'Y'	:	today.add(Calendar.YEAR,iDay);
						break;
			case	'M'	:	today.add(Calendar.MONTH,iDay);
						break;
			case	'W'	:	today.add(Calendar.WEEK_OF_MONTH,iDay);
						break;
			case	'D'	:	today.add(Calendar.DAY_OF_MONTH,iDay);
						break;
		}

		String strYear		=	Integer.toString(today.get(Calendar.YEAR));
		String strMonth		=	Integer.toString(today.get(Calendar.MONTH)+1);

		strMonth				=	(strMonth.length()==1) ? strMonth="0"+strMonth : strMonth;
		String strDay		=	Integer.toString(today.get(Calendar.DAY_OF_MONTH));
		strDay					=	(strDay.length()==1) ? strDay="0"+strDay : strDay;

		return strYear+strMonth+strDay;
	}

	/**
	 * 원하는 길이의 Numeric String을 만드는 메소드<br>
	 * getNstring(12345, 7) ---> "0012345" 를 반환다.
	 * @return java.lang.String
	 */
	public String getNstring(int intstr, int length) {
		String str = Integer.toString(intstr);
		for (int i = length- str.length(); i >0; --i){
			str = "0" + str;
		}
		return str;
	}

	/**
	 * wholeDate 8자리가 있으면, gubun 해당하는 값을 잘라서 리턴해주고,
	 * 없을경우는 현재날짜를 gubun에 해당하는 값으로 리턴해준다.
	 * @param String wholeDate 가공할 문자열
	 * @param String gubun Y, M, D
	 */
	public String getDate(String wholeDate, String gubun) {
		String retStr = "";

		if(gubun.equals("Y")) {
			retStr = wholeDate.length() == 8 ? SvcStringUtil.Left(wholeDate, 4) :
				String.valueOf(getYear());	// 년도
		}
		else if(gubun.equals("M")) {
			retStr = wholeDate.length() == 8 ? SvcStringUtil.Left(SvcStringUtil.Right(wholeDate, 4), 2) :
				String.valueOf(getMonth());	// 월
		}
		else if(gubun.equals("D")) {
			retStr = wholeDate.length() == 8 ? SvcStringUtil.Right(wholeDate, 6) :
				String.valueOf(getDay());	// 일
		}

		return retStr;
	}


	/**
	 * 두 날짜사이의 일수차이 구함
	 * Creation date: (2000-06-05 오전 11:32:41)
	 * @return int
	 * @param year1 int
	 * @param month1 int
	 * @param day1 int
	 * @param year2 int
	 * @param month2 int
	 * @param day2 int
	 */
	public int days_between(int year1, int month1, int day1, int year2, int month2, int day2) {
		try
		{
			Calendar temp=Calendar.getInstance();
			int M1 = month1-1;
			int M2 = month2-1;	         //Calendar 함수에 쓸 수 있는 값으로 변환

			int sum_of_years = (year2-year1)*365+number_of_addyear(year2)-number_of_addyear(year1);
			                       //년도 차이에 365를 곱하고 윤년날수를 보정해서 입력한 두 해 사이의
			                      // 일수 차이를 구한다.(년도만 다르고 월, 일은 같다고 가정)
			temp.set(year2,M2,day2);
			int sum_of_day2=temp.get(Calendar.DAY_OF_YEAR);   //입력해 입력일까지의 날 수
			temp.set(year1,M1,day1);
			int sum_of_day1=temp.get(Calendar.DAY_OF_YEAR);  //입력해 입력일까지의 날 수
			int sum_of_days=sum_of_day2-sum_of_day1;
			int sum=sum_of_years+sum_of_days;     //일수간의 차이를 보정하여 정확한  일수의 차이를 구함
			return sum;    //int값으로 반환
		}
		catch(Exception e)
		{
			return 0;
		}
	}

	/**
	 * Integer 형식으로 입력된 일시로부터 현재일짜지의 날짜수를 반환한다.
	 * Creation date: (2000-06-05 오전 10:36:07)
	 * @return int
	 * @param year int
	 * @param month int
	 * @param day int
	 */
	public int days_between(int year, int month, int day) {
		try
		{
			Calendar temp=Calendar.getInstance();
			int M1=month-1;                                //Calendar함수에 쓸 수 있는 값으로 변환
			int Y2=temp.get(Calendar.YEAR);      //올해

		    //년도 차이에 365를 곱하고 윤년날수를 보정해서 입력한 두 해 사이의
		    //일수 차이를 구한다.(년도만 다르고 월, 일은 같다고 가정)
			int sum_of_years= (Y2-year)*365+number_of_addyear(Y2)-number_of_addyear(year);
			int sum_of_day2=temp.get(Calendar.DAY_OF_YEAR);   //올해 오늘까지의 일수
			temp.set(year,M1,day);
			int sum_of_day1=temp.get(Calendar.DAY_OF_YEAR);  //입력년도 입력일까지의 일수
			int sum_of_days=sum_of_day2-sum_of_day1;
			int sum=sum_of_years+sum_of_days;    //일수간의 차이를 보정하여 정확한 일수의 차이를 구함
			return sum;      //int값으로 반환
		}
		catch(Exception e)
		{
			return 0;
		}
	}

	/**
	 * 입력한 해 직전(입력해의 윤달은 제외)까지의 윤달(년)의 수
	 * Creation date: (2000-06-05 오전 10:54:17)
	 * @return int
	 * @param year int
	 * 작성자 : 서은석
	 */
	public int number_of_addyear(int year) {
		return (year-1)/4-(year-1)/100+(year-1)/400;
		//4의배수는 윤년, 100의 배수는 윤년아님, 그러나 400의 배수는 윤년
	}

	/**
     * 전문에서 8자리로 웹에 뿌려주는 날짜(8자리)들을 format한다.
     * @param date java.lang.String
     * @return string java.lang.String
     */
	public static String dateAlign(String date) {
    	if (date == null){
    		return "";
    	} 	else if (date.equals("0")){
    		return "";
    	}  	else if (date.equals("00000000")){
    		return "";
    	}  	else if (date.length() < 8){
    		return date;
    	}  	else {
    		return date.substring(0,4) + "-" + date.substring(4,6) + "-" + date.substring(6);
    	}
    }

	/**
	 * 메소드 설명을 삽입하십시오.
	 * 작성 날짜: (00-02-09 오후 3:40:24)
	 * iDay 맡큼 빼거나 더한
	 * 년 , 월 , 주 ,일 을 반환
	 * 반환 형식 : "YYYYMMDD"
	 * @return java.lang.String
	 */
	public String getDate(String strDate,int iDay,char flag) {

		if (strDate.length() != 8)
			return "";

		int nYYYY = Integer.parseInt(strDate.substring(0,4));
		int nMM   = Integer.parseInt(strDate.substring(4,6))-1;
		int nDD    = Integer.parseInt(strDate.substring(6));

		Calendar today=Calendar.getInstance();
		today.set(nYYYY,nMM,nDD);

		switch(flag){
			case	'Y'	:	today.add(Calendar.YEAR,iDay);
						break;
			case	'M'	:	today.add(Calendar.MONTH,iDay);
						break;
			case	'W'	:	today.add(Calendar.WEEK_OF_MONTH,iDay);
						break;
			case	'D'	:	today.add(Calendar.DAY_OF_MONTH,iDay);
						break;
		}

		String strYear		=	Integer.toString(today.get(Calendar.YEAR));
		String strMonth		=	Integer.toString(today.get(Calendar.MONTH)+1);
		String strDay		=	Integer.toString(today.get(Calendar.DAY_OF_MONTH));

		strMonth				=	(strMonth.length()==1) ? strMonth="0"+strMonth : strMonth;
		strDay					=	(strDay.length()==1) ? strDay="0"+strDay : strDay;

		return strYear+strMonth+strDay;
	}

	public String chgDateFormat(String strDate, String formatStr){
		String rtnStr = "";
		int numDate = 0;
		try{
			numDate = Integer.parseInt(strDate);
			if(strDate.length()==6) strDate = "20" + strDate;
			strDate = strDate.substring(0,4) + "-" + strDate.substring(4,6) + "-" + strDate.substring(6);
		} catch(Exception e){
			strDate = strDate.replaceAll(" ", "-").replaceAll("/", "-").replaceAll(":", "-");
			if(strDate.length()==8) strDate = "20" + strDate;
		}
		rtnStr = strDate.replaceAll("-", formatStr);

		return rtnStr;
	}

	public String chgTimeFormat(String strTime, String formatStr){
		String rtnStr = "";
		int numTime = 0;
		try{
			numTime = Integer.parseInt(strTime);
			strTime = strTime.substring(0,2) + ":" + strTime.substring(2,4) + ":" + strTime.substring(4);
		} catch(Exception e){
			strTime = strTime.replaceAll(" ", ":").replaceAll("/", ":").replaceAll("-", ":");
		}
		rtnStr = strTime.replaceAll(":", formatStr);

		return rtnStr;
	}

	public String getDayOfWeek(String strDate){
		String dayOfWeek="";
		if(strDate.length()!=8) return "0";
		String[] day={"일", "월", "화", "수", "목", "금", "토"};
		Calendar date=Calendar.getInstance();
		date.set(Calendar.YEAR, Integer.parseInt(strDate.substring(0, 4)));
		date.set(Calendar.MONTH, Integer.parseInt(strDate.substring(4, 6))-1);
		date.set(Calendar.DATE, Integer.parseInt(strDate.substring(6, 8)));

		return day[date.get(Calendar.DAY_OF_WEEK)-1];
	}

	/***
	 * 기준일자 전후 월요일
	 * @param strDate : 기준일자(YYYYMMDD)
	 * @param gubn : A(After), B(Before)
	 * @return
	 */
	public String getMonday(String strDate, String gubn){
		int weekval = 0;
		int intaval = 0;
		String Monday = "";

		if(gubn.equals("A")){
			//After
			intaval = 9;
		} else if(gubn.equals("B")){
			//Before
			intaval = 2;
		}
		
		weekval = this.getWeekDay(strDate);
		Monday = this.getDate(strDate, (intaval-weekval), 'D');
		
		return Monday;
	}

	/***
	 * 기준일자 전후 월요일
	 * @param strDate : 기준일자(YYYYMMDD)
	 * @param gubn : A(After), B(Before)
	 * @return
	 */
	public String getSunday(String strDate, String gubn){
		int weekval = 0;
		int intaval = 0;
		String Sunday = "";

		if(gubn.equals("A")){
			//After
			intaval = 8;
		} else if(gubn.equals("B")){
			//Before
			intaval = 1;
		}
		
		weekval = this.getWeekDay(strDate);
		Sunday = this.getDate(strDate, (intaval-weekval), 'D');
		
		return Sunday;
	}

	/***
	 * 기준일자가 그달의 몇번째 주에 해당하는지 가져옴
	 * @param strDate : 기준일자(YYYYMMDD)
	 * @return
	 */
	public int getWeekOfMonth(String strDate){
		int days  = 0;
		int weeks = 0;
		
		days  = Integer.parseInt(strDate.substring(6));
		weeks = 1 + (days/7);

		return weeks;
	}
	public int getWeekOfMonth(){
		int days  = 0;
		int weeks = 0;
		String strDate = getDate();
		
		days  = Integer.parseInt(strDate.substring(6));
		weeks = 1 + (days/7);

		return weeks;
	}


	/**
	 * 년월일 형식으로 변환
	 * */
	public static String getKoreanDate(String strDate){

		String rt = strDate;
		if	(strDate.length() == 8 ) {
			String	year =  strDate.substring(0,4);
			String	mon	=	strDate.substring(4,6);
			String	day	=	strDate.substring(6,8);
			rt = year+"년 "+Integer.parseInt(mon)+"월 "+Integer.parseInt(day)+"일";
		}
		else if	(strDate.length() == 6 ) {
			String	year =  strDate.substring(0,4);
			String	mon	=	strDate.substring(4,6);
			rt = year+"년 "+Integer.parseInt(mon)+"월 ";
		}
		else if	(strDate.length() == 4 ) {
			String	year =  strDate.substring(0,4);
			rt = year+"년 ";
		}
		return rt;
	}

	public static String toFeedDate(String strDate){
        
        if(strDate == null || strDate.length() != 14) return strDate;
        
        String ret = "";
            
        String srcDate = DateTime.getInstance().getDate(strDate, "yyyymmddhh24miss");
        String curDate = DateTime.getInstance().getDate("yyyymmddhh24miss");
        
        String srcday  = srcDate.substring(0,8);
        String curday  = curDate.substring(0,8);
        
        int srcHH      = Integer.parseInt(srcDate.substring(8,10));
        int curHH      = Integer.parseInt(curDate.substring(8,10));

        int srcMM      = Integer.parseInt(srcDate.substring(10,12));
        int curMM      = Integer.parseInt(curDate.substring(10,12));

        int srcSS      = Integer.parseInt(srcDate.substring(12));
        int curSS      = Integer.parseInt(curDate.substring(12));
        
        if(curDate.substring(0,12).equals(srcDate.substring(0,12))){
            //int ss = Integer.parseInt(curDate.substring(12)) - Integer.parseInt(srcDate.substring(12));
            //ret = ss + "초전";
            ret = "방금전";
        }else if(curDate.substring(0,10).equals(srcDate.substring(0,10))){
            int mm = curMM - srcMM;
            if(mm == 1 && (curSS < srcSS)){
                ret = "방금전";
            } else {
            	ret = mm + "분전";
            }
        }else if(curDate.substring(0,8).equals(srcDate.substring(0,8))){
            int HH = curHH - srcHH;
            if((HH == 1) && (curMM < srcMM)){
            	ret = Integer.toString(60 + curMM - srcMM) + "분전";
            } else {
            	ret = HH + "시간전";
            }
        }else{
            int iDayBetween = SvcDateUtil.getInstance().days_between(srcDate.substring(0,8), curDate.substring(0,8));
            if((iDayBetween==1) && (curHH < srcHH)){
            	if(curHH==0 && srcHH==23){
                	ret = Integer.toString(60 + curMM - srcMM) + "분전";
            	} else {
            		ret = Integer.toString(24 + curHH - srcHH) + "시간전";
            	}
            } else if(iDayBetween < 31){
                ret = iDayBetween + "일전";
            } else {
                ret = getKoreanDate(strDate.substring(0,8)) 
                        + " ("+SvcDateUtil.getInstance().getDayOfWeek(strDate.substring(0,8))+"요일)";
            }
        }
        
        return ret;
    }


}
