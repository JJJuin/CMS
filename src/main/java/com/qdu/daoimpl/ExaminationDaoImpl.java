package com.qdu.daoimpl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.qdu.dao.ExaminationDao;
import com.qdu.pojo.ComeparePhoto;
import com.qdu.pojo.Examination;
import com.qdu.pojo.Judge;
import com.qdu.pojo.MoreSelection;
import com.qdu.pojo.Pack;
import com.qdu.pojo.Score;
import com.qdu.pojo.ShortAnswer;
import com.qdu.pojo.SingleSelection;
import com.qdu.pojo.StudentAnswer;

@Repository
public class ExaminationDaoImpl implements ExaminationDao{
	
	@Autowired private SqlSessionFactory sqlSessionFactory;
	
	@Override
	public List<Examination> selectExamination() {
		String statement = "com.qdu.mapping.ExaminationMapping.selectExamination";
		return sqlSessionFactory.openSession().selectList(statement);
	}

	@Override
	public int insertExamination(Examination examination) {
		String statement = "com.qdu.mapping.ExaminationMapping.insertExamination";
		return sqlSessionFactory.openSession().insert(statement, examination);
	}

	@Override
	public int deleteExaminationById(int examinationID) {
		String statement = "com.qdu.mapping.ExaminationMapping.deleteExaminationById";
		return sqlSessionFactory.openSession().delete(statement, examinationID);
	}

	@Override
	public List<Examination> selectExaminationByCourseId(int courseId) {
		String statement = "com.qdu.mapping.ExaminationMapping.selectExaminationByCourseId";
		return sqlSessionFactory.openSession().selectList(statement, courseId);
	}

	@Override
	public Examination selectMaxExaminationIdByCourseId(int courseId) {
		String statement = "com.qdu.mapping.ExaminationMapping.selectMaxExaminationIdByCourseId";
		return sqlSessionFactory.openSession().selectOne(statement, courseId);
	}

	@Override
	public Examination selectExaminationByExaminationId(int examinationID) {
		String statement = "com.qdu.mapping.ExaminationMapping.selectExaminationByExaminationId";
		return sqlSessionFactory.openSession().selectOne(statement, examinationID);
	}

	@Override
	public int selectSingleSelectionCount(int examinationID) {
		String statement = "com.qdu.mapping.SingleSelectionMapping.selectSingleSelectionCount";
		return sqlSessionFactory.openSession().selectOne(statement, examinationID);
	}

	@Override
	public int insertSingleSelection(SingleSelection selection) {
		String statement = "com.qdu.mapping.SingleSelectionMapping.insertSingleSelection";
		return sqlSessionFactory.openSession().insert(statement, selection);
	}

	@Override
	public List<SingleSelection> selectSingleByExaminationID(int examinationID) {
		String statement = "com.qdu.mapping.SingleSelectionMapping.selectSingleByExaminationID";
		return sqlSessionFactory.openSession().selectList(statement, examinationID);
	}

	@Override
	public int selectMoreSelectionCount(int examinationID) {
		String statement = "com.qdu.mapping.MoreSelectionMapping.selectMoreSelectionCount";
		return sqlSessionFactory.openSession().selectOne(statement, examinationID);
	}

	@Override
	public List<MoreSelection> selectMoreByExaminationID(int examinationID) {
		String statement = "com.qdu.mapping.MoreSelectionMapping.selectMoreByExaminationID";
		return sqlSessionFactory.openSession().selectList(statement, examinationID);
	}

	@Override
	public int insertMoreSelection(MoreSelection moreSelection) {
		String statement = "com.qdu.mapping.MoreSelectionMapping.insertMoreSelection";
		return sqlSessionFactory.openSession().insert(statement, moreSelection);
	}

	@Override
	public int updateMoreSelectionById(int moreSelectionId,int questionNumber) {
		String statement = "com.qdu.mapping.MoreSelectionMapping.updateMoreSelectionById";
		Map<String, Object> map = new HashMap<>();
		map.put("moreSelectionId", moreSelectionId);
		map.put("questionNumber", questionNumber);
		return sqlSessionFactory.openSession().update(statement, map);
	}

