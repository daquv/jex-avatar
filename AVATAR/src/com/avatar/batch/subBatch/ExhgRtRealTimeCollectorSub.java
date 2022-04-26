package com.avatar.batch.subBatch;

import java.io.IOException;
import com.avatar.api.mgnt.CooconApi;
import com.avatar.batch.comm.BatchServiceBiz;
import com.avatar.batch.vo.BatchExecVO;
import com.avatar.comm.SvcDateUtil;

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

/**
 * 환율 조회 서브
 *
 * @author won
 *
 */
public class ExhgRtRealTimeCollectorSub extends BatchServiceBiz {

	private static final String job_id = "GET_RT_EXHG_RT_HSTR";
	BatchExecVO batchvo = new BatchExecVO();

	@Override
	public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {

		batchvo.setJob_id(job_id);
		
    	ExhgRtHstr();

		batchvo.setJob_end_tm(SvcDateUtil.getShortTimeString());
		batchvo.EndBatch();
		batchExecLogInsert(batchvo);

		return null;
	}

	/**
	 * <pre>
	 * 환율 내역 조회
	 * </pre>
	 *
	 * @throws JexException
	 * @throws JexBIZException
	 * @throws IOException
	 */
	private void ExhgRtHstr() throws JexException, JexBIZException, IOException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		
		// 쿠콘 API 호출 - 외화 고시환율조회; 
    	JSONObject rsltData = CooconApi.getExhgRt("011", "1", "0", ""); 

    	//조회결과
    	String rsltCd  = rsltData.getString("RESULT_CD");
		String rsltMsg = rsltData.getString("RESULT_MG");

		String nation = "";
		String currency_baisc = "";
		String currency = "";
		
		if("00000000".equals(rsltCd)){
			
			JSONArray arr_resp_data = rsltData.getJSONArray("RESP_DATA");
			JexDataList<JexData> insertExhgRtData = new JexDataRecordList<JexData>();
			
    		JSONObject respData = null;
    		String exhg_rt_seq_no = SvcDateUtil.getFormatString("yyyyMMddHHmmssSSS");
    		
    		for(int j=0 ; j < arr_resp_data.size() ; j++)
			{
				respData = arr_resp_data.getJSONObject(j);
				
				currency = respData.getString("CURRENCY_NAME");
				
				if(currency.indexOf("USD") > -1){ nation = "미국"; currency_baisc = "1달러";}
				else if(currency.indexOf("JPY") > -1){ currency  = "JPY"; nation = "일본"; currency_baisc = "100엔";}
				else if(currency.indexOf("EUR") > -1){ nation = "유럽연합"; currency_baisc = "1유로";}
				else if(currency.indexOf("CNY") > -1){ nation = "중국"; currency_baisc = "1위안";}
				else if(currency.indexOf("GBP") > -1){ nation = "영국"; currency_baisc = "1파운드";}
				else if(currency.indexOf("CHF") > -1){ nation = "스위스"; currency_baisc = "1프랑";}
				else if(currency.indexOf("CAD") > -1){ nation = "캐나다"; currency_baisc = "1달러";}
				else if(currency.indexOf("HKD") > -1){ nation = "홍콩"; currency_baisc = "1달러";}
				else if(currency.indexOf("SEK") > -1){ nation = "스웨덴"; currency_baisc = "1크로네";}
				else if(currency.indexOf("AUD") > -1){ nation = "호주"; currency_baisc = "1달러";}
				else if(currency.indexOf("DKK") > -1){ nation = "덴마크"; currency_baisc = "1크로네";}
				else if(currency.indexOf("NOK") > -1){ nation = "노르웨이"; currency_baisc = "1크로네";}
				else if(currency.indexOf("SAR") > -1){ nation = "사우디아라비아"; currency_baisc = "1리알";}
				else if(currency.indexOf("KWD") > -1){ nation = "쿠웨이트"; currency_baisc = "1디나르";}
				else if(currency.indexOf("AED") > -1){ nation = "아랍에미리트"; currency_baisc = "1디히람";}
				else if(currency.indexOf("SGD") > -1){ nation = "싱가포르"; currency_baisc = "1달러";}
				else if(currency.indexOf("MYR") > -1){ nation = "말레이지아"; currency_baisc = "1링기트";}
				else if(currency.indexOf("NZD") > -1){ nation = "뉴질랜드"; currency_baisc = "1달러";}
				else if(currency.indexOf("THB") > -1){ nation = "태국"; currency_baisc = "1바트";}
				else if(currency.indexOf("IDR") > -1){ currency  = "IDR"; nation = "인도네시아"; currency_baisc = "100루피아";}
				else if(currency.indexOf("TWD") > -1){ nation = "대만"; currency_baisc = "1달러";}
				else if(currency.indexOf("PHP") > -1){ nation = "필리핀"; currency_baisc = "1페소";}
				else if(currency.indexOf("INR") > -1){ nation = "인도"; currency_baisc = "1루피";}
				else if(currency.indexOf("RUB") > -1){ nation = "러시아"; currency_baisc = "1루블";}
				else if(currency.indexOf("ZAR") > -1){ nation = "남아프리카공화국"; currency_baisc = "1랜드";}
				else if(currency.indexOf("MXN") > -1){ nation = "멕시코"; currency_baisc = "1페소";}
				else if(currency.indexOf("VND") > -1){ nation = "베트남"; currency_baisc = "100동";}
				else if(currency.indexOf("PLN") > -1){ nation = "폴란드"; currency_baisc = "1즐로티";}
				
				respData.put("EXHG_RT_SEQ_NO", exhg_rt_seq_no+(j+10));
				respData.put("CURRENCY_BASIC", currency_baisc);
				respData.put("NTNL", nation);
				respData.put("CURRENCY_NAME", currency);
   				
				insertExhgRtData.add(insertExhgRtHstrData(respData));
			}
    		
    		idoCon.beginTransaction();

    		// 등록할 데이터가 있을 경우에만 삭제(농협은행 국가는 28개)
    		if(arr_resp_data.size() > 0) {
    			deleteExhgRtData(idoCon);
    		}
    		
    		JexDataList<JexData> idoExhgRtBatch = idoCon.executeBatch(insertExhgRtData);

			if (DomainUtil.isError(idoExhgRtBatch)) {
				throw new JexTransactionRollbackException(idoExhgRtBatch);
			}
			
			insertExhgRtData.close();

			idoCon.commit();
			idoCon.endTransaction();
			
		}
		
