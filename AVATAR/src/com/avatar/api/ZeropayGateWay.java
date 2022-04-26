package com.avatar.api;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.Enumeration;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import com.avatar.comm.AESUtils;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.SvcDateUtil;

import jex.enums.JexLANG;
import jex.exception.JexBIZException;
import jex.json.JSONObject;
import jex.sys.JexSystemConfig;
import jex.util.StringUtil;
import jex.web.exception.JexWebBIZException;
import jex.web.ext.WebRequest;
import jex.web.ext.WebResponse;
import jex.web.servlet.JexServlet;


public class ZeropayGateWay extends JexServlet {

    public static final String SUCCESS                   = "0000"; // 성공
    public static final String UNDEFINE_ERROR            = "E_1000"; // 알수 없는 오류
    public static final String RECEIVE_DATA_FORMAT_ERROR = "E_1001"; // 수신 자료 포멧 오류
    public static final String API_SVC_NOT_ALLOWED       = "E_1002"; // API 인증 오류.
    public static final String API_SVC_ID_NOT_FOUND      = "E_1003"; // API_SVC_ID 찾지 못함
    public static final String SERVICE_NOT_FOUND         = "E_1004"; // JEX SERVICE를 찾지 못함

    public static final String SUCCESS_MSG               = "정상 처리되었습니다.";
    public static final String UNDEFINE_ERROR_MSG        = "처리중 오류가 발생하였습니다. 잠시후 이용하시기 바랍니다.";
    public static final String API_SVC_NOT_ALLOWED_MSG   = "공통부 필수입력 항목 누락. 인증되지 않은 요청입니다.";
    public static final String API_SVC_ID_NOT_FOUND_MSG  = "공통부 필수입력 항목 누락. API 서비스 ID를 확인하여 주십시오.";
    public static final String SERVICE_NOT_FOUND_MSG     = "API 서비스를 찾을 수 없습니다.";

    /**
     *
     */
    private static final long serialVersionUID = -3153726252110201567L;

