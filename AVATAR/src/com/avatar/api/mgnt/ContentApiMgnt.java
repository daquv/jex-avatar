package com.avatar.api.mgnt;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.avatar.comm.BizLogUtil;
import com.avatar.comm.CommonErrorHandler;
import com.avatar.comm.ExternalConnectUtil;
import com.avatar.comm.QuestionUtil;
import com.avatar.comm.SvcDateUtil;

import jex.JexContext;
import jex.data.JexData;
import jex.data.JexDataList;
import jex.data.impl.ido.IDODynamic;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.json.JSONArray;
import jex.json.JSONObject;
import jex.json.parser.JSONParser;
import jex.log.JexLogFactory;
import jex.log.JexLogger;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.util.DomainUtil;
import jex.util.StringUtil;
import jex.util.biz.JexCommonUtil;
import jex.util.crypto.CryptoUtil;
import jex.util.date.DateTime;


/**
 *
 * 컨텐츠 제공사 API 관리
 *
 */
public class ContentApiMgnt {

	private static final JexLogger LOG = JexLogFactory.getLogger(ContentApiMgnt.class);
	private static ContentApiMgnt _instance = null;

	private ContentApiMgnt() {
		//앱정보, 질의 API정보를 매번 DB조회가 아닌 메모리로 관리할까?...
	}

	public static final ContentApiMgnt getInstance() {
		if(_instance == null) {
			_instance = new ContentApiMgnt();
		}
		return _instance;
	}

	/**
	 * API 토큰 가져오기
	 *  - API URL, 암호화키 등은 DB로 관리한다.
	 * @param use_intt_id
	 * @param app_id
	 * @param user_id
	 * @param user_pw
	 * @param biz_no
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	public JSONObject executeApiToken(String use_intt_id, String app_id, String user_id, String user_pwd, String biz_no) throws JexException, JexBIZException, Exception{

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		//----------------------------------------------
		//APP 정보 조회
		//----------------------------------------------
		JexData idoIn0 = util.createIDOData("APP_INFM_R001");
		idoIn0.put("APP_ID", app_id);
		JexData idoOut0 = idoCon.execute(idoIn0);
		if (DomainUtil.isError(idoOut0)) CommonErrorHandler.comHandler(idoOut0);

		CryptoUtil crypt = CryptoUtil.createInstance((idoOut0.getString("SVC_KEY")+"000000000000000000000000").substring(0,24));
		String service_url = idoOut0.getString("HOST") + "/gw/rest/token";

		user_pwd = crypt.encryptSEEDString(user_pwd.getBytes());

		JSONObject input = new JSONObject();
		input.put("USER_ID", user_id);
		input.put("USER_PWD", user_pwd);
		input.put("BIZ_NO", biz_no);

		//----------------------------------------------
		//경리나라 토큰가져오기
		//----------------------------------------------
		JSONObject output = callApi(service_url, input.toJSONString(), null);

		if("0000".equals(output.getString("RSLT_CD"))) {
			//고객연계시스템정보 등록/수정
			JexData idoIn1 = util.createIDOData("CUST_LINK_SYS_INFM_U001");
			idoIn1.put("USE_INTT_ID", use_intt_id);
			idoIn1.put("APP_ID", app_id);
			idoIn1.put("USER_ID", user_id);
			idoIn1.put("USER_PWD", ""); //비밀번호 저장안함.
			idoIn1.put("BIZ_NO", biz_no);
			idoIn1.put("TOKEN", output.getString("TOKEN"));
			JexData idoOut1 = idoCon.execute(idoIn1);
			if (DomainUtil.isError(idoOut1)) CommonErrorHandler.comHandler(idoOut1);

			//사업장 조회
			JexData idoIn = util.createIDOData("INTT_INFM_R001");
			idoIn.put("USE_INTT_ID", use_intt_id);
			JexData idoOut = idoCon.execute(idoIn);
			if (DomainUtil.isError(idoOut)) CommonErrorHandler.comHandler(idoOut);

			if(StringUtil.isBlank(idoOut.getString("BSNN_NM"))) {

				String latd  = "";	// 위도(y)
				String lotd  = "";	// 경도(x)

				String adrs = StringUtil.null2void(output.getString("ADRS"));

				// 주소가 있을 경우 위도, 경도 가져오기
				if(!adrs.equals("")){
					adrs = StringUtil.null2void(output.getString("ADRS"))+" "+StringUtil.null2void(output.getString("DTL_ADRS"));
					String jsonString =  KakaoApiMgnt.getCoordination(adrs);
					JSONParser parser = new JSONParser();

					JSONObject json = ( JSONObject ) new JSONParser().parser(jsonString);
					JSONArray jsonDocuments = (JSONArray) json.get( "documents" );
					if( jsonDocuments.size() != 0 ) {
						JSONObject j = (JSONObject) jsonDocuments.get(0);
						latd = ( String ) j.get("y");
						lotd = ( String ) j.get("x");
					}
				}

				//사업장정보 등록/수정
				JexData idoIn2 = util.createIDOData("INTT_INFM_C001");
				idoIn2.put("USE_INTT_ID", use_intt_id);
				idoIn2.put("BIZ_NO", output.getString("BIZ_NO"));
				idoIn2.put("BSNN_NM", output.getString("BSNN_NM"));
				idoIn2.put("RPPR_NM", output.getString("RPPR_NM"));
				idoIn2.put("BSST", output.getString("BSST"));
				idoIn2.put("TPBS", output.getString("TPBS"));
				idoIn2.put("ZPCD", output.getString("ZPCD"));
				idoIn2.put("ADRS", output.getString("ADRS"));
				idoIn2.put("DTL_ADRS", output.getString("DTL_ADRS"));
				idoIn2.put("LATD", latd);
				idoIn2.put("LOTD", lotd);
				idoIn2.put("RPRS_TLNO", output.getString("RPRS_TLNO"));
				JexData idoOut2 = idoCon.execute(idoIn2);
				if (DomainUtil.isError(idoOut1)) CommonErrorHandler.comHandler(idoOut2);
			}
		}

		return output;
	}

	/**
	 * API 연계기초정보조회
	 *  - API URL, 암호화키 등은 DB로 관리한다.
	 * @param app_id
	 * @param token
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	public JSONObject executeAppInfo(String app_id, String token) throws JexException, JexBIZException  {

		if(!app_id.contains("SERP")) {
			JSONObject result = new JSONObject();
			result.put("RSLT_CD", "9999");
			result.put("RSLT_MSG", "API연결정보가 없습니다.");
			return result;
		}

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		//----------------------------------------------
		//APP 정보 조회
		//----------------------------------------------
		JexData idoIn0 = util.createIDOData("APP_INFM_R001");
		idoIn0.put("APP_ID", app_id);
		JexData idoOut0 = idoCon.execute(idoIn0);
		if (DomainUtil.isError(idoOut0)) CommonErrorHandler.comHandler(idoOut0);

		String service_url = idoOut0.getString("HOST") + "/gw/rest/user/info";

		Map<String, String> header = new HashMap();
		header.put("Content-Type", "application/json");
		header.put("Authorization", token);

		//API 호출
		JSONObject output = callApi(service_url, "", header);
		return output;
	}

	/**
	 * API 아바타통합어드민 등록
	 *  - API URL, 암호화키 등은 DB로 관리한다.
	 * @param app_id
	 * @param token
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	public JSONObject executeAvatarJoin(String app_id, String token) throws JexException, JexBIZException  {

		if(!app_id.contains("SERP")) {
			JSONObject result = new JSONObject();
			result.put("RSLT_CD", "9999");
			result.put("RSLT_MSG", "API연결정보가 없습니다.");
			return result;
		}

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		//----------------------------------------------
		//APP 정보 조회
		//----------------------------------------------
		JexData idoIn0 = util.createIDOData("APP_INFM_R001");
		idoIn0.put("APP_ID", app_id);
		JexData idoOut0 = idoCon.execute(idoIn0);
		if (DomainUtil.isError(idoOut0)) CommonErrorHandler.comHandler(idoOut0);

		String service_url = idoOut0.getString("HOST") + "/gw/rest/avatar/join";

		Map<String, String> header = new HashMap();
		header.put("Content-Type", "application/json");
		header.put("Authorization", token);

		//API 호출
		JSONObject output = callApi(service_url, "", header);
		return output;
	}

	/**
	 * 경리나라 API 사용권한 조회
	 *   - 경리나라 스토어에서 아바타 구매하고 관리자인 경우만 API 조회 허용
	 * @param use_intt_id
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */

	public JSONObject authSERP(String use_intt_id) throws JexException, JexBIZException  {
		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JSONObject result = new JSONObject();
		result.put("RSLT_CD", "0000"); //경리나라 연결하지 않은 사용자는 정상으로 리턴

		String app_id = "SERP";

		//API 정보조회
		JexData idoIn0 = util.createIDOData("APP_INFM_R004");
		idoIn0.put("APP_ID", app_id);
		idoIn0.put("USE_INTT_ID", use_intt_id);
		JexData idoOut0 = idoCon.execute(idoIn0);
		if (DomainUtil.isError(idoOut0)) CommonErrorHandler.comHandler(idoOut0);
		if(DomainUtil.getResultCount(idoOut0) == 0) {
			return result;
		}

		String service_url = idoOut0.getString("HOST") + "/gw/rest/user/auth";

		Map<String, String> header = new HashMap();
		header.put("Content-Type", "application/json");
		header.put("Authorization", idoOut0.getString("TOKEN"));

		//API 정보조회
		JexData idoIn3 = util.createIDOData("CUST_LINK_SYS_INFM_R001");
		idoIn3.put("APP_ID", app_id);
		idoIn3.put("USE_INTT_ID", use_intt_id);
		JexData idoOut3 = idoCon.execute(idoIn3);
		if (DomainUtil.isError(idoOut3)) CommonErrorHandler.comHandler(idoOut3);
		if(DomainUtil.getResultCount(idoOut3) == 0) {
			return result;
		}
		JSONObject input = new JSONObject();
		input.put("USE_INTT_ID", use_intt_id);
		input.put("USER_ID", idoOut3.get("USER_ID"));
		String inputString = input.toJSONString();

		log("API_INPUT_LOGIN : " + inputString);

		//API 호출
		JSONObject output = callApi(service_url, "", header);

		//RSLT_CD
		// - S001:경리나라 관리자로 지정된 아이디만 연결할 수 있습니다.
		// - S002:경리나라 연결하기 미가입 사용자 입니다. 경리나라 스토어에서 아바타를 구매 후 이용하실 수 있습니다.
		if("S001".equals(output.getString("RSLT_CD")) || "S002".equals(output.getString("RSLT_CD"))) {
			//경리나라 연결정보 삭제
			JexData idoIn1 = util.createIDOData("CUST_LINK_SYS_INFM_D001");
			idoIn1.put("USE_INTT_ID", use_intt_id);
			idoIn1.put("APP_ID", app_id);
			JexData idoOut1 = idoCon.execute(idoIn1);
			if (DomainUtil.isError(idoOut1)) CommonErrorHandler.comHandler(idoOut1);

			//경리나라 질의연결정보 삭제
			IDODynamic dynamic_0 = new IDODynamic();
			JexData idoIn2 = util.createIDOData("CUST_INTE_LINK_INFM_D001");
			idoIn2.put("USE_INTT_ID", use_intt_id);
			dynamic_0.addNotBlankParameter(app_id, "\n AND APP_ID = ?");
			JexData idoOut2 = idoCon.execute(idoIn2);
			if (DomainUtil.isError(idoOut2)) CommonErrorHandler.comHandler(idoOut2);
		}

		return output;
	}

