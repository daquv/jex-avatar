<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.ido.IDODynamic"%>
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
         * @File Title   : 데이터_매출세금계산서상세조회
         * @File Name    : tax_0003_02_r001_act.jsp
         * @File path    : tax
         * @author       : byeolkim89 (  )
         * @Description  : 데이터_매출세금계산서상세조회
         * @Register Date: 20200130181951
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

        @JexDataInfo(id="tax_0003_02_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

    	// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        // SESSION
        JexDataCMO UserSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = (String)UserSession.get("USE_INTT_ID");
    
        IDODynamic dynamic_0= new IDODynamic();
        
    
        JexData idoIn1 = util.createIDOData("ELEC_TXBL_PTCL_R001");
    
        idoIn1.putAll(input);
        idoIn1.put("USE_INTT_ID", USE_INTT_ID);
        idoIn1.put("ISSU_ID", 		input.getString("ISSU_ID"));
        idoIn1.put("DYNAMIC_0", 	dynamic_0);
    
        JexDataList<JexData> idoOut1 = (JexDataList<JexData>) idoCon.executeList(idoIn1);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut1)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
            }
            throw new JexWebBIZException(idoOut1);
        }
    
        result.put("REC", idoOut1);
        
        
        //detail
        JexData idoIn2 = util.createIDOData("ELEC_TXBL_DTLS_R001");
        
        idoIn2.putAll(input);
        idoIn2.put("USE_INTT_ID", USE_INTT_ID);
        idoIn2.put("ISSU_ID", 		input.getString("ISSU_ID"));
        idoIn2.put("DYNAMIC_0", 	dynamic_0);
    
        JexDataList<JexData> idoOut2 = (JexDataList<JexData>) idoCon.executeList(idoIn2);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut2)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
            }
            throw new JexWebBIZException(idoOut2);
        }
    
        result.put("REC_DT", idoOut2);

        

        util.setResult(result, "default");

%>