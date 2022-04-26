<%@page import="jex.util.StringUtil"%>
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
         * @File Title   : test
         * @File Name    : APP_SVC_C041_act.jsp
         * @File path    : api
         * @author       : vgkwnsxov (  )
         * @Description  : 
         * @Register Date: 20220412161704
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

        @JexDataInfo(id="APP_SVC_C041", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
        
        String emn = StringUtil.null2void(input.getString("EMN"));
        String emp_cpn = StringUtil.null2void(input.getString("EMP_CPN"));

// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
    
        JexData idoIn1 = util.createIDOData("TB_BDP_CMIE01M_20220323");
    
        idoIn1.putAll(input);
    
        JexData idoOut1 =  idoCon.execute(idoIn1);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut1)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
            }
            // 아래는 에러 처리 로직. 업무에 맞게 아래의 방법 등을 활용하여 에러처리가 가능하다.
            // 01. Throws 방식 : JCT호출에서 사용하기 편리한 방식.
            throw new JexWebBIZException(idoOut1);
            // 02. Result Type 선택 방식 : STRUTS의 형태와 같이 Result Type에 따라 분기할 페이지 선택
            // util.setResult(result,"E");
        }
    
        result.putAll(idoOut1);
        

        util.setResult(result, "default");

%>