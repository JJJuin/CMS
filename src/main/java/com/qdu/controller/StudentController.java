 package com.qdu.controller;

import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.qdu.aop.SystemLog;
import com.qdu.pojo.Clazz;
import com.qdu.pojo.ClazzStu;
import com.qdu.pojo.Course;
import com.qdu.pojo.Feedback;
import com.qdu.pojo.LeaveRecord;
import com.qdu.pojo.LogEntity;
import com.qdu.pojo.Message;
import com.qdu.pojo.MyBlog;
import com.qdu.pojo.QrTem;
import com.qdu.pojo.Student;
import com.qdu.pojo.StudentInfo;
import com.qdu.pojo.StudentInfoDetail;
import com.qdu.pojo.Teacher;
import com.qdu.service.ClazzService;
import com.qdu.service.ClazzStuService;
import com.qdu.service.CourseService;
import com.qdu.service.LeaveRecordService;
import com.qdu.service.LogEntityService;
import com.qdu.service.MessageService;
import com.qdu.service.MyBlogService;
import com.qdu.service.QrTemService;
import com.qdu.service.StudentInfoService;
import com.qdu.service.StudentService;
import com.qdu.service.TeacherService;
import com.qdu.util.GlobalVariable;
import com.qdu.util.JavaEmailSender;
import com.qdu.util.MD5Util;
import com.qdu.util.Page;
import com.qdu.util.ResponseUtil;
import com.qdu.util.VertifyCodeUtil;
import com.qdu.websocket.WebSocketConnection;

@Controller
@RequestMapping(value = "/student")
public class StudentController {
	@Autowired
	private StudentService studentServiceImpl;
	@Autowired
	private ClazzService clazzServiceImpl;
	@Autowired
	private QrTemService qrTemServiceImpl;
	@Autowired
	private CourseService courseServiceImpl;
	@Autowired
	private StudentInfoService studentInfoServiceImpl;
	@Autowired
	private MessageService messageServiceImpl;
	@Autowired
	private TeacherService teacherServiceImpl;
	@Autowired 
	private LogEntityService logEntityServiceImpl;
	@Autowired 
	private ClazzStuService clazzStuServiceImpl;
	@Autowired
	private LeaveRecordService leaveRecordServiceImpl;
	@Autowired 
	private MyBlogService myBlogServiceImpl;
	

	// 学生登录
	@RequestMapping(value = "/studentLogin.do",method = RequestMethod.POST)
	@SystemLog(module = "学生", methods = "日志管理-登录/刷新")
	public String studentLogin(HttpServletRequest request, String pageNow, String studentRoNo, String password,
			ModelMap map) {
		if (studentRoNo == null) {
			studentRoNo = request.getParameter("studentRoNo");
		}
		if (password == null) {
			password = request.getParameter("studentPassword");
		}
		System.out.println("正经登陆");
		Student student2 = studentServiceImpl.selectStudentByNo(studentRoNo);
		if (student2 != null) {
			if (MD5Util.md5(password, "juin").equals(student2.getStudentPassword()) || password.equals(student2.getStudentPassword())) {
				if (pageNow == null) {
					pageNow = 1 + "";
				}
				List<LogEntity> logEntities = logEntityServiceImpl.selectStudentLog(studentRoNo);
				map.put("logEntity", logEntities);
				List<MyBlog> myBlogs = myBlogServiceImpl.selectMyBlogByNoFilter(); 
				map.put("myBlogs", myBlogs);
				List<StudentInfo> studentInfos2 = studentInfoServiceImpl.selectStudentInfoList(studentRoNo);
				map.put("studentInfos2", studentInfos2);
				List<StudentInfo> studentInfos = studentInfoServiceImpl.selectCourseByStudentRono(studentRoNo);
				map.addAttribute("studentInfos", studentInfos);
				map.addAttribute("student", student2);
				int messageCount = messageServiceImpl.selectMessageCount(studentRoNo);
				map.put("messageCount", messageCount);
				// session的id存一下
				request.getSession().setAttribute("UserId", null);
				request.getSession().setAttribute("UserId", studentRoNo);
				return "studentPage";
			}
		}
		return "failer";
	}
	//学生注销登录
		@SystemLog(module = "学生", methods = "日志管理-注销")
		@RequestMapping(value = "/exitLogin.do")
		@ResponseBody
		public void exitLogin(String studentRoNo,HttpServletRequest request){
			// session的id存一下
			request.getSession().setAttribute("UserId", studentRoNo);
			//数据库记录注销
		}

	// 学生等待审核
	@RequestMapping(value = "/waitForRegister.do")
	public String waitForRegister() {
		return "waitForRegister";
	}

	// ajax验证学号是否已经存在
	@SystemLog(module = "学生", methods = "日志管理-验证账号")
	@RequestMapping(value = "/confirmExitsStudent.do")
	public @ResponseBody Map<String, Object> confirmExitsStudent(HttpServletRequest request, String studentRoNo) {
		System.out.println("ajax探测用户学号是否存在" + studentRoNo);
		Map<String, Object> map = new HashMap<>();
		Student student = studentServiceImpl.selectStudentByNo(studentRoNo);
		if (student == null && studentRoNo != null) {
			map.put("result", true);
		} else {
			map.put("student", student);
			map.put("result", false);
		}
		return map;
	}

