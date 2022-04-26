package com.avatar.service;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.json.JSONObject;

/**
 * 쿠콘 계정 등록 서비스
 *
 * 쿠콘 계정 등록 서비스 Runnable 객체 호출
 *
 * @author webcash.co.kr
 *
 */
public class CooconRegService {

	private ExecutorService executorService;

	public CooconRegService() {
        executorService = Executors.newSingleThreadExecutor();
    }

	/**
	 * <pre>
	 * 인증서 정보를 이용한 계정등록 쓰레드 호출
	 * </pre>
	 * @param use_intt_id
	 * @param bsnn_no
	 * @param cert_type	인증서타입(0:개인용, 1:기업용)
	 * @param reg_user_id
	 * @param cert_name
	 * @param cert_org
	 * @param cert_date
	 * @param cert_pwd	복호화된 인증서 비밀번호
	 * @param cert_folder
	 * @param cert_data
	 * @throws JexException
	 * @throws JexBIZException
	 */
	public void regAllAccountWithCertInfo(String use_intt_id, String prod_cd, String bsnn_no, String cert_type, String reg_user_id
			, String cert_name, String cert_org, String cert_date
			, String cert_pwd, String cert_folder, String cert_data) throws JexException, JexBIZException {

		try {
			JSONObject regInfo = new JSONObject();
			regInfo.put("USE_INTT_ID"  , use_intt_id);
			regInfo.put("PROD_CD"  	   , prod_cd);
			regInfo.put("BSNN_NO"      , bsnn_no);
			regInfo.put("CERT_NAME"    , cert_name);
			regInfo.put("CERT_ORG"     , cert_org);
			regInfo.put("CERT_DATE"    , cert_date);
			regInfo.put("CERT_PWD"     , cert_pwd);
			regInfo.put("CERT_FOLDER"  , cert_folder);
			regInfo.put("CERT_DATA"    , cert_data);
			regInfo.put("CERT_USAG_DIV", cert_type);

			Runnable task = new CooconRegServiceRunnable(reg_user_id, regInfo);
			executorService.submit(task);

		} finally {
			executorService.shutdown();
		}
	}
}
