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
import com.avatar.comm.SvcDateUtil;

/**
 * 카드매출 입금내역 실시간 조회 - Runnable 객체
 *
 * @author webcash.co.kr
 *
 */
public class CrefiaDpstCooconServiceRunnable implements Runnable {

	private String _use_intt_id;
	private String _web_id;
	private String _web_pwd;
	private String _start_date;
	private String _end_date;
	private String _branch_name;

	public CrefiaDpstCooconServiceRunnable(JexData evdcInfo, String start_date, String end_date) {

		_use_intt_id = evdcInfo.getString("USE_INTT_ID");
		_web_id      = evdcInfo.getString("WEB_ID");
		_web_pwd     = evdcInfo.getString("WEB_PWD");
		_start_date  = start_date;
		_end_date    = end_date;
		_branch_name = "";

		//웹케시일 경우에만 가맹점그룹명 입력
		if("webcash0".equals(_web_id)) {
			_branch_name = "웹케시(주)";
		} else if ("webcash".equals(_web_id)) {
			_branch_name = "웹케시1";
		}
	}

	@Override
	public void run() {

		BizLogUtil.info(this, _use_intt_id,"Thread ["+Thread.currentThread().getName()+"] Start");

		try {
			//쿠콘 API 호출 - 여신금융협회 가맹점 매출내역 통합조회 - 매출입금내역, 실시간
			JSONObject rsltData = CooconApi.getCardSalesDpstHstr(_web_id, _web_pwd, _start_date, _end_date, _branch_name);

			String rsltCd = StringUtil.null2void(rsltData.getString("RESULT_CD"));
	    	String rsltMsg = StringUtil.null2void(rsltData.getString("RESULT_MG"));

	    	//최종조회일자
			String his_lst_dtm = SvcDateUtil.getInstance().getDate()+"000000";

	        if(!"00000000".equals(rsltCd)){

	        	//오류인 경우 최종조회일자를 조회시작일자로 처리(재조회 가능하도록)
	        	his_lst_dtm = "";

				//42110000 : 조회된 내용이 없습니다. : 은행 사이트에 거래 결과가 없음.(정상거래)
				//최종조회일자일 조회종료일로 처리(정상일 때와 동일하게)
				if("42110000".equals(rsltCd)) {
					rsltCd = "0000";
					his_lst_dtm = SvcDateUtil.getInstance().getDate()+"000000";
				}

				//최종조회일시 변경
				updEvdcSeupInfm(his_lst_dtm, rsltCd, rsltMsg);
	        }
	        else
	        {
	        	rsltCd = "0000";

	    		JexConnection idoCon = JexConnectionManager.createIDOConnection();
	    		idoCon.beginTransaction();

	    		try {
	        		deleteRcvHisData(idoCon);

	        		//저장내역 등록 정보
	        		JexDataList<JexData> insertData = new JexDataRecordList<JexData>();

	        		JSONArray arr_resp_data =  rsltData.getJSONArray("RESP_DATA");
	        		for(Object row : arr_resp_data)
	        		{
	        			JSONObject resp_data = (JSONObject)row;

	        			JSONArray arr_dtl_resp_data =  resp_data.getJSONArray("DETAIL_RESP_DATA");

	        			for(int j=0 ; j < arr_dtl_resp_data.size() ; j++)
        				{
        					JSONObject dtl_resp_data = arr_dtl_resp_data.getJSONObject(j);

        					insertData.add(insertRcvHisData(dtl_resp_data));
        				}
	        		}

	        		// 등록
	    			JexDataList<JexData> idoOutBatch =  idoCon.executeBatch(insertData);
	    			if (DomainUtil.isError(idoOutBatch)) throw new JexTransactionRollbackException(idoOutBatch);

	    			//최종조회일시 변경 - 삭제 및 저장 시 오류가 나면 최종조회일시를 업데이트 하지 않기 위해 이곳에서 호출한다.
	    			updEvdcSeupInfm(his_lst_dtm, rsltCd, rsltMsg);

	        	} catch (Exception e) {
					BizLogUtil.error(this, _use_intt_id, e, "Thread ["+Thread.currentThread().getName()+"]");
				}

	    		idoCon.endTransaction();
	        }

		} catch (Exception e) {
			// 쓰레드 비정상 종료
			BizLogUtil.error(this, _use_intt_id, e, "Thread ["+Thread.currentThread().getName()+"]");
		}
	}

