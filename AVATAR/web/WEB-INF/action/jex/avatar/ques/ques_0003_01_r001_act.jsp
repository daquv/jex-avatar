<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="com.avatar.session.SessionManager"%>
<%@page import="jex.data.impl.cmo.JexDataCMO"%>
<%@page contentType="text/html;charset=UTF-8" %>

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
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 입/출금내역조회
         * @File Name    : ques_0003_01_r001_act.jsp
         * @File path    : ques
         * @author       : byeolkim89 (  )
         * @Description  : 입/출금내역조회
         * @Register Date: 20200130101623
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

         @JexDataInfo(id="ques_0003_01_r001", type=JexDataType.WSVC)
         JexData input = util.getInputDomain();
         JexData result = util.createResultDomain();

 // IDO Connection
         JexConnection idoCon = JexConnectionManager.createIDOConnection();        
         IDODynamic dynamic_0 = new IDODynamic();
         IDODynamic dynamic_1 = new IDODynamic();

         // Get Session
         JexDataCMO userSession = SessionManager.getSession(request, response);
         String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
       
         //GET ACCOUNT INFO.
         JexData idoIn2 = util.createIDOData("ACCT_INFM_R014");
     
         idoIn2.putAll(input);
         dynamic_1.addNotBlankParameter(userSession.getString("USE_INTT_ID"), "\n AND USE_INTT_ID = ?");
         dynamic_1.addSQL("\n ORDER BY BANK_CD");
         
         idoIn2.put("DYNAMIC_0", dynamic_1);
         JexDataRecordList<JexData> idoOut2 = (JexDataRecordList<JexData>) idoCon.executeList(idoIn2);
     
         // 도메인 에러 검증
         if (DomainUtil.isError(idoOut2)) {
             if (util.getLogger().isDebug())
             {
                 util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
                 util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
             }
             throw new JexWebBIZException(idoOut2);
         }
         
         result.put("REC2", idoOut2);
         
		
        if(!(idoOut2.size()==0)){
			if(!"".equals(StringUtil.null2void(input.getString("STR_DT")))){
				if(!"".equals(StringUtil.null2void(input.getString("END_DT")))){
					dynamic_0.addNotBlankParameter(input.getString("STR_DT"), "\n AND TRNS_DT BETWEEN ? ");
					dynamic_0.addNotBlankParameter(input.getString("END_DT"), " AND ? ");
				} else{
					dynamic_0.addNotBlankParameter(input.getString("STR_DT"), "\n AND TRNS_DT LIKE ?||'%'");
				}
			}
			JexData idoIn1 = util.createIDOData("ACCT_TRNS_HSTR_R008");
			idoIn1.putAll(input);
			idoIn1.put("USE_INTT_ID", USE_INTT_ID);
			idoIn1.put("DYNAMIC_0", dynamic_0);
			JexDataList<JexData> idoOut1 = (JexDataList<JexData>) idoCon.executeList(idoIn1);
         
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
		}
        /*  if(input.getString("SRCH_WD").equals("전일"))
 			/* TO_CHAR(NOW()+'-1 DAY', 'YYYYMMDD') 
 			dynamic_0.addSQL("\n AND TRNS_DT LIKE TO_CHAR(NOW()+'-1 DAY', 'YYYYMMDD')||'%'");
 			//dynamic_0.addSQL("\n AND TRNS_DT LIKE (SELECT MAX(TRNS_DT) FROM ACCT_TRNS_HSTR WHERE TRNS_DT <= TO_CHAR(NOW()+'-1 DAY', 'YYYYMMDD')||'%')");
 		else if(input.getString("SRCH_WD").equals("전주")){
 			dynamic_0.addSQL("\n AND TRNS_DT BETWEEN TO_CHAR( TO_DATE(TO_CHAR(NOW(),'YYYYMMDD'),'YYYYMMDD') - (CAST(TO_CHAR(to_date(TO_CHAR(NOW(),'YYYYMMDD'),'YYYYMMDD'),'D')AS INTEGER)-2)-7, 'YYYYMMDD') AND TO_CHAR( TO_DATE(TO_CHAR(NOW(),'YYYYMMDD'),'YYYYMMDD') - (CAST(TO_CHAR(to_date(TO_CHAR(NOW(),'YYYYMMDD'),'YYYYMMDD'),'D')AS INTEGER)-8)-7, 'YYYYMMDD') ");
 		}
 		else if(input.getString("SRCH_WD").equals("금주")){
 			dynamic_0.addSQL("\n AND TRNS_DT BETWEEN TO_CHAR( TO_DATE(TO_CHAR(NOW(),'YYYYMMDD'),'YYYYMMDD') - (CAST(TO_CHAR(to_date(TO_CHAR(NOW(),'YYYYMMDD'),'YYYYMMDD'),'D')AS INTEGER)-2), 'YYYYMMDD') AND TO_CHAR( TO_DATE(TO_CHAR(NOW(),'YYYYMMDD'),'YYYYMMDD') - (CAST(TO_CHAR(to_date(TO_CHAR(NOW()'YYYYMMDD'),'YYYYMMDD'),'D')AS INTEGER)-8), 'YYYYMMDD') ");
 		}
 		else if(input.getString("SRCH_WD").equals("금월")){
 			dynamic_0.addSQL("\n AND TRNS_DT LIKE TO_CHAR(NOW(),'YYYYMM')||'%'");
 		}
		else if(input.getString("SRCH_WD").equals("전월")){
			dynamic_0.addSQL("\n AND TRNS_DT LIKE TO_CHAR(NOW()+'-1 MONTH','YYYYMM')||'%'");
 		} */
         

         util.setResult(result, "default");

%>