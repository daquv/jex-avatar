<%@page import="com.avatar.api.mgnt.BizmApiMgnt"%>
<%@page import="com.avatar.comm.SvcDateUtil"%>
<%@page import="com.avatar.api.mgnt.ContentApiMgnt"%>
<%@page import="com.avatar.comm.BizLogUtil"%>
<%@page import="com.avatar.comm.AESUtils"%>
<%@page import="jex.web.exception.JexWebBIZException"%>
<%@page import="jex.util.DomainUtil"%>
<%@page import="jex.web.util.WebCommonUtil"%>
<%@page import="jex.resource.cci.JexConnectionManager"%>
<%@page import="jex.data.JexData"%>
<%@page import="jex.resource.cci.JexConnection"%>
<%@page contentType="text/html; charset=utf-8"%>
<%@page import="java.util.List"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.loader.JexDataCreator"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="jex.sys.JexSystemConfig"%>
<%@page import="com.avatar.session.SessionManager"%>
<%@page import="java.util.*"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="jex.json.JSONArray"%>
<%@page import="jex.sys.JexSystemConfig"%>
<%
	try {
		System.out.println("=================================");
		Enumeration names = request.getParameterNames();
		while (names.hasMoreElements()) {
			String sKey = (String) names.nextElement();
			System.out.println(sKey + " = [" + request.getParameter(sKey) + "]");
		}
		System.out.println("=================================");
	} catch (Exception e) {
		e.printStackTrace();
	}
		

// 고객번호	USE_INTT_ID
// 고객명	CUST_NM
// 휴대폰번호	CLPH_NO
// 상태	STTS
// 고객CI  	CUST_CI
// 디바이스ID	DEVICE_ID
// 뱃지건수	BADG_CNT
// 로그인핀번호	LOGIN_FIN_NO
// 로그인실패횟수	LOGIN_ERR_CNT
// 디바이스설치ID	DEVICE_INST_ID
// 최종로그인일시	LOGIN_LST_DTM
// 등록일시	REG_DTM
// 등록자아이디	REGR_ID
// 수정일시	CORC_DTM
// 수정자아이디	CORR_ID

	SessionManager sessionMgr = SessionManager.getInstance();
	JexDataCMO sessionCmo = JexDataCreator.createCMOData("AVATAR_SESSION");
	//sessionCmo.putAll(idoOut1);

	sessionCmo.put("USE_INTT_ID", "A200100001");
	sessionCmo.put("CUST_NM", "홍길동");
	sessionCmo.put("CLPH_NO", "01073677899");
	sessionCmo.put("CUST_CI", "1234");
	sessionCmo.put("APP_ID", "AVATAR");
	sessionCmo.put("LGIN_APP", request.getParameter("LGIN_APP"));

	
	if(request.getParameter("USE_INTT_ID") != null){
		sessionCmo.put("USE_INTT_ID", request.getParameter("USE_INTT_ID"));
	}
	if(request.getParameter("USE_INTT_ID") =="A039900001"){
		sessionCmo.put("USE_INTT_ID", request.getParameter("USE_INTT_ID"));
	}
	
	if(request.getParameter("LGIN_APP") != null){
		sessionCmo.put("LGIN_APP", request.getParameter("LGIN_APP"));
	}
	
	if(request.getParameter("USE_INTT_ID").equals("A200300026")){
		sessionCmo.put("USE_INTT_ID", request.getParameter("USE_INTT_ID"));
		sessionCmo.put("CLPH_NO", "01025999667");
		sessionCmo.put("LGIN_APP", request.getParameter("LGIN_APP"));
		sessionCmo.put("CUST_NM", "김별");
		System.out.println("sessionCmo" + " = [" + sessionCmo + "]");
	}
	
