<%@page import="jex.data.impl.ido.IDODynamic"%>
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
         * @File Title   : 약관목록조회
         * @File Name    : APP_SVC_P040_act.jsp
         * @File path    : api
         * @author       : jepark (  )
         * @Description  : 약관목록조회
         * @Register Date: 20210311111859
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

        @JexDataInfo(id="APP_SVC_P040", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        String agrm_grp_cd = StringUtil.null2void(input.getString("AGRM_GRP_CD"));	// 약관그룹코드
        
		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
    	
        IDODynamic dynamic_0 = new IDODynamic();
     	dynamic_0.addNotBlankParameter(agrm_grp_cd,"\nAND AGRM_GRP_CD = ?");
     
		// 약관목록조회
        JexData idoIn1 = util.createIDOData("AGRM_INFM_R001");
    
        idoIn1.put("DYNAMIC_0", dynamic_0);
    
        JexDataList<JexData> idoOut1 = (JexDataList<JexData>) idoCon.executeList(idoIn1);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut1)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
            }
            throw new JexWebBIZException(idoOut1);
            
        }
        
        result.put("AGRM_GRP_CD", agrm_grp_cd);
        result.put("AGRM_LIST", idoOut1);
    
        util.setResult(result, "default");

%>