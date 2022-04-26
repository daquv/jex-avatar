<%@page import="com.avatar.api.mgnt.BizmApiMgnt"%>
<%@page import="com.avatar.comm.BizLogUtil"%>
<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="jex.util.date.DateTime"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="com.avatar.comm.CommUtil"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="com.avatar.api.mgnt.CooconApi"%>
<%@page import="com.avatar.comm.ApiUtil"%>
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
         * @File Title   : 홈택스 부가가치세/종합소득세 수정
         * @File Name    : tax_0001_01_u002_act.jsp
         * @File path    : tax
         * @author       : jepark (  )
         * @Description  : 홈택스 부가가치세/종합소득세 수정
         * @Register Date: 20210514143715
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

        @JexDataInfo(id="tax_0001_01_u002", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        JexDataCMO userSession = SessionManager.getSession(request, response);
        String use_intt_id = userSession.getString("USE_INTT_ID");
        String user_id = userSession.getString("CUST_CI");
        //모바일에서 인증서 사업자번호를 주는지 확인이 필요함.-- 세션에 사업자 번호 없음(api 마다 달라 질수 있어서 임시로 넣어놈)
        String bsnn_no = userSession.getString("USE_INTT_ID");
        		
    	// 기관원장 수정 여부 
      	boolean inttUdt = false;
      	String sBSNN_NM = "";
    	String sRPPR_NM = "";
    	String sADRS = "";
    	String sBSST = "";
    	String sTPBS = "";
    	
    	// 인증서 암호
    	String cert_pwd = "";
    	String decryptKey = userSession.getString("SCQKEY");
    	
    	// 인증서 암호 복호화
    	cert_pwd = CommUtil.getDecrypt(decryptKey, StringUtil.null2void(input.getString("CERT_PWD")));
    	
    	String before_cert_name = StringUtil.null2void(input.getString("BEFORE_CERT_NAME"));
    	String cert_name = StringUtil.null2void(input.getString("CERT_NAME"));
    	String cert_org = StringUtil.null2void(input.getString("CERT_ORG"));
    	String cert_date = StringUtil.null2void(input.getString("CERT_DATE"));
    	String cert_folder = StringUtil.null2void(input.getString("CERT_FOLDER"));
    	String cert_data = StringUtil.null2void(input.getString("CERT_DATA"));
    	String reg_type = StringUtil.null2void(input.getString("REG_TYPE"));
    	String stts = StringUtil.null2void(input.getString("STTS"));
    	String cert_dsnc = StringUtil.null2void(input.getString("CERT_DSNC"));
    	String cert_usag_div = StringUtil.null2void(input.getString("CERT_USAG_DIV"));
    	String strToday = DateTime.getInstance().getDate("yyyymmdd");
    	String cert_issu_dt = StringUtil.null2void(input.getString("CERT_ISSU_DT"));
    	String cert_reg_type = "1";

    	JSONObject resData1 = new JSONObject();
    	JSONObject resData2 = new JSONObject();

    	String strResData0 ="00000000";
    	String strResData1 ="00000000";

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
     	// 트랜젝션 시작
    	idoCon.beginTransaction();
    	
    	String bsnn_no_t = bsnn_no;
    	
    	if(bsnn_no.startsWith("A0399")){
    		if(cert_name.indexOf("웹케시글로벌") > -1){
    			bsnn_no_t = "1078527739";
    		}else if(cert_name.indexOf("웹케시벡터") > -1 || cert_name.indexOf("웹케시홀딩스") > -1){
    			bsnn_no_t = "1078772295";
    		}else if(cert_name.indexOf("비즈플레이") > -1){
    			bsnn_no_t = "1078836127";
    		}else if(cert_name.indexOf("웹케시네트웍스") > -1 || cert_name.indexOf("한국가치서비스") > -1){
    			bsnn_no_t = "1078686171";
    		}
    	}
    	
    	BizLogUtil.debug(this," ===== CERT INFO ===== ");
    	BizLogUtil.debug(this,"bsnn_no_t 		::  " + bsnn_no_t);
    	BizLogUtil.debug(this,"cert_name        ::  " + cert_name);
    	BizLogUtil.debug(this,"cert_org         ::  " + cert_org);
    	BizLogUtil.debug(this,"cert_date        ::  " + cert_date);
    	BizLogUtil.debug(this,"cert_pwd     	::  " + cert_pwd);
    	BizLogUtil.debug(this,"cert_folder      ::  " + cert_folder);
    	BizLogUtil.debug(this,"reg_type      	::  " + reg_type);
    	//BizLogUtil.debug(this,"cert_data      	::  " + cert_data);
    	BizLogUtil.debug(this," =====================");
    	 
    	// 인증서 등록일 경우 검증 방법
    	if(reg_type.equals("1")){
    		// 등록되지 않은 인증서일 경우 검증 방법(인증서정보 이용)
    		// 인증서검증(실시간 납부할 세액조회)
    		resData1 = CooconApi.getTaxHstrDtlWithCertInfo(cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data);
    		
    		strResData1 = (String)resData1.get("RESULT_CD");
    	}else{
    		// 등록된 인증서일 경우 검증 방법(인증서명 이용)
    		// 인증서검증(실시간 납부할 세액조회)
    		resData1 = CooconApi.getTaxHstrWithCertName(bsnn_no, cert_name);
    		
    		strResData1 = (String)resData1.get("ERRCODE");
    	}
    	
    	// 정상이 아닐 경우
    	if(!"00000000".equals(strResData1) && !"4".equals(StringUtil.null2void(strResData1).substring(0, 1))){
    		result.put("RSLT_CD", strResData1);
    		result.put("RSLT_MSG", ApiUtil.getCooconErroMsgStr(strResData1));
    		util.setResult(result, "default");
    		return;
    	}
    	
     	// 인증서 등록 여부 확인
        JexData idoIn1 = util.createIDOData("CERT_INFM_R003");
    
        idoIn1.put("USE_INTT_ID", use_intt_id);
        idoIn1.put("CERT_NM", cert_name);
    
        JexData idoOut1 =  idoCon.execute(idoIn1);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut1)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
            }
            idoCon.rollback();
    		result.put("RSLT_CD", "SOER1000");
    		result.put("RSLT_MSG", "처리중오류가발생하였습니다. 잠시후이용하시기바랍니다.");
    		util.setResult(result, "default");
    		return;
        }
        
      	// COOCON REG_TYPE=1 : 계정원장(UPDATE) 및 인증서 원장변경(DELETE INSERT 임)
    	// COOCON REG_TYPE=0 : 계정원장(UPDATE) 변경
    	// REG_TYPE=1 예외 : 인증서명이 변경된 경우 DELETE시 예외발생됨.
    	if( "0".equals(reg_type) 
    		&& !"".equals(StringUtil.null2void(idoOut1.getString("CERT_NM")))
    		&& cert_date.equals(StringUtil.null2void(idoOut1.getString("CERT_DT")))
    		&& cert_issu_dt.equals(StringUtil.null2void(idoOut1.getString("CERT_ISSU_DT")))){
    		cert_reg_type = "0";
    	}
      	
    	// 인증서 존재 여부 조회
        JexData idoIn2 = util.createIDOData("CERT_INFM_R006");
    
        idoIn2.put("USE_INTT_ID", use_intt_id);
        idoIn2.put("CERT_NM", cert_name);
    
        JexData idoOut2 =  idoCon.execute(idoIn2);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut2)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
            }
            idoCon.rollback();
    		result.put("RSLT_CD", "SOER1000");
    		result.put("RSLT_MSG", "처리중오류가발생하였습니다. 잠시후이용하시기바랍니다.");
    		util.setResult(result, "default");
    		return;
        }
    
     	// 인증서 정보 존재하지 않으면 등록
    	if(Integer.parseInt(idoOut2.getString("CERT_CNT")) == 0){
    		// 인증서 등록
	        JexData idoIn3 = util.createIDOData("CERT_INFM_C003");
	    
	        idoIn3.put("USE_INTT_ID", use_intt_id);
	        idoIn3.put("CERT_NM", cert_name);
	        idoIn3.put("CERT_ORG", cert_org);
	        idoIn3.put("CERT_DSNC", cert_dsnc);
	        idoIn3.put("CERT_DT", cert_date);
	        idoIn3.put("CERT_STTS", "1");
	        idoIn3.put("REGR_ID", user_id);
	        idoIn3.put("CERT_USAG_DIV", cert_usag_div);
	        idoIn3.put("CERT_ISSU_DT", cert_issu_dt);
	    
	        JexData idoOut3 =  idoCon.execute(idoIn3);
	    
	        // 도메인 에러 검증
	        if (DomainUtil.isError(idoOut3)) {
	            if (util.getLogger().isDebug())
	            {
	                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut3));
	                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut3));
	            }
	            idoCon.rollback();
	    		result.put("RSLT_CD", "SOER1000");
	    		result.put("RSLT_MSG", "처리중오류가발생하였습니다. 잠시후이용하시기바랍니다.");
	    		util.setResult(result, "default");
				return;
	        }
    	}else{
    		if(reg_type.equals("1")){
    			// 인증서 정보 변경
    			JexData idoIn4 = util.createIDOData("CERT_INFM_U002");
    
    			idoIn4.put("USE_INTT_ID", use_intt_id);
    			idoIn4.put("CERT_NM", cert_name);
    			idoIn4.put("CERT_DT", cert_date);
    			idoIn4.put("CERT_ORG", cert_org);
    			idoIn4.put("CERT_DSNC", cert_dsnc);
    			idoIn4.put("CERT_USAG_DIV", cert_usag_div);
    			idoIn4.put("CERT_ISSU_DT", cert_issu_dt);
    			idoIn4.put("CERT_STTS", "1");
    			idoIn4.put("CORR_ID", user_id);
		    
		        JexData idoOut4 =  idoCon.execute(idoIn4);
		    
		        // 도메인 에러 검증
		        if (DomainUtil.isError(idoOut4)) {
		            if (util.getLogger().isDebug())
		            {
		                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut4));
		                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut4));
		            }
		            idoCon.rollback();
		    		result.put("RSLT_CD", "SOER1000");
		    		result.put("RSLT_MSG", "처리중오류가발생하였습니다. 잠시후이용하시기바랍니다.");
		    		util.setResult(result, "default");
					return;
		        }
    		}else{
    			// 인증서 상태 변경
		        JexData idoIn5 = util.createIDOData("CERT_INFM_U003");
    
				idoIn5.put("USE_INTT_ID", use_intt_id);
				idoIn5.put("CERT_NM", cert_name);
				idoIn5.put("CERT_STTS", "1");
				idoIn5.put("CERT_USAG_DIV", cert_usag_div);
				idoIn5.put("CORR_ID", user_id);
    
		        JexData idoOut5 =  idoCon.execute(idoIn5);
		    
		        // 도메인 에러 검증
		        if (DomainUtil.isError(idoOut5)) {
		            if (util.getLogger().isDebug())
		            {
		                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut5));
		                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut5));
		            }
		            idoCon.rollback();
		    		result.put("RSLT_CD", "SOER1000");
		    		result.put("RSLT_MSG", "처리중오류가발생하였습니다. 잠시후이용하시기바랍니다.");
		    		util.setResult(result, "default");
					return;
		        }
    		}
    	}
    
    	// 홈택스 부가가치세/종합소득세 상태 조회
    	JexData idoIn6 = util.createIDOData("EVDC_INFM_R017");
    
        idoIn6.put("USE_INTT_ID", use_intt_id);
        idoIn6.put("EVDC_DIV_CD", input.getString("EVDC_DIV_CD"));
        
        JexData idoOut6 =  idoCon.execute(idoIn6);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut6)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut6));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut6));
            }
            idoCon.rollback();
    		result.put("RSLT_CD", "SOER1000");
    		result.put("RSLT_MSG", "처리중오류가발생하였습니다. 잠시후이용하시기바랍니다.");
    		util.setResult(result, "default");
			return;
        }
    
        stts = StringUtil.null2void(idoOut6.getString("STTS"));	// 부가가치세/종합소득세 상태값
        
    	// 부가가치세/종합소득세정보 저장되어 있는 값이 없으면 최초등록
    	if("".equals(stts)){
    		result.put("FST_REG_YN", "Y");
    	}else{
    		result.put("FST_REG_YN", "N");
    	}
    	
    	if("".equals(stts)){
    		// 부가가치세/종합소득세 증빙설정정보 등록
    		JexData idoIn7 = util.createIDOData("EVDC_INFM_C002");
    
	        idoIn7.put("USE_INTT_ID", use_intt_id);
	        idoIn7.put("EVDC_DIV_CD", input.getString("EVDC_DIV_CD"));
			idoIn7.put("BIZ_NO", bsnn_no);
			idoIn7.put("CERT_NM", cert_name);
			idoIn7.put("CERT_ORG", cert_org);
			idoIn7.put("CERT_DT", cert_date);
			idoIn7.put("STTS", "1");
			idoIn7.put("REGR_ID", user_id);
			idoIn7.put("CORR_ID", user_id);
	    
	        JexData idoOut7 =  idoCon.execute(idoIn7);
	    
	        // 도메인 에러 검증
	        if (DomainUtil.isError(idoOut7)) {
	            if (util.getLogger().isDebug())
	            {
	                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut7));
	                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut7));
	            }
	            idoCon.rollback();
	    		result.put("RSLT_CD", "SOER1000");
	    		result.put("RSLT_MSG", "처리중오류가발생하였습니다. 잠시후이용하시기바랍니다.");
	    		util.setResult(result, "default");
				return;
	        }
    	}else{
    		// 부가가치세/종합소득세 증빙설정정보 변경
    		JexData idoIn8 = util.createIDOData("EVDC_INFM_U008");
    
	        idoIn8.put("CERT_NM", cert_name);
	        idoIn8.put("CERT_ORG", cert_org);
	        idoIn8.put("CERT_DT", cert_date);
	        idoIn8.put("STTS", "1");
	        idoIn8.put("CORR_ID", user_id);
	        idoIn8.put("USE_INTT_ID", use_intt_id);
	        idoIn8.put("EVDC_DIV_CD", input.getString("EVDC_DIV_CD"));
	        idoIn8.put("BIZ_NO", bsnn_no);
	    
	        JexData idoOut8 =  idoCon.execute(idoIn8);
	    
	        // 도메인 에러 검증
	        if (DomainUtil.isError(idoOut8)) {
	            if (util.getLogger().isDebug())
	            {
	                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut8));
	                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut8));
	            }
	            idoCon.rollback();
	    		result.put("RSLT_CD", "SOER1000");
	    		result.put("RSLT_MSG", "처리중오류가발생하였습니다. 잠시후이용하시기바랍니다.");
	    		util.setResult(result, "default");
				return;
	        }
    	}

    	// 등록여부가 0(인증서 미등록)일때 인증서이름 제외하고 초기화 (이미 인증서 정보가 등록되어 있음)
    	if(reg_type.equals("0")){
    		cert_org    = "";
    		cert_date   = "";
    		cert_pwd    = "";
    		cert_folder = "";
    		cert_data   = "";
    	}
    	
    	// 변경전 인증서명(거래구분코드가 "U:수정"인 경우만 입력)
    	if(!"1".equals(stts)){
    		before_cert_name = "";
    	}

    	if("1".equals(stts)){
    		// 홈택스 부가가치세/종합소득세 정보수정
    		resData2 = CooconApi.updateEvdcTax(bsnn_no, bsnn_no, cert_name, before_cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, cert_reg_type, "1");
    	}else{
    		// 홈택스 부가가치세/종합소득세 정보등록
    		resData2 = CooconApi.insertEvdcTax(bsnn_no, bsnn_no, cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, cert_reg_type, "1");
    	}
    	
    	//(00000000:정상, WSND0004:이미 등록된 내용이 있습니다.)
    	if("00000000".equals(resData2.get("ERRCODE"))||"WSND0004".equals(resData2.get("ERRCODE"))){// 성공
    		idoCon.commit();
   		
   			result.put("RSLT_CD", (String)resData2.get("ERRCODE"));
   			result.put("RSLT_MSG", ApiUtil.getCooconErroMsgStr((String)resData2.get("ERRCODE")));
   			
   			// 고객데이터수집기준정보 조회
			JexData idoIn8 = util.createIDOData("CUST_RT_BACH_INFM_R002");
          	
			idoIn8.put("USE_INTT_ID", use_intt_id);
			idoIn8.put("EVDC_GB", "02");
			
			JexData idoOut8 =  idoCon.execute(idoIn8);
              
			if(DomainUtil.isError(idoOut8)) {
				if (util.getLogger().isDebug())
				{
	                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut8));
	                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut8));
	            }
	        }
			
			/*
			// TODO : 납부할 세액 매시간 로직이 추가되면 주석 풀어야됨.
			String pay_yn = StringUtil.null2void(idoOut8.getString("PAY_YN"),"N");
           
            // 아바타 유료회원 신청/해지(현금영수증 : 002, 전자세금계산서 : 006, 부가가치세/종합소득세 : 007)
            JSONObject resJData = CooconApi.insertMembership("007", use_intt_id, pay_yn);
               
            //(00000000:정상, WSND0004:이미 등록된 내용이 있습니다.)
            if("00000000".equals(resJData.get("ERRCODE")) || "WSND0004".equals(resJData.get("ERRCODE"))){
               	BizLogUtil.debug(this, "아바타 부가가치세/종합소득세 유료회원 신청/해지 정상처리되었습니다. (변경데이터 : "+pay_yn+")");   
            }else{
               	BizLogUtil.debug(this, "아바타 부가가치세/종합소득세 유료회원 신청/해지 중 오류가 발생하였습니다. (변경데이터 : "+pay_yn+")");
            }
            */
            
         	// 고객핸드폰번호 조회
    		JexData idoIn9 = util.createIDOData("CUST_LDGR_R035");
        	
    		idoIn9.put("USE_INTT_ID", use_intt_id);
    			
            JexData idoOut9 =  idoCon.execute(idoIn9);
            
            if(DomainUtil.isError(idoOut9)) {
				if (util.getLogger().isDebug()) {
					util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut9));
					util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut9));
				}
			}
            
            String clph_no = StringUtil.null2void(idoOut9.getString("CLPH_NO"));
            
    		// 홈택스(세액내역) 연동 알림톡 전송
    		String msg = "";
    		msg += "홈택스 데이터가 아바타와 연결되었습니다.\n\n";
    		msg += "이제 아바타에게 이렇게 물어보세요!\n\n";
    		msg += "\"이번달 세금 내역은?\"\n";
    		msg += "\"세액 얼마야?\"";
    		
    		String tmplId = "askavatar_003_hometax_tax";
            
            JSONObject button1 = new JSONObject();
            button1.put("name"    			, "에스크아바타 열기");
            button1.put("type"      		, "AL");
            button1.put("scheme_android"    , "kakaoa51a93ebcd6f4145ad28e1fa20cfff50://kakaolink");
            button1.put("scheme_ios"      	, "kakaoa51a93ebcd6f4145ad28e1fa20cfff50://kakaolink");
            
            BizmApiMgnt.apiJoinSendMsg(clph_no, msg, tmplId, button1);
   		}
        else{
    		result.put("RSLT_CD", (String)resData2.get("ERRCODE"));
    		result.put("RSLT_MSG", ApiUtil.getCooconErroMsgStr((String)resData2.get("ERRCODE")));
    		util.setResult(result, "default");
    		
    		idoCon.rollback();
    		idoCon.endTransaction();
    		return;
    	}
    	
    	idoCon.endTransaction();
    	
    	util.setResult(result, "default");
%>