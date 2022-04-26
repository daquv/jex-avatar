<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.AdminSessionManager"%>

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
<%@page import="jex.data.impl.ido.IDODynamic"%>


<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 질의API등록
         * @File Name    : srvc_0202_02_c001_act.jsp
         * @File path    : admin.srvc
         * @author       : byeolkim89 (  )
         * @Description  : 질의API등록
         * @Register Date: 20200922094432
         * </pre>
         *
         * ============================================================
         * 참조
         * ============================================================
         * 본 Action을 사용하는 View에서는 해당 도메인을 import하고.
         * 응답 도메인에 대한 객체를 아래와 같이 생성하여야 합니다.
         *
         **/

        WebCommonUtil   util    = WebCommonUtil.getInstace(request, response);

        @JexDataInfo(id="srvc_0202_02_c001", type=JexDataType.WSVC)
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
		
		String RSLT_CD = "0000";
		
		
		try{
			idoCon.beginTransaction();
			IDODynamic dynamic_0 = new IDODynamic();
			dynamic_0.addNotBlankParameter(input.getString("APP_ID_BASE"), "\n AND APP_ID = ?");
			dynamic_0.addNotBlankParameter(input.getString("API_ID_BASE"), "\n AND API_ID = ?");
			
			if(!"".equals(input.getString("APP_ID_BASE"))){
				//update
				JexData idoIn0 = util.createIDOData("QUES_API_INFM_U003");
				
				idoIn0.put("APP_ID", input.getString("APP_ID"));
				idoIn0.put("API_ID", input.getString("API_ID"));
				idoIn0.put("API_URL", input.getString("API_URL"));
				idoIn0.put("QUES_CTT", input.getString("QUES_CTT"));
				idoIn0.put("CTGR_CD", input.getString("CTGR_CD"));
				idoIn0.put("QUES_RSLT_TYPE", input.getString("QUES_RSLT_TYPE"));
				idoIn0.put("QUES_DESC", input.getString("QUES_DESC"));
				idoIn0.put("STTS", input.getString("STTS"));
				idoIn0.put("CORR_ID", userId);
				//idoIn0.put("APP_ID_BASE",input.getString("APP_ID_BASE"));
				//idoIn0.put("API_ID_BASE",input.getString("API_ID_BASE"));
				//idoIn0.put("DYNAMIC_0", dynamic_0);
				JexData idoOut0 =  idoCon.execute(idoIn0);
				// 도메인 에러 검증
				if (DomainUtil.isError(idoOut0)) {
					if (util.getLogger().isDebug()){
						util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut0));
						util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut0));
					}
					throw new JexWebBIZException(idoOut0);
				}
			} else{
				//create
				JexData idoIn0 = util.createIDOData("QUES_API_INFM_C001");
				idoIn0.put("APP_ID", input.getString("APP_ID"));
				idoIn0.put("API_ID", input.getString("API_ID"));
				idoIn0.put("API_URL", input.getString("API_URL"));
				idoIn0.put("QUES_CTT", input.getString("QUES_CTT"));
				idoIn0.put("CTGR_CD", input.getString("CTGR_CD"));
				idoIn0.put("QUES_RSLT_TYPE", input.getString("QUES_RSLT_TYPE"));
				idoIn0.put("QUES_DESC", input.getString("QUES_DESC"));
				idoIn0.put("STTS", input.getString("STTS"));
				idoIn0.put("REGR_ID", userId);
				JexData idoOut0 =  idoCon.execute(idoIn0);
				// 도메인 에러 검증
				if (DomainUtil.isError(idoOut0)) {
					if (util.getLogger().isDebug()){
						util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut0));
						util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut0));
					}
					throw new JexWebBIZException(idoOut0);
				}
			}
			//수정 아니면 삭제 x
			if(!"".equals(input.getString("APP_ID_BASE")) && !"".equals(input.getString("API_ID_BASE"))){
				JexData idoIn4 = util.createIDOData("QUES_API_DTLS_D001");
				idoIn4.put("DYNAMIC_0", dynamic_0);
				JexData idoOut4 =  idoCon.execute(idoIn4);
				// 도메인 에러 검증
				if (DomainUtil.isError(idoOut4)) {
					if (util.getLogger().isDebug()){
						util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut4));
						util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut4));
					}
					throw new JexWebBIZException(idoOut4);
				}
			}
			
			
			
			JexDataList<JexData> headerRec = input.getRecord("HEADER_REC");
			while(headerRec.next()){
				JexData headerData = headerRec.get(); 
				JexData idoIn1 = util.createIDOData("QUES_API_DTLS_C001");
				idoIn1.putAll(headerData);
				JexData idoOut1 =  idoCon.execute(idoIn1);
				// 도메인 에러 검증
				if (DomainUtil.isError(idoOut1)) {
					if (util.getLogger().isDebug()){
						util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
						util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
					}
					throw new JexWebBIZException(idoOut1);
				}
			}
			
			JexDataList<JexData> inputRec = input.getRecord("INPUT_REC");
			while(inputRec.next()){
				JexData inputData = inputRec.get(); 
				JexData idoIn1 = util.createIDOData("QUES_API_DTLS_C001");
				idoIn1.putAll(inputData);
				JexData idoOut1 =  idoCon.execute(idoIn1);
				// 도메인 에러 검증
				if (DomainUtil.isError(idoOut1)) {
					if (util.getLogger().isDebug()){
						util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
						util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
					}
					throw new JexWebBIZException(idoOut1);
				}
			}
			
			JexDataList<JexData> outputRec = input.getRecord("OUTPUT_REC");
			while(outputRec.next()){
				JexData outputData = outputRec.get(); 
				JexData idoIn1 = util.createIDOData("QUES_API_DTLS_C001");
				idoIn1.putAll(outputData);
				JexData idoOut1 =  idoCon.execute(idoIn1);
				// 도메인 에러 검증
				if (DomainUtil.isError(idoOut1)) {
					if (util.getLogger().isDebug()){
						util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
						util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
					}
					throw new JexWebBIZException(idoOut1);
				}
			}
			idoCon.commit();
			//idoCon.rollback();
		} catch(Exception e){
			e.printStackTrace();
			RSLT_CD = "9999";
			idoCon.rollback();
		} finally {
			idoCon.endTransaction();
		}
		result.put("RSLT_CD", RSLT_CD);
        util.setResult(result, "default");

%>