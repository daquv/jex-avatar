<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.ido.IDODynamic"%>
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
         * @File Title   : 계좌목록 조회
         * @File Name    : acct_0001_01_r001_act.jsp
         * @File path    : acct
         * @author       : kth91 (  )
         * @Description  : 계좌목록 조회
         * @Register Date: 20200116151704
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

        @JexDataInfo(id="acct_0001_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();
		//GET SESSION
		JexDataCMO UserSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = (String)UserSession.get("USE_INTT_ID");
    
		IDODynamic            dynamic       = new IDODynamic();
        
		/*					조건문						*/
//         if(!"All".equals(StringUtil.null2void(input.getString("ACTV_DV")))){
//         	dynamic.addSQL("\n AND A.ACTV_DV='"+input.getString("ACTV_DV")+"' ");
//         }
		dynamic.addSQL("\n AND ACCT_STTS IN ('0','1', '8','7')");
		dynamic.addSQL("\n AND BANK_CD='"+input.getString("BANK_CD")+"' ");
		/*					정렬							*/
        dynamic.addSQL("\n ORDER BY OTPT_SQNC");
        /*					페이징						*/
//         if(!StringUtil.isBlank(input.get("PAGE_NO")) && !StringUtil.isBlank(input.get("PAGE_SZ"))) {
//             int pageNo = (Integer.parseInt(input.getString("PAGE_NO")) - 1) * Integer.parseInt(input.getString("PAGE_SZ"));
//             dynamic.addSQL("\n OFFSET "+pageNo+" LIMIT "+input.get("PAGE_SZ")+" ");
//         }
        
        JexData idoIn1 = util.createIDOData("ACCT_INFM_R002");
    
        idoIn1.putAll(input);
        idoIn1.put("USE_INTT_ID",USE_INTT_ID);
        idoIn1.put("DYNAMIC_0",dynamic);
    
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