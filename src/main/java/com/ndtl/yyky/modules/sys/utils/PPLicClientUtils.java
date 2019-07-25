/**
 * 
 */
package com.ndtl.yyky.modules.sys.utils;

import com.ndtl.yyky.common.config.Global;
import com.pplic.auth.jni.client.PPLicAuthClientCore;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.cert.Certificate;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

/**
 * @author LiuZhiming
 *
 */
public class PPLicClientUtils
{

	private static String projectSN = Global.getProjectSN();

	private static String licensePath = "d:/hsr/encoder.license";

	private static Certificate[] verifyJarSign(JarFile jar)
	{
		Set<Certificate> certSet = new HashSet<Certificate>();
		try
		{
			Enumeration<JarEntry> entries = jar.entries();
			while (entries.hasMoreElements())
			{
				JarEntry entry = entries.nextElement();
				if (entry.isDirectory() == true)
				{
					continue;
				}
				String name = entry.getName().toUpperCase(Locale.ENGLISH);
				try
				{
					byte[] buffer = new byte[8192];
					InputStream is = jar.getInputStream(entry);
					while ((is.read(buffer, 0, buffer.length)) != -1)
					{
						// We just read. This will throw a SecurityException
						// if a signature/digest check fails.
					}
					is.close();
					Certificate[] certs = entry.getCertificates();
					if (certs == null || certs.length < 1)
					{
	                    if (name.endsWith("MANIFEST.MF") == false && name.endsWith("PPLIC.RSA") == false && name.endsWith("PPLIC.SF") == false)
	                    {
	                    	return null;
	                    }
					}
					else
					{
						for (int i = 0; i < certs.length; i++)
						{
							certSet.add(certs[i]);
						}						
					}
				}
				catch (SecurityException se)
				{
					se.printStackTrace();
					return null;
				}
			}
			Certificate[] certArrays = new Certificate[certSet.size()];
			return certSet.toArray(certArrays);
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			return null;
		}
	}
	
	private static boolean verifyJNISign()
	{
		String jarFilePath = PPLicAuthClientCore.class.getProtectionDomain().getCodeSource().getLocation().getPath();
		try
		{
			JarFile jar = new JarFile(jarFilePath, true);
			Certificate[] certs = verifyJarSign(jar);
			String pplicCaCertCN = "CN=PPLIC.com CA, O=www.PPLIC.com, ST=BEIJING, C=CN";
			if (certs == null || certs.length != 3)
			{
				// www.DoubleCA的根证书
				// PPLIC的二级CA证书
				// PPLIC的代码签名证书
				System.out.println("PPLIC的代码签名证书有3个，JNI库文件校验不通过");
				return false;
			}
			else
			{
				// 验证证书
				CertificateFactory cf = CertificateFactory.getInstance("X.509");
				X509Certificate rootCert = (X509Certificate)cf.generateCertificate(new FileInputStream("D:\\works\\customsworks\\TestPPLicClientJNI\\resources\\DoubleCA.com ROOT CA.cer"));
				X509Certificate pplicCaCert = null;
				X509Certificate pplicSignCert = null;
				for (int i = 0; i < certs.length; i++)
				{
					X509Certificate cert = (X509Certificate)certs[i];
					if (cert.getSubjectDN().equals(rootCert.getSubjectDN()))
					{
						// 根证书
						if (cert.getSerialNumber().equals(rootCert.getSerialNumber()) == false || Arrays.equals(cert.getEncoded(), rootCert.getEncoded()) == false)
						{
							// 根证书校验失败
							System.out.println("www.DoubleCA.com的根证书校验失败");
							return false;
						}
						System.out.println(rootCert.getSubjectDN().getName() + " 通过校验");
					}
					else if (cert.getIssuerDN().equals(rootCert.getSubjectDN()))
					{
						// pplic的CA证书校验
						pplicCaCert = cert;
						pplicCaCert.verify(rootCert.getPublicKey());
						if (pplicCaCertCN.equals(pplicCaCert.getSubjectDN().getName()) == false)
						{
							// 主题不匹配
							System.out.println("不是PPLIC的二级CA证书");
							return false;
						}
						System.out.println(pplicCaCert.getSubjectDN().getName() + " 通过校验");
						if (pplicSignCert != null)
						{
							// pplic的jar代码签名证书校验
							pplicSignCert.verify(pplicCaCert.getPublicKey());
							System.out.println(pplicSignCert.getSubjectDN().getName() + " 通过校验");
						}
					}
					else
					{
						// pplic的jar代码签名证书校验
						pplicSignCert = cert;
						if (pplicCaCert != null)
						{
							pplicSignCert.verify(pplicCaCert.getPublicKey());
							System.out.println(pplicSignCert.getSubjectDN().getName() + " 通过校验");
						}
					}
				}
				return true;
			}
		}
		catch(Exception ex)
		{
			// 异常，证书校验失败
			System.out.println("证书校验失败");
			ex.printStackTrace();
			return false;
		}
	}
	
