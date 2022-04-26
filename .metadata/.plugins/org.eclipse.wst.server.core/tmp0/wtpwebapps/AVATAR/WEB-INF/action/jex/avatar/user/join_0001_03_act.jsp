<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page contentType="text/html;charset=UTF-8" %>
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
<%@page import="jex.data.loader.JexDataCreator"%>

<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 회원가입_가입완료화면
         * @File Name    : join_0001_03_act.jsp
         * @File path    : user
         * @author       : byeolkim89 (  )
         * @Description  : 회원가입_가입완료화면
         * @Register Date: 20200129100814
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

        @JexDataInfo(id="join_0001_03", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
		
     	// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();
     	
        String SEQ_NO = "";
        String CUST_NM = "";
        String CLPH_NO = "";
        String CUST_CI = input.getString("CUST_CI");
        
		JexData idoIn2 = util.createIDOData("CUST_LDGR_R015");
		
		idoIn2.put("CUST_CI", CUST_CI);
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
        
        
     	if(DomainUtil.getResultCount(idoOut2)==0){
     		//GET USE_INTT_ID
    		JexData idoIn0 = util.createIDOData("CUST_LDGR_R003");		//GET MAX NUM OF USE_INTT_ID
    		JexData idoOut0 =  idoCon.execute(idoIn0);
    		SEQ_NO = idoOut0.get("SEQ_NO").toString();
    		CUST_NM = input.getString("CUST_NM");
    		CLPH_NO = input.getString("CLPH_NO");
    		
    		JexData idoIn1 = util.createIDOData("CUST_LDGR_C001");
    		idoIn1.putAll(input);
    		idoIn1.put("USE_INTT_ID", SEQ_NO);
    		idoIn1.put("CUST_NM", CUST_NM);
    		idoIn1.put("CLPH_NO", CLPH_NO);
    		idoIn1.put("CUST_CI", CUST_CI);
    		
    		idoIn1.put("DEVICE_ID", "test123"/*input.getString("DEVICE_ID")*/);
    		idoIn1.put("CUST_GRP_CD", "A");
    		idoIn1.put("REGR_ID",""); //등록자ID
    		JexData idoOut1 =  idoCon.execute(idoIn1);
     	} else{
     		if( "9".equals(idoOut2.get(0).getString("STTS"))){
     			JexData idoIn3 = util.createIDOData("CUST_LDGR_U002");
         		idoIn3.put("CUST_CI", CUST_CI);
         		JexData idoOut3 =  idoCon.execute(idoIn3);
     		}
     		SEQ_NO = idoOut2.get(0).getString("USE_INTT_ID");
     		CUST_NM = idoOut2.get(0).getString("CUST_NM");
     		CLPH_NO = idoOut2.get(0).getString("CLPH_NO");
     	}
     	//세션 처리
		
	     SessionManager sessionMgr = SessionManager.getInstance();
	     JexDataCMO sessionCmo = JexDataCreator.createCMOData("AVATAR_SESSION");
	     sessionCmo.putAll(input);
	     sessionCmo.put("CUST_CI", CUST_CI);
	     sessionCmo.put("USE_INTT_ID", SEQ_NO);
	     sessionCmo.put("CLPH_NO", CLPH_NO);
	     sessionCmo.put("CUST_NM", CUST_NM);
	     sessionMgr.setUserSession(request, response, sessionCmo);
	     util.setResult(result, "default");
	     
        /* JexData idoIn2 = util.createIDOData("CUST_LDGR_R001");
        idoIn2.put("CUST_CI", input.getString("CUST_CI"));
        JexData idoOut2 = idoCon.execute(idoIn2);
        if (DomainUtil.isError(idoOut2)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
            }
            throw new JexWebBIZException(idoOut2);
        }
        
        //등록되지 않았거나 탈퇴상태라면 재가입처리
        if(DomainUtil.getResultCount(idoOut2) == 0 || "9".equals(idoOut2.getString("STTS"))){
        	
        } */
        	
        
		

%>