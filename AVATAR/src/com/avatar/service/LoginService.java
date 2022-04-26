package com.avatar.service;

import jex.data.JexData;
import jex.data.JexDataList;
import jex.data.impl.cmo.JexDataCMO;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.json.JSONArray;
import jex.json.JSONObject;
import jex.log.JexLogFactory;
import jex.log.JexLogger;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.util.DomainUtil;
import jex.util.StringUtil;
import jex.util.biz.JexCommonUtil;
import jex.util.date.DateTime;
import jex.web.JexContextWeb;
import jex.web.exception.JexWebBIZException;
import com.avatar.api.mgnt.PushApiMgnt;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.COMCode;
import com.avatar.comm.CommUtil;
import com.avatar.comm.CommonErrorHandler;

public class LoginService {


	private static final JexLogger LOG = JexLogFactory.getLogger(LoginService.class);

	/**
	 * 세션 정보 생성
	 *
	 * @param input
	 * @param sessionCmo
	 * @param result
	 * @param user_gb
	 * @param user_id
	 * @param use_intt_id
	 * @param inst_yn
	 * @throws JexException
	 * @throws JexBIZException
	 */
	
/*	
	public void setMasterUserSession(JexData input, JexDataCMO sessionCmo, JexData result, String user_gb, String user_id, String use_intt_id, String inst_yn)
			throws JexException, JexBIZException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContextWeb.getContext().getCommonUtil();


		// 사용자 이용기관정보 조회
		JexData idoIn = util.createIDOData("USER_LDGR_R003");
		idoIn.put("USER_ID", user_id);
		JexData idoOut = idoCon.execute(idoIn);

		if (DomainUtil.isError(idoOut)) CommonErrorHandler.comHandler(idoOut);

		// 세션 정보 입력
		sessionCmo.put("PTL_ID"          , CommUtil.getPtlId()); // 포탈아이디
		sessionCmo.put("USER_ID"         , idoOut.getString("USER_ID")); // 사용자ID
		sessionCmo.put("CLPH_NO"         , idoOut.getString("CLPH_NO")); // 휴대폰번호
		sessionCmo.put("USER_NM"         , idoOut.getString("RPPR_NM")); // 사용자명
		sessionCmo.put("BSNN_NO"         , idoOut.getString("BSNN_NO")); // 사업자번호
		sessionCmo.put("BSNN_NM"         , idoOut.getString("BSNN_NM")); // 사업장명
		sessionCmo.put("STTS"            , idoOut.getString("INTT_STTS")); // 상태
		sessionCmo.put("ACCT_REG_YN"     , ""); // 계좌등록여부
		sessionCmo.put("CARD_REG_YN"     , ""); // 신용카드등록여부
		sessionCmo.put("RCV_CARD_REG_YN" , ""); // 매출신용카드등록여부
		sessionCmo.put("SCQKEY"          , idoOut.getString("USER_ID") + CommUtil.getPreScqKey()); // 키보드보안키
		sessionCmo.put("APP_OS"          , input.getString("APP_OS")); // 앱실행OS
		sessionCmo.put("APP_VER"         , input.getString("APP_VER")); // 앱버젼
		sessionCmo.put("ADRS"            , idoOut.getString("ADRS")); // 주소
		sessionCmo.put("DTL_ADRS"        , idoOut.getString("DTL_ADRS")); // 상세주소
		sessionCmo.put("RPPR_NM"         , idoOut.getString("RPPR_NM")); // 대표자명
		sessionCmo.put("PAYR_NO"         , idoOut.getString("PAYR_NO")); // 납부자번호
		sessionCmo.put("EMAL"         	 , idoOut.getString("EML"));  // 이메일
		sessionCmo.put("BSST"         	 , idoOut.getString("BSST")); // 업태
		sessionCmo.put("TPBS"         	 , idoOut.getString("TPBS")); // 업종



		//응답값 세팅
		result.put("USER_NM"           , idoOut.getString("RPPR_NM"));
        result.put("BSNN_NO"           , idoOut.getString("BSNN_NO"));
        result.put("BSNN_NM"           , idoOut.getString("BSNN_NM"));
        result.put("RPPR_NM"           , idoOut.getString("RPPR_NM"));
        result.put("ADRS"              , idoOut.getString("ADRS"));
        result.put("DTL_ADRS"          , idoOut.getString("DTL_ADRS"));
        result.put("CLPH_NO"           , idoOut.getString("CLPH_NO"));
        result.put("DEVICE_INST_ID"    , idoOut.getString("DEVICE_INST_ID"));
        result.put("DEVICE_ID"         , idoOut.getString("DEVICE_INST_ID"));
        
		// 계좌 등록 여부
		getAcctRegYn(idoCon, util, sessionCmo);
		// 카드 등록 여부
		getCardRegYn(idoCon, util, sessionCmo);


		String payAcctUpdYn = StringUtil.null2void(idoOut.getString("PAY_ACCT_UPD_YN"),"N"); //지급계좌변경여부
		String userLoginHisYn = getInstYn(idoCon, util, result, use_intt_id);

		// 앱 재설치, 수수류 계좌 수정시 재인증
		if("Y".equals(inst_yn) || "Y".equals(payAcctUpdYn))
		{
			//간편송금 계좌 변경과 앱재설치가 동시에 일어날시
			//인증을 두번 받아야 하는 경우가 생김 추후 변경이 필요 한것 같음
			if("Y".equals(userLoginHisYn))
			{
				result.put("RINST_CERT_TYPE", "1");
				result.put("RINST_CERT_YN"  , "Y");
			}
			else if("Y".equals(payAcctUpdYn))
			{
				result.put("RINST_CERT_TYPE", "2");
				result.put("RINST_CERT_YN"  , "Y");
			}else {
				result.put("RINST_CERT_YN"  , "N");
			}

		}
		else
		{
			//
			result.put("RINST_CERT_YN"  , "N");
			result.put("RINST_CERT_TYPE", "");
		}

		// 재설치 인증 없음. 지급계좌변경은 차후 검토.
		result.put("RINST_CERT_YN"  , "N");
		result.put("RINST_CERT_TYPE", "");
	}
*/
	/**
	 * 기존 설치여부 조회
	 *
	 * @param idoCon
	 * @param util
	 * @param result
	 * @param use_intt_id
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private String getInstYn(JexConnection idoCon, JexCommonUtil util, JexData result, String use_intt_id)
			throws JexException, JexBIZException {

		JexData idoIn = util.createIDOData("USER_LOGIN_HIS_R001");
		idoIn.put("USE_INTT_ID", use_intt_id);
		JexData idoOut = idoCon.execute(idoIn);

		if (DomainUtil.isError(idoOut)) CommonErrorHandler.comHandler(idoOut);

		String lnstYn = "";
		if("".equals(StringUtil.null2void(idoOut.getString("LOGIN_DATE")))){
			lnstYn = "N";
		}else{
			lnstYn = "Y";
		}

		return lnstYn;
	}

	/**
	 * 계좌 등록 여부
	 *
	 * @param idoCon
	 * @param util
	 * @param sessionCmo
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void getAcctRegYn(JexConnection idoCon, JexCommonUtil util, JexDataCMO sessionCmo)
			throws JexException, JexBIZException {

		JexData idoIn = util.createIDOData("ACCT_LDGR_R005");
		idoIn.put("PTL_ID", CommUtil.getPtlId());
		idoIn.put("USE_INTT_ID", sessionCmo.getString("USE_INTT_ID"));
		JexData idoOut = idoCon.execute(idoIn);

		if (DomainUtil.isError(idoOut)) CommonErrorHandler.comHandler(idoOut);

		sessionCmo.put("ACCT_REG_YN", idoOut.getString("CASH_REG_YN")); // 계좌등록여부

	}

	/**
	 * 카드 등록 여부
	 *
	 * @param idoCon
	 * @param util
	 * @param sessionCmo
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void getCardRegYn(JexConnection idoCon, JexCommonUtil util, JexDataCMO sessionCmo)
			throws JexException, JexBIZException {

		JexData idoIn = util.createIDOData("CARD_LDGR_R006");
		idoIn.put("PTL_ID", CommUtil.getPtlId());
		idoIn.put("USE_INTT_ID", sessionCmo.getString("USE_INTT_ID"));
		JexData idoOut = idoCon.execute(idoIn);

		if (DomainUtil.isError(idoOut)) CommonErrorHandler.comHandler(idoOut);

		sessionCmo.put("CARD_REG_YN", idoOut.getString("CARD_REG_YN")); //

	}


	/**
	 * 디바이스 정보 등록
	 *
	 * @param use_intt_id
	 * @param device_info
	 * @throws JexException
	 * @throws JexBIZException
	 * @throws JexWebBIZException
	 */
	public void deviceInfoService(String use_intt_id, JSONObject device_info)
			throws JexException, JexBIZException, JexWebBIZException {


		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContextWeb.getContext().getCommonUtil();

		idoCon.beginTransaction();

		JexData idoIn = util.createIDOData("PUSH_DEVI_LDGR_R003");
		idoIn.put("USE_INTT_ID", use_intt_id);
		JexData idoOut = idoCon.execute(idoIn);

		if (DomainUtil.isError(idoOut)) CommonErrorHandler.comHandler(idoOut);

		String inDevice_id = StringUtil.null2void(idoOut.getString("DEVICE_ID"));
		String inPush_id = StringUtil.null2void(idoOut.getString("PUSH_ID"));

		String newDevice_id = StringUtil.null2void(device_info.getString("_device_id"));
		String newPush_id = StringUtil.null2void(device_info.getString("_push_id"));


		LOG.debug("등록된 Device_id >> " + inDevice_id);
		LOG.debug("등록된 Push_id >> " + inPush_id);
		LOG.debug("신규 Device_id >> " + newDevice_id);
		LOG.debug("신규 Push_id >> " + newPush_id);

		// 등록 된 디바이스 정보가 없을경우
		if( "".equals(inDevice_id) )
		{
			// 새로운 디바이스 등록
			try{
				insertDevice(idoCon, util, use_intt_id, device_info);
			}catch(Exception e) {
				BizLogUtil.debug(this, "device_info 등록오류 ");
        		BizLogUtil.debug(this, "device_info >> " + device_info.toJSONString());
			}
		}
		else {

			// 정보가 맞지 않을경우
			if( !inDevice_id.equals(newDevice_id) || !inPush_id.equals(newPush_id) )
			{
				LOG.debug("다른 디바이스일경우 실행");
				// 기존 정보 해지
				try {
					deviceDelete(idoCon, util, idoOut, use_intt_id);
				}catch(Exception e) {
					BizLogUtil.debug(this, "device_info 삭제오류 ");
					BizLogUtil.debug(this, "device_info >> " + device_info.toJSONString());
				}
				// 새로운 디바이스 등록
				try{
					insertDevice(idoCon, util, use_intt_id, device_info);
				}catch(Exception e) {
					BizLogUtil.debug(this, "device_info 등록오류 ");
	        		BizLogUtil.debug(this, "device_info >> " + device_info.toJSONString());
				}
			}

		}

		idoCon.commit();
		idoCon.endTransaction();

	}


