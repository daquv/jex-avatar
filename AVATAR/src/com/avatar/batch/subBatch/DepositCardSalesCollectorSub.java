package com.avatar.batch.subBatch;

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
import com.avatar.api.mgnt.CooconApiMgnt;
import com.avatar.batch.comm.BatchServiceBiz;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.CommUtil;
import com.avatar.comm.SvcDateUtil;
import com.avatar.batch.vo.BatchExecVO;

/**
 * 카드매출 입금내역 서브
 * 
 * @author won
 *
 */
public class DepositCardSalesCollectorSub extends BatchServiceBiz {

	private final static String job_id = "GET_DPST_CARD_SALES";
	BatchExecVO batchvo = new BatchExecVO();

	@Override
	public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {

		BizLogUtil.debug(this, "execute", "Input :: " + input.toJSONString());

		String use_intt_id = input.getString("USE_INTT_ID");

		batchvo.setJob_id(job_id);
		batchvo.setUse_intt_id(use_intt_id);

		JexConnection idoCon = JexConnectionManager.createIDOConnection();

		// 기관 사업자 번호
		String bsnn_no = getbsnnNo(use_intt_id);

		JexData evdc_data = getEvdcSeupInfmData(use_intt_id);

		String startDate = StringUtil.null2void(evdc_data.getString("HIS_LST_DTM")).trim();
		String endDate = SvcDateUtil.getInstance().getDate(SvcDateUtil.getInstance().getDate(), -1, 'D');

		// 실시간조회로 최종조회일자가 조회시점의 당일로 저장되면서,
		// 조회시작일자가 조회종료일자보다 이후이면 초기조회조건으로 변경(재조회 성격으로, 혹시나 빠진 거래에 대한 대비책으로...)
		if (!"".equals(startDate) && SvcDateUtil.getInstance().days_between(startDate.substring(0, 8), endDate) <= 0) {
			startDate = "";
		}

		// 첫 조회는 -8일에서 3개월로 변경
		if ("".equals(startDate)) {
			//startDate = SvcDateUtil.getInstance().getDate(-8, 'D');
			startDate = SvcDateUtil.getInstance().getDate(-3, 'M');
		} else {
			startDate = SvcDateUtil.getInstance().getDate(startDate.substring(0, 8), -8, 'D'); //쿠콘에서 16일 데이타가 24일에 조회된경우가 있음.
		}

		JSONObject resData = CooconApiMgnt.data_wapi_0107(bsnn_no, "3", startDate, endDate, "1", "99999");

		// 호출 이력
//		extnInsert(use_intt_id, "C", "0107", resData.getString("ERRCODE"), resData.getString("ERRMSG"));

		if (!"00000000".equals(resData.getString("ERRCODE"))) {
			// 최종조회일시, 상태 업데이트
			updEvdcSeupInfm(use_intt_id, SvcDateUtil.getInstance().getDate(startDate, -1, 'D'), resData.getString("ERRCODE"), resData.getString("ERRMSG"));
			batchvo.addErrCnt(1);
			batchvo.setProc_stts(resData.getString("ERRCODE"));
			batchvo.setProc_rslt_ctt(resData.getString("ERRMSG"));
			batchvo.setTotl_cnt(batchvo.getNor_cnt() + batchvo.getEtc_cnt() + batchvo.getErr_cnt());
			batchvo.setJob_end_tm(SvcDateUtil.getShortTimeString());
			batchvo.EndBatch();
			batchExecLogInsert(batchvo);
			return null;
		}

		// String tranorder = (String)resData.get("TRANORDER"); //거래순서
		// (0:최신거래내역순,1:과거거래내역순)
		String rsltCd = "0000";
		String rsltMsg = "";
		String rsltDt = endDate;

		for (Object resp : resData.getJSONArray("RESP_DATA")) {
			JSONObject resp_data = (JSONObject) resp;

			rsltCd = resp_data.getString("DET_CODE"); // 결과코드
			rsltMsg = resp_data.getString("DET_MSG"); // 결과메시지

			batchvo.setProc_stts(rsltCd);
			batchvo.setProc_rslt_ctt(rsltMsg);

			// 조회를 실패하였습니다 : 쿠콘DB에 거래 결과가 없음, 쿠콘 BATCH가 실행되기전 api요청을 한 경우
			if ("WERR0006".equals(rsltCd)) {
				batchvo.addEtcCnt(1);
				rsltCd = "0000";
				rsltDt = SvcDateUtil.getInstance().getDate(startDate, -1, 'D');
				break;
			}
			// 거래결과가 없습니다. : 카드사 사이트에 거래 결과가 없음.(정상거래)
			else if ("42110000".equals(rsltCd)) {
				batchvo.addNorCnt(1);
				rsltCd = "0000";
				rsltDt = endDate;
				break;
			}
			// 오류인 경우
			else if (!"00000000".equals(rsltCd)) {
				batchvo.addErrCnt(1);
				rsltDt = SvcDateUtil.getInstance().getDate(startDate, -1, 'D');
				break;
			}

			// 기존 등록된 데이타가 있으면 삭제.
			deleteRcvDtlsData(idoCon, use_intt_id, startDate, endDate);

			JSONArray hstr_data = resp_data.getJSONArray("HSTR_DATA"); // 카드사별 승인내역 반복부
			JexDataList<JexData> insertData = new JexDataRecordList<JexData>();
			JSONObject hstrData = null;
			// int seq = 0;
			for (int i = 0; i < hstr_data.size(); i++) {
				hstrData = (JSONObject) hstr_data.get(i);
				insertData.add(insertRcvDtlsData(hstrData, use_intt_id));

			}

			JexDataList<JexData> idoOutBatch = idoCon.executeBatch(insertData);

			if (DomainUtil.isError(idoOutBatch)) {
				throw new JexTransactionRollbackException(idoOutBatch);
			} else {
				batchvo.addNorCnt(1);
				rsltCd = "0000";
			}

		}

		updEvdcSeupInfm(use_intt_id, rsltDt, rsltCd, rsltMsg);

		batchvo.setProc_stts(rsltCd);
		batchvo.setProc_rslt_ctt(rsltMsg);
		batchvo.setTotl_cnt(batchvo.getNor_cnt() + batchvo.getEtc_cnt() + batchvo.getErr_cnt());
		batchvo.setJob_end_tm(SvcDateUtil.getShortTimeString());
		batchvo.EndBatch();
		batchExecLogInsert(batchvo);

		return null;
	}

