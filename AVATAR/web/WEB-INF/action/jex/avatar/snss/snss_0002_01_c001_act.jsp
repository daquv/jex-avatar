<%@page import="com.avatar.api.mgnt.BizmApiMgnt"%>
<%@page import="com.avatar.comm.BizLogUtil"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="com.avatar.comm.SvcDateUtil"%>
<%@page import="com.avatar.api.mgnt.CooconApi"%>
<%@page import="com.avatar.comm.CommUtil"%>
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
         * @File Title   : 온라인매출 계정 등록
         * @File Name    : snss_0002_01_c001_act.jsp
         * @File path    : snss
         * @author       : jepark (  )
         * @Description  : 온라인매출 계정 등록
         * @Register Date: 20210722145619
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

        @JexDataInfo(id="snss_0002_01_c001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
        
        JexDataCMO userSession = SessionManager.getSession(request, response);
        String use_intt_id 	= userSession.getString("USE_INTT_ID");
        String bsnn_no 		= userSession.getString("USE_INTT_ID");
        String user_id 		= userSession.getString("CUST_CI");
        String decryptKey 	= userSession.getString("SCQKEY");
       	String web_pwd 		= "";
       	String strToday 	= SvcDateUtil.getInstance().getDate();
       	String startMonth 	= SvcDateUtil.getInstance().getDate(-3, 'M').substring(0, 6);
       	String shop_cd 		= StringUtil.null2void(input.getString("SHOP_CD"));
       	String sub_shop_cd 	= StringUtil.null2void(input.getString("SUB_SHOP_CD"));
       	String web_id 		= StringUtil.null2void(input.getString("WEB_ID"));
       	
     	// 복호화
    	web_pwd = CommUtil.getDecrypt(decryptKey, StringUtil.null2void(input.getString("WEB_PWD")));

    	JSONObject rsltData = new JSONObject();
    	JSONObject resData = new JSONObject();
    	
    	try{

    		//쿠콘 API 호출 - 판매자 실시간 주문내역 
			rsltData = CooconApi.getSnssOrdrHstr(web_id, web_pwd, strToday, strToday, "1", "", shop_cd);
			
			String rsltCd = rsltData.getJSONObject("Common").getString("Result_cd");
	    	String rsltMsg = rsltData.getJSONObject("Common").getString("Result_mg");

	    	// 온라인매출 아이디 검증 완료
	    	if("00000000".equals(rsltCd) || "42110000".equals(rsltCd)){
				rsltCd = StringUtil.null2void(rsltData.getJSONArray("ResultList").getJSONObject(0).getJSONObject("Output").getString("ErrorCode"));
		    	rsltMsg = StringUtil.null2void(rsltData.getJSONArray("ResultList").getJSONObject(0).getJSONObject("Output").getString("ErrorMessage"));
	
		    	// 정상
		    	if("00000000".equals(rsltCd) || "42110000".equals(rsltCd)){
		       		//온라인매출 계정 등록
	    			resData = CooconApi.insertSmart(bsnn_no, shop_cd, sub_shop_cd, web_id, web_pwd, "", "", "", "", startMonth);
		       		
		       		// 쿠콘에 계정등록 성공(00000000:정상, WSND0004:이미 등록된 내용이 있습니다.)
	    			if("00000000".equals(resData.getString("ERRCODE"))
	    					||"WSND0004".equals(resData.get("ERRCODE"))){
	    				// IDO Connection
	    		        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
	    		    
	    				// 온라인매출계정 등록
	    		        JexData idoIn1 = util.createIDOData("EVDC_INFM_C003");
	    		    
	    		        idoIn1.put("USE_INTT_ID", use_intt_id);
						idoIn1.put("EVDC_DIV_CD", "40");
						idoIn1.put("BIZ_NO", bsnn_no);
						idoIn1.put("WEB_ID", web_id.replaceAll("'", "''"));
						idoIn1.put("WEB_PWD", web_pwd);
						idoIn1.put("STTS", "1");
						idoIn1.put("SHOP_CD", shop_cd);
						idoIn1.put("SUB_SHOP_CD", sub_shop_cd);
						idoIn1.put("REGR_ID", user_id);
						idoIn1.put("CORR_ID", user_id);
					
	    		        JexData idoOut1 =  idoCon.execute(idoIn1);
	    		    
	    		        // 도메인 에러 검증
	    		        if (DomainUtil.isError(idoOut1)) {
	    		            if (util.getLogger().isDebug())
	    		            {
	    		                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
	    		                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
	    		            }
	    		            result.put("RSLT_CD", "SOER1000");
							result.put("RSLT_MSG", "카드매출 증빙정보 등록 시 오류가 발생했습니다.");
	    		        }else{
	    		        	// 아바타 서버에 계정정보 등록 성공
	    		        	result.put("RSLT_CD", resData.getString("ERRCODE"));
	    		        	result.put("RSLT_MSG", resData.getString("ERRMSG"));
	    		        	
	    		        	// 고객데이터수집기준정보 조회
	    	 				JexData idoIn2 = util.createIDOData("CUST_RT_BACH_INFM_R002");
	    	            	
	    	 				idoIn2.put("USE_INTT_ID", use_intt_id);
	    	 				idoIn2.put("EVDC_GB", "11");
	    	 				
	    	                JexData idoOut2 =  idoCon.execute(idoIn2);
	    	                
	    	                if(DomainUtil.isError(idoOut2)) {
	    	 					if (util.getLogger().isDebug())
	    	 		            {
	    	 		                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
	    	 		                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
	    	 		            }
	    	 		        }
	    	                
	    	                String pay_yn = StringUtil.null2void(idoOut2.getString("PAY_YN"),"N");
	    					
	    	                // 아바타 유료회원 신청/해지(sns쇼핑몰 : 011)
	    	                JSONObject resJData = CooconApi.insertMembership("011", use_intt_id, pay_yn);
	    	                
	    	              	//(00000000:정상, WSND0004:이미 등록된 내용이 있습니다.)
	    	                if("00000000".equals(resJData.get("ERRCODE")) || "WSND0004".equals(resJData.get("ERRCODE"))){
	    	                	BizLogUtil.debug(this, "아바타 sns쇼핑몰 유료회원 신청/해지 정상처리되었습니다. (변경데이터 : "+pay_yn+")");   
	    	                }else{
	    	                	BizLogUtil.debug(this, "아바타 sns쇼핑몰 유료회원 신청/해지 중 오류가 발생하였습니다. (변경데이터 : "+pay_yn+")");
	    	                }
	    	              	
	    	              	
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
	    	                String shop_nm = "";
	    	                
	    	                if(shop_cd.equals("sellBaemin")){
	    	            		shop_nm = "배달의민족";
	    	            	}else if(shop_cd.equals("sellYogiyo")){
	    	            		shop_nm = "요기요";
	    	            	}else if(shop_cd.equals("sellCoupangeats")){
	    	            		shop_nm = "쿠팡이츠";
	    	            	}
	    	                
	    	        		// 온라인 매출 연동 알림톡 전송
	    	        		String msg = "";
	    	        		msg += "배달앱 "+shop_nm+"데이터가 아바타와 연결되었습니다.\n\n";
	    	        		msg += "이제 아바타에게 이렇게 물어보세요!\n\n";
	    	        		msg += "\"배달앱 매출은?\"\n";
	    	        		msg += "\"배달앱 정산금액은?\"";
	    	        		
	    	        		String tmplId = "askavatar_003_online";
	    	                
	    	                JSONObject button1 = new JSONObject();
	    	                button1.put("name"    			, "에스크아바타 열기");
	    	                button1.put("type"      		, "AL");
	    	                button1.put("scheme_android"    , "kakaoa51a93ebcd6f4145ad28e1fa20cfff50://kakaolink");
	    	                button1.put("scheme_ios"      	, "kakaoa51a93ebcd6f4145ad28e1fa20cfff50://kakaolink");
	    	                
	    	                BizmApiMgnt.apiJoinSendMsg(clph_no, msg, tmplId, button1);
	    	                
	    		        }
	    		    }
	    			// 쿠콘에 계정등록 오류
	    			else{
						result.put("RSLT_CD", resData.getString("ERRCODE"));
						result.put("RSLT_MSG", resData.getString("ERRMSG"));
					}
		        }
		    	else{
					result.put("RSLT_CD", rsltCd);
					result.put("RSLT_MSG", rsltMsg);
				}
	    	}else{
				result.put("RSLT_CD", rsltCd);
				result.put("RSLT_MSG", rsltMsg);
			}
	    }catch(Exception e){
			util.getLogger().debug("e.getMessage()   ::"+e.getMessage());
		}
		util.setResult(result, "default");
%>