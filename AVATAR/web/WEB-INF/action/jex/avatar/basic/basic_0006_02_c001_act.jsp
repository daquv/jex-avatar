<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.util.StringUtil"%>

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

<%@page import="java.io.UnsupportedEncodingException"%>

<%@page import="jex.json.JSONArray"%>
<%@page import="jex.json.JSONObject"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.HashSet"%>
<%@page import="jex.sys.JexSystemConfig"%>
<%@page import="javax.xml.bind.DatatypeConverter"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.io.IOUtils"%>
<%@page import="java.io.InputStream"%>
<%@page import="jex.util.date.DateTime"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.BufferedOutputStream"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.IOException"%>

<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 1:1 문의 등록
         * @File Name    : basic_0006_02_c001_act.jsp
         * @File path    : basic
         * @author       : byeolkim89 (  )
         * @Description  : 
         * @Register Date: 20200820142055
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

        @JexDataInfo(id="basic_0006_02_c001", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

		// IDO Connection
        JexConnection idoCon = JexConnectionManager.createIDOConnection();        
     	// Get Session
        JexDataCMO userSession = SessionManager.getSession(request, response);
        String USE_INTT_ID = StringUtil.null2void(userSession.getString("USE_INTT_ID"));
        
		String RSLT_CD = "0000";
    	try{
    		idoCon.beginTransaction();
    		JexData idoIn1 = util.createIDOData("BLBD_HSTR_R002");
    		JexData idoOut1 =  idoCon.execute(idoIn1);
    		// 도메인 에러 검증
            if (DomainUtil.isError(idoOut1)) {
                if (util.getLogger().isDebug())
                {
                    util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut1));
                    util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut1));
                }
                throw new JexWebBIZException(idoOut1);
            }
    		
    		result.putAll(idoOut1);
    		
    		JexData idoIn2 = util.createIDOData("BLBD_HSTR_C001");
    	    
    		idoIn2.putAll(input);
    		idoIn2.put("BLBD_DIV"	, input.getString("BLBD_DIV"));
    		idoIn2.put("BLBD_NO"	, idoOut1.get("BLBD_NO"));
    		idoIn2.put("BLBD_TITL"	, input.getString("BLBD_TITL"));
    		idoIn2.put("APP_ID"		, StringUtil.null2void(userSession.getString("APP_ID")));
    		idoIn2.put("BLBD_CTT"	, input.getString("BLBD_CTT"));
    		idoIn2.put("FILE_YN"	, input.getString("FILE_YN"));
    		idoIn2.put("STTS"		, input.getString("STTS"));
    		idoIn2.put("TEL_NO"		, input.getString("TEL_NO"));
    		idoIn2.put("REGR_ID"	, USE_INTT_ID);
    		idoIn2.put("BLBD_DIV"	, input.getString("BLBD_DIV"));
        	
            JexData idoOut2 =  idoCon.execute(idoIn2);
        
            // 도메인 에러 검증
            if (DomainUtil.isError(idoOut2)) {
                if (util.getLogger().isDebug())
                {
                    util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut2));
                    util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut2));
                }
                throw new JexWebBIZException(idoOut2);
            }
            
            JexDataList<JexData> inputRecInsert = input.getRecord("INSERT_REC");
            if(inputRecInsert.hasNext()){
            	deleteTemp();
            }
			while(inputRecInsert.next()){
				JexData idoIn4 = util.createIDOData("BLBD_FILE_R002");
				JexData idoOut4 =  idoCon.execute(idoIn4);
				// 도메인 에러 검증
				if (DomainUtil.isError(idoOut4)) {
					if (util.getLogger().isDebug()){
						util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut4));
						util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut4));
						// result.put("RSLT_CD", "9999");
					}
					throw new JexWebBIZException(idoOut4);
				}
				
				JexData inputData = inputRecInsert.get(); 
				JexData idoIn3 = util.createIDOData("BLBD_FILE_C001");
				idoIn3.putAll(inputData);
				idoIn3.put("BLBD_NO"	, idoOut1.get("BLBD_NO"));
				idoIn3.put("FILE_NO"	, idoOut4.get("FILE_NO"));
				JexData idoOut3 =  idoCon.execute(idoIn3);
				// 도메인 에러 검증
				if (DomainUtil.isError(idoOut3)) {
					if (util.getLogger().isDebug()){
						util.getLogger().debug("Error Code   ::"+DomainUtil.getErrorCode    (idoOut3));
						util.getLogger().debug("Error Message::"+DomainUtil.getErrorMessage  (idoOut3));
						// result.put("RSLT_CD", "9999");
					}
					throw new JexWebBIZException(idoOut3);
				}
			}
            idoCon.commit();
        
    	} catch (Exception e) {
			e.printStackTrace();
			RSLT_CD = "9999";
			idoCon.rollback();
		} finally {
			idoCon.endTransaction();
		}
		result.put("RSLT_CD", RSLT_CD);

        util.setResult(result, "default");
