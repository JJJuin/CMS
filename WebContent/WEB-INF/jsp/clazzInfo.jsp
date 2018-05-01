<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%if(session.getAttribute("UserId")==null){
response.sendRedirect(request.getContextPath() + "/index.jsp");
}%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet"
	href="<%=request.getContextPath()%>/css/teacherPage.css">
<link rel="shortcut icon" type="image/x-icon"
	href="<%=request.getContextPath()%>/icon/cms2.ico" media="screen" />

<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery-3.2.1.min.js"></script>

<link type="text/css" rel="stylesheet"
	href="<%=request.getContextPath()%>/layui/css/layui.css">
<script src="<%=request.getContextPath()%>/layui/layui.js "></script>
<script src="<%=request.getContextPath()%>/layui/mods/index.js"></script>
<title>班级事务</title>



<script type="text/javascript">
layui.use(['form'], function(){
var form = layui.form;

});

var examinationId;
//修改班级信息
function changeWhenClick(clazzId) {

	 $('#getHeadLine').html("修改班级信息");
	 var clazzIdpre = clazzId.substring(3);
	 document.getElementById("preclazzId").value = clazzIdpre;
	$('#clazzInfoShow1').hide();
	$('#clazzForm').toggle();	
}
function saveChange() {
	 $.ajax({
         type: "GET",
         data: {
        	 "clazzId": $('#preclazzId').val(),
        	 "clazzName": $('#ChangeClazzName').val(),
        	 "currentYear":$('#ChangeCurrentYear').val()
         },
         contentType: "application/json; charset=utf-8",
         dataType: "json",
         async: false,
         url: "<%=request.getContextPath()%>/clazz/changeClazzByAjax.do",
         success: function (data) {
        	if(data.result == true){
        		layui.use('layer', function(){ //独立版的layer无需执行这一句
 	               var $ = layui.jquery, layer = layui.layer; 
 	             //触发事件
   			      layer.open({
   			        type: 1
   			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
   			        ,id: 'layerDemo'+'auto' //防止重复弹出
   			        ,title: '成功'
   			        ,content: '<div style="padding: 20px 100px;">'+ "班级信息修改成功.." +'</div>'
   			        ,btn: '关闭'
   			        ,btnAlign: 'c' //按钮居中
   			        ,shade: 0 //不显示遮罩
   			        ,yes: function(){
   			        	window.location.reload();
   			        }
   			      });
 	            });
        	}else{
        		layui.use('layer', function(){ //独立版的layer无需执行这一句
  	               var $ = layui.jquery, layer = layui.layer; 
  	             //触发事件
    			      layer.open({
    			        type: 1
    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
    			        ,id: 'layerDemo'+'auto' //防止重复弹出
    			        ,title: '失败'
    			        ,content: '<div style="padding: 20px 100px;">'+ "班级信息修改失败.." +'</div>'
    			        ,btn: '关闭'
    			        ,btnAlign: 'c' //按钮居中
    			        ,shade: 0 //不显示遮罩
    			        ,yes: function(){
    			        	 layer.closeAll();
    			        }
    			      });
  	            });
			}
         },
         error: function (data) {
             alert("修改失败！");
         },
     });
}
//ajax删除clazz,本质上是修改clazz的外键courseId为null
function deleteClazzByAjax(clazzid) {
	var clazzId = clazzid.substring(3);
	 $.ajax({
         type: "GET",
         data: {
        	 "clazzId": clazzId
         },
         contentType: "application/json; charset=utf-8",
         dataType: "json",
         async: false,
         url: "<%=request.getContextPath()%>/clazz/deleteClazzById.do",
         success: function (data) {
        	 layui.use('layer', function(){ //独立版的layer无需执行这一句
	               var $ = layui.jquery, layer = layui.layer; 
	             //触发事件
  			      layer.open({
  			        type: 1
  			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
  			        ,id: 'layerDemo'+'auto' //防止重复弹出
  			        ,title: '成功'
  			        ,content: '<div style="padding: 20px 100px;">'+ data.message +'</div>'
  			        ,btn: '关闭'
  			        ,btnAlign: 'c' //按钮居中
  			        ,shade: 0 //不显示遮罩
  			        ,yes: function(){
  			        	window.location.reload();
  			        }
  			      });
	            });
        	// window.location.reload();
         },
         error: function (data) {
        	 layui.use('layer', function(){ //独立版的layer无需执行这一句
	               var $ = layui.jquery, layer = layui.layer; 
	             //触发事件
			      layer.open({
			        type: 1
			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
			        ,id: 'layerDemo'+'auto' //防止重复弹出
			        ,title: '失败'
			        ,content: '<div style="padding: 20px 100px;">'+ "删除失败！" +'</div>'
			        ,btn: '关闭'
			        ,btnAlign: 'c' //按钮居中
			        ,shade: 0 //不显示遮罩
			        ,yes: function(){
			          layer.closeAll();
			        }
			      });
	            });
         },
     });
}
//隐藏正在滚动刷新的验证码
function closeValidateCode() {
	$("#validateCode").hide();
}
//二维码要用到的随机数
var run = true;
function hello(){ 
	if(run){
	$.ajax({
         type: "GET",
         data: {
         },
         contentType: "application/json; charset=utf-8",
         dataType: "json",
         async: false,
         url: "<%=request.getContextPath()%>/student/getVertifyCode.do",
         success: function (data) {
        	 $("#validateCode").html(data.code);
        	 var t2 = window.setTimeout("hello()",15000);//15s后刷新随机数
         },
         error: function (data) {
             alert("服务器异常！");
         },
     });
	 window.setTimeout("closeValidateCode()",30000);
	}
} 
//倒计时
var maxtime = 10;
function CountDown(){  
		if(maxtime>=0){   
			 seconds = maxtime;  
			 msg = "签到码还有<span style='color:red; font-size:1.5em;'>"+seconds+"</span>秒刷新";  
			 document.all["timer"].innerHTML=msg;   
			 --maxtime;  
		}else{  
		clearInterval(timer);    
		}  
}  
//timer = setInterval("CountDown()",1000); 	
//显示签到二维码
function showQrImg() {
	$('#getAllInfo').hide();
	$('#qrHref').attr("disabled","disabled");
	 $.ajax({
         type: "GET",
         data: {
        	 "teacherMobile":${teacher.teacherMobile},
        	 "courseId": ${course.courseId}
         },
         contentType: "application/json; charset=utf-8",
         dataType: "json",
         async: false,
         url: "<%=request.getContextPath()%>/course/getQrImg.do",
         success: function (data) {
        	 run = true;
        	 var url = "/ClassManageSys/qrImg/" + data.url + ".gif";
        	 var imgPre = document.getElementById("qrImg");
//         	 imgPre.style.display = "block";
             imgPre.src = url;
             maxtime = 10;
             setInterval("CountDown()",1000);
             //5s刷新
             setInterval('YesConfirm()', 5000);
             var t1 = window.setTimeout("hello()",11500); //10s后显示随机数
            // window.clearTimeout(t1);//去掉定时器             
         },
         error: function (data) {
             alert("服务器异常！");
         },
     });
}
//获取签到成功学生列表
function YesConfirm() {
	if(run){
		$.ajax({
	         type: "GET",
	         data: {
	        	 "courseId": ${course.courseId}
	         },
	         contentType: "application/json; charset=utf-8",
	         dataType: "json",
	         async: true,
	         url: "<%=request.getContextPath()%>/student/getTemStudent.do",
	         success: function (data) {
	        	    var dataObj = data.clazzStuss, //返回的data为json格式的数据
	        	    con =  '\
	        	    		<caption>当前签到进度</caption>\
	        				<tr>\
	        					<th style="text-align:center">学号</th>\
	        					<th style="text-align:center">姓名</th>\
	        					<th style="text-align:center">班级</th>\
	        				</tr>\
	        				';
	        	    $.each(dataObj, function (index, item) {  
	        	        con += "<tr>";
	        	        con += "<td style='text-align:center'>" + item.student.studentRoNo + "</td>";
	        	        con += "<td style='text-align:center'>" + item.student.studentName + "</td>";
	        	        con += "<td style='text-align:center'>" + item.clazz.clazzName + "</td>";
	        	        con += "<tr/>";
	        	    });
	        	        //可以在控制台打印一下看看，这是拼起来的标签和数据
	        	        //把内容入到这个div中即完成
	        	        $('#showStudents').show();
	        	    $("#showStudents").html(con);
	         },
	         error: function (data) { 
	             console.log(data);
	             alert("服务器异常！");
	         },
	     });
	}
	 
}
//提交签到表
function submitSignIn() {
	 $.ajax({
         type: "GET",
         data: {
        	 "courseId": ${course.courseId}
         },
         contentType: "application/json; charset=utf-8",
         dataType: "json",
         async: false,
         url: "<%=request.getContextPath()%>/student/submitSignIn.do",
			success : function(data) {
				layui.use('layer', function(){ //独立版的layer无需执行这一句
	  	               var $ = layui.jquery, layer = layui.layer; 
	  	             //触发事件
	    			      layer.open({
	    			        type: 1
	    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
	    			        ,id: 'layerDemo'+'auto' //防止重复弹出
	    			        ,title: '成功'
	    			        ,content: '<div style="padding: 20px 100px;">'+ data.message +'</div>'
	    			        ,btn: '关闭'
	    			        ,btnAlign: 'c' //按钮居中
	    			        ,shade: 0 //不显示遮罩
	    			        ,yes: function(){
	    			        	run = false;
	    			        	layer.closeAll();
	    			        	window.location.reload();
	    			        }
	    			      });
	  	            });
				$('#getAllInfo').show();
			},
			error : function(data) {
				alert("服务器异常！");
			},
		});
	}
//ajax获取上传的文件列表
function getPrivateData() {
	 $('#signModel').hide();
	 $('#getHeadLine').html("上传文件");
	 $('#otherModel').hide();
	 $('#addExaminationDiv').hide();
	 $('#addClassShow').hide();
	 $('#clazzInfoShow').hide();
	 $('#addQuestionsDiv').hide();
	 $('#inClazzStudentInfoDiv').hide();
	 $('#studentExam').hide();
	 $('#scoreFormList').hide();
	 $('#proclamationDiv').hide();
	 $('#homeWork').hide();  
	 $('#compareDetailDiv').hide();
	 $('#upLoadShow').show();
	 
	 $.ajax({
         type: "GET",
         data: {
        	 "courseId":${course.courseId}
         },
         contentType: "application/json; charset=utf-8",
         async: false,
         url: "<%=request.getContextPath()%>/teacher/getPrivateData.do",
		success : function(data) {
			var dataObj = data.filePackages;
			 con = "";
			 $.each(dataObj, function (index, item) {
				    con += "<tr>";
        	        con += "<td style='text-align:center;'>" + item.fileType + "</td>";
        	        con += "<td style='text-align:center;'>" + item.createTime + "</td>";
        	        con += "<td style='padding-left:5%;'><a href=\'<%=request.getContextPath() %>/file/"+item.fileName+"\'>" + item.fileName + "</a></td>";
        	        con += "<tr/>";
        	    });
			 $('#privateData').html(con);
		},
		error : function(data) {
		},
		dataType : "json",
	});
	
}
function timeoutForFileList() {
	setTimeout('getPrivateData()',2000);
}
//添加班级
function getAddClass() {
	 $('#getHeadLine').html("添加班级");
	 $('#signModel').hide();
	 $('#otherModel').hide();
	 $('#upLoadShow').hide();
	 $('#clazzInfoShow').hide();
	 $('#addExaminationDiv').hide();
	 $('#homeWork').hide();
	 $('#addQuestionsDiv').hide();
	 $('#compareDetailDiv').hide();
	 $('#studentExam').hide();
	 $('#inClazzStudentInfoDiv').hide();
	 $('#proclamationDiv').hide();
	 $('#scoreFormList').hide();
	 $('#addClassShow').show();
}
//班级信息
function classInfo() {
	 $('#getHeadLine').html("班级信息");
	 $('#clazzForm').hide();
	 $('#signModel').hide();
	 $('#otherModel').hide();
	 $('#upLoadShow').hide();
	 $('#addClassShow').hide();
	 $('#homeWork').hide();  
	 $('#addExaminationDiv').hide();
	 $('#addQuestionsDiv').hide();
	 $('#addClassShow').hide();
	 $('#compareDetailDiv').hide();
	 $('#studentExam').hide();
	 $('#inClazzStudentInfoDiv').hide();
	 $('#scoreFormList').hide();
	 $('#proclamationDiv').hide();
	 $('#clazzInfoShow1').show();
	 $('#clazzInfoShow').show();
	 
}

//添加班级
function teacherAddClazz() {
	if($('#clazzName').val().length > 0 && $('#clazzName').val().length <21 & $('#currentYear').val()!=""){
		$.ajax({
	         type: "GET",
	         data: {
	        	 "courseId":${course.courseId},
	        	 "clazzName":$('#clazzName').val(),
	        	 "currentYear":$('#currentYear').val()
	         },
	         contentType: "application/json; charset=utf-8",
	         async: false,
	         url: "<%=request.getContextPath()%>/clazz/addClazz.do",
			success : function(data) {
				if(data.result == true){
					layui.use('layer', function(){ //独立版的layer无需执行这一句
		  	               var $ = layui.jquery, layer = layui.layer; 
		  	             //触发事件
		    			      layer.open({
		    			        type: 1
		    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
		    			        ,id: 'layerDemo'+'auto' //防止重复弹出
		    			        ,title: '成功'
		    			        ,content: '<div style="padding: 20px 100px;">'+ "添加班级成功." +'</div>'
		    			        ,btn: '关闭'
		    			        ,btnAlign: 'c' //按钮居中
		    			        ,shade: 0 //不显示遮罩
		    			        ,yes: function(){
		    			        	setTimeout('yourFunction()',200);
		    			        }
		    			      });
		  	            });
					//$('#afterAddClazz').show();
				}
			},
			error : function(data) {
				alert("服务器异常");
			},
			dataType : "json",
		});
	}
}
//刷新当前页面
function yourFunction() {
 window.location.reload();
}
//查看班级里的学生信息
var clazzIdTem;
function aClick(clazzId) {
	clazzIdTem = clazzId;
	$.ajax({
        type: "GET",
        data: {
       	 "clazzId":clazzId
        },
        contentType: "application/json; charset=utf-8",
        async: false,
        url: "<%=request.getContextPath()%>/student/selectStudentByClazzId.do",
		success : function(data) {
			$('#clazzInfoShow').hide();
			$('#studentCount').html(data.count);
			$('#getHeadLine').html("班级  " + data.clazzName + "学生信息");
			var dataObj = data.students;
			 con = "";
			 $.each(dataObj, function (index, item) {
				con += "<tr id='Tr"+ item.studentRoNo +"'>";
       	        con += "<td style='text-align:center;'>" + item.studentRoNo + "</td>";
       	        con += "<td id='NM" + item.studentRoNo +"' style='text-align:center;'>" + item.studentName + "</td>";
       	        con += "<td style='text-align:center;'>" + item.studentGender + "</td>";
       	        con += "<td style='text-align:center;'>" + item.studentMobile + "</td>";
       	        con += "<td style='text-align:center;'><img src=\'/ClassManageSys/studentPhoto/"+item.studentPhoto+"\'/></td>";
       	        con += "<td id='ds' style='text-align:center;'><div class='site-demo-button'><a id='M"+ item.studentRoNo +"' onclick='forSendMessageToStudent(this.id)'  href='#' style='color:#5FB878'>" + "<i class='layui-icon' style='font-size: 24px; color: #1E9FFF;'>&#xe611;</i>  " + "</a></div></td>";
       	        con += "<td id='ds' style='text-align:center;'><div class='site-demo-button' id='layerDemo'><a class='myDelete' id='"+ item.studentRoNo +"' onclick='forDeleteStudent(this.id)' data-method='notice' href='#' style='color:#5FB878'>" + "<i class='layui-icon' style='font-size: 30px; color: #1E9FFF;'>&#xe640;</i>  " + "</a></div></td>";
       	        con += "<tr/>";
       	    });
			 $('#inClazzStudentInfoTable').html(con);
			 $('#inClazzStudentInfoDiv').show();
		},
		error : function(data) {
			alert("??");
		},
		dataType : "json",
	});
	layui.use([ 'element', 'layer' ],function() {
		var element = layui.element, $ = layui.jquery, layer = layui.layer;
		//触发事件
		var active = {
			notice : function() {
				//示范一个公告层
				layer
						.open({
							type : 1,
							title : false //不显示标题栏
							,
							closeBtn : false,
							area : '300px;',
							shade : 0.8,
							id : 'LAY_layuipro' //设定一个id，防止重复弹出
							,
							btn : [ '删除', '取消' ],
							yes : function(index, layero) {
								deleteStudent();
								layer.closeAll();
							},
							btn2 : function(index, layero) {
								//按钮【按钮二】的回调
							},
							btnAlign : 'c',
							moveType : 1 //拖拽模式，0或者1
							,
							content : '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">确定移除该学生？<br/>(同时删除签到记录)</div>'
						});
			},
			page : function() {
				layer.open({
					type : 1,
					title : false,
					closeBtn : 0,
					area : '390px',
					skin : 'layui-layer-lan', //没有背景色
					shadeClose : true,
					content : $('#target')
				});
			}

		};

		$('#layerDemo .myDelete').on(
				'click',
				function() {
					var othis = $(this), method = othis
							.data('method');
					active[method] ? active[method].call(
							this, othis) : '';
				});

		//监听导航点击
		element.on('nav(demo)', function(elem) {
			//console.log(elem)
			layer.msg(elem.text());
		});
	});
}
//给学生发消息
function forSendMessageToStudent(id) {
	layui.use('layer', function(){ //独立版的layer无需执行这一句
          var $ = layui.jquery, layer = layui.layer;
	layer.open({
        type: 1
        ,title: false //不显示标题栏
        ,closeBtn: true
        ,area: '300px;'
        ,shade: 0.8
        ,id: 'LAY_layuipro' //设定一个id，防止重复弹出
        ,btn: ['立即发送', '想想再说']
        ,btnAlign: 'c'
        ,moveType: 0 //拖拽模式，0或者1
        ,content: '<div style="background-color: #393D49; color: #fff;"><div  style="width:100%;"> <br/><label>给<'+ $('#N'+id).html() +'>发送消息</label><textarea style="color:#393D49" id="messageToStudentContent" class="layui-textarea"></textarea></div></div>'
        ,yes: function(){
        	if($('#messageToStudentContent').val() != "" && id != null){
        		$.ajax({
        	        type: "GET",
        	        data: {
        	         "messageToStudentContent":$('#messageToStudentContent').val(),
        	         "teacherMobile":${teacher.teacherMobile},
        	         "studentRoNo":id.substring(1)
        	        },
        	        contentType: "application/json; charset=utf-8",
        	        async: false,
        	        url: "<%=request.getContextPath()%>/teacher/sendMessageToStudent.do",
        			success : function(data) {
        				if(data.result == true){
        					layui.use('layer', function(){
     		 	               var $ = layui.jquery, layer = layui.layer; 
     		   			      layer.open({
     		   			        type: 1
     		   			        ,offset: 'auto'
     		   			        ,id: 'layerDemo'+'auto'
     		   			        ,title: '成功'
     		   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "消息发送成功！" +'</div>'
     		   			        ,btn: '关闭'
     		   			        ,btnAlign: 'c'
     		   			        ,skin: 'demo-class'
     		   			        ,shade: 0 
     		   			        ,yes: function(){
     		   			        	 layer.closeAll();
     		   			        }
     		   			      });
     		 	            });
        				}else{
        					layui.use('layer', function() {
        						var $ = layui.jquery, layer = layui.layer;
        						layer.msg('消息发送失败！');
        					});
        				}
        			},
        			error : function(data) {
        				alert("服务器异常");
        			},
        			dataType : "json",
        		});
        	}else {
        		layui.use('layer', function() {
					var $ = layui.jquery, layer = layui.layer;
					layer.msg('内容不能为空！');
				});
			}
		  }
	});
  });
}
//服务于删除学生
var studentRoNoTem;
function forDeleteStudent(studentRoNo) {
	 studentRoNoTem = studentRoNo;
}
//删除某一学生
function deleteStudent() {
	$.ajax({
        type: "GET",
        data: {
       	 "clazzId":clazzIdTem,
       	 "studentRoNo":studentRoNoTem,
         "courseId":${course.courseId}
        },
        contentType: "application/json; charset=utf-8",
        async: false,
        url: "<%=request.getContextPath()%>/teacher/deleteStudent.do",
		success : function(data) {
			if(data.result == true){
				var ccount = $('#studentCount').html();
		        	$('#studentCount').html(ccount-1);
				layui.use('layer', function(){
	 	               var $ = layui.jquery, layer = layui.layer; 
	   			      layer.open({
	   			        type: 1
	   			        ,offset: 'auto'
	   			        ,id: 'layerDemo'+'auto'
	   			        ,title: '成功'
	   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "删除成功" +'</div>'
	   			        ,btn: '关闭'
	   			        ,btnAlign: 'c'
	   			        ,skin: 'demo-class'
	   			        ,shade: 0 
	   			        ,yes: function(){
	   			         //window.location.reload();
	   			        layer.closeAll();
	   			        }
	   			      });
	 	            });
				$('#Tr' + studentRoNoTem).hide();
			}else{
				layui.use('layer', function() {
					var $ = layui.jquery, layer = layui.layer;
					layer.msg('出现问题，删除失败！');
				});
			}
		},
		error : function(data) {
			alert("??");
		},
		dataType : "json",
	});
}
//批改试卷
function TocorrectExamination() {
	 $('#getHeadLine').html("批改试卷");
	 $('#clazzForm').hide();
	 $('#signModel').hide();
	 $('#otherModel').hide();
	 $('#upLoadShow').hide();
	 $('#addClassShow').hide();
	 $('#addExaminationDiv').hide();
	 $('#addQuestionsDiv').hide();
	 $('#addClassShow').hide();
	 $('#inClazzStudentInfoDiv').hide();
	 $('#clazzInfoShow1').hide();
	 $('#homeWork').hide();  
	 $('#clazzInfoShow').hide();
	 $('#compareDetailDiv').hide();
	 $('#packScore').hide();
	 $('#ShortAnswerScore').hide();
	 $('#studentScoreList').hide();
	 $('#studentScoreListH3').hide();
	 $('#studentExam').show();
	 $('#proclamationDiv').hide();
	 $('#scoreFormList').hide();
	 $('#PreExaminationList').show();
	 
		$.ajax({
	        type: "GET",
	        data: {
	        	"courseId":${course.courseId}
	        },
	        contentType: "application/json; charset=utf-8",
	        async: false,
	        url: "<%=request.getContextPath()%>/exam/selectExaminationByCourseIdAndAnother.do",
			success : function(data) {
				var dataObj = data.examinations;
				 con = "";
				 $.each(dataObj, function (index, item) {
					    con += "<tr id=N"+item.examinationID+">";
	       	        con += "<td style='text-align:center;'>" + item.examinationID + "</td>";
	       	        con += "<td style='text-align:center;'>" + item.examinationName + "</td>";
	       	        con += "<td style='text-align:center; color:#FF5722;'>" + item.onlyCode + "</td>";
	       	        con += "<td style='text-align:center;'>" + item.totalValue + "分</td>";
	       	        con += "<td style='text-align:center;'>" + item.startTime + "</td>";
	       	        con += "<td style='text-align:center;'>" + item.duration + "分钟</td>";
	       	        con += "<td style='text-align:center;'><div class='site-demo-button' id='layerDemo'><a id="+item.examinationID+" onclick='getStudentExamList(this.id)' class='layui-btn'>" + "批改" + "</a></div></td>";
	       	        con += "<tr/>";
	       	    });
				 $('#teacherExaminationShowTable').html(con);
			},
			error : function(data) {
				alert("??");
			},
			dataType : "json",
		});
}
//获取考完的学生的试卷/答案列表
function getStudentExamList(id) {
	$('#changeExamEndX').val(id);
	$.ajax({
        type: "GET",
        data: {
        	"examinationID":id
        },
        contentType: "application/json; charset=utf-8",
        async: false,
        url: "<%=request.getContextPath()%>/exam/getStudentExamList.do",
		success : function(data) {
			var dataObj = data.scores;
			 con = "";
			 $.each(dataObj, function (index, item) {
		        con += "<tr id=SL"+item.examinationID+">";
	            con += "<td style='text-align:center;'>" + item.studentRoNo + "</td>";
	            con += "<td style='text-align:center;'>" + item.studentName + "</td>";
	            con += "<td style='text-align:center;'>" + item.studentClass + "</td>";
	            con += "<td style='text-align:center;'>" + item.singleSelectionValue + "</td>";
                con += "<td style='text-align:center;'>" + item.moreSelectionValue + "</td>";
       	        con += "<td style='text-align:center;'>" + item.judgeValue + "</td>";
       	        con += "<td style='text-align:center;'><a style='color:#FF5722;' id='P"+item.scoreId+"' onclick='getStudentPackList(this.id)' href='#'>" + item.packValue + "&nbsp;<i class='layui-icon' style='font-size: 14px; color: #1E9FFF;'>&#xe62a;</i>  </a></td>";
       	        con += "<td style='text-align:center;'><a id='S"+item.scoreId+"'>" + item.shortAnswerValue + "</a></td>";
       	        con += "<td style='text-align:center;'>" + item.totalValue + "</td>";
       	        con += "<td style='text-align:center;'>" + item.scoreStatus + "</td>";
       	        con += "<tr/>";
       	    });
			 $('#ScoreList').html(con);
			 $('#PreExaminationList').hide();
			 $('#packScore').hide();
			 $('#ShortAnswerScore').hide();
			 $('#studentScoreList').show();
			 $('#studentScoreListH3').show();
		},
		error : function(data) {
			alert("??");
		},
		dataType : "json",
	});
}
//填空/简答打分
function getStudentPackList(id) {
	window.location.reload;
	$.ajax({
        type: "GET",
        data: {
        	"scoreId":id.substring(1)
        },
        contentType: "application/json; charset=utf-8",
        async: false,
        url: "<%=request.getContextPath()%>/exam/getStudentPackList.do",
		success : function(data) {
			if(data.result == true){
				$('#ssscoreId').val(id.substring(1));
				var dataObj = data.packs;
				 con = "";
				 $.each(dataObj, function (index, item) {
		            con += "<li style='font-size: 1.2em'>(" + item.questionNumber + ") " +item.packContent + " (" + item.value +"分)</li>";
		            con += "<li>" + "&nbsp;" + "</li>";
		            con += "<li><span style='color:#5FB878;'>参考答案：</span>" + item.answer + "</li>";
		            con += "<li>" + "<input type='text' id='Y"+item.packId+"' value='"+item.value+"' style='display:none'/>" + "</li>";
		            con += "<li><span style='color:#FF5722;'>学生答案：</span>" + item.studentAnswer + "</li>";
		            con += "<li>" + "<input type='text' id='X"+item.packId+"' value='"+data.student.studentRoNo+"' style='display:none'/>" + "</li>";
		            con += "<li>得分：" + "<input id='"+item.packId+"' onchange='setPackStuAnswer(this.id)' type='text'/>" + "</li>";
	       	    });
				 
				 var dataOs = data.shortAnswers;
				 von = "";
				 $.each(dataOs, function (index, item) {
					 von += "<li style='font-size: 1.2em'>(" + item.questionNumber + ") " +item.shortAnswerContent + " (" + item.value +"分)</li>";
					 von += "<li>" + "&nbsp;" + "</li>";
					 von += "<li>" + "<input type='text' id='YTC"+item.shortAnswerId+"' value='"+item.value+"' style='display:none'/>" + "</li>";
					 von += "<li><span style='color:#FF5722;'>学生答案：</span>" + item.studentAnswer + "</li>";
					 von += "<li>" + "<input type='text' id='XTC"+item.shortAnswerId+"' value='"+data.student.studentRoNo+"' style='display:none'/>" + "</li>";
					 von += "<li>得分：" + "<input id='TC"+item.shortAnswerId+"' onchange='setShortAnswerIdStuAnswer(this.id)' type='text'/>" + "</li>";
		       	    });
				 
				 
				 $('#PackLi').html(con);
				 $('#ShortAnswerLi').html(von);
				 $('#PreExaminationList').hide();
				 $('#studentScoreList').hide();
				 $('#studentScoreListH3').hide();
				 $('#packScore').show();
				 $('#ShortAnswerScore').show();
			}else {
				 layui.use('layer', function() {
						var $ = layui.jquery, layer = layui.layer;
						layer.msg('考生暂未交卷！');
					});
			}
			
		},
		error : function(data) {
			layui.use('layer', function(){
	              var $ = layui.jquery, layer = layui.layer; 
				      layer.open({
				        type: 1
				        ,offset: 'auto' 
				        ,id: 'layerDemo'+'auto'
				        ,title: '错误'
				        ,content: '<div style="padding: 20px 100px; color:#FF5722;">'+ "该考生考试非正常结束." +'</div>'
				        ,btn: '关闭'
				        ,btnAlign: 'c' 
				        ,shade: 0 
				        ,yes: function(){
				        	layer.closeAll();
				        }
				      });
	           });
		},
		dataType : "json",
	});
}
//老师对填空题打了分
function setPackStuAnswer(id) {
	var studentRoNo = $('#X'+id).val();
	var oldValue = $('#Y'+id).val();
	var packId = id;
	var r = /^\+?[0-9][0-9]*$/;
	if(r.test($('#'+id).val())){
		if($('#'+id).val() <= oldValue){
			$.ajax({
		        type: "GET",
		        data: {
		        	"studentRoNo":studentRoNo,
		        	"packId":packId,
		        	"value":$('#'+id).val()
		        },
		        contentType: "application/json; charset=utf-8",
		        async: false,
		        url: "<%=request.getContextPath()%>/exam/setPackStuAnswer.do",
				success : function(data) {
					
				},
				error : function(data) {
					alert("??");
				},
				dataType : "json",
			});
		}else {
			layui.use('layer', function(){
	              var $ = layui.jquery, layer = layui.layer; 
				      layer.open({
				        type: 1
				        ,offset: 'auto' 
				        ,id: 'layerDemo'+'auto'
				        ,title: '错误'
				        ,content: '<div style="padding: 20px 100px; color:#FF5722;">'+ "分数超出~." +'</div>'
				        ,btn: '关闭'
				        ,btnAlign: 'c' 
				        ,shade: 0 
				        ,yes: function(){
				        	$('#'+id).val("");
				        	layer.closeAll();
				        }
				      });
	           });
		}
	}else {
		layui.use('layer', function(){
             var $ = layui.jquery, layer = layui.layer; 
		      layer.open({
		        type: 1
		        ,offset: 'auto'
		        ,id: 'layerDemo'+'auto'
		        ,title: '错误'
		        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "分数请输入0或正整数" +'</div>'
		        ,btn: '关闭'
		        ,btnAlign: 'c'
		        ,skin: 'demo-class'
		        ,shade: 0 
		        ,yes: function(){
		        	$('#'+id).val("");
		        	 layer.closeAll();
		        }
		      });
          });
	}	
}

