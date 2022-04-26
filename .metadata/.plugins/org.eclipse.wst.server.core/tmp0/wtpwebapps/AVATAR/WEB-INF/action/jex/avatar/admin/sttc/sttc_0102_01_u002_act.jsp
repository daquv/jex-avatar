<%@page contentType="text/html;charset=UTF-8" %>
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

<%@page import="jex.json.JSONObject"%>
<%@page import="jex.json.JSONArray"%>
<%@page import="com.avatar.api.mgnt.PushApiMgnt"%>
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 질의현황 학습상태 변경
         * @File Name    : sttc_0102_01_u002_act.jsp
         * @File path    : admin.sttc
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20210907165417
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

        @JexDataInfo(id="sttc_0102_01_u002", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        String RSLT_CD = "0000";
     	// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
     	try{
     		JexDataList rec = input.getList("INSERT_REC");
     		if(rec != null){
     			// IDO Connection
     			idoCon.beginTransaction();
     	
     			while(rec.next()) {
     				JexData data = rec.get();
       			
     				String QUES_DTM = StringUtil.null2void(data.getString("QUES_DTM"));
     				String USE_INTT_ID = StringUtil.null2void(data.getString("USE_INTT_ID"));
     				String LRN_STTS = StringUtil.null2void(data.getString("LRN_STTS"));
     			
     				JexData idoIn1 = util.createIDOData("QUES_HSTR_U001");
     				idoIn1.put("QUES_DTM", QUES_DTM);
     				idoIn1.put("USE_INTT_ID", USE_INTT_ID);
     				idoIn1.put("LRN_STTS", LRN_STTS);
     				JexData idoOut1 = idoCon.execute(idoIn1);
     				//도메인 에러 검증
     				if (DomainUtil.isError(idoOut1)) {
     					if (util.getLogger().isDebug())
     					{
     						util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
     						util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
     					}
     					idoCon.rollback();
     					throw new JexWebBIZException(idoOut1);
     				}
     				RSLT_CD = "0000";
     				if("1".equals(StringUtil.null2void(data.getString("LRN_STTS")))){
     					String result_cd = "";
     					String result_msg = "";
     					String page_url = "basic_0013_01.act?MENU_DV=02";
     					String control_cd = "001";
     					String control_message  = "001" + "|N|" + page_url;
     					String relation_key = USE_INTT_ID; // 발송대상 이용기관ID
     					String display_message = "답변 받지 못한 질의가 학습되었어요! \""+StringUtil.null2void(data.getString("VOIC_CTT"))+"\""; //“사용자 질의내용”은 실제 질의내용 셋팅

     					//badge cnt 조회
     					JexData idoIn3 = util.createIDOData("CUST_LDGR_R039");
     					idoIn3.put("USE_INTT_ID", USE_INTT_ID);
     					JexData idoOut3 = idoCon.execute(idoIn3);
     					
     					String badge_cnt = String.valueOf( Integer.parseInt(idoOut3.getString("BADG_CNT"))+1 );
     					//badge update
     					JexData idoIn4 = util.createIDOData("CUST_LDGR_U008");
     					idoIn4.put("USE_INTT_ID", USE_INTT_ID);
     					idoIn4.put("BADG_CNT", badge_cnt);
     					JexData idoOut4 = idoCon.execute(idoIn4);
     					
     					//push 전송
     					JSONObject rtnObj = PushApiMgnt.svc_MS0001(display_message, relation_key, control_cd, control_message, badge_cnt);
     					JSONObject res_data = (JSONObject)((JSONArray)rtnObj.get("_tran_res_data")).get(0);

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

     					// 푸시발송 결과 이력 등록
     					JexData idoIn2 = util.createIDOData("PUSH_SEND_HIS_C001");
     					idoIn2.put("USE_INTT_ID", USE_INTT_ID);
     					idoIn2.put("USE_INTT_ID", USE_INTT_ID);
     					idoIn2.put("NOTI_GB", "001");
     					idoIn2.put("PUSH_MSG", display_message);
     					idoIn2.put("ERROR_CD", result_cd);
     					idoIn2.put("ERROR_MSG", result_msg);
     					JexData idoOut2 = idoCon.execute(idoIn2);
     		     	}
     				
     			}
     			idoCon.commit();
     		} 
     		else {
     			RSLT_CD = "9999";
     		}
     	} catch(Exception e){
     		RSLT_CD = "9999";
     		idoCon.rollback();
     	} finally {
     		idoCon.endTransaction();
     	}
             result.put("RSLT_CD", RSLT_CD);

        util.setResult(result, "default");

%>