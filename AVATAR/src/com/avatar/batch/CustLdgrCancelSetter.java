package com.avatar.batch;

import jex.JexContext;
import jex.data.JexData;
import jex.data.JexDataList;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.exception.JexTransactionRollbackException;
import jex.json.JSONArray;
import jex.json.JSONObject;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.simplebatch.AbstractSimpleBatchTask;
import jex.util.DomainUtil;
import jex.util.biz.JexCommonUtil;
import com.avatar.api.mgnt.CooconApiMgnt;
import com.avatar.api.mgnt.PushApiMgnt;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.CommUtil;
import com.avatar.comm.KISA_SEED_CBC_Util;
import com.avatar.comm.SvcStringUtil;

/**
 * 배치 > 회원관리 > 고객탈퇴처리
 *
 */
public class CustLdgrCancelSetter extends AbstractSimpleBatchTask {

    @Override
    public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {

    	System.out.println("CustLdgrCancelSetter 배치 실행");
        BizLogUtil.debug(this, "execute", "Input :: " + input.toJSONString());

        JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContext.getContext().getCommonUtil();


        idoCon.beginTransaction();

        try {
        	// 탈퇴신청 고객원장 조회
            JexData idoIn1 = util.createIDOData("CUST_LDGR_R032");
            JexDataList<JexData> custLdgrList = idoCon.executeList(idoIn1);

            if (DomainUtil.isError(custLdgrList))
                throw new JexTransactionRollbackException(custLdgrList);


            for(JexData custLdgr : custLdgrList) {
                BizLogUtil.info(this, "cancelcustLdgr", "해지대상 : "+custLdgr.toJSONString());
                
                // 계좌 해지(쿠콘)
                cancelAcct(idoCon, util, custLdgr);

                // 법인카드 해지(쿠콘)
                cancelCorpCard(idoCon, util, custLdgr);

                // 증빙 해지(쿠콘)
                cancelEvdc(idoCon, util, custLdgr);

                // 인증서해지(쿠콘)
                cancelCert(idoCon, util, custLdgr);

                // 푸시디바이스 해지
                deleteDevice(idoCon, util, custLdgr);

                // 아바타 데이터 삭제
                deleteAllData(idoCon, util, custLdgr);
                
                // 해지완료
                cancelCustLdgr(idoCon, util, custLdgr);

            }
            
        } catch(Throwable e) {
            BizLogUtil.error(this, "execute", e);

        }

        idoCon.endTransaction();

        return null;
    }

    private void cancelCustLdgr(JexConnection idoCon, JexCommonUtil util, JexData custLdgr) throws JexException, JexBIZException {
    	// 고객정보 초기화(상태변경-해지완료)
        JexData idoIn1 = util.createIDOData("CUST_LDGR_U006");
        idoIn1.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
        JexData idoOut1 = idoCon.execute(idoIn1);

        if (DomainUtil.isError(idoOut1))
            throw new JexTransactionRollbackException(idoOut1);

	}

