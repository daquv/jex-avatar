package com.avatar.comm;

import java.util.Iterator;

import jex.JexContext;
import jex.data.JexData;
import jex.data.JexDataList;
import jex.data.impl.ido.IDODynamic;
import jex.exception.JexBIZException;
import jex.exception.JexException;
import jex.json.JSONObject;
import jex.log.JexLogFactory;
import jex.log.JexLogger;
import jex.resource.cci.JexConnection;
import jex.resource.cci.JexConnectionManager;
import jex.util.DomainUtil;
import jex.util.StringUtil;
import jex.util.biz.JexCommonUtil;
import jex.util.date.DateTime;
/**
 * 
 */
public class QuestionUtil {
	
	private static final JexLogger LOG = JexLogFactory.getLogger(QuestionUtil.class);
	
	private QuestionUtil() {
	}

	/**
	 * 매핑변수명에 대하여 음성결과,세션정보를 이용하여 결과값을 만든다.
	 * 
	 * @param variableName 변수명
	 * @param voiceInfo 음성결과값
	 * @param sessionInfo 세션정보
	 * @return
	 */
	
	public static String changeField(String variableName, JSONObject voiceInfo, JexData sessionInfo, String inteInfo, String page_no, String page_sz)  throws JexException, JexBIZException {
		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();
		//==============================================================
		//매핑변수 만들자. 새로운 변수 생길때마다 아래에 로직 추가하자!
		//==============================================================
	
		//고정문자열 가져오기 (변수명이 value값)
		if(!StringUtil.isBlank(variableName) && variableName.startsWith("STRING.")) {
			return variableName.substring("STRING.".length());
		}
		
		JSONObject voiceInfo2 = keyUpper(voiceInfo);
		//TODO 임시로 개발서버에서만 사용!!!
		/*
		 * if(CommUtil.isdev()) { if("FST_INQ_DT".equals(variableName) && voiceInfo !=
		 * null) { return idoOut0.getString("FST_INQ_DT"); }
		 * if("LST_INQ_DT".equals(variableName) && voiceInfo != null) { return
		 * idoOut0.getString("LST_INQ_DT"); } }
		 */
		
		//TODO 아래 FST_INQ_DT, LST_INQ_DT 로직은 DB펑션으로 변경이후 삭제할것!

		String dateVariableName =  ",FST_INQ_DT,LST_INQ_DT,TRSC_DT,";
		String dateVariableNameOther =  ",OT_FST_INQ_DT,OT_LST_INQ_DT,";
		
		//조회 시작일,종료일 가져오기 
		if(dateVariableName.indexOf(variableName)>-1) {
			JexData idoIn0 = util.createIDOData("FN_INQ_DT_R001");
			String NE_B_YEAR = !"".equals(StringUtil.null2void(voiceInfo2.getString("NE-B-YEAR")))?voiceInfo2.getString("NE-B-YEAR"):voiceInfo2.getString("NE-YEAR1");
			idoIn0.put("INTE_CD", inteInfo);
			idoIn0.put("NE_DAY", voiceInfo2.getString("NE-DAY"));
			idoIn0.put("NE_B_YEAR", NE_B_YEAR);
			idoIn0.put("NE_B_MONTH", voiceInfo2.getString("NE-B-MONTH"));
			idoIn0.put("NE_B_DATE", voiceInfo2.getString("NE-B-DATE"));
			idoIn0.put("NE_DATEFROM", voiceInfo2.getString("NE-DATEFROM"));
			idoIn0.put("NE_DATETO", voiceInfo2.getString("NE-DATETO"));
			JexData idoOut0 = idoCon.execute(idoIn0);
			System.out.println("###########"+idoOut0);
			//조회시작일 가져오기
			if ("FST_INQ_DT".equals(variableName) && voiceInfo != null) {
				return !"".equals(StringUtil.null2void(idoOut0.getString("FST_INQ_DT")))? idoOut0.getString("FST_INQ_DT") : idoOut0.getString("LST_INQ_DT");
			}
			//조회종료일 가져오기
			else if ("LST_INQ_DT".equals(variableName) && voiceInfo != null) {
				if(StringUtil.null2void(voiceInfo.getString("NE-COUNTERPARTNAME"))!="" && ("SON001".equals(inteInfo)||"PON001".equals(inteInfo)))
					return "00000001";
				else
					return idoOut0.getString("LST_INQ_DT");
			}
			//거래일자로 조회 시
			else if ("TRSC_DT".equals(variableName) && voiceInfo != null) {
				if(inteInfo.equals("BDW001_1")) {
					return DateTime.getInstance().getDate("YYYYMMDD");
				} else {
					return idoOut0.getString("LST_INQ_DT");
				}
			}
		}
		
		//조회 시작일,종료일 가져오기 
		if(dateVariableNameOther.indexOf(variableName)>-1) {
			JexData idoIn0 = util.createIDOData("FN_INQ_DT_R001");
			String NE_B_YEAR = !"".equals(StringUtil.null2void(voiceInfo2.getString("NE-B-YEAR")))?voiceInfo2.getString("NE-B-YEAR"):voiceInfo2.getString("NE-YEAR1");
			idoIn0.put("INTE_CD", inteInfo+"_01");
			idoIn0.put("NE_DAY", voiceInfo2.getString("NE-DAY"));
			idoIn0.put("NE_B_YEAR", NE_B_YEAR);
			idoIn0.put("NE_B_MONTH", voiceInfo2.getString("NE-B-MONTH"));
			idoIn0.put("NE_B_DATE", voiceInfo2.getString("NE-B-DATE"));
			JexData idoOut0 = idoCon.execute(idoIn0);
			System.out.println("###########"+idoOut0);
			//조회시작일 가져오기
			if ("OT_FST_INQ_DT".equals(variableName) && voiceInfo != null) {
				return !"".equals(StringUtil.null2void(idoOut0.getString("FST_INQ_DT")))? idoOut0.getString("FST_INQ_DT") : idoOut0.getString("LST_INQ_DT");
			}
			//조회종료일 가져오기
			else if ("OT_LST_INQ_DT".equals(variableName) && voiceInfo != null) {
				return idoOut0.getString("LST_INQ_DT");
			}
		}
		//paging
		if("PAGE_NO".equals(variableName)){
			return page_no;
		} 
		if("PAGE_SZ".equals(variableName)) {
			return page_sz;
		}
		
		if("BZAQ_NM".equals(variableName)) {
			String bzaq_no = "";
			bzaq_no = voiceInfo.getString("NE-COUNTERPARTNAME");
			System.out.println(bzaq_no);
			return bzaq_no;
		}
		
		if("BANK_CD".equals(variableName)) {
			String bank_cd = "";
			if(voiceInfo.containsKey("NE-BANKNAME")) {
				JexData idoIn1 = util.createIDOData("DSDL_ITEM_R005");
				IDODynamic dynamic_0 = new IDODynamic();
				dynamic_0.addSQL("\n AND DSDL_GRP_CD = 'S1001'");
				dynamic_0.addNotBlankParameter(voiceInfo.getString("NE-BANKNAME"), "\n AND ((POSITION(DSDL_ITEM_NM IN REPLACE(?, '은행', ''))>0)");
				dynamic_0.addNotBlankParameter(voiceInfo.getString("NE-BANKNAME"), " OR (DSDL_ITEM_NM LIKE '%'||REPLACE(?, '은행', '')||'%')");
				dynamic_0.addNotBlankParameter(voiceInfo.getString("NE-BANKNAME"), " OR (RMRK LIKE '%'||REPLACE(?, '은행', '')||'%'))");
				idoIn1.put("DYNAMIC_0", dynamic_0);
				JexData idoOut1 = idoCon.execute(idoIn1);
				bank_cd = idoOut1.getString("DSDL_ITEM_CD");
			}
			else bank_cd = "";
			return bank_cd;
		}
		
		if("BANK_NM".equals(variableName)) {
			String bank_nm = "";
			if(voiceInfo.containsKey("NE-BANKNAME")) {
				bank_nm = voiceInfo.getString("NE-BANKNAME");
			}
			return bank_nm;
		}
		
		if("SRCH_WD".equals(variableName)) {
			String srch_wd = "";
			
			if("SCN002".equals(inteInfo) ) {
				srch_wd = StringUtil.null2void(voiceInfo.getString("NE-CARDNAME"));
			} else if("SCN001".equals(inteInfo)) {
				srch_wd = StringUtil.null2void(voiceInfo.getString("NE-CARDNAME"));
			} else if("PCN002".equals(inteInfo)) {
				srch_wd = StringUtil.null2void(voiceInfo.getString("NE-CARDNAME"));
			} else if("STN001".equals(inteInfo)) {
				srch_wd = StringUtil.null2void(voiceInfo.getString("NE-COUNTERPARTNAME"));
			} else if("PTN001".equals(inteInfo)) {
				srch_wd = StringUtil.null2void(voiceInfo.getString("NE-COUNTERPARTNAME"));
			} else if("BST001".equals(inteInfo)) {
				srch_wd = StringUtil.null2void(voiceInfo.getString("NE-COUNTERPARTNAME"));
			} else if("BPT001".equals(inteInfo)) {
				srch_wd = StringUtil.null2void(voiceInfo.getString("NE-COUNTERPARTNAME"));
			} else if("SON001".equals(inteInfo)) {
				srch_wd = StringUtil.null2void(voiceInfo.getString("NE-SALESUSAGE"));
			} else if("PON001".equals(inteInfo)) {
				srch_wd = StringUtil.null2void(voiceInfo.getString("NE-COSTUSAGE"));
			} else if("BDW001".equals(inteInfo)) {
				srch_wd = StringUtil.null2void(voiceInfo.getString("NE-BANKNAME"));
			} else if("BDW001_1".equals(inteInfo)) {
				srch_wd = StringUtil.null2void(voiceInfo.getString("NE-BANKNAME"));
			} else if("BDN001".equals(inteInfo) || "BWN001".equals(inteInfo) || "BDW002".equals(inteInfo)) {
				srch_wd = StringUtil.null2void(voiceInfo.getString("NE-COUNTERPARTNAME"));
			} else if("SCT001".equals(inteInfo) || "PCT001".equals(inteInfo)) {
				srch_wd = StringUtil.null2void(voiceInfo.getString("NE-COUNTERPARTNAME"));
			} else if("APN001".equals(inteInfo) || "ASN002".equals(inteInfo) || "ASP002".equals(inteInfo)) {
				// 매출처, 매입처, 거래처목록
				srch_wd = StringUtil.null2void(voiceInfo.getString("NE-COUNTERPARTNAME"));
			} else {
				if(!"".equals(StringUtil.null2void(voiceInfo.getString("NE-COUNTERPARTNAME")))) {
					if(".".equals(StringUtil.null2void(voiceInfo.getString("NE-COUNTERPARTNAME")))){
						srch_wd = "";
					} else {
						
						srch_wd = StringUtil.null2void(voiceInfo.getString("NE-COUNTERPARTNAME"));
					}
				} else if(!"".equals(StringUtil.null2void(voiceInfo.getString("NE-CARDNAME")))) {
					srch_wd = StringUtil.null2void(voiceInfo.getString("NE-CARDNAME"));
				} else if(!"".equals(StringUtil.null2void(voiceInfo.getString("NE-SALESUSAGE")))) {
					srch_wd = StringUtil.null2void(voiceInfo.getString("NE-SALESUSAGE"));
				} else if(!"".equals(StringUtil.null2void(voiceInfo.getString("NE-COSTUSAGE")))) {
					srch_wd = StringUtil.null2void(voiceInfo.getString("NE-COSTUSAGE"));
				} else if(!"".equals(StringUtil.null2void(voiceInfo.getString("NE-BANKNAME")))) {
					srch_wd = StringUtil.null2void(voiceInfo.getString("NE-BANKNAME"));
				}
			}
			/* 기존 CODE
			 * if(!"".equals(StringUtil.null2void(voiceInfo.getString("NE-COUNTERPARTNAME"))
			 * )) {
			 * if(".".equals(StringUtil.null2void(voiceInfo.getString("NE-COUNTERPARTNAME"))
			 * )){ srch_wd = ""; } else {
			 * 
			 * srch_wd = StringUtil.null2void(voiceInfo.getString("NE-COUNTERPARTNAME")); }
			 * } else
			 * if(!"".equals(StringUtil.null2void(voiceInfo.getString("NE-CARDNAME")))) {
			 * srch_wd = StringUtil.null2void(voiceInfo.getString("NE-CARDNAME")); } else
			 * if(!"".equals(StringUtil.null2void(voiceInfo.getString("NE-SALESUSAGE")))) {
			 * srch_wd = StringUtil.null2void(voiceInfo.getString("NE-SALESUSAGE")); } else
			 * if(!"".equals(StringUtil.null2void(voiceInfo.getString("NE-COSTUSAGE")))) {
			 * srch_wd = StringUtil.null2void(voiceInfo.getString("NE-COSTUSAGE")); } else
			 * if(!"".equals(StringUtil.null2void(voiceInfo.getString("NE-BANKNAME")))) {
			 * srch_wd = StringUtil.null2void(voiceInfo.getString("NE-BANKNAME")); }
			 */
			return srch_wd;
		}
		
		if("SRCH_TERMS".equals(variableName)) {
			String srch_terms = "";
			
			if(!"".equals(StringUtil.null2void(voiceInfo.getString("NE-STORE")))) {
				srch_terms = StringUtil.null2void(voiceInfo.getString("NE-STORE"));
			} else if(!"".equals(StringUtil.null2void(voiceInfo.getString("NE-SALES")))) {
				srch_terms = StringUtil.null2void(voiceInfo.getString("NE-SALES"));
			} else if(!"".equals(StringUtil.null2void(voiceInfo.getString("NE-BUY")))) {
				srch_terms = StringUtil.null2void(voiceInfo.getString("NE-BUY"));
			}
			
			return srch_terms;
		}
		
		if("BZAQ_KEY".equals(variableName)) {
			String bzaq_key = "";
			bzaq_key = voiceInfo.getString("BZAQ_KEY");
			return bzaq_key;
		}
		
		if("SRCH_DV".equals(variableName)) {
			String srch_dv = "";
			if(inteInfo.equals("BDW001_1")) {
				srch_dv = "INFO";
			}
			return srch_dv;
		}
		
		return "";
	}
	
