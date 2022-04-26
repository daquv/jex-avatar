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
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 고객별 질의 출처 변경
         * @File Name    : ques_0000_04_u001_act.jsp
         * @File path    : ques
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20210512150706
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

        @JexDataInfo(id="ques_0000_04_u001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        String RSLT_CD = "";
        
     // Get Session
        JexDataCMO userSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
        
    	try{
    		idoCon.beginTransaction();
    		JexData idoIn1 = util.createIDOData("CUST_LDGR_U004");
    	    
            idoIn1.putAll(input);
        	idoIn1.put("QUES_DV", input.getString("QUES_DV"));
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
        	RSLT_CD = "0000";
            result.putAll(idoOut1);
    	} catch(Exception e){
    		RSLT_CD = "9999";
    		idoCon.rollback();
    	} finally{
    		idoCon.endTransaction();
    	}
		result.put("RSLT_CD", RSLT_CD);
        

        util.setResult(result, "default");

%>