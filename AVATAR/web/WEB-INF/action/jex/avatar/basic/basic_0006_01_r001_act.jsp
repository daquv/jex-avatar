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
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 1:1 문의 내역 조회
         * @File Name    : basic_0006_01_r001_act.jsp
         * @File path    : basic
         * @author       : byeolkim89 (  )
         * @Description  : 1:1 문의 내역 조회
         * @Register Date: 20200819160637
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

        @JexDataInfo(id="basic_0006_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
     	// Get Session
        JexDataCMO userSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
        String LGIN_APP = StringUtil.null2void(userSession.getString("LGIN_APP"), "AVATAR");
        IDODynamic dynamic_0 = new IDODynamic();
    
        
		dynamic_0.addNotBlankParameter(input.getString("BLBD_DIV"), "\n AND BLBD_DIV = ?");
        //dynamic_0.addSQL(" AND BLBD_DIV = '01'");
        if("01".equals(input.getString("BLBD_DIV")))
        	dynamic_0.addNotBlankParameter(USE_INTT_ID, "\n AND REGR_ID = ?");
        dynamic_0.addSQL("\n AND COALESCE(DEL_YN, '') != 'Y'");
        if(!"".equals(input.getString("SRCH_WD"))){
        	dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND (BLBD_TITL ILIKE '%'||?||'%'");
        	dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), " OR BLBD_CTT ILIKE '%'||?||'%')");
        }
      	//	cnt -> FAQ(BLBD_DIV : 03)만 적용
      	if("03".equals(input.getString("BLBD_DIV"))){
      		
      	// 로그인APP에 따라 채널조건 추가
            if("AVATAR".equals(LGIN_APP)) {
            	dynamic_0.addNotBlankParameter("01", "\n AND BLBD_CHNL IN ('00', ?)");
            } 
            else if ("SERP".equals(LGIN_APP)) {
            	dynamic_0.addNotBlankParameter("02", "\n AND BLBD_CHNL IN ('00', ?)");
            }
            else if ("ZEROPAY".equals(LGIN_APP)) {
            	dynamic_0.addNotBlankParameter("03", "\n AND BLBD_CHNL IN ('00', ?)");
            }
            else if ("KTSERP".equals(LGIN_APP)) {
            	dynamic_0.addNotBlankParameter("04", "\n AND BLBD_CHNL IN ('00', ?)");
            }
      	
      		JexData idoIn2 = util.createIDOData("BLBD_HSTR_R005"); 
            idoIn2.putAll(input);
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
      		dynamic_0.addSQL("\n ORDER BY BLBD_CTGR_CD");
      	} else {
        	dynamic_0.addSQL("\n ORDER BY BLBD_NO DESC");
      	}
      	
        
     	// paging
        if(!StringUtil.isBlank(input.getString("PAGE_CNT")) && !StringUtil.isBlank(input.getString("PAGE_NO"))){
            int pageNo = Integer.parseInt(input.getString("PAGE_NO"));
    		int pageCnt = Integer.parseInt(input.getString("PAGE_CNT"));
    		int end_idx = pageCnt;
    		int str_idx = ((pageNo-1)*pageCnt);
               
            dynamic_0.addNotBlankParameter(end_idx , "\n LIMIT CAST(? AS INTEGER) ");
            dynamic_0.addNotBlankParameter(str_idx , " OFFSET CAST(? AS INTEGER) ");
        }
        JexData idoIn1 = util.createIDOData("BLBD_HSTR_R001");
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