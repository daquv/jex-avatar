<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="jex.util.StringUtil"%>
<%@page contentType="text/html;charset=UTF-8" %>

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
         * @File Title   : 고객별결과조회 목록
         * @File Name    : sstm_0201_01_r001_act.jsp
         * @File path    : admin.sstm
         * @author       : kth91 (  )
         * @Description  : 고객별결과조회 목록
         * @Register Date: 20200410154957
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

        @JexDataInfo(id="sstm_0201_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
        
    
        IDODynamic dynamic_0 = new IDODynamic();
        
		// 고객명
    	if("CUST".equals(StringUtil.null2void(input.getString("INQ_TRCN")))){
			dynamic_0.addNotBlankParameter(input.getString("INQ_TRCN_CTT"), "\n AND CUST.CUST_NM LIKE '%'||?||'%' ");
		}
		// 핸드폰번호
		else if("PHONE".equals(StringUtil.null2void(input.getString("INQ_TRCN")))){
			dynamic_0.addNotBlankParameter(input.getString("INQ_TRCN_CTT"), "\n AND decrypt(CUST.CLPH_NO) LIKE '%'||?||'%' ");
		} else {
			dynamic_0.addNotBlankParameter(input.getString("INQ_TRCN_CTT"), "\n AND ( CUST.CUST_NM LIKE '%'||?||'%' ");
			dynamic_0.addNotBlankParameter(input.getString("INQ_TRCN_CTT"), "\n OR decrypt(CUST.CLPH_NO) LIKE '%'||?||'%' ) ");
		}
		//계좌
		if(StringUtil.null2void(input.getString("NEW_BR_NO")).equals("0")){
			dynamic_0.addSQL("\n AND ACCT.GB = 'ACCT'");
			if(StringUtil.null2void(input.getString("STTS")).equals("0000")){
				dynamic_0.addSQL("\n AND COALESCE(ACCT.ACCT_FAIL_NCNT,0)=0");
			}else if(StringUtil.null2void(input.getString("STTS")).equals("9999")){
				dynamic_0.addSQL("\n AND COALESCE(ACCT.ACCT_FAIL_NCNT,0)>0 ");
			}
		}
		//카드
		else if(StringUtil.null2void(input.getString("NEW_BR_NO")).equals("1")){
			dynamic_0.addSQL("\n AND CARD.GB = 'CARD'");
			if(StringUtil.null2void(input.getString("STTS")).equals("0000")){
				dynamic_0.addSQL("\n AND COALESCE(CARD.CARD_APV_FAIL_NCNT,0)=0 ");
			}else if(StringUtil.null2void(input.getString("STTS")).equals("9999")){
				dynamic_0.addSQL("\n AND (COALESCE(CARD.CARD_APV_FAIL_NCNT,0)>0) ");
			}
		}
		//카드매출
		else if(StringUtil.null2void(input.getString("NEW_BR_NO")).equals("2")){
			dynamic_0.addSQL("\n AND EVDC.GB = 'EVDC'");
			dynamic_0.addSQL("\n AND COALESCE(EVDC.RCV_STTS,0)<>0 ");
			if(StringUtil.null2void(input.getString("STTS")).equals("0000")){
				dynamic_0.addSQL("\n AND COALESCE(EVDC.RCV_STTS,0)=1 ");
			}else if(StringUtil.null2void(input.getString("STTS")).equals("9999")){
				dynamic_0.addSQL("\n AND COALESCE(EVDC.RCV_STTS,0)=2 ");
			}
			
		}
		//증빙
		else if(StringUtil.null2void(input.getString("NEW_BR_NO")).equals("3")){
			dynamic_0.addSQL("\n AND EVDC.GB = 'EVDC'");
			dynamic_0.addSQL("\n AND (COALESCE(EVDC.ELEC_TXBL_STTS,0)<>0 OR COALESCE(EVDC.RCPT_STTS,0)<>0) ");
			if(StringUtil.null2void(input.getString("STTS")).equals("0000")){
				dynamic_0.addSQL("\n AND (COALESCE(EVDC.ELEC_TXBL_STTS,0)=1 OR COALESCE(EVDC.RCPT_STTS,0)=1) ");
			}else if(StringUtil.null2void(input.getString("STTS")).equals("9999")){
				dynamic_0.addSQL("\n AND (COALESCE(EVDC.ELEC_TXBL_STTS,0)=2 OR COALESCE(EVDC.RCPT_STTS,0)=2) ");
			}
		}
		
		/*조회상태*/
		if(StringUtil.null2void(input.getString("STTS")).equals("0000")){
			dynamic_0.addSQL("\n AND COALESCE(ACCT.ACCT_FAIL_NCNT,0)=0 ");
			dynamic_0.addSQL("\n AND COALESCE(CARD.CARD_APV_FAIL_NCNT,0)=0 ");
			dynamic_0.addSQL("\n AND (COALESCE(EVDC.RCV_STTS,0)<>2) ");
			dynamic_0.addSQL("\n AND (COALESCE(EVDC.ELEC_TXBL_STTS,0)<>2) ");
			dynamic_0.addSQL("\n AND (COALESCE(EVDC.RCPT_STTS,0)<>2) ");
		}else if(StringUtil.null2void(input.getString("STTS")).equals("9999")){
			dynamic_0.addSQL("\n AND ( COALESCE(ACCT.ACCT_FAIL_NCNT,0)>0" 
					   +"\n OR COALESCE(CARD.CARD_APV_FAIL_NCNT,0)>0"
					   +"\n OR COALESCE(EVDC.RCV_STTS,0)=2 OR COALESCE(EVDC.ELEC_TXBL_STTS,0)=2 OR COALESCE(EVDC.RCPT_STTS,0)=2 ) ");
		}
		
		dynamic_0.addSQL("\n ORDER BY CUST.REG_DTM DESC ");     	
		
        JexData idoIn1 = util.createIDOData("CUST_LDGR_R016");
     	
      	//Pagination
     	if(!"".equals(StringUtil.null2void(input.getString("PAGE_NO")))){
      	    int page_no = Integer.parseInt(input.getString("PAGE_NO"));
       		int page_size = Integer.parseInt(input.getString("PAGE_SIZE"));
       		DomainUtil.setIDOPageInfo(idoIn1, page_no, page_size, false);
      	}
    
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
        result.put("CNT", String.valueOf(DomainUtil.getMaxResultCount(idoOut1)));
        result.put("ERR_CD", "0000");
        

        util.setResult(result, "default");

%>