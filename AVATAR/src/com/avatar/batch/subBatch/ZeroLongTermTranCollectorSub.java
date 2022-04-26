package com.avatar.batch.subBatch;

import com.avatar.api.mgnt.ZeropayApiMgnt;
import com.avatar.batch.comm.BatchServiceBiz;
import com.avatar.batch.vo.BatchExecVO;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.SvcDateUtil;

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

/**
 * 제로페이 결제내역조회 서브(3개월)
 *
 * @author won
 *
 */
public class ZeroLongTermTranCollectorSub extends BatchServiceBiz {

	private static final String job_id = "GET_LONG_TERM_ZERO_TRAN";
	BatchExecVO batchvo = new BatchExecVO();

	@Override
	public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {

		BizLogUtil.debug(this, "execute", "Input :: " + input.toJSONString());

		String use_intt_id = input.getString("USE_INTT_ID");

		batchvo.setJob_id(job_id);
		batchvo.setUse_intt_id(use_intt_id);
		
		// 제로페이 연결 고객 중 거래내역 조회해야 되는 대상 조회
		JexDataList<JexData> link_data = getCustLinkData(use_intt_id);
		
		for (JexData linkInfo : link_data) {
			
			BizLogUtil.debug(this, "execute", "linkInfo :: " + linkInfo.toJSONString());
			
			// TODO : 3개월 이전 데이터를 원하면 거래시작일자(tran_str_date) 변경될수 있음
			String tran_str_date = SvcDateUtil.getInstance().getDate(-3, 'M'); 	// 3개월
			String tran_end_date = SvcDateUtil.getInstance().getDate(); 		// 오늘
			
			String afltManagementNo = linkInfo.getString("AFLT_MANAGEMENT_NO");
			String bizNo = linkInfo.getString("MEST_BIZ_NO");
			String serBizNo = linkInfo.getString("SER_BIZ_NO");
			String cust_ci = linkInfo.getString("CUST_CI");
			
			// 결제내역조회
			JSONObject reqDat004 = ZeropayApiMgnt.data_api_004(cust_ci, bizNo, serBizNo, tran_str_date, tran_end_date, "2");

	     	JexDataList<JexData> insertTranData = new JexDataRecordList<JexData>();
			JexDataList<JexData> insertPointData = new JexDataRecordList<JexData>();
			
			// 결제내역조회 성공
        	if((reqDat004.getString("RSLT_CD")).equals("0000")){
        		JexConnection idoCon = JexConnectionManager.createIDOConnection();
    			idoCon.beginTransaction();
    			
        		// 결제내역 등록
        		JSONArray tranArr = JSONObject.fromArray(reqDat004.get("REC").toString());
        		
        		// 결제내역이 있을 경우
    			for(int ti = 0; ti< tranArr.size(); ti++){
    				
    				JSONObject tranObj = (JSONObject)tranArr.get(ti);
    				insertTranData.add(insertZeroTranHstr(use_intt_id, cust_ci, tranObj));
    		
    				String setl_dt = StringUtil.null2void((String)tranObj.get("TRAN_OCC_DATE"));
    				String otran_time = StringUtil.null2void((String)tranObj.get("OTRAN_TIME"));
    				String tran_id = StringUtil.null2void((String)tranObj.get("TRAN_ID"));
    				
    				if (tranObj.getJSONArray("POINT_REC") != null) {
    					// 기존 등록된 제로페이거래상품권내역 삭제
	        			deleteZeroTranPointHstr(idoCon, use_intt_id, setl_dt, otran_time, tran_id);
	        			
    					JSONObject pot = null;
    					int trns_srno = 0;
    					for (Object potData : tranObj.getJSONArray("POINT_REC")) {
    						pot = (JSONObject) potData;
    						trns_srno++;
    						insertPointData.add(insertZeroTranPointHstr(pot, use_intt_id, setl_dt, otran_time, tran_id, cust_ci, trns_srno));
    					}
    				}
    			}
    		
    			// 제로페이 결제내역 등록
    			JexDataList<JexData> idoOutTranBatch = idoCon.executeBatch(insertTranData);

    			if (DomainUtil.isError(idoOutTranBatch)) {
    				insertPointData.close();
    				throw new JexTransactionRollbackException(idoOutTranBatch);
    			}
    			insertTranData.close();

    			// 제로페이 결제 상품권 내역 등록
    			JexDataList<JexData> idoOutPointBatch = idoCon.executeBatch(insertPointData);

    			if (DomainUtil.isError(idoOutPointBatch)) {
    				idoOutPointBatch.close();
    				throw new JexTransactionRollbackException(idoOutPointBatch);
    			} 
    			idoOutPointBatch.close();
    			
    			// 가맹점 거래내역 조회여부 수정
    			updZeroMestInfm(use_intt_id, afltManagementNo, bizNo, serBizNo);
    			
    			idoCon.commit();
    			idoCon.endTransaction();
        	}
		}
		
		batchvo.setJob_end_tm(SvcDateUtil.getShortTimeString());
		batchvo.EndBatch();
		batchExecLogInsert(batchvo);

		return null;
	}