	/**
     * <pre>
     * 고객 관련 모든 데이타 삭제
     * </pre>
     * @param idoCon
     * @param util
     * @param custLdgr
     * @throws JexBIZException
     * @throws JexException
     */
    private void deleteAllData(JexConnection idoCon, JexCommonUtil util, JexData custLdgr)
    		throws JexException, JexBIZException {

    	BizLogUtil.info(this, "deleteAllData", "("+custLdgr.getString("USE_INTT_ID")+") 데이타 삭제");
    	
    	/**계좌정보(2개)*****************************************************/
    	// 계좌정보 삭제(ACCT_INFM)
    	JexData acct_idoIn1 = util.createIDOData("ACCT_INFM_D001");
    	acct_idoIn1.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData acct_idoOut1 =  idoCon.execute(acct_idoIn1);
    	if (DomainUtil.isError(acct_idoOut1))
    		throw new JexTransactionRollbackException(acct_idoOut1);
    	
    	// 계좌거래내역 삭제(ACCT_TRNS_HSTR)
    	JexData acct_idoIn2 = util.createIDOData("ACCT_TRNS_HSTR_D001");
    	acct_idoIn2.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData acct_idoOut2 =  idoCon.execute(acct_idoIn2);
    	if (DomainUtil.isError(acct_idoOut2))
    		throw new JexTransactionRollbackException(acct_idoOut2);
    	
    	/**법인카드정보(2개)*****************************************************/
    	// 카드정보 삭제(CARD_INFM)
    	JexData card_idoIn1 = util.createIDOData("CARD_INFM_D001");
    	card_idoIn1.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData card_idoOut1 =  idoCon.execute(card_idoIn1);
    	if (DomainUtil.isError(card_idoOut1))
    		throw new JexTransactionRollbackException(card_idoOut1);
    	
    	// 카드매입승인내역 삭제(CARD_BUY_APV_HSTR)
    	JexData card_idoIn2 = util.createIDOData("CARD_BUY_APV_HSTR_D002");
    	card_idoIn2.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData card_idoOut2 =  idoCon.execute(card_idoIn2);
    	if (DomainUtil.isError(card_idoOut2))
    		throw new JexTransactionRollbackException(card_idoOut2);
    	
    	/**증빙정보(11개)****************************************************/
    	// 증빙정보 삭제(EVDC_INFM)-여신, 현금영수증, 전자세금계산서, 세액, 온라인매출(배달앱)
    	JexData evdc_idoIn1 = util.createIDOData("EVDC_INFM_D001");
    	evdc_idoIn1.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData evdc_idoOut1 =  idoCon.execute(evdc_idoIn1);
    	if (DomainUtil.isError(evdc_idoOut1))
    		throw new JexTransactionRollbackException(evdc_idoOut1);
    	
    	// 카드매출승인내역 삭제(CARD_SEL_APV_HSTR)
    	JexData evdc_idoIn2 = util.createIDOData("CARD_SEL_APV_HSTR_D002");
    	evdc_idoIn2.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData evdc_idoOut2 =  idoCon.execute(evdc_idoIn2);
    	if (DomainUtil.isError(evdc_idoOut2))
    		throw new JexTransactionRollbackException(evdc_idoOut2);
    	
    	// 카드매출입금내역 삭제(CARD_SEL_RCV_HSTR)
    	JexData evdc_idoIn3 = util.createIDOData("CARD_SEL_RCV_HSTR_D001");
    	evdc_idoIn3.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData evdc_idoOut3 =  idoCon.execute(evdc_idoIn3);
    	if (DomainUtil.isError(evdc_idoOut3))
    		throw new JexTransactionRollbackException(evdc_idoOut3);
    	
    	// 현금영수증매입내역 삭제(CASH_RCPT_BUY_HSTR)
    	JexData evdc_idoIn4 = util.createIDOData("CASH_RCPT_BUY_HSTR_D002");
    	evdc_idoIn4.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData evdc_idoOut4 =  idoCon.execute(evdc_idoIn4);
    	if (DomainUtil.isError(evdc_idoOut4))
    		throw new JexTransactionRollbackException(evdc_idoOut4);
    	
    	// 현금영수증매출내역 삭제(CASH_RCPT_SEL_HSTR)
    	JexData evdc_idoIn5 = util.createIDOData("CASH_RCPT_SEL_HSTR_D002");
    	evdc_idoIn5.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData evdc_idoOut5 =  idoCon.execute(evdc_idoIn5);
    	if (DomainUtil.isError(evdc_idoOut5))
    		throw new JexTransactionRollbackException(evdc_idoOut5);
    	
    	// 전자(세금)계산서상세 삭제(ELEC_TXBL_DTLS)
    	JexData evdc_idoIn6 = util.createIDOData("ELEC_TXBL_DTLS_D003");
    	evdc_idoIn6.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData evdc_idoOut6 =  idoCon.execute(evdc_idoIn6);
    	if (DomainUtil.isError(evdc_idoOut6))
    		throw new JexTransactionRollbackException(evdc_idoOut6);
    	
    	// 전자(세금)계산서명세 삭제(ELEC_TXBL_PTCL)
    	JexData evdc_idoIn7 = util.createIDOData("ELEC_TXBL_PTCL_D003");
    	evdc_idoIn7.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData evdc_idoOut7 =  idoCon.execute(evdc_idoIn7);
    	if (DomainUtil.isError(evdc_idoOut7))
    		throw new JexTransactionRollbackException(evdc_idoOut7);
    	
    	// 거래처정보 삭제(BZAQ_INFM)
    	JexData evdc_idoIn8 = util.createIDOData("BZAQ_INFM_D001");
    	evdc_idoIn8.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData evdc_idoOut8 =  idoCon.execute(evdc_idoIn8);
    	if (DomainUtil.isError(evdc_idoOut8))
    		throw new JexTransactionRollbackException(evdc_idoOut8);
    	
    	// 세액내역 삭제(TAX_HSTR)
    	JexData evdc_idoIn9 = util.createIDOData("TAX_HSTR_D003");
    	evdc_idoIn9.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData evdc_idoOut9 =  idoCon.execute(evdc_idoIn9);
    	if (DomainUtil.isError(evdc_idoOut9))
    		throw new JexTransactionRollbackException(evdc_idoOut9);
    	
    	// 온라인매출정산내역 삭제(SNSS_CALC_HSTR)
    	JexData evdc_idoIn10 = util.createIDOData("SNSS_CALC_HSTR_D002");
    	evdc_idoIn10.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData evdc_idoOut10 =  idoCon.execute(evdc_idoIn10);
    	if (DomainUtil.isError(evdc_idoOut10))
    		throw new JexTransactionRollbackException(evdc_idoOut10);
    	
    	// 온라인매출주문내역 삭제(SNSS_ORDR_HSTR)
    	JexData evdc_idoIn11 = util.createIDOData("SNSS_ORDR_HSTR_D003");
    	evdc_idoIn11.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData evdc_idoOut11 =  idoCon.execute(evdc_idoIn11);
    	if (DomainUtil.isError(evdc_idoOut11))
    		throw new JexTransactionRollbackException(evdc_idoOut11);
    	
    	/**연결정보-경리나라, 제로페이(7개)***************************************/
    	// 고객인텐트연결정보 삭제(CUST_INTE_LINK_INFM)
    	JexData link_idoIn1 = util.createIDOData("CUST_INTE_LINK_INFM_D003");
    	link_idoIn1.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData link_idoOut1 =  idoCon.execute(link_idoIn1);
    	if (DomainUtil.isError(link_idoOut1))
    		throw new JexTransactionRollbackException(link_idoOut1);
    	
    	// 고객연계시스템정보 삭제(CUST_LINK_SYS_INFM)
    	JexData link_idoIn2 = util.createIDOData("CUST_LINK_SYS_INFM_D002");
    	link_idoIn2.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData link_idoOut2 =  idoCon.execute(link_idoIn2);
    	if (DomainUtil.isError(link_idoOut2))
    		throw new JexTransactionRollbackException(link_idoOut2);
    	
    	// 고객연계시스템정보이력 삭제(CUST_LINK_SYS_INFM_HIS)
    	JexData link_idoIn3 = util.createIDOData("CUST_LINK_SYS_INFM_HIS_D001");
    	link_idoIn3.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData link_idoOut3 =  idoCon.execute(link_idoIn3);
    	if (DomainUtil.isError(link_idoOut3))
    		throw new JexTransactionRollbackException(link_idoOut3);
    	
    	// 제로페이가맹점정보 삭제(ZERO_MEST_INFM)
    	JexData link_idoIn4 = util.createIDOData("ZERO_MEST_INFM_D001");
    	link_idoIn4.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData link_idoOut4 =  idoCon.execute(link_idoIn4);
    	if (DomainUtil.isError(link_idoOut4))
    		throw new JexTransactionRollbackException(link_idoOut4);
    	
    	// 제로페이가맹점상품권 삭제(ZERO_MEST_PINT)
    	JexData link_idoIn5 = util.createIDOData("ZERO_MEST_PINT_D002");
    	link_idoIn5.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData link_idoOut5 =  idoCon.execute(link_idoIn5);
    	if (DomainUtil.isError(link_idoOut5))
    		throw new JexTransactionRollbackException(link_idoOut5);
    	
    	// 제로페이거래내역 삭제(ZERO_TRAN_HSTR)
    	JexData link_idoIn6 = util.createIDOData("ZERO_TRAN_HSTR_D001");
    	link_idoIn6.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData link_idoOut6 =  idoCon.execute(link_idoIn6);
    	if (DomainUtil.isError(link_idoOut6))
    		throw new JexTransactionRollbackException(link_idoOut6);
    	
    	// 제로페이거래상품권내역 삭제(ZERO_TRAN_POINT_HSTR)
    	JexData link_idoIn7 = util.createIDOData("ZERO_TRAN_POINT_HSTR_D003");
    	link_idoIn7.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData link_idoOut7 =  idoCon.execute(link_idoIn7);
    	if (DomainUtil.isError(link_idoOut7))
    		throw new JexTransactionRollbackException(link_idoOut7);
    	
    	/**고객정보(6개)*****************************************************/
    	// 기관원장 삭제(INTT_INFM)
    	JexData infm_idoIn1 = util.createIDOData("INTT_INFM_D001");
    	infm_idoIn1.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData infm_idoOut1 =  idoCon.execute(infm_idoIn1);
    	if (DomainUtil.isError(infm_idoOut1))
    		throw new JexTransactionRollbackException(infm_idoOut1);
    	
    	// 인증서정보 삭제(CERT_INFM)
    	JexData infm_idoIn2 = util.createIDOData("CERT_INFM_D001");
    	infm_idoIn2.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData infm_idoOut2 =  idoCon.execute(infm_idoIn2);
    	if (DomainUtil.isError(infm_idoOut2))
    		throw new JexTransactionRollbackException(infm_idoOut2);
    	
    	// 푸시디바이스원장 삭제(PUSH_DEVI_LDGR)
    	JexData infm_idoIn3 = util.createIDOData("PUSH_DEVI_LDGR_D002");
    	infm_idoIn3.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData infm_idoOut3 =  idoCon.execute(infm_idoIn3);
    	if (DomainUtil.isError(infm_idoOut3))
    		throw new JexTransactionRollbackException(infm_idoOut3);
    	
    	// 푸시디바이스원장이력 삭제(PUSH_DEVI_LDGR_HIS)
    	JexData infm_idoIn4 = util.createIDOData("PUSH_DEVI_LDGR_HIS_D001");
    	infm_idoIn4.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData infm_idoOut4 =  idoCon.execute(infm_idoIn4);
    	if (DomainUtil.isError(infm_idoOut4))
    		throw new JexTransactionRollbackException(infm_idoOut4);
    	
    	// 푸시발송이력 삭제(PUSH_SEND_HIS)
    	JexData infm_idoIn5 = util.createIDOData("PUSH_SEND_HIS_D001");
    	infm_idoIn5.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData infm_idoOut5 =  idoCon.execute(infm_idoIn5);
    	if (DomainUtil.isError(infm_idoOut5))
    		throw new JexTransactionRollbackException(infm_idoOut5);
    	
    	// 실시간조회요청 삭제(RT_INQ_TASK)
    	JexData infm_idoIn6 = util.createIDOData("RT_INQ_TASK_D001");
    	infm_idoIn6.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
    	JexData infm_idoOut6 =  idoCon.execute(infm_idoIn6);
    	if (DomainUtil.isError(infm_idoOut6))
    		throw new JexTransactionRollbackException(infm_idoOut6);
    	
    	/**총 27개**********************************************************/
	}

