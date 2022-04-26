package com.avatar.comm;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.StringTokenizer;
import java.util.Vector;

public class SvcStringUtil {

    private static SvcStringUtil stringUtil = null;

    public static SvcStringUtil getInstance(){
        if ( stringUtil == null ) {
            stringUtil = new SvcStringUtil();
        }
        return stringUtil;
    }

	/*
     * 숫자인지 확인
     */
	public static boolean isNumber(String src) {
		try{
			Double.parseDouble(src);

			return true;
		}catch (Exception e){

			return false;
		}
	}

	/**
	  * ',' 를 3자리 마다 삽입한다. 숫자일 경우
	  * 123456 -> 123,456
	  * 작성 날짜: (00-10-19 오전 2:02:15)
	  * @return java.lang.String
	  * @param str java.lang.String
	  */
	private static java.text.DecimalFormat commaDF =
		new java.text.DecimalFormat("###,##0");

	/**
	 * String Data를 int Data로 바꿔준다
	 * */
	public static int sti(String tmpStr, int retVal) {
		try	{
			if(tmpStr != null && tmpStr.length() > 0) {
				retVal = Integer.parseInt(tmpStr);
			}
		}
		catch(Exception e) {}

		return retVal;
	}

	/**
	 * 문자열을 왼쪽부터 지정된 인덱스로 자른다. exception 처리를 추가했음
	 */
	public static String Left(String str, int len) {
		try {
			str = str.substring(0, len);
		}
		catch(Exception e) {
		}

		return str;
	}

	/**
	 * 문자열을 오른쪽끝부터 지정된 인덱스로 자른다. exception 처리를 추가했음
	 */
	public static String Right(String str, int len) {
		try {
			str = str.substring(str.length()-len);
		}
		catch(Exception e) {
		}

		return str;
	}

	/**
	 * 로그작성을 위해 JAVA명을 추출한다.
	 */
	public static String getClassName(String className) {
		return Right(className, className.lastIndexOf(".") + 1);
	}

	/**
	 * '-' 3개를 지정한 자리에 삽입 <br>
	 * 작성 날짜: (2001-11-09 오전 11:54:07)
	 * @return java.lang.String
	 */
	public String putChar(String str, String offset, String chr) {
		if(str == null || str.equals("")) return "";
		String[] arrOffset	= split(offset, ",");
		int [] arrOffInt	= new int[arrOffset.length];

		for(int i=0; i<arrOffset.length; i++) {
			if(i != 0) {
				arrOffInt[i] = arrOffInt[i-1] + sti(arrOffset[i], 0);
			}
			else {
				arrOffInt[i] = sti(arrOffset[i], 0);
			}
		}

		if(str.length()<arrOffInt[arrOffInt.length - 1] || arrOffInt[arrOffInt.length - 1]<=0)
			return str;

		StringBuffer sb = new StringBuffer();
		char  c;
		for(int i=0; i<str.length();i++){
			c= str.charAt(i);
			for(int j=0; j<arrOffInt.length; j++) {
			    if(i == (arrOffInt[j])) {
			    	sb.append(chr);
			    }
			}
			if(c!=' ')
				sb.append(c);
		}
		return sb.toString();
	}

	/**
	 * 문자를 지정한 기호로 잘라서 주어진 순서에 문자열을 돌려준다
	 * @return String
	 */
	public static String[] split(String paramStr, String delimStr) {
		StringTokenizer st = new StringTokenizer(paramStr, delimStr);
		String[] retStr = new String[st.countTokens()];

		for(int i=0; st.hasMoreTokens(); i++) {
			retStr[i] = st.nextToken();
		}

		return retStr;
	}

	/**
	 * 문자열 replace
	 *
	 * @param String src : 찾을 대상 문자열
	 * @param String org : 찾을 문자열
	 * @param String tar : 대치할 문자열
	 *
	 * @return String : replace 된 문자열
	 */
	public static String replace(String src, String org, String tar) {
		if (src == null) {
			return "";
		}

		if (org == null) {
			return src;
		}

		if (tar == null) {
			tar = "";
		}

		String tmp1 = src;
		String tmp2 = "";
		while (tmp1.indexOf(org) > -1) {
			tmp2 = tmp2 + tmp1.substring(0, tmp1.indexOf(org)) + tar;
			tmp1 = tmp1.substring(tmp1.indexOf(org) + org.length());
		}
		tmp2 = tmp2 + tmp1;
		return tmp2;
	}

	/**
	 * 금액에서 00005000 에서 0000을 떼내고,
	 * 5,000 으로 리턴한다.
	 * 작성 날짜: (2000-12-22 오후 2:02:38)
	 * @return java.lang.String
	 */
	public static String getMoneyForm(String str) {
		if (str != null) {
			for (int i = 0; i < str.length(); i++) {
				if (str.charAt(i) != '0') {
					return putComma(str.substring(i, str.length()));
				}
			}
			return "0";
		}
		else {
			return null;
		}
	}

