package com.avatar.batch.subBatch;

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
 * 매시간 법인카드 승인내역조회 서브
 *
 * @author won
 *
 */
public class CorpCardApprovalRealTimeCollectorSub extends BatchServiceBiz {

	private final static String job_id = "GET_RT_CORP_CARD_APRV";
	BatchExecVO batchvo = new BatchExecVO();

	@Override
	public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {

		BizLogUtil.debug(this, "execute", "Input :: " + input.toJSONString());

		String use_intt_id = input.getString("USE_INTT_ID");

		batchvo.setJob_id(job_id);
		batchvo.setUse_intt_id(use_intt_id);

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		/**
		 * =======================================================
		 * 기관에 등록되어 있는 법인 카드 조회
		 * =======================================================
		 */

		JexDataList<JexData> cardList = getCardList(idoCon, util, use_intt_id);

		JexData cardInfo = null;
		String card_stts = "";

		String comp_idno = "";
		String bank_cd = "";
		String card_no = "";
		String appr_no = "";
		String start_date = "";
		String end_date = SvcDateUtil.getInstance().getDate();

		while (cardList.next()) {
			cardInfo = cardList.get();
			comp_idno = cardInfo.getString("BIZ_NO");
			card_no = cardInfo.getString("CARD_NO");
			card_stts = cardInfo.getString("CARD_STTS");
			bank_cd = cardInfo.getString("BANK_CD");
			start_date = StringUtil.null2void(cardInfo.getString("APV_HIS_LST_DTM")).trim();

			// 실시간조회로 최종조회일자가 조회시점의 당일로 저장되면서,
			// 조회시작일자가 조회종료일자보다 이후이면 초기조회조건으로 변경(재조회 성격으로, 혹시나 빠진 거래에 대한 대비책으로...)
			if (!"".equals(start_date) && SvcDateUtil.getInstance().days_between(start_date.substring(0, 8), end_date) < 0) {
				start_date = "";
			}
						
			if ("".equals(start_date)) {
				start_date = SvcDateUtil.getInstance().getDate(-3, 'M');
    		} else if("0".equals(card_stts) || "8".equals(card_stts)) {
    			//신규 및 재등록인 경우
    			start_date = SvcDateUtil.getInstance().getDate(-3, 'M');
    		} else {
				// BC카드일 경우(누락된 데이터가 있는 경우가 있어 -3일치 가져옴)
    			start_date = SvcDateUtil.getInstance().getDate(start_date.substring(0, 8), -3, 'D');
			} 

			String coo_bank_cd = "";

			if ("30000060".equals(bank_cd) || "30000061".equals(bank_cd) || "30000062".equals(bank_cd) || "30000063".equals(bank_cd) || "30000064".equals(bank_cd)) {
				coo_bank_cd = "006";
			} else {
				coo_bank_cd = bank_cd.substring(5);
			}

			JSONObject resData = CooconApiMgnt.data_wapi_0106(comp_idno, coo_bank_cd, card_no, appr_no, start_date,	end_date);

			String errcode = StringUtil.null2void(resData.getString("ERRCODE"));
			String errmsg = StringUtil.null2void(resData.getString("ERRMSG"));

			// 정상(00000000), 내역없음(42110000) 외 값은 오류
			if (!"00000000".equals(errcode) && !"42110000".equals(errcode)) {
				// 오류 처리
				//updateCardApvHisLst(use_intt_id, card_no, SvcDateUtil.getInstance().getDate(start_date, -1, 'D'), errcode, errmsg);
				// 최종상태 업데이트
				updateCardApvHisLst(use_intt_id, card_no, errcode, errmsg);
				// 매시간 법인카드 승인내역조회 상태값 변경
				updateCustRtCardApvHisLst(use_intt_id, errcode, errmsg, SvcDateUtil.getInstance().getDate(start_date, -1, 'D'));
				batchvo.addErrCnt(1);
				batchvo.setProc_stts(resData.getString("ERRCODE"));
				batchvo.setProc_rslt_ctt(resData.getString("ERRMSG"));
			} else {
				String apv_his_lst_dt = "";
				// 정상
				JSONArray arrRESP_DATA = resData.getJSONArray("RESP_DATA");

				String tranorder = resData.getString("TRANORDER");
				String apv_his_lst_stts = "";
				String apv_his_lst_msg = "";
				for (Object row : arrRESP_DATA) {
					JSONObject resp_data = (JSONObject) row;
					String det_code = resp_data.getString("DET_CODE");
					String det_msg = resp_data.getString("DET_MSG");

					batchvo.setProc_stts(det_code);
					batchvo.setProc_rslt_ctt(det_msg);

					apv_his_lst_msg = det_msg;
					apv_his_lst_dt = end_date;

					// WERR0006 쿠폰에서 정보 수집전에 호출 할경우 발생
					if ("WERR0006".equals(det_code)) {
						batchvo.addEtcCnt(1);
						apv_his_lst_stts = "0000";
						apv_his_lst_dt = SvcDateUtil.getInstance().getDate(start_date, -1, 'D');
						break;
					}

					// 거래내역 없음
					if ("42110000".equals(det_code)) {
						batchvo.addNorCnt(1);
						apv_his_lst_stts = "0000";
						break;
					}

					// 오루 발생
					if (!"00000000".equals(det_code)) {
						batchvo.addErrCnt(1);
						apv_his_lst_stts = det_code;
						apv_his_lst_dt = SvcDateUtil.getInstance().getDate(start_date, -1, 'D');
						break;
					}

					// 기존 등록된 데이타가 있으면 삭제.
					deleteApvHisData(idoCon, use_intt_id, bank_cd, card_no, start_date, end_date);

					JSONArray arrHSTR_DATA = resp_data.getJSONArray("HSTR_DATA");

					JexDataList<JexData> insertData = new JexDataRecordList<JexData>();
					JSONObject hstr_data = null;
					// 0:최신거래내역순,1:과거거래내역순
					if ("0".equals(tranorder)) {
						for (int i = arrHSTR_DATA.size(); i >= 0; i--) {
							hstr_data = arrHSTR_DATA.getJSONObject(i);
							insertData.add(insertApvHisData(hstr_data, use_intt_id, bank_cd, card_no));
						}
					} else {
						for (int i = 0; i < arrHSTR_DATA.size(); i++) {
							hstr_data = arrHSTR_DATA.getJSONObject(i);
							insertData.add(insertApvHisData(hstr_data, use_intt_id, bank_cd, card_no));
						}
					}

					// 등록
					JexDataList<JexData> idoOutBatch = idoCon.executeBatch(insertData);
					if (DomainUtil.isError(idoOutBatch)) {
						throw new JexTransactionRollbackException(idoOutBatch);
					} else {
						batchvo.addNorCnt(1);
						apv_his_lst_stts = "0000";
					}
				}
				//updateCardApvHisLst(use_intt_id, card_no, apv_his_lst_dt, apv_his_lst_stts, apv_his_lst_msg);
				// 최종상태 업데이트
				updateCardApvHisLst(use_intt_id, card_no, apv_his_lst_stts, apv_his_lst_msg);
				// 매시간 법인카드 승인내역조회 상태값 변경
				updateCustRtCardApvHisLst(use_intt_id, apv_his_lst_stts, apv_his_lst_msg, apv_his_lst_dt);
				batchvo.setProc_stts(apv_his_lst_stts);
				batchvo.setProc_rslt_ctt(apv_his_lst_msg);
			}

		}

		batchvo.setTotl_cnt(batchvo.getNor_cnt() + batchvo.getEtc_cnt() + batchvo.getErr_cnt());
		batchvo.setJob_end_tm(SvcDateUtil.getShortTimeString());
		batchvo.EndBatch();
		batchExecLogInsert(batchvo);

		return null;
	}

