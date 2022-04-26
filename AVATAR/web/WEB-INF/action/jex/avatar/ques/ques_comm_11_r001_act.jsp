<%@page contentType="text/html;charset=UTF-8"%>

<%@page import="jex.util.DomainUtil"%>
<%@page import="jex.log.JexLogFactory"%>
<%@page import="jex.log.JexLogger"%>
<%@page import="jex.data.JexData"%>
<%@page import="jex.data.annotation.JexDataInfo"%>
<%@page import="jex.enums.JexDataType"%>
<%@page import="jex.data.JexDataList"%>
<%@page import="jex.web.util.WebCommonUtil"%>
<%@page import="jex.resource.cci.JexConnection"%>
<%@page import="jex.web.exception.JexWebBIZException"%>
<%@page import="jex.resource.cci.JexConnectionManager"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="jex.json.parser.JSONParser"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.resource.cci.JexConnection"%>
<%@page import="jex.resource.cci.JexConnectionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>

<%
	/**
	 * <pre>
	 * AVATAR
	 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
	 *
	 * @File Title   : 질의조회_IBKCRM
	 * @File Name    : ques_comm_11_r001_act.jsp
	 * @File path    : ques
	 * @author       : jedkim (  )
	 * @Description  : 
	 * @Register Date: 20220401162424
	 * </pre>
	 *
	 * ============================================================
	 * 참조
	 * ============================================================
	 * 본 Action을 사용하는 View에서는 해당 도메인을 import하고.
	 * 응답 도메인에 대한 객체를 아래와 같이 생성하여야 합니다.
	 *
	 **/

	WebCommonUtil util = WebCommonUtil.getInstace(request, response);

	@JexDataInfo(id = "ques_comm_11_r001", type = JexDataType.WSVC)
	JexData input = util.getInputDomain();
	JexData result = util.createResultDomain();
	
	// IDO Connection
	JexConnection idoCon = JexConnectionManager.createIDOConnection();
	
	// Get Session
    JexDataCMO userSession = SessionManager.getSession(request, response);
    String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
    String APP_ID = StringUtil.null2void(userSession.getString("APP_ID"), "AVATAR");
    String LGIN_APP = StringUtil.null2void(userSession.getString("LGIN_APP"), "AVATAR");
	String LAST_MNGM_BRCD = StringUtil.null2void(userSession.getString("LAST_MNGM_BRCD"), "");
	String MBCD = StringUtil.null2void(userSession.getString("MBCD"), "");
	String CSMN_TEAM_DLCD = StringUtil.null2void(userSession.getString("CSMN_TEAM_DLCD"), "");

	
	//음성 결과  ex) INTE_INFO:{"recog_txt":"매출 매입 데이타 ?","recog_data":{"Intent":"SAMPLE","appInfo":{"NE-DAY":"오늘"}} };
	JSONObject inteInfo = (JSONObject) JSONParser.parser(StringUtil.null2void(input.getString("INTE_INFO")));
	//         util.getLogger().debug("1 : " + inteInfo);
	String recog_txt = StringUtil.null2void((String) inteInfo.get("recog_txt"));
	JSONObject recog_data = (JSONObject) inteInfo.get("recog_data");
	String Intent = StringUtil.null2void((String) recog_data.get("Intent"));
	JSONObject appInfo = (JSONObject) recog_data.get("appInfo");
	String appId = "";
	String apiId = "";

	JSONObject rslt_ctt = new JSONObject();


	//-------------------------------------
	//인텐트정보에 등록된 html, query 가져오기
	//-------------------------------------
	// 로그인한 APP에 해당하는 질의만 보여줌.
	JexData idoIn1 = util.createIDOData("INTE_INFM_R011");
	idoIn1.put("INTE_CD", Intent);
	idoIn1.put("USE_INTT_ID", USE_INTT_ID);
	idoIn1.put("APP_ID", LGIN_APP);

	JexData idoOut1 = idoCon.execute(idoIn1);
	if (DomainUtil.isError(idoOut1)) {
		if (util.getLogger().isDebug()) {
			util.getLogger().debug("Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
			util.getLogger().debug("Error Message::" + DomainUtil.getErrorMessage(idoOut1));
		}
		throw new JexWebBIZException(idoOut1);
	}

	result.put("OTXT_HTML", StringUtil.null2void(idoOut1.getString("OTXT_HTML")));

	// 브리핑 현황
	if ("IB001".equals(Intent)) {
		JexData idoIn = util.createIDOData("IBK_BR_INFM_R001");
		if(appInfo.get("NE-BRIEFINGSTATUS") == null) {
			// 브리핑 전체
			idoIn.put("LAST_MNGM_BRCD", LAST_MNGM_BRCD);	// 최종관리부점코드
			idoIn.put("MBCD", MBCD);	// 모점코드
			idoIn.put("CSMN_TEAM_DLCD", CSMN_TEAM_DLCD);	// 고객관리팀세부코드
			JexData idoOut =  idoCon.execute(idoIn);
			String lnttNbi = idoOut.getString("LNTT_NBI");
			String lnttAmt = StringUtil.null2void(idoOut.getString("LNTT_AMT"));
			String prodLoanNewNbi = StringUtil.null2void(idoOut.getString("PRDD_LOAN_NEW_NBI"));
			String prodLoanNewAmt = StringUtil.null2void(idoOut.getString("PRDD_LOAN_NEW_AMT"));
			String prodLoanRpmnNbi = StringUtil.null2void(idoOut.getString("PRDD_LOAN_RPMN_NBI"));
			String prodLoanRpmnAmt = StringUtil.null2void(idoOut.getString("PRDD_LOAN_RPMN_AMT"));

			String depNbi = idoOut.getString("DEP_NBI");
			String depAvb = StringUtil.null2void(idoOut.getString("DEP_AVB"));
			String depIntpEpadNbi = StringUtil.null2void(idoOut.getString("DEP_INTP_EPAD_NBI"));
			String depIntpEpadAmt = StringUtil.null2void(idoOut.getString("DEP_INTP_EPAD_AMT"));
			String depDeptEpadNbi = StringUtil.null2void(idoOut.getString("DEP_DEPT_EPAD_NBI"));
			String depDeptEpadAmt = StringUtil.null2void(idoOut.getString("DEP_DEPT_EPAD_AMT"));

			// 대출
			rslt_ctt.put("LNTT_NBI", lnttNbi);
			rslt_ctt.put("LNTT_AMT", lnttAmt);
			rslt_ctt.put("PRDD_LOAN_NEW_NBI", prodLoanNewNbi);
			rslt_ctt.put("PRDD_LOAN_NEW_AMT", prodLoanNewAmt);
			rslt_ctt.put("PRDD_LOAN_RPMN_NBI", prodLoanRpmnNbi);
			rslt_ctt.put("PRDD_LOAN_RPMN_AMT", prodLoanRpmnAmt);

			// 외환
			rslt_ctt.put("DEP_NBI", depNbi);
			rslt_ctt.put("DEP_AVB", depAvb);
			rslt_ctt.put("DEP_INTP_EPAD_NBI", depIntpEpadNbi);
			rslt_ctt.put("DEP_INTP_EPAD_AMT", depIntpEpadAmt);
			rslt_ctt.put("DEP_DEPT_EPAD_NBI", depDeptEpadNbi);
			rslt_ctt.put("DEP_DEPT_EPAD_AMT", depDeptEpadAmt);

		} else {
			// 대출 현황
			if(appInfo.get("NE-BRIEFINGSTATUS").equals("대출")) {
				idoIn.put("LAST_MNGM_BRCD", LAST_MNGM_BRCD);
				idoIn.put("MBCD", MBCD);
				idoIn.put("CSMN_TEAM_DLCD", CSMN_TEAM_DLCD);
//			idoIn.put("BASE_YMD","2022-03-31");
				JexData idoOut =  idoCon.execute(idoIn);
				String lnttNbi = idoOut.getString("LNTT_NBI");
				String lnttAmt = StringUtil.null2void(idoOut.getString("LNTT_AMT"));
				String prodLoanNewNbi = StringUtil.null2void(idoOut.getString("PRDD_LOAN_NEW_NBI"));
				String prodLoanNewAmt = StringUtil.null2void(idoOut.getString("PRDD_LOAN_NEW_AMT"));
				String prodLoanRpmnNbi = StringUtil.null2void(idoOut.getString("PRDD_LOAN_RPMN_NBI"));
				String prodLoanRpmnAmt = StringUtil.null2void(idoOut.getString("PRDD_LOAN_RPMN_AMT"));

				rslt_ctt.put("MDDV_CD", "대출현황");
				rslt_ctt.put("LNTT_AMT", lnttAmt);
				rslt_ctt.put("LNTT_NBI", lnttNbi);
				rslt_ctt.put("PRDD_LOAN_NEW_NBI", prodLoanNewNbi);
				rslt_ctt.put("PRDD_LOAN_NEW_AMT", prodLoanNewAmt);
				rslt_ctt.put("PRDD_LOAN_RPMN_NBI", prodLoanRpmnNbi);
				rslt_ctt.put("PRDD_LOAN_RPMN_AMT", prodLoanRpmnAmt);
			}
			else if(appInfo.get("NE-BRIEFINGSTATUS").equals("외환")) {
				// 외환 현황
				idoIn.put("LAST_MNGM_BRCD", LAST_MNGM_BRCD);
				idoIn.put("MBCD", MBCD);
				idoIn.put("CSMN_TEAM_DLCD", CSMN_TEAM_DLCD);
//			idoIn.put("BASE_YMD","2022-03-31");
				JexData idoOut =  idoCon.execute(idoIn);
				String lnttNbi = idoOut.getString("LNTT_NBI");
				String lnttAmt = StringUtil.null2void(idoOut.getString("LNTT_AMT"));
				String prodLoanNewNbi = StringUtil.null2void(idoOut.getString("PRDD_LOAN_NEW_NBI"));
				String prodLoanNewAmt = StringUtil.null2void(idoOut.getString("PRDD_LOAN_NEW_AMT"));
				String prodLoanRpmnNbi = StringUtil.null2void(idoOut.getString("PRDD_LOAN_RPMN_NBI"));
				String prodLoanRpmnAmt = StringUtil.null2void(idoOut.getString("PRDD_LOAN_RPMN_AMT"));

				rslt_ctt.put("MDDV_CD", "대출현황");
				rslt_ctt.put("LNTT_NBI", lnttNbi);
				rslt_ctt.put("LNTT_AMT", lnttAmt);
				rslt_ctt.put("PRDD_LOAN_NEW_NBI", prodLoanNewNbi);
				rslt_ctt.put("PRDD_LOAN_NEW_AMT", prodLoanNewAmt);
				rslt_ctt.put("PRDD_LOAN_RPMN_NBI", prodLoanRpmnNbi);
				rslt_ctt.put("PRDD_LOAN_RPMN_AMT", prodLoanRpmnAmt);
			}
		}
	}

	result.put("RSLT_CTT", rslt_ctt.toJSONString()); //질의결과값

	util.setResult(result, "default");

%>