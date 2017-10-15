package com.qdu.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.qdu.pojo.Teacher;
import com.qdu.service.TeacherService;

@Controller
@RequestMapping(value="/teacher")
public class TeacherController {

	@Autowired
	private TeacherService teacherServiceImpl;
	
	@RequestMapping(value = "/forTeacherLogin.do")
	public String forTeacherLogin() {
		return "teacherLogin";
	}
	
	@RequestMapping(value="/teacherLogin.do")
	public String teacherLogin(HttpServletRequest request,ModelMap map){
		String id = request.getParameter("teacherId");
		String password = request.getParameter("password");
		Teacher teacher = teacherServiceImpl.selectTeacherByEmail(id);
		if(teacher != null){
		if(id.equals(teacher.getTeacherMobile()) && password.equals(teacher.getTeacherPassword())){
			map.addAttribute("teacher",teacher);
			// session的id存一下
			request.getSession().setAttribute("studentId", id);
			return "teacherPage";
		}else
			return "failer";
		}
		return "failer";
	}
	
	
	@RequestMapping(value = "/insertTeacher.do")
	public String insertTeacher(Teacher teacher, ModelMap map, HttpServletRequest request) {
		teacherServiceImpl.insertTeacher(teacher);
		String teacherMobile = request.getParameter("teacherMobile");
		Teacher teacher2 = teacherServiceImpl.selectTeacherByEmail(teacherMobile);
		map.addAttribute("teacher", teacher2);
		return "teacherPage";
	}
}
