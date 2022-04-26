package com.avatar.batch.subBatch;

import com.avatar.api.mgnt.KakaoApiMgnt;
import com.avatar.api.mgnt.ZeropayApiMgnt;
import com.avatar.batch.comm.BatchServiceBiz;
import com.avatar.batch.vo.BatchExecVO;
import com.avatar.comm.BizLogUtil;
import com.avatar.comm.SvcDateUtil;

import jex.JexContext;
import jex.data.JexData;
import jex.data.JexDataList;
import jex.data.impl.JexDataRecordList;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.exception.JexTransactionRollbackException;
import jex.json.JSONArray;
import jex.json.JSONObject;
import jex.json.parser.JSONParser;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.util.DomainUtil;
import jex.util.StringUtil;
import jex.util.biz.JexCommonUtil;

/**
 * 제로페이 가맹점조회 서브
 *
 * @author won
 *
 */
public class ZeroMestCollectorSub extends BatchServiceBiz {

	private static final String job_id = "GET_ZERO_MEST";
	BatchExecVO batchvo = new BatchExecVO();

	@Override
	public JexData execute(JexData input) throws JexException, JexBIZException, Throwable {

		BizLogUtil.debug(this, "execute", "Input :: " + input.toJSONString());

		String use_intt_id = input.getString("USE_INTT_ID");

		batchvo.setJob_id(job_id);
		batchvo.setUse_intt_id(use_intt_id);
		
		// 제로페이 연결 고객
		JexData link_data = getCustLinkData(use_intt_id);
		
		// 연결 cust_ci
		String cust_ci = link_data.getString("USER_ID");
		
		// 제로페이와 연결되어 있는 경우
		if(!cust_ci.equals("")) {
			JexDataList<JexData> insertMestData = new JexDataRecordList<JexData>();
			JexDataList<JexData> insertPointData = new JexDataRecordList<JexData>();
			
			// 가맹점정보 조회
	     	JSONObject reqDat008 = ZeropayApiMgnt.data_api_008(cust_ci, "");

	     	// 가맹점정보 성공
	    	if((reqDat008.getString("RSLT_CD")).equals("0000")){
	    		JexConnection idoCon = JexConnectionManager.createIDOConnection();
    			// 트랜젝션 시작
            	idoCon.beginTransaction();
            	
            	// 가맹점정보 전체 해지로 상태값 전체 변경
            	updateZeroMestInfm(idoCon, use_intt_id);
         	
         		JSONArray mestArr = JSONObject.fromArray(reqDat008.get("REC").toString());
         		
         		if(mestArr.size() == 0) {
         			// 가맹점 정보가 없을 경우 연결정보 해지
             		deleteZeroLinkInfm(use_intt_id);
         		}else {
         			// 가맹점 리스트가 있을 경우
        			for(int i = 0; i< mestArr.size(); i++){
        			
        			    JSONObject mestObj = (JSONObject)mestArr.get(i);
        			    JSONArray qrArr = (JSONArray)mestObj.get("QR_LIST");
        			    String qr_cd = "";
        			    
        			    // QR코드가 있을 경우
        			    if(qrArr.size() > 0){
        			    	JSONObject qrObj = (JSONObject)qrArr.get(0);
        			    	qr_cd = StringUtil.null2void(qrObj.getString("QR_CD"));						// QR 코드값
        			    }
        			    
        			    mestObj.put("QR_CD", qr_cd);
        			    
        			    insertMestData.add(insertZeroMestInfm(use_intt_id, mestObj));
        		
        			    String aflt_management_no = StringUtil.null2void((String)mestObj.get("AFLT_MANAGEMENT_NO"));	// 가맹점관리번호
        			    String biz_no = StringUtil.null2void((String)mestObj.get("BIZ_NO")); 						 	// 가맹점사업자번호
        			    String ser_biz_no = StringUtil.null2void((String)mestObj.get("SER_BIZ_NO")); 		
        			    
        			    // 가맹점의 상품권 리스트 삭제
        			    deleteZeroMestPintInfm(idoCon, use_intt_id, aflt_management_no, biz_no, ser_biz_no);

        			    JSONObject pot = null;
        			    // 가맹점 상품권 리스트
        			    for (Object potData : mestObj.getJSONArray("POINT_REC")) {
        			    	pot = (JSONObject) potData;			    	
            			    insertPointData.add(insertZeroMestPintInfm(pot, use_intt_id, aflt_management_no, biz_no, ser_biz_no));        			    
    					}
        			}
        			
        			JexDataList<JexData> idoOutMestBatch = idoCon.executeBatch(insertMestData);

        			if (DomainUtil.isError(idoOutMestBatch)) {
        				insertPointData.close();
        				throw new JexTransactionRollbackException(idoOutMestBatch);
        			}
        			insertMestData.close();

        			JexDataList<JexData> idoOutPointBatch = idoCon.executeBatch(insertPointData);

        			if (DomainUtil.isError(idoOutPointBatch)) {
        				idoOutPointBatch.close();
        				throw new JexTransactionRollbackException(idoOutPointBatch);
        			} 
        			idoOutPointBatch.close();
        			
        			idoCon.commit();
        			idoCon.endTransaction();
         		}
         	}else if((reqDat008.getString("RSLT_CD")).equals("B001")) {
         		// 등록된 회원이 아닐경우 제로페이 연결정보 해지
         		deleteZeroLinkInfm(use_intt_id);
         	}
        }
		
		batchvo.setJob_end_tm(SvcDateUtil.getShortTimeString());
		batchvo.EndBatch();
		batchExecLogInsert(batchvo);

		return null;
	}
	