	/**
	 * @param args
	 * @throws IOException
	 */
	// 支持Windows x86/64 Linux x86/64 MacOS x64
	// JDK6及以上
	public static void main(String[] args) throws IOException
	{
		// TODO Auto-generated method stub
		// 一定要校验jar的代码签名，即使不使用PPLIC也要进行代码签名校验，否则文件容易被替换掉
		// 可以去www.DoubleCA.com申请免费的代码签名证书，也可以定制自己的CA系统发数字证书，很便宜
		if (verifyJNISign() == false)
		{
			return;
		}
		else
		{
			System.out.println("JNI库文件代码验证通过");
		}
	}

	// 申请码
	public static String generateLicRequest(){

		PPLicAuthClientCore a = new PPLicAuthClientCore();
		byte[] buffer = new byte[1024 * 20];
		int result = a.GenerateLicRequest(buffer);
		if (result == PPLicAuthClientCore.PPLIC_SYSTEM_SUCCESS){
			return "授权请求数据编码：\r\n" + new String(buffer).trim();
		}else{
			return "生成授权请求数据出错，错误码：0x" + Integer.toHexString(result);
		}
	}
	// 保存授权码
	public static Map saveLicCode(String basecode){

		File file = new File(licensePath);

		if(!file.exists()){
			file.getParentFile().mkdirs();
			try {
				file.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		EncoderFile.mywrite(file,basecode);

		return validateLicDate();
	}

	// 校验
	public static Map validateLicDate(){

		Map resultMap = new HashMap();
		File file = new File(licensePath);
		if(!file.exists()){
			resultMap.put("isLicense",false);
			resultMap.put("message","授权时间验证失败，系统未授权");
			return resultMap;
		}

		//读取授权码文件，获取授权码
		String licenseCode = EncoderFile.myread(file).trim();

		PPLicAuthClientCore a = new PPLicAuthClientCore();
		int result = a.ValidateLic(projectSN, licenseCode, PPLicAuthClientCore.REQUEST_TYPE_DATE);

		if (result > PPLicAuthClientCore.PPLIC_SYSTEM_SUCCESS){
			resultMap.put("isLicense",false);
			resultMap.put("message","授权时间验证失败，错误编号：0x"+ Integer.toHexString(result));
			return resultMap;
		}else{
			if (result == 999999){
				resultMap.put("isLicense",true);
				resultMap.put("message","授权时间验证成功，授权有效期为：永久授权");
				return resultMap;
			}else{
				int days = result / 24;
				int hours = result % 24;
				Date now = new Date();
				long milliSeconds = result * 3600000L;
				Date endTime = new Date(now.getTime() + milliSeconds);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日 HH时");
				if (result > 0){
					resultMap.put("isLicense",true);
					resultMap.put("message","授权时间验证成功，授权有效期至[" + sdf.format(endTime) + "]，还有[" + days + "]天[" + hours + "]小时");
					return resultMap;
				}else if (result == 0){
					resultMap.put("isLicense",true);
					resultMap.put("message","授权时间验证成功，授权即将过期");
					return resultMap;
				}else{
					resultMap.put("isLicense",false);
					resultMap.put("message","授权时间验证成功，授权有效期至[" + sdf.format(endTime) + "]，已过期[" + Math.abs(days) + "]天[" + Math.abs(hours) + "]小时");
					return resultMap;
				}
			}
		}
	}

}
