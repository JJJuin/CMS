package com.qdu.serviceimpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
import com.qdu.service.ExaminationService;

@Transactional
@Service
public class ExaminationServiceImpl implements ExaminationService{
	
	@Autowired private ExaminationDao examinationDaoImpl;
	
	@Override
	public List<Examination> selectExamination() {
		return examinationDaoImpl.selectExamination();
	}

	@Override
	public int insertExamination(Examination examination) {
		return examinationDaoImpl.insertExamination(examination);
	}

	@Override
	public int deleteExaminationById(int examinationID) {
		return examinationDaoImpl.deleteExaminationById(examinationID);
	}

	@Override
	public List<Examination> selectExaminationByCourseId(int courseId) {
		return examinationDaoImpl.selectExaminationByCourseId(courseId);
	}

	@Override
	public Examination selectMaxExaminationIdByCourseId(int courseId) {
		return examinationDaoImpl.selectMaxExaminationIdByCourseId(courseId);
	}

	@Override
	public Examination selectExaminationByExaminationId(int examinationID) {
		return examinationDaoImpl.selectExaminationByExaminationId(examinationID);
	}

	@Override
	public int selectSingleSelectionCount(int examinationID) {
		return examinationDaoImpl.selectSingleSelectionCount(examinationID);
	}

	@Override
	public int insertSingleSelection(SingleSelection selection) {
		return examinationDaoImpl.insertSingleSelection(selection);
	}

	@Override
	public List<SingleSelection> selectSingleByExaminationID(int examinationID) {
		return examinationDaoImpl.selectSingleByExaminationID(examinationID);
	}

	@Override
	public int selectMoreSelectionCount(int examinationID) {
		return examinationDaoImpl.selectMoreSelectionCount(examinationID);
	}

	@Override
	public List<MoreSelection> selectMoreByExaminationID(int examinationID) {
		return examinationDaoImpl.selectMoreByExaminationID(examinationID);
	}

	@Override
	public int insertMoreSelection(MoreSelection moreSelection) {
		return examinationDaoImpl.insertMoreSelection(moreSelection);
	}

	@Override
	public int updateMoreSelectionById(int moreSelectionId,int questionNumber) {
		return examinationDaoImpl.updateMoreSelectionById(moreSelectionId,questionNumber);
	}

	@Override
	public int selectJudgeCount(int examinationID) {
		return examinationDaoImpl.selectJudgeCount(examinationID);
	}

	@Override
	public int insertJudge(Judge judge) {
		return examinationDaoImpl.insertJudge(judge);
	}

	@Override
	public int updateJudgeById(int judgeId, int questionNumber) {
		return examinationDaoImpl.updateJudgeById(judgeId, questionNumber);
	}

	@Override
	public List<Judge> selectJudgeByExaminationID(int examinationID) {
		return examinationDaoImpl.selectJudgeByExaminationID(examinationID);
	}

	@Override
	public List<Pack> selectPackByExaminationIDX(int examinationID) {
		return examinationDaoImpl.selectPackByExaminationIDX(examinationID);
	}

	@Override
	public int insertPack(Pack pack) {
		return examinationDaoImpl.insertPack(pack);
	}

	@Override
	public int updatePackById(int packId, int questionNumber) {
		return examinationDaoImpl.updatePackById(packId, questionNumber);
	}

	@Override
	public List<ShortAnswer> selectShortAnswerByExaminationIDX(int examinationID) {
		return examinationDaoImpl.selectShortAnswerByExaminationIDX(examinationID);
	}

	@Override
	public int insertShortAnswer(ShortAnswer shortAnswer) {
		return examinationDaoImpl.insertShortAnswer(shortAnswer);
	}

	@Override
	public int updateShortAnswerById(int shortAnswerId, int questionNumber) {
		return examinationDaoImpl.updateShortAnswerById(shortAnswerId, questionNumber);
	}

	@Override
	public int selectPackCount(int examinationID) {
		return examinationDaoImpl.selectPackCount(examinationID);
	}

	@Override
	public int selectShortAnswerCount(int examinationID) {
		return examinationDaoImpl.selectShortAnswerCount(examinationID);
	}

	@Override
	public int updateExaminationOfEdit(int examinationID,int canEdit) {
		return examinationDaoImpl.updateExaminationOfEdit(examinationID,canEdit);
	}

	@Override
	public int updateExaminationTemValue(int examinationID, int temValue) {
		return examinationDaoImpl.updateExaminationTemValue(examinationID, temValue);
	}

	@Override
	public int deleteJudge(int examinationID) {
		return examinationDaoImpl.deleteJudge(examinationID);
	}

	@Override
	public int deletePack(int examinationID) {
		return examinationDaoImpl.deletePack(examinationID);
	}

