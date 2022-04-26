package com.avatar.comm;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.util.Date;

import jex.json.JSONObject;
import jex.log.JexLogFactory;
import jex.log.JexLogger;
import jex.util.StringUtil;

public class BizLogUtil {

	private static final JexLogger LOG = JexLogFactory.getLogger(BizLogUtil.class);

    public BizLogUtil(){

    }

    private void zipLogFile(String filenm){

        try{

            String msg = "";
            Runtime rt = java.lang.Runtime.getRuntime();
            Process proc = rt.exec("gzip " + filenm);
            int inp;
            while ((inp = proc.getInputStream().read()) != -1) {
                msg+=(char)inp;
            }
            proc.waitFor();

            debug(this, "zipLogFile",  filenm + "==" + msg );
        }catch(Exception e){
            error(this, "zipLogFile", e);
        }
    }
    public void delLogFile(String filePath, String agos){

        String logRoot = ServerInfoUtil.getInstance().getlogHome();;
        String path    = "";
        String logfiledate = "";
        int adays = 0;
        int daysago2 = 0; //Integer.parseInt(SvcDateUtil.getInstance().getDate(-2,'D'));
        int filedate = 0;
        try{
            if(filePath.trim().equals("")){
                path = logRoot;
            } else {
                path = filePath;
            }

            if(agos.trim().equals("")){
                adays = ServerInfoUtil.getInstance().getlogDelDDay();
            } else {
                adays = Integer.parseInt(agos);
            }

            daysago2 = Integer.parseInt(SvcDateUtil.getInstance().getDate(adays,'D'));

            File dirp= new File(path);
            if(dirp.isDirectory()){
                File[] filelst = dirp.listFiles();
                for(int i=0; i < filelst.length; i++){
                    delLogFile(filelst[i].getPath(), Integer.toString(adays));
                }
            } else {
                String filenm = dirp.getName().replaceAll("-", "");
                if(filenm.indexOf("log") > 0){
                	int endIdx = filenm.indexOf(".log");
                    logfiledate = filenm.substring(endIdx-8, endIdx);

                    filedate = Integer.parseInt(logfiledate);
                    if(filedate < daysago2){
                        debug(this, "delLogFile", "filedate : " + Integer.toString(filedate) );
                        debug(this, "delLogFile", "daysago2 : " + Integer.toString(daysago2) );
                        debug(this, "delLogFile", "delete : " + filenm );
                        dirp.delete();
                    } else if(filedate < Integer.parseInt(SvcDateUtil.getInstance().getDate(ServerInfoUtil.getInstance().getlogZipDDay(),'D'))){
                        //zipLogFile(dirp.getName());
                    }
                }
            }

        }catch(Exception e) {
            error(this, "delLogFile", e );
        }
    }

    private static String logdir(String logdir){

        String currpath = ServerInfoUtil.getInstance().getlogHome();
        try {
        	File dirp1= new File(currpath);
            if(!dirp1.exists()) dirp1.mkdir();

        	logdir = logdir.replaceAll("org.apache.", "");
            logdir = logdir.replaceAll("jsp.WEB_002dINF.", "");
            logdir = logdir.replaceAll("005f", "");

            if(logdir.indexOf(".")<0){
                currpath = currpath + "/" +logdir;
                File dirp= new File(currpath);
                if(!dirp.exists()) dirp.mkdir();
            } else {
                String[]  logpath = logdir.split("\\.");
                if("semo".equals(logpath[0])){
                    currpath = currpath + "/classes" ;
                    File dirp= new File(currpath);
                    if(!dirp.exists()) dirp.mkdir();

                    currpath = currpath + "/" +logdir;
                    File dirp2= new File(currpath);
                    if(!dirp2.exists()) dirp2.mkdir();
                } else {
                    currpath = currpath + "/" +logpath[0];
                    File dirp= new File(currpath);
                    if(!dirp.exists()) dirp.mkdir();

                    currpath = currpath + "/" +logdir.substring(logpath[0].length()+1);
                    File dirp2= new File(currpath);
                    if(!dirp2.exists()) dirp2.mkdir();
                }
            }

        } catch (Exception e) {
        	LOG.error("semo.comm.BizLogUtil.logdir", e );
        }
        return currpath;
    }