// 	sessionCmo.put("DEVICE_ID", "1234567890123456789012345678901234567890");
// 	sessionCmo.put("BADG_CNT", "0");
// 	sessionCmo.put("DEVICE_ID", "1234567890123456789012345678901234567890");
// 	sessionCmo.put("LOGIN_FIN_NO", "123456");
// 	sessionCmo.put("DEVICE_INST_ID", "");
// 	sessionCmo.put("LOGIN_ERR_CNT", "0");
// 	sessionCmo.put("LOGIN_LST_DTM", "");
	sessionMgr.setUserSession(request, response, sessionCmo);
	out.println("로그인 성공");
	
	 // 암호화키
	String encryptKey = JexSystemConfig.get("avatarAPI", "enc_key");
	String encryptIvKey = JexSystemConfig.get("avatarAPI", "enc_iv_key");
	
	BizLogUtil.debug(this,"encryptKey :: "+encryptKey);
	BizLogUtil.debug(this,"encryptIvKey :: "+encryptIvKey);
	// 암호화 KEY 
	byte[] encKey = AESUtils.changeHex2Byte(encryptKey); 
	byte[] encIv = AESUtils.changeHex2Byte(encryptIvKey); 
	
	BizLogUtil.debug(this,"encKey :: "+encKey);
	BizLogUtil.debug(this,"encIv :: "+encIv);
	
	
	String reqEv = "tLcok8Dg0Lmoq2620SAOVLl777%2FovKKkS3b%2B4iWx%2Flu7jSzgBEkiNdxALXu4Prp%2B5EPBLQUiyVqw4y62KUI946gZnTYgrQLS0UTRlgio9M5nUDFkp7RaPovVph9NDEgzv8rE1CSduYtTrzqGodAtb2B58d5%2Fig4384WGbniyT8woXvrzoOkztNeKB%2FlVh1cWgeGiBb0sVjg9erpD%2BUk2aCKozirdypgOBZY2o53aYciFTB8Une%2BDOq5Fw%2FlhUhHDGZo9D0N7SsEw8hZYvKVywD9aaYOzV9JLJsyxFuKKXj8uAyfeMjHPuWnaK1LN0NxEfOWcDMcR3tqlgm7xg1wjlhFs7nl7zieknmavd%2BUuWeqoaJUibzvrSmBlfvTppKWSdijfcOfIx1WX%2F8u%2F8Qb9pdsxnM62HM5EmfStgoMGZspMGpY%2BFOAj0icP%2FsdBZjFjxvTy%2BFWEQ6RslBMSo0a%2BLPs%2Bh2bO3qRLUrWQ44BEVAPGqOaKeTdgviIrz7b%2BoowdtnXgo7p97Vp2xrQBQmSzKQ%3D%3D";
	String reqVv = "Q7XMNG01VYQZZ4X89maZSuanK%2FFGRKR5%2F4yL%2BVm7Ens%3D";
	//String reqVv = "saQ%2FqFOytdfXeNX1P0ZbDPwg6FQMk%2BjH4KDzL%2BrZi2s%3D";
	
	
    //reqEv = java.net.URLDecoder.decode(reqEv.toString(), "UTF-8");
    
    //BizLogUtil.debug(this,"reqEv decode:: "+reqEv);

    //sun.misc.BASE64Decoder decoder = new sun.misc.BASE64Decoder();
	//byte[] reqEvBytes = decoder.decodeBuffer(reqEv);
	//reqEv = new String(reqEvBytes, "UTF-8");

	 //BizLogUtil.debug(this,"reqEv BASE64Decoder:: "+reqEv);

	// EV데이터 복호화 
    String devEv = AESUtils.DecryptAes256(reqEv, encKey, encIv).substring(14);
	
	BizLogUtil.debug(this,"devEv :: "+devEv);
	//devEv = devEv.substring(14);
    BizLogUtil.debug(this,"devEv.substring(14) :: "+devEv);
	
    // 검증 VV 생성 
    String chkVv = AESUtils.getHmacSha256(devEv, encKey); 
    BizLogUtil.debug(this,"chkVv :: "+chkVv);
    if(!chkVv.equals(reqVv)){     
    	BizLogUtil.debug(this,"chkVv :: nononono");
    }
   
    Map<String, Object> mActionData2 = JSONObject.fromObject(devEv);
    BizLogUtil.debug(this,"mActionData2 :: "+mActionData2.toString());

    int reqcnt = 10;
 	// 은행 연동 알림톡 전송
	String msg = "";
	msg += reqcnt+"개의 은행 데이터가 아바타와 연결되었습니다.\n\n";
	msg += "이제 아바타에게 이렇게 물어보세요!\n\n";
	msg += "\"기업은행 통장잔고는?\"\n";
	msg += "\"신한은행 입출금 내역은?\"\n";
	msg += "\"현재 자금현황은?\"\n";
	
	String tmplId = "askavatar_003_bank_renew";
    
    JSONObject button1 = new JSONObject();
    button1.put("name"    			, "에스크아바타 열기");
    button1.put("type"      		, "AL");
    button1.put("scheme_android"    , "kakaoa51a93ebcd6f4145ad28e1fa20cfff50://kakaolink");
    button1.put("scheme_ios"      	, "kakaoa51a93ebcd6f4145ad28e1fa20cfff50://kakaolink");
    
    //BizmApiMgnt.apiJoinSendMsg("01028602673", msg, tmplId, button1);
    
   
    JSONObject voiceInfo = new JSONObject();
	voiceInfo.put("NE-COUNTERPARTNAME","홍게");
	voiceInfo.put("NE-BIZCD","0") ;
	
	//JSONObject rslt_ctt = ContentApiMgnt.getInstance().executeZeropayApi("A210500001",  "Z-011", voiceInfo);
	//BizLogUtil.debug(this,"rslt_ctt ::"+rslt_ctt.toJSONString());
%>

