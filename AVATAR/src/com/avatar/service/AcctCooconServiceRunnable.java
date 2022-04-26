package com.avatar.service;

import java.sql.SQLException;

import jex.JexContext;
import jex.data.JexData;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.json.JSONArray;
import jex.json.JSONObject;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.util.DomainUtil;
import jex.util.biz.JexCommonUtil;
import com.avatar.api.mgnt.CooconApi;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.CommonErrorHandler;
import com.avatar.comm.SvcDateUtil;
import com.avatar.comm.SvcStringUtil;

/**
 * 계좌 거래내역 실시간 조회 - Runnable 객체
 *
 * @author webcash.co.kr
 *
 */
public class AcctCooconServiceRunnable implements Runnable {

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
	private String _start_date;
	private String _end_date;
	private String _pay_yn;

	public AcctCooconServiceRunnable(JSONObject acctInfo, String start_date, String end_date, String pay_yn) {

		_use_intt_id = acctInfo.getString("USE_INTT_ID");
		_bsnn_no     = acctInfo.getString("BSNN_NO");
		_org_cd      = acctInfo.getString("BANK_CD");
		_ib_type     = acctInfo.getString("CERT_DSNC");
		_acct_no     = acctInfo.getString("FNNC_INFM_NO");
		_fnnc_unq_no = acctInfo.getString("FNNC_UNQ_NO");
		_acct_pw     = "";
		_cert_name   = acctInfo.getString("CERT_NM");
		_web_id      = acctInfo.getString("WEB_ID");
		_web_pwd     = acctInfo.getString("WEB_PWD");
		_start_date  = start_date;
		_end_date    = end_date;
		_pay_yn    	 = pay_yn;
	}

	@Override
	public void run() {

		BizLogUtil.info(this, _use_intt_id,"Thread ["+Thread.currentThread().getName()+"] Start");

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContext.getContext().getCommonUtil();

        try {
        	//쿠콘 API 호출 - 계좌 거래내역조회 - 실시간, 등록된 인증서명
        	JSONObject rsltData = CooconApi.getAcctHstrWithCertName(_bsnn_no, _org_cd, _ib_type, _web_id, _web_pwd, _acct_no, _acct_pw, _cert_name, _start_date, _end_date);

        	//조회결과
        	String rsltCd  = rsltData.getString("ERRCODE");
    		String rsltMsg = rsltData.getString("ERRMSG");

    		//최종조회일자
    		String shis_lst_dtm = SvcDateUtil.getInstance().getDate()+"000000";
    		if(_pay_yn.equals("Y")) {
    			shis_lst_dtm = SvcDateUtil.getInstance().getDate() + SvcDateUtil.getShortTimeString();
    		}
    		String his_lst_dtm = shis_lst_dtm;
    		
    		if(!"00000000".equals(rsltCd)){

    			//오류인 경우 최종조회일자를 조회시작일자로 처리(재조회 가능하도록)
    			his_lst_dtm = "";

    			//42110000 : 조회된 내용이 없습니다. : 은행 사이트에 거래 결과가 없음.(정상거래)
    			//최종조회일자일 조회종료일로 처리(정상일 때와 동일하게)
    			if("42110000".equals(rsltCd)) {
    				rsltCd = "0000";
    				his_lst_dtm = shis_lst_dtm;
    			}

    		} else {
    			rsltCd = "0000";

    			String tranorder = rsltData.getString("TRANORDER"); //거래순서 (0:최신거래내역순,1:과거거래내역순)
        		JSONArray arr_resp_data = rsltData.getJSONArray("RESP_DATA");
        		JSONObject respData = null;

        		String cur_amt = "";
    			String be_trandate = "";
    			int trns_srno = 0;

    			//최신거래내역순
    			if("0".equals(tranorder))
    			{
    				for(int j=arr_resp_data.size()-1 ; j >= 0 ; j--)
    				{
    					respData = arr_resp_data.getJSONObject(j);

    					cur_amt  = respData.getString("AMOUNT_BALANCE");

    					if(be_trandate.equals(respData.getString("DATE_TRADE")))
    					{
    						trns_srno++;
    					}
    					else
    					{
    						trns_srno = 1;
    					}

    					// 계좌 거래내역 등록
    					insertHisData(idoCon, util, String.valueOf(trns_srno), respData);

    					// 거래 일자
    					be_trandate = respData.getString("DATE_TRADE");
    				}
    			}
    			//과거거래내역순
    			else {
    				for(int j=0 ; j < arr_resp_data.size() ; j++)
    				{
    					respData = arr_resp_data.getJSONObject(j);

    					cur_amt  = respData.getString("AMOUNT_BALANCE");

    					if(be_trandate.equals(respData.getString("DATE_TRADE")))
    					{
    						trns_srno++;
    					}
    					else
    					{
    						trns_srno = 1;
    					}

    					// 계좌 거래내역 등록
    					insertHisData(idoCon, util, String.valueOf(trns_srno), respData);

    					// 거래 일자
    					be_trandate = respData.getString("DATE_TRADE");
    				}
    			}

        		// 잔액 변경
        		if(!"".equals(cur_amt)) {
        		    updateAcctCurAmt(idoCon, util, cur_amt);
        		}
    		}

    		// 최종조회일시 변경
    		updateAcctHisLstAcct(idoCon, util, rsltCd, rsltMsg, his_lst_dtm);

		} catch (Exception e) {
			// 쓰레드 비정상 종료
			BizLogUtil.error(this, _use_intt_id, e, "Thread ["+Thread.currentThread().getName()+"]");
		}
	}

