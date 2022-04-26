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
         * @File Title   : 데이터_계좌거래내역조회
         * @File Name    : acct_0002_01_r001_act.jsp
         * @File path    : acct
         * @author       : byeolkim89 (  )
         * @Description  : 데이터_계좌거래내역조회
         * @Register Date: 20200116175650
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

        @JexDataInfo(id="acct_0002_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        // IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        // SESSION
        JexDataCMO UserSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = (String)UserSession.get("USE_INTT_ID");
    
        IDODynamic dynamic_0= new IDODynamic();
		dynamic_0.addNotBlankParameter(input.getString("BANK_CD"), "\n AND BANK_CD = ?");
		dynamic_0.addNotBlankParameter(input.getString("FNNC_UNQ_NO"), "\n AND A.FNNC_UNQ_NO = ?");
      	//cnt
        JexData idoIn2 = util.createIDOData("ACCT_TRNS_HSTR_R002"); 
        idoIn2.putAll(input);
        idoIn2.put("USE_INTT_ID", UserSession.getString("USE_INTT_ID"));
        idoIn2.put("DYNAMIC_0", dynamic_0);
        JexData idoOut2 =  idoCon.execute(idoIn2);
        if (DomainUtil.isError(idoOut2)) {
            if (util.getLogger().isDebug()){
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
            }
            throw new JexWebBIZException(idoOut2);
        }
        result.putAll(idoOut2);
        
		// order
        dynamic_0.addSQL("\n ORDER BY TRNS_DT DESC, TRNS_SRNO DESC");
		// paging
        if(!StringUtil.isBlank(input.getString("PAGE_CNT")) && !StringUtil.isBlank(input.getString("PAGE_NO"))){
            int pageNo = Integer.parseInt(input.getString("PAGE_NO"));
    		int pageCnt = Integer.parseInt(input.getString("PAGE_CNT"));
    		int end_idx = pageCnt;
    		int str_idx = ((pageNo-1)*pageCnt);
               
            dynamic_0.addNotBlankParameter(end_idx , "\n LIMIT CAST(? AS INTEGER) ");
            dynamic_0.addNotBlankParameter(str_idx , " OFFSET CAST(? AS INTEGER) ");
        }
     
		JexData idoIn1 = util.createIDOData("ACCT_TRNS_HSTR_R001");
        idoIn1.put("USE_INTT_ID", UserSession.getString("USE_INTT_ID"));
        idoIn1.put("DYNAMIC_0",dynamic_0);
        
        
    
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