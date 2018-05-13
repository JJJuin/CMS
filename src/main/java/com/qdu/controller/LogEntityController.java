package com.qdu.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qdu.aop.SystemLog;
import com.qdu.cache.RedisCache;
import com.qdu.pojo.Admin;
import com.qdu.pojo.Feedback;
import com.qdu.pojo.LogEntity;
import com.qdu.pojo.Message;
import com.qdu.pojo.MyBlog;
import com.qdu.pojo.Student;
import com.qdu.pojo.Teacher;
import com.qdu.service.LogEntityService;
import com.qdu.service.MessageService;
import com.qdu.service.MyBlogService;
import com.qdu.service.StudentService;
import com.qdu.service.TeacherService;
import com.qdu.util.Page;
import com.qdu.websocket.WebSocketConnection;
//超级管理员+相关操作
@Controller
@RequestMapping(value="/admin")
public class LogEntityController {

	@Autowired 
	LogEntityService logEntityServiceImpl;
	@Autowired 
	StudentService studentServiceImpl;
	@Autowired 
	TeacherService teacherServiceImpl;
	@Autowired 
	private MyBlogService myBlogServiceImpl;
	@Autowired
	private MessageService messageServiceImpl;
	
	
	
	//超管准备登录
	@RequestMapping(value="/forAdminLogin.do")
	public String forAdminLogin(ModelMap map) {
		return "adminPage";
	} 
	
	//超级管理员登录准备
	@RequestMapping(value = "/ConfirmAdminCount.do")
	@ResponseBody
	public Map<String, Object> adminLogin(String adminId,String adminPassword, HttpServletRequest request){
		Map<String, Object> map = new HashMap<>();
		Admin admin = logEntityServiceImpl.selectAdminById(adminId);
		if(admin != null && adminPassword.equals(admin.getAdminPassword())){
			map.put("result", true);
		}
		else {
			map.put("result", false); 
		}
		return map;
	}
	//管理员登录
	@RequestMapping(value = "/adminLogin.do",method = RequestMethod.POST)
	public String adminLogin(ModelMap map,HttpServletRequest request){
		List<LogEntity> logEntities = new ArrayList<LogEntity>();
		    List<Student> students = studentServiceImpl.selectStuList();
		    List<Teacher> teachers = teacherServiceImpl.selectTeacher();
		    List<LogEntity> teacherLogEntitys = logEntityServiceImpl.selectTeacherLogEntity();
		    List<LogEntity> studentLogEntitys = logEntityServiceImpl.selectStudentLogEntity();
		    List<MyBlog> myBlogs = myBlogServiceImpl.selectMyBlogByVerify();
		    List<Feedback> feedbacks = logEntityServiceImpl.selectFeedback();
		    map.put("feedbacks", feedbacks);
			map.put("logEntities", logEntities);
			map.put("myBlogs", myBlogs);
			map.put("students", students);
			map.put("teachers", teachers);
			map.put("teacherLogEntitys", teacherLogEntitys);
			map.put("studentLogEntitys", studentLogEntitys);
		return "superManagerPage";
	}
	//超级管理员登录准备
		@RequestMapping(value = "/clearRedis.do")
		@ResponseBody
		public Map<String, Object> clearRedis(){
			Map<String, Object> map = new HashMap<>();
			 new RedisCache("com.qdu.mapping.AdminMapping").clear();
	    	 new RedisCache("com.qdu.mapping.ClazzMapping").clear();
	    	 new RedisCache("com.qdu.mapping.ClazzStuMapping").clear();
	    	 new RedisCache("com.qdu.mapping.CourseMapping").clear();
	    	 new RedisCache("com.qdu.mapping.ExaminationMapping").clear();
	    	 new RedisCache("com.qdu.mapping.FilePackageMapping").clear();
	    	 new RedisCache("com.qdu.mapping.LeaveRecordMapping").clear();
	    	 new RedisCache("com.qdu.mapping.LogEntityMapping").clear();
	    	 new RedisCache("com.qdu.mapping.MessageMapping").clear();
	    	 new RedisCache("com.qdu.mapping.PackMapping").clear();
	    	 new RedisCache("com.qdu.mapping.QrTemMapping").clear();
	    	 new RedisCache("com.qdu.mapping.ShortAnswerMapping").clear();
	    	 new RedisCache("com.qdu.mapping.SingleSelectionMapping").clear();
	    	 new RedisCache("com.qdu.mapping.StudentInfoMapping").clear();
	    	 new RedisCache("com.qdu.mapping.StudentMapping").clear();
	    	 new RedisCache("com.qdu.mapping.TeacherMapping").clear();
	    	 new RedisCache("com.qdu.mapping.TestMapping").clear();
			map.put("result", true);
			return map;
		}
		