	/**
	 * 푸시 API 호출
	 *
	 * @param api
	 * @param user_id
	 * @param device_info
	 * @throws JexWebBIZException
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void pushApiCall(String api, String user_id, JSONObject device_info)
			throws JexWebBIZException, JexException, JexBIZException {

		JSONObject mPushTrnRes = null;
		JSONArray mPushResArr = null;
		JSONObject mPushRespData = null;
		// 등록
		if("PS0002".equals(api))
		{
			mPushTrnRes = PushApiMgnt.svc_PS0002(user_id, device_info);

		}
		else if("PS0005".equals(api))
		{
			mPushTrnRes = PushApiMgnt.svc_PS0005(device_info.getString("REMARK")
					, device_info.getString("DEVICE_ID")
					, device_info.getString("PUSHSERVER_KIND"));
		}

		mPushResArr = (JSONArray)mPushTrnRes.get("_tran_res_data");
		mPushRespData  = (JSONObject)mPushResArr.get(0);

		// 응답값이 없을경우
		if(mPushRespData.isEmpty())
		{
			throw new JexWebBIZException(COMCode.COM_CODE_0014, COMCode.getErrCodeCustMsg(COMCode.COM_CODE_0014));
		}
		else
		{
			// 응답값이 정상이 이닐경우
			if(!StringUtil.null2void((String)mPushRespData.get("_result"), "false").trim().equals("true"))
			{
				throw new JexWebBIZException(COMCode.COM_CODE_0014, COMCode.getErrCodeCustMsg(COMCode.COM_CODE_0014));
			}
		}
	}

	/**
	 * 디바이스 정보 저장
	 *
	 * @param idoCon
	 * @param util
	 * @param user_id
	 * @param use_intt_id
	 * @param device_info
	 * @throws JexException
	 * @throws JexBIZException
	 * @throws JexWebBIZException
	 */
	private void insertDevice(JexConnection idoCon, JexCommonUtil util, String use_intt_id, JSONObject device_info)
			throws JexException, JexBIZException, JexWebBIZException {

		pushApiCall("PS0002", use_intt_id, device_info);

		// 정상이면

		// 원장 등록
		JexData idoIn1 = util.createIDOData("PUSH_DEVI_LDGR_C001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("DEVICE_ID", device_info.getString("_device_id"));
		idoIn1.put("PUSH_ID", device_info.getString("_push_id"));
		idoIn1.put("PUSHSERVER_KIND", device_info.getString("_pushserver_kind"));
		idoIn1.put("MODEL_NAME", device_info.getString("_model_name"));
		idoIn1.put("OS", device_info.getString("_os"));
		idoIn1.put("RETRANS_YN", "");
		idoIn1.put("REMARK", device_info.getString("_remark"));
		idoIn1.put("DEL_YN", "N");
		idoIn1.put("REGR_ID", use_intt_id);
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) CommonErrorHandler.comHandler(idoOut1);


		// 이력 등록
		JexData idoIn2 = util.createIDOData("PUSH_DEVI_LDGR_HIS_C002");
		idoIn2.put("PTL_ID", CommUtil.getPtlId());
		idoIn2.put("USE_INTT_ID", use_intt_id);
		idoIn2.put("DEVICE_ID", device_info.getString("_device_id"));
		idoIn2.put("DEL_YN", "N");
		idoIn2.put("REGR_ID", use_intt_id);
		JexData idoOut2 = idoCon.execute(idoIn2);

		if (DomainUtil.isError(idoOut2)) CommonErrorHandler.comHandler(idoOut2);
	}


