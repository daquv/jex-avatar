<%@page import="jex.json.JSONArray"%>
<%@page import="com.avatar.api.mgnt.CooconApi"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="com.avatar.comm.CommUtil"%>
<%@page import="com.avatar.comm.BizLogUtil"%>
<%@page import="jex.util.StringUtil"%>
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
         * @File Title   : 계좌구분 변경
         * @File Name    : acct_0001_02_u001_act.jsp
         * @File path    : acct
         * @author       : jepark (  )
         * @Description  : 계좌구분 변경
         * @Register Date: 20210527135337
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

        @JexDataInfo(id="acct_0001_02_u001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        JexDataCMO userSession = SessionManager.getSession(request, response);
        String use_intt_id = userSession.getString("USE_INTT_ID");
        String user_id = userSession.getString("CUST_CI");
        String bsnn_no = userSession.getString("USE_INTT_ID");
        
    	String rslt_cd          = "";
    	String rslt_msg         = "";
    	
    	// 계좌정보
    	String bank_cd     	    = StringUtil.null2void(input.getString("BANK_CD"));
    	String fnnc_unq_no      = StringUtil.null2void(input.getString("FNNC_UNQ_NO"));
    	// 변경할 계좌구분
    	String upd_acct_dv		= StringUtil.null2void(input.getString("UPD_ACCT_DV")); 
    	// 인증서 정보
    	String reg_type         = StringUtil.null2void(input.getString("REG_TYPE"));
    	String cert_usag_div    = StringUtil.null2void(input.getString("CERT_USAG_DIV"));
    	String cert_name        = StringUtil.null2void(input.getString("CERT_NAME"));
    	String cert_org         = StringUtil.null2void(input.getString("CERT_ORG"));
    	String cert_date        = StringUtil.null2void(input.getString("CERT_DATE"));
    	String cert_issu_dt     = StringUtil.null2void(input.getString("CERT_ISSU_DT"));
    	String cert_pwd         = StringUtil.null2void(input.getString("CERT_PWD"));
    	String cert_folder      = StringUtil.null2void(input.getString("CERT_FOLDER"));
    	String cert_data        = StringUtil.null2void(input.getString("CERT_DATA"));
    	String cert_reg_type    = "1";
    	
    	String acct_no          = "";
    	String acct_dv          = "";
    	String before_cert_name = "";
    	String ib_type 			= "";
    	String web_id 			= "";
    	
    	BizLogUtil.debug(this," ===== CERT INFO ===== ");
    	BizLogUtil.debug(this,"cert_name        ::  " + cert_name);
    	BizLogUtil.debug(this,"cert_org         ::  " + cert_org);
    	BizLogUtil.debug(this,"cert_date        ::  " + cert_date);
    	BizLogUtil.debug(this,"cert_issu_dt     ::  " + cert_issu_dt);
    	BizLogUtil.debug(this,"cert_folder      ::  " + cert_folder);
    	BizLogUtil.debug(this,"cert_reg_type    ::  " + cert_reg_type);
    	BizLogUtil.debug(this,"INPUT    		::  " + input.toString());
    	BizLogUtil.debug(this," =====================");

    	// 0:인증서 미등록, 1:인증서 등록
    	// 인증서 암호는 REG_TYPE에 상관없이 복호화.
    	if("0".equals(reg_type) || "1".equals(reg_type)){
    		if(!"".equals(StringUtil.null2void(userSession.getString("SCQKEY")))){
    	    	cert_pwd = CommUtil.getDecrypt(userSession.getString("SCQKEY"), cert_pwd);
        	
    		}else if(!"".equals(StringUtil.null2void(userSession.getString("USE_INTT_ID")))){
        		cert_pwd = CommUtil.getDecrypt(userSession.getString("USE_INTT_ID")+CommUtil.getPreScqKey(), cert_pwd);
        	
    		}else{
        		cert_pwd = CommUtil.getDecrypt(CommUtil.getPreScqKey(), cert_pwd);
        	}
		}
    	
		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();
     	
		// 인증서 등록여부 확인
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
            result.put("RSLT_CD", "SOER0000");
            result.put("RSLT_MSG", "데이터(DB) 처리 중 오류가 발생하였습니다. 잠시후 이용하시기 바랍니다.");
            util.setResult(result, "default");
            return;
        }

        
      	// COOCON REG_TYPE=1 : 계정원장(UPDATE) 및 인증서 원장변경(DELETE INSERT 임)
    	// COOCON REG_TYPE=0 : 계정원장(UPDATE) 변경
    	// REG_TYPE=1 예외 : 인증서명이 변경된 경우 DELETE시 예외발생됨.
    	// 쿠콘에 이미 등록된 인증서라 인증서정보는 수정하지 않고 계정정보만 수정함.
    	if("0".equals(reg_type) && !"".equals(StringUtil.null2void(idoOut1.getString("CERT_NM")))
    		&& cert_date.equals(StringUtil.null2void(idoOut1.getString("CERT_DT"))) 
    	){
    		// 쿠콘에 이미 등록된 인증서(아바타 원장에 등록되어 있으면 쿠콘에도 등록되어 있음.) 
    		cert_reg_type = "0";
    	}
      	
		// 등록된 계좌종류 조회
		JexData idoIn2 = util.createIDOData("ACCT_INFM_R022");
		    
		idoIn2.put("USE_INTT_ID", use_intt_id);  
		idoIn2.put("FNNC_UNQ_NO", fnnc_unq_no);
		
	    JexData idoOut2 =  idoCon.execute(idoIn2);
	    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut2)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
            }
         	result.put("RSLT_CD", "SOER0001");
          	result.put("RSLT_MSG", "계좌구분 조회 중 오류가 발생하였습니다.");
          	util.setResult(result, "default");
            return;
        }
	     
		BizLogUtil.debug(this,"BANK_GB    ::  " + idoOut2.getString("BANK_GB"));
		BizLogUtil.debug(this,"ACCT_NO    ::  " + idoOut2.getString("FNNC_INFM_NO"));
		BizLogUtil.debug(this,"ACCT_DV    ::  " + idoOut2.getString("ACCT_DV"));
		BizLogUtil.debug(this,"CERT_NM    ::  " + idoOut2.getString("CERT_NM"));
		
		ib_type = StringUtil.null2void(idoOut2.getString("BANK_GB"));
		acct_no = StringUtil.null2void(idoOut2.getString("FNNC_INFM_NO"));
		acct_dv = StringUtil.null2void(idoOut2.getString("ACCT_DV"), "01");
		before_cert_name = StringUtil.null2void(idoOut2.getString("CERT_NM"));
		web_id = StringUtil.null2void(idoOut2.getString("WEB_ID"));
		
		// 변경하려는 계좌구분과 기존에 설정되어 있는 계좌구분이 같을 경우
		if(upd_acct_dv.equals(acct_dv)){
			result.put("RSLT_CD", "SOER0002");
          	result.put("RSLT_MSG", "이미 등록된 계좌종류입니다.");
          	util.setResult(result, "default");
            return;
		}else if(bank_cd.equals("031") && !web_id.equals("")){
			result.put("RSLT_CD", "SOER0008");
          	result.put("RSLT_MSG", "대구은행의 경우 계좌구분 변경이 불가합니다.");
          	util.setResult(result, "default");
            return;
		}
		// TODO : 어떻게 해야될지 결정해야됨. 
		// 인증서명 조회해서 인증한 인증서명이랑 같지 않을 경우
		/*
		else if(!cert_name.equals(before_cert_name)){
			result.put("RSLT_CD", "SOER0003");
          	result.put("RSLT_MSG", "등록한 인증서명과 동일하지 않습니다.");
          	util.setResult(result, "default");
            return;
		} 
		*/
		
		JSONObject resData     = null;
		//JSONObject resUpdData     = null;
		
		// 0:인증서 미등록, 1:인증서 등록
		if("0".equals(reg_type)){
			resData = CooconApi.getAcctListWithCertInfo(bank_cd, idoOut2.getString("BANK_GB"), cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, upd_acct_dv.substring(1));
			
			rslt_cd  = StringUtil.null2void((String)resData.get("RESULT_CD"));
			rslt_msg = StringUtil.null2void((String)resData.get("RESULT_MG"));
			
			// 응답코드가 없을 경우
			if("".equals(rslt_cd)){
				rslt_cd  = StringUtil.null2void((String)resData.get("ERRCODE"));
				rslt_msg = StringUtil.null2void((String)resData.get("ERRMSG"));
			}
		}else if("1".equals(reg_type)){
			resData = CooconApi.getAcctListWithCertName(use_intt_id, bank_cd, idoOut2.getString("BANK_GB"), cert_name, upd_acct_dv.substring(1));
				
			rslt_cd  = StringUtil.null2void((String)resData.get("ERRCODE"));
			rslt_msg = StringUtil.null2void((String)resData.get("ERRMSG"));
			
			// 응답코드가 없을 경우
			if("".equals(rslt_cd)){
				rslt_cd  = StringUtil.null2void((String)resData.get("RESULT_CD"));
				rslt_msg = StringUtil.null2void((String)resData.get("RESULT_MG"));
			}
		}
		
		BizLogUtil.debug(this,"계좌 응답코드 :: " + rslt_cd);
		BizLogUtil.debug(this,"계좌 응답메시지 :: " + rslt_msg);
			
		boolean acctCertChk = false;
		
		// 계좌목록 조회 성공
		if("00000000".equals(rslt_cd) || "42110000".equals(rslt_cd) || "42120101".equals(rslt_cd) ||
			"42120110".equals(rslt_cd) || "42120011".equals(rslt_cd) || "42120111".equals(rslt_cd) ){
			
			JSONArray resArr = (JSONArray) resData.get("RESP_DATA");
					
			if(resArr == null){
				result.put("RSLT_CD", "SOER0004");
			    result.put("RSLT_MSG", "계좌종류 변경이 불가능합니다.");
			    util.setResult(result, "default");
			    return;
			}
			
			String  comp_acct_no = ""; 
			
			// 계좌 검증
			for(int i = 0 ; i < resArr.size() ; i++){
				JSONObject row = (JSONObject)resArr.get(i);
				comp_acct_no = (String)row.get("ACCOUNT_NO");
				
				// 전계좌 조회한 계좌와 비교, 같은 계좌가 존재하면 검증 완료
				if(acct_no.equals(comp_acct_no)){
					acctCertChk = true;
				}
			}
		}
		
		BizLogUtil.debug(this,"계좌 인증여부   :: " + acctCertChk);
		
		if(!acctCertChk){
			result.put("RSLT_CD", "SOER0005");
		    result.put("RSLT_MSG", "계좌종류 변경이 불가능합니다.");
		    util.setResult(result, "default");
            return;
		}else{
			
			// 트랜젝션 시작
	    	idoCon.beginTransaction();
	     	String bank_typ = "";
			
			// 외환은행일 경우
        	if("005".equals(bank_cd)){
        		bank_typ = "0";
        	}else{
        		bank_typ = "1";
        	}
        	
			// 계좌수정에서 수정하게 되면 인증서 교체 업무에 문제가 있어 계좌 삭제 후 재 등록 처리하는 로직으로 변경
        	// resUpdData = CooconApi.updateAcct(upd_acct_dv, bank_cd, bsnn_no, cert_name, before_cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, "", "", acct_no, "", "", cert_reg_type, "1");
        	
        	// 계좌 삭제
        	JSONObject resDelData = CooconApi.deleteAcct(acct_dv, bank_cd, bsnn_no, acct_no, ib_type, "", bank_typ);
        	
        	// 계좌 삭제 성공
        	if("00000000".equals(resDelData.get("ERRCODE")) || "WSND0007".equals(resDelData.get("ERRCODE"))){
        		// 변경하려는 계좌 구분값으로 계좌 재등록
	            JSONObject resRegJData = CooconApi.insertAcct(upd_acct_dv, bank_cd, bsnn_no, 
	            		cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, 
	            		"", "", acct_no, "", ib_type, "1", bank_typ);
        	
	         	// 계좌재등록 성공
	            if("00000000".equals(resRegJData.get("ERRCODE"))){
	            	// 계좌구분, 인증서 변경
					JexData idoIn5 = util.createIDOData("ACCT_INFM_U021");
					
					idoIn5.put("ACCT_DV", upd_acct_dv);
					idoIn5.put("CERT_NM", cert_name);
					idoIn5.put("USE_INTT_ID", use_intt_id);
					idoIn5.put("FNNC_UNQ_NO", fnnc_unq_no);
					
					JexData idoOut5 =  idoCon.execute(idoIn5);
					
					// 도메인 에러 검증
			        if (DomainUtil.isError(idoOut5)) {
			        	result.put("RSLT_CD", "SOER0006");
			          	result.put("RSLT_MSG", "계좌종류 수정 중 오류가 발생하였습니다.");
			          	util.setResult(result, "default");
				    	idoCon.rollback();
			        	idoCon.endTransaction();
			        	return;
			        }
					
					// 인증서 등록 OR 수정
			        JexData idoIn4 = util.createIDOData("CERT_INFM_C002");
					
					idoIn4.put("USE_INTT_ID", use_intt_id);
					idoIn4.put("CERT_NM", cert_name);
					idoIn4.put("CERT_ORG", cert_org);
					idoIn4.put("CERT_DSNC", "");
					idoIn4.put("CERT_DT", cert_date);
					idoIn4.put("CERT_ISSU_DT", cert_issu_dt);
					idoIn4.put("CERT_STTS", "1");
					idoIn4.put("CERT_USAG_DIV", cert_usag_div);
					idoIn4.put("REGR_ID", user_id);
					idoIn4.put("CORR_ID", user_id);
					
					JexData idoOut4 =  idoCon.execute(idoIn4);
				    
				    // 도메인 에러 검증
				    if (DomainUtil.isError(idoOut4)) {
				    	result.put("RSLT_CD", "SOER0007");
			          	result.put("RSLT_MSG", "인증서 등록/수정 중 오류가 발생하였습니다.");
			          	util.setResult(result, "default");
				    	idoCon.rollback();
			        	idoCon.endTransaction();
			        	return;
				    }
	            }
	         	// 계좌 삭제는 되었지만 재등록에 실패한 경우(사용자 입장에서는 계좌종류를 변경한것인데 오류가 발생하여 삭제가 되어버린 경우)
	            else{
	            	
	            	// 계좌 삭제
	            	JexData idoIn5 = util.createIDOData("ACCT_INFM_U007");
    
	            	idoIn5.put("ACCT_STTS"	, "9");
	            	idoIn5.put("CORR_ID"	, user_id);
	            	idoIn5.put("USE_INTT_ID", use_intt_id);
	            	idoIn5.put("FNNC_UNQ_NO", fnnc_unq_no);
			    
			        JexData idoOut5 =  idoCon.execute(idoIn5);
			    
			        // 도메인 에러 검증
			        if (DomainUtil.isError(idoOut5)) {
				    	result.put("RSLT_CD", "SOER0009");
			          	result.put("RSLT_MSG", "계좌삭제 중 오류가 발생하였습니다.");
			          	util.setResult(result, "default");
				    	idoCon.rollback();
			        	idoCon.endTransaction();
			        	return;
				    }else{
				    	result.put("RSLT_CD", "SOER0010");
			          	result.put("RSLT_MSG", "계좌종류 변경 중 계좌가 삭제가 되었습니다.");
			          	util.setResult(result, "default");
			          	idoCon.commit();
						idoCon.endTransaction();
						return;
				    }
	            }
        	}
        	// 계좌 삭제부터 실패한 경우(변동내용 없음)
        	else{
        		result.put("RSLT_CD", "SOER0011");
	          	result.put("RSLT_MSG", "계좌종류 변경 중 오류가 발생하였습니다.");
	          	util.setResult(result, "default");
		    	idoCon.rollback();
	        	idoCon.endTransaction();
	        	return;
        	}
        	
			idoCon.commit();
			idoCon.endTransaction();
		}
		
		result.put("RSLT_CD", "0000");
	    result.put("RSLT_MSG", "정상처리되었습니다.");
        util.setResult(result, "default");

%>