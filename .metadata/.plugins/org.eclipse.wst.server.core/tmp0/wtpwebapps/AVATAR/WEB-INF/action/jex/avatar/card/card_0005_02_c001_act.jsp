<%@page import="com.avatar.api.mgnt.BizmApiMgnt"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.comm.CommUtil"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="jex.json.JSONArray"%>
<%@page import="com.avatar.comm.SvcDateUtil"%>
<%@page import="com.avatar.api.mgnt.CooconApi"%>
<%@page import="com.avatar.comm.BizLogUtil"%>
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
         * @File Title   : 기업신용카드 등록
         * @File Name    : card_0005_02_c001_act.jsp
         * @File path    : card
         * @author       : kth91 (  )
         * @Description  : 기업신용카드 등록
         * @Register Date: 20200128155305
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

        @JexDataInfo(id="card_0005_02_c001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        JexDataCMO UserSession = SessionManager.getSession(request, response);
        String use_intt_id 	= (String)UserSession.get("USE_INTT_ID");
        String user_id 		= (String)UserSession.get("CUST_CI");
        String bsnn_no 		= (String)UserSession.get("USE_INTT_ID");
    	String scqkey 		= (String)UserSession.get("SCQKEY");
        
        String bank_cd 		= StringUtil.null2void(input.getString("BANK_CD"));
    	String bank_nm 		= StringUtil.null2void(input.getString("BANK_NM"));
    	String web_id 		= StringUtil.null2void(input.getString("WEB_ID"));
    	String web_pwd 		= StringUtil.null2void(input.getString("WEB_PWD"));
    	String card_no 		= StringUtil.null2void(input.getString("CARD_NO"));
    	
    	// 비밀번호 복호화
    	web_pwd = CommUtil.getDecrypt(scqkey, web_pwd);
    	
		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
		
    	// 신용카드 등록여부 조회
    	JexData idoIn3 = util.createIDOData("CARD_INFM_R004");
        
        idoIn3.put("USE_INTT_ID", use_intt_id);
        idoIn3.put("CARD_NO", card_no);
        
        JexData idoOut3 =  idoCon.execute(idoIn3);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut3)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut3));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut3));
            }
            throw new JexWebBIZException(idoOut3);
        }
        
    	// 신용카드 상태값이 '1','8' 이면 등록되어 있는 카드
     	if( "1".equals(idoOut3.getString("CARD_STTS")) || "8".equals(idoOut3.getString("CARD_STTS"))){
     		result.put("RSLT_CD","9999");
     		result.put("RSLT_MSG","이미 등록되어 있는 카드입니다.");
     		util.setResult(result, "default");
     		return;
     	}
    	
     	// 신용카드 최초등록여부 조회
    	JexData idoIn5 = util.createIDOData("CARD_INFM_R005");
        
    	idoIn5.put("USE_INTT_ID", use_intt_id);
        
        JexData idoOut5 =  idoCon.execute(idoIn5);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut5)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut5));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut5));
            }
            throw new JexWebBIZException(idoOut5);
        }
        
     	if( "0".equals(idoOut5.getString("CARD_CNT"))){
     		result.put("FST_REG_YN","Y");
     	}else{
     		result.put("FST_REG_YN","N");
     	}
     	
		try{
	
			// bc 카드일경우(기업,대구, 부산, 경남, SC)
        	if("060".equals(bank_cd) || "061".equals(bank_cd) || "062".equals(bank_cd) || 
				"063".equals(bank_cd) || "064".equals(bank_cd)){
                bank_cd = "006";
            }
            
            // 법인카드 결제일 조회 - 실시간
            JSONObject resData = CooconApi.getCorpCardPaymentDay(bank_cd, web_id, web_pwd, card_no);
			
         	// 외부이력테이블에 응답 결과 이력 입력
//             ExtnTrnsHis.insert(use_intt_id, "C", "0327", resData.getString("RESULT_CD"), resData.getString("RESULT_MG"));
         
			String date_payment = "";
			
			if("00000000".equals(resData.get("RESULT_CD"))){
				JSONArray jsonArr = (JSONArray) resData.get("RESP_DATA");
            	JSONObject resDataTemp = new JSONObject();
            	String tempCardNo = card_no;
            	
            	boolean cardNoChk = false;
            	
            	for(int resInt = 0 ; resInt < jsonArr.size(); resInt++ ){
                    resDataTemp = (JSONObject)jsonArr.get(resInt);
                    
                    tempCardNo = CommUtil.getNonStrCardNo(card_no, (String)resDataTemp.get("CARD_NO_TYPE"));
                    
                    // 결제일 가져오기
                    if(tempCardNo.equals(resDataTemp.get("CARD_NO"))){
                        date_payment = (String)resDataTemp.get("DATE_PAYMENT");
                        cardNoChk = true;
                        break;
                    }
                }
            	
            	if(!cardNoChk){
                    result.put("RSLT_CD", "9999");
                    result.put("RSLT_MSG", "일치하는 카드번호가 없습니다.");
                    util.setResult(result, "default");
            		return;
                }
            	
            	// 결제일이 한자리인 경우
    			if(date_payment.length() == 1){
    	            date_payment = "0" + date_payment;
    	        }
            	
			}else{
				result.put("RSLT_CD", resData.getString("RESULT_CD"));
            	result.put("RSLT_MSG", resData.getString("RESULT_MG"));
                util.setResult(result, "default");
        		return;
			}
			
			int nowDD = SvcDateUtil.getDay();	// 현재일자
			int PayDD = Integer.parseInt(date_payment)-2;	// 결제일 -2
			String clm_lst_ym = "";
			if(nowDD <= PayDD){
				clm_lst_ym = SvcDateUtil.getInstance().getDate(-1,'M').substring(0,6);
			}else{
				clm_lst_ym = SvcDateUtil.getInstance().getDate().substring(0,6);
			}
			
			idoCon.beginTransaction();
			
			// 최초등록
			if(idoOut3.getString("CARD_STTS") == null){
				// 기업 신용카드 등록
				JexData idoIn2 = util.createIDOData("CARD_INFM_C001");
			    
		        idoIn2.put("USE_INTT_ID", use_intt_id);
		        idoIn2.put("BANK_CD", "30000" + bank_cd);
		        idoIn2.put("CARD_NO", card_no);
		        idoIn2.put("CARD_RPSN_INFM", card_no.substring(0, 4)+"-"+card_no.substring(4, 8)+"-****-"+card_no.substring(12));
		        idoIn2.put("BIZ_NO", bsnn_no);
		        idoIn2.put("CARD_STTS", "0");
		        idoIn2.put("WEB_ID", web_id);
		        idoIn2.put("WEB_PWD", web_pwd);
		        idoIn2.put("SETL_DT", date_payment);
		        idoIn2.put("CLM_LST_YM", clm_lst_ym);
		        idoIn2.put("REGR_ID", user_id);
		        idoIn2.put("CORR_ID", user_id);
// 		        idoIn2.put("LIM_NOTI_AMT", "1000000");	// 100만원 기본값
		        
		        JexData idoOut2 =  idoCon.execute(idoIn2);
		    
		        // 도메인 에러 검증
		        if (DomainUtil.isError(idoOut2)) {
		            if (util.getLogger().isDebug())
		            {
		                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
		                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
		            }
		            idoCon.rollback();
		            result.put("RSLT_CD", "9999");
                    result.put("RSLT_MSG", "신용카드 등록이 실패하였습니다.");
                    util.setResult(result, "default");
            		return;
		        }
			}
			// 재등록
			else if("9".equals(idoOut3.getString("CARD_STTS"))) {
				// 신용카드 재등록
				JexData idoIn1 = util.createIDOData("CARD_INFM_U003");
			    
		        idoIn1.put("CARD_STTS","8");
		        idoIn1.put("WEB_ID", web_id);
		        idoIn1.put("WEB_PWD",web_pwd);
		        idoIn1.put("SETL_DT", date_payment);
		        idoIn1.put("CLM_LST_YM", clm_lst_ym);
		        idoIn1.put("CORR_ID", user_id);
		        idoIn1.put("USE_INTT_ID", use_intt_id);
		        idoIn1.put("CARD_NO", card_no);
		    
		        JexData idoOut1 =  idoCon.execute(idoIn1);
		    
		        // 도메인 에러 검증
		        if (DomainUtil.isError(idoOut1)) {
		            if (util.getLogger().isDebug())
		            {
		                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
		                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
		            }
		            idoCon.rollback();
		            result.put("RSLT_CD", "9999");
                    result.put("RSLT_MSG", "신용카드 재등록에 실패하였습니다.");
                    util.setResult(result, "default");
            		return;
		        }
			}

			try{
				// bc 카드일경우(기업, 대구, 부산, 경남, SC)
				if("060".equals(bank_cd) || "061".equals(bank_cd) || "062".equals(bank_cd) || 
					"063".equals(bank_cd) || "064".equals(bank_cd)){
					bank_cd = "006";
				}

				// 법인카드정보등록
				resData = CooconApi.insertCorpCard(bank_cd, bsnn_no, web_id, web_pwd, card_no, date_payment);

				// 외부이력테이블에 응답 결과 이력 입력
// 	            ExtnTrnsHis.insert(use_intt_id, "C", "0100_003_I", resData.getString("ERRCODE"), resData.getString("ERRMSG"));
	         
				if("00000000".equals(resData.get("ERRCODE"))){// 성공
					idoCon.commit();
					// 카드등록여부 세션값 변경
// 	            	UserSession.put("CARD_REG_YN", "Y");
	            	result.put("RSLT_CD", (String)resData.get("ERRCODE"));
                    result.put("RSLT_MSG", (String)resData.get("ERRMSG"));
                    
                 	// 고객데이터수집기준정보 조회
	 				JexData idoIn8 = util.createIDOData("CUST_RT_BACH_INFM_R002");
	            	
	 				idoIn8.put("USE_INTT_ID", use_intt_id);
	 				idoIn8.put("EVDC_GB", "03");
	 				
	                JexData idoOut8 =  idoCon.execute(idoIn8);
	                
	                if(DomainUtil.isError(idoOut8)) {
	 					if (util.getLogger().isDebug())
	 		            {
	 		                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut8));
	 		                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut8));
	 		            }
	 		        }
	                
	                String pay_yn = StringUtil.null2void(idoOut8.getString("PAY_YN"),"N");
					
	                // 아바타 유료회원 신청/해지(법인카드 : 003)
	                JSONObject resJData = CooconApi.insertMembership("003", use_intt_id, pay_yn);
	                
	                //(00000000:정상, WSND0004:이미 등록된 내용이 있습니다.)
	                if("00000000".equals(resJData.get("ERRCODE")) || "WSND0004".equals(resJData.get("ERRCODE"))){
	                	BizLogUtil.debug(this, "아바타 법인카드 유료회원 신청/해지 정상처리되었습니다. (변경데이터 : "+pay_yn+")");        	
	                }else{
	                	BizLogUtil.debug(this, "아바타 법인카드 유료회원 신청/해지 중 오류가 발생하였습니다. (변경데이터 : "+pay_yn+")");
	                }
	                
	                // 고객핸드폰번호 조회
					JexData idoIn9 = util.createIDOData("CUST_LDGR_R035");
	            	
					idoIn9.put("USE_INTT_ID", use_intt_id);
	 				
	                JexData idoOut9 =  idoCon.execute(idoIn9);
	                
	                if(DomainUtil.isError(idoOut9)) {
	 					if (util.getLogger().isDebug())
	 		            {
	 		                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut9));
	 		                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut9));
	 		            }
	 		        }
	                
	                String clph_no = StringUtil.null2void(idoOut9.getString("CLPH_NO"));
	                
					// 카드사 연동 알림톡 전송
					String msg = "";
					msg += "카드사 데이터가 아바타와 연결되었습니다.\n\n";
					msg += "이제 아바타에게 이렇게 물어보세요!\n\n";
					msg += "\"법인카드 사용내역은?\"\n";
					msg += "\"00카드 한도는?\"";
							
					String tmplId = "askavatar_003_card_renew_2";
			        
			        JSONObject button1 = new JSONObject();
			        button1.put("name"    			, "에스크아바타 열기");
			        button1.put("type"      		, "AL");
			        button1.put("scheme_android"    , "kakaoa51a93ebcd6f4145ad28e1fa20cfff50://kakaolink");
			        button1.put("scheme_ios"      	, "kakaoa51a93ebcd6f4145ad28e1fa20cfff50://kakaolink");
			        
			        BizmApiMgnt.apiJoinSendMsg(clph_no, msg, tmplId, button1);
	                
				}else{
					idoCon.rollback();
					result.put("RSLT_CD", (String)resData.get("ERRCODE"));
                    result.put("RSLT_MSG", (String)resData.get("ERRMSG"));
				}
			}catch(Exception e2){
				idoCon.rollback();
				result.put("RSLT_CD", "9999");
                result.put("RSLT_MSG", "카드등록API 호출 오류가 발생하였습니다.");
			}
			idoCon.endTransaction();
		
		}catch(Exception e){
			BizLogUtil.debug(this,"Exception :: "+e.getMessage());
			result.put("RSLT_CD", "9999");
            result.put("RSLT_MSG", e.getMessage());
		}
		
		/*
		IDODynamic dynamic = new IDODynamic();
    	dynamic.addSQL("\nAND NOTI_GB IN ('22','23','20','27') ");
    	
		//  브리핑 푸시전송 여부 수정
        JexData idoIn4 = util.createIDOData("BRIF_SUBS_INFM_U001");
   
        idoIn4.put("USE_YN", "Y");
        idoIn4.put("MOD_USER_ID", user_id);
        idoIn4.put("PTL_ID", ptl_id);
        idoIn4.put("USE_INTT_ID", use_intt_id);
        idoIn4.put("DYNAMIC_0", dynamic);
    
        JexData idoOut4 =  idoCon.execute(idoIn4);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut4)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut4));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut4));
            }
            throw new JexWebBIZException(idoOut4);
        }
     	*/
        util.setResult(result, "default");

%>