<%@page import="com.avatar.comm.CommUtil"%>
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
         * @File Title   : 더보기 기초정보 조회(계좌,카드,증빙,인증서 개수)
         * @File Name    : basic_0002_01_r001_act.jsp
         * @File path    : basic
         * @author       : kth91 (  )
         * @Description  : 더보기 기초정보 조회(계좌,카드,증빙,인증서 개수)
         * @Register Date: 20200129174642
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

        @JexDataInfo(id="basic_0002_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
      	//GET SESSION
    	JexDataCMO UserSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = StringUtil.null2void((String)UserSession.get("USE_INTT_ID"));
		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
		// 카드사별 카드사 목록
        JexData idoIn1 = util.createIDOData("CARD_INFM_R008");
    
        idoIn1.putAll(input);
        idoIn1.put("USE_INTT_ID",USE_INTT_ID);
    
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
    
        result.put("CARD_REC", idoOut1);

     	// 은행별 은행 목록
        JexData idoIn2 = util.createIDOData("ACCT_INFM_R015");
    
        idoIn2.putAll(input);
        idoIn2.put("USE_INTT_ID",USE_INTT_ID);
    
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
    
        result.put("ACCT_REC", idoOut2);
        
    	// 홈텍스,여신,온라인매출,인증서 개수 조회
        JexData idoIn3 = util.createIDOData("EVDC_INFM_R005");
    
        idoIn3.putAll(input);
        idoIn3.put("USE_INTT_ID",USE_INTT_ID);
    
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
    
        result.put("EVDC_REC", idoOut3);
    
        // 실시간 조회 결과
        JexData idoIn4 = util.createIDOData("RT_INQ_TASK_R001");
        
        idoIn4.put("USE_INTT_ID",USE_INTT_ID);
    
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
    
        result.put("RT_REC", idoOut4);
        
        // 연계된 계정 조회
        JexData idoIn5 = util.createIDOData("CUST_LINK_SYS_INFM_R003");
        
        idoIn5.put("USE_INTT_ID", USE_INTT_ID);
        idoIn5.put("APP_ID1", "SERP");
        idoIn5.put("APP_ID2", "ZEROPAY");
        
		JexDataList<JexData> idoOut5 = (JexDataList<JexData>) idoCon.executeList(idoIn5);

		if (DomainUtil.isError(idoOut5)) {
			if (util.getLogger().isDebug())
			{
				util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut5));
				util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut5));
			}
			throw new JexWebBIZException(idoOut5);
		}
		result.put("LINK_REC", idoOut5);
		
		// 계정 유료서비스 조회
		JexData idoIn6 = util.createIDOData("CUST_RT_BACH_INFM_R001");
        
        idoIn6.put("USE_INTT_ID", USE_INTT_ID);
    
        JexDataList<JexData> idoOut6 = (JexDataList<JexData>) idoCon.executeList(idoIn6);
        
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut6)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut6));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut6));
            }
            throw new JexWebBIZException(idoOut6);
        }
    
        result.put("PAY_REC", idoOut6);
        
        util.setResult(result, "default");

%>