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
import jex.util.DomainUtil;
import jex.util.StringUtil;
import jex.util.biz.JexCommonUtil;
import com.avatar.api.mgnt.CooconApiMgnt;
import com.avatar.batch.comm.BatchServiceBiz;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.SvcDateUtil;
import com.avatar.batch.vo.BatchExecVO;

/**
 * 매시간 법인카드 카드한도조회 서브
 * @author won
 *
 */
public class CorpCardLimitRealTimeCollectorSub extends BatchServiceBiz {

	private final static String job_id = "GET_RT_CORP_CARD_LIMT";
	BatchExecVO batchvo = new BatchExecVO();

	@Override
	public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {
	
		BizLogUtil.debug(this, "execute", "Input :: " + input.toJSONString());

		String use_intt_id = input.getString("USE_INTT_ID");

		batchvo.setJob_id(job_id);
		batchvo.setUse_intt_id(use_intt_id);

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

        /**
		 * =======================================================
		 * 기관에 등록되어 있는 법인 카드 조회
		 * =======================================================
		 */
        
        JexDataList<JexData> cardList = getCardList(idoCon, util, use_intt_id);

        String rsltDt = SvcDateUtil.getInstance().getDate("yyyymmddhh24miss");

        String comp_idno = "";
        String coo_bank_cd = "";
        String bank_cd = "";
        for(JexData card : cardList)
        {
        	comp_idno = card.getString("BIZ_NO");
        	bank_cd = card.getString("BANK_CD");
        	coo_bank_cd = card.getString("BANK_CD").substring(5);
            if( "060".equals(coo_bank_cd) || "061".equals(coo_bank_cd) || "062".equals(coo_bank_cd) ||
                    "063".equals(coo_bank_cd) || "064".equals(coo_bank_cd)){ // bc 카드일경우 // 기업,대구, 부산, 경남, SC
            	coo_bank_cd = "006";
            }
            
        	JSONObject resData =  CooconApiMgnt.data_wapi_0111(comp_idno, coo_bank_cd, card.getString("CARD_NO"));

        	//쿠콘API 오류인 경우
    		if(!"00000000".equals(resData.get("ERRCODE")) && !"42110000".equals(resData.get("ERRCODE"))){
                //한도내역 최종조회일시, 상태 업데이트
    			updErrCardInfm(use_intt_id, bank_cd, card.getString("CARD_NO"), (String)resData.get("ERRCODE"), (String)resData.get("ERRMSG"));
            	batchvo.setProc_stts(resData.getString("ERRCODE"));
    			batchvo.setProc_rslt_ctt(resData.getString("ERRMSG"));
    			batchvo.addErrCnt(1);
            } else {

	            String rsltCd = "0000";
	            String rsltMsg = "";
	
	            JSONArray resp_data = (JSONArray)resData.get("RESP_DATA");
	
	            JSONObject lastHstrData = new JSONObject();
	            for(Object resp : resp_data)
	            {
	            	JSONObject respData = (JSONObject)resp;
	
	            	rsltCd = respData.getString("DET_CODE"); //결과코드
	                rsltMsg = respData.getString("DET_MSG"); //결과메시지
	
	                batchvo.setProc_stts(rsltCd);
					batchvo.setProc_rslt_ctt(rsltMsg);
					
	                if("WERR0006".equals(rsltCd)){
	                	batchvo.addEtcCnt(1);
	                    rsltCd = "0000";
	                    updErrCardInfm(use_intt_id, bank_cd, card.getString("CARD_NO"), rsltCd, rsltMsg);
	                    break;
	                }
	                // 거래결과가 없습니다. : 카드사 사이트에 거래 결과가 없음.(정상거래)
	                else if("42110000".equals(rsltCd)){
	                	batchvo.addNorCnt(1);
	                    rsltCd = "0000";
	                    updErrCardInfm(use_intt_id, bank_cd, card.getString("CARD_NO"), rsltCd, rsltMsg);
	                    break;
	                }
	                // 오류인 경우
	                else if(!"00000000".equals(rsltCd)){
	                	batchvo.addErrCnt(1);
	                	updErrCardInfm(use_intt_id, bank_cd, card.getString("CARD_NO"), rsltCd, rsltMsg);
	                    break;
	                }
	
	                for(Object hstr : respData.getJSONArray("HSTR_DATA")){
	                	lastHstrData = (JSONObject)hstr;
	                }
	
					batchvo.addNorCnt(1);
					rsltCd = "0000";
					updCardInfm(use_intt_id, bank_cd, card.getString("CARD_NO"), rsltDt, rsltCd, rsltMsg, lastHstrData);
					
	            }
	
	            batchvo.setProc_stts(rsltCd);
	            batchvo.setProc_rslt_ctt(rsltMsg);
            }
        }

        batchvo.setTotl_cnt(batchvo.getNor_cnt() + batchvo.getEtc_cnt() + batchvo.getErr_cnt());
		batchvo.setJob_end_tm(SvcDateUtil.getShortTimeString());
		batchvo.EndBatch();
		batchExecLogInsert(batchvo);

		return null;
	}
	
