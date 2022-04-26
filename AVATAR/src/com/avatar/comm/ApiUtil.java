package com.avatar.comm;

import jex.data.JexData;
import jex.json.JSONObject;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.util.DomainUtil;
import jex.util.StringUtil;
import jex.util.biz.JexCommonUtil;
import jex.web.JexContextWeb;

public class ApiUtil {
	private static final String	UNDEFINE_ERROR                  = "SOER1000" ;
	private static final String	UNDEFINE_ERROR_MSG              = "처리중오류가발생하였습니다.잠시후이용하시기바랍니다." ;
	private static final String	RECEIVE_DATA_FORMAT_ERROR       = "SOER1001" ;
	private static final String	RECEIVE_DATA_FORMAT_ERROR_MSG   = "송신한 데이터의 JSON변환 중 오류가 발생하였습니다." ;
	private static final String	TRNO_NO_NOT_FOUND               = "SOER1002" ;
	private static final String	TRNO_NO_NOT_FOUND_MSG           = "전문ID는필수입력사항입니다." ;
	private static final String	API_RCGN_CD_NOT_FOUND           = "SOER1003" ;
	private static final String	API_RCGN_CD_NOT_FOUND_MSG       = "API인증키를찾을수없습니다." ;
	private static final String	API_RCGN_CD_NOT_VALID           = "SOER1004" ;
	private static final String	API_RCGN_CD_NOT_VALID_MSG       = "유효하지 않은 API인증키 입니다." ;
	private static final String	TRNO_NO_NOT_VALID               = "SOER1005" ;
	private static final String	TRNO_NO_NOT_VALID_MSG           = "유효하지않은전문ID입니다." ;
	private static final String	HOST_DATA_FORMAT_ERROR          = "SOER1006" ;
	private static final String	HOST_DATA_FORMAT_ERROR_MSG      = "HOST 응답 데이터의 JSON변환 중 오류가 발생하였습니다." ;
	private static final String	CERT_INFO_ERROR                 = "SOER1007" ;
	private static final String	CERT_INFO_ERROR_MSG             = "이미 등록되어 있는 인증서입니다." ;
	private static final String	CERT_REG_ERROR                  = "SOER1008" ;
	private static final String	CERT_REG_ERROR_MSG              = "인증서등록중 오류가 발생하였습니다." ;
	private static final String	CERT_DEL_ERROR                  = "SOER1009" ;
	private static final String	CERT_DEL_ERROR_MSG              = "해당인증서를 사용중인 계좌가 있습니다." ;
	private static final String	CERT_REG_NOT_ERROR              = "SOER1010" ;
	private static final String	CERT_REG_NOT_ERROR_MSG          = "등록되어 있는 인증서가 없습니다." ;
	private static final String	CERT_REG_P_ERROR                = "SOER1011" ;
	private static final String	CERT_REG_P_ERROR_MSG            = "일부 계좌번호만 등록" ;
	private static final String	UNDEFINE_BIZ_ERROR              = "SOER3000" ;
	private static final String	UNDEFINE_BIZ_ERROR_MSG          = "처리중 오류가 발생하였습니다.잠시후 이용하시기 바랍니다." ;
	private static final String	SSESION_TIMEOUT                 = "SOER3001" ;
	private static final String	SSESION_TIMEOUT_MSG             = "세션이종료되었습니다." ;
	private static final String	SOCKET_TIMEOUT                  = "SOER3003" ;
	private static final String	SOCKET_TIMEOUT_MSG              = "SOCKET TIMEOUT 오류발생" ;
	private static final String	HOST_URL_NOT_VALID              = "SOER3004" ;
	private static final String	HOST_URL_NOT_VALID_MSG          = "알수 없는 호스트 정보입니다" ;
	private static final String	UNDEFINE_DB_ERROR               = "SOER3007" ;
	private static final String	UNDEFINE_DB_ERROR_MSG           = "처리중 오류가 발생하였습니다.잠시후 이용하시기 바랍니다." ;
	private static final String	USER_INFO_NOT_FOUND             = "SOER4001" ;
	private static final String	USER_INFO_NOT_FOUND_MSG         = "등록된 사용자가 없습니다." ;
	private static final String	USER_INFO_NOT_VALID             = "SOER4002" ;
	private static final String	USER_INFO_NOT_VALID_MSG         = "사용자 불일치." ;
	private static final String	USER_INFO_NOT_STTS              = "SOER4006" ;
	private static final String	USER_INFO_NOT_STTS_MSG          = "해지 또는 중지된 사용자 입니다. " ;
	private static final String	USER_INFO_NOT_STTS_8            = "SOER4003" ;
	private static final String	USER_INFO_NOT_STTS_MSG_8        = "중지된 사용자 입니다." ;
	private static final String	USER_INFO_NOT_STTS_9            = "SOER4005" ;
	private static final String	USER_INFO_NOT_STTS_MSG_9        = "해지된 사용자 입니다. 재 가입해서 이용하시길 바랍니다." ;
	private static final String	USER_INFO_PWD_NOT_STTS          = "SOER4004" ;
	private static final String	USER_INFO_PWD_NOT_STTS_MSG      = "비밀번호를 확인하세요." ;

