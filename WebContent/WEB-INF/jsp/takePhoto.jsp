<%@page import="com.qdu.pojo.Student"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<title>考前拍照</title>

</head>
<script type="text/javascript">

</script>

<body style="background-color: #eeeeee">
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
			<a class="navbar-brand" href="#">CMS考试系统</a>
		</div>
		<form class="navbar-form navbar-right"
			style="margin-right: 5%; float: left;">
			<a id="lllww" style="width: 100px; color: white; font-size: 1.7em;">考前拍照</a>
		</form>
	</div>
	</nav>

	<div>
		<br /> <br /> <br /> <br /> <br /> <br /> <br /> <br />
	</div>

	<div
		style="heigh: 300px; background-color: white; margin-left: 19%; margin-right: 20%; padding-left: 10%; padding-right: 10%; padding-top: 4%; padding-bottom: 100px;">

     <div class="booth">
    <!-- <video id="video" width="200px" height="200px;" style="margin:0;"></video> -->
    <!-- <button id='tack'> snap shot</button> -->
    <canvas id='canvas' width='200px' height='200px' style="margin:0; padding:0;display:none;" ></canvas>
    <img id='img' src='' style="margin:0;display:none;">
  </div>
 
 
  <script>
  
  </script>


		<fieldset>
			<legend> 请考生本人拍照验证： </legend>
			<img id="phtoto" alt="点击拍照" src="<%=request.getContextPath()%>/icon/拍照.PNG" width="200px;" height="180" style="margin-left: 10px;" onclick="takePhoto()">
		    
		    <div id="videoDiv" style="margin:0;display:none;">
		    <video id="video" width="200px" height="200px;" style="margin:0;"></video>
		    <br/>
		    <input id='tack' type="button" style="margin-left: 3%;"
				class="layui-btn" value="拍照" />
		    </div>
		    
		</fieldset>
		<br/>
		<form id="examForm" style="display: none;" action="<%=request.getContextPath() %>/exam/lastExamConfirm.do" method="post">
		    <input id="examinationID" name="examinationID" readonly="readonly" type="text" value="${student.studentRoNo}" style="display: none;"/>
		    <input id="studentRoNo" name="studentRoNo" readonly="readonly" type="text" value="${examination.examinationID}" style="display: none;"/>
		</form>
								
		<div style="height: 60px; width: 300px; float: left;">
		    <input id="takeNow" type="button" style="float: left; margin-left: 4%;"
				class="layui-btn" onclick="takePhoto()" value="点击开始" /> 
			<input id="achive" type="submit" style="float: left; margin-left: 4%; display: none;"
				class="layui-btn" onclick="nextstep()" value="完成" /> 
			<input id="back"
				type="button" style="float: left; margin-left: 24%;"
				class="layui-btn" onclick="javascript:history.back()" value="返回" />
			<br /> <br />
		</div>
	</div>
	
	<script type="text/javascript">
	var Pic;
	  function getVideo() {
		  var video = document.getElementById('video'),
	      canvas = document.getElementById('canvas'),
	      snap = document.getElementById('tack'),
	      img = document.getElementById('img'),
	      vendorUrl = window.URL || window.webkitURL;
	      
	  //媒体对象
	  navigator.getMedia = navigator.getUserMedia ||
	                       navagator.webkitGetUserMedia ||
	                       navigator.mozGetUserMedia ||
	                       navigator.msGetUserMedia;
	  navigator.getMedia({
	      video: true, //使用摄像头对象
	      audio: false  //不适用音频
	  }, function(strem){
	      console.log(strem);
	      video.src = vendorUrl.createObjectURL(strem);
	      video.play();
	  }, function(error) {
	      //error.code
	      console.log(error);
	  });
	  snap.addEventListener('click', function(){
		  $('#videoDiv').hide();
		  $('#takeNow').hide();
	      //绘制canvas图形
	      canvas.getContext('2d').drawImage(video, 0, 0, 200, 150);
	      
	      //把canvas图像转为img图片
	      var phtoto = document.getElementById('phtoto');
	      phtoto.src=canvas.toDataURL("image/png");
	      
	      var ext = img.src.substring(img.src.lastIndexOf(".")+1).toLowerCase();  
	      Pic = canvas.toDataURL("image/png");   
	     // console.log(Pic);
	      Pic = Pic.replace(/^data:image\/(png);base64,/,"");
	      
		  $('#phtoto').show();
		  $('#achive').show();
		  $('#back').show();
		  
	  })
	}
	 
	
	
	function takePhoto() {
		$('#takeNow').hide();
		$('#back').hide();
		$('#achive').hide();
		$('#phtoto').hide();
		$('#videoDiv').show();
		getVideo();
	}
	function nextstep() {
		//console.log(Pic);
		var imageData = Pic;
		 //console.log(imageData);
		$('#studentRoNo').val("${student.studentRoNo}");
		$('#examinationID').val("${examination.examinationID}");
		layui.use('layer', function() {
			var $ = layui.jquery, layer = layui.layer;
			layer.msg("正在处理，请稍后..");
		});
		$.ajax({
	         type: "POST",
	         data: {
	        	 "studentRoNo":$('#studentRoNo').val(),
		         "examinationID":$('#examinationID').val(),
			     "imageData":Pic
	         },
	         contentType: "application/json; charset=utf-8",
	         dataType: "json",
	         async: true,
	         url: "<%=request.getContextPath()%>/exam/confirmPhoto.do",
	         success: function (data) {
	        	 if(data.result == "success"){
						$('#examForm').submit();
					}else {
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
	</script>
</body>
</html>