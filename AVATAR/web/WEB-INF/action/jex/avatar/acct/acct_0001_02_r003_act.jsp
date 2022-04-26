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
         * @File Title   : 동일계좌 계좌유형 조회
         * @File Name    : acct_0001_02_r003_act.jsp
         * @File path    : acct
         * @author       : jepark (  )
         * @Description  : 동일계좌 계좌유형 조회
         * @Register Date: 20210524145715
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

        @JexDataInfo(id="acct_0001_02_r003", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
        
        JexDataCMO UserSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = (String)UserSession.get("USE_INTT_ID");

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
    	// 동일 계좌 계좌유형 조회 
        JexData idoIn1 = util.createIDOData("ACCT_INFM_R021");
    
        idoIn1.putAll(input);
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
        }
    
        result.putAll(idoOut1);
        

        util.setResult(result, "default");

%>