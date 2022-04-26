package com.avatar.api.mgnt;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Map;

import jex.json.JSONObject;
import jex.sys.JexSystemConfig;

import com.avatar.comm.AESUtils;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.ExternalConnectUtil;
import com.avatar.comm.SvcDateUtil;

public class ZeropayApiMgnt {
	
	/**
	 * 제로페이연결 
	 * @param CI 대표자 CI
	 * @param STATE_CODE 상태
	 * @return
	 */
	public static JSONObject data_api_001(String ci) {

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("CI", ci);
		//inputREQ_DATA.put("STATE_CODE", state_code);

		return apiDataMake("AVATAR_API_001", inputREQ_DATA);
	}
	
	/**
	 * 결제내역집계 
	 * @param CI 대표자 CI
	 * @param TRAN_OCC_DATE 거래일자
	 * @return
	 */
	public static JSONObject data_api_003(String ci, String tran_occ_date) {

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("CI", ci);
		inputREQ_DATA.put("TRAN_OCC_DATE", tran_occ_date);

		return apiDataMake("AVATAR_API_003", inputREQ_DATA);
	}
	
	/**
	 * 결제내역집계 
	 * @param CI 대표자 CI
	 * @param AFLT_NM 가맹점명
	 * @param STR_DATE 조회시작일자
	 * @param END_DATE 조회종료일자
	 * @return
	 */
	public static JSONObject data_api_003_sdk(String ci, String str_date, String end_date, String mest_nm,
			String PAGE_NO, String PAGE_SIZE) {

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("CI", ci);
		inputREQ_DATA.put("AFLT_NM", mest_nm);
		inputREQ_DATA.put("STR_DATE", str_date);
		inputREQ_DATA.put("END_DATE", end_date);
		inputREQ_DATA.put("PAGE_NO", PAGE_NO);
		inputREQ_DATA.put("PAGE_SIZE", PAGE_SIZE);

		return apiDataMake("AVATAR_API_003", inputREQ_DATA);
	}
	
	/**
	 * 결제내역조회 
	 * @param CI 대표자 CI 
	 * @param BIZ_NO 사업자번호 
	 * @param SER_BIZ_NO 가맹점종사업번호 
	 * @param STR_DATE 조회시작일자
	 * @param END_DATE 조회종료일자
	 * @param TRAN_TP 거래구분(상품권, 일반) 
	 * @return
	 */
	public static JSONObject data_api_004(String ci, String biz_no, String ser_biz_no
			, String str_date, String end_date, String tran_tp) {
		
		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("CI", ci);
		inputREQ_DATA.put("BIZ_NO", biz_no);
		inputREQ_DATA.put("SER_BIZ_NO", ser_biz_no);
		inputREQ_DATA.put("STR_DATE", str_date);
		inputREQ_DATA.put("END_DATE", end_date);
		inputREQ_DATA.put("TRAN_TP", tran_tp);

		return apiDataMake("AVATAR_API_004", inputREQ_DATA);
	}
	
	/**
	 * 결제내역조회 
	 * @param CI 대표자 CI 
	 * @param STR_DATE 조회시작일자 
	 * @param END_DATE 조회종료일자 
	 * @param TRAN_TP 거래구분
	 * @param AFLT_NM 가맹점명
	 * @param PAY_ST 결제상태
	 * @param PAY_NM 결제사명
	 * @param GIFT_NM 상품권명
	 * @param PAGE_NO 페이지 Index
	 * @param PAGE_SIZE 페이지 SIZE
	 * @return
	 */
	public static JSONObject data_api_004_sdk(String ci, String str_date, String end_date
			, String biz_cd, String mest_nm, String pay_st, String pay_nm, String gift_nm
			, String PAGE_NO, String PAGE_SIZE) {
		
		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("CI", ci);
		inputREQ_DATA.put("STR_DATE", str_date);
		inputREQ_DATA.put("END_DATE", end_date);
		inputREQ_DATA.put("TRAN_TP", biz_cd);
		inputREQ_DATA.put("AFLT_NM", mest_nm);
		inputREQ_DATA.put("PAY_ST", pay_st);
		inputREQ_DATA.put("PAY_NM", pay_nm);
		inputREQ_DATA.put("GIFT_NM", gift_nm);
		inputREQ_DATA.put("PAGE_NO", PAGE_NO);
		inputREQ_DATA.put("PAGE_SIZE", PAGE_SIZE);
		
		return apiDataMake("AVATAR_API_004", inputREQ_DATA);
	}
	
	/**
	 * 결제수수료
	 * @param CI 대표자 CI 
	 * @param BIZ_NO 사업자번호 
	 * @param SER_BIZ_NO 가맹점종사업번호 
	 * @param STR_DATE 조회시작일자
	 * @param END_DATE 조회종료일자
	 * @return
	 */
	public static JSONObject data_api_005(String ci, String biz_no, String ser_biz_no
			, String str_date, String end_date) {
		
		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("CI", ci);
		inputREQ_DATA.put("BIZ_NO", biz_no);
		inputREQ_DATA.put("SER_BIZ_NO", ser_biz_no);
		inputREQ_DATA.put("STR_DATE", str_date);
		inputREQ_DATA.put("END_DATE", end_date);
		
		return apiDataMake("AVATAR_API_005", inputREQ_DATA);
	}
	
