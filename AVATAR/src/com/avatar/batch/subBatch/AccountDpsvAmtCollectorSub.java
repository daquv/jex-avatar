package com.avatar.batch.subBatch;

import jex.JexContext;
import jex.data.JexData;
import jex.data.JexDataList;
import jex.data.impl.ido.IDODynamic;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.json.JSONArray;
import jex.json.JSONObject;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.util.DomainUtil;
import jex.util.StringUtil;
import jex.util.biz.JexCommonUtil;
import com.avatar.api.mgnt.CooconApiMgnt;
import com.avatar.batch.comm.BatchServiceBiz;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.CommonErrorHandler;
import com.avatar.comm.SvcDateUtil;
import com.avatar.batch.vo.BatchExecVO;

public class AccountDpsvAmtCollectorSub extends BatchServiceBiz {

	private static final String job_id = "GET_ACCT_DPSV_AMT";
	BatchExecVO batchvo = new BatchExecVO();

	@Override
	public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {

		BizLogUtil.debug(this, "execute", "Input :: " + input.toJSONString());

		String use_intt_id = input.getString("USE_INTT_ID");

		batchvo.setJob_id(job_id);
		batchvo.setUse_intt_id(use_intt_id);

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		String bsnn_no = getbsnnNo(use_intt_id);
		
		
		/**
		 * ========================================================= 
		 * 등록된 계좌의 잔액조회
		 * =========================================================
		 */
		// 이용기관별 잔액조회 - 전계좌(예적금)
		acctAmtReg_intt(idoCon, util, use_intt_id, bsnn_no);
		
		return null;
	}

