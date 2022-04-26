<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.util.StringUtil"%>

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
<%@page import="com.avatar.session.AdminSessionManager"%>

<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 거래처표제어 일괄등록
         * @File Name    : cstm_0302_01_c001_act.jsp
         * @File path    : admin.cstm
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20210408174417
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

        @JexDataInfo(id="cstm_0302_01_c001", type=JexDataType.WSVC)
		JexData input = util.getInputDomain();
		JexData result = util.createResultDomain();

		// IDO Connection
		JexConnection idoCon = JexConnectionManager.createIDOConnection();        
		JexDataCMO userSession = (JexDataCMO)AdminSessionManager.getSession(request, response);

		String userId = StringUtil.null2void((String)userSession.get("USER_ID"));
		try{
			idoCon.beginTransaction();
			JexDataList<JexData> inputRecInsert = input.getRecord("INSERT_REC");
			while(inputRecInsert.next()){
				JexData inputData = inputRecInsert.get(); 
				
				JexData idoIn1 = util.createIDOData("BZAQ_HEAD_WORD_C001");
				idoIn1.putAll(inputData);
				idoIn1.put("REGR_ID",userId);
				JexData idoOut1 =  idoCon.execute(idoIn1);
				// 도메인 에러 검증
				if (DomainUtil.isError(idoOut1)) {
					if (util.getLogger().isDebug()){
						util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
						util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
						// result.put("RSLT_CD", "9999");
					}
					throw new JexWebBIZException(idoOut1);
				}
			}
			result.put("RSLT_CD", "0000");
			idoCon.commit();
			idoCon.endTransaction();
		} catch(Exception e){
			idoCon.rollback();
			idoCon.endTransaction();
			if (util.getLogger().isDebug()) util.getLogger().debug("Error Code   ::"+e.getMessage());
			result.put("RSLT_CD", "9999");
			util.setResult(result, "E");
		}

		util.setResult(result, "default");

%>