	/**
	 * 조회일자를 추출한다.
	 * 
	 * @param variableName 변수명
	 * @param voiceInfo 음성결과값
	 * @param inteInfo 인텐트
	 * @return
	 */
	public static String getInqDt(String variableName, JSONObject voiceInfo, String inteInfo) throws JexException, JexBIZException {
		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();
		
		JSONObject voiceInfo2 = keyUpper(voiceInfo);
		String dateVariableName =  ",STR_DATE,END_DATE,SCH_DATE,";
		
		//조회 시작일,종료일 가져오기 
		if(dateVariableName.indexOf(variableName)>-1) {
			JexData idoIn0 = util.createIDOData("FN_INQ_DT_R001");
			String NE_B_YEAR = !"".equals(StringUtil.null2void(voiceInfo2.getString("NE-B-YEAR")))?voiceInfo2.getString("NE-B-YEAR"):voiceInfo2.getString("NE-YEAR1");
			idoIn0.put("INTE_CD", inteInfo);
			idoIn0.put("NE_DAY", voiceInfo2.getString("NE-DAY"));
			idoIn0.put("NE_B_YEAR", NE_B_YEAR);
			idoIn0.put("NE_B_MONTH", voiceInfo2.getString("NE-B-MONTH"));
			idoIn0.put("NE_B_DATE", voiceInfo2.getString("NE-B-DATE"));
			idoIn0.put("NE_DATEFROM", voiceInfo2.getString("NE-DATEFROM"));
			idoIn0.put("NE_DATETO", voiceInfo2.getString("NE-DATETO"));
			JexData idoOut0 = idoCon.execute(idoIn0);
			System.out.println("###########"+idoOut0);
			//조회시작일 가져오기
			if ("STR_DATE".equals(variableName) && voiceInfo != null) {
				return !"".equals(StringUtil.null2void(idoOut0.getString("FST_INQ_DT")))? idoOut0.getString("FST_INQ_DT") : idoOut0.getString("LST_INQ_DT");
			}
			//조회종료일 가져오기
			else if ("END_DATE".equals(variableName) && voiceInfo != null) {
				return idoOut0.getString("LST_INQ_DT");
			}
			//조회일자로 조회 시
			else if ("SCH_DATE".equals(variableName) && voiceInfo != null) {
				return idoOut0.getString("LST_INQ_DT");
			}
		}
		return "";
	}

