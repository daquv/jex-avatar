package com.avatar.comm;

import java.io.ByteArrayOutputStream;
import java.net.InetAddress;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.json.simple.JSONObject;

import com.coocon.seed.KISA_SEED_CBC;

import MTransKeySrvLib.MTransKeySrv;
//import semo.comm.session.SEMO_SESSION;

@SuppressWarnings({ "unchecked", "rawtypes" })
public class KISA_SEED_CBC_Util {
	
	//암복호화 Initial Vector
    static byte[] pbszIV =  { (byte)0x0FE, (byte)0x0DC, (byte)0x0BA, (byte)0x098,
            (byte)0x076, (byte)0x054, (byte)0x032, (byte)0x010,
            (byte)0x0FE, (byte)0x0DC, (byte)0x0BA, (byte)0x098,
            (byte)0x076, (byte)0x054, (byte)0x032, (byte)0x010};
    
	//랜덤키 사이즈
    private static final int SEED_KEY_SIZE = 10;
    //케릭터 셋
    private static final String CHARSET = "UTF-8";
    //암복호화 키 사이즈(무조건 16byte)
    private static final int  SeedBlockSize   = 16;
	
	private static KISA_SEED_CBC_Util instance = null;
	
	public static KISA_SEED_CBC_Util getInstance(){
		if(instance == null){
			instance = new KISA_SEED_CBC_Util();
		}
		return instance;
	}

	//데이터 암호화
    public static String encrypt(String data, String key) throws Exception{
    	getInstance();
    	byte[] encData = data.getBytes(CHARSET);	
    	byte keyByte[] = instance.addPadding(instance.getEncryptSeedKey(key).getBytes(CHARSET), SeedBlockSize);
    	return instance.byteArrayToHex(KISA_SEED_CBC.SEED_CBC_Encrypt(keyByte,  pbszIV, encData, 0, encData.length));
    }
    
    //데이터 복호화
    public static String decrypt(String data, String key) throws Exception{
    	getInstance();
    	byte keyByte[] = instance.addPadding(instance.getDecryptSeedKey(key).getBytes(CHARSET), SeedBlockSize);
    	byte cipherTextByte[] = changeHex2Byte(data);
    	return new String(KISA_SEED_CBC.SEED_CBC_Decrypt(keyByte,  pbszIV, cipherTextByte, 0, cipherTextByte.length), CHARSET);
    }

    
    //데이터 복호화
    public String decrypt(byte[] data, byte[] key) throws Exception{
    	return new String(KISA_SEED_CBC.SEED_CBC_Decrypt(key,  pbszIV, data, 0, data.length), CHARSET);
    }

    
	//랜덤키 생성
    public static String generateRandomKey() throws Exception{
    	StringBuffer buffer = new StringBuffer();
        String characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        
        int charactersLength = characters.length();

        for (int i = 0; i < SEED_KEY_SIZE; i++) {
            double index = Math.random() * charactersLength;
            buffer.append(characters.charAt((int) index));
        }
        return buffer.toString();
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
  	
  //hex -> byte
    public static byte[] changeHex2Byte(String hex){

        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        for(int i=0; i < hex.length(); i+= 2){
            int b = Integer.parseInt(hex.substring(i, i+2), 16);
            byteArrayOutputStream.write(b);
        }
        return byteArrayOutputStream.toByteArray();
    }
  //byte -> hex
    public String byteArrayToHex(byte[] ba) throws Exception{
        if (ba == null || ba.length == 0) {
            return null;
        }

        StringBuffer sb = new StringBuffer(ba.length * 2);
        String hexNumber;
        for (int x = 0; x < ba.length; x++) {
            hexNumber = "0" + Integer.toHexString(0xff & ba[x]);

            sb.append(hexNumber.substring(hexNumber.length() - 2));
        }
        return sb.toString();
    }
    

    //암호화시 키 Message Digest 변환
    public String getEncryptSeedKey(String randomKey) throws Exception {
		return getSHA256(randomKey).substring(4, 15);

	}

	public String getDecryptSeedKey(String randomKey) throws Exception{
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
