
<%@page import="org.apache.poi.ss.util.CellRangeAddress"%>
<%@page import="org.apache.poi.ss.usermodel.DataFormat"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@page import="jex.json.JSONObject"%>
<%@page import="jex.json.JSONArray"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="java.io.File"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.util.Date"%>



<%@page import="java.util.Locale"%>

<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@page import="org.apache.poi.ss.usermodel.Cell"%>
<%@page import="org.apache.poi.ss.usermodel.CellStyle"%>
<%@page import="org.apache.poi.ss.usermodel.Font"%>
<%@page import="org.apache.poi.ss.usermodel.IndexedColors"%>
<%@page import="org.apache.poi.ss.usermodel.PrintSetup"%>
<%@page import="org.apache.poi.ss.usermodel.Row"%>
<%@page import="org.apache.poi.ss.usermodel.Sheet"%>
<%@page import="org.apache.poi.ss.usermodel.Workbook"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>

<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>


<%!
	private String path = "/tmp/";

	/**
	 * 엑셀파일 생성에서 사용하는 메서드 : 기본 CellStyle을 만든다.
	 */
	private CellStyle createBorderedStyle(Workbook wb)
	{
	    CellStyle style = wb.createCellStyle();
	    // TEMP block Comment 
	    
	    style.setBorderRight(CellStyle.BORDER_THIN);
	    style.setRightBorderColor(IndexedColors.BLACK.getIndex());
	    style.setBorderBottom(CellStyle.BORDER_THIN);
	    style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
	    style.setBorderLeft(CellStyle.BORDER_THIN);
	    style.setLeftBorderColor(IndexedColors.BLACK.getIndex());
	    style.setBorderTop(CellStyle.BORDER_THIN);
	    style.setTopBorderColor(IndexedColors.BLACK.getIndex());
	    
	    return style;
	}

	/**
	 * 엑셀파일 생성에서 사용하는 메서드 : 기본 CellStyle에 특정 스타일을 추가한다.
	 */
	
	private Map<String, CellStyle> createStyles(Workbook wb)
	{
	    Map<String, CellStyle> styles = new HashMap<String, CellStyle>();
		
	    DataFormat format = wb.createDataFormat();
	    CellStyle style;
	    
	    //타이틀 스타일 설정
	    // TEMP block Comment
		
		Font titleFont = (Font) wb.createFont();
		//titleFont.setFontHeightInPoints((short)16);
		//titleFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
	
		style = wb.createCellStyle();
		style.setAlignment(CellStyle.ALIGN_CENTER);
		style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		//style.setFont(titleFont);
		styles.put("title", style);
	   
	    //헤더 스타일 설정
	    Font headerFont =(Font) wb.createFont();
	   // headerFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
	    style = createBorderedStyle(wb);
	    style.setAlignment(CellStyle.ALIGN_CENTER);
	    style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
	    style.setFillPattern(CellStyle.SOLID_FOREGROUND);
	    //style.setFont(headerFont);
	    styles.put("header", style);
	    
	    //푸터 스타일 설정
	    style = createBorderedStyle(wb);
	    style.setAlignment(CellStyle.ALIGN_RIGHT);
	    style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
	    style.setFillPattern(CellStyle.SOLID_FOREGROUND);
	    style.setDataFormat( format.getFormat("#,##0"));
	    styles.put("footer", style);
		
		
	    //홀수행 스타일 설정 : 문자
	    style = createBorderedStyle(wb);
        style.setAlignment(CellStyle.ALIGN_LEFT);
        style.setWrapText(true);
        styles.put("row_odd", style);
        
        //홀수행 스타일 설정 : 숫자(Integer)
        style = createBorderedStyle(wb);
        style.setAlignment(CellStyle.ALIGN_RIGHT);
        style.setDataFormat( format.getFormat("#,##0"));
        styles.put("row_odd_integer", style);
        
      	//홀수행 스타일 설정 : 숫자(double)
        style = createBorderedStyle(wb);
        style.setAlignment(CellStyle.ALIGN_RIGHT);
        style.setDataFormat( format.getFormat("#,##0.0########"));
        styles.put("row_odd_double", style);

        /*
		//짝수행  스타일 설정 : 문자
        style = createBorderedStyle(wb);
        style.setAlignment(CellStyle.ALIGN_LEFT);
//      style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
//	    style.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style.setWrapText(true);
        styles.put("row_even", style);
        
     	//짝수행  스타일 설정 : 숫자
        style = createBorderedStyle(wb);
        style.setAlignment(CellStyle.ALIGN_RIGHT);
        //style.setDataFormat( format.getFormat("#,##0.0####"));
        styles.put("row_even_double", style);
        */
	    return styles;
	}

	
	/**
	 * 입력받은 컬럼인덱스에 해당하는 엑셀컬럼순서 알파벳을 리텃한다.
	 */
	private String getColumnPosition(int colIdx)
	{
		//(char)('A'+i)
		String al = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		int alLength = al.length();

		int quotient = colIdx; //몫
		int remainder = -1; //나머지
		String result = "";
		do
		{
			remainder = quotient%alLength;
			quotient = quotient/alLength;
			result = String.valueOf( al.charAt( remainder ) )+result;
		}
		while( quotient > alLength );

		if( --quotient > -1 )
		{
			result = String.valueOf( al.charAt( quotient ) )+result;
		}
		
		return result;
	}
	
	
	/**
	 * 엑셀파일생성
	 * @param d
	 * @param request
	 * @param response
	 * @param pageContext
	 * @param out
	 * @return
	 */
	private void makeExcelFile(JSONObject d, HttpServletRequest request, HttpServletResponse response, PageContext pageContext, JspWriter out)  throws ServletException, IOException
	{
		String fileName ="";
		
		//타이틀정보
		JSONObject title = (JSONObject)d.get("title");
		
		//헤더
		JSONArray	colDef = (JSONArray)d.get("colDef");
		int colDefSize = colDef.size() ;
		String lastColumnPosition = getColumnPosition(colDefSize-1);
		boolean b_footer = false;
		boolean b_parent = false;
		int footerStartRowNum = 0;
		
		//데이터
		JSONArray	data = (JSONArray)d.get("data");
		
		
		Workbook wb = new HSSFWorkbook();
		Map<String, CellStyle> styles = createStyles(wb);
		Sheet sheet = wb.createSheet("sheet1");
	
        //turn off gridlines
        sheet.setDisplayGridlines(true);
        sheet.setPrintGridlines(false);
        sheet.setFitToPage(true);
        sheet.setHorizontallyCenter(true);
        PrintSetup printSetup = sheet.getPrintSetup();
        printSetup.setLandscape(true);
	
        //the following three statements are required only for HSSF
        sheet.setAutobreaks(true);
        //printSetup.setFitHeight((short)1);
        //printSetup.setFitWidth((short)1);
        printSetup.setPaperSize( PrintSetup.A4_PAPERSIZE );
		
		int startRowNum = 0;
	 	
		/***************************************
		 * 타이틀 셋팅
		 ***************************************/
		if(title!=null)
		{
			lastColumnPosition = getColumnPosition(colDefSize-1);
			
			String sTitle = (String)title.get("title");
			
			fileName = sTitle + "_" + new SimpleDateFormat("yyyyMMddHHmm", Locale.KOREAN).format(new Date())+".xls";
						
			if(sTitle!=null && sTitle.length()>0)
			{
				Row titleRow = sheet.createRow( startRowNum++ );
		        titleRow.setHeightInPoints(30);
		        Cell titleCell = titleRow.createCell(0);
		        titleCell.setCellValue( sTitle );
		        titleCell.setCellStyle(styles.get("title"));
		        sheet.addMergedRegion(CellRangeAddress.valueOf("$A$"+startRowNum+":$"+lastColumnPosition+"$"+startRowNum));
			}
	       	
	        //타이틀 보조내용 세팅
			JSONArray details = (JSONArray)title.get("details");
			int detailsSize = details==null?0:details.size();
			for(int i=0 ; i<detailsSize ; i++)
			{
				JSONObject detailRow = (JSONObject)details.get(i);
				Row detail = sheet.createRow( startRowNum++ );
				Cell detailCell = detail.createCell(0);
				detailCell.setCellValue( (String)detailRow.get("key")+" : "+ (String)detailRow.get("value"));
				sheet.addMergedRegion(CellRangeAddress.valueOf("$A$"+startRowNum+":$"+lastColumnPosition+"$"+startRowNum));
			}
			
		}
	
		/***************************************
		 * 이중 헤더 로우 셋팅
		 ***************************************/
		 
		for(int i=0 ; i<colDefSize ; i++)
		{
			JSONObject rowJson = (JSONObject)colDef.get(i);
			
			String sParent = (String)rowJson.get("parent");
			
			//이중헤더 존재여부 확인
			if(sParent != null && sParent.length() > 0)
			{
				b_parent = true;
			}
		}
		
		if(b_parent)
		{
			Row row = sheet.createRow( startRowNum++ );
			Cell cell = null;
			String tempParentValue = "";
			int tempParentNode = 0;
			for(int i=0 ; i < colDefSize ; i++)
			{
				JSONObject rowJson = (JSONObject)colDef.get(i);

				String StringParentTempValue_n = StringUtil.null2void(rowJson.getString("parent"),"");
				
				if(i != 0){
					if(!"".equals(StringParentTempValue_n)){
						if("".equals(tempParentValue)){
							cell = row.createCell(i);
							cell.setCellValue(rowJson.getString("parent"));
							cell.setCellStyle(styles.get("header"));
						}else{
							if(!tempParentValue.equals(StringParentTempValue_n) ){
								cell = row.createCell(i);
								cell.setCellValue(rowJson.getString("parent"));
								cell.setCellStyle(styles.get("header"));
								
								sheet.addMergedRegion(new CellRangeAddress(startRowNum-1, startRowNum-1, tempParentNode, i-1));
								
								tempParentValue = StringParentTempValue_n;
								tempParentNode = i;
							}else{
								if( i  == (colDefSize-1)){
									sheet.addMergedRegion(new CellRangeAddress(startRowNum-1, startRowNum-1, tempParentNode, colDefSize-1));
								}
							}
						}
					}
				}else{
					cell = row.createCell(i);
					cell.setCellValue(rowJson.getString("parent"));
					cell.setCellStyle(styles.get("header"));

					tempParentValue = StringParentTempValue_n;
					tempParentNode = i;					
				}
				
			}
		}

		/***************************************
		 * 헤더 로우 셋팅
		 ***************************************/
		Row row = sheet.createRow( startRowNum++ );
		Cell cell = null;
		
		for(int i=0 ; i<colDefSize ; i++)
		{
			JSONObject rowJson = (JSONObject)colDef.get(i);
			
			cell = row.createCell(i);
			cell.setCellValue(rowJson.getString("name"));
			cell.setCellStyle(styles.get("header"));
			
			//합계항목 존재여부확인
			if( ((Boolean)rowJson.get("sumRenderer")).booleanValue () )
			{
				b_footer = true;
			} 
		}
		
		/***************************************
		 * 데이터로우 셋팅
		 ***************************************/
		int dataSize = data.size() ;
		Object value=null;
		boolean isString = false;
		for(int i=0 ; i<dataSize ; i++)
		{
			JSONObject rowJson = (JSONObject)data.get(i);
			
			row = sheet.createRow( startRowNum++ );
			
			//푸터에서 수식에 사용하기 위해 데이터의 시작행을 저장함
			if(i==0)
			{
				footerStartRowNum = startRowNum;
			}
			
			int rowJsonSize = rowJson.size();
			for(int j=0 ; j<rowJsonSize ; j++)
			{
				cell = row.createCell(j);
				value = rowJson.get("A"+j);
				
				//숫자일경우
				if(value instanceof Integer || value instanceof Float || value instanceof Double || value instanceof Long)
				{
					cell.setCellValue( rowJson.getDouble("A"+j) );
					cell.setCellType( Cell.CELL_TYPE_NUMERIC );
					isString = false;
				}
				else
				{
					cell.setCellValue( rowJson.getString("A"+j) );
					isString = true;
				}
				
//				if(i%2==1)
//				{
					if(isString)
						cell.setCellStyle(styles.get("row_odd"));
					else if(value instanceof Float || value instanceof Double)
						cell.setCellStyle(styles.get("row_odd_double"));
					else
						cell.setCellStyle(styles.get("row_odd_integer"));
//				}
//				else
//				{
//					if(isString)
//						cell.setCellStyle(styles.get("row_even"));
//					else
//						cell.setCellStyle(styles.get("row_even_double"));
//				}
			}
		}
		
		
		/***************************************************
		 * 푸터세팅 : 컬럼정의에 sumRenderer 가 한개이상 존재할경우
		 **************************************************/
		if(b_footer)
		{
			row = sheet.createRow( startRowNum );
			String footerColPosition = "";
			for(int i=0 ; i<colDefSize ; i++)
			{
				JSONObject rowJson = (JSONObject)colDef.get(i);
				
				cell = row.createCell(i);
				
				//합계항목
				if( ((Boolean)rowJson.get("sumRenderer")).booleanValue () )
				{
					footerColPosition = getColumnPosition(i);
					cell.setCellFormula("SUM(" + (footerColPosition + footerStartRowNum) +":"+ (footerColPosition + startRowNum) + ")");
				}
				else
				{
					cell.setCellValue( "" );
				}
				cell.setCellStyle(styles.get("footer"));
			}
		}
		
		
		/***************************************
		 * 컬럼너비 조절
		 ***************************************/
		for(int i=0 ; i<colDefSize ; i++)
		{
			sheet.autoSizeColumn(i);
			if(sheet.getColumnWidth(i)/256 < 255){
            	sheet.setColumnWidth(i, (sheet.getColumnWidth(i))+1024 );  
            } else {
                sheet.setColumnWidth(i, 256*100 );
            }
		}

		try
		{
			
		    String CHARSET = "UTF-8";
		    
		    response.setContentType("application/octet-stream;charset="+CHARSET);
		
		    String userAgent = request.getHeader("User-Agent");
		    
		    if (userAgent.indexOf("MSIE 5.5") > -1) 
		    { // MS IE 5.5 이하
		      response.setHeader("Content-Disposition", "filename=" + URLEncoder.encode(fileName, "UTF-8") + ";");
		    }
		    else if (userAgent.indexOf("MSIE") > -1) 
		    { // MS IE (보통은 6.x 이상 가정)
		      response.setHeader("Content-Disposition", "attachment; filename=" + java.net.URLEncoder.encode(fileName, "UTF-8") + ";");
		    } 
		    else if (userAgent.indexOf("Trident") > -1) 
		    { // MS IE 11
		      fileName = URLEncoder.encode(fileName,"UTF-8").replaceAll("\\+", "%20");
		      response.setHeader("Content-Disposition", "attachment; filename=" + fileName + ";");
		    } 
		    else
		    { // 모질라나 오페라
		      response.setHeader("Content-Disposition", "attachment; filename=" + new String(fileName.getBytes(CHARSET), "latin1") + ";");
		    }
		    
		    out.clear();
		    out = pageContext.pushBody();
		    
		    request.getSession().setAttribute("_jgrid_download_result_", "SUCCESS");
		    request.getSession().setAttribute("_file_name", fileName);
		    request.getSession().setAttribute("_accs_ip", request.getRemoteAddr());
		    wb.write(response.getOutputStream());
		}
		catch(Exception e) 
		{
			request.getSession().setAttribute("_jgrid_download_result_", "FAIL");
			e.printStackTrace(System.out);
		}
		finally
		{
		} 
	}
%>
<%
	System.setProperty("java.awt.headless", "true");
//request.setCharacterEncoding("EUC-KR");
request.getSession().setAttribute("_jgrid_download_result_", "START");
String inputData = null;

if (ServletFileUpload.isMultipartContent(request)) 
{
    DiskFileItemFactory factory = new DiskFileItemFactory();
    
    ServletFileUpload upload = new ServletFileUpload(factory);

//    upload.setHeaderEncoding("EUC-KR");
    
    List<FileItem> list = upload.parseRequest(request);
    
    for (int i = 0 ; i < list.size() ; i++) 
    {
        FileItem fileItem = (FileItem) list.get(i);
        
		if( "json".equals(fileItem.getFieldName()) )
		{
			inputData = fileItem.getString();
		}
        
        if(!fileItem.isInMemory()){
			fileItem.delete();
        }
    }
}
	

if(inputData!=null)
{
	inputData = URLDecoder.decode(inputData, "UTF-8");
// 	System.out.println("start++++++++++++++++++++++++++");
// 	System.out.println(inputData);
// 	System.out.println("end++++++++++++++++++++++++++");
	
	JSONObject  jo2 = JSONObject.fromObject(inputData);
	
	makeExcelFile(jo2, request, response, pageContext, out);
}
%>