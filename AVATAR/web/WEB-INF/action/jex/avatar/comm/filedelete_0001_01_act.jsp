<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="jex.data.impl.ido.IDODynamic"%>
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
<%@page import="jex.sys.JexSystemConfig"%>
<%@page import="java.io.File"%>
<%
        /**
         * <pre>
         * AVATAR
         * @COPYRIGHT (c) 2009-2010 WebCash, Inc. All Right Reserved.
         *
         * @File Title   : 첨부파일 삭제
         * @File Name    : filedelete_0001_01_act.jsp
         * @File path    : comm
         * @author       : byeolkim89 (  )
         * @Description  : 첨부파일 삭제
         * @Register Date: 20200821160432
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

        @JexDataInfo(id="filedelete_0001_01", type=JexDataType.WSVC)
        JexData input = util.getInputDomain();
        JexData result = util.createResultDomain();

        String fileName = StringUtil.null2void(input.getString("SAVE_FILE_NM"));
        String filePath = StringUtil.null2void(input.getString("FILE_PATH"));
        String Filedir = filePath.split("/")[filePath.split("/").length-1];
        String tmpPath = JexSystemConfig.get("FileStorage", "path")+Filedir+"_tmp"; //다운로드경로
        String downloadPath = JexSystemConfig.get("FileStorage", "path")+Filedir; //다운로드경로
      //서버상 파일 삭제
        File tmpfile = null;
        try{
         	tmpfile = new File(tmpPath,fileName);
         	File file = new File(downloadPath, fileName);
         	File folder = new File(downloadPath);
         	if( tmpfile.exists() ){
                 if(file.delete() && tmpfile.delete()){
                    System.out.println("파일삭제 성공_tmp :: "+fileName);
                     result.put("RSLT_CD","0000");
                 }else{
                     System.out.println("파일삭제 실패_tmp");
                     result.put("RSLT_CD","9999");
                 }
             }else if(!tmpfile.exists()){
            	 if(file.delete()){
                    System.out.println("파일삭제 성공 :: "+fileName);
                     result.put("RSLT_CD","0000");
                 }else{
                     System.out.println("파일삭제 실패");
                     result.put("RSLT_CD","9999");
                 }
             } else {
            	 System.out.println("파일이 존재하지 않습니다.");
                 out.println("<script language='javascript'>alert('파일을 찾을 수 없습니다');history.back();</script>");
             }
         	 if(folder.listFiles().length == 0){
         		File tmpDir = new File(tmpPath);
         		tmpDir.delete();
         	}
         }catch(Exception e){
     		response.setContentType("text/html;charset=UTF-8");
     		out.println("<script language='javascript'>alert('파일을 찾을 수 없습니다');history.back();</script>");
     		e.printStackTrace();
     		return;
     	}

        util.setResult(result, "default");

%>
