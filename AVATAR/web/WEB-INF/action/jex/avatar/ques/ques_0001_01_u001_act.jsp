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
         * @File Title   : 인텐트 사용 내역 집계
         * @File Name    : ques_0001_01_u001_act.jsp
         * @File path    : ques
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200220104507
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

        @JexDataInfo(id="ques_0001_01_u001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

     	// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        IDODynamic dynamic_0 = new IDODynamic();
        // Get Session
        JexDataCMO userSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
        String APP_ID = StringUtil.null2void(userSession.getString("APP_ID"));
        String inte_cd = StringUtil.null2void(input.getString("INTE_CD"));
        
        if (!"".equals(inte_cd)) {
			try{
				idoCon.beginTransaction();
				JexData idoIn2 = util.createIDOData("QUES_USE_SUMR_C001");
				
				idoIn2.putAll(input);
				idoIn2.put("USE_INTT_ID", USE_INTT_ID);
				idoIn2.put("INTE_CD", inte_cd);
				idoIn2.put("CORR_ID", "SYSTEM");
				idoIn2.put("REGR_ID", "SYSTEM");
				
				JexData idoOut2 = idoCon.execute(idoIn2);
				// 도메인 에러 검증
				if (DomainUtil.isError(idoOut2)) {
					if (util.getLogger().isDebug()) {
						util.getLogger().debug("Error Code   ::" + DomainUtil.getErrorCode(idoOut2));
						util.getLogger().debug("Error Message::" + DomainUtil.getErrorMessage(idoOut2));
					}
					throw new JexWebBIZException(idoOut2);
				}
				result.putAll(idoOut2);
				idoCon.commit();
				idoCon.endTransaction();
			} catch(Exception e){
				idoCon.rollback();
				idoCon.endTransaction();
				util.setResult(result, "E");
			}
			
		}
        
        String lrn_stts = "0"; 
    	
    	JexData idoIn4 = util.createIDOData("QUES_HSTR_C001");
     	idoIn4.putAll(input);
     	idoIn4.put("USE_INTT_ID", USE_INTT_ID);
     	idoIn4.put("INTE_CD", inte_cd);
     	idoIn4.put("QUES_CTT", input.getString("QUES_CTT"));
     	idoIn4.put("APP_ID", APP_ID);
     	idoIn4.put("LRN_STTS", "9");
    
        JexData idoOut4 =  idoCon.execute(idoIn4);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut4)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut4));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut4));
            }
            throw new JexWebBIZException(idoOut4);
        }
    
        result.putAll(idoOut4);
        
        util.setResult(result, "default");

%>