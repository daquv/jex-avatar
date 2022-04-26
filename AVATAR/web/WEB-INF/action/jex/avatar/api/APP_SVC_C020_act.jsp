
<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="com.avatar.comm.IdoSqlException"%>
<%@page import="jex.util.date.DateTime"%>
<%@page import="com.avatar.api.mgnt.CooconApi"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="jex.json.JSONArray"%>
<%@page import="com.avatar.comm.CommUtil"%>
<%@page import="com.avatar.comm.BizLogUtil"%>
<%@page import="jex.util.StringUtil"%>
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
         * @File Title   : 인증서교체(기관별)
         * @File Name    : APP_SVC_C020_act.jsp
         * @File path    : api
         * @author       : kth91 (  )
         * @Description  : 인증서교체(기관별)
         * @Register Date: 20200117172433
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

        @JexDataInfo(id="APP_SVC_C020", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

     	// 세션값 체크
		JexDataCMO usersession = null;
    	try{
    		usersession   = SessionManager.getInstance().getUserSession(request, response);  		
    	}catch(Throwable e){
    		throw new JexBIZException("9999", "Session DisConnected.");
    	}
    	
    	String rslt_cd          = "";
    	String rslt_msg         = "";
    	
    	String reg_type         = StringUtil.null2void(input.getString("REG_TYPE"));
    	String before_cert_name = StringUtil.null2void(input.getString("BEFORE_CERT_NAME"));
    	String cert_usag_div    = StringUtil.null2void(input.getString("CERT_USAG_DIV"));
    	String cert_name        = StringUtil.null2void(input.getString("CERT_NAME"));
    	String cert_org         = StringUtil.null2void(input.getString("CERT_ORG"));
    	String cert_date        = StringUtil.null2void(input.getString("CERT_DATE"));
    	String cert_issu_dt     = StringUtil.null2void(input.getString("CERT_ISSU_DT"));
    	String cert_pwd         = StringUtil.null2void(input.getString("CERT_PWD"));
    	String cert_folder      = StringUtil.null2void(input.getString("CERT_FOLDER"));
    	String cert_data        = StringUtil.null2void(input.getString("CERT_DATA"));
    	
    	String use_intt_id      = usersession.getString("USE_INTT_ID");
    	String cert_reg_type    = "1";
    	
    	String acct_no          = "";
    	String card_no          = "";
    	String acct_dv          = "";
    	
    	BizLogUtil.debug(this," ===== CERT INFO ===== ");
    	BizLogUtil.debug(this,"before_cert_name ::  " + before_cert_name);
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
    		if(!"".equals(StringUtil.null2void(usersession.getString("SCQKEY")))){
    	    	cert_pwd = CommUtil.getDecrypt(usersession.getString("SCQKEY"), cert_pwd);
        	
    		}else if(!"".equals(StringUtil.null2void(usersession.getString("USE_INTT_ID")))){
        		cert_pwd = CommUtil.getDecrypt(usersession.getString("USE_INTT_ID")+CommUtil.getPreScqKey(), cert_pwd);
        	
    		}else{
        		cert_pwd = CommUtil.getDecrypt(CommUtil.getPreScqKey(), cert_pwd);
        	}
		}
    	
		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
    	// 인증서 등록여부 확인
        JexData idoIn1 = util.createIDOData("CERT_INFM_R003");
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
            result.put("RSLT_PROC_GB", "");
        }

        
      	// COOCON REG_TYPE=1 : 계정원장(UPDATE) 및 인증서 원장변경(DELETE INSERT 임)
    	// COOCON REG_TYPE=0 : 계정원장(UPDATE) 변경
    	// REG_TYPE=1 예외 : 인증서명이 변경된 경우 DELETE시 예외발생됨.
    	// 쿠콘에 이미 등록된 인증서라 인증서정보는 수정하지 않고 계정정보만 수정함.
    	if("0".equals(reg_type) && !"".equals(StringUtil.null2void(idoOut1.getString("CERT_NM")))
    		&& cert_date.equals(StringUtil.null2void(idoOut1.getString("CERT_DT"))) 
    		//&& cert_issu_dt.equals(StringUtil.null2void(idoOut1.getString("CERT_ISSU_DT")))
    	){
    		
    		cert_reg_type = "0";
    	}
    	
    	JexDataList<JexData> bizList = input.getRecord("BIZ_LIST");
    	JexDataList<JexData> orgRec  = null;
    	
    	JSONArray bizListRes = new JSONArray();
    	JSONObject bizRowRes = null;
    	
    	JexData bizRow = null;
    	JexData orgRow = null;
    	
    	BizLogUtil.debug(this," ============================================== ");
    	BizLogUtil.debug(this," reg_type :: " + reg_type);
    	BizLogUtil.debug(this," ============================================== ");
    	
    	String biz_cd = "";
    	String biz_nm = "";
    	String org_cd = "";
    	String org_nm = "";
    	
    	int biz_cnt = 0;
    	int success_cnt = 0;
    	
    	JSONObject certResData = null;
    	JSONObject reqData     = null;
    	JSONObject resData     = null;
    	
    	while(bizList.next()){
    		BizLogUtil.debug(this," ===== biz " + biz_cnt);
    		
    		bizRow = (JexData)bizList.get();
    		
    		biz_cd = bizRow.getString("BIZ_CD");
    		biz_nm = bizRow.getString("BIZ_NM");
    		
    		BizLogUtil.debug(this," biz_cd :: " + biz_cd);
    		BizLogUtil.debug(this," biz_nm :: " + biz_nm);
    		
    		orgRec = bizRow.getRecord("ORG_REC");
    		
    		boolean acctCertChk = false;
    		boolean cardCertChk = false;
    		boolean evdcCertChk = false;
    		boolean taxCertChk = false;
    		
    		while(orgRec.next()){
    			orgRow = (JexData)orgRec.get();
    			
    			org_cd = orgRow.getString("ORG_CD").trim();
    			org_nm = orgRow.getString("ORG_NM");
    			
    			BizLogUtil.debug(this," org_cd :: " + org_cd);	
    			BizLogUtil.debug(this," org_nm :: " + org_nm);
    			//첫번째 row에 검색 FNNC_UNQ_NO를 담아줌(먼저 교체 API로 확인 후 실패면 바로 팅기기)
        		String fnnc_unq_no = "";
        		if(orgRec.isFirst()){
        			fnnc_unq_no = StringUtil.null2void(bizRow.getString("FNNC_UNQ_NO"));
        		}	
    			// 계좌
    			if("001".equals(biz_cd)){
    				
    				// 변경전 인증서명으로 뱅킹구분 조회
    				JexData idoIn2 = util.createIDOData("ACCT_INFM_R005");
    				    
    				idoIn2.put("USE_INTT_ID", usersession.getString("USE_INTT_ID"));  
    				idoIn2.put("CERT_NM", before_cert_name);
    				idoIn2.put("BANK_CD", org_cd);
					//교체 대상 계좌번호로 판별(첫 행에서만 - 첫행은 사용자가 선택한 은행으로 판별)   			    
    				if(orgRec.isFirst() && !"".equals(fnnc_unq_no)){
	    				IDODynamic dynamic_0 = new IDODynamic();
    					dynamic_0.addSQL("\n AND FNNC_UNQ_NO='"+fnnc_unq_no+"' ");
	    		        idoIn2.put("DYNAMIC_0", dynamic_0);
    				}
    				
   			        JexData idoOut2 =  idoCon.execute(idoIn2);
   			    
   			        // 도메인 에러 검증
   			        if (DomainUtil.isError(idoOut2)) {
   			            if (util.getLogger().isDebug())
   			            {
   			                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
   			                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
   			            }
   			         	result.put("RSLT_CD", "SOER3007");
   		            	result.put("RSLT_MSG", "처리중오류가발생하였습니다.잠시후이용하시기바랍니다.");
   		            	result.put("RSLT_PROC_GB", "");
   			        }
   			     
    				BizLogUtil.debug(this,"BANK_GB    ::  " + idoOut2.getString("BANK_GB"));
    				BizLogUtil.debug(this,"ACCT_NO    ::  " + idoOut2.getString("FNNC_INFM_NO"));
    				BizLogUtil.debug(this,"ACCT_DV    ::  " + idoOut2.getString("ACCT_DV"));
    				
    				// 계좌번호
    				acct_no = StringUtil.null2void(idoOut2.getString("FNNC_INFM_NO"));
    				acct_dv = StringUtil.null2void(idoOut2.getString("ACCT_DV"), "01");
    				
    				BizLogUtil.debug(this,"acct_dv.substring(1)    ::  " + acct_dv.substring(1));
    				
    				if(!acctCertChk){
    					// 0:인증서 미등록, 1:인증서 등록
    					if("0".equals(reg_type)){
    						resData = CooconApi.getAcctListWithCertInfo(org_cd, idoOut2.getString("BANK_GB"), cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, acct_dv.substring(1));
    						
    						rslt_cd  = StringUtil.null2void((String)resData.get("RESULT_CD"));
    						rslt_msg = StringUtil.null2void((String)resData.get("RESULT_MG"));
    						
    						// 응답코드가 없을 경우
    						if("".equals(rslt_cd)){
    							rslt_cd  = StringUtil.null2void((String)resData.get("ERRCODE"));
    							rslt_msg = StringUtil.null2void((String)resData.get("ERRMSG"));
    						}
    					}else if("1".equals(reg_type)){
    						resData = CooconApi.getAcctListWithCertName(use_intt_id, org_cd, idoOut2.getString("BANK_GB"), cert_name, acct_dv.substring(1));
    						
    						rslt_cd  = StringUtil.null2void((String)resData.get("ERRCODE"));
    						rslt_msg = StringUtil.null2void((String)resData.get("ERRMSG"));
    						
    						// 응답코드가 없을 경우
    						if("".equals(rslt_cd)){
    							rslt_cd  = StringUtil.null2void((String)resData.get("RESULT_CD"));
    							rslt_msg = StringUtil.null2void((String)resData.get("RESULT_MG"));
    						}
    					}
    				
    					// 외부이력테이블에 응답 결과 이력 입력
// 			            ExtnTrnsHis.insert(usersession.getString("USE_INTT_ID"), "C", "0201", rslt_cd, rslt_msg);
    					
    					BizLogUtil.debug(this,"계좌 응답코드 :: " + rslt_cd);
    					BizLogUtil.debug(this,"계좌 응답메시지 :: " + rslt_msg);
    					
    					if("00000000".equals(rslt_cd) || "42110000".equals(rslt_cd) || "42120101".equals(rslt_cd) ||
    						"42120110".equals(rslt_cd) || "42120011".equals(rslt_cd) || "42120111".equals(rslt_cd) ){
    						
    						if(this.acctCardCheck(biz_cd, acct_no, resData)){
    							acctCertChk = true;	
    						}else{
    							rslt_cd = "SOER1000";
    							rslt_msg = "처리중오류가발생하였습니다.잠시후이용하시기바랍니다.";
    							if(orgRec.isFirst() && !"".equals(fnnc_unq_no)){
    								bizRowRes = new JSONObject();
    								bizRowRes.put("ORG_CD", org_cd);
    								bizRowRes.put("ORG_NM", org_nm);
    								bizRowRes.put("RESULT_CD", rslt_cd);
    								bizRowRes.put("RESULT_MG", rslt_msg);
    								result.put("RSLT_CD", "SOER5002");
    						        result.put("RSLT_MSG", "인증서 교체에 실패하였습니다.");
    						        result.put("RSLT_PROC_GB", "");
    						    	result.put("BIZ_LIST_RESP", bizListRes);
    						    	BizLogUtil.debug(this,"최좋 변경 결과   :: " + result.toJSONString());
    						    	util.setResult(result, "default");			
    						    	return;
    							}
    						}
    					}
    				}
    			}
    			// 신용카드
    			else if("003".equals(biz_cd)){
    				
//     				String bc_org_cd = "";
//     				org_cd = org_cd.substring(5);
    				
//     				if(CommUtil.isBCCard(org_cd)){
//     					bc_org_cd = "006";
//     				}
    				
//     				// 카드번호 조회
//     				JexData idoIn3 = util.createIDOData("PSNL_CARD_OWER_INFM_R001");
//     				idoIn3.put("PTL_ID", usersession.getString("PTL_ID"));  
//     				idoIn3.put("USE_INTT_ID", usersession.getString("USE_INTT_ID"));  
//     				idoIn3.put("BANK_CD", "30000"+org_cd);
    				
//     		        JexData idoOut3 =  idoCon.execute(idoIn3);
    		    
//     		        // 도메인 에러 검증
//     		        if (DomainUtil.isError(idoOut3)) {
//     		            if (util.getLogger().isDebug())
//     		            {
//     		                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut3));
//     		                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut3));
//     		            }
//     		            result.put("RSLT_CD", "SOER3007");
//    		            	result.put("RSLT_MSG", "데이터(DB) 처리 중 오류가 발생하였습니다. 잠시후 이용하시기 바랍니다.");
//    		            	result.put("RSLT_PROC_GB", "");
//     		        }
    		        
//     				card_no = idoOut3.getString("CARD_NO");
    				
//     				BizLogUtil.debug(this,"org_cd    ::  " + org_cd);
//     				BizLogUtil.debug(this,"card_no   ::  " + card_no);
    			
// 	    			if(!cardCertChk){
// 	    				// 0:인증서 미등록, 1:인증서 등록
// 	    				if("0".equals(reg_type)){
// 	    					resData = CooconApi.getPsnlCardListWithCertInfo("".equals(bc_org_cd)?org_cd:bc_org_cd, cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data);
// 	    					rslt_cd  = StringUtil.null2void((String)resData.get("ERRCODE"));
// 	    					rslt_msg = StringUtil.null2void((String)resData.get("ERRMSG"));
	    					
// 	    					// 응답코드가 없는 경우
// 	    					if("".equals(rslt_cd)){
// 	    						rslt_cd  = StringUtil.null2void((String)resData.get("RESULT_CD"));
// 	    						rslt_msg = StringUtil.null2void((String)resData.get("RESULT_MG"));
// 	    					}
	    					
// 	    				}else if("1".equals(reg_type)){
// 	    					resData = CooconApi.getPsnlCardListWithCertName(bsnn_no, "".equals(bc_org_cd)?org_cd:bc_org_cd, cert_name);
// 	    					rslt_cd  = StringUtil.null2void((String)resData.get("ERRCODE"));
// 	    					rslt_msg = StringUtil.null2void((String)resData.get("ERRMSG"));
	    					
// 	    					// 응답코드가 없는 경우
// 	    					if("".equals(rslt_cd)){
// 	    						rslt_cd  = StringUtil.null2void((String)resData.get("RESULT_CD"));
// 	    						rslt_msg = StringUtil.null2void((String)resData.get("RESULT_MG"));
// 	    					}
	    					
// 	    				}
// 	    				// 외부이력테이블에 응답 결과 이력 입력
// 			            ExtnTrnsHis.insert(usersession.getString("USE_INTT_ID"), "C", "0340", rslt_cd, rslt_msg);
	    				
// 	    				BizLogUtil.debug(this,"신용카드 응답코드    :: " + rslt_cd);
// 	    				BizLogUtil.debug(this,"신용카드 응답메시지 :: " + rslt_msg);
	    				
// 	    				if("00000000".equals(rslt_cd) || "42110000".equals(rslt_cd) || "42120101".equals(rslt_cd) ||
// 	    					"42120110".equals(rslt_cd) || "42120011".equals(rslt_cd) || "42120111".equals(rslt_cd) ){
	    					
// 	    					if(this.acctCardCheck(biz_cd, card_no, resData)){
// 	    						cardCertChk = true; 
// 	    					}else{
//     				            rslt_cd = "SOER1000";
//     							rslt_msg = "처리중오류가발생하였습니다.잠시후이용하시기바랍니다.";  
// 	    					}
// 	    				}
// 	    			}
	    		}
    			// 홈택스(전자세금계산서/현금영수증)
    			else if("002".equals(biz_cd)){
    				if(!evdcCertChk){
    					String strToday = DateTime.getInstance().getDate("yyyymmdd");
    					
    					// 0:인증서 미등록, 1:인증서 등록
    					if("0".equals(reg_type)){
    						resData = CooconApi.getEvdcTxblHstrWithCertInfo("3", strToday, strToday, cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, "", "");
    						rslt_cd = StringUtil.null2void((String)resData.get("RESULT_CD"));
    						rslt_msg = StringUtil.null2void((String)resData.get("RESULT_MG"));
    						// 응답코드가 없는 경우
    						if("".equals(rslt_cd)){
    							rslt_cd  = StringUtil.null2void((String)resData.get("ERRCODE"));
    							rslt_msg = StringUtil.null2void((String)resData.get("ERRMSG"));
    						}
    						
    					}else if("1".equals(reg_type)){
    						resData = CooconApi.getEvdcTxblHstrWithCertName(use_intt_id, "3", strToday, strToday, cert_name, "", "");
    						rslt_cd  = StringUtil.null2void((String)resData.get("ERRCODE"));
    						rslt_msg = StringUtil.null2void((String)resData.get("ERRMSG"));
    						// 응답코드가 없는 경우
    						if("".equals(rslt_cd)){
    							rslt_cd  = StringUtil.null2void((String)resData.get("RESULT_CD"));
    							rslt_msg = StringUtil.null2void((String)resData.get("RESULT_MG"));
    						}
    					}
    					
    					// 외부이력테이블에 응답 결과 이력 입력
// 			            ExtnTrnsHis.insert(usersession.getString("USE_INTT_ID"), "C", "1335", rslt_cd, rslt_msg);
    					
    					BizLogUtil.debug(this,"홈택스(전자세금계산서/현금영수증) 응답코드    :: " + rslt_cd);
    					BizLogUtil.debug(this,"홈택스(전자세금계산서/현금영수증) 응답메시지 :: " + rslt_msg);
    					
    					if("00000000".equals(rslt_cd) || "42110000".equals(rslt_cd) || "42120101".equals(rslt_cd) ||
    						"42120110".equals(rslt_cd) || "42120011".equals(rslt_cd) || "42120111".equals(rslt_cd)){
    						evdcCertChk = true; 
    					} else {
    						rslt_cd = "SOER1000";
							rslt_msg = "처리중오류가발생하였습니다.잠시후이용하시기바랍니다.";
							if(bizList.isFirst()){
								bizRowRes = new JSONObject();
								bizRowRes.put("ORG_CD", org_cd);
								bizRowRes.put("ORG_NM", org_nm);
								bizRowRes.put("RESULT_CD", rslt_cd);
								bizRowRes.put("RESULT_MG", rslt_msg);
								result.put("RSLT_CD", "SOER5002");
						        result.put("RSLT_MSG", "인증서 교체에 실패하였습니다.");
						        result.put("RSLT_PROC_GB", "");
						    	result.put("BIZ_LIST_RESP", bizListRes);
						    	BizLogUtil.debug(this,"최좋 변경 결과   :: " + result.toJSONString());
						    	util.setResult(result, "default");			
						    	return;
							}
    					}
    				}
    			}
    			// 홈택스(부가가치세/종합소득세)
    			else if("007".equals(biz_cd)){
    				if(!taxCertChk){
    					// 0:인증서 미등록, 1:인증서 등록
    					if("0".equals(reg_type)){
    						// 인증서정보로 납부할 세액조회
    						resData = CooconApi.getTaxHstrWithCertInfo(cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data);
    						rslt_cd = StringUtil.null2void((String)resData.get("RESULT_CD"));
    						rslt_msg = StringUtil.null2void((String)resData.get("RESULT_MG"));
    						// 응답코드가 없는 경우
    						if("".equals(rslt_cd)){
    							rslt_cd  = StringUtil.null2void((String)resData.get("ERRCODE"));
    							rslt_msg = StringUtil.null2void((String)resData.get("ERRMSG"));
    						}
    					}else if("1".equals(reg_type)){
    						// 인증서명으로 납부할세액 조회
    						resData = CooconApi.getTaxHstrWithCertName(use_intt_id, cert_name);
    						rslt_cd  = StringUtil.null2void((String)resData.get("ERRCODE"));
    						rslt_msg = StringUtil.null2void((String)resData.get("ERRMSG"));
    						// 응답코드가 없는 경우
    						if("".equals(rslt_cd)){
    							rslt_cd  = StringUtil.null2void((String)resData.get("RESULT_CD"));
    							rslt_msg = StringUtil.null2void((String)resData.get("RESULT_MG"));
    						}
    					}
    					
    					BizLogUtil.debug(this,"홈택스(부가가치세/종합소득세) 응답코드    :: " + rslt_cd);
    					BizLogUtil.debug(this,"홈택스(부가가치세/종합소득세) 응답메시지 :: " + rslt_msg);
    					
    					if("00000000".equals(rslt_cd) || "42110000".equals(rslt_cd) || "42120101".equals(rslt_cd) ||
    						"42120110".equals(rslt_cd) || "42120011".equals(rslt_cd) || "42120111".equals(rslt_cd)){
    						taxCertChk = true; 
    					} else {
    						rslt_cd = "SOER1000";
							rslt_msg = "처리중오류가발생하였습니다.잠시후이용하시기바랍니다.";
							if(bizList.isFirst()){
								bizRowRes = new JSONObject();
								bizRowRes.put("ORG_CD", org_cd);
								bizRowRes.put("ORG_NM", org_nm);
								bizRowRes.put("RESULT_CD", rslt_cd);
								bizRowRes.put("RESULT_MG", rslt_msg);
								result.put("RSLT_CD", "SOER5002");
						        result.put("RSLT_MSG", "인증서 교체에 실패하였습니다.");
						        result.put("RSLT_PROC_GB", "");
						    	result.put("BIZ_LIST_RESP", bizListRes);
						    	BizLogUtil.debug(this,"최좋 변경 결과   :: " + result.toJSONString());
						    	util.setResult(result, "default");			
						    	return;
							}
    					}
    				}
    			} 

				// 검증 완료된 인증서만 변경 가능
				BizLogUtil.debug(this,"검증후 결과코드   :: " + rslt_cd);
				BizLogUtil.debug(this,"검증후 결과메시지   :: " + rslt_msg);
				BizLogUtil.debug(this,"계좌 인증여부   :: " + acctCertChk);
				BizLogUtil.debug(this,"카드 인증여부    :: " + cardCertChk);
				BizLogUtil.debug(this,"홈텍스(전자세금계산서/현금영수증) 인증여부    :: " + evdcCertChk);
				BizLogUtil.debug(this,"홈텍스(부가가치세/종합소득세) 인증여부    :: " + taxCertChk);
				
    			if(acctCertChk || cardCertChk || evdcCertChk || taxCertChk){
    				// 인증서 변경
        			certResData = this.certChange(util, use_intt_id, biz_cd, org_cd, use_intt_id, usersession.getString("CUST_CI"), acct_no
        					,acct_dv, cert_name, before_cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, cert_reg_type);
    				
        			if("00000000".equals(certResData.get("ERRCODE"))){
        				
        				// 쿠콘에 해당 인증서가 등록되었기 때문에 다음 계정 변경 시도할때 reg_type을 0으로 보내야됨.
        				if("0".equals(certResData.get("REG_TYPE"))){
        					cert_reg_type = "0";
        				}
        				
        				JexData idoIn4 = util.createIDOData("CERT_INFM_C002");
        				
        				idoIn4.put("USE_INTT_ID", usersession.getString("USE_INTT_ID"));
        				idoIn4.put("CERT_NM", cert_name);
        				idoIn4.put("CERT_ORG", cert_org);
        				idoIn4.put("CERT_DSNC", "");
        				idoIn4.put("CERT_DT", cert_date);
        				idoIn4.put("CERT_ISSU_DT", cert_issu_dt);
        				idoIn4.put("CERT_STTS", "1");
        				idoIn4.put("CERT_USAG_DIV", cert_usag_div);
        				idoIn4.put("REGR_ID", usersession.getString("CUST_CI"));
        				idoIn4.put("CORR_ID", usersession.getString("CUST_CI"));
        				
        				JexData idoOut4 =  idoCon.execute(idoIn4);
        			    
        			    // 도메인 에러 검증
        			    if (DomainUtil.isError(idoOut4)) {
       			            if (util.getLogger().isDebug())
       			            {
       			                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut4));
       			                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut4));
       			            }
       			            result.put("RSLT_CD", "SOER3007");
          		            result.put("RSLT_MSG", "데이터(DB) 처리 중 오류가 발생하였습니다. 잠시후 이용하시기 바랍니다.");
          		            result.put("RSLT_PROC_GB", "");
       			        }
        			    
        			    success_cnt++;
        			    rslt_cd  = "0000";
        				rslt_msg = "정상처리되었습니다.";
        			}else{
        				rslt_cd  = (String)certResData.get("ERRCODE");
        				rslt_msg = (String)certResData.get("ERRMSG");
        			}
        			
        			// cert_reg_type '1' 인증서 변경이 성공하면 그 후엔 인증서 미등록으로 변경
        			// 쿠콘에 인증서 정상적으로 등록되어 있기 때문에 상태값 변경해줘야함
        			// 이미 등록된 인증서인데 reg_type = "1"로 보내면 오류 발생 
        			if("1".equals(cert_reg_type) && "00000000".equals(certResData.get("ERRCODE"))){
        				cert_reg_type = "0";
        			}
    			}else{
    				rslt_cd  = "SOER5004";
    				rslt_msg = "교체 가능한 인증서가 아닙니다.";
    			}
    			
    			
    			bizRowRes = new JSONObject();
    			bizRowRes.put("ORG_CD", org_cd);
				bizRowRes.put("ORG_NM", org_nm);
				bizRowRes.put("RESULT_CD", rslt_cd);
				bizRowRes.put("RESULT_MG", rslt_msg);
	            bizListRes.add(bizRowRes);   
	            biz_cnt++;
    		}
    		
    		acctCertChk = false;
    		cardCertChk = false;
    		evdcCertChk = false;
    		taxCertChk = false;
    	}
    	
    	if(biz_cnt > 0 && success_cnt == 0){
    		result.put("RSLT_CD", "SOER5002");
	        result.put("RSLT_MSG", "공동인증서 교체 실패");
	        result.put("RSLT_PROC_GB", "");
    	}else if(biz_cnt > 0 && biz_cnt == success_cnt){
    		result.put("RSLT_CD", "0000");
	        result.put("RSLT_MSG", "공동인증서 교체 완료");
	        result.put("RSLT_PROC_GB", "");
    	}else{
    		result.put("RSLT_CD", "SOER5003");
			result.put("RSLT_MSG", biz_cnt+"건 중 "+success_cnt+"건 교체 완료");
			result.put("RSLT_PROC_GB" , "");
    	}
    	result.put("BIZ_LIST_RESP", bizListRes);
    	BizLogUtil.debug(this,"최좋 변경 결과   :: " + result.toJSONString());
    	util.setResult(result, "default");
