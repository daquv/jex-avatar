package com.avatar.batch.subBatch;

import java.sql.SQLException;

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
import com.avatar.api.mgnt.CooconApiMgnt;
import com.avatar.batch.comm.BatchServiceBiz;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.CommUtil;
import com.avatar.comm.CommonErrorHandler;
import com.avatar.comm.SvcDateUtil;
import com.avatar.batch.vo.BatchExecVO;

/**
 * 매시간 현금영수증 매입 내역 조회 서브
 * 
 * @author won
 *
 */
public class CashRcptPerchaseRealTimeCollectorSub extends BatchServiceBiz {

	private static final String job_id = "GET_RT_CASH_RCPT_PRCHS";
	BatchExecVO batchvo = new BatchExecVO();

	@Override
	public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {

		BizLogUtil.debug(this, "execute", "Input :: " + input.toJSONString());

		String use_intt_id = input.getString("USE_INTT_ID");

		batchvo.setJob_id(job_id);
		batchvo.setUse_intt_id(use_intt_id);
		batchvo.addTotlCnt(1);

		JexConnection idoCon = JexConnectionManager.createIDOConnection();

		// 기관 사업자 번호
		String bsnn_no = getbsnnNo(use_intt_id);

		JexData evdc_data = getEvdcSeupInfmData(use_intt_id);

		String previous_month = SvcDateUtil.getInstance().getDate(-1, 'M').substring(0, 6);
		String startDate = "";
		String endDate = "";
		
		if (DomainUtil.getResultCount(evdc_data) == 1) {

			startDate = StringUtil.null2void(evdc_data.getString("BUY_HIS_LST_DTM"));
			endDate = SvcDateUtil.getInstance().getDate();

			// 실시간조회로 최종조회일자가 조회시점의 당일로 저장되면서,
			// 조회시작일자가 조회종료일자보다 이후이면 초기조회조건으로 변경(재조회 성격으로, 혹시나 빠진 거래에 대한 대비책으로...)
			if (!"".equals(startDate) && SvcDateUtil.getInstance().days_between(startDate.substring(0, 8), endDate) < 0) {
				startDate = previous_month + "01"; // 전월 1일
			}

			if (startDate.length() > 8) {
				startDate = startDate.substring(0, 8);
			}
			
			// 최초조회는 -3개월
			if(StringUtil.null2void(evdc_data.getString("BUY_HIS_LST_DTM")).equals("")) {
				startDate = SvcDateUtil.getInstance().getDate(-3, 'M');
				endDate = SvcDateUtil.getInstance().getDate(-2, 'D');
			}
						
			// 현금영수증 매입 내역
			JSONObject resData = CooconApiMgnt.data_wapi_0401(bsnn_no, "", "", startDate, endDate, "1", "99999");

			if (!"00000000".equals(resData.getString("ERRCODE"))) {
				// 최종조회일시, 상태 업데이트
				//updEvdcSeupInfm(use_intt_id, SvcDateUtil.getInstance().getDate(startDate, -1, 'D'),	resData.getString("ERRCODE"), resData.getString("ERRMSG"));
				// 최종상태 업데이트
				updEvdcSeupInfm(use_intt_id, resData.getString("ERRCODE"), resData.getString("ERRMSG"));
				// 매시간 현금영수증 매입조회 상태값 변경
				updateCustRtRcptBuyHisLst(idoCon, use_intt_id, resData.getString("ERRCODE"), resData.getString("ERRMSG"), SvcDateUtil.getInstance().getDate(startDate, -1, 'D'));
				batchvo.setProc_stts(resData.getString("ERRCODE"));
				batchvo.setProc_rslt_ctt(resData.getString("ERRMSG"));
				batchvo.addErrCnt(1);
				batchvo.setJob_end_tm(SvcDateUtil.getShortTimeString());
				batchvo.EndBatch();
				batchExecLogInsert(batchvo);
				return null;
			}

			// (0:최신거래내역순,1:과거거래내역순)
			String rsltCd = "0000";
			String rsltMsg = "";
			String rsltDt = endDate;

			if (resData.getJSONArray("RESP_DATA") != null) {

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
						break;
					}
					// 오류인 경우
					else if (!"00000000".equals(rsltCd)) {
						batchvo.addErrCnt(1);
						rsltDt = SvcDateUtil.getInstance().getDate(startDate, -1, 'D');
						break;
					}

					// 기존 등록된 데이타가 있으면 삭제.(조회기간동안 데이터 삭제)
					deleteRcptBuyPtclData(idoCon, use_intt_id, startDate, endDate);

					JSONArray hstr_data = resp_data.getJSONArray("HSTR_DATA"); // 카드사별 승인내역 반복부
					JexDataList<JexData> insertData = new JexDataRecordList<JexData>();
					JSONObject hstrData = null;

					for (int i = 0; i < hstr_data.size(); i++) {
						hstrData = (JSONObject) hstr_data.get(i);
						insertNowRcptBuyPtcl(idoCon, hstrData, use_intt_id);
					}

					batchvo.addNorCnt(1);
				}
			}