	@Override
	public int selectJudgeCount(int examinationID) {
		String statement = "com.qdu.mapping.JudgeMapping.selectJudgeCount";
		return sqlSessionFactory.openSession().selectOne(statement, examinationID);
	}

	@Override
	public int insertJudge(Judge judge) {
		String statement = "com.qdu.mapping.JudgeMapping.insertJudge";
		return sqlSessionFactory.openSession().insert(statement, judge);
	}

	@Override
	public int updateJudgeById(int judgeId, int questionNumber) {
		String statement = "com.qdu.mapping.JudgeMapping.updateJudgeById";
		Map<String, Object> map = new HashMap<>();
		map.put("judgeId", judgeId);
		map.put("questionNumber", questionNumber);
		return sqlSessionFactory.openSession().update(statement, map);
	}

	@Override
	public List<Judge> selectJudgeByExaminationID(int examinationID) {
		String statement = "com.qdu.mapping.JudgeMapping.selectJudgeByExaminationIDX";
		return sqlSessionFactory.openSession().selectList(statement, examinationID);
	}

	@Override
	public List<Pack> selectPackByExaminationIDX(int examinationID) {
		String statement = "com.qdu.mapping.PackMapping.selectPackByExaminationIDX";
		return sqlSessionFactory.openSession().selectList(statement, examinationID);
	}

	@Override
	public int insertPack(Pack pack) {
		String statement = "com.qdu.mapping.PackMapping.insertPack";
		return sqlSessionFactory.openSession().insert(statement, pack);
	}

	@Override
	public int updatePackById(int packId, int questionNumber) {
		String statement = "com.qdu.mapping.PackMapping.updatePackById";
		Map<String, Object> map = new HashMap<>();
		map.put("packId", packId);
		map.put("questionNumber", questionNumber);
		return sqlSessionFactory.openSession().update(statement, map);
	}

	@Override
	public List<ShortAnswer> selectShortAnswerByExaminationIDX(int examinationID) {
		String statement = "com.qdu.mapping.ShortAnswerMapping.selectShortAnswerByExaminationIDX";
		return sqlSessionFactory.openSession().selectList(statement, examinationID);
	}

	@Override
	public int insertShortAnswer(ShortAnswer shortAnswer) {
		String statement = "com.qdu.mapping.ShortAnswerMapping.insertShortAnswer";
		return sqlSessionFactory.openSession().insert(statement, shortAnswer);
	}

	@Override
	public int updateShortAnswerById(int shortAnswerId, int questionNumber) {
		String statement = "com.qdu.mapping.ShortAnswerMapping.updateShortAnswerById";
		Map<String, Object> map = new HashMap<>();
		map.put("shortAnswerId", shortAnswerId);
		map.put("questionNumber", questionNumber);
		return sqlSessionFactory.openSession().update(statement, map);
	}

	@Override
	public int selectPackCount(int examinationID) {
		String statement = "com.qdu.mapping.PackMapping.selectPackCount";
		return sqlSessionFactory.openSession().selectOne(statement, examinationID);
	}

	@Override
	public int selectShortAnswerCount(int examinationID) {
		String statement = "com.qdu.mapping.ShortAnswerMapping.selectShortAnswerCount";
		return sqlSessionFactory.openSession().selectOne(statement, examinationID);
	}

	@Override
	public int updateExaminationOfEdit(int examinationID,int canEdit) {
		Map<String, Object> map = new HashMap<>();
		String statement = "com.qdu.mapping.ExaminationMapping.updateExaminationOfEdit";
		map.put("examinationID", examinationID);
		map.put("canEdit", canEdit);
		return sqlSessionFactory.openSession().update(statement, map);
	}

	@Override
	public int updateExaminationTemValue(int examinationID, int temValue) {
		Map<String, Object> map = new HashMap<>();
		String statement = "com.qdu.mapping.ExaminationMapping.updateExaminationTemValue";
		map.put("examinationID", examinationID);
		map.put("temValue", temValue);
		return sqlSessionFactory.openSession().update(statement, map);
	}

	@Override
	public int deleteJudge(int examinationID) {
		String statement = "com.qdu.mapping.JudgeMapping.deleteJudge";
		return sqlSessionFactory.openSession().delete(statement, examinationID);
	}

