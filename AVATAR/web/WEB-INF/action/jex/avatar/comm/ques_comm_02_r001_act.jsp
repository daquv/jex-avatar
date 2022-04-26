<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.data.impl.ido.IDODynamic"%>

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
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.util.StringUtil"%>
<%
	/**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 샘플코드 조회
         * @File Name    : ques_comm_02_r001_act.jsp
         * @File path    : comm
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200605175824
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
	
		@JexDataInfo(id = "ques_comm_02_r001", type = JexDataType.WSVC)
		JexData input = util.getInputDomain();
		JexData result = util.createResultDomain();
	
		// IDO Connection
		JexConnection idoCon = JexConnectionManager.createIDOConnection();
        // Get Session
        JexDataCMO userSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
		//Html 조회
		JexData idoIn1 = util.createIDOData("INTE_INFM_R004");
	
		idoIn1.putAll(input);
		idoIn1.put("INTE_CD", input.getString("INTE_CD"));
		JexDataList<JexData> idoOut1 = (JexDataList<JexData>) idoCon.executeList(idoIn1);
	
		// 도메인 에러 검증
		if (DomainUtil.isError(idoOut1)) {
			if (util.getLogger().isDebug()) {
				util.getLogger().debug("Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
				util.getLogger().debug("Error Message::" + DomainUtil.getErrorMessage(idoOut1));
			}
			throw new JexWebBIZException(idoOut1);
		}
	
		result.put("REC", idoOut1);
	
		//데이터 연결 유무 조회_DB
		JexData idoIn2 = util.createIDOData("CUST_LDGR_R017");
	
		idoIn2.putAll(input);
		idoIn2.put("USE_INTT_ID", USE_INTT_ID);
		JexDataList<JexData> idoOut2 = (JexDataList<JexData>) idoCon.executeList(idoIn2);
	
		// 도메인 에러 검증
		if (DomainUtil.isError(idoOut2)) {
			if (util.getLogger().isDebug()) {
				util.getLogger().debug("Error Code   ::" + DomainUtil.getErrorCode(idoOut2));
				util.getLogger().debug("Error Message::" + DomainUtil.getErrorMessage(idoOut2));
			}
			throw new JexWebBIZException(idoOut2);
		}
	
		result.put("REC_CNT", idoOut2);
	
		//데이터 연결 유무 조회_API
		JexData idoIn3 = util.createIDOData("CUST_INTE_LINK_INFM_R002");
		
		idoIn3.putAll(input);
		idoIn3.put("USE_INTT_ID", USE_INTT_ID);
		idoIn3.put("INTE_CD", input.getString("INTE_CD"));
		JexData idoOut3 = idoCon.execute(idoIn3);
	
		// 도메인 에러 검증
		if (DomainUtil.isError(idoOut3)) {
			if (util.getLogger().isDebug()) {
				util.getLogger().debug("Error Code   ::" + DomainUtil.getErrorCode(idoOut3));
				util.getLogger().debug("Error Message::" + DomainUtil.getErrorMessage(idoOut3));
			}
			throw new JexWebBIZException(idoOut3);
		}
	
		result.put("API_CNT", idoOut3.getString("API_CNT"));
		
		//데이터 연결 유무 조회_APP
		JexData idoIn4 = util.createIDOData("CUST_LINK_SYS_INFM_R002");
		
		idoIn4.putAll(input);
		idoIn4.put("USE_INTT_ID", USE_INTT_ID);
		JexData idoOut4 = idoCon.execute(idoIn4);
		
		// 도메인 에러 검증
		if (DomainUtil.isError(idoOut4)) {
			if (util.getLogger().isDebug()) {
				util.getLogger().debug("Error Code   ::" + DomainUtil.getErrorCode(idoOut4));
				util.getLogger().debug("Error Message::" + DomainUtil.getErrorMessage(idoOut4));
			}
			throw new JexWebBIZException(idoOut4);
		}
		
		result.put("APP_CNT", idoOut4.getString("APP_CNT"));
	
		//데이터 연결 유무 조회_API
		JexData idoIn5 = util.createIDOData("QUES_API_INFM_R003");
		
		idoIn5.putAll(input);
		idoIn5.put("API_ID", idoOut3.getString("API_ID"));
		idoIn5.put("APP_ID", idoOut4.getString("APP_ID"));
		JexData idoOut5 = idoCon.execute(idoIn5);
		
		// 도메인 에러 검증
		if (DomainUtil.isError(idoOut5)) {
			if (util.getLogger().isDebug()) {
				util.getLogger().debug("Error Code   ::" + DomainUtil.getErrorCode(idoOut5));
				util.getLogger().debug("Error Message::" + DomainUtil.getErrorMessage(idoOut5));
			}
			throw new JexWebBIZException(idoOut5);
		}
		
		result.put("STTS", idoOut5.getString("STTS"));
		
		//데이터 연결 유무 조회_API
		JexData idoIn6 = util.createIDOData("BZAQ_INFM_R003");
		
		idoIn6.putAll(input);
		idoIn6.put("USE_INTT_ID", USE_INTT_ID);
		JexData idoOut6 = idoCon.execute(idoIn6);
		
		// 도메인 에러 검증
		if (DomainUtil.isError(idoOut6)) {
			if (util.getLogger().isDebug()) {
				util.getLogger().debug("Error Code   ::" + DomainUtil.getErrorCode(idoOut6));
				util.getLogger().debug("Error Message::" + DomainUtil.getErrorMessage(idoOut6));
			}
			throw new JexWebBIZException(idoOut6);
		}
		
		result.put("TOTL_CNT", idoOut6.getString("TOTL_CNT"));
		
		util.setResult(result, "default");
%>