<%@page import="com.avatar.comm.BizLogUtil"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="jex.json.JSONArray"%>
<%@page import="jex.exception.JexBIZException"%>
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
         * @File Title   : 연락처 등록
         * @File Name    : APP_SVC_C026_act.jsp
         * @File path    : api
         * @author       : kth91 (  )
         * @Description  : 연락처 등록
         * @Register Date: 20200213144417
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

        @JexDataInfo(id="APP_SVC_C026", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
     	// 세션값 체크
   		JexDataCMO usersession = null;
       	try{
       		usersession   = SessionManager.getInstance().getUserSession(request, response);  		
       	}catch(Throwable e){
       		throw new JexBIZException("9999", "Session DisConnected.");
       	}
       	
       	JSONArray  cnplList = new JSONArray();
       	cnplList 			= JSONObject.fromArray(input.get("CNPL_LIST").toString());	//연락처 리스트
       	 
       	BizLogUtil.debug(this," ===== CNPL INFO ===== ");
    	BizLogUtil.debug(this,"CNPL_LIST    	::    " + cnplList.toJSONString());
    	BizLogUtil.debug(this," =====================");
    	
       	String USE_INTT_ID 	= usersession.getString("USE_INTT_ID");
       	String CUST_CI 		= usersession.getString("CUST_CI");
       	
    	// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();
       	try{
            idoCon.beginTransaction();
           	
           	JexData idoIn2 = util.createIDOData("CNPL_INFM_U001");
            idoIn2.put("USE_INTT_ID",USE_INTT_ID);
	        idoIn2.put("DEL_YN","Y");
	        idoIn2.put("CORR_ID",CUST_CI);
            JexData idoOut2 =  idoCon.execute(idoIn2);
            // 도메인 에러 검증
            if (DomainUtil.isError(idoOut2)) {
                if (util.getLogger().isDebug())
                {
                    util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
                    util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
                }
                throw new JexWebBIZException(idoOut2);
            } else {
            	for(int i = 0; i< cnplList.size(); i++){
                	JSONObject reqDatatemp = new JSONObject();
    				reqDatatemp = (JSONObject)cnplList.get(i);
    		        JexData idoIn1 = util.createIDOData("CNPL_INFM_C001");
    		    
    		        idoIn1.putAll(reqDatatemp);
    		        idoIn1.put("MEMO","");
    		        idoIn1.put("USE_INTT_ID",USE_INTT_ID);
    		        idoIn1.put("DEL_YN","N");
    		        idoIn1.put("CORR_ID",CUST_CI);
    		        idoIn1.put("REGR_ID",CUST_CI);
    		    
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
    		        
                }	
            }
            result.put("RSLT_CD" , "0000");
			result.put("RSLT_MSG" , "정상처리 되었습니다.");
			result.put("RSLT_PROC_GB" , "0");
            idoCon.commit();
       	}catch(Exception e){
			BizLogUtil.debug(this, "Exception e ::: " + e.getMessage() );
			result.put("RSLT_CD" , "SOER1000");
			result.put("RSLT_MSG" , "처리중오류가발생하였습니다.잠시후이용하시기바랍니다.");
			result.put("RSLT_PROC_GB" , "");
			idoCon.rollback();
		}
        util.setResult(result, "default");

%>