	/**
	 * <pre>
	 * 제로페이 연결정보 해지
	 * </pre>
	 *
	 * @param use_intt_id
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void deleteZeroLinkInfm(String use_intt_id) throws JexException, JexBIZException {
		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		// 제로페이 가맹점 상태값 변경(전체 해지)
		JexData idoIn1 = util.createIDOData("CUST_LINK_SYS_INFM_D001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("APP_ID", "ZEROPAY"); 
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			BizLogUtil.error(this, "Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
			BizLogUtil.error(this, "Error Message::" + DomainUtil.getErrorMessage(idoOut1));
			throw new JexBIZException(idoOut1);
	    }
	}
	
	/**
	 * <pre>
	 * 제로페이 가맹점 상태값 변경
	 * </pre>
	 *
	 * @param idoCon
	 * @param use_intt_id
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void updateZeroMestInfm(JexConnection idoCon, String use_intt_id) throws JexException, JexBIZException {
		
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		// 제로페이 가맹점 상태값 변경(전체 해지)
		JexData idoIn1 = util.createIDOData("ZERO_MEST_INFM_U001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1))
			throw new JexTransactionRollbackException(idoOut1);

	}

	/**
	 * <pre>
	 * 제로페이 가맹점정보 등록/수정
	 * </pre>
	 * @param use_intt_id
	 * @param mest_info
	 * @return 
	 * @throws JexException
	 * @throws JexBIZException
	 * @throws Exception
	 */
	private JexData insertZeroMestInfm(String use_intt_id, JSONObject mest_info)
			throws JexException, JexBIZException, Exception {
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		String aflt_management_no = StringUtil.null2void((String)mest_info.get("AFLT_MANAGEMENT_NO"));	// 가맹점관리번호
	    String biz_no = StringUtil.null2void((String)mest_info.get("BIZ_NO")); 						 	// 가맹점사업자번호
	    String ser_biz_no = StringUtil.null2void((String)mest_info.get("SER_BIZ_NO")); 					// 가맹점종사업번호
	    String aflt_nm = StringUtil.null2void((String)mest_info.get("AFLT_NM"));						// 가맹점명
	    String aflt_owner_nm = StringUtil.null2void((String)mest_info.get("AFLT_OWNER_NM"));			// 가맹점대표자명
	    String aflt_state_cd = "";																		// 가맹점상태코드
	    String road_addr = StringUtil.null2void((String)mest_info.get("ROAD_ADDR"));					// 주소
	    String shop_tel_no = StringUtil.null2void((String)mest_info.get("SHOP_TEL_NO"));				// 전화번호
	    String market_nm = StringUtil.null2void((String)mest_info.get("MARKET_NM"));					// 시장명
	    String tpbs	= StringUtil.null2void((String)mest_info.get("TPBS"));								// 업종
		String bsst	= StringUtil.null2void((String)mest_info.get("BSST"));  							// 업태		
		String small_fee = StringUtil.null2void((String)mest_info.get("SMALL_FEE"),"0");				// 수수료율
		String biz_type_cd = StringUtil.null2void((String)mest_info.get("BIZ_TYPE_CD"));				// 업종코드
		String qr_cd = StringUtil.null2void((String)mest_info.get("QR_CD"));							// QR 코드값
		
		String latd  = "";	// 위도(y)
       	String lotd  = "";	// 경도(x)
       	
		// 주소가 있을 경우 위도, 경도 가져오기
		if(!road_addr.equals("")){
			String jsonString =  KakaoApiMgnt.getCoordination(road_addr);
	       	JSONParser parser = new JSONParser();
	       
	    	JSONObject json = ( JSONObject ) new JSONParser().parser(jsonString);
			JSONArray jsonDocuments = (JSONArray) json.get( "documents" );
	    	if( jsonDocuments.size() != 0 ) {
		  		JSONObject j = (JSONObject) jsonDocuments.get(0);
		  		latd = ( String ) j.get("y");
		  		lotd = ( String ) j.get("x");
			}
		}
		
		// 제로페이 가맹점정보 등록
		JexData idoIn1 = util.createIDOData("ZERO_MEST_INFM_C003");
		
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("AFLT_MANAGEMENT_NO", aflt_management_no);
		idoIn1.put("MEST_BIZ_NO", biz_no);
		idoIn1.put("SER_BIZ_NO", ser_biz_no);
		idoIn1.put("MEST_NM", aflt_nm);
		idoIn1.put("AFLT_OWNER_NM", aflt_owner_nm);
		idoIn1.put("AFLT_STATE_CD", aflt_state_cd);
		idoIn1.put("MEST_ADDR", road_addr);
		idoIn1.put("LATD", latd);
		idoIn1.put("LOTD", lotd);
		idoIn1.put("MEST_TEL_NO", shop_tel_no);
		idoIn1.put("MARKET_NM", market_nm);
		idoIn1.put("TPBS", tpbs);
		idoIn1.put("BSST", bsst);
		idoIn1.put("SMALL_FEE", small_fee);
		idoIn1.put("QR_CD", qr_cd);
		idoIn1.put("BIZ_TYPE_CD", biz_type_cd);

		return idoIn1;
	}
	