%>
<%!

//인증서 변경
public JSONObject certChange(WebCommonUtil util, String bsnn_no, String biz_cd, String org_cd, String use_intt_id, String user_id, String acct_no, String acct_dv, 
        String cert_name, String before_cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data, String reg_type){

	JSONObject resData = new JSONObject();
	
	if("001".equals(biz_cd)){
		// 계좌
		resData = acctCertChange(util, bsnn_no, org_cd, use_intt_id, acct_no, acct_dv, cert_name, before_cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, reg_type);
	}else if("002".equals(biz_cd)){
		// 홈택스(전자세금계산서/현금영수증)
		resData = evdcCertChange(util, bsnn_no, org_cd, use_intt_id, cert_name, before_cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, reg_type);
	}else if("003".equals(biz_cd)){
		// 신용카드
// 		resData = psnlCardCertChange(util, bsnn_no, org_cd, use_intt_id, user_id, cert_name, before_cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, reg_type);
	}else if("007".equals(biz_cd)){
		// 홈택스(부가가치세/종합소득세)
		resData = taxCertChange(util, bsnn_no, org_cd, use_intt_id, cert_name, before_cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, reg_type);
	}
	return resData;
}

// 계좌원장 인증서 변경
private JSONObject acctCertChange(WebCommonUtil util, String bsnn_no, String org_cd, String use_intt_id, String acct_no, String acct_dv,
	String cert_name, String before_cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data, String reg_type){

	JSONObject resData = new JSONObject();

	try{
		
		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		
		resData = CooconApi.updateAcct(acct_dv, org_cd, bsnn_no, cert_name, before_cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, "", "", acct_no, "", "", reg_type, "1");
		
		// 외부이력테이블에 응답 결과 이력 입력
//         ExtnTrnsHis.insert(use_intt_id, "C", "0100_001_U", resData.getString("ERRCODE"), resData.getString("ERRMSG"));
		
		if("00000000".equals(resData.get("ERRCODE"))){
			// 계좌의 인증서 변경
			JexData idoIn5 = util.createIDOData("ACCT_INFM_U006");
			
			idoIn5.put("USE_INTT_ID", use_intt_id);
			idoIn5.put("CERT_NM", cert_name);
			idoIn5.put("BANK_CD", org_cd);
			idoIn5.put("BEFORE_CERT_NAME", before_cert_name);
			
			JexData idoOut5 =  idoCon.execute(idoIn5);
			
			// 도메인 에러 검증
	        if (DomainUtil.isError(idoOut5)) {
	        	BizLogUtil.debug(this, "      ===== APP_SVC_C020 JexDomainUtil.isError()"  );
				BizLogUtil.debug(this, "      ===== Error Code :: "+IdoSqlException.getInstance(idoOut5).getErrorCode());
	        }
			
	     	// 쿠콘에 해당 인증서가 등록되었기 때문에 0으로 변경
			resData.put("REG_TYPE", "0");
		}
	
	}catch(Exception e){
		resData.put("ERRCODE", "SOER1000");
		resData.put("ERRMSG" , "데이터 처리 중 오류가 발생하였습니다. 잠시후 이용하시기 바랍니다.");
	}

	return resData;
}