	/**
	 * 입력한 String의 맨앞에있는 '0'을 없앤다.
	 * e) "00001234"   ---> "1234"
	 * 수정(2002-01-31)
	 * 소수점 처리
	 * e) "000.00"     ---> "0.00"
	 * 작성 날짜: (2001-12-24 오후 6:17:07)
	 * @return java.lang.String
	 */
	public String rmZero(String str) {
		if(str==null) return "";
		char indexChr = ' ';
		int index =0;
		while(index<str.length()){
			if(str.charAt(index)=='0' ){
				index++;
			}else{
				indexChr = str.charAt(index);
				break;
			}
		}
		if(index<str.length()) return str.substring(indexChr=='.'?index-1:index);
		else return "0";
	}

	/**
	 * 한글은 2Byte로 자동계산하여 substring한다.
	 * @return java.lang.String
	 */
	public String hsubstring(String strData, int Cstartindex, int Cendindex)
	{
		Hangul hg =  new Hangul();
		char c;
		int hancnt = 0;
		int cnt = 0;
		int sindex = 0;
		int eindex = 0;
		String result = null;

		for (int i = 0; i < strData.length(); i++) {
			c = strData.charAt(i);
			if (cnt >= Cstartindex) {
				break;
			}
			if (hg.checkHan(c)) {
				cnt = cnt + 2;
				hancnt++;
			}
			else {
				cnt++;
			}
		}

		sindex = cnt - hancnt;
		cnt = 0;
		hancnt = 0;

		for (int i = 0; i < strData.length(); i++) {
			c = strData.charAt(i);
			if (cnt >= Cendindex) {
				break;
			}
			if (hg.checkHan(c)) {
				cnt = cnt + 2;
				hancnt++;
			}
			else {
				cnt++;
			}
		}
		eindex = cnt - hancnt;

		try {
			result = strData.substring(sindex, eindex);
		}
		catch (Exception e){}

		return result;
	}

	/**
	 * 원하는 길이의 Numeric String을 만드는 메소드<br>
	 * getNstring(12345, 7) ---> "0012345" 를 반환다.
	 * 작성 날짜: (2001-11-16 오후 8:31:40)
	 * @return java.lang.String
	 */
	public static String getNstring(int intstr, int length) {
		String str = Integer.toString(intstr);
		for (int i = length- str.length(); i >0; --i){
			str = "0" + str;
		}
		return str;
	}

	/**
	 * 원하는 길이의 Numeric String을 만드는 메소드<br>
	 * getNstring(12345, 7) ---> "0012345" 를 반환다.
	 * 작성 날짜: (2001-11-16 오후 8:31:40)
	 * @return java.lang.String
	 */
	public static String getNstring(String str, int length) {
		for (int i = length- str.length(); i >0; --i){
			str = "0" + str;
		}
		return str;
	}

	/**
	 * 원하는 길이의 alphaNumeric String을 만드는 메소드<br>
	 * getANstring("asdf",6) --> asdf  을 반환(asdf뒤에 공백두칸 추가 ^^;;)<br>
	 * 작성 날짜: (2001-11-16 오후 8:31:40)
	 * @return java.lang.String
	 */
	public static String getANstring(String str, int length) {
		if(str==null) return "";
		for (int i = length- str.length(); i >0; --i){
			str += " ";
		}
		return str;
	}

	/**
	 * String str에서 특정문자(char g)를 제거하는 메소드<br>
	 * 작성 날짜: (2001-11-09 오후 2:44:09)
	 * @return java.lang.String
	 */
	public String delchar(String str, char g) {
		StringBuffer sb = new StringBuffer();
		char  c;
		for(int i=0; i<str.length();i++){
			c= str.charAt(i);
			if(c!=g){
				sb.append(c);
			}
		}
		return sb.toString();
	}

	/**
	 * 소수점이하자리수 채워주기
	 * 소수점이하 cnt만큼 0을 채운다
	 * 작성 날짜: (2002-01-09 오후 5:19:16)
	 * 최종수정일 : 2002-02-18
	 * 취종수정내용 : String ---> StringBuffer로
	 * @return java.lang.String
	 */
	public String getRateForm(String str, int cnt) {
		if(str==null) return "";

		StringBuffer sb = new StringBuffer();
		sb.append(str);

		if(str.indexOf(".")<0 ){
			//소수점이 없으면
			sb.append(".");
			while(cnt>0){
				sb.append("0");
				cnt--;
			}
		}else{
			//소수점이 있으면
			while(cnt  >= (str.length() - str.indexOf(".")) ){
				sb.append("0");
				cnt--;
			}

		}
		return sb.toString();
	}

