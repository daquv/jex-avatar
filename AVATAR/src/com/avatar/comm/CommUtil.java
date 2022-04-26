package com.avatar.comm;

import java.net.InetAddress;
import java.util.Enumeration;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import MTransKeySrvLib.MTransKeySrv;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.sys.JexSystem;
import jex.sys.JexSystemConfig;
import jex.web.exception.JexWebBIZException;


@SuppressWarnings({ "unchecked", "rawtypes" })
public class CommUtil {

	private static String FullSpace = "　";

	public static String getPtlId(){
		return JexSystemConfig.get("semo_info", "ptl_id");
	}
	public static String getChnlId(){
		return JexSystemConfig.get("semo_info", "chnl_id");
	}
	public static String getCntsId(){
		return JexSystemConfig.get("semo_info", "cnts_id");
	}

	public static String getServiceDomain(){
		return JexSystemConfig.get("semo_info", "svcdomain");
	}

	public static String getAdminDomain(){
		return JexSystemConfig.get("semo_info", "admdomain");
	}

	public static String getHomeDomain(){
		return JexSystemConfig.get("semo_info", "admdomain");
	}


	/**
	 * <pre>
	 * 세모장부 API key
	 * </pre>
	 * @return
	 */
//	public static String getSemoAPIKey() {
//		return "d18b0e32-4f3f-408e-ba27-d106a67ec98b";
//	}

	/**
	 * <pre>
	 * 쿠콘 서버스크래핑 API 인증키
	 * </pre>
	 * @return
	 */
	public static String getCooconAPIKEY(){
//		return "bYSLhosBXwsyYfAZfPEm";  //세모_스크래핑인증키
		return "nycf1li9XdXdqGhN5sin"; //아바타_스크래핑인증키  !!!!
	}

	/**
	 * <pre>
	 * 플로우 API 인증키
	 * </pre>
	 * @return
	 */
	public static String getFlowAPIKEY(){
		return "20190524_a7793dbd-235c-4ab8-bffe-a70cd65ec6d7";
	}

	/**
	 * <pre>
	 * 쿠콘 서버스크래핑 예금주성명 API 인증키
	 * </pre>
	 * @param apiId
	 * @return
	 */
	public static String getCooconSECRKEY(String inq_dv){
		// 예금주성명조회
		if("1".equals(inq_dv)){
			return "HIiPqvi8HEbZdZVXIL7v";
		}
		// 예금주실명조회
		else if("2".equals(inq_dv)){
			return "HIiPqvi8HEbZdZVXIL7v";
		}
		else{
			return "";
		}
	}

	public static String getProtocol(){
		return JexSystemConfig.get("semo_info", "Protocol");
	}

	/**
	 * 우체국 우편번호 조회 키
	 */
	public static String getRegkey(){
		return "ef14f56a4eb3f7f011447305954202";
	}

	public static String getHostUrlScrap(){
		return JexSystemConfig.get("cooconApiCenter", "Scrap_Url");
	}

	public static String getHostUrl(){
		return JexSystemConfig.get("cooconApiCenter", "Data_Url");
	}
	
	public static String getHostUrlcard(){
		return JexSystemConfig.get("cooconApiCenter", "Card_Url");
	}

	public static String getAcctCertHostUrl(){
		return JexSystemConfig.get("cooconApiCenter", "Cert_Url");
	}

	public static String getAcctnmHostUrl(){
		return JexSystemConfig.get("cooconApiCenter", "Acctnm_Url");
	}

	public static String getHostUrlLongterm(){
		return JexSystemConfig.get("cooconApiCenter", "Longterm_Url");
	}
	
	public static String getHostUrlAvatar(){
		return JexSystemConfig.get("cooconApiCenter", "Avatar_Url");
	}

	public static String getFlowHostUrl(){
		return JexSystemConfig.get("flowApiCenter", "flow_Url");
	}

	public static String getSignHostUrl(){
		return JexSystemConfig.get("cooconApiCenter", "Sign_Url");
	}
	
	public static String getWdrwHostUrl(){
		return JexSystemConfig.get("cooconApiCenter", "Wdrw_Url");
	}

	public static String getSmartHostUrl(){
		return JexSystemConfig.get("cooconApiCenter", "Smart_url");
	}
	