    @Override
    public void jexService(WebRequest request, WebResponse response) throws IOException, ServletException {
    	
    	/****************************************
         * 응답부 Character Set
         ****************************************/
        response.setContentType("application/json; charset=UTF-8");


        /****************************************
         * local 변수 선언
         ****************************************/
        String strApiCrtsKey         = "";
        String strApiSvcId           = "";
        String strJSONData           = "";

        JSONObject jReqParam         = null; // 전문 요청 파라미터
        Map<String, Object> mReqData = null; // 전문 요청 개별부
        JSONObject jRspParam         = null; // 전문 응답 파라미터

        Map<String, Object> mActionData = null; // API 요청 데이타

        PrintWriter out              = response.getWriter();

        Enumeration<?> headerNames = request.getHeaderNames();
        BizLogUtil.debug(this, "Request Header ========================================");
        while(headerNames.hasMoreElements()) {
            String hname = (String)headerNames.nextElement();
            String hvalue = request.getHeader(hname);
            if(hvalue==null) hvalue = "";
            BizLogUtil.debug(this, "Request Header : "+hname+"="+hvalue);
        }
        BizLogUtil.debug(this, "Request Header ========================================");
        BizLogUtil.debug(this,"user-getRemoteAddr=" +request.getRemoteAddr());
        BizLogUtil.debug(this,"Method="+request.getMethod());

        /****************************************
         * 문자열 전문 취득
         ****************************************/
        if(!request.getMethod().equals("POST")){
        	sendRespErrorData(request, out, UNDEFINE_ERROR, UNDEFINE_ERROR_MSG, "", "");
        	return;
        } 
        
        StringBuilder stringBuilder = new StringBuilder();
        BufferedReader bufferedReader = null;
        try {
            InputStream inputStream = request.getInputStream();
            if (inputStream != null) {
                bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
                char[] charBuffer = new char[128];
                int bytesRead = -1;
                while ( (bytesRead = bufferedReader.read(charBuffer)) > 0 ) {
                    stringBuilder.append(charBuffer, 0, bytesRead);
                }
            }
        } catch (IOException ex) {
            throw ex;
        } finally {
            if (bufferedReader != null) {
                try {
                    bufferedReader.close();
                } catch (IOException ex) {
                    throw ex;
                }
            }
        }

        BizLogUtil.debug(this,"BODY="+stringBuilder.toString());
        strJSONData = stringBuilder.toString();

        /****************************************
         * JSONData 문자열 오류 체크
         ****************************************/
        if ("".equals(strJSONData)) {
            sendRespErrorData(request, out, RECEIVE_DATA_FORMAT_ERROR, "BODY 데이타 누락", "", strApiSvcId);
            return;
        }

        /****************************************
         * JSONData 오류 체크
         ****************************************/
        jReqParam = JSONObject.fromObject(strJSONData);
        if (jReqParam.isEmpty()) {
            sendRespErrorData(request, out, RECEIVE_DATA_FORMAT_ERROR, "송신한 데이터의 JSON변환 중 오류가 발생하였습니다.", "", strApiSvcId);
            return;
        }

        /****************************************
         * API 인증키 검증
         ****************************************/
        strApiCrtsKey = StringUtil.null2void(jReqParam.getString("API_KEY"));

        if(!strApiCrtsKey.equals("a5fb5485_3919_2086_f731_5689e70af6f3")){
            sendRespErrorData(request, out, API_SVC_NOT_ALLOWED, API_SVC_NOT_ALLOWED_MSG, "", strApiSvcId);
            return;
        }

        /****************************************
         * API ID 추출
         ****************************************/
        strApiSvcId  = StringUtil.null2void(jReqParam.getString("API_ID"));

        /****************************************
         * API ID 검증
         ****************************************/
        if ("".equals(strApiSvcId)) {
            sendRespErrorData(request, out, API_SVC_ID_NOT_FOUND, API_SVC_ID_NOT_FOUND_MSG, "", strApiSvcId);
            return;
        }
        BizLogUtil.debug(this,"API ID 검증 완료.");

        /****************************************
         * 서비스 context 초기화
         ****************************************/
        try {
            initContext(strApiSvcId, request, response, JexLANG.DF);
        } catch (Exception e) {
            e.printStackTrace();
            sendRespErrorData(request, out, SERVICE_NOT_FOUND, SERVICE_NOT_FOUND_MSG, e.toString(), strApiSvcId);
            return;
        }
        BizLogUtil.debug(this,"Context 초기화 완료.");
        
        /****************************************
         * API 요청 개별부 추출
         ****************************************/
   		mReqData = (Map<String, Object>) jReqParam.get("REQ_DATA");

        /****************************************
         * API 응답 파라미터 생성
         ****************************************/
        jRspParam = new JSONObject();

        /****************************************
         * 전문 호출
         ****************************************/
        try {
            // API 요청 개별부 설정
            mActionData = mReqData;
            
            // 암호화키
            String encryptKey = JexSystemConfig.get("avatarAPI", "enc_key");
        	String encryptIvKey = JexSystemConfig.get("avatarAPI", "enc_iv_key");
    		
        	// 암호화 KEY 
        	byte[] encKey = AESUtils.changeHex2Byte(encryptKey); 
        	byte[] encIv = AESUtils.changeHex2Byte(encryptIvKey);
    		
            String reqEv = (String)mActionData.get("EV");
            String reqVv = (String)mActionData.get("VV");
            
            BizLogUtil.debug(this,"reqEv :: "+reqEv);
    		BizLogUtil.debug(this,"reqVv :: "+reqVv);
    		
    		// EV데이터 복호화 
    	    String devEv = AESUtils.DecryptAes256(reqEv, encKey, encIv).substring(14);
    	    BizLogUtil.debug(this,"devEv :: "+devEv);
	        // 검증 VV 생성 
    	    String chkVv = AESUtils.getHmacSha256(devEv, encKey); 
	        BizLogUtil.debug(this,"chkVv :: "+chkVv);
	        
            if(!chkVv.equals(reqVv)){     
	        	jRspParam.put("RC" 	, "C003"		);
                jRspParam.put("RM"	, "데이터 검증 오류가 발생하였습니다.");
	        }else {
	        	BizLogUtil.debug(this,"strApiSvcId :: "+strApiSvcId);
	        	BizLogUtil.debug(this,"JSONObject.fromObject(devEv) :: "+JSONObject.fromObject(devEv));
	        	
	        	Map<String, Object> mActionInput = JSONObject.fromObject(devEv);
	        	BizLogUtil.debug(this,"mActionInput :: "+mActionInput.toString());
                
	        	// API 호출
	        	JSONObject jRspData = performJsonAction(strApiSvcId, mActionInput, request, response);
	 
	            BizLogUtil.debug(this,"jRspData :: "+jRspData.toJSONString());
	            
	            // 응답 파라미터 설정
	            if(jRspData.getJSONObject("attribute")==null){
	            	// 통신이 정상일 경우에 성공 메시지
	            	if( "".equals(StringUtil.null2void(jRspData.getString("RSLT_CD"))) ) {
	            		jRspParam.put("RC" 	, SUCCESS		);
	                    jRspParam.put("RM"	, SUCCESS_MSG	);
	            	}else {
	            		jRspParam.put("RC" 	, StringUtil.null2void(jRspData.getString("RSLT_CD"))	);
	                    jRspParam.put("RM"	, StringUtil.null2void(jRspData.getString("RSLT_MSG"))	);
	            	}
	            	// 요청일시(14)
	        		String reqDtm = SvcDateUtil.getInstance().getDateTime();
	        		// 암호화 EV 생성(현재시간정보(14) + 응답값) 
	        		String encEv = AESUtils.EncryptAes256(reqDtm+jRspData.toJSONString(), encKey, encIv); 
	        		// 암호화 VV 생성
	        		String encVv = AESUtils.getHmacSha256(jRspData.toJSONString(), encKey); 
	        		
	        		JSONObject rspEncData = new JSONObject(); 
	        		rspEncData.put("EV", encEv);	  // 암호화
	        		rspEncData.put("VV", encVv);	  // EV값의 HASH
	                jRspParam.put("RESP_DATA", rspEncData);
	
	            } else {
	                JSONObject attr = jRspData.getJSONObject("attribute");
	                if(attr.getString("_ERROR_CODE_").startsWith("S") || attr.getString("_ERROR_CODE_").equals("Session Disconnect")){
						jRspParam.put("RC" 	, attr.getString("_ERROR_CODE_")     );
						jRspParam.put("RM"	, attr.getString("_ERROR_MESSAGE_")  );
						jRspParam.put("RESP_DATA"	, "" );
					} else {
						jRspParam.put("RC" 	, UNDEFINE_ERROR		);
						jRspParam.put("RM"	, UNDEFINE_ERROR_MSG	);
						jRspParam.put("RESP_DATA"	, ""		);
					}
	            }
	        }
     
            // 응답 전송
            sendRespData(request, out, jRspParam.toString(), strApiSvcId);

        } catch (JexBIZException je) {
            BizLogUtil.error(this, je);
            sendRespErrorData(request, out, je.getCode(), je.getMessage(), je.toString(), strApiSvcId);
        } catch (JexWebBIZException jwe) {
            BizLogUtil.error(this, jwe);
            sendRespErrorData(request, out, jwe.getCode(), jwe.getMessage(), jwe.toString(), strApiSvcId);
        } catch (Error e) {
            BizLogUtil.error(this, e);
            sendRespErrorData(request, out, UNDEFINE_ERROR, UNDEFINE_ERROR_MSG, e.toString(), strApiSvcId);
        } catch (Throwable e) {
            BizLogUtil.error(this, e);
            if (e instanceof JexBIZException) {
                sendRespErrorData(request, out, ((JexBIZException) e).getCode(), ((JexBIZException) e).getMessage(), e.toString(), strApiSvcId);
            } else if (e instanceof ServletException) {
                if (((ServletException) e.getCause()).getCause() instanceof JexBIZException) {
                    JexBIZException je = (JexBIZException) ((ServletException) e.getCause()).getCause();
                    sendRespErrorData(request, out, je.getCode(), je.getMessage(), je.toString(), strApiSvcId);
                } else {
                    sendRespErrorData(request, out, UNDEFINE_ERROR, UNDEFINE_ERROR_MSG, e.toString(), strApiSvcId);
                }
            } else {
                sendRespErrorData(request, out, UNDEFINE_ERROR, UNDEFINE_ERROR_MSG, e.toString(), strApiSvcId);
            }
        } finally {
        }
    }

    private void sendRespData(HttpServletRequest request, PrintWriter out, String data, String ApiSvcId) throws Throwable {

        BizLogUtil.debug(this,"[RETRUNDATA]"+data);
        out.println(data);
    }

    private void sendRespErrorData(HttpServletRequest request, PrintWriter out, String id, String message, String debugMessage, String ApiSvcId) throws IOException {

        JSONObject jRspParam = new JSONObject();

        // 응답 파라미터 셋팅
        jRspParam.put("RSLT_CD" , id);      // 결과코드
        jRspParam.put("RSLT_MSG", message); // 결과메시지
        jRspParam.put("RESP_DATA", null);

        BizLogUtil.debug(this, "=== ["+ApiSvcId+"]Response Error Data ========================================");
        BizLogUtil.debug(this, jRspParam.toString());
        BizLogUtil.debug(this, "==============================================================================");

        out.println(jRspParam.toString());
    }

}