	/**
	 * <pre>
	 * 가맹점의 상품권 리스트 삭제
	 * </pre>
	 *
	 * @param idoCon
	 * 
	 * @param use_intt_id
	 * @param aflt_management_no
	 * @param biz_no
	 * @param ser_biz_no
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private void deleteZeroMestPintInfm(JexConnection idoCon, String use_intt_id,
			String aflt_management_no, String biz_no, String ser_biz_no) throws JexException, JexBIZException {
		
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		// 가맹점의 상품권 리스트 삭제
		JexData idoIn1 = util.createIDOData("ZERO_MEST_PINT_D001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("AFLT_MANAGEMENT_NO", aflt_management_no);
		idoIn1.put("MEST_BIZ_NO", biz_no);
		idoIn1.put("SER_BIZ_NO", ser_biz_no);
			
		JexData idoOut1 = idoCon.execute(idoIn1);
		  
		if (DomainUtil.isError(idoOut1))
			throw new JexTransactionRollbackException(idoOut1);
	}
	
	/**
	 * <pre>
	 * 가맹점의 상품권 등록
	 * </pre>
	 *
	 * @param point_info
	 * @param use_intt_id
	 * @param aflt_management_no
	 * @param biz_no
	 * @param ser_biz_no
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JexData insertZeroMestPintInfm(JSONObject point_info, String use_intt_id
			, String aflt_management_no, String biz_no, String ser_biz_no)
			throws JexException, JexBIZException {
		
		JexCommonUtil util = JexContext.getContext().getCommonUtil();
		
		String point_disc_cd = StringUtil.null2void((String)point_info.get("POINT_DISC_CD"));			// 상품권분류코드
	    String point_nm = StringUtil.null2void((String)point_info.get("POINT_NM")); 		   			// 상품권명
	    String point_img_url = StringUtil.null2void((String)point_info.get("POINT_IMG_URL")); 			// 상품권이미지URL
	    String point_icon_img_url = StringUtil.null2void((String)point_info.get("POINT_ICON_IMG_URL")); // 상품권아이콘이미지URL
	    
		// 가맹점의 상품권 등록
		JexData idoIn1 = util.createIDOData("ZERO_MEST_PINT_C001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
	    idoIn1.put("AFLT_MANAGEMENT_NO", aflt_management_no);
	    idoIn1.put("MEST_BIZ_NO", biz_no);
	    idoIn1.put("SER_BIZ_NO", ser_biz_no);
	    idoIn1.put("POINT_DISC_CD", point_disc_cd);
	    idoIn1.put("POINT_NM", point_nm);
	    idoIn1.put("POINT_IMG_URL", point_img_url);
	    idoIn1.put("POINT_ICON_IMG_URL", point_icon_img_url);
			
	    return idoIn1;
	}
	
	/**
	 * <pre>
	 * 제로페이 연결여부 조회
	 * </pre>
	 *
	 * @param use_intt_id
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JexData getCustLinkData(String use_intt_id) throws JexException, JexBIZException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn1 = util.createIDOData("CUST_LINK_SYS_INFM_R001");
		idoIn1.put("USE_INTT_ID", use_intt_id);
		idoIn1.put("APP_ID", "ZEROPAY"); 
		JexData idoOut1 = idoCon.execute(idoIn1);

		if (DomainUtil.isError(idoOut1)) {
			BizLogUtil.error(this, "Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
			BizLogUtil.error(this, "Error Message::" + DomainUtil.getErrorMessage(idoOut1));
			throw new JexBIZException(idoOut1);
		}

		return idoOut1;
	}
}