	public static final String REG_PUSH_API_ID				= "PS0002"; /* 디바이스 등록      */
	public static final String UPD_PUSH_API_ID	            = "PS0003"; /* 디바이스 변경 */
	public static final String DEL_PUSH_API_ID	            = "PS0005"; /* 디바이스 해지  */

	public static JSONObject ErrorJsonData(String id, String message){
		JSONObject sendJsonData = new JSONObject();
        sendJsonData.put("RSLT_CD"     , id       );	//결과코드
        sendJsonData.put("RSLT_MSG"    , message  );	//결과메시지
        return sendJsonData;
	}

	public static JSONObject ErrorJsonData(String id, String message, String gb){
		JSONObject sendJsonData = new JSONObject();
		sendJsonData.put("RSLT_CD"      , id       );	//결과코드
		sendJsonData.put("RSLT_MSG"     , message  );	//결과메시지
		sendJsonData.put("RSLT_PROC_GB" , gb       );	//응답결과처리구분
		return sendJsonData;
	}

	public static JSONObject ErrorJsonData(String id){
		return getCooconErroMsgJson(id);
	}

	/***
	 * 정상처리
	 * @return
	 */
	public static JSONObject getOkJson(){
	    return ApiUtil.ErrorJsonData( "0000", "정상처리 되었습니다." , "0");
	}

