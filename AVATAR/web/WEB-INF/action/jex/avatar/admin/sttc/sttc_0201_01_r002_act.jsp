<%@page import="com.avatar.comm.SvcDateUtil"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.ido.IDODynamic"%>
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
         * @File Title   : 어드민 로그인현황 개수 조회
         * @File Name    : sttc_0201_01_r002_act.jsp
         * @File path    : admin.sttc
         * @author       : kth91 (  )
         * @Description  : 어드민 로그인현황 조회
         * @Register Date: 20200310140023
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

        @JexDataInfo(id="sttc_0201_01_r002", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
		IDODynamic dynamic_0 = new IDODynamic();
  		
		
		JexData idoIn2 = util.createIDOData("CUST_LDGR_R014");
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
    
        result.putAll(idoOut2);
        
  		String inq_dt_dv_cd = StringUtil.null2void(input.getString("INQ_DT_DV_CD"));
  		String inq_ym = StringUtil.null2void(input.getString("INQ_YM"));
  		// 일별 
		if("2".equals(inq_dt_dv_cd)){
		    dynamic_0.addNotBlankParameter(input.getString("INQ_STR_DT"), "\n AND T.LOGIN_DT = ? ");
		}
		// 기간별
		else if("1".equals(inq_dt_dv_cd)){
		    dynamic_0.addNotBlankParameter(input.getString("INQ_STR_DT"), "\n AND T.LOGIN_DT BETWEEN ? ");
		    dynamic_0.addNotBlankParameter(input.getString("INQ_END_DT"), "\t AND ? ");
		}
		// 월별
	    else if("0".equals(inq_dt_dv_cd)){
	    	
	        dynamic_0.addNotBlankParameter(inq_ym + "01", "\n AND T.LOGIN_DT BETWEEN ? ");
	        dynamic_0.addNotBlankParameter(inq_ym + SvcDateUtil.getInstance().getLastDay(inq_ym), "\t AND ? ");
	    }
    
        JexData idoIn1 = util.createIDOData("CUST_LDGR_R018");
    
        idoIn1.putAll(input);
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
        

        util.setResult(result, "default");

%>