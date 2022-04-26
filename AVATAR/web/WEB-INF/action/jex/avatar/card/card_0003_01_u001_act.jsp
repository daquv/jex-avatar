<%@page import="com.avatar.api.mgnt.BizmApiMgnt"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="com.avatar.comm.CommUtil"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="com.avatar.api.mgnt.CooconApi"%>
<%@page import="com.avatar.comm.ApiUtil"%>
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
         * @File Title   : 여신금융협회 변경
         * @File Name    : card_0003_01_u001_act.jsp
         * @File path    : card
         * @author       : kth91 (  )
         * @Description  : 여신금융협회 변경
         * @Register Date: 20200128144213
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

        @JexDataInfo(id="card_0003_01_u001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        JexDataCMO userSession = SessionManager.getSession(request, response);
    	String decryptKey = userSession.getString("SCQKEY");
    	String bsnn_no = userSession.getString("USE_INTT_ID");
    	String stts = StringUtil.null2void(input.getString("STTS"));
    	String web_pwd = StringUtil.null2void(input.getString("WEB_PWD"));
    	String web_pwd_h = StringUtil.null2void(input.getString("WEB_PWD_CHK"));

    	// 암호화 값이 넘어 오면 복호화, 암호화 값이 넘어 오지 않으면 기존 암호값이 넘어 온다(id만 변경할 경우)
    	if(!"".equals(web_pwd_h)){
    		web_pwd = CommUtil.getDecrypt(decryptKey, web_pwd_h);
    	}
    	
    	JSONObject resData = new JSONObject();
    	JSONObject resData2 = new JSONObject();

    	try{

    		resData = CooconApi.checkCrefiaVerification(input.getString("WEB_ID"), web_pwd);

    		// TODO : 개발 서버는 접속이 안됨. 운영에서 테스트 해야됨.
    		boolean devYn = CommUtil.getHostUrlScrap().contains("dev");
    		if(devYn){
    			resData.put("ERRCODE", "00000000");
    		}
    		
    		// 외부이력테이블에 응답 결과 이력 입력
//             ExtnTrnsHis.insert(userSession.getString("USE_INTT_ID"), "C", "0103", resData.getString("ERRCODE"), resData.getString("ERRMSG"));
    		
    		// 성공
    		if("00000000".equals(resData.get("ERRCODE"))){

    			if("1".equals(stts)){
    				//수정
    				resData2 = CooconApi.updateCrefia(bsnn_no, bsnn_no, input.getString("WEB_ID"), web_pwd);
    				// 외부이력테이블에 응답 결과 이력 입력
//                     ExtnTrnsHis.insert(userSession.getString("USE_INTT_ID"), "C", "0100_004_U", resData2.getString("ERRCODE"), resData2.getString("ERRMSG"));
    			}else{
    				//등록
    				resData2 = CooconApi.insertCrefia(bsnn_no, bsnn_no, input.getString("WEB_ID"), web_pwd);
    				// 외부이력테이블에 응답 결과 이력 입력
//                     ExtnTrnsHis.insert(userSession.getString("USE_INTT_ID"), "C", "0100_004_I", resData2.getString("ERRCODE"), resData2.getString("ERRMSG"));
    			}
    			
    			if("00000000".equals(resData2.get("ERRCODE"))){// 성공
    				// IDO Connection
    		        JexConnection idoCon = JexConnectionManager.createIDOConnection();  
    			
    				idoCon.beginTransaction();
    				
    				// 증빙설정정보 변경
    				JexData idoIn1 = util.createIDOData("EVDC_INFM_U006");
    				
    				idoIn1.put("WEB_ID", input.getString("WEB_ID").replaceAll("'", "''"));
    				idoIn1.put("WEB_PWD", web_pwd);
    				idoIn1.put("STTS", "1");
    				idoIn1.put("CORR_ID", userSession.getString("CUST_CI"));
    				idoIn1.put("USE_INTT_ID", userSession.getString("USE_INTT_ID"));
    				idoIn1.put("EVDC_DIV_CD", "10");
    				idoIn1.put("BIZ_NO", bsnn_no);
    		    
    		        JexData idoOut1 =  idoCon.execute(idoIn1);
    		    
    		        // 도메인 에러 검증
    		        if (DomainUtil.isError(idoOut1)) {
    		            if (util.getLogger().isDebug())
    		            {
    		                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
    		                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
    		            }
    		            
    		            idoCon.rollback();
    					
    		            result.put("RSLT_CD", "SOER1000");
    					result.put("RSLT_MSG", "카드매출 증빙정보 수정 시 오류가 발생했습니다.");
    		        }else{

				        idoCon.commit();
				        
						// 매출신용카드등록여부 값 수정
// 						userSession.put("RCV_CARD_REG_YN", "Y");
						
						result.put("RSLT_CD", (String)resData2.get("ERRCODE"));
						result.put("RSLT_MSG", (String)resData2.get("ERRMSG"));
						
						
						// 계정 등록 성공일 경우 알림톡 발송
						if(!"1".equals(stts)){
							// 고객핸드폰번호 조회
							JexData idoIn2 = util.createIDOData("CUST_LDGR_R035");
			            	
							idoIn2.put("USE_INTT_ID", userSession.getString("USE_INTT_ID"));
			 				
			                JexData idoOut2 =  idoCon.execute(idoIn2);
			                
			                if(DomainUtil.isError(idoOut2)) {
			 					if (util.getLogger().isDebug())
			 		            {
			 		                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
			 		                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
			 		            }
			 		        }
			                
			                String clph_no = StringUtil.null2void(idoOut2.getString("CLPH_NO"));
			                
							// 여신금융협회 연동 알림톡 전송
							String msg = "";
							msg += "여신금융협회 데이터가 아바타와 연결되었습니다.\n\n";
							msg += "이제 아바타에게 이렇게 물어보세요!\n\n";
							msg += "\"어제 카드 매출 얼마야?\"\n";
							msg += "\"이번달 카드매출 입금예정액은?\"\n";
							msg += "\"국민카드 카드매출 얼마야?\"";
									
							String tmplId = "askavatar_003_CFA";
					        
					        JSONObject button1 = new JSONObject();
					        button1.put("name"    			, "에스크아바타 열기");
					        button1.put("type"      		, "AL");
					        button1.put("scheme_android"    , "kakaoa51a93ebcd6f4145ad28e1fa20cfff50://kakaolink");
					        button1.put("scheme_ios"      	, "kakaoa51a93ebcd6f4145ad28e1fa20cfff50://kakaolink");
					        
					        BizmApiMgnt.apiJoinSendMsg(clph_no, msg, tmplId, button1);
						}
    		        }
    		        
    				idoCon.endTransaction();
    			}else{
    				result.put("RSLT_CD", (String)resData2.get("ERRCODE"));
    				result.put("RSLT_MSG", (String)resData2.get("ERRMSG"));
    			}
    			
    		}else{
    			result.put("RSLT_CD", (String)resData.get("ERRCODE"));
    			result.put("RSLT_MSG", (String)resData2.get("ERRMSG"));
    		}
    		
    	}catch(Exception e){
    		util.getLogger().debug("e.getMessage()   ::"+e.getMessage());
    	}

        util.setResult(result, "default");

%>