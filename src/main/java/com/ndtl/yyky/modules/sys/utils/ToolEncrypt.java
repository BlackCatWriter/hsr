
package com.ndtl.yyky.modules.sys.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * 
 * @ClassName: ToolEncrypt
 * @Description:
 * @date 2016年4月20日 下午3:54:36
 *
 */

public class ToolEncrypt {

    /**
     * MD5加密
     * 
     * @param param
     *            加密字符
     * @return String 加密后的字符
     * @throws NoSuchAlgorithmException
     *             Encryption异常
     */
    public static String md5Encrypt(String param) throws NoSuchAlgorithmException {
        char[] hexDigits = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h','i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u' };
        byte[] strTemp = param.getBytes();
        MessageDigest mdTemp = MessageDigest.getInstance("MD5");
        mdTemp.update(strTemp);
        byte[] md = mdTemp.digest();
        int j = md.length;
        char[] str = new char[j * 2];
        int k = 0;
        for (int i = 0; i < j; i++) {
            byte byte0 = md[i];
            str[k++] = hexDigits[byte0 >>> 4 & 0xf];
            str[k++] = hexDigits[byte0 & 0xf];
        }
        return new String(str);
    }

    public static void main(String[] args) throws NoSuchAlgorithmException {

        System.out.println(md5Encrypt("哈哈"));

    }
}