	/**
	 * DB에서 정보 추출시 각 값을 태그 값으로 변경
	 */
	public String vCheckWord(String strval){
		if ( strval == null ) {	return "";	}

		strval = replace(strval, "&nbsp;"," " );
//		strval = replace(strval, "&lt;", "<");
//		strval = replace(strval, "&gt;", ">");
		strval = replace(strval, "\n", "<br>");
		strval = replace(strval, "&quot;","'" );

		return strval;
	}

	/**
	 * DB에 정보 입력시 각 태그 및 특수 기호를 DB에 적당한 값으로 변경
	 */
	public String checkWord(String strval){
		if ( strval == null ) {
			return "";
		}

		strval = replace(strval, "\"", "&quot;" );
		strval = replace(strval, "'", "&quot;" );
		strval = replace(strval, "<br>", "\n" );
//		strval = StrUtil.replace(strval, " ", "&nbsp;");
//		strval = StrUtil.replace(strval, "<", "&lt;" );
//		strval = StrUtil.replace(strval, ">", "&gt;" );

		return strval;
	}

	/**
	 * 전자를 반자로바꾼다.
	 * 작성 날짜: (2002-01-11 오전 9:51:38)
	 * @return java.lang.String
	 */
	public String full2half(String fullVal) {
		char halfChar;
		char ascii;
		StringBuffer sb = new StringBuffer();
		for(int i = 0; i < fullVal.length(); i++) {
	        ascii = fullVal.charAt(i);
	        if(65281 <= ascii && ascii <= 65339) {
	          halfChar = (char)(ascii - 65248);
	          sb.append(halfChar);
	        }
	        else if (ascii == 65340 || ascii == 65510) {
	          halfChar = 92;
	          sb.append(halfChar);
	        }
	        else if(65341 <= ascii && ascii <= 65374) {
	          halfChar = (char)(ascii - 65248);
	          sb.append(halfChar);
	        }
	        /*
	        else if(65341 <= ascii && ascii <= 65344) {
	          halfChar = (char)((int)ascii - 65248);
	          sb.append(halfChar);
	        }
	        else if(65371 <= ascii && ascii <= 65374) {
	          halfChar = (char)((int)ascii - 65248);
	          sb.append(halfChar);
	        }
	          */
	        else if(ascii == 12288) {
	          halfChar = ' ';
	          sb.append(halfChar);
	        }
	        else {
	          sb.append(fullVal.charAt(i));
	        }
	    }
	    return sb.toString();
	}

	/**
	 * 입력된 아스키값을 유니코드값으로 바꿔 리턴한다.
	 * 작성 날짜: (2000-04-11 오후 3:11:46)
	 * @return java.lang.String
	 */
	public String ascTouni(String str) {
		try	{
			return new String(str.getBytes("8859_1"), "KSC5601");
		}
		catch(UnsupportedEncodingException e) {
			return str;
		}
	}

	/**
	 * 반자를 전자로 바꾼다.
	 * 작성 날짜: (2002-01-11 오전 9:53:02)
	 */
	public String half2full(String HalfVal) {
		String[] FullChar = {
		"　", "！","＂","＃","＄","％","＆","＇","（",          //33~
		"）","＊","＋","，","－","．","／","０","１","２",      //41~
		"３","４","５","６","７","８","９","：","；","＜",      //51~
		"＝","＞","？","＠","Ａ","Ｂ","Ｃ","Ｄ","Ｅ","Ｆ",      //61~
		"Ｇ","Ｈ","Ｉ","Ｊ","Ｋ","Ｌ","Ｍ","Ｎ","Ｏ","Ｐ",      //71~
		"Ｑ","Ｒ","Ｓ","Ｔ","Ｕ","Ｖ","Ｗ","Ｘ","Ｙ","Ｚ",      //81~
		"［","￦","］","＾","＿","｀","Ａ","Ｂ","Ｃ","Ｄ",      //91~
		"Ｅ","Ｆ","Ｇ","Ｈ","Ｉ","Ｊ","Ｋ","Ｌ","Ｍ","Ｎ",      //101~
		"Ｏ","Ｐ","Ｑ","Ｒ","Ｓ","Ｔ","Ｕ","Ｖ","Ｗ","Ｘ",      //111~
		"Ｙ","Ｚ","｛","｜","｝","～"                           //121~
		};
		StringBuffer stFinal = new StringBuffer();

		int ascii;
		for(int i = 0; i < HalfVal.length(); i++) {
	 		ascii = HalfVal.charAt(i);
	 		if( (31 < ascii && ascii < 128)) {
				stFinal.append(FullChar[ascii-32]);
	 		}
	 		else {
				stFinal.append(HalfVal.charAt(i));
	 		}
		}

		return stFinal.toString();
	}

