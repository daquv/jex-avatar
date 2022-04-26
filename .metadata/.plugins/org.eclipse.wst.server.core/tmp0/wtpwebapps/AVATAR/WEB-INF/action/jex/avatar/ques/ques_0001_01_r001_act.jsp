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

<%@ page import="java.util.Date"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 질의예시목록 조회
         * @File Name    : ques_0001_01_r001_act.jsp
         * @File path    : ques
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200219172952
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
        @JexDataInfo(id="ques_0001_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
     	// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
		// Get Session
        JexDataCMO userSession = SessionManager.getSession(request, response);
		String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
		String LGIN_APP = StringUtil.null2void(userSession.getString("LGIN_APP"), "AVATAR");
		String CLPH_NO = StringUtil.null2void(userSession.getString("CLPH_NO"));
		String testUser =  ",01028602673,01099994486,01038698349,01041212036,01031687616,01053013762,01073677899,01025999667,01045541465,01025396636,01012341234,01072349760";

		// new icon 표시 설정
		Calendar week = Calendar.getInstance();
		week.add(Calendar.DATE , -7);	
		String beforeWeek = new java.text.SimpleDateFormat("yyyyMMdd").format(week.getTime());
		
		if (LGIN_APP.indexOf("SERP") > -1){
			//############## 전체 질의 - 경리나라 ##############
			JexData idoIn1 = util.createIDOData("QUES_INFM_R001");
			
			// new icon 표시 설정
			idoIn1.put("REG_DTM", beforeWeek);
			
			IDODynamic dynamic_0 = new IDODynamic();
			dynamic_0.addSQL("\n AND A.CTGR_CD !='9998'");				//맞춤질의 제외
			dynamic_0.addSQL("\n AND (A.QUES_CTT IS NOT NULL AND A.QUES_CTT != '')");	//질의명 있는 것만
			dynamic_0.addSQL("\n AND A.STTS NOT IN ('8','9')");			//사용하는 질의만
			if(LGIN_APP.equals("SERP")) { //SERP 연동되어있는 질의만
				dynamic_0.addSQL("\n AND COALESCE(B.APP_ID,'') <> 'KTSERP'");
			} else {
				dynamic_0.addSQL("\n AND COALESCE(B.APP_ID, '') <> 'SERP'");
			}
			dynamic_0.addSQL("\n ORDER BY NEW_DV_SERP DESC, CTGR_CD, OTPT_SQNC");
	
			idoIn1.putAll(input);
			idoIn1.put("APP_ID", LGIN_APP);
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
			result.put("REC_SERP_TOT", idoOut1);
			
		} else if("AVATAR".equals(LGIN_APP)){
			//############## 질의 조회 순 집계_전체 ##############
// 			JexData idoIn2 = util.createIDOData("QUES_USE_SUMR_R001");
// 			IDODynamic dynamic_2 = new IDODynamic();
// 			dynamic_2.addSQL("\n AND (CASE WHEN B.CORC_DTM IS NOT NULL THEN SUBSTRING(B.CORC_DTM,1,8)>TO_CHAR(NOW()+'- 7DAYS', 'YYYYMMDD') ELSE SUBSTRING(B.REG_DTM, 1,8)>TO_CHAR(NOW()+'- 7DAYS', 'YYYYMMDD') END)"); //최근 일주일 
// 			dynamic_2.addSQL("\n AND A.CTGR_CD !='9998'");				//맞춤질의 제외
// 			dynamic_2.addSQL("\n AND A.INTE_CD NOT IN ('NNN001', 'NNN013', 'NNN017', 'NNN018')");	//제외 인텐트
// 			dynamic_2.addSQL("\n AND COALESCE(A.INTE_CD,'') != ''");	//비어있는인텐트 제외
// 			dynamic_2.addSQL("\n AND A.STTS NOT IN ('8', '9')");		//사용하는 질의만
// 			dynamic_2.addSQL("\n GROUP BY A.QUES_CTT, A.INTE_CD \n ORDER BY SUM(USE_CNT) DESC \n LIMIT 5");
			
// 			idoIn2.putAll(input);
// 			idoIn2.put("DYNAMIC_1", dynamic_2);
// 			JexDataList<JexData> idoOut2 = (JexDataList<JexData>) idoCon.executeList(idoIn2);
	
// 			// 도메인 에러 검증
// 			if (DomainUtil.isError(idoOut2)) {
// 				if (util.getLogger().isDebug())
// 				{
// 					util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
// 					util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
// 				}
// 				throw new JexWebBIZException(idoOut2);
// 			}
// 			result.put("REC_TOT_TOP", idoOut2);
			
			//############## 전체 질의 ##############
			JexData idoIn3 = util.createIDOData("QUES_INFM_R001");
			
			idoIn3.put("REG_DTM", beforeWeek);
			
			IDODynamic dynamic_3 = new IDODynamic();
			dynamic_3.addSQL("\n AND (A.QUES_CTT IS NOT NULL AND A.QUES_CTT != '')");	//질의 내역이 없을 경우 x
			dynamic_3.addSQL("\n AND A.STTS NOT IN ('8','9')");					//실제 사용
			dynamic_3.addSQL("\n AND A.CTGR_CD NOT IN ('0', '9999', '9997')");			//경리나라 질의, NNN제외, 제로페이 제외 
			if(testUser.indexOf(CLPH_NO) == -1 ){
				dynamic_3.addSQL("\n AND A.CTGR_CD NOT IN ('9998')");			//testUser만 맞춤질의 아니면 x
			}
			dynamic_3.addSQL("\n AND COALESCE(B.APP_ID, '') <> 'KTSERP' ");
			dynamic_3.addSQL("\n ORDER BY CTGR_CD, NEW_DV DESC, OTPT_SQNC");
			idoIn3.putAll(input);
			idoIn3.put("DYNAMIC_0", dynamic_3);
			
			JexDataList<JexData> idoOut3 = (JexDataList<JexData>) idoCon.executeList(idoIn3);
			// 도메인 에러 검증
			if (DomainUtil.isError(idoOut3)) {
				if (util.getLogger().isDebug())
				{
					util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut3));
					util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut3));
				}
				throw new JexWebBIZException(idoOut3);
			}
			result.put("REC_TOTAL", idoOut3);
			
			//############## 전체 질의 - 경리나라 ##############
