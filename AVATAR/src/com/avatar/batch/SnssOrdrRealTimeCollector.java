package com.avatar.batch;

import jex.JexContext;
import jex.data.JexData;
import jex.data.JexDataList;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.simplebatch.AbstractSimpleBatchTask;
import jex.util.biz.JexCommonUtil;
import com.avatar.comm.BizLogUtil;

/**
 * 온라인매출 주문내역 매시간 수집
 * @author won
 *
 */
public class SnssOrdrRealTimeCollector extends AbstractSimpleBatchTask {

	@Override
	public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {

	    BizLogUtil.debug(this, "execute", "Input :: " + input.toJSONString());

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContext.getContext().getCommonUtil();

        // 온라인매출 매시간 조회 신청 고객
        JexData idoIn1 = util.createIDOData("CUST_LDGR_R028");
        idoIn1.put("CUST_GRP_CD", input.getString("CUST_GRP_CD"));
        idoIn1.put("EVDC_GB", "11");
        JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);

        for(JexData row : idoOut1)
        {
        	JexData subBatch = this.createSubBatch("SnssOrdrRealTimeCollectorSub");
			subBatch.put("USE_INTT_ID", row.getString("USE_INTT_ID"));
			this.executeSubBatch(subBatch);
        }

		return null;
	}

}
