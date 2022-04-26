package com.avatar.service;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import com.avatar.comm.SvcDateUtil;

import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.json.JSONArray;
import jex.json.JSONObject;

/**
 * 쿠콘 계정 실시간조회 서비스
 *
 * 쿠콘 계정 실시간조회 Runnable 객체 호출
 *
 * @author webcash.co.kr
 *
 */
public class CooconRealTimeService {

	private ExecutorService executorService;

	public CooconRealTimeService() {
		executorService = Executors.newSingleThreadExecutor();
	}

	/**
	 * <pre>
	 * 계좌거래내역 실시간 조회
	 * </pre>
	 * @param acctList
	 * @param pay_yn
	 * @throws JexException
	 * @throws JexBIZException
	 */
	public void searchAcctRealTime(JSONArray acctList, String pay_yn) throws JexException, JexBIZException {

		try {
			// 계좌리스트
	     	for(int i = 0; i< acctList.size(); i++){
	     		JSONObject acctInfo = (JSONObject)acctList.get(i);

				Runnable task = new CooconAcctRealTime(SvcDateUtil.getFormatString("yyyyMMddHHmmssSSS")+i, acctInfo, pay_yn);
				executorService.submit(task);
	     	}

		} finally {
			executorService.shutdown();
		}
	}
	
	/**
	 * <pre>
	 * 카드승인내역 실시간 조회
	 * </pre>
	 * @param use_intt_id
	 * @param scqkey
	 * @param cardList
	 * @param pay_yn
	 * @throws JexException
	 * @throws JexBIZException
	 */
	public void searchCardRealTime(String use_intt_id, String scqkey, JSONArray cardList, String pay_yn) throws JexException, JexBIZException {

		try {
			// 카드리스트
	     	for(int i = 0; i< cardList.size(); i++){
	     		JSONObject cardInfo = (JSONObject)cardList.get(i);
	     		cardInfo.put("USE_INTT_ID"  , use_intt_id);
	     		cardInfo.put("SCQKEY"  		, scqkey);
	     		cardInfo.put("PAY_YN"  		, pay_yn);
	     		
				Runnable task = new CooconCardRealTime(SvcDateUtil.getFormatString("yyyyMMddHHmmssSSS")+i, cardInfo);
				executorService.submit(task);
	     	}
	     	
		} finally {
			executorService.shutdown();
		}
	}
	/**
	 * <pre>
	 * 홈택스 실시간 조회
	 * </pre>
	 * @param use_intt_id
	 * @param pay_yn
	 * @param task_gb
	 * @throws JexException
	 * @throws JexBIZException
	 */
	public void searchHometaxRealTime(String use_intt_id, String pay_yn, String task_gb) throws JexException, JexBIZException {

		try {
			JSONObject realTimeInfo = new JSONObject();
			realTimeInfo.put("USE_INTT_ID"  , use_intt_id);
			realTimeInfo.put("PAY_YN"  		, pay_yn);
			realTimeInfo.put("TASK_GB"  	, task_gb);
			
			Runnable task = new CooconHometaxRealTime(realTimeInfo);
			executorService.submit(task);

		} finally {
			executorService.shutdown();
		}
	}
	
	/**
	 * <pre>
	 * 카드매출 실시간 조회
	 * </pre>
	 * @param use_intt_id
	 * @throws JexException
	 * @throws JexBIZException
	 */
	public void searchCrefiaRealTime(String use_intt_id) throws JexException, JexBIZException {

		try {
			JSONObject realTimeInfo = new JSONObject();
			realTimeInfo.put("USE_INTT_ID"  , use_intt_id);
			
			Runnable task = new CooconCrefiaRealTime(realTimeInfo);
			executorService.submit(task);

		} finally {
			executorService.shutdown();
		}
	}
	
	/**
	 * <pre>
	 * 쇼핑몰(배달앱) 실시간 조회
	 * </pre>
	 * @param use_intt_id
	 * @param shop_cd
	 * @param sub_shop_cd
	 * @param pay_yn
	 * @throws JexException
	 * @throws JexBIZException
	 */
	public void searchSnssDlvryRealTime(String use_intt_id, String shop_cd, String sub_shop_cd, String pay_yn) throws JexException, JexBIZException {

		try {
			JSONObject realTimeInfo = new JSONObject();
			realTimeInfo.put("USE_INTT_ID"  , use_intt_id);
			realTimeInfo.put("PAY_YN"  		, pay_yn);
			realTimeInfo.put("SHOP_CD"  	, shop_cd);
			realTimeInfo.put("SUB_SHOP_CD"  , sub_shop_cd);
			
			Runnable task = new CooconSnssDlvryRealTime(realTimeInfo);
			executorService.submit(task);

		} finally {
			executorService.shutdown();
		}
	}
}
