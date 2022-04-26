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
import com.avatar.comm.CommUtil;

/**
 * 카드매출 승인내역 수집
 * @author won
 *
 */
public class CardSalesCollector extends AbstractSimpleBatchTask {

	@Override
	public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {

	    BizLogUtil.debug(this, "execute", "Input :: " + input.toJSONString());

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContext.getContext().getCommonUtil();

        JexData idoIn1 = util.createIDOData("CUST_LDGR_R010");
        idoIn1.put("CUST_GRP_CD", input.getString("CUST_GRP_CD"));
        JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);


        for(JexData row : idoOut1)
        {
        	//LOG.debug(row.getString("USE_INTT_ID"));
        	JexData subBatch = this.createSubBatch("CardSalesCollectorSub");
			subBatch.put("USE_INTT_ID", row.getString("USE_INTT_ID"));
			this.executeSubBatch(subBatch);
        }

		return null;
	}

}
