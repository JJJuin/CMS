<%@page import="com.mysql.fabric.xmlrpc.base.Data"%>
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

<link type="text/css" rel="stylesheet"
	href="<%=request.getContextPath()%>/layui/css/layui.css">
<script src="<%=request.getContextPath()%>/layui/layui.js "></script>
	<script src="<%=request.getContextPath()%>/layui/mods/index.js"></script>
<title>教师</title>

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
	    	websocket.send("${teacher.teacherMobile}");
	    }else {
	    	layui.use('layer', function() {
				var $ = layui.jquery, layer = layui.layer;
				layer.msg('websocket链接异常');
			});
		}
	}

	
layui.use(['form'], function(){
	var form = layui.form;
	form.render(); 
	});
	 $(document).ready(function () {
		 layui.use(['form'], function(){
			 var form = layui.form;
			 form.render(); 
			 });		 
		 //首先检查学生个人信息是否完善
		 if(${empty student.college} ||${empty student.special}||${empty student.intoSchoolYear}
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
		 function gggetMessageCount() {
			 
			 $.ajax({
	             type: "GET",
	             data: {
	            	 "teacherMobile":$('#teacherMobile').val()
	             },
	             contentType: "application/json; charset=utf-8",
	             async: true,
	             //url不加空格！！！！！！！！！！！！！！！！！！！！！！！
	             url: "<%=request.getContextPath()%>/teacher/gggetMessageCount.do",
				success : function(data) {
					if(data.message > 0){
						$('#TmessageCount').html(data.message);
						$('#TmessageCount').show();
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
		 //添加课程
		 $('#createCourse').click(function() {
			 $('#messageList').html("添加课程");
		    $('#changeCourseinfo').hide();
			$('#doubleHandle').hide();
			$('#signal').hide();
		    $('#courseInfo').hide();
		    $('#messageShow').hide();
		    $('#seprateMessage').hide();
		    $('#fushuMessage').hide();
		    $('#teacherInfoShow').hide();
		    $('#upLoadShow').hide();
		    $('#fileInfo').hide();
		    $('#lookData').hide();
		    $('#forTeacherLogInfo').hide();
			$('#teacherLogInfo').hide();
			$("#teacherLogOfTime").hide();
			$('#courseShow').show();
		});
		 //课程信息
		 $('#checkCourseShow').click(function() {
			 window.location.reload();
			});
		 //点击消息
		  $('#messageButtton').click(function() {
			  $('#messageList').html("消息列表");
			 $('#changeCourseinfo').hide();
			 $('#doubleHandle').hide();
			 $('#signal').hide();
			 $('#courseShow').hide();
			 $('#courseInfo').hide();
			 $('#fushuMessage').hide();
			 $('#teacherInfoShow').hide();
			 $('#lookData').hide();
			 $('#fileInfo').hide();
			 $('#upLoadShow').hide();
			 $('#forTeacherLogInfo').hide();
				$('#teacherLogInfo').hide();
				$("#teacherLogOfTime").hide();
			 $('#seprateMessage').show();
			 $('#messageShow').show();
			 layui.use('table', function(){
				  var table = layui.table;
				  table.reload('test1', {});
				  table.reload('test2', {});
			 });
			 
			 layui.use('table', function(){
				  var table = layui.table;
				  table.reload('test2', {});
			 });
			});
		 //点击二维码叉号
		 $('#esc').click(function() {
			 $('#targetup').hide();
			 $('#courseInfo').show();
			});
		 //删除课程，点击取消时
		 $('#false').click(function() {
			$('#torf').hide();
		});
		//个人中心
		 $('#teacherInfoCenter').click(function name1() {
			 $('#messageList').html("个人中心");
			 $('#seprateMessage').hide();
			 $('#changeCourseinfo').hide();
			 $('#doubleHandle').hide();
			 $('#signal').hide();
			 $('#courseShow').hide();
			 $('#messageShow').hide();
			 $('#fushuMessage').hide();
			 $('#forTeacherLogInfo').hide();
			 $("#teacherLogOfTime").hide();
			 $('#teacherLogInfo').hide();
			 $('#lookData').hide();
			 $('#fileInfo').hide();
			 $('#courseInfo').hide();
			 $('#upLoadShow').hide();
			 $('#teacherInfoShow').show();
		 });
		 //查看资料
		 $('#lookatData').click(function name1() {
			 $('#messageList').html("查看资料");
			 $('#seprateMessage').hide();
			 $('#changeCourseinfo').hide();
			 $('#doubleHandle').hide();
			 $('#signal').hide();
			 $('#courseShow').hide();
			 $('#messageShow').hide();
			 $('#fushuMessage').hide();
			 $('#fileInfo').hide();
			 $('#courseInfo').hide();
			 $('#forTeacherLogInfo').hide();
				$('#teacherLogInfo').hide();
				$("#teacherLogOfTime").hide();
			 $('#upLoadShow').hide();
			 $('#teacherInfoShow').hide();
			 $('#lookData').show();
		 });
		//点击修改信息
		$('#changeTeacherInfoh').click(function name1() {
			 $('#seprateMessage').hide();
			 $('#changeCourseinfo').hide();
			 $('#doubleHandle').hide();
			 $('#signal').hide();
			 $('#courseShow').hide();
			 $('#messageShow').hide();
			 $('#fushuMessage').hide();
			 $('#upLoadShow').hide();
			 $('#lookData').hide();
			 $('#courseInfo').hide();
			 $('#forTeacherLogInfo').hide();
				$('#teacherLogInfo').hide();
				$("#teacherLogOfTime").hide();
			 $('#collegeTr').hide();
				$('#reCollegeTr').show();
				$('#specialTr').hide();
				$('#reSpecialTr').show();
				$('#schoolRecordTr').hide();
				$('#reSchoolRecordTr').show();
				$('#birthDayTr').hide();
				$('#reBirthDayTr').show();
				$('#forSavefectButton').show();
				$('#freeStyleTr').hide();
				$('#reFreeStyleTr').show();
				$('#perfectButton').hide();
				$('#signalNow').hide();
				$('#savefectButton').show();
			 $('#teacherInfoShow').show();
		});
		//点击操作日志
		 $('#teacherLog').click(function name() {
			 $('#messageList').html("操作日志");
			 $('#seprateMessage').hide();
			 $('#changeCourseinfo').hide();
			 $('#doubleHandle').hide();
			 $('#signal').hide();
			 $('#courseShow').hide();
			 $('#messageShow').hide();
			 $('#fushuMessage').hide();
			 $('#fileInfo').hide();
			 $('#courseInfo').hide();
			 $('#upLoadShow').hide();
			 $('#teacherInfoShow').hide();
			 $('#lookData').hide();
			 $('#forTeacherLogInfo').show();
			 $('#teacherLogInfo').show();
		});
		//点击完善信息
		 $('#perfectButton').click(function wq() {
			 $('#messageList').html("完善信息");
				$('#collegeTr').hide();
				$('#reCollegeTr').show();
				$('#specialTr').hide();
				$('#reSpecialTr').show();
				$('#schoolRecordTr').hide();
				$("#teacherLogOfTime").hide();
				$('#reSchoolRecordTr').show();
				$('#birthDayTr').hide();
				$('#reBirthDayTr').show();
				$('#forSavefectButton').show();
				$('#freeStyleTr').hide();
				$('#reFreeStyleTr').show();
				$('#perfectButton').hide();
				$('#signalNow').hide();
				$('#savefectButton').show();
			});
		    //点击保存 后台完善教师信息
		    $('#savefectButton').click(function wannaSubmittt() {
		    	$.ajax({
		              type: "GET",
		              data: {
		            	  "teacherMobile":$('#teacherMobile').val(),
		            	  "college":$('#college').val(),
		            	  "special":$('#special').val(),
		            	  "schoolRecord":$('#schoolRecord').val(),
		            	  "birthDay":$('#birthDay').val(),
		            	  "freeStyle":$('#freeStyle').val()
		              },
		              contentType: "application/json; charset=utf-8",
		              async: false,
		              dataType: "json",
		              url: "<%=request.getContextPath()%>/teacher/updateStudentInfoByAjax.do",
		              success: function (data) {
		            	  if(data.result == true){
		            		  layer.open({
				   			        type: 1
				   			        ,offset: 'auto'
				   			        ,id: 'layerDemo'+'auto'
				   			        ,title: '成功'
				   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "个人信息更新成功！" +'</div>'
				   			        ,btn: '关闭'
				   			        ,btnAlign: 'c'
				   			        ,skin: 'demo-class'
				   			        ,shade: 0 
				   			        ,yes: function(){
				   			        	yourFunction(); 
				   			        }
				   			      });		            		 
		            	  }else{
		            		  layui.use('layer', function() {
            						var $ = layui.jquery, layer = layui.layer;
            						layer.msg('信息更新失败！');
            					});
		            	  }
		              },
		              error: function (data) {
		            	  alert("服务器异常");
		              }
		          });
		    });
		
	 });
	 //添加课程
	 function addCourse() {
		 $.ajax({
             type: "GET",
             data: {
                 "teacherMobile":$('#teacherMobile').val(),
                 "courseName": $('#courseName').val(),
		         "courseType": $('input[name="courseType"]').filter(':checked').val(),
		         "classCapacity": $('#classCapacity').val(),
		         "startTime": $('#startTime').val(),
		         "endTime": $('#endTime').val(),
		         "currentYear": $('#currentYear').val(),
		         "schoolTem": $('#schoolTem').val()
             },
             contentType: "application/json; charset=utf-8",
             async: false,
             //url不加空格！！！！！！！！！！！！！！！！！！！！！！！
             url: "<%=request.getContextPath()%>/course/insertCourse.do",
			success : function(data) {
				layui.use('layer', function(){
	 	               var $ = layui.jquery, layer = layui.layer; 
	   			      layer.open({
	   			        type: 1
	   			        ,offset: 'auto'
	   			        ,id: 'layerDemo'+'auto'
	   			        ,title: '成功'
	   			        ,content: '<div style="padding: 20px 100px;">'+ "课程添加成功" +'</div>'
	   			        ,btn: '关闭'
	   			        ,btnAlign: 'c'
	   			        ,skin: 'demo-class'
	   			        ,shade: 0 
	   			        ,yes: function(){
	   			         window.location.reload();
	   			        	 layer.closeAll();
	   			        }
	   			      });
	 	            });
			},
			dataType : "json",
		});
	}
	 //刷新页面函数
	 function yourFunction() {
		 window.location.reload();
	}
	//跳转到班级页面，post
	function aClick(clazzId) {
		document.getElementById("asd" + clazzId).submit()
	}
	var tem = ${messageCount}
	//点击某个消息
	function getMessage(messageId) {
		$('#t'+messageId).html("已读");
		$('#t'+messageId).val("已读");
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
            //url不加空格！！！！！！！！！！！！！！！！！！！！！！！
            url: "<%=request.getContextPath()%>/teacher/getMessageByAjax.do",
			success : function(data) {
				$('#handleMessageShow').hide();
				if(data.mmm.messageType == 'admin'){
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
				}else if(data.mmm.messageType == 'nomal'){
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
			                  ,content: '<div style="background-color: #393D49; color: #fff;"><div  style="width:100%;"> <br/><label>回复消息</label><textarea style="color:#393D49" id="returnMessageToStudentContent" class="layui-textarea"></textarea></div></div>'
			                  ,yes: function(){
			                  	if($('#returnMessageToStudentContent').val() != "" && messageId != null){
			                  		$.ajax({
			                  	        type: "GET",
			                  	        data: {
			                  	         "returnMessageToStudentContent":$('#returnMessageToStudentContent').val(),
			                  	         "messageId":messageId
			                  	        },
			                  	        contentType: "application/json; charset=utf-8",
			                  	        async: false,
			                  	        url: "<%=request.getContextPath()%>/teacher/returnMessageToStudent.do",
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
				}else if(data.mmm.messageType == 'insertCourse'){
					$('#handleMessageShow').hide();
					$('#forMessageContent').hide();
					$('#messageContent').hide();
					$('#seprateMessage').hide();
					$('#courseInfo').hide();
					$('#insertCourseDiv').show();
					$('#studentAskLeaveDiv').hide();
					
					$('#MstudentRoNo').val(data.mmm.messageSender);
					$('#MCourseId').val(data.mmm.messageContent);
					$('#messageShow').hide();
					$('#messageTitle').html('标题 <' + data.mmm.messageTitle + '>');
					$('#messageSnder').html('发件人账号 <' + data.mmm.messageSender +'>');
					if(data.student != null){
					$('#messageSenderName').html('发件人姓名 <' + data.student.studentName +'><br/><br/><br/><br/>');
					$('#messageSenderName').show();
					  }
					$('#sendTime').html('时间 <' + data.mmm.sendTime +'>');
					$('#messageContent').html(data.mmm.messageContent);
					$('#fushuMessage').show();
				}else if(data.mmm.messageType == 'leaveRecord'){
					$('#leaveRecordId').val(data.mmm.messageOther);
					$('#forMessageContent').show();
					$('#messageContent').show();
					$('#seprateMessage').hide();
					$('#courseInfo').hide();
					$('#insertCourseDiv').hide();
					$('#studentAskLeaveDiv').show();
					$('#messageContent').html(data.mmm.messageContent);
					$('#MstudentRoNo').val(data.mmm.messageSender);
					$('#MCourseId').val(data.mmm.messageContent);
					$('#messageShow').hide();
					$('#messageTitle').html('标题 <' + data.mmm.messageTitle + '>');
					$('#messageSnder').html('发件人账号 <' + data.mmm.messageSender +'>');
					if(data.student != null){
					$('#messageSenderName').html('发件人姓名 <' + data.student.studentName +'><br/><br/><br/><br/>');
					$('#messageSenderName').show();
					  }
					$('#sendTime').html('时间 <' + data.mmm.sendTime +'>');
					$('#messageContent').html(data.mmm.messageContent);
					$('#fushuMessage').show();
				}
				
				
			},
			error : function(data) {
				alert("服务器异常");
			},
			dataType : "json",
		});
	}
	//查看发件箱
	function getSenderMessage(messageId) {
		$.ajax({
            type: "GET",
            data: {
		         "messageId": messageId
            },
            contentType: "application/json; charset=utf-8",
            async: false,
            //url不加空格！！！！！！！！！！！！！！！！！！！！！！！
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
	
	
	function myFunction() {
		$('#handleMessageShow').hide();
		 $('#changeCourseinfo').hide();
		 $('#doubleHandle').hide();
		 $('#signal').hide();
		 $('#courseShow').hide();
		 $('#courseInfo').hide();
		 $('#fushuMessage').hide();
		 $('#seprateMessage').show();
		 $('#messageShow').show();
	}
	function agree() {
		 $.ajax({
             type: "GET",
             data: {
            	 "teacherMobile":$('#teacherMobile').val(),
		         "studentRoNo": $('#MstudentRoNo').val(),
		         "content": $('#MCourseId').val()
             },
             contentType: "application/json; charset=utf-8",
             async: false,
             //url不加空格！！！！！！！！！！！！！！！！！！！！！！！
             url: "<%=request.getContextPath()%>/studentInfo/insertStudentInfoByteacher.do",
			success : function(data) {
				if(data.result == true){
					layui.use('layer', function(){
		 	               var $ = layui.jquery, layer = layui.layer; 
		   			      layer.open({
		   			        type: 1
		   			        ,offset: 'auto'
		   			        ,id: 'layerDemo'+'auto'
		   			        ,title: '成功'
		   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "处理成功！" +'</div>'
		   			        ,btn: '关闭'
		   			        ,btnAlign: 'c'
		   			        ,skin: 'demo-class'
		   			        ,shade: 0 
		   			        ,yes: function(){
		   			        	 layer.closeAll();
		   			        }
		   			      });
		 	            });
					setTimeout('myFunction()',1500);
				}else{
					layui.use('layer', function(){
		 	               var $ = layui.jquery, layer = layui.layer; 
		   			      layer.open({
		   			        type: 1
		   			        ,offset: 'auto'
		   			        ,id: 'layerDemo'+'auto'
		   			        ,title: '提示'
		   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "请勿重复添加" +'</div>'
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
			error : function(data) {
				alert("服务器异常");
			},
			dataType : "json",
		});
	} 
	function dontCare() {
		     $('#handleMessageShow').hide();
			 $('#changeCourseinfo').hide();
			 $('#doubleHandle').hide();
			 $('#signal').hide();
			 $('#courseShow').hide();
			 $('#courseInfo').hide();
			 $('#fushuMessage').hide();
			 $('#seprateMessage').show();
			 $('#messageShow').show();
	}
	//注销
	function exitLogin() {
		 $.ajax({
             type: "GET",
             data: {
            	 "teacherMobile":$('#teacherMobile').val()
             },
             contentType: "application/json; charset=utf-8",
             async: false,
             //url不加空格！！！！！！！！！！！！！！！！！！！！！！！
             url: "<%=request.getContextPath()%>/teacher/exitLogin.do",
			success : function(data) {
				
			},
			error : function(data) {
			},
			dataType : "json",
		});
	}
	//个人博客
	function toPersonBlog() {
		$('#PersonBlogForm').submit();
	}
	//ajax获取上传的文件列表
	function getPrivateData() {
		 $('#messageList').html("文件上传");
		 $('#seprateMessage').hide();
		 $('#changeCourseinfo').hide();
		 $('#doubleHandle').hide();
		 $('#signal').hide();
		 $('#courseShow').hide();
		 $('#messageShow').hide();
		 $('#fushuMessage').hide();
		 $('#lookData').hide();
		 $('#teacherInfoShow').hide();
		 $('#courseInfo').hide();
		 $('#forTeacherLogInfo').hide();
		 $('#fileInfo').hide();
		 $("#teacherLogOfTime").hide();
		 $('#upLoadShow').show();
		 $.ajax({
             type: "GET",
             data: {
            	 "teacherMobile":$('#teacherMobile').val()
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
	//鼠标悬浮下载
	function getData(id) {
		$('#ab'+id).hide();
		$('#b'+id).show();
	}
	//鼠标离开下载
	function leaveData(id) {
		$('#'+id).hide();
		$('#a'+id).show();
	}
	//教师根据时间查询操作日志
	function searchTeacherLogByTime() {
		if($('#logDate').val() != "" || $('#CoreKey').val() != ""){
		 $.ajax({
	         type: "GET",
	         data: {
	        	 "logDate": $('#logDate').val(),
	        	 "coreKey":$('#CoreKey').val(),
	        	 "studentRono":$('#teacherMobile').val()
	         },
	         contentType: "application/json; charset=utf-8",
	         dataType: "json",
	         async: true,
	         url: "<%=request.getContextPath()%>/student/searchStudentLogByTime.do",
	         success: function (data) {
	        	 $('#teacherLogInfo').hide();
	        	    var dataObj = data.logEntities, //返回的data为json格式的数据
	        	    con =  '\
	        				<tr>\
	        					<th>账号</th>\
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
	        	    $("#teacherLogOfTime").html(con);
	        	    $("#teacherLogOfTime").show();
	         },
	         error: function (data) {
	             alert("暂时无法获取");
	         },
	     });
		}else{
			layui.use('layer', function(){
	               var $ = layui.jquery, layer = layui.layer; 
			      layer.open({
			        type: 1
			        ,offset: 'auto'
			        ,id: 'layerDemo'+'auto'
			        ,title: '提示'
			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "至少输入一个条件" +'</div>'
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
	//同意学生请假
function agreeLeave() {
	 $.ajax({
         type: "GET",
         data: {
        	 "leaveRecordId":$('#leaveRecordId').val(),
           	 "teacherMobile":$('#teacherMobile').val(),
    	     "studentRoNo": $('#MstudentRoNo').val(),
    	     "content": $('#refuseContent').val()
         },
         contentType: "application/json; charset=utf-8",
         async: false,
         //url不加空格！！！！！！！！！！！！！！！！！！！！！！！
         url: "<%=request.getContextPath()%>/teacher/agreeLeave.do",
		success : function(data) {
			if(data.result == true){
				layui.use('layer', function(){
	 	               var $ = layui.jquery, layer = layui.layer; 
	   			      layer.open({
	   			        type: 1
	   			        ,offset: 'auto'
	   			        ,id: 'layerDemo'+'auto'
	   			        ,title: '成功'
	   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "处理成功！" +'</div>'
	   			        ,btn: '关闭'
	   			        ,btnAlign: 'c'
	   			        ,skin: 'demo-class'
	   			        ,shade: 0 
	   			        ,yes: function(){
	   			        	setTimeout('dontCare()',1500);
	   			        	 layer.closeAll();
	   			        }
	   			      });
	 	            });
				
			}else{
				layui.use('layer', function(){
	 	               var $ = layui.jquery, layer = layui.layer; 
	   			      layer.open({
	   			        type: 1
	   			        ,offset: 'auto'
	   			        ,id: 'layerDemo'+'auto'
	   			        ,title: '提示'
	   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "您已经处理过" +'</div>'
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
		error : function(data) {
			alert("服务器异常");
		},
		dataType : "json",
	});
	}
//驳回学生请假请求
function cantLeave() {
	$.ajax({
        type: "GET",
        data: {
         "leaveRecordId":$('#leaveRecordId').val(),
         "teacherMobile":$('#teacherMobile').val(),
	     "studentRoNo": $('#MstudentRoNo').val()
        },
        contentType: "application/json; charset=utf-8",
        async: false,
        url: "<%=request.getContextPath()%>/teacher/confirmCantLeaveExist.do",
		success : function(data) {
			if(data.result == true){
				$('#handleMessageShow').show();
				setTimeout('dontCare()',1500);
			}else{
				layui.use('layer', function(){
	 	               var $ = layui.jquery, layer = layui.layer; 
	   			      layer.open({
	   			        type: 1
	   			        ,offset: 'auto'
	   			        ,id: 'layerDemo'+'auto'
	   			        ,title: '提示'
	   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "您已经处理过" +'</div>'
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
		error : function(data) {
			alert("服务器异常");
		},
		dataType : "json",
	});
}
//首页
function checkCourseShow2() {
	window.location.reload();
}
</script>
</head>
<body>
	<!-- 课程二维码 -->
	<img id="target"
		style="width: 390px; height: 390px; display: none; z-index: 9; background-color: rgba(0, 0, 0, 1);"
		src="" />

	<!-- 新建课程成功提示信息 -->
	<div id="addCourseShow"
		style="background-color: #393D49; height: 20%; width: 20%; z-index: 20; position: fixed; margin-top: 23%; text-align: center; margin-left: 50%; display: none;">
		<h3 style="color: white; margin-top: 19%">添加课程成功..</h3>
	</div>

	<!-- 修改课程成功提示信息 -->
	<div id="changeCourseSuccess"
		style="background-color: #393D49; height: 27%; width: 25%; z-index: 20; position: fixed; margin-top: 23%; text-align: center; margin-left: 50%; display: none;">
		<h3 style="color: white; margin-top: 15%">修改课程成功..</h3>
	</div>


	<!-- 处理消息成功提示信息 -->
	<div id="handleMessageShow"
		style="background-color: #393D49; height: 20%; width: 20%; z-index: 20; position: fixed; margin-top: 20%; text-align: center; margin-left: 30%; display: none;">
		<h3 style="color: white; margin-top: 19%">处理成功..</h3>
	</div>

	<div class="layui-layout layui-layout-admin">
		<!-- 头部导航 -->
		<div class="layui-header header header-demo">
			<div class="layui-main">
				<a class="CMSlogo" href="#" onclick="checkCourseShow2()"><span
					style="color: white; font-size: 25px;">CMS</span></a>

				<ul class="layui-nav">
					<li class="layui-nav-item"><a id="checkCourseShow2" onclick="checkCourseShow2()" href="#">
							<i class="layui-icon bbbbb"
							style="font-size: 20px; color: #d2d2d2">&#xe68e;</i>
					</a></li>
					<li class="layui-nav-item"><a id="messageButtton" href="#">
							<i class="layui-icon bbbbb"
							style="font-size: 20px; color: #d2d2d2">&#xe63a;</i>
							<span id="TmessageCount" class="layui-badge" style="display: none;">${messageCount}</span>
					</a></li>
					<li class="layui-nav-item"><a id="teacherInfoCenter" href="#">
							<i class="layui-icon bbbbb"
							style="font-size: 20px; color: #d2d2d2">&#xe612;</i><span
							id="redSignal" style="display: none;" class="layui-badge-dot"></span>
					</a></li>
					<li class="layui-nav-item"><a href="#">${teacher.teacherName}老师</a>
						<ul class="layui-nav-child">
							<li>
								<a id="changeTeacherInfoh" href="#">修改信息</a>
							</li>
							<li>
								<a href="#" id="safeManage">安全管理</a>
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
		<script type="text/javascript">
		layui.use([ 'form', 'laydate' ], function() {
			var form = layui.form, laydate = layui.laydate;
		});
		</script>
		<!-- 左侧垂直导航 -->
		<div class="layui-side layui-bg-black">
			<div class="layui-side-scroll">
				<ul class="layui-nav layui-nav-tree" lay-filter="test">
					<!-- 侧边导航: <ul class="layui-nav layui-nav-tree layui-nav-side"> -->
					<li class="layui-nav-item layui-nav-itemed"><a
						href="javascript:;">课程相关</a>
						<dl class="layui-nav-child">
							<dd>
								<a id="checkCourseShow" href="#">课程信息</a>
							</dd>
							<dd>
								<a id="createCourse" href="#">新建课程</a>
							</dd>
							<!-- <dd>
								<a href="">跳转</a>
							</dd> -->
						</dl></li>
					<li class="layui-nav-item layui-nav-itemed"><a href="#">查看资料</a>
						<dl class="layui-nav-child">
							<dd>
								<a id="lookatData" href="#">资料仓库</a>
							</dd>
						<!-- 	<dd>
								<a id="dataUpload" onclick="getPrivateData()" href="#">课件上传</a>
							</dd> -->
							<!-- <dd>
								<a href="#">待定</a>
							</dd> -->
						</dl></li>
					<li class="layui-nav-item"><a href="#" onclick="toPersonBlog()">个人博客</a></li>
					<li class="layui-nav-item"><a id="teacherLog" href="#">操作日志</a></li>
				</ul>
			</div>
		</div>

		<!-- 内容显示 -->
		<div class="layui-body site-demo"
			style="padding-top: 3%; overflow: auto;">
			<br /> <span id="messageList" style="margin-left: 5%;">课程信息</span>
			<hr class="layui-bg-cyan" style="width: 100%;">
			
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
			<!-- 查看资料，搜寻各种格式的，自己的，或者他人 -->
			<div id="lookData" class="site-text site-block" style="padding-top: 5px;margin-top: 0;display: none;padding-left: 0;padding-right: 0">
				<form class="layui-form" action="">
					<div class="layui-form-item" style="width: 100%; margin-left: 1%;">
						 <div class="layui-form-item" style="height: 100%; width: 35%; float: left;">
						    <label class="layui-form-label">类型</label>
						    <div class="layui-input-block" style="width: 150px;">
						      <select id="dataType" name="dataType" lay-verify="required" style="width: 100%;">
						        <option value=""></option>
						        <option value="课件">课件</option>
						        <option value="博客">博客</option>
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
				
			    <table id="teacherGetFileList" class="layui-table" lay-even style="width: 100%; display: none; margin-left: 0;margin-right: 0; padding-left: 0;padding-right: 0;">
					<colgroup>
						<col width="250">
						<col width="300">
						<col width="440">
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
			
			<table id="teacherGetBlogList" class="layui-table" style="width: 100%; display: none;">
					 <colgroup>
						<col width="150">
						<col width="200">
						<col width="200">
						<col width="200">
						<col width="200">
						<col width="130">
					</colgroup>
					<thead>
						<tr>
							<th style="text-align: center;"></th>
							<th style="text-align: center;">类别</th>
							<th style="text-align: center;">标题</th>
							<th style="text-align: center;">标签</th>
							<th style="text-align: center;">创建时间</th>
							<th style="text-align: center;">点击</th>
						</tr>
					</thead>
					 <tbody id="blogThreafd">
		                
					 </tbody>
					</table>
			
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
					//点击查询
					function searchData() {
						if($('#dataType').val() != "" && $('#dataContent').val() != ""){
							if($('#dataType').val() == '课件'){
								$.ajax({
							        type: "GET",
							        data: {
							        	"fileName" :$('#dataContent').val()
							        },
							        contentType: "application/json; charset=utf-8",
							        async: false,
							        url: "<%=request.getContextPath()%>/teacher/teacherGetFile.do",
									success : function(data) {
										if(data.result == true){
											var dataObj = data.filePackages;
											 con = "";
											 $.each(dataObj, function (index, item) {
												con += "<tr>";
								       	        con += "<td style='text-align:center;'>" + item.fileType + "</td>";
								       	        con += "<td style='text-align:center;'>" + item.createTime + "</td>";
								       	        con += "<td style='text-align:center; color:#FF5722;'><a  target='_blank' style='color:#FF5722;' href=\'<%=request.getContextPath() %>/file/"+item.fileName+"\'>" + item.fileName + "</a></td>";
								       	        con += "<tr/>";
							      
								       	    });
											 $('#privateData').html(con);
											 $('#teacherGetFileList').show();
											 $('#teacherGetBlogList').hide();
										}else {
											layui.use('layer', function(){ //独立版的layer无需执行这一句
									               var $ = layui.jquery, layer = layui.layer; 
						            			      layer.open({
						            			        type: 1
						            			        ,offset: 'auto' //具体配置参考：http://www.layui.com/doc/modules/layer.html#offset
						            			        ,id: 'layerDemo'+'auto' //防止重复弹出
						            			        ,title: '失败'
						            			        ,content: '<div style="padding: 20px 100px;">'+"请求资源未找到"+'</div>'
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
							}else if ($('#dataType').val() == '博客') {
								 $.ajax({
						              type: "GET",
						              data: {
						            	  "fileName" :$('#dataContent').val()
						              },
						              contentType: "application/json; charset=utf-8",
						              async: false,
						              dataType: "json",
						              url: "<%=request.getContextPath()%>/blog/teacherSearchBlog.do",
						              success: function (data) {
						            	 var dataObj = data.myBlogs;
										 con = "";
										 $.each(dataObj, function (index, item) {
											    con += "<tr id='TD"+item.blogId+"'>";
							        	        con += "<td style='text-align:center;'>" + index + "</td>";
							        	        con += "<td style='text-align:center;'>" + item.belongTo + "</td>";
							        	        con += "<td style='text-align:center;'><a style='color:#FF5722;' id='"+item.blogId+"' target='_blank' href='<%=request.getContextPath()%>/blog/getBlogTemValue.do?userId=${teacher.teacherMobile}&role=teacher&blogId="+item.blogId+"'>" + item.blogTitle + "</a></td>";
							        	        con += "<td style='text-align:center;'>" + item.up + "</td>";
							        	        con += "<td style='text-align:center;'>" + item.down + "</td>";
							        	        con += "<td style='text-align:center;'>" + item.hotClick + "</td>";
							        	        con += "<tr/>";
							        	    });
										 $('#blogThreafd').html(con);
										 $('#teacherGetFileList').hide();
										 $('#teacherGetBlogList').show();
						              },
						              error: function (data) {
						            	  alert("服务器异常");
						              }
						          });
							}
						}else {
							
						}
						
					}
			</script>
			
			<!-- 教师博客 -->
			<form id="PersonBlogForm" action="<%=request.getContextPath()%>/teacher/toPersonBlog.do" method="post" style="display: none;">
			  <input type="text" name="userId" value="${teacher.teacherMobile}"/>
			  <input type="text" name="userPassWord" value="${teacher.teacherPassword}"/>
			  <input type="text" name="userRole" value="teacher"/>
			</form>

			<!-- 教师操作日志表 -->
			<div id="forTeacherLogInfo" class="site-text site-block"
				style=" height: 3em; margin-top: 0.1%; display: none;">
				<form class="layui-form" action="">
					<div class="layui-form-item" style="width: 100%; margin-left: 1%;">
						<div style="height: 100%; float: left;">
							<label class="layui-form-label" style="">输入日期</label>
							<div class="layui-input-block" style="">
								<input id="logDate" type="text" lay-verify="logDate"
									placeholder="yyyy-MM-dd" autocomplete="on" class="layui-input"
									style="width: 80%; float: left;">
							</div>
						</div>
						<div style="height: 100%; width: 49%; float: left;">
							<label class="layui-form-label" style="">输入关键字</label>
							<div class="layui-input-block" style="">
								<input id="CoreKey" type="text" lay-verify="CoreKey"
									placeholder="如  '登录'" autocomplete="off" class="layui-input"
									style="width: 40%; float: left;"> <input
									class="layui-btn" lay-submit type="button"
									onclick="searchTeacherLogByTime()" value="查询"
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

			<table id="teacherLogOfTime" border="1"
				style="display: none; text-align: center; width: 80%; margin-left: 9.5%;">
			</table>

			<table id="teacherLogInfo" border="1"
				style="text-align: center; width: 80%; margin-left: 9.5%; display: none;">
				<tr>
					<th>账号</th>
					<th>活动</th>
					<th>Ip</th>
					<th>时间</th>
					<th>结果</th>
				</tr>
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
			</table>

			<!-- 个人中心 -->
			<div id="teacherInfoShow"
				style="background-color: white; margin-left: 13%; margin-right: 20%; width: 100%; padding-left: 5%; padding-bottom: 500px; display: none;">

				<!-- 更新信息成功显示的Div -->
				<div id="updateTeacherInfoSuccess" class="site-text site-block"
					style="background-color: #393D49; height: 20%; width: 20%; display: none; z-index: 20; margin-top: 14%; text-align: center; margin-left: 15%; position: absolute;">
					<h3 style="color: white; margin-top: 19%">更新信息成功..</h3>
				</div>

				<table style="float: left; width: 40%; text-align: center;"
					class="layui-form layui-form-pane">
					<tr>
						<td class="layui-form-label">账号</td>
						<td style="text-align: left;">${teacher.teacherMobile}</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td class="layui-form-label">姓名</td>
						<td style="text-align: left;">${teacher.teacherName}</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td class="layui-form-label">性别</td>
						<td style="text-align: left;">${teacher.teacherGender}</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td class="layui-form-label">邮箱</td>
						<td style="text-align: left;">${teacher.teacherEmail}</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td class="layui-form-label">学科</td>
						<td style="text-align: left;">${teacher.teacherSubject}</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
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
					style="width: 50%; heigh: 120px; float: left;">
					<p id="demoText"></p>
					<table style="margin-left: -50px; width: 70%"
						class="layui-form layui-form-pane">

						<tr id="collegeTr" style="">
							<td class="layui-form-label">学院</td>
							<td style="text-align: left;">${teacher.college}</td>
						</tr>

						<tr id="reCollegeTr" style="display: none;">
							<td class="layui-form-label">学院</td>
							<td style="text-align: left;"><input required
								style="width: 60%;" class="layui-input" type="text"
								value="${teacher.college}" id="college" name="college" /></td>
						</tr>

						<tr id="forSpecial" style="">
							<td>&nbsp;</td>
						</tr>

						<tr id="specialTr" style="">
							<td class="layui-form-label">研究方向</td>
							<td style="text-align: left;">${teacher.special}</td>
						</tr>
						<tr id="reSpecialTr" style="display: none;">
							<td class="layui-form-label">研究方向</td>
							<td style="text-align: left;"><input required
								style="width: 60%;" class="layui-input" type="text"
								value="${teacher.special}" id="special" name="special" /></td>
						</tr>
						<tr id="forschoolRecord" style="">
							<td>&nbsp;</td>
						</tr>

						<tr id="schoolRecordTr" style="text-align: left;">
							<td class="layui-form-label" style="text-align: left;">当前学历</td>
							<td style="text-align: left; width: 47%;">${teacher.schoolRecord}</td>
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
							<td style="text-align: left; width: 47%;">${teacher.birthDay}</td>
						</tr>
						<tr id="reBirthDayTr" style="display: none;">
							<td class="layui-form-label" style="text-align: left;">出生日期</td>
							<td style="text-align: left; width: 47%;"><input required
								style="width: 60%;" class="layui-input" type="text"
								value="${teacher.birthDay}" id="birthDay" name="birthDay" /></td>
						</tr>

						<tr id="forFreeStyle" style="">
							<td>&nbsp;</td>
						</tr>

						<tr id="freeStyleTr" style="">
							<td class="layui-form-label" style="text-align: left;">备注信息</td>
							<td style="text-align: left;">${teacher.freeStyle}</td>
						</tr>
						<tr id="reFreeStyleTr" style="display: none;">
							<td class="layui-form-label" style="text-align: left;">备注信息</td>
							<td style="text-align: left; width: 47%;"><input
								style="width: 60%;" class="layui-input" type="text"
								value="${teacher.freeStyle}" id="freeStyle" name="freeStyle" /></td>
						</tr>
					</table>
				</div>

			</div>
			<script>
					//Demo
					layui.use([ 'form', 'laydate' ], function() {
						var form = layui.form, laydate = layui.laydate;
						form.render(); 
						laydate.render({
							elem : '#birthDay'
						});

					});
					layui.use('form', function() {
						var form = layui.form;
					form.verify({
						requirevalidate: [/\S/,'必填项不可为空']
					});
					});
				</script>

	<!-- 显示消息 -->
	<div class="layui-tab" id="messageShow" style="margin-left: 5%; margin-right: 5%; display: none;">
	  <ul class="layui-tab-title">
	    <li class="layui-this">收件箱</li>
	    <li onclick="tableRender()">发件箱</li>
	  </ul>
	  <div class="layui-tab-content">
	  <div class="layui-tab-item layui-show">
	      <div>
				<table id="theOne" class="layui-table" lay-skin="line"
					lay-data="{page:true,height:485,width:1070, url:'<%=request.getContextPath() %>/student/getSeperratePage.do',
			 id:'test1', where:{messageAcpter:'${teacher.teacherMobile}'}, limit:10}"
					lay-filter="test1">
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
			 id:'test2', where:{messageSender:'${teacher.teacherMobile}'}, limit:1000}"
					lay-filter="test1">
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
 
		<script>
		//注意：选项卡 依赖 element 模块，否则无法进行功能性操作
		layui.use('element', function(){
		  var element = layui.element();
		  var table = layui.table;
	        table.render();
		});
		</script>
			
			<script type="text/html" id="titleTpl">
        <a href="#" class="layui-table-link">{{d.messageTitle}}</a>
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
            
			<script type="text/html" id="barDemo">
               <a class="layui-btn layui-btn-primary layui-btn-mini" lay-event="detail">查看</a>
                <a class="layui-btn layui-btn-danger layui-btn-mini" lay-event="del">删除</a>
           </script>
           
           <script type="text/html" id="barDemo2">
               <a class="layui-btn layui-btn-primary layui-btn-mini" lay-event="detail2">查看</a>
           </script>
          
			<script>
			function tableRender() {
				layui.use('table', function(){
			        var table = layui.table;
			        table.reload('test2', {});
			        table.render();
				});
			   }
        layui.use('table', function(){
        var table = layui.table;
        table.render();
        //监听工具条
        table.on('tool(test1)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
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
        } else if(layEvent === 'detail2'){ //查看
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
             url: "<%=request.getContextPath()%>/teacher/deleteMessage.do",
			success : function(data) {
				if(data.result == true){
					 obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
			            layer.close(index);
				}else{
					layui.use('layer', function(){
		 	               var $ = layui.jquery, layer = layui.layer; 
		   			      layer.open({
		   			        type: 1
		   			        ,offset: 'auto'
		   			        ,id: 'layerDemo'+'auto'
		   			        ,title: '失败'
		   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "删除失败" +'</div>'
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
				style="width: 100%; padding-left: 25%; display: none;">
				<h3 id="messageTitle"></h3>
				<hr />
				<br /> <br /> <span id="messageSnder"></span><br /> <br /> <br />
				<br /> <span id="messageSenderName" style="display: none;"></span>
				<span id="sendTime"></span><br /> <br /> <br /> <br /> <span
					id="forMessageContent">内容<br /></span>
				<textarea id="messageContent" rows="5" cols="40" readonly="readonly">
				
				</textarea>
				<br /> <br />
				<div id="insertCourseDiv" style="display: none;">
					<input type="text" id="MstudentRoNo" style="display: none;" /> <input
						type="text" id="MCourseId" style="display: none;" /> <input
						id="leaveRecordId" style="display: none;"> <input
						id="agree" class="layui-btn" onclick="agree()" type="button"
						value="同意" /> <input style="margin-left: 10%;" id="dontCare"
						onclick="dontCare()" class="layui-btn layui-btn-primary"
						type="button" value="忽略" />
				</div>
				<div id="studentAskLeaveDiv" style="display: none;">
					<input id="ImAgreeLeave" class="layui-btn" onclick="agreeLeave()"
						type="button" value="批准" /> 
						<input style="margin-left: 10%;"
						id="cantLeave" onclick="cantLeave()"
						class="layui-btn layui-btn-primary" type="button" value="驳回" />
				</div>
			</div>

			<!-- 新建课程 -->
			<div class="site-text site-block" id="courseShow"
				style="display: none; margin-top: 0;">
				<form class="layui-form" action="">
					<div class="layui-form-item">
						<label class="layui-form-label">课程名称</label>
						<div class="layui-input-block">
							<input id="courseName" type="text" name="courseName" required
								lay-verify="required" placeholder="请输入课程名称" autocomplete="off"
								class="layui-input">
						</div>
					</div>
					<input type="text" id="teacherMobile" name="teacher.teacherMobile"
						value="${teacher.teacherMobile}" style="display: none;" />
					<div class="layui-form-item">
						<label class="layui-form-label">课程类型</label>
						<div class="layui-input-block">
							<input type="radio" name="courseType" 
							value="必修" style="color: #FF5722" title="必修" checked> 
							<input type="radio" name="courseType" 
							value="选修" style="color: #FF5722" title="选修">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">班级容量</label>
						<div class="layui-input-block">
							<input id="classCapacity" type="text" name="classCapacity"
								lay-verify="required|number" placeholder="请输入班级容量"
								autocomplete="off" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label">开始时间</label>
							<div class="layui-input-inline">
								<input class="layui-input" id="startTime" lay-verify="required"
									type="text" name="startTime" placeholder="yyyy-MM-dd">
							</div>
						</div>
					</div>
					<div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label">结束时间</label>
							<div class="layui-input-inline">
								<input class="layui-input" id="endTime" lay-verify="required"
									type="text" name="endTime" placeholder="yyyy-MM-dd">
							</div>
						</div>
					</div>
					<div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label">当前学年</label>
							<div class="layui-input-inline">
								<input class="layui-input" lay-verify="required"
									id="currentYear" type="text" name="currentYear"
									placeholder="yyyy">
							</div>
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">当前学期</label>
						<div class="layui-input-block">
							<select id="schoolTem" name="schoolTem" lay-verify="required">
								<option value="春季学期">春季学期</option>
								<option value="夏季学期">夏季学期</option>
								<option value="秋季学期" selected>秋季学期</option>
								<option value="冬季学期">冬季学期</option>
							</select>
						</div>
					</div>
					<div class="layui-form-item">
						<div class="layui-input-block">
							<input id="subButton" class="layui-btn" onclick="addCourse()"
								style="margin-left: 5%;" type="button" value="提交" lay-submit />
							<button type="reset" style="margin-left: 5%;"
								class="layui-btn layui-btn-primary">重置</button>
						</div>
					</div>
				</form>

				<script>
					//Demo
					layui.use([ 'form', 'laydate' ], function() {
						var form = layui.form, laydate = layui.laydate;
						form.render(); 
						//监听提交
						form.on('submit(demo())', function(data) {
							return false;
						});
						laydate.render({
							elem : '#startTime'
						});
						laydate.render({
							elem : '#endTime'
						});
						laydate.render({
							elem : '#currentYear',
							type : 'year'
						});

					});

					
				</script>
			</div>

			<!-- 课程信息 -->
			<div class="layui-form sessiontable" id="courseInfo" style="">
				<table class="layui-table"  lay-even style="text-align: center;">
					<colgroup>
						<col width="160">
						<col width="170">
						<col width="130">
						<col width="150">
						<col width="140">
						<col width="200">
						<col width="180">
						<col width="150">
						<col width="150">
					</colgroup>
					<thead>
						<tr>
							<th style="text-align: center;">课程编码</th>
							<th style="text-align: center;">名称</th>
							<th style="text-align: center;">二维码</th>
							<th style="text-align: center;">学年</th>
							<th style="text-align: center;">限制人数</th>
							<th style="text-align: center;">班级</th>
							<th style="text-align: center;">事务</th>
							<th colspan="2" style="text-align: center;">操作</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${! empty courses}">
								<c:forEach items="${courses}" var="r">
									<tr id="abs${r.courseId}">
										<td>${r.courseId}</td>
										<td>${r.courseName}</td>
										<td style="text-align: center;">
											<div class="site-demo-button" id="layerDemo">
												<button id="${r.qrImg}" onclick="showQrImg(this.id)"
													class="layui-btn" data-method="page">获取</button>
											</div>
										</td>
										<td style="text-align: center;">${r.currentYear}</td>
										<td style="text-align: center;">${r.classCapacity}</td>
										<td style="text-align: center;"><c:choose>
												<c:when test="${! empty r.clazz}">
													<c:forEach items="${r.clazz}" var="c">
														<form style="margin-top: 0; margin-bottom: 0;"
															id="asd${c.clazzId}"
															action="<%=request.getContextPath()%>/student/selectStudentByClazzId.do"
															method="post">
															<input name="clazzId" style="display: none;"
																value="${c.clazzId}" /> <a class="aSign"
																id="${c.clazzId}" onclick="" href="#">${c.clazzName}</a>
														</form>
														<br />
													</c:forEach>
												</c:when>
												<c:otherwise>
													<a style="color: red;">（空）</a>
												</c:otherwise>
											</c:choose></td>
										<td style="text-align: center;"><a class="aSign"
											href="<%=request.getContextPath()%>/course/forsearchClazz.do?courseId=${r.courseId}&teacherMobile=${teacher.teacherMobile}">查看/签到&nbsp;<i class="layui-icon" style="font-size: 15px; color: #FF5722;">&#xe62a;</i>  </a></td>
										<td>
											<!-- <a href="/course/forChangeCousrInfo.do?courseId=${r.courseId}">修改</a> -->
											<div class="site-demo-button" id="layerDemo"
												style="margin-bottom: 0;">
												<button id="change${r.courseId}"
													onclick="beforeChangeCourse('${r.courseId}','${r.courseName}','${r.classCapacity}')"
													class="layui-btn">修改</button>
											</div>
										</td>
										<td>
											<div class="site-demo-button" id="layerDemo"
												style="margin-bottom: 0;">
												<button id="${r.courseId}" onclick="forDeleteThis(this.id)"
													class="layui-btn" data-method="notice">删除</button>
											</div>
										</td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="9">（空）</td>
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
			</div>

			<!-- 修改课程信息 -->
			<div class="site-text site-block" id="changeCourseinfo"
				style="display: none;">
				<form class="layui-form" action="">
					<input type="text" name="ccourseId" id="ccourseId" value=""
						readonly="readonly" style="display: none;" /><br />
					<div class="layui-form-item">
						<label class="layui-form-label">课程名称</label>
						<div class="layui-input-block">
							<input id="ccourseName" type="text" name="ccourseName" required
								lay-verify="required" placeholder="请输入课程名称" autocomplete="off"
								class="layui-input">
						</div>
						<br />
						<p id="listenName"
							style="color: red; display: none; margin-left: 13%;">*课程名不可为空*</p>
					</div>
					<input type="text" id="cteacherMobile"
						name="cteacher.teacherMobile" value="${teacher.teacherMobile}"
						style="display: none;" />
					<div class="layui-form-item">
						<label class="layui-form-label">课程类型</label>
						<div class="layui-input-block">
							<input id="ccourseType" type="radio" name="ccourseType"
								value="必修" title="必修" checked> <input id="ccourseType"
								type="radio" name="ccourseType" value="选修" title="选修">
						</div>
						<p id="listenType"
							style="color: red; display: none; margin-left: 13%;">*课程类型不可为空*</p>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">班级容量</label>
						<div class="layui-input-block">
							<input id="cclassCapacity" type="text" name="cclassCapacity"
								required lay-verify="required" placeholder="请输入班级容量"
								autocomplete="off" class="layui-input">
						</div>
						<p id="listenCapacity"
							style="color: red; display: none; margin-left: 13%;">*班级容量不可为空*</p>
						<p id="listenIfN"
							style="color: red; display: none; margin-left: 13%;">*请输入数字*</p>
					</div>
					<div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label">开始时间</label>
							<div class="layui-input-inline">
								<input class="layui-input" id="cstartTime" type="text"
									name="cstartTime" placeholder="yyyy-MM-dd">
							</div>
							<p id="listenStart"
								style="color: red; display: none; margin-left: 13%;">*开始时间不可为空*</p>
						</div>
					</div>
					<div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label">结束时间</label>
							<div class="layui-input-inline">
								<input class="layui-input" id="cendTime" type="text"
									name="cendTime" placeholder="yyyy-MM-dd">
							</div>
							<p id="listenEnd"
								style="color: red; display: none; margin-left: 13%;">*结束时间不可为空*</p>
							<p id="listenMaxOrMin"
								style="color: red; display: none; margin-left: 13%;">*结束时间不可小于开始时间*</p>
						</div>
					</div>
					<div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label">当前学年</label>
							<div class="layui-input-inline">
								<input class="layui-input" id="ccurrentYear" type="text"
									name="ccurrentYear" placeholder="yyyy">
							</div>
							<p id="listenCurrent"
								style="color: red; display: none; margin-left: 13%;">*当前学年不可为空*</p>
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">当前学期</label>
						<div class="layui-input-block">
							<select id="cschoolTem" name="cschoolTem" lay-verify="required">
								<option value=""></option>
								<option value="春季">春季学期</option>
								<option value="夏季">夏季学期</option>
								<option value="秋季">秋季学期</option>
								<option value="冬季">冬季学期</option>
							</select>
						</div>
						<p id="listenTem"
							style="color: red; display: none; margin-left: 13%;">*当前学期不可为空*</p>
					</div>
					<div class="layui-form-item">
						<div class="layui-input-block">
							<input id="subButton" class="layui-btn"
								onclick="changeCourseInfo()" type="button" value="提交修改" />
							<button type="reset" class="layui-btn layui-btn-primary">重置</button>
						</div>
					</div>
				</form>
				<script>
					//Demo
					layui.use([ 'form', 'laydate' ], function() {
						var form = layui.form, laydate = layui.laydate;
						form.render(); 
						//监听提交
						form.on('submit(formDemo)', function(data) {
							layer.msg(JSON.stringify(data.field));
							return false;
						});
						laydate.render({
							elem : '#startTime',
							elem : '#cstartTime'
						});
						laydate.render({
							elem : '#endTime',
							elem : '#cendTime'
						});
						laydate.render({
							elem : '#currentYear',
							type : 'year'
						});
						laydate.render({
							elem : '#ccurrentYear',
							type : 'year'
						});

					});
				</script>
			</div>

			<!-- 安全/密码 -->
			<div id="signal"
				style="width: 95%; margin-left: 5%; padding-left: 5%; background-color: #cccc00; height: 3%; display: none; font-family: 微软雅黑;">
				提示：修改邮箱后后请前往原邮箱确认..</div>

			<!-- 更改邮箱成功提示信息 -->
			<div id="changeMailShow" class="site-text site-block"
				style="background-color: #393D49; height: 23%; width: 20%; display: none; z-index: 20; margin-top: 14%; text-align: center; margin-left: 25%; position: absolute;">
				<h3 style="color: white; margin-top: 19%">更新邮箱成功..</h3>
			</div>

			<div class="site-text site-block" id="doubleHandle"
				style="width: 70%; margin-left: 15%; margin-top: 1%; display: none;">
				<a class="layui-btn layui-btn-primary" href="#" id="changeTeaPass"
					style="float: left; height: 20%; width: 49%; font-size: 1.5em">更改密码</a>
				<a class="layui-btn layui-btn-primary" href="#" id="changeTeaMail"
					style="float: left; height: 20%; width: 49%; font-size: 1.5em">更换邮箱</a>
				<br /> <br />
				<!-- 修改密码 -->
				<form class="layui-form layui-form-pane" id="safe"
					action="<%=request.getContextPath()%>/teacher/updateTeacherPassWord.do"
					style="width: 84%; margin-left: 5%; padding-left: 17%">
					<table>
						<br />
						<tr style="width: 100%;">
							<td><label class="layui-form-label">手机号</label></td>
							<td><input class="layui-input" type="text"
								readonly="readonly" name="teacherMobile"
								value="${teacher.teacherMobile}" id="teacherMobile2"
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
								name="oldPassword" id="teacherPassword" style="width: 25em" /></td>
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
								name="teacherPassword" id="newPassword" style="width: 25em" /></td>
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
				<form id="emailsafe"
					action="<%=request.getContextPath()%>/teacher/updateTeacherEmail.do"
					style="width: 84%; margin-left: 5%; padding-left: 17%; display: none;">
					<table>
						<br />
						<tr style="width: 100%;">
							<td><label class="layui-form-label">手机号</label></td>
							<td><input class="layui-input" type="text"
								readonly="readonly" name="teacherMobile"
								value="${teacher.teacherMobile}" id="teacherMobile3"
								style="width: 25em;" /></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><label class="layui-form-label">邮箱</label></td>
							<td><input class="layui-input" type="text" name="oldEmail"
								value="${teacher.teacherEmail}" id="teacherEmail"
								style="width: 25em" readonly="readonly" /></td>
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
								name="teacherEmail" required lay-verify="required|email"
								autocomplete="off" style="width: 25em" /></td>
						</tr>

						<tr>
							<td id="emailTypeError"
								style="text-align: right; width: 20em; color: red; display: none;">*格式错误*</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td colspan="2"><input class="layui-btn"
								id="changeTeaMailPush" type="button" value="申请修改"
								style="width: 70%; margin-left: 15%;" /></td>
						</tr>
					</table>
				</form>
			</div>


		</div>

	</div>



	<script>
	//修改密码
	$('#changeTeaPass').click(function asd() {
		$('#emailsafe').hide();
		$('#safe').show();
	});
	//修改邮箱
    $('#changeTeaMail').click(function asd() {
    	$('#safe').hide();
		$('#emailsafe').show();
	});
	//提交更改邮箱申请
	 $('#changeTeaMailPush').click(function asd() {
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
					        ,content: '<div style="padding: 20px 100px; color:#FF5722;">'+ "邮箱重置成功~" +'</div>'
					        ,btn: '关闭'
					        ,btnAlign: 'c' 
					        ,shade: 0 
					        ,yes: function(){
					        	yourFunction();
					        }
					      });
		           });
    		 }
    	}
	});
	function pushEmail() {
		 //ajax后台更新
		 var result = false;
		 var teacherEmail = $('#mail').val();
		 var teacherMobile  =$('#teacherMobile').val();
		$.ajax({
              type: "GET",
              data: {
            	  "teacherEmail":teacherEmail,
            	  "teacherMobile":teacherMobile
              },
              contentType: "application/json; charset=utf-8",
              async: false,
              dataType: "json",
              url: "<%=request.getContextPath()%>/teacher/changeTeaMail.do",
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
	 //修改课程信息 前
	 function beforeChangeCourse(courseId,courseName,classCapacity) {
		 document.getElementById("ccourseId").value = courseId;
		 document.getElementById("ccourseName").value = courseName;
		 document.getElementById("cclassCapacity").value = classCapacity;
		 $('#doubleHandle').hide();
		 $('#signal').hide();
		 $('#courseShow').hide();
		 $('#courseInfo').hide();
		 $('#changeCourseinfo').show();
	}
	 //修改课程信息
	 function changeCourseInfo() {
		if(confirmType()){
			if(pushCourseInfo()){
				$('#changeCourseSuccess').show();
				setTimeout('yourFunction()',2000); 
			}
		}
		
	}
	//刷新当前页面
		function yourFunction() {
		 window.location.reload();
	}
	 
	 //课程信息提交到后台
	 function pushCourseInfo() {
		 var result = false;
		 var teacherMobile = $('#cteacherMobile').val();
		 var courseId = $('#ccourseId').val();
		 var courseName = $('#ccourseName').val();
		 var courseType = $('#ccourseType').val();
		 var classCapacity = $('#cclassCapacity').val();
		 var startTime = $('#cstartTime').val();
		 var endTime = $('#cendTime').val();
		 var currentYear = $('#ccurrentYear').val();
		 var schoolTem = $('#cschoolTem').val();
		$.ajax({
              type: "GET",
              data: {
            	  "teacherMobile":teacherMobile,
                  "courseId": courseId,
                  "courseName":courseName,
                  "courseType":courseType,
                  "classCapacity":classCapacity,
                  "startTime":startTime,
                  "endTime":endTime,
                  "currentYear":currentYear,
                  "schoolTem":schoolTem
              },
              contentType: "application/json; charset=utf-8",
              async: false,
              dataType: "json",
              url: "<%=request.getContextPath()%>/course/changeCourse.do",
              success: function (data) {
            	  if(data.result == true){
            		  result = true;
            	  }else{
            		  $('#listenMaxOrMin').show();
            	  }
              },
              error: function (data) {
            	  alert("服务器异常");
              }
          });
		  return result;
	}
	//点击安全管理
	$('#safeManage').click(function name1() {
		$('#messageList').html("安全管理");
		 $('#courseInfo').hide();
		 $('#courseShow').hide();
		 $('#messageShow').hide();
		 $('#fushuMessage').hide();
		 $('#seprateMessage').hide();
		 $('#forTeacherLogInfo').hide();
		 $('#teacherInfoShow').hide();
		 $("#teacherLogOfTime").hide();
		 $('#upLoadShow').hide();
		$('#doubleHandle').show();
		$('#signal').show();
	});
	//点击申请修改触发密码验证
	$('#ccchangePass').click(function wannaSubmittt() {
		var password = $('#teacherPassword').val();
		var teacherMobile = $('#teacherMobile').val();
		var newPassword = $('#newPassword').val();
		var rePassword = $('#rePassword').val();
		if(getStuAnwser(password,teacherMobile)){
			$('#passError').hide();
			if(newPassword != null && newPassword != "" && newPassword == rePassword){
				$('#noLike').hide();
				changeTeaPass();					
			}else{
				$('#noLike').show();
			}
		}else {
			$('#passError').show();
		}
	});
	
	//获取教师密码，进行后台比对
	function getStuAnwser(password,teacherMobile) {
		var result = false;
		$.ajax({
              type: "GET",
              data: {
                  "password": password,
                  "teacherMobile":teacherMobile
              },
              contentType: "application/json; charset=utf-8",
              async: false,
              dataType: "json",
              url: "<%=request.getContextPath()%>/teacher/confirmTeacherPassWord.do",
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
	//ajax更改教师密码
	function changeTeaPass() {
		$('#safe').submit();
	}
	
	//url
	 function showQrImg(id) {
	     var url = "/ClassManageSys/qrImg/" + id + ".gif";
		     var imgPre = document.getElementById("target");
		     imgPre.src = url;
	}

	 var tem;
	 function forDeleteThis(courseId) {
		 var courseId = courseId;
		 tem = courseId;
	}
	 function deleteThis() {
		 var Id = tem;
		 lookApplyPeople(Id); 
	}
	 
	 //删除课程
	  function lookApplyPeople(courseId) {
          $.ajax({
              type: "GET",
              data: {
                  "courseId": courseId
              },
              contentType: "application/json; charset=utf-8",
              async: true,
              url: "<%=request.getContextPath()%>/course/deleteCourseById.do",
						//              beforeSend:function(){$("#href").html("等待..");},
						success : function(data) {
							document.getElementById("abs" + tem).style.display = "none";
						},
						error : function(data) {
							alert("出错了！");
						},
						dataType : "json",
					});
			$('#torf').hide();
		}
		//修改课程信息内容输入验证
		function confirmType() {
			var world = false;
			if ($('#ccourseName').val() != null
					&& $('#ccourseName').val() != "") {
				if ($('#ccourseType').val() != null
						&& $('#ccourseType').val() != "") {
					if ($('#cclassCapacity').val() != null
							&& $('#cclassCapacity').val() != "") {
						if (isNaN($('#cclassCapacity').val())) {
							$('#listenIfN').show();
						}
						if ($('#cstartTime').val() != null
								&& $('#cstartTime').val() != "") {
							if ($('#cendTime').val() != null
									&& $('#cendTime').val() != "") {
								if ($('#ccurrentYear').val() != null
										&& $('#ccurrentYear').val() != "") {
									if ($('#cschoolTem').val() != null
											&& $('#cschoolTem').val() != "") {
										//都不为空返回true
										world = true;
									} else {
										$('#listenName').hide();
										$('#listenType').hide();
										$('#listenCapacity').hide();
										$('#listenStart').hide();
										$('#listenEnd').hide();
										$('#listenCurrent').hide();
										$('#listenIfN').hide();
										$('#listenTem').show();
									}
								} else {
									$('#listenName').hide();
									$('#listenType').hide();
									$('#listenCapacity').hide();
									$('#listenEnd').hide();
									$('#listenStart').hide();
									$('#listenIfN').hide();
									$('#listenCurrent').show();
								}
							} else {
								$('#listenName').hide();
								$('#listenType').hide();
								$('#listenCapacity').hide();
								$('#listenStart').hide();
								$('#listenIfN').hide();
								$('#listenEnd').show();
							}
						} else {
							$('#listenName').hide();
							$('#listenType').hide();
							$('#listenCapacity').hide();
							$('#listenIfN').hide();
							$('#listenStart').show();
						}
					} else {
						$('#listenName').hide();
						$('#listenType').hide();
						$('#listenCapacity').show();
					}
				} else {
					$('#listenName').hide();
					$('#listenType').show();
				}
			} else {
				$('#listenName').show();
			}
			return world;
		}

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
													deleteThis();
													layer.closeAll();
												},
												btn2 : function(index, layero) {
													//按钮【按钮二】的回调
												},
												btnAlign : 'c',
												moveType : 1 //拖拽模式，0或者1
												,
												content : '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">确定删除该课程？</div>'
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

							$('#layerDemo .layui-btn').on(
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
	</script>
</body>
</html>