	/***
	*처리중오류가발생하였습니다.잠시후이용하시기바랍니다.
	****/
	public static JSONObject getUNDEFINE_ERROR(){
	    return ApiUtil.ErrorJsonData( ApiUtil.UNDEFINE_ERROR            , ApiUtil.UNDEFINE_ERROR_MSG            , "0");
	}
	/***
	*수신 자료 포멧 오류
	****/
	public static JSONObject getRECEIVE_DATA_FORMAT_ERROR(){
	    return ApiUtil.ErrorJsonData( ApiUtil.RECEIVE_DATA_FORMAT_ERROR , ApiUtil.RECEIVE_DATA_FORMAT_ERROR_MSG , "0");
	}
	/***
	*전문ID는필수입력사항입니다.
	****/
	public static JSONObject getTRNO_NO_NOT_FOUND(){
	    return ApiUtil.ErrorJsonData( ApiUtil.TRNO_NO_NOT_FOUND         , ApiUtil.TRNO_NO_NOT_FOUND_MSG         , "0");
	}
	/***
	*API인증키를찾을수없습니다.
	****/
	public static JSONObject getAPI_RCGN_CD_NOT_FOUND(){
	    return ApiUtil.ErrorJsonData( ApiUtil.API_RCGN_CD_NOT_FOUND     , ApiUtil.API_RCGN_CD_NOT_FOUND_MSG     , "0");
	}
	/***
	*유효하지 않은 API인증키 입니다.
	****/
	public static JSONObject getAPI_RCGN_CD_NOT_VALID(){
	    return ApiUtil.ErrorJsonData( ApiUtil.API_RCGN_CD_NOT_VALID     , ApiUtil.API_RCGN_CD_NOT_VALID_MSG     , "0");
	}
	/***
	*유효하지않은전문ID입니다.
	****/
	public static JSONObject getTRNO_NO_NOT_VALID(){
	    return ApiUtil.ErrorJsonData( ApiUtil.TRNO_NO_NOT_VALID         , ApiUtil.TRNO_NO_NOT_VALID_MSG         , "0");
	}
	/***
	*HOST 응답 데이터의 JSON변환 중 오류가 발생하였습니다.
	****/
	public static JSONObject getHOST_DATA_FORMAT_ERROR(){
	    return ApiUtil.ErrorJsonData( ApiUtil.HOST_DATA_FORMAT_ERROR     , ApiUtil.HOST_DATA_FORMAT_ERROR       , "0");
	}
	/***
	*이미등록되어 있는 인증서 입니다.
	****/
	public static JSONObject getCERT_INFO_ERROR(){
	    return ApiUtil.ErrorJsonData( ApiUtil.CERT_INFO_ERROR     , ApiUtil.CERT_INFO_ERROR_MSG       , "0");
	}
	/***
	*인증서 등록중 오류발생
	****/
	public static JSONObject getCERT_REG_ERROR(){
	    return ApiUtil.ErrorJsonData( ApiUtil.CERT_REG_ERROR     , ApiUtil.CERT_REG_ERROR_MSG       , "0");
	}
	/***
	*해당인증서를 사용중인 계좌가 있습니다
	****/
	public static JSONObject getCERT_DEL_ERROR(){
	    return ApiUtil.ErrorJsonData( ApiUtil.CERT_DEL_ERROR     , ApiUtil.CERT_DEL_ERROR_MSG       , "0");
	}
	/***
	*등록되어 있는 인증서가 없습니다
	****/
	public static JSONObject getCERT_REG_NOT_ERROR(){
	    return ApiUtil.ErrorJsonData( ApiUtil.CERT_REG_NOT_ERROR     , ApiUtil.CERT_REG_NOT_ERROR_MSG       , "0");
	}

	/***
	*처리중 오류가 발생하였습니다.잠시후 이용하시기 바랍니다.
	****/
	public static JSONObject getUNDEFINE_BIZ_ERROR(){
	    return ApiUtil.ErrorJsonData( ApiUtil.UNDEFINE_BIZ_ERROR        , ApiUtil.UNDEFINE_BIZ_ERROR_MSG        , "0");
	}
	/***
	*세션이종료되었습니다.
	****/
	public static JSONObject getSSESION_TIMEOUT(){
	    return ApiUtil.ErrorJsonData( ApiUtil.SSESION_TIMEOUT           , ApiUtil.SSESION_TIMEOUT_MSG           , "0");
	}
	/***
	*SOCKET TIMEOUT 오류발생
	****/
	public static JSONObject getSOCKET_TIMEOUT(){
	    return ApiUtil.ErrorJsonData( ApiUtil.SOCKET_TIMEOUT            , ApiUtil.SOCKET_TIMEOUT_MSG            , "0");
	}
	/***
	*알수 없는 호스트 정보입니다
	****/
	public static JSONObject getHOST_URL_NOT_VALID(){
	    return ApiUtil.ErrorJsonData( ApiUtil.HOST_URL_NOT_VALID        , ApiUtil.HOST_URL_NOT_VALID_MSG        , "0");
	}
	/***
	*처리중 오류가 발생하였습니다.잠시후 이용하시기 바랍니다.
	****/
	public static JSONObject getUNDEFINE_DB_ERROR(){
	    return ApiUtil.ErrorJsonData( ApiUtil.UNDEFINE_DB_ERROR         , ApiUtil.UNDEFINE_DB_ERROR_MSG         , "0");
	}
	/***
	*등록된 사용자가 없습니다.
	****/
	public static JSONObject getUSER_INFO_NOT_FOUND(){
	    return ApiUtil.ErrorJsonData( ApiUtil.USER_INFO_NOT_FOUND       , ApiUtil.USER_INFO_NOT_FOUND_MSG       , "0");
	}
	/***
	*사용자 불일치.
	****/
	public static JSONObject getUSER_INFO_NOT_VALID(){
	    return ApiUtil.ErrorJsonData( ApiUtil.USER_INFO_NOT_VALID       , ApiUtil.USER_INFO_NOT_VALID_MSG       , "0");
	}
	/***
	*해지또는 정지
	****/
	public static JSONObject getUSER_INFO_NOT_STTS(){
	    return ApiUtil.ErrorJsonData( ApiUtil.USER_INFO_NOT_STTS      , ApiUtil.USER_INFO_NOT_STTS_MSG        , "1");
	}
	/***
	*해지 된 사용자 입니다.
	****/
	public static JSONObject getUSER_INFO_NOT_STTS_9(){
	    return ApiUtil.ErrorJsonData( ApiUtil.USER_INFO_NOT_STTS_9      , ApiUtil.USER_INFO_NOT_STTS_MSG_9        , "1");
	}
	/***
	 *중지된 사용자 입니다.
	 ****/
	public static JSONObject getUSER_INFO_NOT_STTS_8(){
		return ApiUtil.ErrorJsonData( ApiUtil.USER_INFO_NOT_STTS_8      , ApiUtil.USER_INFO_NOT_STTS_MSG_8        , "1");
	}
	/***
	*비밀번호 확인
	****/
	public static JSONObject getUSER_INFO_PWD_NOT_STTS(){
	    return ApiUtil.ErrorJsonData( ApiUtil.USER_INFO_PWD_NOT_STTS    , ApiUtil.USER_INFO_PWD_NOT_STTS_MSG        , "0");
	}

