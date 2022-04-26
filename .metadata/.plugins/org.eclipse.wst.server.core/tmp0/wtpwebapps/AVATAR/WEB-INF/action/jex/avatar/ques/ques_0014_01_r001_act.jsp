<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="jex.util.StringUtil"%>
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
         * @File Title   : 메모정보 목록 조회
         * @File Name    : ques_0014_01_r001_act.jsp
         * @File path    : ques
         * @author       : jepark (  )
         * @Description  : 메모정보 목록 조회
         * @Register Date: 20210928140616
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

        @JexDataInfo(id="ques_0014_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
        JexDataCMO UserSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = (String)UserSession.get("USE_INTT_ID");
        IDODynamic dynamic = new IDODynamic();
        if(!"".equals(StringUtil.null2void(input.getString("NE_DAY"))) || !"".equals(StringUtil.null2void(input.getString("NE_B_YEAR"))) || !"".equals(StringUtil.null2void(input.getString("NE_B_MONTH"))) 
        		|| !"".equals(StringUtil.null2void(input.getString("NE_B_DATE"))) || !"".equals(StringUtil.null2void(input.getString("NE_DATEFROM"))) || !"".equals(StringUtil.null2void(input.getString("NE_DATETO")))){
        	//조회 시작일, 종료일 가져오기 
            JexData idoIn1 = util.createIDOData("FN_INQ_DT_R001");
            /* String NE_B_YEAR = !"".equals(StringUtil.null2void(input.getString("NE_B_YEAR")))?input.getString("NE_B_YEAR"):input.getString("NE-YEAR1"); */
            //idoIn1.put("INTE_CD", "메모인텐트");
            idoIn1.put("NE_DAY", input.getString("NE_DAY"));
            idoIn1.put("NE_B_YEAR", input.getString("NE_B_YEAR"));
            idoIn1.put("NE_B_MONTH", input.getString("NE_B_MONTH"));
            idoIn1.put("NE_B_DATE", input.getString("NE_B_DATE"));
            idoIn1.put("NE_DATEFROM", input.getString("NE_DATEFROM"));
            idoIn1.put("NE_DATETO", input.getString("NE_DATETO"));
        
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
        
            String STR_INQ_DT =  StringUtil.null2void(idoOut1.getString("FST_INQ_DT"));
            String LST_INQ_DT =  StringUtil.null2void(idoOut1.getString("LST_INQ_DT"));
            
            if(STR_INQ_DT.equals("") && !LST_INQ_DT.equals("")){
            	STR_INQ_DT = LST_INQ_DT; 
            }
        
        	// 조회 조건이 있는 경우(메모날짜)
        	if(!"".equals(STR_INQ_DT) && !"".equals(LST_INQ_DT)){
        		dynamic.addSQL("\n AND SUBSTRING(MEMO_DTM ,1, 8) BETWEEN '"+STR_INQ_DT+"' AND '"+LST_INQ_DT+"'");
        	}
        }
    	
        dynamic.addSQL("\n AND DEL_YN != 'Y'");
    	// 메모 목록 조회
        JexData idoIn2 = util.createIDOData("MEMO_INFM_R001");
    
        idoIn2.put("USE_INTT_ID", USE_INTT_ID);
        idoIn2.put("DYNAMIC_0", dynamic);
        idoIn2.put("PAGE_CNT", String.valueOf(input.getString("PAGE_CNT")));
        idoIn2.put("STR_IDX", String.valueOf(input.getString("STR_IDX")));
    
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
        
        result.put("REC", idoOut2);
    
        util.setResult(result, "default");

%>