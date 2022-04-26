<%@page import="jex.json.JSONObject"%>
<%@page import="com.avatar.api.mgnt.CooconApi"%>
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
         * @File Title   : 유료서비스 신청/해지
         * @File Name    : basic_0002_01_c001_act.jsp
         * @File path    : basic
         * @author       : jepark (  )
         * @Description  : 유료서비스 신청/해지
         * @Register Date: 20210319142412
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

        @JexDataInfo(id="basic_0002_01_c001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        JexDataCMO userSession = SessionManager.getSession(request, response);
		String use_intt_id = userSession.getString("USE_INTT_ID");
        
		// 01:은행, 02:홈택스, 03:카드, 11:온라인매출
		String evdc_gb = StringUtil.null2void(input.getString("EVDC_GB"));
		// Y:유료, N:무료
		String pay_yn = StringUtil.null2void(input.getString("PAY_YN"));
		
		String use_pric = StringUtil.null2void(input.getString("USE_PRIC"));
		
		// 001:은행, 003:법인카드, 002:현금영수증, 006:전자세금계산서, 011:sns쇼핑몰
		String biz_cd = "0"+evdc_gb;
		
		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
     	
		// 트랜젝션 시작
    	idoCon.beginTransaction();
		
		// 유료서비스 신청/해지
    	JexData idoIn1 = util.createIDOData("CUST_RT_BACH_INFM_C001");
        
        idoIn1.put("PAY_YN", pay_yn);
        idoIn1.put("USE_PRIC", use_pric);
        idoIn1.put("USE_INTT_ID", use_intt_id);
        idoIn1.put("EVDC_GB", evdc_gb);
        
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
    		result.put("RSLT_MSG", "유료서비스 신청/해지 중 오류가 발생하였습니다.");
    		util.setResult(result, "default");
			return;
        }
    
     	// 유료서비스 신청/해지 이력 등록
        JexData idoIn2 = util.createIDOData("CUST_RT_BACH_INFM_HIS_C001");
    
        idoIn2.put("USE_INTT_ID", use_intt_id);
        idoIn2.put("EVDC_GB", evdc_gb);
        idoIn2.put("PAY_YN", pay_yn);
        idoIn2.put("USE_PRIC", use_pric);
        idoIn2.put("REGR_ID", use_intt_id);
    
        JexData idoOut2 =  idoCon.execute(idoIn2);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut2)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
            }
            idoCon.rollback();
    		result.put("RSLT_CD", "SOER2000");
    		result.put("RSLT_MSG", "유료서비스 신청/해지 이력 등록 중 오류가 발생하였습니다.");
    		util.setResult(result, "default");
			return;
        }
    	
        // 아바타 유료회원 신청/해지
        JSONObject resJData = CooconApi.insertMembership(biz_cd, use_intt_id, pay_yn);
        
        //(00000000:정상, WSND0004:이미 등록된 내용이 있습니다.)
        if("00000000".equals(resJData.get("ERRCODE")) || "WSND0004".equals(resJData.get("ERRCODE"))){
        	// 홈택스일 경우 006:전자세금계산서 으로 한번 호출해야됨.
        	if(evdc_gb.equals("02")){
        		// 아바타 유료회원 신청/해지(현금영수증은 이미 날렸기 때문에 전자세금계산서만 다시 날리면 됨)
                JSONObject resJData2 = CooconApi.insertMembership("006", use_intt_id, pay_yn);
        		if("00000000".equals(resJData2.get("ERRCODE")) || "WSND0004".equals(resJData2.get("ERRCODE"))){
        			idoCon.commit();
            		idoCon.endTransaction();
            		result.put("RSLT_CD", "0000");
        			result.put("RSLT_MSG", "정상처리되었습니다.");
        			/*
        			// TODO : 납부할 세액 매시간 로직이 추가되면 주석 풀어야됨.
        			// 아바타 유료회원 신청/해지(현금영수증은,전자세금계산서 이미 날렸기 때문에 부가가치세/종합소득세만 다시 날리면 됨)
                    JSONObject resJData3 = CooconApi.insertMembership("007", use_intt_id, pay_yn);
            		if("00000000".equals(resJData3.get("ERRCODE")) || "WSND0004".equals(resJData3.get("ERRCODE"))){
            			idoCon.commit();
                		idoCon.endTransaction();
                		result.put("RSLT_CD", "0000");
            			result.put("RSLT_MSG", "정상처리되었습니다.");
            		}else{
            			idoCon.rollback();
            			idoCon.endTransaction();
            			result.put("RSLT_CD", (String)resJData3.get("ERRCODE"));
            			result.put("RSLT_MSG", (String)resJData3.get("ERRMSG"));
            		}
            		*/
        		}else{
        			idoCon.rollback();
        			idoCon.endTransaction();
        			result.put("RSLT_CD", (String)resJData2.get("ERRCODE"));
        			result.put("RSLT_MSG", (String)resJData2.get("ERRMSG"));
        		}
        	}else{
        		idoCon.commit();
        		idoCon.endTransaction();
        		result.put("RSLT_CD", "0000");
    			result.put("RSLT_MSG", "정상처리되었습니다.");
        	}
        }else{
        	idoCon.rollback();
			idoCon.endTransaction();
        	result.put("RSLT_CD", (String)resJData.get("ERRCODE"));
			result.put("RSLT_MSG", (String)resJData.get("ERRMSG"));
        }
        		
        util.setResult(result, "default");
%>