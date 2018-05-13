<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/css/studentPage.css">
<link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/layui/css/layui.css">
<script src="<%=request.getContextPath()%>/layui/layui.js "></script>
<script src="<%=request.getContextPath()%>/layui/mods/index.js"></script>

<title>学生</title>
<script type="text/javascript">
function   fresh(){  
	if(location.href.indexOf("?reload=true")<0){
	    location.href+="?reload=true";  
	   }  
	}
	
if('WebSocket' in window){
    websocket = new WebSocket('ws://192.168.11.202:8080/ClassManageSys/websocket.do');
    console.log("link success")
  }else{
    alert('当前浏览器不支持websocket，消息系统暂时无法使用..')
  }

	//连接发生错误的回调方法
	websocket.onerror = function(){
	   console.log("websocketError");
	};
	 
	//连接成功建立的回调方法
	websocket.onopen = function(event){
	    send();
	}
	//接收到消息的回调方法
	websocket.onmessage = function(event){
	     $('#TmessageCount').html(event.data);
	}
	 
	//连接关闭的回调方法
	websocket.onclose = function(){
		console.log("close");
	}
	
	//发送消息
	function send(){
	    if(websocket != null){
	    	websocket.send("${student.studentRoNo}");
	    }else {
	    	layui.use('layer', function() {
				var $ = layui.jquery, layer = layui.layer;
				layer.msg('websocket链接异常');
			});
		}
	}
	
	
	
