<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="com.avatar.session.AdminSessionManager"%>
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
<%@page import="jex.data.impl.JexDataRecordList"%>
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : ㅊ
         * @File Name    : srvc_0103_02_c001_act.jsp
         * @File path    : admin.srvc
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200311145248
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

        @JexDataInfo(id="srvc_0103_02_c001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
     	// SESSION
        JexDataCMO UserSession = AdminSessionManager.getSession(request, response);
        String USE_INTT_ID = (String)UserSession.get("USE_INTT_ID");
        
        String RSLT_CD = "0000";
        
        
        JexDataList<JexData> inputArr = new JexDataRecordList();		
        try{
        	idoCon.beginTransaction();
     
        	/* JexData idoIn0 = util.createIDOData("QUES_API_INFM_U001");
        	
        	idoIn0.putAll(input);
            //idoIn0.put("INTE_CD", input.getString("INTE_CD"));
            idoIn0.put("QUES_CTT", input.getString("QUES_CTT"));
            idoIn0.put("CTGR_CD", input.getString("CTGR_CD"));
            
            IDODynamic dynamic_0 = new IDODynamic();
            dynamic_0.addNotBlankParameter(input.getString("APP_ID"), "\n AND APP_ID = ?");
            dynamic_0.addNotBlankParameter(input.getString("API_ID"), "\n AND API_ID = ?");
            idoIn0.put("DYNAMIC_0", dynamic_0);
            JexData idoOut0 =  idoCon.execute(idoIn0);
                
    		// 도메인 에러 검증
    		if (DomainUtil.isError(idoOut0)) {
    			if (util.getLogger().isDebug())
    			{
    				util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut0));
    				util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut0));
    			}
    			throw new JexWebBIZException(idoOut0);
    		} */
    		
			JexDataList<JexData> inputRecInsert = input.getList("INSERT_REC");
        	
        	JexData idoJexData = util.createIDOData("QUES_API_DTLS_U001");
        	for(JexData jexData : inputRecInsert){
        		JexData idoIn1 = idoJexData.createNewData();
        		idoIn1.putAll(jexData);
        		//idoIn1.put("MPPG_VRBS", input.getString("MPPG_VRBS"));
        		inputArr.add(idoIn1);
        	}
        	JexDataList<JexData> idoOut1 = idoCon.executeBatch(inputArr);
        	
             // 도메인 에러 검증
             if (DomainUtil.isError(idoOut1)) {
                 if (util.getLogger().isDebug())
                 {
                     util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                     util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
                    // result.put("RSLT_CD", "9999");
                 }
                 throw new JexWebBIZException(idoOut1);
             }
        	result.put("RSLT_CD", "0000");
        	idoCon.commit();
        	idoCon.endTransaction();
         }
        catch(Exception e){
       		idoCon.rollback();
        	idoCon.endTransaction();
        	if (util.getLogger().isDebug()) util.getLogger().debug("Error Code   ::"+e.getMessage());
            result.put("RSLT_CD", "9999");
        }
        
        if(!"".equals(StringUtil.null2void(input.getString("INTE_CD_BASE")))){
        	try{
            	idoCon.beginTransaction();
            	JexData idoIn1 = util.createIDOData("INTE_INFM_U001");
            	idoIn1.putAll(input);
            	idoIn1.put("INTE_CD_BASE", input.getString("INTE_CD_BASE"));
            	idoIn1.put("CORR_ID", "SYSTEM");
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
    			
    			//표준질의 일 경우
    			/* if("2".equals(StringUtil.null2void(input.getString("RSMB_SRCH_METH")))){
    				JexData idoIn00 = util.createIDOData("INTE_RSMB_QUES_D001");
    				idoIn00.put("INTE_CD", input.getString("INTE_CD"));
    				
    				JexData idoOut00 =  idoCon.execute(idoIn00);
    		        
		            // 도메인 에러 검증
		            if (DomainUtil.isError(idoOut00)) {
		                if (util.getLogger().isDebug())
		                {
		                    util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut00));
		                    util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut00));
		                }
		                throw new JexWebBIZException(idoOut00);
		            }
		            
    				JexDataList<JexData> inputRecInsert = input.getList("INSERT_REC");
    				while(inputRecInsert.next()){
    		    		JexData modData = inputRecInsert.get();
    		    		
    		    		JexData idoIn0 = util.createIDOData("INTE_RSMB_QUES_C001");
    		    		idoIn0.put("INTE_CD", input.getString("INTE_CD"));
    		    		idoIn0.put("QUES_CTT", StringUtil.null2void(modData.getString("QUES_CTT")));
    		    		idoIn0.put("USE_INTT_ID",USE_INTT_ID);
    		    		idoIn0.put("REGR_ID", "SYSTEM");
    		    		
    		            JexData idoOut0 =  idoCon.execute(idoIn0);
    		        
    		            // 도메인 에러 검증
    		            if (DomainUtil.isError(idoOut0)) {
    		                if (util.getLogger().isDebug())
    		                {
    		                    util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut0));
    		                    util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut0));
    		                }
    		                RSLT_CD = "8888";
    		                throw new JexWebBIZException(idoOut0);
    		                
    		            }
    		        }
    			} */
    			idoCon.commit();
    			//
            	
            } catch (Exception e){
    			e.printStackTrace();
    			RSLT_CD = "9999";
    			idoCon.rollback();
    		} finally{
    			idoCon.endTransaction();
    		}
        } 
        else{
        	try{
            	idoCon.beginTransaction();
            	JexData idoIn1 = util.createIDOData("INTE_INFM_C001");
            	idoIn1.putAll(input);
            	idoIn1.put("REGR_ID", "SYSTEM");
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
    			/* if("2".equals(StringUtil.null2void(input.getString("RSMB_SRCH_METH")))){
    				JexDataList<JexData> inputRecInsert = input.getList("INSERT_REC");
    				while(inputRecInsert.next()){
    		    		JexData modData = inputRecInsert.get();
    		    		
    		    		JexData idoIn0 = util.createIDOData("INTE_RSMB_QUES_C001");
    		    		idoIn0.put("INTE_CD", input.getString("INTE_CD"));
    		    		idoIn0.put("QUES_CTT", StringUtil.null2void(modData.getString("QUES_CTT")));
    		    		idoIn0.put("USE_INTT_ID",USE_INTT_ID);
    		    		idoIn0.put("REGR_ID", "SYSTEM");
    		    		
    		            JexData idoOut0 =  idoCon.execute(idoIn0);
    		        
    		            // 도메인 에러 검증
    		            if (DomainUtil.isError(idoOut0)) {
    		                if (util.getLogger().isDebug())
    		                {
    		                    util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut0));
    		                    util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut0));
    		                }
    		                RSLT_CD = "8888";
    		                throw new JexWebBIZException(idoOut0);
    		            }
    		        }
    			} */
    			idoCon.commit();
            	
            } catch (Exception e){
    			e.printStackTrace();
    			RSLT_CD = "9999";
    			idoCon.rollback();
    		} finally{
    			idoCon.endTransaction();
    		}
        } 
        
        result.put("RSLT_CD", RSLT_CD);
		util.setResult(result, "default");
%>