		batchvo.setProc_stts(rsltCd);
		batchvo.setProc_rslt_ctt(rsltMsg);
	}
	
	/**
	 * <pre>
	 * 환율 내역 삭제
	 * </pre>
	 *
	 * @param idoCon
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void deleteExhgRtData(JexConnection idoCon) throws JexException, JexBIZException {

		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		// 환율 내역 전체 삭제
		JexData idoIn1 = util.createIDOData("EXHG_RT_HSTR_D001");
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1))
			throw new JexTransactionRollbackException(idoOut1);
		
	}

	/**
	 * <pre>
	 * 환율 내역 등록
	 * </pre>
	 *
	 * @param hstrData
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JexData insertExhgRtHstrData(JSONObject hstrData)
			throws JexException, JexBIZException {
		JexCommonUtil util = JexContext.getContext().getCommonUtil();
		
		JexData idoIn1 = util.createIDOData("EXHG_RT_HSTR_C001");
		idoIn1.put("EXHG_RT_SEQ_NO"		, hstrData.getString("EXHG_RT_SEQ_NO"));
		idoIn1.put("NOTICE_TIMES"		, hstrData.getString("NOTICE_TIMES"));
		idoIn1.put("CURRENCY_NAME"   	, hstrData.getString("CURRENCY_NAME"));
		idoIn1.put("NTNL"     			, hstrData.getString("NTNL"));
		idoIn1.put("CURRENCY_BASIC"   	, hstrData.getString("CURRENCY_BASIC"));
		idoIn1.put("CASH_BUY"    		, StringUtil.null2void(hstrData.getString("CASH_BUY"),"0"));
		idoIn1.put("CASH_SELL"   		, StringUtil.null2void(hstrData.getString("CASH_SELL"),"0"));
		idoIn1.put("TELEGRAPHIC_SEND"	, StringUtil.null2void(hstrData.getString("TELEGRAPHIC_SEND"),"0"));
		idoIn1.put("TELEGRAPHIC_RECEIVE", StringUtil.null2void(hstrData.getString("TELEGRAPHIC_RECEIVE"),"0"));
		idoIn1.put("TRAVELER_CHECK_BUY" , StringUtil.null2void(hstrData.getString("TRAVELER_CHECK_BUY"),"0"));
		idoIn1.put("FOREIGN_CHECK_SELL" , StringUtil.null2void(hstrData.getString("FOREIGN_CHECK_SELL"),"0"));
		idoIn1.put("TRADE_BASIC_RATE"   , StringUtil.null2void(hstrData.getString("TRADE_BASIC_RATE"),"0"));
		idoIn1.put("CONVERSION_RATE"    , StringUtil.null2void(hstrData.getString("CONVERSION_RATE"),"0"));
		idoIn1.put("USA_CONVERSION_RATE", StringUtil.null2void(hstrData.getString("USA_CONVERSION_RATE"),"0"));
		idoIn1.put("STANDARD_DATE"    	, hstrData.getString("STANDARD_DATE"));
		idoIn1.put("STANDARD_TIME"    	, hstrData.getString("STANDARD_TIME"));
		idoIn1.put("CONTRAST"    		, hstrData.getString("CONTRAST"));
		idoIn1.put("STANDARD_END_DATE"  , hstrData.getString("STANDARD_END_DATE"));
		
		return idoIn1;
	}

}