    private static String datestr(Date dt, String formatstr){
        String rtn = "";
        java.text.SimpleDateFormat dtf = new java.text.SimpleDateFormat(formatstr);

        rtn = dtf.format(dt);
        return rtn;
    }

    private static String getErrorMsg(Throwable e) {
        return StringUtil.toString(e);
    }

    /**
     * <pre>
     * 지정된 로그 파일에 메세지를 작성한다. 만약 로그 파일이 없다면 새로 생성한다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * </pre>
     * @param filename 파일명
     * @param dirname 파일 경로
     * @param msg 메세지
     * @throws FileNotFoundException
     */
    private static void write(String filename, String dirname, String msg) throws FileNotFoundException {

        OutputStreamWriter out = null;
        FileOutputStream is = null;

        boolean apnd = true;

        try {
            filename = filename.replaceAll("005f", "");

            if(msg==null) msg = "NULL";
            else msg = new String(msg.getBytes(), "utf-8");

            File log_file= new File(logdir(dirname)+"/"+filename+"_" + datestr(new Date(),"yyyyMMdd")+".log");

            if(log_file.exists()) apnd = true;
            else apnd = false;

            is = new FileOutputStream(log_file, apnd);
            out = new OutputStreamWriter(is,"utf-8");
            out.write(msg);
            out.flush();
            out.close();

        } catch (UnsupportedEncodingException e) {
            LOG.error(e);
        } catch (FileNotFoundException e) {
            LOG.error(e);
        } catch (IOException e) {
            LOG.error(e);
        } finally {
            try {is.close();} catch (IOException e) {}
            try {out.close();} catch (IOException e) {}
        }
    }