	/**
	 * <pre>
	 * 이용기관별 잔액조회 - 전계좌
	 * </pre>
	 * 
	 * @param idoCon
	 * @param util
	 * @param use_intt_id
	 * @param bsnn_no
	 * @throws JexBIZException
	 * @throws JexException
	 */
	private void acctAmtReg_intt(JexConnection idoCon, JexCommonUtil util, String use_intt_id, String bsnn_no)
			throws JexBIZException, JexException {

		// 조회대상 계좌건수 조회 - 조회대상 건수가 0건이면 쿠콘조회 하지 않음.
		// 정상적인 계좌만 있을경우에만 쿠콘조회하기 위해(미등록, 삭제 계좌 제외하기 위함)
		if (getAcctCount(idoCon, util, use_intt_id) == 0) {
			return;
		}

		JSONObject resData = CooconApiMgnt.data_wapi_0148("", "", bsnn_no);

		if (!"00000000".equals(resData.getString("ERRCODE"))) {
			updateLstStts(idoCon, util, use_intt_id, "", resData.getString("ERRCODE"), resData.getString("ERRMSG"));
			batchvo.setProc_stts(resData.getString("ERRCODE"));
			batchvo.setProc_rslt_ctt(resData.getString("ERRMSG"));
			batchvo.addErrCnt(getAcctCount(idoCon, util, use_intt_id));
			batchvo.setTotl_cnt(batchvo.getNor_cnt() + batchvo.getEtc_cnt() + batchvo.getErr_cnt());
			batchvo.setJob_end_tm(SvcDateUtil.getShortTimeString());
			batchvo.EndBatch();
			batchExecLogInsert(batchvo);
			return;
		}

		JSONArray resp_data = resData.getJSONArray("RESP_DATA");

		String rsltCd = "0000";
		String rsltMsg = "";
		String fnnc_unq_no = "";
		
		for (Object resp : resp_data) {
			JSONObject respData = (JSONObject) resp;
			rsltCd = respData.getString("DET_CODE"); // 결과코드
			rsltMsg = respData.getString("DET_MSG"); // 결과메시지

			batchvo.setProc_stts(rsltCd);
			batchvo.setProc_rslt_ctt(rsltMsg);

			fnnc_unq_no = getFnncUnqNo(idoCon, util, use_intt_id, respData.getString("ACCT_NO"));

			// 등록하지 않은 계좌는 Skip.
			if ("".equals(StringUtil.null2void(fnnc_unq_no))) {
				batchvo.addEtcCnt(1);
				continue;
			}

			if ("WERR0006".equals(rsltCd)) {
				batchvo.addEtcCnt(1);
				rsltCd = "0000";
				updateLstStts(idoCon, util, use_intt_id, fnnc_unq_no, rsltCd, rsltMsg);
				continue;
			}
			// 거래결과가 없습니다. : 카드사 사이트에 거래 결과가 없음.(정상거래)
			else if ("42110000".equals(rsltCd)) {
				batchvo.addNorCnt(1);
				rsltCd = "0000";
				updateLstStts(idoCon, util, use_intt_id, fnnc_unq_no, rsltCd, rsltMsg);
				continue;
			}
			// 오류인 경우
			else if (!"00000000".equals(rsltCd)) {
				batchvo.addErrCnt(1);
				updateLstStts(idoCon, util, use_intt_id, fnnc_unq_no, rsltCd, rsltMsg);
				continue;
			}

			rsltCd = "0000";

			JSONObject hstrData = null;
			JSONArray hstr_data = respData.getJSONArray("HSTR_DATA"); // 카드사별 청구내역 반복부

			String bal = "";
			String cont_rt = "";
			String agmt_amt = "";
			String pyat_amt = "";
			String pyat_dt = "";
			String expi_dt = "";
			
			for (int j = hstr_data.size() - 1; j >= 0; j--) {
				hstrData = hstr_data.getJSONObject(j);

				bal = hstrData.getString("AMOUNT_BALANCE");				// 현재잔액
				cont_rt = hstrData.getString("RATE_INTEREST");			// 이자율
				agmt_amt = hstrData.getString("AMOUNT_CONTRACT");		// 약정액
				pyat_amt = hstrData.getString("AMOUNT_INSTALLENT");		// 월납입액
				pyat_dt = hstrData.getString("DATE_RECEIVE_INTEREST");	// 최종이수일자
				expi_dt = hstrData.getString("DATE_EXPIRE");			// 만기일자
				
				// 잔액 변경
				updateAcctAmt(idoCon, util, use_intt_id, fnnc_unq_no, bal, 
						cont_rt, agmt_amt, pyat_amt, pyat_dt, expi_dt, rsltCd, rsltMsg);

			}
			
			batchvo.addNorCnt(1);

		}
		batchvo.setTotl_cnt(batchvo.getNor_cnt() + batchvo.getEtc_cnt() + batchvo.getErr_cnt());
		batchvo.setJob_end_tm(SvcDateUtil.getShortTimeString());
		batchvo.EndBatch();
		batchExecLogInsert(batchvo);
	}
	

