<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.comm.ApiUtil"%>
<%@page import="com.avatar.api.mgnt.CooconApi"%>
<%@page import="jex.json.JSONObject"%>
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
         * @File Title   : 여신금융협회 삭제
         * @File Name    : card_0003_01_d001_act.jsp
         * @File path    : card
         * @author       : kth91 (  )
         * @Description  : 여신금융협회 삭제
         * @Register Date: 20200128145826
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

        @JexDataInfo(id="card_0003_01_d001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        JexDataCMO userSession = SessionManager.getSession(request, response);
        
		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
     	// 트랜젝션 시작
    	idoCon.beginTransaction();
    
        JexData idoIn1 = util.createIDOData("EVDC_INFM_U004");
    
        idoIn1.put("STTS", "9");
    	idoIn1.put("CORR_ID", userSession.getString("CUST_CI"));
    	idoIn1.put("USE_INTT_ID", userSession.getString("USE_INTT_ID"));
    	idoIn1.put("EVDC_DIV_CD", "10");
    	idoIn1.put("BIZ_NO", userSession.getString("USE_INTT_ID"));
    
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
			result.put("RSLT_MSG", "카드매출 증빙정보 삭제 시 오류가 발생했습니다.");
        }else{

    		try{

    			JSONObject resData2 = CooconApi.deleteCrefia(userSession.getString("USE_INTT_ID"), userSession.getString("USE_INTT_ID"), input.getString("WEB_ID"));
    	        
    			// 외부이력테이블에 응답 결과 이력 입력
// 	            ExtnTrnsHis.insert(userSession.getString("USE_INTT_ID"), "C", "0100_004_D", resData2.getString("ERRCODE"), resData2.getString("ERRMSG"));
    			
    	        if("00000000".equals(resData2.get("ERRCODE")) || "WSND0007".equals(resData2.get("ERRCODE"))){// 성공

			        idoCon.commit();
			        
			     	// 매출신용카드등록여부 값 수정
// 					userSession.put("RCV_CARD_REG_YN", "N");
					
					result.put("RSLT_CD", "00000000");
					result.put("RSLT_MSG", "정상처리되었습니다.");
			        
    	        }else{
    	            idoCon.rollback();
    	            result.put("RSLT_CD", (String)resData2.get("ERRCODE"));
    				result.put("RSLT_MSG", ApiUtil.getCooconErroMsgStr((String)resData2.get("ERRCODE")));
    	        }
    			
    		}catch(Exception e){
    			result.put("RSLT_CD", "9999");
    			result.put("RSLT_MSG", e.getMessage());
    			util.getLogger().debug("e.getMessage()   ::"+e.getMessage());	
    		}
    	}
    
        util.setResult(result, "default");
%>