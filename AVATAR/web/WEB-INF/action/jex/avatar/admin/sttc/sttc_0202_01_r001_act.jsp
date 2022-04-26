<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="jex.util.StringUtil"%>
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
         * @File Title   : 어디민 데이터가져오기 목록
         * @File Name    : sttc_0202_01_r001_act.jsp
         * @File path    : admin.sttc
         * @author       : kth91 (  )
         * @Description  : 어디민 데이터가져오기 목록
         * @Register Date: 20200309173453
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

        @JexDataInfo(id="sttc_0202_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        IDODynamic dynamic_0 = new IDODynamic();
// 		IDODynamic dynamic_1 = new IDODynamic();
		// Get Session
		/* JexDataCMO userSession = SessionManager.getSession(request, response);
		String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID")); */
        
		//가입일자
		if(!"".equals(StringUtil.null2void(input.getString("STR_DT"))) && !"".equals(StringUtil.null2void(input.getString("END_DT")))){
			dynamic_0.addNotBlankParameter(input.getString("STR_DT"), "\n AND T2.REG_DTM BETWEEN ?||'000000' AND ");
			dynamic_0.addNotBlankParameter(input.getString("END_DT"), " ?||'235959' ");
			
		}
		//검색 - 고객명, 회사명? 사업자번호(고객원장 X)
			if("".equals(StringUtil.null2void(input.getString("SRCH_CD")))){
				dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND (CUST_NM like '%'||?||'%'");
				dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n OR CLPH_NO like '%'||?||'%' ) ");
            } else if("CUST".equals(StringUtil.null2void(input.getString("SRCH_CD")))){
            	dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND CUST_NM like '%'||?||'%'");
            } else if("PHONE".equals(StringUtil.null2void(input.getString("SRCH_CD")))){
            	dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND CLPH_NO like '%'||?||'%'");
            }      		

		//상태
		if(!StringUtil.isBlank(input.getString("STTS"))){
			String stts[] = input.getString("STTS").split(",");
			dynamic_0.addSQL("\n AND T2.STTS IN (");
			
			for(int i=0 ; i<stts.length; i++){
				String sttsSql = ",?";
				if(i==0){
					sttsSql = "?";
				}
				dynamic_0.addNotBlankParameter(stts[i], sttsSql);
				
			}
			dynamic_0.addSQL(")");
		}	
		//데이터가져오기
		if(!"".equals(StringUtil.null2void(input.getString("INQ_TRCN")))){
			if("HOME".equals(input.getString("INQ_TRCN"))){
				dynamic_0.addSQL( "\n AND (T2.PRCH_CNT" + " > 0" );
				dynamic_0.addSQL( "\n OR T2.CASH_CNT" + " > 0 )" );
			} else {
				dynamic_0.addSQL( "\n AND T2." + input.getString("INQ_TRCN")+"_CNT" + " > 0" );
			}
		}
    
        JexData idoIn1 = util.createIDOData("CUST_LDGR_R008");
        
      	//Pagination
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
    
        result.put("CNT", String.valueOf(DomainUtil.getMaxResultCount(idoOut1)));
        result.put("REC", idoOut1);

        

        util.setResult(result, "default");

%>