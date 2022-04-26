<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.ido.IDODynamic"%>
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
         * @File Title   : 어드민 고객별결과조회 상세 목록
         * @File Name    : sstm_0201_02_r001_act.jsp
         * @File path    : admin.sstm
         * @author       : kth91 (  )
         * @Description  : 어드민 고객별결과조회 상세 목록
         * @Register Date: 20200410175616
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

        @JexDataInfo(id="sstm_0201_02_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
        IDODynamic dynamic_0 = new IDODynamic();
    	IDODynamic dynamic_1 = new IDODynamic();
    	IDODynamic dynamic_2 = new IDODynamic();
    	IDODynamic dynamic_3 = new IDODynamic();
    	IDODynamic dynamic_4 = new IDODynamic();
    	IDODynamic dynamic_5 = new IDODynamic();
    	
    	/*구분*/
    	if(!StringUtil.null2void(input.getString("DV_CD")).equals("")){
    		
    		dynamic_0.addNotBlankParameter(input.getString("DV_CD"), "\n   AND 'ACCT' = ? ");
   			dynamic_1.addNotBlankParameter(input.getString("DV_CD"), "\n   AND 'CARD' = ? ");
    		dynamic_2.addNotBlankParameter(input.getString("DV_CD"), "\n   AND 'RCV' = ? ");
    		dynamic_3.addNotBlankParameter(input.getString("DV_CD"), "\n   AND 'EVDC' = ? ");
    		dynamic_4.addNotBlankParameter(input.getString("DV_CD"), "\n   AND 'MECR' = ? ");
    		
//     		if(input.getString("DV_CD").equals("ACCT") || input.getString("DV_CD").equals("RCV")
//     				|| input.getString("DV_CD").equals("EVDC") || input.getString("DV_CD").equals("MECR")) {
//         		dynamic_2.addNotBlankParameter(input.getString("DV_CD"), "\n   AND 'CARD' = ? ");
//     		} else {
//     			if(!input.getString("CARD_KIND").equals("")) {
//         			dynamic_1.addNotBlankParameter(input.getString("CARD_KIND"), "\n   AND 'CORP' = ? ");
//             		dynamic_2.addNotBlankParameter(input.getString("CARD_KIND"), "\n   AND 'PSNL' = ? ");
//         		}	
//     		}
    	}
    	
    	/*조회상태*/
    	if(StringUtil.null2void(input.getString("STTS")).equals("0000")){
    		dynamic_0.addNotBlankParameter(input.getString("STTS"), "\n   AND HIS_LST_STTS = ? ");
    		dynamic_1.addNotBlankParameter(input.getString("STTS"), "\n   AND A.APV_HIS_LST_STTS = ? ");
    		dynamic_2.addNotBlankParameter(input.getString("STTS"), "\n   AND A.APV_HIS_LST_STTS = ? ");
    		dynamic_3.addNotBlankParameter(input.getString("STTS"), "\n   AND HIS_LST_STTS = ? ");
    		dynamic_4.addNotBlankParameter(input.getString("STTS"), "\n   AND (BUY_HIS_LST_STTS = ? ");
    		dynamic_4.addNotBlankParameter(input.getString("STTS"), "\n   AND HIS_LST_STTS = ? )");
    		dynamic_5.addNotBlankParameter(input.getString("STTS"), "\n   AND (BUY_HIS_LST_STTS = ? ");
    		dynamic_5.addNotBlankParameter(input.getString("STTS"), "\n   AND HIS_LST_STTS = ? ) ");
    		
    	}else if(StringUtil.null2void(input.getString("STTS")).equals("9999")){
    		dynamic_0.addNotBlankParameter("0000", "\n   AND HIS_LST_STTS <> ? ");
    		dynamic_1.addNotBlankParameter("0000", "\n   AND A.APV_HIS_LST_STTS <> ? ");
    		dynamic_2.addNotBlankParameter("0000", "\n   AND A.APV_HIS_LST_STTS <> ? ");
    		dynamic_3.addNotBlankParameter("0000", "\n   AND HIS_LST_STTS <> ? ");
    		dynamic_4.addNotBlankParameter("0000", "\n   AND (BUY_HIS_LST_STTS <> ? ");
    		dynamic_4.addNotBlankParameter("0000", "\n   AND HIS_LST_STTS <> ? )");
    		dynamic_5.addNotBlankParameter("0000", "\n   AND (BUY_HIS_LST_STTS <> ? ");
    		dynamic_5.addNotBlankParameter("0000", "\n   OR HIS_LST_STTS <> ? ) ");
    	}
    	
    	JexData idoIn1 = util.createIDOData("ACCT_INFM_R017");
    
        idoIn1.putAll(input);
        idoIn1.put("DYNAMIC_0", dynamic_0);
        idoIn1.put("DYNAMIC_1", dynamic_1);
        idoIn1.put("DYNAMIC_2", dynamic_2);
        idoIn1.put("DYNAMIC_3", dynamic_3);
        idoIn1.put("DYNAMIC_4", dynamic_4);
        idoIn1.put("DYNAMIC_5", dynamic_5);
        
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
       	result.put("ERR_CD", "0000");

        

        util.setResult(result, "default");

%>