	/**
	 * 문자열을 delimeter를 기준으로 Vector로 잘라서 반
	 * 작성 날짜: (2001-11-15 오후 1:03:17)
	 */
	public Vector getStrCut(String str, String del) {
		if(str == null) return null;

		Vector result = new Vector();
		if(str.equals("")) return result;
		if(del == null || del.equals("")){
			  result.addElement(str);
			  return result;
		}
		int f = 0;
		int t = 0;
		while(f < str.length()){
			t = str.indexOf(del,f);
			if(t== -1) t = str.length();
				result.addElement(str.substring(f,t));
				f=t+del.length();
			}
			return result;
	}

	/**
	 * 대구은행 계좌번호를 만듭니다.<br>
	 * BBBKKCCCCCCD  ---> BBB-KK-CCCCCC-D<br>
	 *
	 * 타은행의 경우 그냥 쓰던가..'-'을 붙여야한다면<br>
	 * putDash()메소드를 쓰십시오..<br>
	 *
	 * 작성 날짜: (2001-11-09 오후 1:02:12)
	 * @return java.lang.String
	 */
	public String getAcctForm(String acct) {
		acct = acct.trim();

		if (acct == null){
    		return "";
    	} else if (acct.length() < 11) {
    	  return acct;
    	} else if (acct.length() == 11) {
    	  return acct.substring(0,3) + "-" + acct.substring(3,5) + "-" + acct.substring(5);
    	} else{
    	  return acct.substring(0,3) + "-" + acct.substring(3,5) + "-" + acct.substring(5,11) + "-" + acct.substring(11);
    	}
	}

	/**
	* 사업자번호 / 주민번호를 세팅한다.<br>
	* 형식: 123-45-67890 or  771021-1020102
	*
	*/
	public String getJuminForm(String str) {
		StringBuffer sb = new StringBuffer();
		if (str == null) {
			return null;
		}
		// 사업자번호일 경우
		if (str.trim().length() == 10) {
			sb.append(hsubstring(str, 0, 3));
			sb.append("-");
			sb.append(hsubstring(str, 3, 5));
			sb.append("-");
			sb.append(hsubstring(str, 5, 10));
			return sb.toString();
		}
		//주민번호일경우
		else 	if (str.trim().length() == 13) {
			if (str.startsWith("000")) {
                sb.append(hsubstring(str, 3, 6));
				sb.append("-");
				sb.append(hsubstring(str, 6, 8));
				sb.append("-");
				sb.append(hsubstring(str, 8, 13));
            } else {
            	sb.append(hsubstring(str, 0, 6));
				sb.append("-");
				sb.append(hsubstring(str, 6, 13));
            }

			return sb.toString();
		}
		else {
			return "";
		}
	}

	/**
	 * 전화번호 세개를 받아서 4칸에 맞게 공백을 넣어 리턴하는 메소드<br>
	 * 작성 날짜: (00-10-30 오후 5:36:27)
	 * @return java.lang.String
	 */
	public String getTelNo(String tel1,	String tel2,String tel3) {
		return getANstring(tel1,4) + getANstring(tel2,4) + getANstring(tel3,4);
	}

	/**
	 * 전화번호에 '-'를 끼워서 반환한다.
	 * @param tel
	 * @return String
	 */
	public String getTelNoForm(String tel) {
		return putChar(tel, "4,4", "-");
	}

	/**
	 * 원하는 길이만큼 공백(" ")을  세팅한다.
	 * IBUtil.setStrAlign(Mobil1,3,"L")
	 * 	+ IBUtil.setStrAlign(Mobil2,4,"L")
	 *  + IBUtil.setStrAlign(Mobil3,4,"L");//핸드폰번호
	 * 작성 날짜: (2001-07-27 오후 11:52:32)
	 * @return java.lang.String
	 * @param inputValue java.lang.String
	 * @param len int
	 */
	public String setStrAlign(String inputValue, int len,String flag) {
		String spaceTemp = "";
		if (inputValue == null) return "null";
		if (inputValue.length() > len) return inputValue.substring(0,len);
		else {
			for (int i =  inputValue.length(); i < len ; i++){
				spaceTemp += " ";
			}
		}

		if (flag.equals("R")) return inputValue + spaceTemp;
		else if (flag.equals("L")) return spaceTemp + inputValue;
		else if (flag.equals("l")) return spaceTemp + inputValue;
		else return inputValue + spaceTemp;
	}

