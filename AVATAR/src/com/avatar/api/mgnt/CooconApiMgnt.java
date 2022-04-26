package com.avatar.api.mgnt;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.URLEncoder;

import jex.json.JSONArray;
import jex.json.JSONObject;
import jex.json.parser.JSONParser;
import jex.sys.JexSystemConfig;

import com.avatar.comm.BizLogUtil;
import com.avatar.comm.CommUtil;
import com.avatar.comm.ExternalConnectUtil;
import com.avatar.comm.SvcDateUtil;

public class CooconApiMgnt {

	// 쇼핑몰(배달앱) 판매자 주문 내역 조회
	public static JSONObject data_wapi_0130(String comp_idno, String shop_cd, String sub_shop_cd, String web_id, String start_date, String end_date, String spage, String epage){
		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("COMP_IDNO"	, comp_idno); 	// 사업자번호
		inputREQ_DATA.put("SHOP_CD"		, shop_cd); 	// 쇼핑몰코드(sellBaemin:배달의민족, sellYogiyo:요기요, sellCoupangeats:쿠팡이츠)
		inputREQ_DATA.put("SUB_SHOP_CD" , sub_shop_cd); // 보조쇼핑몰코드
		inputREQ_DATA.put("WEB_ID" 		, web_id); 		// 로그인아이디
		inputREQ_DATA.put("START_DATE"  , start_date); 	// 조회시작일자
		inputREQ_DATA.put("END_DATE"    , end_date); 	// 조회종료일자
		inputREQ_DATA.put("SPAGE"       , spage); 		// 시작번호
		inputREQ_DATA.put("EPAGE"       , epage); 		// 종료번호

		return apiDataMake("0130", inputREQ_DATA);
	}
	
	// 쇼핑몰(배달앱) 판매자 정산 내역 조회
	public static JSONObject data_wapi_0129(String comp_idno, String shop_cd, String sub_shop_cd, String web_id, String start_date, String end_date, String spage, String epage){

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("COMP_IDNO"	, comp_idno); 	// 사업자번호
		inputREQ_DATA.put("SHOP_CD"		, shop_cd); 	// 쇼핑몰코드(sellBaemin:배달의민족, sellYogiyo:요기요, sellCoupangeats:쿠팡이츠)
		inputREQ_DATA.put("SUB_SHOP_CD" , sub_shop_cd); // 보조쇼핑몰코드
		inputREQ_DATA.put("WEB_ID" 		, web_id); 		// 로그인아이디
		inputREQ_DATA.put("START_DATE"  , start_date); 	// 조회시작일자
		inputREQ_DATA.put("END_DATE"    , end_date); 	// 조회종료일자
		inputREQ_DATA.put("SPAGE"       , spage); 		// 시작번호
		inputREQ_DATA.put("EPAGE"       , epage); 		// 종료번호

		return apiDataMake("0129", inputREQ_DATA);
	}
		
	// 국세청 전자세금계산서 내역 조회
	public static JSONObject data_wapi_0403(String comp_idno, String search_gubun, String appno, String search_compno, String searchDateGb, String start_date, String end_date, String spage, String epage){

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("COMP_IDNO"     , comp_idno); // 사업자번호
		inputREQ_DATA.put("SEARCH_GUBUN"  , search_gubun); // 5:매출(면세포함), 6:매입(면세포함)
		inputREQ_DATA.put("APPNO"         , appno); // 승인번호
		inputREQ_DATA.put("SEARCH_COMPNO" , search_compno); // 조회사업자번호
		inputREQ_DATA.put("SEARCH_DATE_GB", searchDateGb);	//조회시작일자(필수)1:작성일자, 2:발행일자, 3:전송일자
		inputREQ_DATA.put("START_DATE"    , start_date); // start_date
		inputREQ_DATA.put("END_DATE"      , end_date); // 조회종료일자
		inputREQ_DATA.put("SPAGE"         , spage); // 시작번호
		inputREQ_DATA.put("EPAGE"         , epage); // 종료번호

		return apiDataMake("0403", inputREQ_DATA);
	}

