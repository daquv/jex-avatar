<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.avatar.comm.AESUtils"%>
<%@page import="jex.sys.JexSystemConfig"%>
<%@page import="com.avatar.comm.SvcDateUtil"%>
<%@page import="com.avatar.api.mgnt.CooconApi"%>
<%@page contentType="text/html;charset=UTF-8" %>

<%@page import="jex.util.DomainUtil"%>
<%@page import="jex.util.StringUtil"%>
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
<%@page import="jex.json.JSONArray"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="jex.json.parser.JSONParser"%>
<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.Arrays" %>
<%@page import="com.avatar.api.mgnt.ContentApiMgnt" %>
<%@page import="com.avatar.comm.CommUtil"%>
<%@page import="com.avatar.comm.BizLogUtil"%>

<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 질의예시목록 조회_IBKCRM
         * @File Name    : ques_0001_11_r001_act.jsp
         * @File path    : ques
         * @author       : vgkwnsxov (  )
         * @Description  : 
         * @Register Date: 20220331163644
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

        @JexDataInfo(id="ques_0001_11_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
        
        
		//IDO Connection
		JexConnection idoCon = JexConnectionManager.createBCSIDOConnection();
		
		//음성결과
		JSONObject inteInfo 	= (JSONObject)JSONParser.parser(StringUtil.null2void(input.getString("INTE_INFO")));
        String	EMN		= StringUtil.null2void(input.getString("EMN"));
        String	BASE_YMD		= StringUtil.null2void(input.getString("BASE_YMD")); 
        String 		recog_txt	= StringUtil.null2void((String)inteInfo.get("recog_txt"));
        JSONObject	recog_data	= (JSONObject)inteInfo.get("recog_data");
        JSONObject	appInfo		= (JSONObject)recog_data.get("appInfo");
        String		Intent		= StringUtil.null2void((String)recog_data.get("Intent"));
        
        JSONObject	rslt_ctt	= new JSONObject();
        
        
        
        /*
    	*	Intent			내용						조건									
    	*	========================================================================================================
    	*	
    	*	IB001			브리핑 현황				현황 종류			
    	*	IB002			기업발화유도			
    	*	IB003			기업 정보				NE-COUNTERPARTNAME					
    	*	IB004			기업 정보 요약			NE-COUNTERPARTNAME				
    	**/
    	
    	
    	JexData		idoIn0 = util.createIDOData("INTE_INFM_R013");
        idoIn0.put("INTE_CD", Intent);
        
        JexData		idoOut0 = idoCon.execute(idoIn0);

        if (DomainUtil.isError(idoOut0)) {
			if (util.getLogger().isDebug())
			{
				util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut0));
				util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut0));
			}
			throw new JexWebBIZException(idoOut0);
		}
		result.put("OTXT_HTML", StringUtil.null2void(idoOut0.getString("OTXT_HTML")) );
		result.put("INTE_NM", StringUtil.null2void(idoOut0.getString("INTE_NM")) );
    	
    	// 질의 인입 이력을 등록한다.(history)
    	JexData 	idoIn1 = util.createIDOData("");
    	idoIn1.put("EMN", EMN);
    	idoIn1.put("VOIC_DATA", inteInfo.toString());
    	idoIn1.put("INTE_CD", Intent);
    	idoIn1.put("QUES_CTT", recog_txt);
    	idoIn1.put("BASE_YMD", BASE_YMD);
    	JexData 	idoOut1 = idoCon.execute(idoIn1);
    	
    	// 도메인 에러 검증
        if (DomainUtil.isError(idoOut1)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
            }
            // throw new JexWebBIZException(idoOut1);
			rslt_ctt.put("RSLT_CD", "9998");
			rslt_ctt.put("RSLT_MSG", "질의이력 등록 중 오류가 발생했습니다.");
        } else {
        	
        }
        
    	result.put("RSLT_CTT", rslt_ctt.toJSONString());
        util.setResult(result, "default");
    	

%>