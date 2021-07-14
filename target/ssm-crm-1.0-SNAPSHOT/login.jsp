<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" +
request.getServerName() + ":" + request.getServerPort() +
request.getContextPath() + "/";
%>
<html>
<head>
	<base href="<%=basePath%>" />
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script>
	// 页面加载完毕执行函数
	$(function(){
		// 设置为顶端窗口
		if(window.top!=window){
			window.top.location=window.location
		}

		// 页面加载 文本框清除
		$("#loginAct").val("");
		$("#loginPwd").val("");

		// 让文本框获得光标
		$("#loginAct").focus();

		// 为登入窗口绑定快捷键
		$(window).keydown(function (event) {
			if(event.keyCode == 13){
				login(); // 登录验证
			}
		})

		// 为提交按钮绑定事件
		$("#submitBtn").click(function(){
			login();
		})


	})

	// 定义验证方法
	/*
	1.对账户密码进行去重  2.将用户密码发送ajax请求，得到后台响应结果值来判断是否进去工作台
	*/
	login = function () {
		// 去重处理
		var loginAct = $.trim($("#loginAct").val());
		var loginPwd = $.trim($("#loginPwd").val());

		if(loginAct == "" || loginPwd == ""){
			$("#msg").html("账号密码不能为空");
			return false;
		}

		// 验证密码
		$.ajax({
			url : "settings/user/login.do",
			data : {
				/*
					data: {"success" :true/false, "msg": "错误位置"}
				*/
				"loginAct" : loginAct,
				"loginPwd" : loginPwd
			},
			type : "post",
			datatype : "ajax",
			success : function(data){
				if(data.success){
					// 验证通过
					window.location.href = "workbench/index.jsp"
				}else{
					// 验证失败
					$("#msg").html(data.msg)
				}

			}


		})
	}



</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<!--<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">-->
		<img src="" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.jsp" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" id="loginAct" type="text" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" id="loginPwd" type="password" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						
							<span id="msg" style="color: red"></span>
						
					</div>
					<button type="button" id="submitBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>