	public static String getHostUserReg(){
		String platFormHost = "";
		if( CommUtil.isdev()){ // 개발
			platFormHost = "https://devplatform.wecontent.co.kr/ByPass";
		}else{ // 운영
			platFormHost = "https://www.weplatform.co.kr/ByPass";
		}
		return platFormHost;
	}

	public static boolean isdev() {
		boolean rtn = true;
		try{
			if(JexSystem.getProperty("JEX.id").indexOf("_DEV") > -1){
				rtn = true;
			}else{ // 리얼
				rtn = false;
			}
		}catch(Exception e){
			System.out.println("Error"+e);
		}
		return rtn;
	}

	public static String getHostIp() {
		String hostIp = "";
		try{
			InetAddress localHostAddress = InetAddress.getLocalHost();

			hostIp = localHostAddress.toString();

		}catch(Exception e){
			System.out.println("Error"+e);
		}
		return hostIp.trim();
	}

	/**
	 * sms 인증 url
	 */
	public static String getSmsCertify(){
		return JexSystemConfig.get("smsAPI", "api_url");
	}

	/**
	 * sms 인증키
	 */
	public static String getSmsCertifyKey(){
		if( CommUtil.isdev()){ // 개발
			return "e06fa9ff-694a-e823-58f8-ee078dc01688";
		}else{ // 운영
			return "21581eff-410b-00f7-ba31-eff8a9c47cb6";
		}
	}

	/**
	 * sms 수진전화번호
	 */
	public static String getSendNum(){
		return JexSystemConfig.get("smsAPI", "Send_Num");
	}

	public static String getPushApiKey(){
		String ApiKey = "AIzaSyCd2BXzFYQXsuZ5UXGf02Llw4wfjRyHxNk";
		return ApiKey;
	}

	public static String getPushServer(){
		return JexSystemConfig.get("push_api", "api_url");
	}

	public static String getPushPrjid(){
		return JexSystemConfig.get("push_api", "prjid_ios");
	}

	public static String getPushPrjid_ANDROID(){
		return JexSystemConfig.get("push_api", "prjid_aos");
	}

	public static String getPushCompid(){
		return JexSystemConfig.get("push_api", "user_id");
	}

	// 캐시원
	public static String getCashOneUrl(){
		return JexSystemConfig.get("admin_cash1", "url");
	}
	
	// 캐시원2
	public static String getCashOneUrl2(){
		return JexSystemConfig.get("admin_cash1", "url2");
	}

	// 캐시원
	public static String getCashOneUrlHttp(){
		return JexSystemConfig.get("admin_cash1", "Protocol");
	}

	//NAS
    public static String getNasPath(){

        String Prjid = "";
        if( CommUtil.isdev()){ // 개발
            Prjid = "/WAS_DATA/webRoot/avatar/src/file";
        }else{ // 운영
            Prjid = "/webRoot/avatar/src/file";
        }
        return Prjid;
    }

	public static String replaceFullSpace(String str){
		return str.replaceAll(" ", CommUtil.FullSpace);
	}


	/**
	 * 클래스명가져오기
	 */
	public static String getClassName(Object callerClass) {
	    String csname = "";
    	csname = callerClass.getClass().getName();
    	csname = csname.substring(csname.lastIndexOf(".")+1);

		return csname;
	}

	/**
	 * 복호화
	 */
	public static String getDecrypt(String key, String str){

		byte[] aKey = key.getBytes();

		String decrypted = MTransKeySrv.MTK_Decrypt(aKey, str);

		if(decrypted == null){
			decrypted = "error :: " + MTransKeySrv.MTK_GetLastError();
		}

		return decrypted;
	}

