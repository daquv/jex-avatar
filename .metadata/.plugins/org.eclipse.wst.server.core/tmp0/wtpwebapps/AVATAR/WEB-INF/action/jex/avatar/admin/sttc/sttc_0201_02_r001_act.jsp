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
         * @File Title   : 고객로그이력 조회
         * @File Name    : sttc_0201_02_r001_act.jsp
         * @File path    : admin.sttc
         * @author       : kth91 (  )
         * @Description  : 고객로그이력 조회
         * @Register Date: 20200310153127
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

        @JexDataInfo(id="sttc_0201_02_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
		IDODynamic dynamic_0 = new IDODynamic();
  		
  		String inq_dt_dv_cd = StringUtil.null2void(input.getString("INQ_DT_DV_CD"));
  		String inq_ym = StringUtil.null2void(input.getString("INQ_YM"));
  		// 일별 
		if("2".equals(inq_dt_dv_cd)){
		    dynamic_0.addNotBlankParameter(input.getString("INQ_STR_DT"), "\n AND LOGIN_DT = ? ");
		}
		// 기간별
		else if("1".equals(inq_dt_dv_cd)){
		    dynamic_0.addNotBlankParameter(input.getString("INQ_STR_DT"), "\n AND LOGIN_DT BETWEEN ? ");
		    dynamic_0.addNotBlankParameter(input.getString("INQ_END_DT"), "AND ? ");
		}
		// 월별
	    else if("0".equals(inq_dt_dv_cd)){
	    	
	        dynamic_0.addNotBlankParameter(inq_ym + "01", "\n AND LOGIN_DT BETWEEN ? ");
	        dynamic_0.addNotBlankParameter(inq_ym + SvcDateUtil.getInstance().getLastDay(inq_ym), " AND ? ");
	    }
		dynamic_0.addSQL("\n ORDER BY T1.LOGIN_DT DESC,T1.LOGIN_TM DESC");
        JexData idoIn1 = util.createIDOData("CUST_LGIN_HIS_R001");
    
        if(!"".equals(StringUtil.null2void(input.getString("PAGE_NO")))){
      	    int page_no = Integer.parseInt(input.getString("PAGE_NO"));
       		int page_size = Integer.parseInt(input.getString("PAGE_SIZE"));
       		DomainUtil.setIDOPageInfo(idoIn1, page_no, page_size, false);
      	}
        
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
        result.put("CNT", String.valueOf(DomainUtil.getMaxResultCount(idoOut1)));
        result.put("REC", idoOut1);

        util.setResult(result, "default");

%>