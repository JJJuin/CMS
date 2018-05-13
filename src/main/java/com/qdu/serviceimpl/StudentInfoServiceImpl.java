package com.qdu.serviceimpl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.qdu.dao.StudentInfoDao;
import com.qdu.pojo.StudentInfo;
import com.qdu.pojo.StudentInfoDetail;
import com.qdu.service.StudentInfoService;

@Transactional
@Service
public class StudentInfoServiceImpl implements StudentInfoService{
	
	@Autowired
	private StudentInfoDao studentInfoDaoImpl;

	@Override
	public int insertStudentInfo(StudentInfo studentInfo) {
		return studentInfoDaoImpl.insertStudentInfo(studentInfo);
	}

	@Override
	public void deleteStudentInfoByCourse(int courseId) {		
		studentInfoDaoImpl.deleteStudentInfoByCourse(courseId);
	}

	@Override
	public StudentInfo selectStudentInfoByMany(String studentRoNo, int courseId) {
		return studentInfoDaoImpl.selectStudentInfoByMany(studentRoNo, courseId);
	}

	@Override
	public void updateStudentInfoAboutSignIn(int studentInfoId, int signIn) {
		studentInfoDaoImpl.updateStudentInfoAboutSignIn(studentInfoId, signIn);
	}

	@Override
	public List<StudentInfo> selectInfoList(int courseId) {
		return studentInfoDaoImpl.selectInfoList(courseId);
	}

	@Override
	public void updateStudentInfoAboutAbs(int studentInfoId, int absenteeism) {
		studentInfoDaoImpl.updateStudentInfoAboutAbs(studentInfoId, absenteeism);
	}

	@Override
	public List<StudentInfo> selectInfoFromInfoAndStudent(int courseId) {
		return studentInfoDaoImpl.selectInfoFromInfoAndStudent(courseId);
	}
	
	@Override
	public List<StudentInfo> selectCourseByStudentRono(String studentRoNo) {
		return studentInfoDaoImpl.selectCourseByStudentRono(studentRoNo);
	}

	@Override
	public List<StudentInfo> selectStudentInfoList(String studentRoNo) {
		return studentInfoDaoImpl.selectStudentInfoList(studentRoNo);
	}

	@Override
	public int updateStudentInfoAboutLeave(int studentInfoId, int askForLeave) {
		return studentInfoDaoImpl.updateStudentInfoAboutLeave(studentInfoId, askForLeave);
	}

	@Override
	public int selectCountOfStudentByStudentInfo(int courseId) {
		return studentInfoDaoImpl.selectCountOfStudentByStudentInfo(courseId);
	}

	@Override
	public StudentInfo selectStudentInfoOfLate(String studentRoNo, int courseId) {
		return studentInfoDaoImpl.selectStudentInfoOfLate(studentRoNo, courseId);
	}

	@Override
	public int updateStudentInfoAboutLateOrLeave(int comeLate, int leaveEarlier, int studentInfoId) {
		return studentInfoDaoImpl.updateStudentInfoAboutLateOrLeave(comeLate, leaveEarlier, studentInfoId);
	}

	@Override
	public StudentInfo selectStudentInfoById(int studentInfoId) {
		return studentInfoDaoImpl.selectStudentInfoById(studentInfoId);
	}

	@Override
	public int deleteStudentInfoById(int studentInfoId) {
		return studentInfoDaoImpl.deleteStudentInfoById(studentInfoId);
	}

	@Override
	public int selectCountOfStudentInThisCourse(int courseId) {
		return studentInfoDaoImpl.selectCountOfStudentByStudentInfo(courseId);
	}

	@Override
	public int insertStudentInfoDetailResult(StudentInfoDetail studentInfoDetail) {
		return studentInfoDaoImpl.insertStudentInfoDetailResult(studentInfoDetail);
	}

	@Override
	public List<StudentInfoDetail> selectStudentInfoDetailResult(String studentRoNo, int courseId, String currentTime) {
		return studentInfoDaoImpl.selectStudentInfoDetailResult(studentRoNo, courseId, currentTime);
	}

	@Override
	public int selectMaxStudentInfoDetailResult(String studentRoNo, int courseId, String currentTime) {
		return studentInfoDaoImpl.selectMaxStudentInfoDetailResult(studentRoNo, courseId, currentTime);
	}

	@Override
	public List<StudentInfoDetail> selectStuInfoDetailList(int courseId) {
		return studentInfoDaoImpl.selectStuInfoDetailList(courseId);
	}

	@Override
	public int selectCountOfCurrentDay(int courseId, String currentTime) {
		return studentInfoDaoImpl.selectCountOfCurrentDay(courseId, currentTime);
	}

	@Override
	public List<StudentInfoDetail> selectEveryTimeSign(int courseId, String currentTime, int currentCount) {
		return studentInfoDaoImpl.selectEveryTimeSign(courseId, currentTime, currentCount);
	}

	@Override
	public StudentInfoDetail selectStudentInfoDetailId(int studentInfoDetailId) {
		return studentInfoDaoImpl.selectStudentInfoDetailId(studentInfoDetailId);
	}

	@Override
	public int updateStudentInfoDetail(String signInStatus, int studentinfodetailId) {
		return studentInfoDaoImpl.updateStudentInfoDetail(signInStatus, studentinfodetailId);
	}

	@Override
	public int deleteStudentInfoDetail(String studentRoNo, int courseId) {
		return studentInfoDaoImpl.deleteStudentInfoDetail(studentRoNo, courseId);
	}

	@Override
	public List<StudentInfoDetail> selectTimeList(int courseId) {
		return studentInfoDaoImpl.selectTimeList(courseId);
	}

	@Override
	public StudentInfoDetail stuInfoDetailByThree(String studentRoNo, int courseId, String currentTime) {
		return studentInfoDaoImpl.stuInfoDetailByThree(studentRoNo, courseId, currentTime);
	}
	

}