	/**
	 * 예적금 잔액_정보 변경
	 * 
	 * @param idoCon
	 * @param util
	 * @param use_intt_id
	 * @param fnnc_unq_no
	 * @param bal		현재잔액
	 * @param cont_rt   이자율
	 * @param agmt_amt  약정액
	 * @param pyat_amt  월납입금
	 * @param pyat_dt  	최종이수일자
	 * @param expi_dt  	만기일자
	 * @param rsltCd	잔액조회결과상태
	 * @param rsltMsg	잔액조회결과메시지
	 * @throws JexBIZException
	 * @throws JexException
	 */
	private void updateAcctAmt(JexConnection idoCon, JexCommonUtil util, String use_intt_id, String fnnc_unq_no,
			String bal, String cont_rt, String agmt_amt, String pyat_amt, String pyat_dt, String expi_dt, String rslt_cd, String rslt_msg) throws JexBIZException, JexException {
		
		JexData idoIn1 = util.createIDOData("ACCT_INFM_U016");
		idoIn1.put("CUR_AMT"	  , bal);
		idoIn1.put("BAL"		  , bal);
		idoIn1.put("CONT_RT"	  , cont_rt);
		idoIn1.put("AGMT_AMT"	  , agmt_amt);
		idoIn1.put("PYAT_AMT"	  , pyat_amt);
		idoIn1.put("PYAT_DT"	  , pyat_dt);
		idoIn1.put("EXPI_DT"  	  , expi_dt);
		idoIn1.put("BAL_LST_STTS" , rslt_cd);
		idoIn1.put("BAL_LST_DTM"  , SvcDateUtil.getInstance().getDate() + SvcDateUtil.getShortTimeString());
		idoIn1.put("BAL_LST_MSG"  , rslt_msg);
		idoIn1.put("USE_INTT_ID"  , use_intt_id);
		idoIn1.put("FNNC_UNQ_NO"  , fnnc_unq_no);
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1))
			CommonErrorHandler.comHandler(idoOut1);
	}
	
	/**
	 * <pre>
	 * 계좌별 잔액최종결과 수정
	 * </pre>
	 * 
	 * @param idoCon
	 * @param util
	 * @param use_intt_id
	 * @param fnnc_unq_no
	 * @param rsltCd		잔액조회결과상태
	 * @param rsltMsg		잔액조회결과메시지
	 * @param his_lst_dtm
	 * @throws JexBIZException
	 * @throws JexException
	 */
	private void updateLstStts(JexConnection idoCon, JexCommonUtil util, String use_intt_id, String fnnc_unq_no,
			String rslt_cd, String rslt_msg) throws JexBIZException, JexException {

		IDODynamic dynamic0 = new IDODynamic();	
		IDODynamic dynamic1 = new IDODynamic();	
		
		// 정상인 경우
		if ("0000".equals(rslt_cd)) {
			dynamic0.addSQL(", BAL_LST_DTM = '"+SvcDateUtil.getInstance().getDate() + SvcDateUtil.getShortTimeString()+"'");
		}
				
		if (!"".equals(fnnc_unq_no)) {
			dynamic1.addSQL("AND FNNC_UNQ_NO = '"+fnnc_unq_no+"'");
		}
		dynamic1.addSQL("AND COALESCE(ACCT_DV , '01') = '02'");
		
		
		JexData idoIn1 = util.createIDOData("ACCT_INFM_U012");
		idoIn1.put("BAL_LST_STTS", rslt_cd);
		idoIn1.put("BAL_LST_MSG", rslt_msg);
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("DYNAMIC_0", dynamic0);
		idoIn1.put("DYNAMIC_1", dynamic1);
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1))
			CommonErrorHandler.comHandler(idoOut1);
	}
	
	/**
	 * <pre>
	 * 금융고유번호 조회
	 * </pre>
	 * 
	 * @param idoCon
	 * @param util
	 * @param use_intt_id
	 * @param acct_no
	 * @return
	 * @throws JexBIZException
	 * @throws JexException
	 */
	private String getFnncUnqNo(JexConnection idoCon, JexCommonUtil util, String use_intt_id, String acct_no)
			throws JexBIZException, JexException {

		JexData idoIn1 = util.createIDOData("ACCT_INFM_R008");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("FNNC_INFM_NO", acct_no);
		idoIn1.put("ACCT_DV", "02");
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1))
			CommonErrorHandler.comHandler(idoOut1);

		return idoOut1.getString("FNNC_UNQ_NO");
	}
	
	/**
	 * <pre>
	 * 쿠콘 조회대상 계좌 건수조회(예적금)
	 * </pre>
	 * 
	 * @param idoCon
	 * @param util
	 * @param use_intt_id
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private int getAcctCount(JexConnection idoCon, JexCommonUtil util, String use_intt_id)
			throws JexException, JexBIZException {

		JexData idoIn1 = util.createIDOData("ACCT_INFM_R019");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			CommonErrorHandler.comHandler(idoOut1);
		}

		return Integer.parseInt(StringUtil.null2void(idoOut1.getString("CNT"), "0"));
	}
}
