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

<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 기능개선문의 목록조회
         * @File Name    : cstm_0201_01_r001_act.jsp
         * @File path    : admin.cstm
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200824142928
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

        @JexDataInfo(id="cstm_0201_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        IDODynamic dynamic_0 = new IDODynamic();
    
        
    
    	//조회기간
    	if(!"".equals(input.getString("STR_DT")) && !"".equals(input.getString("END_DT"))){
    		dynamic_0.addNotBlankParameter(input.getString("STR_DT"), "\n AND A.REG_DTM BETWEEN  ?||'000000' AND");
    		dynamic_0.addNotBlankParameter(input.getString("END_DT"), " ?||'235959'");
    	}
    	//상태
    	dynamic_0.addNotBlankParameter(input.getString("STTS"), "\n AND A.STTS = ?");
    	//상태
    	dynamic_0.addNotBlankParameter(input.getString("APP_ID"), "\n AND A.APP_ID = ?");
    	//검색대상
    	if(!"".equals(input.getString("SRCH_WD"))){
    		if("01".equals(input.getString("SRCH_CD"))){	//제목
    			dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND BLBD_TITL LIKE '%'||?||'%'");
    		} else if("02".equals(input.getString("SRCH_CD"))){	//내용+제목
    			dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND (BLBD_TITL LIKE '%'||?||'%' OR");
    			dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n BLBD_CTT LIKE '%'||?||'%')");
    		} else if("03".equals(input.getString("SRCH_CD"))){	//작성자
    			dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND CUST_NM LIKE '%'||?||'%'");
    		} else if("04".equals(input.getString("SRCH_CD"))){
    			dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND REGR_NM LIKE '%'||?||'%'");
    		} else if("05".equals(input.getString("SRCH_CD"))){
    			dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND TEL_NO LIKE '%'||?||'%'");
    		}
    	}
    	
    	dynamic_0.addNotBlankParameter(input.getString("BLBD_NO"), "\n AND A.BLBD_NO = CAST(? AS INTEGER)");
    	
		JexData idoIn0 = util.createIDOData("BLBD_HSTR_R004");
    	
		idoIn0.putAll(input);
		idoIn0.put("DYNAMIC_0", dynamic_0);
        JexData idoOut0 = idoCon.execute(idoIn0);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut0)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut0));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut0));
            }
            throw new JexWebBIZException(idoOut0);
        }
    
        result.putAll(idoOut0);
        
        dynamic_0.addSQL("\n ORDER BY A.CORC_DTM DESC, A.REG_DTM DESC");
      //paging
        if(!StringUtil.isBlank(input.getString("PAGE_NO")) && !StringUtil.isBlank(input.getString("PAGE_CNT"))){
        	int pageNo = Integer.parseInt(input.getString("PAGE_NO"));
    		int pageCnt = Integer.parseInt(input.getString("PAGE_CNT"));
    		int end_idx = pageCnt;
    		int str_idx = ((pageNo-1)*pageCnt);
               
            dynamic_0.addNotBlankParameter(end_idx , "\n LIMIT CAST(? AS INTEGER) ");
            dynamic_0.addNotBlankParameter(str_idx , " OFFSET CAST(? AS INTEGER) ");
        }
    	JexData idoIn1 = util.createIDOData("BLBD_HSTR_R003");
    	
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