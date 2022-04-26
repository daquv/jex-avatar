package com.avatar.service;

import jex.JexContext;
import jex.data.JexData;
import jex.data.impl.ido.IDODynamic;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.exception.JexTransactionRollbackException;
import jex.json.JSONObject;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.util.DomainUtil;
import jex.util.StringUtil;
import jex.util.biz.JexCommonUtil;
import jex.util.date.DateTime;
import com.avatar.api.mgnt.CooconApi;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.CommUtil;
//import com.avatar.comm.ExtnTrnsHis;

/**
 * 인증서 정보를 이용한 홈택스 등록 - Runnable 객체
 *
 * @author webcash.co.kr
 *
 */
public class HometaxRegServiceRunnable implements Runnable {

	private String _reg_user_id;
	private String _use_intt_id;
	private String _prod_cd;
	private String _task_no;
	private String _bsnn_no;
	private String _cert_name;
	private String _cert_org;
	private String _cert_date;
	private String _cert_pwd;
	private String _cert_folder;
	private String _cert_data;
	private String _tax_agent_no;
	private String _tax_agent_password;

	public HometaxRegServiceRunnable(String task_no, String reg_user_id, JSONObject regInfo, String tax_agent_no, String tax_agent_password) {

		_reg_user_id 		= reg_user_id;
		_task_no     		= task_no;
		_use_intt_id 		= regInfo.getString("USE_INTT_ID");
		_prod_cd 	 		= regInfo.getString("PROD_CD");
		_bsnn_no     		= regInfo.getString("BSNN_NO");
		_cert_name   		= regInfo.getString("CERT_NAME");
		_cert_org    		= regInfo.getString("CERT_ORG");
		_cert_date   		= regInfo.getString("CERT_DATE");
		_cert_pwd    		= regInfo.getString("CERT_PWD");
		_cert_folder 		= regInfo.getString("CERT_FOLDER");
		_cert_data   		= regInfo.getString("CERT_DATA");
		_tax_agent_no   	= tax_agent_no;
		_tax_agent_password = tax_agent_password;
	}

