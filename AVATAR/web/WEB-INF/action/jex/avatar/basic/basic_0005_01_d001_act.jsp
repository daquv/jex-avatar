<%@page import="jex.util.StringUtil"%>
<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page contentType="text/html;charset=UTF-8" %>

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
         * @File Title   : 고객연계시스템정보 삭제
         * @File Name    : basic_0005_01_d001_act.jsp
         * @File path    : basic
         * @author       : kth91 (  )
         * @Description  : 고객연계시스템정보 삭제
         * @Register Date: 20200603101226
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

        @JexDataInfo(id="basic_0005_01_d001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
      	//GET SESSION
    	JexDataCMO UserSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = StringUtil.null2void((String)UserSession.get("USE_INTT_ID"));
        
        String APP_ID 		= StringUtil.null2void(input.getString("APP_ID"));
        
        JexData idoIn1 = util.createIDOData("CUST_LINK_SYS_INFM_D001");
    
        idoIn1.put("APP_ID",APP_ID);
        idoIn1.put("USE_INTT_ID",USE_INTT_ID);
    
        JexData idoOut1 =  idoCon.execute(idoIn1);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut1)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
            }
            throw new JexWebBIZException(idoOut1);
        } else {
        	result.put("RSLT_CD","0000");
        }
        
        JexData idoIn2 = util.createIDOData("CUST_INTE_LINK_INFM_D001");
        idoIn2.put("USE_INTT_ID",USE_INTT_ID);
        JexData idoOut2 =  idoCon.execute(idoIn2);
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut2)) {
        	idoCon.rollback();
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
            }
            throw new JexWebBIZException(idoOut2);
        } else {
        	result.put("RSLT_CD","0000");
        }
    
        result.putAll(idoOut1);
        
        util.setResult(result, "default");

%>