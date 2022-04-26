package com.avatar.api.mgnt;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.Map;

import jex.json.JSONArray;
import jex.json.JSONObject;
import jex.json.parser.JSONParser;
import jex.log.JexLogFactory;
import jex.log.JexLogger;
import jex.sys.JexSystemConfig;
import jex.util.date.DateTime;

import com.avatar.comm.BizLogUtil;
import com.avatar.comm.ExternalConnectUtil;

/***
 * 비즈엠 api
 * @author moving
 *
 */
public class BizmApiMgnt {

    private static final JexLogger LOG = JexLogFactory.getLogger(BizmApiMgnt.class);

    /**
     * 가입 인사 메세지 전송
     * @param phn
     * @param msg
     * @param tmplId
     * @param button1
     * @return
     */
    public static JSONArray apiJoinSendMsg(String phn, String msg, String tmplId, JSONObject button1){

        JSONObject inputData = new JSONObject();
        JSONArray  inputDataArr  = new JSONArray();
        
        inputData.put("message_type"    , JexSystemConfig.get("bizm_api", "message_type"));
        inputData.put("phn"      		, phn);
        inputData.put("profile"      	, JexSystemConfig.get("bizm_api", "profile"));
        inputData.put("msg"      		, msg);
        inputData.put("tmplId"      	, tmplId); 	//회원가입 (renew_askavatar_001)
        inputData.put("button1"      	, button1);
        inputDataArr.add(inputData);
        
        String userid = JexSystemConfig.get("bizm_api", "user_id");
        return call_api(JexSystemConfig.get("bizm_api", "bizm_send_url"), userid, inputDataArr);
    }
    
    /**
     * 가입 인사 메세지 전송(버전3)
     * @param phn
     * @param msg
     * @param tmplId
     * @param button1
     * @param button2
     * @return
     */
    public static JSONArray apiJoinSendMsgVer3(String phn, String msg, String tmplId, JSONObject button1, JSONObject button2){

        JSONObject inputData = new JSONObject();
        JSONArray  inputDataArr  = new JSONArray();
        
        inputData.put("message_type"    , JexSystemConfig.get("bizm_api", "message_type"));
        inputData.put("phn"      		, phn);
        inputData.put("profile"      	, JexSystemConfig.get("bizm_api", "profile"));
        inputData.put("msg"      		, msg);
        inputData.put("tmplId"      	, tmplId); 	//회원가입 (renew_askavatar_001_ver2)
        inputData.put("button1"      	, button1);
        inputData.put("button2"      	, button2);
        inputDataArr.add(inputData);
        
        String userid = JexSystemConfig.get("bizm_api", "user_id");
        return call_api(JexSystemConfig.get("bizm_api", "bizm_send_url"), userid, inputDataArr);
    }
    
    /**
     * 사용자 인증(테스트 계정만 사용)
     * @param phoneNumber
     * @param token
     * @return
     */
    public static JSONArray apiUserCertify(String phoneNumber, String token){
    	// 개발서버에서 토큰 요청 URL
    	// https://dev-alimtalk-api.bizmsg.kr:1443/v2/partner/test/user/token?phoneNumber=01012341234 
        String url = "https://dev-alimtalk-api.bizmsg.kr:1443/v2/partner/test/user/certify?phoneNumber="+phoneNumber;
        url += "&token="+token;
        return call_api(url, "", new JSONArray());
    }

    
    
    /**
     * API 호출
     * @param url
     * @param url
     * @param input
     * @return
     */
    private static JSONArray call_api(String url, String userid, JSONArray input){

        StackTraceElement[] stacks = new Throwable().getStackTrace();
        StringBuffer sbLog = new StringBuffer();
        sbLog.append("\n------------------------ START ------------------------");
        sbLog.append("\nStartTime :: " + DateTime.getInstance().getDate("YYYY-MM-DD HH24:MI:SS"));

        if(stacks.length > 3)
        sbLog.append("\n[before] " + stacks[4].getClassName().replaceAll("002d", "").replaceAll("005f", "")+ " " + stacks[4].getMethodName());
        if(stacks.length > 2)
        sbLog.append("\n[before] " + stacks[3].getClassName().replaceAll("002d", "").replaceAll("005f", "")+ " " + stacks[3].getMethodName());
        sbLog.append("\n[before] " + stacks[2].getClassName().replaceAll("002d", "").replaceAll("005f", "")+ " " + stacks[2].getMethodName());

        JSONArray outputData = new JSONArray();
        
		Map<String, String> header = new HashMap();
		header.put("Content-Type", "application/json");
		header.put("userid", userid);

        try{
            sbLog.append("\nUrl	:: " + url);
            sbLog.append("\nInput	:: " + input.toJSONString());
            sbLog.append("\nHeader	:: " + header);
            
            String strResultData = ExternalConnectUtil.connect(url
                    , input.toJSONString()
                    , url.toLowerCase().startsWith("https")?"https":"http"
                    , "UTF-8"
                    , header);

            sbLog.append("\nResult :: " + strResultData);
            sbLog.append("\nEndTime :: " + DateTime.getInstance().getDate("YYYY-MM-DD HH24:MI:SS")+"\n");

            log(sbLog.toString());
            sbLog.setLength(0);

            JSONParser parser = new JSONParser();
            Object outputDataObj = parser.parser(strResultData);
            outputData = (JSONArray)outputDataObj;

        }catch(Exception e){

            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));

            sbLog.append("\nException :: " + sw.toString());
            sbLog.append("\nEnd Time " + DateTime.getInstance().getDate("YYYY-MM-DD HH24:MI:SS"));

            log(sbLog.toString());
            sbLog.setLength(0);

            JSONObject outputDataObj = new JSONObject();
            outputDataObj.put("code", "fail");
            outputDataObj.put("message", "처리중 오류가 발생하였습니다.");
            outputData.add(outputDataObj);
            
        }
        return outputData;
    }

    private static void log(String str){
        BizmApiMgnt PushApiMgntapi = new BizmApiMgnt();
        BizLogUtil.debug(PushApiMgntapi, str);
    }

}
