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
         * @File Title   : 개인 맞춤 질의목록 조회
         * @File Name    : ques_0001_01_r003_act.jsp
         * @File path    : ques
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20210827140838
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

        @JexDataInfo(id="ques_0001_01_r003", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
     // IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
		// Get Session
        JexDataCMO userSession = SessionManager.getSession(request, response);
		String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
		String APP_ID = StringUtil.null2void(userSession.getString("APP_ID"), "AVATAR");
		
		// APP_ID : AVATAR, ZEROPAY일 때만
		//############## data연동 여부 확인 ##############
		JexData idoIn2 = util.createIDOData("EVDC_INFM_R011");
		idoIn2.put("USE_INTT_ID", USE_INTT_ID);
		idoIn2.put("USE_INTT_ID", USE_INTT_ID);
		idoIn2.put("USE_INTT_ID", USE_INTT_ID);
		idoIn2.put("USE_INTT_ID", USE_INTT_ID);
		idoIn2.put("USE_INTT_ID", USE_INTT_ID);
		System.out.println("@@##2");
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
        result.put("DATA_YN", idoOut2.getString("DATA_YN"));
        System.out.println("@@##3");
		
		//############## 질의 조회 순 집계_개인별 ##############
		JexData idoIn1 = util.createIDOData("QUES_HSTR_R002");
		IDODynamic dynamic_1 = new IDODynamic();
		idoIn1.putAll(input);
		idoIn1.put("USE_INTT_ID", USE_INTT_ID);
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
		
		result.put("REC_INDI_TOP", idoOut1);
		
		
		//############## 질의 조회 최신순 집계_개인별 ##############
		JexData idoIn5 = util.createIDOData("QUES_HSTR_R003");
		IDODynamic dynamic_0 = new IDODynamic();
		
		dynamic_0.addSQL("\n AND COALESCE(A.CTGR_CD,'') !='9998'");				//맞춤질의 제외
		dynamic_0.addSQL("\n AND COALESCE(B.INTE_CD,'') NOT IN ('NNN001', 'NNN013', 'NNN017', 'NNN018')");	//해당 인텐트 제외
		dynamic_0.addSQL("\n AND COALESCE(B.INTE_CD,'') != ''");	//비어있는 인텐트는 답변x
		dynamic_0.addSQL("\n AND CASE WHEN COALESCE(A.INTE_CD, '')!='' THEN A.STTS NOT IN ('8', '9') ELSE 1=1 END");		//사용하는 질의만
		//IDODynamic dynamic_5 = new IDODynamic();
		dynamic_0.addSQL("\n AND COALESCE(VOIC_CTT, '')!=''");		//실제 발화만
		dynamic_0.addSQL("\n AND COALESCE(B.APP_ID,'') not in ('SERP', 'KTSERP')");	 //SERP,KTSERP에서 발화한 질의 제외
		dynamic_0.addNotBlankParameter(USE_INTT_ID, "\n AND USE_INTT_ID = ?");
		dynamic_0.addSQL("\n ORDER BY QUES_DTM DESC");
		dynamic_0.addSQL("\n LIMIT 5");
		
		idoIn5.putAll(input);
		idoIn5.put("DYNAMIC_0", dynamic_0);
		
		JexDataList<JexData> idoOut5 = (JexDataList<JexData>) idoCon.executeList(idoIn5);
		
		// 도메인 에러 검증
		if (DomainUtil.isError(idoOut5)) {
			if (util.getLogger().isDebug())
			{
				util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut5));
				util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut5));
			}
			throw new JexWebBIZException(idoOut5);
		}
		result.put("REC_INDI_RCNT", idoOut5);
		
		
		//############## 질의 조회 (답변x)_개인별 ##############
		JexData idoIn6 = util.createIDOData("QUES_HSTR_R003");
		IDODynamic dynamic_6 = new IDODynamic();
		
		dynamic_6.addNotBlankParameter(USE_INTT_ID, "\n AND USE_INTT_ID = ?");
		dynamic_6.addSQL("\n AND COALESCE(B.VOIC_CTT,'')!=''");		//실제발화만
		dynamic_6.addSQL("\n AND COALESCE(B.INTE_CD,'')=''");		//비어있는인텐트만
		//dynamic_6.addSQL("\n AND COALESCE(A.APP_ID,'')!='BIZPLAY_ZEROPAY' \n AND COALESCE(A.APP_ID,'')!='KT_GIFTCARD' \n AND COALESCE(A.APP_ID,'')!='customerCount'");	//맞춤질의 제외
		dynamic_6.addSQL("\n AND COALESCE(A.CTGR_CD,'') !='9998'");				//맞춤질의 제외
		dynamic_6.addSQL("\n AND COALESCE(B.APP_ID,'') not in ('SERP', 'KTSERP')");				//SERP,KTSERP에서 발화한 질의 제외
		dynamic_6.addSQL("\n ORDER BY QUES_DTM DESC");
		dynamic_6.addSQL("\n LIMIT 5");
		
		idoIn6.putAll(input);
		idoIn6.put("USE_INTT_ID", USE_INTT_ID);
		idoIn6.put("DYNAMIC_0", dynamic_6);
		
		JexDataList<JexData> idoOut6 = (JexDataList<JexData>) idoCon.executeList(idoIn6);
		
		// 도메인 에러 검증
		if (DomainUtil.isError(idoOut6)) {
			if (util.getLogger().isDebug())
			{
				util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut6));
				util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut6));
			}
			throw new JexWebBIZException(idoOut6);
		}
		
		result.put("REC_INDI_UNAN", idoOut6); 
	
		
		util.setResult(result, "default");

%>