	/**
	 * <pre>
	 * 최종조회일시 변경
	 * </pre>
	 * @param idoCon
	 * @param util
	 * @param errcode
	 * @param errmsg
	 * @param his_lst_dtm
	 * @throws JexBIZException
	 * @throws JexException
	 */
	private void updateAcctHisLstAcct(JexConnection idoCon, JexCommonUtil util, String errcode, String errmsg, String his_lst_dtm)
			throws JexBIZException, JexException {

		JexData idoIn1 = util.createIDOData("ACCT_INFM_U009");
        idoIn1.put("HIS_LST_STTS", errcode);
        idoIn1.put("HIS_LST_MSG" , errmsg);
        //idoIn1.put("HIS_LST_DTM"  , his_lst_dt + SvcDateUtil.getShortTimeString());
        idoIn1.put("RT_HIS_LST_DTM"  , his_lst_dtm);
        idoIn1.put("USE_INTT_ID" , _use_intt_id);
        idoIn1.put("FNNC_UNQ_NO" , _fnnc_unq_no);
        JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) CommonErrorHandler.comHandler(idoOut1);
	}

	/**
	 * <pre>
	 * 계좌 거래내역 등록
	 * </pre>
	 * @param idoCon
	 * @param util
	 * @param trns_srno
	 * @param respData
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void insertHisData(JexConnection idoCon, JexCommonUtil util, String trns_srno, JSONObject respData)
    		throws JexException, JexBIZException {


    	JexData idoIn1 = util.createIDOData("ACCT_TRNS_HSTR_C001");
    	
    	idoIn1.put("USE_INTT_ID", _use_intt_id);
    	idoIn1.put("FNNC_UNQ_NO", _fnnc_unq_no);
    	idoIn1.put("TRNS_DT"    , respData.getString("DATE_TRADE"));
    	idoIn1.put("TRNS_SRNO"  , trns_srno);

    	String inot_dsnc = "";
    	String trans_amt = "";
    	// 출금 금액이 0이면 입금 정보
		if( "0".equals(SvcStringUtil.null2void(respData.getString("AMOUNT_PAYMENT"), "0")) )
		{
			inot_dsnc = "1";
			trans_amt = respData.getString("AMOUNT_RECEIPT");
		}
		else
		{
			inot_dsnc = "2";
			trans_amt = respData.getString("AMOUNT_PAYMENT");
		}
    	idoIn1.put("INOT_DSNC"  , inot_dsnc);
    	idoIn1.put("TRNS_AMT"   , trans_amt);
    	idoIn1.put("BAL_AMT"    , respData.getString("AMOUNT_BALANCE"));
    	idoIn1.put("TRNS_TIME"  , respData.getString("TIME_TRADE"));
    	idoIn1.put("SMR"        , respData.getString("AMOUNT_DESC_1"));
    	idoIn1.put("SMR2"       , respData.getString("AMOUNT_DESC_2"));
    	idoIn1.put("TRNS_MENZ"  , respData.getString("TRANSACTION_METHODD_1"));
    	idoIn1.put("TRNS_MENZ2" , respData.getString("TRANSACTION_METHODD_2"));
    	idoIn1.put("REGR_ID", "SYSTEM");
        JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1))
		{
			SQLException exce = (SQLException) DomainUtil.getErrorTrace(idoOut1);

			// 정상
			if(exce.getSQLState().equals("23505"))
			{
				BizLogUtil.debug(this, " 23505 : " + respData.toJSONString());
			}
			// 오류
			else
			{
				throw new JexBIZException(idoOut1);
			}
		}
    }

	/**
	 * 잔액 변경
	 * @param idoCon
	 * @param util
	 * @param cur_amt 잔액
	 * @throws JexBIZException
	 * @throws JexException
	 */
	private void updateAcctCurAmt(JexConnection idoCon, JexCommonUtil util, String cur_amt)
			throws JexBIZException, JexException {

		JexData idoIn1 = util.createIDOData("ACCT_INFM_U010");
		idoIn1.put("CUR_AMT"    , cur_amt);
		idoIn1.put("USE_INTT_ID", _use_intt_id);
		idoIn1.put("FNNC_UNQ_NO", _fnnc_unq_no);
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) CommonErrorHandler.comHandler(idoOut1);
	}

}
