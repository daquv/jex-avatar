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
 * 현금영수증 매입내역 실시간 조회 - Runnable 객체
 *
 * @author webcash.co.kr
 *
 */
public class CashRcptPrchsCooconServiceRunnable implements Runnable {

	private String _use_intt_id;
	private String _biz_no;
	private String _cert_name;
	private String _srchYYYYMM;
	private String _start_date;
	private String _end_date;
	private String _tax_agent_no;
	private String _tax_agent_password;

	public CashRcptPrchsCooconServiceRunnable(JexData evdcInfo, String srchYYYYMM, String start_date, String end_date, String tax_agent_no, String tax_agent_password) {

		_use_intt_id 		= evdcInfo.getString("USE_INTT_ID");
		_biz_no      		= evdcInfo.getString("BIZ_NO");
		_cert_name   		= evdcInfo.getString("CERT_NM");
		_srchYYYYMM  		= srchYYYYMM;
		_start_date  		= start_date;
		_end_date    		= end_date;
		_tax_agent_no    	= tax_agent_no;
		_tax_agent_password = tax_agent_password;
	}

	@Override
	public void run() {

		BizLogUtil.info(this, _use_intt_id,"Thread ["+Thread.currentThread().getName()+"] Start");

		try {
			//쿠콘 API 호출 - 현금영수증 매입내역조회 - 실시간, 등록된 인증서명
			JSONObject rsltData = CooconApi.getEvdcCashBuyHstrWithCertName(_biz_no, _srchYYYYMM, _cert_name, _tax_agent_no, _tax_agent_password);
			
			String rsltCd = StringUtil.null2void(rsltData.getString("ERRCODE"));
	    	String rsltMsg = StringUtil.null2void(rsltData.getString("ERRMSG"));

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
	    			deleteRcptBuyPtclData(idoCon);

	        		//저장내역 등록 정보
	        		JexDataList<JexData> insertData = new JexDataRecordList<JexData>();

	        		JSONArray arr_resp_data =  rsltData.getJSONArray("RESP_DATA");
	        		for(Object row : arr_resp_data)
	        		{
	        			JSONObject resp_data = (JSONObject)row;
	        			
	        			// 오늘일자 제외한 데이터만 저장
	        			if(!resp_data.getString("USED_DATE").substring(0, 8).equals(SvcDateUtil.getInstance().getDate())) {
	        				insertData.add(insertRcptBuyPtclData(resp_data));
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

	private void deleteRcptBuyPtclData(JexConnection idoCon)
			throws JexException, JexBIZException {

		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		//현금영수증 매입내역조회 - 실시간(1332)는 무조건 3개월치 조회하기 때문에, 그  기간만큼 삭제해줘야 함.
		//String startDate = SvcDateUtil.getInstance().getDate(_end_date.substring(0,6)+"01", -2, 'M');

		JexData idoIn1 = util.createIDOData("CASH_RCPT_BUY_HSTR_D001");
        
        idoIn1.put("USE_INTT_ID", _use_intt_id);
        idoIn1.put("START_DT"   , _srchYYYYMM+"01");
        idoIn1.put("END_DT"     , _end_date);
        JexData idoOut1 = idoCon.execute(idoIn1);

        if (DomainUtil.isError(idoOut1))
            throw new JexTransactionRollbackException(idoOut1);
	}

	private JexData insertRcptBuyPtclData(JSONObject hstrData) throws JexException, JexBIZException
	{	
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("CASH_RCPT_BUY_HSTR_C001");
		
		idoIn1.put("USE_INTT_ID", _use_intt_id);
		idoIn1.put("TRNS_DT"    , hstrData.getString("USED_DATE").substring(0, 8));
		idoIn1.put("APV_NO"     , hstrData.getString("APPROVAL_CODE"));
		idoIn1.put("USE_DTM"   	, hstrData.getString("USED_DATE"));
		idoIn1.put("USER_NM"    , hstrData.getString("USER_NM"));
		idoIn1.put("TRNS_DIV"   , hstrData.getString("TRADE_GUBUN"));
		idoIn1.put("MEST_BIZ_NO", hstrData.getString("REGNO_RESIDENT"));
		idoIn1.put("MEST_NM"    , hstrData.getString("BRANCH_DESC"));
		idoIn1.put("MEST_TYP"   , hstrData.getString("PATTERN"));
		idoIn1.put("SPLY_AMT"   , StringUtil.null2void(hstrData.getString("VALUE_OF_SUPPLY"),"0"));
		idoIn1.put("VAT_AMT"    , StringUtil.null2void(hstrData.getString("TAX_AMOUNT"),"0"));
		idoIn1.put("SRV_FEE"    , StringUtil.null2void(hstrData.getString("SERVICE_CHARGE"),"0"));
		idoIn1.put("TOTL_AMT"   , StringUtil.null2void(hstrData.getString("SUM_AMOUNT"),"0"));
		idoIn1.put("SBTR_YN"    , hstrData.getString("SETTLEMENT_DATE"));
		idoIn1.put("RMRK"       , hstrData.getString("NOTE"));
		idoIn1.put("MEMO"       , "");

		return idoIn1;
	}
	
	private void updEvdcSeupInfm(String last_dtm, String stts, String msg)
			throws JexException, JexBIZException{

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContext.getContext().getCommonUtil();


        msg = StringUtil.null2void(msg);
        if(msg.getBytes().length > 255){
            msg = StringUtil.byteSubString(msg, 0, 255);
        }

        JexData idoIn1 = util.createIDOData("EVDC_INFM_U011");
        //idoIn1.put("BUY_HIS_LST_DTM"  , last_dt + SvcDateUtil.getShortTimeString());
        idoIn1.put("RT_BUY_HIS_LST_DTM"  , last_dtm);
        idoIn1.put("BUY_HIS_LST_STTS", stts);
        idoIn1.put("BUY_HIS_LST_MSG" , msg);
        idoIn1.put("USE_INTT_ID"     , _use_intt_id);
        idoIn1.put("EVDC_DIV_CD"     , "21");
        JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);

        if (DomainUtil.isError(idoOut1))
        {
            BizLogUtil.error(this, "Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
            BizLogUtil.error(this, "Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
        }
    }
}
