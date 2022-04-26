package com.avatar.batch.vo;

import com.avatar.comm.SvcDateUtil;

public class BatchExecVO {

	String job_id; // 작업ID
	String use_intt_id; // 이용기관아이디
	String exec_svr_nm; // 실행서버명
	String job_dt; // 작업일자
	String job_str_tm; // 작업시작시간
	String job_end_tm; // 작업종료시간
	String job_proc_id; // 작업프로세스아이디

	int totl_cnt; // 전체건수
	int nor_cnt; // 정상건수
	int err_cnt; // 오류건수
	int etc_cnt; // 기타건수

//	String totl_cnt; // 전체건수
//	String nor_cnt; // 정상건수
//	String err_cnt; // 오류건수
//	String etc_cnt; // 기타건수

	String proc_stts; // 처리상태
	String proc_rslt_ctt; // 처리결과내용
	String ptl_id; // 포탈아이디

	public BatchExecVO() {
		this.setJob_dt(SvcDateUtil.getShortDateString());
		this.setJob_str_tm(SvcDateUtil.getShortTimeString());
	}

	public void addTotlCnt(int totl_cnt) {
		setTotl_cnt(getTotl_cnt() + totl_cnt);
	}

	public void addNorCnt(int nor_cnt) {
		setNor_cnt(getNor_cnt() + nor_cnt);
	}

	public void addErrCnt(int err_cnt) {
		setErr_cnt(getErr_cnt() + err_cnt);
	}

	public void addEtcCnt(int etc_cnt) {
		setEtc_cnt(getEtc_cnt() + etc_cnt);
	}

	public String getJob_id() {
		return job_id;
	}

	public void setJob_id(String job_id) {
		this.job_id = job_id;
	}

	public String getUse_intt_id() {
		return use_intt_id;
	}

	public void setUse_intt_id(String use_intt_id) {
		this.use_intt_id = use_intt_id;
	}

	public String getExec_svr_nm() {
		return exec_svr_nm;
	}

	public void setExec_svr_nm(String exec_svr_nm) {
		this.exec_svr_nm = exec_svr_nm;
	}

	public String getJob_dt() {
		return job_dt;
	}

	public void setJob_dt(String job_dt) {
		this.job_dt = job_dt;
	}

	public String getJob_str_tm() {
		return job_str_tm;
	}

	public void setJob_str_tm(String job_str_tm) {
		this.job_str_tm = job_str_tm;
	}

	public String getJob_end_tm() {
		return job_end_tm;
	}

	public void setJob_end_tm(String job_end_tm) {
		this.job_end_tm = job_end_tm;
	}

	public String getJob_proc_id() {
		return job_proc_id;
	}

	public void setJob_proc_id(String job_proc_id) {
		this.job_proc_id = job_proc_id;
	}

	public int getTotl_cnt() {
		return totl_cnt;
	}

	public void setTotl_cnt(int totl_cnt) {
		this.totl_cnt = totl_cnt;
	}

	public int getNor_cnt() {
		return nor_cnt;
	}

	public void setNor_cnt(int nor_cnt) {
		this.nor_cnt = nor_cnt;
	}

	public int getErr_cnt() {
		return err_cnt;
	}

	public void setErr_cnt(int err_cnt) {
		this.err_cnt = err_cnt;
	}

	public int getEtc_cnt() {
		return etc_cnt;
	}

	public void setEtc_cnt(int etc_cnt) {
		this.etc_cnt = etc_cnt;
	}

	public String getProc_stts() {
		return proc_stts;
	}

	public void setProc_stts(String proc_stts) {
		this.proc_stts = proc_stts;
	}

	public String getProc_rslt_ctt() {
		return proc_rslt_ctt;
	}

	public void setProc_rslt_ctt(String proc_rslt_ctt) {
		this.proc_rslt_ctt = proc_rslt_ctt;
	}

	public String getPtl_id() {
		return ptl_id;
	}

	public void setPtl_id(String ptl_id) {
		this.ptl_id = ptl_id;
	}

	public void EndBatch() {
		this.setTotl_cnt(getTotl_cnt());
		this.setNor_cnt(getNor_cnt());
		this.setEtc_cnt(getEtc_cnt());
		this.setErr_cnt(getErr_cnt());
	}
}
