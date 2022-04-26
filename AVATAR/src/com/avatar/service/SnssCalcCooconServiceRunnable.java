package com.avatar.service;

import jex.JexContext;
import jex.data.JexData;
import jex.data.JexDataList;
import jex.data.impl.JexDataRecordList;
import jex.data.impl.ido.IDODynamic;
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
 * 판매자 정산내역 실시간 조회 - Runnable 객체
 *
 * @author webcash.co.kr
 *
 */
public class SnssCalcCooconServiceRunnable implements Runnable {

	private String _use_intt_id;
	private String _web_id;
	private String _web_pwd;
	private String _shop_cd;
	private String _sub_shop_cd;
	private String _start_date;
	private String _end_date;
	private String _pay_yn;

	public SnssCalcCooconServiceRunnable(JexData evdcInfo, String start_date, String end_date, String pay_yn) {

		_use_intt_id = evdcInfo.getString("USE_INTT_ID");
		_web_id      = evdcInfo.getString("WEB_ID");
		_web_pwd     = evdcInfo.getString("WEB_PWD");
		_shop_cd     = evdcInfo.getString("SHOP_CD");
		_sub_shop_cd = evdcInfo.getString("SUB_SHOP_CD");
		_start_date  = start_date;
		_end_date    = end_date;
		_pay_yn 	 = pay_yn;
		
	}