	// 현금영수증 매입 내역 조회
	public static JSONObject data_wapi_0401(String comp_idno, String appno, String search_compno, String start_date, String end_date, String spage, String epage){

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("COMP_IDNO"    , comp_idno); // 사업자번호
		inputREQ_DATA.put("APPNO"        , appno); // 승인번호
		inputREQ_DATA.put("SEARCH_COMPNO", search_compno); // 조회사업자번호
		inputREQ_DATA.put("START_DATE"   , start_date); // start_date
		inputREQ_DATA.put("END_DATE"     , end_date); // 조회종료일자
		inputREQ_DATA.put("SPAGE"        , spage); // 시작번호
		inputREQ_DATA.put("EPAGE"        , epage); // 종료번호

		return apiDataMake("0401", inputREQ_DATA);
	}

	// 현금영수증 매출 내역 조회
	public static JSONObject data_wapi_0402(String comp_idno, String appno, String search_compno, String start_date, String end_date, String spage, String epage){

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("COMP_IDNO"    , comp_idno); // 사업자번호
		inputREQ_DATA.put("APPNO"        , appno); // 승인번호
		inputREQ_DATA.put("SEARCH_COMPNO", search_compno); // 조회사업자번호
		inputREQ_DATA.put("START_DATE"   , start_date); // start_date
		inputREQ_DATA.put("END_DATE"     , end_date); // 조회종료일자
		inputREQ_DATA.put("SPAGE"        , spage); // 시작번호
		inputREQ_DATA.put("EPAGE"        , epage); // 종료번호

		return apiDataMake("0402", inputREQ_DATA);
	}

	// 여신 매출 매입/입금 내역 조회
	public static JSONObject data_wapi_0107(String comp_idno, String type_gbn, String start_date, String end_date, String spage, String epage){

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("COMP_IDNO"  , comp_idno);
		inputREQ_DATA.put("TYPE_GBN"   , type_gbn); //1:매입, 2:승인, 3:입금, 4:미매입승인
		inputREQ_DATA.put("START_DATE" , start_date); //매입:매입일자기준, 승인/미매입승인:거래일자기준, 입금:입금일자기준
		inputREQ_DATA.put("END_DATE"   , end_date);
		inputREQ_DATA.put("SPAGE"      , spage);
		inputREQ_DATA.put("EPAGE"      , epage);

		return apiDataMake("0107", inputREQ_DATA);
	}

	// 개인카드 한도 조회
	public static JSONObject data_wapi_0115(String comp_idno, String org_cd, String card_owner_code, String company){

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("COMP_IDNO"      , comp_idno); //사업자번호
		inputREQ_DATA.put("ORG_CD"         , org_cd); //카드사 코드 (미 입력시 사업자로 등록된 내역 모두 조회)
		inputREQ_DATA.put("CARD_OWNER_CODE", card_owner_code); //소유자 식별코드 (미 입력시 사업자로 등록된 내역 모두 조회)
		inputREQ_DATA.put("COMPANY"        , company); //BC카드인 경우 필수

		return apiDataMake("0115", inputREQ_DATA);
	}
	// 법인카드 한도 조회
	public static JSONObject data_wapi_0111(String comp_idno, String org_cd, String card_no){

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("COMP_IDNO" , comp_idno); //사업자번호
		inputREQ_DATA.put("ORG_CD"    , org_cd); //카드사 코드 (미 입력시 사업자로 등록된 내역 모두 조회)
		inputREQ_DATA.put("CARD_NO"   , card_no); // 카드번호

		return apiDataMake("0111", inputREQ_DATA);
	}