	@Override
	public int deletePack(int examinationID) {
		String statement = "com.qdu.mapping.PackMapping.deletePack";
		return sqlSessionFactory.openSession().delete(statement, examinationID);
	}

	@Override
	public int deleteShortAnswer(int examinationID) {
		String statement = "com.qdu.mapping.ShortAnswerMapping.deleteShortAnswer";
		return sqlSessionFactory.openSession().delete(statement, examinationID);
	}

	@Override
	public int deleteSingleSelection(int examinationID) {
		String statement = "com.qdu.mapping.SingleSelectionMapping.deleteSingleSelection";
		return sqlSessionFactory.openSession().delete(statement, examinationID);
	}

	@Override
	public int deleteMoreSelection(int examinationID) {
		String statement = "com.qdu.mapping.MoreSelectionMapping.deleteMoreSelection";
		return sqlSessionFactory.openSession().delete(statement, examinationID);
	}

	@Override
	public int deleteExamination(int examinationID) {
		String statement = "com.qdu.mapping.ExaminationMapping.deleteExamination";
		return sqlSessionFactory.openSession().delete(statement, examinationID);
	}

	@Override
	public int updateExamination(String examinationName,String startTime, int duration,
			int examinationID) {
		String statement = "com.qdu.mapping.ExaminationMapping.updateExamination";
		Map<String, Object> map = new HashMap<>();
		map.put("examinationName", examinationName);
		map.put("startTime", startTime);
		map.put("duration", duration);
		map.put("examinationID", examinationID);
		return sqlSessionFactory.openSession().update(statement, map);
	}

	@Override
	public SingleSelection selectSingleSelectionBysingleSelectionId(int singleSelectionId) {
		String statement = "com.qdu.mapping.SingleSelectionMapping.selectSingleSelectionBysingleSelectionId";
		return sqlSessionFactory.openSession().selectOne(statement, singleSelectionId);
	}

	@Override
	public int updateSingleBysingleSelectionId(SingleSelection singleSelection) {
		String statement = "com.qdu.mapping.SingleSelectionMapping.updateSingleBysingleSelectionId";
		return sqlSessionFactory.openSession().update(statement, singleSelection);
	}

	@Override
	public int deleteSingleBySingleSelectionId(int singleSelectionId) {
		String statement = "com.qdu.mapping.SingleSelectionMapping.deleteSingleBySingleSelectionId";
		return sqlSessionFactory.openSession().delete(statement, singleSelectionId);
	}

	@Override
	public int updateSingleSelectionById(int singleSelectionId, int questionNumber) {
		String statement = "com.qdu.mapping.SingleSelectionMapping.updateSingleSelectionQuestionNumById";
		Map<String, Object> map = new HashMap<>();
		map.put("singleSelectionId", singleSelectionId);
		map.put("questionNumber", questionNumber);
		return sqlSessionFactory.openSession().update(statement, map);
	}

	@Override
	public MoreSelection selectMoreSelectionByMoreSelectionId(int moreSelectionId) {
		String statement = "com.qdu.mapping.MoreSelectionMapping.selectMoreSelectionByMoreSelectionId";
		return sqlSessionFactory.openSession().selectOne(statement, moreSelectionId);
	}

	@Override
	public int updatemoreByMoreSelectionId(MoreSelection moreSelection) {
		String statement = "com.qdu.mapping.MoreSelectionMapping.updatemoreByMoreSelectionId";
		return sqlSessionFactory.openSession().update(statement,moreSelection);
	}

	@Override
	public int deleteMoreSelectionId(int moreSelectionId) {
		String statement = "com.qdu.mapping.MoreSelectionMapping.deleteMoreSelectionId";
		return sqlSessionFactory.openSession().delete(statement, moreSelectionId);
	}

	@Override
	public Judge selectJudgeByJudgeId(int judgeId) {
		String statement = "com.qdu.mapping.JudgeMapping.selectJudgeByJudgeId";
		return sqlSessionFactory.openSession().selectOne(statement, judgeId);
	}

	@Override
	public int updatejudgeByJudgeId(Judge judge) {
		String statement = "com.qdu.mapping.JudgeMapping.updatejudgeByJudgeId";
		return sqlSessionFactory.openSession().update(statement,judge);
	}