	@Override
	public int deleteShortAnswer(int examinationID) {
		return examinationDaoImpl.deleteShortAnswer(examinationID);
	}

	@Override
	public int deleteSingleSelection(int examinationID) {
		return examinationDaoImpl.deleteSingleSelection(examinationID);
	}

	@Override
	public int deleteMoreSelection(int examinationID) {
		return examinationDaoImpl.deleteMoreSelection(examinationID);
	}

	@Override
	public int deleteExamination(int examinationID) {
		return examinationDaoImpl.deleteExamination(examinationID);
	}

	@Override
	public int updateExamination(String examinationName, String startTime, int duration, int examinationID) {
		return examinationDaoImpl.updateExamination(examinationName, startTime, duration, examinationID);
	}

	@Override
	public SingleSelection selectSingleSelectionBysingleSelectionId(int singleSelectionId) {
		return examinationDaoImpl.selectSingleSelectionBysingleSelectionId(singleSelectionId);
	}

	@Override
	public int updateSingleBysingleSelectionId(SingleSelection singleSelection) {
		return examinationDaoImpl.updateSingleBysingleSelectionId(singleSelection);
	}

	@Override
	public int deleteSingleBySingleSelectionId(int singleSelectionId) {
		return examinationDaoImpl.deleteSingleBySingleSelectionId(singleSelectionId);
	}

	@Override
	public int updateSingleSelectionById(int singleSelectionId, int questionNumber) {
		return examinationDaoImpl.updateSingleSelectionById(singleSelectionId, questionNumber);
	}

	@Override
	public MoreSelection selectMoreSelectionByMoreSelectionId(int moreSelectionId) {
		return examinationDaoImpl.selectMoreSelectionByMoreSelectionId(moreSelectionId);
	}

	@Override
	public int updatemoreByMoreSelectionId(MoreSelection moreSelection) {
		return examinationDaoImpl.updatemoreByMoreSelectionId(moreSelection);
	}

	@Override
	public int deleteMoreSelectionId(int moreSelectionId) {
		return examinationDaoImpl.deleteMoreSelectionId(moreSelectionId);
	}

	@Override
	public Judge selectJudgeByJudgeId(int judgeId) {
		return examinationDaoImpl.selectJudgeByJudgeId(judgeId);
	}

	@Override
	public int updatejudgeByJudgeId(Judge judge) {
		return examinationDaoImpl.updatejudgeByJudgeId(judge);
	}

	@Override
	public int deleteJudgeId(int judgeId) {
		return examinationDaoImpl.deleteJudgeId(judgeId);
	}

	@Override
	public Pack selectPackByPackId(int packId) {
		return examinationDaoImpl.selectPackByPackId(packId);
	}

	@Override
	public int updatePackByPackId(Pack pack) {
		return examinationDaoImpl.updatePackByPackId(pack);
	}

	@Override
	public int deletePackId(int packId) {
		return examinationDaoImpl.deletePackId(packId);
	}

	@Override
	public ShortAnswer selectShortAnswerByShortAnswerId(int shortAnswerId) {
		return examinationDaoImpl.selectShortAnswerByShortAnswerId(shortAnswerId);
	}

	@Override
	public int updateShortAnswerByShortAnswerId(ShortAnswer shortAnswer) {
		return examinationDaoImpl.updateShortAnswerByShortAnswerId(shortAnswer);
	}

	@Override
	public int deleteShortAnswerId(int shortAnswerId) {
		return examinationDaoImpl.deleteShortAnswerId(shortAnswerId);
	}

	@Override
	public Examination selectExaminationOnlyCode(String onlyCode) {
		return examinationDaoImpl.selectExaminationOnlyCode(onlyCode);
	}

	@Override
	public int insertStudentAnswer(StudentAnswer studentAnswer) {
		return examinationDaoImpl.insertStudentAnswer(studentAnswer);
	}

	@Override
	public int updateStudentAnswer(String studentRoNo, int examinationID, int questionNumber, String stuAnswer,int getValue) {
		return examinationDaoImpl.updateStudentAnswer(studentRoNo, examinationID, questionNumber, stuAnswer,getValue);
	}

	@Override
	public int insertScore(Score score) {
		return examinationDaoImpl.insertScore(score);
	}

	@Override
	public int updateScore(String studentRoNo, int examinationID, int singleSelectionValue, int moreSelectionValue,
			int judgeValue, int packValue, int shortAnswerValue, int totalValue) {
		return examinationDaoImpl.updateScore(studentRoNo, examinationID, singleSelectionValue, moreSelectionValue, judgeValue, packValue, shortAnswerValue, totalValue);
	}

