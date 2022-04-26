package com.avatar.comm;

import java.sql.SQLException;

import jex.data.JexData;
import jex.data.JexDataList;
import jex.util.DomainUtil;

public class IdoSqlException {
	private static IdoSqlException thisObj = null;

	private SQLException _jexErr = null;
	private String _ErrorCode =           "";
	private String _SQLState =            "";
	private String _Message =             "";
	private String  _ServerErrorMessage =  "";

	public IdoSqlException(JexData data) {
		String serverMsg = "";
		try{
			if(DomainUtil.getErrorCode(data).trim().startsWith("JEXD300")){
				this.setjexErr((SQLException) DomainUtil.getErrorTrace(data));
//				serverMsg += "SQLState : " + _jexErr.getSQLState();
//				serverMsg += "Message  : " + _jexErr.getMessage() ;
//				serverMsg += "Detail   : " + _jexErr.getDetail()  ;
				this.setErrorCode(         Integer.toString(_jexErr.getErrorCode())         );
				this.setSQLState(          _jexErr.getSQLState()          );
				this.setMessage(           _jexErr.toString() + " (" + _jexErr.getCause().getMessage() + ")"           );
				this.setServerErrorMessage(serverMsg);
			} else {
				this.setErrorCode(DomainUtil.getErrorCode(data));
				this.setMessage(  DomainUtil.getErrorMessage(data));
			}
		} catch(Exception e){
			this.setErrorCode(DomainUtil.getErrorCode(data));
			this.setMessage(  DomainUtil.getErrorMessage(data));
			this.setServerErrorMessage(e.getMessage());
		}
	}

	public IdoSqlException(JexDataList data) {
		String serverMsg = "";
		try{
			if(DomainUtil.getErrorCode(data).trim().startsWith("JEXD300")){
				this.setjexErr((SQLException) DomainUtil.getErrorTrace(data));
//				serverMsg += "SQLState : " + _jexErr.getSQLState();
//				serverMsg += "Message  : " + _jexErr.getMessage() ;
//				serverMsg += "Detail   : " + _jexErr.getDetail()  ;
				this.setErrorCode(         Integer.toString(_jexErr.getErrorCode())         );
				this.setSQLState(          _jexErr.getSQLState()          );
				this.setMessage(           _jexErr.toString() + " (" + _jexErr.getCause().getMessage() + ")"           );
				this.setServerErrorMessage(serverMsg);
			} else {
				this.setErrorCode(DomainUtil.getErrorCode(data));
				this.setMessage(  DomainUtil.getErrorMessage(data));
			}
		} catch(Exception e){
			this.setErrorCode(DomainUtil.getErrorCode(data));
			this.setMessage(  DomainUtil.getErrorMessage(data));
			this.setServerErrorMessage(e.getMessage());
		}
	}

	public static IdoSqlException getInstance(JexData data) {
			thisObj = new IdoSqlException(data);
		return thisObj;
	}

	public static IdoSqlException getInstance(JexDataList data) {
			thisObj = new IdoSqlException(data);
		return thisObj;
	}

	public static void printErr(Object callerClass, String title, JexData data) {
		IdoSqlException Obj = new IdoSqlException(data);
    	BizLogUtil.debug(callerClass,title, "      ===== Error Code         :: "+Obj.getErrorCode());
    	BizLogUtil.debug(callerClass,title, "      ===== Error SQLState     :: "+Obj.getSQLState());
    	BizLogUtil.debug(callerClass,title, "      ===== Error Message      :: "+Obj.getMessage());
    	BizLogUtil.debug(callerClass,title, "      ===== Error ServerMessage:: "+Obj.getServerErrorMessage());
	}

	public static void printErr(Object callerClass, String title, JexDataList data) {
		IdoSqlException Obj = new IdoSqlException(data);
    	BizLogUtil.debug(callerClass,title, "      ===== Error Code         :: "+Obj.getErrorCode());
    	BizLogUtil.debug(callerClass,title, "      ===== Error SQLState     :: "+Obj.getSQLState());
    	BizLogUtil.debug(callerClass,title, "      ===== Error Message      :: "+Obj.getMessage());
    	BizLogUtil.debug(callerClass,title, "      ===== Error ServerMessage:: "+Obj.getServerErrorMessage());
	}

	public void printErr(Object callerClass, String title) {
    	BizLogUtil.debug(callerClass,title, "      ===== Error Code         :: "+this.getErrorCode());
    	BizLogUtil.debug(callerClass,title, "      ===== Error SQLState     :: "+this.getSQLState());
    	BizLogUtil.debug(callerClass,title, "      ===== Error Message      :: "+this.getMessage());
    	BizLogUtil.debug(callerClass,title, "      ===== Error ServerMessage:: "+this.getServerErrorMessage());
	}

	/***
	 * sql 오류코드
	 * @return
	 */
	public String getErrorCode()         {
		return _ErrorCode         ;
	}
	public String getSQLState()          {
		return _SQLState          ;
	}
	public String getMessage()           {
		return _Message           ;
	}
	public String getServerErrorMessage(){
		return _ServerErrorMessage;
	}
	public SQLException get_jexErr(){
		return _jexErr;
	}

	private void setjexErr(         SQLException jexErr         ){
		_jexErr          = jexErr         ;
	}

	private void setErrorCode(         String strErrorCode         ){
		_ErrorCode          = strErrorCode         ;
	}
	private void setSQLState(          String strSQLState          ){
		_SQLState           = strSQLState          ;
	}
	private void setMessage(           String strMessage           ){
		_Message            = strMessage           ;
	}
	private void setServerErrorMessage(String strServerErrorMessage){
		_ServerErrorMessage = strServerErrorMessage;
	}

}
