package com.avatar.api.mgnt;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.URLEncoder;

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
 * 푸쉬 api
 * @author moving
 *
 */
public class PushApiMgnt {

    private static final JexLogger LOG = JexLogFactory.getLogger(PushApiMgnt.class);

    /**
     * 디바이스 등록
     * @param user_id
     * @param reqData
     * @return
     */
    public static JSONObject svc_PS0002(String user_id, JSONObject reqData){

        JSONObject inputREQ_DATA = new JSONObject();

        inputREQ_DATA.put("_pushserver_kind", reqData.getString("_pushserver_kind"));
        inputREQ_DATA.put("_push_id"        , reqData.getString("_push_id"        ));
		inputREQ_DATA.put("_model_name"     , reqData.getString("_model_name"     ));
		inputREQ_DATA.put("_os"             , reqData.getString("_os"             ));
		inputREQ_DATA.put("_device_id"      , reqData.getString("_device_id"      ));
		inputREQ_DATA.put("_remark"         , reqData.getString("_remark"         ));
		inputREQ_DATA.put("_relation_key"   , user_id);

        return apiDataMake("PS0002", inputREQ_DATA);
    }

    /**
     * 디바이스 해지
     * @param user_id
     * @param reqData
     * @return
     */
    public static JSONObject svc_PS0005(String remark,  String device_id, String pushserver_kind){

        JSONObject inputREQ_DATA = new JSONObject();


        inputREQ_DATA.put("_pushserver_kind", pushserver_kind);
        inputREQ_DATA.put("_device_id"      , device_id.trim());
		inputREQ_DATA.put("_remark"         , remark.trim());


        return apiDataMake("PS0005", inputREQ_DATA);
    }

    /**
     * <pre>
     * 메세지전송
     * </pre>
     * @param display_message 푸시 메시지
     * @param relation_key 연계키(사용자ID)
     * @param control_cd 정의된 제어코드(등록일자)
     * @param control_message 정의된 제어메시지(페이지URL)
     * @param badge_cnt 뱃지 개수(건수)
     * @return
     */
    public static JSONObject svc_MS0001(String display_message, String relation_key, String control_cd,String control_message, String badge_cnt){

        JSONObject msgData  = new JSONObject();
        JSONArray  arr_msg  = new JSONArray();
        JSONObject jsonData = new JSONObject();

        msgData.put("_display_message" , display_message ) ; // 푸시 메시지          (256)
        msgData.put("_relation_key"    , relation_key                                 ) ; // 연계키                (100)
        msgData.put("_work_id"         , JexSystemConfig.get("push_api", "work_id")   ) ; // 등록된 업무 ID  (20 )
        msgData.put("_sender_cd"       , JexSystemConfig.get("push_api", "sender_cd") ) ; // 정의된 전송코드   (20 )
        msgData.put("_user_id"         , JexSystemConfig.get("push_api", "user_id")   ) ; // 등록된 사용자 ID (20 )
        msgData.put("_control_cd"      , control_cd                                   ) ; // 정의된 제어코드   (10 )
        msgData.put("_control_message" , control_message                              ) ; // 정의된 제어코드   (10 )
        msgData.put("_appgroup_id"     , ""                                           ) ; // 앱 그룹 ID      (20 )
        msgData.put("_company_id"      , JexSystemConfig.get("push_api", "company_id")) ; // 업체 ID        (20 )
        msgData.put("_company_msg_id"  , ""                                           ) ; // 업체 메시지 ID   (20 )
        msgData.put("_retrans_yn"      , ""                                           ) ; // 재전송 여부          (1  )
        msgData.put("_remark"          , ""                                           ) ; // 비고                    (100)
        msgData.put("_badge_cnt"       , badge_cnt                                    ) ; // 뱃지 개수 (숫자) (3  )

        arr_msg.add(msgData);

        //공통부
        jsonData.put("_tran_cd", "MS0001"); //API명
        jsonData.put("_tran_req_data", arr_msg);
        return call_api(JexSystemConfig.get("push_api", "api_url"), jsonData);
    }

    /**
     * 공통 값 세팅
     * @param apiId
     * @param user_id
     * @param reqData
     * @return
     */
    private static JSONObject apiDataMake(String apiId, JSONObject reqData){


    	// 등록
    	/**
    	 * _tran_cd, _tran_req_data
    	 */

        JSONObject inputData = new JSONObject();
        JSONArray REQ = new JSONArray();

        if(reqData.getString("_remark").equals("iOS")){
			reqData.put("_app_id"          , JexSystemConfig.get("push_api", "prjid_ios"));
			reqData.put("_pushserver_kind" , JexSystemConfig.get("push_api", "pushserver_kind_ios"));
		} else {
			reqData.put("_app_id"          , JexSystemConfig.get("push_api", "prjid_aos"));
			reqData.put("_pushserver_kind" , JexSystemConfig.get("push_api", "pushserver_kind_aos"));
		}

        reqData.put("_company_id"      , JexSystemConfig.get("push_api", "company_id"));
        reqData.put("_retrans_yn"      , "N");

        inputData.put("_tran_cd"  , apiId);
        REQ.add(reqData);
        inputData.put("_tran_req_data", REQ );

        return call_api(JexSystemConfig.get("push_api", "api_url"), inputData);
    }

    /**
     * API 호출
     * @param url
     * @param input
     * @return
     */
    private static JSONObject call_api(String url, JSONObject input){

        StackTraceElement[] stacks = new Throwable().getStackTrace();
        StringBuffer sbLog = new StringBuffer();
        sbLog.append("\n------------------------ START ------------------------");
        sbLog.append("\nStartTime :: " + DateTime.getInstance().getDate("YYYY-MM-DD HH24:MI:SS"));

        if(stacks.length > 3)
        sbLog.append("\n[before] " + stacks[4].getClassName().replaceAll("002d", "").replaceAll("005f", "")+ " " + stacks[4].getMethodName());
        if(stacks.length > 2)
        sbLog.append("\n[before] " + stacks[3].getClassName().replaceAll("002d", "").replaceAll("005f", "")+ " " + stacks[3].getMethodName());
        sbLog.append("\n[before] " + stacks[2].getClassName().replaceAll("002d", "").replaceAll("005f", "")+ " " + stacks[2].getMethodName());

        JSONObject outputData = new JSONObject();

        try{
            sbLog.append("\nInput  :: " + input.toJSONString());

            String strResultData = ExternalConnectUtil.connect(url
                    , "JSONData=" + URLEncoder.encode(input.toJSONString(), "UTF-8")
                    , url.toLowerCase().startsWith("https")?"https":"http", "UTF-8");

            sbLog.append("\nResult :: " + strResultData);
            sbLog.append("\nEndTime :: " + DateTime.getInstance().getDate("YYYY-MM-DD HH24:MI:SS")+"\n");

            log(sbLog.toString());
            sbLog.setLength(0);

            outputData = (JSONObject)JSONParser.parser(strResultData);

        }catch(Exception e){

            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));

            sbLog.append("\nException :: " + sw.toString());
            sbLog.append("\nEnd Time " + DateTime.getInstance().getDate("YYYY-MM-DD HH24:MI:SS"));

            log(sbLog.toString());
            sbLog.setLength(0);

            outputData.put("RSLT_CD", "C999");
            outputData.put("RSLT_MSG", "처리중 오류가 발생하였습니다.");
        }
        return outputData;
    }

    private static void log(String str){
        PushApiMgnt PushApiMgntapi = new PushApiMgnt();
        BizLogUtil.debug(PushApiMgntapi, str);
    }

}
