<%@page import="com.avatar.session.AdminSessionManager"%>
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
         * @File Title   : 어드민 세부코드 등록
         * @File Name    : sstm_0102_03_c001_act.jsp
         * @File path    : admin.sstm
         * @author       : kth91 (  )
         * @Description  : 어드민 세부코드 등록
         * @Register Date: 20200309103610
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

        @JexDataInfo(id="sstm_0102_03_c001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
    
		JexDataCMO UserSession = AdminSessionManager.getSession(request, response);
        
        String regrId = "";
        if(UserSession == null){
        	regrId = "TEST";
        }else{
        	regrId = (String)UserSession.get("USER_ID");	
        }
    
        JexData idoIn1 = util.createIDOData("DSDL_ITEM_R004");
    	
        idoIn1.put("DSDL_GRP_CD", input.getString("DSDL_GRP_CD"));
        idoIn1.put("DSDL_ITEM_CD", input.getString("DSDL_ITEM_CD"));
       
    	
        JexData idoOut1 = idoCon.execute(idoIn1);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut1)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
            }
            
            throw new JexWebBIZException(idoOut1);
           
        }
    
        int has_record = Integer.parseInt(idoOut1.getString("CNT"));
        if(has_record >= 1){
        	result.put("ERR_CD", "9999"); // Dupliate Item
        	util.setResult(result, "default");
        	return;
        }
        
        
    
        JexData idoIn2 = util.createIDOData("DSDL_ITEM_C001");
    
        idoIn2.putAll(input);
        idoIn2.put("REG_USER_ID" , regrId);
    
        JexData idoOut2 =  idoCon.execute(idoIn2);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut2)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
            }
            
            throw new JexWebBIZException(idoOut2);
           
        }
    
    
        
        result.put("ERR_CD", "0000"); // Dupliate Item
        util.setResult(result, "default");


%>