<%@page import="jex.exception.JexBIZException"%>
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
         * @File Title   : 메인페이지_공지팝업 확인처리
         * @File Name    : ques_comm_01_u002_act.jsp
         * @File path    : ques
         * @author       : jepark (  )
         * @Description  : 메인페이지_공지팝업 확인처리
         * @Register Date: 20210203104450
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

        @JexDataInfo(id="ques_comm_01_u002", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

     	// 세션값 체크
   		JexDataCMO usersession = null;
   		try {
   			usersession = SessionManager.getInstance().getUserSession(request, response);
   		} catch (Throwable e) {
   			throw new JexBIZException("9999", "Session DisConnected.");
   		}
   		
   		String USE_INTT_ID = usersession.getString("USE_INTT_ID");
   		
		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
		JexData idoIn1 = util.createIDOData("CUST_LDGR_U003");
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
        util.setResult(result, "default");

%>