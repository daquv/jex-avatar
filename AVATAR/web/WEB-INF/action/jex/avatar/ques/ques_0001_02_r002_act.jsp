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
         * @File Title   : 전체질의리스트목록조회
         * @File Name    : ques_0001_02_r002_act.jsp
         * @File path    : ques
         * @author       : byeolkim89 (  )
         * @Description  : 전체질의리스트목록조회
         * @Register Date: 20201111130847
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

        @JexDataInfo(id="ques_0001_02_r002", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
     	// Get Session
        JexDataCMO userSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
        String testUser =  ".01028602673,01099994486,01038698349,01041212036,01031687616,01053013762,01073677899,01025999667,01045541465,01025396636,01063470367,01012341234,01072349760";
        
// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        

        IDODynamic dynamic_1 = new IDODynamic();
        if(!"".equals(StringUtil.null2void(input.getString("MENU_DV")))){
        	dynamic_1.addNotBlankParameter(input.getString("MENU_DV").toUpperCase(), "\n AND T1.APP_ID = ?");
        	dynamic_1.addSQL("\n AND T2.STTS IN ('3')");
        } else {
        	dynamic_1.addNotBlankParameter(input.getString("CTGR_CD"), "\n AND T1.CTGR_CD = ?");
        }
        if("3000".equals(StringUtil.null2void(input.getString("CTGR_CD")))){
        	dynamic_1.addSQL("\n OR (T1.INTE_CD LIKE 'SPN%')");
        	
        }
        dynamic_1.addSQL("\n AND T1.STTS NOT IN ('8','9')");
        if(testUser.indexOf(userSession.getString("CLPH_NO")) == -1 ) {
        	dynamic_1.addSQL("\n AND coalesce(T1.app_id, '') != 'BIZPLAY_ZEROPAY'");
        	dynamic_1.addSQL("\n AND coalesce(T1.api_id, '') != 'customerCount'");
        	dynamic_1.addSQL("\n AND coalesce(T1.app_id, '') != 'KT_GIFTCARD'");
        }
        dynamic_1.addSQL("\n ORDER BY NEW_DV DESC, T1.OTPT_SQNC");
        JexData idoIn1 = util.createIDOData("QUES_INFM_R001");
    	
        idoIn1.putAll(input);
        // new icon 표시 설정
        Calendar week = Calendar.getInstance();
		week.add(Calendar.DATE , -7);	
		String beforeWeek = new java.text.SimpleDateFormat("yyyyMMdd").format(week.getTime());
		
        idoIn1.put("REG_DTM", beforeWeek);
        idoIn1.put("DYNAMIC_0", dynamic_1);
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
    
        result.put("REC_TOTAL", idoOut1);


        util.setResult(result, "default");

%>