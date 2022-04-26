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
         * @File Title   : 계좌삭제
         * @File Name    : acct_0001_02_d001_act.jsp
         * @File path    : acct
         * @author       : kth91 (  )
         * @Description  : 계좌삭제
         * @Register Date: 20200122174740
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

        @JexDataInfo(id="acct_0001_02_d001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        JexDataCMO UserSession = SessionManager.getSession(request, response);
        String USER_ID 		= (String)UserSession.get("CUST_CI");
        String USE_INTT_ID 	= (String)UserSession.get("USE_INTT_ID");
        
        String BANK_CD 		= StringUtil.null2void(input.getString("BANK_CD")).trim();
        String IB_TYPE 		= StringUtil.null2void(input.getString("BANK_GB"));
        String ACCT_DV 		= StringUtil.null2void(input.getString("ACCT_DV"), "01");
        String BANK_TYPE 	= "";
        
		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
        idoCon.beginTransaction();
        
        JexData idoIn1 = util.createIDOData("ACCT_INFM_U007");
    
        idoIn1.put("ACCT_STTS"	, "9");
        idoIn1.put("CORR_ID"	, USER_ID);
        idoIn1.put("USE_INTT_ID", USE_INTT_ID);
        idoIn1.put("FNNC_UNQ_NO", input.getString("FNNC_UNQ_NO"));
    
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

        	// 외환은행일 경우
        	if("005".equals(BANK_CD)){
        		BANK_TYPE = "0";
        	}else{
        		BANK_TYPE = "1";
        	}
        	
        	JSONObject resData = CooconApi.deleteAcct(ACCT_DV, BANK_CD, USE_INTT_ID, input.getString("FNNC_INFM_NO"), IB_TYPE, "", BANK_TYPE);
        	
        	// 외부이력테이블에 응답 결과 이력 입력
//             ExtnTrnsHis.insert(input.getString("USE_INTT_ID"), "C", "0100_001_D", resData.getString("ERRCODE"), resData.getString("ERRMSG"));
        	
        	if("00000000".equals(resData.get("ERRCODE")) || "WSND0007".equals(resData.get("ERRCODE"))){
        		idoCon.commit();
        		result.put("RSLT_CD","00000000");
        	}else{
        		idoCon.rollback();
        		result.put("RSLT_CD",(String)resData.get("ERRCODE"));
        	}
 		}

        idoCon.endTransaction();
        
    	// 등록된 계좌 수 조회
//         JexData idoIn2 = util.createIDOData("ACCT_INFM_R012");
        
//         idoIn2.put("USE_INTT_ID", USE_INTT_ID);
        
//         JexData idoOut2 =  idoCon.execute(idoIn2);
    
//         // 도메인 에러 검증
//         if (DomainUtil.isError(idoOut2)) {
//             if (util.getLogger().isDebug())
//             {
//                 util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
//                 util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
//             }         
//         }
        
//         // 계좌가 1개도 존재 하지 않으면 계좌등록여부 값 변경
//         if("0".equals(idoOut2.getString("CNT"))){
//         	UserSession.put("ACCT_REG_YN", "N");
//         }
        
//     	// 인증서 사용여부
//         JexData idoIn3 = util.createIDOData("ACCT_INFM_R013");
        
//         idoIn3.put("USE_INTT_ID", USE_INTT_ID);
//         idoIn3.put("CERT_NM"	, input.getString("CERT_NM"));
        
//         JexData idoOut3 =  idoCon.execute(idoIn3);
    
//         // 도메인 에러 검증
//         if (DomainUtil.isError(idoOut3)) {
//             if (util.getLogger().isDebug())
//             {
//                 util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut3));
//                 util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut3));
//             }         
//         }
        
//         // 인증서가 사용하지 않을 경우
//         if("0".equals(idoOut3.getString("CNT"))){
//         	result.put("CERT_USE_YN", "N");
//         }else{
//         	result.put("CERT_USE_YN", "Y");
//         }
        
        util.setResult(result, "default");
%>