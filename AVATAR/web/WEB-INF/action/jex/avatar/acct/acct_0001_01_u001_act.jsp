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
         * @File Title   : 계좌 상태 업데이트
         * @File Name    : acct_0001_01_u001_act.jsp
         * @File path    : acct
         * @author       : byeolkim89 (  )
         * @Description  : 계좌 상태 업데이트
         * @Register Date: 20210107163912
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

        @JexDataInfo(id="acct_0001_01_u001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

      	//GET SESSION
    	JexDataCMO UserSession = SessionManager.getSession(request, response);
        String USE_INTT_ID 	= StringUtil.null2void((String)UserSession.get("USE_INTT_ID"));
// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        String RSLT_CD = "0000";
    	try{
            idoCon.beginTransaction();
    		JexData idoIn1 = util.createIDOData("ACCT_INFM_U008");
    	    
            idoIn1.putAll(input);
        	idoIn1.put("USE_INTT_ID", USE_INTT_ID);
        	idoIn1.put("ACCT_STTS", input.getString("ACCT_STTS"));
        	idoIn1.put("FNNC_UNQ_NO", input.getString("FNNC_UNQ_NO"));
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
            idoCon.commit();
            idoCon.endTransaction();
    	} catch(Exception e){
    		RSLT_CD = "9999";
            idoCon.rollback();
            idoCon.endTransaction();
    	}
        
        result.put("RSLT_CD", RSLT_CD);
        

        util.setResult(result, "default");

%>