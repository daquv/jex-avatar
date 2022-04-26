package com.avatar.batch.comm;

import jex.data.JexData;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.simplebatch.AbstractSimpleBatchTask;
import jex.util.DomainUtil;
import jex.util.StringUtil;
import jex.util.biz.JexCommonUtil;
import jex.web.JexContextWeb;
import com.avatar.batch.vo.BatchExecVO;
import com.avatar.comm.ServerInfoUtil;
import com.avatar.comm.CommUtil;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.CommonErrorHandler;

public abstract class BatchServiceBiz extends  AbstractSimpleBatchTask  {



	protected void batchExecLogInsert(BatchExecVO vo)  throws JexException, JexBIZException {

//		JexConnection idoCon = JexConnectionManager.createIDOConnection();
//		JexCommonUtil util = JexContextWeb.getContext().getCommonUtil();
//
//		JexData idoIn = util.createIDOData("BACH_EXEC_HSTR_C001");
//		idoIn.put("JOB_ID", vo.getJob_id());
//		idoIn.put("USE_INTT_ID", vo.getUse_intt_id());
//		idoIn.put("EXEC_SVR_NM", ServerInfoUtil.getInstance().getHostName());
//		idoIn.put("JOB_DT", vo.getJob_dt());
//		idoIn.put("JOB_STR_TM", vo.getJob_str_tm());
//		idoIn.put("JOB_END_TM", vo.getJob_end_tm());
//		idoIn.put("JOB_PROC_ID", "");
//		idoIn.put("TOTL_CNT", vo.getTotl_cnt());
//		idoIn.put("NOR_CNT", vo.getNor_cnt());
//		idoIn.put("ERR_CNT", vo.getErr_cnt());
//		idoIn.put("ETC_CNT", vo.getEtc_cnt());
//		idoIn.put("PROC_STTS", vo.getProc_stts());
//		idoIn.put("PROC_RSLT_CTT", vo.getProc_rslt_ctt());
//		idoIn.put("PTL_ID", CommUtil.getPtlId());
//		JexData idoOut = idoCon.execute(idoIn);
//
//		if (DomainUtil.isError(idoOut)) CommonErrorHandler.comHandler(idoOut);
	}

	protected String getbsnnNo(String use_intt_id) throws JexException, JexBIZException {

//		JexConnection idoCon = JexConnectionManager.createIDOConnection();
//		JexCommonUtil util = JexContextWeb.getContext().getCommonUtil();
//
//		JexData idoIn1 = util.createIDOData("INTT_LDGR_R002");
//        idoIn1.put("PTL_ID", CommUtil.getPtlId());
//        idoIn1.put("USE_INTT_ID", use_intt_id);
//        JexData idoOut1 = idoCon.execute(idoIn1);
//
//        return idoOut1.getString("BSNN_NO");
		
		//사업자번호 대신
		
		//test !!!!
		if(use_intt_id.startsWith("UTLZ_")) {
			use_intt_id = use_intt_id.substring(5);
		}
		
		return use_intt_id;
	}

	protected void log(String msg){
		//StackTraceElement[] stacks = new Throwable().getStackTrace();
		BizLogUtil.debug(this, msg);
	}

//	protected int getBadgCnt(String use_intt_id) throws JexException, JexBIZException {
//		JexConnection idoCon = JexConnectionManager.createIDOConnection();
//		JexCommonUtil util = JexContextWeb.getContext().getCommonUtil();
//
//		JexData idoIn1 = util.createIDOData("USER_LDGR_R001");
//        idoIn1.put("PTL_ID", CommUtil.getPtlId());
//        idoIn1.put("USE_INTT_ID", use_intt_id);
//        JexData idoOut1 = idoCon.execute(idoIn1);
//
//        return Integer.parseInt(StringUtil.null2void(idoOut1.getString("BADG_CNT"), "0")) ;
//	}

//	protected String getUserId(String use_intt_id) throws JexException, JexBIZException {
//		JexConnection idoCon = JexConnectionManager.createIDOConnection();
//		JexCommonUtil util = JexContextWeb.getContext().getCommonUtil();
//
//		JexData idoIn1 = util.createIDOData("USER_LDGR_R001");
//		idoIn1.put("PTL_ID", CommUtil.getPtlId());
//		idoIn1.put("USE_INTT_ID", use_intt_id);
//		JexData idoOut1 = idoCon.execute(idoIn1);
//
//		return idoOut1.getString("USER_ID");
//	}
	
//	protected void extnInsert(String use_intt_id, String biz_div, String trns_div, String proc_rslt_cd, String proc_rslt_ctt) {
//		ExtnTrnsHis.insert(use_intt_id, biz_div, trns_div, proc_rslt_cd, proc_rslt_ctt);
//	}

}
