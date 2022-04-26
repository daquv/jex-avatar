<%@page import="jex.util.crypto.CryptoUtil"%>
<%@page import="jex.sys.JexSystemConfig"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.json.JSONObject"%>
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
         * @File Title   : 회원가입 및 정보제공동의
         * @File Name    : join_0003_01_act.jsp
         * @File path    : user
         * @author       : jepark (  )
         * @Description  : 회원가입 및 정보제공동의
         * @Register Date: 20210219160508
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

        @JexDataInfo(id="join_0003_01", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        String user_str = input.getString("USER_INFO");
        
        // TODO : 임시데이터 
        //user_str = "{\"_user_key\":\"CTkZ80Dbmcg6gKEdaBZEbi33mlKMnvdWrOpTvTk2ZAM=\",\"_token\":\"GD3tVfMHBe65oVd3zYNeDuHY1tLLp5CWEuC5xsRsaLtSkNnjfexZ+RcH3rTlOzITw1GNooot+TPR5ab1Xax8/W6SsA3gRCwmndKUDbHmx6ZFBISrmlA3s8EiU8Xjk6vQ4YGuizGBGSrtOoOtWXGpdgKNLfgLwM6PHTBZ0UuEOa5LqstnUHZYgcOtDifR8TxPut5nY55B4616fqPLdUYj41ir2BiOg2YIcAq89ePnJtRiSzcNHSlcEH0y5W99R43TJc37oQF7EKKW4DwYirxK/g==\",\"_app_id\":\"8T0XZt2HMQFbN1qIXO62Ew==\"}";

        JSONObject user_info = JSONObject.fromObject(StringUtil.null2void(user_str));
		String secr_key = JexSystemConfig.get("avatarAPI", "secr_key");
		CryptoUtil crypt = CryptoUtil.createInstance(secr_key);
        
        // 복호화
        String app_id =  new String(crypt.decryptSEEDString(StringUtil.null2void(user_info.getString("_app_id"))));
        String user_key =  new String(crypt.decryptSEEDString(StringUtil.null2void(user_info.getString("_user_key"))));
        String token =  new String(crypt.decryptSEEDString(StringUtil.null2void(user_info.getString("_token"))));
        		
        result.put("APP_ID", app_id);        		
        result.put("USER_KEY", user_key);        		
        result.put("TOKEN", token);        		
        
        util.setResult(result, "default");

%>