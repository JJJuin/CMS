package com.qdu.util;

import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.MatOfRect;
import org.opencv.core.Point;
import org.opencv.core.Rect;
import org.opencv.core.Scalar;
import org.opencv.core.Size;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;
import org.opencv.objdetect.CascadeClassifier;

public class DetectFaceTest {

	 static{  
	        // 载入opencv的库  
	        String opencvpath =  System.getProperty("user.dir") + "\\opencv\\x64\\";
	        System.out.println(opencvpath);
	        String opencvDllName = opencvpath + Core.NATIVE_LIBRARY_NAME + ".dll";  
	       
	        System.load(opencvDllName);
	    }  
	  

	    /**  
	     * opencv实现人脸识别  
	     * @param imagePath  
	     * @param outFile  
	     * @throws Exception  
	     */  
	    public int detectFace(String imagePath,  String outFile) throws Exception  
	    {  
	  
	        System.out.println("Running DetectFace ... ");  
	        // 从配置文件lbpcascade_frontalface.xml中创建一个人脸识别器，该文件位于opencv安装目录中  
	        CascadeClassifier faceDetector = new CascadeClassifier(  
	                "D:\\opencv\\sources\\data\\haarcascades\\haarcascade_frontalface_alt.xml");  
	  
	        Mat image = Imgcodecs.imread(imagePath);  
	  
	        // 在图片中检测人脸  
	        MatOfRect faceDetections = new MatOfRect();  
	  
	        faceDetector.detectMultiScale(image, faceDetections);  
	  
	        System.out.println(String.format("Detected %s faces", faceDetections.toArray().length));  
	  
	        Rect[] rects = faceDetections.toArray();  
	        if(rects != null && rects.length > 1){  
	            System.err.println("超过一个脸"); 
	                return 2;
	        }else if (rects.length == 0 || rects == null) {
	        	 System.err.println("没有发现人脸"); 
		            return 0;
			}else{
				// 在每一个识别出来的人脸周围画出一个方框  
		        Rect rect = rects[0];  
		  
		        Imgproc.rectangle(image, new Point(rect.x-2, rect.y-2),  
		                          new Point(rect.x + rect.width, rect.y + rect.height),  
		                          new Scalar(0, 255, 0));  
		  
		        Imgcodecs.imwrite(outFile, image);  
		        //截取的区域：参数,坐标X,坐标Y,截图宽度,截图长度  
		        //Rect rect2 = new Rect(rect.x-2, rect.y-2,rect.x + rect.width, rect.y + rect.height);  
		  
		        //两句效果一样  
		        Mat sub = image.submat(rect);   //Mat sub = new Mat(image,rect);  
		        Mat mat = new Mat();  
		        Size size = new Size(300, 300);  
		        Imgproc.resize(sub, mat, size);//将人脸进行截图并保存  
		  
		        Imgcodecs.imwrite(outFile, mat);  
		       
	            System.out.println(String.format("人脸识别成功，人脸图片文件为： %s", outFile));  
	            System.out.println(String.format("图片裁切成功，裁切后图片文件为： %s", outFile));  
	            return 1;
			}  
	        
	  
	    } 
	    
	    /**  
	     * 裁剪图片并重新装换大小  
	     * @param imagePath  
	     * @param posX  
	     * @param posY  
	     * @param width  
	     * @param height  
	     * @param outFile  
	     */  
	    public void imageCut(String imagePath,String outFile, int posX,int posY,int width,int height ){  
	  
	        //原始图像  
	        Mat image = Imgcodecs.imread(imagePath);  
	  
	        //截取的区域：参数,坐标X,坐标Y,截图宽度,截图长度  
	        Rect rect = new Rect(posX,posY,width,height);  
	  
	        //两句效果一样  
	        Mat sub = image.submat(rect);   //Mat sub = new Mat(image,rect);  
	  
	        Mat mat = new Mat();  
	        Size size = new Size(300, 300);  
	        Imgproc.resize(sub, mat, size);//将人脸进行截图并保存  
	  
	        Imgcodecs.imwrite(outFile, mat);  
	        System.out.println(String.format("图片裁切成功，裁切后图片文件为： %s", outFile));  
	  
	    }  
	  

}
