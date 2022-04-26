<%@page import="java.net.URLEncoder"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="jex.sys.JexSystemConfig"%>
<%@page import="jex.sys.JexSystem"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.File"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.web.util.WebCommonUtil" %>
<%@page import="jex.util.StringUtil"%>
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 파일다운로드
         * @File Name    : filedownload_0001_01_view.jsp
         * @File path    : comm
         * @author       : byeolkim89 (  )
         * @Description  : 파일다운로드
         * @Register Date: 20200821163703
         * </pre>
         *
         * ============================================================
         * 참조
         * ============================================================
         * 본 Action을 사용하는 View에서는 해당 도메인을 import하고.
         * 응답 도메인에 대한 객체를 아래와 같이 생성하여야 합니다.
         *
         **/

%>
<%
    // 공통 Util생성
    WebCommonUtil util = WebCommonUtil.getInstace(request, response);
	request.setCharacterEncoding("UTF-8");
	
	if(StringUtil.null2void(request.getParameter("FILE_NM")).contains("../")){
		out.println("잘못된 접근입니다.");
		return;
	}
	String saveFileName = StringUtil.null2void(request.getParameter("SAVE_FILE_NM"));
	String downloadUrl = StringUtil.null2void(request.getParameter("FILE_PATH"));
	String userFileName = StringUtil.null2void(request.getParameter("ORG_FILE_NM"));
	
	System.out.println(saveFileName);
	
	
	if(StringUtil.isBlank(saveFileName)){
		response.setContentType("text/html;charset=UTF-8");
		out.println(getErrorMsg());
		return;
	}
	
	InputStream 	is = null;
	OutputStream 	os = null;
	
	File file = null;
	
	try{
		
		if(downloadUrl.toLowerCase().startsWith("http")){
			
			is = new URL(downloadUrl).openStream();
			
		}else{
			
			// String downloadPath = JexSystemConfig.get("FileStorage", "noti");
			String rootPath = JexSystemConfig.get("FileStorage", "path");
			System.out.println("########################");
			System.out.println("rootPath :: " + rootPath +" downloadUrl :: " + downloadUrl);
			System.out.println("######################");
			
			if( !downloadUrl.startsWith(rootPath) ){
			    throw new Exception();
			}
			
			String downloadPath = downloadUrl;
			
			String downloadFileName = saveFileName;
			// file = new File(downloadPath+downloadUrl);
			file = new File(downloadPath+File.separator+saveFileName);
			is = new FileInputStream(file);
		
		}
		
		response.reset();
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Description", "JSP Generated Data");
		String userAgent = request.getHeader("User-Agent");
		if(userAgent.indexOf("MSIE") != -1 || userAgent.indexOf("Trident/7.0") != -1){
			saveFileName = "".equals(userFileName)?URLEncoder.encode(saveFileName, "UTF-8").replace("\\+", "\\ "):URLEncoder.encode(userFileName, "UTF-8").replace("\\+", "\\ ");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + saveFileName + "\"");
		}else{
			saveFileName = "".equals(userFileName)?URLEncoder.encode(saveFileName, "UTF-8").replaceAll("\\+", "\\ "):URLEncoder.encode(userFileName, "UTF-8").replaceAll("\\+", "\\ ");
			response.setHeader("Content-Disposition", "attachment; filename=\""+saveFileName+"\"");
			response.setHeader("Content-Type", "application/octet-stream; charset=utf-8");
		}
		if(downloadUrl.toLowerCase().startsWith("http")){
			
			out.clear();
			out = pageContext.pushBody();
			os = response.getOutputStream();
			byte b[] = new byte[1024];
			int leng = 0;
			while((leng = is.read(b)) > 0){
				os.write(b,0,leng);
			}
		}else{
			
			response.setHeader ("Content-Length", ""+file.length());
			out.clear();
			//out.close();
			out = pageContext.pushBody();
			byte b[] = new byte[(int)file.length()];
			int leng = 0;
			while( (leng = is.read(b)) > 0 ){
				response.getOutputStream().write(b,0,leng);
			}	
			
		}
		
	}catch(FileNotFoundException e){
		response.setContentType("text/html;charset=UTF-8");
		out.println(getErrorMsg());
		e.printStackTrace();
		return;
	}catch(Exception e){
		response.setContentType("text/html;charset=UTF-8");
		out.println(getErrorMsg());
		e.printStackTrace();
		return;
	}finally{
		if(is!=null) try{is.close();} catch(Exception e){}
		if(os!=null) try{os.close();} catch(Exception e){}
	}
                        
    // Action 결과 추출
%>
<%! 
public String getErrorMsg(){
	return "<script language='javascript'>alert('파일을 찾을 수 없습니다');history.back();</script>";
}
%>