package com.avatar.comm;

import java.io.ByteArrayOutputStream;

/**
 * @title		: Hex Data Util
 * @author		: Webcash
 * @date		: 2015
 * @description	: 입력된 String Data를 Hex 형식으로 변환 또는 Hex Data를 String 형식으로 변환
 */
public class HexUtils {

    /**
     *  해당 정보 hex data로 변환
     * @param ba
     * @return
     */
    public static String byteArrayToHex(byte[] ba) {

        if(ba ==  null || ba.length ==0) {
            return null;
        }

        StringBuffer sb = new StringBuffer(ba.length * 2);
        for(int i = 0 ; i < ba.length;i++) {
            if (((int) ba[i] & 0xff) < 0x10) {
                sb.append("0");
            }
            sb.append(Long.toString((int) ba[i] & 0xff, 16));
        }
        return sb.toString();
    }

    /**
     *  Hex 정보 Byte 로 변환
     * @param hex
     * @return
     */
    public static byte[] hexByteArray(String hex) {

        if(hex == null || hex.length() ==0) {
            return null;
        }

        byte[] ba = new byte[hex.length()/2];
        for(int i = 0; i < ba.length; i++) {
            ba[i] = (byte) Integer.parseInt(hex.substring(2*i,2*i+2),16);
        }
        return ba;
    }

    public static byte[] changeHex2Byte(String hex){
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        for(int i=0; i < hex.length(); i+= 2){
            int b = Integer.parseInt(hex.substring(i, i+2), 16);
            byteArrayOutputStream.write(b);
        }
        return byteArrayOutputStream.toByteArray();
    }

    public static byte[] toByte(String hexString) {
        int len = hexString.length()/2;
        byte[] result = new byte[len];
        for (int i = 0; i < len; i++)
            result[i] = Integer.valueOf(hexString.substring(2*i, 2*i+2), 16).byteValue();
        return result;
    }

    public static String toHex(byte[] buf) {
        if (buf == null)
            return "";
        StringBuffer result = new StringBuffer(2*buf.length);
        for (int i = 0; i < buf.length; i++) {
            appendHex(result, buf[i]);
        }
        return result.toString();
    }

    private final static String KEY_HEX = "0123456789ABCDEF";

    private static void appendHex(StringBuffer sb, byte b) {
        sb.append(KEY_HEX.charAt((b>>4)&0x0f)).append(KEY_HEX.charAt(b&0x0f));
    }
}
