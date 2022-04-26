<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>
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
<%@page import="jex.util.StringUtil"%>
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 고객인텐트연결정보등록
         * @File Name    : ques_comm_02_c001_act.jsp
         * @File path    : ques
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200609171653
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

        @JexDataInfo(id="ques_comm_02_c001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        // Get Session
        JexDataCMO userSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
    
        
        try{
			idoCon.beginTransaction();
			//전체 변경
			if("ALL".equals(input.getString("MENU_DV"))){
				//get INTE_CD
				JexData idoIn2 = util.createIDOData("QUES_API_INFM_R006");
				idoIn2.put("USE_INTT_ID", USE_INTT_ID); 
				//idoIn2.put("USE_INTT_ID2", USE_INTT_ID);
				JexDataList<JexData> idoOut2 = (JexDataList<JexData>) idoCon.executeList(idoIn2);
				// 도메인 에러 검증
				if (DomainUtil.isError(idoOut2)) {
					if (util.getLogger().isDebug())
					{
						util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
						util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
					}
					throw new JexWebBIZException(idoOut2);
				}
				System.out.println("IDOOUT2 :: " + idoOut2);
				
				//delete all inte_cd 
				JexData idoIn3 = util.createIDOData("CUST_INTE_LINK_INFM_D001");
				idoIn3.put("USE_INTT_ID", USE_INTT_ID);
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
				
				while(idoOut2.next()){
					JexData inputData = idoOut2.get();
					JexData idoIn1 = util.createIDOData("CUST_INTE_LINK_INFM_C002");
					idoIn1.putAll(inputData);
					idoIn1.put("USE_INTT_ID",USE_INTT_ID);
					idoIn1.put("REGR_ID","system");
					JexData idoOut1 =  idoCon.execute(idoIn1);
					// 도메인 에러 검증
					if (DomainUtil.isError(idoOut1)) {
						if (util.getLogger().isDebug()){
							util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
							util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
							// result.put("RSLT_CD", "9999");
						}
						throw new JexWebBIZException(idoOut1);
					}
				}
				result.put("RSLT_CD", "0000");
				
			}
			//개별 변경
			else{
				IDODynamic dynamic_0 = new IDODynamic();
				
				JexData idoIn1 = util.createIDOData("CUST_INTE_LINK_INFM_C002");
			    
		        idoIn1.putAll(input);
		        idoIn1.put("USE_INTT_ID",USE_INTT_ID);
				if("ASP001".equals(input.getString("INTE_CD")) || "ASP002".equals(input.getString("INTE_CD"))){
					dynamic_0.addSQL("\n AND INTE_CD IN ('ASP001', 'ASP002')");
				} else {
					dynamic_0.addNotBlankParameter(input.getString("INTE_CD"), "\n AND INTE_CD = ?");
				}
		    	idoIn1.put("REGR_ID","system");
		    	idoIn1.put("DYNAMIC_0", dynamic_0);
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
			}
			idoCon.commit();
			idoCon.endTransaction();
		} catch(Exception e){
			idoCon.rollback();
			idoCon.endTransaction();
			if (util.getLogger().isDebug()) util.getLogger().debug("Error Code   ::"+e.getMessage());
			result.put("RSLT_CD", "9999");
			util.setResult(result, "E");
		}

        util.setResult(result, "default");

%>