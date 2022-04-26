<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="jex.exception.JexBIZException"%>

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
<%@page import="jex.util.StringUtil"%>
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : API연결 여부 조회
         * @File Name    : ques_comm_01_r005_act.jsp
         * @File path    : ques
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20201228163741
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

        @JexDataInfo(id="ques_comm_01_r005", type=JexDataType.WSVC)
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
     	
     	String USE_INTT_ID = usersession.getString("USE_INTT_ID");
        String APP_ID = StringUtil.null2void(usersession.getString("APP_ID"), "AVATAR");
		//-------------------------------------
		//데이터 연결 유무 조회_API
		//-------------------------------------
		/* JexData idoIn1 = util.createIDOData("CUST_INTE_LINK_INFM_R002");
	
		idoIn1.putAll(input);
		idoIn1.put("USE_INTT_ID", USE_INTT_ID);
		idoIn1.put("INTE_CD", input.getString("INTE_CD"));
		JexData idoOut1 = idoCon.execute(idoIn1);
	
		// 도메인 에러 검증
		if (DomainUtil.isError(idoOut1)) {
			if (util.getLogger().isDebug()) {
				util.getLogger().debug("Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
				util.getLogger().debug("Error Message::" + DomainUtil.getErrorMessage(idoOut1));
			}
			throw new JexWebBIZException(idoOut1);
		}
	
		result.put("API_CNT", idoOut1.getString("API_CNT")); */

		//-------------------------------------
		//데이터 연결 유무 조회_APP
		//-------------------------------------		
		IDODynamic dynamic_0 = new IDODynamic();
		dynamic_0.addNotBlankParameter(APP_ID, "\n AND APP_ID = ?");		
		JexData idoIn2 = util.createIDOData("CUST_LINK_SYS_INFM_R002");
	
		idoIn2.putAll(input);
		idoIn2.put("USE_INTT_ID", USE_INTT_ID);
		JexData idoOut2 = idoCon.execute(idoIn2);
	
		// 도메인 에러 검증
		if (DomainUtil.isError(idoOut2)) {
			if (util.getLogger().isDebug()) {
				util.getLogger().debug("Error Code   ::" + DomainUtil.getErrorCode(idoOut2));
				util.getLogger().debug("Error Message::" + DomainUtil.getErrorMessage(idoOut2));
			}
			throw new JexWebBIZException(idoOut2);
		}
	
		result.put("APP_CNT", idoOut2.getString("APP_CNT"));
    

        util.setResult(result, "default");

%>