<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.ido.IDODynamic"%>

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
<%@page import="com.avatar.session.AdminSessionManager"%>

<%@page import="java.io.File"%>
<%@page import="jex.sys.JexSystemConfig"%>
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 기능개선문의 답변 등록
         * @File Name    : cstm_0202_01_c001_act.jsp
         * @File path    : admin.cstm
         * @author       : byeolkim89 (  )
         * @Description  : 기능개선문의 답변 등록
         * @Register Date: 20200825090300
         * </pre>
         *
         * ============================================================
         * 참조
         * ============================================================
         * 본 Action을 사용하는 View에서는 해당 도메인을 import하고.
         * 응답 도메인에 대한 객체를 아래와 같이 생성하여야 합니다.
         *
         **/
		//파일 번호 :                                                                
        WebCommonUtil   util    = WebCommonUtil.getInstace(request, response);
		
        @JexDataInfo(id="cstm_0202_01_c001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
     // Get Session
        JexDataCMO userSession = AdminSessionManager.getSession(request, response);
        String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
        String USER_NM = StringUtil.null2void(userSession.getString("USER_NM"));
        System.out.println(USER_NM);
        String RSLT_CD = "0000";
        String RPLY_NO = "";
        try{
    		idoCon.beginTransaction();
    		if("true".equals(input.getString("MENU_DV"))){		//등록
    			//채번
    			JexData idoIn1 = util.createIDOData("BLBD_RPLY_HSTR_R002");
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
        		
        		result.putAll(idoOut1);
                RPLY_NO = idoOut1.getString("RPLY_NO");
        		//등록
        		JexData idoIn2 = util.createIDOData("BLBD_RPLY_HSTR_C001");
        	    
        		idoIn2.putAll(input);
        		idoIn2.put("BLBD_DIV"	, input.getString("BLBD_DIV"));
        		idoIn2.put("BLBD_NO"	, input.getString("BLBD_NO"));
        		idoIn2.put("RPLY_NO"	, Integer.parseInt(RPLY_NO));
        		idoIn2.put("RPLY_CTT"	, input.getString("RPLY_CTT"));
        		idoIn2.put("FILE_YN"	, input.getString("FILE_YN"));
        		idoIn2.put("REGR_ID"	, USE_INTT_ID);
        		idoIn2.put("REGR_NM"		, USER_NM);
            	
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
    		else if("false".equals(input.getString("MENU_DV"))){		//수정
    			RPLY_NO = input.getString("RPLY_NO");
    			//수정
				JexData idoIn2 = util.createIDOData("BLBD_RPLY_HSTR_U001");
        	    
        		idoIn2.putAll(input);
        		idoIn2.put("BLBD_NO"	, input.getString("BLBD_NO"));
        		idoIn2.put("RPLY_NO"	, RPLY_NO);
        		idoIn2.put("RPLY_CTT"	, input.getString("RPLY_CTT"));
        		idoIn2.put("FILE_YN"	, input.getString("FILE_YN"));
        		idoIn2.put("REGR_ID"	, USE_INTT_ID);
        		idoIn2.put("REGR_NM"	, USER_NM);
            	
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
            
            System.out.println("RPLY_NO >> "+RPLY_NO);
            JexDataList<JexData> inputRecInsert = input.getRecord("INSERT_REC");
            if(inputRecInsert.hasNext()){
            	//tmp 폴더 삭제
            	/* 01 : img
            	   02 : blbd
            	*/
            	String Filedir = "";
            	if("01".equals(input.getString("BLBD_DIV"))){
            		Filedir = "img";
            	} else if("02".equals(input.getString("BLBD_DIV"))){
            		Filedir = "blbd";
            	}
            	delete(Filedir);
            }
            
        	 // 게시글 답변 첨부파일 일괄삭제
	        JexData idoIn2 = util.createIDOData("BLBD_RPLY_FILE_D001");
	    
	        idoIn2.putAll(input);
	    	idoIn2.put("BLBD_NO",  Long.parseLong(input.getString("BLBD_NO")));
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
	    
	        result.putAll(idoOut2);
			while(inputRecInsert.next()){
				JexData idoIn4 = util.createIDOData("BLBD_RPLY_FILE_R002");
				JexData idoOut4 =  idoCon.execute(idoIn4);
				// 도메인 에러 검증
				if (DomainUtil.isError(idoOut4)) {
					if (util.getLogger().isDebug()){
						util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut4));
						util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut4));
						// result.put("RSLT_CD", "9999");
					}
					throw new JexWebBIZException(idoOut4);
				}
				
				JexData inputData = inputRecInsert.get(); 
				JexData idoIn3 = util.createIDOData("BLBD_RPLY_FILE_C001");
				idoIn3.putAll(inputData);
				idoIn3.put("RPLY_NO"	, RPLY_NO);
				idoIn3.put("FILE_NO"	, idoOut4.get("FILE_NO"));
				JexData idoOut3 =  idoCon.execute(idoIn3);
				// 도메인 에러 검증
				if (DomainUtil.isError(idoOut3)) {
					if (util.getLogger().isDebug()){
						util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut3));
						util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut3));
					}
					throw new JexWebBIZException(idoOut3);
				}
			}
			
			JexData idoIn5 = util.createIDOData("BLBD_HSTR_U001");
			IDODynamic dynamic_0 = new IDODynamic();
			dynamic_0.addNotBlankParameter(input.getString("BLBD_NO"), "\n AND BLBD_NO = CAST(? AS INTEGER)");
			idoIn5.put("STTS",input.getString("STTS"));
			idoIn5.put("DYNAMIC_0", dynamic_0);
			JexData idoOut5 =  idoCon.execute(idoIn5);
			// 도메인 에러 검증
			if (DomainUtil.isError(idoOut5)) {
				if (util.getLogger().isDebug()){
					util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut5));
					util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut5));
				}
				throw new JexWebBIZException(idoOut5);
			}
			idoCon.commit();
        
    	} catch (Exception e) {
			e.printStackTrace();
			RSLT_CD = "9999";
			idoCon.rollback();
		} finally {
			idoCon.endTransaction();
		}
		result.put("RSLT_CD", RSLT_CD);
        

        util.setResult(result, "default");
%>
<%!
private void delete(String Filedir) {
	
	String path = JexSystemConfig.get("FileStorage", "path")+Filedir+"_tmp";
	System.out.println("save_delete :: "+path);
	File folder = new File(path);
	try {
		while(folder.exists()) {
			File[] folder_list = folder.listFiles(); //파일리스트 얻어오기
			for (int j = 0; j < folder_list.length; j++) {
				folder_list[j].delete(); //파일 삭제 
				//System.out.println("파일이 삭제되었습니다.");
			}
			if(folder_list.length == 0 && folder.isDirectory()){ 
				folder.delete(); //대상폴더 삭제
				System.out.println("폴더가 삭제되었습니다.");
			}
		}
	} catch (Exception e) {
		e.getStackTrace();
	}
}

%>