	/**
     * <pre>
     * 쿠콘에 등록 된 계좌 해지 처리
     * </pre>
     * @param idoCon
     * @param util
     * @param custLdgr 기관원장
     * @throws JexBIZException
     * @throws JexException
     */
    private void cancelAcct(JexConnection idoCon, JexCommonUtil util, JexData custLdgr)
            throws JexException, JexBIZException{
        BizLogUtil.info(this, "cancelAcct", "("+custLdgr.getString("USE_INTT_ID")+") 계좌 해지");

        // 계좌원장 조회(해지 대상)
        JexData idoIn1 = util.createIDOData("ACCT_INFM_R023");
        idoIn1.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
        JexDataList<JexData> acctList = idoCon.executeList(idoIn1);

        if (DomainUtil.isError(acctList))
            throw new JexTransactionRollbackException(acctList);

        // 총 건수 구하기(순전히 로깅을 위해)
        int iTotCnt = 0;

        for(JexData acctLdgr : acctList) {
            BizLogUtil.info(this, "cancelAcct", "("+custLdgr.getString("USE_INTT_ID")+") 계좌정보 : "+acctLdgr.toJSONString());

            JSONObject reqData  = new JSONObject();

            reqData.put("BIZ_CD"         , "001");                                  //업무구분코드(001:은행, 002:현금영수증, 003:카드, 004:여신금융협회, 005:개인카드)
            reqData.put("GUBUN"          , "D");                                    //거래구분코드(I:등록, U:수정,D:삭제)
            reqData.put("ORG_CD"         , acctLdgr.getString("BANK_CD"));          //은행코드3자리
            reqData.put("ACCT_GUBUN"     , acctLdgr.getString("ACCT_DV"));          //계좌구분(01:수시입출금,02:예적금,03:대출금)
            reqData.put("COMP_IDNO"      , acctLdgr.getString("USE_INTT_ID"));      //사업자번호
            if("01".equals(acctLdgr.getString("BANK_INQ_METH"))){
                reqData.put("BANK_TYPE"  , "0");                                    //서비스구분(빠른조회:1, 인증서조회:2)
            }else{
                reqData.put("BANK_TYPE"  , "1");
            }
            reqData.put("ACCT_NO"        , acctLdgr.getString("FNNC_INFM_NO"));     //계좌번호
            reqData.put("IB_TYPE"        , acctLdgr.getString("BANK_GB"));          //은행 개인/기업 뱅킹 구분값

            // 쿠콘에 등록 된 계좌 해지 호출
            JSONObject resData = CooconApiMgnt.data_wapi_0100(reqData);

            iTotCnt++;
        }
        BizLogUtil.info(this, "cancelAcct", "("+custLdgr.getString("USE_INTT_ID")+") 계좌정보 해지대상 건수 : "+String.valueOf(iTotCnt));
    }

