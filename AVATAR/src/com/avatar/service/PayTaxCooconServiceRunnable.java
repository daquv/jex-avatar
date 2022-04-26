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

import java.util.Random;

import com.avatar.api.mgnt.CooconApi;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.SvcDateUtil;

/**
 * 납부할 세액내역 실시간 조회 - Runnable 객체
 *
 * @author webcash.co.kr
 *
 */
public class PayTaxCooconServiceRunnable implements Runnable {

	private String _use_intt_id;
	private String _biz_no;
	private String _cert_name;
	
	public PayTaxCooconServiceRunnable(JexData evdcInfo) {
		_use_intt_id 		= evdcInfo.getString("USE_INTT_ID");
		_biz_no      		= evdcInfo.getString("BIZ_NO");
		_cert_name   		= evdcInfo.getString("CERT_NM");
	}

	@Override
	public void run() {

		BizLogUtil.info(this, _use_intt_id,"Thread ["+Thread.currentThread().getName()+"] Start");

		try {
			//쿠콘 API 호출 - 납부할 세액조회 - 실시간, 등록된 인증서명
			JSONObject rsltData = CooconApi.getTaxHstrWithCertName(_biz_no, _cert_name);
			
			String rsltCd = StringUtil.null2void(rsltData.getString("ERRCODE"));
	    	String rsltMsg = StringUtil.null2void(rsltData.getString("ERRMSG"));

	    	//최종조회일자
			String shis_lst_dtm = SvcDateUtil.getInstance().getDate("yyyymmddhh24miss");
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

				//최종조회일시 변경
				updEvdcSeupInfm(his_lst_dtm, rsltCd, rsltMsg);
	        }
	        else
	        {
	        	rsltCd = "0000";

	    		JexConnection idoCon = JexConnectionManager.createIDOConnection();
	    		idoCon.beginTransaction();

	    		try {
	    			deletePayTaxData(idoCon);

	        		//저장내역 등록 정보
	        		JexDataList<JexData> insertData = new JexDataRecordList<JexData>();

	        		JSONArray arr_resp_data =  rsltData.getJSONArray("RESP_DATA");
	        		int i=0;
	        		for(Object row : arr_resp_data)
	        		{
	        			JSONObject resp_data = (JSONObject)row;
	        			
	        			insertData.add(insertPayTaxData(resp_data, i));
	        			i++;
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

	// 납부할 세액 전체 삭제
	private void deletePayTaxData(JexConnection idoCon)
			throws JexException, JexBIZException {

		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("TAX_HSTR_D001");
        
        idoIn1.put("USE_INTT_ID", _use_intt_id);
        JexData idoOut1 = idoCon.execute(idoIn1);

        if (DomainUtil.isError(idoOut1))
            throw new JexTransactionRollbackException(idoOut1);
	}

	private JexData insertPayTaxData(JSONObject hstrData, int idx) throws JexException, JexBIZException
	{	
		Random rand = new Random();
		String evdc_seq_no = SvcDateUtil.getFormatString("yyyyMMddHHmmssSSS")+"_"+rand.nextInt(100); 
		
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("TAX_HSTR_C001");
		 
		idoIn1.put("USE_INTT_ID"	, _use_intt_id);
		idoIn1.put("EVDC_SEQ_NO"	, evdc_seq_no);
		idoIn1.put("ELEC_PAYR_NO"   , hstrData.getString("PAYMENT_NO"));
		idoIn1.put("OFNM"     		, hstrData.getString("OFFICE_NAME"));
		idoIn1.put("TXOF_CD"   		, hstrData.getString("OFFICE_CODE"));
		idoIn1.put("TAXT_DV"    	, hstrData.getString("TAX_TYPE"));
		idoIn1.put("TAX_ITEM_NM"   	, hstrData.getString("TAX_ITEM"));
		idoIn1.put("BLN_YY"			, hstrData.getString("VESTED_YEAR"));
		idoIn1.put("PAY_EXDT_DT"    , hstrData.getString("PAYMENT_LIMIT_DATE"));
		idoIn1.put("PAY_PLAN_TAX"   , StringUtil.null2void(hstrData.getString("TAX_AMOUNT_TO_PAY"),"0"));
		idoIn1.put("PAY_TAX"   		, StringUtil.null2void(hstrData.getString("TAX_PAYING_AMOUNT"),"0"));
		idoIn1.put("CHRG_NM"    	, hstrData.getString("ISSUE_PERSON"));
		idoIn1.put("TX_TYPE"    	, "");
		idoIn1.put("REGR_ID"    	, _use_intt_id);
		
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

        JexData idoIn1 = util.createIDOData("EVDC_INFM_U014");
        idoIn1.put("RT_HIS_LST_DTM"	, last_dtm);
        idoIn1.put("HIS_LST_STTS"	, stts);
        idoIn1.put("HIS_LST_MSG" 	, msg);
        idoIn1.put("USE_INTT_ID"    , _use_intt_id);
        idoIn1.put("EVDC_DIV_CD"    , "22");
        JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);

        if (DomainUtil.isError(idoOut1))
        {
            BizLogUtil.error(this, "Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
            BizLogUtil.error(this, "Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
        }
    }
}
