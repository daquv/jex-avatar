package com.avatar.batch.subBatch;

import java.io.IOException;
import java.util.Random;

import com.avatar.api.mgnt.CooconApiMgnt;
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
 * 매시간 납부할세액 조회 서브
 *
 * @author won
 *
 */
public class PayTaxRealTimeCollectorSub extends BatchServiceBiz {

	private static final String job_id = "GET_RT_PAY_TAX_HSTR";
	BatchExecVO batchvo = new BatchExecVO();

	@Override
	public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {

		BizLogUtil.debug(this, "execute", "Input :: " + input.toJSONString());

		String use_intt_id = input.getString("USE_INTT_ID");

		batchvo.setJob_id(job_id);
		batchvo.setUse_intt_id(use_intt_id);

		// 기관 사업자 번호
		String bsnn_no = use_intt_id;
		
		JexData evdc_data = getEvdcSeupInfmData(use_intt_id);

		if (DomainUtil.getResultCount(evdc_data) == 1) {

			/**
			 * ===================================================================
			 * 납부할 세액 등록
			 * ===================================================================
			 */
			String vested_year_last = (SvcDateUtil.getInstance().getYear()-1)+"";
			String vested_year = (SvcDateUtil.getInstance().getYear())+"";
			// 작년조회
			insTaxHstr(evdc_data, use_intt_id, bsnn_no, vested_year_last);
			// 올해조회
			insTaxHstr(evdc_data, use_intt_id, bsnn_no, vested_year);

		}

		batchvo.setTotl_cnt(batchvo.getNor_cnt() + batchvo.getEtc_cnt() + batchvo.getErr_cnt());
		batchvo.setJob_end_tm(SvcDateUtil.getShortTimeString());
		batchvo.EndBatch();
		batchExecLogInsert(batchvo);

		return null;
	}

	/**
	 * <pre>
	 * 납부할세액 내역 조회
	 * </pre>
	 *
	 * @param evdc_data
	 * @param use_intt_id
	 * @param bsnn_no
	 * @param vested_year
	 * @throws JexException
	 * @throws JexBIZException
	 * @throws IOException
	 */
	private void insTaxHstr(JexData evdc_data, String use_intt_id, String bsnn_no, String vested_year)
			throws JexException, JexBIZException, IOException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();

		String his_lst_dtm = StringUtil.null2void(evdc_data.getString("HIS_LST_DTM"));
		String rsltDt = SvcDateUtil.getInstance().getDate("yyyymmddhh24miss");
		
		JSONObject resData = CooconApiMgnt.data_wapi_0412(bsnn_no, bsnn_no, vested_year, "A");
		
		if (!"00000000".equals(resData.getString("ERRCODE"))) {
			// 최종조회일시, 상태 업데이트
			updEvdcSeupInfm(use_intt_id, his_lst_dtm, resData.getString("ERRCODE"), resData.getString("ERRMSG"));
			batchvo.setProc_stts(resData.getString("ERRCODE"));
			batchvo.setProc_rslt_ctt(resData.getString("ERRMSG"));
			batchvo.addErrCnt(1);
			return;
		}

		String rsltCd = "0000";
		String rsltMsg = "";

		for (Object resp : resData.getJSONArray("RESP_DATA")) {
			JSONObject resp_data = (JSONObject) resp;

			rsltCd = resp_data.getString("DET_CODE"); // 결과코드
			rsltMsg = resp_data.getString("DET_MSG"); // 결과메시지

			batchvo.setProc_stts(rsltCd);
			batchvo.setProc_rslt_ctt(rsltMsg);
			
			// 거래결과가 없습니다. : 카드사 사이트에 거래 결과가 없음.(정상거래)
			if ("42110000".equals(rsltCd)) {
				batchvo.addNorCnt(1);
				rsltCd = "0000";
				break;
			}
			// 오류인 경우
			else if (!"00000000".equals(rsltCd)) {
				batchvo.addErrCnt(1);
				break;
			}

			idoCon.beginTransaction();

			// 기존 등록된 데이타가 있으면 삭제.
			deleteTaxHstrData(idoCon, use_intt_id, vested_year);

			JSONArray hstr_data = resp_data.getJSONArray("HSTR_DATA");
			JexDataList<JexData> insertPtclData = new JexDataRecordList<JexData>();
			JSONObject hstrData = null;

			for (int i = 0; i < hstr_data.size(); i++) {
				hstrData = (JSONObject) hstr_data.get(i);
				insertPtclData.add(insertTaxHstrData(hstrData, use_intt_id));
			}

			JexDataList<JexData> idoOutPtclBatch = idoCon.executeBatch(insertPtclData);

			if (DomainUtil.isError(idoOutPtclBatch)) {
				throw new JexTransactionRollbackException(idoOutPtclBatch);
			}
			insertPtclData.close();

			idoCon.commit();
			idoCon.endTransaction();

		}
		
