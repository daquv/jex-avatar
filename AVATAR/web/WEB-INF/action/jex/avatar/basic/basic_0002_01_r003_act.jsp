<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="jex.util.StringUtil"%>

<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
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
         * @File Title   : 인증서만료여부조회
         * @File Name    : basic_0002_01_r003_act.jsp
         * @File path    : basic
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20210517183503
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

        @JexDataInfo(id="basic_0002_01_r003", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
        
        JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexDataCMO UserSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = (String)UserSession.get("USE_INTT_ID");
        
        IDODynamic dynamic_0 = new IDODynamic();
    	JexData idoIn1 = util.createIDOData("EVDC_INFM_R016");
    	idoIn1.put("USE_INTT_ID", USE_INTT_ID);
    	dynamic_0.addSQL("\n AND A.EVDC_DIV_CD IN ('20', '21', '22')");
    	idoIn1.put("DYNAMIC_0", dynamic_0);
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
        result.put("TAX_CERT",idoOut1);

        JexData idoIn2 = util.createIDOData("CERT_INFM_R010");

        idoIn2.put("USE_INTT_ID", USE_INTT_ID);

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
        result.put("ACCT_CERT", idoOut2);

        util.setResult(result, "default");

%>