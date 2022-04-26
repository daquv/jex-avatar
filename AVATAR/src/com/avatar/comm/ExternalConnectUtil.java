package com.avatar.comm;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import jex.exception.JexBIZException;
import jex.util.StringUtil;

public class ExternalConnectUtil {

	/**
	 * JSON API 데이터 받기
	 * @param url
	 * @param json
	 * @param mode
	 * @param charSet
	 * @param propertyMap
	 * @param logwrite
	 * @return
	 * @throws Exception
	 */
	public static String connect(String url , String json , String mode , String sendCharSet, String receiveCharSet, Map<String, String> propertyMap, String readTime, boolean logwrite) throws Exception {

		PrintWriter postReq 	   = null;
		BufferedReader postRes 	   = null;
		String resultJson 		   = null;
		StringBuilder resultBuffer = new StringBuilder();

		ExternalConnectUtil ec = new ExternalConnectUtil();
		/*
		BizLogUtil.debug(ec, "url           " , url             );
		BizLogUtil.debug(ec, "json          " , json            );
		BizLogUtil.debug(ec, "mode          " , mode            );
		BizLogUtil.debug(ec, "sendCharSet   " , sendCharSet     );
		BizLogUtil.debug(ec, "receiveCharSet" , receiveCharSet  );
		BizLogUtil.debug(ec, "readTime      " , readTime        );
		*/

	    try {

	        URL connectUrl = new URL(url);

	        if("https".equals(mode)){

	        	HttpsURLConnection con = (HttpsURLConnection)connectUrl.openConnection();
	        	con.setRequestMethod("POST");
	        	con.setDoOutput(true);
	        	con.setUseCaches(false);
	        	con.setConnectTimeout(5000);	//TIMEOUT 5초 설정

	        	if(readTime != null){
	        		con.setReadTimeout(Integer.parseInt(readTime));
	        	}

		        if(propertyMap != null){
		        	for(String key : propertyMap.keySet()){
		        		con.setRequestProperty(key, propertyMap.get(key));
		        	}
		        }

		        // JSONArray 전송
		        postReq = new PrintWriter(new OutputStreamWriter(con.getOutputStream(),sendCharSet));
		        postReq.write(json);
		        postReq.flush();

		        // JSONObject 수신
		        postRes = new BufferedReader(new InputStreamReader(con.getInputStream(), receiveCharSet));
		        while ((resultJson = postRes.readLine()) != null){
		            resultBuffer.append(resultJson);
		        }
		        con.disconnect();

	        }else{
	        	HttpURLConnection con = (HttpURLConnection)connectUrl.openConnection();
	        	con.setRequestMethod("POST");
		    	con.setDoOutput(true);
		    	con.setUseCaches(false);
		        con.setConnectTimeout(5000);	//TIMEOUT 5초 설정
		        if(readTime != null){
	        		con.setReadTimeout(Integer.parseInt(readTime));
	        	}
	        	if(propertyMap != null){
		        	for(String key : propertyMap.keySet()){
		        		con.setRequestProperty(key, propertyMap.get(key));
		        	}
		        }
		        // JSONArray 전송
		        postReq = new PrintWriter(new OutputStreamWriter(con.getOutputStream(),sendCharSet));
		        postReq.write(json);
		        postReq.flush();
		        // JSONObject 수신
		        postRes = new BufferedReader(new InputStreamReader(con.getInputStream(), receiveCharSet));
		        while ((resultJson = postRes.readLine()) != null){
		            resultBuffer.append(resultJson);
		        }
		        con.disconnect();
	        }

	    }catch(SocketTimeoutException e){
	    	BizLogUtil.error(ec, "SocketTimeoutException", e);
	    	throw e;
	    }catch(Exception e){
	    	BizLogUtil.error(ec, "Exception", e);
	    	throw e;
	    }finally {
	    }

		return resultBuffer.toString();
	}

