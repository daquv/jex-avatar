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
import com.avatar.comm.SvcDateUtil;

/**
 * 여신금융협회 계정 등록 후 실시간 조회. - Runnable 객체
 *
 * 카드매출내역 조회
 *
 * @author webcash.co.kr
 *
 */
public class CooconCrefiaRealTime implements Runnable {

	private ExecutorService executorService;

	private JSONObject _realTimeInfo;
	private String _task_no;		// 작업일련번호(작업일시-yyyyMMddHHmmssSSS)
	
	public CooconCrefiaRealTime(JSONObject realTimeInfo) {

		_realTimeInfo     = realTimeInfo;
        _task_no     	  = SvcDateUtil.getFormatString("yyyyMMddHHmmssSSS");

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
		insertRtInqTask();

		try {
			// 카드매출 실시간 조회
			callRunnableCrefiaService();
			
		} catch (Exception e) {
			// 쓰레드 비정상 종료
			BizLogUtil.error(this, _realTimeInfo.getString("USE_INTT_ID"), e, "Thread ["+Thread.currentThread().getName()+"]");
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
	private void insertRtInqTask() {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		try {
			JexData idoIn1 = util.createIDOData("RT_INQ_TASK_C001");
			idoIn1.put("USE_INTT_ID"   , _realTimeInfo.getString("USE_INTT_ID"));
			idoIn1.put("TASK_NO"       , _task_no);
			idoIn1.put("TASK_GB"       , "4");		// 작업구분코드(1:계좌, 2:카드, 3:홈택스, 4:여신)
			idoIn1.put("TASK_STTS"     , "0");		// 작업상태(0:등록, 1:완료)

			JexData idoOut1 =  idoCon.execute(idoIn1);
			if (DomainUtil.isError(idoOut1)) throw new JexBIZException(idoOut1);

		} catch (Exception e) {
			BizLogUtil.error(this, _realTimeInfo.getString("USE_INTT_ID")+".insertAcctInqTask()", e, "Thread ["+Thread.currentThread().getName()+"]");
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
			idoIn1.put("USE_INTT_ID"   , _realTimeInfo.getString("USE_INTT_ID"));
			idoIn1.put("TASK_NO"       , _task_no);
			idoIn1.put("TASK_GB"       , "4");		// 작업구분코드(1:계좌, 2:카드, 3:홈택스, 4:여신)
			idoIn1.put("TASK_STTS"     , "1");	// 작업상태(0:등록, 1:완료)

			JexData idoOut1 =  idoCon.execute(idoIn1);
			if (DomainUtil.isError(idoOut1)) throw new JexBIZException(idoOut1);

		} catch (Exception e) {
			BizLogUtil.error(this, _realTimeInfo.getString("USE_INTT_ID")+".updateAcctInqTask()", e, "Thread ["+Thread.currentThread().getName()+"]");
		}
	}

	/**
	 * <pre>
	 * 카드매출 실시간 조회
	 * </pre>
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void callRunnableCrefiaService() throws JexException, JexBIZException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		String start_date = SvcDateUtil.getInstance().getDate(-7, 'D');
		String end_date = SvcDateUtil.getInstance().getDate(-1, 'D');
		    	
		// 증빙설정정보 조회
		JexData idoIn1 = util.createIDOData("EVDC_INFM_R015");
		idoIn1.put("USE_INTT_ID", _realTimeInfo.getString("USE_INTT_ID"));
        idoIn1.put("EVDC_DIV_CD", "10");

		JexData idoOut1 =  idoCon.execute(idoIn1);
		if (DomainUtil.isError(idoOut1)) throw new JexBIZException(idoOut1);

		if(!"0".equals(idoOut1.getAttribute("_RESULT_COUNT_").toString())) {
			
			//카드매출 승인내역 실시간 조회 - Runnable 객체
	        Runnable task1 = new CrefiaApprCooconServiceRunnable(idoOut1, start_date, end_date);
    		executorService.submit(task1);
    		
    		//카드매출 입금내역 실시간 조회 - Runnable 객체
            Runnable task2 = new CrefiaDpstCooconServiceRunnable(idoOut1, start_date, end_date);
    		executorService.submit(task2);
        }
	}
}
