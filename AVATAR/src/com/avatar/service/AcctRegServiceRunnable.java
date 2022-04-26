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
import jex.util.date.DateTime;
import com.avatar.api.mgnt.CooconApi;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.CommUtil;
//import com.avatar.comm.ExtnTrnsHis;

/**
 * 인증서 정보를 이용한 계좌 등록 - Runnable 객체
 *
 * @author webcash.co.kr
 *
 */
public class AcctRegServiceRunnable implements Runnable {

	private String _use_intt_id;
	private String _task_no;
	private String _org_cd;
	private String _ib_type;
	private String _bank_gb;
	private String _cert_name;
	private String _cert_org;
	private String _cert_date;
	private String _cert_pwd;
	private String _cert_folder;
	private String _cert_data;

	public AcctRegServiceRunnable(String task_no, String org_cd, String ib_type, String bank_gb, JSONObject regInfo) {

		_use_intt_id = regInfo.getString("USE_INTT_ID");
		_task_no     = task_no;
		_org_cd      = org_cd;
		_ib_type     = ib_type;
		_bank_gb     = bank_gb;
		_cert_name   = regInfo.getString("CERT_NAME");
		_cert_org    = regInfo.getString("CERT_ORG");
		_cert_date   = regInfo.getString("CERT_DATE");
		_cert_pwd    = regInfo.getString("CERT_PWD");
		_cert_folder = regInfo.getString("CERT_FOLDER");
		_cert_data   = regInfo.getString("CERT_DATA");
	}

	@Override
	public void run() {

		String st_tm = DateTime.getInstance().getDate("hhmiss");
		BizLogUtil.info(this, _use_intt_id,"Thread ["+Thread.currentThread().getName()+"] Start");

		JexConnection idoCon = JexConnectionManager.createIDOConnection();

        try {
        	//쿠콘 API 호출 - 전계좌 조회 - 인증서정보
        	JSONObject rsltData = CooconApi.getAcctListWithCertInfo(_org_cd, _ib_type, _cert_name, _cert_org, _cert_date, _cert_pwd, _cert_folder, _cert_data, "1");

        	//조회결과
        	String rsltCd  = rsltData.getString("RESULT_CD");
    		String rsltMsg = rsltData.getString("RESULT_MG");

        	// 호출 이력 등록
//    		ExtnTrnsHis.insert(_use_intt_id, "C", "0201", rsltCd, rsltMsg);

    		if("00000000".equals(rsltCd) ||  // 정상
               "42120011".equals(rsltCd) ||  // 수시입출금과 정기예적금 계좌가 구분 불가능합니다.
               "42120101".equals(rsltCd) ||  // 수시입출금과 대출금 계좌가 구분 불가능합니다.
               "42120110".equals(rsltCd) ||  // 정기예적금과 대출금 계좌가 구분 불가능합니다.
               "42120111".equals(rsltCd)){   // 수시입출금, 정기예적금, 대출금 계좌가 구분 불가능합니다.

    			rsltCd = "0000";

    			idoCon.beginTransaction();

    			try {
    				// 조회계정 상세정보 등록
            		JexDataList<JexData> insertData = new JexDataRecordList<JexData>();
        			JSONArray arr_resp_data = rsltData.getJSONArray("RESP_DATA");
        			for(Object row : arr_resp_data)
            		{
            			JSONObject resp_data = (JSONObject)row;
            			insertData.add(insertAcctInqDtls(resp_data));
            		}
        			JexDataList<JexData> idoOutBatch =  idoCon.executeBatch(insertData);
        			if (DomainUtil.isError(idoOutBatch)) throw new JexTransactionRollbackException(idoOutBatch);

				} catch (Exception e) {
					BizLogUtil.error(this, _use_intt_id, e, "Thread ["+Thread.currentThread().getName()+"]");
				}

    			idoCon.endTransaction();
    		}

    		// 조회계정의 상태 변경
			updateAcctInqPtcl(idoCon, rsltCd, rsltMsg);

		} catch (Exception e) {
			// 쓰레드 비정상 종료
			BizLogUtil.error(this, _use_intt_id, e, "Thread ["+Thread.currentThread().getName()+"]");
		}

        String en_tm = DateTime.getInstance().getDate("hhmiss");
        BizLogUtil.info(this, _use_intt_id,"Thread ["+Thread.currentThread().getName()+"] End "+DateTime.getInstance().getTimeBetween(st_tm, en_tm)+"초");
	}

	/**
	 * <pre>
	 * 조회계정 상세정보 등록
	 * </pre>
	 * @param resp_data
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JexData insertAcctInqDtls(JSONObject resp_data) throws JexException, JexBIZException
	{
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("ACCT_INQ_DTLS_C001");

//		idoIn1.put("PTL_ID"     , CommUtil.getPtlId());
		idoIn1.put("USE_INTT_ID", _use_intt_id);
		idoIn1.put("TASK_NO"    , _task_no);
		idoIn1.put("TASK_GB"    , _bank_gb);													// 업무구분(1:개인계좌, 2:기업계좌, 3:개인카드, 4:기업카드, 5:홈택스)
		idoIn1.put("BANK_CD"    , _org_cd);
		idoIn1.put("ACCT_NO"    , StringUtil.null2void(resp_data.getString("ACCOUNT_NO")));		// 계좌번호
		idoIn1.put("CUR_AMT"    , StringUtil.null2void(resp_data.getString("AMOUNT_BALANCE")));	// 현재잔액
		idoIn1.put("RMRK"       , StringUtil.null2void(resp_data.getString("ACCOUNT_CLASS")));	// 계좌별칭

		return idoIn1;
	}

	/**
	 * <pre>
	 * 조회계정의 상태 변경
	 * </pre>
	 * @param idoCon
	 * @param rslt_cd
	 * @param rslt_msg
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void updateAcctInqPtcl(JexConnection idoCon, String rslt_cd, String rslt_msg) throws JexException, JexBIZException
	{
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("ACCT_INQ_PTCL_U001");

//		idoIn1.put("PTL_ID"       , CommUtil.getPtlId());
		idoIn1.put("USE_INTT_ID"  , _use_intt_id);
		idoIn1.put("TASK_NO"      , _task_no);
		idoIn1.put("TASK_GB"      , _bank_gb);		// 업무구분(1:개인계좌, 2:기업계좌, 3:개인카드, 4:기업카드, 5:홈택스)
		idoIn1.put("BANK_CD"      , _org_cd);
		idoIn1.put("PROC_RSLT_CD" , rslt_cd);
		idoIn1.put("PROC_RSLT_CTT", rslt_msg);

		JexData idoOut1 =  idoCon.execute(idoIn1);
		if (DomainUtil.isError(idoOut1)) throw new JexBIZException(idoOut1);
	}
}
