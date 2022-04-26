<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="jex.util.StringUtil"%>

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
         * @File Title   : 세부코드조회
         * @File Name    : srvc_0103_01_r002_act.jsp
         * @File path    : admin.srvc
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200310143951
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

        @JexDataInfo(id="srvc_0103_01_r002", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        IDODynamic dynamic_0 = new IDODynamic();
        if(!"".equals(StringUtil.null2void(input.getString("DSDL_GRP_CD")))){
        	dynamic_0.addNotBlankParameter(input.getString("DSDL_GRP_CD"), "\n AND DSDL_GRP_CD = ?");
        }
        if(!"".equals(StringUtil.null2void(input.getString("DSDL_ITEM_CD")))){
        	dynamic_0.addNotBlankParameter(input.getString("DSDL_ITEM_CD"), "\n AND DSDL_ITEM_CD = ?");
        }
        if(!"".equals(StringUtil.null2void(input.getString("DSDL_ITEM_NM")))){
        	dynamic_0.addNotBlankParameter(input.getString("DSDL_ITEM_NM"), "\n AND DSDL_ITEM_NM = ?");
        }
        dynamic_0.addSQL("\n AND ACVT_STTS != 'N'");
        JexData idoIn1 = util.createIDOData("DSDL_ITEM_R005");
    	dynamic_0.addSQL("\n ORDER BY OTPT_SQNC, DSDL_ITEM_CD");
        idoIn1.putAll(input);
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
    
        result.put("REC", idoOut1);

        

        util.setResult(result, "default");

%>