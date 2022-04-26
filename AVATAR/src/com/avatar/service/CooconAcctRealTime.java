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
import com.avatar.service.AcctCooconServiceRunnable;

import com.avatar.comm.BizLogUtil;
import com.avatar.comm.SvcDateUtil;

/**
 * 계좌 등록 후 실시간 조회. - Runnable 객체
 *
 * @author webcash.co.kr
 *
 */
public class CooconAcctRealTime implements Runnable {

	private ExecutorService executorService;

	private JSONObject _acctInfo;
	private String _task_no;		// 작업일련번호(작업일시-yyyyMMddHHmmssSSS)
	private String _pay_yn;
	
	public CooconAcctRealTime(String task_no, JSONObject acctInfo, String pay_yn) {

		_acctInfo     	  = acctInfo;
        //_task_no     	  = SvcDateUtil.getFormatString("yyyyMMddHHmmssSSS");
		_task_no     	  = task_no;
		_pay_yn     	  = pay_yn;

		executorService = Executors.newFixedThreadPool(
				1
        		//Runtime.getRuntime().availableProcessors()
        );
        BizLogUtil.debug(this, "availableProcessors() : "+String.valueOf(Runtime.getRuntime().availableProcessors()));
    }

	@Override
	public void run() {

		String st_tm = DateTime.getInstance().getDate("hhmiss");
		BizLogUtil.info(this, _task_no,"Thread ["+Thread.currentThread().getName()+"] Start");

		// 실시간조회등록작업 생성
     	insertRtInqTask(_acctInfo.getString("BANK_CD"), _acctInfo.getString("FNNC_INFM_NO"));
     	
     	try {
     		callRunnableAcctService();
		} catch (Exception e) {
			// 쓰레드 비정상 종료
			BizLogUtil.error(this, _acctInfo.getString("USE_INTT_ID"), e, "Thread ["+Thread.currentThread().getName()+"]");
		} finally {
			executorService.shutdown();
		}

     	// 요청한 쓰레드가 종료되면 알림 생성
     	while(true) {
 			if(executorService.isTerminated()) {
 				// 실시간조회요청 상태 변경 - 완료처리
 				updateRtInqTask();
 				break;
 			}
     	}
     	
		String en_tm = DateTime.getInstance().getDate("hhmiss");
        BizLogUtil.info(this, _task_no,"Thread ["+Thread.currentThread().getName()+"] End "+DateTime.getInstance().getTimeBetween(st_tm, en_tm)+"초");
	}

	/**
	 * <pre>
	 * 실시간조회요청 - 등록시작
	 * </pre>
	 */
	private void insertRtInqTask(String bank_cd, String fnnc_infm_no) {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		try {
			JexData idoIn1 = util.createIDOData("RT_INQ_TASK_C001");
			idoIn1.put("USE_INTT_ID"   , _acctInfo.getString("USE_INTT_ID"));
			idoIn1.put("TASK_NO"       , _task_no);
			idoIn1.put("TASK_GB"       , "1");		// 작업구분코드(1:계좌, 2:카드, 3:홈택스, 4:여신)
			idoIn1.put("TASK_STTS"     , "0");		// 작업상태(0:등록, 1:완료)
			idoIn1.put("BANK_CD"       , bank_cd);
			idoIn1.put("FNNC_INFM_NO"  , fnnc_infm_no);

			JexData idoOut1 =  idoCon.execute(idoIn1);
			if (DomainUtil.isError(idoOut1)) throw new JexBIZException(idoOut1);

		} catch (Exception e) {
			BizLogUtil.error(this, _acctInfo.getString("USE_INTT_ID")+".insertAcctInqTask()", e, "Thread ["+Thread.currentThread().getName()+"]");
		}
	}

	/**
	 * <pre>
	 * 실시간조회요청 상태 변경 - 완료처리
	 * </pre>
	 */
	private void updateRtInqTask() {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		try {
			JexData idoIn1 = util.createIDOData("RT_INQ_TASK_U001");
			idoIn1.put("USE_INTT_ID"   , _acctInfo.getString("USE_INTT_ID"));
			idoIn1.put("TASK_NO"       , _task_no);
			idoIn1.put("TASK_GB"       , "1");		// 작업구분코드(1:계좌, 2:카드, 3:홈택스, 4:여신)
			idoIn1.put("TASK_STTS"     , "1");		// 작업상태(0:등록, 1:완료)
			idoIn1.put("PROC_RSLT_CD"  , "");
			idoIn1.put("PROC_RSLT_CTT" , "");

			JexData idoOut1 =  idoCon.execute(idoIn1);
			if (DomainUtil.isError(idoOut1)) throw new JexBIZException(idoOut1);

		} catch (Exception e) {
			BizLogUtil.error(this, _acctInfo.getString("USE_INTT_ID")+".updateAcctInqTask()", e, "Thread ["+Thread.currentThread().getName()+"]");
		}
	}

	/**
	 * <pre>
	 * 계좌거래내역 조회 - 실시간
	 * </pre>
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void callRunnableAcctService() throws JexException, JexBIZException {

		String start_date = SvcDateUtil.getInstance().getDate(-7, 'D');
        String end_date = SvcDateUtil.getInstance().getDate(-1, 'D');
        if(_pay_yn.equals("Y")) {
        	end_date = SvcDateUtil.getInstance().getDate();
        }
        
		//계좌 거래내역 실시간 조회 - Runnable 객체
        Runnable task1 = new AcctCooconServiceRunnable(_acctInfo, start_date, end_date, _pay_yn);
     	executorService.submit(task1);
     	
     	//계좌 잔액 실시간 조회 - Runnable 객체
        Runnable task2 = new AcctAmtCooconServiceRunnable(_acctInfo);
     	executorService.submit(task2);
     	
	}
}
