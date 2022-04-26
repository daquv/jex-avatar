<%@page import="jex.json.JSONArray"%>
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
         * @File Title   : 등록시도한 계좌목록 조회
         * @File Name    : acct_0004_01_r001_act.jsp
         * @File path    : acct
         * @author       : jepark (  )
         * @Description  : 
         * @Register Date: 20210121094202
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

        @JexDataInfo(id="acct_0004_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        JexDataCMO UserSession = SessionManager.getSession(request, response);
        //JSONArray REC_ACCT_LIST = (JSONArray)UserSession.get("REC_ACCT_LIST");
        String REC_ACCT_LIST = StringUtil.null2void((String)UserSession.get("REC_ACCT_LIST"));
        //String REC_ACCT_LIST = UserSession.get("REC_ACCT_LIST").toString().replaceAll("\\\"", "\'");
        //String REC_ACCT_LIST = UserSession.get("REC_ACCT_LIST").toString().replaceAll("\\\"", "\'");
        result.put("REC_ACCT_LIST", REC_ACCT_LIST);
        UserSession.put("REC_ACCT_LIST", null); // 등록 계좌 초기화
        
        util.setResult(result, "default");

%>