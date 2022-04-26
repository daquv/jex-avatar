package com.avatar.service;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import jex.JexContext;
import jex.data.JexData;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.json.JSONObject;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.util.DomainUtil;
import jex.util.biz.JexCommonUtil;
import jex.util.date.DateTime;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.CommUtil;
import com.avatar.comm.SvcDateUtil;

/**
 * 인증서 정보를 이용해 모든 계정을 조회한다. - Runnable 객체
 *
 * 개인용인증서 : 개인뱅킹 계좌, 개인카드
 * 기업용인증서 : 기업뱅킹 계좌, 홈택스
 * 예외> 기업은행, SC은행은 개인뱅킹/기업뱅킹 모두 조회
 *
 * @author webcash.co.kr
 *
 */
public class CooconRegServiceRunnable implements Runnable {

	private ExecutorService executorService;

	private JSONObject _regInfo;
	private String _reg_user_id;
	private String _task_no;		// 작업일련번호(작업일시-yyyyMMddHHmmssSSS)
	private String _bank_gb;		// 뱅킹구분(1:개인뱅킹, 2:기업뱅킹)

	public CooconRegServiceRunnable(String reg_user_id, JSONObject regInfo) {

		_regInfo     = regInfo;
        _reg_user_id = reg_user_id;
        _task_no     = SvcDateUtil.getFormatString("yyyyMMddHHmmssSSS");

        if("0".equals(regInfo.getString("CERT_USAG_DIV"))) {
			// 개인용인증서인 경우 개인뱅킹
        	_bank_gb = "1";
		} else if("1".equals(regInfo.getString("CERT_USAG_DIV"))) {
			// 기업용인증서 경우 기업뱅킹
			_bank_gb = "2";
		}

		executorService = Executors.newFixedThreadPool(
        		Runtime.getRuntime().availableProcessors()
        );
        BizLogUtil.debug(this, "availableProcessors() : "+String.valueOf(Runtime.getRuntime().availableProcessors()));
    }

	@Override
	public void run() {

		String st_tm = DateTime.getInstance().getDate("hhmiss");
		BizLogUtil.info(this, _task_no,"Thread ["+Thread.currentThread().getName()+"] Start");

		// 계정등록작업 생성
		insertAcctInqTask();

		try {
			// KDB산업은행(002)
			callRunnableAcctRegService("002", _bank_gb);

			// 기업은행(003) - 개인뱅킹/기업뱅킹 모두 조회
			callRunnableAcctRegService("003", "1");
			callRunnableAcctRegService("003", "2");

			// 국민은행(004)
			callRunnableAcctRegService("004", _bank_gb);

			// 수협(007)
			callRunnableAcctRegService("007", _bank_gb);

			// 농협은행(011)
			callRunnableAcctRegService("011", _bank_gb);

			// 우리은행(020)
			callRunnableAcctRegService("020", _bank_gb);

			// SC은행(023) - 개인뱅킹/기업뱅킹 모두 조회
			callRunnableAcctRegService("023", "1");
			callRunnableAcctRegService("023", "2");

			// 씨티은행(027)
			callRunnableAcctRegService("027", _bank_gb);

			// 대구은행(031)
			callRunnableAcctRegService("031", _bank_gb);

			// 부산은행(032)
			callRunnableAcctRegService("032", _bank_gb);

			// 광주은행(034)
			callRunnableAcctRegService("034", _bank_gb);

			// 제주은행(035)
			callRunnableAcctRegService("035", _bank_gb);

			// 전북은행(037)
			callRunnableAcctRegService("037", _bank_gb);

			// 경남은행(039)
			callRunnableAcctRegService("039", _bank_gb);

			// 새마을금고(045)
			callRunnableAcctRegService("045", _bank_gb);

			// 신협(048)
			callRunnableAcctRegService("048", _bank_gb);

			// 우체국(071)
			callRunnableAcctRegService("071", _bank_gb);

			// KEB하나(081)
			callRunnableAcctRegService("081", _bank_gb);

			// 신한은행(088)
			callRunnableAcctRegService("088", _bank_gb);

			// 개인용인증서인 경우 케이뱅크
			if("0".equals(_regInfo.getString("CERT_USAG_DIV"))) {
				// 케이뱅크(089)
				callRunnableAcctRegService("089", _bank_gb);
			}


/*
			// 개인용인증서인 경우 개인카드 조회/등록
			if("0".equals(_regInfo.getString("CERT_USAG_DIV"))) {
				// 국민카드(001)
				callRunnablePsnlCardRegService("001");

				// 현대카드(002)
				callRunnablePsnlCardRegService("002");

				// 삼성카드(003)
				callRunnablePsnlCardRegService("003");

				// 비씨카드(006)
				callRunnablePsnlCardRegService("006");

				// 신한카드(008)
				callRunnablePsnlCardRegService("008");

				// 씨티카드(009)
				callRunnablePsnlCardRegService("009");

				// KEB하나카드(015)
				callRunnablePsnlCardRegService("015");

				// 우리카드(018)
				callRunnablePsnlCardRegService("018");

				// 롯데카드(019)
				callRunnablePsnlCardRegService("019");

				// NH농협카드(021)
				callRunnablePsnlCardRegService("021");

				// K뱅크카드(051)
				//callRunnablePsnlCardRegService("051");
			}
*/


			// 기업용인증서인 경우 홈택스 조회/등록
			if("1".equals(_regInfo.getString("CERT_USAG_DIV"))) {
				callRunnableHometaxRegService();
			}

		} catch (Exception e) {
			// 쓰레드 비정상 종료
			BizLogUtil.error(this, _regInfo.getString("USE_INTT_ID"), e, "Thread ["+Thread.currentThread().getName()+"]");
		} finally {
			executorService.shutdown();
		}

		// 요청한 쓰레드가 종료되면 알림 생성
		while(true) {
			if(executorService.isTerminated()) {
				// 계정등록작업 상태 변경 - 완료처리
				updateAcctInqTask();

				// 브리핑 생성
//				makeBriefInfo();
				break;
			}
		}

		String en_tm = DateTime.getInstance().getDate("hhmiss");
        BizLogUtil.info(this, _task_no,"Thread ["+Thread.currentThread().getName()+"] End "+DateTime.getInstance().getTimeBetween(st_tm, en_tm)+"초");
	}