// 개인카드 기관별 인증서 변경
// private JSONObject psnlCardCertChange(WebCommonUtil util, String bsnn_no, String org_cd, String use_intt_id, String user_id, String cert_name, 
// 	String before_cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data, String reg_type){
	
// 	JSONObject resData = new JSONObject();
	
// 	try{
		
// 		JexConnection idoCon = JexConnectionManager.createIDOConnection();
// 		// 개인카드 조회
// 		JexData idoIn6 = util.createIDOData("PSNL_CARD_LDGR_R001");
		
// 		idoIn6.put("PTL_ID", CommUtil.getPtlId());
// 		idoIn6.put("USE_INTT_ID", use_intt_id);
// 		idoIn6.put("BANK_CD", "30000"+org_cd);
		
// 		JexData idoOut6 =  idoCon.execute(idoIn6);
		
// 		// 도메인 에러 검증
//         if (DomainUtil.isError(idoOut6)) {
//         	BizLogUtil.debug(this, "      ===== SUPARK_SVC_C020 JexDomainUtil.isError()"  );
// 			BizLogUtil.debug(this, "      ===== Error Code :: "+IdoSqlException.getInstance(idoOut6).getErrorCode());
//         	return resData;
// 		}
	
// 		if(CommUtil.isBCCard(org_cd)){
// 			org_cd = "006";
// 		}
	
