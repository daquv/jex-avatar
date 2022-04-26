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
         * @File Title   : 제로페이 가맹점 사용여부 수정
         * @File Name    : basic_0015_01_u001_act.jsp
         * @File path    : basic
         * @author       : jepark (  )
         * @Description  : 제로페이 가맹점 사용여부 수정
         * @Register Date: 20210818145759
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

        @JexDataInfo(id="basic_0015_01_u001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        JexDataCMO UserSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = StringUtil.null2void((String)UserSession.get("USE_INTT_ID"));
        
		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
     	// 제로페이 가맹점  사용여부 수정
        JexData idoIn1 = util.createIDOData("ZERO_MEST_INFM_U002");
    
        idoIn1.put("USE_INTT_ID", USE_INTT_ID);
        idoIn1.put("USE_YN", input.getString("USE_YN"));
        idoIn1.put("AFLT_MANAGEMENT_NO", input.getString("AFLT_MANAGEMENT_NO"));
        idoIn1.put("MEST_BIZ_NO", input.getString("MEST_BIZ_NO"));
        idoIn1.put("SER_BIZ_NO", input.getString("SER_BIZ_NO"));
    
        JexData idoOut1 =  idoCon.execute(idoIn1);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut1)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
            }
            result.put("RSLT_CD", "SOER1000");
    		result.put("RSLT_MSG", "제로페이 가맹점 사용여부 변경 시 오류가 발생하였습니다.");
    		util.setResult(result, "default");
			return;
            
        }
    
        result.put("RSLT_CD","0000");
        result.put("RSLT_MSG","정상처리되었습니다.");
        util.setResult(result, "default");

%>