	/**
	 * 오류메세지 String
	 * @param errCode
	 * @return
	 */
	public static String getCooconErroMsgStr(String errCode){
		String errMsg = "";

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContextWeb.getContext().getCommonUtil();
		try{
	        JexData idoIn1 = util.createIDOData("ERCD_INFM_R001");

	        idoIn1.put("ERR_CD",errCode);

	        JexData idoOut = idoCon.execute(idoIn1);

	        // 도메인 에러 검증
	        if (DomainUtil.isError(idoOut)) {
	        }

			if("".equals(StringUtil.null2void(idoOut.getString("CUST_MESG")))){
				errMsg = idoOut.getString("ERR_MESG");
			}else{
				errMsg = idoOut.getString("CUST_MESG");
			}


		}catch(Exception e){

			BizLogUtil.debug("ApiUtil", "==============================");
			BizLogUtil.debug("ApiUtil", "===============e.getMessage() :: " + e.getMessage());

		}

		return errMsg;
	}
	/**
	 * 오류메세지 json
	 * @param errCode
	 * @return
	 */
	public static JSONObject getCooconErroMsgJson(String errCode){
		String errMsg = "";
		String errgb  = "";

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContextWeb.getContext().getCommonUtil();

		try{


	        JexData idoIn1 = util.createIDOData("EMPL_LDGR_R001");

	        idoIn1.put("ERR_CD", errCode);

	        JexData idoOut = idoCon.execute(idoIn1);

	        // 도메인 에러 검증
	        if (DomainUtil.isError(idoOut)) {
	        }

			if( "".equals(StringUtil.null2void(idoOut.getString("ERR_CD"))) ){// 등록되어 있는 코드가 없을경우
				errMsg = "처리중 오류가 발생하였습니다.";


			}else{
				if("".equals(StringUtil.null2void(idoOut.getString("CUST_MESG")))){
					errMsg = idoOut.getString("ERR_MESG");
				}else{
					errMsg = idoOut.getString("CUST_MESG");
				}

			}

			errgb = "1"; //StringUtil.null2void(idoOut.getRsltProcGb(), "1");


		}catch(Exception e){

			BizLogUtil.debug("ApiUtil", "==============================");
			BizLogUtil.debug("ApiUtil", "===============e.getMessage() :: " + e.getMessage());

		}

		return ApiUtil.ErrorJsonData(errCode,errMsg,errgb);
	}

}
