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
         * @File Title   : 카드매입관리-삭제처리
         * @File Name    : card_0008_01_d001_act.jsp
         * @File path    : card
         * @author       : kth91 (  )
         * @Description  : 카드매입관리-삭제처리
         * @Register Date: 20200128170503
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

        @JexDataInfo(id="card_0008_01_d001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        JexDataCMO UserSession = SessionManager.getSession(request, response);
        String user_id 		= StringUtil.null2void(UserSession.getString("CUST_CI"));
        String use_intt_id 	= StringUtil.null2void(UserSession.getString("USE_INTT_ID"));
        String card_no 		= StringUtil.null2void(input.getString("CARD_NO"));
    	String web_id  		= StringUtil.null2void(input.getString("WEB_ID"));
    	String bank_cd 		= StringUtil.null2void(input.getString("BANK_CD").substring(5));
    	
		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
        JexData idoIn1 = util.createIDOData("CARD_INFM_R010");
    
        idoIn1.put("CARD_NO"		, card_no);
        idoIn1.put("BANK_CD"		, input.getString("BANK_CD"));
        idoIn1.put("USE_INTT_ID"	, use_intt_id);
        
        JexData idoOut1 =  idoCon.execute(idoIn1);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut1)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
            }
            result.put("RSLT_CD", (DomainUtil.getErrorCode 	(idoOut1)));
            result.put("RSLT_MSG", (DomainUtil.getErrorMessage 	(idoOut1)));
        }
		String BIZ_NO = StringUtil.null2void(idoOut1.getString("BIZ_NO"));
		idoCon.beginTransaction();
        
        // 법인카드 상태값 변경
        JexData idoIn3 = util.createIDOData("CARD_INFM_U005");
    
        idoIn3.put("CARD_STTS", "9");
        idoIn3.put("CORR_ID", user_id);
        idoIn3.put("CARD_NO", card_no);
        idoIn3.put("USE_INTT_ID", use_intt_id);
        
        JexData idoOut3 =  idoCon.execute(idoIn3);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut3)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut3));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut3));
            }
            idoCon.rollback();
            result.put("RSLT_CD", (DomainUtil.getErrorCode 	(idoOut3)));
            result.put("RSLT_MSG", (DomainUtil.getErrorMessage 	(idoOut3)));
        }


    	if("060".equals(bank_cd) || "061".equals(bank_cd) || "062".equals(bank_cd) || 
			"063".equals(bank_cd) || "064".equals(bank_cd)){ // bc 카드일경우 // 기업,대구, 부산, 경남, SC
    		bank_cd = "006";
    	}

    	// 법인카드정보삭제
    	JSONObject resData = CooconApi.deleteCorpCard(bank_cd, BIZ_NO, web_id, card_no);

    	// 외부이력테이블에 응답 결과 이력 입력
//         ExtnTrnsHis.insert(use_intt_id, "C", "0100_003_D", resData.getString("ERRCODE"), resData.getString("ERRMSG"));
		
        if("00000000".equals(resData.get("ERRCODE")) || "WSND0007".equals(resData.get("ERRCODE"))){// 성공
            idoCon.commit();
            result.put("RSLT_CD", "0000");
            result.put("RSLT_MSG", "정상처리되었습니다.");
        }else{
            idoCon.rollback();
            result.put("RSLT_CD", (String)resData.get("ERRCODE"));
            result.put("RSLT_MSG", ApiUtil.getCooconErroMsgStr((String)resData.get("ERRCODE")));
        }
                
        idoCon.endTransaction();
        
        util.setResult(result, "default");

%>