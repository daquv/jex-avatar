<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="kcb.jni.Okname"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.avatar.comm.COMCode"%>
<%@page import="jex.exception.JexBIZException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.avatar.comm.CommUtil"%>
<%@page import="jex.sys.JexSystemConfig"%>
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
         * @File Title   : 인증번호받기
         * @File Name    : join_0001_02_r001_act.jsp
         * @File path    : user
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200206111612
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

         @JexDataInfo(id="join_0001_02_r001", type=JexDataType.WSVC)
         JexData input = util.getInputDomain();
         JexData result = util.createResultDomain();
         
  		String EcnmcTelCmmYn = input.getString("ECNMC_TEL_CMM_YN");		//알뜰폰 유무
         
		String TrscUnqNo = ""; // 거래고유번호. 동일문자열을 두번 사용할 수 없음.
     	String Name = input.getString("NAME");
     	String Brdt = input.getString("BRDT");
     	String Gndr = input.getString("GNDR");
     	String InFrnrDvCd = input.getString("IN_FRNR_DV_CD");
     	String TelCmmCd = input.getString("TEL_CMM_CD");
     	String ClphNo = input.getString("CLPH_NO");
     	String RsngYn = "N"; // SMS 재전송여부
     	String rsv1 = "0";
     	String rsv2 = "0";
     	String rqstMsrCd = "10";
     	String RqstRsn = "99"; // 인증요청사유코드 (00:회원가입, 01:성인인증, 02:회원정보수정, 03:비밀번호찾기, 04:상품구매, 99:기타)
     	String memId = JexSystemConfig.get("sms_kcb","MEM_ID");				// 회원사코드(아이디)
     	String serverIp = "x";	// 모듈이 설치된 서버IP (서버IP검증을 무시하려면 'x'로 설정)
     	String siteUrl = JexSystemConfig.get("sms_kcb", "SITE_URL");				// 회원사 사이트 URL
     	String siteDomain = JexSystemConfig.get("sms_kcb", "SITE_DOMAIN");			// 회원사 도메인명, SMS인증번호문자에 표시됨 **
     	String endPointUrl = JexSystemConfig.get("sms_kcb", "END_POINT_URL");	//(운영계서버).;
     	String logPath = JexSystemConfig.get("sms_kcb", "LOG_PATH");				// 로그경로. 로그파일을 만들지 않더라도 경로는 지정하도록 한다.;
     	String options = "JU";
     	
     	if("Y".equals(EcnmcTelCmmYn)){
     		if("01".equals(TelCmmCd)){
     			TelCmmCd = "04";
     		}
     		if("02".equals(TelCmmCd)){
     			TelCmmCd = "05";
     		}
     		if("03".equals(TelCmmCd)){
     			TelCmmCd = "06";
     		}
     	}
     	
     	// SMS인증번호 재전송 여부에 따라 거래번호를 설정
     	if (!"Y".equals(RsngYn)) {
     		Calendar cal = Calendar.getInstance();
     		SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmssSSS");
     		TrscUnqNo = df.format(cal.getTime()); 	// 거래고유번호. 동일문자열을 두번 사용할 수 없음.
     	}
     	
     	String[] cmd = new String[19];
     	cmd[0]=TrscUnqNo;
     	cmd[1]=Name;
     	cmd[2]=Brdt;
     	cmd[3]=Gndr;
     	cmd[4]=InFrnrDvCd;
     	cmd[5]=TelCmmCd;
     	cmd[6]=ClphNo;
     	cmd[7]=RsngYn;
     	cmd[8]=rsv1;
     	cmd[9]=rsv2;
     	cmd[10]=rqstMsrCd;
     	cmd[11]=RqstRsn;
     	cmd[12]=memId;
     	cmd[13]=serverIp;
     	cmd[14]=siteUrl;
     	cmd[15]=siteDomain;
     	cmd[16]=endPointUrl;
     	cmd[17]=logPath;
     	cmd[18]=options;

     	if (util.getLogger().isDebug()){
     		util.getLogger().debug("================================================================================");
     		util.getLogger().debug("== KCB SMS CERT DATA ===========================================================");
     		for(String s : cmd){
     			util.getLogger().debug("|| "+s);
     		}
     		util.getLogger().debug("================================================================================");
     	}
     	
     	String retcode = null;		
     	List<String> sms_result = new ArrayList<String>();	// 인증결과
     	int ret = -999;			// 프로세스 리턴값
     	try {
     		Okname okname = new Okname();
     		ret = okname.exec(cmd, sms_result);
     		if (ret == 0) {	//성공일 경우 변수를 결과에서 얻음
     			retcode = sms_result.get(0);
     		} else {
     			DecimalFormat dcf = new DecimalFormat("000");
     			if(ret <=200) {
     				retcode = "B" + dcf.format(ret);
     			} else {
     				retcode = "S" + dcf.format(ret);
     			}
     		}
     	}catch(Exception e) {
     		e.printStackTrace();
     		if (util.getLogger().isDebug()) util.getLogger().debug("Error Code   :: KCBC011");
     		if (util.getLogger().isDebug()) util.getLogger().debug("Error Message:: 휴대폰 본인인증 모듈 호출시 오류가 발생했습니다.");
     		throw new JexBIZException("KCBC011");
     	}
     	
     	
     	util.getLogger().debug("retcode >> " + retcode);
     	
     	if(!"B000".equals(retcode)) {
     		if (util.getLogger().isDebug()) util.getLogger().debug("Error Code   :: KCB"+retcode);
     		//throw new JexBIZException(retcode, COMCode.getErrCodeMsg(retcode));
     	}
     	
 		result.put("TRSC_UNQ_NO", TrscUnqNo);
 		result.put("RSLT_CD", retcode);
         util.setResult(result, "default");

%>