	/**
	 * <pre>
	 * 계정등록작업 생성
	 * </pre>
	 */
	private void insertAcctInqTask() {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		try {
			JexData idoIn1 = util.createIDOData("ACCT_INQ_TASK_C001");
//			idoIn1.put("PTL_ID"        , CommUtil.getPtlId());
			idoIn1.put("USE_INTT_ID"   , _regInfo.getString("USE_INTT_ID"));
			idoIn1.put("TASK_NO"       , _task_no);
			idoIn1.put("TASK_STTS"     , "0");		// 작업상태(0:등록, 1:완료)
			idoIn1.put("CERT_REG_DIV"  , "1");		// 인증서등록구분(0:인증서 미등록, 1:인증서 등록)
			idoIn1.put("CERT_DATA"     , _regInfo.toJSONString());
			idoIn1.put("REG_USER_ID"   , _reg_user_id);

			JexData idoOut1 =  idoCon.execute(idoIn1);
			if (DomainUtil.isError(idoOut1)) throw new JexBIZException(idoOut1);

		} catch (Exception e) {
			BizLogUtil.error(this, _regInfo.getString("USE_INTT_ID")+".insertAcctInqTask()", e, "Thread ["+Thread.currentThread().getName()+"]");
		}
	}

	/**
	 * <pre>
	 * 계정등록작업 상태 변경 - 완료처리
	 * </pre>
	 */
	private void updateAcctInqTask() {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		try {
			JexData idoIn1 = util.createIDOData("ACCT_INQ_TASK_U001");
//			idoIn1.put("PTL_ID"        , CommUtil.getPtlId());
			idoIn1.put("USE_INTT_ID"   , _regInfo.getString("USE_INTT_ID"));
			idoIn1.put("TASK_NO"       , _task_no);
			idoIn1.put("TASK_STTS"     , "1");	// 작업상태(0:등록, 1:완료)

			JexData idoOut1 =  idoCon.execute(idoIn1);
			if (DomainUtil.isError(idoOut1)) throw new JexBIZException(idoOut1);

		} catch (Exception e) {
			BizLogUtil.error(this, _regInfo.getString("USE_INTT_ID")+".updateAcctInqTask()", e, "Thread ["+Thread.currentThread().getName()+"]");
		}
	}