	/**
	 * 결제수수료
	 * @param CI 대표자 CI 
	 * @param STR_DATE 조회시작일자
	 * @param END_DATE 조회종료일자
	 * @param AFLT_NM 가맹점명
	 * @return
	 */
	public static JSONObject data_api_005_sdk(String ci, String str_date, String end_date
			, String mest_nm ) 
	{
		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("CI", ci);
		inputREQ_DATA.put("STR_DATE", str_date);
		inputREQ_DATA.put("END_DATE", end_date);
		inputREQ_DATA.put("AFLT_NM", mest_nm);
		
		return apiDataMake("AVATAR_API_005", inputREQ_DATA);
	}
	
	/**
	 * 입금예정
	 * @param CI 대표자 CI 
	 * @param BIZ_NO 사업자번호 
	 * @param SER_BIZ_NO 가맹점종사업번호 
	 * @param DEPOSIT_SCH_DATE 입금예정일자
	 * @return
	 */
	public static JSONObject data_api_006(String ci, String biz_no, String ser_biz_no
			, String deposit_sch_date) {
		
		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("CI", ci);
		inputREQ_DATA.put("BIZ_NO", biz_no);
		inputREQ_DATA.put("SER_BIZ_NO", ser_biz_no);
		inputREQ_DATA.put("DEPOSIT_SCH_DATE", deposit_sch_date);
		
		return apiDataMake("AVATAR_API_006", inputREQ_DATA);
	}
	

	/**
	 * 입금예정
	 * @param CI 대표자 CI 
	 * @param DEPOSIT_SCH_DATE 입금예정일자
	 * @param AFLT_NM 가맹점명
	 * @return
	 */
	public static JSONObject data_api_006_sdk(String ci, String deposit_sch_date, String mest_nm) {
		
		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("CI", ci);
		inputREQ_DATA.put("DEPOSIT_SCH_DATE", deposit_sch_date);
		inputREQ_DATA.put("AFLT_NM", mest_nm);
		
		return apiDataMake("AVATAR_API_006", inputREQ_DATA);
	}
	
	/**
	 * 입금예정상세
	 * @param CI 대표자 CI 
	 * @param BIZ_NO 사업자번호 
	 * @param SER_BIZ_NO 가맹점종사업번호 
	 * @param DEPOSIT_SCH_DATE 입금예정일자
	 * @param BIZ_CD 결제구분
	 * @return
	 */
	public static JSONObject data_api_007(String ci, String biz_no, String ser_biz_no
			, String deposit_sch_date, String biz_cd) {
		
		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("CI", ci);
		inputREQ_DATA.put("BIZ_NO", biz_no);
		inputREQ_DATA.put("SER_BIZ_NO", ser_biz_no);
		inputREQ_DATA.put("DEPOSIT_SCH_DATE", deposit_sch_date);
		inputREQ_DATA.put("BIZ_CD", biz_cd);
		
		return apiDataMake("AVATAR_API_007", inputREQ_DATA);
	}
	
	/**
	 * 입금예정상세
	 * @param CI 대표자 CI 
	 * @param DEPOSIT_SCH_DATE 입금예정일자
	 * @param BIZ_CD 결제구분
	 * @param AFLT_NM 가맹점명
	 * @return
	 */
	public static JSONObject data_api_007_sdk(String ci, String deposit_sch_date
			, String biz_cd, String mest_nm) {
		
		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("CI", ci);
		inputREQ_DATA.put("DEPOSIT_SCH_DATE", deposit_sch_date);
		inputREQ_DATA.put("BIZ_CD", biz_cd);
		inputREQ_DATA.put("AFLT_NM", mest_nm);
		
		return apiDataMake("AVATAR_API_007", inputREQ_DATA);
	}
	
	/**
	 * 가맹점정보 조회
	 * @param CI 대표자 CI
	 * @param AFLT_NM 가맹점명
	 * @return
	 */
	public static JSONObject data_api_008(String ci, String aflt_nm, String aflt_management_no, String biz_no, String ser_biz_no) {

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("CI", ci);
		inputREQ_DATA.put("AFLT_NM", aflt_nm);
		inputREQ_DATA.put("AFLT_MANAGEMENT_NO", aflt_management_no);
		inputREQ_DATA.put("BIZ_NO", biz_no);
		inputREQ_DATA.put("SER_BIZ_NO", ser_biz_no);

		return apiDataMake("AVATAR_API_008", inputREQ_DATA);
	}


