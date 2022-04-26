<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.AdminSessionManager"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.JexDataRecordList"%>

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
	     * @File Title   : 앱관리 신규등록
	     * @File Name    : srvc_0101_02_c001_act.jsp
	     * @File path    : admin.srvc
	     * @author       : byeolkim89 (  )
	     * @Description  : 
	     * @Register Date: 20200713093827
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

		@JexDataInfo(id = "srvc_0101_02_c001", type = JexDataType.WSVC)
		JexData input = util.getInputDomain();
		JexData result = util.createResultDomain();
		System.out.println(input);
		// IDO Connection
		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexDataCMO userSession = AdminSessionManager.getSession(request, response);

		String userId = "";
		if (userSession == null) {
			userId = "system";
		} else {
			userId = (String) userSession.get("USE_INTT_ID");
		}
	
		//create
		if(!"".equals(StringUtil.null2void(input.getString("APP_ID_BASE")))){
			
		} 
		//update
		else{
			
		}
		String RSLT_CD = "0000";
		try {
			idoCon.beginTransaction();
			
			JexData idoIn1;
			if(!"".equals(StringUtil.null2void(input.getString("APP_ID_BASE")))){
				idoIn1 = util.createIDOData("APP_INFM_U001");
				idoIn1.put("CORR_ID", userId);
				idoIn1.put("APP_ID1", input.getString("APP_ID_BASE"));
			} else{
				idoIn1 = util.createIDOData("APP_INFM_C001");
				idoIn1.put("REGR_ID", userId);
			}
				
			idoIn1.put("APP_ID", input.getString("APP_ID"));
			idoIn1.put("APP_NM", input.getString("APP_NM"));
			idoIn1.put("HOST", input.getString("HOST"));
			idoIn1.put("VRFC_TYPE", input.getString("VRFC_TYPE"));
			idoIn1.put("SVC_KEY", input.getString("SVC_KEY"));
			idoIn1.put("INTF_DV", input.getString("INTF_DV"));
			idoIn1.put("DATA_TYPE", input.getString("DATA_TYPE"));
			idoIn1.put("BIZ_NO", input.getString("BIZ_NO"));
			idoIn1.put("BSNN_NM", input.getString("BSNN_NM"));
			idoIn1.put("APP_OWNR_ID", input.getString("APP_OWNR_ID"));
			JexData idoOut1 = idoCon.execute(idoIn1);
			// 도메인 에러 검증
			if (DomainUtil.isError(idoOut1)) {
				if (util.getLogger().isDebug()) {
					util.getLogger().debug("Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
					util.getLogger().debug("Error Message::" + DomainUtil.getErrorMessage(idoOut1));
				}
				throw new JexWebBIZException(idoOut1);
			}
			
			
			if(!"".equals(StringUtil.null2void(input.getString("APP_ID_BASE")))){
				JexData idoIn3 = util.createIDOData("APP_CHRG_INFM_D001");
				idoIn3.put("APP_ID", input.getString("APP_ID"));
				JexData idoOut3 = idoCon.execute(idoIn3);
				// 도메인 에러 검증
				if (DomainUtil.isError(idoOut3)) {
					if (util.getLogger().isDebug())
					{
						util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut3));
						util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut3));
					}
					throw new JexWebBIZException(idoOut3);
				}
			}
			
			JexDataList<JexData> inputRecInsert = input.getList("INSERT_REC");
			while(inputRecInsert.next()){ 
				JexData modData = inputRecInsert.get();
				
				JexData idoIn2 = util.createIDOData("APP_CHRG_INFM_C001");
				idoIn2.put("USER_ID", modData.getString("USER_ID"));
				idoIn2.put("APP_ID", modData.getString("APP_ID"));
				idoIn2.put("REGR_ID", userId);
				JexData idoOut2 =  idoCon.execute(idoIn2);
				
				// 도메인 에러 검증
				if (DomainUtil.isError(idoOut2)) {
					if (util.getLogger().isDebug())
					{
						util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
						util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
					}
					throw new JexWebBIZException(idoOut2);
				}
			 }
			RSLT_CD = "0000";
			
			idoCon.commit();
		} catch (Exception e) {
			e.printStackTrace();
			RSLT_CD = "9999";
			idoCon.rollback();
		} finally {
			idoCon.endTransaction();
		}

		result.put("RSLT_CD", RSLT_CD);
		util.setResult(result, "default");
%>