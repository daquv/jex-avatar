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
         * @File Title   : 공지사항목록조회
         * @File Name    : blbd_0101_01_r001_act.jsp
         * @File path    : admin.blbd
         * @author       : byeolkim89 (  )
         * @Description  : 공지사항목록조회
         * @Register Date: 20200828153943
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

        @JexDataInfo(id="blbd_0101_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        IDODynamic dynamic_0 = new IDODynamic();
        
        if (!"".equals(StringUtil.null2void(input.getString("SRCH_WD")))) {
        	if("01".equals(input.getString("SRCH_CD"))){
            	dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND (BLBD_TITL LIKE '%'||?||'%'");
            	dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), " OR BLBD_CTT LIKE '%'||?||'%')");
            } else if("02".equals(input.getString("SRCH_CD"))){
            	dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND REGR_ID LIKE '%'||?||'%'");
            } else {
            	dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND (REGR_ID LIKE '%'||?||'%'");
            	dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), " OR BLBD_TITL LIKE '%'||?||'%'");
            	dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), " OR BLBD_CTT LIKE '%'||?||'%')");
            }
		}
        if (!"".equals(StringUtil.null2void(input.getString("CTGR_CD")))) {
            dynamic_0.addNotBlankParameter(input.getString("CTGR_CD"), "\n AND BLBD_CTGR_CD = ?");
		}
        if(!"".equals(StringUtil.null2void(input.getString("CHNL_CD")))) {
        	dynamic_0.addNotBlankParameter(input.getString("CHNL_CD"), "\n AND COALESCE(BLBD_CHNL, '00') = ?");
        }
        
        dynamic_0.addNotBlankParameter(input.getString("BLBD_DIV"), "\n AND BLBD_DIV = ?");
        dynamic_0.addNotBlankParameter(input.getString("BLBD_NO"), "\n AND BLBD_NO = CAST(? AS INTEGER)");
        dynamic_0.addSQL("\n AND COALESCE(DEL_YN,'N') != 'Y'");
        
        JexData idoIn0 = util.createIDOData("BLBD_HSTR_R005");
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
     	
        JexData idoIn1 = util.createIDOData("BLBD_HSTR_R001");
        if("03".equals(input.getString("BLBD_DIV"))) {
        	// FAQ게시판은 정렬기준에 채널 추가
    		dynamic_0.addSQL("\n ORDER BY REG_DTM DESC, BLBD_CHNL ASC");
        } else {
    		dynamic_0.addSQL("\n ORDER BY REG_DTM DESC");
        }
        if(!"".equals(StringUtil.null2void(input.getString("PAGE_NO")))){
      	    int page_no = Integer.parseInt(input.getString("PAGE_NO"));
       		int page_size = Integer.parseInt(input.getString("PAGE_CNT"));
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
    
        result.put("REC", idoOut1);

        

        util.setResult(result, "default");

%>