	/**
	 * JSON API 데이터 받기
	 * @param url
	 * @param mode
	 * @param charSet
	 * @param propertyMap
	 * @param logwrite
	 * @return
	 * @throws Exception
	 */
	public static String nojsonconnect(String url , String mode , String sendCharSet, String receiveCharSet, Map<String, String> propertyMap, String readTime, boolean logwrite) throws Exception {
		PrintWriter postReq 	   = null;
		BufferedReader postRes 	   = null;
		String resultJson 		   = null;
		StringBuilder resultBuffer = new StringBuilder();

		ExternalConnectUtil ec = new ExternalConnectUtil();
		BizLogUtil.debug(ec, "url           " , url             );
		BizLogUtil.debug(ec, "mode          " , mode            );
		BizLogUtil.debug(ec, "sendCharSet   " , sendCharSet     );
		BizLogUtil.debug(ec, "receiveCharSet" , receiveCharSet  );
		BizLogUtil.debug(ec, "readTime      " , readTime        );

	    try {
	        URL connectUrl = new URL(url);

	        if("https".equals(mode)){

	        	HttpsURLConnection con = (HttpsURLConnection)connectUrl.openConnection();
	        	con.setRequestMethod("POST");
	        	con.setDoOutput(true);
	        	con.setUseCaches(false);
	        	con.setConnectTimeout(5000);	//TIMEOUT 5초 설정

	        	if(readTime != null){
	        		con.setReadTimeout(Integer.parseInt(readTime));
	        	}

		        if(propertyMap != null){
		        	for(String key : propertyMap.keySet()){
		        		con.setRequestProperty(key, propertyMap.get(key));
		        	}
		        }

		        // JSONArray 전송
		        postReq = new PrintWriter(new OutputStreamWriter(con.getOutputStream(),sendCharSet));
		        postReq.flush();

		        // JSONObject 수신
		        postRes = new BufferedReader(new InputStreamReader(con.getInputStream(), receiveCharSet));
		        while ((resultJson = postRes.readLine()) != null){
		            resultBuffer.append(resultJson);
		        }
		        con.disconnect();

	        }else{

	        	HttpURLConnection con = (HttpURLConnection)connectUrl.openConnection();
		        con.setRequestMethod("POST");
		        con.setDoOutput(true);
		        con.setUseCaches(false);
		        con.setConnectTimeout(5000);	//TIMEOUT 5초 설정

	        	if(readTime != null){
	        		con.setReadTimeout(Integer.parseInt(readTime));
	        	}

		        if(propertyMap != null){
		        	for(String key : propertyMap.keySet()){
		        		con.setRequestProperty(key, propertyMap.get(key));
		        	}
		        }

		        // JSONArray 전송
		        postReq = new PrintWriter(new OutputStreamWriter(con.getOutputStream(),sendCharSet));
		        postReq.flush();

		        // JSONObject 수신
		        postRes = new BufferedReader(new InputStreamReader(con.getInputStream(), receiveCharSet));
		        while ((resultJson = postRes.readLine()) != null){
		            resultBuffer.append(resultJson);
		        }
		        con.disconnect();
	        }

	    }catch(SocketTimeoutException e){
	    	BizLogUtil.error(ec, "SocketTimeoutException", e);
	    	throw e;
	    }catch(Exception e){
	    	BizLogUtil.error(ec, "Exception", e);
	    	throw e;
	    }finally {
	    }

		return resultBuffer.toString();
	}

	/**
	 * JSON API 데이터 받기
	 * @param url
	 * @param json
	 * @param mode
	 * @param charSet
	 * @return
	 * @throws Exception
	 */
	public static String connect(String url , String json , String mode , String charSet) throws Exception {
		return connect(url, json, mode, charSet,charSet, null, null);
	}

	/**
	 * 전송 시 Property 추가
	 * @param url
	 * @param json
	 * @param mode
	 * @param charSet
	 * @param propertyMap
	 * @return
	 * @throws Exception
	 */
	public static String connect(String url , String json , String mode , String charSet, Map<String, String> propertyMap) throws Exception {
		return connect(url, json, mode, charSet,charSet, propertyMap, null);
	}

	/**
	 *
	 * @param url
	 * @param json
	 * @param mode
	 * @param charSet
	 * @param readTime
	 * @return
	 * @throws Exception
	 */
	public static String connect(String url , String json , String mode , String charSet, String readTime) throws Exception {
		return connect(url, json, mode, charSet,charSet, null, readTime);
	}

	/**
	 * 받을 때 인코딩 방식 추가
	 * @param url
	 * @param json
	 * @param mode
	 * @param sendCharSet
	 * @param receiveCharSet
	 * @return
	 * @throws Exception
	 */
	public static String connectChar(String url , String json , String mode , String sendCharSet, String receiveCharSet) throws Exception {
		return connect(url, json, mode, sendCharSet,receiveCharSet, null, null);
	}

	/**
	 *
	 * @param url
	 * @param json
	 * @param mode
	 * @param charSet
	 * @param propertyMap
	 * @return
	 * @throws Exception
	 */
	public static String connect(String url , String json , String mode , String sendCharSet, String receiveCharSet, Map<String, String> propertyMap, String readTime) throws Exception {
		return connect(url, json, mode, sendCharSet, receiveCharSet, propertyMap, readTime, true);
	}

	public static String connect(String url , String json , String mode , String charSet, boolean logwrite) throws Exception {
		return connect(url, json, mode, charSet,charSet, null, null, logwrite);
	}

	public static String connect(String url , String json , String mode , String charSet, Map<String, String> propertyMap, boolean logwrite) throws Exception {
		return connect(url, json, mode, charSet,charSet, propertyMap, null,logwrite);
	}

	public static String connect(String url , String json , String mode , String charSet, String readTime, boolean logwrite) throws Exception {
		return connect(url, json, mode, charSet,charSet, null, readTime,logwrite);
	}
	public static String connectChar(String url , String json , String mode , String sendCharSet, String receiveCharSet, boolean logwrite) throws Exception {
		return connect(url, json, mode, sendCharSet,receiveCharSet, null, null,logwrite);
	}

	/**
	 * Google을 이용한 단축 URL 생성
	 *  - 2015-01-14 작업 : 리얼 반영 안됌
	 * @param longUrl URL
	 * @return
	 * @throws Exception
	 */
	public static String urlShort(String longUrl) throws Exception{
		Map<String, String> map = new HashMap<String, String>();
		map.put("content-Type", "application/json");

		String result = connect("https://www.googleapis.com/urlshortener/v1/url", "{\"longUrl\": \""+longUrl+"\"}", "https", "UTF-8", map);

		JSONParser parser = new JSONParser();
		JSONObject obj =  (JSONObject) parser.parse(result);
		String shortUrl = (String)obj.get("id");


		if(StringUtil.isBlank(shortUrl)){
			throw new JexBIZException("WCE00163");
		}

		return shortUrl;
	}
}

