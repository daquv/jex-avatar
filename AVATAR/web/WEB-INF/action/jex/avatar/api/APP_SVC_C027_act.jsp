<%@page import="com.avatar.comm.BizLogUtil"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="jex.json.JSONArray"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="jex.exception.JexBIZException"%>
<%@page import="jex.json.parser.JSONParser"%>
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
<%@page import="java.net.URLDecoder" %>
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 질의내역 등록
         * @File Name    : APP_SVC_C027_act.jsp
         * @File path    : api
         * @author       : byeolkim89 (  )
         * @Description  : 질의내역 등록
         * @Register Date: 20200424144659
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

        @JexDataInfo(id="APP_SVC_C027", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

     	// 세션값 체크
   		JexDataCMO usersession = null;
       	try{
       		usersession   = SessionManager.getInstance().getUserSession(request, response);  		
       	}catch(Throwable e){
       		throw new JexBIZException("9999", "Session DisConnected.");
       	}
       	
       	//CHARACTER
       	String VOIC_DATA = input.getString("VOIC_DATA");
       	BizLogUtil.debug(this," ===== VOICE INFO ===== ");
    	BizLogUtil.debug(this,"VOIC_DATA    	::    " + VOIC_DATA);
    	//BizLogUtil.debug(this,"DECODED VOIC_DATA    	::    " + URLDecoder.decode(VOIC_DATA));
    	BizLogUtil.debug(this," =====================");
    	//encoding 적용 시 아래 소스 사용
    	JSONObject inteInfo = (JSONObject)JSONParser.parser(StringUtil.null2void(URLDecoder.decode(VOIC_DATA)));
    	//JSONObject inteInfo = (JSONObject)JSONParser.parser(StringUtil.null2void(VOIC_DATA));
    	String INTE_CD = "";
    	if(StringUtil.null2void(inteInfo.getString("recog_data")) == ""){
    		INTE_CD = "";
    	} else{
	    	JSONObject jsonObj = (JSONObject)inteInfo.get("recog_data");
       		INTE_CD = StringUtil.null2void((String)jsonObj.get("Intent"));
    	}
       	String USE_INTT_ID 	= usersession.getString("USE_INTT_ID");
       	String APP_ID 	= usersession.getString("LGIN_APP");
       	String QUES_CTT = StringUtil.null2void((String)inteInfo.get("recog_txt"));
       	
		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        try{
        	idoCon.beginTransaction();
        	
        	String LRN_STTS = "0"; 
        	/* // 인텐트가 없는 경우 
        	if (!"".equals(INTE_CD)) {
        		// 학습미처리
        		LRN_STTS = "9";
        	} */
        	JexData idoIn1 = util.createIDOData("QUES_HSTR_C001");
        	idoIn1.put("USE_INTT_ID", USE_INTT_ID);
        	idoIn1.put("VOIC_DATA", inteInfo);
        	idoIn1.put("INTE_CD", INTE_CD);
        	idoIn1.put("QUES_CTT", QUES_CTT);
        	idoIn1.put("VOIC_CTT", QUES_CTT);
        	idoIn1.put("APP_ID", APP_ID);
        	idoIn1.put("LRN_STTS", "9");
        	JexData idoOut1 = idoCon.execute(idoIn1);
        	// 도메인 에러 검증
            if (DomainUtil.isError(idoOut1)) {
                if (util.getLogger().isDebug())
                {
                    util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                    util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
                }
                throw new JexWebBIZException(idoOut1);
            }
        	

            if (!"".equals(INTE_CD)) {
    			JexData idoIn2 = util.createIDOData("QUES_USE_SUMR_C001");
    			
    			idoIn2.putAll(input);
    			idoIn2.put("USE_INTT_ID", USE_INTT_ID);
    			idoIn2.put("INTE_CD", INTE_CD);
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
    		}
            
            result.put("RSLT_CD" , "0000");
			result.put("RSLT_MSG" , "정상처리 되었습니다.");
			result.put("RSLT_PROC_GB" , "0");
			idoCon.commit();
        } catch(Exception e){
        	BizLogUtil.debug(this, "Exception e ::: " + e.getMessage() );
			result.put("RSLT_CD" , "E_1000");
			result.put("RSLT_MSG" , "처리중오류가발생하였습니다.잠시후이용하시기바랍니다.");
			result.put("RSLT_PROC_GB" , "");
			idoCon.rollback();
		}
        util.setResult(result, "default");
%>