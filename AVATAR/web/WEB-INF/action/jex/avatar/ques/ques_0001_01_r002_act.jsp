<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.data.impl.ido.IDODynamic"%>
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
<%@page import="com.avatar.session.SessionManager"%>

<%@page import="com.avatar.api.mgnt.ContentApiMgnt" %>
<%@page import="jex.json.JSONObject"%>
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 메인페이지_유효기간만료조회
         * @File Name    : ques_0001_01_r002_act.jsp
         * @File path    : ques
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20201116145013
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

        @JexDataInfo(id="ques_0001_01_r002", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        IDODynamic dynamic_0 = new IDODynamic();
        // Get Session
        JexDataCMO userSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
    
        JexData idoIn1 = util.createIDOData("CERT_INFM_R007");
    	dynamic_0.addNotBlankParameter(USE_INTT_ID, "\n AND T1.USE_INTT_ID = ?");
    	//dynamic_0.addSQL("\n AND CERT_DT >= TO_CHAR(NOW(), 'YYYYMMDD')");
    	dynamic_0.addSQL("\n AND T1.CERT_DT < TO_CHAR(NOW()+'1 MONTH', 'YYYYMMDD')");
    	dynamic_0.addSQL("\n AND T1.CERT_STTS IN ('1')");
    	dynamic_0.addSQL("\n AND T2.ACCT_STTS IN ('0','1','8')");
    	dynamic_0.addSQL("\n ORDER BY LEFT_DT LIMIT 1");
        idoIn1.putAll(input);
    
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
    
        result.putAll(idoOut1);
        System.out.println(result);
        
        
        JexData idoIn2 = util.createIDOData("EVDC_INFM_R011");
    	idoIn2.put("USE_INTT_ID", USE_INTT_ID);
    	idoIn2.put("USE_INTT_ID", USE_INTT_ID);
    	idoIn2.put("USE_INTT_ID", USE_INTT_ID);
    	idoIn2.put("USE_INTT_ID", USE_INTT_ID);
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
        result.put("DATA_YN", idoOut2.getString("DATA_YN"));

        JSONObject authResult = ContentApiMgnt.getInstance().authSERP(USE_INTT_ID);
        System.out.println(authResult.get("RSLT_CD"));
        result.put("AUTH_RSLT", authResult.get("RSLT_CD"));
        
        JexData idoIn3 = util.createIDOData("CUST_LDGR_R019");
        idoIn3.put("USE_INTT_ID", USE_INTT_ID);
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
        result.put("POPUP_CNFM_YN", idoOut3.getString("POPUP_CNFM_YN"));
        
        util.setResult(result, "default");

%>