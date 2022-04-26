<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.json.JSONArray"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="jex.json.parser.JSONParser"%>

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
<%@page import="com.avatar.session.SessionManager"%>

<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 데이터-매출목록조회
         * @File Name    : basic_0003_03_r001_act.jsp
         * @File path    : basic
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200529160221
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

        @JexDataInfo(id="basic_0003_03_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        JexDataCMO userSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
    
        JexData idoIn1 = util.createIDOData("EVDC_INFM_R012");
    
        idoIn1.putAll(input);
        idoIn1.put("USE_INTT_ID", USE_INTT_ID);
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
        JSONArray jsonArr = (JSONArray)JSONParser.parser(idoOut1.getString("JSON"));
        result.put("JSON", jsonArr);
        
        
        JexData idoIn2 = util.createIDOData("EVDC_INFM_R013");
        
        idoIn2.putAll(input);
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
        result.put("BUY_HIS_LST_DTM", idoOut2.getString("BUY_HIS_LST_DTM"));
        
        
        JexData idoIn3 = util.createIDOData("EVDC_INFM_R014");
        
        idoIn3.putAll(input);
        idoIn3.put("USE_INTT_ID", USE_INTT_ID);
        JexData idoOut3 =  idoCon.execute(idoIn3);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut1)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut3));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut3));
            }
            throw new JexWebBIZException(idoOut3);
        }
        result.put("SEL_HIS_LST_DTM", idoOut3.getString("SEL_HIS_LST_DTM"));
        

        util.setResult(result, "default");

%>