	// 법인카드 청구내역 조회
	public static JSONObject data_wapi_0110(String comp_idno, String org_cd, String card_no, String date_payment1, String spage, String epage){

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("COMP_IDNO"      , comp_idno); //사업자번호
		inputREQ_DATA.put("ORG_CD"         , org_cd); //카드사 코드 (미 입력시 사업자로 등록된 내역 모두 조회)
		inputREQ_DATA.put("CARD_NO"        , card_no);
		inputREQ_DATA.put("DATE_PAYMENT1"  , date_payment1); //청구년월 (YYYYMM)
		inputREQ_DATA.put("SPAGE"          , spage); //시작번호
		inputREQ_DATA.put("EPAGE"          , epage); //종료번호

		return apiDataMake("0110", inputREQ_DATA);

	}

	// 개인카드 청구내역 조회
	public static JSONObject data_wapi_0114(String comp_idno, String org_cd, String card_owner_code
            , String date_payment1, String payment_day, String company, String spage, String epage){

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("COMP_IDNO"      , comp_idno); //사업자번호
		inputREQ_DATA.put("ORG_CD"         , org_cd); //카드사 코드 (미 입력시 사업자로 등록된 내역 모두 조회)
		inputREQ_DATA.put("CARD_OWNER_CODE", card_owner_code); //소유자 식별코드 (미 입력시 사업자로 등록된 내역 모두 조회)
		inputREQ_DATA.put("DATE_PAYMENT1"  , date_payment1); //청구년월 (YYYYMM)
		inputREQ_DATA.put("PAYMENT_DAY"    , payment_day); //결제일 (DD)
		inputREQ_DATA.put("COMPANY"        , company); //회원사(BC카드인경우필수)
		inputREQ_DATA.put("SPAGE"          , spage); //시작번호
		inputREQ_DATA.put("EPAGE"          , epage); //종료번호

		return apiDataMake("0114", inputREQ_DATA);

	}


	// 개인카드 승인내역 조회
	public static JSONObject data_wapi_0113(String comp_idno, String org_cd, String card_owner_code, String appr_no, String company
            ,String start_date, String end_date, String spage, String epage){

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("COMP_IDNO"      , comp_idno); //사업자번호
		inputREQ_DATA.put("ORG_CD"         , org_cd); //카드사 코드
		inputREQ_DATA.put("CARD_OWNER_CODE", card_owner_code); //소유자 식별코드 (미 입력시 사업자로 등록된 내역 모두 조회)
		inputREQ_DATA.put("APPR_NO"        , appr_no); //승인번호 (미 입력시 사업자로 등록된 내역 모두 조회)
		inputREQ_DATA.put("COMPANY"        , company); //회원사(BC카드인경우필수)
		inputREQ_DATA.put("START_DATE"     , start_date); //조회시작일자
		inputREQ_DATA.put("END_DATE"       , end_date); //조회종료일자
		inputREQ_DATA.put("SPAGE"          , spage); //시작번호
		inputREQ_DATA.put("EPAGE"          , epage); //종료번호

		return apiDataMake("0113", inputREQ_DATA);

	}

	// 결재일 조회(개인)
	public static JSONObject data_wapi_0116(String comp_idno, String org_cd, String card_owner_code, String company){

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("COMP_IDNO"      , comp_idno); //사업자번호
		inputREQ_DATA.put("ORG_CD"         , org_cd); //카드사 코드 (미 입력시 사업자로 등록된 내역 모두 조회)
        inputREQ_DATA.put("CARD_OWNER_CODE", card_owner_code); //소유자 식별코드 (미 입력시 사업자로 등록된 내역 모두 조회)
        inputREQ_DATA.put("COMPANY"        , company); //BC카드인 경우 필수

		return apiDataMake("0116", inputREQ_DATA);

	}

	// 결재일 조회(법인)
	public static JSONObject data_wapi_0327(String web_id, String web_pw, String org_cd, String search_gubun){

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("WEB_ID"      , web_id); // 빠른조회 ID
		inputREQ_DATA.put("WEB_PW"      , web_pw); // 빠른조회 PW
		inputREQ_DATA.put("ORG_CD"      , org_cd);  // 카드번호
		inputREQ_DATA.put("SEARCH_GUBUN", search_gubun);  // 카드조회 구분 (1:그룹멸, 2:법인전체)

		return apiDataMake("0327", inputREQ_DATA);

	}


