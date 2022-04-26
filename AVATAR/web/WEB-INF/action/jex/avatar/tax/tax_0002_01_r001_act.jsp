<%@page import="com.avatar.comm.BizLogUtil"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="jex.json.JSONArray"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
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
         * @File Title   : 홈텍스 인증서 조회
         * @File Name    : tax_0002_01_r001_act.jsp
         * @File path    : tax
         * @author       : kth91 (  )
         * @Description  : 홈텍스 인증서 조회
         * @Register Date: 20200121091552
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

        @JexDataInfo(id="tax_0002_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

     	// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexDataCMO userSession = SessionManager.getSession(request, response);
        String use_intt_id = userSession.getString("USE_INTT_ID");
//         String bsnn_no = userSession.getString("BSNN_NO");		//사업자 번호 없음
        
    	// 전자(세금)계산서 홈택스 증빙설정정보 조회
        JexData idoIn1 = util.createIDOData("EVDC_INFM_R004");
    
    	idoIn1.put("USE_INTT_ID", use_intt_id);
    	idoIn1.put("EVDC_DIV_CD", input.getString("EVDC_DIV_CD1"));
//     	idoIn1.put("BIZ_NO", bsnn_no);
    
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
        
     	// 현금영수증 홈택스 증빙설정정보 조회
        JexData idoIn2 = util.createIDOData("EVDC_INFM_R004");
    
        idoIn2.put("USE_INTT_ID", use_intt_id);
        idoIn2.put("EVDC_DIV_CD", input.getString("EVDC_DIV_CD2"));
//         idoIn2.put("BIZ_NO", bsnn_no);
    
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
		//하나만 데이터가 있을 경우 그 데이터의 인증서 이름을 가져온다.        
        String cert_nm = "".equals( StringUtil.null2void(idoOut1.getString("CERT_NM")) )?StringUtil.null2void(idoOut2.getString("CERT_NM")):StringUtil.null2void(idoOut1.getString("CERT_NM"));
        // 전자(세금)계산서가 없을 경우 현금영수증 정보 셋팅
        if("".equals(StringUtil.null2void(idoOut1.getString("STTS")))
                || "9".equals(StringUtil.null2void(idoOut1.getString("STTS")))){
        	result.putAll(idoOut2);
        	result.put("HIS_LST_STTS", idoOut1.getString("HIS_LST_STTS"));
            result.put("HIS_LST_MSG", idoOut1.getString("HIS_LST_MSG"));
        }
        
        result.put("OTHER_STTS", idoOut2.getString("STTS"));
        result.put("OTHER_HIS_LST_STTS", idoOut2.getString("HIS_LST_STTS"));
        result.put("OTHER_HIS_LST_MSG", idoOut2.getString("HIS_LST_MSG"));
        
        util.setResult(result, "default");
%>