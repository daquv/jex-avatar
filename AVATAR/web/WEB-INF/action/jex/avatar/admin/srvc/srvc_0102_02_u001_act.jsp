<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="jex.util.StringUtil"%>

<%@page import="jex.util.DomainUtil"%>
<%@page import="jex.log.JexLogFactory"%>
<%@page import="jex.log.JexLogger"%>
<%@page import="jex.data.JexData"%>
<%@page import="jex.data.annotation.JexDataInfo"%>
<%@page import="jex.enums.JexDataType"%>
<%@page import="jex.data.JexDataList"%>
<%@page import="jex.web.util.WebCommonUtil"%>
<%@page import="jex.resource.cci.JexConnection"%>
<%@page import="jex.web.exception.JexWebBIZException"%>
<%@page import="jex.resource.cci.JexConnectionManager"%>

<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 질의관리 수정
         * @File Name    : srvc_0102_02_u001_act.jsp
         * @File path    : admin.srvc
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200309112208
         * </pre>
         *
         * ============================================================
         * 참조
         * ============================================================
         * 본 Action을 사용하는 View에서는 해당 도메인을 import하고.
         * 응답 도메인에 대한 객체를 아래와 같이 생성하여야 합니다.
         *
         **/

        WebCommonUtil   util    = WebCommonUtil.getInstace(request, response);

        @JexDataInfo(id="srvc_0102_02_u001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();
		String RSLT_CD = "0000";
		//1. 같으면 -> 업데이트
		//1. 같지 않으면 -> 갯수 확인 -> 0일 때 업데이트
		//1. 같지 않고 갯수가 0보다 크면 끝 아니면 업데이트
		// IDO Connection
		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		IDODynamic dynamic_0 = new IDODynamic();
		JexData idoIn0 = util.createIDOData("QUES_API_INFM_R004");
		idoIn0.put("QUES_CTT", input.getString("QUES_CTT"));
		JexData idoOut0 = idoCon.execute(idoIn0);
		// 도메인 에러 검증
		if (DomainUtil.isError(idoOut0)) {
			if (util.getLogger().isDebug())
			{
				util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut0));
				util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut0));
			}
			throw new JexWebBIZException(idoOut0);
		}
		
		if(!input.getString("QUES_CTT").equals(input.getString("QUES_CTT_BASE")) && Integer.parseInt(StringUtil.null2void(idoOut0.getString("CNT"), "0"))>0){
			RSLT_CD = "8888";
		}
		else{
			try{
				idoCon.beginTransaction();
				JexData idoIn1 = util.createIDOData("QUES_INFM_U001");
				idoIn1.put("QUES_CTT", input.getString("QUES_CTT"));
				idoIn1.put("INTE_CD", input.getString("INTE_CD"));
				idoIn1.put("CTGR_CD", input.getString("CTGR_CD"));
				idoIn1.put("CORR_ID", "SYSTEM");
				dynamic_0.addNotBlankParameter(input.getString("QUES_CTT_BASE"), "\n AND TRIM(QUES_CTT) = ?");
				idoIn1.put("DYNAMIC_0", dynamic_0);
				JexData idoOut1 =  idoCon.execute(idoIn1);
				
				
				// 도메인 에러 검증
				if (DomainUtil.isError(idoOut1)) {
					if (util.getLogger().isDebug())
					{
						util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
						util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
					}
					throw new JexWebBIZException(idoOut1);
				}
				idoCon.commit();
			} catch (Exception e){
				e.printStackTrace();
				RSLT_CD = "9999";
				idoCon.rollback();
			} finally{
				idoCon.endTransaction();
			}
		}
		result.put("RSLT_CD", RSLT_CD);

        util.setResult(result, "default");

%>