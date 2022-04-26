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
 * 판매자 주문내역 실시간 조회 - Runnable 객체
 *
 * @author webcash.co.kr
 *
 */
public class SnssOrdrCooconServiceRunnable implements Runnable {

	private String _use_intt_id;
	private String _web_id;
	private String _web_pwd;
	private String _shop_cd;
	private String _sub_shop_cd;
	private String _start_date;
	private String _end_date;
	private String _pay_yn;

	public SnssOrdrCooconServiceRunnable(JexData evdcInfo, String start_date, String end_date, String pay_yn) {

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
			
			// 거래상태별로 3번 호출(1:완료, 2:취소, 3:처리중)
			//for(int i=1; i<=3; i++){
			for(int i=1; i<=1; i++){
				//쿠콘 API 호출 - 판매자 실시간 주문내역
				JSONObject rsltData = CooconApi.getSnssOrdrHstr(_web_id, _web_pwd, _start_date, _end_date, String.valueOf(i), "", _shop_cd);
				
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
			    			deleteSnssOrdrHstrData(idoCon, String.valueOf(i));
		
			        		//저장내역 등록 정보
			    			JexDataList<JexData> insertData = new JexDataRecordList<JexData>();
		
			    			// 응답결과
			        		JSONArray arr_resp_data =  rsltData.getJSONArray("ResultList")
			        									.getJSONObject(0).getJSONObject("Output")
			        									.getJSONObject("Result")
			        									.getJSONArray("주문내역");
			        		
			        		String be_orderdate = "";
			        		int seq = 0;
			        		
			        		for(Object row : arr_resp_data)
			        		{
			        			JSONObject resp_data = (JSONObject)row;
			        			
			        			if(be_orderdate.equals(resp_data.getString("주문일자"))){
			        				seq++;
		    					}
		    					else{
		    						// 주문일자별로 seq를 생성하는데 거래상태가 다르면 중복될수 있기 때문에 seq채번 기준 다름
		    						seq = 1;
		    						// 거래상태가 취소인 경우
				        			if(i==2) {
				        				seq = 50001;
				        			}
				        			// 거래상태가 처리중인 경우
				        			else if(i==3) {
				        				seq = 70001;
				        			}
		    					}
			        			insertData.add(insertSnssOrdrHstrData(resp_data, String.valueOf(seq)));
			        			// 주문일자
			        			be_orderdate = resp_data.getString("주문일자");
			        		}
			        		
			        		// 주문내역 등록
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
			}
		} catch (Exception e) {
			// 쓰레드 비정상 종료
			BizLogUtil.error(this, _use_intt_id, e, "Thread ["+Thread.currentThread().getName()+"]");
		}
	}

	private void deleteSnssOrdrHstrData(JexConnection idoCon, String tran_sts)
			throws JexException, JexBIZException {

		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		//JexData idoIn1 = util.createIDOData("SNSS_ORDR_HSTR_D002");
		JexData idoIn1 = util.createIDOData("SNSS_ORDR_HSTR_D001");
        idoIn1.put("USE_INTT_ID", _use_intt_id);
        idoIn1.put("SHOP_CD"	, _shop_cd);
        idoIn1.put("SUB_SHOP_CD", _sub_shop_cd);
        idoIn1.put("WEB_ID"		, _web_id);
        //idoIn1.put("TRAN_STS"   , tran_sts);
        idoIn1.put("START_DT"   , _start_date);
        idoIn1.put("END_DT"     , _end_date);
        
        JexData idoOut1 = idoCon.execute(idoIn1);

        if (DomainUtil.isError(idoOut1)) throw new JexTransactionRollbackException(idoOut1);
	}

	private JexData insertSnssOrdrHstrData(JSONObject resp_data, String seq) throws JexException, JexBIZException
	{
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("SNSS_ORDR_HSTR_C001");
		
		idoIn1.put("USE_INTT_ID" 	, _use_intt_id);
		idoIn1.put("SHOP_CD"     	, _shop_cd);
		idoIn1.put("SUB_SHOP_CD"	, _sub_shop_cd);
		idoIn1.put("WEB_ID"			, _web_id);
		idoIn1.put("ORDER_DATE"		, resp_data.getString("주문일자"));											
		idoIn1.put("SEQ"     		, StringUtil.null2void(seq,"1"));											
		idoIn1.put("ORDER_TIME"     , resp_data.getString("주문시각"));											
		idoIn1.put("ORDER_NO"     	, resp_data.getString("주문번호"));												
		idoIn1.put("TRAN_STS"     	, resp_data.getString("거래상태"));												
		idoIn1.put("PAY_AMT"     	, StringUtil.null2void(resp_data.getString("결제금액"), "0"));					
		idoIn1.put("PAY_TYPE"     	, resp_data.getString("결제타입"));												
		idoIn1.put("RECEIPT_METHOD" , resp_data.getString("수령방법"));										
		idoIn1.put("PAY_METHOD"     , resp_data.getString("결제방법"));											
		idoIn1.put("DELIVERY_FEE"   , StringUtil.null2void(resp_data.getString("배달요금"), "0"));				
		idoIn1.put("ORDER_AMT"     	, StringUtil.null2void(resp_data.getString("주문금액"), "0"));					
		idoIn1.put("SALE_1"     	, resp_data.getString("할인1"));													
		idoIn1.put("SALE_2"     	, resp_data.getString("할인2"));													
		idoIn1.put("COMPANY_NAME"   , resp_data.getString("업체명"));												
		idoIn1.put("COMPANY_CODE"   , resp_data.getString("업체코드"));												
		idoIn1.put("CONTACT"     	, resp_data.getString("연락처"));													
		idoIn1.put("RECEIPT_WAY"    , resp_data.getString("접수수단"));													
		idoIn1.put("JUNGSAN_AMT"    , StringUtil.null2void(resp_data.getString("정산금액"), "0"));										
		idoIn1.put("FEE"     		, StringUtil.null2void(resp_data.getString("수수료"), "0"));													
		idoIn1.put("FEES_2"     	, StringUtil.null2void(resp_data.getString("수수료2"), "0"));												
		idoIn1.put("VAT_AMT"     	, StringUtil.null2void(resp_data.getString("부가세"), "0"));												
		idoIn1.put("REG_DATETIME"   , "");

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
		dynamic.addSQL(", RT_HIS_LST_DTM = '"+last_dtm+"'");
		
        JexData idoIn1 = util.createIDOData("EVDC_INFM_U017");
        idoIn1.put("HIS_LST_STTS", stts);
        idoIn1.put("HIS_LST_MSG" , msg);
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
