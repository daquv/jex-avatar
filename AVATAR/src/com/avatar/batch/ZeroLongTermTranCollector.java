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
 * 제로페이 결제내역 수집(기간)
 * @author won
 *
 */
public class ZeroLongTermTranCollector extends AbstractSimpleBatchTask {

	@Override
	public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {

	    BizLogUtil.debug(this, "execute", "Input :: " + input.toJSONString());

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContext.getContext().getCommonUtil();

        // 그룹별 이용기관 조회(제로페이연결)
        JexData idoIn1 = util.createIDOData("CUST_LINK_SYS_INFM_R008");
        idoIn1.put("APP_ID", "ZEROPAY");
        idoIn1.put("CUST_GRP_CD", input.getString("CUST_GRP_CD"));
        JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);

        for(JexData row : idoOut1)
        {
        	JexData subBatch = this.createSubBatch("ZeroLongTermTranCollectorSub");
			subBatch.put("USE_INTT_ID", row.getString("USE_INTT_ID"));
			this.executeSubBatch(subBatch);
        }

		return null;
	}

}
