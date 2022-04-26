<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.JexDataRecordList"%>

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
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page import="com.avatar.session.SessionManager"%>


<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 거래처조회
         * @File Name    : ques_0010_01_r001_act.jsp
         * @File path    : ques
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200210154131
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

        @JexDataInfo(id="ques_0010_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

     // IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        IDODynamic dynamic_0 = new IDODynamic();
        // Get Session
        JexDataCMO userSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
        
      	//GET BZAQ INFO
        //거래처 데이터 등록여부
      	JexData idoIn4 = util.createIDOData("BZAQ_INFM_R003");
    
        idoIn4.putAll(input);
        idoIn4.put("USE_INTT_ID", USE_INTT_ID);
        
        JexDataRecordList<JexData> idoOut4 = (JexDataRecordList<JexData>) idoCon.executeList(idoIn4);
        // 도메인 에러 검증
        if (DomainUtil.isError(idoOut4)) {
            if (util.getLogger().isDebug())
            {
                util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut4));
                util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut4));
            }
            throw new JexWebBIZException(idoOut4);
        }
        result.put("REC2", idoOut4);
        
         if(!idoOut4.get(0).getString("TOTL_CNT").equals("0")){
        	dynamic_0.addNotBlankParameter(USE_INTT_ID, "\n AND USE_INTT_ID = ?");
        	dynamic_0.addNotBlankParameter( input.getString("BZAQ_NM"), "\n AND BZAQ_NM like '%'||?||'%'");
            dynamic_0.addSQL("\n ORDER BY BZAQ_NM LIMIT 1");
            JexData idoIn1 = util.createIDOData("BZAQ_INFM_R001");
        
            idoIn1.putAll(input);
            idoIn1.put("DYNAMIC_0", dynamic_0);
        
            JexDataRecordList<JexData> idoOut1 = (JexDataRecordList<JexData>)idoCon.executeList(idoIn1);
        
            // 도메인 에러 검증
            if (DomainUtil.isError(idoOut1)) {
                if (util.getLogger().isDebug())
                {
                    util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                    util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
                }
                throw new JexWebBIZException(idoOut1);
            }
        
            result.put("REC", idoOut1);
            if(idoOut1.size()>0){
            String biz_no = idoOut1.get(0).getString("BIZ_NO");
            if(!"".equals(StringUtil.null2void(biz_no))){
            	JexData idoIn2 = util.createIDOData("ELEC_TXBL_PTCL_R008");
            	System.out.println(idoOut1.getAttribute("BIZ_NO"));
                idoIn2.put("SELR_CORP_NO", biz_no);
                idoIn2.put("USE_INTT_ID", USE_INTT_ID);
            
                JexDataList<JexData> idoOut2 = (JexDataList<JexData>) idoCon.executeList(idoIn2);
            
                // 도메인 에러 검증
                if (DomainUtil.isError(idoOut2)) {
                    if (util.getLogger().isDebug())
                    {
                        util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
                        util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
                    }
                    throw new JexWebBIZException(idoOut2);
                }
                result.put("SEL_REC", idoOut2);

                JexData idoIn3 = util.createIDOData("ELEC_TXBL_PTCL_R007");
            
                idoIn3.putAll(input);
                idoIn3.put("BUYR_CORP_NO", biz_no);
                idoIn3.put("USE_INTT_ID", USE_INTT_ID);
                JexDataList<JexData> idoOut3 = (JexDataList<JexData>) idoCon.executeList(idoIn3);
            
                // 도메인 에러 검증
                if (DomainUtil.isError(idoOut3)) {
                    if (util.getLogger().isDebug())
                    {
                        util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut3));
                        util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut3));
                    }
                    throw new JexWebBIZException(idoOut3);
                }
            
                result.put("BUY_REC", idoOut3);
            	} 
            }
            }
            
        	
        

        util.setResult(result, "default");

%>