//老师对简答题打分
function setShortAnswerIdStuAnswer(id) {
	var studentRoNo = $('#X'+id).val();
	var oldValue = $('#Y'+id).val();
	var shortAnswerId = id.substring(2);
	var zx = /^\+?[0-9][0-9]*$/;
	if(zx.test($('#'+id).val())){
		if($('#'+id).val() <= oldValue){
			$.ajax({
		        type: "GET",
		        data: {
		        	"studentRoNo":studentRoNo,
		        	"shortAnswerId":shortAnswerId,
		        	"value":$('#'+id).val()
		        },
		        contentType: "application/json; charset=utf-8",
		        async: false,
		        url: "<%=request.getContextPath()%>/exam/setShortAnswerStuAnswer.do",
				success : function(data) {
					
				},
				error : function(data) {
					alert("??");
				},
				dataType : "json",
			});
		}else {
			layui.use('layer', function(){
	              var $ = layui.jquery, layer = layui.layer; 
				      layer.open({
				        type: 1
				        ,offset: 'auto' 
				        ,id: 'layerDemo'+'auto'
				        ,title: '错误'
				        ,content: '<div style="padding: 20px 100px; color:#FF5722;">'+ "分数超出~." +'</div>'
				        ,btn: '关闭'
				        ,btnAlign: 'c' 
				        ,shade: 0 
				        ,yes: function(){
				        	layer.closeAll();
				        }
				      });
	           });
		}
	}else {
		layui.use('layer', function(){
            var $ = layui.jquery, layer = layui.layer; 
		      layer.open({
		        type: 1
		        ,offset: 'auto'
		        ,id: 'layerDemo'+'auto'
		        ,title: '错误'
		        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "分数请输入0或正整数" +'</div>'
		        ,btn: '关闭'
		        ,btnAlign: 'c'
		        ,skin: 'demo-class'
		        ,shade: 0 
		        ,yes: function(){
		        	 layer.closeAll();
		        }
		      });
         });
	}

}
//打分完成
function changeExamEndXX() {
	$.ajax({
        type: "GET",
        data: {
        	"scoreId":$('#ssscoreId').val()
        },
        contentType: "application/json; charset=utf-8",
        async: false,
        url: "<%=request.getContextPath()%>/exam/updateScoreStatus.do",
		success : function(data) {
			if(data.result == true){
				layui.use('layer', function(){
			        var $ = layui.jquery, layer = layui.layer; 
				      layer.open({
				        type: 1
				        ,offset: 'auto'
				        ,id: 'layerDemo'+'auto'
				        ,title: '成功'
				        ,content: '<div style="padding: 20px 100px;">'+ "后续可对成绩进行更改" +'</div>'
				        ,btn: '关闭'
				        ,btnAlign: 'c'
				        ,skin: 'demo-class'
				        ,shade: 0 
				        ,yes: function(){
				        	 layer.closeAll();
				        }
				      });
			     });
				getStudentExamList($('#changeExamEndX').val());
			}else {
				
			}
		},
		error : function(data) {
			alert("??");
		},
		dataType : "json",
	});
}
// 显示成绩单
function scoreFormList() {
	$('#getHeadLine').html("成绩show");
	 $('#changeExaminationForm').hide();
	 $('#addQuestionsDiv').hide();
	 $('#signModel').hide();
	 $('#otherModel').hide();
	 $('#upLoadShow').hide();
	 $('#studentExam').hide();
	 $('#clazzInfoShow').hide();
	 $('#proclamationDiv').hide();
	 $('#homeWork').hide();  
	 $('#inClazzStudentInfoDiv').hide();
	 $('#addClassShow').hide();
	 $('#addExaminationForm').hide();
	 $('#compareDetailDiv').hide();
	 $('#ExaminationList').hide();
	 $('#addExaminationDiv').hide();
	 $('#scoreFormList').show();
	 $('#scoreShowTableFirst').show();
	 $('#scoreShowTableSecond').hide();	 
	 $.ajax({
	        type: "GET",
	        data: {
	        	"courseId":${course.courseId}
	        },
	        contentType: "application/json; charset=utf-8",
	        async: false,
	        url: "<%=request.getContextPath()%>/exam/selectExaminationByCourseIdAndAnother.do",
			success : function(data) {
				var dataObj = data.examinations;
				 con = "";
				 $.each(dataObj, function (index, item) {
					    con += "<tr id=N"+item.examinationID+">";
	       	        con += "<td style='text-align:center;'>" + item.examinationID + "</td>";
	       	        con += "<td style='text-align:center;'>" + item.examinationName + "</td>";
	       	        con += "<td style='text-align:center; color:#FF5722;'>" + item.onlyCode + "</td>";
	       	        con += "<td style='text-align:center;'>" + item.totalValue + "分</td>";
	       	        con += "<td style='text-align:center;'>" + item.startTime + "</td>";
	       	        con += "<td style='text-align:center;'>" + item.duration + "分钟</td>";
	       	        con += "<td style='text-align:center;'><div class='site-demo-button' id='layerDemo'><a href='#' id='"+item.examinationID+"' onclick='scoreShowTableFirst(this.id)'><i class='layui-icon' style='font-size: 30px; color: #1E9FFF;'>&#xe63c;</i></a> </div></td>";
	       	        con += "<td style='text-align:center;'><a href='<%=request.getContextPath()%>/teacher/exportScore.do?examinationID="+item.examinationID+"'><i class='layui-icon' style='font-size: 30px; color: #1E9FFF;'>&#xe61e;</i></a></td>";
	       	        con += "<tr/>";
	       	    });
				 $('#scoreShowTable').html(con);
			},
			error : function(data) {
				alert("??");
			},
			dataType : "json",
		});
}
//导出成绩单
function exportScore(id) {
	alert(id);
	$.ajax({
        type: "GET",
        data: {
        	"examinationID":id.substring(1)
        },
        contentType: "application/json; charset=utf-8",
        async: false,
        url: "<%=request.getContextPath()%>/teacher/exportScore.do",
		success : function(data) {
			
		},
		error : function(data) {
			alert("??");
		},
		dataType : "json",
	});
}
//看某试卷下面的学生成绩
function scoreShowTableFirst(id) {
	$('#studentScoreTem').val(id);
	$.ajax({
        type: "GET",
        data: {
        	"examinationID":id
        },
        contentType: "application/json; charset=utf-8",
        async: false,
        url: "<%=request.getContextPath()%>/exam/getStudentExamList.do",
		success : function(data) {
			 $('#compareDetailDiv').hide();
			 $('#scoreFormList').show();
			var dataObj = data.scores;
			 con = "";
			 $.each(dataObj, function (index, item) {
		        con += "<tr id=SL"+item.examinationID+">";
	            con += "<td style='text-align:center;'>" + item.studentRoNo + "</td>";
	            con += "<td style='text-align:center;'>" + item.studentName + "</td>";
	            con += "<td style='text-align:center;'>" + item.studentClass + "</td>";
	            con += "<td style='text-align:center;'>" + item.singleSelectionValue + "</td>";
                con += "<td style='text-align:center;'>" + item.moreSelectionValue + "</td>";
       	        con += "<td style='text-align:center;'>" + item.judgeValue + "</td>";
       	        con += "<td style='text-align:center;'>" + item.packValue + "</a></td>";
       	        con += "<td style='text-align:center;'>" + item.shortAnswerValue + "</a></td>";
       	        con += "<td style='text-align:center;'>" + item.totalValue + "</td>";
       	        if(item.chertSuspicion != null){
       	         con += "<td style='text-align:center;'><a id=cp"+item.scoreId+" onclick='coparePhoto(this.id)' style='color:#FF5722' href='#'>" + item.chertSuspicion + "</a></td>";
       	        }else {
       	         con += "<td style='text-align:center;'><a id=cp"+item.scoreId+" onclick='coparePhoto(this.id)' style='color:#5FB878' href='#'>详情</a></td>";
				}
       	       
       	        con += "<tr/>";
       	    });
			 $('#classCount').html(data.count);
			 $('#classExamCount').html(data.count2);
			 $('#classAvgCount').html(data.avg);
			 $('#classMaxCount').html(data.max);
			 $('#classMinCount').html(data.min);
			 $('#ScoreListaa').html(con);
			 $('#scoreShowTableFirst').hide();
			 $('#scoreShowTableSecond').show();
		},
		error : function(data) {
			alert("??");
		},
		dataType : "json",
	});
	
}
// 人脸识别详情
function coparePhoto(id) {
	var scoreId = id.substring(2);
	$.ajax({
        type: "GET",
        data: {
        	"scoreId":scoreId
        },
        contentType: "application/json; charset=utf-8",
        async: false,
        url: "<%=request.getContextPath()%>/exam/coparePhotoDetail.do",
		success : function(data) {
			$('#scoreFormList').hide();
			
		     var ds = data.score;
		     var don = "";
		     don += "<tr>";
		     don += "<td>"+ ds.studentRoNo +"</td>";
		     don += "<td>"+ ds.studentName +"</td>";
		     don += "<td>"+ ds.studentClass+"</td>";
		     don += "</tr>";
		     
		     $('#scoreStudentDetail').html(don);
		     $('#hereBackUp').html("<a onclick='scoreShowTableFirst("+ds.examinationID+")' href='#' style='color: #009688;margin-left: 13px;'><i class='layui-icon' style='font-size: 15px; color: #009688;'>&#xe65a;</i>&nbsp;返回上一层</a>");
			 var dataObj = data.comeparePhotos;
			 con = "";
			 $.each(dataObj, function (index, item) {
		        con += "<tr id=SL"+item.cppId+">";
	            con += "<td style='text-align:center;'>" + item.cppTime + "</td>";
	            con += "<td style='text-align:center;'>" + item.cppResult + "</td>";
	            if(item.chertAddress != null){
	            	con += "<td style='text-align:center;'><img width:200px; src='"+item.chertAddress+"'/></td>";  
	            }else {
	            	con += "<td style='text-align:center;'>正常范围</td>";  
				}
	                      
       	        con += "<tr/>";
       	    });
			 $('#scoreDetail').html(con);
			 $('#compareDetailDiv').show();
		},
		error : function(data) {
			alert("??");
		},
		dataType : "json",
	});
}
//点击查看试卷
function addExamination() {
	 $('#getHeadLine').html("添加试卷");
	 $('#changeExaminationForm').hide();
	 $('#addQuestionsDiv').hide();
	 $('#signModel').hide();
	 $('#otherModel').hide();
	 $('#upLoadShow').hide();
	 $('#proclamationDiv').hide();
	 $('#compareDetailDiv').hide();
	 $('#homeWork').hide();  
	 $('#studentExam').hide();
	 $('#clazzInfoShow').hide();
	 $('#inClazzStudentInfoDiv').hide();
	 $('#scoreFormList').hide();
	 $('#addClassShow').hide();
	 
	$.ajax({
	        type: "GET",
	        data: {
	        	"courseId":"${course.courseId}"
	        },
	        contentType: "application/json; charset=utf-8",
	        async: false,
	        url: "<%=request.getContextPath()%>/exam/selectExaminationByCourseId.do",
			success : function(data) {
				var dataObj = data.examinations;
				 con = "";
				 $.each(dataObj, function (index, item) {
					    con += "<tr id=N"+item.examinationID+">";
	       	        con += "<td style='text-align:center;'>" + item.examinationID + "</td>";
	       	        con += "<td style='text-align:center;'>" + item.examinationName + "</td>";
	       	        con += "<td style='text-align:center; color:#FF5722;'>" + item.onlyCode + "</td>";
	       	        con += "<td style='text-align:center;'>" + item.totalValue + "分</td>";
	       	        con += "<td style='text-align:center;'>" + item.startTime + "</td>";
	       	        con += "<td style='text-align:center;'>" + item.duration + "分钟</td>";
	       	        con += "<td style='text-align:center;'>" + item.examinationStatus + "</td>";
	       	        con += "<td style='text-align:center;'><div class='site-demo-button' id='layerDemo'><a id=D"+item.examinationID+" onclick='forDeleteQuestion(this.id)' class='layui-btn' data-method='notice'>" + "删除" + "</a></div></td>";
	       	        con += "<td style='text-align:center;'><a id=C"+item.examinationID+" onclick='changeQuestion(this.id)' href=\'#\'>" + "修改" + "</a></td>";
	       	        con += "<td style='text-align:center;'><a id="+item.examinationID+" onclick='createQuestion(this.id)' href=\'#\'>" + "出题" + "</a></td>";
	       	        con += "<tr/>";
      
	       	    });
				 $('#examinationShowTable').html(con);
				 $('#addExaminationForm').show();
				 $('#ExaminationList').show();
				 $('#addExaminationDiv').show();
			},
			error : function(data) {
				alert("??");
			},
			dataType : "json",
		});
	 $('#addExaminationDiv').show();
	 //删除
		layui.use([ 'element', 'layer'], function() {
			var element = layui.element, $ = layui.jquery, layer = layui.layer;
			//触发事件
			var active = {
				notice : function() {
					//示范一个公告层
					layer.open({
								type : 1,
								title : false //不显示标题栏
								,
								closeBtn : false,
								area : '300px;',
								shade : 0.8,
								id : 'LAY_layuipro' //设定一个id，防止重复弹出
								,
								btn : [ '删除', '取消' ],
								yes : function(index, layero) {
									deleteThis();
									layer.closeAll();
								},
								btn2 : function(index, layero) {
									//按钮【按钮二】的回调
								},
								btnAlign : 'c',
								moveType : 1 //拖拽模式，0或者1
								,
								content : '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">确定删除该试卷？</div>'
							});
				}

			};

			$('#layerDemo .layui-btn').on(
					'click',
					function() {
						var othis = $(this), method = othis
								.data('method');
						active[method] ? active[method].call(
								this, othis) : '';
					});
});
}
function FirstFunction() {
	 $('#afterAddExamination').hide();
	 addExamination();
	 window.location.hash = "#title";   
}
//教师添加试卷
function teacherAddExamination() {
	if($('#examinationName').val() != "" && $('#totalValue').val() != "" && 
			$('#startTime').val() != "" && $('#duration').val() != ""){
		$.ajax({
	        type: "GET",
	        data: {
	         "courseId":${course.courseId},
	       	 "examinationName":$('#examinationName').val(),
	       	 "totalValue":$('#totalValue').val(),
	       	 "startTime":$('#startTime').val(),
	         "duration":$('#duration').val()
	        },
	        contentType: "application/json; charset=utf-8",
	        async: false,
	        url: "<%=request.getContextPath()%>/exam/addExamination.do",
			success : function(data) {
				if(data.result == true){
					layui.use('layer', function(){
		  	               var $ = layui.jquery, layer = layui.layer; 
		    			      layer.open({
		    			        type: 1
		    			        ,offset: 'auto'
		    			        ,id: 'layerDemo'+'auto'
		    			        ,title: '成功'
		    			        ,content: '<div style="padding: 20px 100px;">'+ "添加试卷成功." +'</div>'
		    			        ,btn: '关闭'
		    			        ,btnAlign: 'c'
		    			        ,shade: 0
		    			        ,yes: function(){
		    			        	setTimeout('FirstFunction()',500);
		    			        	layer.closeAll();
		    			        }
		    			      });
		  	            });
				}else {
					layui.use('layer', function(){ //独立版的layer无需执行这一句
		  	               var $ = layui.jquery, layer = layui.layer; 
		  	             //触发事件
		    			      layer.open({
		    			        type: 1
		    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
		    			        ,id: 'layerDemo'+'auto' //防止重复弹出
		    			        ,title: '失败'
		    			        ,content: '<div style="padding: 20px 100px;">'+ "添加试卷失败." +'</div>'
		    			        ,btn: '关闭'
		    			        ,btnAlign: 'c' //按钮居中
		    			        ,shade: 0 //不显示遮罩
		    			        ,yes: function(){
		    			        	 layer.closeAll();
		    			        }
		    			      });
		  	            });
				}
			},
			error : function(data) {
				layui.use('layer', function(){
	  	               var $ = layui.jquery, layer = layui.layer; 
	    			      layer.open({
	    			        type: 1
	    			        ,offset: 'auto' 
	    			        ,id: 'layerDemo'+'auto'
	    			        ,title: '失败'
	    			        ,content: '<div style="padding: 20px 100px; color:#FF5722;">'+ "输入格式有误哦~." +'</div>'
	    			        ,btn: '关闭'
	    			        ,btnAlign: 'c' 
	    			        ,shade: 0 
	    			        ,yes: function(){
	    			        	setTimeout('FirstFunction()',500);
	    			        	layer.closeAll();
	    			        }
	    			      });
	  	            });
			},
			dataType : "json",
		});
	}
}
//修改题
function changeTiMu(temId) {
	//temId 为共有Id暂存区，前缀有二，如'CS'是修改单选。'DS'为删除单选，望周知
	$('#temId').val(temId);
	$('#temId').attr("readonly","readonly");
	//修改单选
	if(temId.substring(0,2) == 'CS'){
	$.ajax({
        type: "GET",
        data: {
       	 "singleSelectionId":temId.substring(2)
        },
        contentType: "application/json; charset=utf-8",
        async: false,
        url: "<%=request.getContextPath()%>/exam/changeSingleSelection.do",
		success : function(data) {
			if(data.result == true){
				$('#SingleSelectionQuestionContent').val(data.singleSelection.questionContent);
				 $('#SingleSelectionValue').val(data.singleSelection.value);
		       	 $('#SingleSelectionOptionA').val(data.singleSelection.optionA);
		         $('#SingleSelectionOptionB').val(data.singleSelection.optionB);
		       	 $('#SingleSelectionOptionC').val(data.singleSelection.optionC);
		       	 $('#SingleSelectionOptionD').val(data.singleSelection.optionD);
		         $('#SingleSelectioAnswer').val(data.singleSelection.answer);
		         $('#SingleSelectionNote').val(data.singleSelection.note);
		         $('#SingleSelectionButton').hide();
		         $('#ChangeSingleSelectionButton').show();
		         
				$('#SingleSelectionDetail').show();
				 window.location.hash = "#SingleSelectionDetail"; 
			}else {
				layui.use('layer', function(){ 
	  	               var $ = layui.jquery, layer = layui.layer; 
	  	             //触发事件
	    			      layer.open({
	    			        type: 1
	    			        ,offset: 'auto'
	    			        ,id: 'layerDemo'+'auto' //防止重复弹出
	    			        ,title: '错误'
	    			        ,content: '<div style="padding: 20px 100px;">'+ "获取该题失败." +'</div>'
	    			        ,btn: '关闭'
	    			        ,btnAlign: 'c' //按钮居中
	    			        ,shade: 0 //不显示遮罩
	    			        ,yes: function(){
	    			        	 layer.closeAll();
	    			        }
	    			      });
	  	            });
			}
		},
		error : function(data) {
			alert("??");
		},
		dataType : "json",
	});
  }else if (temId.substring(0,2) == 'CM') {
	  //修改多选
		$.ajax({
	        type: "GET",
	        data: {
	       	 "moreSelectionId":temId.substring(2)
	        },
	        contentType: "application/json; charset=utf-8",
	        async: false,
	        url: "<%=request.getContextPath()%>/exam/changeMoreSelection.do",
			success : function(data) {
				if(data.result == true){
			       	 $('#MoreSelectionQuestionContent').val(data.moreSelection.questionContent),
			       	 $('#MoreSelectionValue').val(data.moreSelection.value);
			       	 $('#MoreSelectionOptionA').val(data.moreSelection.optionA);
			         $('#MoreSelectionOptionB').val(data.moreSelection.optionB);
			       	 $('#MoreSelectionOptionC').val(data.moreSelection.optionC);
			       	 $('#MoreSelectionOptionD').val(data.moreSelection.optionD);
			         $('#MoreSelectionNote').val(data.moreSelection.note);
					
			         $('#MoreSelectionButton').hide();
			         $('#ChangeMoreSelectionButton').show();
					 $('#MoreSelectionADetail').show();
					 window.location.hash = "#MoreSelectionADetail"; 
				}else {
					layui.use('layer', function(){ 
		  	               var $ = layui.jquery, layer = layui.layer; 
		  	             //触发事件
		    			      layer.open({
		    			        type: 1
		    			        ,offset: 'auto'
		    			        ,id: 'layerDemo'+'auto' //防止重复弹出
		    			        ,title: '错误'
		    			        ,content: '<div style="padding: 20px 100px;">'+ "获取该题失败." +'</div>'
		    			        ,btn: '关闭'
		    			        ,btnAlign: 'c' //按钮居中
		    			        ,shade: 0 //不显示遮罩
		    			        ,yes: function(){
		    			        	 layer.closeAll();
		    			        }
		    			      });
		  	            });
				}
			},
			error : function(data) {
				alert("??");
			},
			dataType : "json",
		});
 }else if (temId.substring(0,2) == 'CJ') {
	//修改判断题
	 $.ajax({
	        type: "GET",
	        data: {
	       	 "judgeId":temId.substring(2)
	        },
	        contentType: "application/json; charset=utf-8",
	        async: false,
	        url: "<%=request.getContextPath()%>/exam/changeJudge.do",
			success : function(data) {
				if(data.result == true){
			       	 $('#JudgeQuestionContent').val(data.judge.judgeContent);
			       	 $('#JudgeValue').val(data.judge.value);
			         $('#JudgeNote').val(data.judge.note);
			         $("input[name='JudgeAnswer']").val(data.judge.answer);
					
			         $('#JudgeButton').hide();
			         $('#ChangeJudgeButton').show();
					 $('#JudgeDetail').show();
					 window.location.hash = "#JudgeDetail"; 
				}else {
					layui.use('layer', function(){ 
		  	               var $ = layui.jquery, layer = layui.layer; 
		  	             //触发事件
		    			      layer.open({
		    			        type: 1
		    			        ,offset: 'auto'
		    			        ,id: 'layerDemo'+'auto' //防止重复弹出
		    			        ,title: '错误'
		    			        ,content: '<div style="padding: 20px 100px;">'+ "获取该题失败." +'</div>'
		    			        ,btn: '关闭'
		    			        ,btnAlign: 'c' //按钮居中
		    			        ,shade: 0 //不显示遮罩
		    			        ,yes: function(){
		    			        	 layer.closeAll();
		    			        }
		    			      });
		  	            });
				}
			},
			error : function(data) {
				alert("??");
			},
			dataType : "json",
		});
 }else if (temId.substring(0,2) == 'CP') {
	//修改填空题
	 $.ajax({
	        type: "GET",
	        data: {
	       	 "packId":temId.substring(2)
	        },
	        contentType: "application/json; charset=utf-8",
	        async: false,
	        url: "<%=request.getContextPath()%>/exam/changePack.do",
			success : function(data) {
				if(data.result == true){
			       	 $('#PackQuestionContent').val(data.pack.packContent);
			       	 $('#PackValue').val(data.pack.value);
			         $('#PackNote').val(data.pack.note);
			         $('#Packanswer').val(data.pack.answer);

			         $('#PackButton').hide();
			         $('#ChangePackButton').show();
					 $('#PackDetail').show();
					 window.location.hash = "#PackDetail"; 
				}else {
					layui.use('layer', function(){ 
		  	               var $ = layui.jquery, layer = layui.layer; 
		  	             //触发事件
		    			      layer.open({
		    			        type: 1
		    			        ,offset: 'auto'
		    			        ,id: 'layerDemo'+'auto' //防止重复弹出
		    			        ,title: '错误'
		    			        ,content: '<div style="padding: 20px 100px;">'+ "获取该题失败." +'</div>'
		    			        ,btn: '关闭'
		    			        ,btnAlign: 'c' //按钮居中
		    			        ,shade: 0 //不显示遮罩
		    			        ,yes: function(){
		    			        	 layer.closeAll();
		    			        }
		    			      });
		  	            });
				}
			},
			error : function(data) {
				alert("??");
			},
			dataType : "json",
		});
 }else if (temId.substring(0,2) == 'CA') {
	//修改简答
	 $.ajax({
	        type: "GET",
	        data: {
	       	 "shortAnswerId":temId.substring(2)
	        },
	        contentType: "application/json; charset=utf-8",
	        async: false,
	        url: "<%=request.getContextPath()%>/exam/changeShortAnswer.do",
			success : function(data) {
				if(data.result == true){
			       	 $('#ShortAnswerQuestionContent').val(data.shortAnswer.shortAnswerContent);
			       	 $('#ShortAnswerValue').val(data.shortAnswer.value);
			         $('#ShortAnswerNote').val(data.shortAnswer.note);
					
			         $('#ShortAnswerButton').hide();
			         $('#ChangeShortAnswerButton').show();
					 $('#ShortAnswerDetail').show();
					 window.location.hash = "#ShortAnswerDetail"; 
				}else {
					layui.use('layer', function(){ 
		  	               var $ = layui.jquery, layer = layui.layer; 
		  	             //触发事件
		    			      layer.open({
		    			        type: 1
		    			        ,offset: 'auto'
		    			        ,id: 'layerDemo'+'auto' //防止重复弹出
		    			        ,title: '错误'
		    			        ,content: '<div style="padding: 20px 100px;">'+ "获取该题失败." +'</div>'
		    			        ,btn: '关闭'
		    			        ,btnAlign: 'c' //按钮居中
		    			        ,shade: 0 //不显示遮罩
		    			        ,yes: function(){
		    			        	 layer.closeAll();
		    			        }
		    			      });
		  	            });
				}
			},
			error : function(data) {
				alert("??");
			},
			dataType : "json",
		});
 }
}
//保存题的修改
function saveTiMuChange() {
	var temId = $('#temId').val();
	if(temId.substring(0,2) == 'CS'){
	if($('#SingleSelectionQuestionContent').val != "" && $('#SingleSelectionValue').val != ""&& $('#SingleSelectionOptionA').val != ""
		&& $('#SingleSelectionOptionB').val != ""&& $('#SingleSelectionOptionC').val != ""&& $('#SingleSelectionOptionD').val != ""&& $('#SingleSelectioAnswer').val != ""
			&& $('#SingleSelectionNote').val != ""){
		$.ajax({
	        type: "GET",
	        data: {
	         "examinationId":$('#examinationIddd').val(),
	         "singleSelectionId":temId.substring(2),
	       	 "questionContent":$('#SingleSelectionQuestionContent').val(),
	       	 "singleSelectionValue":$('#SingleSelectionValue').val(),
	       	 "optionA":$('#SingleSelectionOptionA').val(),
	         "optionB":$('#SingleSelectionOptionB').val(),
	       	 "optionC":$('#SingleSelectionOptionC').val(),
	       	 "optionD":$('#SingleSelectionOptionD').val(),
	         "answer":$('#SingleSelectioAnswer').val(),
	         "note":$('#SingleSelectionNote').val()
	        },
	        contentType: "application/json; charset=utf-8",
	        async: false,
	        url: "<%=request.getContextPath()%>/exam/saveChangeSingleSelection.do",
			success : function(data) {
				if(data.result == true){
					layui.use('layer', function(){ //独立版的layer无需执行这一句
		  	               var $ = layui.jquery, layer = layui.layer; 
		  	             //触发事件
		    			      layer.open({
		    			        type: 1
		    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
		    			        ,id: 'layerDemo'+'auto' //防止重复弹出
		    			        ,title: '成功'
		    			        ,content: '<div style="padding: 20px 100px;">'+ "修改该单选题成功.." +'</div>'
		    			        ,btn: '关闭'
		    			        ,btnAlign: 'c' //按钮居中
		    			        ,skin: 'demo-class'
		    			        ,shade: 0 //不显示遮罩
		    			        ,yes: function(){
		    			        	createQuestion($('#examinationIddd').val());
		    			        	window.location.hash = "#SingleSelectionShowUl";  
		    			        	$('#SingleSelectionButton').show();
		    			        	$('#ChangeSingleSelectionButton').hide();
		    			        	layer.closeAll();
		    			        }
		    			      });
		  	            });
					
				}else {
					if(data.result == "no"){
						layui.use('layer', function(){ //独立版的layer无需执行这一句
			  	               var $ = layui.jquery, layer = layui.layer; 
			  	             //触发事件
			    			      layer.open({
			    			        type: 1
			    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
			    			        ,id: 'layerDemo'+'auto' //防止重复弹出
			    			        ,title: '提示'
			    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "分数超出总分.." +'</div>'
			    			        ,btn: '关闭'
			    			        ,btnAlign: 'c' //按钮居中
			    			        ,skin: 'demo-class'
			    			        ,shade: 0 //不显示遮罩
			    			        ,yes: function(){
			    			        	 layer.closeAll();
			    			        }
			    			      });
			  	            });
						//alert("分数超出总分，请合理分配分数..");
					}else
						layui.use('layer', function(){ //独立版的layer无需执行这一句
			  	               var $ = layui.jquery, layer = layui.layer; 
			  	             //触发事件
			    			      layer.open({
			    			        type: 1
			    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
			    			        ,id: 'layerDemo'+'auto' //防止重复弹出
			    			        ,title: '失败'
			    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "单选修改失败.." +'</div>'
			    			        ,btn: '关闭'
			    			        ,btnAlign: 'c' //按钮居中
			    			        ,skin: 'demo-class'
			    			        ,shade: 0 //不显示遮罩
			    			        ,yes: function(){
			    			        	 layer.closeAll();
			    			        }
			    			      });
			  	            });
				}
			},
			error : function(data) {
				alert("??");
			},
			dataType : "json",
		});
	}
  }else if(temId.substring(0,2) == 'CM') {
	  //多选保存修改
		if($('#MoreSelectionQuestionContent').val != "" && $('#MoreSelectionValue').val != ""&& $('#MoreSelectionOptionA').val != ""
			&& $('#MoreSelectionOptionB').val != ""&& $('#MoreSelectionOptionC').val != ""&& $('#MoreSelectionOptionD').val != ""&& $('#MoreSelectionAnswer').val != ""
				&& $('#MoreSelectionNote').val != ""){
			  var answer = "";
		        $("input:checkbox[name='MoreSelectionAnswer']:checked").each(function() {
		        	answer += $(this).val() + " ";
		        });
			$.ajax({
		        type: "GET",
		        data: {
		        	 "examinationId":$('#examinationIddd').val(),
			         "moreSelectionId":temId.substring(2),
			       	 "questionContent":$('#MoreSelectionQuestionContent').val(),
			       	 "MoreSelectionValue":$('#MoreSelectionValue').val(),
			       	 "optionA":$('#MoreSelectionOptionA').val(),
			         "optionB":$('#MoreSelectionOptionB').val(),
			       	 "optionC":$('#MoreSelectionOptionC').val(),
			       	 "optionD":$('#MoreSelectionOptionD').val(),
			         "note":$('#MoreSelectionNote').val(),
			         "answer": answer
		        },
		        contentType: "application/json; charset=utf-8",
		        async: false,
		        url: "<%=request.getContextPath()%>/exam/saveChangeMoreSelectionId.do",
				success : function(data) {
					if(data.result == true){
						layui.use('layer', function(){ //独立版的layer无需执行这一句
			  	               var $ = layui.jquery, layer = layui.layer; 
			  	             //触发事件
			    			      layer.open({
			    			        type: 1
			    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
			    			        ,id: 'layerDemo'+'auto' //防止重复弹出
			    			        ,title: '成功'
			    			        ,content: '<div style="padding: 20px 100px;">'+ "修改该多选题成功.." +'</div>'
			    			        ,btn: '关闭'
			    			        ,btnAlign: 'c' //按钮居中
			    			        ,skin: 'demo-class'
			    			        ,shade: 0 //不显示遮罩
			    			        ,yes: function(){
			    			        	createQuestion($('#examinationIddd').val());
			    			        	window.location.hash = "#MoreSelectionShowUl"; 
			    			        	$('#MoreSelectionButton').show();
			    			        	$('#ChangeMoreSelectionButton').hide();
			    			        	layer.closeAll();
			    			        }
			    			      });
			  	            });
						
					}else {
						if(data.result == "no"){
							layui.use('layer', function(){ //独立版的layer无需执行这一句
				  	               var $ = layui.jquery, layer = layui.layer; 
				  	             //触发事件
				    			      layer.open({
				    			        type: 1
				    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
				    			        ,id: 'layerDemo'+'auto' //防止重复弹出
				    			        ,title: '提示'
				    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "分数超出总分.." +'</div>'
				    			        ,btn: '关闭'
				    			        ,btnAlign: 'c' //按钮居中
				    			        ,skin: 'demo-class'
				    			        ,shade: 0 //不显示遮罩
				    			        ,yes: function(){
				    			        	 layer.closeAll();
				    			        }
				    			      });
				  	            });
							//alert("分数超出总分，请合理分配分数..");
						}else
							layui.use('layer', function(){ //独立版的layer无需执行这一句
				  	               var $ = layui.jquery, layer = layui.layer; 
				  	             //触发事件
				    			      layer.open({
				    			        type: 1
				    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
				    			        ,id: 'layerDemo'+'auto' //防止重复弹出
				    			        ,title: '失败'
				    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "多选修改失败.." +'</div>'
				    			        ,btn: '关闭'
				    			        ,btnAlign: 'c' //按钮居中
				    			        ,skin: 'demo-class'
				    			        ,shade: 0 //不显示遮罩
				    			        ,yes: function(){
				    			        	 layer.closeAll();
				    			        }
				    			      });
				  	            });
					}
				},
				error : function(data) {
					alert("??");
				},
				dataType : "json",
			});
		}
 }else if(temId.substring(0,2) == 'CJ') {
	  //判断保存修改
		if($('#JudgeQuestionContent').val != "" && $('#JudgeValue').val != ""
						&& $('#JudgeAnswer').val != ""
							&& $('#JudgeNote').val != ""){
			$.ajax({
		        type: "GET",
		        data: {
		        	 "examinationId":$('#examinationIddd').val(),
		        	 "judgeId":temId.substring(2),
			       	 "questionContent":$('#JudgeQuestionContent').val(),
			       	 "JudgeValue":$('#JudgeValue').val(),
			         "note":$('#JudgeNote').val(),
			         "answer":$("input[name='JudgeAnswer']").val()
		        },
		        contentType: "application/json; charset=utf-8",
		        async: false,
		        url: "<%=request.getContextPath()%>/exam/saveChangejudgeId.do",
				success : function(data) {
					if(data.result == true){
						layui.use('layer', function(){
			  	               var $ = layui.jquery, layer = layui.layer; 
			  	                  //触发事件
			    			      layer.open({
			    			        type: 1
			    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
			    			        ,id: 'layerDemo'+'auto' //防止重复弹出
			    			        ,title: '成功'
			    			        ,content: '<div style="padding: 20px 100px;">'+ "修改该判断题成功.." +'</div>'
			    			        ,btn: '关闭'
			    			        ,btnAlign: 'c' //按钮居中
			    			        ,skin: 'demo-class'
			    			        ,shade: 0 //不显示遮罩
			    			        ,yes: function(){
			    			        	createQuestion($('#examinationIddd').val());
			    			        	window.location.hash = "#JudgeShowUl";   
			    			        	$('#JudgeButton').show();
			    			        	$('#ChangeJudgeButton').hide();
			    			        	layer.closeAll();
			    			        }
			    			      });
			  	            });
						
					}else {
						if(data.result == "no"){
							layui.use('layer', function(){ //独立版的layer无需执行这一句
				  	               var $ = layui.jquery, layer = layui.layer; 
				  	             //触发事件
				    			      layer.open({
				    			        type: 1
				    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
				    			        ,id: 'layerDemo'+'auto' //防止重复弹出
				    			        ,title: '提示'
				    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "分数超出总分.." +'</div>'
				    			        ,btn: '关闭'
				    			        ,btnAlign: 'c' //按钮居中
				    			        ,skin: 'demo-class'
				    			        ,shade: 0 //不显示遮罩
				    			        ,yes: function(){
				    			        	 layer.closeAll();
				    			        }
				    			      });
				  	            });
							//alert("分数超出总分，请合理分配分数..");
						}else
							layui.use('layer', function(){ //独立版的layer无需执行这一句
				  	               var $ = layui.jquery, layer = layui.layer; 
				  	             //触发事件
				    			      layer.open({
				    			        type: 1
				    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
				    			        ,id: 'layerDemo'+'auto' //防止重复弹出
				    			        ,title: '失败'
				    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "判断题修改失败.." +'</div>'
				    			        ,btn: '关闭'
				    			        ,btnAlign: 'c' //按钮居中
				    			        ,skin: 'demo-class'
				    			        ,shade: 0 //不显示遮罩
				    			        ,yes: function(){
				    			        	 layer.closeAll();
				    			        }
				    			      });
				  	            });
					}
				},
				error : function(data) {
					alert("??");
				},
				dataType : "json",
			});
		}
   }else if(temId.substring(0,2) == 'CP') {
		  //填空保存修改
		if($('#PackQuestionContent').val != "" && $('#PackValue').val != ""
			&& $('#PackAnswer').val != ""
				&& $('#PackNote').val != ""){
			$.ajax({
		        type: "GET",
		        data: {
		        	 "packId":temId.substring(2),
		        	 "examinationId":$('#examinationIddd').val(),
			       	 "questionContent":$('#PackQuestionContent').val(),
			       	 "PackValue":$('#PackValue').val(),
			         "note":$('#PackNote').val(),
			         "answer":$('#Packanswer').val()
		        },
		        contentType: "application/json; charset=utf-8",
		        async: false,
		        url: "<%=request.getContextPath()%>/exam/saveChangePack.do",
				success : function(data) {
					if(data.result == true){
						layui.use('layer', function(){ //独立版的layer无需执行这一句
			  	               var $ = layui.jquery, layer = layui.layer; 
			  	             //触发事件
			    			      layer.open({
			    			        type: 1
			    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
			    			        ,id: 'layerDemo'+'auto' //防止重复弹出
			    			        ,title: '成功'
			    			        ,content: '<div style="padding: 20px 100px;">'+ "修改该填空题成功.." +'</div>'
			    			        ,btn: '关闭'
			    			        ,btnAlign: 'c' //按钮居中
			    			        ,skin: 'demo-class'
			    			        ,shade: 0 //不显示遮罩
			    			        ,yes: function(){
			    			        	createQuestion($('#examinationIddd').val());
			    			        	window.location.hash = "#PackShowUl";  
			    			        	$('#PackButton').show();
			    			        	$('#ChangePackButton').hide();
			    			        	layer.closeAll();
			    			        }
			    			      });
			  	            });
						
					}else {
						if(data.result == "no"){
							layui.use('layer', function(){ //独立版的layer无需执行这一句
				  	               var $ = layui.jquery, layer = layui.layer; 
				  	             //触发事件
				    			      layer.open({
				    			        type: 1
				    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
				    			        ,id: 'layerDemo'+'auto' //防止重复弹出
				    			        ,title: '提示'
				    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "分数超出总分.." +'</div>'
				    			        ,btn: '关闭'
				    			        ,btnAlign: 'c' //按钮居中
				    			        ,skin: 'demo-class'
				    			        ,shade: 0 //不显示遮罩
				    			        ,yes: function(){
				    			        	 layer.closeAll();
				    			        }
				    			      });
				  	            });
							//alert("分数超出总分，请合理分配分数..");
						}else
							layui.use('layer', function(){ //独立版的layer无需执行这一句
				  	               var $ = layui.jquery, layer = layui.layer; 
				  	             //触发事件
				    			      layer.open({
				    			        type: 1
				    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
				    			        ,id: 'layerDemo'+'auto' //防止重复弹出
				    			        ,title: '失败'
				    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "填空修改失败.." +'</div>'
				    			        ,btn: '关闭'
				    			        ,btnAlign: 'c' //按钮居中
				    			        ,skin: 'demo-class'
				    			        ,shade: 0 //不显示遮罩
				    			        ,yes: function(){
				    			        	 layer.closeAll();
				    			        }
				    			      });
				  	            });
					}
				},
				error : function(data) {
					alert("??");
				},
				dataType : "json",
			});
		}
    }else if(temId.substring(0,2) == 'CA') {
		  //简答保存修改
		if($('#ShortAnswerQuestionContent').val != "" && $('#ShortAnswerValue').val != ""
			&& $('#ShortAnswerNote').val != ""){
			$.ajax({
		        type: "GET",
		        data: {
		        	 "shortAnswerId":temId.substring(2),
		        	 "examinationId":$('#examinationIddd').val(),
			       	 "questionContent":$('#ShortAnswerQuestionContent').val(),
			       	 "ShortAnswerValue":$('#ShortAnswerValue').val(),
			         "note":$('#ShortAnswerNote').val()
		        },
		        contentType: "application/json; charset=utf-8",
		        async: false,
		        url: "<%=request.getContextPath()%>/exam/saveChangeShortAnswer.do",
				success : function(data) {
					if(data.result == true){
						layui.use('layer', function(){ //独立版的layer无需执行这一句
			  	               var $ = layui.jquery, layer = layui.layer; 
			  	             //触发事件
			    			      layer.open({
			    			        type: 1
			    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
			    			        ,id: 'layerDemo'+'auto' //防止重复弹出
			    			        ,title: '成功'
			    			        ,content: '<div style="padding: 20px 100px;">'+ "修改该简答题成功.." +'</div>'
			    			        ,btn: '关闭'
			    			        ,btnAlign: 'c' //按钮居中
			    			        ,skin: 'demo-class'
			    			        ,shade: 0 //不显示遮罩
			    			        ,yes: function(){
			    			        	createQuestion($('#examinationIddd').val());
			    			        	window.location.hash = "#ShortAnswerShowUl";  
			    			        	$('#ShortAnswerButton').show();
			    			        	$('#ChangeShortAnswerButton').hide();
			    			        	layer.closeAll();
			    			        }
			    			      });
			  	            });
						
					}else {
						if(data.result == "no"){
							layui.use('layer', function(){ //独立版的layer无需执行这一句
				  	               var $ = layui.jquery, layer = layui.layer; 
				  	             //触发事件
				    			      layer.open({
				    			        type: 1
				    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
				    			        ,id: 'layerDemo'+'auto' //防止重复弹出
				    			        ,title: '提示'
				    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "分数超出总分.." +'</div>'
				    			        ,btn: '关闭'
				    			        ,btnAlign: 'c' //按钮居中
				    			        ,skin: 'demo-class'
				    			        ,shade: 0 //不显示遮罩
				    			        ,yes: function(){
				    			        	 layer.closeAll();
				    			        }
				    			      });
				  	            });
							//alert("分数超出总分，请合理分配分数..");
						}else
							layui.use('layer', function(){ //独立版的layer无需执行这一句
				  	               var $ = layui.jquery, layer = layui.layer; 
				  	             //触发事件
				    			      layer.open({
				    			        type: 1
				    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
				    			        ,id: 'layerDemo'+'auto' //防止重复弹出
				    			        ,title: '失败'
				    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "简答修改失败.." +'</div>'
				    			        ,btn: '关闭'
				    			        ,btnAlign: 'c' //按钮居中
				    			        ,skin: 'demo-class'
				    			        ,shade: 0 //不显示遮罩
				    			        ,yes: function(){
				    			        	 layer.closeAll();
				    			        }
				    			      });
				  	            });
					}
				},
				error : function(data) {
					alert("??");
				},
				dataType : "json",
			});
		}
}
}
//for删除题目
function forDeleteTiMu(temId) {
	$('#temId').val(temId);
	$('#temId').attr("readonly","readonly");
}
//删除题
function deleteTiMu() {
	var temId = $('#temId').val();
	//删除单选
	if(temId.substring(0,2) == 'DS'){
	var singleSelectionId = temId.substring(2);
	$.ajax({
        type: "GET",
        data: {
         "examinationId":$('#examinationIddd').val(),
       	 "singleSelectionId":singleSelectionId
        },
        contentType: "application/json; charset=utf-8",
        async: false,
        url: "<%=request.getContextPath()%>/exam/deleteSingleSelection.do",
		success : function(data) {
			if(data.result == true){
				createQuestion($('#examinationIddd').val());
	        	window.location.hash = "#SingleSelectionShowUl"; 
			}else {
				layui.use('layer', function(){ 
	  	               var $ = layui.jquery, layer = layui.layer; 
	  	             //触发事件
	    			      layer.open({
	    			        type: 1
	    			        ,offset: 'auto'
	    			        ,id: 'layerDemo'+'auto' //防止重复弹出
	    			        ,title: '失败'
	    			        ,content: '<div style="padding: 20px 100px;">'+ "删除单选失败." +'</div>'
	    			        ,btn: '关闭'
	    			        ,btnAlign: 'c' //按钮居中
	    			        ,shade: 0 //不显示遮罩
	    			        ,yes: function(){
	    			        	 layer.closeAll();
	    			        }
	    			      });
	  	            });
			}
		},
		error : function(data) {
			alert("??");
		},
		dataType : "json",
	});
  }else if(temId.substring(0,2) == 'DM') {
	  //删除多选
		var moreSelectionId = temId.substring(2);
		$.ajax({
	        type: "GET",
	        data: {
	         "examinationId":$('#examinationIddd').val(),
	       	 "moreSelectionId":moreSelectionId
	        },
	        contentType: "application/json; charset=utf-8",
	        async: false,
	        url: "<%=request.getContextPath()%>/exam/deleteMoreSelection.do",
			success : function(data) {
				if(data.result == true){
					createQuestion($('#examinationIddd').val());
		        	window.location.hash = "#MoreSelectionShowUl"; 
				}else {
					layui.use('layer', function(){ 
		  	               var $ = layui.jquery, layer = layui.layer; 
		  	             //触发事件
		    			      layer.open({
		    			        type: 1
		    			        ,offset: 'auto'
		    			        ,id: 'layerDemo'+'auto' //防止重复弹出
		    			        ,title: '失败'
		    			        ,content: '<div style="padding: 20px 100px;">'+ "删除多选失败." +'</div>'
		    			        ,btn: '关闭'
		    			        ,btnAlign: 'c' //按钮居中
		    			        ,shade: 0 //不显示遮罩
		    			        ,yes: function(){
		    			        	 layer.closeAll();
		    			        }
		    			      });
		  	            });
				}
			},
			error : function(data) {
				alert("??");
			},
			dataType : "json",
		});
 }else if(temId.substring(0,2) == 'DJ') {
	  //删除判断
		var judgeId = temId.substring(2);
		$.ajax({
	        type: "GET",
	        data: {
	         "examinationId":$('#examinationIddd').val(),
	       	 "judgeId":judgeId
	        },
	        contentType: "application/json; charset=utf-8",
	        async: false,
	        url: "<%=request.getContextPath()%>/exam/deletejudge.do",
			success : function(data) {
				if(data.result == true){
					createQuestion($('#examinationIddd').val());
		        	window.location.hash = "#JudgeShowUl"; 
				}else {
					layui.use('layer', function(){ 
		  	               var $ = layui.jquery, layer = layui.layer; 
		  	             //触发事件
		    			      layer.open({
		    			        type: 1
		    			        ,offset: 'auto'
		    			        ,id: 'layerDemo'+'auto' //防止重复弹出
		    			        ,title: '失败'
		    			        ,content: '<div style="padding: 20px 100px;">'+ "删除判断失败." +'</div>'
		    			        ,btn: '关闭'
		    			        ,btnAlign: 'c' //按钮居中
		    			        ,shade: 0 //不显示遮罩
		    			        ,yes: function(){
		    			        	 layer.closeAll();
		    			        }
		    			      });
		  	            });
				}
			},
			error : function(data) {
				alert("??");
			},
			dataType : "json",
		});
    }else if(temId.substring(0,2) == 'DP') {
	  //删除填空
		var packId = temId.substring(2);
		$.ajax({
	        type: "GET",
	        data: {
	         "examinationId":$('#examinationIddd').val(),
	       	 "packId":packId
	        },
	        contentType: "application/json; charset=utf-8",
	        async: false,
	        url: "<%=request.getContextPath()%>/exam/deletePack.do",
			success : function(data) {
				if(data.result == true){
					createQuestion($('#examinationIddd').val());
		        	window.location.hash = "#PackShowUl"; 
				}else {
					layui.use('layer', function(){ 
		  	               var $ = layui.jquery, layer = layui.layer; 
		  	             //触发事件
		    			      layer.open({
		    			        type: 1
		    			        ,offset: 'auto'
		    			        ,id: 'layerDemo'+'auto' //防止重复弹出
		    			        ,title: '失败'
		    			        ,content: '<div style="padding: 20px 100px;">'+ "删除填空失败." +'</div>'
		    			        ,btn: '关闭'
		    			        ,btnAlign: 'c' //按钮居中
		    			        ,shade: 0 //不显示遮罩
		    			        ,yes: function(){
		    			        	 layer.closeAll();
		    			        }
		    			      });
		  	            });
				}
			},
			error : function(data) {
				alert("??");
			},
			dataType : "json",
		});
  }else if(temId.substring(0,2) == 'DA') {
	  //删除简答
		var shortAnswerId = temId.substring(2);
		$.ajax({
	        type: "GET",
	        data: {
	         "examinationId":$('#examinationIddd').val(),
	       	 "shortAnswerId":shortAnswerId
	        },
	        contentType: "application/json; charset=utf-8",
	        async: false,
	        url: "<%=request.getContextPath()%>/exam/deleteShortAnswer.do",
			success : function(data) {
				if(data.result == true){
					createQuestion($('#examinationIddd').val());
		        	window.location.hash = "#ShortAnswerShowUl"; 
				}else {
					layui.use('layer', function(){ 
		  	               var $ = layui.jquery, layer = layui.layer; 
		  	             //触发事件
		    			      layer.open({
		    			        type: 1
		    			        ,offset: 'auto'
		    			        ,id: 'layerDemo'+'auto' //防止重复弹出
		    			        ,title: '失败'
		    			        ,content: '<div style="padding: 20px 100px;">'+ "简答删除失败." +'</div>'
		    			        ,btn: '关闭'
		    			        ,btnAlign: 'c' //按钮居中
		    			        ,shade: 0 //不显示遮罩
		    			        ,yes: function(){
		    			        	 layer.closeAll();
		    			        }
		    			      });
		  	            });
				}
			},
			error : function(data) {
				alert("??");
			},
			dataType : "json",
		});
    }
}
//教师出题
function createQuestion(id) {
	$.ajax({
        type: "GET",
        data: {
       	 "examinationId":id
        },
        contentType: "application/json; charset=utf-8",
        async: false,
        url: "<%=request.getContextPath()%>/exam/selectExaminationByMyId.do",
		success : function(data) {
			layui.use(['form'], function(){
				var form = layui.form;
				});
			if(data.result == true){
				$('#examinationIddd').val(data.examination.examinationID);
				$('#examinationTitle').html(data.examination.examinationName);
				$('#examinationTotalValue').html("总分：" + data.examination.totalValue);
				$('#examinationStartTime').html("考试时间：" + data.examination.startTime);
				$('#examinationTime').html("考试时长：" + data.examination.duration + "分钟");
				
				//单选题
				var dataObj = data.singleSelections;   
				//<div class='site-demo-button' id='layerDemo'>
				con = "";
				 $.each(dataObj, function (index, item) {
	      	        con += "<li style='font-size:1.3em'>(" + item.questionNumber + ")" + item.questionContent +
	      	        "("+ item.value  + "分)&nbsp;<div class='layui-btn-group' id='layerDemo'> <button id='CS"+item.singleSelectionId+"' onclick='changeTiMu(this.id)' class='layui-btn layui-btn-danger layui-btn-mini' style=''><i class='layui-icon'>&#xe642;</i></button>"+
	      	        " <button id='DS"+item.singleSelectionId+"' data-method='notice' onclick='forDeleteTiMu(this.id)'  style='' class='layui-btn layui-btn-mini  layui-btn-danger'><i class='layui-icon'>&#xe640;</i></button></div></li>";
	      	        con += "<li style='margin-left: 1.5em'>"
	      	       +"A "+ item.optionA +"   B " + item.optionB + "   C "+ item.optionC + "   D "+ item.optionD  + "</li>";
	      	        con += "<li style='margin-left: 1.5em'>答案："+ item.answer + "</li>";
	      	        con += "<li>&nbsp;</li>";
				 });
				 $('#SingleSelectionShowUl').html(con);                           					
				// window.location.hash = "#examinationTotalValue";  
				 //多选题
				 var dataObj2 = data.moreSelections;
				 von = "";
				 $.each(dataObj2, function (index, item) {
		      	        von += "<li style='font-size:1.3em'>(" + item.questionNumber + ")" + item.questionContent +"("+ item.value  + "分)&nbsp;<div class='layui-btn-group' id='layerDemo'> <button id='CM"+item.moreSelectionId+"' onclick='changeTiMu(this.id)' class='layui-btn layui-btn-danger layui-btn-mini' style=''><i class='layui-icon'>&#xe642;</i></button>"+
		      	        " <button id='DM"+item.moreSelectionId+"' data-method='notice' onclick='forDeleteTiMu(this.id)'  style='' class='layui-btn layui-btn-mini  layui-btn-danger'><i class='layui-icon'>&#xe640;</i></button></div></li>";
		      	        von += "<li style='margin-left: 1.5em'>"
		      	       +"A "+ item.optionA +"   B " + item.optionB + "   C "+ item.optionC + "   D "+ item.optionD  + "</li>";
		      	        von += "<li style='margin-left: 1.5em'>答案："+ item.answer + "</li>"; 
	                    von += "<li>&nbsp;</li>";
					 });
					 $('#MoreSelectionShowUl').html(von);
					 //window.location.hash = "#mark2"; 
					  
			    //判断题
					 var dataObj2 = data.judges;
					 bon = "";
					 $.each(dataObj2, function (index, item) {
			      	        bon += "<li style='font-size:1.3em'>(" + item.questionNumber + ")" + item.judgeContent +"("+ item.value  + "分)&nbsp;<div class='layui-btn-group' id='layerDemo'> <button id='CJ"+item.judgeId+"' onclick='changeTiMu(this.id)' class='layui-btn layui-btn-danger layui-btn-mini' style=''><i class='layui-icon'>&#xe642;</i></button>"+
			      	        " <button id='DJ"+item.judgeId+"' data-method='notice' onclick='forDeleteTiMu(this.id)'  style='' class='layui-btn layui-btn-mini  layui-btn-danger'><i class='layui-icon'>&#xe640;</i></button></div></li>";
			      	        bon += "<li style='margin-left: 1.5em'>答案："+ item.answer + "</li>"; 
		                    bon += "<li>&nbsp;</li>";
						 });
						 $('#JudgeShowUl').html(bon);
						// window.location.hash = "#mark3"; 
			       //填空
						 var dataObj3 = data.packs;
						 non = "";
						 $.each(dataObj3, function (index, item) {
				      	        non += "<li style='font-size:1.3em'>(" + item.questionNumber + ")" + item.packContent +"("+ item.value  + "分)&nbsp;<div class='layui-btn-group' id='layerDemo'> <button id='CP"+item.packId+"' onclick='changeTiMu(this.id)' class='layui-btn layui-btn-danger layui-btn-mini' style=''><i class='layui-icon'>&#xe642;</i></button>"+
				      	        " <button id='DP"+item.packId+"' data-method='notice' onclick='forDeleteTiMu(this.id)'  style='' class='layui-btn layui-btn-mini  layui-btn-danger'><i class='layui-icon'>&#xe640;</i></button></div></li>";
				      	        non += "<li style='margin-left: 1.5em'>参考答案："+ item.answer + "</li>"; 
			                    non += "<li>&nbsp;</li>";
							 });
							 $('#PackShowUl').html(non);
							// window.location.hash = "#mark4"; 
							 
							 
				//简答shortAnswers
							 var dataObj4 = data.shortAnswers;
							 mon = "";
							 $.each(dataObj4, function (index, item) {
					      	        mon += "<li style='font-size:1.3em'>(" + item.questionNumber + ")" + item.shortAnswerContent +"("+ item.value  + "分)&nbsp;<div class='layui-btn-group' id='layerDemo'> <button id='CA"+item.shortAnswerId+"' onclick='changeTiMu(this.id)' class='layui-btn layui-btn-danger layui-btn-mini' style=''><i class='layui-icon'>&#xe642;</i></button>"+
					      	        " <button id='DA"+item.shortAnswerId+"' data-method='notice' onclick='forDeleteTiMu(this.id)'  style='' class='layui-btn layui-btn-mini  layui-btn-danger'><i class='layui-icon'>&#xe640;</i></button></div></li>";
				                    mon += "<li>&nbsp;</li>";
								 });
								 $('#ShortAnswerShowUl').html(mon);
								// window.location.hash = "#mark4";
								 
								 $('#addExaminationDiv').hide();
								 $('#addQuestionsDiv').show();
			}else{
				layui.use('layer', function(){ //独立版的layer无需执行这一句
	  	               var $ = layui.jquery, layer = layui.layer; 
	  	             //触发事件
	    			      layer.open({
	    			        type: 1
	    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
	    			        ,id: 'layerDemo'+'auto' //防止重复弹出
	    			        ,title: '提示'
	    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "试卷已被锁定无法编辑." +'</div>'
	    			        ,btn: '关闭'
	    			        ,btnAlign: 'c' //按钮居中
	    			        ,shade: 0 //不显示遮罩
	    			        ,yes: function(){
	    			        	setTimeout('closeAddExam()',500);
	    			        	layer.closeAll();
	    			        }
	    			      });
	  	            });
				//alert("试卷已被锁定无法进行题目编辑.");
				//$('#confirmAddExamination').show();
			}
			 
		},
		error : function(data) {
			alert("??");
		},
		dataType : "json",
	});
	 //删除
	layui.use([ 'element', 'layer'], function() {
		var element = layui.element, $ = layui.jquery, layer = layui.layer;
		//触发事件
		var active = {
			notice : function() {
				//示范一个公告层
				layer.open({
							type : 1,
							title : false //不显示标题栏
							,
							closeBtn : false,
							area : '300px;',
							shade : 0.8,
							id : 'LAY_layuipro' //设定一个id，防止重复弹出
							,
							btn : [ '删除', '取消' ],
							yes : function(index, layero) {
								deleteTiMu();
								layer.closeAll();
							},
							btn2 : function(index, layero) {
								//按钮【按钮二】的回调
							},
							btnAlign : 'c',
							moveType : 1 //拖拽模式，0或者1
							,
							content : '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">确定删除该题？</div>'
						});
			}

		};

		$('#layerDemo .layui-btn').on(
				'click',
				function() {
					var othis = $(this), method = othis
							.data('method');
					active[method] ? active[method].call(
							this, othis) : '';
				});
});
	
}
//试卷不可出题的情况下点击后隐藏提示框
function closeAddExam() {
	$('#confirmAddExamination').hide();
}
//隐藏修改试卷成功的
function closeChangeExam() {
	$('#changeExaminationSuccess').hide();
}
//删除试卷，先出一个提示框
var tem;
function forDeleteQuestion(examinationId) {
	 var examinationId = examinationId.substring(1);
	 tem = examinationId;
}
function deleteThis() {
	 var Id = tem;
	 deleteExam(Id); 
}

