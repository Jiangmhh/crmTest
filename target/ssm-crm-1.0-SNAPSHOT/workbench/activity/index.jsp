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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<script type="text/javascript">

	$(function(){
		// 时间控件
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		/*
		模糊窗口 modal show:打开窗口 /hide:关闭窗口
		*/
		// 添加模糊窗口注值操作
		$("#addBtn").click(function () {
			// 打开模糊窗口前注值
			$.ajax({
				url :"workbench/activity/user/getUserList.do",
				data : {

				},
				type :"get",
				dataType : "json",
				success : function(data){
					var html = "";
					/*
						data [{"id":?,"name":?,.......},{}]
					*/
					$.each(data,function (i,n) {  // n: 每一个user对象
						html+="<option value='"+n.id+"'>"+n.name+"</option>";
						// alert(n.name)
					})
					$("#create-owner").html(html)
					// 设置默认值
					/*
					 $("#create-marketActivityOwner").val("06f5fc056eac41558a964f96daa7f27c")
					*/
					var id = "${user.id}"
					$("#create-owner").val(id)
				}
			})
			$("#createActivityModal").modal("show")


			// 市场活动添加操作
			$("#saveBtn").click(function (e){
				if(!e.isPropagationStopped()){
					// 发送ajax
					$.ajax({
						url : "workbench/activity/user/save.do",
						data : {
							"owner" : $.trim($("#create-owner").val()),
							"name" : $.trim($("#create-name").val()),
							"startDate" : $.trim($("#create-startDate").val()),
							"endDate" : $.trim($("#create-endDate").val()),
							"cost" : $.trim($("#create-cost").val()),
							"description" : $.trim($("#create-description").val()),
						},
						type :"post",  // ??????post失败
						dataType : "json",
						// contentType : "application/x-www-form-urlencoded",
						success : function(data){
							// data : true/false ajax直接返回布尔类型
							if(data){
								// 刷新市场活动信息列表（局部刷新）
								// pageList(1,2)
								pageList(1 ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
								// 重置表单
								/*
                                    jquery对象没有提供reset方法
                                    jquery对象转换为dom对象
                                        jquery对象[下标]
                                    dom对象转换jquery对象
                                        $(dom)
                                 */
								$("#activityAddForm")[0].reset()
								// 关闭模糊窗口
								$("#createActivityModal").modal("hide")
							}else{
								alert("添加失败")
							}

						}
					})
				}
				e.stopPropagation()
			})

		})
		// 页面加载完毕,刷新列表
		/*
			pageList方法运用场景
			(1).点击左侧菜单栏中的“市场活动”超链接
			(2).添加，修改，删除
			(3).查询
			(4).点击下方分页组件时
		*/
		pageList(1,2);

		// 查询按钮操作
		function search(){
			// 将数据存入隐藏域
			$("#hidden-name").val($.trim($("#search-name").val()))
			$("#hidden-owner").val($.trim($("#search-owner").val()))
			$("#hidden-startDate").val($.trim($("#search-startDate").val()))
			$("#hidden-endDate").val($.trim($("#search-endDate").val()))

			pageList(1,2)
		}
		$("#searchBtn").click(function () {
			search()

		})
		// 查询按钮绑定空格
		$(window).keydown(function (event) {
			if(event.keyCode == 13){
				search()
			}
		})


		// 为全选框的复选框绑定事件 和 触发全选操作
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked)
		})

		/*
		动态生成的元素，是不能以普通绑定事件的形式来进行操作的
			动态生成的元素，以on方法的新式来触发事件
			语法：
				$(需要绑定元素有效的外层元素).on(绑定事件的方式，需要绑定的元素的jquery对象,回调函数)
		*/
		$("#activityBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})

		// 市场活动删除
		$("#deleteBtn").click(function(){
			// 获取选择框为checked状态的dom对象
			var $xz = $("input[name=xz]:checked");
			var param = "";
			if($xz.length==0){
				alert("请选择需要删除的记录")
			}else{
				// 提醒是否删除
				if(confirm("确定删除所选记录吗?")){
					// 获取每个dom对象的value值
					for(var i=0;i <$xz.length;i++){
						param += "id=" + $($xz[i]).val()   //转换为jquery对象取其val值

						if(i < $xz.length-1){
							param += "&"
						}
					}
					// alert(param)
					// "workbench/activity/user/delete.do?id=#####&id=######"
					$.ajax({
						url :"workbench/activity/user/delete.do",
						data : param,
						type :"post",
						dataType : "json",
						success : function(data){
							// true/false
							if(data){
								// 刷新页面
								pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

							}else{
								alert("市场活动删除失败")
							}
						}
					})

				}

			}


		})

		// 市场活动修改
		$("#editBtn").click(function(){
			// 时间控件
			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});

			var $xz = $("input[name=xz]:checked");
			var id = "";
			if($xz.length ==0 ) {
				alert("请选择需要修改的记录")
			}else if($xz.length >1){
				alert("请选择单条记录")
			}else{
				// 获取复选框的id值
				id = $($xz[0]).val()
				$("#hidden-edit-id").val(id)
				// 注值
				$.ajax({
					url : "workbench/activity/user/getUserListAndActivity.do",
					data : {
						"id":$("#hidden-edit-id").val()
					},
					type :"get",
					dataType : "json",
					success : function(data){
						$("#edit-name").val(data.a.name);
						var html = "";
						/*
							data:
								(1).所有者
								(2).市场活动单条记录
								{"ulist":[{用户1},{用户2},....],"a":{"name":"发传单","startDate":"",...}}
						*/
						$.each(data.uList,function(i,n) {
							html += "<option value='"+n.id+"'>"+n.name+"</option>";
						})

						$("#edit-owner").html(html);

						$("#edit-name").val(data.a.name);
						// 选择下拉列表的默认项
						$("#edit-owner").val(data.a.owner);
						$("#edit-startDate").val(data.a.startDate);
						$("#edit-endDate").val(data.a.endDate);
						$("#edit-cost").val(data.a.cost);
						$("#edit-description").val(data.a.description);
					}
				})

				// 打开模糊窗口
				$("#editActivityModal").modal("show");
				$("#updateBtn").click(function (e) {
					// 修改操作
					if(!e.isPropagationStopped()){
						$.ajax({
							url : "workbench/activity/user/update.do",
							data : {
								"id" : $("#hidden-edit-id").val(),
								"owner" : $.trim($("#edit-owner").val()),
								"name" : $.trim($("#edit-name").val()),
								"startDate" : $.trim($("#edit-startDate").val()),
								"endDate" : $.trim($("#edit-endDate").val()),
								"cost" : $.trim($("#edit-cost").val()),
								"description" : $.trim($("#edit-description").val()),
								// createTime
								// createBy
								// editTime
								// editBy
							},
							type : "post",
							dataType : "json",
							success : function(data){
								if(data){
									alert("修改成功")
									// 刷新页面
									pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
											,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
									// 关闭模糊窗口
									$("#editActivityModal").modal("hide");
								}else{
									alert("修改失败")
								}
							}
						})
					}
					e.stopPropagation()
				})



			}

		})


		
	});

	// 定义分页方法
	pageList = function (pageNo,pageSize) {
		// 取消选择框选择状态
		$("#qx").prop("checked",false)

		// 从隐藏域中取数据 赋值到搜索框
		var  name = $.trim($("#hidden-name").val())
		$("#search-owner").val($.trim($("#hidden-owner").val()))
		$("#search-startDate").val($.trim($("#hidden-startDate").val()))
		$("#search-endDate").val($.trim($("#hidden-endDate").val()))
		// 发送ajax
		$.ajax({
			url : "workbench/activity/user/pageList.do",
			data : {
				"pageNo":pageNo,
				"pageSize":pageSize,
				"name":name,
				"owner":$.trim($("#search-owner").val()),
				"startDate":$.trim($("#search-startDate").val()),
				"endDate":$.trim($("#search-endDate").val()),
			},
			type :"get",
			dataType : "json",
			success : function(data){
				/*
					data : 1)市场活动 [{市场活动1},{2},....]
						   2)查询出来的总记录数(分页插件需要的)
				    {“total”:100,"dataList":[{市场活动1},{2},{3}]}
				*/
				var html = "";
				$.each(data.dataList,function(i,n){
					// 结果展示
					html += '<tr class="active">',
					html += '<td><input type="checkbox" name="xz" value='+n.id+'></td>',
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/user/detail.do?id='+n.id+'\';">'+n.name+'</a></td>',
					html += '<td>'+n.owner+'</td>',
					html += '<td>'+n.startDate+'</td>',
					html += '<td>'+n.endDate+'</td>',
					html += '</tr>'
				})

				$("#activityBody").html(html)
				// 分页插件
				// 总页数
				var totalPages = data.total%pageSize==0 ?data.total/pageSize :parseInt(data.total/pageSize)+1
				$("#activityPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});

			}
		})
	}
</script>
</head>
<body>
	<%--隐藏域--%>
	<input type="hidden" id="hidden-name" />
	<input type="hidden" id="hidden-owner" />
	<input type="hidden" id="hidden-startDate" />
	<input type="hidden" id="hidden-endDate" />
	<input type="hidden" id="hidden-edit-id" />

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="activityAddForm">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <%--<option>zhangsan</option>--%>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
<%--								  <option>zhangsan123</option>--%>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate" >
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<%--
									textarea : 文本域
									(1).以标签对的形式来呈现，正常状态下紧挨着
									(2).textarea取值和赋值操作 统一val()方法
								--%>
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn" >更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control time" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control time" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<%--
						data-toggle="modal":
							表示触发该按钮，将打开一个模糊窗口
						data-target="#createActivityModal":
							表示打开的模糊窗口，通过#id的形式找到该窗口

						问题：不能对按钮的功能进行扩充
						实际开发写在js代码中用来操作
					--%>

					<%--<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createActivityModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
					<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>--%>
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn" data-toggle="modal" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div id="activityPage">

			</div>
			
		</div>
		
	</div>
</body>
</html>