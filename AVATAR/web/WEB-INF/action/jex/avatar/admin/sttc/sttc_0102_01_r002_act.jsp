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
         * @File Title   : 질의현황 목록조회
         * @File Name    : sttc_0102_01_r002_act.jsp
         * @File path    : admin.sttc
         * @author       : kth91 (  )
         * @Description  : 질의현황 목록조회
         * @Register Date: 20200311143712
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

        @JexDataInfo(id="sttc_0102_01_r002", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
		IDODynamic dynamic_0 = new IDODynamic();
		IDODynamic dynamic_1 = new IDODynamic();
		IDODynamic dynamic_2 = new IDODynamic();
		
		JexData idoIn1 = util.createIDOData("QUES_HSTR_R001");
		
  		String inq_dt_dv_cd = StringUtil.null2void(input.getString("INQ_DT_DV_CD"));
  		String inq_ym = StringUtil.null2void(input.getString("INQ_YM"));
  		// 일별 
		if("2".equals(inq_dt_dv_cd)){
		    dynamic_0.addNotBlankParameter(input.getString("INQ_STR_DT"), "\n AND substring(T1.QUES_DTM,0,9) = ? ");
		    dynamic_1.addNotBlankParameter(input.getString("INQ_STR_DT"), "\n AND substring(T1.QUES_DTM,0,9) = ? ");
		}
		// 기간별
		else if("1".equals(inq_dt_dv_cd)){
		    dynamic_0.addNotBlankParameter(input.getString("INQ_STR_DT"), "\n AND substring(T1.QUES_DTM,0,9) BETWEEN ? ");
		    dynamic_0.addNotBlankParameter(input.getString("INQ_END_DT"), "\t AND ? ");
		    dynamic_1.addNotBlankParameter(input.getString("INQ_STR_DT"), "\n AND substring(T1.QUES_DTM,0,9) BETWEEN ? ");
		    dynamic_1.addNotBlankParameter(input.getString("INQ_END_DT"), "\t AND ? ");
		}
		// 월별
	    else if("0".equals(inq_dt_dv_cd)){
	        dynamic_0.addNotBlankParameter(inq_ym + "01", "\n AND substring(T1.QUES_DTM,0,9) BETWEEN ? ");
	        dynamic_0.addNotBlankParameter(inq_ym + SvcDateUtil.getInstance().getLastDay(inq_ym), "\t AND ? ");
	        dynamic_1.addNotBlankParameter(inq_ym + "01", "\n AND substring(T1.QUES_DTM,0,9) BETWEEN ? ");
	        dynamic_1.addNotBlankParameter(inq_ym + SvcDateUtil.getInstance().getLastDay(inq_ym), "\t AND ? ");
	    }
    	// 인텐트
    	if(!"".equals(StringUtil.null2void(input.getString("INTE_CD")))){
    		if("no".equals(StringUtil.null2void(input.getString("INTE_CD")))){
    			dynamic_0.addSQL("\n AND COALESCE(T1.INTE_CD,'') = '' ");
    			dynamic_1.addSQL("\n AND COALESCE(T1.INTE_CD,'') = '' ");
    		}else {
				dynamic_0.addNotBlankParameter(input.getString("INTE_CD"), "\n AND T1.INTE_CD = ? ");
				dynamic_1.addNotBlankParameter(input.getString("INTE_CD"), "\n AND T1.INTE_CD = ? ");
    		}
		}
    	// 카테고리
    	if(!"".equals(StringUtil.null2void(input.getString("CTGR_CD")))){
    		if("no".equals(StringUtil.null2void(input.getString("CTGR_CD")))){
    			dynamic_0.addSQL("\n AND COALESCE(T2.CTGR_CD,'') = '' ");
    			dynamic_1.addSQL("\n AND COALESCE(T2.CTGR_CD,'') = '' ");
    		}else {
				dynamic_0.addNotBlankParameter(input.getString("CTGR_CD"), "\n AND T2.CTGR_CD = ? ");
				dynamic_1.addNotBlankParameter(input.getString("CTGR_CD"), "\n AND T2.CTGR_CD = ? ");
    		}
		}
  		
  		if(!"".equals(StringUtil.null2void(input.getString("INQ_TRCN")))){
  			if("CUST".equals(StringUtil.null2void(input.getString("INQ_TRCN")))){		// 고객명
  				dynamic_0.addNotBlankParameter(input.getString("INQ_TRCN_CTT"), "\n AND T3.CUST_NM LIKE '%'||?||'%' ");
  			} else if("PHONE".equals(StringUtil.null2void(input.getString("INQ_TRCN")))){		// 핸드폰번호 
  				dynamic_0.addNotBlankParameter(input.getString("INQ_TRCN_CTT"), "\n AND DECRYPT(T3.CLPH_NO) LIKE '%'||?||'%' ");
  			}
  		} else {
  			dynamic_0.addNotBlankParameter(input.getString("INQ_TRCN_CTT"), "\n AND (T3.CUST_NM LIKE '%'||?||'%' ");
  			dynamic_0.addNotBlankParameter(input.getString("INQ_TRCN_CTT"), "OR DECRYPT(T3.CLPH_NO) LIKE '%'||?||'%')");
  		}
    	 
    	if(!"".equals(StringUtil.null2void(input.getString("APP_ID")))){
			dynamic_0.addNotBlankParameter(input.getString("APP_ID"), "\n AND T1.APP_ID = ? ");
		}
    	if(!"".equals(StringUtil.null2void(input.getString("LRN_STTS")))){
			dynamic_0.addNotBlankParameter(input.getString("LRN_STTS"), "\n AND T1.LRN_STTS = ? ");
		}
    	//dynamic_2.addSQL("\n ORDER BY T1.QUES_DTM DESC");
    	dynamic_2.addSQL("\n ORDER BY QUES_DTM DESC");
        
    
        if(!"".equals(StringUtil.null2void(input.getString("PAGE_NO")))){
      	    int page_no = Integer.parseInt(input.getString("PAGE_NO"));
       		int page_size = Integer.parseInt(input.getString("PAGE_SIZE"));
       		DomainUtil.setIDOPageInfo(idoIn1, page_no, page_size, false);
      	}
        
        idoIn1.putAll(input);
      	idoIn1.put("DYNAMIC_0", dynamic_0);
      	idoIn1.put("DYNAMIC_1", dynamic_1);
      	idoIn1.put("DYNAMIC_2", dynamic_2);
      	
    
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
        result.put("CNT", String.valueOf(DomainUtil.getMaxResultCount(idoOut1)));
        

        util.setResult(result, "default");

%>