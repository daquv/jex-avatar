<%@page import="jex.util.StringUtil"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.data.impl.ido.IDODynamic"%>

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
         * @File Title   : 세무사상세조회
         * @File Name    : ques_0013_01_r001_act.jsp
         * @File path    : ques
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20210803134250
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

        @JexDataInfo(id="ques_0013_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
    	
        // IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        

        IDODynamic dynamic_0 = new IDODynamic();
        JexData idoIn1 = util.createIDOData("TXOF_INFM_R003");
        //dynamic_0.addNotBlankParameter(input.getString("CHRG_NM"), "\n AND CHRG_NM = ?");
        //dynamic_0.addNotBlankParameter(input.getString("CHRG_NM"), "\n AND CHRG_NM LIKE '%'||?||'%'");
        dynamic_0.addNotBlankParameter(input.getString("CHRG_TEL_NO"), "\n AND CHRG_TEL_NO = ?");
        dynamic_0.addNotBlankParameter(input.getString("BIZ_NO"), "\n AND BIZ_NO = ?");
        dynamic_0.addNotBlankParameter(input.getString("SEQ_NO"), "\n AND SEQ_NO = CAST(? AS INTEGER)");
     
        if(!"".equals(StringUtil.null2void(input.getString("CHRG_NM")))){
        	dynamic_0.addSQL("\n AND (CHRG_NM ='"+ input.getString("CHRG_NM")+"'");
        	dynamic_0.addSQL("\n OR CHRG_NM LIKE '%'||'"+input.getString("CHRG_NM")+"'||'%')");
        	dynamic_0.addSQL("\n LIMIT 1");
        }
        idoIn1.putAll(input);
        idoIn1.put("DYNAMIC_0", dynamic_0);
        
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
     	
     	result.putAll(idoOut1);
        util.setResult(result, "default");

%>