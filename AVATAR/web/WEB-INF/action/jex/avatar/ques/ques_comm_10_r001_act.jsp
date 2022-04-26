<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.avatar.comm.AESUtils"%>
<%@page import="jex.sys.JexSystemConfig"%>
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
<%@page import="com.avatar.comm.BizLogUtil"%>

<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 질의조회_제로페이
         * @File Name    : ques_comm_10_r001_act.jsp
         * @File path    : ques
         * @author       : jwpark (  )
         * @Description  : 
         * @Register Date: 20211209095801
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

        @JexDataInfo(id="ques_comm_10_r001", type=JexDataType.WSVC)
        JexData input 	= util.getInputDomain();
        JexData result 	= util.createResultDomain();
        
        //IDO Connection
        JexConnection idoCon 	= JexConnectionManager.createIDOConnection();
        
        //음성결과
        JSONObject inteInfo 	= (JSONObject)JSONParser.parser(StringUtil.null2void(input.getString("INTE_INFO")));
        String	ENC_CUST_CI		= StringUtil.null2void(input.getString("USER_CI"));
        ENC_CUST_CI = URLEncoder.encode(ENC_CUST_CI, "UTF-8");
        
        // CUST_CI 복호화
        String  CUST_CI = decryptCustCi(ENC_CUST_CI, util);
        
        //TEST DATA
        //String 		sampleStr	= "\"INTE_INFO\":\"{\"recog_data\":{\"appInfo\":{\"NE-COUNTERPARTNAME\":\"비즈플레이\"},\"Intent\":\"ZNN002\"},\"recog_txt\":\"비즈플레이 결제내역 보여줘\"}";
        //String		CUST_CI		= "";
        //JSONObject 	inteInfo	= (JSONObject)JSONParser.parser(sampleStr);
        
        String		page_no		= StringUtil.null2void((String)input.get("PAGE_NO"));
        String		page_size	= StringUtil.null2void((String)input.get("PAGE_CNT"));
        
        String 		recog_txt	= StringUtil.null2void((String)inteInfo.get("recog_txt"));
        JSONObject	recog_data	= (JSONObject)inteInfo.get("recog_data");
        JSONObject	appInfo		= (JSONObject)recog_data.get("appInfo");
        String		Intent		= StringUtil.null2void((String)recog_data.get("Intent"));
        
        JSONObject	rslt_ctt	= new JSONObject();
       	
        /*
    	*	Intent			내용						조건									연동 API
    	*	========================================================================================================
    	*	
    	*	ZNN001			제로페이 결제금액				NE-COUNTERPARTNAME					결제내역집계(AVATAR_API_003)
    	*	ZNN002			제로페이 결제내역				NE-COUNTERPARTNAME, 직불,결제수단		결제내역조회(AVATAR_API_004)
    	*	ZNN003			제로페이 결제수수료			NE-COUNTERPARTNAME					결제수수료(AVATAR_API_005)
    	*	ZNN004			제로페이 결제 취소 금액			NE-COUNTERPARTNAME					결제내역집계(AVATAR_API_003)
    	*	ZNN005			제로페이 결제 취소 내역			NE-COUNTERPARTNAME, 직불,결제수단		결제내역조회(AVATAR_API_004)
    	*	ZNN006			제로페이 입금 예정액			NE-COUNTERPARTNAME					입금예정(AVATAR_API_006)
    	*	ZNN007			제로페이 입금 예정내역			NE-COUNTERPARTNAME, 결재방법			입금예정상세(AVATAR_API_007)
    	*	ZNN008			제로페이 상품권 결제내역		NE-COUNTERPARTNAME,	상품권명, 결제수단
    	*	ZNN009			제로페이 상품권 결제취소 내역		NE-COUNTERPARTNAME, 상품권명, 결제수단
    	*	ZNN010			제로페이 콜센터 전화해줘
    	*	ZSN001			제로페이 매출 브리핑												결제내역집계(AVATAR_API_003)
    	*	AZN001			QR코드					NE-COUNTERPARTNAME					가맹점정보(AVATAR_API_008)
    	*	AZN002			결제 가능 상품권				NE-COUNTERPARTNAME					가맹점정보(AVATAR_API_008)
    	*	ASP003			가맹점					대표,사업자번호,가맹점,관리번호, ...			가맹점정보(AVATAR_API_008)
    	*	ASP004			가맹점목록														가맹점정보(AVATAR_API_008)
    	**/
    	
    	
    	JexData		idoIn0 = util.createIDOData("INTE_INFM_R013");
        idoIn0.put("INTE_CD", Intent);
        
        JexData		idoOut0 = idoCon.execute(idoIn0);
        if (DomainUtil.isError(idoOut0)) {
			if (util.getLogger().isDebug())
			{
				util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut0));
				util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut0));
			}
			throw new JexWebBIZException(idoOut0);
		}
		result.put("OTXT_HTML", StringUtil.null2void(idoOut0.getString("OTXT_HTML")) );
		result.put("INTE_NM", StringUtil.null2void(idoOut0.getString("INTE_NM")) );
    	
    	// 질의 인입 이력을 등록한다.
    	JexData 	idoIn1 = util.createIDOData("ZERO_QUES_HSTR_C001");
    	idoIn1.put("CUST_CI", CUST_CI);
    	idoIn1.put("VOIC_DATA", inteInfo.toString());
    	idoIn1.put("INTE_CD", Intent);
    	idoIn1.put("QUES_CTT", recog_txt);
    	idoIn1.put("ENC_CUST_CI", ENC_CUST_CI);
    	JexData 	idoOut1 = idoCon.execute(idoIn1);
    	
    	// 도메인 에러 검증
        if (DomainUtil.isError(idoOut1)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
            }
            // throw new JexWebBIZException(idoOut1);
			rslt_ctt.put("RSLT_CD", "9998");
			rslt_ctt.put("RSLT_MSG", "질의이력 등록 중 오류가 발생했습니다.");
        } else {
        	
	    	// 제로페이 Intent Code 인입 시 API를 호출한다.
	    	String		zeroIntent	= ",ZNN001,ZNN002,ZNN003,ZNN004,ZNN005,ZNN006,ZNN007,ZNN008,ZNN009,ZNN010"
	    							+ ",ZSN001,AZN001,AZN002,ASP003,ASP004,SCT001";
	    	
	        if(zeroIntent.indexOf(Intent) > -1){
	        	rslt_ctt	= ContentApiMgnt.getInstance().executeZeropayApiSdk(CUST_CI, page_no, page_size, Intent, appInfo);
	        }
	        
        }
        
    	result.put("RSLT_CTT", rslt_ctt.toJSONString());
        util.setResult(result, "default");
    	

%>

<%!
public String decryptCustCi(String encCustCi, WebCommonUtil util) {	
	String decCustCi = "";
	
	try {
		
		// 암호화키
		String encryptKey = JexSystemConfig.get("avatarAPI", "enc_key");
		String encryptIvKey = JexSystemConfig.get("avatarAPI", "enc_iv_key");
	    
		// 암호화 KEY
	   	byte[] encKey = AESUtils.changeHex2Byte(encryptKey); 
	   	byte[] encIv = AESUtils.changeHex2Byte(encryptIvKey);
	   	
	   	// EV데이터 복호화 
	    decCustCi = AESUtils.DecryptAes256(encCustCi, encKey, encIv);
	    
	} catch(Exception e) {
		e.printStackTrace();
	}
	
	return decCustCi;
}

%>