<%@page import="com.avatar.api.mgnt.PushApiMgnt"%>
<%@page import="jex.data.impl.JexDataRecordList"%>
<%@page import="jex.JexContext"%>
<%@page import="jex.util.biz.JexCommonUtil"%>
<%@page import="jex.exception.JexBIZException"%>
<%@page import="jex.exception.JexException"%>
<%@page import="java.sql.SQLException"%>
<%@page import="jex.json.JSONArray"%>
<%@page import="jex.json.JSONObject"%>
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
         * @File Title   : 결제내역통지
         * @File Name    : ZERO_TRAN_C001_act.jsp
         * @File path    : api
         * @author       : jepark (  )
         * @Description  : 결제내역통지
         * @Register Date: 20210727164613
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

        @JexDataInfo(id="ZERO_TRAN_C001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

	    // IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
        util.getLogger().debug("ZERO_TRAN_C001 input ::"+input.toJSONString());
        
        String cust_ci   	 = StringUtil.null2void(input.getString("CI"));						// 대표자 CI
        String setl_dt   	 = StringUtil.null2void(input.getString("TRAN_OCC_DATE"));			// 결제일자
        String otran_time    = StringUtil.null2void(input.getString("OTRAN_TIME"));				// 결제시간
        String tran_id    	 = StringUtil.null2void(input.getString("TRAN_ID"));				// 결제거래번호 
        String trns_amt   	 = StringUtil.null2void(input.getString("TRAN_AMT"),"0");			// 거래금액 
        String srv_fee   	 = StringUtil.null2void(input.getString("SVC_AMT"),"0");			// 봉사료 
        String add_tax_amt   = StringUtil.null2void(input.getString("ADD_TAX_AMT"),"0");		// 부가가치세 
        String fee   		 = StringUtil.null2void(input.getString("AFLT_FEE"),"0");			// 수수료 
        String stts   		 = StringUtil.null2void(input.getString("TRAN_PROC_CD"));			// 상태(1:결제, 2:취소) 
        String biz_cd   	 = StringUtil.null2void(input.getString("BIZ_CD"));					// 결제구분(1:직불, 2:상품권)
        String otran_bank_nm = StringUtil.null2void(input.getString("OTRAN_BANK_NM"));			// 결제사명 		
        String org_proc_date = StringUtil.null2void(input.getString("ORG_PROC_DATE"));			// 원거래일자 		
        String org_proc_seq  = StringUtil.null2void(input.getString("ORG_PROC_SEQ"));			// 원거래번호 
        String aflt_management_no = StringUtil.null2void(input.getString("AFLT_MANAGEMENT_NO"));// 가맹점관리번호 
        String mest_biz_no   = StringUtil.null2void(input.getString("BIZ_NO"));					// 가맹점사업자번호 
        String ser_biz_no    = StringUtil.null2void(input.getString("SER_BIZ_NO"));				// 가맹점종사업번호 
        String mest_nm   	 = StringUtil.null2void(input.getString("AFLT_NM"));				// 가맹점명 
        String aflt_id   	 = StringUtil.null2void(input.getString("AFLT_ID"));				// 가맹점아이디 
        JSONArray zApiArr 	 = JSONObject.fromArray(input.get("REC").toString());				// 상품권종류 및 결제금액(결제구분이 상품권이 일때만 데이터가 있음)
        
        // 필수값 체크
        if(cust_ci.equals("") || setl_dt.equals("") || otran_time.equals("") || tran_id.equals("")){
        	result.put("RSLT_CD","ZPER0001");
            result.put("RSLT_MSG","필수값이 누락되었습니다.");   
            util.setResult(result, "default");
            return;
        }
     
     	// 대표자 CI로 고객번호 조회
        JexData idoIn1 = util.createIDOData("CUST_LDGR_R030");
        idoIn1.put("CUST_CI", cust_ci);  
        JexData idoOut1 =  idoCon.execute(idoIn1);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut1)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
            }
            result.put("RSLT_CD","ZPER0002");
            result.put("RSLT_MSG","대표자CI 조회 중 오류가 발생하였습니다.");   
            util.setResult(result, "default");
            return;
        }
        
        String use_intt_id = StringUtil.null2void(idoOut1.getString("USE_INTT_ID"));
        
     	// 고객번호 체크
        if(use_intt_id.equals("")){
        	result.put("RSLT_CD","ZPER0003");
            result.put("RSLT_MSG","등록된 고객정보가 없습니다.");   
            util.setResult(result, "default");
            return;
        }
     	
     	// 아바타와 연결여부 조회
        JexData idoIn2 = util.createIDOData("CUST_LINK_SYS_INFM_R007");
        idoIn2.put("USE_INTT_ID", use_intt_id);  
        idoIn2.put("APP_ID", "ZEROPAY");  
        JexData idoOut2 =  idoCon.execute(idoIn2);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut2)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
            }
            result.put("RSLT_CD","ZPER0004");
            result.put("RSLT_MSG","아바타 연결여부 조회 중 오류가 발생하였습니다.");   
            util.setResult(result, "default");
            return;
        }
        
        // 연결된 아이디가 없을 경우
        if("0".equals(StringUtil.null2void(idoOut2.getString("LINK_CNT")))){
        	result.put("RSLT_CD","ZPER0005");
            result.put("RSLT_MSG","아바타와 연결된 고객이 아닙니다.");   
            util.setResult(result, "default");
            return;
        }
        
     	// 트랜젝션 시작
    	idoCon.beginTransaction();
     	
    	JexDataList<JexData> insertPointData = new JexDataRecordList<JexData>();
    	
    	// 상품권결제 리스트 수
		int pointCnt = zApiArr.size();
		// 상품권결제 리스트
		for(int i = 0; i < pointCnt; i++){
			JSONObject zApiObj = new JSONObject();
			zApiObj = (JSONObject)zApiArr.get(i);
			insertPointData.add(insertZeroTranPointHstr(zApiObj, use_intt_id, setl_dt, otran_time, tran_id, cust_ci, (i+1)));
		}
     	
		// 제로페이 결제내역 등록
        JexData idoIn3 = util.createIDOData("ZERO_TRAN_HSTR_U001");
    
        idoIn3.put("USE_INTT_ID", use_intt_id);  
        idoIn3.put("SETL_DT", setl_dt);  
        idoIn3.put("OTRAN_TIME", otran_time);  
        idoIn3.put("TRAN_ID", tran_id);
        idoIn3.put("TRNS_AMT", trns_amt);
        idoIn3.put("SRV_FEE", srv_fee);
        idoIn3.put("ADD_TAX_AMT", add_tax_amt);
        idoIn3.put("FEE", fee);  
        idoIn3.put("STTS", stts);  
        idoIn3.put("BIZ_CD", biz_cd);  
        idoIn3.put("OTRAN_BANK_NM", otran_bank_nm);  
        idoIn3.put("POINT_NM", "");
        idoIn3.put("ORG_PROC_DATE", org_proc_date);  
        idoIn3.put("ORG_PROC_SEQ", org_proc_seq);  
        idoIn3.put("AFLT_MANAGEMENT_NO", aflt_management_no);  
        idoIn3.put("MEST_BIZ_NO", mest_biz_no);  
        idoIn3.put("SER_BIZ_NO", ser_biz_no);  
        idoIn3.put("MEST_NM", mest_nm);  
        idoIn3.put("AFLT_ID", aflt_id);  
        idoIn3.put("CUST_CI", cust_ci);  
        
        JexData idoOut3 =  idoCon.execute(idoIn3);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut3)) {
            SQLException exce = (SQLException) DomainUtil.getErrorTrace(idoOut3);

			if (exce.getSQLState().equals("23505")) {
				insertPointData.close();
				result.put("RSLT_CD","ZPER0007");
	            result.put("RSLT_MSG","이미 등록된 결제 내역입니다.");   
	            util.setResult(result, "default");
	            idoCon.rollback();
	        	idoCon.endTransaction();
	        	return;
			}else{
				insertPointData.close();
				result.put("RSLT_CD","ZPER0006");
	            result.put("RSLT_MSG","결제내역 등록 중 오류가 발생하였습니다.");   
	            util.setResult(result, "default");
	            idoCon.rollback();
	        	idoCon.endTransaction();
	        	return;
			}
            
        }
        
     	// 제로페이거래상품권내역 삭제
        JexData idoIn4 = util.createIDOData("ZERO_TRAN_POINT_HSTR_D001");
        idoIn4.put("USE_INTT_ID", use_intt_id);  
        idoIn4.put("SETL_DT", setl_dt);  
        idoIn4.put("OTRAN_TIME", otran_time);  
        idoIn4.put("TRAN_ID", tran_id);  
        
        JexData idoOut4 =  idoCon.execute(idoIn4);
        
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut4)) {
        	insertPointData.close();
        	result.put("RSLT_CD"  , "ZPER0008");
	    	result.put("RSLT_MSG" , "상품권 결제내역 삭제 중 오류가 발생하였습니다.");
	    	util.setResult(result, "default");
	    	idoCon.rollback();
        	idoCon.endTransaction();
        	return;
        }
        
     	// 제로페이거래상품권내역 등록
        JexDataList<JexData> idoOutPointBatch = idoCon.executeBatch(insertPointData);

		if (DomainUtil.isError(idoOutPointBatch)) {
			insertPointData.close();
			result.put("RSLT_CD","ZPER0009");
            result.put("RSLT_MSG","상품권 결제내역 등록 중 오류가 발생하였습니다.");   
			idoCon.rollback();
        	idoCon.endTransaction();
        	return;
		}
		
		idoCon.commit();	
		idoCon.endTransaction();
		
        result.put("RSLT_CD","0000");
        result.put("RSLT_MSG","정상처리되었습니다.");
        /*
        // 보이스알림여부 조회
        JexData idoIn5 = util.createIDOData("CUST_LDGR_R040");
        idoIn5.put("USE_INTT_ID", use_intt_id);  
        
        JexData idoOut5 =  idoCon.execute(idoIn5);
        
        if(("Y").equals(idoOut5.getString("VOIC_NOTI_YN"))){
        	// 음성보이스 push 발송
            String control_cd = "VOIC_TRAN";
            String display_message  = "한국간편결제진흥원에서 정상 결제되었습니다.!";
            if(!stts.equals("1")){
            	display_message  = "한국간편결제진흥원에서 결제 취소되었습니다.!";
            }
            String control_message  = control_cd + "|";
            JSONObject rtnObj = PushApiMgnt.svc_MS0001(display_message, use_intt_id, control_cd, control_message, "");
            JSONObject res_data = (JSONObject)((JSONArray)rtnObj.get("_tran_res_data")).get(0);
            
            String result_cd = ""; 
            String result_msg = "";
            
            if((res_data.get("_result")==null) || (((String)res_data.get("_result")).equals(""))){
                result_cd = "9";
                result_msg = "발송실패";
                if((res_data.get("_error_cd")!=null) || (!((String)res_data.get("_error_cd")).equals(""))){
                	result_cd = res_data.getString("_error_cd");
                	result_msg = res_data.getString("_error_msg");
                }
            } else {
                result_cd = "0000";
                result_msg = "성공";
            }
            
         	// 푸시발송 결과 이력
            JexData idoIn6 = util.createIDOData("PUSH_SEND_HIS_C001");
            idoIn6.put("USE_INTT_ID", use_intt_id);
            idoIn6.put("NOTI_GB", control_cd);
            idoIn6.put("PUSH_MSG", display_message);
            idoIn6.put("ERROR_CD", result_cd);
            idoIn6.put("ERROR_MSG", result_msg);
            JexData idoOut6 = idoCon.execute(idoIn6);            
        }
        */
        
        util.setResult(result, "default");

