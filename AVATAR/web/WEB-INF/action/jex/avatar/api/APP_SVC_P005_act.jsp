<%@page import="com.avatar.comm.IdoSqlException"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="jex.exception.JexBIZException"%>
<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="jex.json.JSONArray"%>
<%@page import="com.avatar.comm.BizLogUtil"%>
<%@page import="jex.json.JSONObject"%>
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
         * @File Title   : 계좌목록 조회
         * @File Name    : APP_SVC_P005_act.jsp
         * @File path    : api
         * @author       : kth91 (  )
         * @Description  : 계좌목록 조회
         * @Register Date: 20200117112139
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

        @JexDataInfo(id="APP_SVC_P005", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

   		//// input 공통부   /////
        JSONObject _req = JSONObject.fromObject(input.toJSONString());
		JSONObject _cmo = JSONObject.fromObject( _req.getString("MOBL_COMM"));		
        BizLogUtil.debug(this, _cmo.getString("TRAN_NO"), "REQ :: " + input.toJSONString());	
		//// input 공통부   /////

		JSONArray resarr   = new JSONArray();
        String sUSE_INTT_ID  = _req.getString("USE_INTT_ID");
        String sBANK_CD      = _req.getString("BANK_CD");
        int    nREC_CNT      = 0;
        
		// 세션값 체크
		JexDataCMO usersession = null;
    	try{
    		usersession   = SessionManager.getInstance().getUserSession(request, response);  		
    	}catch(Throwable e){
    		throw new JexBIZException("9999", "Session DisConnected.");
    	}
    	
    	// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
        IDODynamic dynamic = new IDODynamic();
        
        if(!StringUtil.isBlank(sBANK_CD)){
            //dynamic.addNotBlankParameter(sBANK_CD, "\n AND A.BANK_CD = ? ");
            String[] sBankArr = sBANK_CD.split(",");
            sBANK_CD = "";
            for (String sBANK : sBankArr){
                sBANK_CD += "'"+sBANK+"',";
            }

            sBANK_CD = sBANK_CD.substring(0, sBANK_CD.length()-1);

            dynamic.addSQL("\n AND A.BANK_CD IN ("+sBANK_CD+")");
        }        
        
    
        JexData idoIn1 = util.createIDOData("ACCT_INFM_R003");
    
        idoIn1.putAll(input);
    
        JexDataList<JexData> idoOut1 = (JexDataList<JexData>) idoCon.executeList(idoIn1);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut1)) {
        	IdoSqlException idoe = new IdoSqlException(idoOut1);
	    	IdoSqlException.printErr(this, idoIn1._getId(), idoOut1);
			result.put("RSLT_CD", "SOER3007");
			result.put("RSLT_MSG", "데이터(DB) 처리 중 오류가 발생하였습니다. 잠시후 이용하시기 바랍니다.");
			result.put("RSLT_PROC_GB", "");
        }else{
        	resarr = idoOut1.toJSON();
        	result.put("ACCT_CNT", DomainUtil.getResultCount(idoOut1));
            result.put("ACCT_LIST", resarr);
            result.put("RSLT_CD", "0000");
			result.put("RSLT_MSG", "정상처리 되었습니다.");
			result.put("RSLT_PROC_GB", "");
        }

        

        util.setResult(result, "default");

%>