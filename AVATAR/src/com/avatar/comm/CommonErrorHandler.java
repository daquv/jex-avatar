package com.avatar.comm;

import jex.data.JexData;
import jex.data.JexDataList;
import jex.exception.JexBIZException;
import jex.log.JexLogFactory;
import jex.log.JexLogger;
import jex.task.AbstractTask;
import jex.util.DomainUtil;

public class CommonErrorHandler extends AbstractTask {
	private static final JexLogger LOG = JexLogFactory.getLogger(CommonErrorHandler.class);
	
	/**
	 * 공통에러처리
	 * @param data
	 * @throws JexBIZException
	 */
	public static void comHandler(JexData data) throws JexBIZException{
		if(LOG.isDebug()) {
			LOG.error("Error Code   ::"+DomainUtil.getErrorCode    (data));
			LOG.error("Error Message::"+DomainUtil.getErrorMessage  (data));
		}
		throw new JexBIZException(data);
	}

	/**
	 * 공통에러처리
	 * @param data
	 * @throws JexBIZException
	 */
	public static void comHandler(JexDataList<JexData> data) throws JexBIZException{
		if(LOG.isDebug()) {
			LOG.error("Error Code   ::"+DomainUtil.getErrorCode    (data));
			LOG.error("Error Message::"+DomainUtil.getErrorMessage  (data));
		}
		throw new JexBIZException(data);
	}
}