//删除试卷
 function deleteExam(examinationId) {
     $.ajax({
         type: "GET",
         data: {
             "examinationId": examinationId
         },
         contentType: "application/json; charset=utf-8",
         async: true,
         url: "<%=request.getContextPath()%>/exam/deleteExamById.do",
					success : function(data) {
						if(data.result == true){
							document.getElementById("N" + tem).style.display = "none";
						}
					},
					error : function(data) {
						alert("出错了！");
					},
					dataType : "json",
				});
		$('#torf').hide();
	}
//修改试卷
function changeQuestion(examinationId) {
	 var examinationId = examinationId.substring(1);
	 $('#ReexaminationId').val(examinationId);
	 $('#ReexaminationId').attr("readonly","readonly");
	 $('#addExaminationForm').hide();
	 $('#ExaminationList').hide();
	 $('#changeExaminationForm').show();
}
//修改试卷
function teacherChangeExamination() {
	if($('#ReexaminationId').val() != "" && $('#ReexaminationName').val() != "" && 
			$('#RestartTime').val() != "" && $('#Reduration').val() != ""){
	  $.ajax({
	         type: "GET",
	         data: {
	             "examinationId": $('#ReexaminationId').val(),
	             "examinationName":$('#ReexaminationName').val(),
	             "startTime":$('#RestartTime').val(),
	             "duration":$('#Reduration').val()
	         },
	         contentType: "application/json; charset=utf-8",
	         async: false,
	         url: "<%=request.getContextPath()%>/exam/changeExamById.do",
						success : function(data) {
							if(data.result == true){
								layui.use('layer', function(){ //独立版的layer无需执行这一句
					  	               var $ = layui.jquery, layer = layui.layer; 
					  	             //触发事件
					    			      layer.open({
					    			        type: 1
					    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
					    			        ,id: 'layerDemo'+'auto' //防止重复弹出
					    			        ,title: '成功'
					    			        ,content: '<div style="padding: 20px 100px;">'+ "修改试卷信息成功." +'</div>'
					    			        ,btn: '关闭'
					    			        ,btnAlign: 'c' //按钮居中
					    			        ,shade: 0 //不显示遮罩
					    			        ,yes: function(){
					    			        	setTimeout('closeChangeExam()',500);
												setTimeout('addExamination()',500);
					    			        	 layer.closeAll();
					    			        }
					    			      });
					  	            });
								//$('#changeExaminationSuccess').show();
							}
						},
						error : function(data) {
							alert("出错了！");
						},
						dataType : "json",
					});
	}
}
//发布公告
function proclamation() {
	 $('#getHeadLine').html("发布公告(消息+邮箱)");
	 $('#signModel').hide();
	 $('#otherModel').hide();
	 $('#upLoadShow').hide();
	 $('#clazzInfoShow').hide();
	 $('#addExaminationDiv').hide();
	 $('#addQuestionsDiv').hide();
	 $('#compareDetailDiv').hide();
	 $('#studentExam').hide();
	 $('#inClazzStudentInfoDiv').hide();
	 $('#scoreFormList').hide();
	 $('#addClassShow').hide();
	 $('#homeWork').hide();  
	 $('#proclamationDiv').show();
}
//课后作业
function afterClassHomeWork() {
	 $('#getHeadLine').html("课后作业");
	 $('#signModel').hide();
	 $('#otherModel').hide();
	 $('#upLoadShow').hide();
	 $('#clazzInfoShow').hide();
	 $('#addExaminationDiv').hide();
	 $('#addQuestionsDiv').hide();
	 $('#studentExam').hide();
	 $('#compareDetailDiv').hide();
	 $('#inClazzStudentInfoDiv').hide();
	 $('#scoreFormList').hide();
	 $('#addClassShow').hide();
	 $('#proclamationDiv').hide();
	 $('#homeWork').show();      
}
//返回首页
function returnTeacherIndex() {
	$('#returnTeacherIndexForm').submit();
}
</script>
</head>
<body>
	<div class="layui-layout layui-layout-admin">
		<!-- 头部导航 -->
		<div class="layui-header header header-demo">
			<div class="layui-main">
				<a class="CMSlogo" id="pageTitle" onclick="returnTeacherIndex()"
					href="#"><span
					style="color: white; font-size: 25px;">CMS</span></a>
				<ul class="layui-nav">
					<li class="layui-nav-item"><a href="">课程Module</a></li>
				</ul>
			</div>
		</div>

		<!-- 左侧垂直导航 -->
		<div class="layui-side layui-bg-black">
			<div class="layui-side-scroll">
				<ul class="layui-nav layui-nav-tree" lay-filter="test">
					<!-- 侧边导航: <ul class="layui-nav layui-nav-tree layui-nav-side"> -->
					<li class="layui-nav-item layui-nav-itemed"><a href="#">班级事务</a>
						<dl class="layui-nav-child">
							<dd>
								<a id="classInfo" onclick="classInfo()" href="#">班级信息</a>
							</dd>
							<dd>
								<a id="addClass" onclick="getAddClass()" href="#">添加班级</a>
							</dd>
							<dd>
								<a id="dataUpload" onclick="getPrivateData()" href="#">课件上传</a>
							</dd>
							<dd>
								<a id="afterClass" onclick="afterClassHomeWork()" href="#">课后作业</a>
							</dd>
							<dd>
								<a id="proclamation" onclick=" proclamation()" href="#">发布公告</a>
							</dd>
						</dl></li>
					<li class="layui-nav-item layui-nav-itemed"><a
						href="javascript:;">签到系统</a>
						<dl class="layui-nav-child">
							<dd>
								<a id="signShow" onclick="signShow()" href="#">点名签到</a>
							</dd>
							<dd>
								<a id="otherShow" onclick="otherShow()" href="#">签到记录</a>
							</dd>
							<!-- <dd>
								<a href="#">待定</a>
							</dd> -->
						</dl></li>
					<li class="layui-nav-item layui-nav-itemed"><a href="javascript:;">考试系统</a>
						<dl class="layui-nav-child">
							<dd>
								<a onclick="FirstFunction()" id="addExamination" href="#">查看试卷</a>
							</dd>
							<dd>
								<a onclick="TocorrectExamination()" id="correctExamination" href="#">批改试卷</a>
							</dd>
							<dd>
								<a id="lookatScore" onclick="scoreFormList()" href="#">查看成绩</a>
							</dd>
							<!-- <dd>
								<a href="#">待定</a>
							</dd> -->
						</dl></li>
					<!-- <li class="layui-nav-item"><a href="#">产品</a></li>
					<li class="layui-nav-item"><a href="#">大数据</a></li> -->
				</ul>
			</div>
		</div>


		<!-- 内容 -->
		<div class="layui-body site-demo">
		  <!-- 反馈工具 -->
			<script>
			layui.cache.page = 'jie';
			layui.cache.user = {
			 
			};
			layui.config({
			  version: "3.0.0"
			  ,base: '<%=request.getContextPath()%>/layui/mods/'
			}).extend({
				fly : 'index'
			}).use('fly');
			</script>

			<br><span
				style="margin-left: 5%; color: #c2c2c2; font-style: oblique;">${course.courseName}：<span
				id="getHeadLine">班级信息</span></span>
			<hr class="layui-bg-cyan">
			
			<!-- 教师首页 -->
			<form id="returnTeacherIndexForm" action="<%=request.getContextPath()%>/teacher/teacherLogin.do" method="post" style="display: none;">
			  <input type="text" name="id" value="${teacher.teacherMobile}"/>
			  <input type="text" name="password" value="${teacher.teacherPassword}"/>
			</form>
			
			<!-- 发布公告 -->
			<div class="site-text site-block" id="proclamationDiv" style="display: none; height: 400px;">
			<form class="layui-form">
			  <div class="layui-form-item layui-form-text" style="margin-top: 50px;">
                 <label class="layui-form-label" style="width: 100%;text-align: left;">公告：<span style="color: #FF5722;">@该课程下所有学生</span></label>
                      <div class="layui-input-block" style="margin-left: 0;">
                           <textarea id="proclamationNowContent" placeholder="请输入内容" class="layui-textarea" style="height: 150px;"></textarea>
                       </div>
                 </div>
                 
				<div style="height: 60px; width: 300px;">
				    <input class="layui-btn" style="margin-left: 14%;"
								onclick="proclamationNowX()" type="button" value="即刻发布" />
						<button style=" margin-left: 14%; width: 100px"
						type="reset" class="layui-btn layui-btn-primary">重置</button>
					<br /> <br /> <br />
					<script type="text/javascript">
					function proclamationNowX() {
						   if($('#proclamationNowContent').val() != ""){
							   $.ajax({
							         type: "GET",
							         data: {
							        	 "teacherMobile":${teacher.teacherMobile},
							        	 "courseId":${course.courseId},
							        	 "messageContent":$('#proclamationNowContent').val()
							         },
							         contentType: "application/json; charset=utf-8",
							         async: true,
							         url: "<%=request.getContextPath()%>/teacher/addProclamation.do",
									success : function(data) {
										if(data.result == true){
											layui.use('layer', function(){
									              var $ = layui.jquery, layer = layui.layer; 
												      layer.open({
												        type: 1
												        ,offset: 'auto' 
												        ,id: 'layerDemo'+'auto'
												        ,title: '成功'
												        ,content: '<div style="padding: 20px 100px; color:#FF5722;">'+ "广播成功" +'</div>'
												        ,btn: '关闭'
												        ,btnAlign: 'c' 
												        ,shade: 0 
												        ,yes: function(){
												        	layer.closeAll();
												        }
												      });
									           });
											$('#proclamationNowContent').val("");
										}else {
											layer.msg('广播失败，暂无学生接收~');
										}
									},
									error : function(data) {
									},
									dataType : "json",
								});
						   }else {
							   layer.msg('内容不可为空哦~');
						}
							
						 }
					   
					</script>
				  </div>
			    
              </form>
		</div>
		
		<!-- 人脸识别结果 -->
       <div  id="compareDetailDiv" style="display: none; height: 520px; overflow: hidden; margin-top: 0;">
			 <div style="height: 100%; width:103%; overflow: scroll;">
			<div id="hereBackUp">
			
			</div>
			<table  style="text-align: center; margin-top: 0; width: 100%; margin-left: 0;">
					<colgroup>
						<col width="300">
						<col width="300">
						<col width="300">
					</colgroup>
					<thead>
						<tr>
							<th style="text-align: center;">学号</th>
							<th style="text-align: center;">姓名</th>
							<th style="text-align: center;">班级</th>
						</tr>
					</thead>
					<tbody id="scoreStudentDetail">
						
					</tbody>
				</table>
			
			<table class="layui-table" lay-even style="text-align: center;">
					<colgroup>
						<col width="150">
						<col width="200">
						<col width="200">
					</colgroup>
					<thead>
						<tr>
							<th style="text-align: center;">识别比对时间</th>
							<th style="text-align: center;">相似度</th>
							<th style="text-align: center;"></th>
						</tr>
					</thead>
					<tbody id="scoreDetail">
						
					</tbody>
				</table>
		</div>
	</div>
		
		
		<!-- 发布作业 -->
			<div class="site-text site-block" id="homeWork" style="display: none; height: 400px;">
			<form class="layui-form">
			  <div class="layui-form-item layui-form-text" style="margin-top: 50px;">
                 <label class="layui-form-label" style="width: 100%;text-align: left;">课后作业：<span style="color: #FF5722;">@该课程下所有学生</span></label>
                 
                 <div class="layui-form-item">
				<label class="layui-form-label" for="datetime" style="text-align: left;">完成时间：</label>
				<div class="layui-input-block">
					<input id="homeWordDatetime" type="text" name="datetime" required style="width: 50%;"
						lay-verify="required" autocomplete="off"
						class="layui-input">
				</div>
			   </div>
                      <div class="layui-input-block" style="margin-left: 0;">
                           <textarea id="homeWorkContent" placeholder="请输入内容" class="layui-textarea" style="height: 150px;"></textarea>
                       </div>
                 </div>
                 
				<div style="height: 60px; width: 300px;">
				    <input class="layui-btn" style="margin-left: 14%;"
								onclick="proclamationNowHome()" type="button" value="布置作业" />
						<button style=" margin-left: 14%; width: 100px"
						type="reset" class="layui-btn layui-btn-primary">重置</button>
					<br /> <br /> <br />
					<script type="text/javascript">
					function proclamationNowHome() {
						   if($('#homeWorkContent').val() != ""){
							   $.ajax({
							         type: "GET",
							         data: {
							        	 "teacherMobile":${teacher.teacherMobile},
							        	 "courseId":${course.courseId},
							        	 "homeWorkContent":$('#homeWorkContent').val(),
							        	 "homeWordDatetime":$('#homeWordDatetime').val()
							         },
							         contentType: "application/json; charset=utf-8",
							         async: true,
							         url: "<%=request.getContextPath()%>/teacher/pushHomeWork.do",
									success : function(data) {
										if(data.result == true){
											layui.use('layer', function(){
									              var $ = layui.jquery, layer = layui.layer; 
												      layer.open({
												        type: 1
												        ,offset: 'auto' 
												        ,id: 'layerDemo'+'auto'
												        ,title: '成功'
												        ,content: '<div style="padding: 20px 100px; color:#FF5722;">'+ "作业布置完成" +'</div>'
												        ,btn: '关闭'
												        ,btnAlign: 'c' 
												        ,shade: 0 
												        ,yes: function(){
												        	layer.closeAll();
												        }
												      });
									           });
											$('#homeWorkContent').val("");
											$('#homeWordDatetime').val("");
										}else {
											layer.msg('布置失败，暂无学生接收~');
										}
									},
									error : function(data) {
									},
									dataType : "json",
								});
						   }else {
							   layer.msg('内容不可为空哦~');
						}
							
						 }
					   
					</script>
				  </div>
			    
              </form>
		</div>
   <script>
   layui.use(['form', 'layedit', 'laydate'], function(){
  var form = layui.form,laydate = layui.laydate;
   form.render();
   laydate.render({
		elem : '#homeWordDatetime'
	});
   layer = layui.layer
  ,layedit = layui.layedit
  ,laydate = layui.laydate;  
   });
  </script>
  
			
			<!-- 迟到或者早退修改 -->
			<div id="comeLateOrLeaveEarly" style="position: fixed; background-color: #e2e2e2; width: 30%;
			 top: 200px;opacity: 1; padding-left:10px;display:none;
			z-index: 20; margin-left: 10%;">
			<h3 style="font-size: 1.5em; width: 100%; text-align: center;">迟到or早退</h3>
			<br/>
				  <form class="layui-form" action="">
				    <div class="layui-form-item">
						<label style="background-color: #FF5722;text-align: center;" class="layui-form-label">学号</label>
						<div class="layui-input-block">
							<input id="QstudentRoNo" type="text" readonly="readonly"
								class="layui-input" style="width: 90%;">
						</div>
					</div>
					
					<div class="layui-form-item">
						<label style="background-color: #FF5722;text-align: center;" class="layui-form-label">姓名</label>
						<div class="layui-input-block">
							<input id="QstudentName" type="text" readonly="readonly"
								class="layui-input" style="width: 90%;">
						</div>
					</div>
					
					
					<div class="layui-form-item">
						<label style="background-color: #FF5722;text-align: center;" class="layui-form-label">迟到</label>
						<div class="layui-input-block">
							<input id="QstudentComeLate" type="text" readonly="readonly"
								class="layui-input" style="width: 30%;float: left;">
								<a onclick="addComeLate()" href="#"><i class="layui-icon" style="font-size: 40px; color: #1E9FFF;float: left; margin-left: 15px;">&#xe608;</i></a>
						</div>
					</div>
					<input type="text" id="studentInFOID" style="display: none;" readonly="readonly"/>
					<div class="layui-form-item">
						<label style="background-color: #FF5722;text-align: center;" class="layui-form-label">早退</label>
						<div class="layui-input-block">
							<input id="QstudentLeaveEarly" type="text" readonly="readonly"
								class="layui-input" style="width: 30%;float: left;">
								<a onclick="addLeaveEarly()" href="#"><i class="layui-icon" style="font-size: 40px; color: #1E9FFF;float: left; margin-left: 15px;">&#xe608;</i></a> 
						</div>
					</div>
					<div class="layui-form-item">
						<div class="layui-input-block">
							<input id="subButton" class="layui-btn" style="width: 60%;"
								onclick="closeThisStuInfo()" type="button" value="关闭" />
						</div>
					</div>
				  </form>
			</div>


			<!-- 班级信息 -->
			<div class="layui-form sessiontable" id="clazzInfoShow"
				style="">
				<table id="clazzInfoShow1" class="layui-table" lay-even style="text-align: center;">
					<colgroup>
						<col width="150">
						<col width="200">
						<col width="200">
						<col width="150">
						<col width="150">
					</colgroup>
					<thead>
						<tr>
							<th style="text-align: center;">班级</th>
							<th style="text-align: center;">学年</th>
							<th style="text-align: center;" colspan="3">操作</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${! empty course.clazz }">
								<c:forEach items="${course.clazz}" var="c">
	  						    <tr>
										<td>${c.clazzName}</td>
										<td>${c.currentYear}</td>
										<td><input name="clazzId" style="display: none;"
											value="${c.clazzId}" /> <a class="aSign" id="${c.clazzId}"
											onclick="aClick(this.id)" href="#">查看学生</a></td>
										<td><a class="aSign" id="zxc${c.clazzId}"
											onclick="changeWhenClick(this.id)" href="#">修改</a></td>
										<td><a class="aSign" id="del${c.clazzId}"
											onclick="deleteClazzByAjax(this.id)" href="#">删除</a></td>
									</tr>
									<br />
								</c:forEach>
							</c:when>
							<c:otherwise>
							     <tr>
							     <td colspan="5">(空)</td>
							     </tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>

				<script>
				layui.use('table', function() {
					var table = layui.table;
				});
			    </script>
			    
		 <!-- 修改班级信息 -->
		<div class="site-text site-block" id="clazzForm" style="display: none;">
			<form action="" class="layui-form layui-form-pane">
				<div class="layui-form-item">
					<label class="layui-form-label">班级名称</label>
					<div class="layui-input-block">
						<input id="ChangeClazzName" type="text" name="ChangeClazzName" required
							lay-verify="required|idvalidate" onchange="searchIfExistCourse()"
							placeholder="请输入班级名称" autocomplete="off" class="layui-input">
					</div>

				</div>

				<div class="layui-form-item">
					<label class="layui-form-label">当前学年</label>
					<div class="layui-input-inline">
						<input id="ChangeCurrentYear" type="text" name="ChangeCurrentYear" required
							lay-verify="required" placeholder="如'2017'" autocomplete="off"
							class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
					<div class="layui-input-block">
						<input id="" class="layui-btn"
							onclick="saveChange()" lay-submit lay-filter="formDemo"
							type="button" value="提交修改" />
						<button type="reset" class="layui-btn layui-btn-primary">重置</button>
					</div>
				</div>
			</form>

			<script>
				layui.use([ 'form', 'laydate' ], function() {
					var form = layui.form, laydate = layui.laydate;
					laydate.render({
						elem : '#ChangeCurrentYear',
						type : 'year'
					});
					
					form.verify({
						idvalidate:[/(.+){1,20}$/,'班级名称必须是1到20位字符'],
					});
				});
				</script>
		</div>
		<form id="clazzForm" style="display: none">
		  <input type="text" id="courseId" name="courseId"
			value="${course.courseId}" /><br /> <input type="text"
			id="preclazzId" name="preclazzId"><br /> 班级名称：<input
			type="text" id="preclazzName" name="preclazzName"><br />
		   <input onclick="saveChange()" type="button" value="提交修改" />
	     </form>
		</div>
		

		<!-- 班级内部具体信息 -->
		<div class="site-text site-block" id="inClazzStudentInfoDiv"
			style="display: none;padding-left: 0;padding-right: 0; padding-top: 0; margin-top: 0;">
			<br /> 班级人数：<span id="studentCount"></span>
			<table class="layui-table" lay-even>
				<colgroup>
					<col width="150">
					<col width="100">
					<col width="100">
					<col width="150">
					<col width="210">
					<col width="80">
					<col width="80">
				</colgroup>
				<thead>
					<tr>
						<th style="text-align: center;">学号</th>
						<th style="text-align: center;">姓名</th>
						<th style="text-align: center;">性别</th>
						<th style="text-align: center;">手机</th>
						<th style="text-align: center;">照片</th>
						<th style="text-align: center;" colspan="2">操作</th>
					</tr>
				</thead>
				<tbody id="inClazzStudentInfoTable">

				</tbody>
			</table>
		</div>

		<!-- 添加班级 -->
		<div class="site-text site-block" id="addClassShow"
			style="display: none;">
			<!-- 新建班级成功提示信息 -->
			<div id="afterAddClazz"
				style="background-color: #393D49; height: 20%; width: 20%; z-index: 20; position: fixed; text-align: center; margin-left: 10%; display: none;">
				<h3 style="color: white; margin-top: 19%">添加班级成功..</h3>
			</div>
			<form action="" class="layui-form layui-form-pane">
				<div class="layui-form-item">
					<label class="layui-form-label">班级名称</label>
					<div class="layui-input-block">
						<input id="clazzName" type="text" name="clazzName" required
							lay-verify="required|idvalidate" onchange="searchIfExistCourse()"
							placeholder="请输入班级名称" autocomplete="off" class="layui-input">
					</div>

				</div>

				<div class="layui-form-item">
					<label class="layui-form-label">当前学年</label>
					<div class="layui-input-inline">
						<input id="currentYear" type="text" name="currentYear" required
							lay-verify="required" placeholder="如'2017'" autocomplete="off"
							class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
					<div class="layui-input-block">
						<input id="AddCourseButton" class="layui-btn"
							onclick="teacherAddClazz()" lay-submit lay-filter="formDemo"
							type="button" value="点击添加" />
						<button type="reset" class="layui-btn layui-btn-primary">重置</button>
					</div>
				</div>
			</form>

			<script>
				layui.use([ 'form', 'laydate' ], function() {
					var form = layui.form, laydate = layui.laydate;
					laydate.render({
						elem : '#currentYear',
						type : 'year'
					});
					
					form.verify({
						idvalidate:[/(.+){1,20}$/,'班级名称必须是1到20位字符'],
					});
				});
				</script>
		</div>

		<!-- 签到content -->
		<div id="signModel"
			style="width: 100%; overflow: hidden; height: 100%; display: none;">
			<!-- 签到模块 -->
			<div style="width: 35%; float: right; margin-top: 3%;">
				<!-- 二维码模块 -->
				<div style="width: 98%; height: 20%; text-align: center;">
					<!-- 签到数字 -->
					<div id="validateCode"
						style="width: 98; height: 30px; font-size: 25px; text-align: center;">
						<span id="timer" style="color: #FF5722;">签到码</span>
					</div>
					<!-- 签到二维码 -->
					<div
						style="padding: 10px; width: auto; text-align: center; margin-top: 10px;">
						<img style="border: solid; border-color: black;" id="qrImg" >
					</div>
				</div>
				<!-- 签到操作 -->
				<div style="text-align: center;">
					<input type="text" value="${course.courseId}"
						style="display: none;" /> <br /> <a id="qrHref"
						class="layui-btn layui-btn-normal" onclick="showQrImg()" href="#">开始签到</a>
					<a class="layui-btn layui-btn-danger" href="#"
						onclick="submitSignIn()">提交签到</a><br /> <br />
				</div>
			</div>
			<!-- 垂直分界线 -->
			<div
				style="float: right; width: 2%; height: 100%; text-align: center;">
				<hr style="width: 2px; height: 100%; background-color: #c2c2c2;"></hr>
			</div>
			<!-- 签到状况模块 -->
			<div style="width: 58%; text-align: center;">
				<!-- 实时签到表 -->
				<table class="layui-table" width="99%" border="1" id="showStudents"
					style="margin-top: 10%; margin-left: 15px; display: none;">
				</table>
				<table id="getAllInfo" style="width: 99%; margin-left: 3%"
					class="layui-table">
					<caption>本学期签到汇总</caption>
					<thead>
						<tr>
							<th>学号</th>
							<th>班级</th>
							<th>姓名</th>
							<th>签到</th>
							<th>迟到</th>
							<th>早退</th>
							<th>旷课</th>
							<th>请假</th>
							<th>修改</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${! empty clazzStus}">
								<c:forEach items="${clazzStus}" var="c">
									<tr>
										<td>${c.student.studentRoNo}</td>
										<td>${c.clazz.clazzName}</td>
										<td>${c.student.studentName}</td>
										<td>${c.student.studentInfo.signIn}</td>
										<td id="CL${c.student.studentInfo.studentInfoId}">${c.student.studentInfo.comeLate}</td>
										<td id="LE${c.student.studentInfo.studentInfoId}">${c.student.studentInfo.leaveEarlier}</td>
										<td>${c.student.studentInfo.absenteeism}</td>
										<td>${c.student.studentInfo.askForLeave}</td>
										<td><a id="Q${c.student.studentRoNo}" onclick="changeQiandao(this.id)" href="#"><i class="layui-icon" style="font-size: 24px; color: #1E9FFF;">&#xe642;</i></a></td>
									</tr>
								</c:forEach>
							</c:when>
						</c:choose>
					</tbody>
				</table>
			</div>
		</div>

		<script>
				//签到模块显示
				function signShow() {
					$('#getHeadLine').html("点名签到");
					$('#addClassShow').hide();
					$('#otherModel').hide();
					$('#compareDetailDiv').hide();
					$('#clazzInfoShow').hide();
					$('#inClazzStudentInfoDiv').hide();
					$('#addQuestionsDiv').hide();
					$('#proclamationDiv').hide();
					$('#homeWork').hide();  
					$('#studentExam').hide();
					$('#addExaminationDiv').hide();
					$('#scoreFormList').hide();
					$('#signModel').show();
				}
				//点击修改迟到或者早退
				function changeQiandao(studentRoNo) {
					var studentRoNo = studentRoNo.substring(1);
					$.ajax({
			              type: "GET",
			              data: {
			            	  "studentRoNo":studentRoNo,
			            	  "courseId":${course.courseId}
			              },
			              contentType: "application/json; charset=utf-8",
			              async: false,
			              dataType: "json",
			              url: "<%=request.getContextPath()%>/studentInfo/changeQiandao.do",
			              success: function (data) {
			  				 $('#studentInFOID').val(data.studentInfo.studentInfoId);
			            	 $('#QstudentRoNo').val(data.student.studentRoNo);
			            	 $('#QstudentName').val(data.student.studentName);
			            	 $('#QstudentComeLate').val(data.studentInfo.comeLate);
			            	 $('#QstudentLeaveEarly').val(data.studentInfo.leaveEarlier);
			            	 $('#comeLateOrLeaveEarly').show();
			              },
			              error: function (data) {
			            	  alert("服务器异常");
			              }
			          });
					
				}
				//添加迟到次数
				function addComeLate() {
					$.ajax({
			              type: "GET",
			              data: {
			            	  "studentInfoId": $('#studentInFOID').val()
			              },
			              contentType: "application/json; charset=utf-8",
			              async: false,
			              dataType: "json",
			              url: "<%=request.getContextPath()%>/studentInfo/addComeLate.do",
			              success: function (data) {
			            	  if(data.result == true){
			            		  $('#CL'+data.studentInfo.studentInfoId).html(data.studentInfo.comeLate);
			            		  $('#QstudentComeLate').val(data.studentInfo.comeLate);
			            		  layui.use('layer', function(){
					 	               var $ = layui.jquery, layer = layui.layer; 
					   			      layer.open({
					   			        type: 1
					   			        ,offset: 'auto'
					   			        ,id: 'layerDemo'+'auto'
					   			        ,title: '成功'
					   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "添加迟到次数成功" +'</div>'
					   			        ,btn: '关闭'
					   			        ,btnAlign: 'c'
					   			        ,skin: 'demo-class'
					   			        ,shade: 0 
					   			        ,yes: function(){
					   			        	 layer.closeAll();
					   			        }
					   			      });
					 	            });
			            	  }
			            	 
			              },
			              error: function (data) {
			            	  alert("服务器异常");
			              }
			          });
				}
				//添加早退次数
				function addLeaveEarly() {
					$.ajax({
			              type: "GET",
			              data: {
			            	  "studentInfoId":$('#studentInFOID').val()
			              },
			              contentType: "application/json; charset=utf-8",
			              async: false,
			              dataType: "json",
			              url: "<%=request.getContextPath()%>/studentInfo/addLeaveEarly.do",
			              success: function (data) {
			            	  if(data.result == true){
			            		  $('#LE'+data.studentInfo.studentInfoId).html(data.studentInfo.leaveEarlier);
			            		  $('#QstudentLeaveEarly').val(data.studentInfo.leaveEarlier);
			            		  layui.use('layer', function(){
					 	               var $ = layui.jquery, layer = layui.layer; 
					   			      layer.open({
					   			        type: 1
					   			        ,offset: 'auto'
					   			        ,id: 'layerDemo'+'auto'
					   			        ,title: '成功'
					   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "添加早退次数成功" +'</div>'
					   			        ,btn: '关闭'
					   			        ,btnAlign: 'c'
					   			        ,skin: 'demo-class'
					   			        ,shade: 0 
					   			        ,yes: function(){
					   			        	 layer.closeAll();
					   			        }
					   			      });
					 	            });
			            	  }
			              },
			              error: function (data) {
			            	  alert("服务器异常");
			              }
			          });
				}
				function closeThisStuInfo() {
					$('#comeLateOrLeaveEarly').hide();
				}
				//添加早退次数
			</script>

		<!-- 签到记录模块 -->
		<div id="otherModel" style="display: none; padding: 25px 4%;">
		<a id="getStuInfoDatial1" onclick="getStuInfoDatial()" href="#" style="color: #5FB878;">按日期查看签到记录<i class="layui-icon" style="font-size: 20px; color: #FF5722;">&#xe61d;</i> </a>
		<a id="getStuInfoDatial2" onclick="getStuInfoDatial2()" href="#" style="color: #5FB878;display: none;">按日期查看签到记录<i class="layui-icon" style="font-size: 20px; color: #FF5722;">&#xe61a;</i> </a>
			
			<div id="getInfoDetail" style="width: 100%; display: none;">
			<table class="layui-table" style="float: left; width: 30%;">
			<caption>---------历史签到记录---------</caption>
			<colgroup>
					<col width="120">
					<col width="140">
				</colgroup>
				<thead>
					<tr>
						<th style="text-align: center;">签到日期</th>
						<th style="text-align: center;">附加信息</th>
					</tr>
				</thead>
				<tbody id="InfoDetailTable">
					
				</tbody>
			</table>
			 <!-- 垂直分界线 -->
			<div style="float: left; width: 2%; height: 100%; text-align: center; margin-left: 3%;">
				<hr style="width: 2px; height: 300px; background-color: #c2c2c2;"></hr>
			</div>
			
			<table id="detailOfSign" class="layui-table" style="float: left; width: 50%; margin-left: 3%;margin-top: 3%;">
			<caption id="caption" style="color:#FF5722;text-align:left"></caption>
			<colgroup>
					<col width="180">
					<col width="140">
					<col width="200">
				</colgroup>
				<thead>
					<tr>
						<th style="text-align: center;">学号</th>
						<th style="text-align: center;">状态</th>
						<th style="text-align: center;">操作</th>
					</tr>
				</thead>
				<tbody id="detailOfSignTbody" style="font-family: 微软雅黑;">
					
				</tbody>
			</table>
			
			
			</div>
			
			
			<div id="getAllInfo2">
			  <table style="width: 99%;" class="layui-table">
			<caption>---------签到汇总---------</caption>
				<thead>
					<tr>
						<th>学号</th>
						<th>班级</th>
						<th>姓名</th>
						<th>签到</th>
						<th>迟到</th>
						<th>早退</th>
						<th>旷课</th>
						<th>请假</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${! empty clazzStus}">
							<c:forEach items="${clazzStus}" var="c">
								<tr>
									<td>${c.student.studentRoNo}</td>
									<td>${c.clazz.clazzName}</td>
									<td>${c.student.studentName}</td>
									<td>${c.student.studentInfo.signIn}</td>
									<td>${c.student.studentInfo.comeLate}</td>
									<td>${c.student.studentInfo.leaveEarlier}</td>
									<td>${c.student.studentInfo.absenteeism}</td>
									<td>${c.student.studentInfo.askForLeave}</td>
								</tr>
							</c:forEach>
						</c:when>
					</c:choose>
				</tbody>
			</table>
            <a href="<%=request.getContextPath()%>/studentInfo/exportTotalSign.do?courseId=${course.courseId}" style="margin-left: 81%;color: #5FB878;">--导出签到总记录<i class="layui-icon" style="font-size: 20px; color: #FF5722;">&#xe61e;</i>--</a>
			</div>
			
		</div>

		<script>
		        //查看签到细节
		        function getStuInfoDatial() {
		        	$('#getInfoDetail').show();
		        	$('#getStuInfoDatial1').hide();
		        	$('#getStuInfoDatial2').show();
		        	$('#getAllInfo2').hide();
		       	 $.ajax({
		 	        type: "GET",
		 	        data: {
		 	        	"courseId":${course.courseId}
		 	        },
		 	        contentType: "application/json; charset=utf-8",
		 	        async: false,
		 	        url: "<%=request.getContextPath()%>/studentInfo/getStuInfoDetailList.do",
		 			success : function(data) {
		 				if(data.result == true){
		 					var dataObj = data.stuInfoDetail;
			 				 con = "";
			 				 $.each(dataObj, function (index, item) {
			 					con += "<tr id=N"+item.studentInfoDetailId+">";
			 	       	        con += "<td style='text-align:center;'><a id="+item.studentInfoDetailId+" onclick='lookAtStuInfoCount(this.id)' href='#' style='color:#5FB878;'>" + item.currentTime + "</a></td>";
			 	       	        con += "<td style='text-align:center;'><a href='#'>" + item.currentWeek + "</a></td>";
			 	       	        con += "<tr/>";
			 	       	    });
			 				 $('#InfoDetailTable').html(con);
		 				}else{
		 					con = "";
		 					con += "<tr style='text-align:center;'>";
		 					con += "<td colspan='2'>" + "暂无签到信息" + "</td>";
		 					con += "<tr/>";
		 					 $('#InfoDetailTable').html(con);
		 				}
		 				
		 			},
		 			error : function(data) {
		 				alert("??");
		 			},
		 			dataType : "json",
		 		});
				}
		        // 查看选中的日期当天有几次签到记录
		        function lookAtStuInfoCount(id) {
		        	
		        	 $.ajax({
				 	        type: "GET",
				 	        data: {
				 	        	"studentInfoDetailId":id
				 	        },
				 	        contentType: "application/json; charset=utf-8",
				 	        async: false,
				 	        url: "<%=request.getContextPath()%>/studentInfo/selectCountOfCurrentDay.do",
				 			success : function(data) {
				 				var dataObj = data.studentInfoDetails; //返回的data为json格式的数据
				        	    var con;
				        	    $.each(dataObj, function (index, item) {
				        	        con += "<tr>";
				        	        con += "<td style='text-align:center;'>" + item.studentRoNo + "</td>";
				        	        con += "<td style='text-align:center;' id=P"+item.studentInfoDetailId+">" + item.signInStatus + "</td>";
				        	        con += "<td style='text-align:center;><div class='site-demo-button' id='layerDemo3'><a id="+item.studentInfoDetailId+" onclick='changeSignStatus(this.id)' href='#'><i id=S"+item.studentInfoDetailId+" class='layui-icon' style='font-size: 20px; color: #1E9FFF;'>&#xe642;</i></a><a id=I"+item.studentInfoDetailId+" href='#' style='font-size:10px;display:none;'><span class='layui-btn22' data-method='notice' id=Q"+item.studentInfoDetailId+" onclick='showThing(this.id)' style='color:white; background-color:#5FB878;'>签到</span>&nbsp;<span class='layui-btn3' id=W"+item.studentInfoDetailId+" data-method='notice2' onclick='showThing(this.id)' style='color:white; background-color:#FF5722;'>迟到</span>&nbsp;<span class='layui-btn4' id=E"+item.studentInfoDetailId+" data-method='notice' onclick='showThing(this.id)' style='color:white; background-color:#5FB878;'>早退</span>&nbsp;<span class='layui-btn5' id=R"+item.studentInfoDetailId+" data-method='notice' onclick='showThing(this.id)' style='color:white; background-color:#FF5722;'>请假</span>&nbsp;<span class='layui-btn6' data-method='notice' onclick='showThing(this.id)' id=T"+item.studentInfoDetailId+" style='color:white; background-color:#5FB878;'>旷课</span>&nbsp;<i id=L"+item.studentInfoDetailId+" onclick='reBack(this.id)' class='layui-icon' style='font-size: 20px; color: #1E9FFF;'>&#xe633;</i></a></div></td>";
				        	        con += "<tr/>";
				        	    });
				        	    $('#caption').html(data.currentTime+'&nbsp;&nbsp;&nbsp;&nbsp;'+"<a href='<%=request.getContextPath()%>/studentInfo/exportSign.do?studentInfoDetailId="+id+"' style='color:#5FB878;'>--导出该次签到表--</a>");
				        	    $('#detailOfSignTbody').html(con);
				 			},
				 			error : function(data) {
				 				alert("??");
				 			},
				 			dataType : "json",
				 		});
		        	 
		        	//改为签到确认窗
		     		layui.use(['element', 'layer'], function() {
		    			var element = layui.element, $ = layui.jquery, layer = layui.layer;
		    			//触发事件
		    			var active = {
		    				notice : function() {
		    					//示范一个公告层
		    					layer.open({
		    								type : 1,
		    								title : false //不显示标题栏
		    								,
		    								closeBtn : false,
		    								area : '300px;',
		    								shade : 0.8,
		    								id : 'LAY_layuipro22' //设定一个id，防止重复弹出
		    								,
		    								btn : [ '确认', '取消' ],
		    								yes : function(index, layero) {
		    									showThing1();
		    								},
		    								btn2 : function(index, layero) {
		    									//按钮【按钮二】的回调
		    								},
		    								btnAlign : 'c',
		    								moveType : 1 //拖拽模式，0或者1
		    								,
		    								content : '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">确定更改为签到？</div>'
		    							});
		    				}

		    			};

		    			$('#layerDemo3 .layui-btn22').on(
		    					'click',
		    					function() {
		    						var othis = $(this), method = othis
		    								.data('method');
		    						active[method] ? active[method].call(
		    								this, othis) : '';
		    					});
		                 });
		     		//改为迟到确认窗
		     		layui.use(['element', 'layer'], function() {
		    			var element = layui.element, $ = layui.jquery, layer = layui.layer;
		    			//触发事件
		    			var active = {
		    				notice2 : function() {
		    					//示范一个公告层
		    					layer.open({
		    								type : 1,
		    								title : false //不显示标题栏
		    								,
		    								closeBtn : false,
		    								area : '300px;',
		    								shade : 0.8,
		    								id : 'LAY_layuipro33' //设定一个id，防止重复弹出
		    								,
		    								btn : [ '确认', '取消' ],
		    								yes : function(index, layero) {
		    									showThing2();
		    									layer.closeAll();
		    								},
		    								btn2 : function(index, layero) {
		    									//按钮【按钮二】的回调
		    								},
		    								btnAlign : 'c',
		    								moveType : 1 //拖拽模式，0或者1
		    								,
		    								content : '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">确定更改为迟到？</div>'
		    							});
		    				}

		    			};

		    			$('#layerDemo3 .layui-btn3').on(
		    					'click',
		    					function() {
		    						var othis = $(this), method = othis
		    								.data('method');
		    						active[method] ? active[method].call(
		    								this, othis) : '';
		    					});
		                 });
		     		
		     		//改为早退确认窗
		     		layui.use(['element', 'layer'], function() {
		    			var element = layui.element, $ = layui.jquery, layer = layui.layer;
		    			//触发事件
		    			var active = {
		    				notice : function() {
		    					//示范一个公告层
		    					layer.open({
		    								type : 1,
		    								title : false //不显示标题栏
		    								,
		    								closeBtn : false,
		    								area : '300px;',
		    								shade : 0.8,
		    								id : 'LAY_layuipro44' //设定一个id，防止重复弹出
		    								,
		    								btn : [ '确认', '取消' ],
		    								yes : function(index, layero) {
		    									showThing3();
		    									layer.closeAll();
		    								},
		    								btn2 : function(index, layero) {
		    									//按钮【按钮二】的回调
		    								},
		    								btnAlign : 'c',
		    								moveType : 1 //拖拽模式，0或者1
		    								,
		    								content : '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">确定更改为早退？</div>'
		    							});
		    				}

		    			};

		    			$('#layerDemo3 .layui-btn4').on(
		    					'click',
		    					function() {
		    						var othis = $(this), method = othis
		    								.data('method');
		    						active[method] ? active[method].call(
		    								this, othis) : '';
		    					});
		                 });
		     		//改为请假确认窗
		     		layui.use(['element', 'layer'], function() {
		    			var element = layui.element, $ = layui.jquery, layer = layui.layer;
		    			//触发事件
		    			var active = {
		    				notice : function() {
		    					//示范一个公告层
		    					layer.open({
		    								type : 1,
		    								title : false //不显示标题栏
		    								,
		    								closeBtn : false,
		    								area : '300px;',
		    								shade : 0.8,
		    								id : 'LAY_layuipro55' //设定一个id，防止重复弹出
		    								,
		    								btn : [ '确认', '取消' ],
		    								yes : function(index, layero) {
		    									showThing4();
		    									layer.closeAll();
		    								},
		    								btn2 : function(index, layero) {
		    									//按钮【按钮二】的回调
		    								},
		    								btnAlign : 'c',
		    								moveType : 1 //拖拽模式，0或者1
		    								,
		    								content : '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">确定更改为请假？</div>'
		    							});
		    				}

		    			};

		    			$('#layerDemo3 .layui-btn5').on(
		    					'click',
		    					function() {
		    						var othis = $(this), method = othis
		    								.data('method');
		    						active[method] ? active[method].call(
		    								this, othis) : '';
		    					});
		                 });
		     		
		     		//改为旷课确认窗
		     		layui.use(['element', 'layer'], function() {
		    			var element = layui.element, $ = layui.jquery, layer = layui.layer;
		    			//触发事件
		    			var active = {
		    				notice : function() {
		    					//示范一个公告层
		    					layer.open({
		    								type : 1,
		    								title : false //不显示标题栏
		    								,
		    								closeBtn : false,
		    								area : '300px;',
		    								shade : 0.8,
		    								id : 'LAY_layuipro466' //设定一个id，防止重复弹出
		    								,
		    								btn : [ '确认', '取消' ],
		    								yes : function(index, layero) {
		    									showThing5();
		    									layer.closeAll();
		    								},
		    								btn2 : function(index, layero) {
		    									//按钮【按钮二】的回调
		    								},
		    								btnAlign : 'c',
		    								moveType : 1 //拖拽模式，0或者1
		    								,
		    								content : '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">确定更改为旷课？</div>'
		    							});
		    				}

		    			};

		    			$('#layerDemo3 .layui-btn6').on(
		    					'click',
		    					function() {
		    						var othis = $(this), method = othis
		    								.data('method');
		    						active[method] ? active[method].call(
		    								this, othis) : '';
		    					});
		                 });
		     		
				}
		        var studentInfoDetailIIIId;
		        function showThing(id) {
		        	studentInfoDetailIIIId = id.substring(1);
		        	//alert(studentInfoDetailIIIId);
				}
		        //更改状态为签到
		        function showThing1() {
					
					$.ajax({
			 	        type: "GET",
			 	        data: {
			 	        	"studentInfoDetailId":studentInfoDetailIIIId,
					        "signInStatus":"签到"
			 	        },
			 	        contentType: "application/json; charset=utf-8",
			 	        async: false,
			 	        url: "<%=request.getContextPath()%>/studentInfo/changeThisStatus.do",
			 			success : function(data) {
			 				layer.closeAll();
			 				if(data.result == true){
			 					layui.use('layer', function() {
	        						var $ = layui.jquery, layer = layui.layer;
	        						layer.msg('更新成功！请刷新');
	        						$('#P'+studentInfoDetailIIIId).html("签到");
	        					});
			 				}else{
			 					layui.use('layer', function() {
	        						var $ = layui.jquery, layer = layui.layer;
	        						layer.msg('更新失败！');
	        					});
			 				}
			 			},
			 			error : function(data) {
			 				alert("??");
			 			},
			 			dataType : "json",
			 		});
				}
		      //更改状态为迟到
		        function showThing2() {
		    	  //alert("迟到");
		        	$.ajax({
			 	        type: "GET",
			 	        data: {
			 	        	"studentInfoDetailId":studentInfoDetailIIIId,
					        "signInStatus":"迟到"
			 	        },
			 	        contentType: "application/json; charset=utf-8",
			 	        async: false,
			 	        url: "<%=request.getContextPath()%>/studentInfo/changeThisStatus.do",
			 			success : function(data) {
			 				if(data.result == true){
			 					layui.use('layer', function() {
	        						var $ = layui.jquery, layer = layui.layer;
	        						layer.msg('更新成功！请刷新！');
	        						$('#P'+studentInfoDetailIIIId).html("迟到");
	        					});
			 				}else{
			 					layui.use('layer', function() {
	        						var $ = layui.jquery, layer = layui.layer;
	        						layer.msg('更新失败！');
	        					});
			 				}
			 			},
			 			error : function(data) {
			 				alert("??");
			 			},
			 			dataType : "json",
			 		});
				}
		      //更改状态为早退
		        function showThing3() {		    	  
		        	$.ajax({
			 	        type: "GET",
			 	        data: {
			 	        	"studentInfoDetailId":studentInfoDetailIIIId,
					        "signInStatus":"早退"
			 	        },
			 	        contentType: "application/json; charset=utf-8",
			 	        async: false,
			 	        url: "<%=request.getContextPath()%>/studentInfo/changeThisStatus.do",
			 			success : function(data) {
			 				if(data.result == true){
			 					layui.use('layer', function() {
	        						var $ = layui.jquery, layer = layui.layer;
	        						layer.msg('更新成功！请刷新');
	        						$('#P'+studentInfoDetailIIIId).html("早退");
	        					});
			 				}else{
			 					layui.use('layer', function() {
	        						var $ = layui.jquery, layer = layui.layer;
	        						layer.msg('更新失败！');
	        					});
			 				}
			 			},
			 			error : function(data) {
			 				alert("??");
			 			},
			 			dataType : "json",
			 		});
				}
		      //更改状态为请假
		        function showThing4() {
		        	$.ajax({
			 	        type: "GET",
			 	        data: {
			 	        	"studentInfoDetailId":studentInfoDetailIIIId,
					        "signInStatus":"请假"
			 	        },
			 	        contentType: "application/json; charset=utf-8",
			 	        async: false,
			 	        url: "<%=request.getContextPath()%>/studentInfo/changeThisStatus.do",
			 			success : function(data) {
			 				if(data.result == true){
			 					layui.use('layer', function() {
	        						var $ = layui.jquery, layer = layui.layer;
	        						layer.msg('更新成功！请刷新');
	        						$('#P'+studentInfoDetailIIIId).html("请假");
	        					});
			 				}else{
			 					layui.use('layer', function() {
	        						var $ = layui.jquery, layer = layui.layer;
	        						layer.msg('更新失败！');
	        					});
			 				}
			 			},
			 			error : function(data) {
			 				alert("??");
			 			},
			 			dataType : "json",
			 		});
				}
		      //更改状态为旷课
		        function showThing5() {
		        	$.ajax({
			 	        type: "GET",
			 	        data: {
			 	        	"studentInfoDetailId":studentInfoDetailIIIId,
					        "signInStatus":"旷课"
			 	        },
			 	        contentType: "application/json; charset=utf-8",
			 	        async: false,
			 	        url: "<%=request.getContextPath()%>/studentInfo/changeThisStatus.do",
			 			success : function(data) {
			 				if(data.result == true){
			 					layui.use('layer', function() {
	        						var $ = layui.jquery, layer = layui.layer;
	        						layer.msg('更新成功！ 请刷新');
	        						$('#P'+studentInfoDetailIIIId).html("旷课");
	        					});
			 				}else{
			 					layui.use('layer', function() {
	        						var $ = layui.jquery, layer = layui.layer;
	        						layer.msg('更新失败！');
	        					});
			 				}
			 			},
			 			error : function(data) {
			 				alert("??");
			 			},
			 			dataType : "json",
			 		});
				}
		        
		        function changeSignStatus(id) {
					$('#S'+id).hide();
					$('#I'+id).show();
					
				}
		        
		        function reBack(id) {
		        	$('#S'+id.substring(1)).show();
					$('#I'+id.substring(1)).hide();
				}
		        function getStuInfoDatial2() {
		        	$('#getInfoDetail').hide();
		        	$('#getStuInfoDatial1').show();
		        	$('#getStuInfoDatial2').hide();
		        	$('#getAllInfo2').show();
				}
				//其它模块显示
				function otherShow() {
					$('#getHeadLine').html("签到记录");
					$('#upLoadShow').hide();
					$('#addClassShow').hide();
					$('#signModel').hide();
					$('#addExaminationDiv').hide();
				    $('#studentExam').hide();
				    $('#proclamationDiv').hide();
				    $('#compareDetailDiv').hide();
					$('#inClazzStudentInfoDiv').hide();
					$('#homeWork').hide();  
					$('#addQuestionsDiv').hide();
					$('#clazzInfoShow').hide();
					$('#scoreFormList').hide();
					$('#otherModel').show();
				}
			</script>


		<!-- 添加试卷 -->
		<div id="addExaminationDiv" class="site-text site-block"
			style="display: none; margin-top: 0; padding-left: 0; padding-right: 0;">

			<!-- 添加试卷成功提示信息 -->
			<div id="afterAddExamination"
				style="background-color: #393D49; height: 20%; width: 20%; z-index: 20; position: fixed; text-align: center; margin-left: 10%; display: none;">
				<h3 style="color: white; margin-top: 19%">添加试卷成功..</h3>
			</div>

			<!-- 点击出题提示信息 -->
			<div id="confirmAddExamination"
				style="background-color: #393D49; height: 20%; width: 20%; z-index: 20; position: fixed; text-align: center; margin-left: 10%; display: none;">
				<h3 style="color: white; margin-top: 19%">抱歉，该试题已被锁定无法..</h3>
			</div>

			<!-- 填写表单 -->
			<form id="addExaminationForm" class="layui-form layui-form-pane">
				<div class="layui-form-item">
					<label class="layui-form-label">课程名称</label>
					<div class="layui-input-block">
						<input type="text" value="${course.courseName}"
							class="layui-input" readonly="readonly">
					</div>

				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">试卷名称</label>
					<div class="layui-input-block">
						<input id="examinationName" type="text" name="examinationName"
							required lay-verify="required|idvalidate"
							onchange="searchIfExistExamination()" placeholder="请输入试卷名称"
							autocomplete="off" class="layui-input">
					</div>

				</div>

				<div class="layui-form-item">
					<label class="layui-form-label">总分值</label>
					<div class="layui-input-block">
						<input id="totalValue" type="text" name="totalValue" required
							lay-verify="required|math" placeholder="请输入数字" autocomplete="off"
							class="layui-input">
					</div>

				</div>

				<div class="layui-form-item">
					<label class="layui-form-label">开始时间</label>
					<div class="layui-input-inline">
						<input id="startTime" type="text" name="startTime" required
							lay-verify="required" placeholder="如'2017-01-01 13:30:00'"
							autocomplete="off" class="layui-input">
					</div>
				</div>

				<div class="layui-form-item">
					<label class="layui-form-label">考试时长</label>
					<div class="layui-input-inline">
						<input id="duration" type="text" name="duration" required
							lay-verify="required|math" placeholder="如'120分钟'" autocomplete="off"
							class="layui-input">
					</div>
				</div>

				<div class="layui-form-item">
					<div class="layui-input-block">
						<input id="AddExaminationButton" class="layui-btn"
							onclick="teacherAddExamination()" lay-submit
							lay-filter="formDemo" type="button" value="添加试卷" />
						<button type="reset" class="layui-btn layui-btn-primary">重置</button>
					</div>
				</div>
			</form>

			<script>
				layui.use([ 'form', 'laydate' ], function() {
					var form = layui.form, laydate = layui.laydate;
					laydate.render({
						elem : '#startTime',
						type : 'datetime'
					});
					
					form.verify({
						idvalidate:[/(.+){1,20}$/,'试卷名称必须是1到20位字符'],
						math:[/^[1-9]\d*/,'输入为大于零的正整数'],
					});
				});
				</script>

			<!-- 修改试卷成功 -->
			<div id="changeExaminationSuccess"
				style="background-color: #393D49; height: 20%; width: 20%; z-index: 20; position: fixed; text-align: center; margin-left: 10%; display: none;">
				<h3 style="color: white; margin-top: 19%">修改成功,请稍后..</h3>
			</div>
			<!-- 修改试卷 -->
			<form id="changeExaminationForm" class="layui-form layui-form-pane"
				style="display: none;">
				<div class="layui-form-item">
					<label class="layui-form-label">课程名称</label>
					<div class="layui-input-block">
						<input type="text" value="${course.courseName}"
							class="layui-input" readonly="readonly">
					</div>
					<input id="ReexaminationId" style="display: none;" />

				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">试卷名称</label>
					<div class="layui-input-block">
						<input id="ReexaminationName" type="text" name="ReexaminationName"
							required lay-verify="required|idvalidate"
							onchange="searchIfExistExamination()" placeholder="请输入试卷名称"
							autocomplete="off" class="layui-input">
					</div>

				</div>

				<div class="layui-form-item">
					<label class="layui-form-label">开始时间</label>
					<div class="layui-input-inline">
						<input id="RestartTime" type="text" name="RestartTime" required
							lay-verify="required" placeholder="如'2017-01-01 13:30:00'"
							autocomplete="off" class="layui-input">
					</div>
				</div>

				<div class="layui-form-item">
					<label class="layui-form-label">考试时长</label>
					<div class="layui-input-inline">
						<input id="Reduration" type="text" name="Reduration" required
							lay-verify="required|math" placeholder="如'120分钟'" autocomplete="off"
							class="layui-input">
					</div>
				</div>

				<div class="layui-form-item">
					<div class="layui-input-block">
						<input id="changeExaminationButton" class="layui-btn"
							onclick="teacherChangeExamination()" lay-submit
							lay-filter="formDemo" type="button" value="提交修改" />
						<button type="reset" class="layui-btn layui-btn-primary">重置</button>
					</div>
				</div>
			</form>

			<script>
				layui.use([ 'form', 'laydate' ], function() {
					var form = layui.form, laydate = layui.laydate;
					laydate.render({
						elem : '#RestartTime',
						type : 'datetime'
					});
					
					form.verify({
						idvalidate:[/(.+){1,20}$/,'试卷名称必须是1到20位字符'],
						math:[/^[1-9]\d*/,'输入为大于零的正整数'],
					});
				});
				</script>

    
			<!-- 试卷列表 -->
			<table id="ExaminationList" class="layui-table" lay-even lay-skin="row"
				style="text-align: center; width: 100%; margin-left: 0;">
				<colgroup>
					<col width="120">
					<col width="140">
					<col width="80">
					<col width="80">
					<col width="140">
					<col width="120">
					<col width="80">
					<col width="100">
					<col width="80">
					<col width="80">
				</colgroup>
				<thead>
					<tr id="title">
						<th style="text-align: center;">试卷编码</th>
						<th style="text-align: center;">试卷名称</th>
						<th style="text-align: center;">考试码</th>
						<th style="text-align: center;">总分</th>
						<th style="text-align: center;">开始时间</th>
						<th style="text-align: center;">考试时长</th>
						<th style="text-align: center;">状态</th>
						<th style="text-align: center;" colspan="3">操作</th>
					</tr>
				</thead>
				<tbody id="examinationShowTable">

				</tbody>
			</table>
			<script>
				layui.use('table', function() {
					var table = layui.table;
				});
			    </script>
		</div>

		<!-- 添加试题 -->
		<div class="site-text site-block" id="addQuestionsDiv"
			style="display: none; margin-top: 0;">

			<!-- 提交试卷成功提示信息 -->
			<div id="afterSubmitExamination"
				style="background-color: #393D49; height: 20%; width: 20%; z-index: 20; position: fixed; text-align: center; margin-left: 10%; display: none;">
				<h3 style="color: white; margin-top: 19%">提交试卷成功，等待考试..</h3>
			</div>


			<!-- 试卷Id -->
			<input id="examinationIddd" type="text" style="display: none;" />
			<!-- 单选Id -->
			<input id="temId" type="text" style="display: none;" />
			<!-- 试卷名称 -->
			<h2 id="examinationTitle" style="width: 100%; text-align: center;"></h2>
			<!-- 总分 -->
			<h3 id="examinationTotalValue"
				style="width: 100%; padding-left: 70%;"></h3>
			<!-- 开始时间 -->
			<h3 id="examinationStartTime" style="width: 100%; padding-left: 70%;"></h3>
			<!-- 考试时长 -->
			<h3 id="examinationTime" style="width: 100%; padding-left: 70%;"></h3>
			<!-- 单选 -->
			<form class="layui-form">
				<div class="layui-form-item">
					<label class="layui-form-label"
						style="background-color: #009688; text-align: center;">单选</label>
					<a id="SingleSelectionA" onclick="SingleSelectionA()" href="#"
						style="margin-left: 5%;"> <i id="SingleSelectionI"
						class="layui-icon" style="font-size: 30px; color: #1E9FFF;">&#xe608;</i>
						<i id="SingleSelectionII" class="layui-icon"
						style="font-size: 30px; color: #009688; display: none;">&#xe625;</i>
					</a>
				</div>
			</form>
            
			<!-- 单选部分 -->
			<div id="SingleSelectionDetail" class="layui-form-item"
				style="display: none; margin-left: 20px;">
				<form id="singleWait" class="layui-form layui-form-pane">
					<label class="layui-form-label" style="background-color: #009688;">*问题*</label>
					<div class="layui-input-inline">
						<input id="SingleSelectionQuestionContent" type="text"
							name="SingleSelectionQuestionContent" required
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							lay-verify="required" placeholder="如'1+1=?'" autocomplete="off"
							class="layui-input">
					</div>
					<!-- 分值 -->
					<br /> <br /> <br /> <label class="layui-form-label"
						style="background-color: #009688;">分值</label>
					<div class="layui-input-inline">
						<input id="SingleSelectionValue" type="text"
							name="SingleSelectionValue" required
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							lay-verify="required|math" placeholder="本题分值" autocomplete="off"
							class="layui-input">
					</div>
					<!-- 选项A -->
					<br /> <br /> <br /> <label class="layui-form-label"
						style="background-color: #009688;">*选项A*</label>
					<div class="layui-input-inline">
						<input id="SingleSelectionOptionA" type="text"
							name="SingleSelectionOptionA" required
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							lay-verify="required" placeholder="如'0'" autocomplete="off"
							class="layui-input">
					</div>
					<!-- 选项B -->
					<br /> <br /> <br /> <label class="layui-form-label"
						style="background-color: #009688;">*选项B*</label>
					<div class="layui-input-inline">
						<input id="SingleSelectionOptionB" type="text"
							name="SingleSelectionOptionB" required
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							lay-verify="required" placeholder="如'1'" autocomplete="off"
							class="layui-input">
					</div>
					<!-- 选项C -->
					<br /> <br /> <br /> <label class="layui-form-label"
						style="background-color: #009688;">*选项C*</label>
					<div class="layui-input-inline">
						<input id="SingleSelectionOptionC" type="text"
							name="SingleSelectionOptionC" required
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							lay-verify="required" placeholder="如'2'" autocomplete="off"
							class="layui-input">
					</div>
					<!-- 选项D -->
					<br /> <br /> <br /> <label class="layui-form-label"
						style="background-color: #009688;">*选项D*</label>
					<div class="layui-input-inline">
						<input id="SingleSelectionOptionD" type="text"
							name="SingleSelectionOptionD" required
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							lay-verify="required" placeholder="如'3'" autocomplete="off"
							class="layui-input">
					</div>
					<!-- 正确答案 -->
					<br /> <br /> <br /> <label class="layui-form-label"
						style="background-color: #009688;">答案</label>
					<div class="layui-input-inline">
						<select id="SingleSelectioAnswer">
							<option value="A">A</option>
							<option value="B">B</option>
							<option value="C">C</option>
							<option value="D">D</option>
						</select>
					</div>
					<script>
					layui.use('form', function() {
					var form = layui.form;
					form.render(); 
					});
					</script>
					<!-- 本题备注 -->
					<br /> <br /> <br /> <label class="layui-form-label"
						style="background-color: #009688;">备注</label>
					<div class="layui-input-inline">
						<input id="SingleSelectionNote" type="text"
							name="SingleSelectionNote"
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
						   placeholder="如：考察学生逻辑思维" autocomplete="off"
							class="layui-input">
					</div>
					<br /> <br /> <br /> <input id="SingleSelectionButton"
						class="layui-btn" style="width: 8em" lay-submit
						onclick="saveSingleSelection()" type="button" value="保存" />
						<input id="ChangeSingleSelectionButton"
						class="layui-btn" style="width: 8em;display: none;" lay-submit
						onclick="saveTiMuChange()" type="button" value="保存修改" />
						<button style=" margin-left: 5%; width: 8em"
						type="reset" class="layui-btn layui-btn-primary">重置</button>
				</form>
			</div>
			

			<!-- 已出单选 -->
			<ul id="SingleSelectionShowUl" class="layui-timeline"
				style="margin-left: 5em;">

			</ul>
			<script type="text/javascript">
			layui.use([ 'form', 'laydate' ], function() {
				var form = layui.form, laydate = layui.laydate;
					form.render(); 
				form.verify({
					idvalidate:[/(.+){1,20}$/,'试卷名称必须是1到20位字符'],
					math:[/^[1-9]\d*/,'输入为大于零的正整数'],
				});
			});
				//点击保存单选题
				  function saveSingleSelection() {
					if($('#SingleSelectionQuestionContent').val != "" && $('#SingleSelectionValue').val != ""&& $('#SingleSelectionOptionA').val != ""
						&& $('#SingleSelectionOptionB').val != ""&& $('#SingleSelectionOptionC').val != ""&& $('#SingleSelectionOptionD').val != ""&& $('#SingleSelectioAnswer').val != ""
							&& $('#SingleSelectionNote').val != ""){
						$.ajax({
					        type: "GET",
					        data: {
					         "examinationId":$('#examinationIddd').val(),
					       	 "questionContent":$('#SingleSelectionQuestionContent').val(),
					       	 "singleSelectionValue":$('#SingleSelectionValue').val(),
					       	 "optionA":$('#SingleSelectionOptionA').val(),
					         "optionB":$('#SingleSelectionOptionB').val(),
					       	 "optionC":$('#SingleSelectionOptionC').val(),
					       	 "optionD":$('#SingleSelectionOptionD').val(),
					         "answer":$('#SingleSelectioAnswer').val(),
					         "note":$('#SingleSelectionNote').val()
					        },
					        contentType: "application/json; charset=utf-8",
					        async: false,
					        url: "<%=request.getContextPath()%>/exam/addSingleSelection.do",
							success : function(data) {
								if(data.result == true){
									createQuestion($('#examinationIddd').val());
									//window.location.hash = "#mark1";   
									layui.use('layer', function() {
										var $ = layui.jquery, layer = layui.layer;
										layer.msg('添加单选成功!');
										//$('#singleWait')[0].reset();
									});
								}else {
									if(data.result == "no"){
										layui.use('layer', function(){ //独立版的layer无需执行这一句
							  	               var $ = layui.jquery, layer = layui.layer; 
							  	             //触发事件
							    			      layer.open({
							    			        type: 1
							    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
							    			        ,id: 'layerDemo'+'auto' //防止重复弹出
							    			        ,title: '提示'
							    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "分数超出总分.." +'</div>'
							    			        ,btn: '关闭'
							    			        ,btnAlign: 'c' //按钮居中
							    			        ,skin: 'demo-class'
							    			        ,shade: 0 //不显示遮罩
							    			        ,yes: function(){
							    			        	 layer.closeAll();
							    			        }
							    			      });
							  	            });
										//alert("分数超出总分，请合理分配分数..");
									}else
										layui.use('layer', function(){ //独立版的layer无需执行这一句
							  	               var $ = layui.jquery, layer = layui.layer; 
							  	             //触发事件
							    			      layer.open({
							    			        type: 1
							    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
							    			        ,id: 'layerDemo'+'auto' //防止重复弹出
							    			        ,title: '失败'
							    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "单选题添加失败.." +'</div>'
							    			        ,btn: '关闭'
							    			        ,btnAlign: 'c' //按钮居中
							    			        ,skin: 'demo-class'
							    			        ,shade: 0 //不显示遮罩
							    			        ,yes: function(){
							    			        	 layer.closeAll();
							    			        }
							    			      });
							  	            });
								}
							},
							error : function(data) {
								//alert("??");
							},
							dataType : "json",
						});
					}
				}
				</script>

			<!-- 多选 -->
			<div id="mark1" class="layui-form-item">
				<label class="layui-form-label"
					style="background-color: #009688; text-align: center;">多选</label> <a
					id="SingleSelectionA" onclick="MoreSelectionA()" href="#"
					style="margin-left: 5%;"> <i id="MoreSelectionI"
					class="layui-icon" style="font-size: 30px; color: #1E9FFF;">&#xe608;</i>
					<i id="MoreSelectionII" class="layui-icon"
					style="font-size: 30px; color: #009688; display: none;">&#xe625;</i>
				</a>
			</div>

			<!-- 多选部分 -->
			<div id="MoreSelectionADetail" class="layui-form-item"
				style="display: none; margin-left: 20px;">
				<form class="layui-form layui-form-pane">
					<label class="layui-form-label" style="background-color: #009688;">*问题*</label>
					<div class="layui-input-inline">
						<input id="MoreSelectionQuestionContent" type="text"
							name="MoreSelectionQuestionContent" required
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							lay-verify="required" placeholder="如'1+1=?'" autocomplete="off"
							class="layui-input">
					</div>
					<!-- 分值 -->
					<br /> <br /> <br /> <label class="layui-form-label"
						style="background-color: #009688;">分值</label>
					<div class="layui-input-inline">
						<input id="MoreSelectionValue" type="text"
							name="MoreSelectionValue" required
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							lay-verify="required|math" placeholder="本题分值" autocomplete="off"
							class="layui-input">
					</div>
					<!-- 选项A -->
					<br /> <br /> <br /> <label class="layui-form-label"
						style="background-color: #009688;">*选项A*</label>
					<div class="layui-input-inline">
						<input id="MoreSelectionOptionA" type="text"
							name="MoreSelectionOptionA" required
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							lay-verify="required" placeholder="如'0'" autocomplete="off"
							class="layui-input">
					</div>
					<!-- 选项B -->
					<br /> <br /> <br /> <label class="layui-form-label"
						style="background-color: #009688;">*选项B*</label>
					<div class="layui-input-inline">
						<input id="MoreSelectionOptionB" type="text"
							name="MoreSelectionOptionB" required
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							lay-verify="required" placeholder="如'1'" autocomplete="off"
							class="layui-input">
					</div>
					<!-- 选项C -->
					<br /> <br /> <br /> <label class="layui-form-label"
						style="background-color: #009688;">*选项C*</label>
					<div class="layui-input-inline">
						<input id="MoreSelectionOptionC" type="text"
							name="MoreSelectionOptionC" required
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							lay-verify="required" placeholder="如'2'" autocomplete="off"
							class="layui-input">
					</div>
					<!-- 选项D -->
					<br /> <br /> <br /> <label class="layui-form-label"
						style="background-color: #009688;">*选项D*</label>
					<div class="layui-input-inline">
						<input id="MoreSelectionOptionD" type="text"
							name="MoreSelectionOptionD" required
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							lay-verify="required" placeholder="如'3'" autocomplete="off"
							class="layui-input">
					</div>
					<!-- 正确答案 -->
					<br /> <br /> <br />
					<div class="layui-form-item">
						<label class="layui-form-label" style="background-color: #009688;">答案</label>
						<div class="layui-input-block">
							<input type="checkbox" name="MoreSelectionAnswer" value="A"
								title="A">
							<input type="checkbox"
								name="MoreSelectionAnswer" value="B" title="B" checked>
							<input type="checkbox" name="MoreSelectionAnswer" value="C"
								title="C"> 
							<input type="checkbox"
								name="MoreSelectionAnswer" value="D" title="D">
						</div>
					</div>

					<!-- 本题备注 -->
					<label class="layui-form-label" style="background-color: #009688;">备注</label>
					<div class="layui-input-inline">
						<input id="MoreSelectionNote" class="layui-input" type="text" name="MoreSelectionNote" style="border-top: none; border-left: none; border-right: none; border-color: #009688;" placeholder="如：考察学生发散思维" autocomplete="off">
					</div>
					<br /> <br /> <br /> <input id="MoreSelectionButton"
						class="layui-btn" style="width: 8em" lay-submit
						onclick="saveMoreSelection()" type="button" value="保存" />
						<input id="ChangeMoreSelectionButton"
						class="layui-btn" style="width: 8em;display: none;" lay-submit
						onclick="saveTiMuChange()" type="button" value="保存修改" />
						<button style=" margin-left: 5%; width: 8em"
						type="reset" class="layui-btn layui-btn-primary">重置</button>
				</form>
			</div>
			<script type="text/javascript">
			layui.use([ 'form', 'laydate' ], function() {
				var form = layui.form, laydate = layui.laydate;
				form.render(); 	
				form.verify({
					math:[/^[1-9]\d*/,'输入为大于零的正整数'],
				});
			});
				//点击保存多选题
				  function saveMoreSelection() {
					if($('#MoreSelectionQuestionContent').val != "" && $('#MoreSelectionValue').val != ""&& $('#MoreSelectionOptionA').val != ""
						&& $('#MoreSelectionOptionB').val != ""&& $('#MoreSelectionOptionC').val != ""&& $('#MoreSelectionOptionD').val != ""&& $('#MoreSelectionAnswer').val != ""
							&& $('#MoreSelectionNote').val != ""){
						    var answer = "";
					        $("input:checkbox[name='MoreSelectionAnswer']:checked").each(function() {
					        	answer += $(this).val() + " ";
					        });
						$.ajax({
					        type: "GET",
					        data: {
					         "examinationId":$('#examinationIddd').val(),
					       	 "questionContent":$('#MoreSelectionQuestionContent').val(),
					       	 "MoreSelectionValue":$('#MoreSelectionValue').val(),
					       	 "optionA":$('#MoreSelectionOptionA').val(),
					         "optionB":$('#MoreSelectionOptionB').val(),
					       	 "optionC":$('#MoreSelectionOptionC').val(),
					       	 "optionD":$('#MoreSelectionOptionD').val(),
					         "note":$('#MoreSelectionNote').val(),
					         "answer": answer
					        },
					        contentType: "application/json; charset=utf-8",
					        async: false,
					        url: "<%=request.getContextPath()%>/exam/addMoreSelection.do",
							success : function(data) {
								if(data.result == true){
									createQuestion($('#examinationIddd').val());
									layui.use('layer', function() {
										var $ = layui.jquery, layer = layui.layer;
										layer.msg('添加多选成功!');
									});
									//window.location.hash = "#mark2";   
								}else {
									if(data.result == "no"){
										layui.use('layer', function(){ //独立版的layer无需执行这一句
							  	               var $ = layui.jquery, layer = layui.layer; 
							  	             //触发事件
							    			      layer.open({
							    			        type: 1
							    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
							    			        ,id: 'layerDemo'+'auto' //防止重复弹出
							    			        ,title: '提示'
							    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "分数超出总分.." +'</div>'
							    			        ,btn: '关闭'
							    			        ,btnAlign: 'c' //按钮居中
							    			        ,skin: 'demo-class'
							    			        ,shade: 0 //不显示遮罩
							    			        ,yes: function(){
							    			        	 layer.closeAll();
							    			        }
							    			      });
							  	            });
									}else
										layui.use('layer', function(){ //独立版的layer无需执行这一句
							  	               var $ = layui.jquery, layer = layui.layer; 
							  	             //触发事件
							    			      layer.open({
							    			        type: 1
							    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
							    			        ,id: 'layerDemo'+'auto' //防止重复弹出
							    			        ,title: '失败'
							    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "多选题添加失败.." +'</div>'
							    			        ,btn: '关闭'
							    			        ,btnAlign: 'c' //按钮居中
							    			        ,skin: 'demo-class'
							    			        ,shade: 0 //不显示遮罩
							    			        ,yes: function(){
							    			        	 layer.closeAll();
							    			        }
							    			      });
							  	            });
								}
							},
							error : function(data) {
								//alert("??");
							},
							dataType : "json",
						});
					}
				}
				</script>

			<!-- 已出多选 -->
			<ul id="MoreSelectionShowUl" class="layui-timeline"
				style="margin-left: 5em">

			</ul>

			<!-- 判断 -->
			<div id="mark2" class="layui-form-item">
				<label class="layui-form-label"
					style="background-color: #009688; text-align: center;">判断</label> <a
					id="SingleSelectionA" onclick="JudgeA()" href="#"
					style="margin-left: 5%;"> <i id="JudgeI" class="layui-icon"
					style="font-size: 30px; color: #1E9FFF;">&#xe608;</i> <i
					id="JudgeII" class="layui-icon"
					style="font-size: 30px; color: #009688; display: none;">&#xe625;</i>
				</a>
			</div>

			<!-- 判断部分 -->
			<div id="JudgeDetail" class="layui-form-item"
				style="display: none; margin-left: 20px;">
				<form class="layui-form layui-form-pane">
					<label class="layui-form-label" style="background-color: #009688;">*问题*</label>
					<div class="layui-input-inline">
						<input id="JudgeQuestionContent" type="text"
							name="JudgeQuestionContent" required
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							lay-verify="required" placeholder="如'1+1=0'" autocomplete="off"
							class="layui-input">
					</div>
					<!-- 分值 -->
					<br /> <br /> <br /> <label class="layui-form-label"
						style="background-color: #009688;">分值</label>
					<div class="layui-input-inline">
						<input id="JudgeValue" type="text" name="JudgeValue" required
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							lay-verify="required|math" placeholder="本题分值" autocomplete="off"
							class="layui-input">
					</div>

					<!-- 正确答案 -->
					<br /> <br /> <br />
					<div class="layui-form-item">
						<label class="layui-form-label" style="background-color: #009688;">答案</label>
						<div class="layui-input-block">
							<input type="radio" name="JudgeAnswer" value="true" title="true">
							<input type="radio" name="JudgeAnswer" value="false"
								title="false" checked>
						</div>
					</div>

					<!-- 本题备注 -->
					<label class="layui-form-label" style="background-color: #009688;">备注</label>
					<div class="layui-input-inline">
						<input id="JudgeNote" type="text" name="JudgeNote"
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							placeholder="如：考察学生判断能力" autocomplete="off"
							class="layui-input">
					</div>
					<br /> <br /> <br /> <input id="JudgeButton" class="layui-btn"
						style="width: 8em" lay-submit onclick="saveJudge()" type="button"
						value="保存" />
						<input id="ChangeJudgeButton"
						class="layui-btn" style="width: 8em;display: none;" lay-submit
						onclick="saveTiMuChange()" type="button" value="保存修改" />
						<button style=" margin-left: 5%; width: 8em"
						type="reset" class="layui-btn layui-btn-primary">重置</button>
				</form>
			</div>
			<script type="text/javascript">
			layui.use([ 'form', 'laydate' ], function() {
				var form = layui.form, laydate = layui.laydate;
				form.render(); 
				form.verify({
					math:[/^[1-9]\d*/,'输入为大于零的正整数'],
				});
			});
				//点击保存判断题
				  function saveJudge() {
					if($('#JudgeQuestionContent').val != "" && $('#JudgeValue').val != ""
						&& $('#JudgeAnswer').val != ""
							&& $('#JudgeNote').val != ""){
						   
						$.ajax({
					        type: "GET",
					        data: {
					         "examinationId":$('#examinationIddd').val(),
					       	 "questionContent":$('#JudgeQuestionContent').val(),
					       	 "JudgeValue":$('#JudgeValue').val(),
					         "note":$('#JudgeNote').val(),
					         "answer":$("input[name='JudgeAnswer']").val()
					        },
					        contentType: "application/json; charset=utf-8",
					        async: false,
					        url: "<%=request.getContextPath()%>/exam/addJudgeAnswer.do",
							success : function(data) {
								if(data.result == true){
									createQuestion($('#examinationIddd').val());
									layui.use('layer', function() {
										var $ = layui.jquery, layer = layui.layer;
										layer.msg('添加判断成功!');
									});
									//window.location.hash = "#mark3";   
								}else {
									if(data.result == "no"){
										layui.use('layer', function(){ //独立版的layer无需执行这一句
							  	               var $ = layui.jquery, layer = layui.layer; 
							  	             //触发事件
							    			      layer.open({
							    			        type: 1
							    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
							    			        ,id: 'layerDemo'+'auto' //防止重复弹出
							    			        ,title: '提示'
							    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "分数超出总分.." +'</div>'
							    			        ,btn: '关闭'
							    			        ,btnAlign: 'c' //按钮居中
							    			        ,skin: 'demo-class'
							    			        ,shade: 0 //不显示遮罩
							    			        ,yes: function(){
							    			        	 layer.closeAll();
							    			        }
							    			      });
							  	            });
									}else
										layui.use('layer', function(){ //独立版的layer无需执行这一句
							  	               var $ = layui.jquery, layer = layui.layer; 
							  	             //触发事件
							    			      layer.open({
							    			        type: 1
							    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
							    			        ,id: 'layerDemo'+'auto' //防止重复弹出
							    			        ,title: '失败'
							    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "判断题添加失败.." +'</div>'
							    			        ,btn: '关闭'
							    			        ,btnAlign: 'c' //按钮居中
							    			        ,skin: 'demo-class'
							    			        ,shade: 0 //不显示遮罩
							    			        ,yes: function(){
							    			        	 layer.closeAll();
							    			        }
							    			      });
							  	            });
								}
							},
							error : function(data) {
								//alert("??");
							},
							dataType : "json",
						});
					}
				}
				</script>

			<!-- 已出判断 -->
			<ul id="JudgeShowUl" class="layui-timeline" style="margin-left: 5em">

			</ul>


			<!-- 填空 -->
			<div id="mark3" class="layui-form-item">
				<label class="layui-form-label"
					style="background-color: #009688; text-align: center;">填空</label> <a
					id="PackA" onclick="PackA()" href="#" style="margin-left: 5%;">
					<i id="PackI" class="layui-icon"
					style="font-size: 30px; color: #1E9FFF;">&#xe608;</i> <i
					id="PackII" class="layui-icon"
					style="font-size: 30px; color: #009688; display: none;">&#xe625;</i>
				</a>
			</div>

			<!-- 填空部分 -->
			<div id="PackDetail" class="layui-form-item"
				style="display: none; margin-left: 20px;">
				<form class="layui-form layui-form-pane">
					<label class="layui-form-label" style="background-color: #009688;">*问题*</label>
					<div class="layui-input-inline">
						<input id="PackQuestionContent" type="text"
							name="PackQuestionContent" required
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							lay-verify="required" placeholder="如'1+1=?'" autocomplete="off"
							class="layui-input">
					</div>
					<!-- 分值 -->
					<br /> <br /> <br /> <label class="layui-form-label"
						style="background-color: #009688;">分值</label>
					<div class="layui-input-inline">
						<input id="PackValue" type="text" name="PackValue" required
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							lay-verify="required|math" placeholder="本题分值" autocomplete="off"
							class="layui-input">
					</div>

					<!-- 正确答案 -->
					<br /> <br /> <br />
					<div class="layui-form-item">
						<label class="layui-form-label" style="background-color: #009688;">参考答案</label>
						<div class="layui-input-inline">
							<input id="Packanswer" type="text" name="Packanswer" required
								style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
								lay-verify="required" placeholder="如'3'" autocomplete="off"
								class="layui-input">
						</div>
					</div>

					<!-- 本题备注 -->
					<label class="layui-form-label" style="background-color: #009688;">备注</label>
					<div class="layui-input-inline">
						<input id="PackNote" type="text" name="PackNote"
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							placeholder="如：考察学生计算能力" autocomplete="off"
							class="layui-input">
					</div>
					<br /> <br /> <br /> <input id="PackButton" class="layui-btn"
						style="width: 8em" lay-submit onclick="savePack()" type="button"
						value="保存" />
						<input id="ChangePackButton"
						class="layui-btn" style="width: 8em;display: none;" lay-submit
						onclick="saveTiMuChange()" type="button" value="保存修改" />
						<button style=" margin-left: 5%; width: 8em"
						type="reset" class="layui-btn layui-btn-primary">重置</button>
				</form>
			</div>
			<script type="text/javascript">
			layui.use([ 'form', 'laydate' ], function() {
				var form = layui.form, laydate = layui.laydate;
				form.verify({
					math:[/^[1-9]\d*/,'输入为大于零的正整数'],
				});
			});
				//点击保存填空题
				  function savePack() {
					if($('#PackQuestionContent').val != "" && $('#PackValue').val != ""
						&& $('#PackAnswer').val != ""
							&& $('#PackNote').val != ""){
						   
						$.ajax({
					        type: "GET",
					        data: {
					         "examinationId":$('#examinationIddd').val(),
					       	 "questionContent":$('#PackQuestionContent').val(),
					       	 "PackValue":$('#PackValue').val(),
					         "note":$('#PackNote').val(),
					         "answer":$('#Packanswer').val()
					        },
					        contentType: "application/json; charset=utf-8",
					        async: false,
					        url: "<%=request.getContextPath()%>/exam/addPack.do",
							success : function(data) {
								if(data.result == true){
									createQuestion($('#examinationIddd').val());
									layui.use('layer', function() {
										var $ = layui.jquery, layer = layui.layer;
										layer.msg('添加填空成功!');
									});
									//window.location.hash = "#mark4";   
								}else {
									if(data.result == "no"){
										layui.use('layer', function(){ //独立版的layer无需执行这一句
							  	               var $ = layui.jquery, layer = layui.layer; 
							  	             //触发事件
							    			      layer.open({
							    			        type: 1
							    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
							    			        ,id: 'layerDemo'+'auto' //防止重复弹出
							    			        ,title: '提示'
							    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "分数超出总分.." +'</div>'
							    			        ,btn: '关闭'
							    			        ,btnAlign: 'c' //按钮居中
							    			        ,skin: 'demo-class'
							    			        ,shade: 0 //不显示遮罩
							    			        ,yes: function(){
							    			        	 layer.closeAll();
							    			        }
							    			      });
							  	            });
									}else
										layui.use('layer', function(){ //独立版的layer无需执行这一句
							  	               var $ = layui.jquery, layer = layui.layer; 
							  	             //触发事件
							    			      layer.open({
							    			        type: 1
							    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
							    			        ,id: 'layerDemo'+'auto' //防止重复弹出
							    			        ,title: '失败'
							    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "填空题添加失败.." +'</div>'
							    			        ,btn: '关闭'
							    			        ,btnAlign: 'c' //按钮居中
							    			        ,skin: 'demo-class'
							    			        ,shade: 0 //不显示遮罩
							    			        ,yes: function(){
							    			        	 layer.closeAll();
							    			        }
							    			      });
							  	            });
								}
							},
							error : function(data) {
								//alert("??");
							},
							dataType : "json",
						});
					}
				}
				</script>

			<!-- 已出填空 -->
			<ul id="PackShowUl" class="layui-timeline" style="margin-left: 5em">

			</ul>


			<!-- 简答 -->
			<div id="mark4" class="layui-form-item">
				<label class="layui-form-label"
					style="background-color: #009688; text-align: center;">简答</label> <a
					id="ShortAnswerA" onclick="ShortAnswerA()" href="#"
					style="margin-left: 5%;"> <i id="ShortAnswerI"
					class="layui-icon" style="font-size: 30px; color: #1E9FFF;">&#xe608;</i>
					<i id="ShortAnswerII" class="layui-icon"
					style="font-size: 30px; color: #009688; display: none;">&#xe625;</i>
				</a>
			</div>

			<!-- 简答部分 -->
			<div id="ShortAnswerDetail" class="layui-form-item"
				style="display: none; margin-left: 20px;">
				<form class="layui-form layui-form-pane">
					<label class="layui-form-label" style="background-color: #009688;">*问题*</label>
					<div class="layui-input-inline">
						<input id="ShortAnswerQuestionContent" type="text"
							name="ShortAnswerQuestionContent" required
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							lay-verify="required" placeholder="如'1+1=?'" autocomplete="off"
							class="layui-input">
					</div>
					<!-- 分值 -->
					<br /> <br /> <br /> <label class="layui-form-label"
						style="background-color: #009688;">分值</label>
					<div class="layui-input-inline">
						<input id="ShortAnswerValue" type="text" name="ShortAnswerValue"
							required
							style="border-top: none; border-left: none; border-right: none; border-color: #009688;"
							lay-verify="required|math" placeholder="本题分值" autocomplete="off"
							class="layui-input">
					</div>
					<br /> <br /> <br />
					<!-- 本题备注 -->
					<label class="layui-form-label" style="background-color: #009688;">备注</label>
					<div class="layui-input-inline">
						<input id="ShortAnswerNote" type="text" name="ShortAnswerNote" style="border-top: none; border-left: none; border-right: none; border-color: #009688;" placeholder="如：考察学生综合能力" autocomplete="off"
							class="layui-input">
					</div>
					<br /> <br /> <br /> <input id="ShortAnswerButton"
						class="layui-btn" style="width: 8em" lay-submit
						onclick="saveShortAnswer()" type="button" value="保存" />
						<input id="ChangeShortAnswerButton"
						class="layui-btn" style="width: 8em;display: none;" lay-submit
						onclick="saveTiMuChange()" type="button" value="保存修改" />
						<button style=" margin-left: 5%; width: 8em"
						type="reset" class="layui-btn layui-btn-primary">重置</button>
				</form>
			</div>
			<script type="text/javascript">
			layui.use([ 'form', 'laydate' ], function() {
				var form = layui.form, laydate = layui.laydate;
				form.verify({
					math:[/^[1-9]\d*/,'输入为大于零的正整数'],
				});
			});
				//点击保存简答题
				  function saveShortAnswer() {
					if($('#ShortAnswerQuestionContent').val != "" && $('#ShortAnswerValue').val != ""
							&& $('#ShortAnswerNote').val != ""){
						   
						$.ajax({
					        type: "GET",
					        data: {
					         "examinationId":$('#examinationIddd').val(),
					       	 "questionContent":$('#ShortAnswerQuestionContent').val(),
					       	 "ShortAnswerValue":$('#ShortAnswerValue').val(),
					         "note":$('#ShortAnswerNote').val()
					        },
					        contentType: "application/json; charset=utf-8",
					        async: false,
					        url: "<%=request.getContextPath()%>/exam/addShortAnswer.do",
							success : function(data) {
								if(data.result == true){
									createQuestion($('#examinationIddd').val());
									layui.use('layer', function() {
										var $ = layui.jquery, layer = layui.layer;
										layer.msg('添加简答成功!');
									});
									//window.location.hash = "#mark4";   
								}else {
									if(data.result == "no"){
										layui.use('layer', function(){ //独立版的layer无需执行这一句
							  	               var $ = layui.jquery, layer = layui.layer; 
							  	             //触发事件
							    			      layer.open({
							    			        type: 1
							    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
							    			        ,id: 'layerDemo'+'auto' //防止重复弹出
							    			        ,title: '提示'
							    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "分数超出总分.." +'</div>'
							    			        ,btn: '关闭'
							    			        ,btnAlign: 'c' //按钮居中
							    			        ,skin: 'demo-class'
							    			        ,shade: 0 //不显示遮罩
							    			        ,yes: function(){
							    			        	 layer.closeAll();
							    			        }
							    			      });
							  	            });
									}else
										layui.use('layer', function(){ //独立版的layer无需执行这一句
							  	               var $ = layui.jquery, layer = layui.layer; 
							  	             //触发事件
							    			      layer.open({
							    			        type: 1
							    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
							    			        ,id: 'layerDemo'+'auto' //防止重复弹出
							    			        ,title: '失败'
							    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "简答题添加失败.." +'</div>'
							    			        ,btn: '关闭'
							    			        ,btnAlign: 'c' //按钮居中
							    			        ,skin: 'demo-class'
							    			        ,shade: 0 //不显示遮罩
							    			        ,yes: function(){
							    			        	 layer.closeAll();
							    			        }
							    			      });
							  	            });
								}
							},
							error : function(data) {
								//alert("??");
							},
							dataType : "json",
						});
					}
				}
				</script>

			<!-- 已出简答 -->
			<ul id="ShortAnswerShowUl" class="layui-timeline"
				style="margin-left: 5em">

			</ul>


			<!-- 提交 -->
			<div id="mark5" class="layui-form-item">
				<input id="" class="layui-btn" style="width: 8em;"
					onclick="updateEditStatus()" type="button" value="生成试卷" />
			</div>

		</div>
		<script type="text/javascript">
			    //点击添加图标触发以下
			      function SingleSelectionA() {
					$('#SingleSelectionI').toggle();
					$('#SingleSelectionII').toggle();
					$('#SingleSelectionDetail').toggle();
				}
			      function MoreSelectionA() {
			        $('#MoreSelectionI').toggle();
					$('#MoreSelectionII').toggle();
				    $('#MoreSelectionADetail').toggle();
				}
			      function JudgeA() {
				        $('#JudgeI').toggle();
						$('#JudgeII').toggle();
					    $('#JudgeDetail').toggle();
					}
			      function PackA() {
				        $('#PackI').toggle();
						$('#PackII').toggle();
					    $('#PackDetail').toggle();
					}
			      function ShortAnswerA() {
				        $('#ShortAnswerI').toggle();
						$('#ShortAnswerII').toggle();
					    $('#ShortAnswerDetail').toggle();
					}
			      //更新试卷状态是否可以出题
			      function updateEditStatus() {
			  		$.ajax({
				        type: "GET",
				        data: {
				        	"examinationId":$('#examinationIddd').val()
				        },
				        contentType: "application/json; charset=utf-8",
				        async: true,
				        url: "<%=request.getContextPath()%>/exam/updateEditStatus.do",
						success : function(data) {
							if(data.result == true){
								layui.use('layer', function(){ //独立版的layer无需执行这一句
					  	               var $ = layui.jquery, layer = layui.layer; 
					  	             //触发事件
					    			      layer.open({
					    			        type: 1
					    			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
					    			        ,id: 'layerDemo'+'auto' //防止重复弹出
					    			        ,title: '成功'
					    			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "提交成功，等待考试.." +'</div>'
					    			        ,btn: '关闭'
					    			        ,btnAlign: 'c' //按钮居中
					    			        ,skin: 'demo-class'
					    			        ,shade: 0 //不显示遮罩
					    			        ,yes: function(){
					    			        	setTimeout('addExamination()',500);
					    			        	 layer.closeAll();
					    			        }
					    			      });
					  	            });
								//$('#afterSubmitExamination').show();
				               // setTimeout('addExamination()',1500);
							}else {
								layui.use('layer', function(){ //独立版的layer无需执行这一句
					               var $ = layui.jquery, layer = layui.layer; 
					             //触发事件
		               
		            			      layer.open({
		            			        type: 1
		            			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
		            			        ,id: 'layerDemo'+'auto' //防止重复弹出
		            			        ,title: '提示'
		            			        ,content: '<div style="padding: 20px 100px;">'+"您还有" + data.result + "分未分配.."+'</div>'
		            			        ,btn: '关闭'
		            			        ,btnAlign: 'c' //按钮居中
		            			        ,shade: 0 //不显示遮罩
		            			        ,yes: function(){
		            			          layer.closeAll();
		            			        }
		            			      });
					               });
							}
						},
						error : function(data) {
							alert("??");
						},
						dataType : "json",
					});
				}
			    </script>
			    
		<!-- 教师改卷 -->	   
		<div id="studentExam" class="site-text site-block"
			style="display: none;margin-top: 0; padding-left: 0; padding-right: 0;"> 
           <!-- 试卷列表 -->
			<table id="PreExaminationList" class="layui-table" lay-skin="line"  lay-even
				style="text-align: center; width: 100%;">
				<colgroup>
					<col width="80">
					<col width="100">
					<col width="90">
					<col width="100">
					<col width="100">
					<col width="80">
					<col width="110">
				</colgroup>
				<thead>
					<tr id="title">
						<th style="text-align: center;">试卷编码</th>
						<th style="text-align: center;">试卷名称</th>
						<th style="text-align: center;">考试码</th>
						<th style="text-align: center;">总分</th>
						<th style="text-align: center;">开始时间</th>
						<th style="text-align: center;">考试时长</th>
						<th style="text-align: center;">操作</th>
					</tr>
				</thead>
				<tbody id="teacherExaminationShowTable">

				</tbody>
			</table>
			
			<!-- 学生的试卷/答案列表 -->
			<h3 id="studentScoreListH3" style="display: none;color: #FF5722;">判断和简答需要您手动判题🙂</h3>
			<table id="studentScoreList" class="layui-table" lay-even
				style="text-align: center; width: 100%; display: none;">
				<colgroup>
					<col width="80">
					<col width="80">
					<col width="80">
					<col width="80">
					<col width="80">
					<col width="80">
					<col width="80">
					<col width="80">
					<col width="80">
					<col width="80">
				</colgroup>
				<thead>
					<tr id="title">
						<th style="text-align: center;">学号</th>
						<th style="text-align: center;">姓名</th>
						<th style="text-align: center;">班级</th>
						<th style="text-align: center;">单选</th>
						<th style="text-align: center;">多选</th>
						<th style="text-align: center;">判断</th>
						<th style="text-align: center;">填空</th>
						<th style="text-align: center;">简答</th>
						<th style="text-align: center;">得分</th>
						<th style="text-align: center;">状态</th>
					</tr>
				</thead>
				<tbody id="ScoreList">

				</tbody>
			</table>
			
			
	    <form class="layui-form layui-form-pane">
	    <!-- 填空部分打分 -->
		<div id="packScore"
		style="background-color: white; margin-left: 5%; padding-left0;
		margin-right: 5%; padding-top: 10px; font-family: 微软雅黑;display: none;">
		
		<a onclick="returnUp01()" href="#" style="color: #009688;margin-left: 13px;"><i class="layui-icon" style="font-size: 15px; color: #009688;">&#xe65a;</i>&nbsp;返回上一层</a>
		<br/><hr class="layui-bg-red">
		<input id="ssscoreId" type="text" style="display: none;"/>
		<h3 style="font-size: 1.4em;color: #5FB878;"><四>填空<span style="font-size: 0.8em"></span></h3>
		<br />
		<ul id="PackLi">
	
		</ul>
	   </div>
	   
	   <!-- 简答部分打分 -->
	   <div id="ShortAnswerScore"
		style="background-color: white; margin-left: 5%; padding-left0;
		margin-right: 5%; padding-top: 10px; font-family: 微软雅黑;display: none;">
		<h3 style="font-size: 1.4em;color: #5FB878;"><五>简答<span style="font-size: 0.8em"></span></h3>
		<br />
		<ul id="ShortAnswerLi">
	
		</ul>
		<br/><br/>
		<input id="changeExamEndX" style="display: none;"/>
		<input class="layui-btn" style="width: 8em" 
						onclick="changeExamEndXX()" type="button" value="批改完成" />
	   </div>
	   
	   
	  </form>
			
			<script>
			//返回批改试卷上一层
			function returnUp01() {
				$('#messageList').html("批改试卷");
				getStudentExamList($('#changeExamEndX').val());
				$('#packScore').hide();
				$('#ShortAnswerScore').hide();
			}
			//查看成绩返回上一层
			function returnUp02() {
				scoreFormList();
			}
			
			layui.use([ 'form', 'laydate' ], function() {
				var form = layui.form, laydate = layui.laydate;
				form.verify({
					math:[/^[1-9]\d*/,'输入为大于零的正整数'],
				});
			});
				layui.use('table', function() {
					var table = layui.table;
				});
			    </script>
		</div>
		
		
		<!-- 显示成绩单 -->	   
		<div id="scoreFormList" class="site-text site-block"
			style="display: none;margin-top: 0; padding-left: 0; padding-right: 0;"> 
	        
	        <input id="studentScoreTem" type="text" style="display: none;"/>
	        <table id="scoreShowTableFirst" class="layui-table" lay-even lay-skin="row"
				style="text-align: center; width: 100%;">
				<colgroup>
					<col width="80">
					<col width="100">
					<col width="90">
					<col width="100">
					<col width="100">
					<col width="80">
					<col width="110">
					<col width="130">
				</colgroup>
				<thead>
					<tr id="title">
						<th style="text-align: center;">试卷编码</th>
						<th style="text-align: center;">试卷名称</th>
						<th style="text-align: center;">考试码</th>
						<th style="text-align: center;">总分</th>
						<th style="text-align: center;">开始时间</th>
						<th style="text-align: center;">考试时长</th>
						<th style="text-align: center;">查看成绩</th>
						<th style="text-align: center;">导出成绩单</th>
					</tr>
				</thead>
				<tbody id="scoreShowTable">

				</tbody>
			</table>
			
			<div id="scoreShowTableSecond" style=" display: none;">
			<a onclick="returnUp02()" href="#" style="color: #009688;margin-left: 13px;"><i class="layui-icon" style="font-size: 15px; color: #009688;">&#xe65a;</i>&nbsp;返回上一层</a>
		    <br/><hr class="layui-bg-red">
			  
			  <table class="layui-table" lay-even
				style="text-align: center; width: 100%;">
				<caption>
				班级人数：<span id="classCount"></span>&nbsp;&nbsp;&nbsp;&nbsp;
				考试人数：<span id="classExamCount"></span>&nbsp;&nbsp;&nbsp;&nbsp;
				平均分：<span id="classAvgCount"></span>&nbsp;&nbsp;&nbsp;&nbsp;
				最高分：<span id="classMaxCount"></span>&nbsp;&nbsp;&nbsp;&nbsp;
				最低分：<span id="classMinCount"></span>&nbsp;&nbsp;&nbsp;&nbsp;
				</caption>
				<colgroup>
					<col width="80">
					<col width="80">
					<col width="60">
					<col width="60">
					<col width="70">
					<col width="70">
					<col width="70">
					<col width="70">
					<col width="70">
					<col width="80">
				</colgroup>
				<thead>
					<tr id="title">
						<th style="text-align: center;">学号</th>
						<th style="text-align: center;">姓名</th>
						<th style="text-align: center;">班级</th>
						<th style="text-align: center;">单选</th>
						<th style="text-align: center;">多选</th>
						<th style="text-align: center;">判断</th>
						<th style="text-align: center;">填空</th>
						<th style="text-align: center;">简答</th>
						<th style="text-align: center;">总分</th>
						<th style="text-align: center;">作弊</th>
					</tr>
				</thead>
				<tbody id="ScoreListaa">

				</tbody>
			</table>
			</div>
			
		</div>
		
		
		<!-- 上传文件 -->
		<div id="upLoadShow" class="site-text site-block"
			style="display: none; margin-top: 0;">
			<!-- 单个文件上传不能超过50M -->
			<span id="MaxUpload" style="color: red;">单个文件不能超过51200k</span><br />

			<div class="layui-upload">
				<form action="">
					<button type="button"
						class="layui-btn layui-btn-normal layui-btn-danger" id="testList">选择文件</button>
					<div class="layui-upload-list">
						<table class="layui-table">
							<thead>
								<tr>
									<th>文件名</th>
									<th>大小</th>
									<th>状态</th>
									<th>操作</th>
								</tr>
							</thead>
							<tbody id="demoList"></tbody>
						</table>
					</div>
					<button type="button" onclick="timeoutForFileList()"
						class="layui-btn" id="testListAction">开始上传</button>
				</form>
			</div>

			<!-- 个人资料 -->
			<div class="layui-form sessiontable "
				style="width: 100%; margin-left: 0">
				<table class="layui-table" lay-even>
					<colgroup>
						<col width="150">
						<col width="200">
						<col width="340">
					</colgroup>
					<thead>
						<tr>
							<th style="text-align: center;">文件类型</th>
							<th style="text-align: center;">上传时间</th>
							<th style="text-align: center;">文件名称</th>
						</tr>
					</thead>
					<tbody id="privateData">

					</tbody>
				</table>

				<script>
	layui.use('table', function() {
	var table = layui.table;
		});