// 			JexData idoIn4 = util.createIDOData("QUES_INFM_R001");
			
// 			// new icon 표시 설정
// 			idoIn4.put("REG_DTM", beforeWeek);
// 			IDODynamic dynamic_4 = new IDODynamic();
// 			dynamic_4.addSQL("\n AND A.STTS NOT IN ('8','9')");				//실제 사용
// 			dynamic_4.addSQL("\n AND A.CTGR_CD NOT IN ('9998')");			//맞춤질의 x
// 			dynamic_4.addSQL("\n AND (A.QUES_CTT IS NOT NULL AND A.QUES_CTT != '')");	//질의명 있는 것만
// 			dynamic_4.addSQL("\n AND B.APP_ID = 'SERP'");					//경리나라 연동된 질의만
// 			dynamic_4.addSQL("\n ORDER BY NEW_DV_SERP DESC, CTGR_CD, OTPT_SQNC");
	
// 			idoIn4.putAll(input);
// 			idoIn4.put("DYNAMIC_0", dynamic_4);
// 			JexDataList<JexData> idoOut4 = (JexDataList<JexData>) idoCon.executeList(idoIn4);
			
// 			// 도메인 에러 검증
// 			if (DomainUtil.isError(idoOut4)) {
// 				if (util.getLogger().isDebug())
// 				{
// 					util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut4));
// 					util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut4));
// 				}
// 				throw new JexWebBIZException(idoOut4);
// 			}
// 			result.put("REC_SERP_TOT", idoOut4);
		} else if("ZEROPAY".equals(LGIN_APP)){
			//############## 제로페이 질의 ##############
			JexData idoIn3 = util.createIDOData("QUES_INFM_R001");
			
			idoIn3.put("REG_DTM", beforeWeek);
			
			IDODynamic dynamic_3 = new IDODynamic();
			dynamic_3.addSQL("\n AND (A.QUES_CTT IS NOT NULL AND A.QUES_CTT != '')");	//질의 내역이 없을 경우 x
			dynamic_3.addSQL("\n AND A.STTS NOT IN ('8','9')");					//실제 사용
			dynamic_3.addSQL("\n AND A.CTGR_CD IN ('9997')");			//제로페이 
			if(testUser.indexOf(CLPH_NO) == -1 ){
				dynamic_3.addSQL("\n AND A.CTGR_CD NOT IN ('9998')");			//testUser만 맞춤질의 아니면 x
			}
			
			dynamic_3.addSQL("\n ORDER BY CTGR_CD, NEW_DV DESC, OTPT_SQNC");
			idoIn3.putAll(input);
			idoIn3.put("DYNAMIC_0", dynamic_3);
			
			JexDataList<JexData> idoOut3 = (JexDataList<JexData>) idoCon.executeList(idoIn3);
			// 도메인 에러 검증
			if (DomainUtil.isError(idoOut3)) {
				if (util.getLogger().isDebug())
				{
					util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut3));
					util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut3));
				}
				throw new JexWebBIZException(idoOut3);
			}
			result.put("REC_TOTAL", idoOut3);
		}

		util.setResult(result, "default");

%>