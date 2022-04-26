package com.avatar.api.mgnt;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;

import jex.JexContext;
import jex.data.JexData;
import jex.data.JexDataList;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.json.JSONArray;
import jex.json.JSONObject;
import jex.json.parser.JSONParser;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.util.DomainUtil;
import jex.util.StringUtil;
import jex.util.biz.JexCommonUtil;
import jex.util.date.DateTime;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.CommUtil;
import com.avatar.comm.ExternalConnectUtil;
import com.avatar.comm.KISA_SEED_CBC_Util;
import com.avatar.comm.SvcDateUtil;

public class CooconApi {

    /**
     * <pre>
     * 계좌등록
     * </pre>
     * @param acct_gubun
     * @param org_cd
     * @param comp_idno
     * @param cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @param web_id
     * @param web_pwd
     * @param acct_no
     * @param acct_pw
     * @param ib_type
     * @param reg_type
     * @param bank_type
     * @return
     */
    public static JSONObject insertAcct(String acct_gubun, String org_cd, String comp_idno, String cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data
            , String web_id, String web_pwd, String acct_no, String acct_pw, String ib_type
            , String reg_type, String bank_type){

        return data_wapi_0100("001", "I", acct_gubun, org_cd, comp_idno, ""
                , cert_name, "", cert_org, cert_date, cert_pwd, cert_folder, cert_data
                , reg_type, ""
                , web_id, web_pwd
                , acct_no, acct_pw, ib_type, bank_type, ""
                , "", ""
                , "", "", "");
    }

    /**
     * <pre>
     * 계좌수정
     * </pre>
     * @param acct_gubun
     * @param org_cd
     * @param comp_idno
     * @param cert_name
     * @param before_cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @param web_id
     * @param web_pwd
     * @param acct_no
     * @param acct_pw
     * @param ib_type
     * @param reg_type
     * @param bank_type
     * @return
     */
    public static JSONObject updateAcct(String acct_gubun, String org_cd, String comp_idno
            , String cert_name, String before_cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data
            , String web_id, String web_pwd, String acct_no, String acct_pw, String ib_type
            , String reg_type, String bank_type){

        return data_wapi_0100("001", "U", acct_gubun, org_cd, comp_idno, ""
                , cert_name, before_cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data
                , reg_type, ""
                , web_id, web_pwd
                , acct_no, acct_pw, ib_type, bank_type, ""
                , "", ""
                , "", "", "");
    }

    /**
     * <pre>
     * 계좌삭제
     * </pre>
     * @param acct_gubun
     * @param org_cd
     * @param comp_idno
     * @param acct_no
     * @param ib_type
     * @param reg_type
     * @param bank_type
     * @return
     */
    public static JSONObject deleteAcct(String acct_gubun, String org_cd, String comp_idno, String acct_no, String ib_type
    		, String reg_type, String bank_type){

        return data_wapi_0100("001", "D", acct_gubun, org_cd, comp_idno, ""
                , "", "", "", "", "", "", ""
                , reg_type, ""
                , "", ""
                , acct_no, "", ib_type, bank_type, ""
                , "", ""
                , "", "", "");
    }

    /**
     * <pre>
     * 전계좌 조회 - 인증서정보
     * </pre>
     * @param org_cd
     * @param ib_type
     * @param cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @param acct_dv
     * @return
     */
    public static JSONObject getAcctListWithCertInfo(String org_cd, String ib_type
            , String cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data, String acct_dv){

        StringBuffer sbSendData = new StringBuffer();
        sbSendData.append(CommUtil.getStringGapFulRight(org_cd, 3, " ")); // 기관코드(3byte):
        sbSendData.append(CommUtil.getStringGapFulRight(ib_type, 1, " ")); // 뱅킹 구분(1byte):
        sbSendData.append(CommUtil.getStringGapFulRight("", 50, " ")); // 사용자ID(50byte)
        sbSendData.append(CommUtil.getStringGapFulRight("", 20, " ")); // 사용자비밀번호(20byte)
        sbSendData.append(CommUtil.getStringGapFulRight(acct_dv, 1, " ")); // 조회구분  1:수시입출금,2:예적금,3:대출금(1byte)
        sbSendData.append(CommUtil.getStringGapFulRight("", 50, " ")); // 값이 있으면 해당 계좌에 대한 정보만
        sbSendData.append(CommUtil.getStringGapFulRight("", 50, " ")); // 외환) 계좌번호+확장으로 사이트에서 보이는 경우 있음(50byte)
        sbSendData.append(CommUtil.getStringGapFulRight("", 13, " ")); // 기업은행 퇴직연금(13byte)
        sbSendData.append(CommUtil.getStringGapFulRight("", 5, " ")); // 수협 대출금, 하나 CBS 수시입출/예적금(5byte)
        sbSendData.append(CommUtil.getStringGapFulRight(cert_name, 64, " "));    // 인증서이름(64byte)
        sbSendData.append(CommUtil.getStringGapFulRight(cert_org, 1, " "));  // 인증서발급기관(1byte)
        sbSendData.append(CommUtil.getStringGapFulRight(cert_date, 8, " "));  // 인증서만료일자(8byte)
        sbSendData.append(CommUtil.getStringGapFulRight(cert_pwd, 30, " "));   // 인증서비밀번호(30byte)
        sbSendData.append(CommUtil.getStringGapFulRight(cert_folder, 255, " ")); // 인증서경로명(폴더명)(255byte)
        sbSendData.append(CommUtil.getStringGapFulRight(cert_data, 16000, " "));  // 인증서데이터(16000byte)
        
        String encryptKey = "";
        String encryptdata = "";

        try {
            encryptKey = KISA_SEED_CBC_Util.generateRandomKey();
            encryptdata = KISA_SEED_CBC_Util.encrypt(sbSendData.toString(), encryptKey);
        } catch (Exception e) {
            e.printStackTrace();
        }
        sbSendData.setLength(0);

        JSONObject inputData = new JSONObject();
        inputData.put("SEND_DATA", encryptKey + "0" + encryptdata);

        return call_gateway("0201", inputData);
    }