	/**
	 * <pre>
	 * 조회대상 카드목록 조회
	 * </pre>
	 *
	 * @param idoCon
	 * @param util
	 * @param use_intt_id
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JexDataList<JexData> getCardList(JexConnection idoCon, JexCommonUtil util, String use_intt_id)
			throws JexException, JexBIZException{

		JexData idoIn1 = util.createIDOData("CARD_INFM_R003");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);

		if (DomainUtil.isError(idoOut1))
		{
		    BizLogUtil.error(this, "Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
		    BizLogUtil.error(this, "Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
            throw new JexBIZException(idoOut1);
		}

		return idoOut1;
	}

	/**
	 * <pre>
	 * 매시간 카드한도정보 수정
	 * </pre>
	 *
	 * @param idoCon
	 * @param util
	 * @param use_intt_id
	 * @param bank_cd
	 * @param card_no
	 * @param lst_ym
	 * @param stts
	 * @param msg
	 * @param hstrData
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void updCardInfm(String use_intt_id, String bank_cd, String card_no, String lst_ym, String stts, String msg, JSONObject hstrData){
        try{

        	JexConnection idoCon = JexConnectionManager.createIDOConnection();
            JexCommonUtil util = JexContext.getContext().getCommonUtil();

            msg = StringUtil.null2void(msg);
            if(msg.getBytes().length > 255){
                msg = StringUtil.byteSubString(msg, 0, 255);
            }

            String amount_limit = StringUtil.null2void(hstrData.getString("AMOUNT_LIMIT"),"0");
            String amount_payment = StringUtil.null2void(hstrData.getString("AMOUNT_PAYMENT"),"");
            String amount_balance = StringUtil.null2void(hstrData.getString("AMOUNT_BALANCE"),"0");
            
            if(amount_payment.equals("")) {
				amount_payment = (Integer.parseInt(amount_limit) - Integer.parseInt(amount_balance))+"";
			}
            
            JexData idoIn1 = util.createIDOData("CARD_INFM_U010");
            idoIn1.put("RT_LIM_HIS_LST_DTM", StringUtil.null2void(hstrData.getString("REG_DATETIME"),lst_ym));
            idoIn1.put("LIM_HIS_LST_STTS", stts);
            idoIn1.put("LIM_HIS_LST_MSG", msg);
            idoIn1.put("USE_INTT_ID", use_intt_id);
            idoIn1.put("BANK_CD", bank_cd);
            idoIn1.put("CARD_NO", card_no);
            idoIn1.put("LIM_AMT", amount_limit);
            idoIn1.put("USE_AMT", amount_payment);
            idoIn1.put("RMND_LIM", amount_balance);
            
            JexData idoOut1 = idoCon.execute(idoIn1);

            if (DomainUtil.isError(idoOut1))
            {
                BizLogUtil.error(this, "Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                BizLogUtil.error(this, "Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
            }
        } catch(Exception e){
            e.printStackTrace();
        }
    }
	
	/**
	 * <pre>
	 * 카드한도 최종정보 수정 
	 * </pre>
	 *
	 * @param idoCon
	 * @param util
	 * @param use_intt_id
	 * @param bank_cd
	 * @param card_no
	 * @param stts
	 * @param msg
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void updErrCardInfm(String use_intt_id, String bank_cd, String card_no, String stts, String msg){
        try{

        	JexConnection idoCon = JexConnectionManager.createIDOConnection();
            JexCommonUtil util = JexContext.getContext().getCommonUtil();

            msg = StringUtil.null2void(msg);
            if(msg.getBytes().length > 255){
                msg = StringUtil.byteSubString(msg, 0, 255);
            }
            
            JexData idoIn1 = util.createIDOData("CARD_INFM_U009");
            idoIn1.put("LIM_HIS_LST_STTS", stts);
            idoIn1.put("LIM_HIS_LST_MSG", msg);
            idoIn1.put("USE_INTT_ID", use_intt_id);
            idoIn1.put("BANK_CD", bank_cd);
            idoIn1.put("CARD_NO", card_no);
            JexData idoOut1 = idoCon.execute(idoIn1);

            if (DomainUtil.isError(idoOut1))
            {
                BizLogUtil.error(this, "Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                BizLogUtil.error(this, "Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
            }
        } catch(Exception e){
            e.printStackTrace();
        }
    }
	
}
