<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.AdminSessionManager"%>
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
         * @File Title   : 플랫폼회원등록
         * @File Name    : plfm_0101_02_c001_act.jsp
         * @File path    : admin.plfm
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200710100655
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

        @JexDataInfo(id="plfm_0101_02_c001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        JexDataCMO userSession = AdminSessionManager.getSession(request, response);
    
        String userId = "";
        if(userSession == null){
        	userId = "system";
        }else{
        	userId = (String)userSession.get("USE_INTT_ID");
        }
        
        String USER_ID_BASE = input.getString("USER_ID_BASE");
        String RSLT_CD = "0000";
        if("".equals(StringUtil.null2void(USER_ID_BASE))){
        	try{
            	idoCon.beginTransaction();
    	        JexData idoIn1 = util.createIDOData("PLFM_USER_INFM_C001");
    	        idoIn1.put("REGR_ID"	,userId);
    	        idoIn1.put("USER_ID"	,input.getString("USER_ID"));
    	        idoIn1.put("BIZ_NO"		,input.getString("BIZ_NO"));
    	        idoIn1.put("USER_NM"	,input.getString("USER_NM"));
    	        idoIn1.put("DEPT_NM"	,input.getString("DEPT_NM"));
    	        idoIn1.put("OFLV"		,input.getString("OFLV"));
    	        idoIn1.put("EMAL"		,input.getString("EMAL"));
    	        idoIn1.put("CLPH_NO"	,input.getString("CLPH_NO"));
    	        idoIn1.put("USE_ATHT"	,input.getString("USE_ATHT"));	
    	        idoIn1.put("USER_GB"	,input.getString("USER_GB"));
    	        idoIn1.put("STTS"		,input.getString("STTS"));
    	        JexData idoOut1 = idoCon.execute(idoIn1);
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
            } catch (Exception e){
    			e.printStackTrace();
    			RSLT_CD = "9999";
    			idoCon.rollback();
    		} finally {
    			idoCon.endTransaction();
    		}
        } else{
        	try{
            	idoCon.beginTransaction();
    	        JexData idoIn1 = util.createIDOData("PLFM_USER_INFM_U002");
    	        idoIn1.put("CORR_ID"	,userId);
    	        idoIn1.put("USER_ID"	,USER_ID_BASE);
    	        idoIn1.put("BIZ_NO"		,input.getString("BIZ_NO"));
    	        idoIn1.put("USER_NM"	,input.getString("USER_NM"));
    	        idoIn1.put("DEPT_NM"	,input.getString("DEPT_NM"));
    	        idoIn1.put("OFLV"		,input.getString("OFLV"));
    	        idoIn1.put("EMAL"		,input.getString("EMAL"));
    	        idoIn1.put("CLPH_NO"	,input.getString("CLPH_NO"));
    	        idoIn1.put("USE_ATHT"	,input.getString("USE_ATHT"));	
    	        idoIn1.put("USER_GB"	,input.getString("USER_GB"));
    	        idoIn1.put("STTS"		,input.getString("STTS"));
    	        JexData idoOut1 = idoCon.execute(idoIn1);
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
            } catch (Exception e){
    			e.printStackTrace();
    			RSLT_CD = "9999";
    			idoCon.rollback();
    		} finally {
    			idoCon.endTransaction();
    		}
        }
        
        
        result.put("RSLT_CD",RSLT_CD); 

        util.setResult(result, "default");

%>