    /**
     * <pre>
     * 전계좌 조회 - 등록된 인증서명
     * </pre>
     * @param comp_idno
     * @param org_cd
     * @param ib_type
     * @param cert_name
     * @param acct_dv
     * @return
     */
    public static JSONObject getAcctListWithCertName(String comp_idno, String org_cd, String ib_type, String cert_name, String acct_dv){

        try {
            cert_name = URLEncoder.encode(cert_name,"UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        JSONObject inputData = new JSONObject();
        inputData.put("ORG_CD"   , org_cd);    //은행코드
        inputData.put("CERTNAME" , cert_name); //인증서명
        inputData.put("COMP_IDNO", comp_idno); //사업자 번호
        inputData.put("WEB_ID"	 , "");        //사용자ID
		inputData.put("WEB_PW"   , "");        //사용자비밀번호
		inputData.put("GUBUN"    , acct_dv);   //조회구분 (1:수시입출금, 2:예적금, 3:대출금)
        inputData.put("IB_TYPE"  , ib_type);   //뱅킹구분

        return call_data_wapi("0201", inputData);
    }
    
    /**
     * <pre>
     * 전계좌 조회 - 등록된 인증서명
     * </pre>
     * @param comp_idno
     * @param org_cd
     * @param ib_type
     * @param cert_name
     * @return
     */
    public static JSONObject getAcctListWithCertName2(String comp_idno, String org_cd, String ib_type, String cert_name){
    	JSONObject inputData = new JSONObject();
    	inputData.put("ORG_CD"   , org_cd);    //은행코드
    	inputData.put("CERTNAME" , cert_name); //인증서명
    	inputData.put("COMP_IDNO", comp_idno); //사업자 번호
    	inputData.put("WEB_ID"	 , "");        //사용자ID
    	inputData.put("WEB_PW"   , "");        //사용자비밀번호
    	inputData.put("IB_TYPE"  , ib_type);   //뱅킹구분
    	
    	return call_data_wapi("0201", inputData);
    }
    
    /**
     * <pre>
     * 전계좌 조회 - ID/PW
     * </pre>
     * @param comp_idno
     * @param org_cd
     * @param ib_type
     * @param web_id
     * @param web_pwd
     * @return
     */
    public static JSONObject getAcctListWithID(String org_cd, String ib_type, String web_id, String web_pwd){

        StringBuffer sbSendData = new StringBuffer();
        sbSendData.append(CommUtil.getStringGapFulRight(org_cd.trim(), 3, " ")); // 기관코드(3byte):
        sbSendData.append(CommUtil.getStringGapFulRight(ib_type, 1, " ")); 		 // 뱅킹 구분(1byte):
        sbSendData.append(CommUtil.getStringGapFulRight(web_id, 50, " ")); 		 // 사용자ID(50byte)
        sbSendData.append(CommUtil.getStringGapFulRight(web_pwd, 20, " ")); 	 // 사용자비밀번호(20byte)
        sbSendData.append(CommUtil.getStringGapFulRight("1", 1, " ")); 			 // 조회구분  1:수시입출금(1byte)
        sbSendData.append(CommUtil.getStringGapFulRight("", 50, " ")); 			 // 값이 있으면 해당 계좌에 대한 정보만
	    sbSendData.append(CommUtil.getStringGapFulRight("", 50, " ")); 			 // 외환) 계좌번호+확장으로 사이트에서 보이는 경우 있음(50byte)
	    sbSendData.append(CommUtil.getStringGapFulRight("", 13, " ")); 			 // 기업은행 퇴직연금(13byte)
	    sbSendData.append(CommUtil.getStringGapFulRight("", 5, " ")); 			 // 수협 대출금, 하나 CBS 수시입출/예적금(5byte)
	    sbSendData.append(CommUtil.getStringGapFulRight("", 64, " "));    		 // 인증서이름(64byte)
	    sbSendData.append(CommUtil.getStringGapFulRight("", 1, " "));  			 // 인증서발급기관(1byte)
	    sbSendData.append(CommUtil.getStringGapFulRight("", 8, " "));  			 // 인증서만료일자(8byte)
	    sbSendData.append(CommUtil.getStringGapFulRight("", 30, " "));   		 // 인증서비밀번호(30byte)
	    sbSendData.append(CommUtil.getStringGapFulRight("", 255, " ")); 		 // 인증서경로명(폴더명)(255byte)
	    sbSendData.append(CommUtil.getStringGapFulRight("", 16000, " "));  		 // 인증서데이터(16000byte)

        String encryptKey = "";
        String encryptdata = "";
        try {
            encryptKey = KISA_SEED_CBC_Util.generateRandomKey();
            encryptdata = KISA_SEED_CBC_Util.encrypt(sbSendData.toString(), encryptKey);
        } catch (Exception e) {
            e.printStackTrace();
        }
        sbSendData.setLength(0);

        JSONObject inputData = new JSONObject();
        inputData.put("SEND_DATA", encryptKey + "0" + encryptdata);

        return call_gateway("0201", inputData);
    }

    /**
     * <pre>
     * 계좌 잔액조회 - 실시간, 인증서정보 - 사용안함.
     * </pre>
     * @param org_cd
     * @param ib_type
     * @param acct_no
     * @param acct_pw
     * @param cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @return
     */
    public static JSONObject getAcctAmountWithCertInfo(String org_cd, String ib_type, String acct_no, String acct_pw
            , String cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data ){

        StringBuffer sbSendData = new StringBuffer();
        sbSendData.append(CommUtil.getStringGapFulRight(org_cd       ,     3, " ")); // 3    금융기관코드:[참고1]금융기관코드 참고
        sbSendData.append(CommUtil.getStringGapFulRight(ib_type      ,     1, " ")); // 1    뱅킹구분
        sbSendData.append(CommUtil.getStringGapFulRight(""           ,    50, " ")); // 50   사용자 ID구)외환, 하나은행 필요
        sbSendData.append(CommUtil.getStringGapFulRight(""           ,    20, " ")); // 20   사용자 비밀번호구)외환, 하나은행 필요
        sbSendData.append(CommUtil.getStringGapFulRight(acct_no      ,    50, " ")); // 50   계좌번호
        sbSendData.append(CommUtil.getStringGapFulRight(""           ,     5, " ")); // 5    통화코드
        sbSendData.append(CommUtil.getStringGapFulRight(acct_pw      ,    20, " ")); // 20   계좌비밀번호(옵션)SC제일은행 필요
        sbSendData.append(CommUtil.getStringGapFulRight(""           ,    50, " ")); // 50   계좌번호확장새마을금고인 경우 금고번호입력
        sbSendData.append(CommUtil.getStringGapFulRight(""           ,    10, " ")); // 10   뱅킹종류
        sbSendData.append(CommUtil.getStringGapFulRight(cert_name    ,    64, " ")); // 64   인증서이름
        sbSendData.append(CommUtil.getStringGapFulRight(cert_org     ,     1, " ")); // 1    인증서 발급기관
        sbSendData.append(CommUtil.getStringGapFulRight(cert_date    ,     8, " ")); // 8    인증서 만료일자
        sbSendData.append(CommUtil.getStringGapFulRight(cert_pwd     ,    30, " ")); // 30   인증서 비밀번호
        sbSendData.append(CommUtil.getStringGapFulRight(cert_folder  ,   255, " ")); // 255  인증서 경로명(폴더명)
        sbSendData.append(CommUtil.getStringGapFulRight(cert_data    , cert_data.length(), " "));

        String encryptKey = "";
        String encryptdata = "";
        try {
            encryptKey = KISA_SEED_CBC_Util.generateRandomKey();
            encryptdata = KISA_SEED_CBC_Util.encrypt(sbSendData.toString(), encryptKey);
        } catch (Exception e) {
            e.printStackTrace();
        }
        sbSendData.setLength(0);

        JSONObject inputData = new JSONObject();
        inputData.put("SEND_DATA", encryptKey + "0" + encryptdata);

        return call_gateway("0202", inputData);
    }

    /**
     * <pre>
     * 계좌 잔액조회 - 실시간, 등록된 인증서명 - 사용안함.
     * </pre>
     * @param comp_idno
     * @param org_cd
     * @param ib_type
     * @param web_id
     * @param web_pw
     * @param acct_no
     * @param acct_pw
     * @param currency
     * @param account_password 계좌비밀번호(SC은행-인터넷,대구은행-기업인터넷의 경우 필수)
     * @param banking_type 
     * @param account_no_ext  
     * @param cert_name
     * @return
     */
    public static JSONObject getAcctAmountWithCertName(String comp_idno, String org_cd, String ib_type, 
    		String web_id, String web_pw, String acct_no, String acct_pw, String currency, 
    		String account_password, String banking_type, String account_no_ext, String cert_name){

        JSONObject inputData = new JSONObject();
        inputData.put("COMP_IDNO"      	, comp_idno); 		// 사업자번호
        inputData.put("ORG_CD"          , org_cd);    		// 은행코드
        inputData.put("IB_TYPE"         , ib_type);   		// 뱅킹구분
        inputData.put("WEB_ID"         	, web_id);   		// 사용자ID
        inputData.put("WEB_PW"         	, web_pw);   		// 사용자비밀번호
        inputData.put("ACCT_NO"         , acct_no);   		// 계좌번호
        inputData.put("CURRENCY"        , currency);   		// 통화코드
        inputData.put("ACCOUNT_PASSWORD", account_password);// 계좌비밀번호
        inputData.put("BANKING_TYPE"	, banking_type);   	// 뱅킹종류
        inputData.put("ACCOUNT_NO_EXT"	, account_no_ext);  // 계좌번호확장
        inputData.put("CERT_NAME"       , cert_name); 		// 인증서명

        return call_gateway_cert("0202", inputData);
    }

    /**
     * <pre>
     * 계좌 거래내역조회 - 실시간, 등록된 인증서명
     * </pre>
     * @param comp_idno
     * @param org_cd
     * @param ib_type
     * @param web_id
     * @param web_pwd
     * @param acct_no
     * @param acct_pw
     * @param cert_name
     * @param start_date
     * @param end_date
     * @return
     */
    public static JSONObject getAcctHstrWithCertName(String comp_idno, String org_cd, String ib_type, String web_id, String web_pwd
    		, String acct_no, String acct_pw, String cert_name, String start_date, String end_date){

    	JSONObject inputData = new JSONObject();
    	inputData.put("COMP_IDNO"       , comp_idno); // 사업자번호
        inputData.put("ORG_CD"          , org_cd);    // 은행코드
        inputData.put("IB_TYPE"         , ib_type);   // 뱅킹구분
        inputData.put("WEB_ID"          , web_id);    // 뱅킹아이디
        inputData.put("WEB_PW"          , web_pwd);   // 뱅킹비밀번호
        inputData.put("ACCT_NO"         , acct_no);   // 계좌번호
        inputData.put("ACCOUNT_PASSWORD", acct_pw);   // 계좌비밀번호
        inputData.put("START_DATE"      , start_date);// 조회시작일
        inputData.put("END_DATE"        , end_date);  // 조회종료일
        inputData.put("CERT_NAME"       , cert_name); // 인증서명

        return call_gateway_cert("0203", inputData);
    }

    /**
     * <pre>
     * 계좌 거래내역조회 - 실시간, ID/PW - 사용암함.
     * </pre>
     * @param comp_idno
     * @param org_cd
     * @param ib_type
     * @param acct_no
     * @param acct_pw 계좌비밀번호(SC은행)
     * @param start_date
     * @param end_date
     * @param web_id
     * @param web_pwd
     * @return
     */
    public static JSONObject getAcctHstrWithFast(String comp_idno, String org_cd, String ib_type,
    		String acct_no, String acct_pw,
    		String start_date, String end_date,
    		String web_id, String web_pwd){

        JSONObject inputData = new JSONObject();
        inputData.put("ORG_CD"      , org_cd);    // 은행코드
        inputData.put("ACCT_NO"     , acct_no);   // 계좌번호
        inputData.put("ACCT_PW"     , acct_pw);   // 계좌비밀번호
        inputData.put("COMP_IDNO"   , comp_idno); // 사업자번호
        inputData.put("START_DATE"  , start_date);// 조회시작일
        inputData.put("END_DATE"    , end_date);  // 조회종료일
        inputData.put("WEB_ID"      , web_id);    // 사용자ID
        inputData.put("WEB_PW"      , web_pwd);   // 사용자비밀번호
        inputData.put("SSM_CD"      , ib_type);   // 뱅킹구분

        return call_data_wapi("0203", inputData);
    }

    /**
     * <pre>
     * 인증서 변경 - 사용안함.
     * </pre>
     * @param biz_cd_list
     * @param comp_idno
     * @param org_cd
     * @param before_cert_name
     * @param cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @return
     * @throws Exception
     */
    public static JSONObject updateCertInfo(String biz_cd_list, String comp_idno, String org_cd, String before_cert_name
            , String cert_name, String cert_org, String cert_date, String cert_pwd
            , String cert_folder, String cert_data) throws Exception{

        JSONObject inputDataSub = new JSONObject();
        inputDataSub.put("BEFORE_CERT_NAME" , before_cert_name);
        inputDataSub.put("CERT_NAME"        , cert_name);
        inputDataSub.put("CERT_ORG"         , cert_org);
        inputDataSub.put("CERT_DATE"        , cert_date);
        inputDataSub.put("CERT_PWD"         , cert_pwd);
        inputDataSub.put("CERT_FOLDER"      , cert_folder);
        inputDataSub.put("CERTDATA"         , cert_data);

        String encryptKey = KISA_SEED_CBC_Util.generateRandomKey();
        String encryptJsondata = KISA_SEED_CBC_Util.encrypt(inputDataSub.toJSONString(), encryptKey);

        JSONObject inputData = new JSONObject();
        inputData.put("BIZ_CD"     , "001");    	// 001고정
        inputData.put("GUBUN"      , "U");       	// “I”(등록),”U”(수정),”D”(삭제)
        inputData.put("COMP_IDNO"  , comp_idno); 	// 사업자번호, 실명확인번호
        inputData.put("ORG_CD"     , org_cd);    	// 수정시에만 필요
        inputData.put("REG_TYPE"   , "1");       	// 0: 등록한 인증서가 있는 경우, 1:인증서 최초등록
        inputData.put("BIZ_CD_LIST", biz_cd_list);	// 001:은행(계좌), 002:현금영수증, 003:법인카드, 004:여신금융협회가맹점매출, 005:개인카드, 006:전자세금계산서  ex)001,002,005,006
        inputData.put("REG_DATA"   , encryptKey+"0"+encryptJsondata); // 인증서 데이터

        return call_data_wapi("0200", inputData);
    }

    /**
     * <pre>
     * 인증서 삭제 - 사용안함.
     * </pre>
     * @param comp_idno
     * @param cert_nm
     * @param biz_cd_list
     * @return
     * @throws Exception
     */
    public static JSONObject deleteCertInfo(String comp_idno, String cert_nm, String biz_cd_list) throws Exception{

        JSONObject inputDataSub = new JSONObject();
        inputDataSub.put("CERT_NAME"      , cert_nm);
        inputDataSub.put("CERT_ORG"       , "");
        inputDataSub.put("CERT_DATE"      , "");
        inputDataSub.put("CERT_PWD"       , "");
        inputDataSub.put("CERT_FOLDER"    , "");
        inputDataSub.put("CERTDATA"       , "");

        String encryptKey = KISA_SEED_CBC_Util.generateRandomKey();
        String encryptJsondata = KISA_SEED_CBC_Util.encrypt(inputDataSub.toJSONString(), encryptKey);

        JSONObject inputData = new JSONObject();
        inputData.put("BIZ_CD"    , "001");
        inputData.put("GUBUN"     , "D");       	// “I”(등록),”U”(수정),”D”(삭제)
        inputData.put("COMP_IDNO" , comp_idno); 	// 사업자번호, 실명확인번호
        inputData.put("ORG_CD"    , "");        	// 수정시에만 필요
        inputData.put("REG_TYPE"  , "0");       	// 0: 등록한 인증서가 있는 경우, 1:인증서 최초등록
        inputData.put("BIZ_CD_LIST", biz_cd_list);	// 001:은행(계좌), 002:현금영수증, 003:법인카드, 004:여신금융협회가맹점매출, 005:개인카드, 006:전자세금계산서  ex)001,002,005,006
        inputData.put("REG_DATA"  , encryptKey+"0"+encryptJsondata); // 인증서 데이터

        return call_data_wapi("0200", inputData);
    }

    /**
     * <pre>
     * 개인카드정보등록
     * </pre>
     * @param org_cd 카드사코드
     * @param comp_idno 사용자식별키 (사업자번호,뱅킹ID,개인식별키 등..)
     * @param card_owner_code (카드식별번호)
     * @param company (회원사 :BC카드일경우 사용)
     * @param cert_name 인증서명
     * @param cert_org 인증서 기관
     * @param cert_date 인증서 만료일자
     * @param cert_pwd 인증서 비밀번호
     * @param cert_folder 인증서 폴더
     * @param cert_data 인증서 데이타
     * @param reg_type
     * @param bank_type
     * @return
     */
    public static JSONObject insertPsnlCard(String org_cd, String comp_idno, String card_owner_code, String company
            , String cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data
            , String reg_type, String bank_type){

        return data_wapi_0100("005", "I", "", org_cd, comp_idno, card_owner_code
                , cert_name, "", cert_org, cert_date, cert_pwd, cert_folder, cert_data
                , reg_type, ""
                , "", ""
                , "", "", "", bank_type, company
                , "", ""
                , "", "", "");
    }

    /**
     * <pre>
     * 개인카드정보변경
     * </pre>
     * @param org_cd 카드사코드
     * @param comp_idno 사용자식별키 (사업자번호,뱅킹ID,개인식별키 등..)
     * @param card_owner_code (카드식별번호)
     * @param company 회원사(BC카드일 경우 필수)
     * @param cert_name 인증서명
     * @param before_cert_name 인증서명
     * @param cert_org 인증서 기관
     * @param cert_date 인증서 만료일자
     * @param cert_pwd 인증서 비밀번호
     * @param cert_folder 인증서 폴더
     * @param cert_data 인증서 데이타
     * @param reg_type
     * @param bank_type
     * @return
     */
    public static JSONObject updatePsnlCard(String org_cd, String comp_idno, String card_owner_code, String company
            , String cert_name, String before_cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data
            , String reg_type, String bank_type){

        return data_wapi_0100("005", "U", "", org_cd, comp_idno, card_owner_code
                , cert_name, before_cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data
                , reg_type, ""
                , "", ""
                , "", "", "", bank_type, company
                , "", ""
                , "", "", "");
    }

    /**
     * <pre>
     * 개인카드정보삭제
     * </pre>
     * @param org_cd 카드사코드
     * @param comp_idno 사용자식별키 (사업자번호,뱅킹ID,개인식별키 등..)
     * @param card_owner_code 카드식별번호
     * @param reg_type
     * @param bank_type
     * @return
     */
    public static JSONObject deletePsnlCard(String org_cd, String comp_idno, String card_owner_code
    		, String reg_type, String bank_type){

        return data_wapi_0100("005", "D", "", org_cd, comp_idno, card_owner_code
                , "", "", "", "", "", "", ""
                , reg_type, ""
                , "", ""
                , "", "", "", bank_type, ""
                , "", ""
                , "", "", "");
    }

    /**
     * <pre>
     * 개인카드 목록조회 - 실시간, 인증서정보
     * </pre>
     * @param org_cd 기관코드
     * @param cert_name 인증서이름
     * @param cert_org 인증서발급기관
     * @param cert_date 인증서만료일자
     * @param cert_pwd 인증서비밀번호
     * @param cert_folder 인증서경로명
     * @param cert_data 인증서데이터
     * @return
     */
    public static JSONObject getPsnlCardListWithCertInfo(String org_cd
            , String cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data ){

        StringBuffer sbSendData = new StringBuffer();
        sbSendData.append(CommUtil.getStringGapFulRight(org_cd, 3, " ")); 		// 기관코드
        sbSendData.append(CommUtil.getStringGapFulRight("1", 1, " ")); 			// 로그인구분 1:인증서, 2:아이디/비번
        sbSendData.append(CommUtil.getStringGapFulRight("", 50, " ")); 			// 웹ID(50byte)
        sbSendData.append(CommUtil.getStringGapFulRight("", 20, " ")); 			// 웹비밀번호(20byte)
        sbSendData.append(CommUtil.getStringGapFulRight(cert_name, 64, " "));   // 인증서이름(64byte)
        sbSendData.append(CommUtil.getStringGapFulRight(cert_org, 1, " "));  	// 인증서발급기관(1byte)
        sbSendData.append(CommUtil.getStringGapFulRight(cert_date, 8, " "));  	// 인증서만료일자(8byte)
        sbSendData.append(CommUtil.getStringGapFulRight(cert_pwd, 30, " "));   	// 인증서비밀번호(30byte)
        sbSendData.append(CommUtil.getStringGapFulRight(cert_folder, 255, " "));// 인증서경로명(폴더명)(255byte)
        sbSendData.append(CommUtil.getStringGapFulRight(cert_data, 16000, " "));// 인증서데이터(16000byte)

        String encryptKey = "";
        String encryptdata = "";
        try {
            encryptKey = KISA_SEED_CBC_Util.generateRandomKey();
            encryptdata = KISA_SEED_CBC_Util.encrypt(sbSendData.toString(), encryptKey);
        } catch (Exception e) {
            e.printStackTrace();
        }
        sbSendData.setLength(0);

        JSONObject inputData = new JSONObject();
        inputData.put("SEND_DATA", encryptKey + "0" + encryptdata);

        return call_data_wapi("0340", inputData);
    }

    /**
     * <pre>
     * 개인카드 목록조회 - 실시간, 등록된 인증서명
     * </pre>
     * @param comp_idno 사업자 번호(등록된 인증서 있을 경우 사용)
     * @param org_cd 기관코드
     * @param cert_name 인증서이름
     * @return
     */
    public static JSONObject getPsnlCardListWithCertName(String comp_idno, String org_cd, String cert_name ){

        JSONObject inputData = new JSONObject();
        inputData.put("ORG_CD"      , org_cd);    	//카드사 코드
        inputData.put("COMP_IDNO"   , comp_idno);  	//사업자 번호
        inputData.put("SEARCH_GUBUN", "1");     	//조회구분
        inputData.put("CERT_NAME"   , cert_name);  	//인증서명

        return call_data_wapi("0340", inputData);
    }

    /**
     * <pre>
     * 개인카드 승인내역조회 - 실시간, 등록된 인증서명
     * </pre>
     * @param comp_idno
     * @param org_cd
     * @param card_no
     * @param company
     * @param start_date
     * @param end_date
     * @param cert_name
     * @return
     */
    public static JSONObject getPsnlCardApprHstrWithCertName(String comp_idno, String org_cd, String card_no, String company, String start_date, String end_date, String cert_name){

        JSONObject inputData = new JSONObject();
        inputData.put("ORG_CD"    , org_cd); 			//카드사 코드
        inputData.put("LOGIN_TYPE", "1");     			//로그인구분(1:인증서, 2:아이디/비번)
        inputData.put("COMP_IDNO" , comp_idno); 		//사업자번호
        inputData.put("CARD_NO"   , card_no); 			//카드번호
        inputData.put("COMPANY"   , company); 			//회원사(BC카드인경우필수)
        inputData.put("START_DATE", start_date); 		//조회시작일자
        inputData.put("END_DATE"  , end_date); 			//조회종료일자
        inputData.put("CERT_NAME" , cert_name);			//인증서명
        inputData.put("SCRAP_INFO", "A");				//카드조회구분(1:전체카드,2:카드별,3:부서별,4:회원사별,5:농협PFMS(삼성카드),A:마스킹처리한 카드번호로 요청하는 경우)

        return call_longterm_wapi("0334", inputData);
    }

    /**
     * <pre>
     * 개인카드 청구내역조회 - 실시간, 등록된 인증서명 - 사용안함.
     * </pre>
     * @param comp_idno
     * @param org_cd
     * @param company
     * @param cert_name
     * @return
     */
    public static JSONObject getPsnlCardPaymentHstrWithCertName(String comp_idno, String org_cd, String company, String cert_name){

        JSONObject inputData = new JSONObject();
        inputData.put("ORG_CD"    , org_cd); 	//카드사 코드
        inputData.put("LOGIN_TYPE", "1");     	//로그인구분(1:인증서, 2:아이디/비번)
        inputData.put("COMP_IDNO" , comp_idno); //사업자번호
        inputData.put("COMPANY"   , company); 	//회원사(BC카드인경우필수)
        inputData.put("CERT_NAME" , cert_name);	//인증서명

        return call_gateway_cert("0332", inputData);
    }

    /**
     * <pre>
     * 개인카드 결제일 조회 - 실시간, 등록된 인증서명
     * </pre>
     * @param comp_idno
     * @param org_cd
     * @param company
     * @param cert_name
     * @return
     */
    public static JSONObject getPsnlCardPaymentDayWithCertName(String comp_idno, String org_cd, String cert_name){

    	JSONObject inputData = new JSONObject();
        inputData.put("ORG_CD"    , org_cd); 	//카드사 코드
        inputData.put("LOGIN_TYPE", "1");     	//로그인구분(1:인증서, 2:아이디/비번)
        inputData.put("COMP_IDNO" , comp_idno); //사업자번호
        inputData.put("CERT_NAME" , cert_name);	//인증서명

        return call_gateway_cert("0338", inputData);
    }

    /**
     * <pre>
     * 개인카드 포인트조회 - 실시간, 등록된 인증서명 - 사용안함.
     * </pre>
     * @param comp_idno
     * @param org_cd
     * @param cert_name
     * @return
     */
    public static JSONObject getPsnlCardPointWithCertName(String comp_idno, String org_cd, String cert_name){
        JSONObject inputData = new JSONObject();
        inputData.put("ORG_CD"    , org_cd); 	//카드사 코드
        inputData.put("LOGIN_TYPE", "1");     	//로그인구분(1:인증서, 2:아이디/비번)
        inputData.put("COMP_IDNO" , comp_idno); //사업자번호
        inputData.put("CERT_NAME" , cert_name);	//인증서명

        return call_gateway_cert("0342", inputData);
    }

    /**
     * 개인카드 한도내역조회 - 실시간, 등록된 인증서명 - 사용안함.
     * @param comp_idno 사업자번호
     * @param org_cd 카드사 코드
     * @param cert_name 인증서명
     * @return
     */
    public static JSONObject getPsnlCardMaxAmountHstrWithCertName(String comp_idno, String org_cd, String cert_name, String company){

        JSONObject inputData = new JSONObject();
        inputData.put("ORG_CD"    , org_cd); 	//카드사 코드
        inputData.put("LOGIN_TYPE", "1");     	//로그인구분(1:인증서, 2:아이디/비번)
        inputData.put("COMP_IDNO" , comp_idno); //사업자번호
        inputData.put("COMPANY"   , company); 	//회원사(BC카드인경우필수)
        inputData.put("CERT_NAME" , cert_name);	//인증서명

        return call_gateway_cert("0336", inputData);
    }

    /**
     * <pre>
     * 휴폐업 조회 (다건-실시간)
     * </pre>
     * @param source_regno
     * @param target_regno_01
     * @param target_regno_02
     * @param target_regno_03
     * @param target_regno_04
     * @param target_regno_05
     * @param target_regno_06
     * @param target_regno_07
     * @param target_regno_08
     * @param target_regno_09
     * @param target_regno_10
     * @return
     */
    public static JSONObject itx_wapi_9903(String source_regno, String target_regno_01, String target_regno_02, String target_regno_03
    		, String target_regno_04, String target_regno_05, String target_regno_06, String target_regno_07
    		, String target_regno_08, String target_regno_09, String target_regno_10) {

    	JSONObject reqData = new JSONObject();
    	reqData.put("SOURCE_REGNO", source_regno);
    	reqData.put("TARGET_REGNO_01", target_regno_01);
    	reqData.put("TARGET_REGNO_02", target_regno_02);
    	reqData.put("TARGET_REGNO_03", target_regno_03);
    	reqData.put("TARGET_REGNO_04", target_regno_04);
    	reqData.put("TARGET_REGNO_05", target_regno_05);
    	reqData.put("TARGET_REGNO_06", target_regno_06);
    	reqData.put("TARGET_REGNO_07", target_regno_07);
    	reqData.put("TARGET_REGNO_08", target_regno_08);
    	reqData.put("TARGET_REGNO_09", target_regno_09);
    	reqData.put("TARGET_REGNO_10", target_regno_10);

    	return call_gateway("9903", reqData);
    }

    /**
     * <pre>
     * 홈택스 부가가치세/종합소득세 정보등록
     * </pre>
     * @param comp_idno
     * @param ser_idno
     * @param cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @param reg_type
     * @param bank_type
     * @return
     */
    public static JSONObject insertEvdcTax( String comp_idno, String ser_idno
            , String cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data
            , String reg_type, String bank_type
            ){
        return data_wapi_0100("007", "I", "", "", comp_idno, ""
                , cert_name, "", cert_org, cert_date, cert_pwd, cert_folder, cert_data
                , reg_type , ser_idno
                , "", ""
                , "", "", "", bank_type, ""
                , "", ""
                , "", "", "");
    }

    /**
     * <pre>
     * 홈택스 부가가치세/종합소득세 정보수정
     * </pre>
     * @param comp_idno
     * @param ser_idno
     * @param cert_name
     * @param before_cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @param reg_type
     * @param bank_type
     * @return
     */
    public static JSONObject updateEvdcTax( String comp_idno, String ser_idno
            , String cert_name, String before_cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data
            , String reg_type, String bank_type
            ){
        return data_wapi_0100("007", "U", "", "", comp_idno, ""
                , cert_name, before_cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data
                , reg_type , ser_idno
                , "", ""
                , "", "", "", bank_type, ""
                , "", ""
                , "", "", "");
    }

    /**
     * <pre>
     * 홈택스 부가가치세/종합소득세 정보삭제
     * </pre>
     * @param comp_idno
     * @param ser_idno
     * @param cert_nm
     * @param reg_type
     * @param bank_type
     * @return
     */
    public static JSONObject deleteEvdcTax(String comp_idno, String ser_idno, String cert_nm, String reg_type, String bank_type){

        return data_wapi_0100("007", "D", "", "", comp_idno, ""
                , cert_nm, "", "", "", "", "", ""
                , reg_type , ser_idno
                , "", ""
                , "", "", "", bank_type, ""
                , "", ""
                , "", "", "");
    }

    /**
     * <pre>
     * 홈택스 전자세금계산서 정보등록
     * </pre>
     * @param comp_idno
     * @param ser_idno
     * @param cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @param reg_type
     * @param bank_type
     * @param taxpayer_regno
     * @param tax_agent_no
     * @param tax_agent_password
     * @return
     */
    public static JSONObject insertEvdcTxbl( String comp_idno, String ser_idno
            , String cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data
            , String reg_type, String bank_type, String taxpayer_regno, String tax_agent_no, String tax_agent_password
            ){
        return data_wapi_0100("006", "I", "", "", comp_idno, ""
                , cert_name, "", cert_org, cert_date, cert_pwd, cert_folder, cert_data
                , reg_type , ser_idno
                , "", ""
                , "", "", "", bank_type, ""
                , "", ""
                , taxpayer_regno, tax_agent_no, tax_agent_password);
    }

    /**
     * <pre>
     * 홈택스 전자세금계산서 정보수정
     * </pre>
     * @param comp_idno
     * @param ser_idno
     * @param cert_name
     * @param before_cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @param reg_type
     * @param bank_type
     * @param taxpayer_regno
     * @param tax_agent_no
     * @param tax_agent_password
     * @return
     */
    public static JSONObject updateEvdcTxbl( String comp_idno, String ser_idno
            , String cert_name, String before_cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data
            , String reg_type, String bank_type, String taxpayer_regno, String tax_agent_no, String tax_agent_password
            ){
        return data_wapi_0100("006", "U", "", "", comp_idno, ""
                , cert_name, before_cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data
                , reg_type , ser_idno
                , "", ""
                , "", "", "", bank_type, ""
                , "", ""
                , taxpayer_regno, tax_agent_no, tax_agent_password);
    }

    /**
     * <pre>
     * 홈택스 전자세금계산서 정보삭제
     * </pre>
     * @param comp_idno
     * @param ser_idno
     * @param cert_nm
     * @param reg_type
     * @param bank_type
     * @return
     */
    public static JSONObject deleteEvdcTxbl(String comp_idno, String ser_idno, String cert_nm, String reg_type, String bank_type){

        return data_wapi_0100("006", "D", "", "", comp_idno, ""
                , cert_nm, "", "", "", "", "", ""
                , reg_type , ser_idno
                , "", ""
                , "", "", "", bank_type, ""
                , "", ""
                , "", "", "");
    }

    /**
     * <pre>
     * 건강보험 정보등록
     * </pre>
     * @param comp_idno
     * @param ser_idno
     * @param cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @param reg_type
     * @param bank_type
     * @return
     */
    public static JSONObject insertEvdcMedi( String comp_idno, String ser_idno
            , String cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data
            , String reg_type, String bank_type){
        return data_wapi_0100("008", "I", "", "", comp_idno, ""
                , cert_name, "", cert_org, cert_date, cert_pwd, cert_folder, cert_data
                , reg_type , ser_idno
                , "", ""
                , "", "", "", bank_type, ""
                , "", ""
                , "", "", "");
    }

    /**
     * <pre>
     * 건강보험 정보수정
     * </pre>
     * @param comp_idno
     * @param ser_idno
     * @param cert_name
     * @param before_cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @param reg_type
     * @param bank_type
     * @return
     */
    public static JSONObject updateEvdcMedi( String comp_idno, String ser_idno
            , String cert_name, String before_cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data
            , String reg_type, String bank_type){
        return data_wapi_0100("008", "U", "", "", comp_idno, ""
                , cert_name, before_cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data
                , reg_type , ser_idno
                , "", ""
                , "", "", "", bank_type, ""
                , "", ""
                , "", "", "");
    }

    /**
     * <pre>
     * 건강보험 정보삭제
     * </pre>
     * @param comp_idno
     * @param ser_idno
     * @param cert_nm
     * @param reg_type
     * @param bank_type
     * @return
     */
    public static JSONObject deleteEvdcMedi(String comp_idno, String ser_idno, String cert_nm, String reg_type, String bank_type){

        return data_wapi_0100("008", "D", "", "", comp_idno, ""
                , cert_nm, "", "", "", "", "", ""
                , reg_type , ser_idno
                , "", ""
                , "", "", "", bank_type, ""
                , "", ""
                , "", "", "");
    }

    
    
    /**
     * <pre>
     * 전자세금계산서 매입/매출 목록조회 - 실시간, 인증서정보
     * </pre>
     * @param search_gubun 매입매출구분(1:매출, 2:매입, 3:매출(면세), 4:매입(면세))
     * @param start_date
     * @param end_date
     * @param cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @param tax_agent_no
     * @param tax_agent_password
     * @return
     */
    public static JSONObject getEvdcTxblHstrWithCertInfo(String search_gubun, String start_date, String end_date,
    		String cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data, String tax_agent_no, String tax_agent_password){
    	return CooconApi.getEvdcTxblHstrWithCertInfo(search_gubun, start_date, end_date, cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, "", tax_agent_no, tax_agent_password);
    }

    /**
     * <pre>
     * 전자세금계산서 매입/매출 목록조회 - 실시간, 인증서정보
     * </pre>
     * @param search_gubun 매입매출구분(1:매출, 2:매입, 3:매출(면세), 4:매입(면세))
     * @param start_date
     * @param end_date
     * @param cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @param taxpayer_regno
     * @param tax_agent_no
     * @param tax_agent_password
     * @return
     */
    public static JSONObject getEvdcTxblHstrWithCertInfo(String search_gubun, String start_date, String end_date,
    		String cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data,
    		String taxpayer_regno, String tax_agent_no, String tax_agent_password){

        String encryptKey = "";
        String encryptdata = "";

        try {
            encryptKey = KISA_SEED_CBC_Util.generateRandomKey();

            StringBuffer reqSendDataBuffer = new StringBuffer();
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight("0", 1, " "));             // 로그인방식(LOGINTYPE): 1: 아이디, 그외:인증서
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight("", 50, " "));             // 사용자ID(50byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight("", 20, " "));             // 사용자비밀번호(20byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(tax_agent_no, 30, " "));   // 세무대리인 관리번호(30byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(tax_agent_password, 20, " "));// 세무대리인 관리 비밀번호(20byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(taxpayer_regno, 15, " ")); // 납세자 사업자번호(15byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(search_gubun, 1, " "));    // 매입매출구분(1:매출, 2:매입, 3:매출(면세), 4:매입(면세))
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight("1", 5, " "));             // 조회기준(5byte) 1:작성일자,2:발행일자,3:전송일자 
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(start_date, 8, " "));      // 조회시작일자(8byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(end_date, 8, " "));        // 조회종료일자(8byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight("", 30, " "));   	      // 전자세금계산서 종류(대분류)(30byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight("", 30, " "));       	  // 전자세금계산서 종류(소분류)(30byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight("", 30, " "));             // 발행유형(30byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_name, 64, " "));      // 인증서이름(64byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_org, 1, " "));        // 인증서발급기관(1byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_date, 8, " "));       // 인증서만료일자(8byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_pwd, 30, " "));       // 인증서비밀번호(30byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_folder, 255, " "));   // 인증서경로명(폴더명)(255byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_data, 16000, " "));   // 인증서데이터(16000byte)
        	
