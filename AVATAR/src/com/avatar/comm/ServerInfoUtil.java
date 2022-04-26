package com.avatar.comm;

import jex.sys.JexSystem;
import jex.sys.JexSystemConfig;

public class ServerInfoUtil {

	private static ServerInfoUtil thisObj = null;	

	private String _hostName = "";
	private String _logHome  = "";
	private int    _logDelDDay = 0;
	private int    _logZipDDay = 0;
	/**
	 * 코드객체를 생성한다.
	 */
	private ServerInfoUtil() {
		this.getServerInfo();
		//this.init();
	}
	
	/** 
	 * 코드유틸객체를 가져온다.
	 */
	public static ServerInfoUtil getInstance() {
		if ( thisObj == null ) {
			thisObj = new ServerInfoUtil();
		}
		return thisObj;
	}	
	
	public void setHostName(String hostnm){
		_hostName = hostnm;
	}

	public String getHostName(){
		return _hostName;
	}

	public void setlogHome(String logHome){
		_logHome = logHome;
	}

	public String getlogHome(){
		return _logHome;
	}

	public void setlogDelDDay(int logPer){
		_logDelDDay = logPer;
	}

	public int getlogDelDDay(){
		return _logDelDDay;
	}


	public void setlogZipDDay(int logPer){
		_logZipDDay = logPer;
	}

	public int getlogZipDDay(){
		return _logZipDDay;
	}

	public void getServerInfo(){

		String hostName = "";
		try{
			if(_hostName.equals("")){
				Runtime rt = java.lang.Runtime.getRuntime();
				Process proc = rt.exec("hostname -s");
				int inp;
				while ((inp = proc.getInputStream().read()) != -1) {
					hostName+=(char)inp;
				}
				proc.waitFor();
			} else {
				hostName = _hostName;
			}
		}catch(Exception e){
			System.out.println("Error"+e);
			e.printStackTrace();
		}		
		this.setHostName(hostName.trim());

		System.out.println("_hostName   : "+hostName);
		System.out.println("_logHome    : "+JexSystemConfig.get("ServerInfo", "BizLogHome"));
		System.out.println("_logDelDDay : "+JexSystemConfig.get("ServerInfo", "logDelDDay"));
		System.out.println("_logZipDDay : "+JexSystemConfig.get("ServerInfo", "logZipDDay"));
		
		
		this.setlogDelDDay(Integer.parseInt(JexSystemConfig.get("ServerInfo", "logDelDDay")));
		this.setlogZipDDay(Integer.parseInt(JexSystemConfig.get("ServerInfo", "logZipDDay")));
		this.setlogHome(JexSystemConfig.get("ServerInfo", "BizLogHome"));
	}
	
	public boolean isdev(){
		boolean rtn = false;
		if(JexSystem.getProperty("JEX.id").indexOf("_DEV") > -1){
			rtn = true;
		} else {
			rtn = false;
		}
		return rtn;
	}
	
}
