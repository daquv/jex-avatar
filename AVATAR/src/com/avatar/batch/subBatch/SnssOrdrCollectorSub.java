package com.avatar.batch.subBatch;

import java.io.IOException;

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
 * 쇼핑몰(배달앱) 주문내역  조회 서브
 *
 * @author won
 *
 */
public class SnssOrdrCollectorSub extends BatchServiceBiz {

	private static final String job_id = "GET_SNSS_ORDR";
	BatchExecVO batchvo = new BatchExecVO();

	@Override
	public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {

		BizLogUtil.debug(this, "execute", "Input :: " + input.toJSONString());

		String use_intt_id = input.getString("USE_INTT_ID");

		batchvo.setJob_id(job_id);
		batchvo.setUse_intt_id(use_intt_id);

		// 기관 사업자 번호
		String bsnn_no = use_intt_id;
		
		JexDataList<JexData> evdc_data = getEvdcSeupInfmData(use_intt_id);
		
		for (JexData shopInfo : evdc_data) {
			// 주문내역 등록
			insSnssOrdrHstr(shopInfo, use_intt_id, bsnn_no);
		}

		batchvo.setTotl_cnt(batchvo.getNor_cnt() + batchvo.getEtc_cnt() + batchvo.getErr_cnt());
		batchvo.setJob_end_tm(SvcDateUtil.getShortTimeString());
		batchvo.EndBatch();
		batchExecLogInsert(batchvo);

		return null;
	}

	/**
	 * <pre>
	 * 쇼핑몰(배달앱) 주문내역 조회
	 * </pre>
	 *
	 * @param shop_info
	 * @param use_intt_id
	 * @param bsnn_no
	 * @param search_gubun
	 * @throws JexException
	 * @throws JexBIZException
	 * @throws IOException
	 */
	private void insSnssOrdrHstr(JexData shop_info, String use_intt_id, String bsnn_no)
			throws JexException, JexBIZException, IOException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();

		String shopCd = StringUtil.null2void(shop_info.getString("SHOP_CD")); 		// 쇼핑몰코드
		String subShopCd = StringUtil.null2void(shop_info.getString("SUB_SHOP_CD"));// 보조쇼핑몰코드
		String webId = StringUtil.null2void(shop_info.getString("WEB_ID"));			// 로그인아이디
		
		String startDate = StringUtil.null2void(shop_info.getString("HIS_LST_DTM"));
		// 거래상태 변경 여부 반영을 위해 조회할때마다 3일치씩 조회(ex.완료 -> 취소)
		if (!"".equals(startDate)) {
			startDate = SvcDateUtil.getInstance().getDate(startDate.substring(0, 8) ,-3, 'D');
		}
		String endDate = SvcDateUtil.getInstance().getDate(-1, 'D');
		
		// 실시간조회로 최종조회일자가 조회시점의 당일로 저장되면서,
		// 조회시작일자가 조회종료일자보다 이후이면 초기조회조건으로 변경(재조회 성격으로, 혹시나 빠진 거래에 대한 대비책으로...)
		if (!"".equals(startDate) && SvcDateUtil.getInstance().days_between(startDate.substring(0, 8), endDate) <= 0) {
			startDate = "";
		}

		// 최초조회 3개월
		if ("".equals(startDate)) {
			startDate = SvcDateUtil.getInstance().getDate(-3, 'M');
		} else {
			startDate = SvcDateUtil.getInstance().getDate(startDate.substring(0, 8), 1, 'D');
		}

		// 쇼핑몰(배달앱) 판매자 주문 내역 조회
		JSONObject resData = CooconApiMgnt.data_wapi_0130(bsnn_no, shopCd, subShopCd, webId, startDate, endDate, "1", "99999");
		
