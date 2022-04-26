package com.avatar.batch;

import com.avatar.comm.BizLogUtil;
import com.avatar.comm.CommonErrorHandler;

import jex.JexContext;
import jex.data.JexData;
import jex.data.JexDataList;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.simplebatch.AbstractSimpleBatchTask;
import jex.util.DomainUtil;
import jex.util.biz.JexCommonUtil;

/**
 * 배치 > 시스템 > 푸시 > 푸시 발송
 *
 */
public class PushMessageSender extends AbstractSimpleBatchTask {

    @Override
    public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {

        BizLogUtil.debug(this, "execute", "Input :: " + input.toJSONString());

        JexConnection idoCon = JexConnectionManager.createIDOConnection();
        JexCommonUtil util = JexContext.getContext().getCommonUtil();


        try {

            JexData idoIn1 = util.createIDOData("PUSH_DEVI_LDGR_R002");
            idoIn1.put("CUST_GRP_CD", input.getString("CUST_GRP_CD"));
            JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);

            // 도메인 에러 검증
            if (DomainUtil.isError(idoOut1))
                CommonErrorHandler.comHandler(idoOut1);

            // 총 건수 구하기(순전히 로깅을 위해)
            int iTotCnt = 0;

            for(JexData row : idoOut1)
            {
                JexData subBatch = this.createSubBatch("PushMessageSenderSub");
                subBatch.put("USE_INTT_ID", row.getString("USE_INTT_ID"));
                this.executeSubBatch(subBatch);

                iTotCnt++;
            }
            BizLogUtil.info(this, "execute", "그룹별 이용기관 건수("+input.getString("INTT_GRP_CD")+") : "+String.valueOf(iTotCnt));

        } catch(Throwable e) {
            BizLogUtil.error(this, "execute", e);
        }

        return null;
    }

}
