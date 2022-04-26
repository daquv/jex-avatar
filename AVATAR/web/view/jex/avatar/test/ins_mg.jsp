<%@page contentType="text/html;charset=UTF-8" %>
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
<%@page import="jex.util.StringUtil"%>
<%!
private  final HashMap<Integer,String> errMsg;

{
	errMsg = new HashMap<Integer,String>();	
	errMsg.put(1 , "ERROR :: Error saving file");
	errMsg.put(2 , "ERROR :: File is already existed");
	errMsg.put(3 , "SUCCESS :: Save successfully");
}
private static void mkdir(String dir){
	String path = JexSystemConfig.get("FileStorage", "path")+dir+"_tmp";
	System.out.println(path);
	File Folder = new File(path);

	// 해당 디렉토리가 없을경우 디렉토리를 생성합니다.
	if (!Folder.exists()) {
		try{
			Folder.mkdir(); //폴더 생성합니다.
			System.out.println("폴더가 생성되었습니다.");
			} 
		catch(Exception e){
			e.getStackTrace();
		}
	}else {
		System.out.println("이미 폴더가 생성되어 있습니다.");
	}
}
private static int saveFile(String dir, String fileName, byte b[]){
	//mkdir(dir);
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
private void uploadFileTest(HttpServletRequest request, HttpServletResponse response)throws Exception{
	response.setContentType("application/json");
	response.setCharacterEncoding("UTF-8");
	
	JSONObject resp = new JSONObject();
	if(ServletFileUpload.isMultipartContent(request)){
		try {
			String userAgent = request.getHeader("User-Agent");
			String fileDiv = "";
			List<FileItem> multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
			for(FileItem item : multiparts){
				if(item.isFormField()){
					System.out.printf("파라미터 명 : %s, 파라미터 값 : %s \n", item.getFieldName(), item.getString("utf-8"));
					fileDiv = item.getString("utf-8");
				}else if (!item.isFormField()){
					long fileSize = item.getSize();
					System.out.println("item :: " +item);
					String strFileSize ="";
					String orgFileName = new File(item.getName()).getName();
					String fileExtension = "";
					String Filedir = "mg";
					
					System.out.println("item.getFieldName() :: " +item.getFieldName());
					/* if(item.getFieldName().length() > 8){
						Filedir = StringUtil.null2void(item.getFieldName().substring(9).toLowerCase());
					} else{
						Filedir = "";
					} */
					int i = orgFileName.lastIndexOf('.');
					if (i > 0) {
						fileExtension = orgFileName.substring(i+1);
					}
					if(fileSize>0){
						strFileSize = Long.toString(fileSize);
					}

					String saveFileName = item.getName();
					String savetmpFilePath = JexSystemConfig.get("FileStorage", "path")+Filedir+"_tmp";
					String saveFilePath = JexSystemConfig.get("FileStorage", "path")+Filedir;
					byte[] imageByteArray = IOUtils.toByteArray(item.getInputStream());
					mkdir(Filedir);
					int status = saveFile(saveFilePath, saveFileName, imageByteArray);
					saveFile(savetmpFilePath, saveFileName, imageByteArray);
					resp.put("RSLT_CD", "0000");
					if( status == 3 ){
						resp.put("RESP_CD", "0000");
						resp.put("RESP_MSG", errMsg.get(status));
						resp.put("RESP_DATA" , saveFileName);
						resp.put("ORIGIN_FILENM" , orgFileName);
						resp.put("FILE_SIZE" , strFileSize);
						resp.put("FILE_PATH" , saveFilePath);
					}else{
						resp.put("RESP_CD", "9999");
						resp.put("RESP_MSG", errMsg.get(status));
						resp.put("RESP_DATA" , ""); 
					}
				}
			}
		} catch (Exception ex) {
			resp.put("RSLT_CD", "9999");
			resp.put("RSLT_MSG", "File Upload Failed due to " + ex.getStackTrace());
			
		}
	}else{
		resp.put("RSLT_CD", "8888");
		resp.put("RSLT_MSG", "NO FILE");
	}

	response.getWriter().write(resp.toString());
}
%>

<%
	uploadFileTest(request, response);
%>