%>
<%!
	private JexData insertZeroTranPointHstr(JSONObject point, String use_intt_id, String setl_dt 
			, String otran_time, String tran_id, String cust_ci, int trns_srno)
		throws JexException, JexBIZException {
	JexCommonUtil util = JexContext.getContext().getCommonUtil();
	  
	// 제로페이거래상품권내역 등록
	JexData idoIn5 = util.createIDOData("ZERO_TRAN_POINT_HSTR_C001");
	
	idoIn5.put("USE_INTT_ID", use_intt_id);
	idoIn5.put("SETL_DT", setl_dt);
	idoIn5.put("OTRAN_TIME", otran_time);
	idoIn5.put("TRAN_ID", tran_id);
	idoIn5.put("TRNS_SRNO", trns_srno);
	idoIn5.put("POINT_ID", point.getString("POINT_ID"));
	idoIn5.put("POINT_IMG_URL", point.getString("POINT_IMG_URL"));
	idoIn5.put("POINT_ICON_IMG_URL", point.getString("POINT_ICON_IMG_URL"));
	idoIn5.put("POINT_NM", point.getString("POINT_NM"));
	idoIn5.put("POINT_AMT", StringUtil.null2void(point.getString("AMT"),"0"));
	idoIn5.put("BAL_AMT", StringUtil.null2void(point.getString("BAL_AMT"),"0"));
	idoIn5.put("FACE_AMT", StringUtil.null2void(point.getString("FACE_AMT"),"0"));
	idoIn5.put("CUST_CI", cust_ci);

	return idoIn5;
}
%>