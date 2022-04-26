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
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 1:1 문의 상세 내역 조회
         * @File Name    : basic_0006_03_r001_act.jsp
         * @File path    : basic
         * @author       : byeolkim89 (  )
         * @Description  : 1:1 문의 상세 내역 조회
         * @Register Date: 20200820172006
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

        @JexDataInfo(id="basic_0006_03_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
     	// Get Session
        JexDataCMO userSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
        
        
    	IDODynamic dynamic_0 = new IDODynamic();
    	IDODynamic dynamic_1 = new IDODynamic();
        JexData idoIn1 = util.createIDOData("BLBD_HSTR_R001");

        dynamic_0.addNotBlankParameter(input.getString("BLBD_DIV"), "\n AND BLBD_DIV = ?");
        dynamic_0.addNotBlankParameter(input.getString("BLBD_NO"), "\n AND BLBD_NO = CAST(? AS INTEGER)");
        //dynamic_0.addNotBlankParameter(USE_INTT_ID, "\n AND REGR_ID = ?");
        
        idoIn1.putAll(input);
    	idoIn1.put("DYNAMIC_0", dynamic_0);
        
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
    
        result.put("REC_BLBD", idoOut1);
        
        
        
    
        JexData idoIn2 = util.createIDOData("BLBD_FILE_R001");
    
        idoIn2.putAll(input);
        idoIn2.put("DYNAMIC_0", dynamic_0);
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
    
        result.put("REC_FILE", idoOut2);

        
        
        
    
        JexData idoIn3 = util.createIDOData("BLBD_RPLY_HSTR_R001");
    
        idoIn3.putAll(input);
        idoIn3.put("DYNAMIC_0", dynamic_0);
        JexData idoOut3 =  idoCon.execute(idoIn3);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut3)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut3));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut3));
            }
            throw new JexWebBIZException(idoOut3);
        }
    
        result.put("REC_RPLY", idoOut3);
        
        
        
    
        JexData idoIn4 = util.createIDOData("BLBD_RPLY_FILE_R001");
    
        idoIn4.putAll(input);
        idoIn4.put("DYNAMIC_0", dynamic_0);
        JexDataList<JexData> idoOut4 = (JexDataList<JexData>) idoCon.executeList(idoIn4);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut4)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut4));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut4));
            }
            throw new JexWebBIZException(idoOut4);
        }
    
        result.put("REC_RPLY_FILE", idoOut4);

        

        util.setResult(result, "default");

%>