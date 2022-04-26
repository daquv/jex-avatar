<%@page import="com.avatar.comm.BizLogUtil"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.exception.JexBIZException"%>
<%@page import="jex.data.loader.JexDataCreator"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>
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
         * @File Title   : 질의조회(제로페이)
         * @File Name    : ques_comm_10_act.jsp
         * @File path    : ques
         * @author       : yj9253 (  )
         * @Description  : 
         * @Register Date: 20211209084827
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

        @JexDataInfo(id="ques_comm_10", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
		
        
        /**=========================================
         *	세션 생성
         =========================================**/
        String nAPP_ID = "ZEROPAY";
        if(isExistSession(request)) {
        	JexDataCMO userSession = SessionManager.getSession(request, response);
        	userSession.put("APP_ID", nAPP_ID);
        	userSession.put("LGIN_APP", nAPP_ID);
        	// userSession.put("USE_INTT_ID", "A200300026"); //yj TODO: ques_comm_01_r001 임시 호출을 위해 하드코딩.. 나중에 삭제할 것
     	} else {
     		createSession(request, response);
     	}
        
        result.put("APP_ID", nAPP_ID);
        result.put("LGIN_APP", nAPP_ID);
        
        util.setResult(result, "default");

%>

<%!
public void createSession(HttpServletRequest request, HttpServletResponse response) throws Exception {
	
	String rslt_cd = "0000";
	String rslt_msg = "";
    String nAPP_ID = "ZEROPAY";
	SessionManager sessionMgr = SessionManager.getInstance();
    JexDataCMO sessionCmo = JexDataCreator.createCMOData("AVATAR_SESSION");
    
    try{
    	sessionCmo.put("APP_ID"		 , nAPP_ID);
    	sessionCmo.put("LGIN_APP"	 , nAPP_ID);
    	// sessionCmo.put("USE_INTT_ID", "A200300026"); //yj TODO: ques_comm_01_r001 임시 호출을 위해 하드코딩.. 나중에 삭제할 것
     	
	 	sessionMgr.setUserSession(request, response, sessionCmo);
	 	BizLogUtil.debug(this, "Created Session="+sessionCmo.toJSONString());
     	
     }catch(Exception e){
     	e.printStackTrace();
     	throw new JexWebBIZException("S"+rslt_cd, rslt_msg);
     }
}

public boolean isExistSession(HttpServletRequest request) throws Exception {
	boolean result = false;
	
	HttpSession userSession = request.getSession(false);
    if(userSession != null && userSession.getAttribute("AVATAR_SESSION") != null) {
    	result = true;
    }
	
    return result;
}
%>