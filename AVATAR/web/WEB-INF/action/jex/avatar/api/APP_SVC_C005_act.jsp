<%@page import="com.avatar.api.mgnt.BizmApiMgnt"%>
<%@page import="com.avatar.service.CooconRealTimeService"%>
<%@page import="com.avatar.api.mgnt.CooconApi"%>
<%@page import="com.avatar.comm.BizLogUtil"%>
<%@page import="com.avatar.comm.CommUtil"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.json.JSONArray"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="jex.exception.JexBIZException"%>
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
         * @File Title   : 인증서계좌등록
         * @File Name    : APP_SVC_C005_act.jsp
         * @File path    : api
         * @author       : kth91 (  )
         * @Description  : 인증서계좌등록
         * @Register Date: 20200117145513
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

        @JexDataInfo(id="APP_SVC_C005", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
     	// 세션값 체크
   		JexDataCMO usersession = null;
       	try{
       		usersession   = SessionManager.getInstance().getUserSession(request, response);  	
       		usersession.put("REC_ACCT_LIST", null); // 등록 계좌 초기화
       	}catch(Throwable e){
       		throw new JexBIZException("9999", "Session DisConnected.");
       	}
       	
       	JSONObject rtnData    = null;
		JSONArray  mApiTrnArr = new JSONArray();
		JSONArray  rtnAcctArr = new JSONArray();		// 계좌결과리스트
		JSONArray  rtnSuccAcctArr = new JSONArray();	// 정상등록계좌리스트
		JSONObject ArrData    = null;
       	
		String cert_name	= StringUtil.null2void(input.getString("CERT_NAME")); 	// 인증서이름
		String cert_org		= StringUtil.null2void(input.getString("CERT_ORG")); 	// 인증서발급기관
		String cert_date	= StringUtil.null2void(input.getString("CERT_DATE")); 	// 인증서만료일자
		String cert_pwd		= StringUtil.null2void(input.getString("CERT_PWD"));	// 인증서비밀번호
		String cert_folder	= StringUtil.null2void(input.getString("CERT_FOLDER")); // 인증서경로명
		String cert_data	= StringUtil.null2void(input.getString("CERT_DATA")); 	// 인증서정보
		mApiTrnArr 			= JSONObject.fromArray(input.get("ACCOUNT_LIST").toString());	// 계좌리스트
		
		if(!"".equals(StringUtil.null2void(usersession.getString("SCQKEY")))){
			cert_pwd = CommUtil.getDecrypt(usersession.getString("SCQKEY"), cert_pwd);	
		}else if(!"".equals(StringUtil.null2void(usersession.getString("USE_INTT_ID")))){
    		cert_pwd = CommUtil.getDecrypt(usersession.getString("USE_INTT_ID")+CommUtil.getPreScqKey(), cert_pwd);
    	}else{
    		cert_pwd = CommUtil.getDecrypt(CommUtil.getPreScqKey(), cert_pwd);
    	}
		
		BizLogUtil.debug(this, "mApiTrnArr size() :: " +mApiTrnArr.size());
		BizLogUtil.debug(this, "cert_name :: " +cert_name);
		BizLogUtil.debug(this, "cert_date :: " +cert_date);
		
		// 'I' insert, 'U' updqte, 'N' sql실행안함
		String certLdgrSql = "";
		try{
			
			// IDO Connection
	        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
	        
	    	// 인증서 등록여부 확인
	        JexData idoIn1 = util.createIDOData("CERT_INFM_R002");
	    
	        idoIn1.put("USE_INTT_ID", usersession.getString("USE_INTT_ID"));  
	        idoIn1.put("CERT_NM", cert_name);
	        
	        JexData idoOut1 =  idoCon.execute(idoIn1);
	    
	        // 도메인 에러 검증
	        if (DomainUtil.isError(idoOut1)) {
	            if (util.getLogger().isDebug())
	            {
	                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
	                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
	            }
	            result.put("RSLT_CD", "SOER3007");
	            result.put("RSLT_MSG", "데이터(DB) 처리 중 오류가 발생하였습니다. 잠시후 이용하시기 바랍니다.");
	            result.put("RSLT_PROC_GB", "0");
	        }else{
				
	        	// 인증서 정보 없음
				if(!("").equals(StringUtil.null2void(idoOut1.getString("CERT_DT_STTS"),""))){
	    			// 등록된 인증서
					if("1".equals(StringUtil.null2void(idoOut1.getString("CERT_STTS")))){
						certLdgrSql = "N";
					}
					// 해지된 인증서
					else if("9".equals(StringUtil.null2void(idoOut1.getString("CERT_STTS")))){
						certLdgrSql = "U";
					}
				}else{ 
					// 인증서 최초등록
					certLdgrSql = "I";
				}
	        
				BizLogUtil.debug(this, "CERT_INFM_R002 CERT_DT_STTS :: "+idoOut1.getString("CERT_DT_STTS"));
				BizLogUtil.debug(this, "인증서 상태 certLdgrSql :: "+certLdgrSql);

				
				// 계좌최초등록여부
				JexData idoIn7 = util.createIDOData("ACCT_INFM_R004");
		    
				idoIn7.put("USE_INTT_ID", usersession.getString("USE_INTT_ID"));  
		       
		        JexData idoOut7 =  idoCon.execute(idoIn7);
		    
		        // 도메인 에러 검증
		        if (DomainUtil.isError(idoOut7)) {
		        	if (util.getLogger().isDebug())
		            {
		                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut7));
		                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut7));
		            }
		            result.put("RSLT_CD", "SOER3007");
		            result.put("RSLT_MSG", "데이터(DB) 처리 중 오류가 발생하였습니다. 잠시후 이용하시기 바랍니다.");
		            result.put("RSLT_PROC_GB", "0");
		        }else{
		        	if(Integer.parseInt(idoOut7.getString("ACCT_CNT")) > 0){
		        		// 최초등록아님
		        		result.put("FST_REG_YN", "N");
		        	}else{
		        		// 최초등록
		        		result.put("FST_REG_YN", "Y");
		        	}
		        }

	            
				// 받은 계좌리스트 수
				int totCnt = mApiTrnArr.size();
				// 정상 등록된 계좌 수
				int reqcnt = 0;
				
				// 계좌리스트
				for(int i = 0; i< mApiTrnArr.size(); i++){
				
					// IDO Connection
				    JexConnection idoConAcct = JexConnectionManager.createIDOConnection();     
				    idoConAcct.beginTransaction();
				
				    JSONObject reqDatatemp = new JSONObject();
					reqDatatemp = (JSONObject)mApiTrnArr.get(i);
				
					String acct_dv	= StringUtil.null2void((String)reqDatatemp.get("ACCT_DV"), "01");  	// 계좌구분(01:수시입출금, 02:예적금, 03:대출금)
					String orgcd	= StringUtil.null2void((String)reqDatatemp.get("ORGCD"));  			// 기관코드
					String ssmcd	= StringUtil.null2void((String)reqDatatemp.get("SSMCD"));  			// 뱅킹구분
					String cert_usag_div = StringUtil.null2void((String)reqDatatemp.get("SSMCD"));
					String acct_usag_div = ssmcd;
					
					// 개인 일때
					if(ssmcd.equals("0")){
						ssmcd = CommUtil.getCooconIbType(orgcd, "1");	
					}
					// 기업 일때
					else if(ssmcd.equals("1")){
						ssmcd = CommUtil.getCooconIbType(orgcd, "2");	
					}
					else{
						ssmcd = CommUtil.getCooconIbType(orgcd, "3");
					}
		
					// 표시계좌번호 조회
				    JexData idoIn0 = util.createIDOData("DSDL_ITEM_R001");
			    
			        idoIn0.put("FNNC_INFM_NO", (String)reqDatatemp.get("ACCOUNT_NO"));  
			        idoIn0.put("BANK_CD", (String)reqDatatemp.get("ORGCD"));  
			        
			        JexData idoOut0 =  idoCon.execute(idoIn0);
			    
			        // 도메인 에러 검증
			        if (DomainUtil.isError(idoOut0)) {
			            if (util.getLogger().isDebug())
			            {
			                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut0));
			                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut0));
			            }
			        }
					        
			     	// 계좌등록결과
					JSONObject rtnAcctObj = new JSONObject();
					rtnAcctObj.put("BANK_NM", (String)reqDatatemp.get("ORGNM"));				// 은행명
					rtnAcctObj.put("ACCT_NICK_NM", (String)reqDatatemp.get("ACCOUNT_CLASS"));	// 예금종류
					rtnAcctObj.put("FNNC_RPSN_INFM", idoOut0.getString("FNNC_RPSN_INFM"));		// 금융표시정보
					rtnAcctObj.put("REG_YN", "N");												// 등록성공여부
					rtnAcctObj.put("ACCT_USAG_DIV", acct_usag_div);								// 계좌용도구분
					rtnAcctObj.put("ACCT_DV", acct_dv);											// 계좌구분
					String rsltFnncUnqNo = insertAcct(util, usersession, idoConAcct, orgcd, ssmcd, acct_usag_div, cert_name, reqDatatemp);
					
					if(!"".equals(rsltFnncUnqNo)){
						BizLogUtil.debug(this, "certLdgrSql :: " +certLdgrSql);
						BizLogUtil.debug(this, "cert_name :: " +cert_name);
						BizLogUtil.debug(this, "cert_org :: " +cert_org);
						BizLogUtil.debug(this, "cert_date :: " +cert_date);
						BizLogUtil.debug(this, "ssmcd length:: " +ssmcd.length());
						BizLogUtil.debug(this, "ssmcd length:: " +ssmcd);
						
						boolean certSqlChk = true;
						
					    if("I".equals(certLdgrSql)){
					
					    	// 인증서 등록
					        JexData idoIn2 = util.createIDOData("CERT_INFM_C001");
					    
					        idoIn2.put("USE_INTT_ID", usersession.getString("USE_INTT_ID"));  
					        idoIn2.put("CERT_NM", cert_name);  
					        idoIn2.put("CERT_ORG", cert_org);  
					        idoIn2.put("CERT_DSNC", ssmcd);
					        idoIn2.put("CERT_DT", cert_date);
					        idoIn2.put("CERT_ISSU_DT", "");
					        idoIn2.put("CERT_STTS", "1");
					        idoIn2.put("CERT_PWD", "");  
					        idoIn2.put("CERT_PATH", "");  
					        idoIn2.put("CERT_DATA", "");  
					        idoIn2.put("CERT_KEY", "");  
					        idoIn2.put("CERT_USAG_DIV", cert_usag_div);	// 0:개인, 1:기업  
					        idoIn2.put("REGR_ID", usersession.getString("CUST_CI"));  
					        
					        JexData idoOut2 =  idoCon.execute(idoIn2);
					    
					        // 도메인 에러 검증
					        if (DomainUtil.isError(idoOut2)) {
					            if (util.getLogger().isDebug())
					            {
					                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
					                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
					            }
					            certSqlChk = false;
					            idoConAcct.rollback();
					        }
					        
					     	// 인증서 등록후 변경
						    certLdgrSql = "N";
		                  }else if("U".equals(certLdgrSql) || "N".equals(certLdgrSql)){
							// 인증서 상태 변경
							JexData idoIn3 = util.createIDOData("CERT_INFM_U001");
							
							idoIn3.put("CERT_STTS", "1"); 
							idoIn3.put("CERT_USAG_DIV", cert_usag_div); 
							idoIn3.put("CERT_DT", cert_date);
							idoIn3.put("CORR_ID", usersession.getString("CUST_CI"));
							idoIn3.put("USE_INTT_ID", usersession.getString("USE_INTT_ID"));
							idoIn3.put("CERT_NM", cert_name);
		    				
							JexData idoOut3 =  idoCon.execute(idoIn3);
		    				
							// 도메인 에러 검증
					        if (DomainUtil.isError(idoOut3)) {
					            if (util.getLogger().isDebug())
					            {
					                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut3));
					                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut3));
					            }
					            certSqlChk = false;
		    					idoConAcct.rollback();
					        }
					    
		    				// 인증서 등록후 변경
						    certLdgrSql = "N";
		                }
						
					    BizLogUtil.debug(this, "certSqlChk :: "+certSqlChk);
					    
					    // 인증서원장 등록 후
					    if(certSqlChk){
					    	// 비밀번호 복호화
					    	String acct_wpd_dec = StringUtil.null2void((String)reqDatatemp.get("ACCT_WPD"));
					    	String web_pwd_dec = StringUtil.null2void((String)reqDatatemp.get("WEB_PWD"));
					    	
					    	// 계좌비밀번호가 있을 경우에만 복호화 시도
					    	if(!acct_wpd_dec.equals("")){
					    		// 계좌비밀번호 복호화
					    		if(!"".equals(StringUtil.null2void(usersession.getString("SCQKEY")))){
					    			acct_wpd_dec = CommUtil.getDecrypt(usersession.getString("SCQKEY"), acct_wpd_dec);	
					    		}else if(!"".equals(StringUtil.null2void(usersession.getString("USE_INTT_ID")))){
					    			acct_wpd_dec = CommUtil.getDecrypt(usersession.getString("USE_INTT_ID")+CommUtil.getPreScqKey(), acct_wpd_dec);
					    		}else{
					    			acct_wpd_dec = CommUtil.getDecrypt(CommUtil.getPreScqKey(), acct_wpd_dec);
					    		}
					    	}
					    	
					    	// 웹비밀번호가 있을 경우에만 복호화 시도
					    	if(!web_pwd_dec.equals("")){
					    		// 웹비밀번호 복호화
					    		if(!"".equals(StringUtil.null2void(usersession.getString("SCQKEY")))){
					    			web_pwd_dec = CommUtil.getDecrypt(usersession.getString("SCQKEY"), web_pwd_dec);	
					    		}else if(!"".equals(StringUtil.null2void(usersession.getString("USE_INTT_ID")))){
					    			web_pwd_dec = CommUtil.getDecrypt(usersession.getString("USE_INTT_ID")+CommUtil.getPreScqKey(), web_pwd_dec);
					    		}else{
					    			web_pwd_dec = CommUtil.getDecrypt(CommUtil.getPreScqKey(), web_pwd_dec);
					    		}
					    	}
							
					    	// 계좌 등록
				            JSONObject resJData = CooconApi.insertAcct(acct_dv, orgcd, usersession.getString("USE_INTT_ID"), 
				            		cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, 
				            		StringUtil.null2void(reqDatatemp.getString("WEB_ID")), StringUtil.null2void(web_pwd_dec), 
				            		reqDatatemp.getString("ACCOUNT_NO"), StringUtil.null2void(acct_wpd_dec), 
				            		ssmcd, "1", "1");
				            
				         	// 외부이력테이블에 응답 결과 이력 입력
// 				            ExtnTrnsHis.insert(usersession.getString("USE_INTT_ID"), "C", "0100_001_I", resJData.getString("ERRCODE"), resJData.getString("ERRMSG"));
				            if("00000000".equals(resJData.get("ERRCODE"))){// 성공
				            	// 계좌 등록여부 세션 저장
// 				            	usersession.put("ACCT_REG_YN", "Y");
				            	rtnAcctObj.put("REG_YN", "Y");	// 계좌등록성공
				        		reqcnt ++;
				            	
				            	if(acct_dv.equals("01")){
				            		// 등록 성공한 계좌 목록
					        		JSONObject rtnSuccAcctObj = new JSONObject();
					        		rtnSuccAcctObj.put("USE_INTT_ID", usersession.getString("USE_INTT_ID")); 
					        		rtnSuccAcctObj.put("BSNN_NO", usersession.getString("USE_INTT_ID")); 
					        		rtnSuccAcctObj.put("BANK_CD", (String)reqDatatemp.get("ORGCD")); 
					        		rtnSuccAcctObj.put("CERT_DSNC", ssmcd); 
					        		rtnSuccAcctObj.put("FNNC_INFM_NO", idoOut0.getString("FNNC_RPSN_INFM")); 
					        		rtnSuccAcctObj.put("FNNC_UNQ_NO", rsltFnncUnqNo); 
					        		rtnSuccAcctObj.put("CERT_NM", cert_name); 
					        		rtnSuccAcctObj.put("WEB_ID", (String)reqDatatemp.get("WEB_ID")); 
					        		rtnSuccAcctObj.put("WEB_PWD", web_pwd_dec); 
					        		rtnSuccAcctObj.put("BANKING_TYPE", acct_usag_div);
					            	rtnSuccAcctArr.add(rtnSuccAcctObj);
				            	}
				            	
				            	idoConAcct.commit();
				            }else{
				            	idoConAcct.rollback();
				            }
					    }else{
					    	result.put("RSLT_CD" , "SOER1000");
							result.put("RSLT_MSG" , "처리중오류가발생하였습니다.잠시후이용하시기바랍니다.");
							result.put("RSLT_PROC_GB" , "");
					    }
					}
					rtnAcctArr.add(rtnAcctObj);
					idoConAcct.endTransaction();
				}
				
				if(reqcnt == totCnt){
					result.put("RSLT_CD" , "0000");
					result.put("RSLT_MSG" , "정상처리 되었습니다.");
					result.put("RSLT_PROC_GB" , "0");
				}else if(reqcnt == 0){
					result.put("RSLT_CD" , "SOER5000");
					result.put("RSLT_MSG" , "등록된 계좌가 없습니다.");
					result.put("RSLT_PROC_GB" , "");
				}else{
					result.put("RSLT_CD" , "SOER5001");
					result.put("RSLT_MSG", totCnt+"건 중 "+reqcnt+"건 정상등록되었습니다.");
					result.put("RSLT_PROC_GB" , "");
				}
				
				// 정상등록된 계좌가 있을 경우 
				if(reqcnt != 0){
					// 고객데이터수집기준정보 조회
	 				JexData idoIn8 = util.createIDOData("CUST_RT_BACH_INFM_R002");
	            	
	 				idoIn8.put("USE_INTT_ID", usersession.getString("USE_INTT_ID"));
	 				idoIn8.put("EVDC_GB", "01");
	 				
	                JexData idoOut8 =  idoCon.execute(idoIn8);
	                
	                if(DomainUtil.isError(idoOut8)) {
	 					if (util.getLogger().isDebug())
	 		            {
	 		                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut8));
	 		                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut8));
	 		            }
	 		        }
	                
	                String pay_yn = StringUtil.null2void(idoOut8.getString("PAY_YN"),"N");
					
	                // 아바타 유료회원 신청/해지(계좌 : 001)
	                JSONObject resJData = CooconApi.insertMembership("001", usersession.getString("USE_INTT_ID"), pay_yn);
	                
	                //(00000000:정상, WSND0004:이미 등록된 내용이 있습니다.)
	                if("00000000".equals(resJData.get("ERRCODE")) || "WSND0004".equals(resJData.get("ERRCODE"))){
	                	BizLogUtil.debug(this, "아바타 계좌 유료회원 신청/해지 정상처리되었습니다. (변경데이터 : "+pay_yn+")");        	
	                }else{
	                	BizLogUtil.debug(this, "아바타 계좌 유료회원 신청/해지 중 오류가 발생하였습니다. (변경데이터 : "+pay_yn+")");
	                }
	                
					CooconRealTimeService crs = new CooconRealTimeService();
					// 실시간 계좌거래내역 조회
					crs.searchAcctRealTime(rtnSuccAcctArr, pay_yn);
					
					// 고객핸드폰번호 조회
					JexData idoIn9 = util.createIDOData("CUST_LDGR_R035");
	            	
	 				idoIn9.put("USE_INTT_ID", usersession.getString("USE_INTT_ID"));
	 				
	                JexData idoOut9 =  idoCon.execute(idoIn9);
	                
	                if(DomainUtil.isError(idoOut9)) {
	 					if (util.getLogger().isDebug())
	 		            {
	 		                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut9));
	 		                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut9));
	 		            }
	 		        }
	                
	                String clph_no = StringUtil.null2void(idoOut9.getString("CLPH_NO"));
	                
					// 은행 연동 알림톡 전송
					String msg = "";
					msg += reqcnt+"개의 은행 데이터가 아바타와 연결되었습니다.\n\n";
					msg += "이제 아바타에게 이렇게 물어보세요!\n\n";
					msg += "\"기업은행 통장잔고는?\"\n";
					msg += "\"신한은행 입출금 내역은?\"\n";
					msg += "\"현재 자금현황은?\"";
					
					String tmplId = "askavatar_003_bank_renew";
			        
			        JSONObject button1 = new JSONObject();
			        button1.put("name"    			, "에스크아바타 열기");
			        button1.put("type"      		, "AL");
			        button1.put("scheme_android"    , "kakaoa51a93ebcd6f4145ad28e1fa20cfff50://kakaolink");
			        button1.put("scheme_ios"      	, "kakaoa51a93ebcd6f4145ad28e1fa20cfff50://kakaolink");
			        
			        BizmApiMgnt.apiJoinSendMsg(clph_no, msg, tmplId, button1);
				}
			}
		}catch(Exception e){
			BizLogUtil.debug(this, "Exception e ::: " + e.getMessage() );
			result.put("RSLT_CD" , "SOER1000");
			result.put("RSLT_MSG" , "처리중오류가발생하였습니다.잠시후이용하시기바랍니다.");
			result.put("RSLT_PROC_GB" , "");
		}
		
		usersession.put("REC_ACCT_LIST", rtnAcctArr.toString());
		result.put("ACCT_LIST", rtnAcctArr);
		util.setResult(result, "default");

