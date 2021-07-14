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
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		// 刷新分页
		pageList(1,2)
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		// 查询
		function search(){
			$("#hidden-name").val($.trim($("#search-name").val()))
			$("#hidden-owner").val($.trim($("#search-owner").val()))
			$("#hidden-phone").val($.trim($("#search-phone").val()))
			$("#hidden-website").val($.trim($("#search-website").val()))
			pageList(1,2)
		}
		$("#searchBtn").click(function () {
			search()
		})
		$(window).keydown(function (event) {
			if(event.keyCode==13){
				search()
			}
		})
		// 添加
		$("#addBtn").click(function () {
			$("#createCustomerModal").modal("show")
			getUserList()
		})
		// 保存
		$("#saveBtn").click(function () {
			save()
		})

		// 为全选框的复选框绑定事件 和 触发全选操作
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked)
		})

		$("#customerShowBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})
		// 修改
		$("#editBtn").click(function () {
			var $xz = $("input[name=xz]:checked")
			var length = $xz.length
			if(length<1){
				alert("请选择需要修改的记录")
				return;
			}
			if(length>1){
				alert("请选择单条记录")
				return;
			}
			var id = $($xz).val()
			$("#hidden-id").val(id)
			// 注值
			$.ajax({
				url :"workbench/customer/user/getUserListAndCustomer.do",
				data : {
					"id" : $("#hidden-id").val()
				},
				type :"get",
				dataType : "json",
				success : function(data){
					// data : 所有者 + customer数据  {”userList“ : [], "c" : {"name": "","" : "",....}}
					var html = "<option></option>";
					$.each(data.userList, function (i,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>"
					})
					$("#edit-owner").html(html)
					$("#edit-owner").val(data.c.owner)
					$("#edit-website").val(data.c.website)
					$("#edit-phone").val(data.c.phone)
					$("#edit-contactSummary").val(data.c.contactSummary)
					$("#edit-nextContactTime").val(data.c.nextContactTime)
					$("#edit-description").val(data.c.description)
					$("#edit-address").val(data.c.address)
					$("#edit-name").val(data.c.name)
				}
			})
			$("#editCustomerModal").modal("show")
		})
		$("#updateBtn").click(function () {
			update()
		})
		$("#deleteBtn").click(function () {
			var $xz = $("input[name=xz]:checked")
			var length = $xz.length
			if(length==0){
				alert("请选择需要删除的记录")
				return;
			}
			var id=""
			for(var i=0;i<$xz.length;i++){
				id += "id="+$($xz[i]).val()
				if(i<$xz.length-1){
					id += "&"
				}
			}

			if(confirm("确认删除吗")){
				del(id)
			}
		})


	});
	// 注入
	function getUserList() {
		$.ajax({
			url :"workbench/customer/user/getUserList.do",
			data : {

			},
			type :"get",
			dataType : "json",
			success : function(data){
				var html = "<option></option>"
				$.each(data,function (i,n) {
					html+="<option value='"+n.id+"'>"+n.name+"</option>";
				})
				$("#create-owner").html(html)
				var id = "${user.id}"
				$("#create-owner").val(id)
			}
		})
	}

	// 保存
	function save() {
		$.ajax({
			url :"workbench/customer/user/save.do",
			data : {
				"owner" : $.trim($("#create-owner").val()),
				"name" : $.trim($("#create-name").val()),
				"website" : $.trim($("#create-website").val()),
				"phone" : $.trim($("#create-phone").val()),
				"contactSummary" : $.trim($("#create-contactSummary").val()),
				"nextContactTime" : $.trim($("#create-nextContactTime").val()),
				"description" : $.trim($("#create-description").val()),
				"address" : $.trim($("#create-address1").val()),
			},
			type :"get",
			dataType : "json",
			success : function(data){
				if(data){
					pageList(1,2)
					$("#createCustomerModal").modal("hide")
					$("#addForm")[0].reset()
				}else{
					alert("添加失败")
				}
			}
		})
	}

	// 修改
	function update() {
		$.ajax({
			url :"workbench/customer/user/update.do",
			data : {
				"id" : $("#hidden-id").val(),
				"owner" : $.trim($("#edit-owner").val()),
				"name" : $.trim($("#edit-name").val()),
				"website" : $.trim($("#edit-website").val()),
				"phone" : $.trim($("#edit-phone").val()),
				"contactSummary" : $.trim($("#edit-contactSummary").val()),
				"nextContactTime" : $.trim($("#edit-nextContactTime").val()),
				"description" : $.trim($("#edit-description").val()),
				"address" : $.trim($("#edit-address").val()),
			},
			type :"get",
			dataType : "json",
			success : function(data){
				if(data){
					pageList(1,2)
					$("#editCustomerModal").modal("hide")
				}else{
					alert("修改失败")
				}
			}
		})
	}

	 // 删除
	function del(id) {
		$.ajax({
			url :"workbench/customer/user/delete.do",
			data : id,
			type :"post",
			dataType : "json",
			success : function(data){
				if(data){
					// 刷新页面
					pageList(1,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
				}else{
					alert("客户删除失败")
				}
			}
		})
	}

	// 分页
	function pageList(pageNo, pageSize) {
		// 取消选择框选择状态
		$("#qx").prop("checked",false)
		$.ajax({
			url :"workbench/customer/user/pageList.do",
			data : {
				"pageNo" : pageNo,
				"pageSize" : pageSize,
				"name" : $("#hidden-name").val(),
				"owner" : $("#hidden-owner").val(),
				"phone" : $("#hidden-phone").val(),
				"website" : $("#hidden-website").val(),
			},
			type :"get",
			dataType : "json",
			success : function(data){
				// data : 1.total  2.dataList
				var html = ""
				$.each(data.dataList, function (i,n) {
					html += '<tr class="active">'
					html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>'
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/user/detail.do?id='+n.id+'\';">'+n.name+'</a></td>'
					html += '<td>'+n.owner+'</td>'
					html += '<td>'+n.phone+'</td>'
					html += '<td>'+n.website+'</td>'
					html += '</tr>'
				})
				$("#customerShowBody").html(html)

				var totalPages = data.total%pageSize==0 ?data.total/pageSize :parseInt(data.total/pageSize)+1
				$("#customerPage").bs_pagination({
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
	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-phone">
	<input type="hidden" id="hidden-website">
	<input type="hidden" id="hidden-id">
	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="addForm">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
<%--								  <option>zhangsan</option>--%>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control" id="create-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address1"></textarea>
                                </div>
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
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
<%--								  <option>zhangsan</option>--%>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime2" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="edit-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
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
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="search-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" type="text" id="search-website">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
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
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="customerShowBody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>010-84846003</td>--%>
<%--							<td>http://www.bjpowernode.com</td>--%>
<%--						</tr>--%>

					</tbody>
				</table>
			</div>

			<div id="customerPage">

			</div>
			
		</div>
		
	</div>
</body>
</html>