	@Override
	public int deleteJudgeId(int judgeId) {
		String statement = "com.qdu.mapping.JudgeMapping.deleteJudgeId";
		return sqlSessionFactory.openSession().delete(statement, judgeId);
	}

	@Override
	public Pack selectPackByPackId(int packId) {
		String statement = "com.qdu.mapping.PackMapping.selectPackByPackId";
		return sqlSessionFactory.openSession().selectOne(statement, packId);
	}

	@Override
	public int updatePackByPackId(Pack pack) {
		String statement = "com.qdu.mapping.PackMapping.updatePackByPackId";
		return sqlSessionFactory.openSession().update(statement,pack);
	}

	@Override
	public int deletePackId(int packId) {
		String statement = "com.qdu.mapping.PackMapping.deletePackId";
		return sqlSessionFactory.openSession().delete(statement, packId);
	}

	@Override
	public ShortAnswer selectShortAnswerByShortAnswerId(int shortAnswerId) {
		String statement = "com.qdu.mapping.ShortAnswerMapping.selectShortAnswerByShortAnswerId";
		return sqlSessionFactory.openSession().selectOne(statement, shortAnswerId);
	}

	@Override
	public int updateShortAnswerByShortAnswerId(ShortAnswer shortAnswer) {
		String statement = "com.qdu.mapping.ShortAnswerMapping.updateShortAnswerByShortAnswerId";
		return sqlSessionFactory.openSession().update(statement, shortAnswer);
	}

	@Override
	public int deleteShortAnswerId(int shortAnswerId) {
		String statement = "com.qdu.mapping.ShortAnswerMapping.deleteShortAnswerId";
		return sqlSessionFactory.openSession().delete(statement, shortAnswerId);
	}

	@Override
	public Examination selectExaminationOnlyCode(String onlyCode) {
		String statement = "com.qdu.mapping.ExaminationMapping.selectExaminationOnlyCode";
		return sqlSessionFactory.openSession().selectOne(statement,onlyCode);
	}

	@Override
	public int insertStudentAnswer(StudentAnswer studentAnswer) {
		String statement = "com.qdu.mapping.StudentAnswerMapping.insertStudentAnswer";
		return sqlSessionFactory.openSession().insert(statement,studentAnswer);
	}

	@Override
	public int updateStudentAnswer(String studentRoNo, int examinationID, int questionNumber, String stuAnswer,int getValue) {
		String statement = "com.qdu.mapping.StudentAnswerMapping.updateStudentAnswer";
		Map<String, Object> map = new HashMap<>();
	    map.put("studentRoNo", studentRoNo);
	    map.put("examinationID", examinationID);
	    map.put("questionNumber", questionNumber);
	    map.put("stuAnswer", stuAnswer);
	    map.put("getValue", getValue);
		return sqlSessionFactory.openSession().update(statement,map);
	}

	@Override
	public int insertScore(Score score) {
		String statement = "com.qdu.mapping.ScoreMapping.insertScore";
		return sqlSessionFactory.openSession().insert(statement,score);
	}

	@Override
	public int updateScore(String studentRoNo, int examinationID, int singleSelectionValue, int moreSelectionValue,
			int judgeValue, int packValue, int shortAnswerValue, int totalValue) {
		String statement = "com.qdu.mapping.ScoreMapping.updateScore";
		Map<String, Object> map = new HashMap<>();
		 map.put("studentRoNo", studentRoNo);
		 map.put("examinationID", examinationID);
		 map.put("singleSelectionValue", singleSelectionValue);
		 map.put("moreSelectionValue", moreSelectionValue);
		 map.put("judgeValue", judgeValue);
		 map.put("packValue", packValue);
		 map.put("shortAnswerValue", shortAnswerValue);
		 map.put("totalValue", totalValue);
		return sqlSessionFactory.openSession().update(statement,map);
	}

	@Override
	public SingleSelection selectSingleSelectionByExAndQusNum(int examinationID, int questionNumber) {
		String statement = "com.qdu.mapping.SingleSelectionMapping.selectSingleSelectionByExAndQusNum";
		Map<String, Object> map = new HashMap<>();
		 map.put("questionNumber", questionNumber);
		 map.put("examinationID", examinationID);
		return sqlSessionFactory.openSession().selectOne(statement, map);
	}

