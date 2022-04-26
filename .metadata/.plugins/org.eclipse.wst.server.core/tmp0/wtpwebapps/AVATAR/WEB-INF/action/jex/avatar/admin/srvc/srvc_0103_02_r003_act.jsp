<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.JexDataRecordList"%>

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

<%@page import="jex.json.JSONArray"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="jex.json.parser.JSONParser"%>

<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : API 정보 조회
         * @File Name    : srvc_0103_02_r003_act.jsp
         * @File path    : admin.srvc
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200603135933
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

        @JexDataInfo(id="srvc_0103_02_r003", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        IDODynamic dynamic_1 = new IDODynamic();
       
        JexData idoIn2;
        if(!"".equals(StringUtil.null2void(input.getString("APP_ID")))){
        	idoIn2 = util.createIDOData("QUES_API_INFM_R002");
	        dynamic_1.addNotBlankParameter(input.getString("APP_ID"), "\n AND T1.APP_ID = ?");
	        dynamic_1.addNotBlankParameter(input.getString("API_ID"), "\n AND T1.API_ID = ?");
        } else{
        	idoIn2 = util.createIDOData("INTE_INFM_R010");
	        dynamic_1.addNotBlankParameter(input.getString("INTE_CD"), "\n AND INTE_CD = ?");
        }
        
        idoIn2.putAll(input);
        idoIn2.put("DYNAMIC_0", dynamic_1);
        
        JexDataRecordList<JexData> idoOut2 = (JexDataRecordList<JexData>) idoCon.executeList(idoIn2);
    
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
		if(idoOut2.size() > 0){
			JSONArray jsonArr = new JSONArray();
			JSONObject jsonObj = new JSONObject();
			for(int i=0; i<idoOut2.size(); i++){
				JSONObject dataObj = new JSONObject();
				String API_ID = idoOut2.get(i).getString("API_ID");
				String APP_ID = idoOut2.get(i).getString("APP_ID");
		        for(int idx=0; idx<3; idx++){
		        	IDODynamic dynamic_0 = new IDODynamic();
		        	JexData idoIn1 = util.createIDOData("QUES_API_DTLS_R002");
		        	
		            idoIn1.putAll(input);
		            idoIn1.put("API_ID", API_ID);
		            if(idx==0){
		            	dynamic_0.addSQL("\n AND FLD_DV = 'I' AND APP_ID = '" + APP_ID + "'");
		            } else if(idx == 1){
		            	dynamic_0.addSQL("\n AND FLD_DV = 'O' AND COALESCE(UP_FLD_ID, '') ='' AND APP_ID = '" + APP_ID + "' -- AND FLD_DPTH = '1'");
		            } else if(idx == 2){
		            	dynamic_0.addSQL("\n AND FLD_DV = 'O' AND UP_FLD_ID IN (SELECT FLD_ID FROM QUES_API_DTLS) AND APP_ID = '" + APP_ID + "' --AND FLD_DPTH = '2' ");
		            }
		            dynamic_0.addSQL("\n ORDER BY FLD_DV, OTPT_SQNC");
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
		            if(idx==0){
		            	dataObj.put("REC_INPUT", idoOut1);
		            } else if(idx == 1){
		            	dataObj.put("REC_OUTPUT", idoOut1);
		            } else if(idx == 2){
		            	dataObj.put("REC_OUTPUT_REC", idoOut1);
		            }
		        }
		        jsonArr.add(dataObj);
		        jsonObj.put("RSLT", jsonArr);
			}
	        result.put("RSLT_CTT", jsonObj.toJSONString());
		}
        
        util.setResult(result, "default");

%>