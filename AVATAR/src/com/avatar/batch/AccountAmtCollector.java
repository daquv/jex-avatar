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

public class AccountAmtCollector extends AbstractSimpleBatchTask {

	@Override
	public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {

	    BizLogUtil.debug(this, "execute", "Input :: " + input.toJSONString());


		JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContext.getContext().getCommonUtil();

        System.out.println("-------------------");
        JexData idoIn1 = util.createIDOData("CUST_LDGR_R001");
        idoIn1.put("CUST_GRP_CD", input.getString("CUST_GRP_CD"));
        JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);
        int i=0;
        
        for(JexData row : idoOut1)
        {
        	System.out.println("-----["+(i++)+"] ::: " + row.getString("USE_INTT_ID"));
        	
        	//LOG.debug(row.getString("USE_INTT_ID"));
        	JexData subBatch = this.createSubBatch("AccountAmtCollectorSub");
			subBatch.put("USE_INTT_ID", row.getString("USE_INTT_ID"));
			this.executeSubBatch(subBatch);
        }

		return null;
	}

}