layui.use(['form'], function(){
	var form = layui.form;
	});
	 $(document).ready(function () {
		 layui.use(['form'], function(){
			 var form = layui.form;

			 });
		 //检查入学时间是否为0
		 if(${student.intoSchoolYear} == '0'){
			 $('#innerTime').html("");
		 }
		
	 
		 //首先检查学生个人信息是否完善
		 if(${empty student.college} || ${empty student.special}||${empty student.intoSchoolYear}
		 ||${empty student.schoolRecord}||${empty student.birthDay}||${empty student.freeStyle}){
			 $('#redSignal').show();
			 $('#signalNow').show();
		 }
		 //如果消息数量为0
		 if(${messageCount} == 0){
			 $('#TmessageCount').hide();
		 }else {
			 $('#TmessageCount').show();
		}
		 //每1秒执行一次消息数量的查询
	    /* setInterval(gggetMessageCount,1000); */
		 function gggetMessageCount() {
			 $.ajax({
	             type: "GET",
	             data: {
	            	 "studentRoNo":$('#studentRoNo').val()
	             },
	             contentType: "application/json; charset=utf-8",
	             async: true,
	             url: "<%=request.getContextPath()%>/student/gggetMessageCount.do",
				success : function(data) {
					if(data.message > 0){
						$('#TmessageCount').html(data.message);
					}else {
						var TmessageCount = document.getElementById("TmessageCount")
						 TmessageCount.style.display="none";
					}
				},
				error : function(data) {
					
				},
				dataType : "json",
			});
		}
			
		 //该学生课程信息
		 $('#checkCourseShow').click(function name1() {
			 $('#messageList').html("课程信息");
			 $('#upLoadShow').hide();
			 $('#doubleHandle').hide();
			 $('#signal').hide();
			 $('#studentAddCourse').hide();
			 $('#seprateMessage').hide();
			 $('#messageShow').hide();
			 $('#insertCourseDiv').hide();
			 $('#fushuMessage').hide();
			 $('#studentInfoShow').hide();
			 $('#forStudentLogInfo').hide();
			 $('#studentLogInfo').hide();
			 $("#studentLogOfTime").hide();
			 $('#studentWork').hide();
			 $('#beforeLeaveMoudle').hide();
			 $('#afterLeaveMoudle').hide();
			 $('#examList').hide();
			 $('#lookData').hide();
			 $('#courseInfo').show();
		});
		 //个人中心
		 $('#studentInfoCenter').click(function name1() {
			 $('#messageList').html("个人中心");
			 $('#upLoadShow').hide();
			 $('#doubleHandle').hide();
			 $('#signal').hide();
			 $('#studentAddCourse').hide();
			 $('#seprateMessage').hide();
			 $('#messageShow').hide();
			 $('#insertCourseDiv').hide();
			 $('#fushuMessage').hide();
			 $('#courseInfo').hide();
			 $('#forStudentLogInfo').hide();
			 $('#studentLogInfo').hide();
			 $("#studentLogOfTime").hide();
			 $('#studentWork').hide();
			 $('#beforeLeaveMoudle').hide();
			 $('#lookData').hide();
			 $('#afterLeaveMoudle').hide();
			 $('#examList').hide();
			 $('#studentInfoShow').show();
		 });
		 //点击修改信息
		 $('#updateStudentInfoNow').click(function name1() {
			 $('#messageList').html("修改信息");
			 $('#upLoadShow').hide();
			 $('#doubleHandle').hide();
			 $('#signal').hide();
			 $('#studentAddCourse').hide();
			 $('#seprateMessage').hide();
			 $('#messageShow').hide();
			 $('#signalNow').hide();
			 $('#insertCourseDiv').hide();
			 $('#fushuMessage').hide();
			 $('#courseInfo').hide();
			 $('#forStudentLogInfo').hide();
			 $('#studentLogInfo').hide();
			 $("#studentLogOfTime").hide();
			 $('#studentWork').hide();
			 $('#beforeLeaveMoudle').hide();
			 $('#afterLeaveMoudle').hide();
			 $('#lookData').hide();
			 $('#examList').hide();
			 $('#studentInfoShow').show();
		 });
		 //点击操作日志
		 $('#studentLog').click(function name() {
			 $('#messageList').html("操作日志");
			 $('#upLoadShow').hide();
			 $('#doubleHandle').hide();
			 $('#signal').hide();
			 $('#studentAddCourse').hide();
			 $('#seprateMessage').hide();
			 $('#messageShow').hide();
			 $('#insertCourseDiv').hide();
			 $('#fushuMessage').hide();
			 $('#courseInfo').hide();
			 $('#studentInfoShow').hide();
			 $("#studentLogOfTime").hide();
			 $('#studentWork').hide();
			 $('#beforeLeaveMoudle').hide();
			 $('#lookData').hide();
			 $('#afterLeaveMoudle').hide();
			 $('#examList').hide();
			 $('#forStudentLogInfo').show();
			 $('#studentLogInfo').show();
		});
		 
		//点击消息
		  $('#messageButtton').click(function() {
			 $('#messageList').html("消息列表");
			 $('#upLoadShow').hide();
			 $('#doubleHandle').hide();
			 $('#signal').hide();
		     $('#studentAddCourse').hide();
		     $('#courseInfo').hide();
		     $('#insertCourseDiv').hide();
		     $('#fushuMessage').hide();
		     $('#studentInfoShow').hide();
			 $('#seprateMessage').show();
			 $('#forStudentLogInfo').hide();
			 $('#studentLogInfo').hide();
			 $("#studentLogOfTime").hide();
			 $('#studentWork').hide();
			 $('#beforeLeaveMoudle').hide();
			 $('#afterLeaveMoudle').hide();
			 $('#lookData').hide();
			 $('#examList').hide();
			 $('#messageShow').show();
			 layui.use('table', function(){
				  var table = layui.table;
				  table.reload('test', {});
			 });
			}); 
		 //手动添加课程
		 $('#addCourse').click(function name1() {
			 $('#messageList').html("添加课程");
			 $('#upLoadShow').hide();
				$('#courseInfo').hide();
				$('#doubleHandle').hide();
				$('#signal').hide();
				 $('#seprateMessage').hide();
				 $('#messageShow').hide();
				 $('#insertCourseDiv').hide();
				 $('#fushuMessage').hide();
				 $('#studentInfoShow').hide();
				 $('#forStudentLogInfo').hide();
				 $('#studentLogInfo').hide();
				 $("#studentLogOfTime").hide();
				 $('#studentWork').hide();
				 $('#beforeLeaveMoudle').hide();
				 $('#examList').hide();
				 $('#lookData').hide();
				 $('#afterLeaveMoudle').hide();
				$('#studentAddCourse').show();
			});
		 //安全管理
			$('#safeManage').click(function name1() {
				$('#messageList').html("修改密码");
				 $('#upLoadShow').hide();
				$('#courseInfo').hide();
				$('#studentAddCourse').hide();
				$('#doubleHandle').show();
				 $('#seprateMessage').hide();
				 $('#fushuMessage').hide();
				 $('#messageShow').hide();
				 $('#studentInfoShow').hide();
				 $('#insertCourseDiv').hide();
				 $("#studentLogOfTime").hide();
				 $('#forStudentLogInfo').hide();
				 $('#studentLogInfo').hide();
				 $('#studentWork').hide();
				 $('#beforeLeaveMoudle').hide();
				 $('#afterLeaveMoudle').hide();
				 $('#examList').hide();
				 $('#lookData').hide();
				$('#signal').show();
			});
		 //点击签到记录
			$('#studentWordRecord').click(function wq() {
				$('#messageList').html("签到记录");
				$('#courseInfo').hide();
				 $('#upLoadShow').hide();
				$('#studentAddCourse').hide();
				$('#doubleHandle').hide();
				 $('#seprateMessage').hide();
				 $('#fushuMessage').hide();
				 $('#messageShow').hide();
				 $('#studentInfoShow').hide();
				 $('#insertCourseDiv').hide();
				 $("#studentLogOfTime").hide();
				 $('#forStudentLogInfo').hide();
				 $('#studentLogInfo').hide();
				$('#signal').hide();
				$('#beforeLeaveMoudle').hide();
				$('#lookData').hide();
				 $('#afterLeaveMoudle').hide();
				 $('#examList').hide();
				$('#studentWork').show();
			});
			//点击完善信息
			$('#perfectButton').click(function wq() {
				$('#messageList').html("完善信息");
				 $('#upLoadShow').hide();
				$('#collegeTr').hide();
				$('#reCollegeTr').show();
				$('#specialTr').hide();
				$('#beforeLeaveMoudle').hide();
				 $('#afterLeaveMoudle').hide();
				$('#reSpecialTr').show();
				$('#intoSchoolYearTr').hide();
				$('#reIntoSchoolYearTr').show();
				$('#schoolRecordTr').hide();
				$('#reSchoolRecordTr').show();
				$('#signalNow').hide();
				$('#birthDayTr').hide();
				$('#reBirthDayTr').show();
				$('#forSavefectButton').show();
				$('#freeStyleTr').hide();
				$('#lookData').hide();
				$('#reFreeStyleTr').show();
				$('#perfectButton').hide();
				 $('#examList').hide();
				$('#savefectButton').show();
			});
			
			
	 
	//获取学生密码，进行后台比对
		function getStuAnwser(password,studentRono) {
			var result = false;
			$.ajax({
	              type: "GET",
	              data: {
	                  "password": password,
	                  "studentRono":studentRono
	              },
	              contentType: "application/json; charset=utf-8",
	              async: false,
	              dataType: "json",
	              url: "<%=request.getContextPath()%>/student/confirmStudentPassWord.do",
	              success: function (data) {
	            	  if(data.result == true){
	            		  result = true;
	            	  }
	              },
	              error: function (data) {
	            	  
	              }
	          });
			  return result;
		}
	    //点击保存 后台完善学生信息
	    $('#savefectButton').click(function wannaSubmittt() {
	    	$.ajax({
	              type: "GET",
	              data: {
	            	  "studentRono":$('#studentRoNo').val(),
	            	  "college":$('#college').val(),
	            	  "special":$('#special').val(),
	            	  "intoSchoolYear":$('#intoSchoolYear').val(),
	            	  "schoolRecord":$('#schoolRecord').val(),
	            	  "birthDay":$('#birthDay').val(),
	            	  "freeStyle":$('#freeStyle').val()
	              },
	              contentType: "application/json; charset=utf-8",
	              async: false,
	              dataType: "json",
	              url: "<%=request.getContextPath()%>/student/updateStudentInfoByAjax.do",
	              success: function (data) {
	            	  if(data.result == true){
	            		  layui.use('layer', function(){
			 	               var $ = layui.jquery, layer = layui.layer; 
			   			      layer.open({
			   			        type: 1
			   			        ,offset: 'auto'
			   			        ,id: 'layerDemo'+'auto'
			   			        ,title: '成功'
			   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "信息更新完成！" +'</div>'
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
        						layer.msg('更新失败！');
        					});
	            	  }
	              },
	              error: function (data) {
	            	  alert("服务器异常");
	              }
	          });
	    });
		//点击申请修改触发密码验证
		$('#ccchangePass').click(function wannaSubmittt() {
			var password = $('#studentPassword').val();
			var studentRono = $('#studentRoNo').val();
			var newPassword = $('#newPassword').val();
			var rePassword = $('#rePassword').val();
			if(getStuAnwser(password,studentRono)){
				$('#passError').hide();
				if(newPassword != null && newPassword != "" && newPassword == rePassword){
					$('#noLike').hide();
					changeStuPass();					
				}else{
					$('#noLike').show();
				}
			}else {
				$('#passError').show();
			}
		});
		//ajax更改密码
		function changeStuPass() {
			$('#safe').submit();
		}
	 });
		//学生添加课程
		var ccclazzName = "";
		function studentAddCourse() {
			var courseId = $('#courseId').val();
			var courseName = $('#courseName').val();
			ccclazzName = $('#clazzName').val();
			if(confirmInputType(courseId,courseName)){
				if(searchIfExistCourse()){
				if(ccclazzName != "" ){
				if(pushAddCourse(courseId,courseName,ccclazzName)){
					layui.use('layer', function(){
		 	               var $ = layui.jquery, layer = layui.layer; 
		   			      layer.open({
		   			        type: 1
		   			        ,offset: 'auto'
		   			        ,id: 'layerDemo'+'auto'
		   			        ,title: '成功'
		   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "请求已发出！" +'</div>'
		   			        ,btn: '关闭'
		   			        ,btnAlign: 'c'
		   			        ,skin: 'demo-class'
		   			        ,shade: 0 
		   			        ,yes: function(){
		   			        	 layer.closeAll();
		   			        }
		   			      });
		 	            });
					setTimeout('yourFunction()',2000); 
				   }
					}else{
						$('#listenClss').show();
					}
				}else{
					
				}
			}
		}
		//ajax添加课程，后台发送信息给教师
		function pushAddCourse(courseId,courseName,ccclazzName) {
			 var result = false;
			 var studentRono = $('#studentRoNo').val();
			$.ajax({
	              type: "GET",
	              data: {
	            	  "clazzId":ccclazzName,
	            	  "courseId":courseId,
	            	  "studentRono":studentRono,
	            	  "courseName":courseName
	              },
	              contentType: "application/json; charset=utf-8",
	              async: false,
	              dataType: "json",
	              url: "<%=request.getContextPath()%>/student/atudentAddCourse.do",
	              success: function (data) {
	            	  if(data.result == true){
	            		  result = true;
	            	  }else if(data.result == false){
	            		  if(data.message == 'moreThan'){
	            			  layui.use('layer', function() {
									var $ = layui.jquery, layer = layui.layer;
									layer.msg('该课程人数已超额！');
								});
	            		  }else {
	            			  $('#listenClssExit').show();
						}
	            	  }
	              },
	              error: function (data) {
	            	  alert("服务器异常");
	              }
	          });
			return result;
		}
		 //刷新当前页面
		function yourFunction() {
		 window.location.reload();
	   }
		 //添加课程输入验证
		function confirmInputType(courseId,courseName) {
			if($('#courseId').val() != null && $('#courseId').val() != ""){
				if(isNaN($('#courseId').val())){
					$('#listenIdEmpty').hide();
					$('#listenClssExit').hide();
					$('#listenId').show();
				}else{
					if(courseName.length >= 100){
						$('#listenIdEmpty').hide();
						$('#listenId').hide();
						$('#listenClssExit').hide();
						$('#listenName').show();
					}else{
						$('#listenIdEmpty').hide();
						$('#listenId').hide();
						$('#listenClssExit').hide();
						$('#listenName').hide();
						return true;
					}
				}
			}else{
				$('#listenIdEmpty').show();
			}
			
		}
		//点击某个消息
		function getMessage(messageId) {
			$('#me'+messageId).html("已读");
			$('#mem'+messageId).val("已读");
			getMessageByAjax(messageId);
		}
		function getMessageByAjax(messageId) {
			$.ajax({
	            type: "GET",
	            data: { 
			         "messageId": messageId
	            },
	            contentType: "application/json; charset=utf-8",
	            async: false,
	            url: "<%=request.getContextPath()%>/student/getMessageByAjax.do",
				success : function(data) {
					if(data.mmm.messageType == 'nomal'){
						layer.open({
				            type: 1
				            ,title: false
				            ,closeBtn: true
				            ,area: '300px;'
				            ,shade: 0.8
				            ,id: 'LAY_layuipro' 
				            ,btn: ['回复', '忽略']
				            ,btnAlign: 'c'
				            ,moveType: 0 
				            ,content: '<div style="background-color: #393D49; color: #fff;"><br/>' + data.mmm.messageContent +'<br/></div>'
				            ,yes: function(){
				            	layer.closeAll();
				            	layui.use('layer', function(){ 
				                    var $ = layui.jquery, layer = layui.layer;
				          	layer.open({
				                  type: 1
				                  ,title: false
				                  ,closeBtn: true
				                  ,area: '300px;'
				                  ,shade: 0.8
				                  ,id: 'LAY_layuipwro'
				                  ,btn: ['立即回复', '想想再说']
				                  ,btnAlign: 'c'
				                  ,moveType: 0 
				                  ,content: '<div style="background-color: #393D49; color: #fff;"><div  style="width:100%;"> <br/><label>回复消息</label><textarea style="color:#393D49" id="messageToTeacherContent" class="layui-textarea"></textarea></div></div>'
				                  ,yes: function(){
				                  	if($('#messageToTeacherContent').val() != "" && messageId != null){
				                  		$.ajax({
				                  	        type: "GET",
				                  	        data: {
				                  	         "messageToTeacherContent":$('#messageToTeacherContent').val(),
				                  	         "messageId":messageId
				                  	        },
				                  	        contentType: "application/json; charset=utf-8",
				                  	        async: false,
				                  	        url: "<%=request.getContextPath()%>/student/returnMessageToTeacher.do",
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
				           
				          });
					}else if(data.mmm.messageType == 'admin'){
						layer.open({
				            type: 1
				            ,title: false //不显示标题栏
				            ,closeBtn: true
				            ,area: '300px;'
				            ,shade: 0.8
				            ,id: 'LAY_layuipro' //设定一个id，防止重复弹出
				            ,btn: ['知道了~']
				            ,btnAlign: 'c'
				            ,moveType: 0 //拖拽模式，0或者1
				            ,content: '<div style="background-color: #393D49; color: #fff;"><br/>' + data.mmm.messageContent +'<br/></div>'
				            ,yes: function(){
				            	layer.closeAll();
							  }
				           
				          });
					}else if(data.mmm.messageType == 'homeWork'){
						layer.open({
				            type: 1
				            ,title: false //不显示标题栏
				            ,closeBtn: true
				            ,area: '300px;'
				            ,shade: 0.8
				            ,id: 'LAY_layuipro' //设定一个id，防止重复弹出
				            ,btn: ['知道了~']
				            ,btnAlign: 'c'
				            ,moveType: 0 //拖拽模式，0或者1
				            ,content: '<div style="background-color: #393D49; color: #fff;"><br/>' + data.mmm.messageContent +'<br/></div>'
				            ,yes: function(){
				            	layer.closeAll();
							  }
				           
				          });
					}else if(data.mmm.messageType == 'publish'){
						layer.open({
				            type: 1
				            ,title: false //不显示标题栏
				            ,closeBtn: true
				            ,area: '300px;'
				            ,shade: 0.8
				            ,id: 'LAY_layuipro' //设定一个id，防止重复弹出
				            ,btn: ['知道了~']
				            ,btnAlign: 'c'
				            ,moveType: 0 //拖拽模式，0或者1
				            ,content: '<div style="background-color: #393D49; color: #fff;"><br/>' + data.mmm.messageContent +'<br/></div>'
				            ,yes: function(){
				            	layer.closeAll();
							  }
				           
				          });
					}else if(data.mmm.messageType == 'insertCourse'){
						$('#forMessageContent').hide();
						$('#messageContent').hide();
						$('#seprateMessage').hide();
						$('#insertCourseDiv').show();
						$('#MteacherMobile').val(data.mmm.messageSender);
						$('#messageTitleS').html('<span style="color:#5FB878">标题 :&nbsp</span>' + data.mmm.messageTitle);
						$('#messageSenderNameS').html('<span style="color:#5FB878">发件人姓名 :&nbsp</span>' + data.teacher.teacherName + '<br/>' + '<br/>'+ '<br/>');
						$('#messageContentS').html(data.mmm.messageContent);
						$('#MCourseId').val(data.mmm.messageContent);
						$('#messageShow').hide();
						$('#messageSnderS').html('<span style="color:#5FB878">发件人账号 :&nbsp</span> <' + data.mmm.messageSender +'>');
						if(data.teacher != null){
						$('#messageSenderNameS').show();
						  }
						$('#sendTime').html('<span style="color:#5FB878">时间  :&nbsp</span><' + data.mmm.sendTime +'>');
						$('#fushuMessage').show();
					}else if(data.mmm.messageType == 'leaveRecord'){
						$('#messageContent').html(data.mmm.messageContent);
						$('#forMessageContent').show();
						$('#messageContent').show();
						$('#seprateMessage').hide();
						$('#insertCourseDiv').show();
						$('#messageTitleS').html('<span style="color:#5FB878">标题 :&nbsp</span>' + data.mmm.messageTitle);
						$('#messageSenderNameS').html('<span style="color:#5FB878">发件人姓名 :&nbsp</span>' + data.teacher.teacherName + '<br/>' + '<br/>'+ '<br/>');
						$('#MteacherMobile').val(data.mmm.messageSender);
						$('#MCourseId').val(data.mmm.messageContent);
						$('#messageContentS').html(data.mmm.messageTitle);
						$('#messageShow').hide();
						$('#messageSnderS').html('<span style="color:#5FB878">发件人账号 :&nbsp</span> <' + data.mmm.messageSender +'>');
						if(data.teacher != null){
						$('#messageSenderNameS').show();
						  }
						$('#sendTime').html('<span style="color:#5FB878">时间  :&nbsp</span><' + data.mmm.sendTime +'>');
						$('#fushuMessage').show();
					}
					
					
				},
				error : function(data) {
					alert("异常");
				},
				dataType : "json",
			});
		}
		//点击忽略某个消息
		function dontCare() {
			$('#doubleHandle').hide();
			$('#signal').hide();
			 $('#upLoadShow').hide();
		    $('#studentAddCourse').hide();
		     $('#courseInfo').hide();
		     $('#studentInfoShow').hide();
		     $('#studentLogInfo').hide();
		     $('#fushuMessage').hide();
		     $('#lookData').hide();
		     $('#examList').hide();
			 $('#seprateMessage').show();
			 $('#messageShow').show();
       }
		//根据时间查询操作日志
		function searchStudentLogByTime() {
			if($('#logDate').val() != "" || $('#CoreKey').val() != ""){
			 $.ajax({
		         type: "GET",
		         data: {
		        	 "logDate": $('#logDate').val(),
		        	 "coreKey":$('#CoreKey').val(),
		        	 "studentRono":$('#studentRoNo').val()
		         },
		         contentType: "application/json; charset=utf-8",
		         dataType: "json",
		         async: true,
		         url: "<%=request.getContextPath()%>/student/searchStudentLogByTime.do",
		         success: function (data) {
		        	 $('#studentLogInfo').hide();
		        	    var dataObj = data.logEntities, //返回的data为json格式的数据
		        	    con =  '\
		        				<tr>\
		        					<th>学号</th>\
		        					<th>活动</th>\
		        					<th>Ip</th>\
		        					<th>时间</th>\
		        					<th>结果</th>\
		        				</tr>\
		        				';
		        	    $.each(dataObj, function (index, item) {
		        	        con += "<tr>";
		        	        con += "<td>" + item.userId + "</td>";
		        	        con += "<td>" + item.method + "</td>";
		        	        con += "<td>" + item.ip + "</td>";
		        	        con += "<td>" + item.date + "</td>";
		        	        con += "<td>" + item.result + "</td>";
		        	        con += "<tr/>";
		        	    });
		        	        //可以在控制台打印一下看看，这是拼起来的标签和数据
		        	        //把内容入到这个div中即完成
		        	    $("#studentLogOfTime").html(con);
		        	    $("#studentLogOfTime").show();
		         },
		         error: function (data) {
		             alert("暂时无法获取");
		         },
		     });
			}else{
				alert("请至少输入一项吧大侠？");
			}
		}
		//验证课程有效性
		function searchIfExistCourse() {
			var result = false;
			var courseId = $('#courseId').val();
			if(courseId != null && courseId != ""){
			$.ajax({
	            type: "GET",
	            data: { 
			         "courseId": courseId
	            },
	            contentType: "application/json; charset=utf-8",
	            dataType : "json",
	            async: false,
	            url: "<%=request.getContextPath()%>/course/searchIfExistCourse.do",
				success : function(data) {
					var dataObj = data.clazzs;
					if(data.result == true && data.clazzs != null){
						var con = "";
						con = "<option value=''>" + "请选择" + " </option>";
						$.each(dataObj, function (index, item) {
		        	        con += "<option value=\"" + item.clazzId + "\" >" + item.clazzName + "</option>";
						});
					$('#clazzName').html(con);
					$('#listenEmpty').hide();
					$('#listenClazzs').hide();
					$('#clazzDiv').show();
					result = true;
					}else if (data.result == true && data.clazzs == null) {
						$('#clazzDiv').hide();
						$('#listenEmpty').hide();
						$('#listenClazzs').show();
					}else {
						$('#clazzDiv').hide();
						$('#listenEmpty').show();
						$('#listenIdEmpty').hide();
						$('#listenClazzs').hide();
					}
				},
				error : function(data) {
					alert("异常");
				},
			});
			return result;
			}else{
			$('#clazzDiv').hide();
			$('#listenEmpty').show();
			$('#listenIdEmpty').hide();
			$('#listenClazzs').hide();
			}
		}
		function exitLogin() {
			 $.ajax({
	             type: "GET",
	             data: {
	            	 "studentRoNo":$('#studentRoNo').val()
	             },
	             contentType: "application/json; charset=utf-8",
	             async: false,
	             //url不加空格！！！！！！！！！！！！！！！！！！！！！！！
	             url: "<%=request.getContextPath()%>/student/exitLogin.do",
				success : function(data) {
					
				},
				error : function(data) {
				},
				dataType : "json",
			});
		}
	
		//ajax获取上传的文件列表
		function getPrivateData(id) {
			$('#courseInfo').hide();
			$('#upLoadShow').show();
			$('#messageList').html("课件资料");
			 $.ajax({
		         type: "GET",
		         data: {
		        	 "courseId": id
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
		        	        con += "<td style='padding-left:5%;'><a target='_blank' style='color:green;' href=\'<%=request.getContextPath() %>/file/"+item.fileName+"\'>" + item.fileName + "</a></td>";
		        	        con += "<tr/>";
		        	    });
					 $('#privateData').html(con);
				},
				error : function(data) {
				},
				dataType : "json",
			});
		}
//获取请假记录		
function getLeaveRecord() {
	 $.ajax({
         type: "GET",
         data: {
        	 "studentRono":$('#studentRoNo').val()
         },
         contentType: "application/json; charset=utf-8",
         async: false,
         url: "<%=request.getContextPath()%>/student/getLeaveRecord.do",
		success : function(data) {
			var dataObj = data.leaveRecords;
			con =  '\
				<tr>\
					<th>课程编码</th>\
					<th>课程名称</th>\
					<th>请假事由</th>\
					<th>请假时间</th>\
					<th>返回时间</th>\
					<th>状态</th>\
				</tr>\
				';
	    $.each(dataObj, function (index, item) {
	        con += "<tr>";
	        con += "<td>" + item.courseId + "</td>";
	        con += "<td>" + item.courseName + "</td>";
	        con += "<td>" + item.reason + "</td>";
	        con += "<td>" + item.leaveTime + "</td>";
	        con += "<td>" + item.returnTime + "</td>";
	        con += "<td>" + item.status + "</td>";
	        con += "<tr/>";
	    });
	        //可以在控制台打印一下看看，这是拼起来的标签和数据
	        //把内容入到这个div中即完成
	    $("#leaveRecordTable").html(con);
	    $("#leaveRecordTable").show();
		},
		error : function(data) {
			//alert("?");
		},
		dataType : "json",
	});
}	
//学生请假处理请求
function studentAddLeave() {
	if($('#leaveCourseId').val() != "" && $('#reson').val() != "" && $('#leaveTime').val() != "" && 
			$('#returnTime').val() != ""){
		 $.ajax({
	         type: "GET",
	         data: {
	        	 "student":$('#studentRoNo').val(),
	        	 "courseId": $('#leaveCourseId').val(),
	        	 "reson": $('#reson').val(),
	        	 "leaveTime": $('#leaveTime').val(),
	        	 "returnTime": $('#returnTime').val(),
	        	 "status":"待批"
	         },
	         contentType: "application/json; charset=utf-8",
	         async: false,
	         url: "<%=request.getContextPath()%>/student/studentAddLeave.do",
			success : function(data) {
				if(data.result == true){
					layui.use('layer', function(){
		 	               var $ = layui.jquery, layer = layui.layer; 
		   			      layer.open({
		   			        type: 1
		   			        ,offset: 'auto'
		   			        ,id: 'layerDemo'+'auto'
		   			        ,title: '成功'
		   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "请求已发送" +'</div>'
		   			        ,btn: '关闭'
		   			        ,btnAlign: 'c'
		   			        ,skin: 'demo-class'
		   			        ,shade: 0 
		   			        ,yes: function(){
		   			        	leaveRecord();
		   			        	 layer.closeAll();
		   			        }
		   			      });
		 	            });
				}else {
					layui.use('layer', function() {
						var $ = layui.jquery, layer = layui.layer;
						layer.msg('创建假条失败！');
					});
				}
			},
			error : function(data) {
			},
			dataType : "json",
		});
	}
}
function fuckFunction() {
	$('#afterLeaveSuccess').hide();
	getLeaveRecord();
}
//点击查看试卷
function examList() {
	$('#messageList').html("试卷信息");
	 $('#upLoadShow').hide();
	 $('#doubleHandle').hide();
	 $('#signal').hide();
	 $('#studentAddCourse').hide();
	 $('#seprateMessage').hide();
	 $('#messageShow').hide();
	 $('#insertCourseDiv').hide();
	 $('#fushuMessage').hide();
	 $('#studentInfoShow').hide();
	 $('#forStudentLogInfo').hide();
	 $('#studentLogInfo').hide();
	 $("#studentLogOfTime").hide();
	 $('#lookData').hide();
	 $('#studentWork').hide();
	 $('#beforeLeaveMoudle').hide();
	 $('#afterLeaveMoudle').hide();
	 $('#courseInfo').hide();
	 
		$.ajax({
	        type: "GET",
	        data: {
	        	"studentRono":$('#studentRoNo').val()
	        },
	        contentType: "application/json; charset=utf-8",
	        async: false,
	        url: "<%=request.getContextPath()%>/exam/selectScoreByStudent.do",
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
	       	        con += "<td style='text-align:center;'><a id="+item.examinationID+" onclick='getMyScore(this.id)' href=\'#\'><i class='layui-icon' style='font-size: 30px; color: #1E9FFF;'>&#xe63c;</i>  </a></td>";
	       	        con += "<tr/>";
	       	    });
				 $('#scoreShowTable').html(con);
				 $('#scoreShowTableFirst').show();
				 $('#studentScoreDetail').hide();
				 $('#examList').show();
			},
			error : function(data) {
				 layui.use('layer', function() {
       				var $ = layui.jquery, layer = layui.layer;
       				layer.msg('您未作答');
       			});
			},
			dataType : "json",
		});
}
function getMyScore(id) {
	$.ajax({
        type: "GET",
        data: {
        	"studentRono":$('#studentRoNo').val(),
        	"examinationID":id
        },
        contentType: "application/json; charset=utf-8",
        async: false,
        url: "<%=request.getContextPath()%>/exam/getMyScore.do",
		success : function(data) {
			if(data.result == true){
				$('#ExamTitle').html(data.examination.examinationName);
				$('#ExamTotalValue').html("试卷总分： "+data.examination.totalValue);
				$('#all').html(data.score.totalValue);
				$('#single').html(data.score.singleSelectionValue);
				$('#more').html(data.score.moreSelectionValue);
				$('#judge').html(data.score.judgeValue);
				$('#pack').html(data.score.packValue);
				$('#shortAnswer').html(data.score.shortAnswerValue);
				
				var dataObj = data.singleSelections;
				 con = "";
				 $.each(dataObj, function (index, item) {
					con += "<li style='font-size: 1.2em'>("+ item.questionNumber + ")" + item.questionContent + "&nbsp;("+ item.value +"分)</li>";
	       	        con += "<li><input type='radio' disabled='disabled' name='studentAnswer' title='A'>A:" + item.optionA +"<br/></li>";
	       	        con += "<li><input type='radio' disabled='disabled' name='studentAnswer' title='B'>B:" + item.optionB +"<br/></li>";
	       	        con += "<li><input type='radio' disabled='disabled' name='studentAnswer' title='C'>C:" + item.optionC +"<br/></li>";
	             	con += "<li><input type='radio' disabled='disabled' name='studentAnswer' title='D'>D:" + item.optionD +"<br/></li>";
	             	con += "<li>&nbsp;</li>";
	             	con += "<li>正确答案: " + item.answer +"<br/></li>";
	             	var dataObj2 = data.studentAnswers1;
	             	$.each(dataObj2, function (index2, item2) {
	             		if(item.questionNumber == item2.questionNumber){
		             		con += "<li>学生答案: " + item2.stuAnswer +"<br/></li>";
		             		con += "<li>&nbsp;</li>";
		             		if(item2.getValue == item.value){
		             			con += "<li><i class='layui-icon' style='font-size: 30px; color: #1E9FFF;'>&#xe618;</i></li>";
		             		}else {
		             			con += "<li><i class='layui-icon' style='font-size: 30px; color: #FF5722;'>&#x1006;</i></li>";
							}
		             		return false; 
		             	}
	             	 });
				 });
				 
				 $('#singleUl').html(con);
				 //隔断线，NEXT
				 var moreObj = data.moreSelections;
				 mon = "";
				 $.each(moreObj, function (index, item) {
					 mon += "<li style='font-size: 1.2em'>("+ item.questionNumber + ")" + item.questionContent + "&nbsp;("+ item.value +"分)</li>";
					 mon += "<li><input type='radio' disabled='disabled' name='studentAnswer' title='A'>A:" + item.optionA +"<br/></li>";
					 mon += "<li><input type='radio' disabled='disabled' name='studentAnswer' title='B'>B:" + item.optionB +"<br/></li>";
					 mon += "<li><input type='radio' disabled='disabled' name='studentAnswer' title='C'>C:" + item.optionC +"<br/></li>";
					 mon += "<li><input type='radio' disabled='disabled' name='studentAnswer' title='D'>D:" + item.optionD +"<br/></li>";
					 mon += "<li>&nbsp;</li>";
					 mon += "<li>正确答案: " + item.answer +"<br/></li>";
	             	var moreObj2 = data.studentAnswers2; 
	             	$.each(moreObj2, function (index2, item2) {
	             		if(item.questionNumber == item2.questionNumber){
	             			mon += "<li>学生答案: " + item2.stuAnswer +"<br/></li>";
	             			mon += "<li>&nbsp;</li>";
	             			if(item2.getValue == item.value){
		             			mon += "<li><i class='layui-icon' style='font-size: 30px; color: #1E9FFF;'>&#xe618;</i></li>";
		             		}else {
		             			mon += "<li><i class='layui-icon' style='font-size: 30px; color: #FF5722;'>&#x1006;</i></li>";
							}
		             		return false; 
		             	}
	             	 });
				 });
				 $('#moreUl').html(mon);
				//隔断线，NEXT
				 var judgeObj = data.judges;
				 jon = "";
				 $.each(judgeObj, function (index, item) {
					 jon += "<li style='font-size: 1.2em'>("+ item.questionNumber + ")" + item.judgeContent + "&nbsp;("+ item.value +"分)</li>";
					 jon += "<li>&nbsp;</li>";
					 jon += "<li>正确答案: " + item.answer +"<br/></li>";
	             	var judgeObj2 = data.studentAnswers3; 
	             	$.each(judgeObj2, function (index2, item2) {
	             		if(item.questionNumber == item2.questionNumber){
	             			jon += "<li>学生答案: " + item2.stuAnswer +"<br/></li>";
	             			jon += "<li>&nbsp;</li>";
	             			if(item2.getValue == item.value){
		             			jon += "<li><i class='layui-icon' style='font-size: 30px; color: #1E9FFF;'>&#xe618;</i></li>";
		             		}else {
		             			jon += "<li><i class='layui-icon' style='font-size: 30px; color: #FF5722;'>&#x1006;</i></li>";
							}
		             		return false; 
		             	}
	             	 });
				 });
				 $('#judgeUl').html(jon);
				//隔断线，NEXT
				 var packObj = data.packs;
				 pon = "";
				 $.each(packObj, function (index, item) {
					 pon += "<li style='font-size: 1.2em'>("+ item.questionNumber + ")" + item.packContent + "&nbsp;("+ item.value +"分)</li>";
					 pon += "<li>&nbsp;</li>";
					 pon += "<li>参考答案: " + item.answer +"<br/></li>";
	             	var packObj2 = data.studentAnswers4; 
	             	$.each(packObj2, function (index2, item2) {
	             		if(item.questionNumber == item2.questionNumber){
	             			pon += "<li>学生答案: " + item2.stuAnswer +"<br/></li>";
	             			pon += "<li>&nbsp;</li>";
		             		pon += "<li>该题得分：<span style='color:#FF5722;'>"+ item2.getValue +"</span></li>";
		             		return false; 
		             	}
	             	 });
				 });
				 $('#packUl').html(pon);
				//隔断线，NEXT
				 var shortObj = data.shortAnswers;
				 son = "";
				 $.each(shortObj, function (index, item) {
					 son += "<li style='font-size: 1.2em'>("+ item.questionNumber + ")" + item.shortAnswerContent + "&nbsp;("+ item.value +"分)</li>";
	             	 var shortObj2 = data.studentAnswers5; 
	             	$.each(shortObj2, function (index2, item2) {
	             		if(item.questionNumber == item2.questionNumber){
	             			son += "<li>学生答案:<br/> <textarea rows='5' cols='100' disabled='disabled'>" + item2.stuAnswer +"</textarea><br/></li>";
	             			son += "<li>&nbsp;</li>";
	             			son += "<li>该题得分：<span style='color:#FF5722;'>"+ item2.getValue +"</span></li>";
	             		}
	             	 });
				 });
				 $('#shortAnswerUl').html(son);
				
				
				$('#scoreShowTableFirst').hide();
				$('#studentScoreDetail').show();
			}else {
				layui.use('layer', function(){
		              var $ = layui.jquery, layer = layui.layer; 
					      layer.open({
					        type: 1
					        ,offset: 'auto' 
					        ,id: 'layerDemo'+'auto'
					        ,title: '提示'
					        ,content: '<div style="padding: 20px 100px; color:#FF5722;">'+ "少安毋躁，试卷批改中~" +'</div>'
					        ,btn: '关闭'
					        ,btnAlign: 'c' 
					        ,shade: 0 
					        ,yes: function(){
					        	layer.closeAll();
					        }
					      });
		           });
			}
			
		},
		error : function(data) {
			 layui.use('layer', function() {
    				var $ = layui.jquery, layer = layui.layer;
    				layer.msg('您未作答');
    			});
		},
		dataType : "json",
	});
}
//个人博客
function toPersonBlog() {
	$('#PersonBlogForm').submit();
}
//查看其他人博客
function lookData() {
	$('#messageList').html("博文中心");
	 $('#upLoadShow').hide();
	 $('#doubleHandle').hide();
	 $('#signal').hide();
	 $('#studentAddCourse').hide();
	 $('#seprateMessage').hide();
	 $('#messageShow').hide();
	 $('#insertCourseDiv').hide();
	 $('#fushuMessage').hide();
	 $('#studentInfoShow').hide();
	 $('#forStudentLogInfo').hide();
	 $('#studentLogInfo').hide();
	 $("#studentLogOfTime").hide();
	 $('#studentWork').hide();
	 $('#beforeLeaveMoudle').hide();
	 $('#afterLeaveMoudle').hide();
	 $('#examList').hide();
	 $('#courseInfo').hide();
	 $('#lookData').show();
}
//点击请假
function leaveRecord() {
	getLeaveRecord();
	$('#messageList').html("请假记录");
	$('#courseInfo').hide();
	$('#upLoadShow').hide();
	$('#studentAddCourse').hide();
	$('#doubleHandle').hide();
	$('#seprateMessage').hide();
	$('#fushuMessage').hide();
	$('#messageShow').hide();
	$('#studentInfoShow').hide();
	$('#insertCourseDiv').hide();
	$("#studentLogOfTime").hide();
	$('#forStudentLogInfo').hide();
    $('#studentLogInfo').hide();
    $('#examList').hide();
	$('#signal').hide();
	$('#lookData').hide();
	$('#studentWork').hide();
	$('#beforeLeaveMoudle').show();
	 $('#afterLeaveMoudle').show();
}
</script>

</head>
<body>

	<div class="layui-layout layui-layout-admin" style="">
		<!-- 头部导航 -->
		<div class="layui-header header header-demo">
			<div class="layui-main">
				<a class="CMSlogo" href="#"><span
					style="color: white; font-size: 25px;">CMS</span></a>
				<ul class="layui-nav">
					<li class="layui-nav-item"><a id="messageButtton" href="#">
					<i class="layui-icon bbbbb" style="font-size: 20px; color: #d2d2d2">&#xe63a;</i> <span
							id="TmessageCount" class="layui-badge" style="margin-left: 15%;display: none;">${messageCount}</span></a></li>
					<li class="layui-nav-item"><a id="studentInfoCenter" href="#">
					<i class="layui-icon bbbbb" style="font-size: 20px; color: #d2d2d2">&#xe612;</i><span
							id="redSignal" style="display: none;" class="layui-badge-dot"></span></a></li>
					<li class="layui-nav-item"><a href="#">${student.studentName}</a>
						<ul class="layui-nav-child">
							<li>
								<a id="updateStudentInfoNow" href="#">修改信息</a>
							</li>
							<li>
								<a id="safeManage" href="#">安全管理</a>
							</li>
							<li>
								<a onclick="exitLogin()"
									href="<%=request.getContextPath()%>/index.jsp">注销登录</a>
							</li>
						</ul>
					</li>
				</ul>

			</div>
		</div>
		<!-- 左侧垂直导航 -->
		<div class="layui-side layui-bg-black" style="position: absolute;">
			<div class="layui-side-scroll">
				<ul class="layui-nav layui-nav-tree" lay-filter="test">
					<!-- 侧边导航: <ul class="layui-nav layui-nav-tree layui-nav-side"> -->
					<li class="layui-nav-item layui-nav-itemed"><a
						href="javascript:;">课程中心</a>
						<dl class="layui-nav-child">
							<dd>
								<a id="checkCourseShow" href="#">课程信息</a>
							</dd>
							<dd>
								<a id="addCourse" href="#">添加课程</a>
							</dd>
							<dd>
								<a onclick="examList()" href="#">查看试卷</a>
							</dd>
						</dl></li>
					<li class="layui-nav-item layui-nav-itemed"><a href="javascript:;">数据平台</a>
						<dl class="layui-nav-child">
							<dd>
								<a id="studentWordRecord" href="#">签到记录</a>
							</dd>
							<dd>
								<a id="leaveRecord" onclick="leaveRecord()" href="#">请假记录</a>
							</dd>
							<dd>
								<a id="studentLog" href="#">操作日志</a>
							</dd>
						</dl></li>
					<li class="layui-nav-item layui-nav-itemed"><a href="#">博客中心</a>
					<dl class="layui-nav-child">
							<dd>
								<a onclick="toPersonBlog()" href="#">个人博客</a>
							</dd>
							<dd>
								<a onclick="lookData()" href="#">查阅博文</a>
							</dd>
						</dl>
					</li>
				</ul>
			</div>
		</div>

	<!-- 内容显示 -->
	<div class="layui-body site-demo"
		style="padding-top: 1%; overflow: auto;">
		<span id="messageList"
			style="margin-left: 5%; color: #c2c2c2; font-style: oblique;"></span>
		<hr class="layui-bg-cyan">	
		
		<!-- 查看资料，搜寻各种格式的，自己的，或者他人 -->
			<div id="lookData" class="site-text site-block" style="padding-top: 5px;margin-top: 0;display: none;padding-left: 0;padding-right: 0">
				<form class="layui-form" action="">
					<div class="layui-form-item" style="width: 100%; margin-left: 1%;">
						 <div class="layui-form-item" style="height: 100%; width: 35%; float: left;">
						    <label class="layui-form-label">类型</label>
						    <div class="layui-input-block" style="width: 150px;">
						      <select id="dataType" name="dataType" lay-verify="required" style="width: 100%;">
						        <option></option>
								<option value="AI">AI</option>
								<option value="安全">安全</option>
								<option value="算法">算法</option>
								<option value="后端">后端</option>
								<option value="前端">前端</option>
								<option value="终端">终端</option>
						      </select>
						    </div>
						  </div>
						
						<div style="height: 100%; width: 49%; float: left;">
							<label class="layui-form-label">输入关键字</label>
							<div class="layui-input-block" >
								<input id="dataContent" type="text" lay-verify="required" required
									placeholder="如  'java'" autocomplete="off" class="layui-input"
									style="width: 60%; float: left;"> <input
									class="layui-btn" lay-submit type="button"
									onclick="searchData()" value="查询"
									style="float: left;" />
							</div>
						</div>
					</div>
				</form>
				<hr class="layui-bg-cyan">
							
		    <ul id="studentBlogUl" style="width: 100%; margin-top: 10px; margin-left: 0;margin-right: 0;padding-left: 0;padding-right: 0;">
		      <c:choose>
		        <c:when test="${!empty myBlogs}">
		          <c:forEach  items="${myBlogs}" var="s"  varStatus="status" begin="0">
		            <li  class="site-block" style="background-color: #eeeeee;">
		              (${status.index}).<a id="${s.blogId}" target='_blank' href="<%=request.getContextPath()%>/blog/getBlogTemValue.do?blogId=${s.blogId}&userId=${student.studentRoNo}&role=student" style="color: #5FB878;">${s.blogTitle}</a>&nbsp;&nbsp;
		              <i class="layui-icon" style="font-size: 20px; color: #FF5722">&#xe6c6;
		              </i><span id="thisUp">${s.up}</span>  
		              <i class="layui-icon" style="font-size: 20px; padding-left:20px;
					         color: #FF5722;">&#xe6c5;</i>  <span id="thisDown">${s.down}</span>
		            </li>
		          </c:forEach>
		        </c:when>
		        <c:otherwise>
		           <li  class="site-block" style="background-color: #dddddd;">暂无</li>
		        </c:otherwise>
		      </c:choose>
		    </ul>
		    <ul id="BlogUl" style="width: 100%; margin-top: 10px; margin-left: 0;margin-right: 0;
		    padding-left: 0;padding-right: 0; display: none;">
		      
		    </ul>
			
			</div>
			
   <script>
		//Demo
		layui.use([ 'form', 'laydate' ], function() {
			var form = layui.form, laydate = layui.laydate;
			form.render();
		});
//点击查询
function searchData() {
	if($('#dataType').val() != "" && $('#dataContent').val() != ""){
     $.ajax({
            type: "GET",
            data: {
          	  "blogContent" :$('#dataContent').val(),
          	  "belongTo" :$('#dataType').val()
            },
            contentType: "application/json; charset=utf-8",
            async: false,
            dataType: "json",
            url: "<%=request.getContextPath()%>/blog/studentSearchBlog.do",
            success: function (data) {
            	var dataObj = data.myBlogs;
            	var con = "";
            	 $.each(dataObj, function(index, item) {
	        	        con += "<li class='site-block' style='background-color: #eeeeee;'>("+index+").<a id='"+ item.blogId +"' target='_blank' href='<%=request.getContextPath()%>/blog/getBlogTemValue.do?userId=${student.studentRoNo}&blogId= " + item.blogId + "&role=student' style='color: #5FB878;'> " + item.blogTitle + " </a>&nbsp;&nbsp;<i class='layui-icon' style='font-size: 20px; color: #FF5722'>&#xe6c6;</i><span id='thisUp'>"+ item.up +"</span>  <i class='layui-icon' style='font-size: 20px; padding-left:20px;color: #FF5722;'>&#xe6c5;</i>  <span id='thisDown'>"+ item.down +"</span> </li>";
	        	    });
            	$('#BlogUl').html(con);
            	$('#studentBlogUl').hide();
            	$('#BlogUl').show();
            },
            error: function (data) {
          	  alert("服务器异常");
            }
        });
	}else{
		layui.use('layer', function() {
			var $ = layui.jquery, layer = layui.layer;
			layer.msg('总是要填一项...');
		});
	}
}
</script>
			
			
	<!-- 学生博客 -->
	<form id="PersonBlogForm" action="<%=request.getContextPath()%>/student/toPersonBlog.do" method="post" style="display: none;">
	  <input type="text" name="userId" value="${student.studentRoNo}"/>
	  <input type="text" name="userPassWord" value="${student.studentPassword}"/>
	  <input type="text" name="userRole" value="student"/>
	</form>
	
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
			
			
	       	<!-- 学生查看试卷 -->
			<div class="site-text site-block" id="examList"
				style="display: none;margin-top: 0;padding-left: 0; padding-right: 0;">
              	<table id="scoreShowTableFirst" class="layui-table" lay-even
				style="text-align: center; width: 100%;">
				<colgroup>
					<col width="80">
					<col width="100">
					<col width="90">
					<col width="100">
					<col width="100">
					<col width="80">
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
						<th style="text-align: center;">状态</th>
						<th style="text-align: center;">查看成绩</th>
					</tr>
				</thead>
				<tbody id="scoreShowTable">

				</tbody>
			</table>
			
			<div id="studentScoreDetail" style="display: none;">
			<h3 id="ExamTitle" style="width: 100%; text-align: center;font-size: 1.4em"></h3>
			<h3 id="ExamTotalValue" style="width: 100%;font-size: 1.1em;text-align: right;"></h3>
		      <span id=""> 得分：<i class="layui-icon" style="font-size: 13px; color: #1E9FFF;">&#xe65b;</i>  </span>
		      <hr class="layui-bg-red" style="width: 40%;">   
				   <ul>
				    <li>单选：<span id="single"></span></li>
				    <li>多选：<span id="more"></span></li>
				    <li>判断：<span id="judge"></span></li>
				    <li>填空：<span id="pack"></span></li>
				    <li>简答：<span id="shortAnswer"></span></li>
				    <li>总分：<span id="all"></span></li>
				   </ul>
				   
		<!-- 答题部分 -->   <!-- 单选部分 -->
		<h3 style="font-size: 1.4em;color: #5FB878;"><一>单选<span style="font-size: 0.8em">(该部分每题有且仅有一个正确答案，答错不得分)</span></h3>
		<br />
		<ul class="layui-timeline" id="singleUl">
		<br/>				
		</ul>
		<!-- 多选部分 -->
		<h3 style="font-size: 1.4em;color: #5FB878;"><二>多选<span style="font-size: 0.8em">((该部分每题至少有一个选项正确，答错或者答对一部分不得分)</span></h3>
		<br />
		<ul class="layui-timeline" id="moreUl">
						
		</ul>
		<!-- 判断部分 -->
		<h3 style="font-size: 1.4em;color: #5FB878;"><三>判断<span style="font-size: 0.8em"></span></h3>
		<br />
		<ul class="layui-timeline" id="judgeUl">
						
		</ul>
		<!-- 填空部分 -->
		<h3 style="font-size: 1.4em;color: #5FB878;"><四>填空<span style="font-size: 0.8em"></span></h3>
		<br />
		<ul class="layui-timeline" id="packUl">
						
		</ul>
		<!-- 简答部分 -->
		<h3 style="font-size: 1.4em;color: #5FB878;"><五>简答<span style="font-size: 0.8em"></span></h3>
		<br />
		<ul class="layui-timeline" id="shortAnswerUl">
						
		</ul>
				   
				</div>
				<script>
					//Demo
					layui.use([ 'form'], function() {
						var form = layui.form;
						//监听提交
						form.on('submit(formDemo)', function(data) {
							layer.msg(JSON.stringify(data.field));
							return false;
						});
					});
				</script>
			</div>
			<!-- 请假模块 -->
			<div id="beforeLeaveMoudle"  class="site-text site-block"
				style="display: none; margin-top: 0;">
				<!-- 请求发送显示 -->
				<div id="afterLeaveSuccess"
		          style="background-color: #393D49; height: 20%; width: 20%; z-index: 20; position: fixed; 
		          margin-top: 4%; text-align: center; margin-left:5%; display: none;">
		            <h3 style="color: white; margin-top: 19%">请求已发送..</h3>
	           </div>
				<form class="layui-form layui-form-pane">
				<div id="createLeaveRecord" style="width: 100%;" >
					<div id="courseDivShow" class="layui-form-item">
						<label class="layui-form-label">选择课程</label> 
						 <div class="layui-input-inline">
						<select  id="leaveCourseId" lay-verify="required" lay-search="">
						<c:choose>
							<c:when test="${! empty studentInfos}">
								<c:forEach items="${studentInfos}" var="s">
									<option value="${s.course.courseId}">${s.course.courseName}</option>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<option selected="selected">暂无</option>
							</c:otherwise>
						</c:choose>
					</select>
					</div>
					</div>
					<br/>
					<div class="layui-form-item" >
						<label class="layui-form-label">请假原因</label>
						<div class="layui-input-block">
							<input id="reson" type="text" name="reson" required
								lay-verify="required" placeholder="请输入请假原因" autocomplete="off"
								class="layui-input">
					</div>
					</div>
					
					<div class="layui-form-item">
						<label class="layui-form-label">请假时间</label>
						<div class="layui-input-inline">
							<input id="leaveTime" type="text" required
								lay-verify="required" placeholder="请输入离开时间" autocomplete="off"
								class="layui-input">
						</div>
					</div>
					
					<div class="layui-form-item">
						<label class="layui-form-label">返回时间</label>
						<div class="layui-input-inline">
							<input id="returnTime" type="text" required
								lay-verify="required" placeholder="请输入返回时间" autocomplete="off"
								class="layui-input">
						</div>
					</div>
					
					<div class="layui-form-item">
						<div class="layui-input-block">
							<input id="AddCourseButton" class="layui-btn" lay-submit
								onclick="studentAddLeave()" type="button" value="提交申请" />
							<button type="reset" class="layui-btn layui-btn-primary">重置</button>
						</div>
					</div>
				</div>
				</form>
			</div>
			<script>
			//时间控制
			layui.use([ 'form', 'laydate' ], function() {
			 var form = layui.form, laydate = layui.laydate;
                form.render();
				laydate.render({
					elem : '#leaveTime',
				});
				laydate.render({
					elem : '#returnTime',
				});
				//lay-submit是重点
				form.verify({
					idvalidate:[/^[\d]{1,20}$/,'请选择课程']
				});

			});
				</script>
			
			
			<div id="afterLeaveMoudle"  class="site-text site-block"
				style="display: none; margin-top: 0;">
				<table class="layui-table" id="leaveRecordTable">
					<colgroup>
						<col width="130">
						<col width="110">
						<col width="130">
						<col width="130">
						<col width="120">
						<col width="90">
					</colgroup>
					<thead>
						<tr>
							<th style="text-align: center;">课程编码</th>
							<th style="text-align: center;">课程名称</th>
							<th style="text-align: center;">请假事由</th>
							<th style="text-align: center;">请假时间</th>
							<th style="text-align: center;">返回时间</th>
							<th style="text-align: center;">状态</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${! empty leaveRecords}">
								<c:forEach items="${leaveRecords}" var="l">
									<tr>
										<td>${l.courseId}</td>
										<td>${l.courseName}</td>
										<td>${l.reason}</td>
										<td>${l.leaveTime}</td>
										<td>${l.returnTime}</td>
										<td>${l.status}</td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
								
				<script>
			layui.use([ 'element', 'layer' ,'table'], function() {
				var element = layui.element, $ = layui.jquery,table = layui.table;
				//转换静态表格
				table.init('courseInfo', {
				  //设置高度
				  //支持所有基础参数
				});
				table.init('signRecord',{
					
				});
			});
			</script>
			</div>

				<!-- 个人资料 -->
				<div class="layui-form sessiontable" id="upLoadShow"
					style="width: 100%; margin-left: 0; display: none;">
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
				

			<!-- 课程信息模块 -->
			<div id="courseInfo" class="courseInfo">
				<table class="layui-table" >
					<colgroup>
						<col width="125">
						<col width="185">
						<col width="100">
						<col width="150">
						<col width="150">
						<col width="100">
						<col width="140">
						<col width="120">
						<col width="140">
						<col width="110">			
					</colgroup>
					<thead>
						<tr>
							<th style="text-align: center;">课程编码</th>
							<th style="text-align: center;">课程名称</th>
							<th style="text-align: center;">类型</th>
							<th style="text-align: center;">开课时间</th>
							<th style="text-align: center;">结课时间</th>
							<th style="text-align: center;">学年</th>
							<th style="text-align: center;">学期</th>
							<th style="text-align: center;">老师</th>
							<th style="text-align: center;">联系方式</th>
							<th style="text-align: center;">操作</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${! empty studentInfos}">
								<c:forEach items="${studentInfos}" var="s">
									<tr>
									    <td>${s.course.courseId}</td>
										<td><a id="${s.course.courseId}" onclick="getPrivateData(this.id)" href="#" class="aSign">
										${s.course.courseName}&nbsp;<i class="layui-icon" style="font-size: 15px; color: #1E9FFF;">&#xe61d;</i></a></td>
										<td>${s.course.courseType}</td>
										<td>${s.course.startTime}</td>
										<td>${s.course.endTime}</td>
										<td>${s.course.currentYear}</td>
										<td>${s.course.schoolTem}</td>
										<td><a id="${s.course.courseId}" onclick="messageToTeacherNow(this.id)" style="color: #5FB878" href="#">${s.course.teacher.teacherName}&nbsp;<i class="layui-icon" style="font-size: 15px; color: #1E9FFF;">&#xe611;</i></a></td>
										<td>${s.course.teacher.teacherMobile}</td>
										<td><a onclick="wantToExitCourse()" href="#" class="aSign">退出</a></td>
										<!--  <td colspan="8"></td>-->
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="10">(暂无课程)</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
			<script>
			//给老师发消息
			function messageToTeacherNow(courseId) {
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
			        ,content: '<div style="background-color: #393D49; color: #fff;"><div  style="width:100%;"> <br/><label>发送消息</label><textarea style="color:#393D49" id="messageToStudentContentNow" class="layui-textarea"></textarea></div></div>'
			        ,yes: function(){
			        	if($('#messageToStudentContentNow').val() != "" && courseId != null){
			        		$.ajax({
			        	        type: "GET",
			        	        data: {
			        	         "messageToStudentContentNow":$('#messageToStudentContentNow').val(),
			        	         "studentRoNo":${student.studentRoNo},
			        	         "courseId":courseId
			        	        },
			        	        contentType: "application/json; charset=utf-8",
			        	        async: false,
			        	        url: "<%=request.getContextPath()%>/student/messageToTeacherNow.do",
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
			
			
			layui.use([ 'element', 'layer' ,'table'], function() {
				var element = layui.element, $ = layui.jquery,table = layui.table;
				//转换静态表格
				table.init('courseInfo', {
				  //设置高度
				  //支持所有基础参数
				});
				table.init('signRecord',{
					
				});
							
			});
			function wantToExitCourse() {
				layui.use('layer', function() {
					var $ = layui.jquery, layer = layui.layer;
					layer.msg('仅能由教师端删除学生！');
				});
			}
			</script>


			<!-- 学生添加课程模块 -->
			<div class="site-text site-block" id="studentAddCourse"
				style="display: none;">
				<form class="" action="">
					<div class="layui-form-item">
						<label class="layui-form-label">课程编码</label>
						<div class="layui-input-block">
							<input id="courseId" type="text" name="courseId" required
								lay-verify="required" onchange="searchIfExistCourse()"
								placeholder="请输入课程编码" autocomplete="off" class="layui-input">
						</div>
						<p id="listenEmpty"
							style="color: red; display: none; margin-left: 13%;">*课程为空*</p>
						<p id="listenId"
							style="color: red; display: none; margin-left: 13%;">*课程编码请输入数字*</p>
						<p id="listenIdEmpty"
							style="color: red; display: none; margin-left: 13%;">*课程编码不可为空*</p>
						<p id="listenClazzs"
							style="color: red; display: none; margin-left: 13%;">*暂无班级可供选择*</p>
					</div>

					<div class="layui-form-item">
						<label class="layui-form-label">课程名称</label>
						<div class="layui-input-block">
							<input id="courseName" type="text" name="courseName" required
								lay-verify="required" placeholder="请输入课程名称" autocomplete="off"
								class="layui-input">
						</div>
						<p id="listenName"
							style="color: red; display: none; margin-left: 13%;">*课程名称请控制在100字以内*</p>
					</div>

					<div id="clazzDiv" style="display: none;">
						<label class="layui-form-label">选择班级</label> <select
							id="clazzName" name="clazzName"
							style="height: 2.3em; width: 20%;">

						</select> <br />
					</div>
					<p id="listenClss"
						style="color: red; display: none; margin-left: 13%;">*班级不可为空*</p>

					<p id="listenClssExit"
						style="color: red; display: none; margin-left: 13%;">*您已在该课程*</p>
					<div class="layui-form-item">
						<div class="layui-input-block">
							<input id="AddCourseButton" class="layui-btn"
								onclick="studentAddCourse()" type="button" value="提交申请" />
							<button type="reset" class="layui-btn layui-btn-primary">重置</button>
						</div>
					</div>
				</form>

				<script>
					//Demo
					layui.use([ 'form'], function() {
						var form = layui.form;
						//监听提交
						form.on('submit(formDemo)', function(data) {
							layer.msg(JSON.stringify(data.field));
							return false;
						});
					});
				</script>
			</div>


			<!-- 签到记录 -->
			<div id="studentWork" class="studentWork courseInfo">
				<table class="layui-table">
					<colgroup>
    					<col width="120">
    					<col width="200">
    					<col width="150">
    					<col width="150">
    					<col width="120">
    					<col width="120">
    					<col width="120">
    					<col width="120">
 					</colgroup>
					<thead>
						<tr>
							<th style="text-align: center;">课程编码</th>
							<th style="text-align: center;">课程名称</th>
							<th style="text-align: center;">学年</th>
							<th style="text-align: center;">学期</th>
							<th style="text-align: center;">签到</th>
							<th style="text-align: center;">迟到</th>
							<th style="text-align: center;">早退</th>
							<th style="text-align: center;">旷课</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${! empty studentInfos}">
								<c:forEach items="${studentInfos}" var="s">
									<tr>
										<td>${s.course.courseId}</td>
										<td>${s.course.courseName}</td>
										<td>${s.course.currentYear}</td>
										<td>${s.course.schoolTem}</td>
										<td>${s.signIn}</td>
										<td>${s.comeLate}</td>
										<td>${s.leaveEarlier}</td>
										<td>${s.absenteeism}</td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="8">(暂无信息)</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>

			<!-- 显示消息 -->
			<div class="layui-tab" id="messageShow" style="margin-left: 5%; margin-right: 5%; display: none;">
			<ul class="layui-tab-title">
		    <li class="layui-this">收件箱</li>
		    <li onclick="tableRender()">发件箱</li>
		  </ul>
		  <div class="layui-tab-content">
		  <div class="layui-tab-item layui-show">
			<div>
				<table class="layui-table" lay-skin="line"
					lay-data="{page:true,height:485,width:1070, url:'<%=request.getContextPath() %>/student/getSeperratePage.do',
			 id:'test', where:{messageAcpter:'${student.studentRoNo}'}, limit:10}"
					lay-filter="test" style="width: 100%;">
					<thead>
						<tr>
							<th lay-data="{field:'messageSender', width:200, sort: true}">发送方</th>
							<th
								lay-data="{field:'messageTitle', width:500,templet: '#titleTpl'}">标题</th>
							<th
								lay-data="{field:'haveRead', width:200, sort: true, align:'center', templet: '#status'}">状态</th>
							<th
								lay-data="{fixed: 'right', width:160, align:'center', toolbar: '#barDemo'}"></th>
						</tr>
					</thead>
				</table>
			</div>
			</div>
		<div class="layui-tab-item">
	     <div>
				<table class="layui-table" lay-skin="line"
					lay-data="{page:true,height:485,width:1070, url:'<%=request.getContextPath() %>/student/getSenderSeperratePage.do',
			 id:'test2', where:{messageSender:'${student.studentRoNo}'}, limit:1000}"
					lay-filter="test">
					<thead>
						<tr>
							<th lay-data="{field:'messageAccepter', width:200, sort: true}">接收方</th>
							<th
								lay-data="{field:'messageTitle', width:500,templet: '#titleTpl'}">标题</th>
							<th
								lay-data="{field:'haveRead', width:200, sort: true, align:'center', templet: '#havaread'}">状态</th>
							<th
								lay-data="{fixed: 'right', width:160, align:'center', toolbar: '#barDemo2'}"></th>
						</tr>
					</thead>
				</table>
			</div>
	  </div>
	  </div>
	</div>	
			<script type="text/html" id="barDemo">
  			<a class="layui-btn layui-btn-primary layui-btn-mini" lay-event="detail">查看</a>
  			<a class="layui-btn layui-btn-danger layui-btn-mini" lay-event="del">删除</a>
			</script>
			 <script type="text/html" id="barDemo2">
               <a class="layui-btn layui-btn-primary layui-btn-mini" lay-event="detail2">查看</a>
           </script>
			<script type="text/html" id="status">
                  {{#  if(d.haveRead == '已读'){ }}
                    <i class="layui-icon" style="font-size: 20px; color: #5FB878;">&#xe618;</i>
                     {{#  } else { }}
                       <i class="layui-icon" style="font-size: 20px; color: #FF5722;">&#xe607;</i>
                         {{#  } }}
            </script>
            
             <script type="text/html" id="havaread">
                  {{#  if(d.haveRead == '已读'){ }}
                    <i class="layui-icon" style="font-size: 10px; color: #5FB878;">对方已读</i>
                     {{#  } else { }}
                       <i class="layui-icon" style="font-size: 10px; color: #FF5722;">对方未读</i>
                         {{#  } }}
         </script>
            
			<script type="text/html" id="titleTpl">
     		<a href="#" class="layui-table-link">{{d.messageTitle}}</a>
   			</script>
			<script>
			//查看发件箱
			function getSenderMessage(messageId) {
				$.ajax({
		            type: "GET",
		            data: {
				         "messageId": messageId
		            },
		            contentType: "application/json; charset=utf-8",
		            async: false,
		            url: "<%=request.getContextPath()%>/teacher/getMessageByAjax.do",
					success : function(data) {
						$('#handleMessageShow').hide();
							layer.open({
					            type: 1
					            ,title: false
					            ,closeBtn: true
					            ,area: '300px;'
					            ,shade: 0.8
					            ,id: 'LAY_layuipro' 
					            ,btn: ['完成']
					            ,btnAlign: 'c'
					            ,moveType: 0 
					            ,content: '<div style="background-color: #393D49; color: #fff;"><br/>标题：' +data.mmm.messageTitle + '<br/>内容：' + data.mmm.messageContent +'<br/></div>'
					            ,yes: function(){
					            	layer.closeAll();
								  }
					          });				
					},
					error : function(data) {
						alert("服务器异常");
					},
					dataType : "json",
				});
			}
        	layui.use('table', function(){
        		var table = layui.table;
        		table.on('tool(test)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
            		var data = obj.data; //获得当前行数据
            		var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            		var tr = obj.tr; //获得当前行 tr 的DOM对象      
            		if(layEvent === 'detail'){ //查看
            			if(data.haveRead === '未读'){
                    		if($('#TmessageCount').html()>1){
                           	 $('#TmessageCount').html($('#TmessageCount').html()-1);
                            }else {
                            	$('#TmessageCount').hide();
            				}	
                    	}
             			getMessage(data.messageId);
           			}else if(layEvent === 'detail2'){ //查看
           		        //发件箱查看消息	
           	         getSenderMessage(data.messageId);
           	        
           	        }else if(layEvent === 'del'){ //删除
              			layer.confirm('真的删除该消息么？', function(index){
              				if(data.haveRead === '未读'){
              	        		if($('#TmessageCount').html()>1){
              	               	 $('#TmessageCount').html($('#TmessageCount').html()-1);
              	                }else {
              	                	$('#TmessageCount').hide();
              					}	
              	        	}
               				//向服务端发送删除指令
          					$.ajax({
                     			type: "GET",
                     			data: {
                    				"messageId":data.messageId
                     			},
                     			contentType: "application/json; charset=utf-8",
                     			async: false,
                     			//url不加空格！！！！！！！！！！！！！！！！！！！！！！！
                     			url: "<%=request.getContextPath()%>/student/deleteMessage.do",
        						success : function(data) {
        							if(data.result == true){
        								obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
        			            		layer.close(index);
        							}else{
        								alert("删除失败");
        							}
        						},
        						error : function(data) {		
        						},
        						dataType : "json",
        					});
              			});
            		} 
            		obj.update({
                		haveRead: '已读'
					});
				});
			});        
			</script>

			<!-- 附属详细消息 -->
			<div id="fushuMessage"
				style="width: 100%; padding-left: 25%; display: none; margin-top: 5%;">
				<h3 id="messageTitleS"></h3>
				<hr />
				<br /> <br /> <span id="messageSnderS"></span><br /> <br /> <br />
				<br /> <span id="messageSenderNameS" style="display: none;"></span>
				<span id="sendTime"></span><br /> <br /> <br /> <br /> <span
					id="forMessageContentS">内容<br /></span>
				<textarea id="messageContent" rows="5" cols="40" readonly="readonly"></textarea>
				<br /> <br />
				<div id="insertCourseDiv" style="display: none;">
					<input type="text" id="MteacherMoile" style="display: none;" /> <input
						type="text" id="MCourseId" style="display: none;" /> <input
						id="agree" class="layui-btn" onclick="dontCare()" type="button"
						value="了解" /> <input style="margin-left: 10%;" id="dontCare"
						onclick="dontCare()" class="layui-btn layui-btn-primary"
						type="button" value="忽略" />
				</div>
			</div>




			<!-- 学生操作日志表 -->
			<div id="forStudentLogInfo" class="site-text site-block"
				style="text-align: center; height: 3em; margin-top: 0.1%; display: none;">
				<form class="layui-form" action="">
					<div class="layui-form-item" style="width: 100%; margin-left: 1%;">
						<div style="height: 100%; float: left;">
							<label class="layui-form-label" style="">输入日期</label>
							<div class="layui-input-block" style="">
								<input id="logDate" type="text" lay-verify="logDate"
									placeholder="yyyy-MM-dd" autocomplete="off" class="layui-input"
									style="width: 80%; float: left;">
							</div>
						</div>
						<div style="height: 100%; width: 49%; float: left;">
							<label class="layui-form-label" style="">输入关键字</label>
							<div class="layui-input-block" style="">
								<input id="CoreKey" type="text" lay-verify="CoreKey"
									placeholder="如  '登录'" autocomplete="off" class="layui-input"
									style="width: 60%; float: left;"> <input
									class="layui-btn" lay-submit type="button"
									onclick="searchStudentLogByTime()" value="查询"
									style="float: left;" />
							</div>
						</div>
					</div>
				</form>
			</div>
			<script>
					//Demo
					layui.use([ 'form', 'laydate' ], function() {
						var form = layui.form, laydate = layui.laydate;
						laydate.render({
							elem : '#logDate'
						});
						
						form.verify({
							logDate:[/\S/,'日期不可为空']
						});
					});
			</script>

			<table id="studentLogOfTime" border="1"
				style="display: none; text-align: center; width: 80%; margin-left: 9.5%;">
			</table>

			<table class="layui-table"  lay-even lay-size="sm" id="studentLogInfo" 
				style="text-align: center; width: 80%; margin-left: 9.5%; display: none;">
				<colgroup>
    				<col width="150">
    				<col width="250">
    				<col width="200">
    				<col width="250">
    				<col width="150">
  				</colgroup>
				<thead>
					<tr>
						<th>学号</th>
						<th>活动</th>
						<th>Ip</th>
						<th>时间</th>
						<th>结果</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${! empty logEntity}">
							<c:forEach items="${logEntity}" var="s">
								<tr>
									<td>${s.userId}</td>
									<td style="text-align: left; padding-left: 10%;">${s.method}</td>
									<td>${s.ip}</td>
									<td>${s.date}</td>
									<td>${s.result}</td>
									<!--  <td colspan="8"></td>-->
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="5">(暂无信息)</td>
							</tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>



			<!-- 个人中心 -->
			<div id="studentInfoShow"
				style="background-color: white; margin-left: 13%; margin-right: 20%; width: 100%; padding-left: 5%; padding-top: 2%; padding-bottom: 500px; display: none;">

				<!-- 更新信息成功显示的Div -->
				<div id="updateStudentInfoSuccess" class="site-text site-block"
					style="background-color: #393D49; height: 20%; width: 20%; display: none; z-index: 20; margin-top: 14%; text-align: center; margin-left: 15%; position: absolute;">
					<h3 style="color: white; margin-top: 19%">更新信息成功..</h3>
				</div>

				<table style="float: left; width: 40%; text-align: center;"
					class="layui-form layui-form-pane">
					<tr>
						<td class="layui-form-label">学号</td>
						<td style="text-align: left;">${student.studentRoNo}</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td class="layui-form-label">手机</td>
						<td style="text-align: left;">${student.studentMobile}</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td class="layui-form-label">邮箱</td>
						<td style="text-align: left;">${student.studentEmail}</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td class="layui-form-label">姓名</td>
						<td style="text-align: left;">${student.studentName}</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td class="layui-form-label">性别</td>
						<td style="text-align: left;">${student.studentGender}</td>
					</tr>
					<tr id="forCollege" style="">
						<td>&nbsp;</td>
					</tr>

					<tr id="collegeTr" style="">
						<td class="layui-form-label">学院</td>
						<td style="text-align: left;">${student.college}</td>
					</tr>

					<tr id="reCollegeTr" style="display: none;">
						<td class="layui-form-label">学院</td>
						<td style="text-align: left;"><input required
							style="width: 60%;" class="layui-input" type="text"
							value="${student.college}" id="college" name="college" /></td>
					</tr>

					<tr id="forSpecial" style="">
						<td>&nbsp;</td>
					</tr>

					<tr id="specialTr" style="">
						<td class="layui-form-label">专业</td>
						<td style="text-align: left;">${student.special}</td>
					</tr>
					<tr id="reSpecialTr" style="display: none;">
						<td class="layui-form-label">专业</td>
						<td style="text-align: left;"><input required
							style="width: 60%;" class="layui-input" type="text"
							value="${student.special}" id="special" name="special" /></td>
					</tr>

					<tr id="forSavefectButton" style="display: none;">
						<td>&nbsp;</td>
					</tr>
					<tr id="savefectButton" style="display: none;">
						<td colspan="2" style="text-align: left;">
							<button style="margin-left: 0;" class="layui-btn">保存信息</button>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2" style="text-align: left;"><button
								id="perfectButton" style="margin-left: 0;" class="layui-btn">完善信息</button>
							<span id="signalNow"
							style="color: red; margin-left: 20%; display: none;">*请尽快完善信息*</span>
						</td>
					</tr>

				</table>

				<!-- 补充信息 -->
				<div class="layui-upload-list"
					style="width: 50%; heigh: 120px; float: left; margin-left: 10px;">
					<img class="layui-upload-img"
						src="/ClassManageSys/studentPhoto/${student.studentPhoto}"
						style="width: 100px; heigh: 120px; margin-left: -100px;"
						id="imgPre">
						
					<form id= "uploadForm" enctype="multipart/form-data" method="post"> 	
					<input type="file" name="file" id="uploadFile"
						style="display: none;" onchange="preImg(this.id, 'imgPre2','tct');" />
					<input type="text" name="studentRoNoForPhoto" value="${student.studentRoNo}" style="display: none;" readonly="readonly"/>
					</form>
					
					<a href="#" onclick="beforeUploadFile()" style="margin-left: 15%; color: #5FB878" id="demoText">更换照片</a>
					<input id="tct" type="text" value="" lay-verify="photovalidate"
						style="display: none" />
					
					<table style="margin-left: -110px; width: 70%"
						class="layui-form layui-form-pane">
						<tr id="forintoSchool" style="">
							<td>&nbsp;</td>
						</tr>

						<tr id="intoSchoolYearTr" style="">
							<td class="layui-form-label" style="text-align: left;">入学时间</td>
							<td id="innerTime" style="text-align: left; width: 47%;">${student.intoSchoolYear}</td>
						</tr>
						<tr id="reIntoSchoolYearTr" style="display: none;">
							<td class="layui-form-label" valign="2017"
								style="text-align: left;">入学时间</td>
							<td style="text-align: left; width: 47%;"><input
								lay-verify="requirevalidate" required style="width: 60%;"
								class="layui-input" type="text"
								value="${student.intoSchoolYear}" id="intoSchoolYear"
								name="intoSchoolYear" /></td>
						</tr>

						<tr id="forschoolRecord" style="">
							<td>&nbsp;</td>
						</tr>

						<tr id="schoolRecordTr" style="text-align: left;">
							<td class="layui-form-label" style="text-align: left;">当前学历</td>
							<td style="text-align: left; width: 47%;">${student.schoolRecord}</td>
						</tr>
						<tr id="reSchoolRecordTr" style="display: none;">
							<td class="layui-form-label" style="text-align: left;" required>当前学历</td>
							<td style="text-align: left; width: 47%;"><select
								id="schoolRecord">
									<option value="本科" selected="selected">本科</option>
									<option value="硕士">硕士</option>
									<option value="博士">博士</option>
									<option value="海归">海归</option>
							</select>
						</tr>

						<tr id="forBirthDay" style="">
							<td>&nbsp;</td>
						</tr>

						<tr id="birthDayTr" style="">
							<td class="layui-form-label" style="text-align: left;">出生日期</td>
							<td style="text-align: left; width: 47%;">${student.birthDay}</td>
						</tr>
						<tr id="reBirthDayTr" style="display: none;">
							<td class="layui-form-label" style="text-align: left;">出生日期</td>
							<td style="text-align: left; width: 47%;"><input required
								style="width: 60%;" class="layui-input" type="text"
								value="${student.birthDay}" id="birthDay" name="birthDay" /></td>
						</tr>

						<tr id="forFreeStyle" style="">
							<td>&nbsp;</td>
						</tr>

						<tr id="freeStyleTr" style="">
							<td class="layui-form-label" style="text-align: left;">freeStyle</td>
							<td style="text-align: left;">${student.freeStyle}</td>
						</tr>
						<tr id="reFreeStyleTr" style="display: none;">
							<td class="layui-form-label" style="text-align: left;">freeStyle</td>
							<td style="text-align: left; width: 47%;"><input
								style="width: 60%;" class="layui-input" type="text"
								value="${student.freeStyle}" id="freeStyle" name="freeStyle" /></td>
						</tr>
					</table>
				</div>

			</div>
			<script>
			function beforeUploadFile() {
				layer.open({
		            type: 1
		            ,title: false
		            ,area: '300px;'
		            ,shade: 0.8
		            ,id: 'LAY_layuiproJ' 
		            ,btn: ['更换', '取消']
		            ,btnAlign: 'c'
		            ,moveType: 0 
		            ,content: '<div style="background-color: #393D49; color: #fff;"><br/><button class="layui-btn" type="button" onclick="uploadFile.click()">选择照片</button><br/><br/><img class="layui-upload-img" style="width: 100px; heigh:120px;" id="imgPre2"><br/></div>'
		            ,yes: function(){
		            	if($('#tct').val() != ""){
		            		var formData = new FormData($( "#uploadForm" )[0]); 
		            		$.ajax({
	                  	        type: "POST",
	                  	        data:formData,
	                  	        contentType: false,  
	                            processData: false,
	                  	        async: false,
	                  	        url: "<%=request.getContextPath()%>/student/updateStudentPhoto.do",
	                  			success : function(data) {
	                  				if(data.result == true){
	                  					layui.use('layer', function(){
	               		 	               var $ = layui.jquery, layer = layui.layer; 
	               		   			      layer.open({
	               		   			        type: 1
	               		   			        ,offset: 'auto'
	               		   			        ,id: 'layerDemo'+'auto'
	               		   			        ,title: '成功'
	               		   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "照片更换成功！" +'</div>'
	               		   			        ,btn: '关闭'
	               		   			        ,btnAlign: 'c'
	               		   			        ,skin: 'demo-class'
	               		   			        ,shade: 0 
	               		   			        ,yes: function(){
	               		   			        	setTimeout('layer.closeAll()','1500');
	               		   			        	  
	               		   			        }
	               		   			      });
	               		 	            });
	                  					  var imgPre = document.getElementById("imgPre");
                 					      imgPre.style.display = "block";
                 					      imgPre.src = "<%=request.getContextPath()%>/studentPhoto/" + data.fileName;
	                  				}else{
	                  					layui.use('layer', function() {
	                  						var $ = layui.jquery, layer = layui.layer;
	                  						layer.msg('照片更换失败！');
	                  					});
	                  				}
	                  				layer.closeAll();
	                  			},
	                  			error : function(data) {
	                  				alert("服务器异常");
	                  			},
	                  			dataType : "json",
	                  		});
		            	}else {
		            		layui.use('layer', function() {
		  	    				var $ = layui.jquery, layer = layui.layer;
		  	    				layer.msg('请选择照片!');
		  	    			});
						}
					  }
		           
		          });
			}
			/** 
			 * 将本地图片 显示到浏览器上 
			 */
			function getFileUrl(sourceId) {
				var url;
				url = window.URL
						.createObjectURL(document.getElementById(sourceId).files
								.item(0));
				return url;
			}
			function preImg(sourceId, targetId, tct) {
				
				var fileName = document.getElementById(sourceId).value;
				var fileNamePlus = fileName.substr(12);
				var url = getFileUrl(sourceId);
				var imgPre = document.getElementById(targetId);
				imgPre.style.display = "block";
				imgPre.src = url;
				document.getElementById(tct).value = fileNamePlus;
			}
					//Demo
					layui.use([ 'form', 'laydate' ], function() {
						var form = layui.form, laydate = layui.laydate;
						form.render();
						laydate.render({
							elem : '#birthDay'
						});
						laydate.render({
							elem : '#intoSchoolYear',
							type : 'year',
							value: '2017'
						});
					});
					layui.use('form', function() {
						var form = layui.form;
					form.verify({
						requirevalidate: [/\S/,'必填项不可为空']
					});
					});
				</script>


			<!-- 安全/密码 -->
			<div id="signal"
				style="width: 95%; margin-left: 5%; padding-left: 5%; z-index: 1; background-color: #009688; height: 4%; display: none; font-family: 微软雅黑;">
				提示：修改邮箱后后请前往原邮箱确认..</div>
			<!-- 更改邮箱成功提示信息 -->
			<div id="changeMailShow" class="site-text site-block"
				style="background-color: #393D49; height: 20%; width: 20%; display: none; z-index: 20; margin-top: 14%; text-align: center; margin-left: 25%; position: absolute;">
				<h3 style="color: white; margin-top: 19%">更新邮箱成功..</h3>
			</div>

			<div class="site-text site-block" id="doubleHandle"
				style="width: 70%; margin-left: 5%; margin-top: 4%; display: none;">
				<a class="layui-btn layui-btn-primary" href="#" id="changeStuPass"
					style="float: left; height: 20%; width: 49%; font-size: 1.5em">更改密码</a>
				<a class="layui-btn layui-btn-primary" href="#" id="changeStuMail"
					style="float: left; height: 20%; width: 49%; font-size: 1.5em">更换邮箱</a>
				<br /> <br />
				<form class="layui-form layui-form-pane" id="safe"
					action="<%=request.getContextPath()%>/student/updateStudentPassWord.do"
					style="width: 84%; margin-left: 5%; padding-left: 17%">
					<table>
						<br />
						<tr style="width: 100%;">
							<td><label class="layui-form-label">学号</label></td>
							<td><input class="layui-input" type="text"
								readonly="readonly" name="studentRoNo"
								value="${student.studentRoNo}" id="studentRoNo"
								style="width: 25em;" /></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><label class="layui-form-label">原密码</label></td>
							<td><input class="layui-input" type="password"
								name="oldPassword" id="studentPassword" style="width: 25em" /></td>
							<td id="passError"
								style="color: red; margin-left: 1.8em; display: none;">*密码错误*</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><label class="layui-form-label">新密码</label></td>
							<td><input class="layui-input" type="password"
								name="studentPassword" id="newPassword" style="width: 25em" /></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><label class="layui-form-label">确认新密码</label></td>
							<td><input class="layui-input" type="password"
								name="rePassword" id="rePassword" style="width: 25em" /></td>
							<td id="noLike"
								style="color: red; margin-left: 1.8em; display: none;">*两次密码不一致*</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td colspan="2"><input class="layui-btn" id="ccchangePass"
								type="button" value="申请修改" style="width: 70%; margin-left: 15%;" /></td>
						</tr>
					</table>
				</form>

				<!-- 修改邮箱 -->
				<form id="emailsafe" class="layui-form layui-form-pane"
					action="<%=request.getContextPath()%>/student/updateStudentEmail.do"
					style="width: 84%; margin-left: 5%; padding-left: 17%; display: none;">
					<table style="">
						<br />
						<tr style="width: 100%;">
							<td><label class="layui-form-label">学号</label></td>
							<td><input class="layui-input" type="text"
								readonly="readonly" name="studentRoNo"
								value="${student.studentRoNo}" id="studentRoNo"
								style="width: 25em;" /></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><label class="layui-form-label">原邮箱</label></td>
							<td><input class="layui-input" type="text" id="oldEmail"
								name="oldEmail" value="${student.studentEmail}"
								id="studentEmail" style="width: 25em" readonly="readonly" /></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><label class="layui-form-label">新邮箱</label></td>
							<td><input class="layui-input" id="mail" type="text"
								name="studentEmail" required lay-verify="required|email"
								autocomplete="off" style="width: 19em" /></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
						<tr>
							<td colspan="2" id="emailTypeError"
								style="text-align: right; width: 20em; color: red; display: none; padding-left: 20%;">*格式错误*</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td colspan="2"><input class="layui-btn"
								id="changeStuMailPush" type="button" value="申请修改"
								style="width: 70%; margin-left: 15%;" /></td>
						</tr>
					</table>
				</form>

			</div>



		</div>

	</div>



	<script type="text/javascript">
   //刷新当前页面
		function yourFunction() {
		 window.location.reload();
	}
   //修改密码
 	$('#changeStuPass').click(function asd() {
 		$('#messageList').html("修改密码");
 		$('#emailsafe').hide();
 		$('#safe').show();
 	});
 	//修改邮箱
     $('#changeStuMail').click(function asd() {
    	 $('#messageList').html("修改邮箱");
     	$('#safe').hide();
 		$('#emailsafe').show();
 	});
   //提交更改邮箱申请
	 $('#changeStuMailPush').click(function asd() {
    	if(test()){
    		 $('#emailTypeError').hide();
    		 if(pushEmail()){
    			 layui.use('layer', function(){
  	               var $ = layui.jquery, layer = layui.layer; 
  			      layer.open({
  			        type: 1
  			        ,offset: 'auto'
  			        ,id: 'layerDemo'+'auto'
  			        ,title: '成功'
  			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "邮箱重置成功" +'</div>'
  			        ,btn: '关闭'
  			        ,btnAlign: 'c'
  			        ,skin: 'demo-class'
  			        ,shade: 0 
  			        ,yes: function(){
  			          yourFunction(); 
  			        }
  			      });
  	            });
    			
    		 }else {
    			 layui.use('layer', function() {
						var $ = layui.jquery, layer = layui.layer;
						layer.msg('抱歉，服务器拥挤请稍后再试..！');
					});
			}
    	}else {
    		$('#waitChangeMailShow').hide();
		}
	});
   //后台更新邮箱及通知原邮箱
	function pushEmail() {
		 //ajax后台更新
		 var result = false;
		 var studentEmail = $('#mail').val();
		 var oldEmail = $('#oldEmail').val();
		 var studentRoNo = $('#studentRoNo').val();
		$.ajax({
              type: "GET",
              data: {
            	  "studentRoNo":studentRoNo,
            	  "studentEmail":studentEmail,
            	  "oldEmail":oldEmail
              },
              contentType: "application/json; charset=utf-8",
              async: false,
              dataType: "json",
              url: "<%=request.getContextPath()%>/student/changeStuMail.do",
              success: function (data) {
            	  if(data.result == true){
            		  result = true;
            	  }else{
            		  
            	  }
              },
              error: function (data) {
            	  alert("服务器异常");
              }
          });
		return result;
	}
  //对电子邮箱的验证
    function test(){
     var temp = document.getElementById("mail");
     var myreg = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
     if(!myreg.test(temp.value)){
         $('#emailTypeError').show();
         myreg.focus();
          return false;
      }else{
    	  return true;
      }
     }
     </script>

	<script>
		layui.use('element', function() {
			var element = layui.element; //导航的hover效果、二级菜单等功能，需要依赖element模块
			//监听导航点击
			element.on('nav(demo)', function(elem) {
				//console.log(elem)
				layer.msg(elem.text());
			});
		});
	</script>

</body>
</html>