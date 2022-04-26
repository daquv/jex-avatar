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
         * @File Title   : 질의API정보 불러오기
         * @File Name    : srvc_0202_02_r002_act.jsp
         * @File path    : admin.srvc
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200911102241
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

        @JexDataInfo(id="srvc_0202_02_r002", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
    
        JexData idoIn1 = util.createIDOData("QUES_API_INFM_R005");
    	IDODynamic dynamic_0 = new IDODynamic();
    	
    	dynamic_0.addNotBlankParameter(input.getString("API_ID"), "\n AND API_ID = ?");
    	dynamic_0.addNotBlankParameter(input.getString("APP_ID"), "\n AND APP_ID = ?");
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
    
        result.put("REC_INFM", idoOut1);

        
        
        for(int i=0; i<3; i++){
        	JexData idoIn2 = util.createIDOData("QUES_API_DTLS_R002");
        	IDODynamic dynamic_1 = new IDODynamic();
            if(i==0){
            	dynamic_1.addSQL("\n AND FLD_DV = 'H'");
            } else if(i==1)
            	dynamic_1.addSQL("\n AND FLD_DV = 'I'");
            else if(i==2)
            	dynamic_1.addSQL("\n AND FLD_DV = 'O'");
            
            dynamic_1.addSQL("\n ORDER BY UP_FLD_ID NULLS FIRST, FLD_TYPE, FLD_ID ");
            idoIn2.putAll(input);
        	idoIn2.put("API_ID", input.getString("API_ID"));
        	idoIn2.put("DYNAMIC_0", dynamic_1);
        	//idoIn2.put("DYNAMIC_0", dynamic_0);
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
            if(i==0)
            	result.put("REC_HEADER", idoOut2);
            else if(i==1)
            	result.put("REC_INPUT", idoOut2);
            else if(i==2)
            	result.put("REC_OUTPUT", idoOut2);
            //result.put("REC_DTLS", idoOut2);
        }
        


        util.setResult(result, "default");

%>