	@Override
	public Score selectScoreByExIdAndStuRoNo(int examinationID, String studentRoNo) {
		String statement = "com.qdu.mapping.ScoreMapping.selectScoreByExIdAndStuRoNo";
		Map<String, Object> map = new HashMap<>();
		 map.put("examinationID", examinationID);
		 map.put("studentRoNo", studentRoNo);
		return sqlSessionFactory.openSession().selectOne(statement, map);
	}

	@Override
	public StudentAnswer selectStudentAnswerByExIdAndStuRoNo(int examinationID, String studentRoNo,
			int questionNumber) {
		String statement = "com.qdu.mapping.StudentAnswerMapping.selectStudentAnswerByExIdAndStuRoNo";
		Map<String, Object> map = new HashMap<>();
	    map.put("studentRoNo", studentRoNo);
	    map.put("examinationID", examinationID);
	    map.put("questionNumber", questionNumber);
		return sqlSessionFactory.openSession().selectOne(statement,map);
	}

	@Override
	public int UpdateExamExaminationStatus(int examinationID, String examinationStatus) {
		String statement = "com.qdu.mapping.ExaminationMapping.UpdateExamExaminationStatus";
		Map<String, Object> map = new HashMap<>();
	    map.put("examinationStatus", examinationStatus);
	    map.put("examinationID", examinationID);
		return sqlSessionFactory.openSession().update(statement, map);
	}

	@Override
	public MoreSelection selectMoreSelectionByExAndQusNum(int examinationID, int questionNumber) {
		String statement = "com.qdu.mapping.MoreSelectionMapping.selectMoreSelectionByExAndQusNum";
		Map<String, Object> map = new HashMap<>();
		 map.put("questionNumber", questionNumber);
		 map.put("examinationID", examinationID);
		return sqlSessionFactory.openSession().selectOne(statement, map);
	}

	@Override
	public Judge selectJudgeByExAndQusNum(int examinationID, int questionNumber) {
		String statement = "com.qdu.mapping.JudgeMapping.selectJudgeByExAndQusNum";
		Map<String, Object> map = new HashMap<>();
		 map.put("questionNumber", questionNumber);
		 map.put("examinationID", examinationID);
		return sqlSessionFactory.openSession().selectOne(statement, map);
	}

	@Override
	public Pack selectPackByExAndQusNum(int examinationID, int questionNumber) {
		String statement = "com.qdu.mapping.PackMapping.selectPackByExAndQusNum";
		Map<String, Object> map = new HashMap<>();
		 map.put("questionNumber", questionNumber);
		 map.put("examinationID", examinationID);
		return sqlSessionFactory.openSession().selectOne(statement, map);
	}

	@Override
	public ShortAnswer selectShortAnswerByExAndQusNum(int examinationID, int questionNumber) {
		String statement = "com.qdu.mapping.ShortAnswerMapping.selectShortAnswerByExAndQusNum";
		Map<String, Object> map = new HashMap<>();
		 map.put("questionNumber", questionNumber);
		 map.put("examinationID", examinationID);
		return sqlSessionFactory.openSession().selectOne(statement, map);
	}

	@Override
	public int updateStudentAnswerBeforeLoad(String studentRoNo, int examinationID) {
		String statement = "com.qdu.mapping.StudentAnswerMapping.updateStudentAnswerBeforeLoad";
		Map<String, Object> map = new HashMap<>();
	    map.put("studentRoNo", studentRoNo);
	    map.put("examinationID", examinationID);
		return sqlSessionFactory.openSession().update(statement,map);
	}

	@Override
	public int updateScorebeforLoad(String studentRoNo, int examinationID) {
		String statement = "com.qdu.mapping.ScoreMapping.updateScorebeforLoad";
		Map<String, Object> map = new HashMap<>();
		 map.put("studentRoNo", studentRoNo);
		 map.put("examinationID", examinationID);
		return sqlSessionFactory.openSession().update(statement,map);
	}

	@Override
	public int updateExamEnd(String studentRoNo, int examinationID) {
		String statement = "com.qdu.mapping.ScoreMapping.updateExamEnd";
		Map<String, Object> map = new HashMap<>();
		 map.put("examinationID", examinationID);
		 map.put("studentRoNo", studentRoNo);
		return sqlSessionFactory.openSession().update(statement, map);
	}