			// 오늘일자로 최종업데이트
			//updEvdcSeupInfm(use_intt_id, rsltDt, rsltCd, rsltMsg);	
			
			// 최종상태 업데이트
			updEvdcSeupInfm(use_intt_id, rsltCd, rsltMsg);
			
			// 매시간 현금영수증 매입조회 상태값 변경
			updateCustRtRcptBuyHisLst(idoCon, use_intt_id, rsltCd, rsltMsg, rsltDt);
			
			batchvo.setProc_stts(rsltCd);
			batchvo.setProc_rslt_ctt(rsltMsg);
			batchvo.setJob_end_tm(SvcDateUtil.getShortTimeString());
			batchvo.EndBatch();
			batchExecLogInsert(batchvo);
		}

		return null;
	}

	/**
	 * <pre>
	 * 매시간 현금영수증 매입조회 상태값 변경
	 * </pre>
	 * 
	 * @param idoCon
	 * @param use_intt_id
	 * @param errcode
	 * @param errmsg
	 * @param his_lst_dtm
	 * @throws JexBIZException
	 * @throws JexException
	 */
	private void updateCustRtRcptBuyHisLst(JexConnection idoCon, String use_intt_id,
			String errcode, String errmsg, String his_lst_dtm) throws JexBIZException, JexException {

		JexCommonUtil util = JexContext.getContext().getCommonUtil();
		
		JexData idoIn1 = util.createIDOData("CUST_RT_BACH_INFM_U001");
		idoIn1.put("HIS_LST_STTS", errcode);
		idoIn1.put("HIS_LST_MSG", errmsg);
		//idoIn1.put("HIS_LST_DTM", his_lst_dtm);
		idoIn1.put("HIS_LST_DTM", SvcDateUtil.getInstance().getDate() + SvcDateUtil.getShortTimeString());
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("EVDC_GB", "02");
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1))
			CommonErrorHandler.comHandler(idoOut1);
	}
	
	/**
	 * <pre>
	 * 기존 등록된 데이타 삭제
	 * </pre>
	 * 
	 * @param idoCon
	 * @param use_intt_id
	 * @param startDate
	 * @param endDate
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void deleteRcptBuyPtclData(JexConnection idoCon, String use_intt_id, String startDate, String endDate)
			throws JexException, JexBIZException {

		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("CASH_RCPT_BUY_HSTR_D001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("START_DT", startDate);
		idoIn1.put("END_DT", endDate);
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1))
			throw new JexTransactionRollbackException(idoOut1);
	}

	/**
	 * <pre>
	 * 매입내역 등록 - (중복데이타는 Skip 처리)
	 * </pre>
	 * 
	 * @param idoCon
	 * @param hstrData
	 * @param use_intt_id
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void insertNowRcptBuyPtcl(JexConnection idoCon, JSONObject hstrData, String use_intt_id)
			throws JexException, JexBIZException {
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("CASH_RCPT_BUY_HSTR_C001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("TRNS_DT", hstrData.getString("USED_DATE"));
		idoIn1.put("APV_NO", hstrData.getString("APPROVAL_CODE"));
		idoIn1.put("USE_DTTM", hstrData.getString("USED_DATE") + hstrData.getString("USED_TIME"));
		idoIn1.put("USER_NM", hstrData.getString("USER_NM"));
		idoIn1.put("TRNS_DIV", hstrData.getString("TRADE_GUBUN"));
		idoIn1.put("MEST_BIZ_NO", hstrData.getString("BRANCH_COMPNO"));
		idoIn1.put("MEST_NM", hstrData.getString("BRANCH_DESC"));
		idoIn1.put("MEST_TYP", hstrData.getString("PATTERN"));
		idoIn1.put("SPLY_AMT", StringUtil.null2void(hstrData.getString("VALUE_OF_SUPPLY"), "0"));
		idoIn1.put("VAT_AMT", StringUtil.null2void(hstrData.getString("TAX_AMOUNT"), "0"));
		idoIn1.put("SRV_FEE", StringUtil.null2void(hstrData.getString("SERVICE_CHARGE"), "0"));
		idoIn1.put("TOTL_AMT", StringUtil.null2void(hstrData.getString("SUM_AMOUNT"), "0"));
		idoIn1.put("SBTR_YN", hstrData.getString("SETTLEMENT_DATE"));
		idoIn1.put("RMRK", hstrData.getString("NOTE"));
		idoIn1.put("MEMO", "");

		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			SQLException exce = (SQLException) DomainUtil.getErrorTrace(idoOut1);

			// 정상
			if (exce.getSQLState().equals("23505")) {
				return;
			}
			// 오류
			else {
				throw new JexBIZException(idoOut1);
			}
		}
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

		if (last_dt.length() == 8) {
			last_dt = last_dt + SvcDateUtil.getShortTimeString();
		}

		JexData idoIn1 = util.createIDOData("EVDC_INFM_U003");
		idoIn1.put("BUY_HIS_LST_DTM", last_dt);
		idoIn1.put("BUY_HIS_LST_STTS", stts);
		idoIn1.put("BUY_HIS_LST_MSG", msg);
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("EVDC_DIV_CD", "21");
		JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			BizLogUtil.error(this, "Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
			BizLogUtil.error(this, "Error Message::" + DomainUtil.getErrorMessage(idoOut1));
			throw new JexBIZException(idoOut1);
		}

	}
	
	
	/**
	 * <pre>
	 * 최종상태값 수정
	 * </pre>
	 * 
	 * @param use_intt_id
	 * @param stts
	 * @param msg
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void updEvdcSeupInfm(String use_intt_id, String stts, String msg)
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
			dynamic.addSQL(", RT_BUY_HIS_LST_DTM = '"+SvcDateUtil.getInstance().getDate() + SvcDateUtil.getShortTimeString()+"'");
		}
		
		JexData idoIn1 = util.createIDOData("EVDC_INFM_U009");
		idoIn1.put("BUY_HIS_LST_STTS", stts);
		idoIn1.put("BUY_HIS_LST_MSG", msg);
		idoIn1.put("DYNAMIC_0", dynamic);
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("EVDC_DIV_CD", "21");
		JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);
		
		if (DomainUtil.isError(idoOut1)) {
			BizLogUtil.error(this, "Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
			BizLogUtil.error(this, "Error Message::" + DomainUtil.getErrorMessage(idoOut1));
			throw new JexBIZException(idoOut1);
		}
		
	}

	/**
	 * <pre>
	 * 증빙정보 조회
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
		idoIn1.put("EVDC_DIV_CD", "21"); // 21 현금 영수증
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			BizLogUtil.error(this, "Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
			BizLogUtil.error(this, "Error Message::" + DomainUtil.getErrorMessage(idoOut1));
			throw new JexBIZException(idoOut1);
		}

		return idoOut1;

	}
}