	/**
	 * <pre>
	 * 카드매출입금데이터 등록
	 * </pre>
	 * @param hstrData
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JexData insertRcvHisData(JSONObject hstrData) throws JexException, JexBIZException
	{
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("CARD_SEL_RCV_HSTR_C001");
		
		idoIn1.put("USE_INTT_ID"  	, _use_intt_id);
		idoIn1.put("CARD_CORP_NM" 	, hstrData.getString("CARD_COMPANY").trim());			// 카드사명
		idoIn1.put("RCV_DT"      	, hstrData.getString("DATE_RECIEVE_DETAIL").trim());	// 입금일자
		idoIn1.put("MEST_NO" 		, hstrData.getString("DATE_COMPANY_NUM").trim());		// 가맹점번호
		idoIn1.put("SETL_BANK_CD"   , hstrData.getString("BANK").trim());					// 결제은행
		idoIn1.put("SETL_ACCT_NO"   , hstrData.getString("ACCOUNT").trim());				// 결제계좌
		idoIn1.put("SALE_CNT"       , hstrData.getString("TRADE_COUNT_DETAIL").trim());		// 매출건수			// 거래구분
		idoIn1.put("SALE_AMT"    	, hstrData.getString("TRADE_AMOUNT").trim());			// 매출금액
		idoIn1.put("SUSP_AMT"      	, hstrData.getString("POSTPONE_AMOUNT").trim());		// 보류금액
		idoIn1.put("ETC_AMT"		, hstrData.getString("RECIEVE_ETC").trim());			// 기타금액
		idoIn1.put("RCV_AMT" 		, hstrData.getString("REAL_RECIEVE").trim());			// 실입금액
		idoIn1.put("RCV_YN" 		, "");
		idoIn1.put("REGR_ID"  		, "SYSTEM");
		idoIn1.put("REG_DTM"      	, SvcDateUtil.getInstance().getDate("YYYYMMDDHH24miss"));
		
		return idoIn1;
	}

	/**
	 * <pre>
	 * 카드매출입금내역최종조회결과업데이트
	 * </pre>
	 * @param last_dtm
	 * @param stts
	 * @param msg
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void updEvdcSeupInfm(String last_dtm, String stts, String msg)
			throws JexException, JexBIZException{

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContext.getContext().getCommonUtil();


        msg = StringUtil.null2void(msg);
        if(msg.getBytes().length > 255){
            msg = StringUtil.byteSubString(msg, 0, 255);
        }

        JexData idoIn1 = util.createIDOData("EVDC_INFM_U014");
		//idoIn1.put("HIS_LST_DTM", last_dt);
        idoIn1.put("RT_HIS_LST_DTM", last_dtm);
		idoIn1.put("HIS_LST_STTS", stts);
		idoIn1.put("HIS_LST_MSG", msg);
		idoIn1.put("USE_INTT_ID", _use_intt_id);
		idoIn1.put("EVDC_DIV_CD", "10");
		JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);
		
        if (DomainUtil.isError(idoOut1))
        {
            BizLogUtil.error(this, "Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
            BizLogUtil.error(this, "Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
        }

    }

	/**
	 * <pre>
	 * 카드매출입금데이터 삭제
	 * </pre>
	 * @param idoCon
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void deleteRcvHisData(JexConnection idoCon)
			throws JexException, JexBIZException {

		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("CARD_SEL_RCV_HSTR_D002");
        
        idoIn1.put("USE_INTT_ID", _use_intt_id);
        idoIn1.put("START_DT"   , _start_date);
        idoIn1.put("END_DT"     , _end_date);
        JexData idoOut1 = idoCon.execute(idoIn1);

        if (DomainUtil.isError(idoOut1))
            throw new JexTransactionRollbackException(idoOut1);
	}
}