</script>
			</div>

		</div>

		<script>
			var ttem;
			function giveValue(id) {
				var a = $('#fileType').val();
				ttem = a;
				$('#beGiveValue').val(ttem);
			}
            layui.use('upload', function(){
             var $ = layui.jquery
             ,upload = layui.upload;
             //设置上传文件单个大小
               //设定文件大小限制

             //文件上传列表JS
             var demoListView = $('#demoList')
             ,uploadListIns = upload.render({
               elem: '#testList'
               ,url: '<%=request.getContextPath()%>/teacher/teacherUpload.do',
												size : 51200 //限制文件大小，单位 KB(50M = 51200)
												,
												accept : 'file',
												data : {
													"courseId": ${course.courseId}
												},
												multiple : true,
												auto : false,
												bindAction : '#testListAction',
												exts : 'zip|rar|7z|pdf|xls|doc|ppt|docx|gif|bmp|jpeg|png|swf|svg|jpg|tiff|avi|mp4|rm|mov|asf|wmv|mkv|flv|mp3|wma|wav|asf|aac|mp3pro|vqf|flac',
												choose : function(obj) {
													var files = obj.pushFile(); //将每次选择的文件追加到文件队列
													//读取本地文件
													obj
															.preview(function(
																	index,
																	file,
																	result) {
																var tr = $([
																		'<tr id="upload-'+ index +'">',
																		'<td>'
																				+ file.name
																				+ '</td>',
																		'<td>'
																				+ (file.size / 1014)
																						.toFixed(1)
																				+ 'kb</td>',
																		'<td>等待上传</td>',
																		'<td>',
																		'<button class="layui-btn layui-btn-mini demo-reload layui-hide">重传</button>',
																		'<button class="layui-btn layui-btn-mini layui-btn-danger demo-delete">删除</button>',
																		'</td>',
																		'</tr>' ]
																		.join(''));

																//单个重传
																tr
																		.find(
																				'.demo-reload')
																		.on(
																				'click',
																				function() {
																					obj
																							.upload(
																									index,
																									file);
																				});

																//删除
																tr
																		.find(
																				'.demo-delete')
																		.on(
																				'click',
																				function() {
																					delete files[index]; //删除对应的文件
																					tr
																							.remove();
																				});

																demoListView
																		.append(tr);
															});
												},
												done : function(res, index,
														upload) {
													if (res.code == 0) { //上传成功
														var tr = demoListView.find('tr#upload-'+ index), tds = tr.children();
														tds.eq(2).html('<span style="color: #5FB878;">上传成功</span>');
														tds.eq(3).html(''); //清空操作
														delete files[index]; //删除文件队列已经上传成功的文件
														getPrivateData();
														return;
													}
													this.error(index, upload);
												},
												error : function(index, upload) {
													var tr = demoListView
															.find('tr#upload-'
																	+ index), tds = tr
															.children();
													tds
															.eq(2)
															.html(
																	'<span style="color: #FF5722;">上传失败</span>');
													tds
															.eq(3)
															.find(
																	'.demo-reload')
															.removeClass(
																	'layui-hide'); //显示重传
												}
											});
								});
			</script>

	</div>

	</div>
	
	<script>
		layui.use([ 'element', 'layer', 'table', 'util'], function() {
			var element = layui.element
			,$ = layui.jquery
			,layer = layui.layer
			,util = layui.util;
			
			//监听导航点击
			element.on('nav(demo)', function(elem) {
				//console.log(elem)
				layer.msg(elem.text());
			});
			//转换静态表格
			table.init('recordTable', {
			//设置高度
			//支持所有基础参数
			});

		});
	</script>

</body>
</html>