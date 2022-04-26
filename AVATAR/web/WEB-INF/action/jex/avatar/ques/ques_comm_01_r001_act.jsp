<%@page import="com.avatar.comm.SvcDateUtil"%>
<%@page import="com.avatar.api.mgnt.CooconApi"%>
<%@page contentType="text/html;charset=UTF-8" %>

<%@page import="jex.util.DomainUtil"%>
<%@page import="jex.util.StringUtil"%>
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
<%@page import="jex.json.JSONArray"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="jex.json.parser.JSONParser"%>
<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.Arrays" %>
<%@page import="com.avatar.api.mgnt.ContentApiMgnt" %>
<%@page import="com.avatar.comm.CommUtil"%>
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 질의조회
         * @File Name    : ques_comm_01_r001_act.jsp
         * @File path    : ques
         * @author       : moving (  )
         * @Description  : 
         * @Register Date: 20200309142912
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

        @JexDataInfo(id="ques_comm_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

     // IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
        // Get Session
        JexDataCMO userSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
        String APP_ID = StringUtil.null2void(userSession.getString("APP_ID"), "AVATAR");
        String LGIN_APP = StringUtil.null2void(userSession.getString("LGIN_APP"), "AVATAR");

		//음성 결과  ex) INTE_INFO:{"recog_txt":"매출 매입 데이타 ?","recog_data":{"Intent":"SAMPLE","appInfo":{"NE-DAY":"오늘"}} };
		JSONObject inteInfo = (JSONObject)JSONParser.parser(StringUtil.null2void(input.getString("INTE_INFO")));

		String recog_txt = StringUtil.null2void((String)inteInfo.get("recog_txt"));
		JSONObject recog_data = (JSONObject)inteInfo.get("recog_data");
		String Intent = StringUtil.null2void((String)recog_data.get("Intent"));
		JSONObject appInfo = (JSONObject)recog_data.get("appInfo");
		String appId = "";
		String apiId = "";
		
		/*
		String API_USE_YN = "";
		JexData idoIn1 = null;
		//-------------------------------------
		//인텐트정보에 등록된 html, query 가져오기
		//-------------------------------------
		if(APP_ID.equals("SERP")){
			if(!Intent.startsWith(APP_ID)){
				Intent = Intent+"_serp";
			}
			// 경리나라 질의
			idoIn1 = util.createIDOData("INTE_INFM_R011");
			idoIn1.put("INTE_CD", Intent);
			idoIn1.put("USE_INTT_ID", USE_INTT_ID);
			idoIn1.put("APP_ID", APP_ID);			
		}else{
			// 아바타로 접근한 경우 설정된 우선순위 질의
			idoIn1 = util.createIDOData("INTE_INFM_R006");
			idoIn1.put("INTE_CD", Intent);
			//idoIn1.put("INTE_CD", "SCN003");
			idoIn1.put("USE_INTT_ID", USE_INTT_ID);
		}
		
		JexData idoOut1 = idoCon.execute(idoIn1);
		if (DomainUtil.isError(idoOut1)) {
			if (util.getLogger().isDebug())
			{
				util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
				util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
			}
			throw new JexWebBIZException(idoOut1);
		}
		
		
		result.put("OTXT_HTML", StringUtil.null2void(idoOut1.getString("OTXT_HTML")) );
		
		if(APP_ID.equals("SERP")){
			API_USE_YN = "Y";
		}else{
			if(!StringUtil.null2void(idoOut1.getString("APP_ID")).equals("")
				//!!!테스트용 추가 코드 추후 삭제!!!
				&& StringUtil.null2void(idoOut1.getString("API_USE_YN")).equals("Y")
					){
				API_USE_YN = "Y";
			}else{
				API_USE_YN = "N";
			}
			//API_USE_YN = StringUtil.null2void(idoOut1.getString("API_USE_YN"), "N");
		}
		*/

		JSONObject rslt_ctt = new JSONObject();
		
		//-------------------------------------
		//인텐트정보에 등록된 html, query 가져오기
		//-------------------------------------
		//JexData idoIn1 = util.createIDOData("INTE_INFM_R006");
		// 로그인한 APP에 해당하는 질의만 보여줌.
		JexData idoIn1 = util.createIDOData("INTE_INFM_R011");
		idoIn1.put("INTE_CD", Intent);
		idoIn1.put("USE_INTT_ID", USE_INTT_ID);
		idoIn1.put("APP_ID", LGIN_APP);
		
		JexData idoOut1 = idoCon.execute(idoIn1);
		if (DomainUtil.isError(idoOut1)) {
			if (util.getLogger().isDebug())
			{
				util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
				util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
			}
			throw new JexWebBIZException(idoOut1);
		}
		result.put("OTXT_HTML", StringUtil.null2void(idoOut1.getString("OTXT_HTML")) );
		
		String api_use_yn = StringUtil.null2void(idoOut1.getString("API_USE_YN"));
		
		// 맞춤질의
		if("MON001".equals(Intent) || "MON002".equals(Intent) || "MON003".equals(Intent) || "MON004".equals(Intent)){
			api_use_yn = "Y";
		}
		
		//-----------------------------
		//API 방식
		//  - 외부 API연계시스템 에서 데이타조회한다. (경리나라 등..)
		//-----------------------------
		//API 호출여부 체크
		if(StringUtil.isBlank(idoOut1.getString("OTXT_SQL1"))  //DB쿼리 없는 경우 API사용
				|| (!StringUtil.isBlank(idoOut1.getString("OTXT_SQL1")) && "Y".equals(api_use_yn))//DB쿼리 있지만 API사용으로 설정한경우
			//|| (!StringUtil.isBlank(idoOut1.getString("OTXT_SQL1")) && "Y".equals(API_USE_YN))//DB쿼리 있지만 API사용으로 설정한경우
		){
			
			appId = idoOut1.getString("APP_ID");
			apiId = idoOut1.getString("API_ID");
			
			String testUser =  ",01028602673,01099994486,01038698349,01041212036,01031687616,01053013762,01073677899,01025999667,01045541465,01025396636,01063470367,01012341234,01072349760";
			String zeroIntent =  ",ZNN003,ZNN006,ZSN001,ZNN007,";
			
			//--------------------
			//API 사용권한 체크
			//--------------------
			//비플 제로페이 APP 
			
			//if("N".equals(API_USE_YN)){
			if(zeroIntent.indexOf(Intent) > -1){
				// 제로페이 결제 수수료(ZNN003)
				// 제로페이 입금 예정액(ZNN006), 제로페이 입금 예정액-상세(Z-011)
				// 제로페이 매출 브리핑(ZSN001)
				rslt_ctt = ContentApiMgnt.getInstance().executeZeropayApi(USE_INTT_ID, Intent, appInfo);
			} else if("N".equals(api_use_yn)){
			
			} else if(!"N".equals(api_use_yn)){
				
				if("BIZPLAY_ZEROPAY".equals(appId) && (testUser.indexOf(userSession.getString("CLPH_NO")) == -1 ) ){
					rslt_ctt.put("RSLT_CD","8888");
				}
				//경리나라 가입고객수 (특정사용자외에는 조회되지 않도록)
				else if("customerCount".equals(apiId) && ( testUser.indexOf(userSession.getString("CLPH_NO")) == -1 ) ){
					rslt_ctt.put("RSLT_CD","8888");
				} else if("avtmList".equals(apiId) && ( testUser.indexOf(userSession.getString("CLPH_NO")) == -1 ) ){
					rslt_ctt.put("RSLT_CD","8888");
				}
				else{
					rslt_ctt = ContentApiMgnt.getInstance().executeApi(appId, apiId, appInfo, userSession, Intent, input.getString("PAGE_NO"), input.getString("PAGE_CNT"));
					// 자금현황인 경우 SQL REC가 없을 경우 해당 필드 제거
					if("BDW003".equals(Intent)){	
						String sql2Api = rslt_ctt.getString("SQL2");
						String sql3Api = rslt_ctt.getString("SQL3");
						if(sql2Api.equals("") || sql2Api.equals("[]")){
							rslt_ctt.remove("SQL2");
						}
						if(sql3Api.equals("") || sql3Api.equals("[]")){
							rslt_ctt.remove("SQL3");
						}
					}
				}
			}
		}
		
			
		//-----------------------------
		//DB 방식
		//  - 아바타 DB에 등록된 쿠콘스크래핑 데이타 사용
		//  - 어드민에서 등록한 query문 3개를 실행하여 결과값을 RSLT_CTT에 넣는다
		//  - 단건인경우 RSLT_CTT 에 넣기
		//  - 다건인경우 SQL1,SQL2,SQL3 이름으로 RSLT_CTT에 넣기
		//  - ex) sqltype:F ==> RSLT_CTT:{"A":"a"} , sqltype:R ==> RSLT_CTT:{"SQL1":[{"A":"a"}]}
		//-----------------------------
		//모든 앱에서 쓰이는 인텐트
		String allAPPIntent = ",SCT003,PCT002,BNN001,";
		if( StringUtil.isBlank(appId) || "9999".equals(rslt_ctt.getString("RSLT_CD")) || Intent.indexOf("NNN") > -1 || allAPPIntent.indexOf(Intent) > -1 ){// 예외 인텐트인경우
			
			String[] sqlType = {StringUtil.null2void(idoOut1.getString("OTXT_SQL1_TYPE")),	StringUtil.null2void(idoOut1.getString("OTXT_SQL2_TYPE")),	StringUtil.null2void(idoOut1.getString("OTXT_SQL3_TYPE")),	StringUtil.null2void(idoOut1.getString("OTXT_SQL4_TYPE"))};
			String[] sqlTxt  = {StringUtil.null2void(idoOut1.getString("OTXT_SQL1")),	StringUtil.null2void(idoOut1.getString("OTXT_SQL2")),	StringUtil.null2void(idoOut1.getString("OTXT_SQL3")),	StringUtil.null2void(idoOut1.getString("OTXT_SQL4"))};
			if(APP_ID.contains("SERP") && Intent.indexOf("NNN") == -1 && allAPPIntent.indexOf(Intent) == -1){
				
			} else{
				for(int i=0; i < sqlType.length; i++){
					if(StringUtil.isBlank(sqlTxt[i])){
						if("R".equals(sqlType[i])){ //F:단건, R:다건
							//rslt_arr.add(new JSONArray());
							// 자금현황이 아닌 경우에만 초기화
							if(!"BDW003".equals(Intent)){	
								rslt_ctt.put("SQL"+(i+1), new JSONArray());
							}
						}else{
							//rslt_arr.add(new JSONObject());
						}
					}else{
						String query = sqlTxt[i];
						Pattern pattern = Pattern.compile(":([a-z-A-Z-0-9_]*)"); 
						Matcher matcher = pattern.matcher(query);
						
						//Query의 input항목을 세션,음성결과등... 값으로 채우기
						while(matcher.find()){
							if(userSession.hasField(matcher.group(1))){
								query = query.replace(":"+matcher.group(1), "'"+userSession.get(matcher.group(1))+"'"); //세션값 셋팅
							}else if(appInfo.containsKey(matcher.group(1).toUpperCase())){
								query = query.replace(":"+matcher.group(1), "'"+appInfo.get(matcher.group(1).toUpperCase())+"'"); //음성결과값 셋팅
							}else if("STR_IDX".equals(matcher.group(1))){
								query = query.replace(":"+matcher.group(1), String.valueOf((Integer.parseInt(input.getString("PAGE_NO"))-1) * Integer.parseInt(input.getString("PAGE_CNT")))); //페이징 시작 index
							}else if("PAGE_CNT".equals(matcher.group(1))){
								query = query.replace(":"+matcher.group(1), input.getString(matcher.group(1)));  //페이징 갯수
							}else if("INTE_CD".equals(matcher.group(1))){
								query = query.replace(":"+matcher.group(1), "'"+Intent+"'");  //INTENT
							}else if("RECOG_TXT".equals(matcher.group(1))){
								query = query.replace(":"+matcher.group(1), "'"+recog_txt+"'");	//음성값 셋팅
							}else if("APP_ID".equals(matcher.group(1))){
								query = query.replace(":"+matcher.group(1), "'"+LGIN_APP+"'"); //APP_ID
							}
							else if("NE-B-Year".equals(matcher.group(1))){
								Object yearVal = appInfo.get("NE-B-YEAR")!=null ? appInfo.get("NE-B-YEAR") : appInfo.get("NE-YEAR1");
	 							query = query.replace(":"+matcher.group(1), "'"+yearVal+"'"); //음성결과값 셋팅
	 						}  else if("APP_INFO".equals(matcher.group(1))){
	 							query = query.replace(":"+matcher.group(1), "'"+appInfo+"'");	//음성값 셋팅
	 						} else if("_TXOF_LIST".equals(matcher.group(1))){
	 							System.out.println(appInfo.get("TXOF_LIST"));
	 							query = query.replace(":"+matcher.group(1), " "+appInfo.get("TXOF_LIST")+" ");	//음성값 셋팅
	 						}
							else{
								if(!"".equals(StringUtil.null2void(matcher.group(1)))){
									query = query.replace(":"+matcher.group(1), "''");
								}
							}
						}
						
						//-------------------------------------
						//질의 쿼리 조회
						//-------------------------------------
						JexData idoIn2 = util.createIDOData("QUES_COMM_R001");
						IDODynamic dynamic_0= new IDODynamic();
						dynamic_0.addSQL(query);
						idoIn2.put("DYNAMIC_0", dynamic_0);
						JexData idoOut2 = idoCon.execute(idoIn2);
						if (DomainUtil.isError(idoOut2)) {
							if (util.getLogger().isDebug())
							{
								util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
								util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
							}
							throw new JexWebBIZException(idoOut2);
						}
						JSONArray jsonArr = (JSONArray)JSONParser.parser(idoOut2.getString("JSON"));
						if("R".equals(sqlType[i])){ //F:단건, R:다건
							// 자금현황인 경우 SQL REC가 있을 경우에만 셋팅
							if("BDW003".equals(Intent)){	
								if(jsonArr.size() > 0){
									rslt_ctt.put("SQL"+(i+1), new JSONArray());
									rslt_ctt.put("SQL"+(i+1), jsonArr);	
								}
							}else{
								rslt_ctt.put("SQL"+(i+1), jsonArr);
							}
						}else{
							for(Object obj : jsonArr){
								for(Object key : ((JSONObject)obj).keySet()){
									if( key instanceof String ) {
										}
									rslt_ctt.put(key.toString().toUpperCase(), ((JSONObject)obj).get(key));
								}
							}
						}
					}
				}
			}
		}
		
		//1 페이지에서만 실행...
		if("1".equals(input.getString("PAGE_NO"))){
			
		}
	
		/*
		// 환율조회
		if("BNN001".equals(Intent)){
			String currency = StringUtil.null2void(appInfo.getString("NE-NATION"), "USD");
			String nation = "미국";
			String currency_baisc = "달러";
			
			if(currency.equals("USD")){ nation = "미국"; currency_baisc = "1달러";}
			else if(currency.equals("JPY")){ nation = "일본"; currency_baisc = "100엔";}
			else if(currency.equals("EUR")){ nation = "유럽연합"; currency_baisc = "1유로";}
			else if(currency.equals("CNY")){ nation = "중국"; currency_baisc = "1위안";}
			else if(currency.equals("GBP")){ nation = "영국"; currency_baisc = "1파운드";}
			else if(currency.equals("CHF")){ nation = "스위스"; currency_baisc = "1프랑";}
			else if(currency.equals("CAD")){ nation = "캐나다"; currency_baisc = "1달러";}
			else if(currency.equals("HKD")){ nation = "홍콩"; currency_baisc = "1달러";}
			else if(currency.equals("SEK")){ nation = "스웨덴"; currency_baisc = "1크로네";}
			else if(currency.equals("AUD")){ nation = "호주"; currency_baisc = "1달러";}
			else if(currency.equals("DKK")){ nation = "덴마크"; currency_baisc = "1크로네";}
			else if(currency.equals("NOK")){ nation = "노르웨이"; currency_baisc = "1크로네";}
			else if(currency.equals("SAR")){ nation = "사우디아라비아"; currency_baisc = "1리알";}
			else if(currency.equals("KWD")){ nation = "쿠웨이트"; currency_baisc = "1디나르";}
			else if(currency.equals("AED")){ nation = "아랍에미리트"; currency_baisc = "1디히람";}
			else if(currency.equals("SGD")){ nation = "싱가포르"; currency_baisc = "1달러";}
			else if(currency.equals("MYR")){ nation = "말레이지아"; currency_baisc = "1링기트";}
			else if(currency.equals("NZD")){ nation = "뉴질랜드"; currency_baisc = "1달러";}
			else if(currency.equals("THB")){ nation = "태국"; currency_baisc = "1바트";}
			else if(currency.equals("IDR")){ nation = "인도네시아"; currency_baisc = "100루피아";}
			else if(currency.equals("TWD")){ nation = "대만"; currency_baisc = "1달러";}
			else if(currency.equals("PHP")){ nation = "필리핀"; currency_baisc = "1페소";}
			else if(currency.equals("INR")){ nation = "인도"; currency_baisc = "1루피";}
			else if(currency.equals("RUB")){ nation = "러시아"; currency_baisc = "1루블";}
			else if(currency.equals("ZAR")){ nation = "남아프리카공화국"; currency_baisc = "1랜드";}
			else if(currency.equals("MXN")){ nation = "멕시코"; currency_baisc = "1페소";}
			else if(currency.equals("VND")){ nation = "베트남"; currency_baisc = "100동";}
			else if(currency.equals("PLN")){ nation = "폴란드"; currency_baisc = "1즐로티";}
			
			//쿠콘 API 호출 - 외화 고시환율조회
        	//JSONObject rsltData = CooconApi.getExhgRt("081", "3", "0", ""); 
        	JSONObject rsltData = CooconApi.getExhgRt("011", "1", "0", ""); 

        	//조회결과
        	String rsltCd  = rsltData.getString("RESULT_CD");
    		String rsltMsg = rsltData.getString("RESULT_MG");

    		if("00000000".equals(rsltCd)){
    			
        		JSONArray arr_resp_data = rsltData.getJSONArray("RESP_DATA");
        		JSONObject respData = null;
        		
        		for(int j=0 ; j < arr_resp_data.size() ; j++)
    			{
  					respData = arr_resp_data.getJSONObject(j);
					
					if(respData.getString("CURRENCY_NAME").indexOf(currency) > -1){
	   					rslt_ctt.put("CURRENCY_BAISC", currency_baisc);
	   					rslt_ctt.put("CURRENCY", currency);
	   					rslt_ctt.put("NATION", nation);
	   					rslt_ctt.put("NATION_CLASS", nation+"("+currency+")");
	   					rslt_ctt.put("TRSC_DT", respData.getString("STANDARD_DATE"));
	   					rslt_ctt.put("HIS_LST_DTM", respData.getString("STANDARD_DATE")+respData.getString("STANDARD_TIME"));
	   					rslt_ctt.put("TIT_BASIC_RATE", respData.getString("TRADE_BASIC_RATE"));
	   					rslt_ctt.put("TRADE_BASIC_RATE", respData.getString("TRADE_BASIC_RATE"));
	   					rslt_ctt.put("CASH_BUY", respData.getString("CASH_BUY"));
	   					rslt_ctt.put("CASH_SELL", respData.getString("CASH_SELL"));
	   					rslt_ctt.put("TELEGRAPHIC_SEND", respData.getString("TELEGRAPHIC_SEND"));
	   					rslt_ctt.put("TELEGRAPHIC_RECEIVE", respData.getString("TELEGRAPHIC_RECEIVE"));
					}
    			}
    		}
		}
		else */
		// 납부할 세액 내역
		if("BNN002".equals(Intent)){
		
			// 부가가치세/종합소득세 인증서 조회
			JexData idoIn = util.createIDOData("EVDC_INFM_R019");
		    idoIn.put("USE_INTT_ID",USE_INTT_ID);
	        JexData idoOut =  idoCon.execute(idoIn);
	        String taxCertNm = StringUtil.null2void(idoOut.getString("CERT_NM"));
	        
	        if(!"".equals(taxCertNm)){
		    	
	        	JSONArray rtnTaxArr = new JSONArray();
	        	int totl_tax = 0;
	        	
		    	//시연용 데이타 (김지원)
		    	if(CommUtil.isdev() && userSession.getString("CUST_CI").equals("MmrUFl5hQ82U9cd0rHd5HhPz1NadMeurSnmmDBM0Gjq80XouKzn1ePaqbAWb7XNHLQorlN9wdixcXAxbEMXfOQ==")){
		    		JSONObject rtnTaxObj = new JSONObject();
	    			rtnTaxObj.put("TAX_ITEM_NM"	, "부가가치세");
	    			rtnTaxObj.put("BLN_YY"		, "2020");	
	    			rtnTaxObj.put("PAY_EXDT_DT"	, "20210603");
	    			rtnTaxObj.put("PAY_PLAN_TAX", "2333740");	
	    			rtnTaxArr.add(rtnTaxObj);
	    			rtnTaxObj = new JSONObject();
	    			rtnTaxObj.put("TAX_ITEM_NM"	, "법인세");	
	    			rtnTaxObj.put("BLN_YY"		, "2020");	
	    			rtnTaxObj.put("PAY_EXDT_DT"	, "20210601");
	    			rtnTaxObj.put("PAY_PLAN_TAX", "101410");	
	    			rtnTaxArr.add(rtnTaxObj);
	    			totl_tax = 3540250;	
	    			
		    	}else{
		    		
					//쿠콘 API 호출 - 납부할 세액조회 - 실시간, 등록된 인증서명
					JSONObject rsltData = CooconApi.getTaxHstrWithCertName(USE_INTT_ID, taxCertNm);
					
					String rsltCd = StringUtil.null2void(rsltData.getString("ERRCODE"));
			    	String rsltMsg = StringUtil.null2void(rsltData.getString("ERRMSG"));
			    	
			    	if("00000000".equals(rsltCd)){
			    		JSONArray arr_resp_data =  rsltData.getJSONArray("RESP_DATA");
		        		
		        		for(Object row : arr_resp_data)
		        		{
		        			JSONObject resp_data = (JSONObject)row;
		        			JSONObject rtnTaxObj = new JSONObject();
		        			rtnTaxObj.put("TAX_ITEM_NM"	, resp_data.getString("TAX_ITEM"));				// 세목
		        			rtnTaxObj.put("BLN_YY"		, resp_data.getString("VESTED_YEAR"));			// 귀속년도
		        			rtnTaxObj.put("PAY_EXDT_DT"	, resp_data.getString("PAYMENT_LIMIT_DATE"));	// 납부기한
		        			rtnTaxObj.put("PAY_PLAN_TAX", resp_data.getString("TAX_AMOUNT_TO_PAY"));	// 납부할 세액	
		        			rtnTaxArr.add(rtnTaxObj);
		        			
		        			totl_tax += Integer.parseInt(resp_data.getString("TAX_AMOUNT_TO_PAY"));
		        		}
			    	}	
		    	}
		    	
		    	
		    	rslt_ctt.put("SQL2", rtnTaxArr);
		    	rslt_ctt.put("CLASS_TOTL_TAX", totl_tax);
		    	rslt_ctt.put("CERT_YN", "Y");
		    	rslt_ctt.put("HIS_LST_DTM", SvcDateUtil.getInstance().getDate("yyyymmddhh24mi")+"00");
	        }else{
	        	// 해당 계정 등록되어 있지 않음
	        	rslt_ctt.put("CERT_YN", "N");
	        }
		}
		// oo거래처를 보여줘 질의, 최고매출거래처
		else if("ASP001".equals(Intent) || ("ASN001".equals(Intent) && "AVATAR".equals(LGIN_APP))){
			// 전자세금계산서 등록 여부
			JexData idoIn = util.createIDOData("EVDC_INFM_R020");
		    idoIn.put("USE_INTT_ID",USE_INTT_ID);
	        JexData idoOut =  idoCon.execute(idoIn);
	        String taxCertNm = StringUtil.null2void(idoOut.getString("CERT_NM"));
	        if(!"".equals(taxCertNm)){
	        	// 해당 계정 등록되어 있음
	        	rslt_ctt.put("CERT_YN", "Y");
	        }else{
	        	// 해당 계정 등록되어 있지 않음
	        	rslt_ctt.put("CERT_YN", "N");
	        }
		}
		
		result.put("RSLT_CTT", rslt_ctt.toJSONString()); //질의결과값
		//result.put("RSMB_CTT", rsmbArray.toJSONString()); //유사질의목록

		util.setResult(result, "default");

%>