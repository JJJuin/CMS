package com.qdu.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.qdu.aop.SystemLog;
import com.qdu.pojo.ClazzStu;
import com.qdu.pojo.Course;
import com.qdu.pojo.Message;
import com.qdu.pojo.Student;
import com.qdu.pojo.StudentInfo;
import com.qdu.pojo.StudentInfoDetail;
import com.qdu.pojo.Teacher;
import com.qdu.service.ClazzService;
import com.qdu.service.ClazzStuService;
import com.qdu.service.CourseService;
import com.qdu.service.MessageService;
import com.qdu.service.StudentInfoService;
import com.qdu.service.StudentService;
import com.qdu.service.TeacherService;
import com.qdu.util.MD5Util;
import com.qdu.websocket.WebSocketConnection;
import jxl.SheetSettings;
import jxl.Workbook;
import jxl.write.Alignment;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

@Controller 
@RequestMapping(value = "/studentInfo")
public class StudentInfoController {

	@Autowired
	StudentInfoService studentInfoServiceImpl;
	@Autowired
	StudentService studentServiceImpl;
	@Autowired
	private TeacherService teacherServiceImpl;
	@Autowired 
	private MessageService messageServiceImpl;
	@Autowired
	private CourseService courseServiceImpl;
	@Autowired
	private ClazzStuService clazzStuServiceImpl;
	@Autowired ClazzService clazzServiceImpl;

	// 添加学生——课程 中间表
	@SystemLog(module = "中间表", methods = "日志管理-添加中间表")
	@RequestMapping(value = "/insertStudentInfo.do")
	public String insertStudentInfo(StudentInfo studentInfo, HttpServletRequest request) {
		String studentRoNo = request.getParameter("studentRoNo");
		String password = request.getParameter("studentPassword");
		String courseId = request.getParameter("courseId");
		Course course = courseServiceImpl.selectCourseById(Integer.parseInt(courseId));
		int count = studentInfoServiceImpl.selectCountOfStudentByStudentInfo(Integer.parseInt(courseId));
		Student student = studentServiceImpl.selectStudentByNo(studentRoNo);
		if(count < course.getClassCapacity()){
			if (student != null && MD5Util.md5(password, "juin").equals(student.getStudentPassword())) {
				StudentInfo studentInfo2 = studentInfoServiceImpl.selectStudentInfoByMany(studentRoNo,
						Integer.parseInt(courseId));
				if (studentInfo2 == null) {
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
				}
				int clazzId = Integer.parseInt(request.getParameter("clazzId"));
				if (clazzId != 0) {
					clazzStuServiceImpl.insertClazzStu(clazzId,studentRoNo);
				}
				return "success";
			}
			else {
				return "failer";
			}
		} else {
			return "failer";
		}

	}