	/**
	 * <pre>
	 * 은행 계정등록
	 * </pre>
	 * @param org_cd
	 * @param bank_gb
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void callRunnableAcctRegService(String org_cd, String bank_gb) throws JexException, JexBIZException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		String ib_type = CommUtil.getCooconIbType(org_cd, bank_gb);

		// 조회 업무 등록
		JexData idoIn1 = util.createIDOData("ACCT_INQ_PTCL_C001");
//		idoIn1.put("PTL_ID"        , CommUtil.getPtlId());
		idoIn1.put("USE_INTT_ID"   , _regInfo.getString("USE_INTT_ID"));
		idoIn1.put("TASK_NO"       , _task_no);
		idoIn1.put("TASK_GB"       , bank_gb);	// 업무구분(1:개인계좌, 2:기업계좌, 3:개인카드, 4:기업카드, 5:홈택스)
		idoIn1.put("BANK_CD"       , org_cd);
		idoIn1.put("INTN_BANK_TYPE", ib_type);

		JexData idoOut1 =  idoCon.execute(idoIn1);
		if (DomainUtil.isError(idoOut1)) throw new JexBIZException(idoOut1);


		// 은행별 전계좌 조회 작업 등록
		Runnable task = new AcctRegServiceRunnable(_task_no, org_cd, ib_type, bank_gb, _regInfo);
		executorService.submit(task);
	}

	/**
	 * <pre>
	 * 개인카드 계정등록
	 * </pre>
	 * @param org_cd
	 * @throws JexException
	 * @throws JexBIZException
	 */
//	private void callRunnablePsnlCardRegService(String org_cd) throws JexException, JexBIZException {
//
//		JexConnection idoCon = JexConnectionManager.createIDOConnection();
//		JexCommonUtil util = JexContext.getContext().getCommonUtil();
//
//		// 조회 업무 등록
//		JexData idoIn1 = util.createIDOData("ACCT_INQ_PTCL_C001");
//		idoIn1.put("PTL_ID"        , CommUtil.getPtlId());
//		idoIn1.put("USE_INTT_ID"   , _regInfo.getString("USE_INTT_ID"));
//		idoIn1.put("TASK_NO"       , _task_no);
//		idoIn1.put("TASK_GB"       , "3");		// 업무구분(1:개인계좌, 2:기업계좌, 3:개인카드, 4:기업카드, 5:홈택스)
//		idoIn1.put("BANK_CD"       , org_cd);
//		idoIn1.put("INTN_BANK_TYPE", "");
//
//		JexData idoOut1 =  idoCon.execute(idoIn1);
//		if (DomainUtil.isError(idoOut1)) throw new JexBIZException(idoOut1);
//
//
//		// 개인카드 조회 작업 등록
//		Runnable task = new PsnlCardRegServiceRunnable(_task_no, org_cd, _regInfo);
//		executorService.submit(task);
//	}

	/**
	 * <pre>
	 * 홈택스 계정등록
	 * </pre>
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void callRunnableHometaxRegService() throws JexException, JexBIZException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		// 조회 업무 등록
		JexData idoIn1 = util.createIDOData("ACCT_INQ_PTCL_C001");
//		idoIn1.put("PTL_ID"        , CommUtil.getPtlId());
		idoIn1.put("USE_INTT_ID"   , _regInfo.getString("USE_INTT_ID"));
		idoIn1.put("TASK_NO"       , _task_no);
		idoIn1.put("TASK_GB"       , "5");		// 업무구분(1:개인계좌, 2:기업계좌, 3:개인카드, 4:기업카드, 5:홈택스)
		idoIn1.put("BANK_CD"       , "");
		idoIn1.put("INTN_BANK_TYPE", "");

		JexData idoOut1 =  idoCon.execute(idoIn1);
		if (DomainUtil.isError(idoOut1)) throw new JexBIZException(idoOut1);

		// 홈택스 조회 작업 등록
		Runnable task = new HometaxRegServiceRunnable(_task_no, _reg_user_id, _regInfo, "", "");
		
		executorService.submit(task);
	}

	/**
	 * <pre>
	 * 계정조회 완료 알림 생성
	 * </pre>
	 */
//	private void makeBriefInfo()
//	{
//		JexConnection idoCon = JexConnectionManager.createIDOConnection();
//		JexCommonUtil util = JexContext.getContext().getCommonUtil();
//
//		try {
//			JexData idoIn1 = util.createIDOData("NOTI_HSTR_C003");
//
//			idoIn1.put("PTL_ID"     , CommUtil.getPtlId());
//			idoIn1.put("USE_INTT_ID", _regInfo.getString("USE_INTT_ID"));
//			idoIn1.put("PROD_CD"	, _regInfo.getString("PROD_CD"));
//			idoIn1.put("NOTI_TITL"  , "계정 조회가 완료되었습니다. 익일까지 등록이 가능합니다.");
//			idoIn1.put("NOTI_MESG"  , "");
//			idoIn1.put("LINK_KEY1"  , _task_no);	// 연결key(작업번호)
//			idoIn1.put("PUSH_MSG"   , "계정 조회가 완료되었습니다. 익일까지 등록이 가능합니다.");
//
//			JexData idoOut1 = idoCon.execute(idoIn1);
//			if (DomainUtil.isError(idoOut1)) throw new JexBIZException(idoOut1);
//
//		} catch (Exception e) {
//			BizLogUtil.error(this, _regInfo.getString("USE_INTT_ID")+".makeBriefInfo()", e, "Thread ["+Thread.currentThread().getName()+"]");
//		}
//	}
}
