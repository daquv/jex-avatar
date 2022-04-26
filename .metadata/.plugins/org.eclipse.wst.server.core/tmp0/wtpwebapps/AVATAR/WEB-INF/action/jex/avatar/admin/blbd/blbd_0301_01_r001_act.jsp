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
         * @File Title   : 상담내역 조회
         * @File Name    : blbd_0301_01_r001_act.jsp
         * @File path    : admin.blbd
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20210504180617
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

        @JexDataInfo(id="blbd_0301_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        IDODynamic dynamic_0= new IDODynamic();
		// Get Session
		/* JexDataCMO userSession = SessionManager.getSession(request, response);
		String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID")); */
        
		//가입일자
		if(!"".equals(StringUtil.null2void(input.getString("STR_DT"))) && !"".equals(StringUtil.null2void(input.getString("END_DT")))){
			dynamic_0.addNotBlankParameter(input.getString("STR_DT"), "\n AND RQST_DT BETWEEN ? AND ");
			dynamic_0.addNotBlankParameter(input.getString("END_DT"), "?");
		}
		//검색 - 고객명, 회사명? 사업자번호(고객원장 X)
		if(!"".equals(StringUtil.null2void(input.getString("SRCH_WD")))){
			if("0".equals(StringUtil.null2void(input.getString("SRCH_CD")))){
                dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND (RQST_BSNN_NM like '%'||?||'%'");
                dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n OR RQST_BIZ_NO like '%'||?||'%'");
                dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n OR RQST_CUST_NM like '%'||?||'%'");
                dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n OR RQST_CLPH_NO like '%'||?||'%'");
                dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n OR RQST_EML like '%'||?||'%')");
            } else if("1".equals(StringUtil.null2void(input.getString("SRCH_CD")))){
            	dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND RQST_BSNN_NM like '%'||?||'%'");
            } else if("2".equals(StringUtil.null2void(input.getString("SRCH_CD")))){
            	dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND RQST_BIZ_NO like '%'||?||'%'");
            } else if("3".equals(StringUtil.null2void(input.getString("SRCH_CD")))){
            	dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND RQST_CUST_NM like '%'||?||'%'");
            } else if("4".equals(StringUtil.null2void(input.getString("SRCH_CD")))){
            	dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND RQST_CLPH_NO like '%'||?||'%'");
            } else if("5".equals(StringUtil.null2void(input.getString("SRCH_CD")))){
            	dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND RQST_EML like '%'||?||'%'");
            }      		
      	}
		//상태
		if(!StringUtil.isBlank(input.getString("STTS"))){
			String stts[] = input.getString("STTS").split(",");
			dynamic_0.addSQL("\n AND CNSL_STTS IN (");
			
			for(int i=0 ; i<stts.length; i++){
				String sttsSql = ",?";
				if(i==0){
					sttsSql = "?";
				}
				dynamic_0.addNotBlankParameter(stts[i], sttsSql);
				
			}
			dynamic_0.addSQL(")");
		}
        dynamic_0.addNotBlankParameter(input.getString("CNSL_DIV"), "\n AND CNSL_DIV = ? ");
        dynamic_0.addNotBlankParameter(input.getString("CNSL_NO"), "\n AND CNSL_NO = CAST(? AS INTEGER) ");
        JexData idoIn1 = util.createIDOData("CNSL_HSTR_R001");
        dynamic_0.addSQL("\n ORDER BY RQST_DT DESC, CNSL_NO DESC");
      //paging
        if(!StringUtil.isBlank(input.getString("PAGE_NO")) && !StringUtil.isBlank(input.getString("PAGE_CNT"))){
        	int pageNo = Integer.parseInt(input.getString("PAGE_NO"));
    		int pageCnt = Integer.parseInt(input.getString("PAGE_CNT"));
    		int end_idx = pageCnt;
    		int str_idx = ((pageNo-1)*pageCnt);
               
            dynamic_0.addNotBlankParameter(end_idx , "\n LIMIT CAST(? AS INTEGER) ");
            dynamic_0.addNotBlankParameter(str_idx , " OFFSET CAST(? AS INTEGER) ");
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