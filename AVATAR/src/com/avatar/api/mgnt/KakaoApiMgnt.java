package com.avatar.api.mgnt;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;

import javax.net.ssl.HttpsURLConnection;

import jex.log.JexLogFactory;
import jex.log.JexLogger;
/***
 * Kakao api
 * @author moving
 *
 */
public class KakaoApiMgnt {

    private static final JexLogger LOG = JexLogFactory.getLogger(KakaoApiMgnt.class);

    /**
     * 카카오 주소 정보 조회
     * @param address
     * @return
     */
    public static String getCoordination(String address) throws Exception {
    	
    	String encodeAddress = "";	// 한글 주소는 encoding 해서 날려야 함  
    	try { encodeAddress = URLEncoder.encode( address, "UTF-8" ); } 
    	catch ( UnsupportedEncodingException e ) { e.printStackTrace(); }
    	
    	String apiUrl = "https://dapi.kakao.com/v2/local/search/address.json?query="+ encodeAddress;
    	String auth = "KakaoAK " + "eb9e1ddacd2df29bbb84286aab372b3a"; // 발급받은 key
    	
    	URL url = new URL(apiUrl);
        HttpsURLConnection conn = ( HttpsURLConnection ) url.openConnection();
    	conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", auth);
        
        BufferedReader br;

        int responseCode = conn.getResponseCode();
        if( responseCode == 200 ) {  // 호출 OK
        	br = new BufferedReader( new InputStreamReader(conn.getInputStream(), "UTF-8") );
        } else {  // 에러
        	br = new BufferedReader( new InputStreamReader(conn.getErrorStream(), "UTF-8") );
        }
        
        String jsonString = new String();
        String stringLine;
        while ( ( stringLine= br.readLine()) != null ) {
            jsonString += stringLine;
        }
        return jsonString;
    }
    
}