	// 添加学生——课程 中间表 
	@SystemLog(module = "教师", methods = "日志管理-添加学生")
	@RequestMapping(value = "/insertStudentInfoByteacher.do")
	@ResponseBody
	public Map<String, Object> insertStudentInfoByteacher(String content,String teacherMobile, String studentRoNo,
			HttpServletRequest request) {
        Map<String, Object> map = new HashMap<>();
        int tem = 0;
        for(int i = 0; i < content.length(); i ++){
        	if(content.charAt(i) == 'c'){
        		tem = i;
        		break;
        	}
        }
        String aa = content.substring(0, tem);
        String bb = content.substring(tem+1);
        int courseId = Integer.parseInt(aa);
        int clazzId = Integer.parseInt(bb);
		StudentInfo studentInfo2 = studentInfoServiceImpl.selectStudentInfoByMany(studentRoNo,courseId);
		if (studentInfo2 == null) {
			if (clazzId != 0) {
				int tem2 = clazzStuServiceImpl.insertClazzStu(clazzId,studentRoNo);
				System.out.println(tem2);
				if(tem2 > 0){
					Student student = studentServiceImpl.selectStudentByNo(studentRoNo);
					Course course = courseServiceImpl.selectCourseById(courseId);
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
				}
			}
			Teacher teacher = teacherServiceImpl.selectTeacherByEmail(teacherMobile);
	        String time = new SimpleDateFormat("YYYY-MM-dd HH:mm:ss").format(new Date());
	        Message message =  new Message();
	        Course course = courseServiceImpl.selectCourseById(courseId);
			 message.setMessageSender(teacherMobile);
			 message.setMessageAccepter(studentRoNo);
			 message.setMessageTitle(teacher.getTeacherName() + "老师同意你加入课程< " + course.getCourseName() + 
					 ">(" + course.getCurrentYear() + "/" + course.getSchoolTem() + ")");
			 message.setSendTime(time);
			 message.setHaveRead("未读"); 
			 message.setMessageType("insertCourse");
			 message.setMessageContent(courseId+"");
			 messageServiceImpl.insertMessage(message);
			 int messageCount = messageServiceImpl.selectMessageCount(studentRoNo);
			 WebSocketConnection.sendMessageToUser(studentRoNo, messageCount+"");
			map.put("result", true);
		}else{
			map.put("result", false);
		} 
		return map;
	}
	//修改学生迟到早退的情况
	@RequestMapping(value = "/changeQiandao.do")
	@ResponseBody 
	public Map<String, Object> changeQiandao(String studentRoNo,int courseId){
		Map<String, Object> map = new HashMap<>();
		StudentInfo studentInfo = studentInfoServiceImpl.selectStudentInfoOfLate(studentRoNo, courseId);		
		Student student = studentServiceImpl.selectStudentByNo(studentRoNo);
		map.put("studentInfo", studentInfo);
		map.put("student", student);
		return map; 
	}
	//添加学生迟到次数
	@RequestMapping(value = "/addComeLate.do")
	@ResponseBody
	public Map<String, Object> addComeLate(int studentInfoId){
		Map<String, Object> map = new HashMap<>();
		StudentInfo studentInfo = studentInfoServiceImpl.selectStudentInfoById(studentInfoId);
		int tem = studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate()+1, studentInfo.getLeaveEarlier(), studentInfoId);
		if(tem > 0){
			map.put("result", true);
			StudentInfo studentInfo2 = studentInfoServiceImpl.selectStudentInfoById(studentInfoId);
			map.put("studentInfo", studentInfo2);
		}else {
			map.put("result", false);
		}
		return map;
	}
	
	//添加早退迟到次数
	@RequestMapping(value = "/addLeaveEarly.do")
	@ResponseBody
	public Map<String, Object> addLeaveEarly(int studentInfoId){
		Map<String, Object> map = new HashMap<>();
		StudentInfo studentInfo = studentInfoServiceImpl.selectStudentInfoById(studentInfoId);
		int tem = studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate(), studentInfo.getLeaveEarlier()+1, studentInfoId);
		if(tem > 0){
			map.put("result", true);
			StudentInfo studentInfo2 = studentInfoServiceImpl.selectStudentInfoById(studentInfoId);
			map.put("studentInfo", studentInfo2);
		}else {
			map.put("result", false);
		}
		return map;
	}
  //查询具体的签到内容
	@RequestMapping(value = "/getStuInfoDetailList.do")
	@ResponseBody
	public Map<String, Object> getStuInfoDetailList(int courseId){
		Map<String, Object> map = new HashMap<>();
		List<StudentInfoDetail> sdifdl = studentInfoServiceImpl.selectStuInfoDetailList(courseId);
		if(sdifdl.size() > 0){
			map.put("result", true);
			map.put("stuInfoDetail", sdifdl);
		}else{ 
			map.put("result", false);
		}
		return map;
	}	
 //查询某天签到次数
	@RequestMapping(value = "/selectCountOfCurrentDay.do")
	@ResponseBody
	public Map<String, Object> selectCountOfCurrentDay(int studentInfoDetailId){
		Map<String, Object> map = new HashMap<>();
		StudentInfoDetail studentInfoDetail = studentInfoServiceImpl.selectStudentInfoDetailId(studentInfoDetailId);
		int courseId = studentInfoDetail.getCourseId();
		String currentTime = studentInfoDetail.getCurrentTime();
		List<StudentInfoDetail> studentInfoDetails = studentInfoServiceImpl.selectEveryTimeSign(courseId, currentTime, studentInfoDetail.getCurrentCount());
		map.put("studentInfoDetails", studentInfoDetails);
		map.put("currentTime", currentTime);
		return map; 
	}	
	
  //真正的查询某天某次签到
	@RequestMapping(value = "/selectEveryTimeSign.do")
	@ResponseBody
	public Map<String, Object> selectEveryTimeSign(int courseId, String currentTime, int currentCount){
		Map<String, Object> map = new HashMap<>();
		List<StudentInfoDetail> studentInfoDetails = studentInfoServiceImpl.selectEveryTimeSign(courseId, currentTime, currentCount);
		map.put("studentInfoDetails", studentInfoDetails);
		return map;
	}	
 
 //修改某天具体状态	
	@RequestMapping(value = "/changeThisStatus.do")
	@ResponseBody
	public Map<String, Object> changeThisStatus(int studentInfoDetailId,String signInStatus){
		Map<String, Object> map = new HashMap<>();
		//别忘了总签到表相应改动
		System.out.println("将改成: " + signInStatus);
		StudentInfoDetail studentInfoDetail = studentInfoServiceImpl.selectStudentInfoDetailId(studentInfoDetailId);
		StudentInfo studentInfo = studentInfoServiceImpl.selectStudentInfoByMany(studentInfoDetail.getStudentRoNo(), studentInfoDetail.getCourseId());
		//当前签到状态
		String currentStatus = studentInfoDetail.getSignInStatus();
        System.out.println("当前签到状态: " + currentStatus);
        if(signInStatus.equals(currentStatus)){
        	
        }else
        	switch (currentStatus) {
			case "签到":
				System.out.println("签到");
				studentInfoServiceImpl.updateStudentInfoAboutSignIn(studentInfo.getStudentInfoId(), studentInfo.getSignIn()-1);
				System.out.println("签到 -1 完成");
				switch (signInStatus) {
				case "迟到":
					studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate()+1, studentInfo.getLeaveEarlier(), studentInfo.getStudentInfoId());
					break;
                case "早退":
                studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate(), studentInfo.getLeaveEarlier()+1, studentInfo.getStudentInfoId());
                    break;
                case "请假":
                	studentInfoServiceImpl.updateStudentInfoAboutLeave(studentInfo.getStudentInfoId(), studentInfo.getAskForLeave()+1);
                break;
                case "旷课":
                	studentInfoServiceImpl.updateStudentInfoAboutAbs(studentInfo.getStudentInfoId(), studentInfo.getAbsenteeism()+1);
                break;
				default:
					break;
				}
				break;
			case "迟到":
				studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate()-1, studentInfo.getLeaveEarlier(), studentInfo.getStudentInfoId());
                switch (signInStatus) {
				case "签到":
					 studentInfoServiceImpl.updateStudentInfoAboutSignIn(studentInfo.getStudentInfoId(), studentInfo.getSignIn()+1);
					break;
                case "早退":
    				studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate(), studentInfo.getLeaveEarlier()+1, studentInfo.getStudentInfoId());
					break;
                case "请假":
    				studentInfoServiceImpl.updateStudentInfoAboutLeave(studentInfo.getStudentInfoId(), studentInfo.getAskForLeave()+1);
	                break;
                case "旷课":
    				studentInfoServiceImpl.updateStudentInfoAboutAbs(studentInfo.getStudentInfoId(), studentInfo.getAbsenteeism()+1);
	                break;

				default:
					break;
				}
				break;
			case "早退":
				studentInfoServiceImpl.updateStudentInfoAboutSignIn(studentInfo.getStudentInfoId(), studentInfo.getLeaveEarlier()-1);
				switch (signInStatus) {
                case "签到":
   				 studentInfoServiceImpl.updateStudentInfoAboutSignIn(studentInfo.getStudentInfoId(), studentInfo.getSignIn()+1);
					break;
               case "迟到":
   				studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate()+1, studentInfo.getLeaveEarlier(), studentInfo.getStudentInfoId());	
					break;
               case "请假":
   				studentInfoServiceImpl.updateStudentInfoAboutLeave(studentInfo.getStudentInfoId(), studentInfo.getAskForLeave()+1);
	                break;
               case "旷课":
   				studentInfoServiceImpl.updateStudentInfoAboutAbs(studentInfo.getStudentInfoId(), studentInfo.getAbsenteeism()+1);
	                break;

				default:
					break;
				}
				break;
				
			case "请假":
				studentInfoServiceImpl.updateStudentInfoAboutSignIn(studentInfo.getStudentInfoId(), studentInfo.getAskForLeave()-1);
				switch (signInStatus) {
                 case "签到":
					 studentInfoServiceImpl.updateStudentInfoAboutSignIn(studentInfo.getStudentInfoId(), studentInfo.getSignIn()+1);
					break;
                case "迟到":
					studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate()+1, studentInfo.getLeaveEarlier(), studentInfo.getStudentInfoId());
					break;
                case "早退":
					studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate(), studentInfo.getLeaveEarlier()+1, studentInfo.getStudentInfoId());
	                break;
                case "旷课":
					studentInfoServiceImpl.updateStudentInfoAboutAbs(studentInfo.getStudentInfoId(), studentInfo.getAbsenteeism()+1);
	                break;

				default:
					break;
				}
	            break;
	            
			case "旷课":
	            studentInfoServiceImpl.updateStudentInfoAboutAbs(studentInfo.getStudentInfoId(), studentInfo.getAbsenteeism()-1);

				switch (signInStatus) { 
               case "签到":
					 studentInfoServiceImpl.updateStudentInfoAboutSignIn(studentInfo.getStudentInfoId(), studentInfo.getSignIn()+1);
					break;
                case "迟到":
					studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate()+1, studentInfo.getLeaveEarlier(), studentInfo.getStudentInfoId());
					break;
                case "早退":
					studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate(), studentInfo.getLeaveEarlier()+1, studentInfo.getStudentInfoId());
	                break;
                case "请假":
					studentInfoServiceImpl.updateStudentInfoAboutLeave(studentInfo.getStudentInfoId(), studentInfo.getAskForLeave()+1);
	                break;

				default:
					break;
				}
	            break;
			default:
				break;
			}
        	
        	
        	
        	
        	/*if(currentStatus.equals("签到")){
			System.out.println("签到");
			studentInfoServiceImpl.updateStudentInfoAboutSignIn(studentInfo.getStudentInfoId(), studentInfo.getSignIn()-1);
			System.out.println("签到 -1 完成");
			if (signInStatus.equals("迟到")) {
				studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate()+1, studentInfo.getLeaveEarlier(), studentInfo.getStudentInfoId());
			}else if (signInStatus.equals("早退")) {
				studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate(), studentInfo.getLeaveEarlier()+1, studentInfo.getStudentInfoId());
			}else if (signInStatus.equals("请假")) {
				studentInfoServiceImpl.updateStudentInfoAboutLeave(studentInfo.getStudentInfoId(), studentInfo.getAskForLeave()+1);
			}else if (signInStatus.equals("旷课")) {
				studentInfoServiceImpl.updateStudentInfoAboutAbs(studentInfo.getStudentInfoId(), studentInfo.getAbsenteeism()+1);
			}
		}else if (currentStatus.equals("迟到")) {
			studentInfoServiceImpl.updateStudentInfoAboutSignIn(studentInfo.getStudentInfoId(), studentInfo.getComeLate()-1);
			if(signInStatus.equals("签到")){
				 studentInfoServiceImpl.updateStudentInfoAboutSignIn(studentInfo.getStudentInfoId(), studentInfo.getSignIn()+1);
			}else if (signInStatus.equals("早退")) {
				studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate(), studentInfo.getLeaveEarlier()+1, studentInfo.getStudentInfoId());
			}else if (signInStatus.equals("请假")) {
				studentInfoServiceImpl.updateStudentInfoAboutLeave(studentInfo.getStudentInfoId(), studentInfo.getAskForLeave()+1);
			}else if (signInStatus.equals("旷课")) {
				studentInfoServiceImpl.updateStudentInfoAboutAbs(studentInfo.getStudentInfoId(), studentInfo.getAbsenteeism()+1);
			}
		}else if (currentStatus.equals("早退")) {
			studentInfoServiceImpl.updateStudentInfoAboutSignIn(studentInfo.getStudentInfoId(), studentInfo.getLeaveEarlier()-1);
			if(signInStatus.equals("签到")){
				 studentInfoServiceImpl.updateStudentInfoAboutSignIn(studentInfo.getStudentInfoId(), studentInfo.getSignIn()+1);
			}else if (signInStatus.equals("迟到")) {
				studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate()+1, studentInfo.getLeaveEarlier(), studentInfo.getStudentInfoId());
			}else if (signInStatus.equals("请假")) {
				studentInfoServiceImpl.updateStudentInfoAboutLeave(studentInfo.getStudentInfoId(), studentInfo.getAskForLeave()+1);
			}else if (signInStatus.equals("旷课")) {
				studentInfoServiceImpl.updateStudentInfoAboutAbs(studentInfo.getStudentInfoId(), studentInfo.getAbsenteeism()+1);
			}
		}else if (currentStatus.equals("请假")) {
			studentInfoServiceImpl.updateStudentInfoAboutSignIn(studentInfo.getStudentInfoId(), studentInfo.getAskForLeave()-1);
			if(signInStatus.equals("签到")){
				 studentInfoServiceImpl.updateStudentInfoAboutSignIn(studentInfo.getStudentInfoId(), studentInfo.getSignIn()+1);
			}else if (signInStatus.equals("迟到")) {
				studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate()+1, studentInfo.getLeaveEarlier(), studentInfo.getStudentInfoId());
			}else if (signInStatus.equals("早退")) {
				studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate(), studentInfo.getLeaveEarlier()+1, studentInfo.getStudentInfoId());
			}else if (signInStatus.equals("旷课")) {
				studentInfoServiceImpl.updateStudentInfoAboutAbs(studentInfo.getStudentInfoId(), studentInfo.getAbsenteeism()+1);
			}
		}else if (currentStatus.equals("旷课")) {
			studentInfoServiceImpl.updateStudentInfoAboutSignIn(studentInfo.getStudentInfoId(), studentInfo.getAbsenteeism()-1);
			if(signInStatus.equals("签到")){
				 studentInfoServiceImpl.updateStudentInfoAboutSignIn(studentInfo.getStudentInfoId(), studentInfo.getSignIn()+1);
			}else if (signInStatus.equals("迟到")) {
				studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate()+1, studentInfo.getLeaveEarlier(), studentInfo.getStudentInfoId());
			}else if (signInStatus.equals("早退")) {
				studentInfoServiceImpl.updateStudentInfoAboutLateOrLeave(studentInfo.getComeLate(), studentInfo.getLeaveEarlier()+1, studentInfo.getStudentInfoId());
			}else if (signInStatus.equals("请假")) {
				studentInfoServiceImpl.updateStudentInfoAboutLeave(studentInfo.getStudentInfoId(), studentInfo.getAskForLeave()+1);
			}
		}*/
		int tem = studentInfoServiceImpl.updateStudentInfoDetail(signInStatus, studentInfoDetailId);
		if(tem > 0){
			map.put("result", true);
		}else {
			map.put("result", false);
		}
		return map;
	}	
    //导出某天签到表exportScore
    @SuppressWarnings("deprecation")
    @RequestMapping(value = "/exportSign.do")
    public void exportSign(HttpServletResponse response,int studentInfoDetailId) {
        System.out.println(studentInfoDetailId);
        StudentInfoDetail sd = studentInfoServiceImpl.selectStudentInfoDetailId(studentInfoDetailId);
        int courseId = sd.getCourseId();
        Course course = courseServiceImpl.selectCourseById(courseId);
        String currentTime = sd.getCurrentTime();
        // 文件名  
        String fileName = course.getCourseName() + "_" + currentTime + "签到表" + ".xls";

        response.setContentType("application/x-excel");
        response.setCharacterEncoding("UTF-8");
        response.addHeader("Content-Disposition", "attachment;filename="+ fileName);// excel文件名  

        // 业务数据
        List<StudentInfoDetail> studentInfoDetails = studentInfoServiceImpl.selectEveryTimeSign(courseId, currentTime, sd.getCurrentCount()); 
        try {
            // 1.创建excel文件  
            WritableWorkbook book = Workbook.createWorkbook(response.getOutputStream());
            // 居中  
            WritableCellFormat wf = new WritableCellFormat();
            wf.setAlignment(Alignment.CENTRE);

            WritableSheet sheet = null;
            SheetSettings settings = null;

            // 2.创建sheet并设置冻结前一行  
            sheet = book.createSheet("1", 0);
            settings = sheet.getSettings();
            settings.setVerticalFreeze(1);

            // 3.添加第一行及第二行标题数据  
            sheet.addCell(new Label(0, 0, "学号", wf));
            sheet.addCell(new Label(1, 0, "课程编码", wf));
            sheet.addCell(new Label(2, 0, "课程名称", wf));
            sheet.addCell(new Label(3, 0, "日期", wf));
            sheet.addCell(new Label(4, 0, "说明", wf));
            sheet.addCell(new Label(5, 0, "状态", wf));
                        
            // 4.业务数据
            for (int i = 0; i < studentInfoDetails.size(); i++) {
                sheet.addCell(new Label(0, i + 1, studentInfoDetails.get(i).getStudentRoNo(), wf));
                sheet.addCell(new Label(1, i + 1, courseId+"", wf));
                sheet.addCell(new Label(2, i + 1, course.getCourseName(), wf));
                sheet.addCell(new Label(3, i + 1, currentTime, wf));
                sheet.addCell(new Label(4, i + 1, studentInfoDetails.get(i).getCurrentWeek(), wf));
                sheet.addCell(new Label(5, i + 1, studentInfoDetails.get(i).getSignInStatus(), wf));
            }
            // 5.写入excel并关闭  
            book.write();
            book.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
     //导出签到总纪录 exportTotalSign	 
	 @SuppressWarnings("deprecation")
	@RequestMapping(value = "/exportTotalSign.do")
     public void exportTotalSign(HttpServletResponse response,int courseId) {
        System.out.println(courseId);
        Course course = courseServiceImpl.selectCourseById(courseId);
        // 文件名  
        String fileName = course.getCourseName() + "_" + "签到汇总表" + ".xls";

        response.setContentType("application/x-excel");
        response.setCharacterEncoding("UTF-8");
        response.addHeader("Content-Disposition", "attachment;filename="+ fileName);// excel文件名  

        // 业务数据
        List<ClazzStu> clazzStus = clazzStuServiceImpl.selectClazzStuListByCourse(courseId);
        try {
            // 1.创建excel文件  
            WritableWorkbook book = Workbook.createWorkbook(response.getOutputStream());
            // 居中  
            WritableCellFormat wf = new WritableCellFormat();
            wf.setAlignment(Alignment.CENTRE);

            WritableSheet sheet = null;
            SheetSettings settings = null;
            
            List<StudentInfoDetail> sid = studentInfoServiceImpl.selectTimeList(courseId);

            // 2.创建sheet并设置冻结前一行  
            sheet = book.createSheet("1", 0);
            settings = sheet.getSettings();
            settings.setVerticalFreeze(1);

            // 3.添加第一行及第二行标题数据  
            sheet.addCell(new Label(0, 0, "学号", wf));
            sheet.addCell(new Label(1, 0, "班级", wf));
            sheet.addCell(new Label(2, 0, "姓名", wf));
            sheet.addCell(new Label(3, 0, "签到", wf));
            sheet.addCell(new Label(4, 0, "迟到", wf));
            sheet.addCell(new Label(5, 0, "早退", wf));
            sheet.addCell(new Label(6, 0, "请假", wf));
            sheet.addCell(new Label(7, 0, "旷课", wf));
            int tem1 = 0;
            System.err.println(sid.size());
            for(int i = 9; i < 9+sid.size(); i ++){
            	System.out.println(sid.get(tem1).getCurrentTime());
            	sheet.addCell(new Label(i, 0, sid.get(tem1).getCurrentTime(), wf));
            	tem1++;
            }
            
            // 4.业务数据
            for (int i = 0; i < clazzStus.size(); i++) {
                sheet.addCell(new Label(0, i + 1, clazzStus.get(i).getStudent().getStudentRoNo(), wf));
                sheet.addCell(new Label(1, i + 1, clazzStus.get(i).getClazz().getClazzName(), wf));
                sheet.addCell(new Label(2, i + 1, clazzStus.get(i).getStudent().getStudentName(), wf));
                sheet.addCell(new Label(3, i + 1, clazzStus.get(i).getStudent().getStudentInfo().getSignIn()+"", wf));
                sheet.addCell(new Label(4, i + 1, clazzStus.get(i).getStudent().getStudentInfo().getComeLate()+"", wf));
                sheet.addCell(new Label(5, i + 1, clazzStus.get(i).getStudent().getStudentInfo().getLeaveEarlier()+"", wf));
                sheet.addCell(new Label(6, i + 1, clazzStus.get(i).getStudent().getStudentInfo().getAskForLeave()+"", wf));
                sheet.addCell(new Label(7, i + 1, clazzStus.get(i).getStudent().getStudentInfo().getAbsenteeism()+"", wf));
                
                int tem2 = 0;
                for(int j = 9; j < 9+sid.size(); j ++){
                	String currentTime = sid.get(tem2).getCurrentTime();
                	StudentInfoDetail studentInfoDetail = studentInfoServiceImpl.stuInfoDetailByThree(clazzStus.get(i).getStudent().getStudentRoNo(), courseId, currentTime);
                	sheet.addCell(new Label(j, i+1, studentInfoDetail.getSignInStatus(), wf));
                	tem2++;
                }
            }

            // 5.写入excel并关闭  
	            book.write();
	            book.close();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	    }		
}
