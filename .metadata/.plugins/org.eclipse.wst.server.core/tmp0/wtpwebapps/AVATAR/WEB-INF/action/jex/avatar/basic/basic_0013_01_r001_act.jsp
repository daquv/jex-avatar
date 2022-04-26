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
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>

<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 질의모아보기 조회
         * @File Name    : basic_0013_01_r001_act.jsp
         * @File path    : basic
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20210730162014
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

        @JexDataInfo(id="basic_0013_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
     // Get Session
        JexDataCMO userSession = SessionManager.getSession(request, response);
		String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
		String APP_ID = StringUtil.null2void(userSession.getString("APP_ID"));
    
		IDODynamic dynamic_0 = new IDODynamic();
		// 질문 모아보기
		if("01".equals(input.getString("MENU_DV"))){
			JexData idoIn1 = util.createIDOData("QUES_HSTR_R003");
			dynamic_0.addSQL("\n AND COALESCE(A.CTGR_CD,'') !='9998'");				//맞춤질의 제외
			dynamic_0.addSQL("\n AND COALESCE(B.INTE_CD,'') NOT IN ('NNN001', 'NNN013', 'NNN017', 'NNN018')");	//해당 인텐트 제외
			dynamic_0.addSQL("\n AND COALESCE(B.INTE_CD,'') != ''");	//비어있는 인텐트는 답변x
			dynamic_0.addSQL("\n  AND CASE WHEN COALESCE(A.INTE_CD, '')!='' THEN A.STTS NOT IN ('8', '9') ELSE 1=1 END");		//사용하는 질의만
			dynamic_0.addSQL("\n AND COALESCE(VOIC_CTT, '')!=''");		//실제 발화만
			dynamic_0.addSQL("\n AND COALESCE(B.APP_ID,'') not in ('SERP','KTSERP')");				//SERP에서 발화한 질의 제외
			dynamic_0.addNotBlankParameter(USE_INTT_ID, "\n AND USE_INTT_ID = ?");
			dynamic_0.addSQL("\n ORDER BY QUES_DTM DESC");
	     // paging
	        if(!StringUtil.isBlank(input.getString("PAGE_CNT")) && !StringUtil.isBlank(input.getString("PAGE_NO"))){
	            int pageNo = Integer.parseInt(input.getString("PAGE_NO"));
	    		int pageCnt = Integer.parseInt(input.getString("PAGE_CNT"));
	    		int end_idx = pageCnt;
	    		int str_idx = ((pageNo-1)*pageCnt);
	               
	            dynamic_0.addNotBlankParameter(end_idx , "\n LIMIT CAST(? AS INTEGER) ");
	            dynamic_0.addNotBlankParameter(str_idx , " OFFSET CAST(? AS INTEGER) ");
	        }
	    	
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
	    
	        result.put("REC", idoOut1);

		} 
		// 답변 받지 못한 질문
		else if("02".equals(input.getString("MENU_DV"))){
			JexData idoIn1 = util.createIDOData("QUES_HSTR_R003");
	    	
			dynamic_0.addNotBlankParameter(USE_INTT_ID, "\n AND USE_INTT_ID = ?");
			dynamic_0.addSQL("\n AND COALESCE(B.VOIC_CTT,'')!=''");		//실제발화만
			dynamic_0.addSQL("\n AND COALESCE(B.INTE_CD,'')=''");		//비어있는인텐트만
			//dynamic_6.addSQL("\n AND COALESCE(A.APP_ID,'')!='BIZPLAY_ZEROPAY' \n AND COALESCE(A.APP_ID,'')!='KT_GIFTCARD' \n AND COALESCE(A.APP_ID,'')!='customerCount'");	//맞춤질의 제외
			dynamic_0.addSQL("\n AND COALESCE(A.CTGR_CD,'') !='9998'");				//맞춤질의 제외
			dynamic_0.addSQL("\n AND COALESCE(B.APP_ID,'') not in ('SERP','KTSERP')");				//SERP에서 발화한 질의 제외
			dynamic_0.addSQL("\n ORDER BY QUES_DTM DESC");
			
			// paging
	        if(!StringUtil.isBlank(input.getString("PAGE_CNT")) && !StringUtil.isBlank(input.getString("PAGE_NO"))){
	            int pageNo = Integer.parseInt(input.getString("PAGE_NO"));
	    		int pageCnt = Integer.parseInt(input.getString("PAGE_CNT"));
	    		int end_idx = pageCnt;
	    		int str_idx = ((pageNo-1)*pageCnt);
	               
	            dynamic_0.addNotBlankParameter(end_idx , "\n LIMIT CAST(? AS INTEGER) ");
	            dynamic_0.addNotBlankParameter(str_idx , " OFFSET CAST(? AS INTEGER) ");
	        }
			
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
	    
	        result.put("REC", idoOut1);
		}
        
        

        util.setResult(result, "default");

%>