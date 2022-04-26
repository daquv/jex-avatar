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
 * 전자세금계산서 매입내역 실시간 조회 - Runnable 객체
 *
 * @author webcash.co.kr
 *
 */
public class ETaxbillPrchsCooconServiceRunnable implements Runnable {

	private String _use_intt_id;
	private String _biz_no;
	private String _cert_name;
	private String _srch_gubn;
	private String _start_date;
	private String _end_date;
	private String _tax_agent_no;
	private String _tax_agent_password;
	private String _pay_yn;

	public ETaxbillPrchsCooconServiceRunnable(JexData evdcInfo, String srch_gubn, String start_date, String end_date, String tax_agent_no, String tax_agent_password, String pay_yn) {

		_use_intt_id 		= evdcInfo.getString("USE_INTT_ID");
		_biz_no      		= evdcInfo.getString("BIZ_NO");
		_cert_name   		= evdcInfo.getString("CERT_NM");
		_srch_gubn   		= srch_gubn;
		_start_date  		= start_date;
		_end_date    		= end_date;
		_tax_agent_no    	= tax_agent_no;
		_tax_agent_password = tax_agent_password;
		_pay_yn 			= pay_yn;
	}

	@Override
	public void run() {

		BizLogUtil.info(this, _use_intt_id,"Thread ["+Thread.currentThread().getName()+"] Start");

		try {
			//쿠콘 API 호출 - 전자세금계산서 매입/매출 목록조회 - 실시간, 등록된 인증서명
			JSONObject rsltData = CooconApi.getEvdcTxblHstrWithCertNameLongTerm(_biz_no, _srch_gubn, _start_date, _end_date, _cert_name, _tax_agent_no, _tax_agent_password);
			
			String rsltCd = StringUtil.null2void(rsltData.getString("ERRCODE"));
	    	String rsltMsg = StringUtil.null2void(rsltData.getString("ERRMSG"));

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

				//최종조회일시 변경
				updEvdcSeupInfm(his_lst_dtm, rsltCd, rsltMsg);
	        }
	        else
	        {
	        	rsltCd = "0000";

	    		JexConnection idoCon = JexConnectionManager.createIDOConnection();
	    		idoCon.beginTransaction();

	    		try {
	        		//기존 등록된 데이타가 있으면 삭제.
	    			deleteElecTxblPtclData(idoCon);

	        		//저장내역 등록 정보
	    			JexDataList<JexData> insertPtclData = new JexDataRecordList<JexData>();
	                JexDataList<JexData> insertDtlsData = new JexDataRecordList<JexData>();

	        		JSONArray arr_resp_data =  rsltData.getJSONArray("RESP_DATA");
	        		for(Object row : arr_resp_data)
	        		{
	        			JSONObject resp_data = (JSONObject)row;
	        			String IssuId = resp_data.getString("APPROVAL_CODE").replaceAll("-","");
	        			insertPtclData.add(insertElecTxblPtclData(resp_data, IssuId));

	        			JSONArray arr_det_data =  resp_data.getJSONArray("DETAIL_RESP_DATA");
	        			for(int i = 0; i < arr_det_data.size(); i++)
	        			{
	        				JSONObject det_data = arr_det_data.getJSONObject(i);
	        				det_data.put("SEQ", String.valueOf(i+1));

	        				insertDtlsData.add(insertElecTxblDtlsData(det_data, IssuId));
	        			}
        			
	        		}

	        		// 명세 등록
	    			JexDataList<JexData> idoOutPtclBatch =  idoCon.executeBatch(insertPtclData);
	    			if (DomainUtil.isError(idoOutPtclBatch)) {
	    				insertDtlsData.close();
	    				throw new JexTransactionRollbackException(idoOutPtclBatch);
	    			}

	    			// 상세 등록
	    			JexDataList<JexData> idoOutdtlsBatch =  idoCon.executeBatch(insertDtlsData);
	    			if (DomainUtil.isError(idoOutdtlsBatch)) throw new JexTransactionRollbackException(idoOutdtlsBatch);

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

	private void deleteElecTxblPtclData(JexConnection idoCon)
			throws JexException, JexBIZException {

		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("ELEC_TXBL_DTLS_D002");
        idoIn1.put("USE_INTT_ID", _use_intt_id);
        idoIn1.put("BILL_TYPE"  , _srch_gubn);
        idoIn1.put("START_DT"   , _start_date);
        idoIn1.put("END_DT"     , _end_date);
        JexData idoOut1 = idoCon.execute(idoIn1);

        if (DomainUtil.isError(idoOut1))
            throw new JexTransactionRollbackException(idoOut1);


        JexData idoIn2 = util.createIDOData("ELEC_TXBL_PTCL_D002");
        idoIn2.put("USE_INTT_ID", _use_intt_id);
        idoIn2.put("BILL_TYPE"  , _srch_gubn);
        idoIn2.put("START_DT"   , _start_date);
        idoIn2.put("END_DT"     , _end_date);
        JexData idoOut2 = idoCon.execute(idoIn2);

        if (DomainUtil.isError(idoOut2))
            throw new JexTransactionRollbackException(idoOut2);
	}

	private JexData insertElecTxblDtlsData(JSONObject det, String IssuId) throws JexException, JexBIZException
	{
		JexCommonUtil util = JexContext.getContext().getCommonUtil();
		
		JexData idoIn1 = util.createIDOData("ELEC_TXBL_DTLS_C001");
		
		idoIn1.put("USE_INTT_ID", _use_intt_id);
		idoIn1.put("ISSU_ID"    , IssuId);
		idoIn1.put("SEQ_NO"     , det.getString("SEQ"));
		idoIn1.put("TRNS_DT"    , det.getString("TAXBILL_DATE"));
		idoIn1.put("ITEM_CODE"  , "");
		idoIn1.put("ITEM_NM"    , det.getString("ITEM_NAME"));
		idoIn1.put("ITEM_INFM"  , det.getString("ITEM_STANDARD"));
		idoIn1.put("ITEM_DESP"  , "");
		idoIn1.put("ITEM_QUNT"  , StringUtil.null2void(det.getString("ITEM_QUANTITY"),"0"));
		idoIn1.put("UNIT_PRCE"  , StringUtil.null2void(det.getString("ITEM_UNIT_COST"),"0"));
		idoIn1.put("SPLY_AMT"   , StringUtil.null2void(det.getString("ITEM_PROVIDE_AMOUNT"),"0"));
		idoIn1.put("ITEM_TAX"   , StringUtil.null2void(det.getString("ITEM_TAX_AMOUNT"),"0"));

		return idoIn1;
	}

	private JexData insertElecTxblPtclData(JSONObject resp_data, String IssuId) throws JexException, JexBIZException
	{
		JexCommonUtil util = JexContext.getContext().getCommonUtil();
		
		JexData idoIn1 = util.createIDOData("ELEC_TXBL_PTCL_C001");
		
		idoIn1.put("USE_INTT_ID" , _use_intt_id);
		idoIn1.put("ISSU_ID"     , IssuId);
		idoIn1.put("SELR_MGR_ID1", "");
		idoIn1.put("SELR_MGR_ID2", "");
		idoIn1.put("SELR_MGR_ID3", "");																				//일련번호
		idoIn1.put("ISSU_DT"     , resp_data.getString("ISSUE_DATE"));												//발행일자
		idoIn1.put("SND_DT"      , resp_data.getString("SEND_DATE"));												//전송일자
		idoIn1.put("WRTG_DT"     , resp_data.getString("DATE"));													//작성일자

		idoIn1.put("SELR_CORP_NO"   , (resp_data.getString("PROVIDER_REG_NUMBER")).replaceAll("[^0-9]",""));		//공급자 등록번호
		idoIn1.put("SELR_CODE"      , resp_data.getString("PROVIDER_OTHER_REGNO"));									//공급자 종사업장번호
		idoIn1.put("SELR_CORP_NM"   , StringUtil.toHalfChar(resp_data.getString("PROVIDER_COMPANY_NAME")));			//공급자 상호
		idoIn1.put("SELR_CEO"       , StringUtil.toHalfChar(resp_data.getString("PROVIDER_CEO_NAME")));				//공급자 성명
		idoIn1.put("SELR_ADDR"      , StringUtil.toHalfChar(resp_data.getString("PROVIDER_BUSINESS_PLACE")));		//공급자 사업장
		idoIn1.put("SELR_BUSS_CONS" , StringUtil.toHalfChar(resp_data.getString("PROVIDER_BUSINESS_CATEGORY")));	//공급자 업태
		idoIn1.put("SELR_BUSS_TYPE" , StringUtil.toHalfChar(resp_data.getString("PROVIDER_BUSINESS_TYPE")));		//공급자 종목
		idoIn1.put("SELR_CHRG_EMAIL", StringUtil.toHalfChar(resp_data.getString("PROVIDER_EMAIL")));				//공급자 이메일

		idoIn1.put("BUYR_CORP_NO"    , (resp_data.getString("RECEIVER_REG_NUMBER")).replaceAll("[^0-9]",""));		//공급받는자 등록번호
		idoIn1.put("BUYR_CODE"       , resp_data.getString("RECEIVER_OTHER_REGNO"));								//공급받는자 종사업장번호
		idoIn1.put("BUYR_CORP_NM"    , StringUtil.toHalfChar(resp_data.getString("RECEIVER_COMPANY_NAME")));		//공급받는자 상호
		idoIn1.put("BUYR_CEO"        , StringUtil.toHalfChar(resp_data.getString("RECEIVER_CEO_NAME")));			//공급받는자 성명
		idoIn1.put("BUYR_ADDR"       , StringUtil.toHalfChar(resp_data.getString("RECEIVER_BUSINESS_PLACE")));		//공급받는자 사업장
		idoIn1.put("BUYR_BUSS_CONS"  , StringUtil.toHalfChar(resp_data.getString("RECEIVER_BUSINESS_CATEGORY")));	//공급받는자 업태
		idoIn1.put("BUYR_BUSS_TYPE"  , StringUtil.toHalfChar(resp_data.getString("RECEIVER_BUSINESS_TYPE")));		//공급받는자 종목
		idoIn1.put("BUYR_CHRG_EMAIL1", StringUtil.toHalfChar(resp_data.getString("RECEIVER_EMAIL")));				//공급받는자 이메일

		idoIn1.put("BROK_CORP_NO"   , (resp_data.getString("BAILEE_REG_NUMBER")).replaceAll("[^0-9]",""));			//수탁사업자 등록번호
		idoIn1.put("BROK_CODE"      , resp_data.getString("BAILEE_OTHER_REGNO"));									//수탁사업자 종사업장번호
		idoIn1.put("BROK_CORP_NM"   , StringUtil.toHalfChar(resp_data.getString("BAILEE_COMPANY_NAME")));			//수탁사업자 상호
		idoIn1.put("BROK_CEO"       , StringUtil.toHalfChar(resp_data.getString("BAILEE_CEO_NAME")));				//수탁사업자 성명
		idoIn1.put("BROK_ADDR"      , StringUtil.toHalfChar(resp_data.getString("BAILEE_BUSINESS_PLACE")));			//수탁사업자 사업장
		idoIn1.put("BROK_BUSS_CONS" , StringUtil.toHalfChar(resp_data.getString("BAILEE_CATEGORY")));				//수탁사업자 업태
		idoIn1.put("BROK_BUSS_TYPE" , StringUtil.toHalfChar(resp_data.getString("BAILEE_TYPE")));					//수탁사업자 종목
		idoIn1.put("BROK_CHRG_NM"   , StringUtil.toHalfChar(resp_data.getString("BROK_BUSS_TYPE")));				//수탁사업자 종목
		idoIn1.put("BROK_CHRG_EMAIL", StringUtil.toHalfChar(resp_data.getString("BAILEE_EMAIL")));					//수탁사업자 이메일

		idoIn1.put("PYMT_TYPE1", "10");		//현금
		idoIn1.put("PAMT_AMT1" , StringUtil.null2void(resp_data.getString("CASH"),"0"));	//현금
		idoIn1.put("PYMT_TYPE2", "20");		//수표
		idoIn1.put("PAMT_AMT2" , StringUtil.null2void(resp_data.getString("CHECK"),"0"));	//수표
		idoIn1.put("PYMT_TYPE3", "30");		//어음
		idoIn1.put("PAMT_AMT3" , StringUtil.null2void(resp_data.getString("BILL"),"0"));	//어음
		idoIn1.put("PYMT_TYPE4", "40");		//외상(매출금/미수금)
		idoIn1.put("PAMT_AMT4" , StringUtil.null2void(resp_data.getString("CREDIT"),"0"));	//외상(매출금/미수금)

		idoIn1.put("SPLY_TOTL_AMT", StringUtil.null2void(resp_data.getString("PROVIDE_TAX_AMOUNT"),"0"));	//공급가액
		idoIn1.put("TAX_AMT"      , StringUtil.null2void(resp_data.getString("PROVIDE_TAX_AMOUNT2"),"0"));	//세액
		idoIn1.put("TOTL_AMT"     , StringUtil.null2void(resp_data.getString("TOTAL_AMOUNT"),"0"));			//총금액

		idoIn1.put("BILL_TYPE", _srch_gubn);									//매입매출구분 (1:매출, 2:매입, 3:면세매출, 4:면세매입)
		idoIn1.put("POPS_CODE", resp_data.getString("RECEIPT_CLAIM_GUBUN"));	//영수/청구 구분 (영수, 청구)
		idoIn1.put("MODY_CODE", resp_data.getString("EDIT_REASON"));			//수정사유
		idoIn1.put("RMRK1"    , resp_data.getString("ETC"));					//비고
		idoIn1.put("RMRK2"    , resp_data.getString("ETC2"));					//비고2
		idoIn1.put("TAX_TYPE" , resp_data.getString("EBILL_TYPE"));				//전자세금계산서 종류

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
        idoIn1.put("EVDC_DIV_CD"     , "20");

        JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);

        if (DomainUtil.isError(idoOut1))
        {
        	BizLogUtil.error(this, "Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
			BizLogUtil.error(this, "Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
        }
    }
}
