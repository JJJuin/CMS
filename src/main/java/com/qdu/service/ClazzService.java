package com.qdu.service;

import java.util.List;

import com.qdu.pojo.Clazz;
import com.qdu.pojo.Student;

public interface ClazzService {
 
	public int insertClazz(Clazz clazz);
	
	public Clazz selectClazzByAll(String clazzName, String teacherMobile, int currentYear);
	
	public void updateClazzOfCourseId(int clazzId, int courseId);
	
	public List<Clazz> selectClazzByCourse(int courseId);
	
	public List<Clazz> clazzListByClazzId(int courseId);
	
	public void updateClazzByCourseId(int clazzId);
	
	public void updateClazzByClazzId(int clazzId,String clazzName,int currentYear);
	
	public Clazz selectClazzById(int clazzId);
	
	public int deleteClazzById(int clazzId);
	
	public int selectCountOfStudentByClazz(int clazzId);
	
	public List<Clazz> selectClazzNameByCourse(int courseId);
	
	}
