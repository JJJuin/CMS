package com.qdu.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import org.apache.tomcat.util.codec.binary.Base64;
import org.opencv.core.Core;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mysql.fabric.xmlrpc.base.Data;
import com.qdu.aop.SystemLog;
import com.qdu.pojo.ClazzStu;
import com.qdu.pojo.ComeparePhoto;
import com.qdu.pojo.Examination;
import com.qdu.pojo.Judge;
import com.qdu.pojo.MoreSelection;
import com.qdu.pojo.Pack;
import com.qdu.pojo.Score;
import com.qdu.pojo.ShortAnswer;
import com.qdu.pojo.SingleSelection;
import com.qdu.pojo.Student;
import com.qdu.pojo.StudentAnswer;
import com.qdu.pojo.StudentInfo;
import com.qdu.service.ClazzService;
import com.qdu.service.ClazzStuService;
import com.qdu.service.CourseService;
import com.qdu.service.ExaminationService;
import com.qdu.service.FilePackageService;
import com.qdu.service.LeaveRecordService;
import com.qdu.service.LogEntityService;
import com.qdu.service.MessageService;
import com.qdu.service.StudentInfoService;
import com.qdu.service.StudentService;
import com.qdu.service.TeacherService;
import com.qdu.util.BMPLoader;
import com.qdu.util.CopyFile;
import com.qdu.util.DetectFaceTest;
import com.qdu.util.FingerPrint;
import com.qdu.util.MD5Util;
import com.qdu.util.PhotoDigest;

@Controller
@RequestMapping(value = "exam")
public class ExaminationController {
	

	@Autowired
	ExaminationService examinationServiceImpl;
	@Autowired
	private TeacherService teacherServiceImpl;
	@Autowired
	private CourseService courseServiceImpl;
	@Autowired
	private ClazzService clazzServiceImpl;
	@Autowired
	private MessageService messageServiceImpl;
	@Autowired
	private StudentService studentServiceImpl;
	@Autowired
	private FilePackageService filePackageServiceImpl;
	@Autowired
	private LogEntityService logEntityServiceImpl;
	@Autowired
	private LeaveRecordService leaveRecordServiceImpl;
	@Autowired
	private StudentInfoService studentInfoServiceImpl;
	@Autowired
	private ClazzStuService clazzStuServiceImpl;

