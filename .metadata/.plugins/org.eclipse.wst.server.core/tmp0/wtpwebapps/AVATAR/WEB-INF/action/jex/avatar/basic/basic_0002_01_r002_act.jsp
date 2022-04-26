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
         * @File Title   : 실시간 스크래핑 완료여부 조회
         * @File Name    : basic_0002_01_r002_act.jsp
         * @File path    : basic
         * @author       : jepark (  )
         * @Description  : 실시간 스크래핑 완료여부 조회
         * @Register Date: 20210125140613
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

        @JexDataInfo(id="basic_0002_01_r002", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        JexDataCMO UserSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = (String)UserSession.get("USE_INTT_ID");
        String TASK_GB = input.getString("TASK_GB");
        String BANK_CD = StringUtil.null2void(input.getString("BANK_CD"));
        String FNNC_INFM_NO = StringUtil.null2void(input.getString("FNNC_INFM_NO"));
        
        IDODynamic dynamic_0 = new IDODynamic();
			
        if(!BANK_CD.equals("")){
        	dynamic_0.addSQL("AND BANK_CD = '"+BANK_CD+"'");
        }
     
        if(!FNNC_INFM_NO.equals("")){
        	dynamic_0.addSQL("AND FNNC_INFM_NO = '"+FNNC_INFM_NO+"'");
        }
        
		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
    
        JexData idoIn1 = util.createIDOData("RT_INQ_TASK_R002");
    
        idoIn1.put("USE_INTT_ID", USE_INTT_ID);
        idoIn1.put("TASK_GB", TASK_GB);
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
        

        util.setResult(result, "default");

%>