	/**
	 * api 공통
	 * @param svcId
	 * @param reqData
	 * @return
	 */
	private static JSONObject apiDataMake(String svcId, JSONObject reqData){
		
		// 암호화키
		String encryptKey = JexSystemConfig.get("avatarAPI", "enc_key");
		String encryptIvKey = JexSystemConfig.get("avatarAPI", "enc_iv_key");
		
		// 요청일시(14)
		String reqDtm = SvcDateUtil.getInstance().getDateTime();
		
		// INPUT Body(입력값 생성)
		String plainEv = reqData.toJSONString();
		
		// 암호화 KEY 
		byte[] encKey = AESUtils.changeHex2Byte(encryptKey); 
		byte[] encIv = AESUtils.changeHex2Byte(encryptIvKey); 
		
		 
		// 암호화 EV 생성(현재시간정보(14) + 입력값) 
		String encEv = AESUtils.EncryptAes256(reqDtm+plainEv, encKey, encIv); 
		 
		// 암호화 VV 생성
		String encVv = AESUtils.getHmacSha256(plainEv, encKey); 
		
		JSONObject reqEncData = new JSONObject(); 
		reqEncData.put("SVC_ID", svcId); 
		reqEncData.put("EV"	   , encEv);  
		reqEncData.put("VV"	   , encVv);
		
		// 응답값 처리
		JSONObject rltObj = call_api(JexSystemConfig.get("zeropay_api", "Zeropay_Url"), reqEncData);
		JSONObject rltData = new JSONObject();
        
		// 성공일 경우
		if(rltObj.getString("RC").equals("0000")) {
			String rltEv = "";
			try {
				rltEv = rltObj.getString("EV");
				
				// EV값의 HASH(검증을 위한 데이터)
		        String rltVv = rltObj.getString("VV"); 
		        
		        // EV데이터 복호화 
		        String devEv = AESUtils.DecryptAes256(rltEv, encKey, encIv).substring(14); // 요청일시(14) 삭제 
		        
		        StringBuffer sbLog = new StringBuffer();
		        sbLog.append("\n------------------------ EV Decrypt START------------------------");
		        sbLog.append("\ninput DATA :: " + plainEv);
		        sbLog.append("\nEV DATA :: " + devEv);
		        log(sbLog.toString());
	            sbLog.setLength(0);
	            
		        // 검증 VV 생성 
		        String chkVv = AESUtils.getHmacSha256(devEv, encKey); 
		        
		        if(!chkVv.equals(rltVv)){     
		        	rltData.put("RSLT_CD", "9999");
					rltData.put("RSLT_MSG", "데이터 검증 오류가 발생하였습니다.");
		        }else {
		        	//응답값 처리 
			        rltData = JSONObject.fromObject(devEv);
		        	//rltData.put("RSLT_CD", "0000");
					//rltData.put("RSLT_MSG", "정상처리되었습니다.");
		        }
		       
			} catch (Exception e) {
				rltData.put("RSLT_CD", "9999");
				rltData.put("RSLT_MSG", "응답결과 디코딩 중 오류가 발생하였습니다.");
			}
		}else {
			rltData.put("RSLT_CD", rltObj.getString("RC"));
			rltData.put("RSLT_MSG", rltObj.getString("RM"));
		}
		
        return rltData;
    }


	private static JSONObject call_api(String url, JSONObject input){

        StackTraceElement[] stacks = new Throwable().getStackTrace();
        StringBuffer sbLog = new StringBuffer();
        sbLog.append("\n------------------------ START ------------------------");
        sbLog.append("\nStartTime :: " + SvcDateUtil.getInstance().getDate("YYYY-MM-DD HH24:MI:SS"));

        if(stacks.length > 3)
        sbLog.append("\n[before] " + stacks[4].getClassName()+ " " + stacks[4].getMethodName());
        if(stacks.length > 2)
        sbLog.append("\n[before] " + stacks[3].getClassName()+ " " + stacks[3].getMethodName());
        sbLog.append("\n[before] " + stacks[2].getClassName()+ " " + stacks[2].getMethodName());

        JSONObject outputData = new JSONObject();

        Map<String, String> header = new HashMap();
		header.put("Content-Type"	 , "application/json");
		header.put("Content-Length"	 , String.valueOf(input.toString().getBytes().length)); 
		header.put("JEX_ID"			 , "GW_AVATAR");
		header.put("Content-Language", "UTF-8");
		
        try{
        	sbLog.append("\nurl  :: " + url);
            sbLog.append("\nInput  :: " + input.toJSONString());
            sbLog.append("\nHeader	:: " + header);

            String strResultData = ExternalConnectUtil.connect(url
                    , input.toJSONString()
                    , url.toLowerCase().startsWith("https")?"https":"http"
                    , "UTF-8"
                    , header);
            
            sbLog.append("\nResult :: " + strResultData);
            sbLog.append("\nEndTime :: " + SvcDateUtil.getInstance().getDate("YYYY-MM-DD HH24:MI:SS")+"\n");

            log(sbLog.toString());
            sbLog.setLength(0);

            outputData = JSONObject.fromObject(strResultData);
            
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
		ZeropayApiMgnt api = new ZeropayApiMgnt();
        BizLogUtil.debug(api, str);
    }

}
