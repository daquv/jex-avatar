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
<%@page import="jex.data.impl.JexDataRecordList"%>
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 인텐트관리 수정
         * @File Name    : srvc_0103_02_u001_act.jsp
         * @File path    : admin.srvc
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200701144830
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

        @JexDataInfo(id="srvc_0103_02_u001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        IDODynamic dynamic_0 = new IDODynamic();
            
		JexDataList<JexData> inputArr = new JexDataRecordList();		
        try{
        	idoCon.beginTransaction();
        	JexDataList<JexData> inputRecInsert = input.getList("INSERT_REC");
        	
        	JexData idoJexData = util.createIDOData("QUES_API_DTLS_U001");
        	//JexData idoIn1 = util.createIDOData("SHOW_CUST_PTCL_C002");
        	for(JexData jexData : inputRecInsert){
        		JexData idoIn1 = idoJexData.createNewData();
        		idoIn1.putAll(jexData);
        		//idoIn1.put("MPPG_VRBS", input.getString("MPPG_VRBS"));
        		inputArr.add(idoIn1);
        	}
        	JexDataList<JexData> idoOut1 = idoCon.executeBatch(inputArr);
        	
             // 도메인 에러 검증
             if (DomainUtil.isError(idoOut1)) {
                 if (util.getLogger().isDebug())
                 {
                     util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                     util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
                    // result.put("RSLT_CD", "9999");
                 }
                 throw new JexWebBIZException(idoOut1);
             }
        	 result.put("RSLT_CD", "0000");
        	 idoCon.commit();
        	 idoCon.endTransaction();
         }
        catch(Exception e){
       		idoCon.rollback();
        	idoCon.endTransaction();
        	if (util.getLogger().isDebug()) util.getLogger().debug("Error Code   ::"+e.getMessage());
            result.put("RSLT_CD", "9999");
            util.setResult(result, "E");
        } 

        util.setResult(result, "default");

%>