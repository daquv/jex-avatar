<%@page import="com.avatar.comm.ApiUtil"%>
<%@page import="com.avatar.api.mgnt.CooconApi"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="jex.util.StringUtil"%>
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
         * @File Title   : 홈택스 증빙설정 삭제
         * @File Name    : tax_0002_01_d001_act.jsp
         * @File path    : tax
         * @author       : kth91 (  )
         * @Description  : 홈택스 증빙설정 삭제
         * @Register Date: 20200128141839
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

        @JexDataInfo(id="tax_0002_01_d001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        JexDataCMO userSession = SessionManager.getSession(request, response);

        String cert_name = StringUtil.null2void(input.getString("CERT_NAME"));
    	String cert_pwd = "";
    	String cert_org = "";
    	String cert_date = "";
    	String cert_folder = "";
    	String certdata = "";
    	String reg_type = "0";
		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();
		
        JexData idoIn3 = util.createIDOData("EVDC_INFM_R010");
        
    	idoIn3.put("USE_INTT_ID", userSession.getString("USE_INTT_ID"));
    	idoIn3.put("EVDC_DIV_CD", input.getString("EVDC_DIV_CD1"));
    
        JexData idoOut3 =  idoCon.execute(idoIn3);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut3)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut3));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut3));
            }
        }		
        //사업자번호 조회
		String BIZ_NO = userSession.getString("USE_INTT_ID");
		
        idoCon.beginTransaction();
    
      	// 전자(세금)계산서 증빙설정정보 삭제
        JexData idoIn1 = util.createIDOData("EVDC_INFM_U004");
    
        idoIn1.put("STTS", "9");
    	idoIn1.put("CORR_ID", userSession.getString("CUST_CI"));
    	idoIn1.put("USE_INTT_ID", userSession.getString("USE_INTT_ID"));
    	idoIn1.put("EVDC_DIV_CD", input.getString("EVDC_DIV_CD1"));
    	idoIn1.put("BIZ_NO", BIZ_NO);
    
        JexData idoOut1 =  idoCon.execute(idoIn1);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut1)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
            }
            idoCon.rollback();
        }else{
    		
    		JSONObject reqData = new JSONObject();
            JSONObject resData = new JSONObject();

    		JSONObject resData2 = new JSONObject();

    		try{
//     			BIZ_NO="1078686171";
    			resData2 = CooconApi.deleteEvdcTxbl(BIZ_NO, BIZ_NO, cert_name, reg_type, "1");
    			// 외부이력테이블에 응답 결과 이력 입력
// 	            ExtnTrnsHis.insert(userSession.getString("USE_INTT_ID"), "C", "0100_006_D", resData2.getString("ERRCODE"), resData2.getString("ERRMSG"));
    			
    	        //(00000000:정상,  WSND0007:삭제되지않았습니다. <-- 없는데이타 삭제요청한경우)
    	        if("00000000".equals(resData2.get("ERRCODE")) || "WSND0007".equals(resData2.get("ERRCODE"))){
    	        	
    	        	// 현금영수증 증빙설정정보 삭제
    	        	JexData idoIn2 = util.createIDOData("EVDC_INFM_U004");
    
    	        	idoIn2.put("STTS", "9");
    	        	idoIn2.put("CORR_ID", userSession.getString("CUST_CI"));
    	        	idoIn2.put("USE_INTT_ID", userSession.getString("USE_INTT_ID"));
    	        	idoIn2.put("EVDC_DIV_CD",input.getString("EVDC_DIV_CD2"));
    	        	idoIn2.put("BIZ_NO", BIZ_NO);
    
        			JexData idoOut2 =  idoCon.execute(idoIn2);
    
			        // 도메인 에러 검증
			        if (DomainUtil.isError(idoOut2)) {
			            if (util.getLogger().isDebug())
			            {
			                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
			                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
			            }
			            idoCon.rollback();
			        }else{
//     	        	    BIZ_NO="1078686171";
    	        	    resData2 = CooconApi.deleteEvdcCash(BIZ_NO, BIZ_NO, cert_name, reg_type, "1","");
    	        	 	// 외부이력테이블에 응답 결과 이력 입력
//     		            ExtnTrnsHis.insert(userSession.getString("USE_INTT_ID"), "C", "0100_002_D", resData2.getString("ERRCODE"), resData2.getString("ERRMSG"));
    	    			
            	        // 성공
            	        if("00000000".equals(resData2.get("ERRCODE")) || "WSND0007".equals(resData2.get("ERRCODE"))){

            	            idoCon.commit();

            	            result.put("RSLT_CD", "00000000");
            	            result.put("RSLT_MSG", "정상 처리되었습니다.");
            	        }else{
            	        	result.put("RSLT_CD", (String)resData2.get("ERRCODE"));
            	        	result.put("RSLT_MSG", ApiUtil.getCooconErroMsgStr((String)resData2.get("ERRCODE")));
            	            util.setResult(result, "default");
            	            
            	            idoCon.rollback();
            	            idoCon.beginTransaction();
            	            
            	            return;
                        }
                    }
    	        }else{
    	        	result.put("RSLT_CD", (String)resData2.get("ERRCODE"));
    	        	result.put("RSLT_MSG", ApiUtil.getCooconErroMsgStr((String)resData2.get("ERRCODE")));
    	            util.setResult(result, "default");
    	            
    	            idoCon.rollback();
    	            idoCon.beginTransaction();
    	            return;
    	        }
    	        
    		}catch(Exception e){
    			result.put("RSLT_CD", "9999");
    			result.put("RSLT_MSG", e.getMessage());
    			util.getLogger().debug("e.getMessage()   ::"+e.getMessage());	
    		}
    	}
        
    	idoCon.endTransaction();
    	
    	util.setResult(result, "default");
%>