// 		resData = CooconApi.updatePsnlCard(org_cd, bsnn_no, idoOut6.getString("FNNC_UNQ_NO"), idoOut6.getString("BC_MMBCO_NM"), cert_name, before_cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, reg_type, "");
	
// 		// 외부이력테이블에 응답 결과 이력 입력
//         ExtnTrnsHis.insert(use_intt_id, "C", "0100_005_U", resData.getString("ERRCODE"), resData.getString("ERRMSG"));
		
// 		if("00000000".equals(resData.get("ERRCODE"))){
// 			// 개인카드 인증서명 변경
// 			JexData idoIn7 = util.createIDOData("PSNL_CARD_LDGR_U001");
			
// 			idoIn7.put("PTL_ID", CommUtil.getPtlId());
// 			idoIn7.put("USE_INTT_ID", use_intt_id);
// 			idoIn7.put("CERT_NM", cert_name);
// 			idoIn7.put("MOD_USER_ID", user_id);
// 			idoIn7.put("BEFORE_CERT_NAME", before_cert_name);
			
// 			JexData idoOut7 =  idoCon.execute(idoIn7);
			
// 			if (DomainUtil.isError(idoOut7)) {
// 	        	BizLogUtil.debug(this, "      ===== SUPARK_SVC_C020 JexDomainUtil.isError()"  );
// 				BizLogUtil.debug(this, "      ===== Error Code :: "+IdoSqlException.getInstance(idoOut7).getErrorCode());
// 			}
// 		}
	
