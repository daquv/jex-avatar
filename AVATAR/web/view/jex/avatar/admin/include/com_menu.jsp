<%@page import="jex.util.StringUtil"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="com.avatar.session.AdminSessionManager"%>

<%@page import="jex.data.impl.cmo.JexDataCMO"%>

<%
	JexDataCMO userSession = (JexDataCMO)AdminSessionManager.getSession(request, response);
	
	String _USERNM = "";
	String _MEMU = "";
	if(userSession != null && userSession.getString("USER_NM") != null){
	    _USERNM = userSession.getString("USER_NM");
	    
	    if("AVATAR_CSTM".equals(userSession.getString("CNTS_IDNT_ID"))){
	        _MEMU = "avatar_cstm";
	    } else if("AVATAR_SRVC".equals(userSession.getString("CNTS_IDNT_ID"))){
	        _MEMU = "avatar_srvc";
	    } else if("AVATAR_SSTM".equals(userSession.getString("CNTS_IDNT_ID"))){
	        _MEMU = "avatar_sstm";
	    } else if("AVATAR_STTC".equals(userSession.getString("CNTS_IDNT_ID"))){
	        _MEMU = "avatar_sttc";
	    } else if("AVATAR_SRVC2".equals(userSession.getString("CNTS_IDNT_ID"))){
	        _MEMU = "avatar_srvc2";
	    } else if("AVATAR_PLFM".equals(userSession.getString("CNTS_IDNT_ID"))){
	        _MEMU = "avatar_plfm";
	    } else if("AVATAR_CLDC".equals(userSession.getString("CNTS_IDNT_ID"))){
	        _MEMU = "avatar_cldc";
	    } else if("AVATAR_BLBD".equals(userSession.getString("CNTS_IDNT_ID"))){
	        _MEMU = "avatar_cstm";
	    } else if("AVATAR_HMPG".equals(userSession.getString("CNTS_IDNT_ID"))){
	        _MEMU = "avatar_hmpg";
	    }
	}

%>

<div class="lnb_box">
    <div class="lnb_top">
        <div class="user_view">
            <div class="user_r_side">
                <p class="icon_user"><strong><%=_USERNM%></strong> 님</p>
            </div>
        </div>
    </div>
    <div class="com_group_wrap">
        <div class="com_list">
            <div class="com_list_box">
                <div class="com_item" id="leftMenu"  data-SERP_MENU_ID="avatar_${param.MENU}">
                </div>
            </div>
        </div>
    </div>
</div>