    /**
     * <pre>
     * 쿠콘에 등록 된 법인카드 해지 처리
     * </pre>
     * @param idoCon
     * @param util
     * @param custLdgr 기관원장
     * @throws JexBIZException
     * @throws JexException
     */
    private void cancelCorpCard(JexConnection idoCon, JexCommonUtil util, JexData custLdgr)
            throws JexException, JexBIZException{
        BizLogUtil.info(this, "cancelCorpCard", "("+custLdgr.getString("USE_INTT_ID")+") 법인카드 해지");

        // 법인카드원장 조회(해지 대상)
        JexData idoIn1 = util.createIDOData("CARD_INFM_R012");
        idoIn1.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
        JexDataList<JexData> cardList = idoCon.executeList(idoIn1);

        if (DomainUtil.isError(cardList))
            throw new JexTransactionRollbackException(cardList);

        // 총 건수 구하기(순전히 로깅을 위해)
        int iTotCnt = 0;

        for(JexData cardLdgr : cardList) {
            BizLogUtil.info(this, "cancelCorpCard", "("+custLdgr.getString("USE_INTT_ID")+") 법인카드정보 : "+cardLdgr.toJSONString());

            JSONObject reqData = new JSONObject();

            String org_cd = cardLdgr.getString("BANK_CD").substring(5);
            if(CommUtil.isBCCard(org_cd)) { // bc 카드일경우 // 기업,대구, 부산, 경남, SC
                org_cd = "006";
            }
            reqData.put("BIZ_CD"     , "003");                          	//업무구분코드(001:은행, 002:현금영수증, 003:카드, 004:여신금융협회, 005:개인카드)
            reqData.put("GUBUN"      , "D");                            	//거래구분코드(I:등록, U:수정,D:삭제)
            reqData.put("ORG_CD"     , org_cd);                         	//은행코드3자리
            reqData.put("COMP_IDNO"  , cardLdgr.getString("USE_INTT_ID"));  //사업자번호
            reqData.put("BANK_TYPE"  , "0");                            	//서비스구분(빠른조회:1, 인증서조회:2)
            reqData.put("WEB_ID"     , cardLdgr.getString("WEB_ID"));  		//빠른조회 ID
            reqData.put("CARD_NO"    , cardLdgr.getString("CARD_NO"));  	//카드번호
            reqData.put("PAYMENT_DAY", cardLdgr.getString("SETL_DT"));  	//카드결제일

            // 쿠콘에 등록 된 카드 해지 호출
            JSONObject resData = CooconApiMgnt.data_wapi_0100(reqData);

            iTotCnt++;
        }
        BizLogUtil.info(this, "cancelCorpCard", "("+custLdgr.getString("USE_INTT_ID")+") 법인카드 해지대상 건수 : "+String.valueOf(iTotCnt));
    }

