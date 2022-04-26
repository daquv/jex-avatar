<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.JexDataRecordList"%>

<%@page import="jex.util.DomainUtil"%>
<%@page import="jex.log.JexLogFactory"%>
<%@page import="jex.log.JexLogger"%>
<%@page import="jex.data.JexData"%>
<%@page import="jex.data.annotation.JexDataInfo"%>
<%@page import="jex.enums.JexDataType"%>
<%@page import="jex.web.util.WebCommonUtil"%>
<%@page import="jex.resource.cci.JexConnection"%>
<%@page import="jex.web.exception.JexWebBIZException"%>
<%@page import="jex.resource.cci.JexConnectionManager"%>
<%@page import="jex.data.loader.JexDataCreator"%>
<%@page import="com.avatar.comm.BizLogUtil"%>
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 질의예시목록
         * @File Name    : ques_0001_01_act.jsp
         * @File path    : ques
         * @author       : byeolkim89 (  )
         * @Description  : 질의예시목록
         * @Register Date: 20200327164551
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

        @JexDataInfo(id="ques_0001_01", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
        
        SessionManager sessionMgr = SessionManager.getInstance();
        JexDataCMO userSession = SessionManager.getSession(request, response);
        BizLogUtil.debug(this, "************ yjk ********** Session="+userSession.toJSONString());
        
        /* System.out.println("########################1 :: "+input.getString("CUST_CI"));
		if(!"".equals(StringUtil.null2void(input.getString("CUST_CI")))){
			JexConnection idoCon = JexConnectionManager.createIDOConnection();
			JexData idoIn1 = util.createIDOData("CUST_LDGR_R015");
			idoIn1.put("CUST_CI", input.getString("CUST_CI"));
			JexDataRecordList<JexData> idoOut1 = (JexDataRecordList<JexData>) idoCon.executeList(idoIn1);
	     	
	     	 // 도메인 에러 검증
	        if (DomainUtil.isError(idoOut1)) {
	            if (util.getLogger().isDebug())
	            {
	                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
	                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
	            }
	            throw new JexWebBIZException(idoOut1);
	        }
	        
			 SessionManager sessionMgr = SessionManager.getInstance();
				JexDataCMO sessionCmo = JexDataCreator.createCMOData("AVATAR_SESSION");
				sessionCmo.putAll(input);
				sessionCmo.put("CUST_CI", input.getString("CUST_CI"));
				sessionCmo.put("USE_INTT_ID", idoOut1.get(0).getString("USE_INTT_ID"));
				sessionCmo.put("CLPH_NO", idoOut1.get(0).getString("CLPH_NO"));
				sessionCmo.put("CUST_NM", idoOut1.get(0).getString("CUST_NM"));
				sessionMgr.setUserSession(request, response, sessionCmo);
		} */
       
        util.setResult(result, "default");

%>