		if (!"00000000".equals(resData.getString("ERRCODE")) && !"42110000".equals(resData.getString("ERRCODE"))) {
			// 최종조회일시, 상태 업데이트
			if("".equals(StringUtil.null2void(shop_info.getString("HIS_LST_DTM")))) {
				updEvdcSeupInfm(use_intt_id, shopCd, subShopCd, SvcDateUtil.getInstance().getDate(startDate, -1, 'D'), resData.getString("ERRCODE"), resData.getString("ERRMSG"));
			}else {
				// 최종조회일시로부터 -3일 +2일(업데이트 되는 최종조회일시는 -1일)
				updEvdcSeupInfm(use_intt_id, shopCd, subShopCd, SvcDateUtil.getInstance().getDate(startDate, 2, 'D'), resData.getString("ERRCODE"), resData.getString("ERRMSG"));
			}
			batchvo.setProc_stts(resData.getString("ERRCODE"));
			batchvo.setProc_rslt_ctt(resData.getString("ERRMSG"));
			batchvo.addErrCnt(1);
			return;
		}

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
				if(!"".equals(StringUtil.null2void(shop_info.getString("HIS_LST_DTM")))) {
					// 최종조회일시로부터 -3일 +2일(업데이트 되는 최종조회일시는 -1일)
					rsltDt = SvcDateUtil.getInstance().getDate(startDate, 2, 'D');
				}
				break;
			}
			// 거래결과가 없습니다. : 거래 결과가 없음.(정상거래)
			else if ("42110000".equals(rsltCd)) {
				batchvo.addNorCnt(1);
				rsltCd = "0000";
				break;
			}
			// 오류인 경우
			else if (!"00000000".equals(rsltCd)) {
				batchvo.addErrCnt(1);
				rsltDt = SvcDateUtil.getInstance().getDate(startDate, -1, 'D');
				if(!"".equals(StringUtil.null2void(shop_info.getString("HIS_LST_DTM")))) {
					// 최종조회일시로부터  -3일 +2일(업데이트 되는 최종조회일시는 -1일)
					rsltDt = SvcDateUtil.getInstance().getDate(startDate, 2, 'D');
				}
				break;
			}

			// 기존 등록된 데이타가 있으면 삭제.
			deleteSnssOrdrHstrData(idoCon, use_intt_id, shopCd, subShopCd, webId, startDate, endDate);

			JSONArray hstr_data = resp_data.getJSONArray("HSTR_DATA");
			JexDataList<JexData> insertData = new JexDataRecordList<JexData>();
			JSONObject hstrData = null;

			for (int i = 0; i < hstr_data.size(); i++) {
				hstrData = (JSONObject) hstr_data.get(i);
				insertData.add(insertSnssOrdrHstrData(hstrData, use_intt_id, shopCd, subShopCd, webId));
			}

			JexDataList<JexData> idoOutBatch = idoCon.executeBatch(insertData);

			if (DomainUtil.isError(idoOutBatch)) {
				throw new JexTransactionRollbackException(idoOutBatch);
			}else {
				batchvo.addNorCnt(1);
				rsltCd = "0000";
			}
		}
		updEvdcSeupInfm(use_intt_id, shopCd, subShopCd, rsltDt, rsltCd, rsltMsg);
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
	 * @param shop_cd
	 * @param sub_shop_cd
	 * @param web_id
	 * @param startDate
	 * @param endDate
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void deleteSnssOrdrHstrData(JexConnection idoCon, String use_intt_id,
			String shop_cd, String sub_shop_cd, String web_id, String startDate, String endDate) throws JexException, JexBIZException {
		
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		// 온라인매출주문내역 삭제
		JexData idoIn1 = util.createIDOData("SNSS_ORDR_HSTR_D001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("SHOP_CD", shop_cd);
		idoIn1.put("SUB_SHOP_CD", sub_shop_cd);
		idoIn1.put("WEB_ID", web_id);
		idoIn1.put("START_DT", startDate);
		idoIn1.put("END_DT", endDate);
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1))
			throw new JexTransactionRollbackException(idoOut1);

	}

	/**
	 * <pre>
	 * 온라인 매출주문내역 등록
	 * </pre>
	 *
	 * @param hstrData
	 * @param use_intt_id
	 * @param shop_cd
	 * @param sub_shop_cd
	 * @param web_id
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JexData insertSnssOrdrHstrData(JSONObject hstrData, String use_intt_id, String shop_cd, String sub_shop_cd, String web_id)
				throws JexException, JexBIZException {
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		// 온라인매출주문내역 등록
		JexData idoIn1 = util.createIDOData("SNSS_ORDR_HSTR_C001");
		
		idoIn1.put("USE_INTT_ID", use_intt_id);							// 이용기관아이디
		idoIn1.put("SHOP_CD", shop_cd);									// 쇼핑몰코드
		idoIn1.put("SUB_SHOP_CD", sub_shop_cd);							// 보조쇼핑몰코드
		idoIn1.put("WEB_ID", web_id);									// 로그인아이디
		idoIn1.put("ORDER_DATE", hstrData.getString("ORDER_DATE")); 	// 주문일자
		idoIn1.put("SEQ", hstrData.getString("SEQ")); 					// 일련번호
		idoIn1.put("ORDER_TIME", hstrData.getString("ORDER_TIME")); 	// 주문시각
		idoIn1.put("ORDER_NO", hstrData.getString("ORDER_NO")); 		// 주문번호
		idoIn1.put("TRAN_STS", hstrData.getString("TRAN_STS")); 		// 거래상태
		idoIn1.put("PAY_AMT", StringUtil.null2void(hstrData.getString("PAY_AMT"), "0")); 		   	// 결제금액
		idoIn1.put("PAY_TYPE", hstrData.getString("PAY_TYPE")); 								   	// 결제타입
		idoIn1.put("RECEIPT_METHOD", hstrData.getString("RECEIPT_METHOD")); 					   	// 수령방법
		idoIn1.put("PAY_METHOD", hstrData.getString("PAY_METHOD"));								   	// 결제방법
		idoIn1.put("DELIVERY_FEE", StringUtil.null2void(hstrData.getString("DELIVERY_FEE"), "0")); 	// 배달요금
		idoIn1.put("ORDER_AMT", StringUtil.null2void(hstrData.getString("ORDER_AMT"), "0")); 	  	// 주문금액
		idoIn1.put("SALE_1", hstrData.getString("SALE_1")); 									 	// 할인1
		idoIn1.put("SALE_2", hstrData.getString("SALE_2")); 										// 할인2
		idoIn1.put("COMPANY_NAME", hstrData.getString("COMPANY_NAME")); 							// 업체명
		idoIn1.put("COMPANY_CODE", hstrData.getString("COMPANY_CODE")); 							// 업체코드
		idoIn1.put("CONTACT", hstrData.getString("CONTACT")); 										// 연락처
		idoIn1.put("RECEIPT_WAY", hstrData.getString("RECEIPT_WAY")); 								// 접수수단
		idoIn1.put("JUNGSAN_AMT", StringUtil.null2void(hstrData.getString("JUNGSAN_AMT"), "0")); 	// 정산금액
		idoIn1.put("FEE", StringUtil.null2void(hstrData.getString("FEES"), "0")); 					// 수수료
		idoIn1.put("FEES_2", StringUtil.null2void(hstrData.getString("FEES_2"), "0")); 				// 수수료2
		idoIn1.put("VAT_AMT", StringUtil.null2void(hstrData.getString("VAT"), "0")); 				// 부가세
		idoIn1.put("REG_DATETIME", hstrData.getString("REG_DATETIME")); 							// 등록일시
		
		return idoIn1;
	}
	
	/**
	 * <pre>
	 * 최종조회일시 수정
	 * </pre>
	 *
	 * @param use_intt_id
	 * @param shop_cd
	 * @param sub_shop_cd
	 * @param last_dt
	 * @param stts
	 * @param msg
	 * @param search_gubun
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void updEvdcSeupInfm(String use_intt_id, String shop_cd, String sub_shop_cd, String last_dt, String stts, String msg)
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

		IDODynamic dynamic = new IDODynamic();	
		dynamic.addSQL(", HIS_LST_DTM = '"+last_dt+"'");
		
		// 쇼핑몰 주문내역조회결과 수정
		JexData idoIn1 = util.createIDOData("EVDC_INFM_U017");
		
		idoIn1.put("HIS_LST_STTS", stts);
		idoIn1.put("HIS_LST_MSG", msg);
		idoIn1.put("DYNAMIC_0", dynamic);
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("EVDC_DIV_CD", "40");
		idoIn1.put("SHOP_CD", shop_cd);
		idoIn1.put("SUB_SHOP_CD", sub_shop_cd);

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
	private JexDataList<JexData> getEvdcSeupInfmData(String use_intt_id) throws JexException, JexBIZException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("EVDC_INFM_R001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("EVDC_DIV_CD", "40"); // 10:여신, 20:세금계산서, 21:현금영수증, 40:쇼핑몰
		JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			BizLogUtil.error(this, "Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
			BizLogUtil.error(this, "Error Message::" + DomainUtil.getErrorMessage(idoOut1));
			throw new JexBIZException(idoOut1);
		}

		return idoOut1;
	}
}
