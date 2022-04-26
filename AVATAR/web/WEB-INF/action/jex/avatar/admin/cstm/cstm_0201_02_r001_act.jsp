<%@page import="javax.servlet.jsp.tagext.DynamicAttributes"%>
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
         * @File Title   : 기능개선문의 댓글조회
         * @File Name    : cstm_0201_02_r001_act.jsp
         * @File path    : admin.cstm
         * @author       : byeolkim89 (  )
         * @Description  : 기능개선문의_댓글조회
         * @Register Date: 20200826100812
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

        @JexDataInfo(id="cstm_0201_02_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        IDODynamic dynamic_0 = new IDODynamic();
    
        JexData idoIn1 = util.createIDOData("BLBD_RPLY_HSTR_R001");
    	dynamic_0.addNotBlankParameter(input.getString("BLBD_NO"), "\n AND BLBD_NO = CAST(? AS INTEGER)");
        idoIn1.putAll(input);
    	idoIn1.put("DYNAMIC_0", dynamic_0);
        JexData idoOut1 =  idoCon.execute(idoIn1);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut1)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
            }
            throw new JexWebBIZException(idoOut1);
        }
    
        result.putAll(idoOut1);
        
        
        
    
        JexData idoIn2 = util.createIDOData("BLBD_RPLY_FILE_R001");
    	System.out.println(idoOut1.getString("RPLY_NO"));
    	dynamic_0.addNotBlankParameter(idoOut1.getString("RPLY_NO"), "\n AND RPLY_NO = CAST(? AS INTEGER)");
        idoIn2.putAll(input);
    	idoIn2.put("DYNAMIC_0", dynamic_0);
        JexDataList<JexData> idoOut2 = (JexDataList<JexData>) idoCon.executeList(idoIn2);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut2)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
            }
            throw new JexWebBIZException(idoOut2);
        }
    
        result.put("REC", idoOut2);

        

        util.setResult(result, "default");

%>