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
         * @File Title   : 세무사DB 목록 조회
         * @File Name    : txof_0101_01_r001_act.jsp
         * @File path    : admin.cstm
         * @author       : byeolkim89 (  )
         * @Description  : 세무사DB 목록 조회
         * @Register Date: 20210715134314
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

        @JexDataInfo(id="txof_0101_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        IDODynamic dynamic_0 = new IDODynamic();
        IDODynamic dynamic_1 = new IDODynamic();
        
        dynamic_0.addSQL("AND STTS = '1'");
        //가입일자
        if(!"".equals(StringUtil.null2void(input.getString("STR_DT"))) && !"".equals(StringUtil.null2void(input.getString("END_DT")))){
        	dynamic_0.addNotBlankParameter(input.getString("STR_DT"), "\n AND REG_DTM BETWEEN ?||'000000' AND ");
      		dynamic_0.addNotBlankParameter(input.getString("END_DT"), " ?||'235959' ");
      	}
      	
        //검색 - 사업자번호, 사업장명, 표제어, 독음
      	if(!"".equals(StringUtil.null2void(input.getString("SRCH_WD")))){
      		if("0".equals(StringUtil.null2void(input.getString("SRCH_CD")))){
      			dynamic_1.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND (BSNN_NM like '%'||?||'%' ");
      			dynamic_1.addNotBlankParameter(input.getString("SRCH_WD"), "OR CHRG_NM like '%'||?||'%' ");
      			dynamic_1.addNotBlankParameter(input.getString("SRCH_WD"), "OR MAJR_SPHR like '%'||?||'%' ");
      			dynamic_1.addNotBlankParameter(input.getString("SRCH_WD"), "OR CHRG_TEL_NO like '%'||?||'%' ");
      			dynamic_1.addNotBlankParameter(input.getString("SRCH_WD"), "OR LOCA_NO = (SELECT DSDL_ITEM_CD FROM DSDL_ITEM WHERE ? LIKE '%'||DSDL_ITEM_NM||'%'))");
      		} else if("1".equals(StringUtil.null2void(input.getString("SRCH_CD")))){
      			dynamic_1.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND BSNN_NM like '%'||?||'%'");
      		} else if("2".equals(StringUtil.null2void(input.getString("SRCH_CD")))){
      			dynamic_1.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND CHRG_NM like '%'||?||'%'");
      		} else if("3".equals(StringUtil.null2void(input.getString("SRCH_CD")))){
      			dynamic_1.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND MAJR_SPHR like '%'||?||'%'");
      		} else if("4".equals(StringUtil.null2void(input.getString("SRCH_CD")))){
      			dynamic_1.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND CHRG_TEL_NO like '%'||?||'%'");
      		} else if("5".equals(StringUtil.null2void(input.getString("SRCH_CD")))){
      			dynamic_1.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND LOCA_NO = (SELECT DSDL_ITEM_CD FROM DSDL_ITEM WHERE ? LIKE '%'||DSDL_ITEM_NM||'%')");
      		}
      	}
    
        JexData idoIn1 = util.createIDOData("TXOF_INFM_R001");
        dynamic_1.addSQL("\n ORDER BY REG_DTM DESC, BSNN_NM");
      	//paging
        if(!StringUtil.isBlank(input.getString("PAGE_NO")) && !StringUtil.isBlank(input.getString("PAGE_CNT"))){
        	int pageNo = Integer.parseInt(input.getString("PAGE_NO"));
    		int pageCnt = Integer.parseInt(input.getString("PAGE_CNT"));
    		int end_idx = pageCnt;
    		int str_idx = ((pageNo-1)*pageCnt);
               
    		dynamic_1.addNotBlankParameter(end_idx , "\n LIMIT CAST(? AS INTEGER) ");
    		dynamic_1.addNotBlankParameter(str_idx , " OFFSET CAST(? AS INTEGER) ");
        }
        idoIn1.putAll(input);
        idoIn1.put("DYNAMIC_0", dynamic_0);
        idoIn1.put("DYNAMIC_1", dynamic_1);
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

        JexData idoIn2 = util.createIDOData("TXOF_INFM_R002");
        
        idoIn2.putAll(input);
        idoIn2.put("DYNAMIC_0", dynamic_0);
        JexData idoOut2 = idoCon.execute(idoIn2);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut2)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
            }
            throw new JexWebBIZException(idoOut2);
        }
    
        result.put("TOTL_NCNT", idoOut2.getString("TOTL_NCNT"));

        util.setResult(result, "default");

%>