    public static String decryptCertData(String encStr){
        String ret = "";

        try{
            String key = encStr.substring(0,10);
            String flag = encStr.substring(10,11);
            String data = encStr.substring(11);

            //android 5.0 미만, ios인 경우
            if("0".equals(flag)){
                ret = KISA_SEED_CBC_Util.decrypt(data, key);
            }
            //android 5.0 이상인 경우
            else if("1".equals(flag)){
                ret = AESUtils.decrypt(data, key);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return ret;
    }

//    public  static String base64Encoding(String value)
//	{
//		String retVal = "";
//
//		try
//		{
//			byte[] plainText = null; // 평문
//			plainText = value.getBytes();
//
//			//sun.misc.BASE64Encoder encoder = new sun.misc.BASE64Encoder();
//			//retVal = encoder.encode(plainText);
//			retVal = java.util.Base64.getEncoder().encodeToString(plainText);
//
//		}catch(Exception e){
//
//			e.printStackTrace();
//		}
//
//		return retVal;
//
//	}

	public static String getScqKey(String user_id){
		String ScqKey = "";

		try{
			ScqKey = KISA_SEED_CBC_Util.getInstance().getSHA256(user_id);
			if(ScqKey.length() > 15) ScqKey = ScqKey.substring(0,16);
			else ScqKey = SvcStringUtil.getRightPadding(ScqKey,16, "S");
		}catch(Exception e){
			e.printStackTrace();
		}

		return ScqKey;
	}

	public static String getScqKey(){
		String keyString = "";
		Random rnd = new Random();
		keyString = Long.toString(rnd.nextLong());
		keyString = SvcStringUtil.getRightPadding(keyString, 32, "S");
		return CommUtil.getScqKey(keyString);
	}

	public static String getPreScqKey(){
		String strBord_key = "";
		String strInput = "AVATARMOBILE";
		try{
			strBord_key = KISA_SEED_CBC_Util.getInstance().getSHA256(strInput).toLowerCase();
			strBord_key = strBord_key.substring(10,26);
		}catch(Exception e){
			e.printStackTrace();
		}
		return strBord_key;
	}
	/*
	 * 오른쪽으로 공백채우기
	 */
	public static String getStringGapFulRight(String str, int len, String addStr) {
        String result = str;
        byte[] strByte = null;
        try{

        	int templen   = len - str.getBytes("euc-kr").length;
        	for (int i = 0; i < templen; i++){
        		result = result + addStr;
        	}

        }catch(Exception e){
        	e.printStackTrace();
        }

        return result;
    }

	public static String getNonStrCardNo(String CardNo, String CardType) {
        String result = "";
        String strCardType = null;
        String charCardno = "";
        String charTypeno = "";
        try{
        	strCardType = CardType.replace("-", "");
        	if(strCardType.length() == CardNo.length()){
	        	int templen   = strCardType.length();
	        	for (int i = 0; i < templen; i++){
	        		charCardno = CardNo.substring(i, i+1);
	        		charTypeno = strCardType.substring(i, i+1);
	        		if(!charTypeno.equals("x") && !charTypeno.equals("*")){
	        			result = result + charCardno;
	        		}
	        	}
        	}
        }catch(Exception e){
        	e.printStackTrace();
        }

        return result;
    }

	/*
	 * coocon 전문전송시 은행종류(IB_TYPE) 가지고 오기
	 * sc 경우 2.기업뱅킹(First-Biz), 3.기업뱅킹(Straight2Bank)
	 * 하나 경우 2.hana CBS Light, 3.hana CBS
	 * 1.개인 2.기업, 3.기타
	 */

	public static String getCooconIbType(String bankCd, String type){
		String ib_type = "";

		// 저축은행은 개인/기업 구분에 상관없이 ib_type = 1
		if("501".equals(bankCd) || "502".equals(bankCd) || "503".equals(bankCd) || "504".equals(bankCd) || "505".equals(bankCd) ||
				   "507".equals(bankCd) || "508".equals(bankCd) || "512".equals(bankCd) || "515".equals(bankCd) || "518".equals(bankCd) ||
				   "527".equals(bankCd) || "530".equals(bankCd) || "539".equals(bankCd) || "542".equals(bankCd) || "545".equals(bankCd) ||
				   "547".equals(bankCd) || "548".equals(bankCd) || "549".equals(bankCd) || "523".equals(bankCd) || "550".equals(bankCd) ||
				   "551".equals(bankCd) || "552".equals(bankCd) || "553".equals(bankCd) || "554".equals(bankCd) || "556".equals(bankCd) ||
				   "534".equals(bankCd) || "557".equals(bankCd) || "558".equals(bankCd) || "559".equals(bankCd) || "537".equals(bankCd)
		){
			ib_type = "1";
		}else {
			if("1".equals(type)){
				// 개인
				if("002".equals(bankCd) || "004".equals(bankCd) || "005".equals(bankCd) || "007".equals(bankCd) || "011".equals(bankCd) ||
				   "020".equals(bankCd) || "088".equals(bankCd) || "027".equals(bankCd) || "031".equals(bankCd) || "034".equals(bankCd) ||
				   "035".equals(bankCd) || "037".equals(bankCd) || "039".equals(bankCd) || "045".equals(bankCd) || "081".equals(bankCd)
				   ){

					ib_type = "0";
				}else if( "003".equals(bankCd) || "023".equals(bankCd) || "032".equals(bankCd) || "071".equals(bankCd) || "048".equals(bankCd) ||
						  "054".equals(bankCd) || "057".equals(bankCd) || "060".equals(bankCd) || "064".equals(bankCd)){
					ib_type = "1";
				}

			}else if("2".equals(type)){
				// 기업
		        if("002".equals(bankCd) || "004".equals(bankCd) || "005".equals(bankCd) || "007".equals(bankCd) || "011".equals(bankCd) ||
		                "020".equals(bankCd) || "088".equals(bankCd) || "027".equals(bankCd) || "031".equals(bankCd) || "034".equals(bankCd) ||
		                "035".equals(bankCd) || "037".equals(bankCd) || "039".equals(bankCd) || "045".equals(bankCd) || "057".equals(bankCd) ||
		                "060".equals(bankCd) || "064".equals(bankCd)){

		                 ib_type = "1";

		        }else if("003".equals(bankCd) || "081".equals(bankCd)){
		            ib_type = "3";
		        }else if("023".equals(bankCd) || "032".equals(bankCd) || "071".equals(bankCd) || "048".equals(bankCd) || "054".equals(bankCd) ){
		            ib_type = "2";
		        }

			}else if("3".equals(type)){
				// sc 경우 2.기업뱅킹(First-Biz), 3.기업뱅킹(Straight2Bank)
				// 하나 경우 2.hana CBS Light, 3.hana CBS
				if("023".equals(bankCd) || "081".equals(bankCd)){
					ib_type = "3";
				}

			}
		}

		return ib_type;

	}

	/*
	 * coocon 전문전송시 은행종류(IB_TYPE)에 대한 개인/기업 구분값 조회
	 * 0.개인 1.기업
	 */
	public static String getIbType(String bankCd, String ib_type){
		String bank_gb = "";

		if("0".equals(ib_type)){
			if("002".equals(bankCd) || "004".equals(bankCd) || "005".equals(bankCd) || "007".equals(bankCd) || "011".equals(bankCd) ||
					   "020".equals(bankCd) || "088".equals(bankCd) || "027".equals(bankCd) || "031".equals(bankCd) || "034".equals(bankCd) ||
					   "035".equals(bankCd) || "037".equals(bankCd) || "039".equals(bankCd) || "045".equals(bankCd) || "081".equals(bankCd)
			){
				// 개인
				bank_gb = "0";
			}
		}else if("1".equals(ib_type)){
			if( "003".equals(bankCd) || "023".equals(bankCd) || "032".equals(bankCd) || "071".equals(bankCd) || "048".equals(bankCd) || "054".equals(bankCd)){
				// 개인
				bank_gb = "0";

			}else if("002".equals(bankCd) || "004".equals(bankCd) || "005".equals(bankCd) || "007".equals(bankCd) || "011".equals(bankCd) ||
		                "020".equals(bankCd) || "088".equals(bankCd) || "027".equals(bankCd) || "031".equals(bankCd) || "034".equals(bankCd) ||
		                "035".equals(bankCd) || "037".equals(bankCd) || "039".equals(bankCd) || "045".equals(bankCd) || "081".equals(bankCd) ||
		                "057".equals(bankCd) || "060".equals(bankCd) || "064".equals(bankCd)){
				// 기업
				bank_gb = "1";
			}
		}else if("2".equals(ib_type)){
			if("023".equals(bankCd) || "032".equals(bankCd) || "071".equals(bankCd) || "048".equals(bankCd) || "054".equals(bankCd)){
				// 기업
				bank_gb = "1";
			}
		}else if("3".equals(ib_type)){
			if("003".equals(bankCd) || "023".equals(bankCd) || "081".equals(bankCd)){
				// 기업
				bank_gb = "1";
			}
		}
		return bank_gb;

	}

	/**
	 * 요구불 계좌 체크
	 * @param acct
	 * @return
	 */
	public static boolean acctDistinction(String acct){
		boolean result = false;

		int subAcct = Integer.parseInt( getAcctGwamok(acct) );


		// 20160613 '06' 계좌 추가
		switch(subAcct){
			case 1:   case 2:   case 6:   case 12:  case 17:  case 40:  case 51:  case 52:  case 55: case 56:
			case 301: case 302: case 312: case 317: case 351: case 352: case 355: case 356:
			case 501: case 502: case 512: case 517: case 551: case 552: case 555: case 556:
				result = true;
				break;
			default:
				break;
		}

		return result;
	}
	/**
	 * 계좌 구분값 반환
	 * @param acct
	 * @return
	 */
	public static String getAcctGwamok(String acct){

		String result = "-1";
		int acctLength = acct.length();

		// 맞춤계좌일 경우 요구불 값 반환
		if(isOrderedAcct(acct)){
			result = "01";
		}else{

			switch (acctLength) {
			case 11: result = acct.substring(3, 5); break;
			case 12: result = acct.substring(4, 6); break;
			case 13: result = acct.substring(0, 3); break;
			case 14:

				result = acct.substring(0, 3);
				if( "790".equals(result) || "791".equals(result) || "792".equals(result) || "793".equals(result)){
					result = acct.substring(0, 3);
				}else{
					result = acct.substring(6, 8);
				}

				break;
			case 15: result = acct.substring(6, 9); break;
			default:
				break;
			}

		}

		return result;

	}

	/**
	 * 맞춤계좌 체크
	 * @param acct
	 * @return
	 */
	public static boolean isOrderedAcct(String acct){
		boolean result = false;

		int acctLength = acct.length();
		String rightStr = acct.substring(acctLength-1);

		// 10, 13 자리고 끝이 '8', '9' 인계좌는 맞춤계좌번호
		if((acctLength == 10 || acctLength == 13) && ( "8".equals(rightStr) || "9".equals(rightStr) ) ){
		 	result = true;
		}

		return result;

	}

	/**
	 * title
	 * @param
	 * @return
	 */
	public static String getDomainTitle(){

		return "수금박사";
	}


	/**
	 *  리뉴얼 날짜
	 * @param
	 * @return
	 */
	public static int renewalDate(){

		return 20160901;
	}

	/**
     * BC카드 여부
     * @param bank_cd
     * @return
     */
	public static boolean isBCCard(String bank_cd){

		if( "30000060".equals(bank_cd) || "30000061".equals(bank_cd) || "30000062".equals(bank_cd) ||
                "30000063".equals(bank_cd) || "30000064".equals(bank_cd)){ // bc 카드일경우 // 기업,대구, 부산, 경남, SC
			return true;
        }
		if( "060".equals(bank_cd) || "061".equals(bank_cd) || "062".equals(bank_cd) ||
                "063".equals(bank_cd) || "064".equals(bank_cd)){ // bc 카드일경우 // 기업,대구, 부산, 경남, SC
			return true;
        }
        return false;
    }

	public static void passwordRulConfirm(String pwd) throws JexWebBIZException, JexException, JexBIZException {
		System.out.println("pwd >> " + pwd);
		if(pwd.length() != 6){
			throw new JexWebBIZException(COMCode.COM_CODE_0020, COMCode.getErrCodeCustMsg(COMCode.COM_CODE_0020));
        }

		char[] user_pwd_arr = pwd.toCharArray();
        for(int i = 0 ; i < user_pwd_arr.length -2 ; i++){

            int tempInt = user_pwd_arr[i];
            System.out.println("-----------------");
            System.out.println(tempInt);
            System.out.println((int) user_pwd_arr[i + 1]);
            System.out.println((int) user_pwd_arr[i + 2]);
            System.out.println("-----------------");
            // 0 ~ 9 일 경루 체크
            if(tempInt >= 48 && tempInt <= 57){

                // 연속된 숫자 체크 '1234' 체크
                if(tempInt + 1 == user_pwd_arr[i + 1]  &&  tempInt + 2 == user_pwd_arr[i + 2]  ){
                    // "세 자리 이상 연속된 숫자는 사용할 수 없습니다.(123)";
                	throw new JexWebBIZException(COMCode.COM_CODE_0021, COMCode.getErrCodeCustMsg(COMCode.COM_CODE_0021));
                }else if(tempInt == user_pwd_arr[i + 1]  &&  tempInt == user_pwd_arr[i + 2]  ){
                    // 1111, 3333 체크
                	throw new JexWebBIZException(COMCode.COM_CODE_0022, COMCode.getErrCodeCustMsg(COMCode.COM_CODE_0022));
                }
            } else {
            	throw new JexWebBIZException(COMCode.COM_CODE_0023, COMCode.getErrCodeCustMsg(COMCode.COM_CODE_0023));
            }
        }

        // 비밀번호에 공백 체크
        if(pwd.contains(" ")){
        	throw new JexWebBIZException(COMCode.COM_CODE_0024, COMCode.getErrCodeCustMsg(COMCode.COM_CODE_0024));
        }
	}

	public static void emailRuleConfrim(String email) throws JexWebBIZException, JexException, JexBIZException {

		String pwPattern = "^[_0-9a-zA-Z-]+@[0-9a-zA-Z-]+(.[_0-9a-zA-Z-]+)*$";




        Matcher matcher = Pattern.compile(pwPattern).matcher(email);

        if(!matcher.matches()){
        	throw new JexWebBIZException(COMCode.COM_CODE_0019, COMCode.getErrCodeCustMsg(COMCode.COM_CODE_0019));
        }
	}

	public static String getHostName() {

		String hostname = "";
		try {
			hostname = InetAddress.getLocalHost().getHostName();
		}catch(Exception e) {
			e.printStackTrace();
		}

		return hostname;
	}


	public static String getHeader(HttpServletRequest request) {

		String header = "";

		Enumeration<String> em = request.getHeaderNames();

		StringBuffer sb = new StringBuffer();

	    while(em.hasMoreElements()){
	        String name = em.nextElement() ;
	        String val = request.getHeader(name) ;
	        sb.append(name + " : " + val + "\n");
	        //out.println(name + " : " + val) ;
	    }
	    if(sb.toString().length() > 400) {
	    	header = sb.toString().substring(0, 399);
	    }else {
	    	header = sb.toString();
	    }

	    return header;
	}

	/**
	 * <pre>
	 * 인증서 정보에서 개인키를 Base64로 인코딩하여 반환함.
	 * </pre>
	 * @param cert_data
	 * @return
	 */
	public static String getCertPriKeyBase64(String cert_data) {

		int fileNameIndex1 = cert_data.indexOf("signPri.key");
		int fileHexDateLength1 = Integer.parseInt(cert_data.substring(fileNameIndex1 + 11, fileNameIndex1 + 16).trim());

		int startIndex = fileNameIndex1 + 16;
		int endIndex = startIndex + fileHexDateLength1;

		String tmpHexPriKey = cert_data.substring(startIndex, endIndex);

		byte[] encodedBytes = org.apache.commons.codec.binary.Base64.encodeBase64(HexUtils.toByte(tmpHexPriKey));

		return new String(encodedBytes);
	}
	
	/**
     * 두 지점간의 거리 계산
     *
     * @param lat1 지점 1 위도
     * @param lon1 지점 1 경도
     * @param lat2 지점 2 위도
     * @param lon2 지점 2 경도
     * @param unit 거리 표출단위 - 마일(Mile):"", "미터(Meter):meter", 킬로미터(Kilo Meter):"kilometer"
     * @return
     */
	public static double distance(double lat1, double lon1, double lat2, double lon2, String unit) {
    	double theta = lon1 - lon2;
        double dist = Math.sin(deg2rad(lat1)) * Math.sin(deg2rad(lat2)) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.cos(deg2rad(theta));
         
        dist = Math.acos(dist);
        dist = rad2deg(dist);
        dist = dist * 60 * 1.1515;
         
        if (unit == "kilometer") {
            dist = dist * 1.609344;
        } else if(unit == "meter"){
            dist = dist * 1609.344;
        }
 
        return (dist);
    }
 
    // This function converts decimal degrees to radians
	public static double deg2rad(double deg) {
        return (deg * Math.PI / 180.0);
    }
     
    // This function converts radians to decimal degrees
	public static double rad2deg(double rad) {
        return (rad * 180 / Math.PI);
    }
}