	public static JSONObject data_wapi_0106(String comp_idno, String bank_cd, String card_no, String appr_no, String start_date, String end_date) {

		JSONObject inputREQ_DATA = new JSONObject();


		inputREQ_DATA.put("COMP_IDNO" , comp_idno);
		inputREQ_DATA.put("BANK_CD"   , bank_cd);
		inputREQ_DATA.put("CARD_NO"   , card_no);
		inputREQ_DATA.put("APPR_NO"   , appr_no);
		inputREQ_DATA.put("START_DATE", start_date);
		inputREQ_DATA.put("END_DATE"  , end_date);
		inputREQ_DATA.put("SPAGE"     , "1");
		inputREQ_DATA.put("EPAGE"     , "99999");

		return apiDataMake("0106", inputREQ_DATA);

	}


	/**
	 * 휴폐업 조회
	 * @param corpbizno
	 * @param inq_bizno
	 * @return
	 */
	public static JSONObject itx_wapi01(String corpbizno, String inq_bizno) {

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("PRODUCT_CD", "ITX");           // 제품코드
		inputREQ_DATA.put("CORPBIZNO" , corpbizno);  	// 사업자번호
		inputREQ_DATA.put("SERVICE_CD", "TEST");  	    // 조회시작일
		inputREQ_DATA.put("INQ_BIZNO" , inq_bizno);   	// 조회대상 사업자번호

		return apiDataMake2("ITX_WAPI01", inputREQ_DATA);


	}

	/**
	 * 계좌 잔액조회
	 * @param org_cd 은행코드
	 * @param acct_no 계좌 번호
	 * @param comp_idno 사업자 번호
	 * @return
	 */
	public static JSONObject data_wapi_0108(String org_cd, String acct_no, String comp_idno) {

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("ORG_CD", org_cd);
		inputREQ_DATA.put("ACCT_NO", acct_no);
		inputREQ_DATA.put("COMP_IDNO", comp_idno);

		return apiDataMake("0108", inputREQ_DATA);

	}
	
	/**
	 * 예적금 잔액조회
	 * @param org_cd 은행코드
	 * @param acct_no 계좌 번호
	 * @param comp_idno 사업자 번호
	 * @return
	 */
	public static JSONObject data_wapi_0148(String org_cd, String acct_no, String comp_idno) {

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("ORG_CD", org_cd);
		inputREQ_DATA.put("ACCT_NO", acct_no);
		inputREQ_DATA.put("COMP_IDNO", comp_idno);

		return apiDataMake("0148", inputREQ_DATA);

	}
	
	/**
	 * 대출금 잔액조회
	 * @param org_cd 은행코드
	 * @param acct_no 계좌 번호
	 * @param comp_idno 사업자 번호
	 * @return
	 */
	public static JSONObject data_wapi_0150(String org_cd, String acct_no, String comp_idno) {

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("ORG_CD", org_cd);
		inputREQ_DATA.put("ACCT_NO", acct_no);
		inputREQ_DATA.put("COMP_IDNO", comp_idno);

		return apiDataMake("0150", inputREQ_DATA);

	}

	/**
	 * 계좌 거래내역 조회
	 * @param org_cd 은행코드
	 * @param acct_no 계좌번호
	 * @param comp_idno 사업자 번호
	 * @param start_date 조회시작일
	 * @param end_date 조회종료일
	 * @param spage 시작순번
	 * @param epage 종료순번
	 * @return
	 */
	public static JSONObject data_wapi_0109(String org_cd, String acct_no, String comp_idno, String start_date, String end_date, String spage, String epage) {

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("ORG_CD", org_cd);
		inputREQ_DATA.put("ACCT_NO", acct_no);
		inputREQ_DATA.put("COMP_IDNO", comp_idno);
		inputREQ_DATA.put("START_DATE", start_date);
		inputREQ_DATA.put("END_DATE", end_date);
		inputREQ_DATA.put("SPAGE", spage);
		inputREQ_DATA.put("EPAGE", epage);

		return apiDataMake("0109", inputREQ_DATA);
	}
	
