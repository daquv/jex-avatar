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
         * @File Title   : 세무사전화연결수수정
         * @File Name    : ques_comm_01_u003_act.jsp
         * @File path    : ques
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20210805132945
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

        @JexDataInfo(id="ques_comm_01_u003", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        String RSLT_CD = "0000";
        try{
        	idoCon.beginTransaction();
        	 JexData idoIn1 = util.createIDOData("TXOF_INFM_U002");
        	    
             idoIn1.putAll(input);
         
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
             idoCon.commit();
         
        }  catch (Exception e){
			e.printStackTrace();
			RSLT_CD = "9999";
			idoCon.rollback();
		} finally {
			idoCon.endTransaction();
		}
       
        result.put("RSLT_CD", RSLT_CD);
        

        util.setResult(result, "default");

%>