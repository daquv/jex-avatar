<%@page import="jex.json.parser.JSONParser"%>
<%@page import="com.avatar.api.mgnt.KakaoApiMgnt"%>
<%@page import="jex.json.JSONArray"%>
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
         * @File Title   : 세무사DB 일괄등록
         * @File Name    : txof_0102_01_c001_act.jsp
         * @File path    : admin.cstm
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20210715163405
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

        @JexDataInfo(id="txof_0102_01_c001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

		// IDO Connection
		JexConnection idoCon = JexConnectionManager.createIDOConnection();        

		try{
			idoCon.beginTransaction();
			JexDataList<JexData> inputRecInsert = input.getRecord("INSERT_REC");
			while(inputRecInsert.next()){
				JexData inputData = inputRecInsert.get(); 
				//upsert
				JexData idoIn1 = util.createIDOData("TXOF_INFM_C001");
				idoIn1.putAll(inputData);
				
				// search latitude, longitude 
				String lat  = "";	// 위도(y)
				String lng  = "";	// 경도(x)
				String adrs = inputData.getString("ADRS")+" "+inputData.getString("DTL_ADRS");
				String jsonString =  KakaoApiMgnt.getCoordination(adrs);
				JSONParser parser = new JSONParser();
				
				JSONObject json = ( JSONObject ) new JSONParser().parser(jsonString);
				JSONArray jsonDocuments = (JSONArray) json.get( "documents" );
				if( jsonDocuments.size() != 0 ) {
					JSONObject j = (JSONObject) jsonDocuments.get(0);
					lat = ( String ) j.get("y");
					lng = ( String ) j.get("x");
				} 
				System.out.println("위도(y) :: "+lat+" / 경도(x) :: "+lng);
				//-- search latitude, longitude
				
				idoIn1.put("LATD", lat.substring(0,11));
				idoIn1.put("LOTD", lng.substring(0,11));
				idoIn1.put("STTS", "1");
				
				JexData idoOut1 =  idoCon.execute(idoIn1);
				// 도메인 에러 검증
				if (DomainUtil.isError(idoOut1)) {
					if (util.getLogger().isDebug()){
						util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
						util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
						// result.put("RSLT_CD", "9999");
					}
					throw new JexWebBIZException(idoOut1);
				}
			}
			result.put("RSLT_CD", "0000");
			idoCon.commit();
			idoCon.endTransaction();
		} catch(Exception e){
			idoCon.rollback();
			idoCon.endTransaction();
			if (util.getLogger().isDebug()) util.getLogger().debug("Error Code   ::"+e.getMessage());
			result.put("RSLT_CD", "9999");
			util.setResult(result, "E");
		}

		util.setResult(result, "default");

%>