	/**
	 * 전화번호에 대시(-)를 삽입해서 반환
	 * 작성 날짜: (2001-07-18 오후 11:31:11)
	 * @return java.lang.String '000-000-0000', '00-000-0000', '000-0000-0000'
	 * @param inputValue java.lang.String
	 */
	public String telAlignS(String inputValue) {
		if (inputValue == null) {
			return "";
		}
		else if (inputValue.length() < 2) {
			return "";
		}
		else {
			if (inputValue.substring(0,2).equals("02")){
				return inputValue.substring(0,2) + "-" + inputValue.substring(2,inputValue.length()-4) + "-" + inputValue.substring(inputValue.length()-4);
			}
			else{
				return inputValue.substring(0,3) + "-" + inputValue.substring(3,inputValue.length()-4) + "-" + inputValue.substring(inputValue.length()-4);
			}
		}
	}

	/**
	 * 금액포맷으로 변경한다.
	 * 작성 날짜: (2000-05-02 오후 6:36:32)
	 * @return java.lang.String
	 * @param strValue java.lang.String
	 * @exception java.io.IOException 예외 설명.
	 */
	public String toMoney(String strValue) {
		try	{
			strValue = strValue.trim();
			java.text.NumberFormat nF = java.text.NumberFormat.getInstance();
			strValue = nF.format(Double.valueOf(strValue).doubleValue());
			return nlc(strValue, 0) ? strValue : "0";
		}
		catch(Exception e) {
			return nlc(strValue, 0) ? strValue : "0";
		}
	}

	/**
	 * 입력된 String을 소수점으로 변환
	 * @param inString
	 * @param Para1
	 * @return
	 */
    public String Double2Number( String inString, String Para1 )
    {
        try{
            String new_str = "";                //return new String
            int n_str = inString.length();      //가공할 스트링의 길이
            int n_format = Para1.length() -1;   //들어온 Format의 길이
            if( n_str != n_format ) {           //가공할 문자열과 Format의 길이 틀리면 ConverterException발생
                return "LENGTH ERROR";
            }
            int n_dot = Para1.indexOf(".");     //Dot의 위치0부터 시작 (도트가 없을경우는 -1)
            new_str = inString.substring(0,n_dot);  //새로운 스트링을 Format에 맞게 변환한다.
            new_str += ".";
            new_str += inString.substring(n_dot, inString.length());

            byte[] new_byte = new byte[n_format+1];

            for( int i=0; i<n_format+1;i++ ) {
                if(Para1.charAt(i)=='#' && new_str.charAt(i)=='0') {        //Format은 #이고 데이터는 0이면 Space처리
                    new_byte[i] = (byte)' ';
                }else if(Para1.charAt(i)=='#' && new_str.charAt(i)!='0') {  //Format은 #인데 데이터가 0이 아니면 들어온 데이터를 삽입
                    new_byte[i] = (byte)new_str.charAt(i);
                }else if(Para1.charAt(i)=='0' && new_str.charAt(i)=='0') {
                    new_byte[i] = (byte)'0';
                }else if(Para1.charAt(i)=='0' && new_str.charAt(i)!='0') {
                    new_byte[i] = (byte)new_str.charAt(i);
                }else if(Para1.charAt(i)=='.') {
                    new_byte[i] = (byte)'.';
                }
            }
            String ret_str = new String(new_byte);
            return ret_str;
        }catch(Exception e){
            return "CONVERT ERROR";
        }
    }

    /**
     * 입력 string이 null이면 "0"을 반환
     * @param strTarget java.lang.String
     * @return java.lang.String
     */
    public static String null2zero(String strTarget) {
    	if ( strTarget == null ) return "0";
    	else if ( strTarget.trim().equals("") ) return "0";
    	else return strTarget.trim();
    }

    /**
     * 입력 string이 null이면 ""을 반환
     * @param strTarget java.lang.String
     * @return java.lang.String
     */
    public static String null2void(String strTarget) {
    	if ( strTarget == null ) return "";
    	else return strTarget.trim();
    }

    /**
     * 입력 string이 null이면 ""을 반환
     * @param strTarget java.lang.String
     * @return java.lang.String
     */
    public static String null2void(Object strTarget) {
    	if ( strTarget == null ) return "";
    	else return ((String)strTarget).trim();
    }

    /**
     * 입력 string이 null이면 ""을 반환
     * @param strTarget java.lang.String
     * @return java.lang.String
     */
    public static String null2void(Object strTarget, String dval) {
    	if ( strTarget == null ) return dval;
    	else if ( ((String)strTarget).equals("") ) return dval;
    	else return ((String)strTarget).trim();
    }

    /**
     * 입력 string이 null이면 ""을 반환
     * @param strTarget java.lang.String
     * @return java.lang.String
     */
    public static String null2void(String strTarget, String dval) {
    	if ( strTarget == null ) return dval;
    	else if ( strTarget.equals("") ) return dval;
    	else return strTarget.trim();
    }