	/**
	 * 아바타 질의번호에 해당되는  컨텐츠제공사 API 호출한다.
	 * - API URL, 암호화키, 요청, 응답값 등은 DB로 관리한다.
	 * @param app_id
	 * @param api_id
	 * @param voiceInfo
	 * @param sessionInfo
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	public JSONObject executeApi(String app_id, String api_id, JSONObject voiceInfo, JexData sessionInfo, String Intent, String page_no, String page_sz) throws JexException, JexBIZException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		log("==== executeApi ====");
		log("app_id : " + app_id);
		log("api_id : " + api_id);
		log("voiceInfo : " + voiceInfo.toJSONString());
		log("sessionInfo : " + sessionInfo.toJSONString());
		log("page_no : " + page_no);
		log("page_sz : " + page_sz);

		//----------------------------------------------
		//APP 정보 조회
		//----------------------------------------------
		JexData idoIn0 = util.createIDOData("QUES_API_INFM_R004");
		idoIn0.put("APP_ID", app_id);
		idoIn0.put("API_ID", api_id);
		idoIn0.put("USE_INTT_ID", sessionInfo.getString("USE_INTT_ID"));
		JexData idoOut0 = idoCon.execute(idoIn0);
		if (DomainUtil.isError(idoOut0)) CommonErrorHandler.comHandler(idoOut0);
		if(DomainUtil.getResultCount(idoOut0) == 0) {
			JSONObject result = new JSONObject();
			result.put("RSLT_CD", "9999");
			result.put("RSLT_MSG", "API연결정보가 없습니다.");
			return result;
		}

		//----------------------------------------------
		//API INPUT 목록 가져오기
		//----------------------------------------------
		//메뉴 뎁스순으로 조회
		JexData idoIn1 = util.createIDOData("QUES_API_DTLS_R001");
		idoIn1.put("APP_ID", app_id);
		idoIn1.put("API_ID", api_id);
		idoIn1.put("FLD_DV", "I"); //H:header, I:input, O:output
		JexDataList<JexData> idoOut1 = idoCon.executeList(idoIn1);
		if (DomainUtil.isError(idoOut1)) CommonErrorHandler.comHandler(idoOut1);
		String INTE_CD = Intent; //idoOut0.getString("INTE_CD");

		//----------------------------------------------
		//API INPUT 매핑변수에 데이타 넣기
		//----------------------------------------------
		HashMap inputMappingData = new HashMap();
		log("==== Set MappingData START ====");
		int i=1;
		for (JexData rec : idoOut1) {
			String mppg_vrbs = rec.getString("MPPG_VRBS");
			String key = rec.getString("FLD_ID");
			if(StringUtil.isBlank(mppg_vrbs)) {
				continue;
			}

			String value = "";
			//서비스키 셋팅
			if("DB.SVC_KEY".equals(mppg_vrbs)) {
				value = idoOut0.getString("SVC_KEY");
				log("["+(i++)+"] DB           ["+key+"]["+mppg_vrbs+"]=["+value+"]");
			}
			//사용자 정의 매핑변수 셋팅
			if(StringUtil.isBlank(value)){
				value = QuestionUtil.changeField(mppg_vrbs, voiceInfo, sessionInfo, INTE_CD, page_no, page_sz);
				log("["+(i++)+"] QuestionUtil ["+key+"]["+mppg_vrbs+"]=["+value+"]");
			}

			//세션정보 셋팅
			if(StringUtil.isBlank(value) && sessionInfo.hasField(mppg_vrbs)) {
				value = sessionInfo.getString(mppg_vrbs);
				log("["+(i++)+"] sessionInfo ["+key+"]["+mppg_vrbs+"]=["+value+"]");
			}

			//음성정보 셋팅
			if(StringUtil.isBlank(value) && voiceInfo.containsKey(mppg_vrbs)) {
				value = voiceInfo.getString(mppg_vrbs);
				log("["+(i++)+"] voiceInfo   ["+key+"]["+mppg_vrbs+"]=["+value+"]");
			}

			inputMappingData.put(key, value);
		}
		log("==== Set MappingData END ====");
		log("MappingData : " + inputMappingData);

		//----------------------------------------------
		//API INPUT JSON 만들기
		//----------------------------------------------
		JSONObject input = new JSONObject();
		for (JexData rec : idoOut1) {
			createInputJson(rec, input); //input json key값만 생성
		}
		setInputJsonValue(input, inputMappingData); //input json에 매핑변수 데이타 셋팅
		log("setInputJsonValue : " + input.toJSONString());

		//----------------------------------------------
		//API 호출
		//----------------------------------------------
		String service_url = idoOut0.getString("HOST") + idoOut0.getString("API_URL");
		String token = idoOut0.getString("TOKEN");
		log("API_URL : " + service_url);

		Map<String, String> header = new HashMap();
		if("JSON".equals(idoOut0.getString("DATA_TYPE"))) {
			header.put("Content-Type", "application/json");
		}
		if(!StringUtil.isBlank(token)) {
			header.put("Authorization", token);
		}

		String inputString = input.toJSONString();
		if(!StringUtil.isBlank(idoOut0.getString("PARA_ID"))) {
			inputString = idoOut0.getString("PARA_ID") + "=" +inputString; //prameter로 전달하는 경우
		}
		log("API_INPUT : " + inputString);

		//API 호출
		JSONObject output = callApi(service_url, inputString, header);

		log("API_OUTPUT(원본) : " + output);

		//API 응답값에서  DB매핑변수에 해당되는 값만 추출하기
		JSONObject result = convertApiData(app_id, api_id, output);


		//----------------------------------------------
		//API응답외 추가정보 세팅
		//----------------------------------------------
//		result.put("TRSC_DT", input.get("TRSC_DT"));

		if(!"".equals(StringUtil.null2void((String)input.get("FST_INQ_DT")))) {
			if(!input.get("FST_INQ_DT").equals(input.get("LST_INQ_DT")))
				result.put("FST_INQ_DT",input.get("FST_INQ_DT"));
			else
				result.put("FST_INQ_DT", "");
		}
		//result.put("FST_INQ_DT",input.get("FST_INQ_DT"));
		if("".equals(StringUtil.null2void((String)output.get("LST_INQ_DT")))) {
			result.put("LST_INQ_DT",!"".equals(StringUtil.null2void((String)input.get("TRSC_DT"))) ? input.get("TRSC_DT") : input.get("LST_INQ_DT"));
		}

		result.put("YEAR_DATE", DateTime.getInstance().getDate("YYYY"));
		result.put("MONTH_DATE", DateTime.getInstance().getDate("YYYYMM"));
		result.put("DAY_DATE", DateTime.getInstance().getDate("YYYYMMDD"));
		//result.put("SRCH_WD", input.get("SRCH_WD"));
		result.put("SRCH_WD",!"".equals(StringUtil.null2void((String)input.get("SRCH_WD"))) ? input.get("SRCH_WD") : input.get("BZAQ_NM"));
		result.put("CLASS_BANK_NM",voiceInfo.getString("NE-BANKNAME"));
		result.put("RSLT_CD", output.get("RSLT_CD"));
		result.put("RSLT_MSG", output.get("RSLT_MSG"));
		result.put("TRSC_DT", result.get("LST_INQ_DT"));

		log("API_OUTPUT(변경) : " + result);

		return result;
	}

	/**
	 * 아바타 질의번호에 해당되는  컨텐츠제공사 API 호출한다.
	 * - API URL, 암호화키, 요청, 응답값 등은 DB로 관리한다.
	 * @param use_intt_id
	 * @param Intent
	 * @param voiceInfo
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	public JSONObject executeZeropayApi(String use_intt_id, String Intent, JSONObject voiceInfo) throws JexException, JexBIZException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		log("==== executeZeropayApi ====");
		log("use_intt_id : " + use_intt_id);
		log("Intent : " + Intent);
		log("voiceInfo : " + voiceInfo.toJSONString());

		String mest_nm = StringUtil.null2void(voiceInfo.getString("NE-COUNTERPARTNAME"),""); 		// 가맹점이름

//		String biz_dv = StringUtil.null2void(voiceInfo.getString("NE-PAYMENT_METHOD"),""); 		// 결제구분(0:일반, 1:상품권)
		String biz_dv = "";
		if("".equals(StringUtil.null2void(voiceInfo.getString("NE-PAYMENT_METHOD1"),""))) {
			if(!"".equals(StringUtil.null2void(voiceInfo.getString("NE-PAYMENT_METHOD2"),""))){
				biz_dv = "상품권";
			}
		}else {
			biz_dv = "직불";
		}

		String biz_cd = "";

		if(biz_dv.indexOf("상품권") > -1){
			biz_cd = "1";
		}else if(biz_dv.indexOf("직불") > -1){
			biz_cd = "0";
		}

		//--------------------------------------------
		//DB에서 사용자 제로페이 연결여부 확인
		//--------------------------------------------
		JexData idoIn0 = util.createIDOData("CUST_LDGR_R038");
		idoIn0.put("USE_INTT_ID", use_intt_id);
		JexData idoOut0 = idoCon.execute(idoIn0);
		if (DomainUtil.isError(idoOut0)) CommonErrorHandler.comHandler(idoOut0);

		JSONObject result = new JSONObject();
		// 사용자 ZEROPAY 연결되어있고 가맹점이 조회가능할 때만 API 호출
		if("".equals(StringUtil.null2void(idoOut0.getString("CUST_CI")))) {
			result.put("RSLT_CD", "ZER002");
			result.put("RSLT_MSG", "조회가능한 가맹점 정보가 없습니다.");
			result.put("SRCH_WD", mest_nm);
		} else {
			IDODynamic dynamic = new IDODynamic();
			if(!"".equals(mest_nm)) {
				dynamic.addSQL("\n AND MEST.MEST_NM ='"+mest_nm+"'");
				dynamic.addSQL("\n AND MEST.USE_YN ='Y'");
				dynamic.addSQL("\n AND MEST.ACVT_STTS ='1'");
			}

			//--------------------------------------------
			//DB에서 제로페이 연결정보, 가맹점정보 가져오기
			//--------------------------------------------
			JexData idoIn1 = util.createIDOData("CUST_LDGR_R031");
			idoIn1.put("USE_INTT_ID", use_intt_id);
			idoIn1.put("DYNAMIC_0",dynamic);
			JexData idoOut1 = idoCon.execute(idoIn1);
			if (DomainUtil.isError(idoOut1)) CommonErrorHandler.comHandler(idoOut1);

			String ci = idoOut1.getString("CUST_CI");
			//todo
			String biz_no =  !"".equals(mest_nm)? StringUtil.null2void(idoOut1.getString("MEST_BIZ_NO"),"") : "";
			String ser_biz_no = !"".equals(mest_nm)? StringUtil.null2void(idoOut1.getString("SER_BIZ_NO"),"") : "";

			// 인텐트 정보로 조회시간값 추출
			String str_date = QuestionUtil.getInqDt("STR_DATE", voiceInfo, Intent);
			String end_date = QuestionUtil.getInqDt("END_DATE", voiceInfo, Intent);
			String sch_date = QuestionUtil.getInqDt("SCH_DATE", voiceInfo, Intent);

			//API 호출
			JSONObject output = new JSONObject();

			// 조회된 가맹점이 없을 경우 API 호출 안함
			if(!"".equals(mest_nm) && "".equals(biz_no)) {
				output.put("RSLT_CD","ZER001");
				output.put("RSLT_MSG","제로페이 연결정보가 없습니다.");
			}else {
				log("API_INPUT(제로페이 CI) 		: " + ci);
				log("API_INPUT(제로페이 BIZ_NO) 	: " + biz_no);
				log("API_INPUT(제로페이 SER_BIZ_NO)	: " + ser_biz_no);

				// 제로페이 결제 수수료 API 호출
				if(Intent.equals("ZNN003")) {
					log("API_INPUT(제로페이 STR_DATE) 	: " + str_date);
					log("API_INPUT(제로페이 END_DATE) 	: " + end_date);

					output = ZeropayApiMgnt.data_api_005(ci, biz_no, ser_biz_no, str_date, end_date);

					if((output.getString("RSLT_CD")).equals("0000")) {
						String tran_fee = StringUtil.null2void(output.getString("TRAN_FEE"),"0");

						output.put("CLASS_TRAN_FEE", tran_fee);
					}
				}
				// 제로페이 입금 예정액-상세 API 호출
				else if (Intent.equals("ZNN007")/* && !biz_cd.equals("") */) {
					log("API_INPUT(제로페이 SCH_DATE) 	: " + sch_date);
					log("API_INPUT(제로페이 BIZ_CD) 	: " + biz_cd);
					output = ZeropayApiMgnt.data_api_007(ci, biz_no, ser_biz_no, sch_date, biz_cd);

					if((output.getString("RSLT_CD")).equals("0000")) {
						String tran_fee = StringUtil.null2void(output.getString("TRAN_FEE"),"0");

						output.put("CLASS_TRAN_FEE", tran_fee);
						output.put("CLASS_BIZ_DV", StringUtil.null2void(biz_dv, ""));
					}
				}
				// 제로페이 입금 예정액 API 호출
				else if(Intent.equals("ZNN006")) {
					log("API_INPUT(제로페이 SCH_DATE) 	: " + sch_date);
					output = ZeropayApiMgnt.data_api_006(ci, biz_no, ser_biz_no, sch_date);

					if((output.getString("RSLT_CD")).equals("0000")) {
						String tran_amt1 = StringUtil.null2void(output.getString("TRAN_AMT1"),"0");		//직불
						String tran_amt2 = StringUtil.null2void(output.getString("TRAN_AMT2"),"0");		//상품권
						BigDecimal totl_tran_amt   = new BigDecimal("00");
						totl_tran_amt = totl_tran_amt.add(new BigDecimal(tran_amt1));
						totl_tran_amt = totl_tran_amt.add(new BigDecimal(tran_amt2));

						output.put("CLASS_TOTL_TRAN_AMT", String.valueOf(totl_tran_amt)); 	// 입금 예정액(직불+상품권)
					}
				}
				// 제로페이 매출 브리핑 API + SQL
				else if(Intent.equals("ZSN001")) {
					// 오늘일자
					sch_date = DateTime.getInstance().getDate("YYYYMMDD");
					log("API_INPUT(제로페이 SCH_DATE) 	: " + sch_date);

					output = ZeropayApiMgnt.data_api_006(ci, biz_no, ser_biz_no, sch_date);

					if((output.getString("RSLT_CD")).equals("0000")){
						String tran_amt1 = StringUtil.null2void(output.getString("TRAN_AMT1"),"0");
						String tran_amt2 = StringUtil.null2void(output.getString("TRAN_AMT2"),"0");

						BigDecimal totl_tran_amt   = new BigDecimal("00");
						totl_tran_amt = totl_tran_amt.add(new BigDecimal(tran_amt1));
						totl_tran_amt = totl_tran_amt.add(new BigDecimal(tran_amt2));

						String trns_day = SvcDateUtil.getInstance().getDate(-1, 'D');

						// 전일 제로페이 매출액 조회
						JexData idoIn2 = util.createIDOData("ZERO_TRAN_HSTR_R002");
						idoIn2.put("USE_INTT_ID", use_intt_id);
						idoIn2.put("SETL_DT", trns_day);
						JexData idoOut2 = idoCon.execute(idoIn2);
						if (DomainUtil.isError(idoOut2)) CommonErrorHandler.comHandler(idoOut2);

						String trns_amt = StringUtil.null2void(idoOut2.getString("TRNS_AMT"),"0");

						output.put("TRAN_AMT1", tran_amt1);		// 직불 총액
						output.put("TRAN_AMT2", tran_amt2);		// 상품권 총액
						output.put("CLASS_TOTL_TRAN_AMT", String.valueOf(totl_tran_amt)); // 입금 예정액(직불+상품권)
						output.put("CLASS_TRNS_DAY", trns_day); 		// 제로페이매출액기준일자
						output.put("CLASS_TRNS_AMT", trns_amt); 		// 제로페이매출액
					}
				}

				log("API_OUTPUT(제로페이 호출 원본) : " + output);
			}

			// result 셋팅
			result = output;

			//----------------------------------------------
			//API응답외 추가정보 세팅
			//----------------------------------------------
			result.put("TRSC_DT", sch_date);

			if(!"".equals(StringUtil.null2void(str_date))) {
				if(!str_date.equals(end_date))
					result.put("FST_INQ_DT",str_date);
				else
					result.put("FST_INQ_DT", "");
			}

			if("".equals(StringUtil.null2void(end_date))) {
				result.put("LST_INQ_DT",!"".equals(StringUtil.null2void(sch_date)) ? sch_date : end_date);
			}else {
				result.put("LST_INQ_DT",end_date);
			}

			result.put("YEAR_DATE", DateTime.getInstance().getDate("YYYY"));
			result.put("MONTH_DATE", DateTime.getInstance().getDate("YYYYMM"));
			result.put("DAY_DATE", DateTime.getInstance().getDate("YYYYMMDD"));
			result.put("MEST_NM",mest_nm);
			result.put("SRCH_WD", mest_nm);
			result.put("BIZ_DV",biz_dv);
			result.put("HIS_LST_DTM", DateTime.getInstance().getDate("yyyymmddhh24miss"));

			// 조회된 가맹점이 없을 경우
			if(!"".equals(mest_nm) && "".equals(biz_no)) {
				result.put("RSLT_CD", "ZER001");
				result.put("RSLT_MSG", "조회된 가맹점 정보가 없습니다.");
			}else {
				result.put("RSLT_CD", output.get("RSLT_CD"));
				result.put("RSLT_MSG", output.get("RSLT_MSG"));
			}

			log("API_OUTPUT(제로페이 호출 가공) : " + result);
		}
		return result;
	}

	/**
	 * API응답값에서 질의정보의 매핑변수에 해당되는 항목만 추출한다.
	 * @param app_id
	 * @param api_id
	 * @param apiOutput
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 */
	private JSONObject convertApiData(String app_id, String api_id, Object apiOutput) throws JexException, JexBIZException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		//--------------------------------------------
		//DB에서 OUTPUT 매핑변수 목록 가져오기
		//--------------------------------------------
		JexData idoIn2 = util.createIDOData("QUES_API_DTLS_R001");
		idoIn2.put("APP_ID", app_id);
		idoIn2.put("API_ID", api_id);
		idoIn2.put("FLD_DV", "O"); //H:header, I:input, O:output
		JexDataList<JexData> idoOut2 = idoCon.executeList(idoIn2);
		if (DomainUtil.isError(idoOut2)) CommonErrorHandler.comHandler(idoOut2);

		// ##############
		HashMap mappingkeys = new HashMap();
		for (JexData rec : idoOut2) {
			if(!StringUtil.isBlank(rec.getString("MPPG_VRBS"))) {
				//mappingkeys.put(rec.getString("UP_FLD_ID").trim()+"/"+rec.getString("FLD_ID").trim(), rec.getString("MPPG_VRBS").trim());
				mappingkeys.put(rec.getString("FLD_ID").trim(), rec.getString("MPPG_VRBS").trim());
				log("FLD_ID,MPPG_VRBS = [" + rec.getString("FLD_ID").trim()+"/"+rec.getString("UP_FLD_ID").trim() + "," + rec.getString("MPPG_VRBS").trim() + "]");
			}
		}
		// ##############
		//--------------------------------------------
		//API응답값(apiOutput)에서  DB매핑변수에 해당되는 값만 추출하여 result에 등록
		//--------------------------------------------
		JSONObject result = new JSONObject();
		convertApiData("", apiOutput, "", mappingkeys, result);

		String s = result.toJSONString();
		Iterator<String> it = mappingkeys.keySet().iterator();
		//Iterator<String> it = mappingkeysREC.keySet().iterator();

		while (it.hasNext()) {
			String key = it.next();
			s = s.replaceAll("\"" + key + "\"", "\"" + mappingkeys.get(key) + "\"");
		}
		return (JSONObject) JSONParser.parser(s);
	}

	/**
	 * API응답값에서 질의정보의 매핑변수에 해당되는 항목만 추출한다.
	 *   - 매핑변수(mappingKeys)에 해당되는 Json값이 Array 인 경우 result에 최상위에 복사
	 *   - 매핑변수(mappingKeys)에 해당되는 Json값이 String인 경우 result에 최상위에 복사
	 * @param jsonKey
	 * @param jsonObj
	 * @param path
	 * @param mappingKeys
	 * @param result
	 */
	private void convertApiData(String jsonKey, Object jsonObj, String path, HashMap mappingKeys, JSONObject result) {

		if (jsonObj instanceof JSONArray) {
			if(mappingKeys.containsKey(jsonKey)) {
				result.put(jsonKey, jsonObj);
				mappingKeys.put("ARRAY"+path,"");
			}
			for (Object item1 : (JSONArray) jsonObj) {
				convertApiData(jsonKey, (JSONObject)item1, path, mappingKeys, result);
			}
		} else if (jsonObj instanceof JSONObject) {
			JSONObject json = (JSONObject)jsonObj;

			for (Object key : json.keySet()) {
				Object item = json.get(key);
				if (item instanceof JSONArray || item instanceof JSONObject) {
					convertApiData((String)key, item, path+"."+key, mappingKeys, result);
				}else {
					if(mappingKeys.containsKey(key) && mappingKeys.containsKey("ARRAY"+path)) {
						//Array의 매핑변수는 result 최상위에 넣지 않음(array에 포함되어있음)
					}else if(!mappingKeys.containsKey(key) && mappingKeys.containsKey("ARRAY"+path)) {
						//Array에 매핑변수 없으면 array에서 삭제
						json.remove(key);
					} else if(mappingKeys.containsKey(key)) {
						//result 최상위에 값 넣기
						result.put(key, item);
					}
				}
			}
		}
	}

	private JSONObject callApi(String url, String input, Map header){

		StackTraceElement[] stacks = new Throwable().getStackTrace();
		StringBuffer sbLog = new StringBuffer();
		sbLog.append("\n------------------------ START ------------------------");
		sbLog.append("\nStartTime :: " + SvcDateUtil.getInstance().getDate("YYYY-MM-DD HH24:MI:SS"));

		if(stacks.length > 3)
			sbLog.append("\n[before] " + stacks[4].getClassName().replaceAll("002d", "").replaceAll("005f", "")+ " " + stacks[4].getMethodName());
		if(stacks.length > 2)
			sbLog.append("\n[before] " + stacks[3].getClassName().replaceAll("002d", "").replaceAll("005f", "")+ " " + stacks[3].getMethodName());
		sbLog.append("\n[before] " + stacks[2].getClassName().replaceAll("002d", "").replaceAll("005f", "")+ " " + stacks[2].getMethodName());

		JSONObject outputData = new JSONObject();

		try{
			sbLog.append("\nurl  :: " + url);
			sbLog.append("\nInput  :: " + input);
			sbLog.append("\nheader  :: " + header);

			String strResultData = ExternalConnectUtil.connect(url, input, url.toLowerCase().startsWith("https")?"https":"http", "utf-8", header);

			sbLog.append("\nResult :: " + strResultData);
			sbLog.append("\nEndTime :: " + SvcDateUtil.getInstance().getDate("YYYY-MM-DD HH24:MI:SS")+"\n");

			log(sbLog.toString());
			sbLog.setLength(0);

			outputData = (JSONObject)JSONParser.parser(strResultData);

		}catch(Exception e){

			StringWriter sw = new StringWriter();
			e.printStackTrace(new PrintWriter(sw));

			sbLog.append("\nException :: " + sw.toString());
			sbLog.append("\nEnd Time " + SvcDateUtil.getInstance().getDate("YYYY-MM-DD HH24:MI:SS"));

			log(sbLog.toString());
			sbLog.setLength(0);

			outputData.put("RSLT_CD", "C999");
			outputData.put("RSLT_MSG", "처리중오류가발생하였습니다.잠시후이용하시기바랍니다.");
		}
		return outputData;
	}

	private void createInputJson(JexData field, JSONObject input) {
		String fld_id = field.getString("FLD_ID");
		String fld_type = field.getString("FLD_TYPE");
		String path = field.getString("PATH");
		String arr_path[] = path.split(",");

		//ex) fld=USER_NM, path=RESP_DATA,USER_INFO,USER_NM
		JSONObject tmp = input;
		for (int i = 0; i < arr_path.length; i++) {
			if(!fld_id.equals(arr_path[i])) {
				if(tmp.containsKey(arr_path[i])) {
					if (tmp.get(arr_path[i]) instanceof JSONObject) {
						tmp = (JSONObject)tmp.get(arr_path[i]);
					}else {
						log("input의  ["+(i+1)+"]뎁스 ["+arr_path[i]+"] 필드가 JSONObject가 아님!");
						break;
					}
				}else {
					log("input의  ["+(i+1)+"]뎁스 ["+arr_path[i]+"] 필드가 없음!");
					break;
				}
			}else{
				if("F".equals(fld_type)) {
					tmp.put(arr_path[i], "");
				}else if("R".equals(fld_type)) {
					tmp.put(arr_path[i], new JSONObject());
				}
			}
		}
		log("createInputJson : " + input.toJSONString());
	}

	private void setInputJsonValue(Object jsonObj, HashMap mappingKeys) {

		if (jsonObj instanceof JSONArray) {
			for (Object item1 : (JSONArray) jsonObj) {
				setInputJsonValue((JSONObject) item1, mappingKeys);
			}
		} else if (jsonObj instanceof JSONObject) {

			JSONObject json = ((JSONObject)jsonObj);
			for (Object key : json.keySet()) {
				Object item = json.get(key);
				if (item instanceof JSONArray || item instanceof JSONObject) {
					setInputJsonValue(item, mappingKeys);
				}else{
					if(mappingKeys.containsKey(key)){
						json.put(key, mappingKeys.get(key));
					}
				}
			}
		}
	}

	private void log(String str) {
		ContentApiMgnt api = new ContentApiMgnt();
		BizLogUtil.debug(api, str);
//		System.out.println(str);
	}

	/**
	 * 아바타 질의번호에 해당되는  컨텐츠제공사 API 호출한다.
	 * - API URL, 암호화키, 요청, 응답값 등은 DB로 관리한다.
	 * @param use_intt_id
	 * @param Intent
	 * @param voiceInfo
	 * @return
	 * @throws JexException
	 * @throws JexBIZException
	 * @throws ParseException
	 */
	public JSONObject executeZeropayApiSdk(String CUST_CI, String PAGE_NO, String PAGE_SIZE,
										   String Intent, JSONObject voiceInfo) throws JexException, JexBIZException, ParseException {

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		log("==== executeZeropayApiSdk ====");
		log("CUST_CI : " + CUST_CI);
		log("PAGE_NO : " + PAGE_NO);
		log("PAGE_SIZE : " + PAGE_SIZE);
		log("Intent : [" + Intent + "]");
		log("voiceInfo : " + voiceInfo.toJSONString());

		// 가맹점이름
		String 	mest_nm = StringUtil.null2void(voiceInfo.getString("NE-COUNTERPARTNAME"),"");

		// 상품권이름
		String	gift_nm = StringUtil.null2void(voiceInfo.getString("NE-ZEROPAY_GIFT_CERTIFICATENAME"),"");

		// 결제사명
		String	pay_nm 	= StringUtil.null2void(voiceInfo.getString("NE-ZEROPAY_PAYERNAME"),"");

		//결제구분(0:일반, 1:상품권)
		String biz_dv = "";
		if("".equals(StringUtil.null2void(voiceInfo.getString("NE-PAYMENT_METHOD1"),""))) {
			//공백이고
			if(!"".equals(StringUtil.null2void(voiceInfo.getString("NE-PAYMENT_METHOD2"),""))){
				//상품권이 이면
				biz_dv = "상품권";
			} else {

				if(Intent.equals("ZNN002") || Intent.equals("ZNN007")) {
					// 은행+상품권
					biz_dv = "";
				} else {
					biz_dv = "은행";
				}

			}
		}else {
			biz_dv = "은행";
		}

		String 	biz_cd = "";

		if(biz_dv.indexOf("상품권") > -1){
			biz_cd = "1";
		}else if(biz_dv.indexOf("은행") > -1){
			biz_cd = "0";
		}

		// 가맹점관리번호 AFLT_MANAGEMENT_NO
		String	aflt_management_no = StringUtil.null2void(voiceInfo.getString("AFLT_MANAGEMENT_NO"),"");

		// 가맹점사업자번호 BIZ_NO
		String biz_no = StringUtil.null2void(voiceInfo.getString("MEST_BIZ_NO"),"");

		// 가맹점종사업자번호 SER_BIZ_NO
		String ser_biz_no = StringUtil.null2void(voiceInfo.getString("SER_BIZ_NO"),"");

		JSONObject result = new JSONObject();

		// 사용자 ZEROPAY 연결되어있고 가맹점이 조회가능할 때만 API 호출
		if("".equals(StringUtil.null2void(CUST_CI))) {
			result.put("RSLT_CD", "ZER002");
			result.put("RSLT_MSG", "조회가능한 가맹점 정보가 없습니다.");
			result.put("SRCH_WD", mest_nm);
		} else {

			String str_date = QuestionUtil.getInqDt("STR_DATE", voiceInfo, Intent);
			String end_date = QuestionUtil.getInqDt("END_DATE", voiceInfo, Intent);
			String sch_date = QuestionUtil.getInqDt("SCH_DATE", voiceInfo, Intent);


			//API 호출
			JSONObject output = new JSONObject();

			//결제내역집계(AVATAR_API_003) 연동 Intent
			//	1. 제로페이 결제금액 (ZNN001)
			//	2. 제로페이 결제취소금액 (ZNN004)
			//  3. 제로페이 매출 브리핑 (ZSN001)
			// 	4. 제로페이 매출액 (SCT001)
			if(Intent.equals("ZNN001") || Intent.equals("ZNN004")
					|| Intent.equals("ZSN001") || Intent.equals("SCT001")){

				log("API_INPUT(제로페이 STR_DATE) 	: " + str_date);
				log("API_INPUT(제로페이 END_DATE) 	: " + end_date);
				log("API_INPUT(가맹점명 AFLT_NM) 	: " + mest_nm);

				output = ZeropayApiMgnt.data_api_003_sdk(CUST_CI, str_date, end_date, mest_nm, PAGE_NO, PAGE_SIZE);

				if((output.getString("RSLT_CD")).equals("0000")) {

					if(Intent.equals("ZNN001")){

						output.put("CLASS_TOTL_SUM", output.get("TOT_APRV_AMT"));
						output.put("MORE_YN", output.get("MORE_YN"));

						//조회시작일 ~ 조회종료일 사이의 날짜 구하기
						DateFormat df = new SimpleDateFormat("yyyyMMdd");

						Date sdate = df.parse(str_date);
						Date edate = df.parse(end_date);

						Calendar c1 = Calendar.getInstance();
						Calendar c2 = Calendar.getInstance();

						c1.setTime(sdate);
						c2.setTime(edate);

						//조회시작일 ~ 조회종료일 데이터 초기화
						JSONArray dateList = new JSONArray();
						while(c2.compareTo(c1) != -1){

							log("c2.getTime() = " + c2.getTime());

							JSONObject init = new JSONObject();
							init.put("TRSC_DT", df.format(c2.getTime()));
							init.put("DEBIT_SUM", "0");
							init.put("POINT_SUM", "0");

							dateList.add(init);
							c2.add(Calendar.DATE, -1);
						}

						//일자별 금액 합계 구하기
						JSONArray arr = output.getJSONArray("REC");
						for(Object obj : arr){

							JSONObject tmp = (JSONObject)obj;

							String TRAN_DT = tmp.getString("TRAN_DT"); //거래일자
							String DP_APRV_AMT 	= StringUtil.null2void(tmp.getString("DP_APRV_AMT"),"0"); 		//직불(은행) 결제 금액
							String GIFT_APRV_AMT = StringUtil.null2void(tmp.getString("GIFT_APRV_AMT"),"0");	//상품권 결제 금액

							// 직불(은행) 결제 금액
							BigDecimal tmp_debit = new BigDecimal("00");
							tmp_debit = tmp_debit.add(new BigDecimal(DP_APRV_AMT));

							// 상품권 결제 금액 - 상품권 취소 금액
							BigDecimal tmp_point = new BigDecimal("00");
							tmp_point = tmp_point.add(new BigDecimal(GIFT_APRV_AMT));

							for(int i = 0; i < dateList.size(); i++){

								if(TRAN_DT.equals(dateList.getJSONObject(i).getString("TRSC_DT"))){

									String debit_sum = dateList.getJSONObject(i).getString("DEBIT_SUM");
									String point_sum = dateList.getJSONObject(i).getString("POINT_SUM");

									BigDecimal rstDebit = new BigDecimal(debit_sum);
									rstDebit = rstDebit.add(tmp_debit);

									BigDecimal rstPoint = new BigDecimal(point_sum);
									rstPoint = rstPoint.add(tmp_point);

									dateList.getJSONObject(i).put("DEBIT_SUM", String.valueOf(rstDebit));
									dateList.getJSONObject(i).put("POINT_SUM", String.valueOf(rstPoint));
								}
							}
						}

						//결제금액(상품권결제금액)이 0원인 경우를 제외하고 리스트 재조립
						//List Sort
						JSONArray rtnList = new JSONArray();
						for(int i = 0; i < dateList.size(); i++){

							JSONObject tmp = dateList.getJSONObject(i);
							String debit_sum = StringUtil.null2void(tmp.getString("DEBIT_SUM"),"0");
							String point_sum = StringUtil.null2void(tmp.getString("POINT_SUM"),"0");

							BigDecimal chkVal = new BigDecimal("00");
							chkVal = chkVal.add(new BigDecimal(debit_sum));
							chkVal = chkVal.add(new BigDecimal(point_sum));

							if(chkVal.compareTo(BigDecimal.ZERO) != 0){
								rtnList.add(tmp);
							}
						}

						output.put("_MEST_CNT", rtnList.size() == 0 ? 0 : rtnList.size());
						output.put("SQL2", rtnList);
					}

					if(Intent.equals("ZNN004")){

						output.put("CLASS_TOTL_SUM", output.get("TOT_CNCL_AMT"));
						output.put("MORE_YN", output.get("MORE_YN"));

						//조회시작일 ~ 조회종료일 사이의 날짜 구하기
						DateFormat df = new SimpleDateFormat("yyyyMMdd");

						Date sdate = df.parse(str_date);
						Date edate = df.parse(end_date);

						Calendar c1 = Calendar.getInstance();
						Calendar c2 = Calendar.getInstance();

						c1.setTime(sdate);
						c2.setTime(edate);

						//조회시작일 ~ 조회종료일 데이터 초기화
						JSONArray dateList = new JSONArray();
						while(c2.compareTo(c1) != -1){

							log("c2.getTime() = " + c2.getTime());

							JSONObject init = new JSONObject();
							init.put("TRSC_DT", df.format(c2.getTime()));
							init.put("DEBIT_SUM", "0");
							init.put("POINT_SUM", "0");

							dateList.add(init);
							c2.add(Calendar.DATE, -1);
						}

						//일자별 금액 합계 구하기
						JSONArray arr = output.getJSONArray("REC");
						for(Object obj : arr){

							JSONObject tmp = (JSONObject)obj;

							String TRAN_DT = tmp.getString("TRAN_DT"); //거래일자
							String DP_CNCL_AMT 	= StringUtil.null2void(tmp.getString("DP_CNCL_AMT"),"0");		//직불(은행) 취소 금액
							String GIFT_CNCL_AMT = StringUtil.null2void(tmp.getString("GIFT_CNCL_AMT"),"0");	//상품권 취소 금액

							// 직불(은행) 취소 금액
							BigDecimal tmp_debit = new BigDecimal("00");
							tmp_debit = tmp_debit.add(new BigDecimal(DP_CNCL_AMT));

							// 상품권 취소 금액
							BigDecimal tmp_point = new BigDecimal("00");
							tmp_point = tmp_point.add(new BigDecimal(GIFT_CNCL_AMT));

							for(int i = 0; i < dateList.size(); i++){
								if(TRAN_DT.equals(dateList.getJSONObject(i).getString("TRSC_DT"))){

									String debit_sum = dateList.getJSONObject(i).getString("DEBIT_SUM");
									String point_sum = dateList.getJSONObject(i).getString("POINT_SUM");

									BigDecimal rstDebit = new BigDecimal(debit_sum);
									rstDebit = rstDebit.add(tmp_debit);

									BigDecimal rstPoint = new BigDecimal(point_sum);
									rstPoint = rstPoint.add(tmp_point);

									dateList.getJSONObject(i).put("DEBIT_SUM", String.valueOf(rstDebit));
									dateList.getJSONObject(i).put("POINT_SUM", String.valueOf(rstPoint));
								}
							}
						}

						//결제금액(상품권결제금액)이 0원인 경우를 제외하고 리스트 재조립
						//List Sort
						JSONArray rtnList = new JSONArray();
						for(int i = 0; i < dateList.size(); i++){

							JSONObject tmp = dateList.getJSONObject(i);
							String debit_sum = StringUtil.null2void(tmp.getString("DEBIT_SUM"),"0");
							String point_sum = StringUtil.null2void(tmp.getString("POINT_SUM"),"0");

							BigDecimal chkVal = new BigDecimal("00");
							chkVal = chkVal.add(new BigDecimal(debit_sum));
							chkVal = chkVal.add(new BigDecimal(point_sum));

							if(chkVal.compareTo(BigDecimal.ZERO) != 0){
								rtnList.add(tmp);
							}
						}

						output.put("_MEST_CNT", rtnList.size() == 0 ? 0 : rtnList.size());
						output.put("SQL2", rtnList);
					}
				}

				//API History 저장
				JexData idoIn0 = util.createIDOData("ZERO_QUES_HSTR_U001");
				idoIn0.put("API_ID", "AVATAR_API_003");

				idoIn0.put("CUST_CI", CUST_CI);
				idoIn0.put("INTE_CD", Intent);
				idoIn0.put("AFLT_NM", mest_nm);
				idoIn0.put("TRANS_DIV", "");
				idoIn0.put("SRCH_STR_DT", str_date);
				idoIn0.put("SRCH_END_DT", end_date);
				idoIn0.put("SRCH_SCH_DT", "");
				idoIn0.put("PROC_RSLT_CD", output.get("RSLT_CD"));
				idoIn0.put("PROC_RSLT_CTT", output.get("RSLT_MSG"));

				JexData idoOut0 = idoCon.execute(idoIn0);
				if (DomainUtil.isError(idoOut0)) CommonErrorHandler.comHandler(idoOut0);

			}

			//결제내역조회 (AVATAR_API_004) 연동 Intent
			//	1. 제로페이 결제내역 (ZNN002)
			//	2. 제로페이 결제 취소내역 (ZNN005)
			//	3. 제로페이 상품권 결제내역 (ZNN008)
			//	4. 제로페이 상품권 결제 취소내역 (ZNN009)
			else if(Intent.equals("ZNN002") || Intent.equals("ZNN005")
					|| Intent.equals("ZNN008") || Intent.equals("ZNN009")){

				// 결제상태(pay_st)
				// 1 : 결제
				// 2 : 취소
				// 결제 취소내역 Intent유입시 결제상태 변경
				String pay_st = "1";
				if(Intent.equals("ZNN005") || Intent.equals("ZNN009")){
					pay_st = "2";
				}

				//biz_cd = 공백인경우 둘다 조회
				biz_cd = StringUtil.null2void(biz_cd, "2");

				log("API_INPUT(제로페이 STR_DATE) 	: " + str_date);
				log("API_INPUT(제로페이 END_DATE) 	: " + end_date);
				log("API_INPUT(제로페이 BIZ_CD) 	: " + biz_cd);
				log("API_INPUT(가맹점명 AFLT_NM) 	: " + mest_nm);
				log("API_INPUT(결제상태 PAY_ST) 	: " + pay_st);
				log("API_INPUT(결제사명 PAY_NM) 	: " + pay_nm);
				log("API_INPUT(상품권명 GIFT_NM) 	: " + gift_nm);
				log("API_INPUT(페이지INDEX PAGE_NO) 	: " + PAGE_NO);
				log("API_INPUT(페이지SIZE PAGE_SIZE) 	: " + PAGE_SIZE);

				output = ZeropayApiMgnt.data_api_004_sdk(
						CUST_CI, str_date, end_date, biz_cd, mest_nm, pay_st, pay_nm, gift_nm, PAGE_NO, PAGE_SIZE
				);

				if((output.getString("RSLT_CD")).equals("0000")) {

					//TODO 제로페이 결제내역(ZNN002) || 제로페이 결제 취소내역(ZNN005)
					if(Intent.equals("ZNN002") || Intent.equals("ZNN005")){
						output.put("REC_ELEM_NM", "REC");

						JSONArray arr = output.getJSONArray("REC");
						JSONArray rtnList = new JSONArray();

						for(int i = 0; i < arr.size(); i++){
							JSONObject obj = arr.getJSONObject(i);
							String TRAN_ID = obj.getString("TRAN_ID");
							String TRAN_OCC_DATE = obj.getString("TRAN_OCC_DATE");
							String OTRAN_BANK_NM = obj.getString("OTRAN_BANK_NM");
							String OTRAN_TIME = obj.getString("OTRAN_TIME");
							String ADD_TAX_AMT = StringUtil.null2void(obj.getString("ADD_TAX_AMT"),"0");
							String SRV_FEE = StringUtil.null2void(obj.getString("SRV_FEE"),"0");
							String BIZ_CD = obj.getString("BIZ_CD");

							// 상태 값(1: 결제, 2:취소)
							String val = obj.getString("TRAN_PROC_CD");
							// 결제 구분(1: 은행, 2:상품권)
							String val2 = obj.getString("BIZ_CD");

							String STTS = "";

							// 1 = 결제
							if ("1".equals(val)) {
								obj.replace("TRAN_PROC_CD", "결제");
								STTS = "결제";
							}
							// 2 = 취소
							else if ("2".equals(val)) {
								obj.replace("TRAN_PROC_CD", "취소");
								STTS = "취소";
							}
							// 1 = 착불
							if ("1".equals(val2)) {
								obj.replace("BIZ_CD", "은행");
								BIZ_CD = "은행";
							}
							// 2 = 상품권
							else if ("2".equals(val2)) {
								obj.replace("BIZ_CD", "상품권");
								BIZ_CD = "상품권";
							}

							obj.put("TRSC_DT", TRAN_OCC_DATE);
							obj.put("SETL_DT", TRAN_OCC_DATE);
							obj.put("POINT_NM", "");

							JSONArray pointArr = obj.getJSONArray("POINT_REC");
							if(pointArr.size() > 0){

								for(int j = 0; j < pointArr.size(); j++){

									JSONObject pointTmp = pointArr.getJSONObject(j);
									String pointNm = pointTmp.getString("POINT_NM");
									String tranAmt = pointTmp.getString("TRAN_AMT");
									String pointImgUrl = pointTmp.getString("POINT_IMG_URL");

									JSONObject rtnObj = new JSONObject();
									rtnObj.put("TRSC_DT", TRAN_OCC_DATE);
//									rtnObj.put("IMG_PATH", pointImgUrl);
									rtnObj.put("TRAN_ID", TRAN_ID);
									rtnObj.put("SETL_DT", TRAN_OCC_DATE.concat(OTRAN_TIME));
									rtnObj.put("POINT_AMT", tranAmt);
									rtnObj.put("OTRAN_BANK_NM", OTRAN_BANK_NM);
									rtnObj.put("POINT_NM", pointNm);

									rtnObj.put("STTS", STTS);
									rtnObj.put("DTM", OTRAN_TIME);
									rtnObj.put("TRAN_AMT", tranAmt);
									rtnObj.put("ADD_TAX_AMT", ADD_TAX_AMT);
									rtnObj.put("SRV_FEE", SRV_FEE);
									rtnObj.put("BIZ_CD", BIZ_CD);

									rtnList.add(rtnObj);
								}
							} else {
								rtnList.add(obj);
							}

						}

						output.put("_MEST_CNT", rtnList.size() == 0 ? 0 : rtnList.size());
						output.replace("REC", rtnList);

					}

					else if(Intent.equals("ZNN008")){

						//임시
						/*String msg = "{\"RSLT_CD\":\"0000\",\"REC\":[{\"BIZ_CD\":\"1\",\"OTRAN_BANK_NM\":\"쿠콘\",\"BIZ_NO\":\"\",\"TRAN_PROC_CD\":\"1\",\"AFLT_MANAGEMENT_NO\":\"202112001623\",\"AFLT_FEE\":\"0\",\"SVC_AMT\":\"0\",\"SER_BIZ_NO\":\"\",\"POINT_REC\":[{	\"POINT_NM\":\"영등포사랑상품권\",	\"POINT_ID\":\"TEST1\",	\"TRAN_AMT\":\"2000\",	\"BAL_AMT\":\"198000\",	\"FACE_AMT\":\"200000\",	\"POINT_IMG_URL\":\"TESTURL111\",	\"POINT_ICON_IMG_URL\":\"TESTICONURL111\"	},	{	\"POINT_NM\":\"중구사랑상품권\",	\"POINT_ID\":\"TEST2\",	\"TRAN_AMT\":\"5000\",	\"BAL_AMT\":\"195000\",	\"FACE_AMT\":\"200000\",	\"POINT_IMG_URL\":\"TESTURL222\",	\"POINT_ICON_IMG_URL\":\"TESTICONURL222\"	},	{	\"POINT_NM\":\"온누리상품권\",	\"POINT_ID\":\"TEST3\",	\"TRAN_AMT\":\"10000\",	\"BAL_AMT\":\"190000\",	\"FACE_AMT\":\"200000\",	\"POINT_IMG_URL\":\"TESTURL333\",	\"POINT_ICON_IMG_URL\":\"TESTICONURL333\"	}],\"ORG_PROC_SEQ\":null,\"AFLT_NM\":\"코코샤넬\",\"TRAN_AMT\":\"4100\",\"AFLT_ID\":\"202112001623\",\"TRAN_OCC_DATE\":\"20211223\",\"OTRAN_TIME\":\"093459\",\"ADD_TAX_AMT\":\"373\",\"TRAN_ID\":\"H99093458670X\",\"ORG_PROC_DATE\":null},{\"BIZ_CD\":\"1\",\"OTRAN_BANK_NM\":\"쿠콘\",\"BIZ_NO\":\"\",\"TRAN_PROC_CD\":\"1\",\"AFLT_MANAGEMENT_NO\":\"202112001623\",\"AFLT_FEE\":\"0\",\"SVC_AMT\":\"0\",\"SER_BIZ_NO\":\"\",\"POINT_REC\":[	{	\"POINT_NM\":\"영등포사랑상품권\",	\"POINT_ID\":\"TEST1\",	\"TRAN_AMT\":\"2000\",	\"BAL_AMT\":\"198000\",	\"FACE_AMT\":\"200000\",	\"POINT_IMG_URL\":\"TESTURL111\",	\"POINT_ICON_IMG_URL\":\"TESTICONURL111\"	},	{	\"POINT_NM\":\"중구사랑상품권\",	\"POINT_ID\":\"TEST2\",	\"TRAN_AMT\":\"5000\",	\"BAL_AMT\":\"195000\",	\"FACE_AMT\":\"200000\",	\"POINT_IMG_URL\":\"TESTURL222\",	\"POINT_ICON_IMG_URL\":\"TESTICONURL222\"	}],\"ORG_PROC_SEQ\":null,\"AFLT_NM\":\"코코샤넬\",\"TRAN_AMT\":\"200\",\"AFLT_ID\":\"202112001623\",\"TRAN_OCC_DATE\":\"20211222\",\"OTRAN_TIME\":\"173449\",\"ADD_TAX_AMT\":\"18\",\"TRAN_ID\":\"H99173449574B\",\"ORG_PROC_DATE\":null},{\"BIZ_CD\":\"1\",\"OTRAN_BANK_NM\":\"쿠콘\",\"BIZ_NO\":\"\",\"TRAN_PROC_CD\":\"1\",\"AFLT_MANAGEMENT_NO\":\"202112001623\",\"AFLT_FEE\":\"0\",\"SVC_AMT\":\"0\",\"SER_BIZ_NO\":\"\",\"POINT_REC\":[{	\"POINT_NM\":\"영등포사랑상품권\",	\"POINT_ID\":\"TEST1\",	\"TRAN_AMT\":\"2000\",	\"BAL_AMT\":\"198000\",	\"FACE_AMT\":\"200000\",	\"POINT_IMG_URL\":\"TESTURL111\",	\"POINT_ICON_IMG_URL\":\"TESTICONURL111\"	},	{	\"POINT_NM\":\"중구사랑상품권\",	\"POINT_ID\":\"TEST2\",	\"TRAN_AMT\":\"5000\",	\"BAL_AMT\":\"195000\",	\"FACE_AMT\":\"200000\",	\"POINT_IMG_URL\":\"TESTURL222\",	\"POINT_ICON_IMG_URL\":\"TESTICONURL222\"	},	{	\"POINT_NM\":\"온누리상품권\",	\"POINT_ID\":\"TEST3\",	\"TRAN_AMT\":\"10000\",	\"BAL_AMT\":\"190000\",	\"FACE_AMT\":\"200000\",	\"POINT_IMG_URL\":\"TESTURL333\",	\"POINT_ICON_IMG_URL\":\"TESTICONURL333\"	}],\"ORG_PROC_SEQ\":null,\"AFLT_NM\":\"코코샤넬\",\"TRAN_AMT\":\"180\",\"AFLT_ID\":\"202112001623\",\"TRAN_OCC_DATE\":\"20211222\",\"OTRAN_TIME\":\"173313\",\"ADD_TAX_AMT\":\"16\",\"TRAN_ID\":\"H99173312761I\",\"ORG_PROC_DATE\":null}],\"TOT_AMT\":\"44764425\",\"CI\":\"D6e+qnfPqqtUzyKlb2B74UpS2XRTkTANsdZfmWq7T8ifcnWU0FSHhouuj52okCLTd+Qn1ns89ziE/KMdk1OmTA==\",\"RSLT_MSG\":\"정상\",\"MORE_YN\":\"Y\"}";
						output = JSONObject.fromObject(msg);*/

						JSONArray arr = output.getJSONArray("REC");
						JSONArray rtnList = new JSONArray();

						for(Object obj : arr){

							JSONObject tmp = (JSONObject)obj;
							JSONArray pointArr = tmp.getJSONArray("POINT_REC");
							String TRAN_OCC_DATE = tmp.getString("TRAN_OCC_DATE");
							String TRAN_ID = tmp.getString("TRAN_ID");
							String OTRAN_TIME = tmp.getString("OTRAN_TIME");
							String OTRAN_BANK_NM = tmp.getString("OTRAN_BANK_NM");

							String TRAN_PROC_CD = tmp.getString("TRAN_PROC_CD");
							String STTS = "";
							if("1".equals(TRAN_PROC_CD)){
								STTS = "결제";
							}

							else if ("2".equals(TRAN_PROC_CD)){
								STTS = "취소";
							}

							String ADD_TAX_AMT = StringUtil.null2void(tmp.getString("ADD_TAX_AMT"),"0");
							String SRV_FEE = StringUtil.null2void(tmp.getString("SRV_FEE"),"0");
							String BIZ_CD = tmp.getString("BIZ_CD");
							if("1".equals(BIZ_CD)){
								BIZ_CD = "은행";
							}
							else if("2".equals(BIZ_CD)){
								BIZ_CD = "상품권";
							}

							if(pointArr.size() > 0){

								for(int i = 0; i < pointArr.size(); i++){

									JSONObject pointTmp = pointArr.getJSONObject(i);
									String pointNm = pointTmp.getString("POINT_NM");
									String tranAmt = pointTmp.getString("TRAN_AMT");
									String pointImgUrl = pointTmp.getString("POINT_IMG_URL");

									JSONObject rtnObj = new JSONObject();
									rtnObj.put("TRSC_DT", TRAN_OCC_DATE);
									rtnObj.put("IMG_PATH", pointImgUrl);
									rtnObj.put("TRAN_ID", TRAN_ID);
									rtnObj.put("SETL_DT", TRAN_OCC_DATE.concat(OTRAN_TIME));
									rtnObj.put("POINT_AMT", tranAmt);
									rtnObj.put("OTRAN_BANK_NM", OTRAN_BANK_NM);
									rtnObj.put("POINT_NM", pointNm);

									rtnObj.put("STTS", STTS);
									rtnObj.put("DTM", OTRAN_TIME);
									rtnObj.put("TRNS_AMT", tranAmt);
									rtnObj.put("ADD_TAX_AMT", ADD_TAX_AMT);
									rtnObj.put("SRV_FEE", SRV_FEE);
									rtnObj.put("BIZ_CD", BIZ_CD);

									rtnList.add(rtnObj);
								}
							}
						}

						output.put("_MEST_CNT", rtnList.size() == 0 ? 0 : rtnList.size());
						output.put("CLASS_TOTL_AMT", output.get("TOT_AMT"));
						output.put("MORE_YN", output.get("MORE_YN"));
						output.put("SQL2", rtnList);
					}

					else if(Intent.equals("ZNN009")){

						//임시
						/*String msg = "{\"RSLT_CD\":\"0000\",\"REC\":[{\"BIZ_CD\":\"1\",\"OTRAN_BANK_NM\":\"쿠콘\",\"BIZ_NO\":\"\",\"TRAN_PROC_CD\":\"1\",\"AFLT_MANAGEMENT_NO\":\"202112001623\",\"AFLT_FEE\":\"0\",\"SVC_AMT\":\"0\",\"SER_BIZ_NO\":\"\",\"POINT_REC\":[{	\"POINT_NM\":\"영등포사랑상품권\",	\"POINT_ID\":\"TEST1\",	\"TRAN_AMT\":\"2000\",	\"BAL_AMT\":\"198000\",	\"FACE_AMT\":\"200000\",	\"POINT_IMG_URL\":\"TESTURL111\",	\"POINT_ICON_IMG_URL\":\"TESTICONURL111\"	},	{	\"POINT_NM\":\"중구사랑상품권\",	\"POINT_ID\":\"TEST2\",	\"TRAN_AMT\":\"5000\",	\"BAL_AMT\":\"195000\",	\"FACE_AMT\":\"200000\",	\"POINT_IMG_URL\":\"TESTURL222\",	\"POINT_ICON_IMG_URL\":\"TESTICONURL222\"	},	{	\"POINT_NM\":\"온누리상품권\",	\"POINT_ID\":\"TEST3\",	\"TRAN_AMT\":\"10000\",	\"BAL_AMT\":\"190000\",	\"FACE_AMT\":\"200000\",	\"POINT_IMG_URL\":\"TESTURL333\",	\"POINT_ICON_IMG_URL\":\"TESTICONURL333\"	}],\"ORG_PROC_SEQ\":null,\"AFLT_NM\":\"코코샤넬\",\"TRAN_AMT\":\"4100\",\"AFLT_ID\":\"202112001623\",\"TRAN_OCC_DATE\":\"20211223\",\"OTRAN_TIME\":\"093459\",\"ADD_TAX_AMT\":\"373\",\"TRAN_ID\":\"H99093458670X\",\"ORG_PROC_DATE\":null},{\"BIZ_CD\":\"1\",\"OTRAN_BANK_NM\":\"쿠콘\",\"BIZ_NO\":\"\",\"TRAN_PROC_CD\":\"1\",\"AFLT_MANAGEMENT_NO\":\"202112001623\",\"AFLT_FEE\":\"0\",\"SVC_AMT\":\"0\",\"SER_BIZ_NO\":\"\",\"POINT_REC\":[	{	\"POINT_NM\":\"영등포사랑상품권\",	\"POINT_ID\":\"TEST1\",	\"TRAN_AMT\":\"2000\",	\"BAL_AMT\":\"198000\",	\"FACE_AMT\":\"200000\",	\"POINT_IMG_URL\":\"TESTURL111\",	\"POINT_ICON_IMG_URL\":\"TESTICONURL111\"	},	{	\"POINT_NM\":\"중구사랑상품권\",	\"POINT_ID\":\"TEST2\",	\"TRAN_AMT\":\"5000\",	\"BAL_AMT\":\"195000\",	\"FACE_AMT\":\"200000\",	\"POINT_IMG_URL\":\"TESTURL222\",	\"POINT_ICON_IMG_URL\":\"TESTICONURL222\"	}],\"ORG_PROC_SEQ\":null,\"AFLT_NM\":\"코코샤넬\",\"TRAN_AMT\":\"200\",\"AFLT_ID\":\"202112001623\",\"TRAN_OCC_DATE\":\"20211222\",\"OTRAN_TIME\":\"173449\",\"ADD_TAX_AMT\":\"18\",\"TRAN_ID\":\"H99173449574B\",\"ORG_PROC_DATE\":null},{\"BIZ_CD\":\"1\",\"OTRAN_BANK_NM\":\"쿠콘\",\"BIZ_NO\":\"\",\"TRAN_PROC_CD\":\"1\",\"AFLT_MANAGEMENT_NO\":\"202112001623\",\"AFLT_FEE\":\"0\",\"SVC_AMT\":\"0\",\"SER_BIZ_NO\":\"\",\"POINT_REC\":[{	\"POINT_NM\":\"영등포사랑상품권\",	\"POINT_ID\":\"TEST1\",	\"TRAN_AMT\":\"2000\",	\"BAL_AMT\":\"198000\",	\"FACE_AMT\":\"200000\",	\"POINT_IMG_URL\":\"TESTURL111\",	\"POINT_ICON_IMG_URL\":\"TESTICONURL111\"	},	{	\"POINT_NM\":\"중구사랑상품권\",	\"POINT_ID\":\"TEST2\",	\"TRAN_AMT\":\"5000\",	\"BAL_AMT\":\"195000\",	\"FACE_AMT\":\"200000\",	\"POINT_IMG_URL\":\"TESTURL222\",	\"POINT_ICON_IMG_URL\":\"TESTICONURL222\"	},	{	\"POINT_NM\":\"온누리상품권\",	\"POINT_ID\":\"TEST3\",	\"TRAN_AMT\":\"10000\",	\"BAL_AMT\":\"190000\",	\"FACE_AMT\":\"200000\",	\"POINT_IMG_URL\":\"TESTURL333\",	\"POINT_ICON_IMG_URL\":\"TESTICONURL333\"	}],\"ORG_PROC_SEQ\":null,\"AFLT_NM\":\"코코샤넬\",\"TRAN_AMT\":\"180\",\"AFLT_ID\":\"202112001623\",\"TRAN_OCC_DATE\":\"20211222\",\"OTRAN_TIME\":\"173313\",\"ADD_TAX_AMT\":\"16\",\"TRAN_ID\":\"H99173312761I\",\"ORG_PROC_DATE\":null}],\"TOT_AMT\":\"44764425\",\"CI\":\"D6e+qnfPqqtUzyKlb2B74UpS2XRTkTANsdZfmWq7T8ifcnWU0FSHhouuj52okCLTd+Qn1ns89ziE/KMdk1OmTA==\",\"RSLT_MSG\":\"정상\",\"MORE_YN\":\"Y\"}";
						output = JSONObject.fromObject(msg);*/

						JSONArray arr = output.getJSONArray("REC");
						JSONArray rtnList = new JSONArray();

						for(Object obj : arr){

							JSONObject tmp = (JSONObject)obj;
							JSONArray pointArr = tmp.getJSONArray("POINT_REC");
							String TRAN_OCC_DATE = tmp.getString("TRAN_OCC_DATE");
							String TRAN_ID = tmp.getString("TRAN_ID");
							String OTRAN_TIME = tmp.getString("OTRAN_TIME");
							String OTRAN_BANK_NM = tmp.getString("OTRAN_BANK_NM");

							String TRAN_PROC_CD = tmp.getString("TRAN_PROC_CD");
							String STTS = "";
							if("1".equals(TRAN_PROC_CD)){
								STTS = "결제";
							}

							else if ("2".equals(TRAN_PROC_CD)){
								STTS = "취소";
							}

							String ADD_TAX_AMT = StringUtil.null2void(tmp.getString("ADD_TAX_AMT"),"0");
							String SRV_FEE = StringUtil.null2void(tmp.getString("SRV_FEE"),"0");
							String BIZ_CD = tmp.getString("BIZ_CD");
							if("1".equals(BIZ_CD)){
								BIZ_CD = "은행";
							}
							else if("2".equals(BIZ_CD)){
								BIZ_CD = "상품권";
							}

							if(pointArr.size() > 0){

								for(int i = 0; i < pointArr.size(); i++){

									JSONObject pointTmp = pointArr.getJSONObject(i);
									String pointNm = pointTmp.getString("POINT_NM");
									String tranAmt = pointTmp.getString("TRAN_AMT");
									String pointImgUrl = pointTmp.getString("POINT_IMG_URL");

									JSONObject rtnObj = new JSONObject();
									rtnObj.put("TRSC_DT", TRAN_OCC_DATE);
									rtnObj.put("IMG_PATH", pointImgUrl);
									rtnObj.put("TRAN_ID", TRAN_ID);
									rtnObj.put("SETL_DT", TRAN_OCC_DATE.concat(OTRAN_TIME));
									rtnObj.put("POINT_AMT", tranAmt);
									rtnObj.put("OTRAN_BANK_NM", OTRAN_BANK_NM);
									rtnObj.put("POINT_NM", pointNm);

									rtnObj.put("STTS", STTS);
									rtnObj.put("DTM", OTRAN_TIME);
									rtnObj.put("TRNS_AMT", tranAmt);
									rtnObj.put("ADD_TAX_AMT", ADD_TAX_AMT);
									rtnObj.put("SRV_FEE", SRV_FEE);
									rtnObj.put("BIZ_CD", BIZ_CD);

									rtnList.add(rtnObj);
								}
							}
						}

						output.put("_MEST_CNT", rtnList.size() == 0 ? 0 : rtnList.size());
						output.put("CLASS_TOTL_AMT", output.get("TOT_AMT"));
						output.put("MORE_YN", output.get("MORE_YN"));
						output.put("SQL2", rtnList);
					}
				}

				//API History 저장
				JexData idoIn0 = util.createIDOData("ZERO_QUES_HSTR_U001");
				idoIn0.put("API_ID", "AVATAR_API_004");

				idoIn0.put("CUST_CI", CUST_CI);
				idoIn0.put("INTE_CD", Intent);
				idoIn0.put("AFLT_NM", mest_nm);
				idoIn0.put("TRANS_DIV", biz_cd);
				idoIn0.put("SRCH_STR_DT", str_date);
				idoIn0.put("SRCH_END_DT", end_date);
				idoIn0.put("SRCH_SCH_DT", "");
				idoIn0.put("PROC_RSLT_CD", output.get("RSLT_CD"));
				idoIn0.put("PROC_RSLT_CTT", output.get("RSLT_MSG"));

				JexData idoOut0 = idoCon.execute(idoIn0);
				if (DomainUtil.isError(idoOut0)) CommonErrorHandler.comHandler(idoOut0);
			}

			//결제수수료 (AVATAR_API_005) 연동 Intent
			//	1. 제로페이 결제수수료 (ZNN003)
			else if(Intent.equals("ZNN003")){

				log("API_INPUT(제로페이 STR_DATE) 	: " + str_date);
				log("API_INPUT(제로페이 END_DATE) 	: " + end_date);
				log("API_INPUT(가맹점명 AFLT_NM) 	: " + mest_nm);

				output = ZeropayApiMgnt.data_api_005_sdk(CUST_CI, str_date, end_date, mest_nm);

				if((output.getString("RSLT_CD")).equals("0000")) {
					String tran_fee = StringUtil.null2void(output.getString("TRAN_FEE"),"0");
					String tran_amt = StringUtil.null2void(output.getString("TRAN_AMT"),"0");

					output.put("_MEST_CNT", 1);
					output.put("TRAN_TOTL", tran_amt);
					output.put("CLASS_TRAN_FEE", tran_fee);
				}

				//API History 저장
				JexData idoIn0 = util.createIDOData("ZERO_QUES_HSTR_U001");
				idoIn0.put("API_ID", "AVATAR_API_005");

				idoIn0.put("CUST_CI", CUST_CI);
				idoIn0.put("INTE_CD", Intent);
				idoIn0.put("AFLT_NM", mest_nm);
				idoIn0.put("TRANS_DIV", "");
				idoIn0.put("SRCH_STR_DT", str_date);
				idoIn0.put("SRCH_END_DT", end_date);
				idoIn0.put("SRCH_SCH_DT", "");
				idoIn0.put("PROC_RSLT_CD", output.get("RSLT_CD"));
				idoIn0.put("PROC_RSLT_CTT", output.get("RSLT_MSG"));

				JexData idoOut0 = idoCon.execute(idoIn0);
				if (DomainUtil.isError(idoOut0)) CommonErrorHandler.comHandler(idoOut0);
			}

			//입금예정 (AVATAR_API_006) 연동 Intent
			//	1. 제로페이 입금 예정액 (ZNN006)
			else if(Intent.equals("ZNN006")){

				log("API_INPUT(제로페이 SCH_DATE) 	: " + sch_date);
				log("API_INPUT(가맹점명 AFLT_NM) 	: " + mest_nm);

				//TEST DATA
				/*sch_date = "20211216";*/

				output = ZeropayApiMgnt.data_api_006_sdk(CUST_CI, sch_date, mest_nm);

				if((output.getString("RSLT_CD")).equals("0000")) {
					String tran_amt1 = StringUtil.null2void(output.getString("TRAN_AMT1"),"0");		//직불
					String tran_amt2 = StringUtil.null2void(output.getString("TRAN_AMT2"),"0");		//상품권

					BigDecimal totl_tran_amt   = new BigDecimal("00");
					totl_tran_amt = totl_tran_amt.add(new BigDecimal(tran_amt1));
					totl_tran_amt = totl_tran_amt.add(new BigDecimal(tran_amt2));

					output.put("_MEST_CNT", 1);
					output.put("CLASS_TOTL_TRAN_AMT", String.valueOf(totl_tran_amt)); 	// 입금 예정액(직불+상품권)
				}

				//API History 저장
				JexData idoIn0 = util.createIDOData("ZERO_QUES_HSTR_U001");
				idoIn0.put("API_ID", "AVATAR_API_006");

				idoIn0.put("CUST_CI", CUST_CI);
				idoIn0.put("INTE_CD", Intent);
				idoIn0.put("AFLT_NM", mest_nm);
				idoIn0.put("TRANS_DIV", "");
				idoIn0.put("SRCH_STR_DT", "");
				idoIn0.put("SRCH_END_DT", "");
				idoIn0.put("SRCH_SCH_DT", sch_date);
				idoIn0.put("PROC_RSLT_CD", output.get("RSLT_CD"));
				idoIn0.put("PROC_RSLT_CTT", output.get("RSLT_MSG"));

				JexData idoOut0 = idoCon.execute(idoIn0);
				if (DomainUtil.isError(idoOut0)) CommonErrorHandler.comHandler(idoOut0);
			}

			//입금예정상세 (AVATAR_API_007) 연동 Intent
			//	1. 제로페이 입금 예정내역
			else if(Intent.equals("ZNN007")){

				log("API_INPUT(제로페이 SCH_DATE) 	: " + sch_date);
				log("API_INPUT(제로페이 BIZ_CD) 	: " + biz_cd);
				log("API_INPUT(가맹점명 AFLT_NM) 	: " + mest_nm);

				//TEST DATA
				//sch_date = "20211216";
				output = ZeropayApiMgnt.data_api_007_sdk(CUST_CI, sch_date, biz_cd, mest_nm);

				if((output.getString("RSLT_CD")).equals("0000")) {
					String tran_amt = StringUtil.null2void(output.getString("TRAN_AMT"),"0");
					String sac_amt = StringUtil.null2void(output.getString("SAC_AMT"),"0");
					String rcv_date = output.getString("RCV_DATE");
					String tran_cnt = output.getString("TRAN_CNT");
					String aflt_fee = StringUtil.null2void(output.getString("AFLT_FEE"),"0");
					String add_tax_amt = StringUtil.null2void(output.getString("ADD_TAX_AMT"),"0");

					output.put("_MEST_CNT", 1);
					output.put("CLASS_TRAN_AMT", tran_amt);
					output.put("SAC_FEE", sac_amt); // Script에서 AMT가 걸려 FEE로 변경
					output.put("RCV_DATE", rcv_date);
					output.put("TRAN_CNT", tran_cnt);
					output.put("AFLT_FEE", aflt_fee);
					output.put("ADD_TAX_FEE", add_tax_amt);	// Script에서 AMT가 걸려 FEE로 변경
					output.put("CLASS_BIZ_DV", StringUtil.null2void(biz_dv, ""));
				}

				//API History 저장
				JexData idoIn0 = util.createIDOData("ZERO_QUES_HSTR_U001");
				idoIn0.put("API_ID", "AVATAR_API_007");

				idoIn0.put("CUST_CI", CUST_CI);
				idoIn0.put("INTE_CD", Intent);
				idoIn0.put("AFLT_NM", mest_nm);
				idoIn0.put("TRANS_DIV", biz_cd);
				idoIn0.put("SRCH_STR_DT", "");
				idoIn0.put("SRCH_END_DT", "");
				idoIn0.put("SRCH_SCH_DT", sch_date);
				idoIn0.put("PROC_RSLT_CD", output.get("RSLT_CD"));
				idoIn0.put("PROC_RSLT_CTT", output.get("RSLT_MSG"));

				JexData idoOut0 = idoCon.execute(idoIn0);
				if (DomainUtil.isError(idoOut0)) CommonErrorHandler.comHandler(idoOut0);
			}

			//가맹점정보 (AVATAR_API_008) 연동 Intent
			//	1. QR코드 (AZN001)
			//	2. 결제 가능 상품권 (AZN002)
			//	3. 가맹점 (ASP003)
			//	4. 가맹점목록 (ASP004)
			else if(Intent.equals("AZN001") || Intent.equals("AZN002")
					|| Intent.equals("ASP003") || Intent.equals("ASP004")){

				if(Intent.equals("ASP004")) {
					aflt_management_no = "";
					biz_no = "";
					ser_biz_no = "";
				}

				log("API_INPUT(가맹점명 AFLT_NM) 	: " + mest_nm);
				log("API_INPUT(가맹점관리번호AFLT_MANAGEMENT_NO) 	: " + aflt_management_no);
				log("API_INPUT(가맹점사업자번호BIZ_NO) 	: " + biz_no);
				log("API_INPUT(가맹점종사업자번호SER_BIZ_NO) 	: " + ser_biz_no);

				output = ZeropayApiMgnt.data_api_008(CUST_CI, mest_nm, aflt_management_no, biz_no, ser_biz_no);

				//API History 저장
				JexData idoIn0 = util.createIDOData("ZERO_QUES_HSTR_U001");

				idoIn0.put("API_ID", "AVATAR_API_008");

				idoIn0.put("CUST_CI", CUST_CI);
				idoIn0.put("INTE_CD", Intent);
				idoIn0.put("AFLT_NM", mest_nm);
				idoIn0.put("TRANS_DIV", "");
				idoIn0.put("SRCH_STR_DT", "");
				idoIn0.put("SRCH_END_DT", "");
				idoIn0.put("SRCH_SCH_DT", "");
				idoIn0.put("PROC_RSLT_CD", output.get("RSLT_CD"));
				idoIn0.put("PROC_RSLT_CTT", output.get("RSLT_MSG"));

				JexData idoOut0 = idoCon.execute(idoIn0);
				if (DomainUtil.isError(idoOut0)) CommonErrorHandler.comHandler(idoOut0);

				// 정상 응답
				if((output.getString("RSLT_CD")).equals("0000")) {
					JSONArray rec = output.getJSONArray("REC");
					output.put("MEST_CNT", StringUtil.isBlank(rec)? 0 : rec.size());
					output.put("_MEST_CNT", StringUtil.isBlank(rec)? 0 : rec.size());
					output.put("CNT", StringUtil.isBlank(rec)? 0 : rec.size());
					output.put("REC_ELEM_NM", "REC");
				}
				// B001: 회원정보 없음, B002: 조회내역이 없음
				else if((output.getString("RSLT_CD")).equals("B001") || (output.getString("RSLT_CD")).equals("B002")) {
					output.put("MEST_CNT", 0);
					output.put("_MEST_CNT", 0);
					output.put("CNT", 0);
					output.put("SQL2", new JSONArray());
				}
			}

			log("API_OUTPUT(제로페이 호출 원본) : " + output);

			// result 셋팅
			result = output;

			//----------------------------------------------
			//API응답외 추가정보 세팅
			//----------------------------------------------
			result.put("TRSC_DT", sch_date);

			if(!"".equals(StringUtil.null2void(str_date))) {
				if(!str_date.equals(end_date))
					result.put("FST_INQ_DT",str_date);
				else
					result.put("FST_INQ_DT", "");
			}

			if("".equals(StringUtil.null2void(end_date))) {
				result.put("LST_INQ_DT",!"".equals(StringUtil.null2void(sch_date)) ? sch_date : end_date);
			}else {
				result.put("LST_INQ_DT",end_date);
			}

			result.put("YEAR_DATE", DateTime.getInstance().getDate("YYYY"));
			result.put("MONTH_DATE", DateTime.getInstance().getDate("YYYYMM"));
			result.put("DAY_DATE", DateTime.getInstance().getDate("YYYYMMDD"));
			result.put("MEST_NM",mest_nm);
			result.put("SRCH_WD", mest_nm);
			result.put("BIZ_DV",biz_dv);
			result.put("HIS_LST_DTM", DateTime.getInstance().getDate("yyyymmddhh24miss"));
			result.put("RSLT_CD", output.getString("RSLT_CD").startsWith("C")? "9998" : output.getString("RSLT_CD"));
			result.put("RSLT_MSG", output.get("RSLT_MSG"));

			// 각 Intent별 result 셋팅 추가
			if(",ZNN002,ZNN005".indexOf(Intent) > -1) { // 제로페이 결제,결제취소
				setResultZnn002005(result, voiceInfo);
			} else if(",ZNN008,ZNN009".indexOf(Intent) > -1) { // 제로페이상품권 결제,결제취소
				setResultZnn008009(result, voiceInfo);
			} else if("SCT001".matches(Intent)) { // 매출액(SCT001)
				setResultSct001(result, voiceInfo);
			} else if("ASP003".matches(Intent)) { // 가맹점(ASP003)
				setResultAsp003(result, voiceInfo);
			} else if("AZN002".matches(Intent)) { // 결제가능 상품권(AZN002)
				setResultAzn002(result, voiceInfo);
			} else if("AZN001".matches(Intent)) { // QR코드(AZN001)
				setResultAzn001(result, voiceInfo);
			} else if("ASP004".matches(Intent)) { // 가맹점목록(ASP004)
				setResultAsp004(result, voiceInfo);
			}

		}

		log("API_OUTPUT(제로페이 호출 가공) : " + result);

		return result;
	}


	/**
	 * 제로페이 결제내역,결제취소내역(ZNN002,ZNN005) 인텐트일 경우 result 셋팅 추가
	 * @param isZNN2589
	 * @param result
	 * @param voiceInfo
	 */
	public void setResultZnn002005(JSONObject result, JSONObject voiceInfo) {
		String SRCH_WD_0 = StringUtil.null2void(voiceInfo.getString("NE-COUNTERPARTNAME"),"");
		String SRCH_WD_2 = StringUtil.null2void(voiceInfo.getString("NE-PAYMENT_METHOD1"),"");
		result.put("SRCH_WD_0", "".equals(SRCH_WD_0)? "" : (SRCH_WD_0 + "&nbsp")); // 가맹점명

		// [22.01.24 - yjk] 제로페이직불 조건값 워딩 삭제. 최하나님 요청
		// result.put("SRCH_WD_2", "".equals(SRCH_WD_2)? "" : "제로페이 직불&nbsp"); // 제로페이직불

		try {
			String SRCH_WD_1 = this.getDsdlItemNm("B2005", voiceInfo.getString("NE-ZEROPAY_PAYERNAME"));
			result.put("SRCH_WD_1",  "".equals(SRCH_WD_1)? "" : (SRCH_WD_1 + "&nbsp")); // 결제수단
		} catch (Exception e) {
			e.printStackTrace();
			result.put("SRCH_WD_1", "");
		}

	}

	/**
	 * 제로페이상품권 결제내역,결제취소내역(ZNN008,ZNN009) 인텐트일 경우 result 셋팅 추가
	 * @param isZNN2589
	 * @param result
	 * @param voiceInfo
	 */
	public void setResultZnn008009(JSONObject result, JSONObject voiceInfo) {
		String SRCH_WD_0 = StringUtil.null2void(voiceInfo.getString("NE-COUNTERPARTNAME"),"");
		String SRCH_WD_1 = StringUtil.null2void(voiceInfo.getString("NE-ZEROPAY_GIFT_CERTIFICATENAME"),"");
		result.put("SRCH_WD_0", "".equals(SRCH_WD_0)? "" : (SRCH_WD_0 + "&nbsp")); // 가맹점명
		result.put("SRCH_WD_1", "".equals(SRCH_WD_1)? "" : (SRCH_WD_1 + "&nbsp")); // 상품권명

		try {
			String SRCH_WD_2 = this.getDsdlItemNm("B2005", voiceInfo.getString("NE-ZEROPAY_PAYERNAME"));
			result.put("SRCH_WD_2",  "".equals(SRCH_WD_2)? "" : (SRCH_WD_2 + "&nbsp")); // 결제수단
		} catch (Exception e) {
			e.printStackTrace();
			result.put("SRCH_WD_2", "");
		}

	}

	/**
	 * 매출액(SCT001) 인텐트일 경우 result 셋팅 추가
	 * @param result
	 * @param voiceInfo
	 */
	public void setResultSct001(JSONObject result, JSONObject voiceInfo) {
		result.put("CLASS_TOT_AMT", result.getLong("TOT_APRV_AMT") - result.getLong("TOT_CNCL_AMT"));
		result.put("ZERO_AMT", result.get("CLASS_TOT_AMT"));
	}

	/**
	 * 가맹점(ASP003) 인텐트일 경우 result 셋팅 추가
	 * @param result
	 * @param voiceInfo
	 */
	public void setResultAsp003(JSONObject result, JSONObject voiceInfo) {
		if(result.getInt("CNT") != 1) return;

		JSONArray rec = result.getJSONArray("REC");
		JSONObject rec1 = rec.getJSONObject(0);
		result.put("AFLT_OWNER_NM", rec1.get("AFLT_OWNER_NM")); // 대표이사
		result.put("MEST_BIZ_NO", rec1.get("BIZ_NO")); // 사업자번호
		result.put("AFLT_MANAGEMENT_NO", rec1.get("AFLT_MANAGEMENT_NO")); // 가맹점관리번호
		result.put("SMALL_FEE", StringUtil.null2void(rec1.getInt("SMALL_FEE") + "", "0")); // 수수료구분
		result.put("MEST_ADDR", rec1.get("ROAD_ADDR")); // 주소
		result.put("MEST_TEL_NO", rec1.get("SHOP_TEL_NO")); // 전화번호
		result.put("MARKET_NM", rec1.get("MARKET_NM")); // 시장명
		result.put("SRCH_WD", rec1.get("AFLT_NM")); // 가맹점명

		String NE_STORE = StringUtil.null2void(voiceInfo.getString("NE-STORE"), "");
		String SCH_VAL = "";
		String SCH_TIT = "";
		String SCH_WORD = " ";
		if(!"".equals(NE_STORE)){
			if("대표".equals(NE_STORE)) SCH_VAL = result.getString("AFLT_OWNER_NM");
			else if("사업자번호".equals(NE_STORE)) SCH_VAL = result.getString("MEST_BIZ_NO");
			else if("가맹점관리번호".equals(NE_STORE)) SCH_VAL = result.getString("AFLT_MANAGEMENT_NO");
			else if("관리번호".equals(NE_STORE)) SCH_VAL = result.getString("AFLT_MANAGEMENT_NO");
			else if("수수료".equals(NE_STORE)) SCH_VAL = result.getString("SMALL_FEE") + "%";
			else if("주소".equals(NE_STORE)) SCH_VAL = result.getString("MEST_ADDR");
			else if("전화번호".equals(NE_STORE)) SCH_VAL = result.getString("MEST_TEL_NO");
			else if("시장명".equals(NE_STORE)) SCH_VAL = result.getString("MARKET_NM");

			SCH_TIT = NE_STORE + ("시장명".equals(NE_STORE)? "은" : "는") + "<br>";
			SCH_WORD = NE_STORE;
		}

		result.put("SCH_VAL", SCH_VAL);
		result.put("SCH_TIT", SCH_TIT);
		result.put("SCH_WORD", SCH_WORD);
	}

	/**
	 * 결제가능 상품권(AZN002) 인텐트일 경우 result 셋팅 추가
	 * @param result
	 * @param voiceInfo
	 */
	public void setResultAzn002(JSONObject result, JSONObject voiceInfo) {
		if(result.getInt("CNT") != 1) return;

		JSONObject rec1 = (JSONObject) result.getJSONArray("REC").get(0);
		result.put("SRCH_WD", rec1.getString("AFLT_NM"));

		JSONArray point_rec = rec1.getJSONArray("POINT_REC");
		result.put("SQL3", point_rec);
		result.put("POINT_CNT", point_rec.size());

		if(point_rec.size() == 0) {
			result.put("NOTI_TTS", " 없습니다");
			result.put("LIST_CONTENT_YN", "N");
			result.put("INFO_TXT", "정보가 없습니다");
		} else {
			result.put("NOTI_TTS", point_rec.size()+"개입니다.");
			result.put("LIST_CONTENT_YN", "Y");
			result.put("INFO_TXT", "");
		}

	}

	/**
	 * QR코드(AZN001) 인텐트일 경우 result 셋팅 추가
	 * @param isAZN001
	 * @param result
	 * @param voiceInfo
	 */
	public void setResultAzn001(JSONObject result, JSONObject voiceInfo) {
		if(result.getInt("CNT") != 1) return;

		result.put("_MEST_CNT", result.getInt("CNT"));

		JSONObject rec1 = (JSONObject) result.getJSONArray("REC").get(0);
		JSONArray qr_list = rec1.getJSONArray("QR_LIST");

		result.put("MEST_NM", rec1.get("AFLT_NM")); // 가맹점명
		result.put("SRCH_WD", rec1.get("AFLT_NM")); // 가맹점명

		if(qr_list.size() == 0) {
			result.put("LIST_CONTENT_YN", "N");
			result.put("INFO_TXT", "정보가 없습니다.");
			result.put("NOTI_TTS", "정보가 없습니다.");
		} else {
			result.put("LIST_CONTENT_YN", "Y");
			result.put("INFO_TXT", "");
			result.put("NOTI_TTS", rec1.get("입니다."));

			result.put("QR_CD", ((JSONObject)qr_list.get(0)).get("QR_CD"));
		}

	}

	/**
	 * 가맹점목록(ASP004) 인텐트일 경우 result 셋팅 추가
	 * @param isASP004
	 * @param result
	 * @param voiceInfo
	 */
	public void setResultAsp004(JSONObject result, JSONObject voiceInfo) {
		if(result.getInt("CNT") == 0) return;

		JSONArray rec1 = result.getJSONArray("REC");

		for(int i=0; i<rec1.size(); i++) {
			JSONObject rec = rec1.getJSONObject(i);
			rec.put("MEST_BIZ_NO", rec.get("BIZ_NO"));
		}

	}

	/**
	 * 구분자항목 테이블 조회
	 * @param dsdl_grp_cd
	 * @param dsdl_item_cd
	 * @return
	 * @throws Exception
	 */
	public String getDsdlItemNm(String dsdl_grp_cd, String dsdl_item_cd) throws Exception {
		if("".equals(StringUtil.null2void(dsdl_grp_cd, ""))) return "";
		if("".equals(StringUtil.null2void(dsdl_item_cd, ""))) return "";

		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();

		JexData idoIn0 = util.createIDOData("DSDL_ITEM_R005");
		String query = " AND DSDL_GRP_CD = '" + dsdl_grp_cd + "'";
		query += " AND regexp_replace(UPPER(DSDL_ITEM_CD),'((\\(주\\))| )','','g') = regexp_replace(UPPER('" + dsdl_item_cd + "'),'((\\(주\\))| )','','g')";
		IDODynamic dynamic_0= new IDODynamic();
		dynamic_0.addSQL(query);
		idoIn0.put("DYNAMIC_0", dynamic_0);

		JexData idoOut0 = idoCon.execute(idoIn0);
		if (DomainUtil.isError(idoOut0)) CommonErrorHandler.comHandler(idoOut0);

		return StringUtil.null2void(idoOut0.getString("DSDL_ITEM_NM"));
	}
}


