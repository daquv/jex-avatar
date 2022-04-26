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
         * @File Title   : 데이터_데이터목록조회
         * @File Name    : basic_0003_01_r001_act.jsp
         * @File path    : basic
         * @author       : byeolkim89 (  )
         * @Description  : 데이터_데이터목록조회
         * @Register Date: 20200129142511
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

        @JexDataInfo(id="basic_0003_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        // IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        IDODynamic dynamic_0 = new IDODynamic();
        IDODynamic dynamic_00 = new IDODynamic();
        // Get Session
        JexDataCMO userSession = SessionManager.getSession(request, response);
        System.out.println(userSession);
        String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
        
        
        JexData idoIn00 = util.createIDOData("CUST_LDGR_R017");
    	
        idoIn00.putAll(input);
        idoIn00.put("USE_INTT_ID", USE_INTT_ID);
		JexDataList<JexData> idoOut00 = (JexDataList<JexData>) idoCon.executeList(idoIn00);
	
		// 도메인 에러 검증
		if (DomainUtil.isError(idoOut00)) {
			if (util.getLogger().isDebug()) {
				util.getLogger().debug("Error Code   ::" + DomainUtil.getErrorCode(idoOut00));
				util.getLogger().debug("Error Message::" + DomainUtil.getErrorMessage(idoOut00));
			}
			throw new JexWebBIZException(idoOut00);
		}
	
		result.put("REC_CNT", idoOut00);
        
        //GET ACCOUNT INFO.
        JexData idoIn1 = util.createIDOData("ACCT_INFM_R014");
    
        idoIn1.putAll(input);
        dynamic_0.addNotBlankParameter(userSession.getString("USE_INTT_ID"), "\n AND USE_INTT_ID = ?");
        dynamic_0.addSQL("\n ORDER BY BANK_CD");
        
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
        
        result.put("REC", idoOut1);
        
        /* //########################################//
        //GET CARD INFO
        JexData idoIn2 = util.createIDOData("CARD_INFM_R009");
    	
        idoIn2.putAll(input);
        idoIn2.put("USE_INTT_ID", USE_INTT_ID);
        
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

        result.put("REC2", idoOut2);
        
        
      //########################################//
        //GET EVDC INFO
        JexData idoIn3 = util.createIDOData("EVDC_INFM_R008");
    
        idoIn3.putAll(input);
        idoIn3.put("USE_INTT_ID", USE_INTT_ID);
        
        JexDataList<JexData> idoOut3 = (JexDataList<JexData>) idoCon.executeList(idoIn3);
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut3)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut3));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut3));
            }
            throw new JexWebBIZException(idoOut3);
        }
        result.put("REC3", idoOut3);
        
        
      //########################################//
        //GET BZAQ INFO
        JexData idoIn4 = util.createIDOData("BZAQ_INFM_R003");
    
        idoIn4.putAll(input);
        idoIn4.put("USE_INTT_ID", USE_INTT_ID);
        
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
    

        result.put("REC4", idoOut4);
        
      //########################################//
      //GET CNPL INFO
       JexData idoIn5 = util.createIDOData("CNPL_INFM_R002");
    
       idoIn5.putAll(input);
       idoIn5.put("USE_INTT_ID", USE_INTT_ID);
        
        JexDataList<JexData> idoOut5 = (JexDataList<JexData>) idoCon.executeList(idoIn5);
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut5)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut5));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut5));
            }
            throw new JexWebBIZException(idoOut5);
        }
    

        result.put("REC5", idoOut5); */
        
        
        util.setResult(result, "default");

%>