    /**
     * 정해진 길이만큼 앞에서 "0"을 채움
     * @param inputValue java.lang.String
     * @param len int
     * @return java.lang.String
     */
    public String setLeftLeng(String inputValue, int len) {
    	String spaceTemp = "";
    	if (inputValue == null) return "null";
    	else if (inputValue.length() > len) return inputValue.substring(0,len);
    	else {
    		for (int i =  inputValue.length(); i < len ; i++){
    			spaceTemp += "0";
    		}
    	}

    	return spaceTemp + inputValue;
    }

    /**
     * String의 소수점포함 숫자의 포맷인 경우 소수점이하를 제거하여 반환
     * @param strValue java.lang.String
     * @return java.lang.String
     * @exception java.io.IOException 예외 설명.
     */
    public String toDecimal(String strValue) {

    	try {
    		return toDecimal(Double.valueOf(strValue).doubleValue());
    	} catch (Exception e) {
    		return strValue;
    	}
    }

    /**
     * 소수점이하 2자리로 포맷..input:xxxaa->output:xxx.aa
     * @param inputValue java.lang.string
     * @return java.lang.String
     * @exception java.io.IOException 예외 설명.
     */
    public String toMoneyF(String inputValue) {
    	if (inputValue == null) return "";
    	else if (inputValue.equals(".00")) return "0.00";
    	else if (inputValue.length() == 0 ) return "0.00";
    	else if (inputValue.length() == 1 ) return "0.0"+inputValue;
    	else if (inputValue.length() == 2 ) return "0." + inputValue;
    	else{
    		String beforeRnd = toMoney(inputValue.substring(0,inputValue.length()-2));
    		String afterRnd = inputValue.substring(inputValue.length()-2);
    		return beforeRnd + "." + afterRnd;
    	}
    }

	/**
	 * HashMap에서 키값이 널이 아니면 값을 반환
	 */
    public static String getHash(HashMap hs, String s) {
        String s1 = (String)hs.get(s);
        if(s1 != null)
            return s1;
        else
            return null;
    }

    /**
     * HashMap에서 키값이 널이 아니면 값을 세팅
     */
    public static void putHash(HashMap hs, String s, String s1) {
        if(s != null && s != "")
            hs.put(s, s1);
    }

	/**
	 * 한글 체크를 위한 내부클래스
	 * hsubstring 메소드를 위해서 필요하다.
	 * @author 대구렌탈
	 *
	 */
	class Hangul {
	    public boolean checkHan(char c) {
	        if(c >= '\uAC00' && '\uD7A3' >= c)
	            return true;
	        if(c >= '\u3131' && '\u318F' >= c)
	            return true;
	        if(c >= '\u1100' && '\u117F' >= c)
	            return true;
	        if(c >= '\uFF00' && '\uFF5E' >= c)
	            return true;
	        if(c >= '\u3000' && '\u303F' >= c)
	            return true;
	        return c >= '\260' && '\277' >= c;
	    }

	    public int countHan(String mixedString) {
	        int nHangulCnt = 0;
	        if(mixedString == null || mixedString == "")
	            return 0;
	        for(int i = 0; i < mixedString.length(); i++)
	        {
	            char c = mixedString.charAt(i);
	            if(checkHan(c))
	                nHangulCnt++;
	        }

	        return nHangulCnt;
	    }

	    public int fixedlength(String str) {
	        StringBuffer sb = new StringBuffer();
	        sb.append(str);
	        int cntHan = countHan(sb.toString());
	        return sb.length() + cntHan;
	    }
	}

	/**
	  * ',' 를 3자리 마다 삽입한다. 숫자일 경우
	  * 123456 -> 123,456
	  * 작성 날짜: (00-10-19 오전 2:02:15)
	  * @return java.lang.String
	  * @param str java.lang.String
	  */
	public static String putComma(String w) {

		double d = 0;
		try {
			d = Double.valueOf(w).doubleValue();
		}
		catch (Exception e) {
			d = 0;
		}

		return putComma(d);
	}

	/**
	  * ',' 를 3자리 마다 삽입한다. 숫자일 경우
	  * 소숫점 이하는 내림한다.
	  * 123456.99 -> 123,456
	  * 작성 날짜: (00-10-19 오전 2:02:15)
	  * @return java.lang.String
	  * @param str java.lang.String
	  */
	public static String putComma(double w) {
		return commaDF.format(Double.parseDouble(Rounddn(w, 0)));
	}