	/**
	 * 조회일자를 추출한다.
	 * 
	 * @param variableName 변수명
	 * @param voiceInfo 음성결과값
	 * @param inteInfo 인텐트
	 * @return
	 */
	public static String getInqDt2(String variableName, JSONObject voiceInfo, String inteInfo) throws JexException, JexBIZException {
		JexConnection idoCon = JexConnectionManager.createIDOConnection();
		JexCommonUtil util = JexContext.getContext().getCommonUtil();
		
		JSONObject voiceInfo2 = keyUpper(voiceInfo);
		String dateVariableName =  ",STR_DATE,END_DATE,SCH_DATE,";
		
		//조회 시작일,종료일 가져오기 
		if(dateVariableName.indexOf(variableName)>-1) {
			JexData idoIn0 = util.createIDOData("FN_INQ_DT_R002");
			String INTE_CD = inteInfo;
			String NE_B_YEAR = !"".equals(StringUtil.null2void(voiceInfo2.getString("NE-B-YEAR")))?voiceInfo2.getString("NE-B-YEAR"):voiceInfo2.getString("NE-YEAR1");
			String NE_DAY = StringUtil.null2void(voiceInfo2.getString("NE-DAY"));
			String NE_B_MONTH = StringUtil.null2void(voiceInfo2.getString("NE-B-MONTH"));
			String NE_B_DATE = StringUtil.null2void(voiceInfo2.getString("NE-B-DATE"));
			String NE_DATEFROM = StringUtil.null2void(voiceInfo2.getString("NE-DATEFROM"));
			String NE_DATETO = StringUtil.null2void(voiceInfo2.getString("NE-DATETO"));
			String dynamicSql = "";
			dynamicSql += "WITH _TB_TERM AS ( ";
			dynamicSql += "SELECT ";
			dynamicSql += "	(SELECT ";
			dynamicSql += "		CASE WHEN COALESCE(FST_INQ_DT, '') = '' THEN LST_INQ_DT ";
			dynamicSql += "			 WHEN COALESCE(LST_INQ_DT, '') = '00000001' THEN LST_INQ_DT ";
			dynamicSql += "			 ELSE FST_INQ_DT END FST_INQ_DT FROM INQ_DT('" + INTE_CD + "','" + NE_DAY + "','" + NE_B_YEAR + "','" + NE_B_MONTH + "','" + NE_B_DATE + "', 'Y', '" + NE_DATEFROM + "','" + NE_DATEFROM + "')) AS _NE_DATEFROM, ";
			dynamicSql += "	(SELECT LST_INQ_DT FROM INQ_DT('" + INTE_CD + "','" + NE_DAY + "','" + NE_B_YEAR + "','" + NE_B_MONTH + "','" + NE_B_DATE + "', 'Y', '" + NE_DATETO + "','" + NE_DATETO + "')) AS _NE_DATETO ";
			dynamicSql += ") ";
			dynamicSql += ",TB_TERM AS ( ";
			dynamicSql += "SELECT CASE WHEN ( ";
			dynamicSql += "		COALESCE(SUBSTRING('" + NE_DATETO + "' FROM '[0-9]{1,2}(?=월)월'), '') !='' "; 
			dynamicSql += "		AND COALESCE('" + NE_DAY + "','')='')  "; 
			dynamicSql += "		AND SUBSTR(_NE_DATETO, '1', '6') < SUBSTR(_NE_DATEFROM, '1', '6') "; 
			dynamicSql += "		THEN TO_CHAR(TO_DATE(_NE_DATEFROM, 'YYYYMMDD')+INTERVAL '-1 YEAR','YYYYMMDD') ";			
			dynamicSql += "		WHEN ( ";
			dynamicSql += "		COALESCE(SUBSTRING( '" + NE_DATETO + "' FROM '[0-9]{1,2}(?=일)일'), '') !='' "; 
			dynamicSql += "		AND COALESCE(SUBSTRING('" + NE_DATETO + "' FROM '[0-9]{1,2}(?=월)월'), '') ='' "; 
			dynamicSql += "		AND COALESCE('" + NE_DAY + "','')='' ";
			dynamicSql += "		) AND SUBSTR(_NE_DATETO, '1', '6') < SUBSTR(_NE_DATEFROM, '1', '6') "; 
			dynamicSql += "		THEN TO_CHAR(TO_DATE(_NE_DATEFROM, 'YYYYMMDD')+INTERVAL '-1 MONTH','YYYYMMDD') ";
			dynamicSql += "	ELSE _NE_DATEFROM ";
			dynamicSql += "	END _NE_DATEFROM ";
			dynamicSql += "	, _NE_DATETO ";
			dynamicSql += "	FROM _TB_TERM ";
			dynamicSql += ") ";
			dynamicSql += "SELECT CASE WHEN FST_INQ_DT=LST_INQ_DT THEN '' ELSE FST_INQ_DT END FST_INQ_DT, LST_INQ_DT "; 
			dynamicSql += "FROM TB_TERM, INQ_DT('" + INTE_CD + "','" + NE_DAY + "','" + NE_B_YEAR + "','" + NE_B_MONTH + "','" + NE_B_DATE + "', 'Y',";
			dynamicSql += "(SELECT CASE WHEN COALESCE('" + NE_DATEFROM + "','')!='' THEN _NE_DATEFROM ELSE '' END), ";
			dynamicSql += "(SELECT CASE WHEN COALESCE('" + NE_DATETO + "','')!='' THEN _NE_DATETO ELSE '' END)) ";
			
			IDODynamic dynamic_0 = new IDODynamic();
			dynamic_0.addSQL(dynamicSql);
			idoIn0.put("DYNAMIC_0", dynamic_0);
			
			JexData idoOut0 = idoCon.execute(idoIn0);
			System.out.println("###########"+idoOut0);
			//조회시작일 가져오기
			if ("STR_DATE".equals(variableName) && voiceInfo != null) {
				return !"".equals(StringUtil.null2void(idoOut0.getString("FST_INQ_DT")))? idoOut0.getString("FST_INQ_DT") : idoOut0.getString("LST_INQ_DT");
			}
			//조회종료일 가져오기
			else if ("END_DATE".equals(variableName) && voiceInfo != null) {
				return idoOut0.getString("LST_INQ_DT");
			}
			//조회일자로 조회 시
			else if ("SCH_DATE".equals(variableName) && voiceInfo != null) {
				return idoOut0.getString("LST_INQ_DT");
			}
		}
		return "";
	}
	
