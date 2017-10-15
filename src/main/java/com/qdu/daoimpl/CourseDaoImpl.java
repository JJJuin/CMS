package com.qdu.daoimpl;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.qdu.dao.CourseDao;
import com.qdu.pojo.Course;

@Repository
public class CourseDaoImpl implements CourseDao {

	@Autowired
	private SqlSessionFactory SqlSessionFactory;

	@Override
	public void insertCourse(Course course) {
		String statement = "com.qdu.mapping.CourseMapping.insertCourse";
		SqlSessionFactory.openSession().insert(statement, course);
	}

	@Override
	public Course selectIdFromCourse(String courseName, String teacherMobile) {
		String statement = "com.qdu.mapping.CourseMapping.selectIdFromCourse";
        Map<String,Object> map = new HashMap<>();
        map.put("courseName", courseName);
        map.put("teacherMobile",teacherMobile);
        return SqlSessionFactory.openSession().selectOne(statement, map);
	}

	@Override
	public void updateQrImg(int courseId,String qrImg) {
		Map<String,Object> map = new HashMap<>();
		String statement = "com.qdu.mapping.CourseMapping.updateQrImg";
		map.put("courseId", courseId);
		map.put("qrImg", qrImg);
		SqlSessionFactory.openSession().update(statement, map);
	}

}
