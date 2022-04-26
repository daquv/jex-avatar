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
         * @File Title   : 인증서 만료 여부
         * @File Name    : ques_comm_01_r006_act.jsp
         * @File path    : ques
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20210503160014
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

        @JexDataInfo(id="ques_comm_01_r006", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
        JexDataCMO UserSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = (String)UserSession.get("USE_INTT_ID");
        
// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        IDODynamic dynamic_0 = new IDODynamic();
        if("TAX".equals(input.getString("MENU_DV"))){
            JexData idoIn1 = util.createIDOData("EVDC_INFM_R016");
    
            idoIn1.put("USE_INTT_ID", USE_INTT_ID);
        	dynamic_0.addSQL("\n AND A.EVDC_DIV_CD = '20'");
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
        } else if("CASH".equals(input.getString("MENU_DV"))){
            JexData idoIn1 = util.createIDOData("EVDC_INFM_R016");
    
            idoIn1.put("USE_INTT_ID", USE_INTT_ID);
            dynamic_0.addSQL("\n AND A.EVDC_DIV_CD = '21'");
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
        } else if("ACCT".equals(input.getString("MENU_DV"))){
            JexData idoIn1 = util.createIDOData("CERT_INFM_R010");
    
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
            result.putAll(idoOut1);
        }
       
    
        
        

        util.setResult(result, "default");

%>