package com.avatar.batch.subBatch;

import java.sql.SQLException;

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

public class AccountDetailsRealTimeCollectorSub extends BatchServiceBiz {

	private static final String job_id = "GET_ACCT_RT_TRNS_HSTR";
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
		 * 등록된 계좌의 거래내역 조회 상테
		 * 확인 신규계좌 있음, 거래내역 조회 상태 오류코드 있음 (계좌별 조회) 신규계좌 엄음, 
		 * 거래내역 조회 상태 모두 정상 (기관전체 조회)
		 * =========================================================
		 */

		// 신규계좌 나 오류 계좌 있는지 확인 후 기관별, 계좌 별 조회 결정
		if (newErrAcctList(idoCon, util, use_intt_id)) {
			// 계좌별 거래내역 조회
			acctTrnsHisReg_acct(idoCon, util, use_intt_id, bsnn_no);
		}
		// 기관 단위 조회
		else {
			// 이용기관별 계좌거래내역 조회 - 전계좌
			acctTrnsHisReg_intt(idoCon, util, use_intt_id, bsnn_no);
		}

		return null;
	}

	/**
	 * <pre>
	 * 이용기관별 계좌거래내역 조회 - 전계좌
	 * </pre>
	 * 
	 * @param idoCon
	 * @param util
	 * @param use_intt_id
	 * @param bsnn_no
	 * @throws JexBIZException
	 * @throws JexException
	 */
	private void acctTrnsHisReg_intt(JexConnection idoCon, JexCommonUtil util, String use_intt_id, String bsnn_no)
			throws JexBIZException, JexException {

		// 조회대상 계좌건수 조회 - 조회대상 건수가 0건이면 쿠콘조회 하지 않음.
		// 정상적인 계좌만 있을경우에만 쿠콘조회하기 위해(미등록, 삭제 계좌 제외하기 위함)
		if (getAcctCount(idoCon, util, use_intt_id) == 0) {
			return;
		}

		String startDate = SvcDateUtil.getInstance().getDate(-1, 'D');
		String endDate = SvcDateUtil.getInstance().getDate();

		if (startDate.length() > 8) {
			startDate = startDate.substring(0, 8);
		}

		// 매시간 계좌 거래내역 조회
		JSONObject resData = CooconApiMgnt.data_wapi_0109("", "", bsnn_no, startDate, endDate, "1", "99999");

		if (!"00000000".equals(resData.getString("ERRCODE"))) {
			// 이용기관별 전계좌 계좌거래내역 수정
			updateAcctHisLstIntt(idoCon, util, use_intt_id, resData.getString("ERRCODE"), resData.getString("ERRMSG"));
			//updateAcctHisLstIntt(idoCon, util, use_intt_id, resData.getString("ERRCODE"), resData.getString("ERRMSG"), startDate);
			// 계좌 매시간 거래내역조회 상태값 변경
			updateCustRtAcctHisLstAcct(idoCon, util, use_intt_id, resData.getString("ERRCODE"), resData.getString("ERRCODE"), startDate);
			batchvo.setProc_stts(resData.getString("ERRCODE"));
			batchvo.setProc_rslt_ctt(resData.getString("ERRMSG"));
			batchvo.addErrCnt(getAcctCount(idoCon, util, use_intt_id));
			batchvo.setTotl_cnt(batchvo.getNor_cnt() + batchvo.getEtc_cnt() + batchvo.getErr_cnt());
			batchvo.setJob_end_tm(SvcDateUtil.getShortTimeString());
			batchvo.EndBatch();
			batchExecLogInsert(batchvo);
			return;
		}

		String tranorder = resData.getString("TRANORDER"); // 거래순서 (0:최신거래내역순,1:과거거래내역순)
		JSONArray resp_data = resData.getJSONArray("RESP_DATA");

		String rsltCd = "0000";
		String rsltMsg = "";
		String his_lst_dtm = endDate;
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
				his_lst_dtm = startDate;
				rsltCd = "0000";
				updateAcctHisLstAcct(idoCon, util, use_intt_id, fnnc_unq_no, rsltCd, rsltMsg);
				//updateAcctHisLstAcct(idoCon, util, use_intt_id, fnnc_unq_no, rsltCd, rsltMsg, his_lst_dtm);
				// 계좌 매시간 거래내역조회 상태값 변경
				updateCustRtAcctHisLstAcct(idoCon, util, use_intt_id, rsltCd, rsltMsg, his_lst_dtm);
				continue;
			}
			// 거래결과가 없습니다. : 카드사 사이트에 거래 결과가 없음.(정상거래)
			else if ("42110000".equals(rsltCd)) {
				batchvo.addNorCnt(1);
				rsltCd = "0000";
				updateAcctHisLstAcct(idoCon, util, use_intt_id, fnnc_unq_no, rsltCd, rsltMsg);
				//updateAcctHisLstAcct(idoCon, util, use_intt_id, fnnc_unq_no, rsltCd, rsltMsg, his_lst_dtm);
				// 계좌 매시간 거래내역조회 상태값 변경
				updateCustRtAcctHisLstAcct(idoCon, util, use_intt_id, rsltCd, rsltMsg, his_lst_dtm);
				continue;
			}
			// 오류인 경우
			else if (!"00000000".equals(rsltCd)) {
				batchvo.addErrCnt(1);
				his_lst_dtm = startDate;
				updateAcctHisLstAcct(idoCon, util, use_intt_id, fnnc_unq_no, rsltCd, rsltMsg);
				//updateAcctHisLstAcct(idoCon, util, use_intt_id, fnnc_unq_no, rsltCd, rsltMsg, his_lst_dtm);
				// 계좌 매시간 거래내역조회 상태값 변경
				updateCustRtAcctHisLstAcct(idoCon, util, use_intt_id, rsltCd, rsltMsg, his_lst_dtm);
				continue;
			}

			rsltCd = "0000";

			JSONObject hstrData = null;
			JSONArray hstr_data = respData.getJSONArray("HSTR_DATA"); // 카드사별 청구내역 반복부

			String trandate = "";
			String be_trandate = "";
			int trns_srno = 0;
			String cur_amt = "";

			// 최신거래내역순
			if ("0".equals(tranorder)) {
				for (int j = hstr_data.size() - 1; j >= 0; j--) {
					hstrData = hstr_data.getJSONObject(j);

					trandate = hstrData.getString("TRANDATE");
					cur_amt = hstrData.getString("REMAINAMT");

					if (be_trandate.equals(trandate)) {
						trns_srno++;
					} else {
						trns_srno = 1;
					}

					// 계좌 거래내역 등록
					inertHisData(idoCon, util, use_intt_id, fnnc_unq_no, String.valueOf(trns_srno), trandate, hstrData);

					// 거래 일자
					be_trandate = trandate;

				}
			}
			// 과거거래내역순
			else {
				for (int j = 0; j < hstr_data.size(); j++) {
					hstrData = hstr_data.getJSONObject(j);

					trandate = hstrData.getString("TRANDATE");
					cur_amt = hstrData.getString("REMAINAMT");

					if (be_trandate.equals(trandate)) {
						trns_srno++;
					} else {
						trns_srno = 1;
					}

					// 계좌 거래내역 등록
					inertHisData(idoCon, util, use_intt_id, fnnc_unq_no, String.valueOf(trns_srno), trandate, hstrData);

					// 거래 일자
					be_trandate = trandate;
				}
			}

			batchvo.addNorCnt(1);

			// 잔액 변경
			updateAcctCurAmt(idoCon, util, use_intt_id, fnnc_unq_no, cur_amt);
			// 계좌별 최종상태값 수정
			updateAcctHisLstAcct(idoCon, util, use_intt_id, fnnc_unq_no, rsltCd, rsltMsg);
			// 계좌별 최종조회일시 수정
			//updateAcctHisLstAcct(idoCon, util, use_intt_id, fnnc_unq_no, rsltCd, rsltMsg, his_lst_dtm);
			// 계좌 매시간 거래내역조회 상태값 변경
			updateCustRtAcctHisLstAcct(idoCon, util, use_intt_id, rsltCd, rsltMsg, his_lst_dtm);
		}
		
		batchvo.setTotl_cnt(batchvo.getNor_cnt() + batchvo.getEtc_cnt() + batchvo.getErr_cnt());
		batchvo.setJob_end_tm(SvcDateUtil.getShortTimeString());
		batchvo.EndBatch();
		batchExecLogInsert(batchvo);
	}

	/**
	 * <pre>
	 * 계좌별 거래내역 조회
	 * </pre>
	 * 
	 * @param idoCon
	 * @param util
	 * @param use_intt_id
	 * @param bsnn_no
	 * @throws JexBIZException
	 * @throws JexException
	 */
	private void acctTrnsHisReg_acct(JexConnection idoCon, JexCommonUtil util, String use_intt_id, String bsnn_no)
			throws JexBIZException, JexException {

		/**
		 * ========================================================= 
		 * 거래내역 조회 할 계좌 정보 조회
		 * =========================================================
		 */

		JexData idoIn1 = util.createIDOData("ACCT_INFM_R007");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			CommonErrorHandler.comHandler(idoOut1);
		}

		String startDate = "";
		String endDate = SvcDateUtil.getInstance().getDate();
		
		for (JexData acctInfo : idoOut1) {

			startDate = acctInfo.getString("HIS_LST_DTM");
			if ("0".equals(acctInfo.getString("ACCT_STTS")) || "8".equals(acctInfo.getString("ACCT_STTS")) || "".equals(startDate)) {
				startDate = SvcDateUtil.getInstance().getDate(-3, 'M');
			}

			if (startDate.length() > 8) {
				startDate = startDate.substring(0, 8);
			}

			// 매시간 조회 전문 호출
			JSONObject resData = CooconApiMgnt.data_wapi_0109(acctInfo.getString("BANK_CD"), acctInfo.getString("FNNC_INFM_NO"), bsnn_no, startDate, endDate, "1", "99999");

			if (!"00000000".equals(resData.getString("ERRCODE"))) {
				//계좌별 최종상태값 수정
				updateAcctHisLstAcct(idoCon, util, use_intt_id, acctInfo.getString("FNNC_UNQ_NO"), resData.getString("ERRCODE"), resData.getString("ERRMSG"));
				//계좌별 최종조회일시 수정
				//updateAcctHisLstAcct(idoCon, util, use_intt_id, acctInfo.getString("FNNC_UNQ_NO"), resData.getString("ERRCODE"), resData.getString("ERRMSG"), startDate);
				// 계좌 매시간 거래내역조회 상태값 변경
				updateCustRtAcctHisLstAcct(idoCon, util, use_intt_id, resData.getString("ERRCODE"), resData.getString("ERRCODE"), startDate);
				batchvo.addErrCnt(1);
				batchvo.setProc_stts(resData.getString("ERRCODE"));
				batchvo.setProc_rslt_ctt(resData.getString("ERRMSG"));				
				continue;
			}

			String tranorder = resData.getString("TRANORDER"); // 거래순서 (0:최신거래내역순,1:과거거래내역순)
			JSONArray resp_data = resData.getJSONArray("RESP_DATA");

			String rsltCd = "0000";
			String rsltMsg = "";
			String his_lst_dtm = endDate;
			String cur_amt = "";
			for (Object resp : resp_data) {
				JSONObject respData = (JSONObject) resp;
				rsltCd = respData.getString("DET_CODE"); // 결과코드
				rsltMsg = respData.getString("DET_MSG"); // 결과메시지

				batchvo.setProc_stts(rsltCd);
				batchvo.setProc_rslt_ctt(rsltMsg);

				if ("WERR0006".equals(rsltCd)) {
					batchvo.addEtcCnt(1);
					rsltCd = "0000";
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
					his_lst_dtm = startDate;
					break;
				}

				rsltCd = "0000";

				JSONObject hstrData = null;
				JSONArray hstr_data = respData.getJSONArray("HSTR_DATA"); // 카드사별 청구내역 반복부

				String trandate = "";
				String be_trandate = "";
				int trns_srno = 0;

				// 최신거래내역순
				if ("0".equals(tranorder)) {
					for (int j = hstr_data.size() - 1; j >= 0; j--) {
						hstrData = hstr_data.getJSONObject(j);

						trandate = hstrData.getString("TRANDATE");
						cur_amt = hstrData.getString("REMAINAMT");

						if (be_trandate.equals(trandate)) {
							trns_srno++;
						} else {
							trns_srno = 1;
						}

						// 계좌 거래내역 등록
						inertHisData(idoCon, util, use_intt_id, acctInfo.getString("FNNC_UNQ_NO"), String.valueOf(trns_srno), trandate, hstrData);

						// 거래 일자
						be_trandate = trandate;

					}
				}
				// 과거거래내역순
				else {
					for (int j = 0; j < hstr_data.size(); j++) {
						hstrData = hstr_data.getJSONObject(j);

						trandate = hstrData.getString("TRANDATE");
						cur_amt = hstrData.getString("REMAINAMT");
						if (be_trandate.equals(trandate)) {
							trns_srno++;
						} else {
							trns_srno = 1;
						}

						// 계좌 거래내역 등록
						inertHisData(idoCon, util, use_intt_id, acctInfo.getString("FNNC_UNQ_NO"), String.valueOf(trns_srno), trandate, hstrData);

						// 거래 일자
						be_trandate = trandate;
					}
				}

				batchvo.addNorCnt(1);
			}

			// 잔액 변경
			if (!"".equals(cur_amt)) {
				updateAcctCurAmt(idoCon, util, use_intt_id, acctInfo.getString("FNNC_UNQ_NO"), cur_amt);
			}

			// 계좌별 최종상태값 수정
			updateAcctHisLstAcct(idoCon, util, use_intt_id, acctInfo.getString("FNNC_UNQ_NO"), rsltCd, rsltMsg);
			
			// 계좌별 최종조회일시 수정
			//updateAcctHisLstAcct(idoCon, util, use_intt_id, acctInfo.getString("FNNC_UNQ_NO"), rsltCd, rsltMsg,	his_lst_dtm);
			
			// 계좌 매시간 거래내역조회 상태값 변경
			updateCustRtAcctHisLstAcct(idoCon, util, use_intt_id, rsltCd, rsltMsg, his_lst_dtm);
		}
		
				
		batchvo.setTotl_cnt(batchvo.getNor_cnt() + batchvo.getEtc_cnt() + batchvo.getErr_cnt());
		batchvo.setJob_end_tm(SvcDateUtil.getShortTimeString());
		batchvo.EndBatch();
		batchExecLogInsert(batchvo);
	}

	/**
	 * <pre>
	 * 계좌거래내역 등록
	 * </pre>
	 * 
	 * @param idoCon
	 * @param util
	 * @param use_intt_id
	 * @param fnnc_unq_no
	 * @param trns_srno
	 * @param trns_dt
	 * @param hstrData
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void inertHisData(JexConnection idoCon, JexCommonUtil util, String use_intt_id, String fnnc_unq_no,
			String trns_srno, String trns_dt, JSONObject hstrData) throws JexException, JexBIZException {

		JexData idoIn1 = util.createIDOData("ACCT_TRNS_HSTR_C001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("FNNC_UNQ_NO", fnnc_unq_no);
		idoIn1.put("TRNS_DT", trns_dt);
		idoIn1.put("TRNS_SRNO", trns_srno);

		String inot_dsnc = "";
		String trans_amt = "";
		// 출금 금액이 0이면 입금 정보
		if ("0".equals(StringUtil.null2void(hstrData.getString("OUTAMT"), "0"))) {
			inot_dsnc = "1";
			trans_amt = hstrData.getString("INAMT");
		} else {
			inot_dsnc = "2";
			trans_amt = hstrData.getString("OUTAMT");
		}

		idoIn1.put("INOT_DSNC", inot_dsnc);
		idoIn1.put("TRNS_AMT", trans_amt);
		idoIn1.put("BAL_AMT", hstrData.getString("REMAINAMT"));
		idoIn1.put("TRNS_TIME", hstrData.getString("TRANTIME"));
		idoIn1.put("SMR", hstrData.getString("REMARK1"));
		idoIn1.put("SMR2", hstrData.getString("REMARK2"));
		idoIn1.put("TRNS_MENZ", hstrData.getString("REMARK3"));
		idoIn1.put("TRNS_MENZ2", hstrData.getString("REMARK4"));
		idoIn1.put("REGR_ID", "SYSTEM");
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			SQLException exce = (SQLException) DomainUtil.getErrorTrace(idoOut1);

			// 정상
			if (exce.getSQLState().equals("23505")) {
				BizLogUtil.debug(this, " 23505 : " + hstrData.toJSONString());
			}
			// 오류
			else {
				throw new JexBIZException(idoOut1);
			}
		}
	}

	/**
	 * <pre>
	 * 계좌 매시간 거래내역조회 상태값 변경
	 * </pre>
	 * 
	 * @param idoCon
	 * @param util
	 * @param use_intt_id
	 * @param errcode
	 * @param errmsg
	 * @param his_lst_dtm
	 * @throws JexBIZException
	 * @throws JexException
	 */
	private void updateCustRtAcctHisLstAcct(JexConnection idoCon, JexCommonUtil util, String use_intt_id,
			String errcode, String errmsg, String his_lst_dtm) throws JexBIZException, JexException {

		JexData idoIn1 = util.createIDOData("CUST_RT_BACH_INFM_U001");
		idoIn1.put("HIS_LST_STTS", errcode);
		idoIn1.put("HIS_LST_MSG", errmsg);
		//idoIn1.put("HIS_LST_DTM", his_lst_dtm);
		idoIn1.put("HIS_LST_DTM", SvcDateUtil.getInstance().getDate() + SvcDateUtil.getShortTimeString());
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("EVDC_GB", "01");
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1))
			CommonErrorHandler.comHandler(idoOut1);
	}
	
	/**
	 * <pre>
	 * 계좌별 최종상태값 수정
	 * </pre>
	 * 
	 * @param idoCon
	 * @param util
	 * @param use_intt_id
	 * @param fnnc_unq_no
	 * @param errcode
	 * @param errmsg
	 * @throws JexBIZException
	 * @throws JexException
	 */
	private void updateAcctHisLstAcct(JexConnection idoCon, JexCommonUtil util, String use_intt_id, String fnnc_unq_no,
			String errcode, String errmsg) throws JexBIZException, JexException {
		
		IDODynamic dynamic = new IDODynamic();	
		// 정상인 경우
		if ("0000".equals(errcode)) {
			dynamic.addSQL(", RT_HIS_LST_DTM = '"+SvcDateUtil.getInstance().getDate() + SvcDateUtil.getShortTimeString()+"'");
		}
		// 매시간 거래내역조회 상태값 변경, 최종조회일시 수정안함.
		JexData idoIn1 = util.createIDOData("ACCT_INFM_U014");
		idoIn1.put("HIS_LST_STTS", errcode);
		idoIn1.put("HIS_LST_MSG", errmsg);
		idoIn1.put("DYNAMIC_0", dynamic);
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("FNNC_UNQ_NO", fnnc_unq_no);
		JexData idoOut1 = idoCon.execute(idoIn1);
		
		if (DomainUtil.isError(idoOut1))
			CommonErrorHandler.comHandler(idoOut1);
	}
	
	/**
	 * <pre>
	 * 이용기관별 계좌거래내역 수정 - 전계좌
	 * </pre>
	 * 
	 * @param idoCon
	 * @param util
	 * @param use_intt_id
	 * @param errcode
	 * @param errmsg
	 * @throws JexBIZException
	 * @throws JexException
	 */
	private void updateAcctHisLstIntt(JexConnection idoCon, JexCommonUtil util, String use_intt_id, String errcode,
			String errmsg) throws JexBIZException, JexException {
		
		IDODynamic dynamic = new IDODynamic();	
		// 정상인 경우
		if ("0000".equals(errcode)) {
			dynamic.addSQL(", RT_HIS_LST_DTM = '"+SvcDateUtil.getInstance().getDate() + SvcDateUtil.getShortTimeString()+"'");
		}
		
		// 매시간 거래내역조회 상태값 변경(기관별), 최종조회일시 수정안함.
		JexData idoIn1 = util.createIDOData("ACCT_INFM_U013");
		idoIn1.put("HIS_LST_STTS", errcode);
		idoIn1.put("HIS_LST_MSG", errmsg);
		idoIn1.put("DYNAMIC_0", dynamic);
		idoIn1.put("USE_INTT_ID", use_intt_id);
		JexData idoOut1 = idoCon.execute(idoIn1);
		
		if (DomainUtil.isError(idoOut1))
			CommonErrorHandler.comHandler(idoOut1);
	}

	/**
	 * 잔액 변경
	 * 
	 * @param idoCon
	 * @param util
	 * @param use_intt_id
	 * @param fnnc_unq_no
	 * @param cur_amt     잔액
	 * @throws JexBIZException
	 * @throws JexException
	 */
	private void updateAcctCurAmt(JexConnection idoCon, JexCommonUtil util, String use_intt_id, String fnnc_unq_no,
			String cur_amt) throws JexBIZException, JexException {

		JexData idoIn1 = util.createIDOData("ACCT_INFM_U004");
		idoIn1.put("CUR_AMT", cur_amt);
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("FNNC_UNQ_NO", fnnc_unq_no);
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
		idoIn1.put("ACCT_DV", "01");
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1))
			CommonErrorHandler.comHandler(idoOut1);

		return idoOut1.getString("FNNC_UNQ_NO");
	}

	/**
	 * <pre>
	 * 신규/오류 계좌목록 조회
	 * </pre>
	 * 
	 * @param idoCon
	 * @param util
	 * @param use_intt_id
	 * @return
	 * @throws JexBIZException
	 * @throws JexException
	 */
	private boolean newErrAcctList(JexConnection idoCon, JexCommonUtil util, String use_intt_id)
			throws JexBIZException, JexException {

		JexData idoIn1 = util.createIDOData("ACCT_INFM_R006");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			CommonErrorHandler.comHandler(idoOut1);
		}

		if ("0".equals(idoOut1.getString("CNT"))) {
			return false;
		} else {
			return true;
		}
	}

	/**
	 * <pre>
	 * 쿠콘 조회대상 계좌 건수조회
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

		JexData idoIn1 = util.createIDOData("ACCT_INFM_R009");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			CommonErrorHandler.comHandler(idoOut1);
		}

		return Integer.parseInt(StringUtil.null2void(idoOut1.getString("CNT"), "0"));
	}

}
