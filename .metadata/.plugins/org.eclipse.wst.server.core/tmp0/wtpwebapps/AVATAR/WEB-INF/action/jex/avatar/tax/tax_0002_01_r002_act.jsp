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
         * @File Title   : 홈텍스 부가가치세/종합소득세 조회
         * @File Name    : tax_0002_01_r002_act.jsp
         * @File path    : tax
         * @author       : jepark (  )
         * @Description  : 홈텍스 부가가치세/종합소득세 조회
         * @Register Date: 20210514161032
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

        @JexDataInfo(id="tax_0002_01_r002", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

     	// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexDataCMO userSession = SessionManager.getSession(request, response);
        String use_intt_id = userSession.getString("USE_INTT_ID");
        
    	// 홈텍스 부가가치세/종합소득세 조회
        JexData idoIn1 = util.createIDOData("EVDC_INFM_R004");
    
    	idoIn1.put("USE_INTT_ID", use_intt_id);
    	idoIn1.put("EVDC_DIV_CD", input.getString("EVDC_DIV_CD")); // 22: 부가가치세/종합소득세
    
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