	/**
	* 지정자리에서 버림을 한다
	* 작성 날짜: (00-02-02 오후 9:52:11)
	* @return java.lang.String
	*/
	public static String Rounddn(double dbValue, int index) {
		String strDouble = Double.toString(dbValue);

		if (strDouble.substring(strDouble.indexOf('.') + 1).length() <= index)
			return strDouble;

		try {
			BigDecimal rounder =
				new BigDecimal(dbValue).setScale(index, java.math.BigDecimal.ROUND_DOWN);
			return toDecimal(rounder.doubleValue(), index);
		}
		catch (Exception e) {
			return String.valueOf(dbValue);
		}
	}

	/**
	* 지수를 정수로 변환..
	* 계산결과 소수점 이하 버림
	* 작성 날짜: (2000-05-02 오후 6:36:32)
	* @return java.lang.String
	* @param strTemp java.lang.String
	* @exception java.io.IOException 예외 설명.
	*/
	public static String toDecimal(double dbValue, int nCount) {
		try {
			StringBuffer sbTemp = new StringBuffer();
			if (nCount > 0) {
				sbTemp.append(".");
				for (int i = 0; i < nCount; i++) {
					sbTemp.append("#");
				}
			}
			else {
				sbTemp.append("0");

			}

			java.text.DecimalFormat dF = new java.text.DecimalFormat(sbTemp.toString());
			return dF.format(dbValue);
		}
		catch (Exception e) {
			return String.valueOf(dbValue);
		}
	}

	//------------------------------ CONVERT ---------------------------------------
	/**
     * Object data를 받아 NULL Check후 trim()된 형태의 data로 return한다.
     * @param trim()할 Object변수
     * @return trim String
     */
	public static String ntb(Object anyObj){
        return (anyObj == null || String.valueOf(anyObj).trim().length()==0 || String.valueOf(anyObj).equals("null"))
        ? "" : String.valueOf(anyObj).trim();
    }

    /**
     * 계좌 자리수에 맞춰 대시를 삽입해준다.
     */
    public String getDaeguFormat(String daegu_acct_no) {
		if ( daegu_acct_no == null ) return "";

		String ret_val = null;
		int acct_no_len = daegu_acct_no.length();

		if ( acct_no_len == 11 ) {
			ret_val =  daegu_acct_no.substring(0,3) + "-"
				+ daegu_acct_no.substring(3,5) + "-"
                + daegu_acct_no.substring(5,11);
		} else if ( acct_no_len == 12 ) {
			ret_val =  daegu_acct_no.substring(0,3) + "-"
				+ daegu_acct_no.substring(3,5) + "-"
                + daegu_acct_no.substring(5,11) + "-"
                + daegu_acct_no.substring(11,12);
		} else if ( acct_no_len == 14 ) {
			ret_val =  daegu_acct_no.substring(0,3) + "-"
				+ daegu_acct_no.substring(3,5) + "-"
                + daegu_acct_no.substring(5,11) + "-"
                + daegu_acct_no.substring(11,14);
        }

		return ret_val;
	}

	/**
	 * 문자를 지정한 기호로 잘라서 주어진 순서에 문자열을 돌려준다
	 */
	public String sliceStr(String paramStr, String delimStr, int position) {
		String retStr = "", tmpStr = "";

		if(paramStr != null) {
			StringTokenizer st = new StringTokenizer(paramStr, delimStr);

			for(int i=0; st.hasMoreTokens(); i++) {
				tmpStr = st.nextToken();
				if(i == position) {
					retStr = tmpStr;
				}
			}
		}

		return retStr;
	}

	/**
     * 소수점자리 없앰. 버림채택
     * 계산결과 소수점 이하 버림
     * @param dbValue java.lang.double
     * @return java.lang.String
     * @exception java.io.IOException 예외 설명.
     */
    public String toDecimal(double dbValue) {

    	try {
    		java.text.DecimalFormat dF = new java.text.DecimalFormat("0");
    		return dF.format(dbValue);
    	} catch (Exception e) {
    		return String.valueOf(dbValue);
    	}
    }

    /**
     * 지로번호의 검증번호를 산출한다.
     * @param 	giro 		java.lang.String
     * @return 	checkDigit 	java.lang.String
     */
    public String giroChkDgt(String giro) {
    	String wkgiro = null;
    	int	   chkdgt = 0;

		if ( giro == null ) return "0";
		else wkgiro = giro.trim();

		if (wkgiro.length() != 5) return "0";

		try {

			chkdgt = 	( Integer.parseInt( giro.substring(0,1) ) * 3 ) +
						( Integer.parseInt( giro.substring(1,2) ) * 7 ) +
						( Integer.parseInt( giro.substring(2,3) ) * 1 ) +
						( Integer.parseInt( giro.substring(3,4) ) * 3 ) +
						( Integer.parseInt( giro.substring(4,5) ) * 7 );
		} catch(Exception e) {
			return "0";
		}

		chkdgt = chkdgt % 10;
		chkdgt = 10 - chkdgt;

		if ( chkdgt == 10 ) return  "0";
		else return Integer.toString(chkdgt);
    }

