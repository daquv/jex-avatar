<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
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

<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 인텐트 유사단어 조회
         * @File Name    : ques_comm_01_r004_act.jsp
         * @File path    : ques
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200623100741
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

        @JexDataInfo(id="ques_comm_01_r004", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
        
        JexDataCMO userSession = SessionManager.getSession(request, response);
        String LGIN_APP = StringUtil.null2void(userSession.getString("LGIN_APP"), "AVATAR");
        

        IDODynamic dynamic_0 = new IDODynamic();
        //dynamic_0.addNotBlankParameter(input.getString("VOIC_LIST"),"\n AND QUES_CTT ~ '[?']");
		/*
        if(!StringUtil.isBlank(input.getString("VOCA_LIST"))){
			String voca[] = input.getString("VOCA_LIST").split(",");
			// QUES_CTT ~ '[카드,잔고]'
			dynamic_0.addSQL("\n AND ((");
			for(int i=0 ; i<voca.length; i++){
				String vocaSql = "OR QUES_CTT LIKE '%'||?||'%'";
				if(i==0){
					vocaSql = "QUES_CTT LIKE '%'||?||'%'";
				}
				dynamic_0.addNotBlankParameter(voca[i], vocaSql);
				
			}
			dynamic_0.addSQL(")");
		}
        if(!StringUtil.isBlank(input.getString("VOCA_LIST"))){
			String voca[] = input.getString("VOCA_LIST").split(",");
			// QUES_CTT ~ '[카드,잔고]'
			dynamic_0.addSQL("\n OR (");
			for(int i=0 ; i<voca.length; i++){
				String vocaSql = "OR RSMB_SRCH_TXT LIKE '%'||?||'%'";
				if(i==0){
					vocaSql = "RSMB_SRCH_TXT LIKE '%'||?||'%'";
				}
				dynamic_0.addNotBlankParameter(voca[i], vocaSql);
				
			}
			dynamic_0.addSQL("))");
		}
        */
        if(!StringUtil.isBlank(input.getString("VOCA_LIST"))){
			String voca[] = input.getString("VOCA_LIST").split(",");
			// QUES_CTT ~ '[카드,잔고]'
			dynamic_0.addSQL("\n AND (");
			for(int i=0 ; i<voca.length; i++){
				String vocaSql = "OR QUES_CTT LIKE '%'||?||'%'";
				String vocaSql2 = "OR RSMB_SRCH_TXT LIKE '%'||?||'%'";
				if(i==0){
					vocaSql = "QUES_CTT LIKE '%'||?||'%'";
					vocaSql2 = "OR RSMB_SRCH_TXT LIKE '%'||?||'%'";
				}
				dynamic_0.addNotBlankParameter(voca[i], vocaSql);
				dynamic_0.addNotBlankParameter(voca[i], vocaSql2);
				
			}
			dynamic_0.addSQL(")");
		}
        dynamic_0.addSQL("\n AND STTS NOT IN ('8', '9')");
        dynamic_0.addSQL("\n AND CTGR_CD NOT IN ('9999', '9998')");
        dynamic_0.addNotBlankParameter(LGIN_APP, "\n AND EXISTS (SELECT * FROM APP_USE_INTE WHERE APP_USE_INTE.INTE_CD = INTE_INFM.INTE_CD AND APP_USE_INTE.APP_ID = ?)");

// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
    
        JexData idoIn1 = util.createIDOData("INTE_INFM_R007");
    
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

        

        util.setResult(result, "default");

%>