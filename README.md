# CMS
课堂管理系统(B/S)

需求分析

课题：课堂管理系统CMS(B/S)

1，需求简介

教学中有很多工作，细致而繁琐，如给学生提供课件、视频等学习材料，收发作业、批改作业、分享作业，发送通知、与学生沟通等。这些工作，借助邮件、QQ、也可以，但总是有些麻烦，不太专一，让学习工作往往与个人生活相掺杂，很容易发生对作业或学习信息遗漏或遗忘问题。  
目前很多中学和高校一般使用QQ、邮件或微信进行学习上的交互，但我们希望能开发一个基于JAVA的课堂管理系统，实现各种教学功能，如考勤，提问，发布作业等实用功能。真正做到专一的为教师、学生提供便利，帮助教师提高课堂效率。

2，需求功能详细介绍

实现各种教学功能，如考勤，提问，发布作业等实用功能，另外非核心功能，如登录拦截，学生管理，重要信息推送等 

3，项目分析，包括各种图例分析

1.学生注册（注册信息包括照片，数据库存地址）管理员审核后学生方可登录
2.维持一个临时表，作为暂未经过审核的学生信息表
3.教师创建班级（二维码：已有学生班级，老师姓名，其余学生自己填）
4.教师端对学生增删改查，发送消息，消息保存在数据库中，为期6个月
5.学生登录以后可以查看自己信息，登录账号会发送到邮箱
6.教师端课堂发布签到二维码，二维码信息包括个人姓名班级及照片 ，可以设置失效时 间（防止代签），目的：签到点名，其次活跃课堂气氛
7.教师端课下作业发布，作业批改
8.学生端线上完成签到，或者上传高清大图（限时），查询成绩
9.教师端PPT发布，公告发布
10.论坛模块，公共论坛实时交流
针对项目需求，进行模块化设计与开发，利用SSM开源框架进行后台开发，使用MySQL数据库并与项目整合，前端使用jsp动态页面，整体使用Git做版本控制

4.人脸识别模块

检测任意两张图片的相似度思路

加载两张图片为bitmap进入内存
将内存中的两张图片bitmap转换为Mat矩阵(Mat类是OpenCV最基本的一个数据类型，它可以表示一个多维的多通道的数组。Mat常用来存储图像，包括单通道二维数组——灰度图，多通道二维数组——彩色图)
把Mat矩阵的type转换为Cv_8uc1(1通道8位矩阵)类型，然后转换为Cv_32F， 因为在c++代码中会判断他的类型。
通过OpenCv 来进行俩个矩阵的比较（俩个矩阵必须一样大小的高宽）

识别图片中是否有人脸思路

需要一个人脸的Haar特征分类器就是一个XML文件，该文件中会描述人脸的Haar特征值，CascadeClassifier人脸探测器将该特征值集合加载入内存
加载图片为bitmap进入内存，将bitmap转换为Mat矩阵。
有了Mat矩阵，然后通过调用OpenCV的Native方法，人脸探测器CascadeClassifier在该Mat矩阵中检测当前是否有人脸。
如果有，我们会获取到一个Rect数组，里面会有人脸数据，然后将人脸画在屏幕上，方框或者圆形

识别两张图片中的人脸是否是同一个人脸思路

识别出人脸后会得到两个人脸的Rect数组，然后比较这两个Rect数组的相似度即可！

5.项目组成员及成员github地址，维护者的github地址 