            encryptdata = KISA_SEED_CBC_Util.encrypt(reqSendDataBuffer.toString().trim(), encryptKey);
            reqSendDataBuffer.setLength(0);
        } catch (Exception e) {
            e.printStackTrace();
        }
        JSONObject inputData = new JSONObject();
        inputData.put("SEND_DATA", encryptKey + "0" + encryptdata);

        return call_gateway("1335", inputData);
    }

    /**
     * <pre>
     * 전자세금계산서 매입/매출 목록조회 - 실시간, 등록된 인증서명
     * </pre>
     * @param compIdno
     * @param search_gubun 매입매출구분(1:매출, 2:매입, 3:매출(면세), 4:매입(면세))
     * @param start_date
     * @param end_date
     * @param cert_name
     * @param tax_agent_no
     * @param tax_agent_password
     * @return
     */
    public static JSONObject getEvdcTxblHstrWithCertName(String compIdno, String search_gubun, String start_date, String end_date, String cert_name, String tax_agent_no, String tax_agent_password){
    	return CooconApi.getEvdcTxblHstrWithCertName(compIdno, search_gubun, start_date, end_date, cert_name, "", tax_agent_no, tax_agent_password);
    }

    /**
     * <pre>
     * 전자세금계산서 매입/매출 목록조회 - 실시간, 등록된 인증서명
     * </pre>
     * @param compIdno
     * @param search_gubun 매입매출구분(1:매출, 2:매입, 3:매출(면세), 4:매입(면세))
     * @param start_date
     * @param end_date
     * @param cert_name
     * @param taxpayer_regno
     * @param tax_agent_no
     * @param tax_agent_password
     * @return
     */
    public static JSONObject getEvdcTxblHstrWithCertName(String compIdno, String search_gubun, String start_date, 
    		String end_date, String cert_name, String taxpayer_regno, String tax_agent_no, String tax_agent_password){

    	JSONObject inputData = new JSONObject();
        inputData.put("COMP_IDNO"		, compIdno); 			// 사업자번호
        inputData.put("TAX_AGENT_NO"	, tax_agent_no); 		// 세무대리인 관리번호
        inputData.put("TAX_AGENT_PASSWORD", tax_agent_password);// 세무대리인 관리비밀번호
        if(!"".equals(StringUtil.null2void(taxpayer_regno))){
        	inputData.put("TAXPAYER_REGNO"	, taxpayer_regno); 	// 발행유형 : 인터넷발급으로 셋팅
        }
        inputData.put("SEARCH_GUBUN"	, search_gubun); 		// 매입매출구분(1:매출, 2:매입, 3:매출(면세), 4:매입(면세))
        inputData.put("BASIC_DATE"		, "1"); 				// 조회기준 : 1:작성일자,2:발행일자,3:전송일자 
        inputData.put("START_DATE"		, start_date);			// 조회시작일자
        inputData.put("END_DATE"		, end_date);			// 조회종료일자
        inputData.put("TAX_TYPE1"		, "");					// 전자세금계산서 종류(대분류)
        inputData.put("TAX_TYPE2"		, ""); 					// 전자세금계산서 종류(소분류)
        inputData.put("PUBLISHING_TYPE"	, ""); 					// 발행유형
        inputData.put("CERT_NAME"		, cert_name);			// 인증서이름

        return call_data_wapi("1335", inputData);
    }

    /**
     * <pre>
     * 납부할 세액조회 - 실시간, 인증서정보
     * </pre>
     * @param cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @return
     */
    public static JSONObject getTaxHstrWithCertInfo(String cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data){
    	return CooconApi.getTaxHstrDtlWithCertInfo(cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data);
    }

    /**
     * <pre>
     * 납부할 세액조회 - 실시간, 인증서정보
     * </pre>
     * @param cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @return
     */
    public static JSONObject getTaxHstrDtlWithCertInfo(String cert_name, String cert_org, String cert_date, 
    		String cert_pwd, String cert_folder, String cert_data){

        String encryptKey = "";
        String encryptdata = "";

        try {
            encryptKey = KISA_SEED_CBC_Util.generateRandomKey();

            StringBuffer reqSendDataBuffer = new StringBuffer(); 
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_name, 64, " "));      // 인증서이름(64byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_org, 1, " "));        // 인증서발급기관(1byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_date, 8, " "));       // 인증서만료일자(8byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_pwd, 30, " "));       // 인증서비밀번호(30byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_folder, 255, " "));   // 인증서경로명(폴더명)(255byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_data, 16000, " "));   // 인증서데이터(16000byte)
        	
            encryptdata = KISA_SEED_CBC_Util.encrypt(reqSendDataBuffer.toString().trim(), encryptKey);
            reqSendDataBuffer.setLength(0);
        } catch (Exception e) {
            e.printStackTrace();
        }
        JSONObject inputData = new JSONObject();
        inputData.put("SEND_DATA", encryptKey + "0" + encryptdata);

        return call_gateway("1340", inputData);
    }

    /**
     * <pre>
     * 납부할 세액조회 - 실시간, 등록된 인증서명
     * </pre>
     * @param compIdno
     * @param cert_name
     * @return
     */
    public static JSONObject getTaxHstrWithCertName(String compIdno, String cert_name){
    	return CooconApi.getTaxHstrDtlWithCertName(compIdno, cert_name);
    }

    /**
     * <pre>
     * 납부할 세액조회 - 실시간, 등록된 인증서명
     * </pre>
     * @param compIdno
     * @param cert_name
     * @return
     */
    public static JSONObject getTaxHstrDtlWithCertName(String compIdno, String cert_name){

    	JSONObject inputData = new JSONObject();
        inputData.put("COMP_IDNO"		, compIdno); 			// 사업자번호
        inputData.put("CERT_NAME"		, cert_name);			// 인증서이름

        return call_gateway_cert("1340", inputData);
    }

    /**
     * <pre>
     * 전자세금계산서 매입/매출 목록조회 - 실시간, 등록된 인증서명 - 장기간
     * </pre>
     * @param compIdno
     * @param search_gubun 매입매출구분(1:매출, 2:매입, 3:매출(면세), 4:매입(면세))
     * @param start_date
     * @param end_date
     * @param cert_name
     * @param tax_agent_no
     * @param tax_agent_password
     * @return
     */
    public static JSONObject getEvdcTxblHstrWithCertNameLongTerm(String compIdno, String search_gubun, String start_date, String end_date, String cert_name, String tax_agent_no, String tax_agent_password){

    	JSONObject inputData = new JSONObject();
        inputData.put("COMP_IDNO"			, compIdno); 			// 사업자번호
        inputData.put("LOGIN_TYPE"			, "0");					// 로그인유형(1: 아이디, 2: 아이디 + 보안카드, 그외 : 인증서)
        inputData.put("WEBID"				, "");					// 아이디 
        inputData.put("WEBPASSWORD"			, "");					// 비밀번호
        inputData.put("TAX_AGENT_NO"		, tax_agent_no);		// 세무대리인 관리번호
        inputData.put("TAX_AGENT_PASSWORD"	, tax_agent_password);	// 세무대리인 관리비밀번호
        inputData.put("TAXPAYER_REGNO"		, "");					// 납세자 사업자번호
        inputData.put("SEARCH_GUBUN"		, search_gubun);		// 매입매출구분(1:매출, 2:매입, 3:매출(면세), 4:매입(면세))
        inputData.put("SEARCH_BASIC_DATE"	, "1"); 				// 조회기준  1:작성일자,2:발행일자,3:전송일자 
        inputData.put("ENUM_DATE_BEGIN"		, start_date);			// 조회시작일자
        inputData.put("ENUM_DATE_END"		, end_date);			// 조회종료일자
        inputData.put("TAX_TYPE1"			, "");					// 전자세금계산서(대분류)
        inputData.put("TAX_TYPE2"			, "");					// 전자세금계산서(소분류)
        inputData.put("PUBLISHING_TYPE"		, "");					// 조회종료일자
        inputData.put("CERT_NAME"			, cert_name);			// 인증서이름

        return call_longterm_wapi("1337", inputData);
    }
    
    /**
     * <pre>
     * 전자세금계산서 매입/매출 상세조회(실시간)
     * </pre>
     * @param compIdno
     * @param issu_id
     * @param cert_name
     * @param tax_agent_no
     * @param tax_agent_password
     * @return
     */
    public static JSONObject getEvdcTxblHstrDtlWithCertNameLongTerm(String compIdno, String issu_id, String cert_name, String tax_agent_no, String tax_agent_password){
    	
    	JSONObject inputData = new JSONObject();
    	inputData.put("COMP_IDNO"			, compIdno); 			// 사업자번호
    	inputData.put("APPROVAL_CODE"		, issu_id);				// 승인번호
    	inputData.put("BASIC_DATE"			, "1"); 				// 조회기준 1:작성일자,2:발행일자,3:전송일자 
    	inputData.put("TAX_AGENT_NO"		, tax_agent_no); 		// 세무대리인 관리번호 
    	inputData.put("TAX_AGENT_PASSWORD"	, tax_agent_password); 	// 세무대리인 관리비밀번호 
    	inputData.put("CERT_NAME"			, cert_name);			// 인증서이름
    	
    	return call_data_wapi("1336", inputData);
    }

    /**
     * <pre>
     * 홈택스 현금영수증 정보등록
     * </pre>
     * @param comp_idno
     * @param ser_idno
     * @param cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @param reg_type
     * @param bank_type
     * @param tax_agent_no
     * @param tax_agent_password
     * @return
     */
    public static JSONObject insertEvdcCash( String comp_idno, String ser_idno
            , String cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data
            , String reg_type, String bank_type, String tax_agent_no, String tax_agent_password
            ){

        return data_wapi_0100("002", "I", "", "", comp_idno, ""
                , cert_name, "", cert_org, cert_date, cert_pwd, cert_folder, cert_data
                , reg_type , ser_idno
                , "", ""
                , "", "", "", bank_type, ""
                , "", ""
                , "", tax_agent_no, tax_agent_password);
    }

    /**
     * <pre>
     * 홈택스 현금영수증 정보수정
     * </pre>
     * @param comp_idno
     * @param ser_idno
     * @param cert_name
     * @param before_cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @param reg_type
     * @param bank_type
     * @param tax_agent_no
     * @param tax_agent_password
     * @return
     */
    public static JSONObject updateEvdcCash( String comp_idno, String ser_idno
            , String cert_name, String before_cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data
            , String reg_type, String bank_type, String tax_agent_no, String tax_agent_password
            ){

        return data_wapi_0100("002", "U", "", "", comp_idno, ""
                , cert_name, before_cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data
                , reg_type , ser_idno
                , "", ""
                , "", "", "", bank_type, ""
                , "", ""
                ,"", tax_agent_no, tax_agent_password);
    }

    /**
     * <pre>
     * 홈택스 현금영수증 정보삭제
     * </pre>
     * @param comp_idno
     * @param ser_idno
     * @param cert_nm
     * @param reg_type
     * @param bank_type
     * @param tax_agent_no
     * @return
     */
    public static JSONObject deleteEvdcCash(String comp_idno, String ser_idno, String cert_nm, String reg_type, String bank_type, String tax_agent_no){

        return data_wapi_0100("002", "D", "", "", comp_idno, ""
                , cert_nm, "", "", "", "", "", ""
                , reg_type , ser_idno
                , "", ""
                , "", "", "", bank_type, ""
                , "", ""
                , "", tax_agent_no, "");
    }

    /**
     * <pre>
     * 현금영수증 매입내역조회 - 실시간, 등록된 인증서명
     * </pre>
     * @param compIdno
     * @param srch_date 조회일자(조회구분값에 따라 YYYYMMDD/YYYYMM)
     * @param cert_name
     * @param tax_agent_no
     * @param tax_agent_password
     * @return
     */
    public static JSONObject getEvdcCashBuyHstrWithCertName(String compIdno, String srch_date, String cert_name, String tax_agent_no, String tax_agent_password){
    	
        JSONObject inputData = new JSONObject();
        inputData.put("COMP_IDNO"   , compIdno);    // 사업자번호
        inputData.put("WEBID"   	, "");   		// 웹아이디
        inputData.put("WEBPASSWORD" , "");   		// 웹비밀번호
        inputData.put("YEAR_MONTH"  , srch_date);   // 조회일자(YYYYMM 조회기간 : MM-2 ~ M)
        inputData.put("SEARCH_GUBUN", "2");         // 조회구분(2: 월별 (고정))
        inputData.put("REGNO_RESIDENT", "");        // 조회사업자번호
        inputData.put("LOGIN_TYPE"	, "1");        	// 로그인방식(1: 인증서 (고정))
        inputData.put("TAX_AGENT_NO", tax_agent_no);// 세무대리인 관리번호
        inputData.put("TAX_AGENT_PASSWORD", tax_agent_password);// 세무대리인 관리비밀번호
        inputData.put("CERT_NAME"   , cert_name);  	//인증서명
        
        return call_gateway_cert("1347", inputData);
    }
    
    /**
     * <pre>
     * (구)현금영수증 매입내역조회 - 실시간, 등록된 인증서명
     * </pre>
     * @param compIdno
     * @param srch_date 조회일자(조회구분값에 따라 YYYYMMDD/YYYYMM)
     * @param cert_name
     * @return
     */
    public static JSONObject getEvdcCashBuyHstrWithCertName(String compIdno, String srch_date, String cert_name){
        JSONObject inputData = new JSONObject();
        inputData.put("COMP_IDNO"   , compIdno);   //사업자번호
        inputData.put("SER_IDNO"    , compIdno);   //실 조회 사업자번호
        inputData.put("SEARCH_GUBUN", "2");        //조회구분(2: 월별 (고정))
        inputData.put("YEAR_MONTH"  , srch_date);  //조회일자(YYYYMM 조회기간 : MM-2 ~ M)
        inputData.put("CERT_NAME"   , cert_name);  //인증서명

        return call_longterm_wapi("1332", inputData);
    }

    /**
     * <pre>
     * 현금영수증 매출내역조회 - 실시간, 등록된 인증서명
     * </pre>
     * @param compIdno
     * @param srch_div 조회구분(1:일별, 2:월별)
     * @param srch_date 조회일자(조회구분값에 따라 YYYYMMDD/YYYYMM)
     * @param cert_name
     * @param tax_agent_no
     * @param tax_agent_password
     * @return
     */
    public static JSONObject getEvdcCashSelHstrWithCertName(String compIdno, String srch_date, String cert_name, String tax_agent_no, String tax_agent_password){
    	JSONObject inputData = new JSONObject();
        inputData.put("COMP_IDNO"   		, compIdno);   	//사업자번호
        inputData.put("WEBID"   			, "");   	   	//웹아이디
        inputData.put("WEBPASSWORD" 		, "");   	   	//웹비밀번호
        inputData.put("YEAR_MONTH"  		, srch_date);  	//조회일자(YYYYMM 조회기간 : MM-2 ~ M)
        inputData.put("SEARCH_GUBUN"		, "2");        	//조회구분(2: 월별 (고정))
        inputData.put("REGNO_RESIDENT"		, "");	   		//조회사업자번호
        inputData.put("LOGIN_TYPE"    		, "1");      	//로그인방식(1: 인증서)
        inputData.put("TAX_AGENT_NO"  		, tax_agent_no);//세무대리인 관리번호
        inputData.put("TAX_AGENT_PASSWORD"	, tax_agent_password);//세무대리인 관리비밀번호
        inputData.put("CERT_NAME"   		, cert_name);   //인증서명

        return call_gateway_cert("1348", inputData);
    }
    
    /**
     * <pre>
     * (구)현금영수증 매출내역조회 - 실시간, 등록된 인증서명
     * </pre>
     * @param compIdno
     * @param srch_div 조회구분(1:일별, 2:월별)
     * @param srch_date 조회일자(조회구분값에 따라 YYYYMMDD/YYYYMM)
     * @param cert_name
     * @return
     */
    public static JSONObject getEvdcCashSelHstrWithCertName(String compIdno, String srch_date, String cert_name){
    	JSONObject inputData = new JSONObject();
        inputData.put("COMP_IDNO"   , compIdno);   //사업자번호
        inputData.put("SER_IDNO"    , compIdno);   //실 조회 사업자번호
        inputData.put("SEARCH_GUBUN", "2");        //조회구분(2: 월별 (고정))
        inputData.put("YEAR_MONTH"  , srch_date);  //조회일자(YYYYMM 조회기간 : MM-2 ~ M)
        inputData.put("CERT_NAME"   , cert_name);  //인증서명

        return call_longterm_wapi("1334", inputData);
    }

    /**
     * 여신금융협회정보 등록
     * @param comp_idno
     * @param ser_idno
     * @param web_id
     * @param web_pwd
     * @return
     */
    public static JSONObject insertCrefia(String comp_idno, String ser_idno, String web_id, String web_pwd){
        return data_wapi_0100("004", "I", "", "", comp_idno, ""
                , "", "", "", "", "", "", ""
                , "", ser_idno
                , web_id, web_pwd
                , "", "", "", "", ""
                , "", ""
                , "", "", "");
    }
    /**
     * 여신금융협회정보 수정
     * @param comp_idno
     * @param ser_idno
     * @param web_id
     * @param web_pwd
     * @return
     */
    public static JSONObject updateCrefia(String comp_idno, String ser_idno, String web_id, String web_pwd){
        return data_wapi_0100("004", "U", "", "", comp_idno, ""
                , "", "", "", "", "", "", ""
                , "", ser_idno
                , web_id, web_pwd
                , "", "", "", "", ""
                , "", ""
                , "", "", "");
    }

    /**
     * 여신금융협회정보 삭제
     * @param comp_idno
     * @param ser_idno
     * @param web_id
     * @return
     */
    public static JSONObject deleteCrefia(String comp_idno, String ser_idno, String web_id){
        return data_wapi_0100("004", "D", "", "", comp_idno, ""
                , "", "", "", "", "", "", ""
                , "", ser_idno
                , web_id, ""
                , "", "", "", "", ""
                , "", ""
                , "", "", "");
    }

    /**
     * 여신금융협회 아이디 검증
     * @param web_id
     * @param web_pwd
     * @return
     */
    public static JSONObject checkCrefiaVerification(String web_id, String web_pwd){

        JSONObject inputData = new JSONObject();
        inputData.put("SEARCH_GUBUN", "3"); // 조회구분 (1:법인카드 , 2:현금영수증, 3:여신금융협회 가맹점)
        inputData.put("ORGAN_CD", "090"); 	// 기관코드
        inputData.put("WEB_ID", web_id); 	// 빠른조회 ID
        inputData.put("WEB_PW", web_pwd); 	// 빠른조회 PW

        return call_scrap_wapi_0100("0103", inputData);
    }

    /**
     * <pre>
     * 여신금융협회 가맹점 매출내역 통합조회 - 매출승인내역, 실시간
     * </pre>
     * @param org_cd
     * @param web_id
     * @param web_pwd
     * @param start_date
     * @param end_date
     * @param branch_name
     * @return
     */
    public static JSONObject getCardSalesApprHstr(String web_id, String web_pwd, String start_date, String end_date, String branch_name){

        JSONObject inputData = new JSONObject();
        inputData.put("BANKCD"     , "");			// 카드사코드
        inputData.put("WEBID"      , web_id); 		// 로그인 ID
        inputData.put("WEBPASS"    , web_pwd); 		// 로그인 PW
        inputData.put("SSM_CD"     , "0");			// 스크랩모듈구분("0"으로 fix)
        inputData.put("STARTDATE"  , start_date);	// 조회시작일
        inputData.put("ENDDATE"    , end_date);		// 조회종료일
        inputData.put("MENU_VALUE" , "100"); 		// 메뉴 구분값(100:승인, 010:매입, 001:입금)
        inputData.put("SEARCH_TYPE", "2"); 			// 조회구분값(1:합계표, 2:합계표+상세조회)

        if(!"".equals(branch_name)) {
        	inputData.put("BRANCH_NAME", branch_name); 	// 가맹점그룹명 - 웹케시일 경우에만 적용
        }

        return call_gateway("0303", inputData);
    }

    /**
     * <pre>
     * 여신금융협회 가맹점 매출내역 통합조회 - 매출입금내역, 실시간
     * </pre>
     * @param org_cd
     * @param web_id
     * @param web_pwd
     * @param start_date
     * @param end_date
     * @return
     */
    public static JSONObject getCardSalesDpstHstr(String web_id, String web_pwd, String start_date, String end_date, String branch_name){

        JSONObject inputData = new JSONObject();
        inputData.put("BANKCD"     , "");			// 카드사코드
        inputData.put("WEBID"      , web_id); 		// 로그인 ID
        inputData.put("WEBPASS"    , web_pwd); 		// 로그인 PW
        inputData.put("SSM_CD"     , "0");			// 스크랩모듈구분("0"으로 fix)
        inputData.put("STARTDATE"  , start_date);	// 조회시작일
        inputData.put("ENDDATE"    , end_date);		// 조회종료일
        inputData.put("MENU_VALUE" , "001"); 		// 메뉴 구분값(100:승인, 010:매입, 001:입금)
        inputData.put("SEARCH_TYPE", "2"); 			// 조회구분값(1:합계표, 2:합계표+상세조회)

        if(!"".equals(branch_name)) {
        	inputData.put("BRANCH_NAME", branch_name); 	// 가맹점그룹명 - 웹케시일 경우에만 적용
        }
        
        return call_gateway("0303", inputData);
    }


    /**
     * <pre>
     * 사업자등록증명 - 사용안함.
     * </pre>
     * @param bsnn_no
     * @param cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @return
     */
    public static JSONObject gateway_1506(String bsnn_no, String cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data) {

    	String encryptKey = "";
        String encryptdata = "";

        try {
            encryptKey = KISA_SEED_CBC_Util.generateRandomKey();

            StringBuffer reqSendDataBuffer = new StringBuffer();

            reqSendDataBuffer.append(CommUtil.getStringGapFulRight("2", 1, " ")); 			// 조회구분(로그인타입): 1:ID로그인, 2:공인인증서 로그인
        	reqSendDataBuffer.append(CommUtil.getStringGapFulRight(bsnn_no, 15, " "));      // 사업자/주민등록번호(15byte)
        	reqSendDataBuffer.append(CommUtil.getStringGapFulRight("", 20, " "));           // 전화번호(20byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight("", 30, " ")); 			// 아이디(30byte)
        	reqSendDataBuffer.append(CommUtil.getStringGapFulRight("", 30, " ")); 			// 비밀번호(30byte)
        	reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_name, 64, " "));    // 인증서이름(64byte)
        	reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_org, 1, " "));  	// 인증서발급기관(1byte)
        	reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_date, 8, " "));  	// 인증서만료일자(8byte)
        	reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_pwd, 30, " "));   	// 인증서비밀번호(30byte)
        	reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_folder, 255, " ")); // 인증서경로명(폴더명)(255byte)
        	reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_data, 16000, " ")); // 인증서데이터(16000byte)

            encryptdata = KISA_SEED_CBC_Util.encrypt(reqSendDataBuffer.toString().trim(), encryptKey);
            reqSendDataBuffer.setLength(0);
        } catch (Exception e) {
            e.printStackTrace();
        }

        JSONObject inputData = new JSONObject();
        inputData.put("SEND_DATA", encryptKey + "0" + encryptdata);

    	return call_gateway("1506", inputData);
    }
    
    /**
     * <pre>
     * 사업자등록증명(세무대리인정보)
     * </pre>
     * @param bsnn_no
     * @param tax_agent_pw
     * @param cert_name
     * @param cert_org
     * @param cert_date
     * @param cert_pwd
     * @param cert_folder
     * @param cert_data
     * @param tax_agent_no
     * @param tax_agent_password
     * @return
     */
    public static JSONObject gateway_1506(String bsnn_no, String cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data, String tax_agent_no, String tax_agent_password) {

    	String encryptKey = "";
        String encryptdata = "";

        try {
            encryptKey = KISA_SEED_CBC_Util.generateRandomKey();

            StringBuffer reqSendDataBuffer = new StringBuffer();
            
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight("3", 1, " ")); 						// 조회구분(로그인타입): 1:ID로그인, 2:공인인증서 로그인, 3: 세무대리인 전용
         	reqSendDataBuffer.append(CommUtil.getStringGapFulRight(bsnn_no, 50, " "));      		 	// 사업자/주민등록번호(50byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight("", 20, " "));           			// 전화번호(20byte)
        	if(!"".equals(StringUtil.null2void(tax_agent_no))){
        		// 세무대리인일 경우(|세무대리인관리번호)
        		reqSendDataBuffer.append(CommUtil.getStringGapFulRight("|"+tax_agent_no, 25, " "));     	// 증명구분(25byte)
        		reqSendDataBuffer.append(CommUtil.getStringGapFulRight("|"+tax_agent_password, 25, " ")); 	// 공개여부(25byte)
        	}else{
        		// 세무대리인이 아닐 경우
        		reqSendDataBuffer.append(CommUtil.getStringGapFulRight("", 25, " "));           		// 증명구분(25byte)
        		reqSendDataBuffer.append(CommUtil.getStringGapFulRight("", 25, " ")); 					// 공개여부(25byte)
        	}
        	
        	reqSendDataBuffer.append(CommUtil.getStringGapFulRight("", 30, " ")); 						// 아이디(30byte)
        	reqSendDataBuffer.append(CommUtil.getStringGapFulRight("", 30, " ")); 						// 비밀번호(30byte)
            reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_name, 64, " "));    			// 인증서이름(64byte)
        	reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_org, 1, " "));  				// 인증서발급기관(1byte)
        	reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_date, 8, " "));  				// 인증서만료일자(8byte)
        	reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_pwd, 30, " "));   				// 인증서비밀번호(30byte)
        	reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_folder, 255, " ")); 			// 인증서경로명(폴더명)(255byte)
        	reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_data, 16000, " ")); 			// 인증서데이터(16000byte)
        	
            encryptdata = KISA_SEED_CBC_Util.encrypt(reqSendDataBuffer.toString().trim(), encryptKey);
            reqSendDataBuffer.setLength(0);
        } catch (Exception e) {
            e.printStackTrace();
        }

        JSONObject inputData = new JSONObject();
        inputData.put("SEND_DATA", encryptKey + "0" + encryptdata);

    	return call_gateway("1506", inputData);
    }


    /**
     * <pre>
     * 법인카드 결제일 조회 - 실시간
     * </pre>
     * @param bank_cd
     * @param web_id
     * @param web_pwd
     * @param card_no
     * @return
     */
    public static JSONObject getCorpCardPaymentDay(String bank_cd, String web_id, String web_pwd, String card_no) {

    	JSONObject inputData = new JSONObject();

    	inputData.put("SEARCH_GUBUN",  "2");		// 카드조회 구분 (1:그룹별, 2:법인전체)
        inputData.put("ORG_CD"      , bank_cd);		// 기관코드
        inputData.put("WEB_ID"      , web_id);		// 빠른조회 ID
        inputData.put("WEB_PW"      , web_pwd);		// 빠른조회 PW
        inputData.put("CARD_NO"     , card_no);		// 카드번호

    	return call_gateway("0327", inputData);
    }

    /**
     * <pre>
     * 법인카드 승인내역 조회 - 실시간 - 사용안함.
     * </pre>
     * @param bank_cd
     * @param web_id
     * @param web_pwd
     * @param card_no
     * @param card_pwd
     * @param start_date
     * @param end_date
     * @return
     */
    public static JSONObject getCorpCardApprHstr(String bank_cd, String web_id, String web_pwd, String card_no, String start_date, String end_date) {

    	JSONObject inputData = new JSONObject();

    	inputData.put("ORG_CD"         , bank_cd);		// 기관코드
        inputData.put("WEBID"          , web_id);		// 로그인 ID
        inputData.put("WEBPASSWORD"    , web_pwd);		// 로그인 PW
        inputData.put("CARD_NO"        , card_no);		// 카드번호
        inputData.put("ENUM_DATE_BEGIN", start_date);	// 조회시작일자
        inputData.put("ENUM_DATE_END"  , end_date);		// 조회종료일자

    	return call_gateway("0323", inputData);
    }

    /**
     * <pre>
     * 법인카드 승인내역 가맹점 상세조회 - 실시간
     * </pre>
     * @param bank_cd
     * @param web_id
     * @param web_pwd
     * @param card_no
     * @param card_pwd
     * @param start_date
     * @param end_date
     * @return
     */
    public static JSONObject getCorpCardApprHstrWithMest(String bank_cd, String web_id, String web_pwd, String card_no, String start_date, String end_date) {

    	JSONObject inputData = new JSONObject();

    	inputData.put("ORGCD"          , bank_cd);		// 기관코드
        inputData.put("WEBID"          , web_id);		// 로그인 ID
        inputData.put("WEBPASSWORD"    , web_pwd);		// 로그인 PW
        inputData.put("CARD_NO"        , card_no);		// 카드번호
        inputData.put("ENUM_DATE_BEGIN", start_date);	// 조회시작일자
        inputData.put("ENUM_DATE_END"  , end_date);		// 조회종료일자
        inputData.put("SCRAP_INFO"     , "2|1");		// 조회구분

    	return call_longterm_wapi("0341", inputData);
    }

    /**
     * <pre>
     * 법인카드 청구내역 조회 - 실시간 - 사용안함.
     * </pre>
     * @param bank_cd
     * @param web_id
     * @param web_pwd
     * @param card_no
     * @param card_pwd
     * @param pay_year_month
     * @param pay_day
     * @return
     */
    public static JSONObject getCorpCardPaymentHstr(String bank_cd, String web_id, String web_pwd, String card_no, String card_pwd, String pay_year_month, String pay_day) {

    	JSONObject inputData = new JSONObject();

    	inputData.put("ORG_CD"       , bank_cd);		// 기관코드
        inputData.put("WEBID"        , web_id);			// 로그인 ID
        inputData.put("WEBPASSWORD"  , web_pwd);		// 로그인 PW
        inputData.put("CARD_NO"      , card_no);		// 카드번호
        inputData.put("CARD_PASSWORD", card_pwd);		// 카드비밀번호
        inputData.put("DATE_PAYMENT1", pay_year_month);	// 결제년월
        inputData.put("DATE_PAYMENT2", pay_day);		// 결제일
        inputData.put("SCRAP_INFO"  , "");				// 조회구분

    	return call_gateway("0321", inputData);
    }

    /**
     * <pre>
     * 법인카드 한도내역 조회 - 실시간
     * </pre>
     * @param bank_cd
     * @param web_id
     * @param web_pwd
     * @param card_no
     * @param card_pwd
     * @return
     */
    public static JSONObject getCorpCardMaxAmountHstr(String bank_cd, String web_id, String web_pwd, String card_no, String card_pwd) {

    	JSONObject inputData = new JSONObject();

        inputData.put("ORGCD"       , bank_cd);		// 기관코드
        inputData.put("WEBID"        , web_id);		// 로그인 ID
        inputData.put("WEBPASSWORD"  , web_pwd);	// 로그인 PW
        inputData.put("CARD_NO"      , card_no);	// 카드번호
        inputData.put("CARD_PASSWORD", card_pwd);	// 카드비밀번호

    	return call_gateway("0325", inputData);
    }

    /**
     * <pre>
     * 예금주 조회
     * </pre>
     * @param inq_dv
     * @param bank_cd
     * @param acct_no
     * @param iche_amt
     * @param acnm_no
     * @return
     */
    public static JSONObject getAcctnmHstr(String inq_dv, String bank_cd, String acct_no, String iche_amt, String acnm_no, String trsc_seq_no) {

    	JSONArray inputArr = new JSONArray();
    	JSONObject inputSubData = new JSONObject();
    	JSONObject inputData = new JSONObject();

    	inputSubData.put("BANK_CD"       	, bank_cd);		//은행코드
    	inputSubData.put("SEARCH_ACCT_NO"	, acct_no);		//조회계좌번호
    	inputSubData.put("ICHE_AMT"  	  	, iche_amt);	//이체금액
    	
    	//예금주성명조회
		if("1".equals(inq_dv)){
			inputSubData.put("ACNM_NO", ""); //성명조회시 미입력
		}
		//예금주실명조회
		else if("2".equals(inq_dv)){
			inputSubData.put("ACNM_NO", acnm_no); //사업자조회 : 사업자번호 10자리 , 개인조회 : 주민등록상 생년월일 ( YYMMDD ) 6 자리
		}
    	
    	inputSubData.put("TRSC_SEQ_NO"      , trsc_seq_no);	//거래일련번호
    	inputArr.add(inputSubData);
    	inputData.put("REQ_DATA"		, inputArr);
    	return call_acctnm_rcms_wapi("ACCTNM_RCMS_WAPI", inq_dv, inputData);
    }

    /**
     * <pre>
     * 법인카드정보등록
     * </pre>
     * @param org_cd 카드사코드
     * @param comp_idno 사업자번호
     * @param web_id 카드사 로그인 아이디
     * @param web_pwd 카드사 로그인 비밀번호
     * @param card_no 카드번호
     * @param payment_day 결제일자
     * @return
     */
    public static JSONObject insertCorpCard(String org_cd, String comp_idno, String web_id, String web_pwd, String card_no, String payment_day){

        return data_wapi_0100("003", "I", "", org_cd, comp_idno, ""
                , "", "", "", "", "", "", ""
                , "", ""
                , web_id, web_pwd
                , "", "", "", "", ""
                , card_no, payment_day
                , "", "", "");
    }

    /**
     * <pre>
     * 법인카드정보변경
     * </pre>
     * @param org_cd 카드사코드
     * @param comp_idno 사업자번호
     * @param web_id 카드사 로그인 아이디
     * @param web_pwd 카드사 로그인 비밀번호
     * @param card_no 카드번호
     * @param payment_day 결제일자
     * @return
     */
    public static JSONObject updateCorpCard(String org_cd, String comp_idno, String web_id, String web_pwd, String card_no, String payment_day){

    	return data_wapi_0100("003", "U", "", org_cd, comp_idno, ""
                , "", "", "", "", "", "", ""
                , "", ""
                , web_id, web_pwd
                , "", "", "", "", ""
                , card_no, payment_day
                , "", "", "");
    }

    /**
     * <pre>
     * 법인카드정보삭제
     * </pre>
     *@param org_cd 카드사코드
     * @param comp_idno 사업자번호
     * @param web_id 카드사 로그인 아이디
     * @param card_no 카드번호
     * @return
     */
    public static JSONObject deleteCorpCard(String org_cd, String comp_idno, String web_id, String card_no){

    	return data_wapi_0100("003", "D", "", org_cd, comp_idno, ""
                , "", "", "", "", "", "", ""
                , "", ""
                , web_id, ""
                , "", "", "", "", ""
                , card_no, ""
                , "", "", "");
    }





    //계정 정보등록
    private static JSONObject data_wapi_0100(String biz_cd, String gubun, String acct_gubun, String org_cd, String comp_idno, String card_owner_code
            , String cert_name, String before_cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data
            , String reg_type, String ser_idno
            , String web_id, String web_pwd
            , String acct_no, String acct_pw, String ib_type, String bank_type, String company
            , String card_no, String payment_day
            , String taxpayer_regno, String tax_agent_no, String tax_agent_password){

        String cert_reg_data = ""; //인증서 데이타를 암호화 값
        if(!StringUtil.isBlank(cert_name)){
            JSONObject regData = new JSONObject();
            if(!StringUtil.isBlank(cert_data)){
                regData.put("BEFORE_CERT_NAME" , before_cert_name);
                regData.put("CERT_NAME"     , cert_name);
                regData.put("CERT_ORG"      , cert_org);
                regData.put("CERT_DATE"     , cert_date);
                regData.put("CERT_PWD"      , cert_pwd);
                regData.put("CERT_FOLDER"   , cert_folder);
                regData.put("CERTDATA"      , cert_data);
            }else{
                regData.put("BEFORE_CERT_NAME" , before_cert_name);
                regData.put("CERT_NAME"     , cert_name);
                regData.put("CERT_ORG"      , "");
                regData.put("CERT_DATE"     , "");
                regData.put("CERT_PWD"      , "");
                regData.put("CERT_FOLDER"   , "");
                regData.put("CERTDATA"      , "");
            }
            String encryptKey = "";
            String encryptdata = "";
            try {
                encryptKey = KISA_SEED_CBC_Util.generateRandomKey();
                encryptdata = KISA_SEED_CBC_Util.encrypt(regData.toJSONString(), encryptKey);
                cert_reg_data = encryptKey+"0"+encryptdata;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        JSONObject inputData = new JSONObject();


        //BIZ_CD = 001 : 은행 (계좌), 002:현금영수증, 003:법인카드, 004:여신금융협회가맹점매출, 005:개인카드, 006:전자세금계산서, 007:부가가치세/종합소득세
        //계좌
        if("001".equals(biz_cd)){

            inputData.put("BIZ_CD"        , biz_cd);
            inputData.put("GUBUN"         , gubun); 					  	// 거래구분코드(I:등록, U:수정,D:삭제)
            inputData.put("ORG_CD"        , org_cd); 						// 은행코드(은행코드3자리)
            inputData.put("ACCT_GUBUN"    , acct_gubun); 					// 계좌구분(01:수시입출금,02:예적금,03:대출금,07:펀드,08:신탁,09:기타계좌,미입력시 01(수시입출금))
            inputData.put("ACCT_NO"       , acct_no); 						// 계좌번호(구)외환, 하나은행 필요)
            inputData.put("ACCT_PW"       , acct_pw); 						// 계좌비밀번호(구)외환, 하나은행 필요)
            inputData.put("COMP_IDNO"     , comp_idno); 					// 사업자번호, 실명확인번호
            inputData.put("WEB_ID"        , web_id); 						// 빠른조회 ID
            inputData.put("WEB_PW"        , web_pwd); 						// 빠른조회 PW
            inputData.put("BANK_TYPE"     , bank_type);						// 서비스구분(아이디 조회:0, 인증서 조회:1)
            inputData.put("IB_TYPE"       , ib_type); 						// 은행종류(개인/기업 뱅킹 구분값)
            inputData.put("REG_DATA"      , cert_reg_data); 				// 인증서 데이터
            inputData.put("REG_TYPE"      , reg_type); 						// 인증서등록여부(0:등록한 인증서가 있는 경우, 1:인증서 최초등록)
            inputData.put("START_DATE"    , SvcDateUtil.getInstance().getDate(-3, 'M')); //최초조회시작일
        }
        //현금영수증
        else if("002".equals(biz_cd)){
            inputData.put("BIZ_CD"      , biz_cd);
            inputData.put("GUBUN"       , gubun);          			// 거래구분코드 : (I:등록, U:수정, D:삭제)
            inputData.put("COMP_IDNO"   , comp_idno);      			// 사업자번호(기업 : 사업자번호,  개인 : 주민번호)
            if(!"".equals(StringUtil.null2void(tax_agent_no))){
            	inputData.put("SER_IDNO"    , ser_idno+"#"+tax_agent_no); // 조회용사업자번호(기업 : 사업자번호,  개인 : 주민번호)#세무대리인 관리번호
            }else{
            	inputData.put("SER_IDNO"    , ser_idno);       		// 조회용사업자번호(기업 : 사업자번호,  개인 : 주민번호)
            }
            inputData.put("TAX_AGENT_PASSWORD", tax_agent_password);// 세무대리인 관리비밀번호
            inputData.put("BANK_TYPE"   , bank_type);      // 서비스구분(ID/PW 조회 : 0, 인증서 조회:1)
            inputData.put("REG_TYPE"    , reg_type);       // 인증서등록여부 : (0: 인증서 미등록, 1:인증서 등록)
            inputData.put("REG_DATA"    , cert_reg_data);  // 등록정보
            inputData.put("START_MONTH" , "D".equals(gubun)?"":DateTime.getInstance().getDate("YYYYMM",'M',-3)); // 조회시작월 : 삭제 시 공백
        }
        //법인카드
        else if("003".equals(biz_cd)){
            inputData.put("BIZ_CD"      , biz_cd);
            inputData.put("GUBUN"       , gubun);			//거래구분코드 : (I:등록, U:수정, D:삭제)
            inputData.put("ORG_CD" 		, org_cd);			//카드사코드
            inputData.put("COMP_IDNO"   , comp_idno);		//사업자번호(기업 : 사업자번호,  개인 : 주민번호)
            inputData.put("WEB_ID" 		, web_id);			//카드사 로그인 아이디
            inputData.put("WEB_PW" 		, web_pwd);			//카드사 로그인 비밀번호
            inputData.put("CARD_NO" 	, card_no);			//카드사 로그인 아이디
            inputData.put("PAYMENT_DAY" , payment_day);		//카드결제일
            inputData.put("BANK_TYPE"   , "0");				//서비스구분(0으로 고정)
            inputData.put("REG_TYPE"    , "0");				//인증서등록여부(0으로 고정)
            inputData.put("START_DATE"  , SvcDateUtil.getInstance().getDate(-3, 'M')); //최초조회시작일
            inputData.put("START_MONTH" , SvcDateUtil.getInstance().getDate(-3, 'M').substring(0,6)); //조회시작월(법인카드만 해당)
        }
        //여신금융협회
        else if("004".equals(biz_cd)){
            inputData.put("BIZ_CD"      , biz_cd);
            inputData.put("GUBUN"       , gubun); 		// 거래구분코드 I:등록, U:수정,D:삭제
            inputData.put("SER_IDNO"    , ser_idno);	// 사업자번호 기업 : 사업자번호,  개인 : 주민번호
            inputData.put("COMP_IDNO"   , comp_idno);	// 사업자번호 기업 : 사업자번호,  개인 : 주민번호
            inputData.put("WEB_ID"      , web_id); 		// 빠른조회아이디
            inputData.put("WEB_PW"      , web_pwd); 	// 빠른조회비밀번호
            inputData.put("START_DATE"  , DateTime.getInstance().getDate("YYYYMMDD",'D',-3)); // 최초조회시작일 8byte
        }
        //개인카드
        else if("005".equals(biz_cd)){
            inputData.put("BIZ_CD"		      , biz_cd);
            inputData.put("GUBUN"		      , gubun);    				//거래구분 코드 (I:등록, U:수정,D:삭제)
            inputData.put("ORG_CD" 		      , org_cd);				//카드사코드
            inputData.put("COMP_IDNO"         , comp_idno);				//사업자번호
            inputData.put("WEB_ID" 		      , "");					//카드사 로그인 아이디
            inputData.put("WEB_PW" 		      , "");					//카드사 로그인 비밀번호
            inputData.put("CARD_OWNER_CODE"   , card_owner_code);		//소유자식별코드
            inputData.put("EXPIRE_DATE"       , "");					//만료일자
            inputData.put("BANK_TYPE" 	      , "1");					//서비스구분(아이디 조회:0,인증서 조회:1)
            inputData.put("REG_TYPE" 	      , reg_type);				//인증서등록여부(0: 인증서 미등록, 1:인증서 등록)
            inputData.put("REG_DATA" 	      , cert_reg_data);
            inputData.put("COMPANY" 	      , company); 				//회원사 : BC카드일경우 필수값
            inputData.put("START_DATE"        , SvcDateUtil.getInstance().getDate(-3, 'M'));
        }
        //전자세금계산서
        else if("006".equals(biz_cd)){
            inputData.put("BIZ_CD"         , biz_cd);
            inputData.put("GUBUN"          , gubun);          // 거래구분코드(I:등록, U:수정, D:삭제)
            inputData.put("COMP_IDNO"      , comp_idno);      // 사업자번호(기업 : 사업자번호, 개인 : 주민번호)
            inputData.put("SER_IDNO"       , ser_idno);       // 조회용사업자번호(기업 : 사업자번호,  개인 : 주민번호)
            inputData.put("BANK_TYPE"      , "1");            // 서비스구분 : (인증서 조회:1)
            inputData.put("BASIC_DATE"     , "3");            // 조회기준 (1:작성일자, 2:발행일자, 3:전송일자)
            inputData.put("TAX_TYPE1"      , "");             // 전자세금계산서 종류(대분류)
            inputData.put("TAX_TYPE2"      , "");             // 전자세금계산서 종류(소분류)
            inputData.put("PUBLISHING_TYPE", "");             // 발행유형
            inputData.put("TAX_AGENT_NO"   , tax_agent_no);   // 세무대리인 관리번호
            inputData.put("TAX_AGENT_PASSWORD", tax_agent_password); // 세무대리인 관리 비밀번호
            inputData.put("REG_TYPE"       , reg_type);       // 인증서등록여부(0: 인증서 미등록, 1:인증서 등록)
            inputData.put("REG_DATA"       , cert_reg_data);  // 등록정보
            inputData.put("START_DATE"     , "D".equals(gubun)?"":DateTime.getInstance().getDate("YYYYMMDD",'M',-3)); // 최초조회시작일 : 삭제 시 공백

            if(!"".equals(StringUtil.null2void(taxpayer_regno))){
            	inputData.put("TAXPAYER_REGNO"	, taxpayer_regno); 	//납세자 사업자번호
            }
        }
        //부가가치세/종합소득세
        else if("007".equals(biz_cd)){
            inputData.put("BIZ_CD"       , biz_cd);
            inputData.put("GUBUN"        , gubun);     		// 거래구분코드 I:등록, U:수정,D:삭제
            inputData.put("COMP_IDNO"    , comp_idno); 		// 사업자번호 기업 : 사업자번호,  개인 : 주민번호
            inputData.put("SER_IDNO"     , ser_idno);  		// 조회용사업자번호
            inputData.put("REG_TYPE"     , reg_type); 		// 인증서등록여부 : (0: 인증서 미등록, 1:인증서 등록)
            inputData.put("BANK_TYPE"    , "1"); 			// 인증서조회
            inputData.put("TAX_SEARCH_YN", "Y");      		// 부가가치세/종합소득세 조회여부
            inputData.put("REGNO_TYPE"   , "1");      		// 부가세 납부예정조회 구분값 1:사업자번호/2:주민번호
            inputData.put("USER_REGNO"   , ser_idno); 		// 부가세 납부예정조회 사업자번호/주민번호
            inputData.put("REG_DATA"     , cert_reg_data); 	// 인증서 데이터
        }
        //건강보험
        else if("008".equals(biz_cd)){
        	inputData.put("BIZ_CD"       , biz_cd);
            inputData.put("GUBUN"        , gubun);     		// 거래구분코드 I:등록, U:수정,D:삭제
            inputData.put("COMP_IDNO"    , comp_idno); 		// 사업자번호 기업 : 사업자번호,  개인 : 주민번호
            inputData.put("SER_IDNO"     , ser_idno);  		// 조회용사업자번호
            inputData.put("REG_TYPE"     , reg_type); 		// 인증서등록여부 : (0: 인증서 미등록, 1:인증서 등록)
            inputData.put("BANK_TYPE"    , "1"); 			// 인증서조회
            inputData.put("PAY_TYPE"	 , "0");      		// 급여비종류 : (0:전체, 1:의료급여비, 2:요양급여비)
            inputData.put("CEO_PASSWORD" , "");             // 대표자비밀번호
            inputData.put("SEARCH_TYPE"  , "2");            // 조회기준(1:청구일자, 2:지급일자)
            inputData.put("REG_DATA"     , cert_reg_data); 	// 인증서 데이터
            inputData.put("START_DATE"   , "D".equals(gubun)?"":DateTime.getInstance().getDate("YYYYMMDD",'M',-3)); // 최초조회시작일 : 삭제 시 공백
        }

        return call_data_wapi("0100", inputData);
    }

    /**
     * <pre>
     * 아바타 유료회원 신청/해지
     * </pre>
     * @param biz_cd
     * @param comp_idno
     * @param membership_yn
     * @return
     */
    public static JSONObject insertMembership(String biz_cd, String comp_idno, String membership_yn) {

    	JSONObject inputData = new JSONObject();

    	inputData.put("BIZ_CD"         , biz_cd);			// 업무구분코드 (001:은행, 002:현금영수증, 003:법인카드, 006:전자세금계산서, 011:sns쇼핑몰)
        inputData.put("COMP_IDNO"      , comp_idno);		// 사업자번호
        inputData.put("MEMBERSHIP_YN"  , membership_yn);	// 유료회원여부
        
    	return call_avatar_wapi("0400", inputData);
    }
    
    /**
	 * 건강보험공단 요양기관정보마당 인증서 검증 (단말인증서)
	 * @param cert_name
	 * @param cert_org
	 * @param cert_date
	 * @param cert_pwd
	 * @param cert_folder
	 * @param cert_data
	 * @return
	 */
	public static JSONObject evdcMediHstr(String cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data){

		String encryptKey = "";
		String encryptdata = "";
		
		try {
			String strToday = DateTime.getInstance().getDate("yyyymmdd");
			encryptKey = KISA_SEED_CBC_Util.generateRandomKey();
		
			StringBuffer reqSendDataBuffer = new StringBuffer();
			reqSendDataBuffer.append(CommUtil.getStringGapFulRight("1", 1, " ")); 			// 급여비종류: 1: 의료급여비, 2:요양급여비
			reqSendDataBuffer.append(CommUtil.getStringGapFulRight("", 30, " ")); 			// 대표자비밀번호(30byte)
			reqSendDataBuffer.append(CommUtil.getStringGapFulRight(strToday, 8, " ")); 		// 조회시작일(8byte)
			reqSendDataBuffer.append(CommUtil.getStringGapFulRight(strToday, 8, " ")); 		// 조회종료일(8byte)
			reqSendDataBuffer.append(CommUtil.getStringGapFulRight("2", 1, " ")); 			// 조회기준(1byte) : 1:청구일자, 2:지급일자
			reqSendDataBuffer.append(CommUtil.getStringGapFulRight("", 20, " ")); 	        // 접수번호(20byte)
			reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_name, 64, " "));    // 인증서이름(64byte)
			reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_org, 1, " "));  	// 인증서발급기관(1byte)
			reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_date, 8, " "));  	// 인증서만료일자(8byte)
			reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_pwd, 30, " "));   	// 인증서비밀번호(30byte)
			reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_folder, 255, " ")); // 인증서경로명(폴더명)(255byte)
			reqSendDataBuffer.append(CommUtil.getStringGapFulRight(cert_data, 16000, " "));  // 인증서데이터(16000byte)
			
			encryptdata = KISA_SEED_CBC_Util.encrypt(reqSendDataBuffer.toString().trim(), encryptKey);
			reqSendDataBuffer.setLength(0);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		JSONObject inputData = new JSONObject();
		inputData.put("SEND_DATA", encryptKey + "0" + encryptdata);
		return call_gateway("0239", inputData); 
	}
	
	/**
	 * 건강보험공단 요양기관정보마당 인증서 검증 (서버인증서)
	 * @param cert_name
	 * @param cert_org
	 * @param cert_date
	 * @param cert_pwd
	 * @param cert_folder
	 * @param cert_data
	 * @return
	 */
	public static JSONObject evdcMediHstr(String compIdno, String cert_name){
		
		String strToday = DateTime.getInstance().getDate("yyyymmdd");
		
		JSONObject inputData = new JSONObject();
		inputData.put("COMP_IDNO"		, compIdno);	// 사업자번호
		inputData.put("PAY_TYPE"		, "1"); 		// 급여비종류 (1:의료급여비, 2:요양급여비)
		inputData.put("CEO_PASSWORD"	, ""); 			// 대표자비밀번호
		inputData.put("DATE_BEGIN"		, strToday); 	// 조회시작일:YYYYMMDD(접수번호로 조회시 불필요)
		inputData.put("DATE_END"		, strToday); 	// 조회종료일:YYYYMMDD(접수번호로 조회시 불필요)
		inputData.put("SEARCH_TYPE"		, "2"); 		// 조회기준 (1:청구일자, 2:지급일자)
		inputData.put("ACCEPT_NO"		, ""); 			// 접수번호
		inputData.put("CERT_NAME"		, cert_name); 	// 인증서이름
		
		//응답코드(DET_CODE)가   WERR0006(쿠콘에 배치결과 없음), 42110000(카드사에 거래내역없음)인 경우는 정상 거래임
		return call_gateway_cert("0239", inputData);
	}
	
	/**
	 * 외화 고시환율조회
	 * @param orgcode
	 * @param service_type
	 * @param scrap_type
	 * @param cyeerncy_type
	 * @return
	 */
	public static JSONObject getExhgRt(String orgcode, String service_type, String scrap_type, String cyeerncy_type){
		
		String strToday = DateTime.getInstance().getDate("yyyymmdd");
		
		JSONObject inputData = new JSONObject();
		inputData.put("ORGCODE"			, orgcode);		// 기관코드
		inputData.put("SERVICE_TYPE"	, service_type);// 서비스유형
		inputData.put("SCRAP_TYPE"		, scrap_type); 	// 조회유형(0:외화 고시환율, 1:외화 변동고시환율, 2:외화 평균고시환율)
		inputData.put("SCRAP_GUBUN"		, ""); 			// 조회구분
		inputData.put("DATE"			, strToday);	// 조회일자
		inputData.put("EATE_END"		, strToday); 	// 조회종료일
		inputData.put("NOTICE_TIMES"	, "0"); 		// 고시회차(최종현재 : 0)
		inputData.put("CYEERNCY_TYPE"	, cyeerncy_type);// 통화
		
		return call_gateway("0223", inputData);
	}
	
	/**
     * 쇼핑몰  등록 / 쇼핑몰 계정정보등록 (API ID:0100)
     * @param comp_idno 		사업자번호
     * @param shopCd			쇼핑몰 코드
     * @param subShopCd			보조 쇼핑몰 코드
     * @param web_id			쇼핑몰 로그인 아이디
     * @param web_pwd			쇼핑몰 로그인 패스워드
     * @param sub_id			서브 아이디
     * @param loginGubun		로그인구분
     * @param partnerCd			협력사코드	
     * @param searchGubun		조회구분
     * @param startMonth		최조조회시작월
     * @return
     */
    public static JSONObject insertSmart(String comp_idno, String shopCd, String subShopCd, String web_id, String web_pwd, 
    		String sub_id, String loginGubun, String partnerCd, String searchGubun, String startMonth){
        

        JSONObject inputData = new JSONObject();
        
        inputData.put("BIZ_CD"      , "011");		// 011 ( 고정값 )
        inputData.put("GUBUN"       , "I"); 		// 거래구분코드 I:등록, U:수정,D:삭제
        inputData.put("COMP_IDNO"   , comp_idno);	// 사업자번호 기업 : 사업자번호,  개인 : 주민번호
        inputData.put("LOGIN_TYPE"  , "ID");		// 서비스구분("ID":아이디, "CERT":인증서)
        
        /**
		 * //오픈마켓
		 * sell11st(11번가),sellESMPlus(ESMPlus), sellInterpark(인터파크), sellNaver(스마트스토어), sellCJ(CJ몰), sellLotte(롯데닷컴), sellSSG(신세계몰)
		 * //소셜커머스
		 * sellCoupang(쿠팡), sellTmon(티몬), sellWemp(위메프), sellKaKao(카카오), sellWempPS(위메프(여행)), sellTmonPS(티몬(여행))
		 * //숙박앱
		 * sellGoodchoice(여기어때), sellYanolja(야놀자), sellExpedia(익스피디아)
		 * //배달앱
		 * sellBaemin(배달의민족), sellYogiyo(요기요), sellBaegofa(배고파), sellBdtong(배달통), sellCoupangeats(쿠팡이츠)
		 */
        /* 아바타 적용 계정: sellBaemin(배달의민족), sellYogiyo(요기요), sellCoupangeats(쿠팡이츠), sellNaver(스마트스토어)*/
        inputData.put("SHOP_CD"      , shopCd); 	// 쇼핑몰 코드

        /**
         * 이베이코리아( sellESMPlus )일 경우 필수
         * - 1: 옥션, 2:지마켓
         * 쿠팡( SellCoupang )
         * - 1: 중개, 2: 여행 
         */
        inputData.put("SUB_SHOP_CD" , subShopCd); 	// 보조 쇼핑몰 코드
        inputData.put("WEB_ID"      , web_id); 		// 쇼핑몰 로그인 아이디
        inputData.put("WEB_PW"      , web_pwd); 	// 쇼핑몰 로그인 패스워드
        
        /**
         * 토스페이먼츠(sellTosspayments)일 경우 필수
         * -KG이니시스, 토스페이먼츠 사용
         * -그외, 미사용
         */
        inputData.put("SUB_ID"      , sub_id); 		// 서브 아이디

        /**
         * 인터파크(sellInterpark): 다중사업자 인 경우 필수 input 값 : [업체번호|공급계약번호]
         * 스마트스토어(sellNaver): [1]판매자아이디 로그인, [2]네이버아이디 로그인
         * 이베이코리아(sellESMPlus): [0]Master, [1]옥션, [2]지마켓
         * 네이버페이(sellNPay): 미입력, [1]페이센터ID 로그인, [2]네이버ID 로그인
         * 토스페이먼츠(sellTosspayments) : 미입력, [1]일반 계정, [2]관리자 계정
         */
        inputData.put("LOGIN_GUBUN" , loginGubun); 	// 로그인구분
        
        /**
         * CJ몰 필수입력
         */
        inputData.put("PARTNER_CODE", partnerCd); 	// 협력사코드
        
        /**
         * 건별부가세신고내역 스크래핑시, 배달의민족인 경우 
         * 		0:경리나라, 
         * 		1:경리나라 외(에멘탈)
         * 		0:경리나라 인 경우, 결과에 매출금액 2,3 이 값이 없음
         */
        inputData.put("SEARCH_GUBUN", searchGubun); 	// 조회구분
        inputData.put("START_MONTH", startMonth); 		// 최초조회시작월
        inputData.put("USE_YN_MONTH", "0"); 			// 사용여부(월별) - 0:사용, 1:미사용
        inputData.put("USE_YN_VAT", "0"); 				// 사용여부(건별) - 0:사용, 1:미사용
        inputData.put("USE_YN_JUNGSAN", "0"); 			// 사용여부(정산내역) - 0:사용, 1:미사용
        inputData.put("USE_YN_ORDER", "0"); 			// 사용여부(주문내역) - 0:사용, 1:미사용
        
        return call_data_wapi("0100", inputData);
    }
    
    /**
     * 쇼핑몰  등록 / 쇼핑몰 계정정보수정 (API ID:0100)
     * @param comp_idno 		사업자번호
     * @param shopCd			쇼핑몰 코드
     * @param subShopCd			보조 쇼핑몰 코드
     * @param web_id			쇼핑몰 로그인 아이디
     * @param web_pwd			쇼핑몰 로그인 패스워드
     * @return
     */
    public static JSONObject updateSmart(String comp_idno, String shopCd, String subShopCd, String web_id, String web_pwd){
        
        JSONObject inputData = new JSONObject();
        
        inputData.put("BIZ_CD"      	, "011");		// 011 ( 고정값 )
        inputData.put("GUBUN"       	, "U"); 		// 거래구분코드 I:등록, U:수정,D:삭제
        inputData.put("COMP_IDNO"   	, comp_idno);	// 사업자번호 기업 : 사업자번호,  개인 : 주민번호
        inputData.put("LOGIN_TYPE"  	, "ID");		// 서비스구분("ID":아이디, "CERT":인증서)
        inputData.put("SHOP_CD"      	, shopCd); 		// 쇼핑몰 코드(sellBaemin:배달의민족, sellYogiyo:요기요, sellCoupangeats:쿠팡이츠)
        inputData.put("SUB_SHOP_CD" 	, subShopCd); 	// 보조 쇼핑몰 코드
        inputData.put("WEB_ID"      	, web_id); 		// 쇼핑몰 로그인 아이디
        inputData.put("WEB_PW"      	, web_pwd); 	// 쇼핑몰 로그인 패스워드
        inputData.put("USE_YN_MONTH"	, "0"); 		// 사용여부(월별) - 0:사용, 1:미사용
        inputData.put("USE_YN_VAT"		, "0"); 		// 사용여부(건별) - 0:사용, 1:미사용
        inputData.put("USE_YN_JUNGSAN"	, "0"); 		// 사용여부(정산내역) - 0:사용, 1:미사용
        inputData.put("USE_YN_ORDER"  	, "0"); 		// 사용여부(주문내역) - 0:사용, 1:미사용
        
        return call_data_wapi("0100", inputData);
    }
    
    /**
     * 쇼핑몰  등록 / 쇼핑몰 계정정보삭제 (API ID:0100)
     * @param comp_idno 		사업자번호
     * @param shopCd			쇼핑몰 코드
     * @param subShopCd			보조 쇼핑몰 코드
     * @param web_id			쇼핑몰 로그인 아이디
     * @return
     */
    public static JSONObject deleteSmart(String comp_idno, String shopCd, String subShopCd, String web_id){

        JSONObject inputData = new JSONObject();
        
        inputData.put("BIZ_CD"      , "011");		// 011 ( 고정값 )
        inputData.put("GUBUN"       , "D"); 		// 거래구분코드 I:등록, U:수정,D:삭제
        inputData.put("COMP_IDNO"   , comp_idno);	// 사업자번호 기업 : 사업자번호,  개인 : 주민번호
        inputData.put("SHOP_CD"     , shopCd); 		// 쇼핑몰 코드(sellBaemin:배달의민족, sellYogiyo:요기요, sellCoupangeats:쿠팡이츠)
        inputData.put("SUB_SHOP_CD" , subShopCd); 	// 보조 쇼핑몰 코드
        inputData.put("WEB_ID"      , web_id); 		// 쇼핑몰 로그인 아이디
        
        return call_data_wapi("0100", inputData);
    }
    
    /**
     * <pre>
     * 쇼핑몰 주문내역 조회(실시간)
     * </pre>
     * @param web_id
     * @param web_pwd
     * @param start_date
     * @param end_date
     * @param tran_sts
     * @param shop_nm
     * @param shop_cd
     * @return
     */
    public static JSONObject getSnssOrdrHstr(String web_id, String web_pwd, String start_date, String end_date
    		, String tran_sts, String shop_nm, String shop_cd){
    	
    	JSONObject inputData = new JSONObject();
    	inputData.put("판매자아이디" 	, web_id); 			
    	inputData.put("조회구분"		, "S");				// S:목록조회, D:상세조회
    	inputData.put("조회시작일"		, start_date); 				 
    	inputData.put("조회종료일"		, end_date); 		 
    	inputData.put("거래상태"		, tran_sts); 		// 미입력or1:완료, 2:취소, 3:처리중 
    	inputData.put("상호"			, shop_nm);		
    	
    	JSONObject reqData = new JSONObject();
    	reqData.put("Module"	, shop_cd); 		// 금융기관 모듈 (sellBaemin:배달의민족, sellYogiyo:요기요, sellCoupangeats:쿠팡이츠)
    	reqData.put("Class"		, "판매자"); 			// 판매자
    	reqData.put("Job"		, "주문내역"); 		// 주문내역
    	reqData.put("Input"		, inputData); 		// Input항목
    	
    	JSONArray InputList = new JSONArray();
    	InputList.add(reqData);
    	
    	return call_gateway_shop(InputList, web_id, web_pwd);
    }
    
    /**
     * <pre>
     * 쇼핑몰 정산내역_배달 조회(실시간)
     * </pre>
     * @param web_id
     * @param web_pwd
     * @param start_date
     * @param end_date
     * @param comp_idno
     * @param shop_cd
     * @return
     */
    public static JSONObject getSnssCalcHstr(String web_id, String web_pwd, String start_date, String end_date
    		, String comp_idno, String shop_cd){
    	
    	JSONObject inputData = new JSONObject();
    	inputData.put("판매자아이디" 	, web_id); 			
    	inputData.put("조회구분"		, "");				
    	inputData.put("조회시작일"		, start_date); 				 
    	inputData.put("조회종료일"		, end_date); 		 
    	inputData.put("사업자번호"		, comp_idno); 		 
    	
    	JSONObject reqData = new JSONObject();
    	reqData.put("Module"	, shop_cd); 		// 금융기관 모듈 (sellBaemin:배달의민족, sellYogiyo:요기요, sellCoupangeats:쿠팡이츠)
    	reqData.put("Class"		, "판매자"); 			// 판매자
    	reqData.put("Job"		, "정산내역_배달"); 	// 정산내역
    	reqData.put("Input"		, inputData); 		// Input항목
    	
    	JSONArray InputList = new JSONArray();
    	InputList.add(reqData);
    	
    	return call_gateway_shop(InputList, web_id, web_pwd);
    }
    
    /**
     * <pre>
     * 인증서 사인데이터 검증
     * </pre>
     * @param sign_msg
     * @return
     */
    public static JSONObject getSignVerify(String type, String sign_msg){
        JSONObject inputData = new JSONObject();
        inputData.put("SIGN_MSG", sign_msg); 	// Base64 사인데이터
        return call_gateway_sign(inputData, type);
    }

    /**
     * 쿠콘 API 호출  (data_wapi.jsp)
     * @param apiId
     * @param input
     * @return
     */
    private static JSONObject call_data_wapi(String apiId, JSONObject input){
        input.put("API_KEY", CommUtil.getCooconAPIKEY()); //인증키
        input.put("API_ID", apiId); //API번호
        return call_coocon(CommUtil.getHostUrl(), input);
    }
    
    /**
     * 쿠콘 API 호출  (avatar_wapi.jsp)
     * @param apiId
     * @param input
     * @return 
     */
    private static JSONObject call_avatar_wapi(String apiId, JSONObject input){
        input.put("API_KEY", CommUtil.getCooconAPIKEY()); //인증키
        input.put("API_ID", apiId); //API번호
        return call_coocon(CommUtil.getHostUrlAvatar(), input);
    }
    
    /**
     * 쿠콘 API 호출  (gateway.jsp)
     * @param apiId
     * @param input
     * @return
     */
    private static JSONObject call_gateway(String apiId, JSONObject input){
        input.put("API_KEY", CommUtil.getCooconAPIKEY()); //인증키
        input.put("API_ID", apiId); //API번호
        return call_coocon(CommUtil.getHostUrlcard(), input);
    }

    /**
     * 쿠콘 API 호출  (gateway_cert.jsp)
     * @param apiId
     * @param input
     * @return
     */
    private static JSONObject call_gateway_cert(String apiId, JSONObject input){
        input.put("API_KEY", CommUtil.getCooconAPIKEY()); //인증키
        input.put("API_ID", apiId); //API번호
        return call_coocon(CommUtil.getAcctCertHostUrl(), input);
    }

    /**
     * 쿠콘 API 호출  (longterm_wapi.jsp)
     * @param apiId
     * @param input
     * @return
     */
    private static JSONObject call_longterm_wapi(String apiId, JSONObject input){
        input.put("API_KEY", CommUtil.getCooconAPIKEY()); //인증키
        input.put("API_ID", apiId); //API번호
        return call_coocon(CommUtil.getHostUrlLongterm(), input);
    }

    /**
     * 쿠콘 API 호출  (scrap_wapi_0100.jsp)
     * @param apiId
     * @param input
     * @return
     */
    private static JSONObject call_scrap_wapi_0100(String apiId, JSONObject input){
        // 공통
        input.put("API_KEY", CommUtil.getCooconAPIKEY()); //인증키
        input.put("API_ID", apiId); //API번호
        return call_coocon(CommUtil.getHostUrlScrap(), input);
    }

    /**
     * 쿠콘 API 호출  (acctnm_rcms_wapi.jsp)
     * @param apiId
     * @param input
     * @return
     */
    private static JSONObject call_acctnm_rcms_wapi(String apiId, String inq_dv, JSONObject input){
        // 공통
        input.put("SECR_KEY", CommUtil.getCooconSECRKEY(inq_dv)); //인증키
        input.put("KEY", apiId); 	//API번호
      //return call_coocon(CommUtil.getAcctnmHostUrl(), input);
        // TODO : 오픈전에 변경해야됨. 임시
        return call_coocon("https://gw.coocon.co.kr/sol/gateway/acctnm_rcms_wapi.jsp", input);
    }

    /**
     * 쿠콘 API 호출  (signVerifyAction.jsp)
     * @param apiId
     * @param input
     * @return
     */
    private static JSONObject call_gateway_sign(JSONObject input, String type){
        return call_cooconSign(CommUtil.getSignHostUrl(), input, type);
    }
    
    /**
     * 쿠콘 API 호출  (smart_gateway.jsp)
     * @param input
     * @return
     */
    private static JSONObject call_gateway_shop(JSONArray input, String web_id, String web_pwd){
    	JSONObject outputData = new JSONObject();
    	String Tr_seq = "0000001";
    	
    	JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();
		try {
			// 거래일련번호 조회
			JexData idoIn1 = util.createIDOData("API_TR_SEQ_R001");
			JexData idoOut1 = idoCon.execute(idoIn1);
			Tr_seq = idoOut1.getString("TR_SEQ");
		} catch (Exception e) {
			outputData.put("RSLT_CD", "C998");
			outputData.put("RSLT_MSG", "처리중오류가발생하였습니다.잠시후이용하시기바랍니다.");
			return outputData;
		}
		
    	// 공통
        JSONObject loginInfo = new JSONObject();
        loginInfo.put("로그인방식" 		, "ID"); 			
        loginInfo.put("사용자아이디"	, web_id);		
        loginInfo.put("사용자비밀번호"	, web_pwd); 				 
        loginInfo.put("서브아이디"		, ""); 			// KG이니시스, 토스페이먼츠
        loginInfo.put("로그인구분"		, ""); 			// 인터파크, 스마트스토어, 네이버페이, 토스페이먼츠, ESMPlus 인 경우 입력 필요그 외 기관 공백("")입력
        loginInfo.put("협력사코드"		, "");			// CJ몰만 입력 필요
        loginInfo.put("보안문자자동제출"	, "");			// 위메프 사용시에 입력, 그 외 기관 공백("")입력
        loginInfo.put("보안문자"		, "");			// 위메프 사용시에 보안문자 수동제출시 사용
    	
        JSONObject common = new JSONObject();
        common.put("Auth_key" 	, CommUtil.getCooconAPIKEY()); 							// 이용기업 인증키값(이용기업 별로 발급됨)		
        common.put("Tr_seq"		, Tr_seq);	// 거래일련번호(일별로 유일해야됨)
        common.put("Gw_sys_no"	, ""); 				 
        common.put("Ss_sys_no"	, ""); 		 
        common.put("Auth_req"	, ""); 
        common.put("Thread_no"	, "");		
        common.put("Lbs_no"		, "");		
        common.put("Login_info"	, loginInfo);		
    	
    	JSONObject reqData = new JSONObject();
    	reqData.put("Common"		, common); 	// 공통
    	reqData.put("Dsnc"			, "S"); 	// 세션유지여부 "S"로 고정
    	reqData.put("SAS_SessionID"	, ""); 		// SS 서버 거래키값
    	reqData.put("TimeoutRuntime", ""); 		// 전체 타임아웃 시간(초 단위)
    	reqData.put("InputList"		, input); 	// 조회하기 위한 개별 입력값
    
    	return call_coocon(CommUtil.getSmartHostUrl(), reqData);
    }
    
    /**
     * 쿠콘 API 호출  (webilling_wapi.jsp)
     * @param apiId
     * @param inq_dv
     * @param input
     * @return
     */
    private static JSONObject call_gateway_wdrw(String apiId, String inq_dv, JSONObject input){
    	// 공통
        input.put("SECR_KEY", CommUtil.getCooconSECRKEY(inq_dv));   // 인증키
        input.put("KEY", apiId); 									// API 명
    	return call_coocon(CommUtil.getWdrwHostUrl(), input);
    }

    private static JSONObject call_cooconSign(String url, JSONObject input, String type){

    	StackTraceElement[] stacks = new Throwable().getStackTrace();
        StringBuffer sbLog = new StringBuffer();
        sbLog.append("\n------------------------ START ------------------------");
        sbLog.append("\nStartTime :: " + SvcDateUtil.getInstance().getDate("YYYY-MM-DD HH24:MI:SS"));

        if(stacks.length > 3)
        sbLog.append("\n[before] " + stacks[4].getClassName().replaceAll("002d", "").replaceAll("005f", "")+ " " + stacks[4].getMethodName());
        if(stacks.length > 2)
        sbLog.append("\n[before] " + stacks[3].getClassName().replaceAll("002d", "").replaceAll("005f", "")+ " " + stacks[3].getMethodName());
        sbLog.append("\n[before] " + stacks[2].getClassName().replaceAll("002d", "").replaceAll("005f", "")+ " " + stacks[2].getMethodName());

        JSONObject outputData = new JSONObject();

        try{
        	sbLog.append("\nurl  :: " + url);
            sbLog.append("\nInput  :: " + input.toJSONString());

            String encCode = "UTF-8";

            String strResultData = ExternalConnectUtil.connect(url
                    , "TYPE="+type+"&SIGN_DATA=" + URLEncoder.encode(input.toJSONString(), encCode)
                    , "http", encCode);

            strResultData = URLDecoder.decode(strResultData, encCode);
            sbLog.append("\nResult :: " + strResultData);
            sbLog.append("\nEndTime :: " + SvcDateUtil.getInstance().getDate("YYYY-MM-DD HH24:MI:SS")+"\n");

            log(sbLog.toString());
            sbLog.setLength(0);

            outputData = (JSONObject)JSONParser.parser(strResultData);

        }catch(Exception e){

            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));

            sbLog.append("\nException :: " + sw.toString());
            sbLog.append("\nEnd Time " + SvcDateUtil.getInstance().getDate("YYYY-MM-DD HH24:MI:SS"));

            log(sbLog.toString());
            sbLog.setLength(0);

            outputData.put("RSLT_CD", "C999");
            outputData.put("RSLT_MSG", "처리중오류가발생하였습니다.잠시후이용하시기바랍니다.");
        }
        return outputData;
    }

    private static JSONObject call_coocon(String url, JSONObject input){

    	StackTraceElement[] stacks = new Throwable().getStackTrace();
        StringBuffer sbLog = new StringBuffer();
        sbLog.append("\n------------------------ START ------------------------");
        sbLog.append("\nStartTime :: " + SvcDateUtil.getInstance().getDate("YYYY-MM-DD HH24:MI:SS"));

        if(stacks.length > 3)
        sbLog.append("\n[before] " + stacks[4].getClassName().replaceAll("002d", "").replaceAll("005f", "")+ " " + stacks[4].getMethodName());
        if(stacks.length > 2)
        sbLog.append("\n[before] " + stacks[3].getClassName().replaceAll("002d", "").replaceAll("005f", "")+ " " + stacks[3].getMethodName());
        sbLog.append("\n[before] " + stacks[2].getClassName().replaceAll("002d", "").replaceAll("005f", "")+ " " + stacks[2].getMethodName());

        JSONObject outputData = new JSONObject();

        try{
        	sbLog.append("\nurl  :: " + url);
            sbLog.append("\nInput  :: " + input.toJSONString());

            String encCode = "UTF-8";

            //실명조회 시 URLEncoding 변경
            if(url.indexOf("acctnm_rcms_wapi.jsp") > 0) {
            	encCode = "EUC-KR";
            }
            
            String strResultData = "";
            // 쇼핑몰API 조회
            if(url.indexOf("smart_gateway.jsp") > 0) {
            	strResultData = ExternalConnectUtil.connect(url
            			, URLEncoder.encode(input.toJSONString(), encCode)
            			, url.toLowerCase().startsWith("https")?"https":"http", encCode);
            	strResultData = strResultData.replaceAll("%","%25");
    			strResultData = URLDecoder.decode(strResultData, "utf-8");
            }
            else {
            	strResultData = ExternalConnectUtil.connect(url
                        , "JSONData=" + URLEncoder.encode(URLEncoder.encode(input.toJSONString(), encCode).replaceAll("\\+","%20"), encCode)
                        , url.toLowerCase().startsWith("https")?"https":"http", encCode);
            }
            
            sbLog.append("\nResult :: " + strResultData);
            sbLog.append("\nEndTime :: " + SvcDateUtil.getInstance().getDate("YYYY-MM-DD HH24:MI:SS")+"\n");

            log(sbLog.toString());
            sbLog.setLength(0);

            outputData = (JSONObject)JSONParser.parser(strResultData);

        }catch(Exception e){

            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));

            sbLog.append("\nException :: " + sw.toString());
            sbLog.append("\nEnd Time " + SvcDateUtil.getInstance().getDate("YYYY-MM-DD HH24:MI:SS"));

            log(sbLog.toString());
            sbLog.setLength(0);

            outputData.put("RSLT_CD", "C999");
            outputData.put("RSLT_MSG", "처리중오류가발생하였습니다.잠시후이용하시기바랍니다.");
        }
        
        return outputData;
    }


    public static void log(String str){
    	CooconApi api = new CooconApi();

        BizLogUtil.debug(api, str);
    }
}