    /**
     * <pre>
     * 쿠콘에 등록 된 증빙(여신, 전자세금계산서, 현금영수증, 세액, 온라인매출) 해지 처리
     * </pre>
     * @param idoCon
     * @param util
     * @param custLdgr 기관원장
     * @throws Exception
     */
    private void cancelEvdc(JexConnection idoCon, JexCommonUtil util, JexData custLdgr)
            throws Exception{
        BizLogUtil.info(this, "cancelEvdc", "("+custLdgr.getString("USE_INTT_ID")+") 증빙 해지");

        // 증빙설정정보 조회(해지 대상)
        JexData idoIn1 = util.createIDOData("EVDC_INFM_R024");
        idoIn1.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
        JexDataList<JexData> evdcSeupInfmList = idoCon.executeList(idoIn1);

        if (DomainUtil.isError(evdcSeupInfmList))
            throw new JexTransactionRollbackException(evdcSeupInfmList);

        // 총 건수 구하기(순전히 로깅을 위해)
        int iTotCnt = 0;

        for(JexData evdcSeupInfm : evdcSeupInfmList) {
            BizLogUtil.info(this, "cancelEvdc", "("+custLdgr.getString("USE_INTT_ID")+") 증빙정보 : "+evdcSeupInfm.toJSONString());

            JSONObject rtnData = new JSONObject();
            String encryptKey      = "";
            String encryptJsondata = "";

            // 20:전자(세금)계산서, 21:현금영수증 인증서 정보, 22:세액 인증서 정보
            if("20".equals(evdcSeupInfm.getString("EVDC_DIV_CD"))
            	|| "21".equals(evdcSeupInfm.getString("EVDC_DIV_CD"))
            	|| "22".equals(evdcSeupInfm.getString("EVDC_DIV_CD"))) {
            	
                // 인증서정보
                rtnData.put("CERT_NAME"     , evdcSeupInfm.getString("CERT_NM"));
                rtnData.put("CERT_ORG"      , "");
                rtnData.put("CERT_DATE"     , "");
                rtnData.put("CERT_PWD"      , "");
                rtnData.put("CERT_FOLDER"   , "");
                rtnData.put("CERTDATA"      , "");

                // 인증서정보 암호화
                encryptKey      = KISA_SEED_CBC_Util.generateRandomKey();
                encryptJsondata = KISA_SEED_CBC_Util.encrypt(rtnData.toJSONString(), encryptKey);
            }


            JSONObject reqData = new JSONObject();

            if("10".equals(evdcSeupInfm.getString("EVDC_DIV_CD"))) {
                // 10:여신금융협회
                reqData.put("BIZ_CD"         , "004");                              //업무구분코드(001:은행, 002:현금영수증, 003:카드, 004:여신금융협회, 005:개인카드)
                reqData.put("GUBUN"          , "D");                                //거래구분코드(I:등록, U:수정,D:삭제)
                reqData.put("COMP_IDNO"      , evdcSeupInfm.getString("BIZ_NO"));   //사업자번호
                reqData.put("BANK_TYPE"      , "0");                                //서비스구분(빠른조회:1, 인증서조회:2)
                reqData.put("WEB_ID"         , evdcSeupInfm.getString("WEB_ID"));   //빠른조회 ID
                reqData.put("SER_IDNO"       , evdcSeupInfm.getString("BIZ_NO"));   //사업자번호
            } else if("20".equals(evdcSeupInfm.getString("EVDC_DIV_CD"))) {
                // 20:전자(세금)계산서
                reqData.put("BIZ_CD"         , "006");                              // 업무구분코드 : 006(전자세금계산서)
                reqData.put("GUBUN"          , "D");                                // 거래구분코드 : (I:등록, U:수정, D:삭제)
                reqData.put("COMP_IDNO"      , evdcSeupInfm.getString("BIZ_NO"));   // 사업자번호 기업 : 사업자번호,  개인 : 주민번호
                reqData.put("SER_IDNO"       , evdcSeupInfm.getString("BIZ_NO"));   // 조회용사업자번호 기업 : 사업자번호,  개인 : 주민번호
                reqData.put("BANK_TYPE"      , "1");                                // 서비스구분 : (인증서 조회:1)
                reqData.put("BASIC_DATE"     , "3");                                // 조회기준 (1:작성일자, 2:발행일자, 3:전송일자)
                reqData.put("TAX_TYPE1"      , "");                                 // 전자세금계산서 종류(대분류)
                reqData.put("TAX_TYPE2"      , "");                                 // 전자세금계산서 종류(소분류)
                reqData.put("PUBLISHING_TYPE", "");                                 // 발행유형
                reqData.put("REG_TYPE"       , "0");                                // 인증서등록여부 : (0: 인증서 미등록, 1:인증서 등록)
                reqData.put("REG_DATA"       , encryptKey+"0"+encryptJsondata);     // 인증서정보
                reqData.put("START_DATE"     , "");                                 // 최초조회시작일 : 삭제 시 공백
            } else if("21".equals(evdcSeupInfm.getString("EVDC_DIV_CD"))) {
                // 21:현금영수증
                reqData.put("BIZ_CD"         , "002");                              // 업무구분코드 : 002(현금영수증)
                reqData.put("GUBUN"          , "D");                                // 거래구분코드 : (I:등록, U:수정, D:삭제)
                reqData.put("COMP_IDNO"      , evdcSeupInfm.getString("BIZ_NO"));   // 사업자번호 기업 : 사업자번호,  개인 : 주민번호
                reqData.put("SER_IDNO"       , evdcSeupInfm.getString("BIZ_NO"));   // 조회용사업자번호 기업 : 사업자번호,  개인 : 주민번호
                reqData.put("BANK_TYPE"      , "1");                                // 서비스구분 : (인증서 조회:1)
                reqData.put("TAX_TYPE1"      , "");                                 // 전자세금계산서 종류(대분류)
                reqData.put("TAX_TYPE2"      , "");                                 // 전자세금계산서 종류(소분류)
                reqData.put("PUBLISHING_TYPE", "");                                 // 발행유형
                reqData.put("REG_TYPE"       , "0");                                // 인증서등록여부 : (0: 인증서 미등록, 1:인증서 등록)
                reqData.put("REG_DATA"       , encryptKey+"0"+encryptJsondata);     // 인증서정보
                reqData.put("START_DATE"     , "");                                 // 최초조회시작일 : 삭제 시 공백
            } else if("22".equals(evdcSeupInfm.getString("EVDC_DIV_CD"))) {
                // 22:세액
                reqData.put("BIZ_CD"         , "007");                              // 업무구분코드 : 007(부가가치세/종합소득세)
                reqData.put("GUBUN"          , "D");                                // 거래구분코드 : (I:등록, U:수정, D:삭제)
                reqData.put("COMP_IDNO"      , evdcSeupInfm.getString("BIZ_NO"));   // 사업자번호 기업 : 사업자번호,  개인 : 주민번호
                reqData.put("SER_IDNO"       , evdcSeupInfm.getString("BIZ_NO"));   // 조회용사업자번호 기업 : 사업자번호,  개인 : 주민번호
                reqData.put("BANK_TYPE"      , "1");                                // 서비스구분 : (인증서 조회:1)
                reqData.put("REG_TYPE"       , "0");                                // 인증서등록여부 : (0: 인증서 미등록, 1:인증서 등록)
                reqData.put("REG_DATA"       , encryptKey+"0"+encryptJsondata);     // 인증서정보
            } else if("40".equals(evdcSeupInfm.getString("EVDC_DIV_CD"))) {
                // 40:온라인매출
                reqData.put("BIZ_CD"         , "011");                              	// 업무구분코드 : 011(쇼핑몰(배달앱))
                reqData.put("GUBUN"          , "D");                                	// 거래구분코드 : (I:등록, U:수정, D:삭제)
                reqData.put("COMP_IDNO"      , evdcSeupInfm.getString("BIZ_NO"));   	// 사업자번호 기업 : 사업자번호,  개인 : 주민번호
                reqData.put("SHOP_CD"      	 , evdcSeupInfm.getString("SHOP_CD"));      // 쇼핑몰 코드
                reqData.put("SUB_SHOP_CD"    , evdcSeupInfm.getString("SUB_SHOP_CD"));  // 보조 쇼핑몰 코드
                reqData.put("WEB_ID"      	 , evdcSeupInfm.getString("WEB_ID"));       // 로그인아이디
            }

            // 쿠콘에 등록 된 증빙 해지 호출
            JSONObject resData = CooconApiMgnt.data_wapi_0100(reqData);

            iTotCnt++;
        }
        BizLogUtil.info(this, "cancelEvdc", "("+custLdgr.getString("USE_INTT_ID")+") 증빙 해지대상 건수 : "+String.valueOf(iTotCnt));
    }

