package com.avatar.batch.subBatch;

import java.io.IOException;
import java.util.HashMap;

import com.avatar.api.mgnt.CooconApiMgnt;
import com.avatar.api.mgnt.KakaoApiMgnt;
import com.avatar.batch.comm.BatchServiceBiz;
import com.avatar.batch.vo.BatchExecVO;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.CommonErrorHandler;
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
import jex.json.parser.JSONParser;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.util.DomainUtil;
import jex.util.StringUtil;
import jex.util.biz.JexCommonUtil;

/**
 * 매시간 전자세금계산서 조회 서브
 *
 * @author won
 *
 */
public class ETaxbillRealTimeCollectorSub extends BatchServiceBiz {

	private static final String job_id = "GET_RT_ELEC_TXBL";
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
			 * 매출 등록
			 * SEARCH_GUBUN => 5 매출(면세포함)
			 * ===================================================================
			 */

			insElecTxblPtcl(evdc_data, use_intt_id, bsnn_no, "5");

			/**
			 * ===================================================================
			 * 매입 등록
			 * SEARCH_GUBUN => 6 매입(면세포함)
			 * ===================================================================
			 */

			insElecTxblPtcl(evdc_data, use_intt_id, bsnn_no, "6");

		}

		batchvo.setTotl_cnt(batchvo.getNor_cnt() + batchvo.getEtc_cnt() + batchvo.getErr_cnt());
		batchvo.setJob_end_tm(SvcDateUtil.getShortTimeString());
		batchvo.EndBatch();
		batchExecLogInsert(batchvo);

		return null;
	}

	/**
	 * <pre>
	 * 매시간 전자세금계산서 상태값 변경
	 * </pre>
	 * 
	 * @param use_intt_id
	 * @param errcode
	 * @param errmsg
	 * @param his_lst_dtm
	 * @throws JexBIZException
	 * @throws JexException
	 */
	private void updateCustRtElecTxblHisLst(String use_intt_id,
			String errcode, String errmsg, String his_lst_dtm) throws JexBIZException, JexException {

		JexCommonUtil util = JexContext.getContext().getCommonUtil();
		
		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		
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
	 * 홈택스 매입/매출 내역 조회
	 * </pre>
	 *
	 * @param evdc_data
	 * @param use_intt_id
	 * @param bsnn_no
	 * @param search_gubun
	 * @throws JexException
	 * @throws JexBIZException
	 * @throws IOException
	 */
	private void insElecTxblPtcl(JexData evdc_data, String use_intt_id, String bsnn_no, String search_gubun)
			throws JexException, JexBIZException, IOException, Exception {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();

		String startDate = StringUtil.null2void(evdc_data.getString("HIS_LST_DTM"));
		String endDate = SvcDateUtil.getInstance().getDate();

		if ("6".equals(search_gubun)) {
			startDate = StringUtil.null2void(evdc_data.getString("BUY_HIS_LST_DTM"));
		}

		// 최초조회 1개월 -> 3개월로 변경
		if ("".equals(startDate)) {
			//startDate = SvcDateUtil.getInstance().getDate(-1, 'M');
			startDate = SvcDateUtil.getInstance().getDate(-3, 'M');
		} else {
			startDate = SvcDateUtil.getInstance().getDate(startDate.substring(0, 8), 1, 'D');
		}

		JSONObject resData = CooconApiMgnt.data_wapi_0403(bsnn_no, search_gubun, "", "", "3", startDate, endDate, "1", "99999");

		if (!"00000000".equals(resData.getString("ERRCODE"))) {
			// 최종조회일시, 상태 업데이트
			//updEvdcSeupInfm(use_intt_id, SvcDateUtil.getInstance().getDate(startDate, -1, 'D'), resData.getString("ERRCODE"), resData.getString("ERRMSG"), search_gubun);
			// 최종상태 업데이트
			updEvdcSeupInfm(use_intt_id, resData.getString("ERRCODE"), resData.getString("ERRMSG"), search_gubun);
			// 매시간 전자세금계산서 상태값 변경
			updateCustRtElecTxblHisLst(use_intt_id, resData.getString("ERRCODE"), resData.getString("ERRMSG"), SvcDateUtil.getInstance().getDate(startDate, -1, 'D'));
			batchvo.setProc_stts(resData.getString("ERRCODE"));
			batchvo.setProc_rslt_ctt(resData.getString("ERRMSG"));
			batchvo.addErrCnt(1);
			return;
		}

		String rsltCd = "0000";
		String rsltMsg = "";
		String rsltDt = endDate;

		HashMap hBzaqList = new HashMap();
		
		for (Object resp : resData.getJSONArray("RESP_DATA")) {
			JSONObject resp_data = (JSONObject) resp;

			rsltCd = resp_data.getString("DET_CODE"); // 결과코드
			rsltMsg = resp_data.getString("DET_MSG"); // 결과메시지

			// 오류인 경우 상세오류 조회
			if(!"00000000".equals(rsltCd) && !"42110000".equals(rsltCd)) {
				//매입		: PURC_RESULT_CD, PURC_RESULT_MSG
				//매입(면세)	: PURC_EXEM_RESULT_CD, PURC_EXEM_RESULT_MSG
				//매출		: SALES_RESULT_CD, SALES_RESULT_MSG
				//매출(면세)	: SALES_EXEM_RESULT_CD, SALES_EXEM_RESULT_MSG
				//공통		: DET_CODE, DET_MSG
				if ("6".equals(search_gubun)) {
					//매입, 매입면세
					rsltCd = resp_data.getString("PURC_RESULT_CD"); // 결과코드
					rsltMsg = resp_data.getString("PURC_RESULT_MSG"); // 결과메시지

					//매입 거래내역이 없으면, 매입면세 결과 조회
					if ("42110000".equals(rsltCd)) {
						rsltCd = resp_data.getString("PURC_EXEM_RESULT_CD"); // 결과코드
						rsltMsg = resp_data.getString("PURC_EXEM_RESULT_MSG"); // 결과메시지
					}
				} else {
					//매출, 매출면세
					rsltCd = resp_data.getString("SALES_RESULT_CD"); // 결과코드
					rsltMsg = resp_data.getString("SALES_RESULT_MSG"); // 결과메시지

					//매출 거래내역이 없으면, 매출면세 결과 조회
					if ("42110000".equals(rsltCd)) {
						rsltCd = resp_data.getString("SALES_EXEM_RESULT_CD"); // 결과코드
						rsltMsg = resp_data.getString("SALES_EXEM_RESULT_MSG"); // 결과메시지
					}
				}
			}

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

			// 기존 등록된 데이타가 있으면 삭제.
			deleteElecTxblPtclData(idoCon, use_intt_id, startDate, endDate, search_gubun);

			JSONArray hstr_data = resp_data.getJSONArray("HSTR_DATA");
			JexDataList<JexData> insertPtclData = new JexDataRecordList<JexData>();
			JexDataList<JexData> insertDtlsData = new JexDataRecordList<JexData>();
			JexDataList<JexData> insertBzaqData = new JexDataRecordList<JexData>();
			JSONObject hstrData = null;

			for (int i = 0; i < hstr_data.size(); i++) {
				hstrData = (JSONObject) hstr_data.get(i);
				
				addBzaqInfmData(hBzaqList, insertBzaqData, hstrData, use_intt_id, search_gubun) ; //등록할 거래처

				String IssuId = hstrData.getString("APPROVAL_CODE").replaceAll("-", "");
				insertPtclData.add(insertElecTxblPtclData(hstrData, use_intt_id, IssuId));

				if (hstrData.getJSONArray("DET_DATA") != null) {
					JSONObject det = null;
					for (Object detData : hstrData.getJSONArray("DET_DATA")) {
						det = (JSONObject) detData;
						insertDtlsData.add(insertElecTxblDtlsData(det, use_intt_id, IssuId));
					}
				}
			}

			idoCon.beginTransaction();

			JexDataList<JexData> idoOutPtclBatch = idoCon.executeBatch(insertPtclData);

			if (DomainUtil.isError(idoOutPtclBatch)) {
				insertDtlsData.close();
				throw new JexTransactionRollbackException(idoOutPtclBatch);
			}
			insertPtclData.close();

			BizLogUtil.debug(this, "dtls cnt >> " + insertDtlsData.toJSONString());

			JexDataList<JexData> idoOutdtlsBatch = idoCon.executeBatch(insertDtlsData);

			if (DomainUtil.isError(idoOutdtlsBatch)) {
				throw new JexTransactionRollbackException(idoOutdtlsBatch);
			} else {
				rsltCd = "0000";
			}

			batchvo.addNorCnt(1);

			//거래처정보등록/수정
			JexDataList<JexData> idoOutBzaqBatch = idoCon.executeBatch(insertBzaqData);
			idoOutBzaqBatch.close();

			//매출세금계산서의 공급자정보로 아바타 사업장정보를 등록한다. 
			if("5".equals(search_gubun) && hstr_data.size() > 0) {
				JSONObject hstr = (JSONObject) hstr_data.get(hstr_data.size()-1);
				
				//사업장 조회
				JexCommonUtil util = JexContext.getContext().getCommonUtil();
				JexData idoIn0 = util.createIDOData("INTT_INFM_R001");
				idoIn0.put("USE_INTT_ID", use_intt_id);
				JexData idoOut0 = idoCon.execute(idoIn0);
				
				if(StringUtil.isBlank(idoOut0.getString("BSNN_NM"))) {
					
					String latd  = "";	// 위도(y)
			       	String lotd  = "";	// 경도(x)
			       	String adrs = StringUtil.null2void(hstr.getString("PROVIDER_BUSINESS_PLACE"));
			       	
			       	// 주소가 있을 경우 위도, 경도 가져오기
			       	if(!adrs.equals("")){
					   	String jsonString =  KakaoApiMgnt.getCoordination(adrs);
				       	JSONParser parser = new JSONParser();
				       
				    	JSONObject json = ( JSONObject ) new JSONParser().parser(jsonString);
						JSONArray jsonDocuments = (JSONArray) json.get( "documents" );
				    	if( jsonDocuments.size() != 0 ) {
					  		JSONObject j = (JSONObject) jsonDocuments.get(0);
					  		latd = ( String ) j.get("y");
					  		lotd = ( String ) j.get("x");
						} 
					}
					
					//사업장정보 등록/수정
					JexData idoIn2 = util.createIDOData("INTT_INFM_C001");
					idoIn2.put("USE_INTT_ID", use_intt_id);
					idoIn2.put("BIZ_NO", hstr.getString("PROVIDER_REG_NUMBER")); 							// 공급자 등록번호
					idoIn2.put("BSNN_NM", StringUtil.toHalfChar(hstr.getString("PROVIDER_COMPANY_NAME"))); 	// 공급자 상호
					idoIn2.put("RPPR_NM", StringUtil.toHalfChar(hstr.getString("PROVIDER_CEO_NAME"))); 		// 공급자 성명
					idoIn2.put("ADRS", StringUtil.toHalfChar(hstr.getString("PROVIDER_BUSINESS_PLACE"))); 	// 공급자 사업장
					idoIn2.put("LATD", latd); 																// 공급자 사업장 위도
					idoIn2.put("LOTD", lotd); 																// 공급자 사업장 경도
					idoIn2.put("BSST", StringUtil.toHalfChar(hstr.getString("PROVIDER_BUSINESS_CATEGORY")));// 공급자 업태
					idoIn2.put("TPBS", StringUtil.toHalfChar(hstr.getString("PROVIDER_BUSINESS_TYPE"))); 	// 공급자 종목
					JexData idoOut2 = idoCon.execute(idoIn2);
				}
			}
			
			idoCon.commit();
			idoCon.endTransaction();

		}
		//updEvdcSeupInfm(use_intt_id, rsltDt, rsltCd, rsltMsg, search_gubun);
		// 최종 상태 업데이트
		updEvdcSeupInfm(use_intt_id, rsltCd, rsltMsg, search_gubun);
		// 매시간 전자세금계산서 상태값 변경
		updateCustRtElecTxblHisLst(use_intt_id, rsltCd, rsltMsg, rsltDt);
		
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
	 * @param startDate
	 * @param endDate
	 * @param search_gubun
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void deleteElecTxblPtclData(JexConnection idoCon, String use_intt_id, String startDate, String endDate,
			String search_gubun) throws JexException, JexBIZException {

		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("ELEC_TXBL_DTLS_D001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("BILL_TYPE", search_gubun);
		idoIn1.put("START_DT", startDate);
		idoIn1.put("END_DT", endDate);
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1))
			throw new JexTransactionRollbackException(idoOut1);

		JexData idoIn2 = util.createIDOData("ELEC_TXBL_PTCL_D001");
		idoIn2.put("USE_INTT_ID", use_intt_id);
		idoIn2.put("BILL_TYPE", search_gubun);
		idoIn2.put("START_DT", startDate);
		idoIn2.put("END_DT", endDate);
		JexData idoOut2 = idoCon.execute(idoIn2);

		if (DomainUtil.isError(idoOut2))
			throw new JexTransactionRollbackException(idoOut2);
	}

	/**
	 * <pre>
	 * 전자세금계산서 매출/매입 상세 등록
	 * </pre>
	 *
	 * @param det
	 * @param use_intt_id
	 * @param IssuId
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JexData insertElecTxblDtlsData(JSONObject det, String use_intt_id, String IssuId)
			throws JexException, JexBIZException {
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("ELEC_TXBL_DTLS_C001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("ISSU_ID", IssuId);
		idoIn1.put("SEQ_NO", det.getString("SEQ"));
		idoIn1.put("TRNS_DT", det.getString("TAXBILL_DATE"));
		idoIn1.put("ITEM_CODE", "");
		idoIn1.put("ITEM_NM", det.getString("ITEM_NAME"));
		idoIn1.put("ITEM_INFM", det.getString("ITEM_STANDARD"));
		idoIn1.put("ITEM_DESP", "");
		idoIn1.put("ITEM_QUNT", StringUtil.null2void(det.getString("ITEM_QUANTITY"), "0"));
		idoIn1.put("UNIT_PRCE", StringUtil.null2void(det.getString("ITEM_UNIT_COST"), "0"));
		idoIn1.put("SPLY_AMT", StringUtil.null2void(det.getString("ITEM_PROVIDE_AMOUNT"), "0"));
		idoIn1.put("ITEM_TAX", StringUtil.null2void(det.getString("ITEM_TAX_AMOUNT"), "0"));

		BizLogUtil.debug(this, idoIn1.toJSONString());

		return idoIn1;
	}

	/**
	 * <pre>
	 * 전자세금계산서 매출/매입 원장 등록
	 * </pre>
	 *
	 * @param hstrData
	 * @param use_intt_id
	 * @param IssuId
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JexData insertElecTxblPtclData(JSONObject hstrData, String use_intt_id, String IssuId)
			throws JexException, JexBIZException {
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("ELEC_TXBL_PTCL_C001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("ISSU_ID", IssuId);
		idoIn1.put("SELR_MGR_ID1", "");
		idoIn1.put("SELR_MGR_ID2", "");
		idoIn1.put("SELR_MGR_ID3", hstrData.getString("SEQ")); // 일련번호
		idoIn1.put("ISSU_DT", hstrData.getString("ISSUE_DATE")); // 발행일자
		idoIn1.put("SND_DT", hstrData.getString("SEND_DATE")); // 전송일자
		idoIn1.put("WRTG_DT", hstrData.getString("DATE")); // 작성일자

		idoIn1.put("SELR_CORP_NO", hstrData.getString("PROVIDER_REG_NUMBER")); // 공급자 등록번호
		idoIn1.put("SELR_CODE", hstrData.getString("PROVIDER_OTHER_REGNO")); // 공급자 종사업장번호
		idoIn1.put("SELR_CORP_NM", StringUtil.toHalfChar(hstrData.getString("PROVIDER_COMPANY_NAME"))); // 공급자 상호
		idoIn1.put("SELR_CEO", StringUtil.toHalfChar(hstrData.getString("PROVIDER_CEO_NAME"))); // 공급자 성명
		idoIn1.put("SELR_ADDR", StringUtil.toHalfChar(hstrData.getString("PROVIDER_BUSINESS_PLACE"))); // 공급자 사업장
		idoIn1.put("SELR_BUSS_CONS", StringUtil.toHalfChar(hstrData.getString("PROVIDER_BUSINESS_CATEGORY"))); // 공급자 업태
		idoIn1.put("SELR_BUSS_TYPE", StringUtil.toHalfChar(hstrData.getString("PROVIDER_BUSINESS_TYPE"))); // 공급자 종목
		idoIn1.put("SELR_CHRG_EMAIL", StringUtil.toHalfChar(hstrData.getString("PROVIDER_EMAIL"))); // 공급자 이메일

		idoIn1.put("BUYR_CORP_NO", hstrData.getString("RECEIVER_REG_NUMBER")); // 공급받는자 등록번호
		idoIn1.put("BUYR_CODE", hstrData.getString("RECEIVER_OTHER_REGNO")); // 공급받는자 종사업장번호
		idoIn1.put("BUYR_CORP_NM", StringUtil.toHalfChar(hstrData.getString("RECEIVER_COMPANY_NAME"))); // 공급받는자 상호
		idoIn1.put("BUYR_CEO", StringUtil.toHalfChar(hstrData.getString("RECEIVER_CEO_NAME"))); // 공급받는자 성명
		idoIn1.put("BUYR_ADDR", StringUtil.toHalfChar(hstrData.getString("RECEIVER_BUSINESS_PLACE"))); // 공급받는자 사업장
		idoIn1.put("BUYR_BUSS_CONS", StringUtil.toHalfChar(hstrData.getString("RECEIVER_BUSINESS_CATEGORY"))); // 공급받는자
																												// 업태
		idoIn1.put("BUYR_BUSS_TYPE", StringUtil.toHalfChar(hstrData.getString("RECEIVER_BUSINESS_TYPE"))); // 공급받는자 종목
		idoIn1.put("BUYR_CHRG_EMAIL1", StringUtil.toHalfChar(hstrData.getString("RECEIVER_EMAIL"))); // 공급받는자 이메일

		idoIn1.put("BROK_CORP_NO", hstrData.getString("BAILEE_REG_NUMBER")); // 수탁사업자 등록번호
		idoIn1.put("BROK_CODE", hstrData.getString("BAILEE_OTHER_REGNO")); // 수탁사업자 종사업장번호
		idoIn1.put("BROK_CORP_NM", StringUtil.toHalfChar(hstrData.getString("BAILEE_COMPANY_NAME"))); // 수탁사업자 상호
		idoIn1.put("BROK_CEO", StringUtil.toHalfChar(hstrData.getString("BAILEE_CEO_NAME"))); // 수탁사업자 성명
		idoIn1.put("BROK_ADDR", StringUtil.toHalfChar(hstrData.getString("BAILEE_BUSINESS_PLACE"))); // 수탁사업자 사업장
		idoIn1.put("BROK_BUSS_CONS", StringUtil.toHalfChar(hstrData.getString("BAILEE_CATEGORY"))); // 수탁사업자 업태
		idoIn1.put("BROK_BUSS_TYPE", StringUtil.toHalfChar(hstrData.getString("BAILEE_TYPE"))); // 수탁사업자 종목
		idoIn1.put("BROK_CHRG_NM", StringUtil.toHalfChar(hstrData.getString("BROK_BUSS_TYPE"))); // 수탁사업자 종목
		idoIn1.put("BROK_CHRG_EMAIL", StringUtil.toHalfChar(hstrData.getString("BAILEE_EMAIL"))); // 수탁사업자 이메일

		idoIn1.put("PYMT_TYPE1", "10"); // 현금
		idoIn1.put("PAMT_AMT1", StringUtil.null2void(hstrData.getString("CASH"), "0")); // 현금
		idoIn1.put("PYMT_TYPE2", "20"); // 수표
		idoIn1.put("PAMT_AMT2", StringUtil.null2void(hstrData.getString("SUPYO"), "0")); // 수표
		idoIn1.put("PYMT_TYPE3", "30"); // 어음
		idoIn1.put("PAMT_AMT3", StringUtil.null2void(hstrData.getString("BILL"), "0")); // 어음
		idoIn1.put("PYMT_TYPE4", "40"); // 외상(매출금/미수금)
		idoIn1.put("PAMT_AMT4", StringUtil.null2void(hstrData.getString("CREDIT"), "0")); // 외상(매출금/미수금)

		idoIn1.put("SPLY_TOTL_AMT", StringUtil.null2void(hstrData.getString("PROVIDE_TAX_AMOUNT"), "0")); // 공급가액
		idoIn1.put("TAX_AMT", StringUtil.null2void(hstrData.getString("PROVIDE_TAX_AMOUNT2"), "0")); // 세액
		idoIn1.put("TOTL_AMT", StringUtil.null2void(hstrData.getString("TOTAL_AMOUNT"), "0")); // 총금액

		idoIn1.put("BILL_TYPE", hstrData.getString("SEARCH_GUBUN")); // 매입매출구분 (1:매출, 2:매입, 3:면세매출, 4:면세매입)
		idoIn1.put("POPS_CODE", hstrData.getString("RECEIPT_CLAIM_GUBUN")); // 영수/청구 구분 (영수, 청구)
		idoIn1.put("MODY_CODE", hstrData.getString("EDIT_REASON")); // 수정사유
		idoIn1.put("RMRK1", hstrData.getString("ETC")); // 비고
		idoIn1.put("RMRK2", hstrData.getString("ETC2")); // 비고2
		idoIn1.put("TAX_TYPE", hstrData.getString("EBILL_TYPE")); // 전자세금계산서 종류

		return idoIn1;
	}
	
	/**
	 * <pre>
	 * 거래처정보 등록
	 * </pre>
	 *
	 * @param hstrData
	 * @param use_intt_id
	 * @param search_gubun
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void addBzaqInfmData(HashMap hBzaqList, JexDataList insertBzaqData, JSONObject hstrData, String use_intt_id, String search_gubun)
			throws JexException, JexBIZException {
		
		//매입
		if ("6".equals(search_gubun)) {
			if(StringUtil.isBlank(hstrData.getString("PROVIDER_REG_NUMBER")) || hBzaqList.containsKey(hstrData.getString("PROVIDER_REG_NUMBER"))) {
				return;
			}
			hBzaqList.put(hstrData.getString("PROVIDER_REG_NUMBER"), "");
		}
		//매출
		else {
			if(StringUtil.isBlank(hstrData.getString("RECEIVER_REG_NUMBER")) || hBzaqList.containsKey(hstrData.getString("RECEIVER_REG_NUMBER"))) {
				return;
			}
			hBzaqList.put(hstrData.getString("RECEIVER_REG_NUMBER"), "");
		}
		
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("BZAQ_INFM_C001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		BizLogUtil.debug(this, "execute", "Input Bzaq :: " + hstrData.getString("PROVIDER_REG_NUMBER")+" :: "+ hstrData.getString("RECEIVER_REG_NUMBER"));
		//매입
		if ("6".equals(search_gubun)) {
			idoIn1.put("BIZ_NO", hstrData.getString("PROVIDER_REG_NUMBER")); // 공급자 등록번호
			idoIn1.put("BZAQ_NM", StringUtil.null2void(StringUtil.toHalfChar(hstrData.getString("PROVIDER_COMPANY_NAME")), hstrData.getString("PROVIDER_REG_NUMBER"))); // 공급자 상호
			idoIn1.put("RPPR_NM", StringUtil.toHalfChar(hstrData.getString("PROVIDER_CEO_NAME"))); // 공급자 성명
			idoIn1.put("ADRS", StringUtil.toHalfChar(hstrData.getString("PROVIDER_BUSINESS_PLACE"))); // 공급자 사업장
			idoIn1.put("BSST", StringUtil.toHalfChar(hstrData.getString("PROVIDER_BUSINESS_CATEGORY"))); // 공급자
			idoIn1.put("TPBS", StringUtil.toHalfChar(hstrData.getString("PROVIDER_BUSINESS_TYPE"))); // 공급자 종목
			idoIn1.put("EMAL", StringUtil.toHalfChar(hstrData.getString("PROVIDER_EMAIL"))); // 공급자 이메일
			idoIn1.put("BUYR_YN", "Y"); //매입처
		}else {
			idoIn1.put("BIZ_NO", hstrData.getString("RECEIVER_REG_NUMBER")); // 공급받는자 등록번호
			idoIn1.put("BZAQ_NM", StringUtil.null2void(StringUtil.toHalfChar(hstrData.getString("RECEIVER_COMPANY_NAME")), hstrData.getString("RECEIVER_REG_NUMBER"))); // 공급받는자 상호
			idoIn1.put("RPPR_NM", StringUtil.toHalfChar(hstrData.getString("RECEIVER_CEO_NAME"))); // 공급받는자 성명
			idoIn1.put("ADRS", StringUtil.toHalfChar(hstrData.getString("RECEIVER_BUSINESS_PLACE"))); // 공급받는자 사업장
			idoIn1.put("BSST", StringUtil.toHalfChar(hstrData.getString("RECEIVER_BUSINESS_CATEGORY"))); // 공급받는자
			idoIn1.put("TPBS", StringUtil.toHalfChar(hstrData.getString("RECEIVER_BUSINESS_TYPE"))); // 공급받는자 종목
			idoIn1.put("EMAL", StringUtil.toHalfChar(hstrData.getString("RECEIVER_EMAIL"))); // 공급받는자 이메일
			idoIn1.put("SELR_YN", "Y"); //매출처
		}

		insertBzaqData.add(idoIn1);
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
	 * @param search_gubun
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void updEvdcSeupInfm(String use_intt_id, String last_dt, String stts, String msg, String search_gubun)
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

		JexData idoIn1 = null;

		// 매출
		if ("5".equals(search_gubun)) {
			idoIn1 = util.createIDOData("EVDC_INFM_U002");
			idoIn1.put("HIS_LST_DTM", last_dt);
			idoIn1.put("HIS_LST_STTS", stts);
			idoIn1.put("HIS_LST_MSG", msg);
		}
		// 매입
		else {
			idoIn1 = util.createIDOData("EVDC_INFM_U003");
			idoIn1.put("BUY_HIS_LST_DTM", last_dt);
			idoIn1.put("BUY_HIS_LST_STTS", stts);
			idoIn1.put("BUY_HIS_LST_MSG", msg);
		}
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("EVDC_DIV_CD", "20");

		JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			BizLogUtil.error(this, "Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
			BizLogUtil.error(this, "Error Message::" + DomainUtil.getErrorMessage(idoOut1));
		}

	}
	
	/**
	 * <pre>
	 * 최종상태 수정
	 * </pre>
	 *
	 * @param use_intt_id
	 * @param stts
	 * @param msg
	 * @param search_gubun
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void updEvdcSeupInfm(String use_intt_id, String stts, String msg, String search_gubun)
			throws JexException, JexBIZException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		msg = StringUtil.null2void(msg);
		if (msg.getBytes().length > 255) {
			msg = StringUtil.byteSubString(msg, 0, 255);
		}

		JexData idoIn1 = null;
		IDODynamic dynamic = new IDODynamic();	
		
		// 매출
		if ("5".equals(search_gubun)) {
			// 정상인 경우
			if ("0000".equals(stts)) {
				dynamic.addSQL(", RT_HIS_LST_DTM = '"+SvcDateUtil.getInstance().getDate() + SvcDateUtil.getShortTimeString()+"'");
			}

			idoIn1 = util.createIDOData("EVDC_INFM_U010");
			idoIn1.put("HIS_LST_STTS", stts);
			idoIn1.put("HIS_LST_MSG", msg);
		}
		// 매입
		else {
			// 정상인 경우
			if ("0000".equals(stts)) {
				dynamic.addSQL(", RT_BUY_HIS_LST_DTM = '"+SvcDateUtil.getInstance().getDate() + SvcDateUtil.getShortTimeString()+"'");
			}
			idoIn1 = util.createIDOData("EVDC_INFM_U009");
			idoIn1.put("BUY_HIS_LST_STTS", stts);
			idoIn1.put("BUY_HIS_LST_MSG", msg);
		}
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("EVDC_DIV_CD", "20");
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
		idoIn1.put("EVDC_DIV_CD", "20"); // 10:여신, 20:세금계산서, 21:현금영수증
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			BizLogUtil.error(this, "Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
			BizLogUtil.error(this, "Error Message::" + DomainUtil.getErrorMessage(idoOut1));
			throw new JexBIZException(idoOut1);
		}

		return idoOut1;

	}
}