	@Override
	public void run() {

		BizLogUtil.info(this, _use_intt_id,"Thread ["+Thread.currentThread().getName()+"] Start");

		try {
			
			// 쿠콘 API 호출 - 쇼핑몰 실시간 정산내역_배달 조회
			JSONObject rsltData = CooconApi.getSnssCalcHstr(_web_id, _web_pwd, _start_date, _end_date, "", _shop_cd);
			
			String rsltCd = rsltData.getJSONObject("Common").getString("Result_cd");
	    	String rsltMsg = rsltData.getJSONObject("Common").getString("Result_mg");

	    	// 오류인 경우
	    	if(!"00000000".equals(rsltCd)){
				//최종조회일시 변경
				updEvdcSeupInfm("", rsltCd, rsltMsg);
			}
	    	// 정상인 경우
	    	else {
	    		rsltCd = StringUtil.null2void(rsltData.getJSONArray("ResultList").getJSONObject(0).getJSONObject("Output").getString("ErrorCode"));
		    	rsltMsg = StringUtil.null2void(rsltData.getJSONArray("ResultList").getJSONObject(0).getJSONObject("Output").getString("ErrorMessage"));
	
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
		    			deleteSnssCalcHstrData(idoCon);
	
		        		//저장내역 등록 정보
		    			JexDataList<JexData> insertData = new JexDataRecordList<JexData>();
	
		    			// 응답결과
		        		JSONArray arr_resp_data =  rsltData.getJSONArray("ResultList")
		        									.getJSONObject(0).getJSONObject("Output")
		        									.getJSONObject("Result")
		        									.getJSONArray("정산내역");
		        		
		        		String be_receivedate = "";
		        		int seq = 0;
		        		
		        		for(Object row : arr_resp_data)
		        		{
		        			JSONObject resp_data = (JSONObject)row;
		        			
		        			if(be_receivedate.equals(resp_data.getString("입금일자"))) seq++;
	    					else seq = 1;
	    					
		        			insertData.add(insertSnssCalcHstrData(resp_data, String.valueOf(seq)));
		        			// 입금일자
		        			be_receivedate = resp_data.getString("입금일자");
		        		}
		        		
		        		// 정산내역 등록
		    			JexDataList<JexData> idoOutBatch =  idoCon.executeBatch(insertData);
		    			if (DomainUtil.isError(idoOutBatch)) { throw new JexTransactionRollbackException(idoOutBatch);}
		    			
		    			//최종조회일시 변경 - 삭제 및 저장 시 오류가 나면 최종조회일시를 업데이트 하지 않기 위해 이곳에서 호출한다.
		    			updEvdcSeupInfm(his_lst_dtm, rsltCd, rsltMsg);
		        		
		        	} catch (Exception e) {
						BizLogUtil.error(this, _use_intt_id, e, "Thread ["+Thread.currentThread().getName()+"]");
					}
	
		    		idoCon.endTransaction();
		        }
			}
			
		} catch (Exception e) {
			// 쓰레드 비정상 종료
			BizLogUtil.error(this, _use_intt_id, e, "Thread ["+Thread.currentThread().getName()+"]");
		}
	}

	private void deleteSnssCalcHstrData(JexConnection idoCon)
			throws JexException, JexBIZException {

		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("SNSS_CALC_HSTR_D001");
        idoIn1.put("USE_INTT_ID", _use_intt_id);
        idoIn1.put("SHOP_CD"	, _shop_cd);
        idoIn1.put("SUB_SHOP_CD", _sub_shop_cd);
        idoIn1.put("WEB_ID"		, _web_id);
        idoIn1.put("START_DT"   , _start_date);
        idoIn1.put("END_DT"     , _end_date);
        
        JexData idoOut1 = idoCon.execute(idoIn1);

        if (DomainUtil.isError(idoOut1)) throw new JexTransactionRollbackException(idoOut1);
	}

	private JexData insertSnssCalcHstrData(JSONObject resp_data, String seq) throws JexException, JexBIZException
	{
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("SNSS_CALC_HSTR_C001");
		
		idoIn1.put("USE_INTT_ID" 		, _use_intt_id);
		idoIn1.put("SHOP_CD"     		, _shop_cd);
		idoIn1.put("SUB_SHOP_CD"		, _sub_shop_cd);
		idoIn1.put("WEB_ID"				, _web_id);
		idoIn1.put("RECEIVE_DATE"		, resp_data.getString("입금일자"));											
		idoIn1.put("SEQ"     			, StringUtil.null2void(seq,"1"));											
		idoIn1.put("JUNGSAN_START_DATE" , resp_data.getString("정산시작일"));											
		idoIn1.put("JUNGSAN_END_DATE"   , resp_data.getString("정산종료일"));
		idoIn1.put("REFUND_AMT"     	, StringUtil.null2void(resp_data.getString("환급금액"), "0"));												
		idoIn1.put("JUNGSAN_AMT"     	, StringUtil.null2void(resp_data.getString("정산금액"), "0"));					
		idoIn1.put("PAYMENT_STATUS"     , resp_data.getString("지급상태"));												
		idoIn1.put("ORDER_AMT_1" 		, StringUtil.null2void(resp_data.getString("주문금액1"), "0"));										
		idoIn1.put("ORDER_AMT_2"     	, StringUtil.null2void(resp_data.getString("주문금액2"), "0"));											
		idoIn1.put("ORDER_AMT_3"   		, StringUtil.null2void(resp_data.getString("주문금액3"), "0"));				
		idoIn1.put("ORDER_AMT_4"     	, StringUtil.null2void(resp_data.getString("주문금액4"), "0"));					
		idoIn1.put("ORDER_AMT_5"     	, StringUtil.null2void(resp_data.getString("주문금액5"), "0"));													
		idoIn1.put("FEES_1"     		, StringUtil.null2void(resp_data.getString("수수료1"), "0"));													
		idoIn1.put("FEES_2"   			, StringUtil.null2void(resp_data.getString("수수료2"), "0"));												
		idoIn1.put("FEES_3"   			, StringUtil.null2void(resp_data.getString("수수료3"), "0"));												
		idoIn1.put("FEES_4"     		, StringUtil.null2void(resp_data.getString("수수료4"), "0"));													
		idoIn1.put("FEES_5"    			, StringUtil.null2void(resp_data.getString("수수료5"), "0"));													
		idoIn1.put("FEES_6"    			, StringUtil.null2void(resp_data.getString("수수료6"), "0"));										
		idoIn1.put("FEES_7"     		, StringUtil.null2void(resp_data.getString("수수료7"), "0"));													
		idoIn1.put("FEES_8"     		, StringUtil.null2void(resp_data.getString("수수료8"), "0"));												
		idoIn1.put("FEES_9"     		, StringUtil.null2void(resp_data.getString("수수료9"), "0"));												
		idoIn1.put("FEES_10"     		, StringUtil.null2void(resp_data.getString("수수료10"), "0"));												
		idoIn1.put("FEES_11"     		, StringUtil.null2void(resp_data.getString("수수료11"), "0"));												
		idoIn1.put("REG_DATETIME"   	, "");
		idoIn1.put("SEARCH_COMPNO"		, resp_data.getString("사업자번호"));

		return idoIn1;
	}

	// 최종상태 수정
	private void updEvdcSeupInfm(String last_dtm, String stts, String msg)
			throws JexException, JexBIZException{

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContext.getContext().getCommonUtil();


        msg = StringUtil.null2void(msg);
        if(msg.getBytes().length > 255){
            msg = StringUtil.byteSubString(msg, 0, 255);
        }
 
        IDODynamic dynamic = new IDODynamic();	
		dynamic.addSQL(", RT_BUY_HIS_LST_DTM = '"+last_dtm+"'");
		
        JexData idoIn1 = util.createIDOData("EVDC_INFM_U018");
        idoIn1.put("BUY_HIS_LST_STTS", stts);
        idoIn1.put("BUY_HIS_LST_MSG" , msg);
        idoIn1.put("DYNAMIC_0", dynamic);
        idoIn1.put("USE_INTT_ID" , _use_intt_id);
        idoIn1.put("EVDC_DIV_CD" , "40");
        idoIn1.put("SHOP_CD", _shop_cd);
		idoIn1.put("SUB_SHOP_CD", _sub_shop_cd);

        JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);

        if (DomainUtil.isError(idoOut1))
        {
        	BizLogUtil.error(this, "Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
			BizLogUtil.error(this, "Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
        }
    }
}