	/**
	 * <pre>
	 * 카드매출 입금내역 등록
	 * </pre>
	 * 
	 * @param hstrData
	 * @param use_intt_id
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JexData insertRcvDtlsData(JSONObject hstrData, String use_intt_id) throws JexException, JexBIZException {
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("CARD_SEL_RCV_HSTR_C001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("CARD_CORP_NM", hstrData.getString("CARD_NAME"));
		idoIn1.put("RCV_DT", hstrData.getString("RECI_DATE"));
		idoIn1.put("MEST_NO", hstrData.getString("AFFILIATE_NO"));
		idoIn1.put("SETL_BANK_CD", hstrData.getString("SETT_BANK"));
		idoIn1.put("SETL_ACCT_NO", hstrData.getString("SETT_ACCOUNT"));
		idoIn1.put("SALE_CNT", hstrData.getString("SALES_CNT"));
		idoIn1.put("SALE_AMT", hstrData.getString("SALES_AMT"));
		idoIn1.put("SUSP_AMT", hstrData.getString("DEFER_AMT"));
		idoIn1.put("ETC_AMT", hstrData.getString("ETC_AMT"));
		idoIn1.put("RCV_AMT", hstrData.getString("REAL_INAMT"));
		idoIn1.put("RCV_YN", "N");
		idoIn1.put("REGR_ID", "SYSTEM");
		idoIn1.put("REG_DTM", SvcDateUtil.getInstance().getDate("YYYYMMDDHH24miss"));

		return idoIn1;
	}

	/**
	 * <pre>
	 * 카드매출 입금내역 최종조회결과 업데이트
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

		if (last_dt.length() == 8) {
			last_dt = last_dt + SvcDateUtil.getShortTimeString();
		}

		JexData idoIn1 = util.createIDOData("EVDC_INFM_U002");
		idoIn1.put("HIS_LST_DTM", last_dt);
		idoIn1.put("HIS_LST_STTS", stts);
		idoIn1.put("HIS_LST_MSG", msg);
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("EVDC_DIV_CD", "10");
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
		idoIn1.put("EVDC_DIV_CD", "10");
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			BizLogUtil.error(this, "Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
			BizLogUtil.error(this, "Error Message::" + DomainUtil.getErrorMessage(idoOut1));
		}

		return idoOut1;

	}

	/**
	 * <pre>
	 * 카드매출 입금내역 삭제
	 * </pre>
	 * 
	 * @param idoCon
	 * @param use_intt_id
	 * @param startDate
	 * @param endDate
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void deleteRcvDtlsData(JexConnection idoCon, String use_intt_id, String startDate, String endDate)
			throws JexException, JexBIZException {

		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("CARD_SEL_RCV_HSTR_D002");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("START_DT", startDate);
		idoIn1.put("END_DT", endDate);
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1))
			throw new JexTransactionRollbackException(idoOut1);
	}
}