	/**
	 * <pre>
	 * 매시간 법인카드 승인내역조회 상태값 변경
	 * </pre>
	 * 
	 * @param use_intt_id
	 * @param errcode
	 * @param errmsg
	 * @param his_lst_dtm
	 * @throws JexBIZException
	 * @throws JexException
	 */
	private void updateCustRtCardApvHisLst(String use_intt_id,
			String errcode, String errmsg, String his_lst_dtm) throws JexBIZException, JexException {
		
		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();
		
		JexData idoIn1 = util.createIDOData("CUST_RT_BACH_INFM_U001");
		idoIn1.put("HIS_LST_STTS", errcode);
		idoIn1.put("HIS_LST_MSG", errmsg);
		//idoIn1.put("HIS_LST_DTM", his_lst_dtm);
		idoIn1.put("HIS_LST_DTM", SvcDateUtil.getInstance().getDate() + SvcDateUtil.getShortTimeString());
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("EVDC_GB", "03");
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1))
			CommonErrorHandler.comHandler(idoOut1);
	}
	
	/**
	 * <pre>
	 * 기존 등록된 내역 삭제
	 * </pre>
	 *
	 * @param idoCon
	 * @param use_intt_id
	 * @param bank_cd
	 * @param card_no
	 * @param startDate
	 * @param endDate
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void deleteApvHisData(JexConnection idoCon, String use_intt_id, String bank_cd, String card_no,
			String startDate, String endDate) throws JexException, JexBIZException {

		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("CARD_BUY_APV_HSTR_D001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("BANK_CD"    , bank_cd);
		idoIn1.put("CARD_NO"    , card_no);
		idoIn1.put("START_DT"   , startDate);
		idoIn1.put("END_DT"     , endDate);
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1))
			throw new JexTransactionRollbackException(idoOut1);
	}

	/**
	 * <pre>
	 * 승인내역 등록
	 * </pre>
	 *
	 * @param data
	 * @param use_intt_id
	 * @param bank_cd
	 * @param card_no
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JexData insertApvHisData(JSONObject data, String use_intt_id, String bank_cd, String card_no)
			throws JexException, JexBIZException {
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn = util.createIDOData("CARD_BUY_APV_HSTR_C001");
		idoIn.put("USE_INTT_ID", use_intt_id);
		idoIn.put("BANK_CD"    , bank_cd);
		idoIn.put("CARD_NO"    , card_no);

		String strBuySum = data.getString("APPR_AMT");
		String strApvCanYn = "A";
		// 취소일자가 있다면 승인취소거래임
		if (!StringUtil.isBlank(data.getString("CANCEL_DATE"))) {
			strApvCanYn = "B";
			if (Float.parseFloat(strBuySum) > 0f) {
				strBuySum = "-" + strBuySum;
			}
		}

		idoIn.put("APV_DT"      , data.getString("APPR_DATE"));
		idoIn.put("APV_NO"      , data.getString("APPR_NO"));
		idoIn.put("APV_TM"      , data.getString("APPR_TIME"));
		idoIn.put("APV_CAN_YN"  , strApvCanYn);
		idoIn.put("APV_CAN_DT"  , data.getString("CANCEL_DATE"));
		idoIn.put("BUY_SUM"     , strBuySum);
		idoIn.put("CARD_KIND"   , data.getString("CARD_CLASS"));
		idoIn.put("PRD_DIV"     , "");
		idoIn.put("ITLM_MMS_CNT", data.getString("INSTALLMENT"));
		idoIn.put("MEST_NM"     , data.getString("BRANCH_DESC"));
		idoIn.put("MEST_BIZ_NO" , data.getString("BRANCH_COMP_IDNO"));
		idoIn.put("MEST_NO"     , data.getString("BRANCH_NO"));
		idoIn.put("MEST_TYPE"   , data.getString("BRANCH_TYPE"));
		idoIn.put("MEST_ADDR_1" , data.getString("BRANCH_ADDR1"));
		idoIn.put("MEST_ADDR_2" , data.getString("BRANCH_ADDR2"));
		idoIn.put("AREA_DIV"    , data.getString("APPR_AREA"));
		idoIn.put("SETL_SCHE_DT", data.getString("PAYMENT_DATE"));
		idoIn.put("BUY_YN"      , data.getString("PURCHASE_TYPE"));
		idoIn.put("DEPT_NM"     , data.getString("POST_DESC"));
		idoIn.put("BANK_NM"     , data.getString("BANK_DESC"));
		idoIn.put("CURR_CD"     , data.getString("CURRENCY"));
		idoIn.put("CARDNOTYPE"  , data.getString("CARD_NO_TYPE"));
		idoIn.put("BIZ_TYPE_CD" , "");
		idoIn.put("REGR_ID"     , "SYSTEM");
		idoIn.put("REG_DTM"     , SvcDateUtil.getInstance().getDate("yyyymmddhh24miss"));

		return idoIn;
	}

	/**
	 * <pre>
	 * 최종조회일시 수정
	 * </pre>
	 *
	 * @param use_intt_id
	 * @param card_no
	 * @param card_stts
	 * @param apv_his_lst_stts
	 * @param apv_his_lst_msg
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void updateCardApvHisLst(String use_intt_id, String card_no,
			String apv_his_lst_stts, String apv_his_lst_msg) throws JexException, JexBIZException {
		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		IDODynamic dynamic = new IDODynamic();	
		// 정상인 경우
		if ("0000".equals(apv_his_lst_stts)) {
			dynamic.addSQL(", RT_APV_HIS_LST_DTM = '"+SvcDateUtil.getInstance().getDate() + SvcDateUtil.getShortTimeString()+"'");
		}
		
		JexData idoIn1 = util.createIDOData("CARD_INFM_U007");
		idoIn1.put("USE_INTT_ID"     , use_intt_id);
		idoIn1.put("CARD_NO"         , card_no);
		idoIn1.put("CARD_STTS"       , "1");
		idoIn1.put("APV_HIS_LST_STTS", apv_his_lst_stts);
		idoIn1.put("APV_HIS_LST_MSG" , apv_his_lst_msg);
		idoIn1.put("DYNAMIC_0", dynamic);
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			BizLogUtil.error(this, "Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
			BizLogUtil.error(this, "Error Message::" + DomainUtil.getErrorMessage(idoOut1));
		}
	}

	/**
	 * <pre>
	 * 조회대상 카드목록 조회
	 * </pre>
	 *
	 * @param idoCon
	 * @param util
	 * @param use_intt_id
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JexDataList<JexData> getCardList(JexConnection idoCon, JexCommonUtil util, String use_intt_id)
			throws JexException, JexBIZException {

		JexData idoIn1 = util.createIDOData("CARD_INFM_R003");
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