   //管理员通过审核的博文
	@RequestMapping(value = "/updateBlogofVerify.do")
	@ResponseBody
	public Map<String, Object> updateBlogofVerify(int blogId){
		Map<String, Object> map = new HashMap<>();
		MyBlog myBlog = myBlogServiceImpl.selectMyBlogById(blogId);
		myBlog.setVerify("审核通过");
		int tem = myBlogServiceImpl.updateBlogofVerify(myBlog);
		
		Message message = new Message();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		message.setMessageSender("系统消息");
		message.setMessageAccepter(myBlog.getBlogAuthor());
		message.setMessageTitle("博文审核通过！");
		message.setSendTime(sdf.format(new Date()));
		message.setHaveRead("未读");
		message.setMessageContent("<span style='color:#FF5722'>恭喜！</span><br/>博文标题为<<"+ myBlog.getBlogTitle() + ">>通过审核！");
		message.setMessageType("admin");
		messageServiceImpl.insertMessage(message);
		int messageCount = messageServiceImpl.selectMessageCount(myBlog.getBlogAuthor());
		 WebSocketConnection.sendMessageToUser(myBlog.getBlogAuthor(), messageCount+"");
		if(tem > 0){
			map.put("result", true);
		}else {
			map.put("result", false);
		}
		return map;
	}
	//管理员批量审核博文
		@RequestMapping(value = "/passBlogByCheck.do")
		@ResponseBody
		public Map<String, Object> passBlogByCheck(String blogIds){
			Map<String, Object> map = new HashMap<>();
			System.out.println(blogIds);
			String[] divideBlogId = blogIds.split(" ");
			int tem = 0;
			for(int i = 0; i < divideBlogId.length; i ++){
				MyBlog myBlog = myBlogServiceImpl.selectMyBlogById(Integer.parseInt(divideBlogId[i]));
				if(myBlog != null){
				myBlog.setVerify("审核通过！");
				tem += myBlogServiceImpl.updateBlogofVerify(myBlog);
				Message message = new Message();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				message.setMessageSender("系统消息");
				message.setMessageAccepter(myBlog.getBlogAuthor());
				message.setMessageTitle("博文审核通过");
				message.setSendTime(sdf.format(new Date()));
				message.setHaveRead("未读");
				message.setMessageContent("<span style='color:#FF5722'>恭喜！</span><br/>博文标题为<<"+ myBlog.getBlogTitle() + ">>通过审核！");
				message.setMessageType("admin");
				messageServiceImpl.insertMessage(message);
				int messageCount = messageServiceImpl.selectMessageCount(myBlog.getBlogAuthor());
				 WebSocketConnection.sendMessageToUser(myBlog.getBlogAuthor(), messageCount+"");
				}
			}
			if(tem == divideBlogId.length){
				map.put("result", true);
			}else {
				map.put("result", false);
			}
			return map;
		}
	
	//管理员不通过审核的博文
		@RequestMapping(value = "/updateBlogofVerifySecond.do")
		@ResponseBody
		public Map<String, Object> updateBlogofVerifySecond(int blogId){
			Map<String, Object> map = new HashMap<>();
			MyBlog myBlog = myBlogServiceImpl.selectMyBlogById(blogId);
			myBlog.setVerify("审核未通过");
			int tem = myBlogServiceImpl.updateBlogofVerify(myBlog);
			
			Message message = new Message();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			message.setMessageSender("系统消息");
			message.setMessageAccepter(myBlog.getBlogAuthor());
			message.setMessageTitle("博文审核未通过！");
			message.setSendTime(sdf.format(new Date()));
			message.setHaveRead("未读");
			message.setMessageContent("<span style='color:#FF5722'>抱歉！</span><br/>由于内容违反相关法律法规，博文标题为<<"+ myBlog.getBlogTitle() + ">>未通过审核！"
					+ "请自觉维护网络环境");
			message.setMessageType("admin");
			 messageServiceImpl.insertMessage(message);
			 int messageCount = messageServiceImpl.selectMessageCount(myBlog.getBlogAuthor());
			 WebSocketConnection.sendMessageToUser(myBlog.getBlogAuthor(), messageCount+"");
			if(tem > 0){
				map.put("result", true);
			}else {
				map.put("result", false);
			}
			return map;
		}
		
	//管理员批量不通过博文
	@RequestMapping(value = "/dontpassBlogByCheck.do")
	@ResponseBody
	public Map<String, Object> dontpassBlogByCheck(String blogIds){
		Map<String, Object> map = new HashMap<>();
		System.out.println(blogIds);
		String[] divideBlogId = blogIds.split(" ");
		int tem = 0;
		for(int i = 0; i < divideBlogId.length; i ++){
			MyBlog myBlog = myBlogServiceImpl.selectMyBlogById(Integer.parseInt(divideBlogId[i]));
			if(myBlog != null){
				myBlog.setVerify("审核未通过");
				tem += myBlogServiceImpl.updateBlogofVerify(myBlog);
				Message message = new Message();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				message.setMessageSender("系统消息");
				message.setMessageAccepter(myBlog.getBlogAuthor());
				message.setMessageTitle("博文审核未通过!");
				message.setSendTime(sdf.format(new Date()));
				message.setHaveRead("未读");
				message.setMessageContent("<span style='color:#FF5722'>抱歉！</span><br/>由于内容违反相关法律法规，博文标题为<<"+ myBlog.getBlogTitle() + ">>未通过审核！"
						+ "请自觉维护网络环境");
				message.setMessageType("admin");
				 messageServiceImpl.insertMessage(message);
				 int messageCount = messageServiceImpl.selectMessageCount(myBlog.getBlogAuthor());
				 WebSocketConnection.sendMessageToUser(myBlog.getBlogAuthor(), messageCount+"");
			}
		}
		if(tem == divideBlogId.length){
			map.put("result", true);
		}else {
			map.put("result", false);
		}
		return map;
	}		
		
		//管理员解决反馈
	@RequestMapping(value = "/resolveFeedback.do")
	@ResponseBody
	public Map<String, Object> beforResolveFeedback(int feedbackId,String reson){
		Map<String, Object> map = new HashMap<>();
		int tem =  logEntityServiceImpl.updateFeedbackOfReson(feedbackId, reson, "已解决");
		if(tem > 0){
			map.put("result", true);
		}else {
			map.put("result", false);
		}
		return map;
	}	
		
		
		
		
		
		
	
}
