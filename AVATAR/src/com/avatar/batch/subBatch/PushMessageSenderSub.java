package com.avatar.batch.subBatch;

import jex.JexContext;
import jex.data.JexData;
import jex.data.JexDataList;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.json.JSONArray;
import jex.json.JSONObject;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.simplebatch.AbstractSimpleBatchTask;
import jex.util.DomainUtil;
import jex.util.biz.JexCommonUtil;

import java.net.URLEncoder;
import java.util.HashMap;

import com.avatar.api.mgnt.PushApiMgnt;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.CommonErrorHandler;

/**
 * 배치 > 시스템 > 푸시 > 푸시 발송 Sub
 *
 */
public class PushMessageSenderSub extends AbstractSimpleBatchTask {

    private String sUseInttId = "";
    private HashMap badgInfo = new HashMap(); //뱃지정보 (key: 이용기관ID, value:뱃지건수)
    
    @Override
    public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {

        this.sUseInttId = input.getString("USE_INTT_ID");

        BizLogUtil.debug(this, this.sUseInttId, "start ------------- ");

        JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContext.getContext().getCommonUtil();

        try {

        	// 이전뱃지건수 조회
            this.getBadgCnt(idoCon, util);
            
            // 푸시 발송리스트 조회
            JexData idoIn1 = util.createIDOData("PUSH_DEVI_LDGR_R001");
            idoIn1.put("USE_INTT_ID", this.sUseInttId);
            JexDataList<JexData> idoOutList = idoCon.executeList(idoIn1);
            if (DomainUtil.isError(idoOutList))
                CommonErrorHandler.comHandler(idoOutList);

            BizLogUtil.debug(this, this.sUseInttId, "푸시 발송 정보 : "+idoOutList);
            
            // 총 건수 구하기(순전히 로깅을 위해)
            int iTotCnt = 0;

            String display_message = "" ; // 푸시 메시지          (256)
            String relation_key    = "" ; // 연계키                 (100)
            String control_cd      = "" ; // 정의된 제어코드    (10 )
            String control_message = "" ; // 정의된 제어코드    (10 )
            String app_id 		   = "" ; // 앱아이디
            String page_url        = "" ; // 페이지URL
            String voice_msg       = "" ; // 보이스 메시지
            String result_cd       = "" ;
            String result_msg      = "" ;
            
            for(JexData idoOut : idoOutList) {
            	
            	BizLogUtil.info(this, this.sUseInttId, "JexData : "+ idoOut);
            	relation_key     = idoOut.getString("USE_INTT_ID");
                
                // 제로페이매출브리핑
                if("002".equals(idoOut.getString("NOTI_GB"))) {
                	control_cd = "ZSN001";
                	// 제로페이매출브리핑 URL
                	//page_url = "ques_comm_01.act?INTE_INFO="+URLEncoder.encode("{'recog_txt':'','recog_data':{'Intent':'ZSN001','appInfo':{}}}","UTF-8");
                	//page_url = "ques_comm_01.act?INTE_INFO={'recog_txt':'','recog_data':{'Intent':'ZSN001','appInfo':{}}}";
                	display_message  = "제로페이 매출 브리핑이 도착했어요!";
                	voice_msg = "제로페이 매출 브리핑이 도착했어요";
                	app_id = "ZEROPAY";
                } 
                // 카드매출브리핑
                else if("003".equals(idoOut.getString("NOTI_GB"))) {
                	control_cd = "ZSC001";
                	// 카드매출브리핑 URL
                	//page_url = "ques_comm_01.act?INTE_INFO="+URLEncoder.encode("{'recog_txt':'','recog_data':{'Intent':'ZSC001','appInfo':{}}}","UTF-8");
                	//page_url = "ques_comm_01.act?INTE_INFO={'recog_txt':'','recog_data':{'Intent':'ZSC001','appInfo':{}}}";
                	display_message  = "카드 매출 브리핑이 도착했어요!";
                	voice_msg = "카드 매출 브리핑이 도착했어요";
                	app_id = "AVATAR";
                }
                page_url = "push_0000_01.act?INTENT="+control_cd;
                //control_message  = idoOut.getString("NOTI_GB") + "|Y|"+ page_url;
                control_message  = idoOut.getString("NOTI_GB") + "|"+voice_msg+"|"+ page_url+"|"+app_id;
                
                String badg_key = idoOut.getString("USE_INTT_ID");
                String badg_cnt = "1";
                if(badgInfo.containsKey(badg_key)) {
                	badg_cnt = String.valueOf( Integer.parseInt((String)badgInfo.get(badg_key)) + 1 );
                    badgInfo.put(badg_key, badg_cnt);
                    this.updateBadgCnt(idoCon, util, badg_cnt);
                }
                
                // 푸쉬 발송
                BizLogUtil.info(this, this.sUseInttId, "display_message : "+display_message);
                BizLogUtil.info(this, this.sUseInttId, "relation_key : "   +relation_key);
                BizLogUtil.info(this, this.sUseInttId, "control_cd : "     +control_cd);
                BizLogUtil.info(this, this.sUseInttId, "control_message : "+control_message);
                BizLogUtil.info(this, this.sUseInttId, "badg_cnt : "       +badg_cnt);
                
                JSONObject rtnObj = PushApiMgnt.svc_MS0001(display_message, relation_key, control_cd, control_message, badg_cnt);
                
                BizLogUtil.info(this, this.sUseInttId, "rtnObj : "+rtnObj);
                JSONObject res_data = (JSONObject)((JSONArray)rtnObj.get("_tran_res_data")).get(0);
                BizLogUtil.info(this, this.sUseInttId, "res_data : "+res_data);
                
                if((res_data.get("_result")==null) || (((String)res_data.get("_result")).equals(""))){
                    result_cd = "9";
                    result_msg = "발송실패";
                    if((res_data.get("_error_cd")!=null) || (!((String)res_data.get("_error_cd")).equals(""))){
                    	result_cd = res_data.getString("_error_cd");
                    	result_msg = res_data.getString("_error_msg");
                    }
                } else {
                    result_cd = "0000";
                    result_msg = "성공";
                }
                
                BizLogUtil.info(this, this.sUseInttId, "result_cd : "   +result_cd);
                BizLogUtil.info(this, this.sUseInttId, "idoOut : "      +idoOut);

                // 푸시발송 결과 이력
                this.insertPushResult(idoCon, util, idoOut.getString("NOTI_GB"), display_message, result_cd, result_msg);
                
                iTotCnt++;
            }
            BizLogUtil.info(this, this.sUseInttId, "푸쉬발송 대상 건수 : "+String.valueOf(iTotCnt));

        } catch(Throwable e) {
            BizLogUtil.error(this, "execute", e);
        }

        return null;
    }