    /**
     * <pre>
     * 로그 레벨에 따라 출력 할 로그메세지를 작성하여 출력한다.
     *
     * 로그 포멧 : [날짜][타이틀][level] : 메세지
     * </pre>
     * @param csname 호출 클래스명
     * @param packname 호출 클래스 패키지명
     * @param title 타이틀(ex. 호출 함수명)
     * @param msg 메시지
     * @param level 로그레벨(ERROR, WARN, INFO, DEBUG)
     */
    private static void log(String csname, String packname, String title, String msg, String level) {
        String strTrscDtm = datestr(new Date(), "yyyy-MM-dd HH:mm:ss:SSS");

        if(title.length() < 15){
            title = SvcStringUtil.getRightPadding(title, 15, " ");
        }
        title = title.replaceAll("org.apache.", "");
        title = title.replaceAll("jsp.WEB_002dINF.", "");
        title = title.replaceAll("005f", "");

        if(msg==null) msg = "NULL";

        StringBuffer sbMsg = new StringBuffer();
        sbMsg.append("[").append(strTrscDtm).append("][").append(title).append("][").append(level).append("] : ").append(msg).append("\n");
        try{
            write(csname, packname, sbMsg.toString());

            if("DEBUG".equals(level)) {
            	LOG.debug("["+title+"]"+msg);
            }else if("INFO".equals(level)) {
            	LOG.info("["+title+"]"+msg);
            }else if("ERROR".equals(level)) {
            	LOG.error("["+title+"]"+msg);
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            LOG.error(e);
        } catch (Exception e) {
            e.printStackTrace();
            LOG.error(e);
        }
    }

    /**
     * <pre>
     * 디버깅 - 로그레벨이 DEBUG일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][타이틀][DEBUG]메세지
     * </pre>
     * @param csname 호출 클래스명
     * @param packname 호출 클래스 패키지명
     * @param title 타이틀(ex. 호출 함수명)
     * @param msg 메세지
     */
    public static void debug(String csname, String packname, String title, String msg) {
        if(LOG.isDebug()) log(csname, packname, title, msg, "DEBUG");
    }

    /**
     * <pre>
     * 디버깅 - 로그레벨이 DEBUG일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][타이틀][DEBUG]메세지
     * </pre>
     * @param csname 호출 클래스명
     * @param packname 호출 클래스 패키지명
     * @param msg 메세지
     */
    public static void debug(String csname, String packname, String msg) {
        debug(csname, packname, csname, msg);
    }

    /**
     * <pre>
     * 디버깅 - 로그레벨이 DEBUG일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][타이틀][DEBUG]메세지
     * </pre>
     * @param callerClass 호출 클래스
     * @param title 타이틀(ex. 호출 함수명)
     * @param msg 메세지
     */
    public static void debug(Object callerClass, String title, String msg) {
        String csname = "";
        String filename = "";
        String packname = "";

        csname = callerClass.getClass().getName();
        filename = csname.substring(csname.lastIndexOf(".")+1);

        if(callerClass.getClass().getPackage() == null) {
            packname = csname.substring(0, csname.lastIndexOf(filename)-1);
        } else {
            packname = callerClass.getClass().getPackage().getName();
        }

        debug(filename, packname, filename+"."+title, msg);
    }

    /**
     * <pre>
     * 디버깅 - 로그레벨이 DEBUG일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][타이틀][DEBUG]메세지
     * </pre>
     * @param callerClass 호출 클래스
     * @param msg 메세지
     */
    public static void debug(Object callerClass, String msg) {
        String csname = "";
        String filename = "";
        String packname = "";

        csname = callerClass.getClass().getName();
        filename = csname.substring(csname.lastIndexOf(".")+1);

        if(callerClass.getClass().getPackage() == null) {
            packname = csname.substring(0, csname.lastIndexOf(filename)-1);
        } else {
            packname = callerClass.getClass().getPackage().getName();
        }

        debug(filename, packname, filename, msg);
    }

    /**
     * <pre>
     * 디버깅 - 로그레벨이 INFO일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][타이틀][DEBUG]메세지
     * </pre>
     * @param csname 호출 클래스명
     * @param packname 호출 클래스 패키지명
     * @param title 타이틀(ex. 호출 함수명)
     * @param msg 메세지
     */
    public static void info(String csname, String packname, String title, String msg) {
        if(LOG.isInfo()) log(csname, packname, title, msg, "INFO");
    }

    /**
     * <pre>
     * 디버깅 - 로그레벨이 INFO일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][타이틀][DEBUG]메세지
     * </pre>
     * @param csname 호출 클래스명
     * @param packname 호출 클래스 패키지명
     * @param msg 메세지
     */
    public static void info(String csname, String packname, String msg) {
        info(csname, packname, csname, msg);
    }

    /**
     * <pre>
     * 디버깅 - 로그레벨이 INFO일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][타이틀][DEBUG]메세지
     * </pre>
     * @param callerClass 호출 클래스
     * @param title 타이틀(ex. 호출 함수명)
     * @param msg 메세지
     */
    public static void info(Object callerClass, String title, String msg) {
        String csname = "";
        String filename = "";
        String packname = "";

        csname = callerClass.getClass().getName();
        filename = csname.substring(csname.lastIndexOf(".")+1);

        if(callerClass.getClass().getPackage() == null) {
            packname = csname.substring(0, csname.lastIndexOf(filename)-1);
        } else {
            packname = callerClass.getClass().getPackage().getName();
        }

        info(filename, packname, filename+"."+title, msg);
    }

    /**
     * <pre>
     * 디버깅 - 로그레벨이 INFO일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][타이틀][DEBUG]메세지
     * </pre>
     * @param callerClass 호출 클래스
     * @param msg 메세지
     */
    public static void info(Object callerClass, String msg) {
        String csname = "";
        String filename = "";
        String packname = "";

        csname = callerClass.getClass().getName();
        filename = csname.substring(csname.lastIndexOf(".")+1);

        if(callerClass.getClass().getPackage() == null) {
            packname = csname.substring(0, csname.lastIndexOf(filename)-1);
        } else {
            packname = callerClass.getClass().getPackage().getName();
        }

        info(filename, packname, filename, msg);
    }

    /**
     * <pre>
     * 에러 - 로그레벨이 ERROR일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][타이틀][ERROR]메세지
     * </pre>
     * @param csname 호출 클래스명
     * @param packname 호출 클래스 패키지명
     * @param title 타이틀(ex. 호출 함수명)
     * @param msg 메시지
     */
    public static void error(String csname, String packname, String title, String msg) {
        if(LOG.isError()) log(csname, packname, title, msg, "ERROR");
    }

    /**
     * <pre>
     * 에러 - 로그레벨이 ERROR일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][클래스명][ERROR]메세지
     * </pre>
     * @param csname 호출 클래스명
     * @param packname 호출 클래스 패키지명
     * @param msg 메시지
     */
    public static void error(String csname, String packname, String msg) {
        error(csname, packname, csname, msg);
    }

    /**
     * <pre>
     * 에러 - 로그레벨이 ERROR일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][타이틀][ERROR]메세지
     * </pre>
     * @param csname 호출 클래스명
     * @param packname 호출 클래스 패키지명
     * @param title 타이틀(ex. 호출 함수명)
     * @param e Throwable
     */
    public static void error(String csname, String packname, String title, Throwable e) {
        error(csname, packname, csname+"."+title, getErrorMsg(e)) ;
    }

    /**
     * <pre>
     * 에러 - 로그레벨이 ERROR일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][클래스명][ERROR]메세지
     * </pre>
     * @param csname 호출 클래스명
     * @param packname 호출 클래스 패키지명
     * @param title 타이틀(ex. 호출 함수명)
     * @param e Throwable
     */
    public static void error(String csname, String packname, Throwable e) {
        error(csname, packname, csname, getErrorMsg(e)) ;
    }

    /**
     * <pre>
     * 에러 - 로그레벨이 ERROR일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][타이틀][ERROR]메세지
     * </pre>
     * @param csname 호출 클래스명
     * @param packname 호출 클래스 패키지명
     * @param title 타이틀(ex. 호출 함수명)
     * @param e Throwable
     * @param msg 메시지
     */
    public static void error(String csname, String packname, String title, Throwable e, String msg) {
        StringBuffer sbMsg = new StringBuffer();

        sbMsg.append(msg).append("\n");
        sbMsg.append(getErrorMsg(e));

        error(csname, packname, csname+"."+title, sbMsg.toString()) ;
    }

    /**
     * <pre>
     * 에러 - 로그레벨이 ERROR일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][클래스명][ERROR]메세지
     * </pre>
     * @param csname 호출 클래스명
     * @param packname 호출 클래스 패키지명
     * @param e Throwable
     * @param msg 메시지
     */
    public static void error(String csname, String packname, Throwable e, String msg) {
        StringBuffer sbMsg = new StringBuffer();

        sbMsg.append(msg).append("\n");
        sbMsg.append(getErrorMsg(e));

        error(csname, packname, csname, sbMsg.toString()) ;
    }

    /**
     * <pre>
     * 에러 - 로그레벨이 ERROR일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][타이틀][ERROR]메세지
     * </pre>
     * @param callerClass 호출 클래스
     * @param title 타이틀(ex. 호출 함수명)
     * @param msg 예외 메시지
     */
    public static void error(Object callerClass, String title, String msg) {
        String csname = "";
        String filename = "";
        String packname = "";

        csname = callerClass.getClass().getName();
        filename = csname.substring(csname.lastIndexOf(".")+1);

        if(callerClass.getClass().getPackage() == null) {
            packname = csname.substring(0, csname.lastIndexOf(filename)-1);
        } else {
            packname = callerClass.getClass().getPackage().getName();
        }

        error(filename, packname, filename+"."+title, msg) ;
    }

    /**
     * <pre>
     * 에러 - 로그레벨이 ERROR일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][클래스명][ERROR]메세지
     * </pre>
     * @param callerClass 호출 클래스
     * @param title 타이틀(ex. 호출 함수명)
     * @param msg 예외 메시지
     */
    public static void error(Object callerClass, String msg) {
        String csname = "";
        String filename = "";
        String packname = "";

        csname = callerClass.getClass().getName();
        filename = csname.substring(csname.lastIndexOf(".")+1);

        if(callerClass.getClass().getPackage() == null) {
            packname = csname.substring(0, csname.lastIndexOf(filename)-1);
        } else {
            packname = callerClass.getClass().getPackage().getName();
        }

        error(filename, packname, filename, msg) ;
    }

    /**
     * <pre>
     * 에러 - 로그레벨이 ERROR일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][타이틀][ERROR]메세지
     * </pre>
     * @param callerClass 호출 클래스
     * @param title 타이틀(ex. 호출 함수명)
     * @param e Throwable
     */
    public static void error(Object callerClass, String title, Throwable e) {
        error(callerClass, title, getErrorMsg(e)) ;
    }

    /**
     * <pre>
     * 에러 - 로그레벨이 ERROR일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][타이틀][ERROR]메세지
     * </pre>
     * @param callerClass 호출 클래스
     * @param title 타이틀(ex. 호출 함수명)
     * @param e Throwable
     */
    public static void error(Object callerClass, Throwable e) {
        error(callerClass, getErrorMsg(e)) ;
    }

    /**
     * <pre>
     * 에러 - 로그레벨이 ERROR일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][타이틀][ERROR]메세지
     * </pre>
     * @param callerClass 호출 클래스
     * @param title 타이틀(ex. 호출 함수명)
     * @param e Throwable
     * @param msg 메시지
     */
    public static void error(Object callerClass, String title, Throwable e, String msg) {
        StringBuffer sbMsg = new StringBuffer();

        sbMsg.append(msg).append("\n");
        sbMsg.append(getErrorMsg(e));

        error(callerClass, title, sbMsg.toString()) ;
    }

    /**
     * <pre>
     * 에러 - 로그레벨이 ERROR일 경우 사용할 수 있다.
     *
     * 로그디렉토리/패키지명/클래스네임_날짜.log
     * 로그 포멧 : [날짜][타이틀][ERROR]메세지
     * </pre>
     * @param callerClass 호출 클래스
     * @param title 타이틀(ex. 호출 함수명)
     * @param e Throwable
     * @param msg 메시지
     */
    public static void error(Object callerClass, Throwable e, String msg) {
        StringBuffer sbMsg = new StringBuffer();

        sbMsg.append(msg).append("\n");
        sbMsg.append(getErrorMsg(e));

        error(callerClass, sbMsg.toString()) ;
    }

    public static void apilog(String seqno, String trdate, String inout, String surl, JSONObject ogj){
        String logfile  = "TRLOG";
        String logdir   = "APILOG";
        String hosname  = ServerInfoUtil.getInstance().getHostName();

        StringBuffer logtitle = new StringBuffer();
        logtitle.append("[").append(SvcStringUtil.getRightPadding(hosname, 20, " ")).append("]");
        logtitle.append("[").append(SvcStringUtil.getRightPadding(seqno  , 15, " ")).append("]");
        logtitle.append("[").append(SvcStringUtil.getRightPadding(trdate ,  8, " ")).append("]");
        logtitle.append("[").append(SvcStringUtil.getRightPadding(inout  ,  7, " ")).append("]");
        logtitle.append("[").append(SvcStringUtil.getRightPadding(surl   , 50, " ")).append("]");

        debug(logfile, logdir, logtitle.toString(), ogj.toJSONString());
    }
    public static void apilog(String seqno, String trdate, String inout, String surl, String ogj){
        String logfile  = "TRLOG";
        String logdir   = "APILOG";
        String hosname  = ServerInfoUtil.getInstance().getHostName();

        StringBuffer logtitle = new StringBuffer();
        logtitle.append("[").append(SvcStringUtil.getRightPadding(hosname, 20, " ")).append("]");
        logtitle.append("[").append(SvcStringUtil.getRightPadding(seqno  , 15, " ")).append("]");
        logtitle.append("[").append(SvcStringUtil.getRightPadding(trdate ,  8, " ")).append("]");
        logtitle.append("[").append(SvcStringUtil.getRightPadding(inout  ,  7, " ")).append("]");
        logtitle.append("[").append(SvcStringUtil.getRightPadding(surl   , 50, " ")).append("]");

        debug(logfile, logdir, logtitle.toString(), ogj);
    }
}
