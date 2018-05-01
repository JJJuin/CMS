package com.qdu.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class CopyFile {

	public static void copyFile(String src,String target)  
    {     
        File srcFile = new File(src);    
           File targetFile = new File(target);    
           try {    
               InputStream in = new FileInputStream(srcFile);     
               OutputStream out = new FileOutputStream(targetFile);    
               byte[] bytes = new byte[1024];    
               int len = -1;    
               while((len=in.read(bytes))!=-1)  
               {    
                   out.write(bytes, 0, len);    
               }    
               in.close();    
               out.close();    
           } catch (FileNotFoundException e) {    
               e.printStackTrace();    
           } catch (IOException e) {    
               e.printStackTrace();    
           }    
           System.out.println("文件复制成功");   


    }  
}