	// ajax验证学生密码是否正确
	@SystemLog(module = "学生", methods = "日志管理-学生登录密码验证")
	@ResponseBody
	@RequestMapping(value = "/confirmStudentPassWord.do")
	public Map<String, Object> confirmStudentPassWord(String studentRono, String password) {
		Map<String, Object> map = new HashMap<>();
		Student student = studentServiceImpl.selectStudentByNo(studentRono);
		System.out.println(MD5Util.md5(password, "juin"));
		if (student != null && (MD5Util.md5(password, "juin").equals(student.getStudentPassword()) || password.equals(student.getStudentPassword()))) {
			map.put("result", true);
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 通过clazz找student
	@SystemLog(module = "教师", methods = "日志管理-获取学生列表")
	@RequestMapping(value = "/selectStudentByClazzId.do")
	@ResponseBody
	public Map<String, Object> selectStudentByClazzId(int clazzId) {
		Map<String, Object> map = new HashMap<>();
		List<Student> students = new ArrayList<>();
		List<ClazzStu> clazzStus = clazzStuServiceImpl.selectClazzStuById(clazzId);
		for(ClazzStu clazzStu: clazzStus){
			Student student = studentServiceImpl.selectStudentByNo(clazzStu.getStudent().getStudentRoNo());
			students.add(student);
		}
		int count = clazzServiceImpl.selectCountOfStudentByClazz(clazzId);
		Clazz clazz = clazzServiceImpl.selectClazzById(clazzId);
		map.put("clazzName", clazz.getClazzName());
		map.put("count", count);
		map.put("students", students);
		return map;
	}

	// 查找临时表学生信息
	@RequestMapping(value = "/selectStudentTemById.do")
	public String selectStudentTemById(ModelMap map, HttpServletRequest request) {
		String rono = request.getParameter("studentRoNo");
		Student student = studentServiceImpl.selectStudentByNo(rono);
		if (student != null) {
			map.addAttribute("student", student);
			return "showInfo";
		} else
			return "failer";
	}

	// 跳转到新建学生页面
	@RequestMapping(value = "/addStudent.do")
	public String addStudent(ModelMap map) {
		return "addStudent";
	}

	// 学生注册
	@RequestMapping(value = "/insertStudent.do", method = RequestMethod.POST)
	@SystemLog(module = "学生", methods = "日志管理-注册")
	public String insertTemporary(HttpServletRequest request, @RequestParam("file") MultipartFile file, ModelMap map,
			Student student) {
		String path = request.getSession().getServletContext().getRealPath("/") + "studentPhoto";
		System.out.println(path);
		String fileName = file.getOriginalFilename();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-DD-HH-mm-ss");
		System.out.println(fileName);
		String nameNow = sdf.format(new Date())+"/"+fileName;
		File targetFile = new File(path, nameNow);
		if (!targetFile.exists()) {
			targetFile.mkdirs();
		}
		// 保存
		try {
			file.transferTo(targetFile);
		} catch (Exception e) {
			e.printStackTrace();
		}
		String password = request.getParameter("studentPassword");
		System.out.println(MD5Util.md5(password, "juin"));
		student.setStudentPassword(MD5Util.md5(password, "juin"));
		student.setStudentPhoto(nameNow);
		studentServiceImpl.insertStudentByNo(student);
		System.out.println("学生注册成功");  
		map.put("student", student);
		System.out.println(student.getStudentGender());
		request.getSession().setAttribute("UserId", null);
		request.getSession().setAttribute("UserId", student.getStudentRoNo());
		return "waitForRegister";
	}

	// 注册后跳转到首页
	@SystemLog(module = "学生", methods = "日志管理-跳转到首页")
	@RequestMapping(value = "/exchangeStudent.do")
	public String exchangeStudent(String studentRoNo,String pageNow, ModelMap map, HttpServletRequest request) {
		if(studentRoNo.equals(request.getSession().getAttribute("UserId"))){
			Student student = studentServiceImpl.selectStudentByNo(studentRoNo);
			List<StudentInfo> studentInfos = studentInfoServiceImpl.selectCourseByStudentRono(studentRoNo);
			if (pageNow == null) {
				pageNow = 1 + "";
			}
			Page page = null;
			int totalCount = messageServiceImpl.selectMessageTotalCount(studentRoNo);
			page = new Page(totalCount, Integer.parseInt(pageNow));
			int messageCount = messageServiceImpl.selectMessageCount(studentRoNo);
			map.put("messageCount", messageCount);
			List<LogEntity> logEntities = logEntityServiceImpl.selectStudentLog(studentRoNo);
			map.put("logEntity", logEntities);
			List<StudentInfo> studentInfos2 = studentInfoServiceImpl.selectStudentInfoList(studentRoNo);
			map.put("studentInfos2", studentInfos2);
			map.put("page", page);
			map.put("student", student);
			map.addAttribute("studentInfos", studentInfos);
			// session的id存一下
			request.getSession().setAttribute("UserId", null);
			request.getSession().setAttribute("UserId", studentRoNo);
			return "studentPage";
		}else {
			return "failer";
		}
		
	}

	// 学生更改密码
	@RequestMapping(value = "/updateStudentPassWord.do")
	@SystemLog(module = "学生", methods = "日志管理-更改密码")
	public String updateStudentPassWord(Student student, ModelMap map, HttpServletRequest request) {
		MD5Util.md5(student.getStudentPassword(), "juin");
		studentServiceImpl.updateStudentPassWord(student);
		String studentRoNo = request.getParameter("studentRoNo");
		System.out.println(studentRoNo);
		Student student2 = studentServiceImpl.selectStudentByNo(studentRoNo);
		map.put("student", student2);
		System.out.println(student.getStudentGender());
		request.getSession().setAttribute("UserId", null);
		request.getSession().setAttribute("UserId", student.getStudentRoNo());
		return "waitForRegister";
	}

	// 学生更换邮箱
	@SystemLog(module = "学生", methods = "日志管理-更换邮箱")
	@RequestMapping(value = "/changeStuMail.do")
	@ResponseBody
	public Map<String, Object> changeStuMail(String oldEmail,String studentRoNo, String studentEmail) throws Exception {
		Map<String, Object> map = new HashMap<>();
		Student student = studentServiceImpl.selectStudentByNo(studentRoNo);
		String EMAIL = oldEmail;
		String TITLE = student.getStudentName() + "更换邮箱";// 标题
		String CONTENT = "新邮箱为:" + "   " + "[" + oldEmail + "]" + "\n"; // 内容
		int tem = studentServiceImpl.changeStuMail(studentRoNo, studentEmail);
		if(tem > 0){
			JavaEmailSender.sendEmail(EMAIL, TITLE, CONTENT);
			map.put("result", true);
		}else {
			map.put("result", false);
		}
		return map;
	}

	// 学生签到
	@RequestMapping(value = "/insertQrTem.do")
	@SystemLog(module = "学生", methods = "日志管理-学生签到")
	@ResponseBody
	public Map<String, Object> insertQrTem(HttpServletRequest request, String studentRoNo, String password,
			int courseId, String qrTime, int validateCode) throws ParseException {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String currentTime = sdf.format(date);
		request.getSession().setAttribute("UserId", studentRoNo);
		Map<String, Object> map = new HashMap<>();
		StudentInfo studentInfo = studentInfoServiceImpl.selectStudentInfoByMany(studentRoNo, courseId);
		Boolean confirm = false;
			if (studentInfo != null) {
				confirm = true;
			}
		Student student = studentServiceImpl.selectStudentByNo(studentRoNo);
		if (confirm == false) {
			Student student2 = studentServiceImpl.selectStudentByNo(studentRoNo);
			if (student2 != null) {
				map.put("message", "您不在此课程内");
			} else
				map.put("message", "学号错误");
		} else if (!MD5Util.md5(password, "juin").equals(student.getStudentPassword())) {
			System.out.println(student.getStudentPassword());
			map.put("message", "密码错误");
		} else {
			QrTem tem = qrTemServiceImpl.selectQrTemByStuNoAndCourseId(studentRoNo, courseId);
			if (tem != null) {
				map.put("message", "请勿重复签到");
			} else {
				if (GlobalVariable.returnCode() != validateCode) {
					map.put("message", "验证码有误");
				} else {
					QrTem qrTem = new QrTem();
					qrTem.setCourseId(courseId);
					qrTem.setStudentRoNo(studentRoNo);
					qrTem.setQrTime(currentTime);
					qrTemServiceImpl.insertQrTem(qrTem);// 插到临时表稍后删除
					map.put("message", "签到成功！");
				}
			}
		}
		return map;
	}

	// 获取签到成功的学生列表
	@RequestMapping(value = "/getTemStudent.do")
	@ResponseBody
	public Map<String, Object> getTemStudent(int courseId) {
		System.out.println("获取签到列表");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String currentTime = sdf.format(date);
		Map<String, Object> map = new HashMap<>();
		List<QrTem> qrTems = qrTemServiceImpl.selectQrTemByCourseIdAndTime(courseId, currentTime);
		List<ClazzStu> clazzStus = new ArrayList<>();
		if (qrTems != null && qrTems.size() != 0) {
			for (QrTem qrTem : qrTems) { 
				ClazzStu clazzStu = clazzStuServiceImpl.selectClazzStuByCourse(qrTem.getStudentRoNo(), courseId);
				clazzStus.add(clazzStu);
			} 
		} else {
 		}
		map.put("clazzStuss", clazzStus);
		return map;
	}

	// 提交签到表
	@SystemLog(module = "教师", methods = "日志管理-提交签到列表")
	@RequestMapping(value = "/submitSignIn.do")
	@ResponseBody
	public Map<String, Object> submitSignIn(int courseId) {
		System.out.println("提交签到表");
		//年月日
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		//判断周几
		SimpleDateFormat week1 = new SimpleDateFormat("EEEE");
		Date date = new Date();
		String currentTime = sdf.format(date);
		String week = week1.format(date);
		int time = Integer.parseInt(currentTime.replaceAll("-", ""));
		Map<String, Object> map = new HashMap<>();
		List<StudentInfo> studentInfos = studentInfoServiceImpl.selectInfoList(courseId);
		Map<String, Integer> map2 = new HashMap<>();
		for (StudentInfo studentInfo : studentInfos) {
			map2.put(studentInfo.getStudent().getStudentRoNo(), 0);
		}
		List<QrTem> qrTems = qrTemServiceImpl.selectQrTemByCourseIdAndTime(courseId, currentTime);
		if (qrTems.isEmpty()) {
			map.put("message", "暂无学生签到");
		} else {
			for (QrTem qrTem : qrTems) {
				System.out.println("qr中的学号"+qrTem.getStudentRoNo());  
				StudentInfo studentInfo = studentInfoServiceImpl.selectStudentInfoByMany(qrTem.getStudentRoNo(),
						courseId);
				//更改map记录
				List<StudentInfoDetail> studentInfoDetails = studentInfoServiceImpl.selectStudentInfoDetailResult(qrTem.getStudentRoNo(), courseId, currentTime);
				StudentInfoDetail sid = new StudentInfoDetail();
				sid.setCourseId(courseId);
				sid.setStudentRoNo(qrTem.getStudentRoNo());
				sid.setCurrentTime(sdf2.format(new Date()));
				sid.setCurrentWeek(week);
				sid.setSignInStatus("签到");
				if(studentInfoDetails.size() == 0){
					sid.setCurrentCount(1);
				}else{
					int maxCount = studentInfoServiceImpl.selectMaxStudentInfoDetailResult(qrTem.getStudentRoNo(), courseId, currentTime);
					sid.setCurrentCount(maxCount+1);
				}
				int stuinfoDetailTem = studentInfoServiceImpl.insertStudentInfoDetailResult(sid);
				
				
				map2.put(qrTem.getStudentRoNo(), 1);
				int tem = studentInfo.getSignIn();
				System.out.println("tem :" + tem);
				int x = tem + 1;
				System.out.println("x: " + x);
				// 核心：跟新info表，成功+1
				studentInfoServiceImpl.updateStudentInfoAboutSignIn(studentInfo.getStudentInfoId(), x);
				// 删除在QrTem表中的记录，等待下次签到
				qrTemServiceImpl.deleteTemQrById(qrTem.getQrTemId());
				System.out.println("id: " + qrTem.getQrTemId());
			}
			//请假的+1
			for(String string : map2.keySet()){
				if(map2.get(string) == 0){
					List<LeaveRecord> leaveRecords = leaveRecordServiceImpl.selectLeaveRecordByStudentAndCourse(string, courseId, "同意");
				    //如果有 有效请假记录
					if(leaveRecords.size() > 0){
						//遍历有效请假记录
				    	for(int i = 0; i < leaveRecords.size(); i++){
				    		//得到Integer类型的请假时间，和当前时间比对
				    		int time1 = Integer.parseInt(leaveRecords.get(i).getLeaveTime().replaceAll("-", ""));
				    		int time2 = Integer.parseInt(leaveRecords.get(i).getReturnTime().replaceAll("-", ""));
				    		if(time1 <= time && time <= time2){
				    			StudentInfo studentInfo = studentInfoServiceImpl.selectStudentInfoByMany(string, courseId);
				    			//请假 +1
				    			int tem = studentInfo.getAskForLeave();
								int x = tem + 1;
								studentInfoServiceImpl.updateStudentInfoAboutLeave(studentInfo.getStudentInfoId(), x);
								//细节上也加一
								List<StudentInfoDetail> studentInfoDetails = studentInfoServiceImpl.selectStudentInfoDetailResult(string, courseId, currentTime);
								StudentInfoDetail sid = new StudentInfoDetail();
								sid.setCourseId(courseId);
								sid.setStudentRoNo(string);
								sid.setCurrentTime(sdf2.format(new Date()));
								sid.setCurrentWeek(week);
								sid.setSignInStatus("请假");
								if(studentInfoDetails.size() == 0){
									sid.setCurrentCount(1);
								}else{
									int maxCount = studentInfoServiceImpl.selectMaxStudentInfoDetailResult(string, courseId, currentTime);
								    sid.setCurrentCount(maxCount+1);
								}
								int stuinfoDetailTem2 = studentInfoServiceImpl.insertStudentInfoDetailResult(sid);
								//更改map记录
				    		    map2.put(string, 2);
								break;
				    		}
				    	}
				    }
				}
			}
			// 旷课不来的自动将旷课字段+1
			for (String string : map2.keySet()) {
				if (map2.get(string) == 0) {
					StudentInfo studentInfo = studentInfoServiceImpl.selectStudentInfoByMany(string, courseId);
					int tem = studentInfo.getAbsenteeism();
					int x = tem + 1;
					studentInfoServiceImpl.updateStudentInfoAboutAbs(studentInfo.getStudentInfoId(), x);
					//自然，细节上旷课不来的也要加一
					List<StudentInfoDetail> studentInfoDetails = studentInfoServiceImpl.selectStudentInfoDetailResult(string, courseId, currentTime);
					StudentInfoDetail sid = new StudentInfoDetail();
					sid.setCourseId(courseId);
					sid.setStudentRoNo(string);
					sid.setCurrentTime(sdf2.format(new Date()));
					sid.setCurrentWeek(week);
					sid.setSignInStatus("旷课");
					if(studentInfoDetails.size() == 0){
						sid.setCurrentCount(1);
					}else{
						int maxCount = studentInfoServiceImpl.selectMaxStudentInfoDetailResult(string, courseId, currentTime);
					    sid.setCurrentCount(maxCount+1);
					}
					int stuinfoDetailTem3 = studentInfoServiceImpl.insertStudentInfoDetailResult(sid);
				}
			}
			map.put("message", "成功");
		}
		return map;
	}

	// 签到数字（util类获取四位随机数）
	@SystemLog(module = "教师", methods = "日志管理-获取签到数字")
	@RequestMapping(value = "/getVertifyCode.do")
	@ResponseBody
	public Map<String, Object> getVertifyCode() {
		int code = VertifyCodeUtil.getVertifyCode();
		GlobalVariable globalVariable = new GlobalVariable(code);
		System.out.println(globalVariable.returnCode() + " ：寻人不知归处");
		Map<String, Object> map = new HashMap<>();
		map.put("code", code);
		return map;
	}

	// 学生找回密码
	@SystemLog(module = "学生", methods = "日志管理-找回密码(跳转)")
	@RequestMapping(value = "/getStudentPasswordBack.do")
	public String getStudentPasswordBack() {
		return "studentGetPasswordBack";
	}

	// 学生找回密码前的账号验证
	@SystemLog(module = "学生", methods = "日志管理-找回密码(验证+临时密码发放)")
	@RequestMapping(value = "/forStudentReGetPass.do")
	@ResponseBody
	public Map<String, Object> forStudentReGetPass(String studentRoNo, String name, String mobile, String mail,
			HttpServletRequest request) throws Exception {
		System.out.println("进来验证");
		Student student = studentServiceImpl.selectStudentByFour(studentRoNo, name, mobile, mail);
		Map<String, Object> map = new HashMap<>();
		if (student != null) {
			Random random = new Random();
			char a1 = (char) (random.nextInt(24) + 97);
			char a2 = (char) (random.nextInt(14) + 97);
			int x = random.nextInt(9000) + 1000;
			String cc = a1 + "" + x + a2;
			System.out.println(cc);
			studentServiceImpl.ajaxupdateStudentPassWord(studentRoNo, cc);
			String EMAIL = mail;
			String TITLE = student.getStudentName() + ",找回密码";// 标题
			String CONTENT = "临时密码为:" + "   " + "[" + cc + "]" + "\n" + "为了安全，请尽快使用此密码登录后修改密码"; // 内容
			JavaEmailSender.sendEmail(EMAIL, TITLE, CONTENT);
			map.put("result", true);
		} else {
			map.put("result", false);
			System.out.println("查无此人");
		}
		return map;
	}

	// ajax学生添加课程发信息给老师
	@SystemLog(module = "学生", methods = "日志管理-添加课程")
	@RequestMapping(value = "/atudentAddCourse.do")
	@ResponseBody
	public Map<String, Object> atudentAddCourse(int clazzId,String studentRono, String courseName, int courseId) {
		Map<String, Object> map = new HashMap<>();
		System.out.println("学生添加课程");
		String time = new SimpleDateFormat("YYYY-MM-dd HH:mm:ss").format(new Date());
		Course course = courseServiceImpl.selectCourseById(courseId);
		Teacher teacher = course.getTeacher();
		Clazz clazz = clazzServiceImpl.selectClazzById(clazzId);
		Student student = studentServiceImpl.selectStudentByNo(studentRono);
		StudentInfo studentInfo = studentInfoServiceImpl.selectStudentInfoByMany(studentRono, courseId);
		int count = studentInfoServiceImpl.selectCountOfStudentByStudentInfo(courseId);
		boolean tem = false;
			if(clazzStuServiceImpl.selectClazzStuByDouble(clazzId, studentRono) == null){
				tem = true;
		}else {
			tem = false;
		}
		if(tem == true && studentInfo == null && count+1 <= course.getClassCapacity()){
		Message message = new Message();
		message.setMessageSender(studentRono);
		message.setMessageAccepter(teacher.getTeacherMobile());
		message.setMessageTitle(student.getStudentName() + "同学("+clazz.getClazzName()+")申请加入课程： " + course.getCourseName() + "("
				+ course.getCurrentYear() + "/" + course.getSchoolTem() + ")");
		message.setSendTime(time);
		message.setHaveRead("未读");
		message.setMessageType("insertCourse");
		message.setMessageContent(courseId + "c" + clazz.getClazzId());
		messageServiceImpl.insertMessage(message);
		int messageCount = messageServiceImpl.selectMessageCount(teacher.getTeacherMobile());
		 WebSocketConnection.sendMessageToUser(teacher.getTeacherMobile(), messageCount+"");
		map.put("result", true);
		}else {
			map.put("result", false);
			if(count+1 > course.getClassCapacity()){
				map.put("message", "moreThan");
			}else {
				map.put("message", null);
			}
			
		}
		return map;
	}
	// ajax获取消息数量
		@RequestMapping(value = "/gggetMessageCount.do")
		@ResponseBody
		public Map<String, Object> gggetMessageCount(String studentRoNo) {
			Map<String, Object> map = new HashMap<>();
			int messages = messageServiceImpl.selectMessageCount(studentRoNo);
			map.put("message", messages);
			return map;
		}
		// 查看具体消息
		@SystemLog(module = "学生", methods = "日志管理-查看消息")
		@RequestMapping(value = "/getMessageByAjax.do")
		@ResponseBody
		public Map<String, Object> getMessageByAjax(int messageId) {
			Map<String, Object> map = new HashMap<>();
			messageServiceImpl.uodateMesageHaveread(messageId);
			Message message = messageServiceImpl.selectMessageById(messageId);
			Teacher teacher2 = teacherServiceImpl.selectTeacherNameByMobile(message.getMessageSender());
			map.put("teacher", teacher2);
			map.put("mmm", message);
			return map;
		}
		//ajax更新学生信息
		@SystemLog(module = "学生", methods = "日志管理-完善信息")
		@RequestMapping(value = "/updateStudentInfoByAjax.do")
		@ResponseBody
		public Map<String, Object> updateStudentInfoByAjax(String studentRono,String college,String special,
				@DateTimeFormat(pattern = "yyyy") Date intoSchoolYear,String schoolRecord,@DateTimeFormat(pattern = "yyyy-MM-dd") Date birthDay,String freeStyle){
			Map<String, Object> map = new HashMap<>();
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy");
			SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");
			Student student  =studentServiceImpl.selectStudentByNo(studentRono);
			if(college != null){
			student.setCollege(college);
			}
			if(special != null){
			student.setSpecial(special);
			}
			if(birthDay != null){
			student.setBirthDay(sdf2.format(birthDay));
			}
			if(freeStyle != null){
			student.setFreeStyle(freeStyle);
			}
			if(schoolRecord != null){
			student.setSchoolRecord(schoolRecord);
			}
			if(intoSchoolYear != null){
			student.setIntoSchoolYear(Integer.parseInt(sdf.format(intoSchoolYear)));
			}
			int tem = studentServiceImpl.updateStudentextra(student);
			if(tem > 0){
				map.put("result", true);
			}else {
				map.put("result", false);
			}
			return map;
		}
		//ajax查询日志记录通过时间
		@SystemLog(module = "学生", methods = "日志管理-通过时间查询日志")
		@RequestMapping(value = "/searchStudentLogByTime.do")
		@ResponseBody
		public Map<String, Object> searchStudentLogByTime(String coreKey,String logDate,String studentRono){
			Map<String, Object> map = new HashMap<>();
			List<LogEntity> logEntities = logEntityServiceImpl.selectStudentLogByTime(studentRono, logDate,coreKey);
			map.put("logEntities", logEntities);
			return map; 
		} 
		
		//查询收件箱消息分页
		@RequestMapping(value ="/getSeperratePage.do")
		//@SystemLog(module = "学生", methods = "日志管理-消息分页")
		public String getSeperratePage(
				String messageAcpter,
				 @RequestParam(value = "page", required = false) String page,
		         @RequestParam(value = "limit", required = false) String limit,
		         HttpServletResponse response) throws Exception{
			int ppp = Integer.parseInt(page);
			int lll = Integer.parseInt(limit);
          List<Message> messages = messageServiceImpl.selectUnreadMessage(messageAcpter, lll*(ppp-1), lll);
         //使用阿里巴巴的fastJson创建JSONObject
         JSONObject result = new JSONObject();
         //通过fastJson序列化list为jsonArray
         String jsonArray = JSON.toJSONString(messages);
         JSONArray array = JSONArray.parseArray(jsonArray);
		int totalCount = messageServiceImpl.selectMessageTotalCount(messageAcpter);

         //将序列化结果放入json对象中
         result.put("data", array);
         result.put("count", totalCount);
         result.put("code", 0);

         //使用自定义工具类向response中写入数据
         ResponseUtil.write(response, result);
         return null;
		}
		//查看发件箱
		@RequestMapping(value ="/getSenderSeperratePage.do")
		//@SystemLog(module = "学生", methods = "日志管理-消息分页")
		public String getSenderSeperratePage(
				String messageSender,
				 @RequestParam(value = "page", required = false) String page,
		         @RequestParam(value = "limit", required = false) String limit,
		         HttpServletResponse response) throws Exception{
			int ppp = Integer.parseInt(page);
			int lll = Integer.parseInt(limit);
          List<Message> messages = messageServiceImpl.selectSenderMessage(messageSender, lll*(ppp-1), lll);
         //使用阿里巴巴的fastJson创建JSONObject
         JSONObject result = new JSONObject();
         //通过fastJson序列化list为jsonArray
         String jsonArray = JSON.toJSONString(messages);
         JSONArray array = JSONArray.parseArray(jsonArray);
		int totalCount = messageServiceImpl.selectSendreMessageTotalCount(messageSender);

         //将序列化结果放入json对象中
         result.put("data", array);
         result.put("count", totalCount);
         result.put("code", 0);

         //使用自定义工具类向response中写入数据
         ResponseUtil.write(response, result);
         return null;
		}
		
		
		//删除message
		@SystemLog(module = "学生", methods = "日志管理-删除消息")
		@RequestMapping(value = "/deleteMessage.do")
		@ResponseBody
		public Map<String, Object> deleteMessage(int messageId){
			Map<String, Object> map = new HashMap<>();
			int tem = messageServiceImpl.deleteMessage(messageId);
			if(tem > 0){
				map.put("result", true);
			}else{
				map.put("result", false);
			}
			return map;
		}
		//通过二维码添加课程
		@SystemLog(module = "学生", methods = "日志管理-二维码添加课程")
		@RequestMapping(value = "/confirmAddCourse.do")
		@ResponseBody
		public Map<String, Object> confirmAddCourse(String studentRoNo,String studentPassword,
				int clazzId,int courseId,HttpServletRequest request){
			request.getSession().setAttribute("UserId", studentRoNo);
			System.out.println(studentRoNo +":" +studentPassword+":"+clazzId +":" +courseId);
			Map<String, Object> map = new HashMap<>();
			Student student = studentServiceImpl.selectStudentByNo(studentRoNo);
			Course course = courseServiceImpl.selectCourseById(courseId);
			StudentInfo studentInfo = studentInfoServiceImpl.selectStudentInfoByMany(studentRoNo,courseId);
			int count = studentInfoServiceImpl.selectCountOfStudentByStudentInfo(courseId);
				if (student == null) {
					map.put("message", "学号错误");
				} else if (!MD5Util.md5(studentPassword, "juin").equals(student.getStudentPassword())){
					map.put("message", "密码错误");
				} else if (studentInfo != null) {
					map.put("message", "请勿重复加入");
				}else if (count+1 > course.getClassCapacity()) {
					map.put("message", "班级人数超额");
				}else{
					StudentInfo studentInfo3 = new StudentInfo();
					studentInfo3.setStudent(student);
					studentInfo3.setCourse(course);
					studentInfo3.setSignIn(0);
					studentInfo3.setAbsenteeism(0);
					studentInfo3.setAskForLeave(0);
					studentInfo3.setComeLate(0);
					studentInfo3.setLeaveEarlier(0);
					studentInfo3.setLeaveRecord(0);
					studentInfoServiceImpl.insertStudentInfo(studentInfo3);
					clazzStuServiceImpl.insertClazzStu(clazzId,studentRoNo);
					map.put("result", true);
				}
			return map;
		}
	//学生get请假历史记录	
	@RequestMapping(value = "/getLeaveRecord.do")	
	@ResponseBody
	public Map<String, Object> getLeaveRecord(String studentRono){
		Map<String, Object> map = new HashMap<>();
		List<LeaveRecord> leaveRecords = leaveRecordServiceImpl.selectLeaveRecordByStudent(studentRono);
		map.put("leaveRecords", leaveRecords);
		return map;
	}
	//新建请假
	@RequestMapping(value = "/studentAddLeave.do")
	@SystemLog(module = "学生", methods = "日志管理-请假")	
	@ResponseBody
	public Map<String, Object> studentAddLeave(int courseId,String student,String reson,
			@DateTimeFormat(pattern = "yyyy-MM-dd") Date leaveTime,String status,
			@DateTimeFormat(pattern = "yyyy-MM-dd") Date returnTime){
		Map<String, Object> map = new HashMap<>();
		Course course = courseServiceImpl.selectCourseById(courseId);
		Student student2 = studentServiceImpl.selectStudentByNo(student);
		ClazzStu clazzStu = clazzStuServiceImpl.selectClazzStuByCourse(student, courseId);
		LeaveRecord leaveRecord = new LeaveRecord();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		leaveRecord.setCourseId(courseId);
		leaveRecord.setCourseName(course.getCourseName());
		leaveRecord.setStudent(student);
		leaveRecord.setLeaveTime(sdf.format(leaveTime));
		leaveRecord.setReturnTime(sdf.format(returnTime));
		leaveRecord.setReason(reson);
		leaveRecord.setStatus(status);
		int tem = leaveRecordServiceImpl.insertleaveRecord(leaveRecord);
		LeaveRecord leaveRecord2  = leaveRecordServiceImpl.selectLeaveRecordByStudentLimit(student);
		Message message = new Message();
		message.setMessageSender(student);
		message.setMessageAccepter(course.getTeacher().getTeacherMobile());
		message.setMessageTitle(student2.getStudentName() + "同学(" + clazzStu.getClazz().getClazzName() +")请求关于"+course.getCourseName()+"请假:"
				+ sdf.format(leaveTime) + "——" + sdf.format(returnTime));
		message.setSendTime(sdf.format(new Date()));
		message.setHaveRead("未读");
		message.setMessageContent(reson);
		message.setMessageOther(leaveRecord2.getLeaveRecordId()+"");
		message.setMessageType("leaveRecord");
		messageServiceImpl.insertMessage(message);
		if(tem > 0){
			map.put("result", true);
		}
		return map;
	}
	//查看教师自己的博客
		@RequestMapping(value = "/toPersonBlog.do",method = RequestMethod.POST)
		public String toPersonBlog(String userRole,String userId,String userPassWord,ModelMap map,HttpServletRequest request,HttpServletResponse response){
			if(userRole.equals("student")){
				Student student = studentServiceImpl.selectStudentByNo(userId);
				if(userPassWord != null && userPassWord.equals(student.getStudentPassword())){
					map.put("student", student);
					List<MyBlog> myBlogs = myBlogServiceImpl.selectMyBlogByUserId(userId);
					map.put("myBlogs", myBlogs);
					return "studentBlog";
				}else {
					return "failer";
				}	
			}else {
				return "failer";
			}
				
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

	//回复教师消息
	@RequestMapping(value = "/returnMessageToTeacher.do")
	@ResponseBody
	public Map<String, Object> returnMessageToTeacher(int messageId,String messageToTeacherContent){
		Message message2 = messageServiceImpl.selectMessageById(messageId);
		String teacherMobile = message2.getMessageSender();
		String studentRoNo = message2.getMessageAccepter();
		Student student = studentServiceImpl.selectStudentByNo(studentRoNo);
		Map<String, Object> map = new HashMap<>();
		Message message = new Message();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		message.setMessageSender(studentRoNo);
		message.setMessageAccepter(teacherMobile);
		message.setMessageTitle(student.getStudentName() + "同学 回复了你！");
		message.setSendTime(sdf.format(new Date()));
		message.setHaveRead("未读");
		message.setMessageContent(student.getStudentName()+ " ：<br/><br/><span style='color:#FF5722'>"+ messageToTeacherContent +"</span><br/>");
		message.setMessageType("nomal");
		
		int tem = messageServiceImpl.insertMessage(message);
		if(tem > 0){ 
			map.put("result", true);
		}
		else {
			map.put("result", false); 
		}
		return map;
	}		

//给老师发消息
	@RequestMapping(value = "/messageToTeacherNow.do")
	@ResponseBody
	public Map<String, Object> messageToTeacherNow(int courseId,String studentRoNo,String messageToStudentContentNow){
		Course course = courseServiceImpl.selectCourseById(courseId);
		String teacherMobile = course.getTeacher().getTeacherMobile();
		Student student = studentServiceImpl.selectStudentByNo(studentRoNo);
		Map<String, Object> map = new HashMap<>();
		Message message = new Message();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		message.setMessageSender(studentRoNo);
		message.setMessageAccepter(teacherMobile);
		message.setMessageTitle(student.getStudentName() + "同学 给你发送了一条消息！");
		message.setSendTime(sdf.format(new Date()));
		message.setHaveRead("未读");
		message.setMessageContent(student.getStudentName()+ " ：<br/><br/><span style='color:#FF5722'>"+ messageToStudentContentNow +"</span><br/>");
		message.setMessageType("nomal");
		
		int tem = messageServiceImpl.insertMessage(message);
		if(tem > 0){
			map.put("result", true);
		}
		else {
			map.put("result", false); 
		}
		return map;
	}		
		
	//学生更换照片
	@RequestMapping(value = "/updateStudentPhoto.do",method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateStudentPhoto(HttpServletRequest request, @RequestParam("file") MultipartFile file){
		Map<String, Object> map = new HashMap<>();
		String studentRoNo = request.getParameter("studentRoNoForPhoto");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-DD-HH-mm-ss");
		String path = request.getSession().getServletContext().getRealPath("/") + "studentPhoto";
		System.out.println(path);
		String fileName = file.getOriginalFilename();
		System.out.println(fileName);
		String nameNow = sdf.format(new Date())+"_"+fileName;
		File targetFile = new File(path, nameNow);
		if (!targetFile.exists()) {
			targetFile.mkdirs();
		}
		// 保存
		try {
			file.transferTo(targetFile);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		int tem = studentServiceImpl.updateStudentPhoto(studentRoNo, nameNow);
		if(tem > 0){
			map.put("result", true);
			map.put("fileName", nameNow);
		}
		else {
			map.put("result", false); 
		}
		return map;
	}		
		
		
		
		
		
		
}