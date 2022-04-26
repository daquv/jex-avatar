package com.avatar.service;

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
import com.avatar.api.mgnt.CooconApi;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.CommUtil;
import com.avatar.comm.SvcDateUtil;

/**
 * 법인카드 승인내역 실시간 조회 - Runnable 객체
 *
 * @author webcash.co.kr
 *
 */
public class CorpCardCooconServiceRunnable implements Runnable {

	private String _use_intt_id;
	private String _scqkey;
	private String _bank_cd;
	private String _web_id;
	private String _web_pwd;
	private String _card_no;
	private String _pay_yn;
	private String _start_date;
	private String _end_date;

	public CorpCardCooconServiceRunnable(JSONObject cardInfo, String start_date, String end_date) {

		_use_intt_id = cardInfo.getString("USE_INTT_ID");
		_scqkey 	 = cardInfo.getString("SCQKEY");
		_bank_cd     = cardInfo.getString("BANK_CD");
		_web_id      = cardInfo.getString("WEB_ID");
		_web_pwd     = cardInfo.getString("WEB_PWD");
		_card_no     = cardInfo.getString("CARD_NO");
		_pay_yn      = cardInfo.getString("PAY_YN");
		_start_date  = start_date;
		_end_date    = end_date;
	}

	@Override
	public void run() {

		BizLogUtil.info(this, _use_intt_id,"Thread ["+Thread.currentThread().getName()+"] Start");

        String coo_bank_cd = "";

    	if("30000060".equals(_bank_cd) || "30000061".equals(_bank_cd) || "30000062".equals(_bank_cd) ||
                "30000063".equals(_bank_cd) || "30000064".equals(_bank_cd))
    	{
    		coo_bank_cd = "006";
    	}
    	else
    	{
    		coo_bank_cd = _bank_cd.substring(5);
    	}

    	try {
    		
    		// 비밀번호 복호화
    		_web_pwd = CommUtil.getDecrypt(_scqkey, _web_pwd);
        	
    		//쿠콘 API 호출 - 법인카드 승인내역 가맹점 상세조회 - 실시간
    		JSONObject rsltData = CooconApi.getCorpCardApprHstrWithMest(coo_bank_cd, _web_id, _web_pwd, _card_no, _start_date, _end_date);
    		
        	String rsltCd = StringUtil.null2void(rsltData.getString("RESULT_CD"));
        	String rsltMsg = StringUtil.null2void(rsltData.getString("RESULT_MG"));

        	if ("".equals(rsltCd)) {
        		rsltCd = StringUtil.null2void(rsltData.getString("ERRCODE"));
        		rsltMsg = StringUtil.null2void(rsltData.getString("ERRMSG"));
        	}

        	//최종조회일자
        	String shis_lst_dtm = SvcDateUtil.getInstance().getDate()+"000000";
    		if(_pay_yn.equals("Y")) {
    			shis_lst_dtm = SvcDateUtil.getInstance().getDate() + SvcDateUtil.getShortTimeString();
    		}
    		String his_lst_dtm = shis_lst_dtm;
    		
			if( !"00000000".equals(rsltCd))
        	{
        		//오류인 경우 최종조회일자를 조회시작일자로 처리(재조회 가능하도록)
				his_lst_dtm = "";

    			//42110000 : 조회된 내용이 없습니다. : 은행 사이트에 거래 결과가 없음.(정상거래)
    			//최종조회일자일 조회종료일로 처리(정상일 때와 동일하게)
    			if("42110000".equals(rsltCd)) {
    				rsltCd = "0000";
    				his_lst_dtm = shis_lst_dtm;
    			}

    			//최종조회일시 변경
            	updateCardApvHisLst(his_lst_dtm, rsltCd, rsltMsg);
        	}
        	else
        	{
        		rsltCd = "0000";

        		JexConnection idoCon = JexConnectionManager.createIDOConnection();
        		idoCon.beginTransaction();

        		try {
            		// 기존 등록된 데이타가 있으면 삭제.
        			deleteApvHisData(idoCon);

            		//저장내역 등록 정보
            		JexDataList<JexData> insertData = new JexDataRecordList<JexData>();

            		JSONArray arr_resp_data =  rsltData.getJSONArray("RESP_DATA");
            		for(Object row : arr_resp_data)
            		{
            			JSONObject resp_data = (JSONObject)row;

            			insertData.add(insertApvHisData(resp_data));
            		}

            		// 등록
        			JexDataList<JexData> idoOutBatch =  idoCon.executeBatch(insertData);
        			if (DomainUtil.isError(idoOutBatch)) throw new JexTransactionRollbackException(idoOutBatch);

        			//최종조회일시 변경 - 삭제 및 저장 시 오류가 나면 최종조회일시를 업데이트 하지 않기 위해 이곳에서 호출한다.
                	updateCardApvHisLst(his_lst_dtm, rsltCd, rsltMsg);

            	} catch (Exception e) {
    				BizLogUtil.error(this, _use_intt_id, e, "Thread ["+Thread.currentThread().getName()+"]");
    			}

        		idoCon.endTransaction();
        	}

		} catch (Exception e) {
			// 쓰레드 비정상 종료
			BizLogUtil.error(this, _use_intt_id, e, "Thread ["+Thread.currentThread().getName()+"]");
		}
	}

