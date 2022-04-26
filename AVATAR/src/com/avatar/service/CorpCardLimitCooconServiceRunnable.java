package com.avatar.service;

import jex.JexContext;
import jex.data.JexData;
import jex.data.JexDataList;
import jex.data.impl.JexDataRecordList;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.exception.JexTransactionRollbackException;
import jex.json.JSONArray;
import jex.json.JSONObject;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.util.DomainUtil;
import jex.util.StringUtil;
import jex.util.biz.JexCommonUtil;
import com.avatar.api.mgnt.CooconApi;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.CommUtil;
import com.avatar.comm.SvcDateUtil;

/**
 * 법인카드 한도 실시간 조회 - Runnable 객체
 *
 * @author webcash.co.kr
 *
 */
public class CorpCardLimitCooconServiceRunnable implements Runnable {

	private String _use_intt_id;
	private String _scqkey;
	private String _bank_cd;
	private String _web_id;
	private String _web_pwd;
	private String _card_no;
	private String _pay_yn;

	public CorpCardLimitCooconServiceRunnable(JSONObject cardInfo) {

		_use_intt_id = cardInfo.getString("USE_INTT_ID");
		_scqkey 	 = cardInfo.getString("SCQKEY");
		_bank_cd     = cardInfo.getString("BANK_CD");
		_web_id      = cardInfo.getString("WEB_ID");
		_web_pwd     = cardInfo.getString("WEB_PWD");
		_card_no     = cardInfo.getString("CARD_NO");
		_pay_yn      = cardInfo.getString("PAY_YN");
	}

	@Override
	public void run() {

		BizLogUtil.info(this, _use_intt_id,"Thread ["+Thread.currentThread().getName()+"] Start");

        String coo_bank_cd = "";

    	if("30000060".equals(_bank_cd) || "30000061".equals(_bank_cd) || "30000062".equals(_bank_cd) ||
                "30000063".equals(_bank_cd) || "30000064".equals(_bank_cd))
    	{
    		coo_bank_cd = "006";
    	}
    	else
    	{
    		coo_bank_cd = _bank_cd.substring(5);
    	}

    	try {
    		
    		// 비밀번호 복호화
    		_web_pwd = CommUtil.getDecrypt(_scqkey, _web_pwd);
        	
    		//쿠콘 API 호출 - 법인카드 한도내역 조회 - 실시간
    		JSONObject rsltData = CooconApi.getCorpCardMaxAmountHstr(coo_bank_cd, _web_id, _web_pwd, _card_no, "");
    		
        	String rsltCd = StringUtil.null2void(rsltData.getString("RESULT_CD"));
        	String rsltMsg = StringUtil.null2void(rsltData.getString("RESULT_MG"));

        	if ("".equals(rsltCd)) {
        		rsltCd = StringUtil.null2void(rsltData.getString("ERRCODE"));
        		rsltMsg = StringUtil.null2void(rsltData.getString("ERRMSG"));
        	}

        	//최종조회일자
    		String lim_his_lst_dtm = SvcDateUtil.getInstance().getDate() + SvcDateUtil.getShortTimeString();
    		
        	if("00000000".equals(rsltCd)){
        	
    			rsltCd = "0000";
    			
            	String amount_limit = rsltData.getString("AMOUNT_LIMIT"); 		// 한도금액
    			String amount_payment = rsltData.getString("AMOUNT_PAYMENT");  	// 이용금액
    			String amount_balance = rsltData.getString("AMOUNT_BALANCE"); 	// 잔여한도
            	
    			if(amount_payment.equals("")) {
    				amount_payment = (Integer.parseInt(amount_limit) - Integer.parseInt(amount_balance))+"";
    			}
    			// 법인카드 한도 변경
    			updateCardLimit(rsltCd, rsltMsg, lim_his_lst_dtm, amount_limit, amount_payment, amount_balance);
            	
        	}
        	
		} catch (Exception e) {
			// 쓰레드 비정상 종료
			BizLogUtil.error(this, _use_intt_id, e, "Thread ["+Thread.currentThread().getName()+"]");
		}
	}


	/**
	 * <pre>
	 * 법인카드 한도내역 변경
	 * </pre>
	 * @param lim_his_lst_stts
	 * @param lim_his_lst_msg
	 * @param lim_his_lst_dtm
	 * @param amount_limit
	 * @param amount_payment
	 * @param amount_balance
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void updateCardLimit(String lim_his_lst_stts, String lim_his_lst_msg, String lim_his_lst_dtm, 
			String amount_limit, String amount_payment, String amount_balance) throws JexException, JexBIZException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContext.getContext().getCommonUtil();

        JexData idoIn1 = util.createIDOData("CARD_INFM_U011");
        
        idoIn1.put("USE_INTT_ID"     	, _use_intt_id);
        idoIn1.put("CARD_NO"         	, _card_no);
        idoIn1.put("RT_LIM_HIS_LST_DTM" , lim_his_lst_dtm);
        idoIn1.put("LIM_HIS_LST_STTS"	, lim_his_lst_stts);
        idoIn1.put("LIM_HIS_LST_MSG" 	, lim_his_lst_msg);
        idoIn1.put("LIM_AMT" 			, amount_limit);
        idoIn1.put("USE_AMT" 			, amount_payment);
        idoIn1.put("RMND_LIM" 			, amount_balance);
        
        JexData idoOut1 = idoCon.execute(idoIn1);

        if (DomainUtil.isError(idoOut1))
        {
            BizLogUtil.error(this, "Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
            BizLogUtil.error(this, "Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
        }
	}

}
