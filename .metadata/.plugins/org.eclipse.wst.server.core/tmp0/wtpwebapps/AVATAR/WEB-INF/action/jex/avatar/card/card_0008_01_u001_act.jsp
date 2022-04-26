<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.json.JSONArray"%>
<%@page import="com.avatar.comm.CommUtil"%>
<%@page import="com.avatar.comm.ApiUtil"%>
<%@page import="com.avatar.comm.BizLogUtil"%>
<%@page import="com.avatar.api.mgnt.CooconApi"%>
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
         * @File Title   : 카드매입관리-수정처리
         * @File Name    : card_0008_01_u001_act.jsp
         * @File path    : card
         * @author       : kth91 (  )
         * @Description  : 카드매입관리-수정처리
         * @Register Date: 20200128164202
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

        @JexDataInfo(id="card_0008_01_u001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        JexDataCMO UserSession = SessionManager.getSession(request, response);
        String user_id 		= (String)UserSession.get("CUST_CI");
        String bsnn_no 		= (String)UserSession.get("USE_INTT_ID");
        String scqkey  		= (String)UserSession.get("SCQKEY");
        String use_intt_id  = (String)UserSession.get("USE_INTT_ID");
        
        String bank_cd 		= StringUtil.null2void(input.getString("BANK_CD"));
        String card_no		= StringUtil.null2void(input.getString("CARD_NO"));
    	String web_id  		= StringUtil.null2void(input.getString("WEB_ID"));
    	String web_pwd  	= StringUtil.null2void(input.getString("WEB_PWD"));
//     	String scqkey  		= StringUtil.null2void(input.getString("SCQKEY"));
    	// 결제일
    	String date_payment = ""; 
        
        bank_cd = bank_cd.substring(5);
    	web_pwd = CommUtil.getDecrypt(scqkey, web_pwd);
        
        try{
        	// bc 카드일경우(기업,대구, 부산, 경남, SC)
        	if("060".equals(bank_cd) || "061".equals(bank_cd) || "062".equals(bank_cd) || 
				"063".equals(bank_cd) || "064".equals(bank_cd)){
                bank_cd = "006";
            }
            
            // 법인카드 결제일 조회 - 실시간
            JSONObject resData = CooconApi.getCorpCardPaymentDay(bank_cd, web_id, web_pwd, card_no);

         	// 외부이력테이블에 응답 결과 이력 입력
//             ExtnTrnsHis.insert(use_intt_id, "C", "0327", resData.getString("RESULT_CD"), resData.getString("RESULT_MG"));
         
            if("00000000".equals(resData.get("RESULT_CD"))){
            	JSONArray jsonArr = (JSONArray) resData.get("RESP_DATA");
            	JSONObject resDataTemp = new JSONObject();
            	String tempCardNo = card_no;
            	
            	boolean cardNoChk = false;
            	
            	for(int resInt = 0 ; resInt < jsonArr.size(); resInt++ ){
                    resDataTemp = (JSONObject)jsonArr.get(resInt);
                    
                    tempCardNo = CommUtil.getNonStrCardNo(card_no, (String)resDataTemp.get("CARD_NO_TYPE"));
                    
                    // 결제일 가져오기
                    if(tempCardNo.equals(resDataTemp.get("CARD_NO"))){
                        date_payment = (String)resDataTemp.get("DATE_PAYMENT");
                        cardNoChk = true;
                        break;
                    }
                }
            	
    			if(!cardNoChk){
                    result.put("RSLT_CD", "9999");
                    result.put("RSLT_MSG", "일치하는 카드번호가 없습니다.");
                    util.setResult(result, "default");
            		return;
                }
    			
    			// 결제일이 한자리인 경우
    			if(date_payment.length() == 1){
    	            date_payment = "0" + date_payment;
    	        }
    			
        		BizLogUtil.debug(this, "date_payment :: "+date_payment);
            }else{
            	result.put("RSLT_CD", (String)resData.get("RESULT_CD"));
//             	result.put("RSLT_MSG", StringUtil.null2void(ApiUtil.getCooconErroMsgStr((String)resData.get("RESULT_MG"))));
            	result.put("RSLT_MSG", StringUtil.null2void((String)resData.get("RESULT_MG")));
                util.setResult(result, "default");
        		return;
            }
                
        }catch(Exception e1){
        	BizLogUtil.debug(this,"Exception e1 :: "+e1.getMessage());
        	result.put("RSLT_CD", "9999");
            result.put("RSLT_MSG", e1.getMessage());
            util.setResult(result, "default");
    		return;
        }
        
		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
        idoCon.beginTransaction();
        
    	// 신용카드 결제일 변경
        JexData idoIn1 = util.createIDOData("CARD_INFM_U004");
    
    	idoIn1.put("SETL_DT", date_payment);
    	idoIn1.put("CORR_ID", user_id);
    	idoIn1.put("USE_INTT_ID", use_intt_id);
    	idoIn1.put("CARD_NO", card_no);
    
        JexData idoOut1 =  idoCon.execute(idoIn1);
    
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut1)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
            }
            
            idoCon.rollback();
    		idoCon.endTransaction();
    		result.put("RSLT_CD", DomainUtil.getErrorCode(idoOut1));
            result.put("RSLT_MSG", DomainUtil.getErrorMessage(idoOut1));
    		util.setResult(result, "default");
    		return;
        }

        try{
            // bc 카드일경우(기업,대구, 부산, 경남, SC)
            if( "060".equals(bank_cd) || "061".equals(bank_cd) || "062".equals(bank_cd) || 
                "063".equals(bank_cd) || "064".equals(bank_cd)){
                bank_cd = "006";
            }

            // 법인카드정보변경
            JSONObject resData = CooconApi.updateCorpCard(bank_cd, bsnn_no, web_id, web_pwd, card_no, date_payment);

         	// 외부이력테이블에 응답 결과 이력 입력
//             ExtnTrnsHis.insert(use_intt_id, "C", "0100_003_U", resData.getString("ERRCODE"), resData.getString("ERRMSG"));
         
            if("00000000".equals(resData.get("ERRCODE"))){
            	idoCon.commit();
            	idoCon.endTransaction();
            	result.put("RSLT_CD", "0000");
                result.put("RSLT_MSG", (String)resData.get("ERRMSG"));
            	util.setResult(result, "default");
        		return;
            }else{
            	idoCon.rollback();
            	idoCon.endTransaction();
            	result.put("RSLT_CD", (String)resData.get("ERRCODE"));
//             	result.put("RSLT_MSG", StringUtil.null2void(ApiUtil.getCooconErroMsgStr((String)resData.get("RESULT_MG"))));
				result.put("RSLT_MSG", StringUtil.null2void((String)resData.get("RESULT_MG")));
            	util.setResult(result, "default");
        		return;
            }
        	
        }catch(Exception e2){
        	BizLogUtil.debug(this,"Exception e2 :: "+e2.getMessage());
        	idoCon.rollback();
    		idoCon.endTransaction();
    		result.put("RSLT_CD", "9999");
            result.put("RSLT_MSG", e2.getMessage());
    		util.setResult(result, "default");
    		return;
        }
%>