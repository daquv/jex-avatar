package com.avatar.batch;

import com.avatar.comm.BizLogUtil;

import jex.data.JexData;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.simplebatch.AbstractSimpleBatchTask;
import jex.util.StringUtil;

/**
 * 환율내역 수집
 * @author won
 *
 */
public class ExhgRtRealTimeCollector extends AbstractSimpleBatchTask {

	@Override
	public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {

		BizLogUtil.debug(this, "execute", "Input :: " + input.toJSONString());
		String cust_grp_cd = StringUtil.null2void(input.getString("CUST_GRP_CD"),"");
		
		if(cust_grp_cd.equals("A")) {
			JexData subBatch = this.createSubBatch("ExhgRtRealTimeCollectorSub");
			this.executeSubBatch(subBatch);	
		}
		return null;
	}

}
