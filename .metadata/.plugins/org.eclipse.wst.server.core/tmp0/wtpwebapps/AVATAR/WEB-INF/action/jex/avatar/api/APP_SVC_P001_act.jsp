<%@page import="com.avatar.comm.IdoSqlException"%>
<%@page import="com.avatar.api.mgnt.ZeropayApiMgnt"%>
<%@page import="jex.json.parser.JSONParser"%>
<%@page import="com.avatar.api.mgnt.KakaoApiMgnt"%>
<%@page import="com.avatar.api.mgnt.BizmApiMgnt"%>
<%@page import="jex.util.ByteUtil"%>
<%@page import="jex.util.base64.Base64"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="jex.util.crypto.CryptoUtil"%>
<%@page import="jex.sys.JexSystemConfig"%>
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
<%@page import="java.util.Calendar"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.avatar.comm.SvcStringUtil"%>
<%@page import="com.avatar.comm.SvcDateUtil"%>
<%@page import="com.avatar.comm.BizLogUtil"%>
<%@page import="com.avatar.comm.CommUtil"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.json.JSONArray"%>
<%@page import="com.avatar.service.LoginService"%>
<%@page import="com.avatar.comm.COMCode"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="jex.data.loader.JexDataCreator"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 로그인
         * @File Name    : APP_SVC_P001_act.jsp
         * @File path    : api
         * @author       : moving (  )
         * @Description  : 
         * @Register Date: 20200129145251
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

        @JexDataInfo(id="APP_SVC_P001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
       
		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();
        
        String inst_yn   = input.getString("INST_YN"); //최초(재)설치 여부
        String cust_ci   = input.getString("CUST_CI");
        String sApp_id   = "";
        
       	LoginService logsvc = new LoginService();
        JexData idoOut1 = null;
        
        String rslt_cd = "0000";
    	String rslt_msg = "";
    	String use_intt_id = "";
    	String sLgin_app = "AVATAR";
    	
    	// 사용자정보
        String user_str = StringUtil.null2void(input.getString("USER_INFO"));
    	// 연계 앱에서 들어온 경우
    	if(!"".equals(user_str)){
    		//byte[] targetBytes = Base64.decodeBuffer(user_str);
    		//user_str = new String(targetBytes);
    		
    		JSONObject user_info = JSONObject.fromObject(StringUtil.null2void(user_str));
    		// IBKCRM 테스트 떄문에 주석처리함 93,94,97,99번째 줄 주석 해지 해야함
    		// String secr_key = JexSystemConfig.get("avatarAPI", "secr_key");
    		// CryptoUtil crypt = CryptoUtil.createInstance(secr_key);
            
            // 복호화
            //String app_id =  new String(crypt.decryptSEED(ByteUtil.toBytesFromHexaString(user_info.getString("_app_id"))));
            // String app_id = new String(removePadding(crypt.decryptSEED(ByteUtil.toBytesFromHexaString(user_info.getString("_app_id"))) , 16));
            String app_id = "IBKCRM";
            app_id = app_id.trim();
            sApp_id = app_id;
            sLgin_app = app_id;
    	}

		// 고객원장조회 IBKCRM 회원이면 회원번호로 조회
		JexData idoIn1;
		if(sApp_id.equals("IBKCRM")){	
			idoIn1 = util.createIDOData("TB_BDP_CMIE01M_20220323");
			idoIn1.put("0","STTS");
		}else { 
			idoIn1 = util.createIDOData("CUST_LDGR_R002");
		}
        idoIn1.putAll(input);
        idoOut1 =  idoCon.execute(idoIn1);

        if (DomainUtil.isError(idoOut1)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
            }
            throw new JexWebBIZException(idoOut1);
        }
        
        result.putAll(idoOut1);
    	if (DomainUtil.getResultCount(idoOut1) > 0){
    		//IBK 고객이면 검증 안함.
    		if(sApp_id.equals("IBKCRM")){
    			
    		}else{
    			// 해지된 기관
    	       	if("9".equals(idoOut1.getString("STTS"))){
    	       		throw new JexWebBIZException(COMCode.COM_CODE_0017, "해지된 고객입니다.");
    	       	}
    	     	// 정지된 기관
    	       	if("8".equals(idoOut1.getString("STTS"))){
    	       		throw new JexWebBIZException(COMCode.COM_CODE_0034, "사용 정지된 고객입니다.");
    	       	}	
    		}
    	} else {
    		throw new JexWebBIZException(COMCode.COM_CODE_0002, COMCode.getErrCodeCustMsg(COMCode.COM_CODE_0002));
    	
    	}
    	
    	// IBKCRM 에는 USE_INTT_ID 필드가  없음.
    	if(!sApp_id.equals("IBKCRM")){
   			use_intt_id = StringUtil.null2void(idoOut1.getString("USE_INTT_ID"));
    	} else {
    		use_intt_id = StringUtil.null2void(idoOut1.getString("BLNG_BRCD"));
    	}
   		
   		// 연계정보가 없거나 제로페이 통해 들어왔을 경우
   		if(sApp_id.equals("") || sApp_id.equals("ZEROPAY")){
	   		// 제로페이 연결여부 조회
	    	JexData idoIn2 = util.createIDOData("CUST_LINK_SYS_INFM_R007");
	    	idoIn2.put("USE_INTT_ID", use_intt_id);
	    	idoIn2.put("APP_ID", "ZEROPAY");
	    	JexData idoOut2 = idoCon.execute(idoIn2);
	        
	        if (DomainUtil.isError(idoOut2)) {
	            if (util.getLogger().isDebug())
	            {
	                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
	                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
	            }
	            throw new JexWebBIZException(idoOut2);
	        }
	        
	        // 제로페이가 연결된 고객일 경우
	        if(!"0".equals(idoOut2.getString("LINK_CNT"))){
	        	sApp_id = "ZEROPAY";
	        	
	        	// 제로페이연결 
	         	JSONObject reqDat001 = ZeropayApiMgnt.data_api_001(cust_ci);
	         	
	         	// 제로페이 연결 성공
	        	if((reqDat001.getString("RSLT_CD")).equals("0000")){
	         		// 트랜젝션 시작
	            	idoCon.beginTransaction();
	         	
					// 가맹점정보 상태값 전체 변경
	        		JexData idoIn3 = util.createIDOData("ZERO_MEST_INFM_U001");
	        		idoIn3.put("USE_INTT_ID", use_intt_id);
	 				JexData idoOut3 = idoCon.execute(idoIn3);
					  
					if (DomainUtil.isError(idoOut3)) {
			        	idoCon.rollback();
			        	idoCon.endTransaction();
			        }
					
	         		JSONArray mestArr = JSONObject.fromArray(reqDat001.get("REC").toString());
	         		String userInfoModYn = "N";
	         		
	         		// 가맹점 리스트가 있을 경우
	    			for(int i = 0; i< mestArr.size(); i++){
	    			
	    			    JSONObject mestObj = (JSONObject)mestArr.get(i);
	    			    String user_state_code = StringUtil.null2void((String)mestObj.get("USER_STATE_CODE"));	// 가입 상태
	    			    String user_nm = StringUtil.null2void((String)mestObj.get("USER_NM"));					// 가입자 이름
           				String user_phone_no = StringUtil.null2void((String)mestObj.get("USER_PHONE_NO")); 		// 휴대폰번호
           				
						if(user_state_code.equals("01")) continue;
           				
           				// 회원의 상태가 정상인 경우(가입상태 :정상"00")
                   		if(user_state_code.equals("00")) {
                   			// 제로페이 통해 전달받은 고객명, 핸드폰번호
                       		if(!user_nm.equals("") && !user_phone_no.equals("") && userInfoModYn.equals("N")){
                       			// 고객명, 핸드폰번호 정보 수정
                           		JexData idoIn11 = util.createIDOData("CUST_LDGR_U009");
                           	    idoIn11.put("USE_INTT_ID", use_intt_id);
                           	    idoIn11.put("CUST_NM", user_nm);
                           	    idoIn11.put("CLPH_NO", user_phone_no);
                                JexData idoOut11 =  idoCon.execute(idoIn11);
                               
                                // 도메인 에러 검증
                                if (DomainUtil.isError(idoOut11)) {
                                	idoCon.rollback();
            			        	idoCon.endTransaction();
                                }
                                userInfoModYn = "Y";
                       		}
                   		}
           				
	    			    JSONArray qrArr = (JSONArray)mestObj.get("QR_LIST");
	    			    
	    			    String qr_cd = "";	// QR 코드값
	    			    // QR코드가 있을 경우
	    			    if(qrArr.size() > 0){
	    			    	JSONObject qrObj = (JSONObject)qrArr.get(0);
	    			    	qr_cd = StringUtil.null2void((String)qrObj.get("QR_CD"));						// QR 코드값
	    			    }
	    			   
	    			    String aflt_management_no = StringUtil.null2void((String)mestObj.get("AFLT_MANAGEMENT_NO"));// 가맹점관리번호
	    			    String biz_no = StringUtil.null2void((String)mestObj.get("BIZ_NO")); 				// 가맹점사업자번호
	    			    String ser_biz_no = StringUtil.null2void((String)mestObj.get("SER_BIZ_NO")); 		// 가맹점종사업번호
	    			    String aflt_nm = StringUtil.null2void((String)mestObj.get("AFLT_NM"));				// 가맹점명
	    			    String aflt_owner_nm = StringUtil.null2void((String)mestObj.get("AFLT_OWNER_NM"));	// 가맹점대표자명
	    			    String aflt_state_cd = "";															// 가맹점상태코드
	    			    String road_addr = StringUtil.null2void((String)mestObj.get("ROAD_ADDR"));			// 주소
	    			    String shop_tel_no = StringUtil.null2void((String)mestObj.get("SHOP_TEL_NO"));		// 전화번호
	    			    String market_nm = StringUtil.null2void((String)mestObj.get("MARKET_NM"));			// 시장명
	    			    String tpbs	= StringUtil.null2void((String)mestObj.get("TPBS"));					// 업종
	    				String bsst	= StringUtil.null2void((String)mestObj.get("BSST"));  					// 업태		
	    				String small_fee = StringUtil.null2void((String)mestObj.get("SMALL_FEE"),"0");		// 수수료율
	    				String biz_type_cd = StringUtil.null2void((String)mestObj.get("BIZ_TYPE_CD"));		// 업종코드
	    				
	    				// 가맹점 등록 /수정
	    				JexData idoIn4 = util.createIDOData("ZERO_MEST_INFM_C002");
	    				idoIn4.put("USE_INTT_ID", use_intt_id);
	    				idoIn4.put("AFLT_MANAGEMENT_NO", aflt_management_no);
	    				idoIn4.put("MEST_BIZ_NO", biz_no);
	    				idoIn4.put("SER_BIZ_NO", ser_biz_no);
	    				idoIn4.put("MEST_NM", aflt_nm);
	    				idoIn4.put("AFLT_OWNER_NM", aflt_owner_nm);
	    				idoIn4.put("AFLT_STATE_CD", aflt_state_cd);
	    				idoIn4.put("MEST_ADDR", road_addr);
	    				idoIn4.put("MEST_TEL_NO", shop_tel_no);
	    				idoIn4.put("MARKET_NM", market_nm);
	    				idoIn4.put("TPBS", tpbs);
	    				idoIn4.put("BSST", bsst);
	    				idoIn4.put("SMALL_FEE", small_fee);
	    				idoIn4.put("QR_CD", qr_cd);
	    				idoIn4.put("BIZ_TYPE_CD", biz_type_cd);
	    				idoIn4.put("USER_NM", user_nm);
	    				idoIn4.put("USER_PHONE_NO", user_phone_no);
	    				idoIn4.put("USER_STATE_CODE", user_state_code);
	    				
						JexData idoOut4 = idoCon.execute(idoIn4);
						  
						if (DomainUtil.isError(idoOut4)) {
				        	idoCon.rollback();
				        	idoCon.endTransaction();
				        }
						
						// 가맹점의 상품권 리스트 삭제
						JexData idoIn5 = util.createIDOData("ZERO_MEST_PINT_D001");
						idoIn5.put("USE_INTT_ID", use_intt_id);
						idoIn5.put("AFLT_MANAGEMENT_NO", aflt_management_no);
						idoIn5.put("MEST_BIZ_NO", biz_no);
						idoIn5.put("SER_BIZ_NO", ser_biz_no);
							
						JexData idoOut5 = idoCon.execute(idoIn5);
						  
						if (DomainUtil.isError(idoOut5)) {
				        	idoCon.rollback();
				        	idoCon.endTransaction();
				        }
						
						// 상품권 리스트
	    			    JSONArray pointArr = (JSONArray)mestObj.get("POINT_REC");
	    			    for(int pi = 0; pi < pointArr.size(); pi++){
	    			    	JSONObject pointObj = (JSONObject)pointArr.get(pi);
	    			    	String point_disc_cd = StringUtil.null2void((String)pointObj.get("POINT_DISC_CD"));				// 상품권분류코드
	        			    String point_nm = StringUtil.null2void((String)pointObj.get("POINT_NM")); 		   				// 상품권명
	        			    String point_img_url = StringUtil.null2void((String)pointObj.get("POINT_IMG_URL")); 			// 상품권이미지URL
	        			    String point_icon_img_url = StringUtil.null2void((String)pointObj.get("POINT_ICON_IMG_URL")); 	// 상품권아이콘이미지URL
	        			    
	        				// 가맹점의 상품권 등록
	    					JexData idoIn6 = util.createIDOData("ZERO_MEST_PINT_C001");
	        			    idoIn6.put("USE_INTT_ID", use_intt_id);
	        			    idoIn6.put("AFLT_MANAGEMENT_NO", aflt_management_no);
	        			    idoIn6.put("MEST_BIZ_NO", biz_no);
	        			    idoIn6.put("SER_BIZ_NO", ser_biz_no);
	        			    idoIn6.put("POINT_DISC_CD", point_disc_cd);
	        			    idoIn6.put("POINT_NM", point_nm);
	        			    idoIn6.put("POINT_IMG_URL", point_img_url);
	        			    idoIn6.put("POINT_ICON_IMG_URL", point_icon_img_url);
	    						
	    					JexData idoOut6 = idoCon.execute(idoIn6);
	    					  
	    					if (DomainUtil.isError(idoOut6)) {
	    			        	idoCon.rollback();
	    			        	idoCon.endTransaction();
	    			        }
						}
	    			}
	         		// 제로페이 아바타 연결정보 끊기(가맹점목록이 없거나 있어도 가입 상태가 탈퇴인 경우)
	         		if("N".equals(userInfoModYn)){
         				// 제로페이 연결데이터 끊기
    					JexData idoIn12 = util.createIDOData("CUST_LINK_SYS_INFM_D001");
        			    idoIn12.put("USE_INTT_ID", use_intt_id);
        			    idoIn12.put("APP_ID", "ZEROPAY");
        			    
    					JexData idoOut12 = idoCon.execute(idoIn12);
    					  
    					if (DomainUtil.isError(idoOut12)) {
    			        	idoCon.rollback();
    			        	idoCon.endTransaction();
    			        }
	         		}
	         		idoCon.commit();	
	        		idoCon.endTransaction();
	         	}
	         	// 제로페이에 등록된 회원 정보가 없을 경우
	        	else if((reqDat001.getString("RSLT_CD")).equals("B001")){
	         		// 제로페이 연결데이터 끊기
					JexData idoIn12 = util.createIDOData("CUST_LINK_SYS_INFM_D001");
    			    idoIn12.put("USE_INTT_ID", use_intt_id);
    			    idoIn12.put("APP_ID", "ZEROPAY");
    			    
					JexData idoOut12 = idoCon.execute(idoIn12);
					  
					if (DomainUtil.isError(idoOut12)) {
						if (util.getLogger().isDebug())
		   	            {
		   	                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut12));
		   	                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut12));
		   	            }
		   	            throw new JexWebBIZException(idoOut12);
			        }
	         	}
	        }
        }
   		
   		// 경리나라, KT경리나라 연결여부 조회
   		String sSerp_link_yn = "N", sKtSerp_link_yn = "N";
   		if(sApp_id.equals("SERP")){
   			sSerp_link_yn = "Y";
   			sKtSerp_link_yn = getSerpLinkYN(use_intt_id, "KTSERP", util, idoCon); 
   		} else if(sApp_id.equals("KTSERP")) {
   			sKtSerp_link_yn = "Y";
   			sSerp_link_yn = getSerpLinkYN(use_intt_id, "SERP", util, idoCon);
   		} else if(sApp_id.equals("IBKCRM")){
   			
   		} else{
   			sSerp_link_yn = getSerpLinkYN(use_intt_id, "SERP", util, idoCon);
   			sKtSerp_link_yn = getSerpLinkYN(use_intt_id, "KTSERP", util, idoCon);
   		}
	   		
   		
   		// 앱ID가 없을 경우 아바타로 셋팅
   		if(sApp_id.equals("")){
   			sApp_id = "AVATAR";
   		}
   		
   		util.getLogger().debug("appid================================== Code   ::"+sApp_id);
   		
   		
   		if(!sApp_id.equals("IBKCRM")) {
   			// 추천질의 TOP 10개 조회(로그인한 앱에 따라 추천 질의가 달라짐)
   	   		// 경리나라:경리나라전용질의,공통질의(아바타전용질의제외),제로페이전용질의제외
   	 		// 제로페이:제로페이전용질의
   	 		// 아바타:경리나라전용질의제외, 제로페이전용질의제외
   	 		JexData idoIn7 = util.createIDOData("QUES_HSTR_R004");
   	   		idoIn7.put("STR_DT", SvcDateUtil.getInstance().getDate(-6, 'D'));
   	   		idoIn7.put("END_DT", SvcDateUtil.getInstance().getDate());
   	   		idoIn7.put("APP_ID", sLgin_app);
   	   		JexDataList<JexData> idoOut7 =  idoCon.executeList(idoIn7);
   	        if (DomainUtil.isError(idoOut7)) {
   	            if (util.getLogger().isDebug())
   	            {
   	                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut7));
   	                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut7));
   	            }
   	            throw new JexWebBIZException(idoOut7);
   	        }
   	        result.put("QUES_LIST", idoOut7);
   	   		
   	   		// 데이터 연결 여부 조회
   	   		JexData idoIn8 = util.createIDOData("CARD_INFM_R011");
   	   		idoIn8.put("USE_INTT_ID", use_intt_id);
   	   		JexData idoOut8 =  idoCon.execute(idoIn8);
   	        if (DomainUtil.isError(idoOut8)) {
   	            if (util.getLogger().isDebug())
   	            {
   	                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut8));
   	                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut8));
   	            }
   	            throw new JexWebBIZException(idoOut8);
   	        }
   	        result.put("LINK_YN", idoOut8.getString("LINK_YN"));
   	        
   	        // 사용자 뱃지건수 초기화(로그인 성공 시 뱃지갯수 :0)
   	        JexData idoIn9 = util.createIDOData("CUST_LDGR_U008");
   	   		idoIn9.put("BADG_CNT", "0");
   	   		idoIn9.put("USE_INTT_ID", use_intt_id);
   	   		JexData idoOut9 =  idoCon.execute(idoIn9);
   	        if (DomainUtil.isError(idoOut9)) {
   	            if (util.getLogger().isDebug())
   	            {
   	                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut9));
   	                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut9));
   	            }
   	            throw new JexWebBIZException(idoOut9);
   	        }
   		}
   		
        
        JSONObject device_info = (JSONObject)input.get("DEVICE_INFO");

        /**=========================================
        *	세션 생성
        =========================================**/
    	if(request.getSession(false) != null) {
    		request.getSession().invalidate();
    	}
        
        SessionManager sessionMgr = SessionManager.getInstance();
        JexDataCMO sessionCmo = JexDataCreator.createCMOData("AVATAR_SESSION");

        // TODO : 박지은 계정으로 로그인 시 제로페이 화면 보여줌
        if(/* use_intt_id.equals("A210800009")   ||*/ use_intt_id.equals("A200300026") ){
        }
        
        String nAPP_ID = StringUtil.null2void(input.getString("APP_ID"));
        
        try{
        	if(sApp_id.equals("IBKCRM")){
        		sessionCmo.put("CUST_CI"    	 , ""); 	// 고객CI
        		sessionCmo.put("CUST_NM"    	 , ""); 	// 고객명
        		sessionCmo.put("EMN"			 , idoOut1.getString("EMN")); 	   // 직원번호
    			sessionCmo.put("APP_OS"          , input.getString("APP_OS")); 		// 앱실행OS
    			sessionCmo.put("APP_VER"         , input.getString("APP_VER")); 	// 앱버젼
    			sessionCmo.put("DEVICE_ID"		 , device_info.getString("_device_id")); 
    			sessionCmo.put("CLPH_NO"		 , idoOut1.getString("EMP_CPN")); //휴대폰번호
    			sessionCmo.put("APP_OS"          , input.getString("APP_OS")); 		// 앱실행OS
    			sessionCmo.put("APP_VER"         , input.getString("APP_VER")); 	// 앱버젼
    			sessionCmo.put("USE_INTT_ID"	 , use_intt_id);
        	} else {
        		sessionCmo.put("CLPH_NO"         , idoOut1.getString("CLPH_NO")); 	// 휴대폰번호
    			sessionCmo.put("BSNN_NM"         , idoOut1.getString("BSNN_NM")); 	// 사업장명
    			sessionCmo.put("STTS"            , idoOut1.getString("STTS")); 		// 상태
    			sessionCmo.put("SCQKEY"          , idoOut1.getString("USE_INTT_ID") + CommUtil.getPreScqKey()); // 키보드보안키
    			sessionCmo.put("APP_OS"          , input.getString("APP_OS")); 		// 앱실행OS
    			sessionCmo.put("APP_VER"         , input.getString("APP_VER")); 	// 앱버젼
    	 		sessionCmo.put("CUST_CI"    	 , idoOut1.getString("CUST_CI")); 	// 고객CI
    	 		sessionCmo.put("CUST_NM"    	 , idoOut1.getString("CUST_NM")); 	// 고객명
    	 		sessionCmo.put("USE_INTT_ID"	 , use_intt_id);
    	 		sessionCmo.put("DEVICE_INST_ID"	 , idoOut1.getString("DEVICE_INST_ID"));
    	 		sessionCmo.put("DEVICE_ID"		 , device_info.getString("_device_id"));
    	 		sessionCmo.put("SERP_LINK_YN"	 , sSerp_link_yn); 					// 경리나라 연결여부
    	 		sessionCmo.put("KTSERP_LINK_YN"	 , sKtSerp_link_yn); 				// KT경리나라 연결여부
        	}
        	
	 		
	 		// NATIVE에서 넘겨주는 값으로 바로 셋팅
	        if(!nAPP_ID.equals("")){
	        	sessionCmo.put("APP_ID"		 , nAPP_ID); 
	        	sessionCmo.put("LGIN_APP"	 , nAPP_ID); 
	        }else{
	        	sessionCmo.put("APP_ID"		 , sApp_id); 	// 앱ID(AVATAR, SERP..)
	        	sessionCmo.put("LGIN_APP"	 , sLgin_app); 	// 연계앱 통해 로그인한 경우(AVATAR, SERP, ZEROPAY, KTSERP)
	        }
        	sessionMgr.setUserSession(request, response, sessionCmo);
        	
        	// 디바이스 등록
      		logsvc.deviceInfoService(use_intt_id, device_info);
        	logsvc.insLoginHis(use_intt_id, CommUtil.getHostName(), request.getRemoteAddr());
        	
			result.put("CERT_EXPI_STTS", "0"); //인증서상태 ('0:정상, 1:만료전, 8:만료전+만료, 9:만료) 
        	
        }catch(Exception e){
        	e.printStackTrace();
        	throw new JexWebBIZException("S"+rslt_cd, rslt_msg);
        }
        
        util.getLogger().debug("Created Session="+sessionCmo.toJSONString());
        
        if(sApp_id.equals("IBKCRM")){
        	result.put("EMN" , idoOut1.getString("EMN")); // 직원번호
        	result.put("CLPH_NO", idoOut1.getString("EMP_CPN"));
        	result.put("APP_ID", sApp_id);
            result.put("LGIN_APP", sLgin_app);
            result.put("CERT_YN", "Y"); //인증여부
        	result.put("DEVICE_ID", device_info.getString("_device_id"));
        	result.put("USER_NM", idoOut1.getString("PNMN_BRM")); // 직원명
        	result.put("USER_LOGN_NO", CommUtil.getScqKey(use_intt_id));
        	result.put("USE_INTT_ID", use_intt_id);
        	result.put("USER_INFO", StringUtil.null2void(input.getString("USER_INFO")));
        	result.put("CUST_CI", "");
        }else{
        	result.put("USER_INFO", StringUtil.null2void(input.getString("USER_INFO")));
            result.put("APP_ID", sApp_id);
            result.put("LGIN_APP", sLgin_app);
            result.put("USE_INTT_ID", use_intt_id);
            result.put("CLPH_NO", idoOut1.getString("CLPH_NO"));
            result.put("CERT_YN", "Y");
            result.put("USER_NM", idoOut1.getString("CUST_NM"));
            result.put("USER_LOGN_NO", CommUtil.getScqKey(use_intt_id));
            result.put("CUST_CI", cust_ci);
            result.put("DEVICE_ID", device_info.getString("_device_id"));
        }
        
        // NATIVE에서 넘겨주는 값으로 바로 셋팅
        if(!nAPP_ID.equals("")){
        	result.put("LGIN_APP", nAPP_ID);
        	result.put("APP_ID", nAPP_ID);
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
<%!
		public String getSerpLinkYN(String use_intt_id, String app_id, WebCommonUtil util, JexConnection idoCon) throws Exception {
			String isSerp_link_yn = "N";
			
			// 경리나라 연결여부 조회
	    	JexData idoIn10 = util.createIDOData("CUST_LINK_SYS_INFM_R007");
	    	idoIn10.put("USE_INTT_ID", use_intt_id);
	    	idoIn10.put("APP_ID", app_id);
	    	JexData idoOut10 = idoCon.execute(idoIn10);
	        
	        if (DomainUtil.isError(idoOut10)) {
	            if (util.getLogger().isDebug())
	            {
	                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut10));
	                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut10));
	            }
	            throw new JexWebBIZException(idoOut10);
	        }
	        
	        // 경리나라가 연결된 고객일 경우
	        if(!"0".equals(idoOut10.getString("LINK_CNT"))){
	        	isSerp_link_yn = "Y";
	        }
			
			return isSerp_link_yn;
		}
%>


