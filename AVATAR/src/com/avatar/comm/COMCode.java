package com.avatar.comm;

import jex.data.JexData;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.util.DomainUtil;
import jex.util.StringUtil;
import jex.util.biz.JexCommonUtil;
import jex.util.code.CodeManager;
import jex.web.JexContextWeb;
import jex.web.exception.JexWebBIZException;

public class COMCode {

	public static final String SUCCESS = "0000"; /* 정상응답값. */
	public static final String COM_CODE_0001 = "SUER0001"; /* 필수값 누락 되었습니다.*/
	public static final String COM_CODE_0002 = "SUER0002"; /* 이용기관이 없음*/
	public static final String COM_CODE_0003 = "SUER0003"; /* 등록되지 않은 직원입니다.*/
	public static final String COM_CODE_0004 = "SUER0004"; /* 타사에 등록되어 있습니다.*/

	public static final String COM_CODE_0005 = "SUER0005"; /* 법인사업자는 가입이 안됩니다.*/
	public static final String COM_CODE_0006 = "SUER0006"; /* 휴 폐업된 사업자번호 입니다..*/
	public static final String COM_CODE_0007 = "SUER0007"; /* 사업자번호 또는 대표자명을 확인해주세요.*/
	public static final String COM_CODE_0008 = "SUER0008"; /* 해지된 사업자번호입니다.*/
	public static final String COM_CODE_0009 = "SUER0009"; /* 사업자 번호가 없습니다.*/
	public static final String COM_CODE_0010 = "SUER0010"; /* 아이디가 없습니다.*/
	public static final String COM_CODE_0011 = "SUER0011"; /* 잘못된 사업자번호입니다.*/

	public static final String COM_CODE_0012 = "SUER0012"; /* 핀번호가 틀렸습니다.*/
	public static final String COM_CODE_0013 = "SUER0013"; /* 핀번호가 5회 이상 틀리셨습니다*/

	public static final String COM_CODE_0014 = "SUER0014"; /* 디바이스 처리중 오류 발생 */
	public static final String COM_CODE_0015 = "SUER0015"; /* 등록된 사용자가 없습니다. */

	public static final String COM_CODE_0016 = "SUER0016"; /* 2.0 사용자 재인증 필요 (ID 중복)*/
	public static final String COM_CODE_0017 = "SUER0017"; /* 해지된 기관입니다. */
	public static final String COM_CODE_0018 = "SUER0018"; /* 대표자 인증이 필요합니다. */


	public static final String COM_CODE_0019 = "SUER0019"; /* email 형식이 아닙니다. */

	public static final String COM_CODE_0020 = "SUER0020"; /* 핀번호는 숫자 6자리입니다. */
	public static final String COM_CODE_0021 = "SUER0021"; /* 연속된 숫자가 포함되었습니다. */
	public static final String COM_CODE_0022 = "SUER0022"; /* 연속으로 같은 숫자가 포함되었습니다. */
	public static final String COM_CODE_0023 = "SUER0023"; /* 핀번호는 숫자만 가능합니다. */
	public static final String COM_CODE_0024 = "SUER0024"; /* 핀번호에 공백이 포함되었습니다. */

	public static final String COM_CODE_0025 = "SUER0025"; /* 사웅중인 아이디 입니다. */
	public static final String COM_CODE_0026 = "SUER0026"; /* 영문/숫자 조합은 10자 이상입니다. */

	public static final String COM_CODE_0027 = "SUER0027"; /* 단독가입사지용자 */
	public static final String COM_CODE_0028 = "SUER0028"; /* 약정 가입 사용자 */
	public static final String COM_CODE_0029 = "SUER0029"; /* 이미 가입된 사업자번호입니다. */

	public static final String COM_CODE_0030 = "SUER0030"; /* 지문 로그인 실패 */

	public static final String COM_CODE_0031 = "SUER0031"; /* imo 전문코드 업무코드 오류  */
	public static final String COM_CODE_0032 = "SUER0032"; /* 2.0 사용자 재인증 필요(ID 중복아님) */
	public static final String COM_CODE_0033 = "SUER0033"; /* 해지 진행중  */

	public static final String COM_CODE_0034 = "SUER0034"; /* 사용 정지된 사업자입니다.  */


	/**
	 * 오뮤 메세지
	 * @param errCode
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 * @throws JexWebBIZException
	 */

	public static String getErrCodeMsg(String errCode) throws JexException, JexBIZException, JexWebBIZException{

		String err_mesg = "";

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContextWeb.getContext().getCommonUtil();

        JexData idoIn1 = util.createIDOData("ERCD_INFM_R001");
        idoIn1.put("ERR_CD" , errCode);
        JexData idoOut1 = idoCon.execute(idoIn1);

        if (DomainUtil.isError(idoOut1)) {
            throw new JexWebBIZException(idoOut1);
        }

        err_mesg = StringUtil.null2void(idoOut1.getString("ERR_MESG"));

        if( "".equals(err_mesg) )
        {
        	err_mesg = "처리중 오류 발생하였습니다.";
        }

        return err_mesg;

	}


	/**
	 * 고객 메세지
	 * @param errCode
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 * @throws JexWebBIZException
	 */
	public static String getErrCodeCustMsg(String errCode) throws JexException, JexBIZException, JexWebBIZException{

		String err_mesg = "";

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContextWeb.getContext().getCommonUtil();

        JexData idoIn1 = util.createIDOData("ERCD_INFM_R001");
        idoIn1.put("ERR_CD" , errCode);
        JexData idoOut1 = idoCon.execute(idoIn1);

        if (DomainUtil.isError(idoOut1)) {
            throw new JexWebBIZException(idoOut1);
        }

        err_mesg = StringUtil.null2void(idoOut1.getString("CUST_MESG"));

        if( "".equals(err_mesg) )
        {
        	err_mesg = "처리중 오류 발생하였습니다.";
        }

        return err_mesg;

	}

	public static String getJexRegErrMsg(String errCode) {

		if(errCode == null) return "";

		String errMsgResult = "";
		String errMsg = CodeManager.getSubCode("RSLT_CD", errCode); // 소분류약어명
		String errDetailMsg = CodeManager.getCode("RSLT_CD", errCode); // 소분류명

		if(errMsg != null && errDetailMsg != null)
		{
			errMsgResult = "(" + errMsg + ")" + errDetailMsg;
		}
		else if(errMsg == null && errDetailMsg != null)
		{
			errMsgResult = errDetailMsg;
		}
		else
		{
			errMsgResult = "등록된 에러 메세지가 없습니다.";
		}

		return errMsgResult;

	}

}



