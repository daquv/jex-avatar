package com.avatar.session;

import java.io.Serializable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jex.data.impl.cmo.JexDataCMO;
import jex.exception.JexBIZException;
import jex.log.JexLogFactory;
import jex.log.JexLogger;
import jex.sys.JexSystemConfig;
import jex.util.JexUtil;
import jex.web.exception.JexWebBIZException;
import jex.web.impl.DefaultWebUserAuthority;

public class SessionManager implements Serializable{
	private static final long serialVersionUID = 919376058275098881L;
	private static final JexLogger LOG = JexLogFactory.getLogger(SessionManager.class);

	public final static String AVATAR_SESSIONATTRIBUTE = "AVATAR_SESSION";
	public final static String AVATAR_SESSIONDISCONNECT_MESSAGE = "Session Disconnect";
	
	static private SessionManager iNSTANCE = new SessionManager();

	private static int activeInterval = 0;

	private SessionManager() {
	}

	static public SessionManager getInstance() {
		return iNSTANCE;
	}

	public void setUserSession(HttpServletRequest request, HttpServletResponse response, JexDataCMO comSession ) {
		this.setUserSession(request, response, comSession, 0);
	}

	public void setUserSession(HttpServletRequest request, HttpServletResponse response, JexDataCMO comSession, int session_time) {
		HttpSession session = request.getSession(true);
		
		if(LOG.isDebug()) LOG.debug("SessionManager setUserSession :: " + session);
		if (session != null) {
			session.setAttribute(AVATAR_SESSIONATTRIBUTE, comSession);
			session.setAttribute(DefaultWebUserAuthority.KEY_SESSION_USER_ID, comSession.getString("CUST_CI"));
			
			if (0 == session_time) {
				activeInterval = JexUtil.toInt(JexSystemConfig.get("web/session", "inActiveInterval", "1800"));
			} else {
				activeInterval = session_time;				
			}
			session.setMaxInactiveInterval(activeInterval);
		}
	}

	public JexDataCMO getUserSession(HttpServletRequest request, HttpServletResponse response) throws Throwable {
		HttpSession session = request.getSession(true);
		if (session.getAttribute(AVATAR_SESSIONATTRIBUTE) != null) {

			LOG.debug("SessionManager getUserSession :: " + ((JexDataCMO) session.getAttribute(AVATAR_SESSIONATTRIBUTE)).toJSON());
			// 여기까지
			return (JexDataCMO) session.getAttribute(AVATAR_SESSIONATTRIBUTE);
		} else {
			throw new JexWebBIZException(AVATAR_SESSIONDISCONNECT_MESSAGE, AVATAR_SESSIONDISCONNECT_MESSAGE);
		}
	}

	public static JexDataCMO getSession(HttpServletRequest request, HttpServletResponse response) throws JexBIZException, JexWebBIZException
	{		
		HttpSession session = request.getSession(true);
		if (session.getAttribute(AVATAR_SESSIONATTRIBUTE) != null) {

			LOG.debug("SessionManager getSession :: " + ((JexDataCMO) session.getAttribute(AVATAR_SESSIONATTRIBUTE)).toJSON());
			// 여기까지
			return (JexDataCMO) session.getAttribute(AVATAR_SESSIONATTRIBUTE);
		} else {
			throw new JexWebBIZException(AVATAR_SESSIONDISCONNECT_MESSAGE, AVATAR_SESSIONDISCONNECT_MESSAGE);
		}
//		return null;
	}

	public void removeSessionUser(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession(true);
		session.removeAttribute(AVATAR_SESSIONATTRIBUTE);
	}
}
