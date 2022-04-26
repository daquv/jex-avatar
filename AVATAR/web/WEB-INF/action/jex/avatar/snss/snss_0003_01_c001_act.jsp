<%@page import="jex.util.StringUtil"%>
<%@page import="com.avatar.service.CooconRealTimeService"%>
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
         * @File Title   : 온라인매출 실시간 조회
         * @File Name    : snss_0003_01_c001_act.jsp
         * @File path    : snss
         * @author       : jepark (  )
         * @Description  : 온라인매출 실시간 조회
         * @Register Date: 20210723085231
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

        @JexDataInfo(id="snss_0003_01_c001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();


        JexDataCMO UserSession = SessionManager.getSession(request, response);
        String use_intt_id = (String)UserSession.get("USE_INTT_ID");
        String shop_cd = input.getString("SHOP_CD");
        String sub_shop_cd = input.getString("SUB_SHOP_CD");
        
    	// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
     	// 고객데이터수집기준정보 조회
		JexData idoIn1 = util.createIDOData("CUST_RT_BACH_INFM_R002");
    	
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("EVDC_GB", "11");	// sns쇼핑몰 계정구분
			
        JexData idoOut1 =  idoCon.execute(idoIn1);
        
        if(DomainUtil.isError(idoOut1)) {
			if (util.getLogger().isDebug())
	        {
	        	util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
	            util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
	        }
		}
        
        String pay_yn = StringUtil.null2void(idoOut1.getString("PAY_YN"),"N");
        
        CooconRealTimeService crs = new CooconRealTimeService();
        
	    crs.searchSnssDlvryRealTime(use_intt_id, shop_cd, sub_shop_cd, pay_yn);
	    
	    result.put("RSLT_CD", "0000");
    	result.put("RSLT_MSG", "정상처리되었습니다.");
    	util.setResult(result, "default");

%>