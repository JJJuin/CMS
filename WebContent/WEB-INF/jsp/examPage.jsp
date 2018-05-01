<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link rel="shortcut icon" type="image/x-icon"
	href="<%=request.getContextPath()%>/icon/cms2.ico" media="screen" />
<link type="text/css" rel="stylesheet"
	href="<%=request.getContextPath()%>/css/bootstrap.min.css">
<link type="text/css" rel="stylesheet"
	href="<%=request.getContextPath()%>/css/mycss.css">
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery-3.2.0.min.js"></script>
<script src="<%=request.getContextPath()%>/js/bootstrap.min.js"></script>
<link type="text/css" rel="stylesheet"
	href="<%=request.getContextPath()%>/layui/css/layui.css">
<script src="<%=request.getContextPath()%>/layui/layui.js "></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery-3.2.0.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery.webcam.min.js"></script>
		<script src="<%=request.getContextPath()%>/layui/mods/index.js"></script>
<title>${examination.examinationName}考试页面</title>
</head>
<script type="text/javascript">
function   fresh(){  
	if(location.href.indexOf("?reload=true")<0){
	    location.href+="?reload=true";  
	   }  
	} 
window.onbeforeunload = function(){
return "您尚未保存！";
}
</script>
<script language="javascript" type="text/javascript"> 
var videoExist = false;   //检测摄像头打开用
var video;
window.onload=function(){
	  video = document.getElementById('video'),
	  vendorUrl = window.URL || window.webkitURL;
	  navigator.getMedia = navigator.getUserMedia ||
	                       navagator.webkitGetUserMedia ||
	                       navigator.mozGetUserMedia ||
	                       navigator.msGetUserMedia;
	  navigator.getMedia({
	      video: true, //使用摄像头对象
	      audio: false //不适用音频
	  }, function(strem){
	      console.log(strem);
	      video.src = vendorUrl.createObjectURL(strem);
	      video.play();
	      //检测到数据流，证明开启了摄像头
	      videoExist = true;
	  }, function(error) {
		  videoExist = false;
	      console.log(error);
	  });
	
	
	document.onkeydown=function (e){
        var currKey=0,evt=e||window.event;
        currKey=evt.keyCode||evt.which||evt.charCode;
        if (currKey == 123) {
            window.event.cancelBubble = true;
            window.event.returnValue = false;
        }
    }
	// 防止右键刷新
	 document.onkeydown = function(){
	        if (event.keyCode == 123) {
	        	 event.keyCode=0;
	              event.returnValue = false;
	        }
          if(event.keyCode==116) {
              event.keyCode=0;
              event.returnValue = false;
          }
    }
    document.oncontextmenu = function() {
        event.returnValue = false;
    }
  //禁止选中
    document.onselectstart = function (event){
        if(window.event){
            event = window.event;
        }try{
            var the = event.srcElement;
            if (!((the.tagName == "INPUT" && the.type.toLowerCase() == "text") || the.tagName == "TEXTAREA")){
                return false;
            }
            return true;
        } catch (e) {
            return false;
        }
    };
    /*禁止复制*/
    document.oncontextmenu = function (event){
        if(window.event){
            event = window.event;
        }try{
            var the = event.srcElement;
            if (!((the.tagName == "INPUT" && the.type.toLowerCase() == "text") || the.tagName == "TEXTAREA")){
                return false;
            }
            return true;
        }catch (e){
            return false;
        }
    };
		  
	 
	layui.use('layer', function(){
         var $ = layui.jquery, layer = layui.layer; 
	      layer.open({
	        type: 1
	        ,offset: 'auto'
	        ,id: 'layerDemo'+'auto'
	        ,title: '提示'
	        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "请把握时间，考试结束系统自动收卷" +'</div>'
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
//拍照截取
function photoCompare() {
	 video = document.getElementById('video'),
	 canvas = document.getElementById('canvas'),
     img = document.getElementById('img'),
	 //绘制canvas图形
    canvas.getContext('2d').drawImage(video, 0, 0, 200, 150);
    
    //把canvas图像转为img图片
    
    var ext = img.src.substring(img.src.lastIndexOf(".")+1).toLowerCase();  
    Pic = canvas.toDataURL("image/png");   
   // console.log(Pic);
    Pic = Pic.replace(/^data:image\/(png);base64,/,"");
    return Pic;
}
var stop = false;
function transitionPhotoData(photoData) {
	var imageData = photoData;	
	$.ajax({
         type: "POST",
         data: {
        	 "studentRoNo":"${student.studentRoNo}",
	         "examinationId":"${examination.examinationID}",
		     "imageData":imageData
         },
         contentType: "application/json; charset=utf-8",
         dataType: "json",
         async: true,
         url: "<%=request.getContextPath()%>/exam/comparePhoto.do",
         success: function (data) {
        	 if(data.isstop == true){
					stop = true;
				}
        	 if(data.result == "success"){
        		 
				}else if(data.result == "fail"){
					layui.use('layer', function() {
						var $ = layui.jquery, layer = layui.layer;
						layer.msg(data.msg);
					});
				}
         },
         error: function (data) {
        	 layui.use('layer', function() {
					var $ = layui.jquery, layer = layui.layer;
					layer.msg("服务器异常，请联系管理员");
				});
			 console.log(data);
         },
     });
}
	var ranTem = 0;
	var Rand = 7;
	function Rand() {
		Rand = Math.floor(Math.random(30)*30);
		alert(Rand);
	}
  var interval = 1000; 
  function ShowCountDown(year,month,day,hour,minute,second,divname) 
	{ 
		  var now = new Date(); 
		  var endDate = new Date(year, month-1, day,hour,minute,second); 
		  var leftTime=endDate.getTime()-now.getTime(); 
		  var leftsecond = parseInt(leftTime/1000); 
		  var day1=Math.floor(leftsecond/(60*60*24)); 
		  var hour=Math.floor((leftsecond-day1*24*60*60)/3600); 
		  $('#hour').val(hour);
		  var minute=Math.floor((leftsecond-day1*24*60*60-hour*3600)/60); 
		  $('#minute').val(minute);
		  var second=Math.floor(leftsecond-day1*24*60*60-hour*3600-minute*60); 
		  $('#second').val(second);
		  var cc = document.getElementById(divname); 
		  cc.innerHTML = "剩余:"+hour+"小时"+"<span style='color:#FF5722'>"+minute+"</span>"+"分"+"<span style='color:#FF5722'>"+second+"</span>"+"秒"; 
		  timeEnd();
		  setTimeout('openVideo()',3000);
		  
	 } 
  function openVideo() {
	//检测摄像头是否开启
	  if(videoExist == false){
		  layui.use('layer', function() {
				var $ = layui.jquery, layer = layui.layer;
				layer.msg("请打开摄像头！");
			});
		  setTimeout('returnIndex()',3000);
	  }else {
		//开启了摄像头，就跑一下随机数，到点了就截取
		if(ranTem < Rand){
			//小于随机数，时间+1s
			ranTem ++;
		}else if(ranTem == Rand){
			if(stop == false){
				//等于了随机数，截取照片，编码后发给后台处理
				var photoData = photoCompare();
				transitionPhotoData(photoData);
				ranTem = 0;
				Rand = Math.floor(Math.random(7)*60);
			}
			
		}
	}
}
		window.setInterval(
				function(){
					ShowCountDown("${year}","${month}","${day}","${hour}","${minute}","${seconds}",'time');
					}, interval); 
        //回到首页
        function returnIndex() {
        	window.location.href="<%=request.getContextPath()%>/index.jsp"; 
		}
		function timeEnd() {
			  if($('#hour').val() == '0' && $('#minute').val() == '5' &&$('#second').val() == '0'){
				  layui.use('layer', function(){
	 	               var $ = layui.jquery, layer = layui.layer; 
	   			      layer.open({
	   			        type: 1
	   			        ,offset: 'auto'
	   			        ,id: 'layerDemo'+'auto'
	   			        ,title: '提示'
	   			        ,content: '<div style="padding: 20px 120px; color:#FF5722">'+ "考试剩余5分钟，请注意时间" +'</div>'
	   			        ,btn: '关闭'
	   			        ,btnAlign: 'c'
	   			        ,skin: 'demo-class'
	   			        ,shade: 0 
	   			        ,yes: function(){
	   			        	 layer.closeAll();
	   			        }
	   			      });
	 	            });
			  }else if($('#hour').val() == '0' && $('#minute').val() == '0' &&$('#second').val() == '3'){
				  layui.use('layer', function(){
	 	               var $ = layui.jquery, layer = layui.layer; 
	   			      layer.open({
	   			        type: 1
	   			        ,offset: 'auto'
	   			        ,id: 'layerDemo'+'auto'
	   			        ,title: '提示'
	   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "考试结束,正在交卷.." +'</div>'
	   			        ,btn: '关闭'
	   			        ,btnAlign: 'c'
	   			        ,skin: 'demo-class'
	   			        ,shade: 0 
	   			        ,yes: function(){
	   			        	 layer.closeAll();
	   			        }
	   			      });
	 	            });
				  setTimeout('examEnd()',3000);
				    
			}
		}
		//交卷
		function examEnd() {
			$.ajax({
		         type: "GET",
		         data: {
		        	 "studentRoNo":"${student.studentRoNo}",
		        	 "examinationID":"${examination.examinationID}"
		         },
		         contentType: "application/json; charset=utf-8",
		         dataType: "json",
		         async: true,
		         url: "<%=request.getContextPath()%>/exam/updateExamEnd.do",
		         success: function (data) {
		        	if(data.result == true){
		        		 window.location.href = "<%=request.getContextPath()%>/index.jsp";
		        	}
		         },
		         error: function (data) {
		             //alert("服务器异常！");
		         },
		     });
		}
</script>
<body style="background-color: #eeeeee" onbeforeunload="checkLeave()">
	<!-- 头部 -->
	<nav class="navbar navbar-inverse navbar-fixed-top">
	<div class="container">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#navbar" aria-expanded="false"
				aria-controls="navbar">
				<span class="sr-only">Toggle navigation</span> <span
					class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="#">CMS考试系统</a> <a class="navbar-brand"
				href="#">剩余：<span id="time"></span></a>
		</div>
		<form class="navbar-form navbar-right"
			style="margin-right: 5%; float: left;">
			<a href="#" id="lllww" style="width: 100px; color: white; font-size: 1.7em;">${examination.examinationName}</a>
		    <a href="#" onclick="toggleVideo()" style="right: 10px; position: fixed; top: 15px; text-decoration: none;"><i class="layui-icon" style="font-size: 30px; color: #1E9FFF;">&#xe660;</i> </a>
		</form>
	</div>
	</nav>
        <script>
        function toggleVideo() {
			$('#videoDiv').toggle();
		}
     //刷新页面函数
	 function yourFunction() {
		 window.location.reload();
	}
	 layui.use('form', function() {
			var form = layui.form;
		});
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

	<div>
		<input id="hour" type="text" style="display: none;" /> <input
			id="minute" type="text" style="display: none;" /> <input id="second"
			type="text" style="display: none;" /> <br /> <br /> <br />
	</div>

	<!-- 正文之考试信息 -->
	<div id="videoDiv" style="margin:0; position: fixed; right: 0">
		    <video id="video" width="200px" height="200px;" style="margin:0;"></video>
		    <canvas id='canvas' width='200px' height='200px' style="margin:0; padding:0;display:none;" ></canvas>
            <img id='img' src='' style="margin:0;display:none;">
	</div>
	
	<div style="background-color: white; margin-left: 5%; margin-right: 5%">
		<table class="layui-table">
			<colgroup>
				<col width="200">
				<col width="200">
				<col width="200">
				<col width="200">
				<col width="200">
				<col>
			</colgroup>
			<thead>
				<tr>
					<th>学号</th>
					<th>姓名</th>
					<th>考试时间</th>
					<th>考试时长</th>
					<th>试卷满分</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>${student.studentRoNo}</td>
					<td>${student.studentName}</td>
					<td>${examination.startTime}</td>
					<td>${examination.duration}分钟</td>
					<td>${examination.totalValue}分</td>
				</tr>
			</tbody>
		</table>
	</div>

	<!-- 答题部分 -->
	<div id="singleSelectionArea"
		style="heigh: 300px; background-color: white; margin-left: 5%; margin-right: 5%; padding-top: 10px; font-family: 微软雅黑">
		<h3 style="font-size: 1.4em;color: #5FB878;"><一>单选<span style="font-size: 0.8em">(该部分每题有且仅有一个正确答案，答错不得分)</span></h3>
		<br />
		<ul class="layui-timeline">
			<c:choose>
				<c:when test="${! empty singleSelections}">
					<c:forEach items="${singleSelections}" var="s">
						<li id="${s.questionNumber}" style="font-size: 1.2em">(${s.questionNumber})
							${s.questionContent}&nbsp;(${s.value}分)</li>
						<li>&nbsp;</li>
						<li><form class="layui-form"><div class="layui-form-item"> <div class="layui-input-block">
						<input type="radio" id="A${s.questionNumber}" lay-filter="encrypt" name="studentAnswer" value="A${s.questionNumber}" title="A">${s.optionA}<br/>
						<input type="radio" id="B${s.questionNumber}" lay-filter="encrypt" name="studentAnswer" value="B${s.questionNumber}" title="B">${s.optionB}<br/>
						<input type="radio" id="C${s.questionNumber}" lay-filter="encrypt" name="studentAnswer" value="C${s.questionNumber}" title="C">${s.optionC}<br/>
						<input type="radio" id="D${s.questionNumber}" lay-filter="encrypt" name="studentAnswer" value="D${s.questionNumber}" title="D">${s.optionD}<br/>
							</div></div></form>
						</li>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<li>该试卷不涉及该类型题目，请继续作答</li>
				</c:otherwise>
			</c:choose>
		</ul>
	</div>
	
	
	<script>
	layui.use('form', function(){
		  var form = layui.form;
		  form.on('radio(encrypt)', function(data){
				 console.log(data.elem); //得到radio原始DOM对象
				 updateSingleSelection(data.value); //被点击的radio的value值
				}); 
		});

	</script>
	
	<script type="text/javascript">
	 function updateSingleSelection(id) {
		var answer = id.substring(0,1);
		var questionNumber = id.substring(1);
		$.ajax({
	         type: "GET",
	         data: {
	        	 "studentRoNo":${student.studentRoNo},
	        	 "examinationID":${examination.examinationID},
	        	 "questionNumber":questionNumber,
	        	 "stuAnswer":answer
	         },
	         contentType: "application/json; charset=utf-8",
	         dataType: "json",
	         async: true,
	         url: "<%=request.getContextPath()%>/exam/updateSingleSelection.do",
	         success: function (data) {
	        	if(data.result == 'end'){
	        		 layui.use('layer', function(){
		 	               var $ = layui.jquery, layer = layui.layer; 
		   			      layer.open({
		   			        type: 1
		   			        ,offset: 'auto'
		   			        ,id: 'layerDemo'+'auto'
		   			        ,title: '提示'
		   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "抱歉，您已交卷" +'</div>'
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
	             //alert("服务器异常！");
	         },
	     });
	}
	</script>
	
	<div id="moreSelectionArea"
		style="heigh: 300px; background-color: white; margin-left: 5%; margin-right: 5%; padding-top: 10px; font-family: 微软雅黑">
		<h3 style="font-size: 1.4em;color: #5FB878;"><二>多选<span style="font-size: 0.8em">(该部分每题至少有一个选项正确，答错或者答对一部分不得分)</span></h3>
		<br />
		<ul class="layui-timeline">
			<c:choose>
				<c:when test="${! empty moreSelections}">
					<c:forEach items="${moreSelections}" var="s">
						<li style="font-size: 1.2em">(${s.questionNumber})
							${s.questionContent}&nbsp;(${s.value}分)</li>
						<li>&nbsp;</li>
						<li><form class="layui-form"><div class="layui-form-item"> <div class="layui-input-block">
						<input type="checkbox" name="studentAnswer1" lay-filter="hehe" value="A${s.questionNumber}" title="A">${s.optionA}<br/>
						<input type="checkbox" name="studentAnswer2" lay-filter="hehe" value="B${s.questionNumber}" title="B">${s.optionB}<br/> 
						<input type="checkbox" name="studentAnswer3" lay-filter="hehe" value="C${s.questionNumber}" title="C">${s.optionC}<br/>
						<input type="checkbox" name="studentAnswer4" lay-filter="hehe" value="D${s.questionNumber}" title="D">${s.optionD}<br/>
							</div></div></form>
						</li>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<li>该试卷不涉及该类型题目，请继续作答</li>
				</c:otherwise>
			</c:choose>
		</ul>
	</div>
	<script>
	layui.use('form', function(){
		  var form = layui.form;
	form.on('checkbox(hehe)', function(data){
		var answer = data.value.substring(0,1);
		var questionNumber = data.value.substring(1);
		if(data.elem.checked){
			$.ajax({
		         type: "GET",
		         data: {
		        	 "studentRoNo":${student.studentRoNo},
		        	 "examinationID":${examination.examinationID},
		        	 "questionNumber":questionNumber,
		        	 "stuAnswer":answer
		         },
		         contentType: "application/json; charset=utf-8",
		         dataType: "json",
		         async: true,
		         url: "<%=request.getContextPath()%>/exam/updateMoreSelection.do",
		         success: function (data) {
		        	 if(data.result == 'end'){
		        		 layui.use('layer', function(){
			 	               var $ = layui.jquery, layer = layui.layer; 
			   			      layer.open({
			   			        type: 1
			   			        ,offset: 'auto'
			   			        ,id: 'layerDemo'+'auto'
			   			        ,title: '提示'
			   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "抱歉，您已交卷" +'</div>'
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
		             //alert("服务器异常！");
		         },
		     });
		}else{
			$.ajax({
		         type: "GET",
		         data: {
		        	 "studentRoNo":${student.studentRoNo},
		        	 "examinationID":${examination.examinationID},
		        	 "questionNumber":questionNumber,
		        	 "stuAnswer":answer
		         },
		         contentType: "application/json; charset=utf-8",
		         dataType: "json",
		         async: true,
		         url: "<%=request.getContextPath()%>/exam/updateMoreSelectionCanel.do",
		         success: function (data) {
		        	if(data.result == true){
		        		
		        	}
		         },
		         error: function (data) {
		             //alert("服务器异常！");
		         },
		     });
		}
	});  
	});
	</script>
	
	
		<div id="judgeArea"
		style="heigh: 300px; background-color: white; margin-left: 5%; margin-right: 5%; padding-top: 10px; font-family: 微软雅黑">
		<h3 style="font-size: 1.4em;color: #5FB878;"><三>判断<span style="font-size: 0.8em">(答错不得分)</span></h3>
		<br />
		<ul class="layui-timeline">
			<c:choose>
				<c:when test="${! empty judges}">
					<c:forEach items="${judges}" var="s">
						<li style="font-size: 1.2em">(${s.questionNumber})
							${s.judgeContent}&nbsp;(${s.value}分)</li>
						<li>&nbsp;</li>
						<li><form class="layui-form"><div class="layui-form-item"> <div class="layui-input-block">
						
						<input type="radio" name="n1" lay-filter="panduan" value="T${s.questionNumber}" title="true">
						<input type="radio" name="n1" lay-filter="panduan" value="F${s.questionNumber}" title="false">
						
							</div></div></form>
						</li>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<li>该试卷不涉及该类型题目，请继续作答</li>
				</c:otherwise>
			</c:choose>
		</ul>
	</div>
	
	<script>
		layui.use('form', function(){
			  var form = layui.form;
			  form.on('radio(panduan)', function(data){
					 console.log(data.elem); //得到radio原始DOM对象
					 updateJudge(data.value); //被点击的radio的value值
					}); 
			});
		function updateJudge(id) {
			var answer = id.substring(0,1);
			if(answer == 'F'){
				answer = 'false'
			}else{
				answer = 'true'
			}
			var questionNumber = id.substring(1);
			$.ajax({
		         type: "GET",
		         data: {
		        	 "studentRoNo":${student.studentRoNo},
		        	 "examinationID":${examination.examinationID},
		        	 "questionNumber":questionNumber,
		        	 "stuAnswer":answer
		         },
		         contentType: "application/json; charset=utf-8",
		         dataType: "json",
		         async: true,
		         url: "<%=request.getContextPath()%>/exam/updateJudge.do",
		         success: function (data) {
		        	 if(data.result == 'end'){
		        		 layui.use('layer', function(){
			 	               var $ = layui.jquery, layer = layui.layer; 
			   			      layer.open({
			   			        type: 1
			   			        ,offset: 'auto'
			   			        ,id: 'layerDemo'+'auto'
			   			        ,title: '提示'
			   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "抱歉，您已交卷" +'</div>'
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
		             //alert("服务器异常！");
		         },
		     });
		}

	</script>
	
	
	
		<div id="packArea"
		style="heigh: 300px; background-color: white; margin-left: 5%; margin-right: 5%; padding-top: 10px; font-family: 微软雅黑">
		<h3 style="font-size: 1.4em;color: #5FB878;"><四>填空<span style="font-size: 0.8em"></span></h3>
		<br />
		<ul class="layui-timeline">
			<c:choose>
				<c:when test="${! empty packs}">
					<c:forEach items="${packs}" var="s">
						<li style="font-size: 1.2em">(${s.questionNumber})
							${s.packContent}&nbsp;(${s.value}分)</li>
						<li>&nbsp;</li>
						<li><form class="layui-form"><div class="layui-form-item"> <div class="layui-input-block">
						<input id="${s.questionNumber}" type="text" onchange="setPack(this.id)" 
							name="nj1" required
							style="border-top: none; border-left: none; border-right: none; 
							border-color: #009688; width: 40%;"
							lay-verify="required" autocomplete="off"
							class="layui-input">
							<br/>
							</div></div></form>
						</li>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<li>该试卷不涉及该类型题目，请继续作答</li>
				</c:otherwise>
			</c:choose>
		</ul>
	</div>
	
	<script type="text/javascript">
	  function setPack(id) {
			$.ajax({
		         type: "GET",
		         data: {
		        	 "studentRoNo":${student.studentRoNo},
		        	 "examinationID":${examination.examinationID},
		        	 "questionNumber":id,
		        	 "stuAnswer":$('#'+id).val()
		         },
		         contentType: "application/json; charset=utf-8",
		         dataType: "json",
		         async: true,
		         url: "<%=request.getContextPath()%>/exam/updatePack.do",
		         success: function (data) {
		        	 if(data.result == 'end'){
		        		 layui.use('layer', function(){
			 	               var $ = layui.jquery, layer = layui.layer; 
			   			      layer.open({
			   			        type: 1
			   			        ,offset: 'auto'
			   			        ,id: 'layerDemo'+'auto'
			   			        ,title: '提示'
			   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "抱歉，您已交卷" +'</div>'
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
		             //alert("服务器异常！");
		         },
		     });
		}
	
	</script>
	
		<div id="shortAnswerArea"
		style="heigh: 300px; background-color: white; margin-left: 5%; margin-right: 5%; padding-top: 10px; font-family: 微软雅黑">
		<h3 style="font-size: 1.4em;color: #5FB878;"><五>简答<span style="font-size: 0.8em"></span></h3>
		<br />
		<ul class="layui-timeline">
			<c:choose>
				<c:when test="${! empty shortAnswers}">
					<c:forEach items="${shortAnswers}" var="s">
						<li style="font-size: 1.2em">(${s.questionNumber})
							${s.shortAnswerContent}&nbsp;(${s.value}分)</li>
						<li>&nbsp;</li>
						<li><form class="layui-form"><div class="layui-form-item">
						     <div class="layui-input-block">
                             <textarea placeholder="请输入内容" id="${s.questionNumber}"
                             onchange="updateShortAnswer(this.id)" class="layui-textarea"></textarea>
                              </div>
							</div></form>
						</li>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<li>该试卷不涉及该类型题目，请继续作答</li>
				</c:otherwise>
			</c:choose>
		</ul>
		<br /> <br /> <br /> 
		<div class="site-demo-button" id="layerDemo" style="margin-bottom: 0;">
			<input id=""
					class="layui-btn" style="width: 8em; margin-left: 5%"
						 type="button" value="提交试卷"  data-method="confirmTrans"/>
		</div>
			<br /> <br /> <br /> 			
	</div>
	
	<script type="text/javascript">
	 function updateShortAnswer(id) {
		$.ajax({
	         type: "GET",
	         data: {
	        	 "studentRoNo":${student.studentRoNo},
	        	 "examinationID":${examination.examinationID},
	        	 "questionNumber":id,
	        	 "stuAnswer":$('#'+id).val()
	         },
	         contentType: "application/json; charset=utf-8",
	         dataType: "json",
	         async: true,
	         url: "<%=request.getContextPath()%>/exam/updateShortAnswer.do",
	         success: function (data) {
	        	 if(data.result == 'end'){
	        		 layui.use('layer', function(){
		 	               var $ = layui.jquery, layer = layui.layer; 
		   			      layer.open({
		   			        type: 1
		   			        ,offset: 'auto'
		   			        ,id: 'layerDemo'+'auto'
		   			        ,title: '提示'
		   			        ,content: '<div style="padding: 20px 100px; color:#FF5722">'+ "抱歉，您已交卷" +'</div>'
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
	             //alert("服务器异常！");
	         },
	     });
	}
	</script>
	
	
	<script>
	layui.use(['form', 'layedit', 'layer','laydate'], function(){
		var form = layui.form,layer = layui.layer
		var $ = layui.jquery, layer = layui.layer; //独立版的layer无需执行这一句
	
		  var active = {
				    confirmTrans: function(){
				        //配置一个透明的询问框
				        layer.msg('确定交卷？', {
				          area: ['300px', '150px'],
				          btnAlign: 'c',
				          time: 10000, //10s后自动关闭
				          btn: ['交卷', '取消']
				          ,yes: function(index, layero){
					    	 setTimeout('examEnd()',1000);
					       }
				     });
				  }
		  }
		  $('#layerDemo .layui-btn').on('click', function(){
			    var othis = $(this), method = othis.data('method');
			    active[method] ? active[method].call(this, othis) : '';
			  });
	});
	</script>

   <script language=javascript>
function keydown(){
	if(event.keyCode==8){
		event.keyCode=0;
		event.returnValue=false;
		alert("当前设置不允许使用退格键");
	  }if(event.keyCode==13){
		event.keyCode=0;
		event.returnValue=false;
		alert("当前设置不允许使用回车键");
	  }if(event.keyCode==116){
		event.keyCode=0;
		event.returnValue=false;
		alert("当前设置不允许使用F5刷新键");
	  }if((event.altKey)&&((window.event.keyCode==37)||(window.event.keyCode==39))){
		event.returnValue=false;
		alert("当前设置不允许使用Alt+方向键←或方向键→");
	  }if((event.ctrlKey)&&(event.keyCode==78)){
	   event.returnValue=false;
	   alert("当前设置不允许使用Ctrl+n新建IE窗口");
	  }if((event.shiftKey)&&(event.keyCode==121)){
	   event.returnValue=false;
	   alert("当前设置不允许使用shift+F10");
	  }
}
function click() {
 event.returnValue=false;
	 alert("当前设置不允许使用右键！");
}
document.oncontextmenu=click
</script>

</body>
</html>