    /**
     * <pre>
     * 푸시발송 결과 이력 등록
     * </pre>
     * @param idoCon
     * @param util
     * @param noti_gb
     * @param push_msg
     * @param error_cd
     * @param error_msg
     * @throws JexException
     * @throws JexBIZException
     */
    private void insertPushResult(JexConnection idoCon, JexCommonUtil util, String noti_gb, String push_msg, String error_cd, String error_msg)
            throws JexException, JexBIZException{

        JexData idoIn1 = util.createIDOData("PUSH_SEND_HIS_C001");
        idoIn1.put("USE_INTT_ID", this.sUseInttId);
        idoIn1.put("NOTI_GB", noti_gb);
        idoIn1.put("PUSH_MSG", push_msg);
        idoIn1.put("ERROR_CD", error_cd);
        idoIn1.put("ERROR_MSG", error_msg);
        JexData idoOut1 = idoCon.execute(idoIn1);

        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut1))
            CommonErrorHandler.comHandler(idoOut1);
    }
    
    /**
     * <pre>
     * 뱃지건수 조회
     * </pre>
     * @param idoCon
     * @param util
     * @throws JexException
     * @throws JexBIZException
     */
    private void getBadgCnt(JexConnection idoCon, JexCommonUtil util)
            throws JexException, JexBIZException{

        JexData idoIn1 = util.createIDOData("CUST_LDGR_R039");
        idoIn1.put("USE_INTT_ID", this.sUseInttId);
        JexDataList<JexData> idoOutList = idoCon.executeList(idoIn1);

        // 도메인 에러 검증
        if (DomainUtil.isError(idoOutList))
            CommonErrorHandler.comHandler(idoOutList);

        while(idoOutList.next()){
            JexData idoOut = idoOutList.get();
            badgInfo.put(this.sUseInttId, idoOut.getString("BADG_CNT"));
        }
    }

    /**
     * <pre>
     * 뱃지건수 업데이트
     * </pre>
     * @param idoCon
     * @param util
     * @param BadgCnt 뱃지건수
     * @throws JexException
     * @throws JexBIZException
     */
    private void updateBadgCnt(JexConnection idoCon, JexCommonUtil util, String badgCnt)
            throws JexException, JexBIZException{

        JexData idoIn1 = util.createIDOData("CUST_LDGR_U008");
        idoIn1.put("USE_INTT_ID", this.sUseInttId);
        idoIn1.put("BADG_CNT"   , badgCnt);
        JexData idoOut1 = idoCon.execute(idoIn1);

        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut1))
            CommonErrorHandler.comHandler(idoOut1);
    }


}
