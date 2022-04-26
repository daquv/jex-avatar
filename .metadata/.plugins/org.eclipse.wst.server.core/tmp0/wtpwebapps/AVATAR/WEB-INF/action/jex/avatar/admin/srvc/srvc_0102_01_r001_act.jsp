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
         * @File Title   : admin 질의관리 목록 조회
         * @File Name    : srvc_0102_01_r001_act.jsp
         * @File path    : admin.srvc
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200306153024
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

		@JexDataInfo(id="srvc_0102_01_r001", type=JexDataType.WSVC)
		JexData input = util.getInputDomain();
		JexData result = util.createResultDomain();

		// IDO Connection
		JexConnection idoCon = JexConnectionManager.createIDOConnection();        
		IDODynamic dynamic_0 = new IDODynamic();
		IDODynamic dynamic_1 = new IDODynamic();
		
		//srvc_0102_01
		if("1".equals(StringUtil.null2void(input.getString("RSLT_CD")))){
			//검색대상
			if(!"".equals(StringUtil.null2void(input.getString("SRCH_WD")))){
				dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND QUES_CTT like '%'||?||'%'");
			}
			//카테고리
			if(!"".equals(StringUtil.null2void(input.getString("CTGR_CD")))){
				dynamic_0.addNotBlankParameter(input.getString("CTGR_CD"), "\n AND CTGR_CD = ? ");
			}
		} 
		//srvc_0103_02
		else if("2".equals(StringUtil.null2void(input.getString("RSLT_CD")))){
			dynamic_0.addNotBlankParameter(input.getString("SRCH_WD"), "\n AND QUES_CTT like '%'||?||'%'");
			dynamic_0.addNotBlankParameter(input.getString("CTGR_CD"), "\n AND CTGR_CD = ? ");
		}
		
		//상태
		if(!StringUtil.isBlank(input.getString("STTS"))){
			String stts[] = input.getString("STTS").split(",");
			dynamic_0.addSQL("\n AND STTS IN (");
				for(int i=0 ; i<stts.length; i++){
					String sttsSql = ",?";
					if(i==0){ sttsSql = "?"; }
					dynamic_0.addNotBlankParameter(stts[i], sttsSql);
				}
				dynamic_0.addSQL(")");
			}
		
		
		//get cnt start
        JexData idoIn2 = util.createIDOData("QUES_API_INFM_R001");
    
        idoIn2.putAll(input);
        idoIn2.put("DYNAMIC_0", dynamic_0);
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
        //get cnt end
        
        
    	//get data start
        JexData idoIn1 = util.createIDOData("QUES_API_INFM_R002");
        dynamic_0.addSQL("\n ORDER BY T1.CORC_DTM DESC, T1.REG_DTM DESC");
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
		//get data end
        
        
        
    	

        util.setResult(result, "default");

%>