<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="jex.json.JSONArray"%>
<%@page import="jex.json.JSONObject"%>
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
         * @File Title   : 등록된 인증서 연결 정보 조회
         * @File Name    : acct_0001_02_r002_act.jsp
         * @File path    : acct
         * @author       : kth91 (  )
         * @Description  : 등록된 인증서 연결 정보 조회
         * @Register Date: 20200206131715
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

        @JexDataInfo(id="acct_0001_02_r002", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
        //GET SESSTION
        JexDataCMO userSession = SessionManager.getSession(request, response);
        String use_intt_id = userSession.getString("USE_INTT_ID");
        
        String certNm = StringUtil.null2void(input.getString("CERT_NM"));
	    // IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();
		
	    //교체하는 계좌의 은행 우선정렬
		IDODynamic dynamic_0 = new IDODynamic();
		dynamic_0.addSQL("\n GROUP BY USE_INTT_ID, BANK_CD");
        if(!"".equals(StringUtil.null2void(input.getString("BANK_CD"))) && !"HOMETAX".equals(StringUtil.null2void(input.getString("BANK_CD")))){
			dynamic_0.addSQL("\n ORDER BY BANK_CD='"+input.getString("BANK_CD")+"' DESC");
		}
	    
        JSONArray bizList = new JSONArray();
    	try{
    		JexData idoIn1 = util.createIDOData("ACCT_INFM_R016");
    	    
    		idoIn1.put("USE_INTT_ID", use_intt_id);
    		idoIn1.put("CERT_NM", certNm);
    		idoIn1.put("DYNAMIC_0", dynamic_0);
    		
    	    JexDataList<JexData> idoOut1 = (JexDataList<JexData>) idoCon.executeList(idoIn1);

    	    // 도메인 에러 검증
    	    if (DomainUtil.isError(idoOut1)) {
    	        if (util.getLogger().isDebug())
    	        {
    	            util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
    	            util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
    	        }
    	    }
    	    
    	    JSONObject bizRowAcct = new JSONObject();
    		JSONArray orgListAcct = new JSONArray();
    		
    		String biz_cd_acct = "";
    		String biz_nm_acct = "";
    		int cntAcct = 0;

    	    while(idoOut1.next()){
    	    	JexData acctRow = idoOut1.get();
    	    	
    	    	biz_cd_acct = acctRow.getString("BIZ_CD");
    	    	biz_nm_acct = acctRow.getString("BIZ_NM");
    	        
    	    	JSONObject ogrRow = new JSONObject();
    	        ogrRow.put("ORG_CD", acctRow.getString("ORG_CD"));
    	        ogrRow.put("ORG_NM", acctRow.getString("ORG_NM"));
    	        orgListAcct.add(ogrRow);
    	        cntAcct++;   
    	    }
    	    
    	    if(cntAcct>0){
    	    	bizRowAcct.put("BIZ_CD", biz_cd_acct);
    	    	bizRowAcct.put("BIZ_NM", biz_nm_acct);
    	    	bizRowAcct.put("ORG_REC", orgListAcct);
    	    }	
    	    
    	    JexData idoIn3 = util.createIDOData("EVDC_INFM_R007");
    	    
            idoIn3.put("USE_INTT_ID", use_intt_id);
            idoIn3.put("CERT_NM", certNm);
        
            JexDataList<JexData> idoOut3 = (JexDataList<JexData>) idoCon.executeList(idoIn3);
        
            // 도메인 에러 검증
            if (DomainUtil.isError(idoOut3)) {
                if (util.getLogger().isDebug())
                {
                    util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut3));
                    util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut3));
                }
            }
            
            JSONObject bizRowEvdc = new JSONObject();
        	JSONArray orgListEvdc = new JSONArray();

        	JSONObject bizRowTax = new JSONObject();
        	JSONArray orgListTax = new JSONArray();
        	
        	String biz_cd_evdc = "";
        	String biz_nm_evdc = "";
        	String biz_cd_tax = "";
        	String biz_nm_tax = "";
        	int cntEvdc = 0;
        	int cntTax = 0;

            while(idoOut3.next()){
            	JexData evdcRow = idoOut3.get();
            	if(evdcRow.getString("BIZ_CD").equals("002")){
	            	biz_cd_evdc = evdcRow.getString("BIZ_CD");
	            	biz_nm_evdc = evdcRow.getString("BIZ_NM");
	                
	            	JSONObject ogrRow = new JSONObject();
	                ogrRow.put("ORG_CD", evdcRow.getString("ORG_CD"));
	                ogrRow.put("ORG_NM", evdcRow.getString("ORG_NM"));
	                orgListEvdc.add(ogrRow);
	                cntEvdc++;   
            	}else{
            		biz_cd_tax = evdcRow.getString("BIZ_CD");
	            	biz_nm_tax = evdcRow.getString("BIZ_NM");
	                
	            	JSONObject ogrRow = new JSONObject();
	                ogrRow.put("ORG_CD", evdcRow.getString("ORG_CD"));
	                ogrRow.put("ORG_NM", evdcRow.getString("ORG_NM"));
	                orgListTax.add(ogrRow);
	                cntTax++;   
            	}
                
            }
    	
            if(cntEvdc>0){
            	bizRowEvdc.put("BIZ_CD", biz_cd_evdc);
            	bizRowEvdc.put("BIZ_NM", biz_nm_evdc);
            	bizRowEvdc.put("ORG_REC", orgListEvdc);
            }
            
            if(cntTax>0){
            	bizRowTax.put("BIZ_CD", biz_cd_tax);
            	bizRowTax.put("BIZ_NM", biz_nm_tax);
            	bizRowTax.put("ORG_REC", orgListTax);
            }
            
            //홈텍스에서 만드는 경우 홈텍스 우선, 계좌면 계좌 우선..
            if("HOMETAX".equals(StringUtil.null2void(input.getString("BANK_CD")))){
            	if(cntEvdc>0){
            		bizList.add(bizRowEvdc);
            	}
            	if(cntTax>0){
            		bizList.add(bizRowTax);
            	}
            	if(cntAcct>0){
            		bizList.add(bizRowAcct);   
            	}
            } else {
            	bizList.add(bizRowAcct);
            	if(cntEvdc>0){
            		bizList.add(bizRowEvdc);   
            	}
            }
    	} catch(Exception e){
        	BizLogUtil.error(this, "getBizlist Err", e);
    	} finally {}
        result.put("BIZ_REC", bizList);
        util.setResult(result, "default");

%>