	// 查询试卷
	@RequestMapping("/selectExaminationByMyId.do")
	@ResponseBody
	public Map<String, Object> selectExaminationByMyId(int examinationId) throws ParseException {
		Map<String, Object> map = new HashMap<>();
		Examination examination2 = examinationServiceImpl.selectExaminationByExaminationId(examinationId);
		long t1 = System.currentTimeMillis();

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:SS");
		String ts1 = examination2.getStartTime().substring(0, 10).replace("-", "");
		String ts2 = examination2.getStartTime().substring(11).replace(":", "");
		String ts3 = ts1 + ts2;
		long tx = Long.parseLong(ts3);

		String aString = sdf.format(new Date());
		String cs1 = aString.substring(0, 10).replace("-", "");
		String cs2 = aString.substring(11, 19).replace(":", "");
		String cs3 = cs1 + cs2;
		long ts = Long.parseLong(cs3);
		long endTime = tx + (examination2.getDuration() / 60) * 10000 + (examination2.getDuration() % 60) * 100;

		if (ts > endTime) {
			examinationServiceImpl.updateExaminationOfEdit(examinationId, 0);
		}

		Examination examination = examinationServiceImpl.selectExaminationByExaminationId(examinationId);
		if (examination.getCanEdit() == 0) {
			List<SingleSelection> singleSelections = examinationServiceImpl.selectSingleByExaminationID(examinationId);
			List<MoreSelection> moreSelections = examinationServiceImpl.selectMoreByExaminationID(examinationId);
			List<Judge> judges = examinationServiceImpl.selectJudgeByExaminationID(examinationId);
			List<Pack> packs = examinationServiceImpl.selectPackByExaminationIDX(examinationId);
			List<ShortAnswer> shortAnswers = examinationServiceImpl.selectShortAnswerByExaminationIDX(examinationId);

			long t2 = System.currentTimeMillis();
			System.out.println("时间差" + (t2 - t1) + "ms");

			map.put("result", true);
			map.put("examination", examination);
			map.put("singleSelections", singleSelections);
			map.put("moreSelections", moreSelections);
			map.put("judges", judges);
			map.put("packs", packs);
			map.put("shortAnswers", shortAnswers);
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 查询某课程下的试卷列表
	@RequestMapping("/selectExaminationByCourseId.do")
	@ResponseBody
	public Map<String, Object> selectExaminationByCourseId(int courseId) {
		Map<String, Object> map = new HashMap<>();
		List<Examination> examinations = examinationServiceImpl.selectExaminationByCourseId(courseId);
		if (examinations.size() == 0) {
			System.out.println("暂无试卷");
		}
		map.put("examinations", examinations);
		return map;
	}

	// 添加试卷
	@SystemLog(module = "教师", methods = "日志管理-添加试卷")
	@RequestMapping("/addExamination.do")
	@ResponseBody
	public Map<String, Object> addExamination(int courseId, String examinationName, int totalValue,
			@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:SS") Date startTime, int duration) {
		Map<String, Object> map = new HashMap<>();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:SS");
		System.out.println(courseId);
		System.out.println(examinationName);
		System.out.println(totalValue);
		List<Examination> examinations = examinationServiceImpl.selectExamination();
		System.out.println(examinations.size());
		int maxId = 0;
		if (examinations != null && examinations.size() > 0) {
			maxId = examinationServiceImpl.selectExamination().get(0).getExaminationID();
		} else {
			maxId = 0;
		}
		String status = "C" + (maxId + 1) + "R" + (new Random().nextInt(90) + 10);
		System.out.println(status);
		Examination examination = new Examination();
		examination.setExaminationName(examinationName);
		examination.setTotalValue(totalValue);
		examination.setStartTime(sdf.format(startTime));
		examination.setDuration(duration);
		examination.setCourseID(courseId);
		examination.setOnlyCode(status);
		examination.setExaminationStatus("待考");
		examination.setCanEdit(0);
		int tem = examinationServiceImpl.insertExamination(examination);
		System.out.println(tem);
		if (tem > 0) {
			map.put("result", true);
		}
		return map;
	}

	// 添加单选题
	@RequestMapping(value = "/addSingleSelection.do")
	@ResponseBody
	public Map<String, Object> addSingleSelection(String examinationId, String questionContent,
			String singleSelectionValue, String optionA, String optionB, String optionC, String optionD, String answer,
			String note) {
		Map<String, Object> map = new HashMap<>();
		int count = examinationServiceImpl.selectSingleSelectionCount(Integer.parseInt(examinationId));
		Examination examination = examinationServiceImpl
				.selectExaminationByExaminationId(Integer.parseInt(examinationId));
		if ((examination.getTemValue() + Integer.parseInt(singleSelectionValue)) <= examination.getTotalValue()) {
			examinationServiceImpl.updateExaminationTemValue(Integer.parseInt(examinationId),
					examination.getTemValue() + Integer.parseInt(singleSelectionValue));
			SingleSelection singleSelection = new SingleSelection();
			singleSelection.setQuestionNumber(count + 1);
			singleSelection.setQuestionContent(questionContent);
			singleSelection.setOptionA(optionA);
			singleSelection.setOptionB(optionB);
			singleSelection.setOptionC(optionC);
			singleSelection.setOptionD(optionD);
			singleSelection.setAnswer(answer);
			singleSelection.setQuestionsType("单选");
			singleSelection.setValue(Integer.parseInt(singleSelectionValue));
			singleSelection.setNote(note);
			singleSelection.setExamination(examination);
			int tem = examinationServiceImpl.insertSingleSelection(singleSelection);

			// 多选题号
			int x = count + 1;
			List<MoreSelection> moreSelections = examinationServiceImpl
					.selectMoreByExaminationID(Integer.parseInt(examinationId));
			if (moreSelections.size() > 0) {
				for (int i = 0; i < moreSelections.size(); i++) {
					x++;
					examinationServiceImpl.updateMoreSelectionById(moreSelections.get(i).getMoreSelectionId(), x);
				}
			}

			// 判断题号
			int count2 = examinationServiceImpl.selectMoreSelectionCount(Integer.parseInt(examinationId));
			int y = count + count2 + 1;
			List<Judge> judges = examinationServiceImpl.selectJudgeByExaminationID(Integer.parseInt(examinationId));
			if (judges.size() > 0) {
				for (int i = 0; i < judges.size(); i++) {
					y++;
					examinationServiceImpl.updateJudgeById(judges.get(i).getJudgeId(), y);
				}
			}

			// 填空题号
			int count3 = examinationServiceImpl.selectJudgeCount(Integer.parseInt(examinationId));
			int z = count + count2 + count3 + 1;
			List<Pack> packs = examinationServiceImpl.selectPackByExaminationIDX(Integer.parseInt(examinationId));
			if (packs.size() > 0) {
				for (int i = 0; i < packs.size(); i++) {
					z++;
					examinationServiceImpl.updatePackById(packs.get(i).getPackId(), z);
				}
			}
			// 简答题号
			int count4 = examinationServiceImpl.selectPackCount(Integer.parseInt(examinationId));
			int s = count + count2 + count3 + count4 + 1;
			List<ShortAnswer> shortAnswers = examinationServiceImpl
					.selectShortAnswerByExaminationIDX(Integer.parseInt(examinationId));
			if (shortAnswers.size() > 0) {
				for (int i = 0; i < shortAnswers.size(); i++) {
					s++;
					examinationServiceImpl.updateShortAnswerById(shortAnswers.get(i).getShortAnswerId(), s);
				}
			}

			if (tem > 0) {
				map.put("result", true);
			} else {
				map.put("result", false);
			}
		} else {
			map.put("result", "no");
		}

		return map;
	}

	// 添加多选题
	@RequestMapping(value = "/addMoreSelection.do")
	@ResponseBody
	public Map<String, Object> addMoreSelection(String examinationId, String questionContent, String MoreSelectionValue,
			String optionA, String optionB, String optionC, String optionD, String answer, String note)
			throws ParseException {
		Map<String, Object> map = new HashMap<>();
		System.out.println("answer: " + answer);
		int count1 = examinationServiceImpl.selectSingleSelectionCount(Integer.parseInt(examinationId));
		int count = examinationServiceImpl.selectMoreSelectionCount(Integer.parseInt(examinationId));
		Examination examination = examinationServiceImpl
				.selectExaminationByExaminationId(Integer.parseInt(examinationId));
		if ((examination.getTemValue() + Integer.parseInt(MoreSelectionValue)) <= examination.getTotalValue()) {
			examinationServiceImpl.updateExaminationTemValue(Integer.parseInt(examinationId),
					examination.getTemValue() + Integer.parseInt(MoreSelectionValue));
			MoreSelection moreSelection = new MoreSelection();
			moreSelection.setQuestionNumber(count1 + count + 1);
			moreSelection.setQuestionContent(questionContent);
			moreSelection.setOptionA(optionA);
			moreSelection.setOptionB(optionB);
			moreSelection.setOptionC(optionC);
			moreSelection.setOptionD(optionD);
			moreSelection.setAnswer(answer);
			moreSelection.setQuestionsType("多选");
			moreSelection.setValue(Integer.parseInt(MoreSelectionValue));
			moreSelection.setNote(note);
			moreSelection.setExamination(examination);
			int tem = examinationServiceImpl.insertMoreSelection(moreSelection);

			// 判断题题号
			int y = count + count1 + 1;
			List<Judge> judges = examinationServiceImpl.selectJudgeByExaminationID(Integer.parseInt(examinationId));
			if (judges.size() > 0) {
				for (int i = 0; i < judges.size(); i++) {
					y++;
					examinationServiceImpl.updateJudgeById(judges.get(i).getJudgeId(), y);
				}
			}
			// 填空题题号
			int count2 = examinationServiceImpl.selectJudgeCount(Integer.parseInt(examinationId));
			int z = count + count1 + count2 + 1;
			List<Pack> packs = examinationServiceImpl.selectPackByExaminationIDX(Integer.parseInt(examinationId));
			if (packs.size() > 0) {
				for (int i = 0; i < packs.size(); i++) {
					z++;
					examinationServiceImpl.updatePackById(packs.get(i).getPackId(), z);
				}
			}
			// 简答题号
			int count3 = examinationServiceImpl.selectPackCount(Integer.parseInt(examinationId));
			int s = count + count1 + count2 + count3 + 1;
			List<ShortAnswer> shortAnswers = examinationServiceImpl
					.selectShortAnswerByExaminationIDX(Integer.parseInt(examinationId));
			if (shortAnswers.size() > 0) {
				for (int i = 0; i < shortAnswers.size(); i++) {
					s++;
					examinationServiceImpl.updateShortAnswerById(shortAnswers.get(i).getShortAnswerId(), s);
				}
			}

			if (tem > 0) {
				map.put("result", true);
			} else {
				map.put("result", false);
			}
		} else {
			map.put("result", "no");
		}
		return map;
	}

	// 添加判断题
	@RequestMapping(value = "/addJudgeAnswer.do")
	@ResponseBody
	public Map<String, Object> addJudgeAnswer(String examinationId, String questionContent, String JudgeValue,
			String answer, String note) {
		Map<String, Object> map = new HashMap<>();
		System.out.println("answer: " + answer);
		int count1 = examinationServiceImpl.selectSingleSelectionCount(Integer.parseInt(examinationId));
		int count2 = examinationServiceImpl.selectMoreSelectionCount(Integer.parseInt(examinationId));
		int count3 = examinationServiceImpl.selectJudgeCount(Integer.parseInt(examinationId));
		int count4 = examinationServiceImpl.selectPackCount(Integer.parseInt(examinationId));
		Examination examination = examinationServiceImpl
				.selectExaminationByExaminationId(Integer.parseInt(examinationId));
		if ((examination.getTemValue() + Integer.parseInt(JudgeValue)) <= examination.getTotalValue()) {
			examinationServiceImpl.updateExaminationTemValue(Integer.parseInt(examinationId),
					examination.getTemValue() + Integer.parseInt(JudgeValue));
			Judge judge = new Judge();
			judge.setJudgeContent(questionContent);
			judge.setQuestionNumber(count1 + count2 + count3 + 1);
			judge.setValue(Integer.parseInt(JudgeValue));
			judge.setQuestionsType("判断");
			judge.setAnswer(answer);
			judge.setNote(note);
			judge.setExamination(examination);
			int tem = examinationServiceImpl.insertJudge(judge);

			// 填空题题号
			int z = count1 + count2 + count3 + 1;
			List<Pack> packs = examinationServiceImpl.selectPackByExaminationIDX(Integer.parseInt(examinationId));
			if (packs.size() > 0) {
				for (int i = 0; i < packs.size(); i++) {
					z++;
					examinationServiceImpl.updatePackById(packs.get(i).getPackId(), z);
				}
			}

			// 简答题号
			int s = count1 + count2 + count3 + count4 + 1;
			List<ShortAnswer> shortAnswers = examinationServiceImpl
					.selectShortAnswerByExaminationIDX(Integer.parseInt(examinationId));
			if (shortAnswers.size() > 0) {
				for (int i = 0; i < shortAnswers.size(); i++) {
					s++;
					examinationServiceImpl.updateShortAnswerById(shortAnswers.get(i).getShortAnswerId(), s);
				}
			}

			if (tem > 0) {
				map.put("result", true);
			} else {
				map.put("result", false);
			}
		} else {
			map.put("result", "no");
		}
		return map;
	}

	// 添加填空题
	@RequestMapping(value = "/addPack.do")
	@ResponseBody
	public Map<String, Object> addPack(String examinationId, String questionContent, String PackValue, String answer,
			String note) {
		Map<String, Object> map = new HashMap<>();
		System.out.println("answer: " + answer);
		int count1 = examinationServiceImpl.selectSingleSelectionCount(Integer.parseInt(examinationId));
		int count2 = examinationServiceImpl.selectMoreSelectionCount(Integer.parseInt(examinationId));
		int count3 = examinationServiceImpl.selectJudgeCount(Integer.parseInt(examinationId));
		int count4 = examinationServiceImpl.selectPackCount(Integer.parseInt(examinationId));
		Examination examination = examinationServiceImpl
				.selectExaminationByExaminationId(Integer.parseInt(examinationId));
		if ((examination.getTemValue() + Integer.parseInt(PackValue)) <= examination.getTotalValue()) {
			examinationServiceImpl.updateExaminationTemValue(Integer.parseInt(examinationId),
					examination.getTemValue() + Integer.parseInt(PackValue));
			Pack pack = new Pack();
			pack.setPackContent(questionContent);
			pack.setQuestionNumber(count1 + count2 + count3 + count4 + 1);
			pack.setValue(Integer.parseInt(PackValue));
			pack.setQuestionsType("填空");
			pack.setAnswer(answer);
			pack.setNote(note);
			pack.setExamination(examination);
			int tem = examinationServiceImpl.insertPack(pack);

			// 简答题号
			int s = count1 + count2 + count3 + count4 + 1;
			List<ShortAnswer> shortAnswers = examinationServiceImpl
					.selectShortAnswerByExaminationIDX(Integer.parseInt(examinationId));
			if (shortAnswers.size() > 0) {
				for (int i = 0; i < shortAnswers.size(); i++) {
					s++;
					examinationServiceImpl.updateShortAnswerById(shortAnswers.get(i).getShortAnswerId(), s);
				}
			}

			if (tem > 0) {
				map.put("result", true);
			} else {
				map.put("result", false);
			}
		} else {
			map.put("result", "no");
		}
		return map;
	}

	// 添加简答题
	@RequestMapping(value = "/addShortAnswer.do")
	@ResponseBody
	public Map<String, Object> addShortAnswer(String examinationId, String questionContent, String ShortAnswerValue,
			String note) {
		Map<String, Object> map = new HashMap<>();
		int count1 = examinationServiceImpl.selectSingleSelectionCount(Integer.parseInt(examinationId));
		int count2 = examinationServiceImpl.selectMoreSelectionCount(Integer.parseInt(examinationId));
		int count3 = examinationServiceImpl.selectJudgeCount(Integer.parseInt(examinationId));
		int count4 = examinationServiceImpl.selectPackCount(Integer.parseInt(examinationId));
		int count5 = examinationServiceImpl.selectShortAnswerCount(Integer.parseInt(examinationId));
		Examination examination = examinationServiceImpl
				.selectExaminationByExaminationId(Integer.parseInt(examinationId));
		if ((examination.getTemValue() + Integer.parseInt(ShortAnswerValue)) <= examination.getTotalValue()) {
			examinationServiceImpl.updateExaminationTemValue(Integer.parseInt(examinationId),
					examination.getTemValue() + Integer.parseInt(ShortAnswerValue));
			ShortAnswer shortAnswer = new ShortAnswer();
			shortAnswer.setShortAnswerContent(questionContent);
			shortAnswer.setQuestionNumber(count1 + count2 + count3 + count4 + +count5 + 1);
			shortAnswer.setValue(Integer.parseInt(ShortAnswerValue));
			shortAnswer.setQuestionsType("简答");
			shortAnswer.setNote(note);
			shortAnswer.setExamination(examination);
			int tem = examinationServiceImpl.insertShortAnswer(shortAnswer);
			if (tem > 0) {
				map.put("result", true);
			} else {
				map.put("result", false);
			}
		} else {
			map.put("result", "no");
		}
		return map;
	}

	// 更新试卷状态，改为不可修改
	@SystemLog(module = "教师", methods = "日志管理-提交试卷")
	@RequestMapping(value = "/updateEditStatus.do")
	@ResponseBody
	public Map<String, Object> updateEditStatus(String examinationId) {
		Map<String, Object> map = new HashMap<>();
		System.out.println(examinationId);
		Examination examination = examinationServiceImpl
				.selectExaminationByExaminationId(Integer.parseInt(examinationId));
		int val = examination.getTemValue();
		int tem = -1;
		if (val == examination.getTotalValue()) {
			tem = examinationServiceImpl.updateExaminationOfEdit(Integer.parseInt(examinationId), 1);
		}
		if (tem > 0) {
			map.put("result", true);
		} else {
			map.put("result", examination.getTotalValue() - examination.getTemValue());
		}
		return map;
	}

	// 删除试卷
	@SystemLog(module = "教师", methods = "日志管理-删除试卷")
	@RequestMapping(value = "/deleteExamById.do")
	@ResponseBody
	public Map<String, Object> deleteExamById(String examinationId) {
		Map<String, Object> map = new HashMap<>();
		int tem1 = examinationServiceImpl.deleteSingleSelection(Integer.parseInt(examinationId));
		int tem2 = examinationServiceImpl.deleteMoreSelection(Integer.parseInt(examinationId));
		int tem3 = examinationServiceImpl.deleteJudge(Integer.parseInt(examinationId));
		int tem4 = examinationServiceImpl.deletePack(Integer.parseInt(examinationId));
		int tem5 = examinationServiceImpl.deleteShortAnswer(Integer.parseInt(examinationId));
		int tem6 = examinationServiceImpl.deleteExamination(Integer.parseInt(examinationId));
		if ((tem1 + tem2 + tem3 + tem4 + tem5 + tem6) > 0) {
			map.put("result", true);
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 修改试卷
	// @SystemLog(module = "教师", methods = "日志管理-修改试卷")
	@RequestMapping(value = "/changeExamById.do")
	@ResponseBody
	public Map<String, Object> changeExamById(String examinationId, String examinationName,
			@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:SS") Date startTime, int duration) {
		Map<String, Object> map = new HashMap<>();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:SS");
		int tem = examinationServiceImpl.updateExamination(examinationName, sdf.format(startTime), duration,
				Integer.parseInt(examinationId));
		if (tem > 0) {
			map.put("result", true);
			System.out.println("222");
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 查找单选题
	@RequestMapping(value = "/changeSingleSelection.do")
	@ResponseBody
	public Map<String, Object> changeTiMu(String singleSelectionId) {
		Map<String, Object> map = new HashMap<>();
		System.out.println(singleSelectionId);
		SingleSelection singleSelection = examinationServiceImpl
				.selectSingleSelectionBysingleSelectionId(Integer.parseInt(singleSelectionId));
		if (singleSelection != null) {
			map.put("result", true);
			map.put("singleSelection", singleSelection);
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 查找多选题
	@RequestMapping(value = "/changeMoreSelection.do")
	@ResponseBody
	public Map<String, Object> changeMoreSelection(int moreSelectionId) {
		Map<String, Object> map = new HashMap<>();
		MoreSelection moreSelection = examinationServiceImpl.selectMoreSelectionByMoreSelectionId(moreSelectionId);
		if (moreSelection != null) {
			map.put("result", true);
			map.put("moreSelection", moreSelection);
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 查找判断题
	@RequestMapping(value = "/changeJudge.do")
	@ResponseBody
	public Map<String, Object> changeJudge(int judgeId) {
		Map<String, Object> map = new HashMap<>();
		Judge judge = examinationServiceImpl.selectJudgeByJudgeId(judgeId);
		if (judge != null) {
			map.put("result", true);
			map.put("judge", judge);
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 查找填空题
	@RequestMapping(value = "/changePack.do")
	@ResponseBody
	public Map<String, Object> changePack(int packId) {
		Map<String, Object> map = new HashMap<>();
		Pack pack = examinationServiceImpl.selectPackByPackId(packId);
		if (pack != null) {
			map.put("result", true);
			map.put("pack", pack);
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 查找简答题
	@RequestMapping(value = "/changeShortAnswer.do")
	@ResponseBody
	public Map<String, Object> changeShortAnswer(int shortAnswerId) {
		Map<String, Object> map = new HashMap<>();
		ShortAnswer shortAnswer = examinationServiceImpl.selectShortAnswerByShortAnswerId(shortAnswerId);
		if (shortAnswer != null) {
			map.put("result", true);
			map.put("shortAnswer", shortAnswer);
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 更新单选题
	@RequestMapping(value = "/saveChangeSingleSelection.do")
	@ResponseBody
	public Map<String, Object> saveSingleSelectionChange(String examinationId, int singleSelectionId,
			String questionContent, String singleSelectionValue, String optionA, String optionB, String optionC,
			String optionD, String answer, String note) {
		Map<String, Object> map = new HashMap<>();
		SingleSelection singleSelection = examinationServiceImpl
				.selectSingleSelectionBysingleSelectionId(singleSelectionId);
		Examination examination = examinationServiceImpl
				.selectExaminationByExaminationId(Integer.parseInt(examinationId));

		if ((examination.getTemValue() - singleSelection.getValue()
				+ Integer.parseInt(singleSelectionValue)) <= examination.getTotalValue()) {
			examinationServiceImpl.updateExaminationTemValue(examination.getExaminationID(),
					(examination.getTemValue() - singleSelection.getValue() + Integer.parseInt(singleSelectionValue)));

			singleSelection.setQuestionContent(questionContent);
			singleSelection.setOptionA(optionA);
			singleSelection.setOptionB(optionB);
			singleSelection.setOptionC(optionC);
			singleSelection.setOptionD(optionD);
			singleSelection.setAnswer(answer);
			singleSelection.setQuestionsType("单选");
			singleSelection.setValue(Integer.parseInt(singleSelectionValue));
			singleSelection.setNote(note);
			int tem = examinationServiceImpl.updateSingleBysingleSelectionId(singleSelection);
			if (tem > 0) {
				map.put("result", true);
			} else {
				map.put("result", false);
			}
		} else {
			map.put("result", "no");
		}
		return map;
	}

	// 更新多选
	@RequestMapping(value = "/saveChangeMoreSelectionId.do")
	@ResponseBody
	public Map<String, Object> saveChangeMoreSelectionId(String examinationId, int moreSelectionId,
			String questionContent, String MoreSelectionValue, String optionA, String optionB, String optionC,
			String optionD, String answer, String note) {
		Map<String, Object> map = new HashMap<>();
		System.out.println(examinationId);
		MoreSelection moreSelection = examinationServiceImpl.selectMoreSelectionByMoreSelectionId(moreSelectionId);
		Examination examination = examinationServiceImpl
				.selectExaminationByExaminationId(Integer.parseInt(examinationId));

		if ((examination.getTemValue() - moreSelection.getValue() + Integer.parseInt(MoreSelectionValue)) <= examination
				.getTotalValue()) {
			examinationServiceImpl.updateExaminationTemValue(examination.getExaminationID(),
					(examination.getTemValue() - moreSelection.getValue() + Integer.parseInt(MoreSelectionValue)));

			moreSelection.setQuestionContent(questionContent);
			moreSelection.setOptionA(optionA);
			moreSelection.setOptionB(optionB);
			moreSelection.setOptionC(optionC);
			moreSelection.setOptionD(optionD);
			moreSelection.setAnswer(answer);
			moreSelection.setValue(Integer.parseInt(MoreSelectionValue));
			moreSelection.setNote(note);
			int tem = examinationServiceImpl.updatemoreByMoreSelectionId(moreSelection);
			if (tem > 0) {
				map.put("result", true);
			} else {
				map.put("result", false);
			}
		} else {
			map.put("result", "no");
		}
		return map;
	}

	// 更新判断题
	@RequestMapping(value = "/saveChangejudgeId.do")
	@ResponseBody
	public Map<String, Object> saveChangejudgeId(int judgeId, String examinationId, String questionContent,
			String JudgeValue, String answer, String note) {
		Map<String, Object> map = new HashMap<>();
		Judge judge = examinationServiceImpl.selectJudgeByJudgeId(judgeId);
		Examination examination = examinationServiceImpl
				.selectExaminationByExaminationId(Integer.parseInt(examinationId));

		if ((examination.getTemValue() - judge.getValue() + Integer.parseInt(JudgeValue)) <= examination
				.getTotalValue()) {
			examinationServiceImpl.updateExaminationTemValue(examination.getExaminationID(),
					(examination.getTemValue() - judge.getValue() + Integer.parseInt(JudgeValue)));

			judge.setJudgeContent(questionContent);
			judge.setAnswer(answer);
			judge.setValue(Integer.parseInt(JudgeValue));
			judge.setNote(note);
			int tem = examinationServiceImpl.updatejudgeByJudgeId(judge);
			if (tem > 0) {
				map.put("result", true);
			} else {
				map.put("result", false);
			}
		} else {
			map.put("result", "no");
		}
		return map;
	}

	// 更新填空题
	@RequestMapping(value = "/saveChangePack.do")
	@ResponseBody
	public Map<String, Object> saveChangePack(int packId, String examinationId, String questionContent,
			String PackValue, String answer, String note) {
		Map<String, Object> map = new HashMap<>();
		Pack pack = examinationServiceImpl.selectPackByPackId(packId);
		Examination examination = examinationServiceImpl
				.selectExaminationByExaminationId(Integer.parseInt(examinationId));

		if ((examination.getTemValue() - pack.getValue() + Integer.parseInt(PackValue)) <= examination
				.getTotalValue()) {
			examinationServiceImpl.updateExaminationTemValue(examination.getExaminationID(),
					(examination.getTemValue() - pack.getValue() + Integer.parseInt(PackValue)));

			pack.setPackContent(questionContent);
			pack.setAnswer(answer);
			pack.setValue(Integer.parseInt(PackValue));
			pack.setNote(note);
			int tem = examinationServiceImpl.updatePackByPackId(pack);
			if (tem > 0) {
				map.put("result", true);
			} else {
				map.put("result", false);
			}
		} else {
			map.put("result", "no");
		}
		return map;
	}

	// 更新简答题
	@RequestMapping(value = "/saveChangeShortAnswer.do")
	@ResponseBody
	public Map<String, Object> saveChangeShortAnswer(int shortAnswerId, String examinationId, String questionContent,
			String ShortAnswerValue, String note) {
		Map<String, Object> map = new HashMap<>();
		ShortAnswer shortAnswer = examinationServiceImpl.selectShortAnswerByShortAnswerId(shortAnswerId);
		Examination examination = examinationServiceImpl
				.selectExaminationByExaminationId(Integer.parseInt(examinationId));

		if ((examination.getTemValue() - shortAnswer.getValue() + Integer.parseInt(ShortAnswerValue)) <= examination
				.getTotalValue()) {
			examinationServiceImpl.updateExaminationTemValue(examination.getExaminationID(),
					(examination.getTemValue() - shortAnswer.getValue() + Integer.parseInt(ShortAnswerValue)));

			shortAnswer.setValue(Integer.parseInt(ShortAnswerValue));
			shortAnswer.setValue(Integer.parseInt(ShortAnswerValue));
			shortAnswer.setNote(note);
			int tem = examinationServiceImpl.updateShortAnswerByShortAnswerId(shortAnswer);
			if (tem > 0) {
				map.put("result", true);
			} else {
				map.put("result", false);
			}
		} else {
			map.put("result", "no");
		}
		return map;
	}

	// 删除单选题
	@RequestMapping(value = "/deleteSingleSelection.do")
	@SystemLog(module = "试卷", methods = "删除单选")
	@ResponseBody
	public Map<String, Object> deleteSingleSelection(String examinationId, int singleSelectionId) {
		Map<String, Object> map = new HashMap<>();
		SingleSelection singleSelection = examinationServiceImpl
				.selectSingleSelectionBysingleSelectionId(singleSelectionId);
		Examination ex = examinationServiceImpl.selectExaminationByExaminationId(Integer.parseInt(examinationId));
		int a1 = singleSelection.getQuestionNumber();
		examinationServiceImpl.updateExaminationTemValue(Integer.parseInt(examinationId),
				ex.getTemValue() - singleSelection.getValue());
		int tem = examinationServiceImpl.deleteSingleBySingleSelectionId(singleSelectionId);

		// 删除单选以后，后面的题目题号向前缩进，通过update
		int count = examinationServiceImpl.selectSingleSelectionCount(Integer.parseInt(examinationId));
		List<SingleSelection> singleSelections = examinationServiceImpl
				.selectSingleByExaminationID(Integer.parseInt(examinationId));
		if (singleSelections.size() > 0) {
			for (int i = 0; i < singleSelections.size(); i++) {
				if (singleSelections.get(i).getQuestionNumber() > a1) {
					int questionNum = singleSelections.get(i).getQuestionNumber() - 1;
					examinationServiceImpl.updateSingleSelectionById(singleSelections.get(i).getSingleSelectionId(),
							questionNum);
				}
			}
		}
		// 多选题号
		int x = count;
		List<MoreSelection> moreSelections = examinationServiceImpl
				.selectMoreByExaminationID(Integer.parseInt(examinationId));
		if (moreSelections.size() > 0) {
			for (int i = 0; i < moreSelections.size(); i++) {
				x++;
				examinationServiceImpl.updateMoreSelectionById(moreSelections.get(i).getMoreSelectionId(), x);
			}
		}

		// 判断题号
		int count2 = examinationServiceImpl.selectMoreSelectionCount(Integer.parseInt(examinationId));
		int y = count + count2;
		List<Judge> judges = examinationServiceImpl.selectJudgeByExaminationID(Integer.parseInt(examinationId));
		if (judges.size() > 0) {
			for (int i = 0; i < judges.size(); i++) {
				y++;
				examinationServiceImpl.updateJudgeById(judges.get(i).getJudgeId(), y);
			}
		}

		// 填空题号
		int count3 = examinationServiceImpl.selectJudgeCount(Integer.parseInt(examinationId));
		int z = count + count2 + count3;
		List<Pack> packs = examinationServiceImpl.selectPackByExaminationIDX(Integer.parseInt(examinationId));
		if (packs.size() > 0) {
			for (int i = 0; i < packs.size(); i++) {
				z++;
				examinationServiceImpl.updatePackById(packs.get(i).getPackId(), z);
			}
		}
		// 简答题号
		int count4 = examinationServiceImpl.selectPackCount(Integer.parseInt(examinationId));
		int s = count + count2 + count3 + count4;
		List<ShortAnswer> shortAnswers = examinationServiceImpl
				.selectShortAnswerByExaminationIDX(Integer.parseInt(examinationId));
		if (shortAnswers.size() > 0) {
			for (int i = 0; i < shortAnswers.size(); i++) {
				s++;
				examinationServiceImpl.updateShortAnswerById(shortAnswers.get(i).getShortAnswerId(), s);
			}
		}

		if (tem > 0) {
			map.put("result", true);
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 删除多选题
	@RequestMapping(value = "/deleteMoreSelection.do")
	@ResponseBody
	public Map<String, Object> deleteMoreSelection(String examinationId, int moreSelectionId) {
		Map<String, Object> map = new HashMap<>();
		Examination ex = examinationServiceImpl.selectExaminationByExaminationId(Integer.parseInt(examinationId));
		MoreSelection moreSelection = examinationServiceImpl.selectMoreSelectionByMoreSelectionId(moreSelectionId);
		examinationServiceImpl.updateExaminationTemValue(Integer.parseInt(examinationId),
				ex.getTemValue() - moreSelection.getValue());
		int a1 = moreSelection.getQuestionNumber();
		int tem = examinationServiceImpl.deleteMoreSelectionId(moreSelectionId);

		// 删除多选以后，后面的题目题号向前缩进，通过update
		// 多选题号
		List<MoreSelection> moreSelections = examinationServiceImpl
				.selectMoreByExaminationID(Integer.parseInt(examinationId));
		if (moreSelections.size() > 0) {
			for (int i = 0; i < moreSelections.size(); i++) {
				if (moreSelections.get(i).getQuestionNumber() > a1) {
					examinationServiceImpl.updateMoreSelectionById(moreSelections.get(i).getMoreSelectionId(),
							moreSelections.get(i).getQuestionNumber() - 1);
				}
			}
		}

		// 判断题号
		List<Judge> judges = examinationServiceImpl.selectJudgeByExaminationID(Integer.parseInt(examinationId));
		if (judges.size() > 0) {
			for (int i = 0; i < judges.size(); i++) {
				examinationServiceImpl.updateJudgeById(judges.get(i).getJudgeId(),
						judges.get(i).getQuestionNumber() - 1);
			}
		}

		// 填空题号
		List<Pack> packs = examinationServiceImpl.selectPackByExaminationIDX(Integer.parseInt(examinationId));
		if (packs.size() > 0) {
			for (int i = 0; i < packs.size(); i++) {
				examinationServiceImpl.updatePackById(packs.get(i).getPackId(), packs.get(i).getQuestionNumber() - 1);
			}
		}
		// 简答题号
		List<ShortAnswer> shortAnswers = examinationServiceImpl
				.selectShortAnswerByExaminationIDX(Integer.parseInt(examinationId));
		if (shortAnswers.size() > 0) {
			for (int i = 0; i < shortAnswers.size(); i++) {
				examinationServiceImpl.updateShortAnswerById(shortAnswers.get(i).getShortAnswerId(),
						shortAnswers.get(i).getQuestionNumber() - 1);
			}
		}

		if (tem > 0) {
			map.put("result", true);
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 删除判断题
	@RequestMapping(value = "/deletejudge.do")
	@ResponseBody
	public Map<String, Object> deletejudge(String examinationId, int judgeId) {
		Map<String, Object> map = new HashMap<>();
		Examination ex = examinationServiceImpl.selectExaminationByExaminationId(Integer.parseInt(examinationId));
		Judge judge = examinationServiceImpl.selectJudgeByJudgeId(judgeId);
		examinationServiceImpl.updateExaminationTemValue(Integer.parseInt(examinationId),
				ex.getTemValue() - judge.getValue());
		int a1 = judge.getQuestionNumber();
		int tem = examinationServiceImpl.deleteJudgeId(judgeId);

		// 删除多选以后，后面的题目题号向前缩进，通过update
		// 判断题号
		List<Judge> judges = examinationServiceImpl.selectJudgeByExaminationID(Integer.parseInt(examinationId));
		if (judges.size() > 0) {
			for (int i = 0; i < judges.size(); i++) {
				if (judges.get(i).getQuestionNumber() > a1) {
					examinationServiceImpl.updateJudgeById(judges.get(i).getJudgeId(),
							judges.get(i).getQuestionNumber() - 1);
				}
			}
		}

		// 填空题号
		List<Pack> packs = examinationServiceImpl.selectPackByExaminationIDX(Integer.parseInt(examinationId));
		if (packs.size() > 0) {
			for (int i = 0; i < packs.size(); i++) {
				examinationServiceImpl.updatePackById(packs.get(i).getPackId(), packs.get(i).getQuestionNumber() - 1);
			}
		}
		// 简答题号
		List<ShortAnswer> shortAnswers = examinationServiceImpl
				.selectShortAnswerByExaminationIDX(Integer.parseInt(examinationId));
		if (shortAnswers.size() > 0) {
			for (int i = 0; i < shortAnswers.size(); i++) {
				examinationServiceImpl.updateShortAnswerById(shortAnswers.get(i).getShortAnswerId(),
						shortAnswers.get(i).getQuestionNumber() - 1);
			}
		}

		if (tem > 0) {
			map.put("result", true);
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 删除填空题
	@RequestMapping(value = "/deletePack.do")
	@ResponseBody
	public Map<String, Object> deletePack(String examinationId, int packId) {
		Map<String, Object> map = new HashMap<>();
		Examination ex = examinationServiceImpl.selectExaminationByExaminationId(Integer.parseInt(examinationId));
		Pack pack = examinationServiceImpl.selectPackByPackId(packId);
		examinationServiceImpl.updateExaminationTemValue(Integer.parseInt(examinationId),
				ex.getTemValue() - pack.getValue());
		int a1 = pack.getQuestionNumber();
		int tem = examinationServiceImpl.deletePackId(packId);
		System.out.println(packId);
		// 删除多选以后，后面的题目题号向前缩进，通过update
		// 填空题号
		List<Pack> packs = examinationServiceImpl.selectPackByExaminationIDX(Integer.parseInt(examinationId));
		if (packs.size() > 0) {
			for (int i = 0; i < packs.size(); i++) {
				if (packs.get(i).getQuestionNumber() > a1) {
					examinationServiceImpl.updatePackById(packs.get(i).getPackId(),
							packs.get(i).getQuestionNumber() - 1);
				}
			}
		}
		// 简答题号
		List<ShortAnswer> shortAnswers = examinationServiceImpl
				.selectShortAnswerByExaminationIDX(Integer.parseInt(examinationId));
		if (shortAnswers.size() > 0) {
			for (int i = 0; i < shortAnswers.size(); i++) {
				examinationServiceImpl.updateShortAnswerById(shortAnswers.get(i).getShortAnswerId(),
						shortAnswers.get(i).getQuestionNumber() - 1);
			}
		}

		if (tem > 0) {
			map.put("result", true);
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 删除简答
	@RequestMapping(value = "/deleteShortAnswer.do")
	@ResponseBody
	public Map<String, Object> deleteShortAnswer(String examinationId, int shortAnswerId) {
		Map<String, Object> map = new HashMap<>();
		Examination ex = examinationServiceImpl.selectExaminationByExaminationId(Integer.parseInt(examinationId));
		ShortAnswer shortAnswer = examinationServiceImpl.selectShortAnswerByShortAnswerId(shortAnswerId);
		examinationServiceImpl.updateExaminationTemValue(Integer.parseInt(examinationId),
				ex.getTemValue() - shortAnswer.getValue());
		int a1 = shortAnswer.getQuestionNumber();
		int tem = examinationServiceImpl.deleteShortAnswerId(shortAnswerId);

		// 删除多选以后，后面的题目题号向前缩进，通过update
		// 简答题号
		List<ShortAnswer> shortAnswers = examinationServiceImpl
				.selectShortAnswerByExaminationIDX(Integer.parseInt(examinationId));
		if (shortAnswers.size() > 0) {
			for (int i = 0; i < shortAnswers.size(); i++) {
				if (shortAnswers.get(i).getQuestionNumber() > a1) {
					examinationServiceImpl.updateShortAnswerById(shortAnswers.get(i).getShortAnswerId(),
							shortAnswers.get(i).getQuestionNumber() - 1);
				}
			}
		}
		if (tem > 0) {
			map.put("result", true);
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 下面是学生考试相关业务

	// 验证考试码是否有效
	@RequestMapping(value = "/confirmExitsExam.do")
	@ResponseBody
	public Map<String, Object> confirmExitsExam(String onlyCode) {
		Map<String, Object> map = new HashMap<>();
		Examination examination = examinationServiceImpl.selectExaminationOnlyCode(onlyCode);
		if (examination != null) {
			map.put("result", true);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:SS");
			String ts1 = examination.getStartTime().substring(0, 10).replace("-", "");
			String ts2 = examination.getStartTime().substring(11).replace(":", "");
			String ts3 = ts1 + ts2;
			long t1 = Long.parseLong(ts3);

			String aString = sdf.format(new Date());
			String cs1 = aString.substring(0, 10).replace("-", "");
			String cs2 = aString.substring(11, 19).replace(":", "");
			String cs3 = cs1 + cs2;
			long t2 = Long.parseLong(cs3);
			long endTime = t1 + (examination.getDuration() / 60) * 10000 + (examination.getDuration() % 60) * 100;

			if (t2 < t1) {
				map.put("message", "wait");
			} else if (t2 > endTime) {
				map.put("message", "end");
			} else {
				// 更新试卷状态，不可编辑，转为考试中
				examinationServiceImpl.UpdateExamExaminationStatus(examination.getExaminationID(), "考试中");
				examinationServiceImpl.updateExaminationOfEdit(examination.getExaminationID(), 1);
				map.put("message", "can");
			}
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 跳转到考试信息验证页面
	@RequestMapping(value = "/studentToExam.do")
	public String studentToExam(ModelMap map, HttpServletRequest request) {
		String onlyCode = request.getParameter("onlyCode");
		Examination examination = examinationServiceImpl.selectExaminationOnlyCode(onlyCode);
		map.put("examination", examination);
		return "forExam";
	}

	// 验证学生信息
	@RequestMapping(value = "/confimStudentInfo.do")
	@ResponseBody
	public Map<String, Object> confimStudentInfo(String studentRoNo, String studentPassword, int examinationID) {
		Map<String, Object> map = new HashMap<>();
		Student student = studentServiceImpl.selectStudentByNo(studentRoNo);
		if (student != null) {
			if (student.getStudentPassword().equals(MD5Util.md5(studentPassword, "juin"))) {
				Examination examination = examinationServiceImpl.selectExaminationByExaminationId(examinationID);
				StudentInfo studentInfo = studentInfoServiceImpl.selectStudentInfoByMany(studentRoNo,
						examination.getCourseID());
				if (studentInfo != null) {
					map.put("result", true);
				} else {
					map.put("result", "notInCourse");
				}
			} else {
				map.put("result", "passwordError");
			}
		} else {
			map.put("result", "noStudent");
		}
		return map;
	}

	// 验证完学生信息跳转到拍片页面
	@RequestMapping(value = "/ToJoinExamNow.do", method = RequestMethod.POST)
	public String ToJoinExamNow(ModelMap map, HttpServletRequest request) {
		String studentRoNo = request.getParameter("studentRoNo");
		String studentPassword = request.getParameter("studentPassword");
		String examinationID = request.getParameter("examinationID");
		Examination examination = examinationServiceImpl
				.selectExaminationByExaminationId(Integer.parseInt(examinationID));
		Score score = examinationServiceImpl.selectScoreByExIdAndStuRoNo(Integer.parseInt(examinationID),
				studentRoNo);
		Student student = studentServiceImpl.selectStudentByNo(studentRoNo);
		if(score != null){
			map.put("student", student);
			map.put("examination", examination);
			return "waitForExam";
		}else {
			if (student != null) {
				if (student.getStudentPassword().equals(MD5Util.md5(studentPassword, "juin"))) {
					map.put("examination", examination);
					map.put("student", student);
					return "takePhoto";
				}
			}
			map.put("examination", examination);
		}
		
		return "forExam";
	}

	// 考前验证照片
	@RequestMapping(value = "/confirmPhoto.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> confirmPhoto(@RequestBody String data, HttpServletRequest request) throws IOException {
		Map<String, Object> map = new HashMap<>();
		String[] re = data.split("&");
		String studentRoNo = re[0].substring(12);
		String examinationID = re[1].substring(14);
		String imageData = re[2].substring(10).toString();
		if (imageData != null || !imageData.equals("")) {
			Score score1 = examinationServiceImpl.selectScoreByExIdAndStuRoNo(Integer.parseInt(examinationID),
					studentRoNo);
			Examination examination = examinationServiceImpl
					.selectExaminationByExaminationId(Integer.parseInt(examinationID));
			Student student = studentServiceImpl.selectStudentByNo(studentRoNo);
			String ext = "data:image/png;base64,";
			//imageData = ext+imageData;
			imageData = imageData.replaceAll("%2B", "+");
			imageData = imageData.replaceAll("%2F", "/");
			imageData = imageData.replaceAll("%3D", "=");
			//System.out.println(imageData);

			File targetFile = new File(request.getSession().getServletContext().getRealPath("/") + "Exam" + "/"
					+ studentRoNo + "_" + examinationID);
			System.out.println(targetFile.getAbsolutePath());
			if (!targetFile.exists()) {
				targetFile.mkdirs();
			}
			// FileWriter writer;
			
			String msg = "";
			boolean confirm = false;
			try {
				byte[] b = Base64.decodeBase64(imageData);
				for (int i = 0; i < b.length; ++i) {
					if (b[i] < 0) {// 调整异常数据
						b[i] += 256;
					}
				}
				// 生成jpeg图片
				String im1 = request.getSession().getServletContext().getRealPath("/") + "Exam" + "/"
						+ studentRoNo + "_" + examinationID + "/" + "beforeExamPhoto.png";
				
				OutputStream out = new FileOutputStream(im1);
				out.write(b);
				out.flush();
				out.close();

		       	//面部识别/剪切
				DetectFaceTest detectFaceTest = new DetectFaceTest();
				int returnTem = detectFaceTest.detectFace(im1, im1);
				//是一张脸不是两张，也不是没有脸时说明拍摄成功
				if(returnTem == 1){				
					ClazzStu clazzStu = clazzStuServiceImpl.selectClazzStuByCourse(studentRoNo, examination.getCourseID());
					    
						// 新建一个成绩单并初始化
						if (score1 == null) {
							Score score = new Score();
							score.setExaminationID(Integer.parseInt(examinationID));
							score.setStudentRoNo(studentRoNo);
							score.setStudentName(student.getStudentName());
							score.setStudentClass(clazzStu.getClazz().getClazzName());
							score.setSingleSelectionValue(0);
							score.setMoreSelectionValue(0);
							score.setJudgeValue(0);
							score.setPackValue(0);
							score.setShortAnswerValue(0);
							score.setTotalValue(0);
							score.setExamEnd(0);
							score.setScoreStatus("待批改");
							examinationServiceImpl.insertScore(score);
							map.put("result", "success");
							System.out.println("success1");
						} else if (score1 != null) {
							// 想记录答案的话可以注释掉下面
							if (score1.getExamEnd() == 0) {
								// 删除答案记录
								examinationServiceImpl.updateStudentAnswerBeforeLoad(studentRoNo, Integer.parseInt(examinationID));
								// 删除成绩记录
								examinationServiceImpl.updateScorebeforLoad(studentRoNo, Integer.parseInt(examinationID));
							}
							map.put("result", "success");
						}
					
				}else {
					 confirm = false;
					 map.put("result", "fail");
					 map.put("msg", "请重新拍摄,一个人且面部清晰明亮..");
					 return map;
				}
							
			} catch (Exception e) {
				System.out.println(e);
				System.out.println("输出照片异常!");
				 map.put("result", "fail");
				 map.put("msg", "系统繁忙请稍后再试..");
			}	
		}

		return map;
	}
	
	//考试过程中传回照片进行比较
	@RequestMapping(value = "/comparePhoto.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> comparePhoto(@RequestBody String data, HttpServletRequest request){
		Map<String, Object> map = new HashMap<>();
		boolean isstop = false;
		String[] re = data.split("&");
		String studentRoNo = re[0].substring(12);
		String examinationId = re[1].substring(14);
		String imageData = re[2].substring(10).toString();
		if (imageData != null || !imageData.equals("")) {
			Examination examination = examinationServiceImpl
					.selectExaminationByExaminationId(Integer.parseInt(examinationId));
			Score score = examinationServiceImpl.selectScoreByExIdAndStuRoNo(Integer.parseInt(examinationId),
					studentRoNo);
			imageData = imageData.replaceAll("%2B", "+");
			imageData = imageData.replaceAll("%2F", "/");
			imageData = imageData.replaceAll("%3D", "=");
			System.out.println(imageData);
			File targetFile = new File(request.getSession().getServletContext().getRealPath("/") + "Exam" + "/"
					+ studentRoNo + "_" + examinationId);
			System.out.println(targetFile.getAbsolutePath());
			if (!targetFile.exists()) {
				targetFile.mkdirs();
			}			
			try {
				byte[] b = Base64.decodeBase64(imageData);
				for (int i = 0; i < b.length; ++i) {
					if (b[i] < 0) {// 调整异常数据
						b[i] += 256;
					}
				}
				// 生成jpeg图片
				String im1 = request.getSession().getServletContext().getRealPath("/") + "Exam" + "/"
						+ studentRoNo + "_" + examinationId + "/" + "beforeExamPhoto2.png";
				
				OutputStream out = new FileOutputStream(im1);
				out.write(b);
				out.flush();
				out.close();
				
		       	//面部识别/剪切
				DetectFaceTest detectFaceTest = new DetectFaceTest();
				int returnTem = detectFaceTest.detectFace(im1, im1);
				//是一张脸不是两张，也不是没有脸时说明拍摄成功
				if(returnTem == 1){
					//人脸比对
					ComeparePhoto comeparePhoto = new ComeparePhoto();
					String imgFilePath = request.getSession().getServletContext().getRealPath("/") + "Exam" + "/"
					+ studentRoNo + "_" + examinationId + "/" + "beforeExamPhoto.png";  //之前的照片
				    FingerPrint fp1 = new FingerPrint(ImageIO.read(new File(im1)));
			        FingerPrint fp2 =new FingerPrint(ImageIO.read(new File(imgFilePath)));
			        System.out.println(fp1.toString(true));
			        float compare = fp1.compare(fp2);
			        String compareResult = compare+"";
			        System.out.println("处理前： " + compareResult);
			        System.out.println(Integer.parseInt(compareResult.substring(2, 4)));
			        if(Integer.parseInt(compareResult.substring(2, 4)) < 69 ){
			        	try {
							Object chertTem =  request.getSession().getAttribute(score.getScoreId()+"");
							System.out.println("session中的记录： " + chertTem);
							int tem = 0;
							if(chertTem != null){
								tem = (int) chertTem;
							}else {
								tem = 0;
							}
							request.getSession().setAttribute(score.getScoreId()+"", tem+1);
							if(tem < 9){//0-8,9次
								//这里的意思是最多观察9次，多于九次不再记录，直接记录作弊嫌疑
								System.out.println("此处应该存点其他东西..");
								String time = new SimpleDateFormat("yyyy-MM-dd HH:mm:SS").format(new Date());
								time = time.replaceAll("-", "").replaceAll(":", "");
								System.err.println(request.getSession().getServletContext().getRealPath("/"));
								String chertPath = request.getSession().getServletContext().getRealPath("/") + "Exam" + "/chert/"
										+ examinationId + "/" + score.getScoreId()+"_"+time+".png";
								System.err.println(chertPath);
								CopyFile.copyFile(im1, chertPath);
								
								comeparePhoto.setChertAddress("http://localhost:8080/ClassManageSys"+"/Exam" + "/chert/"
										+ examinationId + "/" + score.getScoreId()+"_"+time+".png");
								isstop = false;
							}else if(tem == 9){
								examinationServiceImpl.updateScoreChert(score.getScoreId(), "作弊嫌疑");
								isstop = true;
							}else {
								isstop = true;
							}
							
						} catch (Exception e) {
							System.err.println("更改作弊状态出了问题");
						}
						
					}else if(Integer.parseInt(compareResult.substring(2, 4)) >= 69 || Integer.parseInt(compareResult.substring(2, 4))  < 80){
			        	compare = (float) (compare+0.2);
			        }else if (Integer.parseInt(compareResult.substring(2, 4))  >= 80 || Integer.parseInt(compareResult.substring(2, 4))  < 90) {
			        	compare = (float) (compare+0.1);
					}
			        
			        while(compare > 1){
		        		compare = (float) (compare - 0.08);
		        	}
			        System.err.println(compare+"");
			        
			        comeparePhoto.setCppResult(compare+"");
			        comeparePhoto.setCppTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:SS").format(new Date()));
			        comeparePhoto.setScoreId(score.getScoreId());
			        
					int insertComepareResult = examinationServiceImpl.insertComeparePhoto(comeparePhoto);
					if(insertComepareResult > 0){
						map.put("result", "success");
					}
				}else {
					try {
						Object chertTem =  request.getSession().getAttribute(score.getScoreId()+"");
						int tem = 0;
						if(chertTem != null){
							tem = (int) chertTem;
						}
						System.out.println("session中的记录： " + chertTem);
						request.getSession().setAttribute(score.getScoreId()+"", tem+1);
						if(tem == 9){
							examinationServiceImpl.updateScoreChert(score.getScoreId(), "作弊嫌疑");
							isstop = true;
						}else if (tem > 9) {
							isstop = true;
						}
					} catch (Exception e) {
						System.err.println("更改作弊状态出了问题");
					}
					 map.put("isstop", isstop);
					 System.err.println(isstop);
					 map.put("result", "fail");
					 map.put("msg", "请保持面部清晰，积累至一定次数系统将备注作弊!");
					 
					 return map;
				}
							
			} catch (Exception e) {
				System.out.println(e);
				System.out.println("输出照片异常!");
			    map.put("result", "fail");
			    map.put("msg", "考试人脸识别出现问题，请联系管理人员..");
			}	
		}
		map.put("isstop", isstop);
		System.err.println(isstop);
		return map;
	}
	

	// 跳转到考试须知
	@RequestMapping(value = "/lastExamConfirm.do", method = RequestMethod.POST)
	public String lastExamConfirm(ModelMap map, String studentRoNo, String examinationID, HttpServletRequest request) {

		Examination examination = examinationServiceImpl
				.selectExaminationByExaminationId(Integer.parseInt(examinationID));
		Student student = studentServiceImpl.selectStudentByNo(studentRoNo);
		map.put("student", student);
		map.put("examination", examination);
		return "waitForExam";
	}

	// 考前最后一次验证
	@RequestMapping(value = "/beforExamFormSubmit.do")
	@ResponseBody
	public Map<String, Object> beforExamFormSubmit(String studentRoNo, String examinationID, HttpServletRequest request)
			throws IOException {
		Map<String, Object> map = new HashMap<>();
		Examination examination = examinationServiceImpl
				.selectExaminationByExaminationId(Integer.parseInt(examinationID));
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:SS");
		String bs1 = examination.getStartTime().substring(0, 10).replace("-", "");
		String bs2 = examination.getStartTime().substring(11).replace(":", "");
		String bs3 = bs1 + bs2;
		long t11 = Long.parseLong(bs3);
		String aString = sdf.format(new Date());
		String cs1 = aString.substring(0, 10).replace("-", "");
		String cs2 = aString.substring(11, 19).replace(":", "");
		String cs3 = cs1 + cs2;
		long t22 = Long.parseLong(cs3);
		long endTime = t11 + (examination.getDuration() / 60) * 10000 + (examination.getDuration() % 60) * 100;
		if (t22 < endTime) {
			System.out.println(true);
			map.put("result", true);
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 转到考试页面
	@RequestMapping(value = "/reallyToJoinExam.do", method = RequestMethod.POST)
	public String reallyToJoinExam(ModelMap map, HttpServletRequest re) {
		String examinationID = re.getParameter("examinationID");
		String studentRoNo = re.getParameter("studentRoNo");

		// 考试前对于时间的最后一次
		Examination examination = examinationServiceImpl
				.selectExaminationByExaminationId(Integer.parseInt(examinationID));

		Student student = studentServiceImpl.selectStudentByNo(studentRoNo);
		String ts1 = examination.getStartTime().substring(0, 10).replace("-", "");
		String ts2 = examination.getStartTime().substring(11).replace(":", "");
		String ts3 = ts1 + ts2;
		long t1 = Long.parseLong(ts3);
        //根据考试时常平均分成三个时间段，在三个时间段中随机抽取一个时间
		int examTimeLength = examination.getDuration();
		int average = examTimeLength/3;
		
		System.out.println("平均数: " + average);
		//int randomTime1 = new Random().nextInt(average) + 
		long t2 = t1;
		int tem = examination.getDuration();
		for (int i = 0; i < 10000; i++) {
			if (tem / 60 > 0) {
				t2 += 10000;
				tem = tem - 60;
			} else {
				if (tem + Integer.parseInt(ts3.substring(10, 12)) > 60) {
					t2 += 10000;
					t2 += tem * 100 - 60 * 100;
					tem = 0;
				} else {
					t2 += tem * 100;
					break;
				}
			}
		}

		String year = (t2 + "").substring(0, 4);
		String month = (t2 + "").substring(4, 6);
		String day = (t2 + "").substring(6, 8);
		String hour = (t2 + "").substring(8, 10);
		String minute = (t2 + "").substring(10, 12);
		String seconds = (t2 + "").substring(12, 14);
		List<SingleSelection> singleSelections = examinationServiceImpl
				.selectSingleByExaminationID(Integer.parseInt(examinationID));
		List<MoreSelection> moreSelections = examinationServiceImpl
				.selectMoreByExaminationID(Integer.parseInt(examinationID));
		List<Judge> judges = examinationServiceImpl.selectJudgeByExaminationID(Integer.parseInt(examinationID));
		List<Pack> packs = examinationServiceImpl.selectPackByExaminationIDX(Integer.parseInt(examinationID));
		List<ShortAnswer> shortAnswers = examinationServiceImpl
				.selectShortAnswerByExaminationIDX(Integer.parseInt(examinationID));
		// Student student2 = studentServiceImpl.selectStudentByNo(studentRoNo);
		// ClazzStu clazzStu =
		// clazzStuServiceImpl.selectClazzStuByCourse(studentRoNo,
		// examination.getCourseID());
		// // 新建一个成绩单并初始化
		// if (score1 == null) {
		// Score score = new Score();
		// score.setExaminationID(Integer.parseInt(examinationID));
		// score.setStudentRoNo(studentRoNo);
		// score.setStudentName(student2.getStudentName());
		// score.setStudentClass(clazzStu.getClazz().getClazzName());
		// score.setSingleSelectionValue(0);
		// score.setMoreSelectionValue(0);
		// score.setJudgeValue(0);
		// score.setPackValue(0);
		// score.setShortAnswerValue(0);
		// score.setTotalValue(0);
		// score.setExamEnd(0);
		// score.setScoreStatus("待批改");
		// examinationServiceImpl.insertScore(score);
		// } else if(score1 != null){
		// //想记录答案的话可以注释掉下面
		// if(score1.getExamEnd() == 0){
		// //删除答案记录
		// examinationServiceImpl.updateStudentAnswerBeforeLoad(studentRoNo,
		// Integer.parseInt(examinationID));
		// //删除成绩记录
		// examinationServiceImpl.updateScorebeforLoad(studentRoNo,
		// Integer.parseInt(examinationID));
		// }
		// }
		map.put("year", year);
		map.put("month", month);
		map.put("day", day);
		map.put("hour", hour);
		map.put("minute", minute);
		map.put("seconds", seconds);
		map.put("examination", examination);
		map.put("student", student);
		if (singleSelections.size() > 0) {
			for (int i = 0; i < singleSelections.size(); i++) {
				StudentAnswer studentAnswer2 = examinationServiceImpl.selectStudentAnswerByExIdAndStuRoNo(
						Integer.parseInt(examinationID), studentRoNo, singleSelections.get(i).getQuestionNumber());
				if (studentAnswer2 == null) {
					StudentAnswer studentAnswer = new StudentAnswer();
					studentAnswer.setExaminationID(Integer.parseInt(examinationID));
					studentAnswer.setStudentRoNo(studentRoNo);
					studentAnswer.setQuestionNumber(singleSelections.get(i).getQuestionNumber());
					studentAnswer.setQuestionsType(singleSelections.get(i).getQuestionsType());
					studentAnswer.setStuAnswer("");
					studentAnswer.setGetValue(0);
					examinationServiceImpl.insertStudentAnswer(studentAnswer);
				}
			}
			map.put("singleSelections", singleSelections);
		} else {
			map.put("singleSelections", null);
		}
		if (moreSelections.size() > 0) {
			for (int i = 0; i < moreSelections.size(); i++) {
				StudentAnswer studentAnswer2 = examinationServiceImpl.selectStudentAnswerByExIdAndStuRoNo(
						Integer.parseInt(examinationID), studentRoNo, moreSelections.get(i).getQuestionNumber());
				if (studentAnswer2 == null) {
					StudentAnswer studentAnswer = new StudentAnswer();
					studentAnswer.setExaminationID(Integer.parseInt(examinationID));
					studentAnswer.setStudentRoNo(studentRoNo);
					studentAnswer.setQuestionNumber(moreSelections.get(i).getQuestionNumber());
					studentAnswer.setQuestionsType(moreSelections.get(i).getQuestionsType());
					studentAnswer.setStuAnswer("");
					studentAnswer.setGetValue(0);
					examinationServiceImpl.insertStudentAnswer(studentAnswer);
				}
			}
			map.put("moreSelections", moreSelections);
		} else {
			map.put("moreSelections", null);
		}
		if (judges.size() > 0) {
			for (int i = 0; i < judges.size(); i++) {
				StudentAnswer studentAnswer2 = examinationServiceImpl.selectStudentAnswerByExIdAndStuRoNo(
						Integer.parseInt(examinationID), studentRoNo, judges.get(i).getQuestionNumber());
				if (studentAnswer2 == null) {
					StudentAnswer studentAnswer = new StudentAnswer();
					studentAnswer.setExaminationID(Integer.parseInt(examinationID));
					studentAnswer.setStudentRoNo(studentRoNo);
					studentAnswer.setQuestionNumber(judges.get(i).getQuestionNumber());
					studentAnswer.setQuestionsType(judges.get(i).getQuestionsType());
					studentAnswer.setStuAnswer("");
					studentAnswer.setGetValue(0);
					examinationServiceImpl.insertStudentAnswer(studentAnswer);
				}
			}
			map.put("judges", judges);
		} else {
			map.put("judges", null);
		}
		if (packs.size() > 0) {
			for (int i = 0; i < packs.size(); i++) {
				StudentAnswer studentAnswer2 = examinationServiceImpl.selectStudentAnswerByExIdAndStuRoNo(
						Integer.parseInt(examinationID), studentRoNo, packs.get(i).getQuestionNumber());
				if (studentAnswer2 == null) {
					StudentAnswer studentAnswer = new StudentAnswer();
					studentAnswer.setExaminationID(Integer.parseInt(examinationID));
					studentAnswer.setStudentRoNo(studentRoNo);
					studentAnswer.setQuestionNumber(packs.get(i).getQuestionNumber());
					studentAnswer.setQuestionsType(packs.get(i).getQuestionsType());
					studentAnswer.setStuAnswer("");
					studentAnswer.setGetValue(0);
					examinationServiceImpl.insertStudentAnswer(studentAnswer);
				}
			}
			map.put("packs", packs);
		} else {
			map.put("packs", null);
		}
		if (shortAnswers.size() > 0) {
			for (int i = 0; i < shortAnswers.size(); i++) {
				StudentAnswer studentAnswer2 = examinationServiceImpl.selectStudentAnswerByExIdAndStuRoNo(
						Integer.parseInt(examinationID), studentRoNo, shortAnswers.get(i).getQuestionNumber());
				if (studentAnswer2 == null) {
					StudentAnswer studentAnswer = new StudentAnswer();
					studentAnswer.setExaminationID(Integer.parseInt(examinationID));
					studentAnswer.setStudentRoNo(studentRoNo);
					studentAnswer.setQuestionNumber(shortAnswers.get(i).getQuestionNumber());
					studentAnswer.setQuestionsType(shortAnswers.get(i).getQuestionsType());
					studentAnswer.setStuAnswer("");
					studentAnswer.setGetValue(0);
					examinationServiceImpl.insertStudentAnswer(studentAnswer);
				}
			}
			map.put("shortAnswers", shortAnswers);
		} else {
			map.put("shortAnswers", null);
		}

		return "examPage";
	}

	// 更新单选题学生答案及成绩表
	@RequestMapping(value = "/updateSingleSelection.do")
	@ResponseBody
	public Map<String, Object> updateSingleSelection(String studentRoNo, String examinationID, int questionNumber,
			String stuAnswer) {
		Map<String, Object> map = new HashMap<>();
		SingleSelection singleSelection = examinationServiceImpl
				.selectSingleSelectionByExAndQusNum(Integer.parseInt(examinationID), questionNumber);
		Score score = examinationServiceImpl.selectScoreByExIdAndStuRoNo(Integer.parseInt(examinationID), studentRoNo);
		if (score.getExamEnd() == 0) {
			StudentAnswer studentAnswer = examinationServiceImpl
					.selectStudentAnswerByExIdAndStuRoNo(Integer.parseInt(examinationID), studentRoNo, questionNumber);

			// 学生回答过这个单选题目
			if (studentAnswer != null && !studentAnswer.getStuAnswer().equals("")) {
				// 学生上次答错了
				if (!studentAnswer.getStuAnswer().equals(singleSelection.getAnswer())) {
					// 这回答对了
					if (stuAnswer.equals(singleSelection.getAnswer())) {
						examinationServiceImpl.updateScore(studentRoNo, Integer.parseInt(examinationID),
								score.getSingleSelectionValue() + singleSelection.getValue(),
								score.getMoreSelectionValue(), score.getJudgeValue(), score.getPackValue(),
								score.getShortAnswerValue(), score.getTotalValue() + singleSelection.getValue());
					}
				} else {
					// 上次答对了，这回答错了
					if (!stuAnswer.equals(singleSelection.getAnswer())) {
						examinationServiceImpl.updateScore(studentRoNo, Integer.parseInt(examinationID),
								score.getSingleSelectionValue() - singleSelection.getValue(),
								score.getMoreSelectionValue(), score.getJudgeValue(), score.getPackValue(),
								score.getShortAnswerValue(), score.getTotalValue() - singleSelection.getValue());
					}
				}
			} else {
				// 学生没回答过这个题目,答对了
				if (stuAnswer.equals(singleSelection.getAnswer())) {
					examinationServiceImpl.updateScore(studentRoNo, Integer.parseInt(examinationID),
							score.getSingleSelectionValue() + singleSelection.getValue(), score.getMoreSelectionValue(),
							score.getJudgeValue(), score.getPackValue(), score.getShortAnswerValue(),
							score.getTotalValue() + singleSelection.getValue());
				}
			}

			int tem = 0;
			if (stuAnswer.equals(singleSelection.getAnswer())) {
				tem = examinationServiceImpl.updateStudentAnswer(studentRoNo, Integer.parseInt(examinationID),
						questionNumber, stuAnswer, singleSelection.getValue());
			} else {
				tem = examinationServiceImpl.updateStudentAnswer(studentRoNo, Integer.parseInt(examinationID),
						questionNumber, stuAnswer, 0);
			}

			if (tem > 0) {
				map.put("result", true);
			} else {
				map.put("result", false);
			}
		} else {
			map.put("result", "end");
		}
		return map;
	}

	// 更新多选,选中事件
	@RequestMapping(value = "/updateMoreSelection.do")
	@ResponseBody
	public Map<String, Object> updateMoreSelection(String studentRoNo, String examinationID, int questionNumber,
			String stuAnswer) {
		Map<String, Object> map = new HashMap<>();
		MoreSelection moreSelection = examinationServiceImpl
				.selectMoreSelectionByExAndQusNum(Integer.parseInt(examinationID), questionNumber);
		Score score = examinationServiceImpl.selectScoreByExIdAndStuRoNo(Integer.parseInt(examinationID), studentRoNo);
		if (score.getExamEnd() == 0) {
			StudentAnswer studentAnswer = examinationServiceImpl
					.selectStudentAnswerByExIdAndStuRoNo(Integer.parseInt(examinationID), studentRoNo, questionNumber);

			String oldAnswer = moreSelection.getAnswer().replace(" ", "");
			String lastAnswer = studentAnswer.getStuAnswer();
			String temAnswer = studentAnswer.getStuAnswer() + stuAnswer;
			// 在存在的记录中
			int sum = 0;
			for (int i = 0; i < oldAnswer.length(); i++) {
				for (int j = 0; j < lastAnswer.length(); j++) {
					if (oldAnswer.charAt(i) == lastAnswer.charAt(j)) {
						sum++;
						continue;
					}
				}
			}
			// 上一次答对了（ABCD不分顺序）
			if (sum == oldAnswer.length() && sum == lastAnswer.length()) {
				// 这回肯定答错了，画蛇添足(首先保证以前答过)
				if (studentAnswer.getStuAnswer().length() > 0) {
					examinationServiceImpl.updateScore(studentRoNo, Integer.parseInt(examinationID),
							score.getSingleSelectionValue(), score.getMoreSelectionValue() - moreSelection.getValue(),
							score.getJudgeValue(), score.getPackValue(), score.getShortAnswerValue(),
							score.getTotalValue() - moreSelection.getValue());
				}
			} else {
				// 以前答错了，这回答对了
				int bb = 0;
				for (int i = 0; i < oldAnswer.length(); i++) {
					for (int j = 0; j < temAnswer.length(); j++) {
						if (oldAnswer.charAt(i) == temAnswer.charAt(j)) {
							bb++;
							continue;
						}
					}
				}
				if (bb == oldAnswer.length() && bb == temAnswer.length()) {
					examinationServiceImpl.updateScore(studentRoNo, Integer.parseInt(examinationID),
							score.getSingleSelectionValue(), score.getMoreSelectionValue() + moreSelection.getValue(),
							score.getJudgeValue(), score.getPackValue(), score.getShortAnswerValue(),
							score.getTotalValue() + moreSelection.getValue());
				}

			}

			int tem = 0;
			int bb = 0;
			for (int i = 0; i < oldAnswer.length(); i++) {
				for (int j = 0; j < temAnswer.length(); j++) {
					if (oldAnswer.charAt(i) == temAnswer.charAt(j)) {
						bb++;
						continue;
					}
				}
			}
			if (bb == oldAnswer.length() && bb == temAnswer.length()) {
				tem = examinationServiceImpl.updateStudentAnswer(studentRoNo, Integer.parseInt(examinationID),
						questionNumber, temAnswer, moreSelection.getValue());
			} else {
				tem = examinationServiceImpl.updateStudentAnswer(studentRoNo, Integer.parseInt(examinationID),
						questionNumber, temAnswer, 0);
			}

			if (tem > 0) {
				map.put("result", true);
			} else {
				map.put("result", false);
			}
		} else {
			map.put("result", "end");
		}

		return map;
	}

	// 取消选择某多选
	@RequestMapping(value = "/updateMoreSelectionCanel.do")
	@ResponseBody
	public Map<String, Object> updateMoreSelectionCanel(String studentRoNo, String examinationID, int questionNumber,
			String stuAnswer) {
		Map<String, Object> map = new HashMap<>();
		MoreSelection moreSelection = examinationServiceImpl
				.selectMoreSelectionByExAndQusNum(Integer.parseInt(examinationID), questionNumber);
		Score score = examinationServiceImpl.selectScoreByExIdAndStuRoNo(Integer.parseInt(examinationID), studentRoNo);
		if (score.getExamEnd() == 0) {
			StudentAnswer studentAnswer = examinationServiceImpl
					.selectStudentAnswerByExIdAndStuRoNo(Integer.parseInt(examinationID), studentRoNo, questionNumber);

			String oldAnswer = moreSelection.getAnswer().replace(" ", "");

			String newAnswer = studentAnswer.getStuAnswer();
			int sum = 0;
			for (int i = 0; i < oldAnswer.length(); i++) {
				for (int j = 0; j < newAnswer.length(); j++) {
					if (oldAnswer.charAt(i) == newAnswer.charAt(j)) {
						sum++;
						continue;
					}
				}
			}
			// 此次答题现在新的答案
			String temAnswer = "";
			// 更新该题学生答案
			for (int i = 0; i < studentAnswer.getStuAnswer().length(); i++) {
				if (studentAnswer.getStuAnswer().charAt(i) != stuAnswer.charAt(0)) {
					temAnswer += studentAnswer.getStuAnswer().charAt(i);
				}
			}
			if (sum == oldAnswer.length() && sum == newAnswer.length()) {
				// 前面的答案是对的，这回取消了某一项，答案变为错了
				int bb = 0;
				for (int i = 0; i < oldAnswer.length(); i++) {
					for (int j = 0; j < temAnswer.length(); j++) {
						if (oldAnswer.charAt(i) == temAnswer.charAt(j)) {
							bb++;
							continue;
						}
					}
				}
				if (bb != oldAnswer.length()) {
					examinationServiceImpl.updateScore(studentRoNo, Integer.parseInt(examinationID),
							score.getSingleSelectionValue(), score.getMoreSelectionValue() - moreSelection.getValue(),
							score.getJudgeValue(), score.getPackValue(), score.getShortAnswerValue(),
							score.getTotalValue() - moreSelection.getValue());
				}
			} else {
				// 前面的答案错了，这回对了
				int bb = 0;
				for (int i = 0; i < oldAnswer.length(); i++) {
					for (int j = 0; j < temAnswer.length(); j++) {
						if (oldAnswer.charAt(i) == temAnswer.charAt(j)) {
							bb++;
							continue;
						}
					}
				}
				if (bb == oldAnswer.length() && bb == temAnswer.length()) {
					examinationServiceImpl.updateScore(studentRoNo, Integer.parseInt(examinationID),
							score.getSingleSelectionValue(), score.getMoreSelectionValue() + moreSelection.getValue(),
							score.getJudgeValue(), score.getPackValue(), score.getShortAnswerValue(),
							score.getTotalValue() + moreSelection.getValue());
				}
			}

			int tem = 0;
			int bb = 0;
			for (int i = 0; i < oldAnswer.length(); i++) {
				for (int j = 0; j < temAnswer.length(); j++) {
					if (oldAnswer.charAt(i) == temAnswer.charAt(j)) {
						bb++;
						continue;
					}
				}
			}
			if (bb == oldAnswer.length() && bb == temAnswer.length()) {
				tem = examinationServiceImpl.updateStudentAnswer(studentRoNo, Integer.parseInt(examinationID),
						questionNumber, temAnswer, moreSelection.getValue());
			} else {
				tem = examinationServiceImpl.updateStudentAnswer(studentRoNo, Integer.parseInt(examinationID),
						questionNumber, temAnswer, 0);
			}

			if (tem > 0) {
				map.put("result", true);
			} else {
				map.put("result", false);
			}
		} else {
			map.put("result", "end");
		}
		return map;
	}

	// 学生答判断题
	@RequestMapping(value = "/updateJudge.do")
	@ResponseBody
	public Map<String, Object> updateJudge(String studentRoNo, String examinationID, int questionNumber,
			String stuAnswer) {
		Map<String, Object> map = new HashMap<>();
		Judge judge = examinationServiceImpl.selectJudgeByExAndQusNum(Integer.parseInt(examinationID), questionNumber);
		Score score = examinationServiceImpl.selectScoreByExIdAndStuRoNo(Integer.parseInt(examinationID), studentRoNo);
		if (score.getExamEnd() == 0) {
			StudentAnswer studentAnswer = examinationServiceImpl
					.selectStudentAnswerByExIdAndStuRoNo(Integer.parseInt(examinationID), studentRoNo, questionNumber);

			// 学生回答过这个判断题目
			if (studentAnswer != null && !studentAnswer.getStuAnswer().equals("")) {
				// 学生上次答错了
				if (!studentAnswer.getStuAnswer().equals(judge.getAnswer())) {
					// 这回答对了
					if (stuAnswer.equals(judge.getAnswer())) {
						examinationServiceImpl.updateScore(studentRoNo, Integer.parseInt(examinationID),
								score.getSingleSelectionValue(), score.getMoreSelectionValue(),
								score.getJudgeValue() + judge.getValue(), score.getPackValue(),
								score.getShortAnswerValue(), score.getTotalValue() + judge.getValue());
					}
				} else {
					// 上次答对了，这回答错了
					if (!stuAnswer.equals(judge.getAnswer())) {
						examinationServiceImpl.updateScore(studentRoNo, Integer.parseInt(examinationID),
								score.getSingleSelectionValue(), score.getMoreSelectionValue(),
								score.getJudgeValue() - judge.getValue(), score.getPackValue(),
								score.getShortAnswerValue(), score.getTotalValue() - judge.getValue());
					}
				}
			} else {
				// 学生没回答过这个题目,答对了
				if (stuAnswer.equals(judge.getAnswer())) {
					examinationServiceImpl.updateScore(studentRoNo, Integer.parseInt(examinationID),
							score.getSingleSelectionValue(), score.getMoreSelectionValue(),
							score.getJudgeValue() + judge.getValue(), score.getPackValue(), score.getShortAnswerValue(),
							score.getTotalValue() + judge.getValue());
				}
			}

			int tem = 0;
			if (stuAnswer.equals(judge.getAnswer())) {
				tem = examinationServiceImpl.updateStudentAnswer(studentRoNo, Integer.parseInt(examinationID),
						questionNumber, stuAnswer, judge.getValue());
			} else {
				tem = examinationServiceImpl.updateStudentAnswer(studentRoNo, Integer.parseInt(examinationID),
						questionNumber, stuAnswer, 0);
			}
			if (tem > 0) {
				map.put("result", true);
			} else {
				map.put("result", false);
			}
		} else {
			map.put("result", "end");
		}
		return map;
	}

	// 学生填空题答案
	@RequestMapping(value = "/updatePack.do")
	@ResponseBody
	public Map<String, Object> updatePack(String studentRoNo, String examinationID, int questionNumber,
			String stuAnswer) {
		Map<String, Object> map = new HashMap<>();
		Score score = examinationServiceImpl.selectScoreByExIdAndStuRoNo(Integer.parseInt(examinationID), studentRoNo);
		if (score.getExamEnd() == 0) {
			int tem = examinationServiceImpl.updateStudentAnswer(studentRoNo, Integer.parseInt(examinationID),
					questionNumber, stuAnswer, 0);
			if (tem > 0) {
				map.put("result", true);
			} else {
				map.put("result", false);
			}
		} else {
			map.put("result", "end");
		}
		return map;
	}

	// 学生简答题答案
	@RequestMapping(value = "/updateShortAnswer.do")
	@ResponseBody
	public Map<String, Object> updateShortAnswer(String studentRoNo, String examinationID, int questionNumber,
			String stuAnswer) {
		Map<String, Object> map = new HashMap<>();
		Score score = examinationServiceImpl.selectScoreByExIdAndStuRoNo(Integer.parseInt(examinationID), studentRoNo);
		if (score.getExamEnd() == 0) {
			int tem = examinationServiceImpl.updateStudentAnswer(studentRoNo, Integer.parseInt(examinationID),
					questionNumber, stuAnswer, 0);
			if (tem > 0) {
				map.put("result", true);
			} else {
				map.put("result", false);
			}
		} else {
			map.put("result", "end");
		}
		return map;
	}

	// 考完更新成绩单状态，不可再进行修改，但是可以看题
	@RequestMapping(value = "/updateExamEnd.do")
	@ResponseBody
	public Map<String, Object> updateExamEnd(String studentRoNo, String examinationID) {
		Map<String, Object> map = new HashMap<>();
		examinationServiceImpl.UpdateExamExaminationStatus(Integer.parseInt(examinationID), "已考");
		int tem = examinationServiceImpl.updateExamEnd(studentRoNo, Integer.parseInt(examinationID));
		if (tem > 0) {
			map.put("result", true);
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 根据已考完的试卷列表教师进行批卷
	@RequestMapping(value = "/selectExaminationByCourseIdAndAnother.do")
	@ResponseBody
	public Map<String, Object> selectExaminationByCourseIdAndAnother(int courseId) {
		Map<String, Object> map = new HashMap<>();
		List<Examination> examinations = examinationServiceImpl.selectMaxExaminationIdByCourseIdAndStatus(courseId,
				"已考");
		map.put("examinations", examinations);
		return map;
	}

	// 得到学生考完的试卷的列表
	@RequestMapping(value = "/getStudentExamList.do")
	@ResponseBody
	public Map<String, Object> getStudentExamList(String examinationID) {
		Map<String, Object> map = new HashMap<>();
		Examination examination = examinationServiceImpl
				.selectExaminationByExaminationId(Integer.parseInt(examinationID));
		int count = studentInfoServiceImpl.selectCountOfStudentByStudentInfo(examination.getCourseID());
		int count2 = examinationServiceImpl.selectCountScoreById(Integer.parseInt(examinationID));
		double avg = examinationServiceImpl.selectAvgScoreById(Integer.parseInt(examinationID));
		double max = examinationServiceImpl.selectMaxScoreById(Integer.parseInt(examinationID));
		double min = examinationServiceImpl.selectMinScoreById(Integer.parseInt(examinationID));
		List<Score> scores = examinationServiceImpl.selectScoreByExId(Integer.parseInt(examinationID));
		map.put("scores", scores);
		map.put("count", count);
		map.put("count2", count2);
		map.put("avg", avg);
		map.put("max", max);
		map.put("min", min);
		return map;
	}

	// 批改填空题
	@RequestMapping(value = "/getStudentPackList.do")
	@ResponseBody
	public Map<String, Object> getStudentPackList(int scoreId) {
		Map<String, Object> map = new HashMap<>();
		System.out.println(scoreId);
		Score score = examinationServiceImpl.selectScoreById(scoreId);
		if (score.getExamEnd() == 1) {
			Examination examination = examinationServiceImpl.selectExaminationByExaminationId(score.getExaminationID());
			Student student = studentServiceImpl.selectStudentByNo(score.getStudentRoNo());
			List<Pack> packs = examinationServiceImpl.selectPackByExaminationIDX(score.getExaminationID());
			for (Pack pack : packs) {
				StudentAnswer studentAnswer = examinationServiceImpl.selectStudentAnswerByExIdAndStuRoNo(
						score.getExaminationID(), score.getStudentRoNo(), pack.getQuestionNumber());
				examinationServiceImpl.updatePackStudentAnswer(score.getExaminationID(), pack.getQuestionNumber(),
						studentAnswer.getStuAnswer());
			}
			List<ShortAnswer> shortAnswers = examinationServiceImpl
					.selectShortAnswerByExaminationIDX(score.getExaminationID());
			for (ShortAnswer shortAnswer : shortAnswers) {
				StudentAnswer studentAnswer = examinationServiceImpl.selectStudentAnswerByExIdAndStuRoNo(
						score.getExaminationID(), score.getStudentRoNo(), shortAnswer.getQuestionNumber());
				examinationServiceImpl.updateShortAnswerStudentAnswer(score.getExaminationID(),
						shortAnswer.getQuestionNumber(), studentAnswer.getStuAnswer());
			}
			map.put("result", true);
			map.put("shortAnswers", shortAnswers);
			map.put("examination", examination);
			map.put("packs", packs);
			map.put("student", student);
			map.put("score", score);
		} else {
			map.put("result", false);
		}

		return map;
	}

	// 老师填空题打分
	@RequestMapping(value = "/setPackStuAnswer.do")
	@ResponseBody
	public Map<String, Object> setPackStuAnswer(String studentRoNo, int packId, int value) {
		Map<String, Object> map = new HashMap<>();
		Pack pack = examinationServiceImpl.selectPackByPackId(packId);
		Score score = examinationServiceImpl.selectScoreByExIdAndStuRoNo(pack.getExamination().getExaminationID(),
				studentRoNo);
		StudentAnswer studentAnswer = examinationServiceImpl.selectStudentAnswerByExIdAndStuRoNo(
				pack.getExamination().getExaminationID(), studentRoNo, pack.getQuestionNumber());
		int tem = 0;
		if (value <= pack.getValue()) {
			tem = examinationServiceImpl.updateScore(studentRoNo, pack.getExamination().getExaminationID(),
					score.getSingleSelectionValue(), score.getMoreSelectionValue(), score.getJudgeValue(),
					score.getPackValue() - studentAnswer.getGetValue() + value, score.getShortAnswerValue(),
					score.getSingleSelectionValue() + score.getMoreSelectionValue() + score.getJudgeValue() + value
							+ score.getShortAnswerValue() - studentAnswer.getGetValue());
			examinationServiceImpl.updateStudentAnswer(studentRoNo, pack.getExamination().getExaminationID(),
					pack.getQuestionNumber(), studentAnswer.getStuAnswer(), value);
		}

		if (tem > 0) {
			map.put("result", true);
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 老师给简答题打分
	@RequestMapping(value = "/setShortAnswerStuAnswer.do")
	@ResponseBody
	public Map<String, Object> setShortAnswerStuAnswer(String studentRoNo, int shortAnswerId, int value) {
		Map<String, Object> map = new HashMap<>();
		ShortAnswer shortAnswer = examinationServiceImpl.selectShortAnswerByShortAnswerId(shortAnswerId);
		Score score = examinationServiceImpl
				.selectScoreByExIdAndStuRoNo(shortAnswer.getExamination().getExaminationID(), studentRoNo);
		StudentAnswer studentAnswer = examinationServiceImpl.selectStudentAnswerByExIdAndStuRoNo(
				shortAnswer.getExamination().getExaminationID(), studentRoNo, shortAnswer.getQuestionNumber());
		int tem = 0;
		if (value <= shortAnswer.getValue()) {
			tem = examinationServiceImpl.updateScore(studentRoNo, shortAnswer.getExamination().getExaminationID(),
					score.getSingleSelectionValue(), score.getMoreSelectionValue(), score.getJudgeValue(),
					score.getPackValue(), score.getShortAnswerValue() - studentAnswer.getGetValue() + value,
					score.getSingleSelectionValue() + score.getMoreSelectionValue() + score.getJudgeValue() + value
							+ score.getPackValue() - studentAnswer.getGetValue());
			examinationServiceImpl.updateStudentAnswer(studentRoNo, shortAnswer.getExamination().getExaminationID(),
					shortAnswer.getQuestionNumber(), studentAnswer.getStuAnswer(), value);
		}

		if (tem > 0) {
			map.put("result", true);
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 更新答案状态
	@RequestMapping(value = "/updateScoreStatus.do")
	@ResponseBody
	public Map<String, Object> updateScoreStatus(int scoreId) {
		Map<String, Object> map = new HashMap<>();
		int tem = examinationServiceImpl.updateScoreStatus(scoreId, "批改完成");
		if (tem > 0) {
			map.put("result", true);
		} else {
			map.put("result", false);
		}
		return map;
	}

	// 学生查看关于自己的试卷
	@RequestMapping(value = "/selectScoreByStudent.do")
	@ResponseBody
	public Map<String, Object> selectScoreByStudent(String studentRono) {
		Map<String, Object> map = new HashMap<>();
		List<StudentInfo> studentInfos = studentInfoServiceImpl.selectCourseByStudentRono(studentRono);
		List<Examination> examinations = new ArrayList<>();
		for (StudentInfo studentInfo : studentInfos) {
			List<Examination> examinationS2 = examinationServiceImpl
					.selectExaminationByCourseId(studentInfo.getCourse().getCourseId());
			for (Examination examination : examinationS2) {
				examinations.add(examination);
			}

		}
		// List<Score> scores =
		// examinationServiceImpl.selectScoreByStudent(studentRono);
		map.put("examinations", examinations);
		return map;
	}

	// 查看学生自己的试卷及成绩
	@RequestMapping(value = "/getMyScore.do")
	@ResponseBody
	public Map<String, Object> getMyScore(String studentRono, String examinationID) {
		Map<String, Object> map = new HashMap<>();
		Score score = examinationServiceImpl.selectScoreByExIdAndStuRoNo(Integer.parseInt(examinationID), studentRono);
		Examination examination = examinationServiceImpl
				.selectExaminationByExaminationId(Integer.parseInt(examinationID));
		System.out.println(studentRono);
		System.out.println(examinationID);
		System.out.println(score.getScoreStatus());
		if (score.getScoreStatus().equals("批改完成")) {
			List<StudentAnswer> studentAnswers1 = new ArrayList<>();// 单选答案List
			List<StudentAnswer> studentAnswers2 = new ArrayList<>();// 多选答案List
			List<StudentAnswer> studentAnswers3 = new ArrayList<>();// 判断答案List
			List<StudentAnswer> studentAnswers4 = new ArrayList<>();// 填空答案List
			List<StudentAnswer> studentAnswers5 = new ArrayList<>();// 简答答案List
			List<SingleSelection> singleSelections = examinationServiceImpl
					.selectSingleByExaminationID(Integer.parseInt(examinationID));
			for (SingleSelection singleSelection : singleSelections) {
				StudentAnswer studentAnswer = examinationServiceImpl.selectStudentAnswerByExIdAndStuRoNo(
						Integer.parseInt(examinationID), studentRono, singleSelection.getQuestionNumber());
				studentAnswers1.add(studentAnswer);
			}
			List<MoreSelection> moreSelections = examinationServiceImpl
					.selectMoreByExaminationID(Integer.parseInt(examinationID));
			for (MoreSelection moreSelection : moreSelections) {
				StudentAnswer studentAnswer = examinationServiceImpl.selectStudentAnswerByExIdAndStuRoNo(
						Integer.parseInt(examinationID), studentRono, moreSelection.getQuestionNumber());
				studentAnswers2.add(studentAnswer);
			}
			List<Judge> judges = examinationServiceImpl.selectJudgeByExaminationID(Integer.parseInt(examinationID));
			for (Judge judge : judges) {
				StudentAnswer studentAnswer = examinationServiceImpl.selectStudentAnswerByExIdAndStuRoNo(
						Integer.parseInt(examinationID), studentRono, judge.getQuestionNumber());
				studentAnswers3.add(studentAnswer);
			}
			List<Pack> packs = examinationServiceImpl.selectPackByExaminationIDX(Integer.parseInt(examinationID));
			for (Pack pack : packs) {
				StudentAnswer studentAnswer = examinationServiceImpl.selectStudentAnswerByExIdAndStuRoNo(
						Integer.parseInt(examinationID), studentRono, pack.getQuestionNumber());
				studentAnswers4.add(studentAnswer);
			}
			List<ShortAnswer> shortAnswers = examinationServiceImpl
					.selectShortAnswerByExaminationIDX(Integer.parseInt(examinationID));
			for (ShortAnswer shortAnswer : shortAnswers) {
				StudentAnswer studentAnswer = examinationServiceImpl.selectStudentAnswerByExIdAndStuRoNo(
						Integer.parseInt(examinationID), studentRono, shortAnswer.getQuestionNumber());
				studentAnswers5.add(studentAnswer);
			}
			map.put("studentAnswers1", studentAnswers1);
			map.put("studentAnswers2", studentAnswers2);
			map.put("studentAnswers3", studentAnswers3);
			map.put("studentAnswers4", studentAnswers4);
			map.put("studentAnswers5", studentAnswers5);
			map.put("singleSelections", singleSelections);
			map.put("moreSelections", moreSelections);
			map.put("judges", judges);
			map.put("packs", packs);
			map.put("shortAnswers", shortAnswers);
			map.put("result", true);
			map.put("score", score);
			map.put("examination", examination);
		} else {
			map.put("result", false);
		}
		return map;
	}

}