	//전주월요일 조회(일월화수목금토 기준)
	private static String preWeekFirstDate(String date) {
		String ret = SvcDateUtil.getInstance().getSunday(date,"B");
		ret = DateTime.getInstance().getDate(ret,"YYYYMMDD",'D',-6);
		return ret;
	}
	
	//전주일요일 조회(일월화수목금토 기준으로는 해당주일요일)   ex) date:20200601(월) = 20200531(일)
	private static String preWeekLastDate(String date) {
		String ret = SvcDateUtil.getInstance().getSunday(date,"B");
		return ret;
	}
	
	//전월 시작일 조회
	private static String preMonthFirstDate(String date) {
		String ret = DateTime.getInstance().getDate(date, "YYYYMM", 'M', -1);
		return ret + "01";
	}
	
	//전월 마지막일 조회
	private static String preMonthLastDate(String date) {
		String ret = DateTime.getInstance().getDate(date, "YYYYMM", 'M', -1);
		return ret + SvcDateUtil.getInstance().getLastDay(ret);
	}
	//금주월요일 조회(일월화수목금토 기준)
	private static String thisWeekFirstDate(String date) {
		String ret = SvcDateUtil.getInstance().getSunday(date,"A");
		ret = DateTime.getInstance().getDate(ret,"YYYYMMDD",'D',-6);
		return ret;
	}
		
	//금주일요일 조회(일월화수목금토 기준으로는 해당주일요일)   ex) date:20200601(월) = 20200531(일)
	private static String thisWeekLastDate(String date) {
		String ret = SvcDateUtil.getInstance().getSunday(date,"A");
		return ret;
	}
	
	//금월 시작일 조회
	private static String thisMonthFirstDate(String date) {
		String ret = DateTime.getInstance().getDate(date, "YYYYMM");
		return ret + "01";
	}
	
	//금월 마지막일 조회
	private static String thisMonthLastDate(String date) {
		String ret = DateTime.getInstance().getDate(date, "YYYYMM");
		return ret + SvcDateUtil.getInstance().getLastDay(ret);
	}
	
	public static JSONObject keyUpper(JSONObject json){
		JSONObject ret = new JSONObject();
		Iterator<String> it = json.keySet().iterator();
		while (it.hasNext()) {
			String key = it.next();
			ret.put(key.toUpperCase(), json.get(key));
		}
		return ret;
	}
}
