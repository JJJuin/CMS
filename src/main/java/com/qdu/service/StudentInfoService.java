package com.qdu.service;

import java.util.List;

import com.qdu.pojo.Student;
import com.qdu.pojo.StudentInfo;
import com.qdu.pojo.StudentInfoDetail;

public interface StudentInfoService { 

	public int insertStudentInfo(StudentInfo studentInfo);
	
	public void deleteStudentInfoByCourse(int courseId);
	 
	public StudentInfo selectStudentInfoByMany(String studentRoNo, int courseId);
	
	public void updateStudentInfoAboutSignIn(int studentInfoId, int signIn);
	
	public List<StudentInfo> selectInfoList(int courseId);
	
	public void updateStudentInfoAboutAbs(int studentInfoId, int absenteeism);
	
	public List<StudentInfo> selectInfoFromInfoAndStudent(int courseId);
	
	public List<StudentInfo> selectCourseByStudentRono(String studentRoNo);
	
	public List<StudentInfo> selectStudentInfoList(String studentRoNo);
	
	public int updateStudentInfoAboutLeave(int studentInfoId, int askForLeave);
	
	public int selectCountOfStudentByStudentInfo(int courseId);
	
	public StudentInfo selectStudentInfoOfLate(String studentRoNo, int courseId);
	
	public int updateStudentInfoAboutLateOrLeave(int comeLate, int leaveEarlier, int studentInfoId);
	
	public StudentInfo selectStudentInfoById(int studentInfoId);
	
	public int deleteStudentInfoById(int studentInfoId);
	
	public int selectCountOfStudentInThisCourse(int courseId);
	
	// 以下为签到细节
	public int insertStudentInfoDetailResult(StudentInfoDetail studentInfoDetail);
	
	public List<StudentInfoDetail> selectStudentInfoDetailResult(String studentRoNo,int courseId,String currentTime);
	
	public int selectMaxStudentInfoDetailResult(String studentRoNo, int courseId, String currentTime);
	
	public List<StudentInfoDetail> selectStuInfoDetailList(int courseId);
	
    public int selectCountOfCurrentDay(int courseId,String currentTime);
    
    public List<StudentInfoDetail> selectEveryTimeSign(int courseId,String currentTime,int currentCount);

    public StudentInfoDetail selectStudentInfoDetailId(int studentInfoDetailId);
   
    public int updateStudentInfoDetail(String signInStatus, int studentinfodetailId);
    
    public int deleteStudentInfoDetail(String studentRoNo, int courseId);
    
    public List<StudentInfoDetail> selectTimeList(int courseId);

    public StudentInfoDetail stuInfoDetailByThree(String studentRoNo, int courseId, String currentTime);
}
