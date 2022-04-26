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
private void uploadFile(HttpServletRequest request, HttpServletResponse response)throws Exception{
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
					//(ATT_FILE_파일디렉토리명) 없을 경우 빈값
					String Filedir = "";
					
					
					/* if(item.getFieldName().length() > 8){
						Filedir = StringUtil.null2void(item.getFieldName().substring(9).toLowerCase());
					} else{
						Filedir = "";
					} */
					int i = orgFileName.lastIndexOf('.');
					if (i > 0) {
						fileExtension = orgFileName.substring(i+1);
					}
					/* if("img".equals(fileDiv)){
						System.out.println(fileDiv + " :: "+fileExtension);
						if(!"png".equalsIgnoreCase(fileExtension) && !"jpg".equalsIgnoreCase(fileExtension) 
								&& !"jpeg".equalsIgnoreCase(fileExtension) && !"gif".equalsIgnoreCase(fileExtension) 
								&& !"bmp".equalsIgnoreCase(fileExtension)){
							resp.put("RESP_CD", "9999");
							resp.put("RESP_MSG", "ERROR :: ONLY IMG FILE");
							resp.put("RESP_DATA" , ""); 
							response.getWriter().write(resp.toString());
							return;
						}
					}  */
					
					if(fileSize>0){
						strFileSize = Long.toString(fileSize);
					}
					System.out.printf("fileSize ::: ", strFileSize);

					/* String saveFileName = DateTime.getInstance().getDate("YYYYMMDD")+"_"+java.util.UUID.randomUUID()+"." + fileExtension;
					String savetmpFilePath = JexSystemConfig.get("FileStorage", "path")+Filedir+"_tmp";
					String saveFilePath = JexSystemConfig.get("FileStorage", "path")+Filedir;
					byte[] imageByteArray = IOUtils.toByteArray(item.getInputStream());
					mkdir(Filedir);
					int status = saveFile(saveFilePath, saveFileName, imageByteArray);
					saveFile(savetmpFilePath, saveFileName, imageByteArray); */
					resp.put("RESP_CD", "0000");
					/* if( status == 3 ){
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
					}*/
				}
			}
		} catch (Exception ex) {
			resp.put("RESP_CD", "9999");
			resp.put("RESP_MSG", "File Upload Failed due to " + ex);
			resp.put("RESP_DATA" , ""); 
			//request.setAttribute("message", "File Upload Failed due to " + ex);
		}
	}else{
		resp.put("RESP_CD", "8888");
		resp.put("RESP_MSG", "NO FILE");
		resp.put("RESP_DATA" , ""); 
	}

	response.getWriter().write(resp.toString());
}
%>

<%
	uploadFile(request, response);
%>