	@Override
	public void run() {

		String st_tm = DateTime.getInstance().getDate("hhmiss");
		BizLogUtil.info(this, _use_intt_id,"Thread ["+Thread.currentThread().getName()+"] Start");

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		try {
        	//테스트사업자번호인 경우 사업자번호 변경
			String bsnn_no = _bsnn_no;
//			if(_bsnn_no.startsWith("10399")) {
//				if(_cert_name.indexOf("웹케시글로벌") > -1){
//					bsnn_no = "1078527739";
//	    		}else if(_cert_name.indexOf("웹케시벡터") > -1 || _cert_name.indexOf("웹케시홀딩스") > -1){
//	    			bsnn_no = "1078772295";
//	    		}else if(_cert_name.indexOf("비즈플레이") > -1){
//	    			bsnn_no = "1078836127";
//	    		}else if(_cert_name.indexOf("웹케시네트웍스") > -1 || _cert_name.indexOf("한국가치서비스") > -1){
//	    			bsnn_no = "1078686171";
//	    		}
//			}

			//쿠콘 API 호출 - 사업자등록증명
        	//JSONObject rsltData = CooconApi.gateway_1506(bsnn_no, _cert_name, _cert_org, _cert_date, _cert_pwd, _cert_folder, _cert_data);
			JSONObject rsltData = CooconApi.gateway_1506(bsnn_no, _cert_name, _cert_org, _cert_date, _cert_pwd, _cert_folder, _cert_data, _tax_agent_no, _tax_agent_password);
        	
        	//조회결과
        	String rsltCd  = rsltData.getString("RESULT_CD");
    		String rsltMsg = rsltData.getString("RESULT_MG");

        	// 호출 이력 등록
//    		ExtnTrnsHis.insert(_use_intt_id, "C", "1506", rsltCd, rsltMsg);

    		if("00000000".equals(rsltCd)){

    			rsltCd = "0000";

/*
    			// 사업자등록증명 정보를 이용기관원장에 반영한다.
    			// 기관원장 정보 조회
    			JexData idoInIntt = util.createIDOData("INTT_LDGR_R014");
    			idoInIntt.put("PTL_ID"     , CommUtil.getPtlId());
    			idoInIntt.put("USE_INTT_ID", _use_intt_id);
    			idoInIntt.put("PROD_CD"	   , _prod_cd);
    	    	JexData idoOutIntt =  idoCon.execute(idoInIntt);
    	    	// 도메인 에러 검증
		        if (DomainUtil.isError(idoOutIntt)) throw new JexBIZException(idoOutIntt);

	 	    	IDODynamic dynamic = new IDODynamic();

	 	    	// 등록되어 있는 회사명이 없는 경우
	        	if(("").equals(StringUtil.null2void(idoOutIntt.getString("BSNN_NM")))){
	        		dynamic.addSQL("\n	BSNN_NM = '"+StringUtil.null2void(rsltData.getString("COMPANY")).replaceAll("'", "''")+"', ");
	        	}
	        	// 등록되어 있는 대표자명이 없는 경우
	        	if(("").equals(StringUtil.null2void(idoOutIntt.getString("RPPR_NM")))){
	        		dynamic.addSQL("\n	RPPR_NM = '"+StringUtil.null2void(rsltData.getString("NAME")).replaceAll("'", "''")+"', ");
	        	}
	        	// 등록되어 있는 업태가 없는 경우
	        	if(("").equals(StringUtil.null2void(idoOutIntt.getString("BSST")))){
	        		dynamic.addSQL("\n	BSST = '"+StringUtil.null2void(rsltData.getString("CATEGORY")).replaceAll("'", "''")+"', ");
	        	}
	        	// 등록되어 있는 종목이 없는 경우
	        	if(("").equals(StringUtil.null2void(idoOutIntt.getString("TPBS")))){
	        		dynamic.addSQL("\n	TPBS = '"+StringUtil.null2void(rsltData.getString("TYPE")).replaceAll("'", "''")+"', ");
	        	}
	        	// 등록되어 있는 주소가 없는 경우
	        	if(("").equals(StringUtil.null2void(idoOutIntt.getString("ADRS")))){
	        		dynamic.addSQL("\n	ADRS = '"+StringUtil.null2void(rsltData.getString("COMP_ADDR")).replaceAll("'", "''")+"', ");
	            	dynamic.addSQL("\n	DTL_ADRS = '', ");
	            	dynamic.addSQL("\n	ZPCD = '', ");
	        	}
	        	// 변경할 항목이 있으면 실행
	        	if(!"".equals(dynamic.getSQL())) {
		        	JexData idoIn02 = util.createIDOData("INTT_LDGR_U010");
		        	idoIn02.put("PTL_ID"     , CommUtil.getPtlId());
		        	idoIn02.put("USE_INTT_ID", _use_intt_id);
		        	idoIn02.put("EDTR_ID"    , _reg_user_id);
		        	idoIn02.put("DYNAMIC"    , dynamic);
		        	JexData idoOut02 =  idoCon.execute(idoIn02);
		        	// 도메인 에러 검증
		            if (DomainUtil.isError(idoOut02)) {
		            	throw new JexBIZException(idoOut02);
			        }else{
			        	// 캐시원 통합어드민  API 호출 - 고객정보 반영
				    	String resultYn = CashOneService.getInstance().sendInttLdgrInfo(_use_intt_id, _prod_cd);
				    	String other_prod_cd = ""; 
				    	
				    	// 기초데이터가 변경되어서 캐시원에 둘다 전송해야됨.
				    	if(_prod_cd.equals("SEMO_000")) {
				    		other_prod_cd = "SEMO_003";
				    	}else{
				    		other_prod_cd = "SEMO_000";
				    	}
				    	
				    	// 타상품 가입여부 조회
				    	JexData idoIn03 = util.createIDOData("PROD_LDGR_R013");
			        	idoIn03.put("USE_INTT_ID", _use_intt_id);
			        	idoIn03.put("PROD_CD", other_prod_cd);
			        	
			        	JexData idoOut03 =  idoCon.execute(idoIn03);
			        	// 도메인 에러 검증
			            if (DomainUtil.isError(idoOut03)) {
			            	throw new JexBIZException(idoOut03);
				        }
			            
			            if(!"0".equals(idoOut03.getString("CNT"))) {
			            	resultYn = CashOneService.getInstance().sendInttLdgrInfo(_use_intt_id, other_prod_cd);
			            }
			        }
	        	}
*/

	        	// 등록 전 기존에 등록된 내역이 있을 수도 있으니 삭제 처리함.================================
	        	// 전자세금계산서 정보 삭제
    			rsltData = CooconApi.deleteEvdcTxbl(_bsnn_no, _bsnn_no, _cert_name, "0", "1");
                // 외부이력테이블에 응답 결과 이력 입력
//	            ExtnTrnsHis.insert(_use_intt_id, "C", "0100_006_D", rsltData.getString("ERRCODE"), rsltData.getString("ERRMSG"));


	            // 현금영수증 정보 삭제
    			rsltData = CooconApi.deleteEvdcCash(_bsnn_no, _bsnn_no, _cert_name, "0", "1", _tax_agent_no);
                // 외부이력테이블에 응답 결과 이력 입력
//	            ExtnTrnsHis.insert(_use_intt_id, "C", "0100_002_D", rsltData.getString("ERRCODE"), rsltData.getString("ERRMSG"));
	            //================================================================================


    			// 쿠콘 API 호출 - 홈택스 전자세금계산서 정보등록
    			rsltData = CooconApi.insertEvdcTxbl(_bsnn_no, _bsnn_no, _cert_name, _cert_org, _cert_date, _cert_pwd, _cert_folder, _cert_data, "1", "1", "", _tax_agent_no,  _tax_agent_password);
    			//조회결과
            	String rsltCd_Txbl  = rsltData.getString("ERRCODE");
        		String rsltMsg_Txbl = rsltData.getString("ERRMSG");
    			// 호출 이력 등록
//        		ExtnTrnsHis.insert(_use_intt_id, "C", "0100_006_I", rsltCd_Txbl, rsltMsg_Txbl);


        		// 쿠콘 API 호출 - 홈택스 현금영수증 정보등록
        		rsltData = CooconApi.insertEvdcCash(_bsnn_no, _bsnn_no, _cert_name, _cert_org, _cert_date, _cert_pwd, _cert_folder, _cert_data, "1", "1", _tax_agent_no, _tax_agent_password);
    			//조회결과
            	String rsltCd_Cash  = rsltData.getString("ERRCODE");
        		String rsltMsg_Cash = rsltData.getString("ERRMSG");
    			// 호출 이력 등록
//        		ExtnTrnsHis.insert(_use_intt_id, "C", "0100_002_I", rsltCd_Cash, rsltMsg_Cash);


        		// (00000000:정상, WSND0004:이미 등록된 내용이 있습니다.)
        		if(("00000000".equals(rsltCd_Txbl)||"WSND0004".equals(rsltCd_Txbl)) && ("00000000".equals(rsltCd_Cash)||"WSND0004".equals(rsltCd_Cash))){

        			idoCon.beginTransaction();

        			try {
        				// 전자세금계산서/현금영수증 증빙설정정보 등록여부를 조회한다.
        				JexData idoInSrch = util.createIDOData("EVDC_INFM_R009");
//        				idoInSrch.put("PTL_ID"      , CommUtil.getPtlId());
        				idoInSrch.put("USE_INTT_ID" , _use_intt_id);
        				idoInSrch.put("EVDC_DIV_CD1", "20");
        				idoInSrch.put("EVDC_DIV_CD2", "21");
        		        JexData idoOutSrch =  idoCon.execute(idoInSrch);
        		        // 도메인 에러 검증
        		        if (DomainUtil.isError(idoOutSrch)) throw new JexTransactionRollbackException(idoOutSrch);

        		        String stts = StringUtil.null2void(idoOutSrch.getString("STTS"));				// 전자(세금)계산서 상태값
        		    	String other_stts = StringUtil.null2void(idoOutSrch.getString("OTHER_STTS"));	// 현금영수증 상태값

        				if("".equals(stts)) {
        					// 전자(세금)계산서 증빙설정정보 등록
            		        JexData idoIn1 = util.createIDOData("EVDC_INFM_C002");
//            		        idoIn1.put("PTL_ID"     , CommUtil.getPtlId());
            		        idoIn1.put("USE_INTT_ID", _use_intt_id);
            		        idoIn1.put("EVDC_DIV_CD", "20");
            		        idoIn1.put("BIZ_NO"     , _bsnn_no);
            		        idoIn1.put("CERT_NM"    , _cert_name);
            		        idoIn1.put("CERT_ORG"   , _cert_org);
            		        idoIn1.put("CERT_DT"    , _cert_date);
            		        idoIn1.put("STTS"       , "1");
//            		        idoIn1.put("WEB_ID"     , "");
//        		    		idoIn1.put("WEB_PWD"    , "");
            		        idoIn1.put("REGR_ID", _reg_user_id);
            		        idoIn1.put("CORR_ID", _reg_user_id);
            		        JexData idoOut1 =  idoCon.execute(idoIn1);
            		        // 도메인 에러 검증
            		        if (DomainUtil.isError(idoOut1)) throw new JexTransactionRollbackException(idoOut1);
        				} else {
        					// 전자(세금)계산서 증빙설정정보 변경
        		    		JexData idoIn1 = util.createIDOData("EVDC_INFM_U008");
        		    		idoIn1.put("CERT_NM"    , _cert_name);
        		    		idoIn1.put("CERT_ORG"   , _cert_org);
        		    		idoIn1.put("CERT_DT"    , _cert_date);
        		    		idoIn1.put("STTS"       , "1");
        		    		idoIn1.put("CORR_ID", _reg_user_id);
//        		    		idoIn1.put("PTL_ID"     , CommUtil.getPtlId());
        		    		idoIn1.put("USE_INTT_ID", _use_intt_id);
        		    		idoIn1.put("EVDC_DIV_CD", "20");
        		    		idoIn1.put("BIZ_NO"     , _bsnn_no);
//        		    		idoIn1.put("WEB_ID"     , "");
//        		    		idoIn1.put("WEB_PWD"    , "");
        			        JexData idoOut1 =  idoCon.execute(idoIn1);
        			        // 도메인 에러 검증
        			        if (DomainUtil.isError(idoOut1)) throw new JexTransactionRollbackException(idoOut1);
        				}


        				if("".equals(other_stts)) {
        					// 현금영수증 증빙설정정보 등록
                	        JexData idoIn1 = util.createIDOData("EVDC_INFM_C002");
//                	        idoIn1.put("PTL_ID"     , CommUtil.getPtlId());
                	        idoIn1.put("USE_INTT_ID", _use_intt_id);
                	        idoIn1.put("EVDC_DIV_CD", "21");
                	        idoIn1.put("BIZ_NO"     , _bsnn_no);
                	        idoIn1.put("CERT_NM"    , _cert_name);
                	        idoIn1.put("CERT_ORG"   , _cert_org);
                	        idoIn1.put("CERT_DT"    , _cert_date);
                	        idoIn1.put("STTS"       , "1");
//                	        idoIn1.put("WEB_ID"     , "");
//        		    		idoIn1.put("WEB_PWD"    , "");
                	        idoIn1.put("REGR_ID", _reg_user_id);
                	        idoIn1.put("CORR_ID", _reg_user_id);
                	        JexData idoOut1 =  idoCon.execute(idoIn1);
                	        // 도메인 에러 검증
                	        if (DomainUtil.isError(idoOut1)) throw new JexTransactionRollbackException(idoOut1);
        				} else {
        					// 현금영수증 증빙설정정보 변경
        		    		JexData idoIn1 = util.createIDOData("EVDC_INFM_U008");
        		    		idoIn1.put("CERT_NM"    , _cert_name);
        		    		idoIn1.put("CERT_ORG"   , _cert_org);
        		    		idoIn1.put("CERT_DT"    , _cert_date);
        		    		idoIn1.put("STTS"       , "1");
        		    		idoIn1.put("CORR_ID", _reg_user_id);
//        		    		idoIn1.put("PTL_ID"     , CommUtil.getPtlId());
        		    		idoIn1.put("USE_INTT_ID", _use_intt_id);
        		    		idoIn1.put("EVDC_DIV_CD", "21");
        		    		idoIn1.put("BIZ_NO"     , _bsnn_no);
//        		    		idoIn1.put("WEB_ID"     , "");
//        		    		idoIn1.put("WEB_PWD"    , "");
        			        JexData idoOut1 =  idoCon.execute(idoIn1);
        			        // 도메인 에러 검증
        			        if (DomainUtil.isError(idoOut1)) throw new JexTransactionRollbackException(idoOut1);
        				}


            	        // 인증서등록/변경
            	        JexData idoIn2 = util.createIDOData("CERT_INFM_C002");
//            	        idoIn2.put("PTL_ID"       , CommUtil.getPtlId());
            	        idoIn2.put("USE_INTT_ID"  , _use_intt_id);
            	        idoIn2.put("CERT_NM"      , _cert_name);
            	        idoIn2.put("CERT_ORG"     , _cert_org);
            	        idoIn2.put("CERT_DSNC"    , "");
            	        idoIn2.put("CERT_DT"      , _cert_date);
            	        idoIn2.put("CERT_ISSU_DT" , "");
            	        idoIn2.put("CERT_STTS"    , "1");
            	        idoIn2.put("CERT_USAG_DIV", "1"); // 인증서용도구분(0:개인, 1:법인)
            	        idoIn2.put("REGR_ID"      , _reg_user_id);
            	        idoIn2.put("CORR_ID"      , _reg_user_id);
        				JexData idoOut2 =  idoCon.execute(idoIn2);
        			    // 도메인 에러 검증
        			    if (DomainUtil.isError(idoOut2)) throw new JexTransactionRollbackException(idoOut2);

    				} catch (Exception e) {
    					BizLogUtil.error(this, _use_intt_id, e, "Thread ["+Thread.currentThread().getName()+"]");
    				}

        			idoCon.endTransaction();

        		} else {
        			// 셰금계산서 정보 등록 오류 먼저.
        			rsltCd  = rsltCd_Txbl;
        			rsltMsg = rsltMsg_Txbl;
        			// 세금계산서 정보 등록이 정상이면, 현금영수증 정보 등록 오류.
        			if("00000000".equals(rsltCd)||"WSND0004".equals(rsltCd)){
        				rsltCd  = rsltCd_Cash;
            			rsltMsg = rsltMsg_Cash;
        			}

        			// 전자세금계산서 정보 삭제
        			rsltData = CooconApi.deleteEvdcTxbl(_bsnn_no, _bsnn_no, _cert_name, "0", "1");
                    // 외부이력테이블에 응답 결과 이력 입력
//    	            ExtnTrnsHis.insert(_use_intt_id, "C", "0100_006_D", rsltData.getString("ERRCODE"), rsltData.getString("ERRMSG"));


    	            // 현금영수증 정보 삭제
        			rsltData = CooconApi.deleteEvdcCash(_bsnn_no, _bsnn_no, _cert_name, "0", "1", _tax_agent_no);
                    // 외부이력테이블에 응답 결과 이력 입력
//    	            ExtnTrnsHis.insert(_use_intt_id, "C", "0100_002_D", rsltData.getString("ERRCODE"), rsltData.getString("ERRMSG"));
        		}
    		}

    		// 조회계정의 상태 변경
    		updateAcctInqPtcl(idoCon, rsltCd, rsltMsg);

		} catch (Exception e) {
			// 쓰레드 비정상 종료
			BizLogUtil.error(this, _use_intt_id, e, "Thread ["+Thread.currentThread().getName()+"]");
		}

		String en_tm = DateTime.getInstance().getDate("hhmiss");
        BizLogUtil.info(this, _use_intt_id,"Thread ["+Thread.currentThread().getName()+"] End "+DateTime.getInstance().getTimeBetween(st_tm, en_tm)+"초");
	}

	/**
	 * <pre>
	 * 조회계정의 상태 변경
	 * </pre>
	 * @param idoCon
	 * @param rslt_cd
	 * @param rslt_msg
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void updateAcctInqPtcl(JexConnection idoCon, String rslt_cd, String rslt_msg) throws JexException, JexBIZException
	{
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("ACCT_INQ_PTCL_U001");

//		idoIn1.put("PTL_ID"       , CommUtil.getPtlId());
		idoIn1.put("USE_INTT_ID"  , _use_intt_id);
		idoIn1.put("TASK_NO"      , _task_no);
		idoIn1.put("TASK_GB"      , "5");					// 업무구분(1:개인계좌, 2:기업계좌, 3:개인카드, 4:기업카드, 5:홈택스)
		idoIn1.put("BANK_CD"      , "");
		idoIn1.put("PROC_RSLT_CD" , rslt_cd);
		idoIn1.put("PROC_RSLT_CTT", rslt_msg);

		JexData idoOut1 =  idoCon.execute(idoIn1);
		if (DomainUtil.isError(idoOut1)) throw new JexBIZException(idoOut1);
	}
}

