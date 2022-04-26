<%@page import="com.avatar.comm.CertUtils"%>
<%@page import="com.avatar.comm.CommUtil"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.json.parser.JSONParser"%>
<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.comm.BizLogUtil"%>
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
         * @File Title   : 인증서검증
         * @File Name    : APP_SVC_P014_act.jsp
         * @File path    : api
         * @author       : kth91 (  )
         * @Description  : 인증서검증
         * @Register Date: 20200117100746
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

        @JexDataInfo(id="APP_SVC_P014", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
	    //// input 공통부   /////
        JSONObject _req = JSONObject.fromObject(input.toJSONString());
		JSONObject _cmo = JSONObject.fromObject( _req.getString("MOBL_COMM"));	
		BizLogUtil.debug(this, _cmo.getString("TRAN_NO"), "REQ :: " + input.toJSONString());	
		//// input 공통부   /////
		System.out.println("###################################################");
		System.out.println("###################################################");
		System.out.println("getid   :"   +    session.getId());
		System.out.println("###################################################");
		System.out.println("###################################################");
		// 세션값 체크
		JexDataCMO usersession = null;
		String sesion_yn = "Y";
		
    	try{
    		usersession   = SessionManager.getInstance().getUserSession(request, response);  		
    	}catch(Throwable e){
    		sesion_yn = "N";
    	}
    	
    	if(usersession == null){
    		System.out.println("usersession null");
    		System.out.println("sessionid : " + session.getId());
    	}

    	JSONObject enc_data = (JSONObject)input.get("ENC_DATA");
    	
    	System.out.println("enc_data :::::::::: " + enc_data.toString());
    	
    	String cert_data = "";
    	String cert_pwd  = "";

    	JSONObject encData = new JSONObject();
    	JSONParser parser  = new JSONParser();
    	
    	cert_data = StringUtil.null2void(enc_data.getString("CERT_DATA"));
    	cert_pwd  = StringUtil.null2void(enc_data.getString("CERT_PWD"));

    	System.out.println("CERT_DATA :: " + cert_data);
    	System.out.println("CERT_PWD  :: " + cert_pwd);
//     	System.out.println("usersession.getString(USER_ID)  :: " + usersession.getString("USER_ID"));
    	System.out.println("CommUtil.getPreScqKey()  :: " + CommUtil.getPreScqKey());
    	
    	
    	System.out.println("###################################################");
    	System.out.println("### SCQKEY  :: " + usersession.getString("SCQKEY"));
    	System.out.println("###################################################");
    	
    	if("Y".equals(sesion_yn)){
	    	// 인증서 비밀번호 복호화
	    	if(!"".equals(StringUtil.null2void(usersession.getString("SCQKEY")))){
	    		cert_pwd = CommUtil.getDecrypt(usersession.getString("SCQKEY"), cert_pwd);
	    	}else{
	    		cert_pwd = CommUtil.getDecrypt(usersession.getString("USE_INTT_ID")+CommUtil.getPreScqKey(), cert_pwd);
	    	}
    	}else{
    		cert_pwd = CommUtil.getDecrypt(CommUtil.getPreScqKey(), cert_pwd);
    	}
    	
    	//BizLogUtil.debug(this,":::::::복호화 cert_pwd :::::::: " + cert_pwd);

    	if(!CertUtils.verifyPassword(cert_data, cert_pwd) ){
    		result.put("RSLT_CD" , "SOER5009");
            result.put("RSLT_MSG", "인증서 비밀번호를 확인하세요.");
            result.put("RSLT_PROC_GB", "");
    	}else{
    		result.put("RSLT_CD" , "0000");
            result.put("RSLT_MSG", "정상 처리 되었습니다.");
            result.put("RSLT_PROC_GB", "");
    	}

        util.setResult(result, "default");

%>