	/**
	 * <pre>
	 * 제로페이 결제내역 등록/수정
	 * </pre>
	 * @param use_intt_id
	 * @param cust_ci
	 * @param tran_info
	 * @return 
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JexData insertZeroTranHstr(String use_intt_id, String cust_ci, JSONObject tran_info)
			throws JexException, JexBIZException {
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		String setl_dt = StringUtil.null2void((String)tran_info.get("TRAN_OCC_DATE"));		// 결제일자 
		String otran_time = StringUtil.null2void((String)tran_info.get("OTRAN_TIME")); 		// 결제시간 
		String tran_id = StringUtil.null2void((String)tran_info.get("TRAN_ID"));			// 결제거래번호
		String trns_amt = StringUtil.null2void((String)tran_info.get("TRAN_AMT"),"0");		// 거래금액
		String srv_fee	= StringUtil.null2void((String)tran_info.get("SVC_AMT"),"0");		// 봉사료
		String add_tax_amt = StringUtil.null2void((String)tran_info.get("ADD_TAX_AMT"),"0");// 부가가치세
		String fee	= StringUtil.null2void((String)tran_info.get("AFLT_FEE"),"0");  		// 수수료
		String stts = StringUtil.null2void((String)tran_info.get("TRAN_PROC_CD"));			// 상태
		String biz_cd = StringUtil.null2void((String)tran_info.get("BIZ_CD"));				// 결재구분
		String org_proc_date = StringUtil.null2void((String)tran_info.get("ORG_PROC_DATE"));// 원거래일자
		String org_proc_seq = StringUtil.null2void((String)tran_info.get("ORG_PROC_SEQ"));	// 원거래번호
		String aflt_management_no = StringUtil.null2void((String)tran_info.get("AFLT_MANAGEMENT_NO"));	// 가맹점관리번호
		String mest_biz_no = StringUtil.null2void((String)tran_info.get("BIZ_NO"));			// 가맹점사업자번호
		String ser_biz_no = StringUtil.null2void((String)tran_info.get("SER_BIZ_NO"));		// 가맹점종사업번호 
		String mest_nm = StringUtil.null2void((String)tran_info.get("AFLT_NM"));			// 가맹점명
		String aflt_id = StringUtil.null2void((String)tran_info.get("AFLT_ID"));			// 가맹점아이디 
		String otran_bank_nm = StringUtil.null2void((String)tran_info.get("OTRAN_BANK_NM"));// 결제사명
		//String point_nm = StringUtil.null2void((String)tran_info.get("POINT_NM"));		// 상품권명
		
		
		// 제로페이 결제내역 등록
		JexData idoIn1 = util.createIDOData("ZERO_TRAN_HSTR_U001");
		
		idoIn1.put("USE_INTT_ID", use_intt_id);  
		idoIn1.put("SETL_DT", setl_dt);  
        idoIn1.put("OTRAN_TIME", otran_time);  
        idoIn1.put("TRAN_ID", tran_id);
        idoIn1.put("TRNS_AMT", trns_amt);
        idoIn1.put("SRV_FEE", srv_fee);
        idoIn1.put("ADD_TAX_AMT", add_tax_amt);
        idoIn1.put("FEE", fee);  
        idoIn1.put("STTS", stts);  
        idoIn1.put("BIZ_CD", biz_cd);  
        idoIn1.put("OTRAN_BANK_NM", otran_bank_nm);  
        idoIn1.put("POINT_NM", "");
        idoIn1.put("ORG_PROC_DATE", org_proc_date);  
        idoIn1.put("ORG_PROC_SEQ", org_proc_seq);  
        idoIn1.put("AFLT_MANAGEMENT_NO", aflt_management_no);  
        idoIn1.put("MEST_BIZ_NO", mest_biz_no);  
        idoIn1.put("SER_BIZ_NO", ser_biz_no);  
        idoIn1.put("MEST_NM", mest_nm);  
        idoIn1.put("AFLT_ID", aflt_id);  
        idoIn1.put("CUST_CI", cust_ci);  

		return idoIn1;
	}
	
	/**
	 * <pre>
	 * 제로페이 결제 상품권 내역 등록
	 * </pre>
	 *
	 * @param pot
	 * @param use_intt_id
	 * @param setl_dt
	 * @param otran_time
	 * @param tran_id
	 * @param cust_ci
	 * @param trns_srno
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JexData insertZeroTranPointHstr(JSONObject pot, String use_intt_id
			, String setl_dt, String otran_time , String tran_id, String cust_ci, int trns_srno)
			throws JexException, JexBIZException {
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		// 제로페이 결제 상품권 내역 등록
		JexData idoIn1 = util.createIDOData("ZERO_TRAN_POINT_HSTR_C001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("SETL_DT", setl_dt);
		idoIn1.put("OTRAN_TIME", otran_time);
		idoIn1.put("TRAN_ID", tran_id);
		idoIn1.put("TRNS_SRNO", trns_srno);
		idoIn1.put("POINT_ID", pot.getString("POINT_ID"));
		idoIn1.put("POINT_IMG_URL", pot.getString("POINT_IMG_URL"));
		idoIn1.put("POINT_ICON_IMG_URL", pot.getString("POINT_ICON_IMG_URL"));
		idoIn1.put("POINT_NM", pot.getString("POINT_NM"));
		idoIn1.put("POINT_AMT", StringUtil.null2void(pot.getString("TRAN_AMT"),"0"));
		idoIn1.put("BAL_AMT", StringUtil.null2void(pot.getString("BAL_AMT"),"0"));
		idoIn1.put("FACE_AMT", StringUtil.null2void(pot.getString("FACE_AMT"),"0"));
		idoIn1.put("CUST_CI", cust_ci);
		return idoIn1;
	}

	/**
	 * <pre>
	 * 제로페이거래상품권내역 삭제
	 * </pre>
	 *
	 * @param idoCon
	 * 
	 * @param use_intt_id
	 * @param setl_dt
	 * @param otran_time
	 * @param tran_id
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void deleteZeroTranPointHstr(JexConnection idoCon, String use_intt_id,
			String setl_dt, String otran_time, String tran_id) throws JexException, JexBIZException {
		
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		// 제로페이거래상품권내역 삭제
		JexData idoIn1 = util.createIDOData("ZERO_TRAN_POINT_HSTR_D001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("SETL_DT", setl_dt);  
		idoIn1.put("OTRAN_TIME", otran_time);  
		idoIn1.put("TRAN_ID", tran_id);  
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1))
			throw new JexTransactionRollbackException(idoOut1);

	}

	/**
	 * <pre>
	 * 가맹점 거래내역 조회여부 수정
	 * </pre>
	 *
	 * @param use_intt_id
	 * @param aflt_management_no
	 * @param mest_biz_no
	 * @param ser_biz_no
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void updZeroMestInfm(String use_intt_id, String aflt_management_no, String mest_biz_no, String ser_biz_no)
			throws JexException, JexBIZException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();
		
		// 가맹점 거래내역 조회여부 수정
		JexData idoIn1 = util.createIDOData("ZERO_MEST_INFM_U003");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("AFLT_MANAGEMENT_NO", aflt_management_no);
		idoIn1.put("MEST_BIZ_NO", mest_biz_no);
		idoIn1.put("SER_BIZ_NO", ser_biz_no);
		
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			BizLogUtil.error(this, "Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
			BizLogUtil.error(this, "Error Message::" + DomainUtil.getErrorMessage(idoOut1));
		}

	}
	
	/**
	 * <pre>
	 * 가맹점 거래내역 조회여부 조회
	 * </pre>
	 *
	 * @param use_intt_id
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JexDataList<JexData> getCustLinkData(String use_intt_id) throws JexException, JexBIZException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("ZERO_MEST_INFM_R006");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			BizLogUtil.error(this, "Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
			BizLogUtil.error(this, "Error Message::" + DomainUtil.getErrorMessage(idoOut1));
			throw new JexBIZException(idoOut1);
		}

		return idoOut1;
	}
}