	@Override
	public List<Examination> selectMaxExaminationIdByCourseIdAndStatus(int courseId, String examinationStatus) {
		String statement = "com.qdu.mapping.ExaminationMapping.selectMaxExaminationIdByCourseIdAndStatus";
		Map<String, Object> map = new HashMap<>();
	    map.put("examinationStatus", examinationStatus);
	    map.put("courseId", courseId);
		return sqlSessionFactory.openSession().selectList(statement, map);
	}

	@Override
	public List<Score> selectScoreByExId(int examinationID) {
		String statement = "com.qdu.mapping.ScoreMapping.selectScoreByExId";
		return sqlSessionFactory.openSession().selectList(statement, examinationID);
	}

	@Override
	public Score selectScoreById(int scoreId) {
		String statement = "com.qdu.mapping.ScoreMapping.selectScoreById";
		return sqlSessionFactory.openSession().selectOne(statement, scoreId);
	}

	@Override
	public int updatePackStudentAnswer(int examinationID, int questionNumber, String studentAnswer) {
		String statement = "com.qdu.mapping.PackMapping.updatePackStudentAnswer";
		Map<String, Object> map = new HashMap<>();
		 map.put("questionNumber", questionNumber);
		 map.put("examinationID", examinationID);
		 map.put("studentAnswer", studentAnswer);
		return sqlSessionFactory.openSession().update(statement, map);
	}

	@Override
	public int updateShortAnswerStudentAnswer(int examinationID, int questionNumber, String studentAnswer) {
		String statement = "com.qdu.mapping.ShortAnswerMapping.updateShortAnswerStudentAnswer";
		Map<String, Object> map = new HashMap<>();
		 map.put("questionNumber", questionNumber);
		 map.put("examinationID", examinationID);
		 map.put("studentAnswer", studentAnswer);
		return sqlSessionFactory.openSession().update(statement, map);
	}

	@Override
	public int updateScoreStatus(int scoreId, String scoreStatus) {
		String statement = "com.qdu.mapping.ScoreMapping.updateScoreStatus";
		Map<String, Object> map = new HashMap<>();
		 map.put("scoreId", scoreId);
		 map.put("scoreStatus", scoreStatus);
		return sqlSessionFactory.openSession().update(statement, map);
	}

	@Override
	public double selectAvgScoreById(int examinationID) {
		String statement = "com.qdu.mapping.ScoreMapping.selectAvgScoreById";
		return sqlSessionFactory.openSession().selectOne(statement, examinationID);
	}

	@Override
	public int selectMaxScoreById(int examinationID) {
		String statement = "com.qdu.mapping.ScoreMapping.selectMaxScoreById";
		return sqlSessionFactory.openSession().selectOne(statement, examinationID);
	}

	@Override
	public int selectMinScoreById(int examinationID) {
		String statement = "com.qdu.mapping.ScoreMapping.selectMinScoreById";
		return sqlSessionFactory.openSession().selectOne(statement, examinationID);
	}

	@Override
	public int selectCountScoreById(int examinationID) {
		String statement = "com.qdu.mapping.ScoreMapping.selectCountScoreById";
		return sqlSessionFactory.openSession().selectOne(statement, examinationID);
	}

	@Override
	public List<Score> selectScoreByStudent(String studentRoNo) {
		String statement = "com.qdu.mapping.ScoreMapping.selectScoreByStudent";
		return sqlSessionFactory.openSession().selectList(statement, studentRoNo);
	}

	@Override
	public int updateScoreChert(int scoreId, String chertSuspicion) {
		String statement = "com.qdu.mapping.ScoreMapping.updateScoreChert";
		Map<String, Object> map = new HashMap<>();
		 map.put("scoreId", scoreId);
		 map.put("chertSuspicion", chertSuspicion);
		return sqlSessionFactory.openSession().update(statement, map);
	}

	@Override
	public int insertComeparePhoto(ComeparePhoto comeparePhoto) {
		String statement = "com.qdu.mapping.ComeparePhotoMapping.insertComeparePhoto";
		return sqlSessionFactory.openSession().insert(statement,comeparePhoto);
	}

	
	
	

}
