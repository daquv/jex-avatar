<%@page import="com.avatar.comm.COMCode"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="kcb.jni.Okname"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.avatar.comm.CommUtil"%>
<%@page import="jex.sys.JexSystemConfig"%>
<%@page import="jex.exception.JexBIZException"%>
<%@page import="jex.data.impl.ido.IDODynamic"%>
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
         * @File Title   : 인증번호 확인
         * @File Name    : join_0001_02_r002_act.jsp
         * @File path    : user
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200206132612
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

         @JexDataInfo(id="join_0001_02_r002", type=JexDataType.WSVC)
         JexData input = util.getInputDomain();
         JexData result = util.createResultDomain();

      	// 요청파라미터
         String TrscUnqNo = StringUtil.null2void(input.getString("TRSC_UNQ_NO"));	// 거래고유번호
     	String ClphNo = StringUtil.null2void(input.getString("CLPH_NO"));		// 휴대폰번호
     	String SmsCertNo = StringUtil.null2void(input.getString("SMS_CERT_NO"));	// SMS인증번호

     	// 파라미터에 대한 유효성 검증
     	if(!TrscUnqNo.matches("^[0-9a-zA-Z]+$")) {
     		if (util.getLogger().isDebug()) util.getLogger().debug("Error Code   :: KCBC009");
     		if (util.getLogger().isDebug()) util.getLogger().debug("Error Message:: 거래고유번호에 유효하지 않은 문자열이 있습니다.");
     		throw new JexBIZException("KCBC009");
     	}
     	if(!ClphNo.matches("^[0-9]+$")) {
     		if (util.getLogger().isDebug()) util.getLogger().debug("Error Code   :: KCBC006");
     		if (util.getLogger().isDebug()) util.getLogger().debug("Error Message:: 휴대폰번호에 유효하지 않은 문자열이 있습니다.");
     		throw new JexBIZException("KCBC006");
     	}
     	if(!SmsCertNo.matches("^[0-9]+$")) {
     		if (util.getLogger().isDebug()) util.getLogger().debug("Error Code   :: KCBC010");
     		if (util.getLogger().isDebug()) util.getLogger().debug("Error Message:: SMS인증번호에 유효하지 않은 문자열이 있습니다.");
     		throw new JexBIZException("KCBC010");
     	}

     	// ########################################################################
     	// # KCB로부터 부여받은 회원사코드(아이디) 설정 (12자리)
     	// ########################################################################
     	String memId = JexSystemConfig.get("sms_kcb","MEM_ID");				// 회원사코드(아이디)

     	// ########################################################################
     	// # 운영전환시 확인 필요
     	// ########################################################################
     	String endPointUrl  = JexSystemConfig.get("sms_kcb", "END_POINT_URL");	//(운영계서버).
         
     	// ########################################################################
     	// # 회원사 모듈설치서버 IP 설정
     	// ########################################################################
     	String serverIp = "x";   							               // 모듈이 설치된 서버IP (서버IP검증을 무시하려면 'x'로 설정)
     	
     	// ########################################################################
     	// # 로그 경로 지정 및 권한 부여 (절대경로)
     	// ########################################################################
         String logPath = JexSystemConfig.get("sms_kcb", "LOG_PATH");		// 로그경로. 로그파일을 만들지 않더라도 경로는 지정하도록 한다.

     	// ########################################################################
     	// # 옵션값에 'L'을 추가하는 경우에만 로그가 생성됨.
     	// # 시스템(환경변수 LANG설정)이 UTF-8인 경우 'U'옵션 추가 ex)$option='MLU'	
     	// ########################################################################
         String options = "MU";		// L:파일로그생성

         String[] cmd = new String[8];
     	cmd[0]=TrscUnqNo;
     	cmd[1]=ClphNo;
     	cmd[2]=SmsCertNo;
     	cmd[3]=memId;
     	cmd[4]=serverIp;
     	cmd[5]=endPointUrl;
     	cmd[6]=logPath;
     	cmd[7]=options;

     	// log
     	if (util.getLogger().isDebug()){
     		util.getLogger().debug("================================================================================");
     		util.getLogger().debug("== KCB SMS CERT DATA ===========================================================");
     		for(String s : cmd){
     			util.getLogger().debug("|| "+s);
     		}
     		util.getLogger().debug("================================================================================");
     	}

     	String retcode = null;		
     	String ci = null;
     	List<String> sms_result = new ArrayList<String>();	// 인증결과
     	int ret = -999;			// 프로세스 리턴값
     	try {
     		Okname okname = new Okname();
     		ret = okname.exec(cmd, sms_result);
     		if (ret == 0) {		//성공일 경우 변수를 결과에서 얻음
     			retcode = sms_result.get(0);
     			ci = sms_result.get(5);
     		} else {
     			DecimalFormat dcf = new DecimalFormat("000");
     			if(ret <=200) {
     				retcode = "B" + dcf.format(ret);
     			} else {
     				retcode = "S" + dcf.format(ret);
     			}
     		}
     	} catch(Exception e) {
     		if (util.getLogger().isDebug()) util.getLogger().debug("Error Code   :: KCBC011");
     		if (util.getLogger().isDebug()) util.getLogger().debug("Error Message:: 휴대폰 본인인증 모듈 호출시 오류가 발생했습니다.");
     		throw new JexBIZException("KCBC011");
         }
     	System.out.println(retcode + "  ::  retcode_1");
     	System.out.println(ci + "  ::  ci_001");
     	
     	if("B000".equals(retcode)){
     		/*중복 회원가입 검증*/
         	JexConnection idoCon = JexConnectionManager.createIDOConnection();
         	IDODynamic dynamic_0 = new IDODynamic();
         	dynamic_0.addNotBlankParameter(ci,"\n AND CUST_CI = ?");
         	dynamic_0.addSQL("\n AND STTS <> '9'");
         	JexData idoIn1 = util.createIDOData("CUST_LDGR_R005");
         	idoIn1.put("DYNAMIC_0", dynamic_0);
         	
         	JexData idoOut1 = idoCon.execute(idoIn1);
         	
        
            // 도메인 에러 검증
            if (DomainUtil.isError(idoOut1)) {
                if (util.getLogger().isDebug())
                {
                    util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                    util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
                }
                throw new JexWebBIZException(idoOut1);
            }
        	if(Integer.parseInt(StringUtil.null2void(idoOut1.getString("CNT"), "0"))> 0){
        		retcode = "9999";
        		System.out.println(retcode + "  ::  retcode_duplicate");
        	}
     	}else {
     		if (util.getLogger().isDebug()) util.getLogger().debug("Error Code   :: KCB"+retcode);
     	}
     	
    	/* if(!"B000".equals(retcode)) {
    		if (util.getLogger().isDebug()) util.getLogger().debug("Error Code   :: KCB"+retcode);
         	//throw new JexBIZException(retcode, COMCode.getErrCodeMsg(retcode));
         } */
         result.put("RSLT_CD", retcode);
         result.put("CUST_CI", ci);
    	System.out.println(retcode + "  ::  retcode_first");
        /*중복 회원가입 검증*/
     	/* 
     	if(!"B000".equals(retcode)) {
         	if (util.getLogger().isDebug()) util.getLogger().debug("Error Code   :: KCB"+retcode);
         	//throw new JexBIZException(retcode, COMCode.getErrCodeMsg(retcode));
         }
         result.put("RSLT_CD", retcode);
         result.put("CUST_CI", ci); */
     	
     	util.setResult(result, "default");

%>