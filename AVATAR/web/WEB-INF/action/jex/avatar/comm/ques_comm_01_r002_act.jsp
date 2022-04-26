<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="jex.exception.JexBIZException"%>
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

<%
		/**
		 * <pre>
		 * AVATAR
		 * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
		 *
		 * @File Title   : 질의 조회_CNT
		 * @File Name    : ques_comm_01_r002_act.jsp
		 * @File path    : comm
		 * @author       : byeolkim89 (  )
		 * @Description  : 
		 * @Register Date: 20200615173709
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
	
		@JexDataInfo(id = "ques_comm_01_r002", type = JexDataType.WSVC)
		JexData input = util.getInputDomain();
		JexData result = util.createResultDomain();
	
		// IDO Connection
		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		// 세션값 체크
		JexDataCMO usersession = null;
		try {
			usersession = SessionManager.getInstance().getUserSession(request, response);
		} catch (Throwable e) {
			throw new JexBIZException("9999", "Session DisConnected.");
		}
	
		//-------------------------------------
		//인텐트 사용 집계 등록
		//-------------------------------------
		//CHARACTER
		String USE_INTT_ID = usersession.getString("USE_INTT_ID");
		String INTE_CD = input.getString("INTE_CD");
		/* if (!"".equals(INTE_CD)) {
			try{
				idoCon.beginTransaction();
				JexData idoIn2 = util.createIDOData("QUES_USE_SUMR_C001");
				
				idoIn2.putAll(input);
				idoIn2.put("USE_INTT_ID", USE_INTT_ID);
				idoIn2.put("INTE_CD", INTE_CD);
				idoIn2.put("CORR_ID", "SYSTEM");
				idoIn2.put("REGR_ID", "SYSTEM");
				
				JexData idoOut2 = idoCon.execute(idoIn2);
				// 도메인 에러 검증
				if (DomainUtil.isError(idoOut2)) {
					if (util.getLogger().isDebug()) {
						util.getLogger().debug("Error Code   ::" + DomainUtil.getErrorCode(idoOut2));
						util.getLogger().debug("Error Message::" + DomainUtil.getErrorMessage(idoOut2));
					}
					throw new JexWebBIZException(idoOut2);
				}
				result.putAll(idoOut2);
				idoCon.commit();
				idoCon.endTransaction();
			} catch(Exception e){
				idoCon.rollback();
				idoCon.endTransaction();
				util.setResult(result, "E");
			}
			
		} */
		/* //-------------------------------------
		//데이터 연결 유무 조회_DB
		//-------------------------------------
		JexData idoIn1 = util.createIDOData("CUST_LDGR_R017");
	
		idoIn1.putAll(input);
		idoIn1.put("USE_INTT_ID", USE_INTT_ID);
		JexDataList<JexData> idoOut1 = (JexDataList<JexData>) idoCon.executeList(idoIn1);
	
		// 도메인 에러 검증
		if (DomainUtil.isError(idoOut1)) {
			if (util.getLogger().isDebug()) {
				util.getLogger().debug("Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
				util.getLogger().debug("Error Message::" + DomainUtil.getErrorMessage(idoOut1));
			}
			throw new JexWebBIZException(idoOut1);
		}
	
		result.put("REC_CNT", idoOut1); */
		
		//-------------------------------------
		//INTENT 유무 조회
		//-------------------------------------		
		JexData idoIn4 = util.createIDOData("INTE_INFM_R008");
		IDODynamic dynamic_0 = new IDODynamic();
		dynamic_0.addNotBlankParameter(input.getString("INTE_CD"), "\n AND INTE_CD=(CASE WHEN ?='NNN020' THEN 'NNN019' ELSE ");
		dynamic_0.addNotBlankParameter(input.getString("INTE_CD"), "? END)");
		idoIn4.putAll(input);
		idoIn4.put("DYNAMIC_0", dynamic_0);
		JexData idoOut4 = idoCon.execute(idoIn4);
		
		// 도메인 에러 검증
		if (DomainUtil.isError(idoOut4)) {
			if (util.getLogger().isDebug()) {
				util.getLogger().debug("Error Code   ::" + DomainUtil.getErrorCode(idoOut4));
				util.getLogger().debug("Error Message::" + DomainUtil.getErrorMessage(idoOut4));
			}
			throw new JexWebBIZException(idoOut4);
		}
		result.putAll(idoOut4);
		
		JexData idoIn5 = util.createIDOData("CUST_LDGR_R025");
		
		idoIn5.put("USE_INTT_ID", USE_INTT_ID);
// 		idoIn5.put("INTE_CD", input.getString("INTE_CD"));
		idoIn5.put("DYNAMIC_0", dynamic_0);
		JexData idoOut5 = idoCon.execute(idoIn5);
		
		// 도메인 에러 검증
		if (DomainUtil.isError(idoOut4)) {
			if (util.getLogger().isDebug()) {
				util.getLogger().debug("Error Code   ::" + DomainUtil.getErrorCode(idoOut5));
				util.getLogger().debug("Error Message::" + DomainUtil.getErrorMessage(idoOut5));
			}
			throw new JexWebBIZException(idoOut5);
		}
		result.putAll(idoOut5);
// 		result.put("INTE_CNT", idoOut4.getString("INTE_CNT"));
	
		util.setResult(result, "default");
%>