// 	}catch(Exception e){
// 		resData.put("ERRCODE", "SOER1000");
// 		resData.put("ERRMSG" , "데이터 처리 중 오류가 발생하였습니다. 잠시후 이용하시기 바랍니다.");
// 	}
// 	return resData;
// }

// 홈택스(전자세금계산서/현금영수증) 인증서 변경
private JSONObject evdcCertChange(WebCommonUtil util, String bsnn_no, String org_cd, String use_intt_id, String cert_name, 
	String before_cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data, String reg_type){

	JSONObject resData = new JSONObject();

	try{
		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		// 인증서명 기준으로 증빙 조회
		JexData idoIn8 = util.createIDOData("EVDC_INFM_R006");
		
		idoIn8.put("USE_INTT_ID", use_intt_id);
		idoIn8.put("CERT_NM", before_cert_name);
		
		JexDataList<JexData> idoOut8 = (JexDataList<JexData>) idoCon.executeList(idoIn8);
		
		if (DomainUtil.isError(idoOut8)) {
			BizLogUtil.debug(this, "      ===== APP_SVC_C020 JexDomainUtil.isError()"  );
			BizLogUtil.debug(this, "      ===== Error Code :: "+IdoSqlException.getInstance(idoOut8).getErrorCode());
			return resData;
		}
		
		int cnt = 0;
		String evdc_div_cd = "";
		String biz_cd_list = "";
		
		while (idoOut8.next()) {
			cnt++;
			JexData row = (JexData)idoOut8.get();
			evdc_div_cd = row.getString("EVDC_DIV_CD");
			// 전자세금계산서
			if("20".equals(evdc_div_cd)){
				
				BizLogUtil.debug(this, "====================================================");
				BizLogUtil.debug(this, "bsnn_no 			:"+bsnn_no);
				BizLogUtil.debug(this, "bsnn_no 			:"+bsnn_no);
				BizLogUtil.debug(this, "cert_name 			:"+cert_name);
				BizLogUtil.debug(this, "before_cert_name 	:"+before_cert_name);
				BizLogUtil.debug(this, "cert_org 			:"+cert_org);
				BizLogUtil.debug(this, "cert_date 			:"+cert_date);
				BizLogUtil.debug(this, "cert_pwd 			:"+cert_pwd);
				BizLogUtil.debug(this, "cert_folder 		:"+cert_folder);
				BizLogUtil.debug(this, "cert_data 			:"+cert_data);
				BizLogUtil.debug(this, "reg_type 			:"+reg_type);
				BizLogUtil.debug(this, "====================================================");
				
				
				resData = CooconApi.updateEvdcTxbl(bsnn_no, bsnn_no, cert_name, before_cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, reg_type, "1", "","","");
				if("00000000".equals(resData.get("ERRCODE"))){
					reg_type = "0";
					// 쿠콘에 해당 인증서가 등록되었기 때문에 0으로 변경
					resData.put("REG_TYPE", "0");
				}
				// 외부이력테이블에 응답 결과 이력 입력
// 		        ExtnTrnsHis.insert(use_intt_id, "C", "0100_006_U", resData.getString("ERRCODE"), resData.getString("ERRMSG"));
			}
			// 현금영수증
			else if("21".equals(evdc_div_cd)){ 
				resData = CooconApi.updateEvdcCash(bsnn_no, bsnn_no, cert_name, before_cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, reg_type, "1","","");
				if("00000000".equals(resData.get("ERRCODE"))){
					reg_type = "0";
					// 쿠콘에 해당 인증서가 등록되었기 때문에 0으로 변경
					resData.put("REG_TYPE", "0");
				}
				// 외부이력테이블에 응답 결과 이력 입력
// 		        ExtnTrnsHis.insert(use_intt_id, "C", "0100_002_U", resData.getString("ERRCODE"), resData.getString("ERRMSG"));
			}
		}

		if(cnt < 1){
			resData.put("ERRCODE", "SOER1000");
			resData.put("ERRMSG" , "변경할 증빙데이터가 없습니다.");
			return resData;
		}

		if("00000000".equals(resData.get("ERRCODE"))){
			JexData idoIn9 = util.createIDOData("EVDC_INFM_U007");
			
			idoIn9.put("USE_INTT_ID", use_intt_id);
			idoIn9.put("CERT_NM", cert_name);
			idoIn9.put("BEFORE_CERT_NAME", before_cert_name);
			
			JexData idoOut9 =  idoCon.execute(idoIn9);
			
			if (DomainUtil.isError(idoOut9)) {
				BizLogUtil.debug(this, "      ===== APP_SVC_C020 JexDomainUtil.isError()"  );
				BizLogUtil.debug(this, "      ===== Error Code :: "+IdoSqlException.getInstance(idoOut9).getErrorCode());
			}
		}
	}catch(Exception e){
		resData.put("ERRCODE", "SOER1000");
		resData.put("ERRMSG" , "데이터 처리 중 오류가 발생하였습니다. 잠시후 이용하시기 바랍니다." + e.getMessage());
	}
	return resData;
}