	/**
	 * <pre>
	 * 기 등록된 법인카드 승인내역 삭제
	 * </pre>
	 * @param idoCon
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void deleteApvHisData(JexConnection idoCon)
			throws JexException, JexBIZException {

		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("CARD_BUY_APV_HSTR_D001");
        idoIn1.put("USE_INTT_ID", _use_intt_id);
        idoIn1.put("BANK_CD"    , _bank_cd);
        idoIn1.put("CARD_NO"    , _card_no);
        idoIn1.put("START_DT"   , _start_date);
        idoIn1.put("END_DT"     , _end_date);
        JexData idoOut1 = idoCon.execute(idoIn1);

        if (DomainUtil.isError(idoOut1))
            throw new JexTransactionRollbackException(idoOut1);
	}

	/**
	 * <pre>
	 * 법인카드 승인내역 등록
	 * </pre>
	 * @param data
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JexData insertApvHisData(JSONObject data) throws JexException, JexBIZException
	{
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn = util.createIDOData("CARD_BUY_APV_HSTR_C001");
		
		idoIn.put("USE_INTT_ID" , _use_intt_id);
		idoIn.put("BANK_CD"     , _bank_cd);
		idoIn.put("CARD_NO"     , _card_no);

		String strBuySum = data.getString("APPROVAL_AMOUNT");
		String strApvCanYn = "A";
		//취소일자가 있다면 승인취소거래임
        if(!StringUtil.isBlank(data.getString("DATE_CANCEL"))){
            strApvCanYn = "B";
            if(Float.parseFloat(strBuySum) > 0f){
                strBuySum = "-" + strBuySum;
            }
        }

		idoIn.put("APV_DT"      , data.getString("APPROVAL_DATE"));
		idoIn.put("APV_NO"      , data.getString("APPROVAL_CODE"));
		idoIn.put("APV_TM"      , data.getString("APPROVAL_TIME"));
		idoIn.put("APV_CAN_YN"  , strApvCanYn);
		idoIn.put("APV_CAN_DT"  , data.getString("DATE_CANCEL"));
		idoIn.put("BUY_SUM"     , strBuySum);
		idoIn.put("CARD_KIND"   , data.getString("CARD_CLASS"));
		idoIn.put("PRD_DIV"     , "");
		idoIn.put("ITLM_MMS_CNT", data.getString("INSTALLMENT_DIVID"));
		idoIn.put("MEST_NM"     , data.getString("BRANCH_DESC"));
		idoIn.put("MEST_BIZ_NO" , data.getString("BRANCH_REGNO_COMPANY"));
		idoIn.put("MEST_NO"     , data.getString("BRANCH_CODE"));
		idoIn.put("MEST_TYPE"   , data.getString("BRANCH_TYPE"));
		idoIn.put("MEST_ADDR_1" , data.getString("BRANCH_ADDR"));
		idoIn.put("MEST_ADDR_2" , "");
		idoIn.put("AREA_DIV"    , data.getString("APPROVAL_AREA"));
		idoIn.put("SETL_SCHE_DT", "");//data.getString("PAYMENT_DATE"));
		idoIn.put("BUY_YN"      , data.getString("FLAG_ISBUY"));
		idoIn.put("DEPT_NM"     , data.getString("POST_DESC"));
		idoIn.put("BANK_NM"     , data.getString("BANK_DESC"));
		idoIn.put("CURR_CD"     , data.getString("CURRENCY"));
		idoIn.put("CARDNOTYPE"  , data.getString("CARD_NO_TYPE"));
		idoIn.put("BIZ_TYPE_CD" , "");
		idoIn.put("REG_USER_ID" , "SYSTEM");

		return idoIn;
	}

	/**
	 * <pre>
	 * 법인카드 승인내역 최종조회일시 변경
	 * </pre>
	 * @param apv_his_lst_dtm
	 * @param apv_his_lst_stts
	 * @param apv_his_lst_msg
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void updateCardApvHisLst(String apv_his_lst_dtm, String apv_his_lst_stts,
			String apv_his_lst_msg) throws JexException, JexBIZException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContext.getContext().getCommonUtil();

        JexData idoIn1 = util.createIDOData("CARD_INFM_U006");
        
        idoIn1.put("USE_INTT_ID"     , _use_intt_id);
        idoIn1.put("CARD_NO"         , _card_no);
        //idoIn1.put("APV_HIS_LST_DTM"  , apv_his_lst_dt + SvcDateUtil.getShortTimeString());
        idoIn1.put("RT_APV_HIS_LST_DTM"  , apv_his_lst_dtm);
        idoIn1.put("APV_HIS_LST_STTS", apv_his_lst_stts);
        idoIn1.put("APV_HIS_LST_MSG" , apv_his_lst_msg);
        JexData idoOut1 = idoCon.execute(idoIn1);

        if (DomainUtil.isError(idoOut1))
        {
            BizLogUtil.error(this, "Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
            BizLogUtil.error(this, "Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
        }
	}

}
