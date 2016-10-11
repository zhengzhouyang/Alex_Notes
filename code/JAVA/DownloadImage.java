/******************************************************************************************************************************

** File Name    : DownloadImage.java

** Author       : Alex (Zhouyang Zheng)

** Call Syntax  : javac *.java THEN  java filename(not include class) OR run in IDE

** Requirements : IDE OR
** Requirements : JDK(Java Development Kit) & set up environment variables(JAVA_HOME,CLASSPATH,PATH)

** Modified     : 09/23/2016

** Description  : Download a image through URL

******************************************************************************************************************************/

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;

public class DownloadImage 
{
	public static void main(String[] args) throws Exception
	{
		try
		{
			String filename="digital_image_processing.jpg";
			String website="http://tutorialspoint.com/java_dip/images/"+filename;
			System.out.println("Downloading file from "+website);
			URL url= new URL(website);
			InputStream inputStream=url.openStream();
			OutputStream outputStream=new FileOutputStream(filename);
			byte[] buffer=new byte[2048];
			int length=0;
			while((length=inputStream.read(buffer))!=-1)
			{
				System.out.println("Buffer Read of length: "+ length);
				outputStream.write(buffer,0,length);
			}
			inputStream.close();
			outputStream.close();
		}
		catch(IOException e)
		{
			System.out.println(e.toString());
		}
	}
}