    public static boolean nlc(String s, int i) {
        boolean flag = false;
        if(s != null && s.length() > i)
            flag = true;
        return flag;
    }

    /**
     * so, si 붙어있는 한글필드 so,si 제거후 한글 반환 처리
     * @param 	korb 		java.lang.byte
     * @return
     */
	public static String sosi_kor(byte[] korb){
		String rtn = "";
		byte[] field = new byte[korb.length];
		for(int i = 0; i < korb.length; i++){
			if(korb[i] == 0x0e || korb[i] == 0x0f) {
				field[i] = 0x20;
			} else {
				field[i] = korb[i];
			}
		}

		try{
  			rtn = new String(field, "EUC-KR");
		} catch(Exception e){
			e.printStackTrace();
		}
		return rtn;
	}

    /**
     * so, si 붙어있는 한글필드 so,si 제거후 한글 반환 처리
     * @param 	korb 		java.lang.byte
     * @return
     */
	public static String sosi_kortrim(byte[] korb){
		String rtn = "";
		byte[] field = new byte[korb.length];
		for(int i = 0; i < korb.length; i++){
			if(korb[i] == 0x0e || korb[i] == 0x0f) {
				field[i] = 0x20;
			} else {
				field[i] = korb[i];
			}
		}

		try{
  			rtn = new String(field, "EUC-KR");
		} catch(Exception e){
			e.printStackTrace();
		}
		return rtn.trim();
	}

    /**
     * so,si 없는 한글필드 so, si 붙어있는 한글필드로 변환
     * @param 	korb 		java.lang.byte
     * @return
     */
	public static String tranSoSi(byte[] korb){
		String rtn = "";
		boolean space = false;
		byte[] field = new byte[korb.length + 2];
		field[0] = 0x0e;
		for(int i = 0; i < korb.length; i++){
			if(space){
				field[i+2] = korb[i];
			} else if(korb[i] == 0x20 ) {
				space = true;
				field[i+1] = 0x0f ;
				field[i+2] = korb[i];
			} else {
				field[i+2] = korb[i];
			}
		}

		try{
  			rtn = new String(field, "EUC-KR");
		} catch(Exception e){
			e.printStackTrace();
		}
		return rtn;
	}


    /**
     * 정해진 길이만큼 앞에서  주어진 문자를  채움
     * @param inputValue 원본문자열
     * @param len 리턴문자열 총 길이
     * @param pad 채울문자
     * @return java.lang.String
     */
    public static String getLeftPadding(String inputValue, int len, String pad) {
    	String spaceTemp = "";
    	String rtn = null;
    	if (inputValue == null) return null;
    	else if (inputValue.length() > len) rtn = inputValue.substring(0,len);
    	else {
    		for (int i =  inputValue.length(); i < len ; i++){
    			spaceTemp += pad;
    		}
    		rtn = spaceTemp + inputValue;
    	}

    	return rtn;
    }

    /**
     * 정해진 길이만큼 뒤에서  주어진 문자를  채움
     * @param inputValue 원본문자열
     * @param len 리턴문자열 총 길이
     * @param pad 채울문자
     * @return java.lang.String
     */
    public static String getRightPadding(String inputValue, int len, String pad) {
    	String spaceTemp = "";
    	String rtn = null;
    	if (inputValue == null) return null;
    	else if (inputValue.length() > len) rtn = inputValue.substring(0,len);
    	else {
    		for (int i =  inputValue.length(); i < len ; i++){
    			spaceTemp += pad;
    		}
    		rtn = inputValue + spaceTemp;
    	}

    	return rtn;
    }
    /**
     *
     *
     * @param s
     * @return
     */
    public static byte[] binaryStringToByteArray(String s) {
        int count = s.length() / 8;
        byte[] b = new byte[count];
        for (int i = 1; i < count; ++i) {
            String t = s.substring((i - 1) * 8, i * 8);
            b[i - 1] = binaryStringToByte(t);
        }
        return b;
    }

    /**
     *
     *
     * @param s
     * @return
     */
    public static byte binaryStringToByte(String s) {
        byte ret = 0, total = 0;
        for (int i = 0; i < 8; ++i) {
            ret = (s.charAt(7 - i) == '1') ? (byte) (1 << i) : 0;
            total = (byte) (ret | total);
        }
        return total;
    }

    /**
     * 금액 콤마
     * @param str
     * @return
     */
	public static String getAmtCommaForm(String str) {
		long tempVal = Long.parseLong(str);
		DecimalFormat df = new DecimalFormat("#,##0");
		return df.format(tempVal);
	}

}
