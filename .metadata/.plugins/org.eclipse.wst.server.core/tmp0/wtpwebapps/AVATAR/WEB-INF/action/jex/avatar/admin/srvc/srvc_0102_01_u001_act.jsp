<%@page contentType="text/html;charset=UTF-8" %>
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
         * @File Title   : 질의 API 상태 변경
         * @File Name    : srvc_0102_01_u001_act.jsp
         * @File path    : admin.srvc
         * @author       : byeolkim89 (  )
         * @Description  : 질의 API 상태 변경
         * @Register Date: 20200923151505
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

        @JexDataInfo(id="srvc_0102_01_u001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
        
		String RSLT_CD = "0000";
// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
    	try{
    		JexDataList rec = input.getList("REC");      
    		
     		if(rec != null){
      			// IDO Connection
      			idoCon.beginTransaction();
      			
      			while(rec.next()) {
    				System.out.println(rec);
      				JexData data = rec.get();
      				
      				String API_ID = StringUtil.null2void(data.getString("API_ID"));
      				String APP_ID = StringUtil.null2void(data.getString("APP_ID"));
      						
      				JexData idoIn1 = util.createIDOData("QUES_API_INFM_U002");
      				idoIn1.put("API_ID", API_ID);
      				idoIn1.put("APP_ID", APP_ID);
      				idoIn1.put("STTS", StringUtil.null2void(data.getString("STTS")));
      				JexData idoOut1 = idoCon.execute(idoIn1);
      				//도메인 에러 검증
      				if (DomainUtil.isError(idoOut1)) {
      					if (util.getLogger().isDebug())
     					{
      						util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
     						util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
     					}
      					idoCon.rollback();
     					throw new JexWebBIZException(idoOut1);
     				}
      				RSLT_CD = "0000";
     			}
      			idoCon.commit();
     		} else {
     			RSLT_CD = "9999";
     		}
    	} catch(Exception e){
    		RSLT_CD = "9999";
    		idoCon.rollback();
    	} finally {
    		idoCon.endTransaction();
    	}
    
        result.put("RSLT_CD", RSLT_CD);
        

        util.setResult(result, "default");

%>