	@Override
	public SingleSelection selectSingleSelectionByExAndQusNum(int examinationID, int questionNumber) {
		return examinationDaoImpl.selectSingleSelectionByExAndQusNum(examinationID, questionNumber);
	}

	@Override
	public Score selectScoreByExIdAndStuRoNo(int examinationID, String studentRoNo) {
		return examinationDaoImpl.selectScoreByExIdAndStuRoNo(examinationID, studentRoNo);
	}

	@Override
	public StudentAnswer selectStudentAnswerByExIdAndStuRoNo(int examinationID, String studentRoNo,
			int questionNumber) {
		return examinationDaoImpl.selectStudentAnswerByExIdAndStuRoNo(examinationID, studentRoNo, questionNumber);
	}

	@Override
	public int UpdateExamExaminationStatus(int examinationID, String examinationStatus) {
		return examinationDaoImpl.UpdateExamExaminationStatus(examinationID, examinationStatus);
	}

	@Override
	public MoreSelection selectMoreSelectionByExAndQusNum(int examinationID, int questionNumber) {
		return examinationDaoImpl.selectMoreSelectionByExAndQusNum(examinationID, questionNumber);
	}

	@Override
	public Judge selectJudgeByExAndQusNum(int examinationID, int questionNumber) {
		return examinationDaoImpl.selectJudgeByExAndQusNum(examinationID, questionNumber);
	}

	@Override
	public Pack selectPackByExAndQusNum(int examinationID, int questionNumber) {
		return examinationDaoImpl.selectPackByExAndQusNum(examinationID, questionNumber);
	}

	@Override
	public ShortAnswer selectShortAnswerByExAndQusNum(int examinationID, int questionNumber) {
		return examinationDaoImpl.selectShortAnswerByExAndQusNum(examinationID, questionNumber);
	}

	@Override
	public int updateStudentAnswerBeforeLoad(String studentRoNo, int examinationID) {
		return examinationDaoImpl.updateStudentAnswerBeforeLoad(studentRoNo, examinationID);
	}

	@Override
	public int updateScorebeforLoad(String studentRoNo, int examinationID) {
		return examinationDaoImpl.updateScorebeforLoad(studentRoNo, examinationID);
	}

	@Override
	public int updateExamEnd(String studentRoNo, int examinationID) {
		return examinationDaoImpl.updateExamEnd(studentRoNo, examinationID);
	}

	@Override
	public List<Examination> selectMaxExaminationIdByCourseIdAndStatus(int courseId, String examinationStatus) {
		return examinationDaoImpl.selectMaxExaminationIdByCourseIdAndStatus(courseId, examinationStatus);
	}

	@Override
	public List<Score> selectScoreByExId(int examinationID) {
		return examinationDaoImpl.selectScoreByExId(examinationID);
	}

	@Override
	public Score selectScoreById(int scoreId) {
		return examinationDaoImpl.selectScoreById(scoreId);
	}

	@Override
	public int updatePackStudentAnswer(int examinationID, int questionNumber, String studentAnswer) {
		return examinationDaoImpl.updatePackStudentAnswer(examinationID, questionNumber, studentAnswer);
	}

	@Override
	public int updateShortAnswerStudentAnswer(int examinationID, int questionNumber, String studentAnswer) {
		return examinationDaoImpl.updateShortAnswerStudentAnswer(examinationID, questionNumber, studentAnswer);
	}

	@Override
	public int updateScoreStatus(int scoreId, String scoreStatus) {
		return examinationDaoImpl.updateScoreStatus(scoreId, scoreStatus);
	}

	@Override
	public double selectAvgScoreById(int examinationID) {
		return examinationDaoImpl.selectAvgScoreById(examinationID);
	}

	@Override
	public int selectMaxScoreById(int examinationID) {
		return examinationDaoImpl.selectMaxScoreById(examinationID);
	}

	@Override
	public int selectMinScoreById(int examinationID) {
		return examinationDaoImpl.selectMinScoreById(examinationID);
	}

	@Override
	public int selectCountScoreById(int examinationID) {
		return examinationDaoImpl.selectCountScoreById(examinationID);
	}

	@Override
	public List<Score> selectScoreByStudent(String studentRoNo) {
		return examinationDaoImpl.selectScoreByStudent(studentRoNo);
	}

	@Override
	public int updateScoreChert(int scoreId, String chertSuspicion) {
		return examinationDaoImpl.updateScoreChert(scoreId, chertSuspicion);
	}

	@Override
	public int insertComeparePhoto(ComeparePhoto comeparePhoto) {
		return examinationDaoImpl.insertComeparePhoto(comeparePhoto);
	}

	@Override
	public List<ComeparePhoto> coparePhotoDetail(int scoreId) {
		return examinationDaoImpl.coparePhotoDetail(scoreId);
	}
	
	
}