// 홈택스(부가가치세/종합소득세) 인증서 변경
private JSONObject taxCertChange(WebCommonUtil util, String bsnn_no, String org_cd, String use_intt_id, String cert_name, 
	String before_cert_name, String cert_org, String cert_date, String cert_pwd, String cert_folder, String cert_data, String reg_type){

	JSONObject resData = new JSONObject();

	try{
		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		// 인증서명 기준 부가가치세/종합소득세 조회
		JexData idoIn8 = util.createIDOData("EVDC_INFM_R018");
		
		idoIn8.put("USE_INTT_ID", use_intt_id);
		idoIn8.put("CERT_NM", before_cert_name);
		
		JexDataList<JexData> idoOut8 = (JexDataList<JexData>) idoCon.executeList(idoIn8);
		
		if (DomainUtil.isError(idoOut8)) {
			BizLogUtil.debug(this, "      ===== APP_SVC_C020 JexDomainUtil.isError()"  );
			BizLogUtil.debug(this, "      ===== Error Code :: "+IdoSqlException.getInstance(idoOut8).getErrorCode());
			return resData;
		}
		
		int cnt = 0;
		String biz_cd_list = "";
		
		// 부가가치세/종합소득세
		while (idoOut8.next()) {
			cnt++;
			JexData row = (JexData)idoOut8.get();
			
			BizLogUtil.debug(this, "====================================================");
			BizLogUtil.debug(this, "bsnn_no 			:"+bsnn_no);
			BizLogUtil.debug(this, "bsnn_no 			:"+bsnn_no);
			BizLogUtil.debug(this, "cert_name 			:"+cert_name);
			BizLogUtil.debug(this, "before_cert_name 	:"+before_cert_name);
			BizLogUtil.debug(this, "cert_org 			:"+cert_org);
			BizLogUtil.debug(this, "cert_date 			:"+cert_date);
			BizLogUtil.debug(this, "cert_pwd 			:"+cert_pwd);
			BizLogUtil.debug(this, "cert_folder 		:"+cert_folder);
			BizLogUtil.debug(this, "cert_data 			:"+cert_data);
			BizLogUtil.debug(this, "reg_type 			:"+reg_type);
			BizLogUtil.debug(this, "====================================================");
			
			// 홈택스 부가가치세/종합소득세 정보수정
			resData = CooconApi.updateEvdcTax(bsnn_no, bsnn_no, cert_name, before_cert_name, cert_org, cert_date, cert_pwd, cert_folder, cert_data, reg_type, "1");
		  
			if("00000000".equals(resData.get("ERRCODE"))){
				// 쿠콘에 해당 인증서가 등록되었기 때문에 0으로 변경
				resData.put("REG_TYPE", "0");
			}
		}

		if(cnt < 1){
			resData.put("ERRCODE", "SOER1000");
			resData.put("ERRMSG" , "변경할 증빙데이터가 없습니다.");
			return resData;
		}

		if("00000000".equals(resData.get("ERRCODE"))){
			JexData idoIn9 = util.createIDOData("EVDC_INFM_U015");
			
			idoIn9.put("USE_INTT_ID", use_intt_id);
			idoIn9.put("CERT_NM", cert_name);
			idoIn9.put("BEFORE_CERT_NAME", before_cert_name);
			
			JexData idoOut9 =  idoCon.execute(idoIn9);
			
			if (DomainUtil.isError(idoOut9)) {
				BizLogUtil.debug(this, "      ===== APP_SVC_C020 JexDomainUtil.isError()"  );
				BizLogUtil.debug(this, "      ===== Error Code :: "+IdoSqlException.getInstance(idoOut9).getErrorCode());
			}
		}
	}catch(Exception e){
		resData.put("ERRCODE", "SOER1000");
		resData.put("ERRMSG" , "데이터 처리 중 오류가 발생하였습니다. 잠시후 이용하시기 바랍니다." + e.getMessage());
	}
	return resData;
}
	
