package com.avatar.comm;

import java.io.ByteArrayOutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.AlgorithmParameterSpec;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import jex.util.base64.Base64;

import javax.crypto.spec.IvParameterSpec;

/**
 * AES 암호화 Util
 * +[2017.03.27] :: kkb :: 최초 작성
 */
public class AESUtils {

    /** 암호화 방식 */
    private static final String CRYPT_TYPE_AES = "AES";
    private static final String CRYPT_TYPE_AES256 = "AES/CBC/PKCS5Padding";

    /** default algorithm */
    private static final String CRYPT_TYPE_ALGORITHM_SHA1PRNG = "SHA1PRNG";
    private static final String CRYPT_TYPE_ALGORITHM_HmacSHA256 = "HmacSHA256";

    /** default key length */
    public static final int CRYPT_TYPE_LENGTH = 256;
    
    public static final int SeedBlockSize = 16;

    /** default charset */
    public static final String CHARSET_UTF_8 = "UTF-8";

    private static AESUtils instance = null;
    
    public static AESUtils getInstance(){
		if(instance == null){
			instance = new AESUtils();
		}
		return instance;
	}
    
    /**
     * 암호화 키 생성
     * @return 암호화 Key byte[]
     */
    public static byte[] getCryptKey() {
        byte[] cryptKeyBytes = null;

        try {

            KeyGenerator keyGenerator = KeyGenerator.getInstance(CRYPT_TYPE_AES);
            keyGenerator.init(CRYPT_TYPE_LENGTH);

            // 암호화 키 생성
            SecretKey secretKey = keyGenerator.generateKey();
            cryptKeyBytes = secretKey.getEncoded();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return cryptKeyBytes;
    }

    /**
     * 암호화 키 생성
     * @param seed 키를 생성할 seed String
     *             SecureRandom.getInstance(algorithm) (algorithm : 암호화 알고리즘) 과 seed 를 사용하여 키생성
     * @return 암호화 Key byte[]
     */
    public static byte[] getCryptKey(String seed) throws UnsupportedEncodingException {
        return getCryptKey(seed.getBytes(CHARSET_UTF_8));
    }

    /**
     * 암호화 키 생성
     * @param seed 키를 생성할 seed byte[]
     *             SecureRandom.getInstance(algorithm) (algorithm : 암호화 알고리즘) 과 seed 를 사용하여 키생성
     * @return 암호화 Key byte[]
     */
    public static byte[] getCryptKey(byte[] seed) {
        byte[] cryptKeyBytes = null;

        try {

            KeyGenerator keyGenerator = KeyGenerator.getInstance(CRYPT_TYPE_AES);
            SecureRandom secureRandom = SecureRandom.getInstance(CRYPT_TYPE_ALGORITHM_SHA1PRNG);
            secureRandom.setSeed(seed);

            keyGenerator.init(CRYPT_TYPE_LENGTH, secureRandom);

            // 암호화 키 생성
            SecretKey secretKey = keyGenerator.generateKey();
            cryptKeyBytes = secretKey.getEncoded();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return cryptKeyBytes;
    }

    /**
     * AES 암호화
     * @param cryptKeyBytes : 암호화 키 byte[]
     * @param plainDataByte : 암호화할 원본 데이터 String
     * @return
     */
    public static byte[] encrypt (byte [] cryptKeyBytes, String plainDataByte) throws UnsupportedEncodingException {
        return encrypt(cryptKeyBytes, plainDataByte.getBytes(CHARSET_UTF_8));
    }
    
    /**
     * AES 암호화
     * @param cryptKeyBytes : 암호화 키  String
     * @param plainDataByte : 암호화할 원본 데이터 String
     * @return
     * @throws Exception 
     */
    public static String encrypt (String plainDataByte, String cryptKeyBytes) throws Exception {
    	//return encrypt(cryptKeyBytes, plainDataByte.getBytes(CHARSET_UTF_8));
    	getInstance();
    	return HexUtils.byteArrayToHex(encrypt(instance.addPadding(instance.getEncryptSeedKey(cryptKeyBytes).getBytes(CHARSET_UTF_8)
    															  , SeedBlockSize)
    										  , plainDataByte.getBytes(CHARSET_UTF_8)));
    }

    /**
     * AES 암호화
     * @param plainDataByte : 암호화할 원본 데이터 String
     * @return
     * @throws Exception 
     */
    public static String encrypt (String plainDataByte) throws Exception {
    	return encrypt(plainDataByte, "cryptKeyBytes");
    }

    /**
     * AES 암호화
     * @param cryptKeyBytes : 암호화 키 byte[]
     * @param plainDataByte : 암호화할 원본 데이터 byte []
     * @return 암호화한 데이터 byte[]
     */
    public static byte[] encrypt (byte [] cryptKeyBytes, byte[] plainDataByte) {

        byte[] encryptBytes = null;

        try {

            SecretKeySpec secretKeySpec = new SecretKeySpec(cryptKeyBytes, CRYPT_TYPE_AES);
            Cipher cipher = Cipher.getInstance(CRYPT_TYPE_AES);
            cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec);
            encryptBytes = cipher.doFinal(plainDataByte);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return encryptBytes;
    }
    
    /**
     * AES256 암호화
     * @param cryptKeyBytes : 암호화 키  String
     * @param plainDataByte : 암호화할 원본 데이터 String
     * @return
     * @throws Exception 
     */
    public static String encryptAesToBase64(String cryptKeyBytes, String plainDataByte) {
    	
    	String encryptBytes = null;
    	
    	try {
        	String iv = cryptKeyBytes.substring(0, SeedBlockSize); // 16byte
	    	Cipher cipher = Cipher.getInstance(CRYPT_TYPE_AES256);
	        SecretKeySpec keySpec = new SecretKeySpec(iv.getBytes(), CRYPT_TYPE_AES);
	        IvParameterSpec ivParamSpec = new IvParameterSpec(iv.getBytes());
	        cipher.init(Cipher.ENCRYPT_MODE, keySpec, ivParamSpec);
	
	        byte[] encrypted = cipher.doFinal(plainDataByte.getBytes(CHARSET_UTF_8));
	        encryptBytes = new String(Base64.encode(encrypted));
    	} catch (Exception e) {
            e.printStackTrace();
        }
    	return encryptBytes; 
    }
    
    /**
     * AES256 암호화
     * @param plainDataByte : 암호화할 원본 데이터 String
     * @param cryptKeyBytes : 암호화 키 byte[]
     * @param cryptKeyIvBytes : 암호화 Iv키 byte[]
     * @return encryptBytes
     * @throws Exception 
     */
    public static String EncryptAes256(String plainDataByte, byte[] cryptKeyBytes, byte[] cryptKeyIvBytes){
    	String encryptBytes = null;
    	try {
	    	AlgorithmParameterSpec iv = new IvParameterSpec(cryptKeyIvBytes);              
	    	SecretKeySpec k = new SecretKeySpec(cryptKeyBytes, CRYPT_TYPE_AES);              
	    	Cipher c = Cipher.getInstance(CRYPT_TYPE_AES256);      
	    	c.init(Cipher.ENCRYPT_MODE, k, iv);            
	    	byte[] inBytes = plainDataByte.getBytes(CHARSET_UTF_8);      
	    	byte[] encBytes = c.doFinal(inBytes);       
	    	//String b64EncString = Base64.encodeBase64String(encBytes); //Base64 인코딩                 
	    	String b64EncString = Base64.encodeBuffer(encBytes); //Base64 인코딩
	    	encryptBytes = URLEncoder.encode(b64EncString, CHARSET_UTF_8); //URL 인코딩
    	} catch (Exception e) {
            e.printStackTrace();
        }
    	return encryptBytes; 
    } 
    
    /**
     * AES256 복호화
     * @param encryptDataByte : 암호화 데이터 String
     * @param cryptKeyBytes : 암호화 키 byte[]
     * @param cryptKeyIvBytes : 암호화 Iv키 byte[]
     * @return
     * @throws Exception 
     */
    public static String DecryptAes256(String encryptDataByte, byte[] cryptKeyBytes, byte[] cryptKeyIvBytes){  
    	String decString = null;
    	try {
	    	AlgorithmParameterSpec iv = new IvParameterSpec(cryptKeyIvBytes);     
	    	SecretKeySpec k = new SecretKeySpec(cryptKeyBytes, CRYPT_TYPE_AES);          
	    	Cipher c = Cipher.getInstance(CRYPT_TYPE_AES256);  
	    	c.init(Cipher.DECRYPT_MODE, k, iv);     
	    	String b64EncString = URLDecoder.decode(encryptDataByte, CHARSET_UTF_8); //URL 디코딩    
	    	//byte[] encBytes = Base64.decodeBase64(b64EncString); //Base64 인코딩  
	    	byte[] encBytes = Base64.decodeBuffer(b64EncString) ; //Base64 인코딩  
	    	decString = new String(c.doFinal(encBytes), CHARSET_UTF_8); 
    	} catch (Exception e) {
            e.printStackTrace();
        }
    	return decString; 
    } 
     
    // byte[] to Hex
    public static String changeBytes2Hex(byte[] plainDataByte){      
    	StringBuilder builder = new StringBuilder();
		for (byte b : plainDataByte) {
			builder.append(String.format("%02x", b));
		}
		return builder.toString();
    } 
     
    // String To byte[]
    public static byte[] changeHex2Byte(String hex){ 
    	ByteArrayOutputStream baos = new ByteArrayOutputStream();  
    	for(int i=0; i < hex.length(); i+= 2){   
    		int b = Integer.parseInt(hex.substring(i, i+2), SeedBlockSize);   
    		baos.write(b);  
    	}    
    	return baos.toByteArray();  
    } 
     
    // HMAC 생성
    public static String getHmacSha256(String input, byte[] key){
    	String encryptBytes = null;
    	try {
	    	SecretKeySpec keySpec = new SecretKeySpec(key, CRYPT_TYPE_ALGORITHM_HmacSHA256);     
	    	Mac mac = Mac.getInstance(CRYPT_TYPE_ALGORITHM_HmacSHA256);     
	    	mac.init(keySpec);          
	    	byte[] inBytes = input.getBytes(CHARSET_UTF_8);     
	    	byte[] encBytes = mac.doFinal(inBytes); 
	    	//String b64EncString = Base64.encodeBase64String(encBytes); //Base64 인코딩          
	    	String b64EncString = Base64.encodeBuffer(encBytes); //Base64 인코딩          
	    	encryptBytes = URLEncoder.encode(b64EncString, CHARSET_UTF_8); //URL 인코딩
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	return encryptBytes;
    }

    /**
     * AES256 암호화
     * @param cryptKeyBytes : 암호화 키  String
     * @param plainDataByte : 암호화할 원본 데이터 String
     * @return
     * @throws Exception 
     */
    public static String getHmacSHA256ToStr(String cryptKeyBytes, String plainDataByte) {
    	String encryptBytes = null;
    	
    	try {
    		SecretKeySpec skp = new SecretKeySpec( cryptKeyBytes.getBytes(CHARSET_UTF_8), CRYPT_TYPE_ALGORITHM_HmacSHA256);
			Mac mac = Mac.getInstance(CRYPT_TYPE_ALGORITHM_HmacSHA256);
			mac.init(skp);
			encryptBytes = new String( Base64.encode( mac.doFinal(plainDataByte.getBytes(CHARSET_UTF_8))));
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	return encryptBytes;
	}
    
    /**
     * AES 복호화
     * @param cryptKeyBytes : 암호화 키 byte[]
     * @param encryptDataByte : 암호화 데이터 byte []
     * @return
     */
    public static String decrypt (byte [] cryptKeyBytes, byte [] encryptDataByte) {
        String decryptDataString = null;

        try {
            byte [] decryptDataBytes = null;

            SecretKeySpec secretKeySpec = new SecretKeySpec(cryptKeyBytes, CRYPT_TYPE_AES);
            Cipher cipher = Cipher.getInstance(CRYPT_TYPE_AES);
            cipher.init(Cipher.DECRYPT_MODE, secretKeySpec);
            decryptDataBytes = cipher.doFinal(encryptDataByte);
            decryptDataString = new String(decryptDataBytes);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return decryptDataString;
    }


    /**
     * AES 복호화
     * @param plainDataByte : 암호화할 원본 데이터 String
     * @return
     * @throws Exception 
     */
    public static String decrypt (String encryptData) throws Exception {
    	return decrypt(encryptData, "cryptKeyBytes");
    }


    /**
     * AES 복호화
     * @param cryptKeyBytes : 암호화 키 String
     * @param encryptDataByte : 암호화 데이터 String
     * @return
     * @throws Exception 
     * @throws UnsupportedEncodingException 
     */
    public static String decrypt (String encryptData, String cryptKey) throws UnsupportedEncodingException, Exception {
    	getInstance();
    	String decryptDataString = null;
    	byte [] cryptKeyBytes	 = instance.addPadding(instance.getEncryptSeedKey(cryptKey).getBytes(CHARSET_UTF_8)
    												   , SeedBlockSize);
    	byte [] encryptDataByte	 = HexUtils.hexByteArray(encryptData);
    	
    	try {
    		byte [] decryptDataBytes = null;
    		
    		SecretKeySpec secretKeySpec = new SecretKeySpec(cryptKeyBytes, CRYPT_TYPE_AES);
    		Cipher cipher = Cipher.getInstance(CRYPT_TYPE_AES);
    		cipher.init(Cipher.DECRYPT_MODE, secretKeySpec);
    		decryptDataBytes = cipher.doFinal(encryptDataByte);
    		decryptDataString = new String(decryptDataBytes);
    		
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	
    	return decryptDataString;
    }
    
    //바이트배열 blockSize 만큼 0으로 채워넣음
  	public byte[] addPadding(byte[] source, int blockSize) throws Exception{
          
          int paddingCnt = source.length % blockSize;
          byte[] paddingResult = null;  
          if(paddingCnt != 0) {
              paddingResult = new byte[source.length + (blockSize - paddingCnt)];
     
              System.arraycopy(source, 0, paddingResult, 0, source.length);
     
              // 패딩해야 할 갯수 - 1 (마지막을 제외)까지 0x00 값을 추가한다.
              int addPaddingCnt = blockSize - paddingCnt;
              for(int i=0;i<addPaddingCnt;i++) {
                  paddingResult[source.length + i] = 0x00;
              } 
          } else  {
              paddingResult = source;
          }
          
          return paddingResult;
      }
  	
    public String getEncryptSeedKey(String randomKey) throws Exception {
		return getSHA256(randomKey).substring(4, 15);

	}
    //복호화시 키 Message Digest 변환
  	public String getSHA256(String str)  throws Exception{
  		String SHA = "";
  		try{
  			MessageDigest sh = MessageDigest.getInstance("SHA-256");
  			sh.update(str.getBytes());
  			byte byteData[] = sh.digest();
  			StringBuffer sb = new StringBuffer();
  			for(int i = 0 ; i < byteData.length ; i++){
  				sb.append(Integer.toString((byteData[i]&0xff) + 0x100, 16).substring(1));
  			}
  			SHA = sb.toString().toUpperCase();

  		} catch(NoSuchAlgorithmException e){			
  			SHA = null;
  		}catch(Exception e){
  			SHA = null;
  		}
  		return SHA;
  	}
}
