<%@page import="jex.data.impl.ido.IDODynamic"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page contentType="text/html;charset=UTF-8" %>

<%@page import="jex.util.DomainUtil"%>
<%@page import="jex.log.JexLogFactory"%>
<%@page import="jex.log.JexLogger"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="jex.data.JexData"%>
<%@page import="jex.data.annotation.JexDataInfo"%>
<%@page import="jex.enums.JexDataType"%>
<%@page import="jex.data.JexDataList"%>
<%@page import="jex.web.util.WebCommonUtil"%>
<%@page import="jex.resource.cci.JexConnection"%>
<%@page import="jex.web.exception.JexWebBIZException"%>
<%@page import="jex.resource.cci.JexConnectionManager"%>

<%@page import="jex.json.JSONArray"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFFormulaEvaluator"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="org.apache.poi.ss.usermodel.*"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFFormulaEvaluator"%>
<%@page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>
<%@page import="jex.exception.JexException"%>
<%@page import="jex.exception.JexBIZException"%>
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 세무사DB 일괄등록 엑셀파일열기
         * @File Name    : txof_0102_01_r001_act.jsp
         * @File path    : admin.cstm
         * @author       : byeolkim89 (  )
         * @Description  : 세무사DB 일괄등록
         * @Register Date: 20210715155232
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

        @JexDataInfo(id="txof_0102_01_r001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();


        JexConnection idoCon = JexConnectionManager.createIDOConnection();
    	
		// Local Values
		String fileFullPath = null;
		final int START_COL = 2; //2행부터 읽기 시작
		int totlCnt = 0;
	
		// 파일읽기
		fileFullPath = input.getString("SRCH_WD");
		if (util.getLogger().isDebug()) {
			util.getLogger().debug("fileFullPath   : " + fileFullPath);
		}
	
		FileInputStream excelFile = null;
		Workbook wb = null;
		FormulaEvaluator evalutor = null;
	
		try {
			excelFile = new FileInputStream(fileFullPath);
			String exe = fileFullPath.substring(fileFullPath.lastIndexOf(".") + 1).toLowerCase();
			if ("xlsx".equals(exe)) {
				wb = new XSSFWorkbook(excelFile);
				evalutor = new XSSFFormulaEvaluator((XSSFWorkbook) wb);
			} else if ("xls".equals(exe)) {
				wb = new HSSFWorkbook(excelFile);
				evalutor = new HSSFFormulaEvaluator((HSSFWorkbook) wb);
			} else {
				//지원하지 않는 파일
				result.put("RSLT_CD", "9999");
				result.put("RSLT_MSG", "처리시 오류가 발생했습니다.\n아래 항목 확인 후 재처리 하시기 바랍니다.\n\n-잘못된 문서양식 선택시 처리불가\n-지원가능파일(xls,xlsx)외 처리불가");
				util.setResult(result, "default");
				return;
			}
	
			int rowindex = 0;
			int columnindex = 0;
	
			JSONArray jArrItemMeta = new JSONArray();
			JSONObject jsonObj = null;
	
			Sheet sheet = wb.getSheetAt(0);
			evalutor.evaluateAll();
	
			//행의 수
			int rows = sheet.getLastRowNum() + 1;
	
			util.getLogger().debug("rows   : " + rows);
	
			for (rowindex = START_COL - 1; rowindex < rows; rowindex++) {
				//행을 읽는다
				Row row = sheet.getRow(rowindex);
				if (row != null) {
					jsonObj = new JSONObject();
					//셀의 수
					int cells = row.getPhysicalNumberOfCells();
					util.getLogger().debug("cells   : " + cells);
					util.getLogger().debug("row   : " + rowindex);
					for (columnindex = 0; columnindex < cells; columnindex++) {
						//셀값을 읽는다
						Cell cell = row.getCell(columnindex);
						String value = "";
						//셀이 빈값일경우를 위한 널체크
						if (cell == null) {
							//continue;
						} else {
							//타입별로 내용 읽기
							switch (cell.getCellType()) {
							case Cell.CELL_TYPE_FORMULA:
								value = cell.getCellFormula();
								break;
							case Cell.CELL_TYPE_NUMERIC:
								if (DateUtil.isCellDateFormatted(cell)) {
									Date date = cell.getDateCellValue();
									value = new SimpleDateFormat("yyyyMMdd").format(date);
								} else {
									cell.setCellType(Cell.CELL_TYPE_STRING);
									value = cell.getStringCellValue();
								}
								break;
							case Cell.CELL_TYPE_STRING:
								value = cell.getStringCellValue() + "";
								break;
							case Cell.CELL_TYPE_BLANK:
								value = /*cell.getBooleanCellValue()+*/"";
								break;
							case Cell.CELL_TYPE_ERROR:
								value = cell.getErrorCellValue() + "";
								break;
							}
						}
						String key = "";
	
						/** 엑셀 읽기*/
						if (0 == (columnindex)) {key = "BIZ_NO";} 
						else if (1 == (columnindex)) {key = "BSNN_NM";} 
						else if (2 == (columnindex)) {key = "RPPR_NM";} 
						else if (3 == (columnindex)) {key = "BSST";}
						else if (4 == (columnindex)) {key = "TPBS";} 
						else if (5 == (columnindex)) {key = "TEL_NO";} 
						else if (6 == (columnindex)) {key = "ZPCD";}
						else if (7 == (columnindex)) {key = "ADRS";} 
						else if (8 == (columnindex)) {key = "DTL_ADRS";} 
						else if (9 == (columnindex)) {key = "MAJR_SPHR";}
						else if (10 == (columnindex)) {key = "CHRG_NM";} 
						else if (11 == (columnindex)) {key = "CHRG_TEL_NO";} 
						else if (12 == (columnindex)) {key = "COSN_DT";}
						else if (13 == (columnindex)) {key = "BIZ_LINK_CNT";}
						
	
						util.getLogger().debug("key   : " + key);
						util.getLogger().debug("value   : " + value);
	
						jsonObj.put(key, value);
					}
					String biz_no = StringUtil.null2void(jsonObj.getString("BIZ_NO"));
					/* if (!isBizNo(idoCon, util, biz_no))
						jsonObj.put("RSLT_CD", "9999");
					else
						jsonObj.put("RSLT_CD", "0000"); */
					totlCnt++;
					System.out.println(totlCnt);
					jArrItemMeta.add(jsonObj);
				}
			}
			jArrItemMeta = checkDup(jArrItemMeta);
			result.put("CNT", String.valueOf(totlCnt));
			result.put("REC", jArrItemMeta);
			result.put("RSLT_CD", "0000");
			result.put("RSLT_MSG", "정상 처리 되었습니다.");
	
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			throw e;
		} catch (IOException e) {
			e.printStackTrace();
			throw e;
		} finally {
			if (wb != null)
				try {
					wb.close();
				} catch (Exception e) {}
			if (excelFile != null)
				try {
					excelFile.close();
				} catch (Exception e) {}
			/*파일 삭제*/
			try {
				File file = new File(fileFullPath);
				file.delete();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	
		util.setResult(result, "default");
%>

<%!/*코드 체크*/
	private boolean isBizNo(JexConnection idoCon, WebCommonUtil util, String biz_no) throws JexWebBIZException, JexBIZException, JexException {

		IDODynamic dynamic1 = new IDODynamic();

		boolean result = true;
		try {
			//(중복체크)
			JexData idoIn1 = util.createIDOData("BZAQ_HEAD_WORD_R002");

			idoIn1.put("BIZ_NO", biz_no);

			JexData idoOut1 = idoCon.execute(idoIn1);

			// 도메인 에러 검증
			if (DomainUtil.isError(idoOut1)) {
				if (util.getLogger().isDebug()) {
					util.getLogger().debug("Error Code   ::" + DomainUtil.getErrorCode(idoOut1));
					util.getLogger().debug("Error Message::" + DomainUtil.getErrorMessage(idoOut1));
				}
				throw new JexWebBIZException(idoOut1);
			}

			if (!"0".equals(idoOut1.getString("CNT"))) {
				result = false;
			}

		} catch (JexWebBIZException e) {
			throw e;
		} catch (JexBIZException e) {
			throw e;
		} catch (JexException e) {
			throw e;
		}

		return result;
	}

	/** 엑셀 내 코드 중복체크 **/
	private JSONArray checkDup(JSONArray jArrItemMeta) {

		JSONArray resultJSONArray = new JSONArray();
		for (Object row : jArrItemMeta) {

			int sCnt1 = 0;
			JSONObject rowJson = (JSONObject) row;
			String biz_no = StringUtil.null2void(rowJson.getString("BIZ_NO"));
			String chrg_tel_no = StringUtil.null2void(rowJson.getString("CHRG_TEL_NO"));
			if ("".equals(biz_no)) {
				resultJSONArray.add(rowJson);
				continue;
			}
			if ("".equals(chrg_tel_no)) {
				resultJSONArray.add(rowJson);
				continue;
			}

			for (Object subRow : jArrItemMeta) {
				JSONObject subRowJson = (JSONObject) subRow;
				String sub_biz_no = StringUtil.null2void(subRowJson.getString("BIZ_NO"));
				String sub_chrg_tel_no = StringUtil.null2void(subRowJson.getString("CHRG_TEL_NO"));
				if (biz_no.equals(sub_biz_no) && chrg_tel_no.equals(sub_chrg_tel_no)) {
					sCnt1++;
				}
			}

			if (sCnt1 > 1) {
				rowJson.put("RSLT_CD", "9999");
			}
			resultJSONArray.add(rowJson);
			rowJson = null;
		}
		return resultJSONArray;
	}%>