package com.qdu.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qdu.aop.SystemLog;
import com.qdu.pojo.Clazz;
import com.qdu.pojo.ClazzStu;
import com.qdu.pojo.Course;
import com.qdu.pojo.Feedback;
import com.qdu.pojo.StudentInfo;
import com.qdu.pojo.Teacher;
import com.qdu.qr.SignInQr;
import com.qdu.qr.testQR;
import com.qdu.service.ClazzService;
import com.qdu.service.ClazzStuService;
import com.qdu.service.CourseService;
import com.qdu.service.LogEntityService;
import com.qdu.service.MessageService;
import com.qdu.service.QrTemService;
import com.qdu.service.StudentInfoService;
import com.qdu.service.TeacherService;

@Controller
@RequestMapping(value = "/course")
public class CourseController {

	@Autowired 
	CourseService courseServiceImpl;
	@Autowired
	TeacherService teacherServiceImpl;
	@Autowired
	ClazzService clazzServiceImpl;
	@Autowired
	StudentInfoService studentInfoServiceImpl;
	@Resource
	private ClazzStuService clazzStuServiceImpl;
	@Autowired
	private QrTemService qrTemServiceImpl;
	@Autowired 
	LogEntityService logEntityServiceImpl;


	// 教师添加课程
	@SystemLog(module="教师",methods="日志管理-添加课程")
	@RequestMapping(value = "/insertCourse.do")
	public @ResponseBody Map<String, Object> insertCourse(String teacherMobile,String courseName,String courseType,String classCapacity,
			@DateTimeFormat(pattern = "yyyy-MM-dd") Date startTime,@DateTimeFormat(pattern = "yyyy-MM-dd") Date endTime,
			@DateTimeFormat(pattern = "yyyy") Date currentYear,String schoolTem, ModelMap map,
			HttpServletRequest request) throws Exception {
		System.out.println("插入开始");
		Course course = new Course();
		Teacher teacher = teacherServiceImpl.selectTeacherByEmail(teacherMobile);
		course.setTeacher(teacher);
		course.setCourseName(courseName);
		course.setCourseType(courseType);
		course.setClassCapacity(Integer.parseInt(classCapacity));
		SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd");
		course.setStartTime(sdf1.format(startTime));
		course.setEndTime(sdf1.format(endTime));
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy");   
		course.setCurrentYear(Integer.parseInt(sdf.format(currentYear)));
		course.setSchoolTem(schoolTem);
		System.out.println(courseName +">>><<<"+startTime);
		courseServiceImpl.insertCourse(course);
		String teacherName = teacher.getTeacherName();
		String current = sdf.format(currentYear);
		String tem =schoolTem;
		Course course2 = courseServiceImpl.selectIdFromCourse(courseName, teacherMobile);
		int courseId = course2.getCourseId();
		System.out.println("courseId: " + courseId);
		String text = "http://192.168.11.202:8080/ClassManageSys/qr.jsp?teacherMobile=" + teacherMobile + "&courseId="
				+ courseId + "&courseName=" + courseName.replaceAll("\\+", "%2B") + "&teacherName=" + teacherName
				+ "&currentTime=" + current + "&tem=" + tem;
		testQR tQr = new testQR(text, courseName, teacherName);
		// 获取二维码图片名称
		String qrImg = tQr.createQR(request); 
		// 以更新的方式插入二维码图片信息回数据库
		courseServiceImpl.updateQrImg(course2.getCourseId(), qrImg);
		System.out.println(qrImg);
		Map<String, Object> userMap = new HashMap<String, Object>();
		userMap.put("message", "添加成功");
		return userMap;
	}
	//二维码扫描后
	@SystemLog(module="学生",methods="日志管理-扫码签到")
	@RequestMapping(value = "/createQrNew.do")
	public String createQrNew(ModelMap map, HttpServletRequest request) {
		System.out.println("进入");
		String teacherMobile = request.getParameter("teacherMobile");
		int courseId = Integer.parseInt(request.getParameter("courseId"));
		Teacher teacher = teacherServiceImpl.selectTeacherByEmail(teacherMobile);
		Course course = courseServiceImpl.selectCourseById(courseId);
		List<Clazz> clazzs = clazzServiceImpl.selectClazzByCourse(courseId);
		map.put("course", course);
		map.put("teacher", teacher);
		map.put("clazz", clazzs);
		return "qrStudent";
	}
    //查询课程通过id
	@SystemLog(module="教师",methods="日志管理-获取课程列表")
	@RequestMapping(value = "/forsearchClazz.do")
	public String forInsertClazz(int courseId,String teacherMobile, ModelMap map) {
		Course course = courseServiceImpl.selectCourseById(courseId);
		Teacher teacher = teacherServiceImpl.selectTeacherByEmail(teacherMobile);
		List<StudentInfo> studentInfos = studentInfoServiceImpl.selectInfoFromInfoAndStudent(courseId);
		List<ClazzStu> clazzStus = clazzStuServiceImpl.selectClazzStuListByCourse(courseId);
		map.put("clazzStus", clazzStus);
		map.put("studentInfo", studentInfos);
		map.put("course", course);
		map.put("teacher", teacher);
		return "clazzInfo";
	}
    //修改课程信息准备
	@RequestMapping(value = "/forChangeCousrInfo.do")
	public String forChangeCousrInfo(int courseId, ModelMap map) {
		Course course = courseServiceImpl.selectCourseById(courseId);
		map.put("course", course);
		return "changeCourse";
	}
    //修改课程信息
	@SystemLog(module="教师",methods="日志管理-修改课程")
	@RequestMapping(value = "/changeCourse.do")
	@ResponseBody
	public Map<String, Object> changeCourse(String teacherMobile,int courseId, String courseName,String courseType,int classCapacity,
			@DateTimeFormat(pattern = "yyyy-MM-dd") Date startTime,@DateTimeFormat(pattern = "yyyy-MM-dd") Date endTime, int currentYear,String schoolTem,HttpServletRequest request) throws Exception {
		Map<String, Object> map = new HashMap<>();
		long time1 = startTime.getTime();
		long time2 = endTime.getTime();
		if(time1 < time2){
			courseServiceImpl.updateCourse(courseName, courseType, classCapacity, startTime, endTime, currentYear, schoolTem, courseId);
			Teacher teacher = teacherServiceImpl.selectTeacherByEmail(teacherMobile);
			String teacherName = teacher.getTeacherName();
			String current = currentYear +"";
			String text = "http://192.168.11.202:8080/ClassManageSys/qr.jsp?teacherMobile=" + teacherMobile + "&courseId="
					+ courseId + "&courseName=" + courseName.replaceAll("\\+", "%2B") + "&teacherName=" + teacherName
					+ "&currentTime=" + current + "&tem=" + schoolTem;
			testQR tQr = new testQR(text, courseName, teacherName);
			String qrImg = tQr.createQR(request);
			courseServiceImpl.updateQrImg(courseId, qrImg);
			map.put("result", true);
		}else {
			map.put("result", false);
		} 
		return map;
	}
    //删除课程信息通过id
	@SystemLog(module="教师",methods="日志管理-删除课程")
	@RequestMapping(value = "/deleteCourseById.do")
	public @ResponseBody Map<String, Object> messageTarget(int courseId) {
		studentInfoServiceImpl.deleteStudentInfoByCourse(courseId);
		List<Clazz> clazzs = clazzServiceImpl.clazzListByClazzId(courseId);
		for (Clazz clazz : clazzs) {
			clazzServiceImpl.updateClazzByCourseId(clazz.getClazzId());
		}
		courseServiceImpl.deleteCourseById(courseId);
		Map<String, Object> userMap = new HashMap<String, Object>();
		userMap.put("messages", "删除成功");
		return userMap;
	}
	//获取本课程本节课签到图片
	@SystemLog(module="教师",methods="日志管理-获取签到二维码")
	@RequestMapping(value = "/getQrImg.do")
	@ResponseBody
	public Map<String, Object> getQrImg(int courseId,String teacherMobile,HttpServletRequest request) throws Exception{
		qrTemServiceImpl.deleteQrTemByCourseId(courseId);
		Course course = courseServiceImpl.selectCourseById(courseId);
		Teacher teacher = teacherServiceImpl.selectTeacherByEmail(teacherMobile);
		String teacherName = teacher.getTeacherName();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String currentTime = sdf.format(date);
		System.out.println(currentTime);
		String text = "http://192.168.11.202:8080/ClassManageSys/newSignIn.jsp?teacherName=" + teacherName + "&courseId="
				+ courseId + "&courseName=" + course.getCourseName().replaceAll("\\+", "%2B") 
				+ "&currentTime=" + currentTime;
		 String time = new SimpleDateFormat("YYYY-MM-dd-HH-mm-ss").format(new Date());
		SignInQr signInQr = new SignInQr(text, time, teacherName);
		// 获取二维码图片名称
		String url = signInQr.createQR(request);
		Map<String, Object> map = new HashMap<>();
		map.put("url", url);
		return map;
	}
	//查询是否课程编码有效
	@SystemLog(module="学生",methods="日志管理-查看课程有效性")
	@RequestMapping(value = "/searchIfExistCourse.do")
	@ResponseBody
	public Map<String, Object> searchIfExistCourse(int courseId){
		Map<String, Object> map = new HashMap<>();
		Course course = courseServiceImpl.selectCourseIdById(courseId);
		if(course != null){
			List<Clazz> clazzs = clazzServiceImpl.selectClazzNameByCourse(courseId);
			if(clazzs.size() > 0){
				map.put("clazzs", clazzs); 
				map.put("result", true);
				System.out.println(clazzs.get(0).getClazzName());
				
			}else {
				map.put("result", true);
				map.put("clazzs", null);
			}
		}else {
			map.put("result", false);
			map.put("clazzs", null);
		}
		return map;
	}
	
	//反馈
@RequestMapping(value = "/insertFeedback.do")
@ResponseBody
public Map<String, Object> insertFeedback(String returnInfoToAdmin){
	System.out.println(returnInfoToAdmin);
	Map<String, Object> map = new HashMap<>();
	Feedback feedback = new Feedback();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-DD HH:mm");
	feedback.setCurrentTime(sdf.format(new Date()));
	feedback.setFeedbackContent(returnInfoToAdmin);
	feedback.setResult("未解决");
	int tem = logEntityServiceImpl.insertFeedback(feedback);
	if(tem > 0){
		map.put("result", true);
	}
	else {
		map.put("result", false); 
	}
	return map;
}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
