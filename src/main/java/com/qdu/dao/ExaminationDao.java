package com.qdu.dao;

import java.util.List;

import com.qdu.pojo.Examination;
import com.qdu.pojo.Judge;
import com.qdu.pojo.MoreSelection;
import com.qdu.pojo.Pack;
import com.qdu.pojo.ShortAnswer;
import com.qdu.pojo.SingleSelection;

public interface ExaminationDao {
	
	public List<Examination> selectExamination();
	
	public int insertExamination(Examination examination);
	
	public int deleteExaminationById(int examinationID);
	
	public List<Examination> selectExaminationByCourseId(int courseId);
	
	public Examination selectMaxExaminationIdByCourseId(int courseId);
	
	public Examination selectExaminationByExaminationId(int examinationID);
	
	public int selectSingleSelectionCount(int examinationID);
	
	public int insertSingleSelection(SingleSelection selection);
	
	public List<SingleSelection> selectSingleByExaminationID(int examinationID);
	
	public int selectMoreSelectionCount(int examinationID);
	
	public List<MoreSelection> selectMoreByExaminationID(int examinationID);
	
	public int insertMoreSelection(MoreSelection moreSelection);
	
	public int updateMoreSelectionById(int moreSelectionId,int questionNumber);
	
	public int selectJudgeCount(int examinationID);
	
	public List<Judge> selectJudgeByExaminationID(int examinationID);
	
    public int insertJudge(Judge judge);
	
	public int updateJudgeById(int judgeId,int questionNumber);
	
    public List<Pack> selectPackByExaminationIDX(int examinationID);
	
    public int insertPack(Pack pack);
	
	public int updatePackById(int packId,int questionNumber);
	
    public List<ShortAnswer> selectShortAnswerByExaminationIDX(int examinationID);
	
    public int insertShortAnswer(ShortAnswer shortAnswer);
	
	public int updateShortAnswerById(int shortAnswerId,int questionNumber);
	
	public int selectPackCount(int examinationID);
	
	public int selectShortAnswerCount(int examinationID);
	
	public int updateExaminationOfEdit(int examinationID,int canEdit);
	
	public int updateExaminationTemValue(int examinationID,int temValue);
	
	public int deleteJudge(int examinationID);
	
	public int deletePack(int examinationID);
	
	public int deleteShortAnswer(int examinationID);
	
	public int deleteSingleSelection(int examinationID);
	
	public int deleteMoreSelection(int examinationID);
	
	public int deleteExamination(int examinationID);
	
    public int updateExamination(String examinationName,String startTime,int duration,
    		int examinationID);
    //单选四件套
    public SingleSelection selectSingleSelectionBysingleSelectionId(int singleSelectionId);
    
    public int updateSingleBysingleSelectionId(SingleSelection singleSelection);
    
    public int deleteSingleBySingleSelectionId(int singleSelectionId);
    
    public int updateSingleSelectionById(int singleSelectionId,int questionNumber);
    //多选三件套
    public MoreSelection selectMoreSelectionByMoreSelectionId(int moreSelectionId);
    
    public int updatemoreByMoreSelectionId(MoreSelection moreSelection);
    
    public int deleteMoreSelectionId(int moreSelectionId);
    //判断三件套
    public Judge selectJudgeByJudgeId(int judgeId);
    
    public int updatejudgeByJudgeId(Judge judge);
    
    public int deleteJudgeId(int judgeId);
    //填空三件套
    public Pack selectPackByPackId(int packId);
    
    public int updatePackByPackId(Pack pack);
    
    public int deletePackId(int packId);
    //简答三件套
    public ShortAnswer selectShortAnswerByShortAnswerId(int shortAnswerId);
    
    public int updateShortAnswerByShortAnswerId(ShortAnswer shortAnswer);
    
    public int deleteShortAnswerId(int shortAnswerId);
    
    public Examination selectExaminationOnlyCode(String onlyCode);
}