	/**
	 * 디바이스 정보 삭제
	 *
	 * @param idoCon
	 * @param util
	 * @param inDeviceInfo
	 * @param use_intt_id
	 * @param user_id
	 * @throws JexException
	 * @throws JexBIZException
	 * @throws JexWebBIZException
	 */
	private void deviceDelete(JexConnection idoCon, JexCommonUtil util, JexData inDeviceInfo, String use_intt_id)
			throws JexException, JexBIZException, JexWebBIZException {

		// 이력 등록
		JexData idoIn1 = util.createIDOData("PUSH_DEVI_LDGR_HIS_C002");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("DEVICE_ID", inDeviceInfo.getString("DEVICE_ID"));
		idoIn1.put("DEL_YN", "Y");
		idoIn1.put("REGR_ID", use_intt_id);
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) CommonErrorHandler.comHandler(idoOut1);

		// 디바이스 원장 삭제
		JexData idoIn2 = util.createIDOData("PUSH_DEVI_LDGR_D001");
		idoIn2.put("USE_INTT_ID", use_intt_id);
		idoIn2.put("DEVICE_ID", inDeviceInfo.getString("DEVICE_ID"));
		JexData idoOut2 = idoCon.execute(idoIn2);

		if (DomainUtil.isError(idoOut2)) CommonErrorHandler.comHandler(idoOut2);