		updEvdcSeupInfm(use_intt_id, rsltDt, rsltCd, rsltMsg);
		batchvo.setProc_stts(rsltCd);
		batchvo.setProc_rslt_ctt(rsltMsg);
	}

	/**
	 * <pre>
	 * 기존에 등록된 내역 삭제
	 * </pre>
	 *
	 * @param idoCon
	 * @param use_intt_id
	 * @param vested_year
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void deleteTaxHstrData(JexConnection idoCon, String use_intt_id, String vested_year) throws JexException, JexBIZException {

		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("TAX_HSTR_D002");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("BLN_YY", vested_year+'%');
		
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) throw new JexTransactionRollbackException(idoOut1);

	}

	

	/**
	 * <pre>
	 * 납부할세액 내역 등록
	 * </pre>
	 *
	 * @param hstrData
	 * @param use_intt_id
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JexData insertTaxHstrData(JSONObject hstrData, String use_intt_id)
			throws JexException, JexBIZException {
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		Random rand = new Random();
		String evdc_seq_no = SvcDateUtil.getFormatString("yyyyMMddHHmmssSSS")+"_"+rand.nextInt(100); 
		
		JexData idoIn1 = util.createIDOData("TAX_HSTR_C001");
		idoIn1.put("USE_INTT_ID"	, use_intt_id);
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
		idoIn1.put("TX_TYPE"    	, hstrData.getString("TX_TYPE"));
		idoIn1.put("REGR_ID"    	, "SYSTEM");
		
		return idoIn1;
	}
	
	/**
	 * <pre>
	 * 최종조회일시 수정
	 * </pre>
	 *
	 * @param use_intt_id
	 * @param last_dt
	 * @param stts
	 * @param msg
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void updEvdcSeupInfm(String use_intt_id, String last_dt, String stts, String msg)
			throws JexException, JexBIZException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		msg = StringUtil.null2void(msg);
		if (msg.getBytes().length > 255) {
			msg = StringUtil.byteSubString(msg, 0, 255);
		}

		IDODynamic dynamic = new IDODynamic();	
		
		// 정상인 경우
		if ("0000".equals(stts)) {
			dynamic.addSQL(", RT_HIS_LST_DTM = '"+SvcDateUtil.getInstance().getDate() + SvcDateUtil.getShortTimeString()+"'");
		}

		JexData idoIn1 = util.createIDOData("EVDC_INFM_U010");
		idoIn1.put("HIS_LST_STTS", stts);
		idoIn1.put("HIS_LST_MSG", msg);
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("EVDC_DIV_CD", "22");
		idoIn1.put("DYNAMIC_0", dynamic);

		JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			BizLogUtil.error(this, "Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
			BizLogUtil.error(this, "Error Message::" + DomainUtil.getErrorMessage(idoOut1));
		}

	}

	/**
	 * <pre>
	 * 증빙설정정보 조회
	 * </pre>
	 *
	 * @param use_intt_id
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JexData getEvdcSeupInfmData(String use_intt_id) throws JexException, JexBIZException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("EVDC_INFM_R001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("EVDC_DIV_CD", "22"); // 10:여신, 20:세금계산서, 21:현금영수증, 22:부가가치세/종합소득세
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			BizLogUtil.error(this, "Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
			BizLogUtil.error(this, "Error Message::" + DomainUtil.getErrorMessage(idoOut1));
			throw new JexBIZException(idoOut1);
		}

		return idoOut1;

	}
}