    /**
     * <pre>
     * 푸시디바이스 해지 및 삭제
     * </pre>
     * @param idoCon
     * @param util
     * @param custLdgr 고객원장
     * @throws JexBIZException
     * @throws JexException
     */
    private void deleteDevice(JexConnection idoCon, JexCommonUtil util, JexData custLdgr)
            throws JexException, JexBIZException{
        BizLogUtil.info(this, "deleteDevice", "("+custLdgr.getString("USE_INTT_ID")+") 푸시 해지");

        // 사용자원장 조회(디바이스 해지 대상)
        JexData idoIn1 = util.createIDOData("CUST_LDGR_R042");
        idoIn1.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
        JexDataList<JexData> idoOutList1 = idoCon.executeList(idoIn1);

        if (DomainUtil.isError(idoOutList1))
            throw new JexTransactionRollbackException(idoOutList1);

        // 총 건수 구하기(순전히 로깅을 위해)
        int iTotCnt = 0;

        for(JexData userInfo : idoOutList1) {
            BizLogUtil.info(this, "deleteDevice", "("+custLdgr.getString("USE_INTT_ID")+") 사용자정보 : "+userInfo.toJSONString());

            if(!"".equals(userInfo.getString("DEVICE_ID"))) {
                // 푸시디바이스원장 정보가 없으면 패스.
                if("".equals(SvcStringUtil.null2void(userInfo.getString("REMARK"))) || "".equals(SvcStringUtil.null2void(userInfo.getString("DEVICE_ID")))) continue;

                // 푸시서버에 등록 된 디바이스 해지 호출
                JSONObject res_PS0005 	  = PushApiMgnt.svc_PS0005(userInfo.getString("REMARK"), userInfo.getString("DEVICE_ID"), userInfo.getString("PUSHSERVER_KIND"));
                JSONObject mPushRespData  = (JSONObject)((JSONArray)res_PS0005.get("_tran_res_data")).get(0);
                
                if(mPushRespData.isEmpty()){
                    BizLogUtil.info(this, "deleteDevice", "("+custLdgr.getString("USE_INTT_ID")+") 응답데이터 없음");

                } else if(SvcStringUtil.null2void((String)mPushRespData.get("_error_cd"), "").trim().equals("ERR0004")){
                    // 정상처리
                    BizLogUtil.info(this, "deleteDevice", "("+custLdgr.getString("USE_INTT_ID")+") 삭제대상디바이스 없음");

                } else if(!SvcStringUtil.null2void((String)mPushRespData.get("_result"), "false").trim().equals("true")){
                	//전문처리시 오류코드 받음
                	BizLogUtil.info(this, "deleteDevice", "("+custLdgr.getString("USE_INTT_ID")+") 해지 오류  " + mPushRespData.get("_error_cd").toString() );

                } else {
                    // 정상처리
                    BizLogUtil.info(this, "deleteDevice", "("+custLdgr.getString("USE_INTT_ID")+") 해지 성공" );
                }

            }
            iTotCnt++;
        }
        BizLogUtil.info(this, "deleteDevice", "("+custLdgr.getString("USE_INTT_ID")+") 푸시 해지대상 건수 : "+String.valueOf(iTotCnt));
    }