		JSONObject device_info = new JSONObject();
		DomainUtil.setJexData2JSON(device_info, inDeviceInfo);

		pushApiCall("PS0005", use_intt_id, device_info);


	}


	/**
	 * 팝업 공지 조회
	 *
	 * @param result
	 * @throws JexException
	 * @throws JexBIZException
	 */
	public void setPopupList(JexData result) throws JexException, JexBIZException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContextWeb.getContext().getCommonUtil();

		JexData idoIn = util.createIDOData("POPU_NOTI_INFM_R001");

		JexDataList<JexData> idoOut = idoCon.executeList(idoIn);

		if (DomainUtil.isError(idoOut)) CommonErrorHandler.comHandler(idoOut);

		result.put("POPU_NOTI_LIST", idoOut);

	}

	/**
	 * 알림(브리핑) 상단 메시지 조회
	 *
	 * @param result
	 * @param use_intt_id
	 * @throws JexException
	 * @throws JexBIZException
	 */
	public void setBrifList(JexData result, String use_intt_id) throws JexException, JexBIZException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContextWeb.getContext().getCommonUtil();

	    JexData idoIn1 = util.createIDOData("CERT_LDGR_R004");
        idoIn1.put("USE_INTT_ID", use_intt_id);
        idoIn1.put("TODAY1", DateTime.getInstance().getDate("yyyymmdd"));
        idoIn1.put("TODAY2", DateTime.getInstance().getDate("yyyymmdd", 'M', +1));

        JexData idoOut1 =  idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) CommonErrorHandler.comHandler(idoOut1);

		JSONArray brif_list = new JSONArray();
        JSONObject brif_row_c = new JSONObject();
        JSONObject brif_row_u = new JSONObject();

        result.put("CERT_EXPI_STTS", "0");

        if( !"".equals(StringUtil.null2void(idoOut1.getString("EXPI"))) && !"".equals(StringUtil.null2void(idoOut1.getString("BE_EXPI"))))
        {
        	// '0:정상, 1:만료전, 8:만료전+만료, 9:만료
        	if( !"0".equals(idoOut1.getString("EXPI")) && !"0".equals(idoOut1.getString("BE_EXPI")) )
        	{

        		result.put("CERT_EXPI_STTS", "8");

        		brif_row_c.put("BRIF_TYPE", "C");
        		brif_row_c.put("BRIF_CTT", "등록된 인증서가 만료되었습니다.");
        		brif_list.add(brif_row_c);

        		brif_row_u.put("BRIF_TYPE", "U");
        		brif_row_u.put("BRIF_CTT", "등록된 인증서가 한달 안으로 만료됩니다.");
        		brif_list.add(brif_row_u);
        	}
        	// 만료전 만 있을때
        	else if( "0".equals(idoOut1.getString("EXPI")) && !"0".equals(idoOut1.getString("BE_EXPI")) )
        	{
        		result.put("CERT_EXPI_STTS", "1");

        		brif_row_u.put("BRIF_TYPE", "U");
        		brif_row_u.put("BRIF_CTT", "등록된 인증서가 한달 안으로 만료됩니다.");
        		brif_list.add(brif_row_u);
        	}
        	// 만료만 있을때
        	else if( !"0".equals(idoOut1.getString("EXPI")) && "0".equals(idoOut1.getString("BE_EXPI")) )
        	{
        		result.put("CERT_EXPI_STTS", "9");

        		brif_row_c.put("BRIF_TYPE", "C");
        		brif_row_c.put("BRIF_CTT", "등록된 인증서가 만료되었습니다.");
        		brif_list.add(brif_row_c);
        	}
        }


		result.put("BRIF_LIST", brif_list);

	}

	/**
	 * 기관 정보 조회
	 *
	 * @param user_id
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	public JexData getInttLdgrInfo(String user_id) throws JexException, JexBIZException {
		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContextWeb.getContext().getCommonUtil();

		JexData idoIn = util.createIDOData("USER_LDGR_R003");
		idoIn.put("USER_ID", user_id);
		JexData idoOut = idoCon.execute(idoIn);

		if (DomainUtil.isError(idoOut)) CommonErrorHandler.comHandler(idoOut);

		return idoOut;
	}

	/**
	 * 로그인 이력 저장
	 *
	 * @param use_intt_id
	 * @param user_id
	 * @param login_date
	 * @param exec_time
	 * @param user_gb
	 * @param host_nm
	 * @param user_ip
	 * @param req_head
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	public JexData insLoginHis(String use_intt_id, String host_nm, String user_ip)
			throws JexException, JexBIZException {
		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContextWeb.getContext().getCommonUtil();
			
//		JexData idoIn = util.createIDOData("USER_LOGIN_HIS_C001");
		JexData idoIn = util.createIDOData("CUST_LGIN_HIS_C001");
		idoIn.put("USE_INTT_ID", use_intt_id);
//		idoIn.put("LOGIN_DATE", login_date);
//		idoIn.put("EXEC_TIME", exec_time);
//		idoIn.put("USER_GB", user_gb);
//		idoIn.put("HOST_NM", host_nm);
//		idoIn.put("USER_IP", user_ip);
//		idoIn.put("REQ_HEAD", req_head);
		
		idoIn.put("ACCS_SVR", host_nm);
		idoIn.put("ACCS_IP", user_ip);
		JexData idoOut = idoCon.execute(idoIn);

		if (DomainUtil.isError(idoOut)) CommonErrorHandler.comHandler(idoOut);

		return idoOut;
	}



}
