package com.ndtl.yyky.modules.sys.utils;

import com.ndtl.yyky.common.security.Digests;
import com.ndtl.yyky.common.utils.Encodes;

import java.io.*;
/**
 * Created by JAVA on 2018/7/24.
 */
public class EncoderFile {

    private static String licensePath = "d:/hsr/encoder.license";

    public static void main(String[] args) {
        /*String plainPassword = "123456";
        byte[] salt = Digests.generateSalt(8);
        byte[] hashPassword = Digests.sha1(plainPassword.getBytes(), salt,
                1024);
        System.out.println(Encodes.encodeHex(salt) + Encodes.encodeHex(hashPassword));*/
        File file = new File(licensePath);

        if(!file.exists()){
            file.getParentFile().mkdirs();
            try {
                file.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

    }
    public static void mywrite(File cfgFile ,String write){
        File file = cfgFile;    //1、建立连接
        OutputStream os = null;
        try {
            //2、选择输出流,以追加形式(在原有内容上追加) 写出文件 必须为true 否则为覆盖
            os = new FileOutputStream(file);
//            //和上一句功能一样，BufferedInputStream是增强流，加上之后能提高输出效率，建议
//            os = new BufferedOutputStream(new FileOutputStream(file,true));

            byte[] data = write.getBytes();    //将字符串转换为字节数组,方便下面写入

            os.write(data, 0, data.length);    //3、写入文件
            os.flush();    //将存储在管道中的数据强制刷新出去
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            System.out.println("文件没有找到！");
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("写入文件失败！");
        }finally {
            if (os != null) {
                try {
                    os.close();
                } catch (IOException e) {
                    e.printStackTrace();
                    System.out.println("关闭输出流失败！");
                }
            }
        }
    }

    public static String myread(File cfgFile ){

        StringBuilder sb = new StringBuilder();
        try {
            // 读取字符文件
            BufferedReader in = new BufferedReader(new FileReader(cfgFile));
            // 为什么单独在这里加上try块而不是直接使用外边的try块？
            // 需要考虑这么一种情况，如果文件没有成功打开，则finally关闭文件会出问题
            try {
                String s;
                while ((s = in.readLine()) != null) {
                    sb.append(s + "\n");
                }
            }finally{
                in.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return sb.toString();
    }


}