%>  
<%!

public String insertAcct(WebCommonUtil util, JexDataCMO usersession, JexConnection idoCon, String orgcd, String bank_gb, String acct_usag_div, String cert_name, JSONObject JsonData)
{
	String result = "";
		
	String bank_cd = orgcd;
	String acct_dv = StringUtil.null2void((String)JsonData.get("ACCT_DV"), "01");	// 계좌구분(01:수시입출금, 02:예적금, 03:대출금)
	String new_dt = StringUtil.null2void((String)JsonData.get("NEW_DT"));			// 신규일자
	String expi_dt = StringUtil.null2void((String)JsonData.get("EXPI_DT"));			// 만기일자
	String cont_rt = StringUtil.null2void((String)JsonData.get("CONT_RT"),"0");		// 이자율
	String agmt_amt = StringUtil.null2void((String)JsonData.get("AGMT_AMT"),"0");	// 대출한도/가입금액/약정금액
	String pyat_amt = StringUtil.null2void((String)JsonData.get("PYAT_AMT"),"0");	// 월납입금
	String pyat_dt = StringUtil.null2void((String)JsonData.get("PYAT_DT"));			// 월납입일
	String int_payt_dt = StringUtil.null2void((String)JsonData.get("INT_PAYT_DT"));	// 이자납입예정일자
	String dpsv_dv = StringUtil.null2void((String)JsonData.get("DPSV_DV"));			// 예적금구분(1:예금, 2:적금)
	String fnnc_infm_no = StringUtil.null2void((String)JsonData.get("ACCOUNT_NO"));	// 계좌번호
	String acct_pwd = StringUtil.null2void((String)JsonData.get("ACCT_WPD"));		// 계좌비밀번호
	String web_pwd = StringUtil.null2void((String)JsonData.get("WEB_PWD"));			// 웹비밀번호
	String acct_pwd_yn = "N";														// 계좌비밀번호등록여부
	
	// 웹비밀번호가 있을 경우에만 복호화 시도
	if(!web_pwd.equals("")){
		// 웹비밀번호 복호화
		if(!"".equals(StringUtil.null2void(usersession.getString("SCQKEY")))){
			web_pwd = CommUtil.getDecrypt(usersession.getString("SCQKEY"), web_pwd);	
		}else if(!"".equals(StringUtil.null2void(usersession.getString("USE_INTT_ID")))){
			web_pwd = CommUtil.getDecrypt(usersession.getString("USE_INTT_ID")+CommUtil.getPreScqKey(), web_pwd);
		}else{
			web_pwd = CommUtil.getDecrypt(CommUtil.getPreScqKey(), web_pwd);
		}
	}
	
	// 웹PW, 계좌비밀번호 값이 없을 경우
	if(acct_pwd.equals("") && web_pwd.equals("")){
		acct_pwd_yn = "N";
	}else{
		acct_pwd_yn = "Y";
	}
	
	StringBuffer bFnncInfmNo = new StringBuffer(StringUtil.null2void(fnnc_infm_no));

	try{
		// 금융고유번호 채번, 출력순서 MAX+1
		JexData idoIn4 = util.createIDOData("ACCT_INFM_R010");
		
		idoIn4.put("USE_INTT_ID", usersession.getString("USE_INTT_ID"));  
		idoIn4.put("FNNC_INFM_NO", StringUtil.null2void((String)JsonData.get("ACCOUNT_NO")));  
		idoIn4.put("ACCT_DV", acct_dv);  
	    
		JexData idoOut4 =  idoCon.execute(idoIn4);
		    
		if(DomainUtil.isError(idoOut4)) {
			if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut4));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut4));
            }
            result = "";
        }
		BizLogUtil.debug(this, "bank_gb:: " +StringUtil.null2void(bank_gb));
		BizLogUtil.debug(this, "bank_gb:: " +StringUtil.null2void(bank_gb).length());
		BizLogUtil.debug(this, "bank_gb:: " +bank_gb);
		BizLogUtil.debug(this, "bank_gb:: " +bank_gb.length());
		
		result = idoOut4.getString("FNNC_UNQ_NO");
		
	 	// 신규
	    if("0".equals(StringUtil.null2void(idoOut4.getString("ACCT_STTS")))){
		 	 
		    JexData idoIn5 = null;
		 	// 계좌최초등록    
	   	 	if("01".equals(acct_dv)){
	   	 		idoIn5 = util.createIDOData("ACCT_INFM_C001");
	   	 	}else{
	   	 		idoIn5 = util.createIDOData("ACCT_INFM_C002");
	   	 	}
	    	
		    idoIn5.put("USE_INTT_ID", usersession.getString("USE_INTT_ID"));  
		    idoIn5.put("REGR_ID", usersession.getString("CUST_CI"));  
		    idoIn5.put("CORR_ID", usersession.getString("CUST_CI"));  
		    idoIn5.put("FNNC_UNQ_NO", idoOut4.getString("FNNC_UNQ_NO"));  					// 금융고유번호
		    idoIn5.put("BRDT", "");													  		// 생년월일
		    idoIn5.put("BANK_GB", StringUtil.null2void(bank_gb));  							// 뱅킹구분
		    idoIn5.put("BANK_CD", StringUtil.null2void(bank_cd));							// 금융기관코드  
		    idoIn5.put("FNNC_INFM_NO", StringUtil.null2void(fnnc_infm_no));					// 금융정보번호(암호화)  
		    idoIn5.put("FNNC_RPSN_INFM", StringUtil.null2void(fnnc_infm_no));				// 금융기관명  
		    idoIn5.put("OWAC_NM", "");  													// 예금주
		    idoIn5.put("ACCT_NICK_NM", (String)JsonData.get("ACCOUNT_CLASS"));  			// 계좌별칭
		    idoIn5.put("WEB_ID", (String)JsonData.get("WEB_ID"));  							// 웹아이디
		 	// 계좌비밀번호 유무에 따른 처리
		    if(!web_pwd.equals("")){
		    	// 비밀번호 자리수 만큼 0으로 채워 등록하기
		    	String web_pwd_str = "";
		    	int pwdLen = StringUtil.null2void(web_pwd).length();
		    	for(int i=0; i<pwdLen; i++){
		    		web_pwd_str += "0";
		    	}
		    	
		    	idoIn5.put("WEB_PWD", web_pwd_str);						 					// 웹비밀번호
		    }else{
		    	idoIn5.put("WEB_PWD", "");								 					// 웹비밀번호	
		    }
		    idoIn5.put("NAME_CHK_NO", "");  												// 실명확인번호
		    idoIn5.put("CERT_NM", cert_name);  												// 인증서이름
		    idoIn5.put("BANK_INQ_METH", "02");  											// 뱅킹조회방법(02:인증서)
		    idoIn5.put("CUR_AMT", StringUtil.null2void((String)JsonData.get("AMOUNT_BALANCE"))); // 현재잔액
		    idoIn5.put("ACCT_STTS", idoOut4.getString("ACCT_STTS"));						// 계좌상태
		    idoIn5.put("OTPT_SQNC", idoOut4.getString("OTPT_SQNC"));						// 계좌순서
		    idoIn5.put("ACCT_DV", acct_dv);													// 계좌구분
		    idoIn5.put("NEW_DT", new_dt);													// 신규일자
		    idoIn5.put("EXPI_DT", expi_dt);													// 만기일자
		    idoIn5.put("CONT_RT", cont_rt);													// 이자율
		    idoIn5.put("AGMT_AMT", agmt_amt);												// 대출한도/가입금액/약정금액
		    idoIn5.put("PYAT_AMT", pyat_amt);												// 월납입금
		    idoIn5.put("PYAT_DT", pyat_dt);													// 월납입일
		    idoIn5.put("INT_PAYT_DT", int_payt_dt);											// 이자납입예정일자
		    idoIn5.put("DPSV_DV", dpsv_dv);													// 예적금구분
		    if(!"01".equals(acct_dv)){
		    	idoIn5.put("BAL", StringUtil.null2void((String)JsonData.get("AMOUNT_BALANCE"))); // 현재잔액  
	    	}
		    
		    BizLogUtil.debug(this,"=================================input ::  " + idoIn5.toJSONString());
		    
		    JexData idoOut5 =  idoCon.execute(idoIn5);
		    
		    if(DomainUtil.isError(idoOut5)) {
				if (util.getLogger().isDebug())
	            {
	                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut5));
	                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut5));
	            }
	            result = "";
	        }

	    }else{
	    	JexData idoIn6 = null;
	    	// 계좌재등록
	   	 	if("01".equals(acct_dv)){
	       		idoIn6 = util.createIDOData("ACCT_INFM_U001");
	   	 	}else{
	   	 		idoIn6 = util.createIDOData("ACCT_INFM_U020");
	   	 	}
	       	idoIn6.put("USE_INTT_ID", usersession.getString("USE_INTT_ID"));
		    idoIn6.put("CORR_ID", usersession.getString("CUST_CI"));  
	       	idoIn6.put("FNNC_UNQ_NO", idoOut4.getString("FNNC_UNQ_NO"));  					// 금융고유번호
	       	idoIn6.put("BRDT", "");															// 생년월일
	       	idoIn6.put("BANK_GB", StringUtil.null2void(bank_gb));  							// 뱅킹구분
	       	idoIn6.put("BANK_CD", StringUtil.null2void(bank_cd));  							// 금융기관코드  
	       	idoIn6.put("FNNC_INFM_NO", StringUtil.null2void(fnnc_infm_no)); 			 	// 금융정보번호(암호화)  
	       	idoIn6.put("FNNC_RPSN_INFM", StringUtil.null2void(fnnc_infm_no));  				// 금융기관명  
	       	idoIn6.put("OWAC_NM", "");  													// 예금주
	       	idoIn6.put("ACCT_NICK_NM", (String)JsonData.get("ACCOUNT_CLASS"));  			// 계좌별칭
	       	idoIn6.put("WEB_ID", (String)JsonData.get("WEB_ID"));  							// 웹아이디	
	       	
	     	// 계좌비밀번호 유무에 따른 처리
		    if(!web_pwd.equals("")){
		    	// 비밀번호 자리수 만큼 0으로 채워 등록하기
		    	String web_pwd_str = "";
		    	int pwdLen = StringUtil.null2void(web_pwd).length();
		    	for(int i=0; i<pwdLen; i++){
		    		web_pwd_str += "0";
		    	}
		    	idoIn6.put("WEB_PWD", web_pwd_str);  										// 웹비밀번호
		    }else{
		    	idoIn6.put("WEB_PWD", "");								 					// 웹비밀번호	
		    }
	       	
	       	idoIn6.put("NAME_CHK_NO", "");  												// 실명확인번호
	       	idoIn6.put("CERT_NM", cert_name);  												// 인증서이름
	       	idoIn6.put("BANK_INQ_METH", "02");  											// 뱅킹조회방법(02:인증서)
	       	idoIn6.put("ACCT_STTS", idoOut4.getString("ACCT_STTS"));						// 계좌상태
	       	idoIn6.put("OTPT_SQNC", idoOut4.getString("OTPT_SQNC"));						// 계좌상태
	       	idoIn6.put("CUR_AMT", StringUtil.null2void((String)JsonData.get("AMOUNT_BALANCE"))); // 현재잔액  
	       	idoIn6.put("ACCT_DV", acct_dv);													// 계좌구분
	       	idoIn6.put("NEW_DT", new_dt);													// 신규일자
		    idoIn6.put("EXPI_DT", expi_dt);													// 만기일자
		    idoIn6.put("CONT_RT", cont_rt);													// 이자율
		    idoIn6.put("AGMT_AMT", agmt_amt);												// 대출한도/가입금액/약정금액
		    idoIn6.put("PYAT_AMT", pyat_amt);												// 월납입금
		    idoIn6.put("PYAT_DT", pyat_dt);													// 월납입일
		    idoIn6.put("INT_PAYT_DT", int_payt_dt);											// 이자납입예정일자
		    idoIn6.put("DPSV_DV", dpsv_dv);													// 예적금구분
		    
		    if(!"01".equals(acct_dv)){
	    		idoIn6.put("BAL", StringUtil.null2void((String)JsonData.get("AMOUNT_BALANCE"))); // 현재잔액  
	    	}
	       	JexData idoOut6 =  idoCon.execute(idoIn6);
	       	
	       	if(DomainUtil.isError(idoOut6)) {
				if (util.getLogger().isDebug())
	            {
	                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut6));
	                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut6));
	            }
	            result = "";
	        }
	   	}
	   
		BizLogUtil.debug(this,"insertAcct result ::  " + result);
	} catch(Exception e){
    	BizLogUtil.error(this, "insertAcct Err", e);
    	result = "";
	}
	
	return result; 
}
	        
	    
%>