<%@page import="com.avatar.comm.SvcDateUtil"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.data.impl.ido.IDODynamic"%>
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
         * @File Title   : 어드민 로그인현황 조회
         * @File Name    : sttc_0201_01_r001_act.jsp
         * @File path    : admin.sttc
         * @author       : kth91 (  )
         * @Description  : 어드민 로그인현황 조회
         * @Register Date: 20200309152139
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

        @JexDataInfo(id="sttc_0201_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

	    // IDO Connection
  		JexConnection idoCon = JexConnectionManager.createIDOConnection();        
  		IDODynamic dynamic_0 = new IDODynamic();
  		IDODynamic dynamic_1 = new IDODynamic();
  		
  		String inq_dt_dv_cd = StringUtil.null2void(input.getString("INQ_DT_DV_CD"));
  		String inq_ym = StringUtil.null2void(input.getString("INQ_YM"));
  		// 일별 
		if("2".equals(inq_dt_dv_cd)){
		    dynamic_0.addNotBlankParameter(input.getString("INQ_STR_DT"), "\n AND LOGIN_DT = ? ");
		}
		// 기간별
		else if("1".equals(inq_dt_dv_cd)){
		    dynamic_0.addNotBlankParameter(input.getString("INQ_STR_DT"), "\n AND LOGIN_DT BETWEEN ? ");
		    dynamic_0.addNotBlankParameter(input.getString("INQ_END_DT"), "\t AND ? ");
		}
		// 월별
	    else if("0".equals(inq_dt_dv_cd)){
	    	
	        dynamic_0.addNotBlankParameter(inq_ym + "01", "\n AND LOGIN_DT BETWEEN ? ");
	        dynamic_0.addNotBlankParameter(inq_ym + SvcDateUtil.getInstance().getLastDay(inq_ym), "\t AND ? ");
	    }
  		
		if(!"".equals(StringUtil.null2void(input.getString("INQ_TRCN")))){
  			if("CUST".equals(StringUtil.null2void(input.getString("INQ_TRCN")))){		// 고객명
  				dynamic_0.addNotBlankParameter(input.getString("INQ_TRCN_CTT"), "\n AND CUST_NM LIKE '%'||?||'%' ");
  			} else if("PHONE".equals(StringUtil.null2void(input.getString("INQ_TRCN")))){		// 핸드폰번호 
  				dynamic_0.addNotBlankParameter(input.getString("INQ_TRCN_CTT"), "\n AND DECRYPT(CLPH_NO) LIKE '%'||?||'%' ");
  			}
  		} else {
  			dynamic_0.addNotBlankParameter(input.getString("INQ_TRCN_CTT"), "\n AND (CUST_NM LIKE '%'||?||'%' ");
  			dynamic_0.addNotBlankParameter(input.getString("INQ_TRCN_CTT"), "OR DECRYPT(CLPH_NO) LIKE '%'||?||'%')");
  		}
  		
  		//로그인횟수
  		if("true".equals(input.getString("DUP_YN"))){
  			if(!"".equals(StringUtil.null2void(input.getString("LOGIN_CNT")))){
  	  			if("UP".equals(StringUtil.null2void(input.getString("LOGIN_CD")))){
  	  				dynamic_1.addSQL("\n AND LOGIN_CNT_DUP >= "+input.getString("LOGIN_CNT")+" ");
  	  			} else if("DOWN".equals(StringUtil.null2void(input.getString("LOGIN_CD")))){
  	  				dynamic_1.addSQL("\n AND LOGIN_CNT_DUP <= "+input.getString("LOGIN_CNT")+" ");
  	  			}
  	  		}
  		} else {
  			if(!"".equals(StringUtil.null2void(input.getString("LOGIN_CNT")))){
  	  			if("UP".equals(StringUtil.null2void(input.getString("LOGIN_CD")))){
  	  				dynamic_1.addSQL("\n AND LOGIN_CNT >= "+input.getString("LOGIN_CNT")+" ");
  	  			} else if("DOWN".equals(StringUtil.null2void(input.getString("LOGIN_CD")))){
  	  				dynamic_1.addSQL("\n AND LOGIN_CNT <= "+input.getString("LOGIN_CNT")+" ");
  	  			}
  	  		}
  		}
  			
  		//상태
  		if(!StringUtil.isBlank(input.getString("STTS"))){
  			String stts[] = input.getString("STTS").split(",");
  			dynamic_0.addSQL("\n AND STTS IN (");
  			
  			for(int i=0 ; i<stts.length; i++){
  				String sttsSql = ",?";
  				if(i==0){
  					sttsSql = "?";
  				}
  				dynamic_0.addNotBlankParameter(stts[i], sttsSql);
  				
  			}
  			dynamic_0.addSQL(")");
  		}
  		if("true".equals(input.getString("DUP_YN"))){
  			dynamic_1.addSQL("\n ORDER BY LOGIN_CNT_DUP DESC");
  		} else {
  			dynamic_1.addSQL("\n ORDER BY LOGIN_CNT DESC");
  		}
     	//가입자 목록 조회
        JexData idoIn1 = util.createIDOData("CUST_LDGR_R013");
      	
        if(!"".equals(StringUtil.null2void(input.getString("PAGE_NO")))){
      	    int page_no = Integer.parseInt(input.getString("PAGE_NO"));
       		int page_size = Integer.parseInt(input.getString("PAGE_SIZE"));
       		DomainUtil.setIDOPageInfo(idoIn1, page_no, page_size, false);
      	}
        
        idoIn1.putAll(input);
      	idoIn1.put("DYNAMIC_0", dynamic_0);
      	idoIn1.put("DYNAMIC_1", dynamic_1);
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
        result.put("CNT", String.valueOf(DomainUtil.getMaxResultCount(idoOut1)));
        result.put("REC", idoOut1);
        //가입자 목록 조회 END
          
        //가입자 수 테이블 값 조회 START
//         JexData idoIn3 = util.createIDOData("CUST_LDGR_R006");
      
//           idoIn3.putAll(input);
//           idoIn3.put("DYNAMIC_0", dynamic_1);
      
//           JexData idoOut3 = idoCon.execute(idoIn3);
      
//           // 도메인 에러 검증
//           if (DomainUtil.isError(idoOut3)) {
//               if (util.getLogger().isDebug())
//               {
//                   util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut3));
//                   util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut3));
//               }
//               throw new JexWebBIZException(idoOut3);
//           }
      
//           result.put("TOTL_NCNT", idoOut3.getString("TOTL_NCNT"));
//           result.put("NORM_NCNT", idoOut3.getString("NORM_NCNT"));
//           result.put("SPNC_NCNT", idoOut3.getString("SPNC_NCNT"));
//           result.put("TRMN_NCNT", idoOut3.getString("TRMN_NCNT"));
        	//가입자 수 테이블 값 조회 END
          
          util.setResult(result, "default");
%>