public boolean acctCardCheck(String biz_cd, String value, JSONObject list){
	
	try{
	
		JSONArray resArr = null;
		
		// 001 : 계좌, 003:카드
		if("001".equals(biz_cd)){
			resArr = (JSONArray) list.get("RESP_DATA");
			
			if(resArr == null){
				return false;
			}
		
			String acct_no = ""; 
		
			for(int i = 0 ; i < resArr.size() ; i++){
				JSONObject row = (JSONObject)resArr.get(i);
				acct_no = (String)row.get("ACCOUNT_NO");
				
				if(value.equals(acct_no)){
					return true;
				}
			}
		}
		else if("003".equals(biz_cd)){
			resArr = (JSONArray) list.get("RESP_DATA");
			
			if(resArr == null){
				return false;
			}
		
			JSONObject resSubData = (JSONObject)resArr.get(0);
			String card_no = "";
		
			for(int c=0; c<resArr.size(); c++){
				JSONArray resSubArr = (JSONArray) resSubData.get("RESP_DET");
				for(int i=0; i < resSubArr.size(); i++){
					JSONObject resCardData = (JSONObject)resSubArr.get(i);
					card_no = (String)resCardData.get("CARD_NO");
		
					if(value.equals(card_no)){
						return true;
					}
				}
			}
		}
	}catch(Exception e){
		BizLogUtil.debug(this,"acctCardCheck  Exception :: "+e.getMessage());
	}
	
	return false;
}
%>
