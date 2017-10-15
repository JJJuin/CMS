package com.qdu.serviceimpl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.qdu.dao.TeacherDao;
import com.qdu.pojo.Teacher;
import com.qdu.service.TeacherService;

@Transactional
@Service
public class TeacherServiceImpl implements TeacherService{

	@Autowired
	private TeacherDao teacherDaoImpl;
	
	@Override
	public void insertTeacher(Teacher teacher) {
		teacherDaoImpl.insertTeacher(teacher);
	}


	@Override
	public Teacher selectTeacherByEmail(String teacherMobile) {
		return teacherDaoImpl.selectTeacherByEmail(teacherMobile);
	}

}