	/**
	 * 납부할 세액 조회
	 * @param ser_idno 조회 사업자 번호
	 * @param comp_idno 사업자 번호
	 * @param vested_year 귀속년도
	 * @param tx_type 업무구분
	 * @return
	 */
	public static JSONObject data_wapi_0412(String ser_idno, String comp_idno, String vested_year, String tx_type) {

		JSONObject inputREQ_DATA = new JSONObject();

		inputREQ_DATA.put("SER_IDNO", ser_idno);
		inputREQ_DATA.put("COMP_IDNO", comp_idno);
		inputREQ_DATA.put("VESTED_YEAR", vested_year);
		inputREQ_DATA.put("TX_TYPE", tx_type);

		return apiDataMake("0412", inputREQ_DATA);
	}

	/**
	 * <pre>
	 * 계정 등록/수정/삭제
	 * </pre>
	 * @param reqData
	 * @return
	 */
	public static JSONObject data_wapi_0100(JSONObject reqData) {

	    return apiDataMake("0100", reqData);
    }

	/**
	 * <pre>
	 * 인증서 정보 등록/수정/삭제
	 * </pre>
	 * @param reqData
	 * @return
	 */
	public static JSONObject data_wapi_0200(JSONObject reqData) {

        return apiDataMake("0200", reqData);
    }

	/**
	 * api 공통
	 * @param apiId
	 * @param reqData
	 * @return
	 */
	private static JSONObject apiDataMake(String apiId, JSONObject reqData){

		reqData.put("API_KEY" , CommUtil.getCooconAPIKEY());
		reqData.put("API_ID"  , apiId);

        return call_api(JexSystemConfig.get("cooconApiCenter", "Data_Url"), reqData);

    }

	/**
	 * api 공통
	 * @param apiId
	 * @param reqData
	 * @return
	 */
	private static JSONObject apiDataMake2(String apiId, JSONObject reqData){

		JSONObject inputData = new JSONObject();

		inputData.put("SECR_KEY"   , "TEST"      ); //platAPI_KEY); // 인증키
		inputData.put("KEY"        , apiId); // "ITX_WAPI01"
		inputData.put("DOMN"       , "");
		inputData.put("TRG"        , "");
		inputData.put("SORT"       , "");
		inputData.put("PG_PER_CNT" , "");
		inputData.put("PG_NO"      , "");

		JSONArray  req_data = new JSONArray();
		req_data.add(reqData);

		inputData.put("REQ_DATA", req_data);

        return call_api(JexSystemConfig.get("cooconApiCenter", "itx_url"), inputData);

    }


	private static JSONObject call_api(String url, JSONObject input){

        StackTraceElement[] stacks = new Throwable().getStackTrace();
        StringBuffer sbLog = new StringBuffer();
        sbLog.append("\n------------------------ START ------------------------");
        sbLog.append("\nStartTime :: " + SvcDateUtil.getInstance().getDate("YYYY-MM-DD HH24:MI:SS"));

        if(stacks.length > 3)
        sbLog.append("\n[before] " + stacks[4].getClassName()+ " " + stacks[4].getMethodName());
        if(stacks.length > 2)
        sbLog.append("\n[before] " + stacks[3].getClassName()+ " " + stacks[3].getMethodName());
        sbLog.append("\n[before] " + stacks[2].getClassName()+ " " + stacks[2].getMethodName());

        JSONObject outputData = new JSONObject();

        try{
        	sbLog.append("\nurl  :: " + url);
            sbLog.append("\nInput  :: " + input.toJSONString());

            String strResultData = ExternalConnectUtil.connect(url
                    , "JSONData=" + URLEncoder.encode(input.toJSONString(), "UTF-8")
                    , url.toLowerCase().startsWith("https")?"https":"http", "UTF-8");

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

	public static void log(String str){
		CooconApiMgnt api = new CooconApiMgnt();
        //System.out.println(str);
        BizLogUtil.debug(api, str);
        BizLogUtil.info(api, str);
    }

}
