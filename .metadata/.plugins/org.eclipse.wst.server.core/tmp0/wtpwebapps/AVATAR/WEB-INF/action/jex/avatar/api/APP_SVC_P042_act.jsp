<%@page import="jex.util.ByteUtil"%>
<%@page import="jex.util.base64.Base64"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="jex.util.crypto.CryptoUtil"%>
<%@page import="jex.sys.JexSystemConfig"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="jex.util.StringUtil"%>
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
<%@page import="java.net.URLDecoder" %>
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 정보제공동의여부조회
         * @File Name    : APP_SVC_P042_act.jsp
         * @File path    : api
         * @author       : jepark (  )
         * @Description  : 정보제공동의여부조회
         * @Register Date: 20210310130437
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

        @JexDataInfo(id="APP_SVC_P042", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

	    // IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();
     
        //String user_str = StringUtil.null2void(input.getString("USER_INFO"));
        //encoding 적용 시 아래 소스 사용
    	//String user_str = StringUtil.null2void(URLDecoder.decode(input.getString("USER_INFO")));
    	String user_str = StringUtil.null2void(input.getString("USER_INFO"));
    	String app_id = "";
        String user_key = "";
        String token = "";
        String info_cosn_yn = "N";
        
       	/*
       	if(cust_ci.equals("3TY+OE7aYuk6gOSi91GCorKxd+oPX/GYX/7ymrRqUZIGSNYpNrvmJvbZPUcTSZw2wBNGGfMIVRY8NnFvJy5JXg==")){
        	user_str = "{\"_user_key\":\"CTkZ80Dbmcg6gKEdaBZEbi33mlKMnvdWrOpTvTk2ZAM=\",\"_token\":\"GD3tVfMHBe65oVd3zYNeDuHY1tLLp5CWEuC5xsRsaLtSkNnjfexZ+RcH3rTlOzITw1GNooot+TPR5ab1Xax8/W6SsA3gRCwmndKUDbHmx6ZFBISrmlA3s8EiU8Xjk6vQ4YGuizGBGSrtOoOtWXGpdgKNLfgLwM6PHTBZ0UuEOa5LqstnUHZYgcOtDifR8TxPut5nY55B4616fqPLdUYj41ir2BiOg2YIcAq89ePnJtRiSzcNHSlcEH0y5W99R43TJc37oQF7EKKW4DwYirxK/g==\",\"_app_id\":\"8T0XZt2HMQFbN1qIXO62Ew==\"}";
        }
       	*/
       	
     	// 연계 앱에서 들어온 경우
    	if(!"".equals(user_str)){
    		
    		JSONObject user_info = JSONObject.fromObject(StringUtil.null2void(user_str));
    		String secr_key = JexSystemConfig.get("avatarAPI", "secr_key");
    		CryptoUtil crypt = CryptoUtil.createInstance(secr_key);
            
    		
    		// 복호화
            //app_id =  new String(crypt.decryptSEED(ByteUtil.toBytesFromHexaString(user_info.getString("_app_id"))));
            //user_key =  new String(crypt.decryptSEED(ByteUtil.toBytesFromHexaString(user_info.getString("_user_key"))));
            app_id = new String(removePadding(crypt.decryptSEED(ByteUtil.toBytesFromHexaString(user_info.getString("_app_id"))) , 16));
            user_key = new String(removePadding(crypt.decryptSEED(ByteUtil.toBytesFromHexaString(user_info.getString("_user_key"))) , 16));
            token = "";  
            app_id = app_id.trim();
            /*
            System.out.println("::::::::::::::::");
            System.out.println("::::::::::::::::secr_key :" +secr_key);
            System.out.println("::::::::::::::::app_id :" +app_id);
            System.out.println("::::::::::::::::user_key :" +user_key);
            System.out.println("::::::::::::::::");
			*/
			
			
			// 경리나라에서 호출한 경우
    		if(app_id.contains("SERP")){
    			//token =  new String(crypt.decryptSEED(ByteUtil.toBytesFromHexaString(user_info.getString("_token"))));
    			token = new String(removePadding(crypt.decryptSEED(ByteUtil.toBytesFromHexaString(user_info.getString("_token"))) , 16));
    			
    			// util.getLogger().debug(crypt.encryptSEED(ByteUtil.toHexaString("SERP".getBytes())));
    			
    			IDODynamic dynamic = new IDODynamic();	
    			dynamic.addSQL("AND TOKEN = '"+token+"'");
    			
    			// 앱 연결여부 조회
    			JexData idoIn0 = util.createIDOData("CUST_LINK_SYS_INFM_R004");
    			idoIn0.put("APP_ID", app_id);
    			idoIn0.put("USER_ID", user_key);
    			idoIn0.put("DYNAMIC_0", dynamic);

    	    	JexData idoOut0 = idoCon.execute(idoIn0);
    	    	
    	        if (DomainUtil.isError(idoOut0)) {
    	            if (util.getLogger().isDebug())
    	            {
    	                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut0));
    	                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut0));
    	            }
    	            throw new JexWebBIZException(idoOut0);
    	        }
    	        
    	        int link_cnt = DomainUtil.getResultCount(idoOut0);
    	        
    	        // 정보동의제공 하지 않은 경우 CI값을 내려줄수 없음.
    	        if(link_cnt == 0){
    	        	result.put("CUST_CI", "");	// 고객CI
    	        }
    	        // 연결 정보 있음. 연결정보가 있다는것은 이미 회원가입 되어있음.
    	        else{
    	        	info_cosn_yn = "Y";
    	        	// 사용자 정보 조회(이용기관기준)
    	        	JexData idoIn1 = util.createIDOData("CUST_LDGR_R020");
    	        	idoIn1.put("USE_INTT_ID", idoOut0.getString("USE_INTT_ID"));

    	        	JexData idoOut1 = idoCon.execute(idoIn1);
    	    	
	    	        if (DomainUtil.isError(idoOut1)) {
	    	            if (util.getLogger().isDebug())
	    	            {
	    	                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
	    	                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
	    	            }
	    	            throw new JexWebBIZException(idoOut1);
	    	        }
	    	        // 경리나라 계정이랑 연결되어 있는 CI값을 내려줌
	    	        result.put("CUST_CI", URLEncoder.encode(idoOut1.getString("CUST_CI")));	// 고객CI
    			}
    	        result.put("INFO_COSN_YN", info_cosn_yn);	// 정보제공동의여부
	        	result.put("USER_INFO", StringUtil.null2void(input.getString("USER_INFO")));// 연계사용자정보
	        	result.put("APP_ID", app_id);				// 연계앱 ID
	            
    		}
            // 제로페이에서 호출한 경우(user_key는 제로페이에서 사용하는 고객 CI)
    		else if(app_id.equals("ZEROPAY")){
    			
    			// 앱 연결여부 조회
    			JexData idoIn0 = util.createIDOData("CUST_LINK_SYS_INFM_R006");
    			idoIn0.put("APP_ID", app_id);
    			idoIn0.put("USER_KEY", user_key);
    			
    	    	JexData idoOut0 = idoCon.execute(idoIn0);
    	    	
    	        if (DomainUtil.isError(idoOut0)) {
    	            if (util.getLogger().isDebug())
    	            {
    	                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut0));
    	                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut0));
    	            }
    	            throw new JexWebBIZException(idoOut0);
    	        }
    	        
    	        int link_cnt = DomainUtil.getResultCount(idoOut0);
    	        
    	        // 정보동의제공 하지 않은 경우 CI값을 내려줄수 없음.
    	        if(link_cnt == 0){
    	        	result.put("CUST_CI", "");	// 고객CI
    	        }
    	        // 연결 정보 있음. 연결정보가 있다는것은 이미 회원가입 되어있음.
    	        else{
    	        	info_cosn_yn = "Y";
	    	        result.put("CUST_CI", URLEncoder.encode(user_key));	// 고객CI
    			}
    	        result.put("INFO_COSN_YN", info_cosn_yn);	// 정보제공동의여부
	        	result.put("USER_INFO", StringUtil.null2void(input.getString("USER_INFO")));// 연계사용자정보
	        	result.put("APP_ID", app_id);		
    		}
    		// 그외 기타 앱에서 들어온 경우(현재 없음)
            else{
    		}
         
    	}
        util.setResult(result, "default");

%>
<%!
		public static byte[] removePadding(byte[] source, int blockSize) {
			byte[] paddingResult = null;
			boolean isPadding = false;
			int lastValue = source[source.length - 1];
			
			if (0 < lastValue && lastValue < (blockSize - 1)) {
				for (int i = 1; i <= lastValue; i++) {
					if (source[source.length - i] != lastValue) {
						isPadding = false;
						break;
					}
					isPadding = true;
				}
			} else {
				isPadding = false;
			}
			
			if (isPadding) {
				paddingResult = new byte[source.length - lastValue];
				System.arraycopy(source, 0, paddingResult, 0, paddingResult.length);
			} else {
				paddingResult = source;
			}
			return paddingResult;
		}
%>