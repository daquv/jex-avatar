<%@page import="jex.json.JSONArray"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="com.avatar.api.mgnt.PushApiMgnt"%>
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
         * @File Title   : 테스트 푸시발송처리
         * @File Name    : test_0002_01_r001_act.jsp
         * @File path    : test
         * @author       : jepark (  )
         * @Description  : 테스트 푸시발송처리
         * @Register Date: 20210907083826
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

        @JexDataInfo(id="test_0002_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        String control_cd = "";
        String page_url = "";
        String display_message = "";
        String control_message = "";
        String relation_key = "";
        String use_intt_id = StringUtil.null2void(input.getString("USE_INTT_ID"));
        String clph_no = StringUtil.null2void(input.getString("CLPH_NO"));
        String noti_gb = StringUtil.null2void(input.getString("NOTI_GB"));
        String badg_cnt = "1";
        String voice_yn = "N";
        String voice_msg = "";
        String rslt_cd = "";
        String rslt_msg = "";
        
        
        
     	// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();
        
     	// 푸시센터 등록된 이용기관ID 조회
        JexData idoIn1 = util.createIDOData("CUST_LDGR_R041");
    	
        idoIn1.put("USE_INTT_ID", use_intt_id);
        idoIn1.put("CLPH_NO", clph_no);
			
        JexData idoOut1 =  idoCon.execute(idoIn1);
        
        if(DomainUtil.isError(idoOut1)) {
			if (util.getLogger().isDebug()){
	        	util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
	            util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
	        }
	    }
        
        relation_key = StringUtil.null2void(idoOut1.getString("USE_INTT_ID"));
		
        // 이용기관ID가 없을 경우
        if(relation_key.equals("")){
        	result.put("RSLT_CD", "9999");
            result.put("RSLT_MSG", "등록하신 푸시정보가 없습니다.");
            util.setResult(result, "default");
           	return;
        }
        
        String app_id = "";
     	// 카드매출브리핑
        if("001".equals(noti_gb)) {
        	control_cd = "000001";
        	display_message  = "학습완료 되었습니다.";
        }
        // 제로페이매출브리핑
        else if("002".equals(noti_gb)) {
        	control_cd = "ZSN001";
        	voice_yn = "Y";
        	// 제로페이매출브리핑 URL
        	//page_url = "ques_comm_01.act?INTE_INFO={'recog_txt':'','recog_data':{'Intent':'ZSN001','appInfo':{}}}";
        	page_url = "push_0000_01.act?INTENT="+control_cd;
        	display_message = "제로페이 매출 브리핑이 도착했어요!";
        	voice_msg = "제로페이 매출 브리핑이 도착했어요"; 
        	app_id= "ZEROPAY";
        } 
        // 카드매출브리핑
        else if("003".equals(noti_gb)) {
        	control_cd = "ZSC001";
        	voice_yn = "Y";
        	// 카드매출브리핑 URL
        	//page_url = "ques_comm_01.act?INTE_INFO={'recog_txt':'','recog_data':{'Intent':'ZSC001','appInfo':{}}}";
        	page_url = "push_0000_01.act?INTENT="+control_cd;
        	display_message = "카드 매출 브리핑이 도착했어요!";
        	voice_msg = "카드 매출 브리핑이 도착했어요";
        	app_id= "AVATAR";
        }
     	
        //control_message  = noti_gb + "|"+voice_yn+"|" + page_url;
        control_message  = noti_gb + "|"+voice_msg+"|" + page_url+ "|" +app_id;
        
        // 푸쉬 발송
        util.getLogger().debug(this, "display_message : "+display_message);
        util.getLogger().debug(this, "relation_key : "   +relation_key);
        util.getLogger().debug(this, "control_cd : "     +control_cd);
        util.getLogger().debug(this, "control_message : "+control_message);
        util.getLogger().debug(this, "badg_cnt : "       +badg_cnt);
        
        JSONObject rtnObj = PushApiMgnt.svc_MS0001(display_message, relation_key, control_cd, control_message, badg_cnt);
        
        JSONObject res_data = (JSONObject)((JSONArray)rtnObj.get("_tran_res_data")).get(0);
        
        if((res_data.get("_result")==null) || (((String)res_data.get("_result")).equals(""))){
        	rslt_cd = "9";
        	rslt_msg = "발송실패";
            if((res_data.get("_error_cd")!=null) || (!((String)res_data.get("_error_cd")).equals(""))){
            	rslt_cd = res_data.getString("_error_cd");
            	rslt_msg = res_data.getString("_error_msg");
            }
        } else {
        	rslt_cd = "0000";
        	rslt_msg = "성공";
        }
        
        result.put("RSLT_CD", rslt_cd);
        result.put("RSLT_MSG", rslt_msg);
        
        util.setResult(result, "default");

%>