%>
<%!
private static void delete() {
	
	String path = JexSystemConfig.get("FileStorage", "path")+"img_tmp";
	System.out.println("save_delete :: "+path);
	File folder = new File(path);
	try {
		while(folder.exists()) {
			File[] folder_list = folder.listFiles(); //파일리스트 얻어오기
			for (int j = 0; j < folder_list.length; j++) {
				folder_list[j].delete(); //파일 삭제 
				//System.out.println("파일이 삭제되었습니다.");
			}
			if(folder_list.length == 0 && folder.isDirectory()){ 
				folder.delete(); //대상폴더 삭제
				System.out.println("폴더가 삭제되었습니다.");
			}
		}
	} catch (Exception e) {
		e.getStackTrace();
	}
}
/* 
private static void deleteDir() {
	
	String path = JexSystemConfig.get("FileStorage", "path")+"/../tmp_file";
	File folder = new File(path);
	try {
		while(folder.exists()) {
			File[] folder_list = folder.listFiles(); //파일리스트 얻어오기
			for (int j = 0; j < folder_list.length; j++) {
				folder_list[j].delete(); //파일 삭제 
				//System.out.println("파일이 삭제되었습니다.");
			}
			if(folder_list.length == 0 && folder.isDirectory()){ 
				folder.delete(); //대상폴더 삭제
				System.out.println("폴더가 삭제되었습니다.");
			}
		}
	} catch (Exception e) {
		e.getStackTrace();
	}
}
 */
private void deleteTemp(){
	delete();
	//deleteDir();
}
/* private static void copy(){
	File sourceF = new File(JexSystemConfig.get("FileStorage", "path")+"../tmp_file");
	File targetF = new File(JexSystemConfig.get("FileStorage", "path"));
	File[] target_file = sourceF.listFiles();
	for (File file : target_file) {
		
		System.out.println("fileName :: "+file.getName());
		System.out.println("filePath :: "+JexSystemConfig.get("FileStorage", "path"));
		
		String saveFileName = file.getName();
		String saveFilePath = JexSystemConfig.get("FileStorage", "path");
		try {
			byte[] imageByteArray =  Files.readAllBytes(file.toPath());
			int status = saveFile(saveFilePath, saveFileName, imageByteArray);
			System.out.println(status);
		} catch (IOException e) {
			 System.out.println (e.toString());
		}
	}
}
private void Move() {
	copy();
	delete();
}

private static int saveFile(String dir, String fileName, byte b[]){
    
	int isUploaded = 1;
    BufferedOutputStream out = null;
    File f = new File(dir+"/"+fileName);
    
    try{
        if(f.exists()){
        	isUploaded = 2;
        } else{
            out = new BufferedOutputStream(new FileOutputStream(f));
            out.write(b);
            out.close();
            isUploaded = 3;
        }
       
    } catch(Exception ex){
        ex.printStackTrace();
        isUploaded = 1;
    } finally{
        try{
            if(out != null){
                out.close();
            }
        } catch(Exception exception1){}
    }
    return isUploaded;
}
 */
%>
