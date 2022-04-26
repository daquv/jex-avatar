<%@page import="jex.util.StringUtil"%>
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
         * @File Title   : 기관정보수정
         * @File Name    : basic_0004_01_u002_act.jsp
         * @File path    : basic
         * @author       : byeolkim89 (  )
         * @Description  : 기관정보수정
         * @Register Date: 20210107111131
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

        @JexDataInfo(id="basic_0004_01_u002", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

      //GET SESSION
    	JexDataCMO UserSession = SessionManager.getSession(request, response);
        String USE_INTT_ID 	= StringUtil.null2void((String)UserSession.get("USE_INTT_ID"));
// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        String RSLT_CD = "0000";
    	try{
    		idoCon.beginTransaction();
    		
    		JexData idoIn0 = util.createIDOData("INTT_INFM_R001");
    		
    		idoIn0.putAll(input);
    		idoIn0.put("USE_INTT_ID", USE_INTT_ID);
    		JexData idoOut0 =  idoCon.execute(idoIn0);
    		// 도메인 에러 검증
            if (DomainUtil.isError(idoOut0)) {
                if (util.getLogger().isDebug())
                {
                    util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut0));
                    util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut0));
                }
                throw new JexWebBIZException(idoOut0);
            }
    		if(!"".equals(StringUtil.null2void(idoOut0.getString("USE_INTT_ID")))){
    			// 값이 있으면 update
        		JexData idoIn1 = util.createIDOData("INTT_INFM_U001");
        	    
        		idoIn1.putAll(input);
        		idoIn1.put("USE_INTT_ID", USE_INTT_ID);
        		idoIn1.put("BSNN_NM", input.getString("BSNN_NM"));
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
    		} else {
    			// 값이 없으면 insert
        		JexData idoIn2 = util.createIDOData("INTT_INFM_C002");
        	    
        		idoIn2.putAll(input);
        		idoIn2.put("USE_INTT_ID", USE_INTT_ID);
        		idoIn2.put("BSNN_NM", input.getString("BSNN_NM"));
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
    		}
        	idoCon.commit();
        	idoCon.endTransaction();
    	} catch(Exception e){
    		idoCon.rollback();
    		idoCon.endTransaction();
    		RSLT_CD = "9999";
    	}
        
        result.put("RSLT_CD", RSLT_CD);
        

        util.setResult(result, "default");

%>