package com.avatar.service;

import jex.JexContext;
import jex.data.JexData;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.json.JSONObject;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.util.DomainUtil;
import jex.util.biz.JexCommonUtil;
import com.avatar.api.mgnt.CooconApi;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.CommonErrorHandler;
import com.avatar.comm.SvcDateUtil;

/**
 * 계좌 잔액 실시간 조회 - Runnable 객체
 *
 * @author webcash.co.kr
 *
 */
public class AcctAmtCooconServiceRunnable implements Runnable {

	private String _use_intt_id;
	private String _bsnn_no;
	private String _org_cd;
	private String _ib_type;
	private String _acct_no;
	private String _fnnc_unq_no;
	private String _acct_pw;
	private String _cert_name;
	private String _web_id;
	private String _web_pwd;
	private String _banking_type;

	public AcctAmtCooconServiceRunnable(JSONObject acctInfo) {

		_use_intt_id 	= acctInfo.getString("USE_INTT_ID");
		_bsnn_no     	= acctInfo.getString("BSNN_NO");
		_org_cd      	= acctInfo.getString("BANK_CD");
		_ib_type     	= acctInfo.getString("CERT_DSNC");
		_acct_no     	= acctInfo.getString("FNNC_INFM_NO");
		_fnnc_unq_no 	= acctInfo.getString("FNNC_UNQ_NO");
		_acct_pw     	= "";
		_cert_name   	= acctInfo.getString("CERT_NM");
		_web_id      	= acctInfo.getString("WEB_ID");
		_web_pwd     	= acctInfo.getString("WEB_PWD");
		_banking_type   = acctInfo.getString("BANKING_TYPE");
	}

	@Override
	public void run() {

		BizLogUtil.info(this, _use_intt_id,"Thread ["+Thread.currentThread().getName()+"] Start");

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContext.getContext().getCommonUtil();

        try {
        	//쿠콘 API 호출 - 계좌 잔액조회 - 실시간, 등록된 인증서명
        	JSONObject rsltData = CooconApi.getAcctAmountWithCertName(_bsnn_no, _org_cd, _ib_type, 
        			_web_id, _web_pwd, _acct_no, _acct_pw, "", 
        			_acct_pw, _banking_type, "", _cert_name);
        	
        	//조회결과
        	String rsltCd  = rsltData.getString("ERRCODE");
    		String rsltMsg = rsltData.getString("ERRMSG");

    		//최종조회일자
    		String bal_lst_dtm = SvcDateUtil.getInstance().getDate() + SvcDateUtil.getShortTimeString();
    		
    		if("00000000".equals(rsltCd)){
    			rsltCd = "0000";

    			String amount_balance = rsltData.getString("AMOUNT_BALANCE"); 	// 계좌잔액
    			String amount_drawable = rsltData.getString("AMOUNT_DRAWABLE"); // 출금가능액
        		
        		// 잔액 변경
        		if(!"".equals(amount_balance) && !"".equals(amount_drawable)) {
        		    updateAcctCurAmt(idoCon, util, rsltCd, rsltMsg, bal_lst_dtm, amount_balance, amount_drawable);
        		}
    		}

		} catch (Exception e) {
			// 쓰레드 비정상 종료
			BizLogUtil.error(this, _use_intt_id, e, "Thread ["+Thread.currentThread().getName()+"]");
		}
	}

	/**
	 * 잔액 변경
	 * @param idoCon
	 * @param util
	 * @param errcode
	 * @param errmsg
	 * @param bal_lst_dtm
	 * @param amount_balance 계좌잔액
	 * @param amount_drawable 출금가능액
	 * @throws JexBIZException
	 * @throws JexException
	 */
	private void updateAcctCurAmt(JexConnection idoCon, JexCommonUtil util, String errcode, String errmsg
			, String bal_lst_dtm, String amount_balance, String amount_drawable)
			throws JexBIZException, JexException {

		JexData idoIn1 = util.createIDOData("ACCT_INFM_U015");
		idoIn1.put("BAL_LST_STTS"	, errcode);
        idoIn1.put("BAL_LST_MSG" 	, errmsg);
        idoIn1.put("RT_BAL_LST_DTM" , bal_lst_dtm);
		idoIn1.put("BAL"    		, amount_balance);
		idoIn1.put("REAL_AMT"    	, amount_drawable);
		idoIn1.put("USE_INTT_ID"	, _use_intt_id);
		idoIn1.put("FNNC_UNQ_NO"	, _fnnc_unq_no);
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) CommonErrorHandler.comHandler(idoOut1);
	}

}