    /**
     * <pre>
     * 쿠콘에 등록 된 인증서 해지
     * </pre>
     * @param idoCon
     * @param util
     * @param custLdgr 기관원장
     * @throws JexBIZException
     * @throws JexException
     */
    private void cancelCert(JexConnection idoCon, JexCommonUtil util, JexData custLdgr)
            throws Exception {
        BizLogUtil.info(this, "cancelCert", "("+custLdgr.getString("USE_INTT_ID")+") 인증서 해지");

        // 인증서원장 조회(해지 대상)
        JexData idoIn1 = util.createIDOData("CERT_INFM_R011");
        idoIn1.put("USE_INTT_ID", custLdgr.getString("USE_INTT_ID"));
        JexDataList<JexData> certList = idoCon.executeList(idoIn1);

        if (DomainUtil.isError(certList))
            throw new JexTransactionRollbackException(certList);

        // 총 건수 구하기(순전히 로깅을 위해)
        int iTotCnt = 0;

        for(JexData certLdgr : certList) {
            BizLogUtil.info(this, "cancelCert", "("+custLdgr.getString("USE_INTT_ID")+") 인증서정보 : "+certLdgr.toJSONString());

            JSONObject reqData  = new JSONObject();
            JSONObject reqDataSub = new JSONObject();

            reqDataSub.put("CERT_NAME"  , certLdgr.getString("CERT_NM"));
            reqDataSub.put("CERT_ORG"   , "");
            reqDataSub.put("CERT_DATE"  , "");
            reqDataSub.put("CERT_PWD"   , "");
            reqDataSub.put("CERT_FOLDER", "");
            reqDataSub.put("CERTDATA"   , "");

            String encryptKey      = KISA_SEED_CBC_Util.generateRandomKey();
            String encryptJsondata = KISA_SEED_CBC_Util.encrypt(reqDataSub.toJSONString(), encryptKey);

            reqData.put("BIZ_CD"   , "001");                            //업무구분코드(001:은행, 002:현금영수증, 003:카드, 004:여신금융협회, 005:개인카드)
            reqData.put("GUBUN"    , "D");                              //거래구분코드(I:등록, U:수정,D:삭제)
            reqData.put("COMP_IDNO", custLdgr.getString("USE_INTT_ID"));//사업자번호
            reqData.put("REG_TYPE" , "0");                              //인증서등록여부(0:등록한 인증서가 있는경우, 1:인증서 최초등록)
            reqData.put("REG_DATA" , encryptKey+"0"+encryptJsondata);   //인증서 데이터

            // 쿠콘에 등록 된 인증서 해지 호출
            JSONObject resData = CooconApiMgnt.data_wapi_0200(reqData);

            iTotCnt++;
        }
        BizLogUtil.info(this, "cancelCert", "("+custLdgr.getString("USE_INTT_ID")+") 인증서 해지대상 건수 : "+String.valueOf(iTotCnt));
    }
}
