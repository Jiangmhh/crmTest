<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		// 展示线索备注
		$("#remarkShowBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkShowBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})
		remarkShow();
		contactShow();
		tranShow();


		// 编辑
		// 修改线索-线索注入
		$("#editCustomerBtn").click(function () {
			$("#editCustomerModal").modal("show")
			$.ajax({
				url :"workbench/customer/user/getUserListAndCustomer.do",
				data : {
					"id" : "${customer.id}"
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
					$("#edit-contactSummary1").val(data.c.contactSummary)
					$("#edit-nextContactTime1").val(data.c.nextContactTime)
					$("#edit-description").val(data.c.description)
					$("#edit-address").val(data.c.address)
					$("#edit-name").val(data.c.name)
				}
			})
			$("#editCustomerModal").modal("show")
		})

		$("#updateCustomerBtn").click(function () {
			update()
		})

		$("#deleteCustomerBtn").click(function () {
			if(confirm("确认删除吗")){
				deleteCustomer();
			}
		})

		// 修改线索备注
		$("#updateRemarkBtn").click(function (e) {
			if($.trim($("#noteContent").val()) != ""){
				if(!e.isPropagationStopped()){
					$.ajax({
						url :"workbench/customer/user/updateRemark.do",
						data : {
							"id" : $("#hidden-remarkId").val(),
							"noteContent": $.trim($("#noteContent").val()),
						},
						type :"post",
						dataType : "json",
						success : function(data){
							// data : true/false
							if(data){
								remarkShow()
								$("#editRemarkModal").modal("hide")
								// 清空备注
								$("#noteContent").val("")
							}else{
								alert("修改失败")
							}
						}
					})
				}
				e.stopPropagation()
			}else{
				alert("内容不能为空")
			}
		})

		// 添加备注
		$("#addRemarkBtn").click(function () {
			addRemark();
		})
		// 添加联系人注值
		$("#addContactBtn").click(function () {
			$("#createContactsModal").modal("show")
			$.ajax({
				url :"workbench/activity/user/getUserList.do",
				type :"get",
				dataType : "json",
				success : function(data){
					var html = "";
					$.each(data,function (i,n) {  // n: 每一个user对象
						html+="<option value='"+n.id+"'>"+n.name+"</option>";
					})
					$("#create-owner").html(html)
					var id = "${user.id}"
					$("#create-owner").val(id)
				}
			})
		})

		// 添加联系人
		$("#saveBtn").click(function () {
			saveContact();
		})
	});

	// 修改
	function update() {
		$.ajax({
			url :"workbench/customer/user/update.do",
			data : {
				"id" : "${customer.id}",
				"owner" : $.trim($("#edit-owner").val()),
				"name" : $.trim($("#edit-name").val()),
				"website" : $.trim($("#edit-website").val()),
				"phone" : $.trim($("#edit-phone").val()),
				"contactSummary" : $.trim($("#edit-contactSummary1").val()),
				"nextContactTime" : $.trim($("#edit-nextContactTime1").val()),
				"description" : $.trim($("#edit-description").val()),
				"address" : $.trim($("#edit-address").val()),
			},
			type :"get",
			dataType : "json",
			success : function(data){
				if(data){
					location.reload();
					$("#editCustomerModal").modal("hide")
				}else{
					alert("修改失败")
				}
			}
		})
	}

	function deleteCustomer() {
		$.ajax({
			url :"workbench/customer/user/delete.do",
			data : {
				"id" : "${customer.id}"
			},
			type :"get",
			dataType : "json",
			success : function(data){
				if(data){
					alert("删除成功")
					window.location.href="workbench/customer/index.jsp"
				}else {
					alert("删除失败")
				}
			}
		})
	}

	// 展示市场活动备注
	function remarkShow() {
		$.ajax({
			url :"workbench/customer/user/getRemarkListByCusid.do",
			data : {
				"id" : "${customer.id}"
			},
			type :"get",
			dataType : "json",
			success : function (data) {
				var html = ""
				$.each(data,function (i,n) {
					html += '<div class="remarkDiv" style="height: 60px;">'
					html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
					html += '<div style="position: relative; top: -40px; left: 40px;" >'
					html += '<h5 id="c'+n.id+'">'+n.noteContent+'</h5>'
					html += '<font color="gray">客户</font> <font color="gray">-</font> <b>'+n.name+'</b> <small style="color: gray;"> '+(n.editFlag==0?n.createTime :n.editTime)+'由'+(n.editFlag==0?n.createBy :n.editBy)+'</small>'
					html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
					html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" onclick="editRemark(\''+n.id+'\')" style="font-size: 20px; color: #FF0000;"></span></a>'
					html += '&nbsp;&nbsp;&nbsp;&nbsp;'
				    html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" onclick="deleteRemark(\''+n.id+'\')" style="font-size: 20px; color: #FF0000;"></span></a>'
					html += '</div>'
					html += '</div>'
					html += '</div>'
				})
				$("#remarkShowBody").html(html)
			}
		})
	}

	// 打开客户备注
	function editRemark(id){
		$("#editRemarkModal").modal("show")
		$("#hidden-remarkId").val(id)
		// 注值
		var data = $("#c"+id).html()
		$("#noteContent").val(data)
	}

	// 删除客户备注
	function deleteRemark(id){
		if(confirm("确定删除所选备注吗")){
			$.ajax({
				url :"workbench/customer/user/deleteRemark.do",
				data : {
					"id" : id
				},
				type :"post",
				dataType : "json",
				success : function(data){
					if(data){
						remarkShow();
					}else{
						alert("删除失败")
					}
				}
			})
		}
	}
	// 添加备注
	function addRemark(){
		$.ajax({
			url :"workbench/customer/user/addRemark.do",
			data : {
				"customerId" : "${customer.id}",
				"noteContent": $.trim($("#remark").val()),
			},
			type :"post",
			dataType : "json",
			success : function(data){
				// data : true/false
				if(data){
					$("#remark").val("")
					remarkShow()
				}else{
					alert("添加失败")
				}
			}
		})
	}

	// 展示联系人
	function contactShow(){
		$.ajax({
			url :"workbench/customer/user/getContactListById.do",
			data : {
				"customerId" : "${customer.id}",
			},
			type :"get",
			dataType : "json",
			success : function(data){
				var html = ""
				$.each(data,function (i,n) {
					html += '<tr>'
					html += '<td><a href="contacts/detail.html" style="text-decoration: none;">'+n.fullname+'</a></td>'
					html += '<td>'+n.email+'</td>'
					html += '<td>'+n.mphone+'</td>'
					html += '<td><a href="javascript:void(0);" onclick="deleteContact(\''+n.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>'
					html += '</tr>'
				})
				$("#contactBody").html(html)
			}
		})
	}
	// 展示交易
	function tranShow() {
		$.ajax({
			url :"workbench/customer/user/getTranListByCusId.do",
			data : {
				"customerId" : "${customer.id}",
			},
			type :"get",
			dataType : "json",
			success : function(data){
				var html = ""
				$.each(data,function (i,n) {
					html += '<tr>'
					html += '<td><a href="workbench/transaction/detail.jsp" style="text-decoration: none;">${customer.name}-'+n.name+'</a></td>'
					html += '<td>'+n.money+'</td>'
					html += '<td>'+n.stage+'</td>'
					html += '<td>'+n.possibility+'</td>'
					html += '<td>'+n.expectedDate+'</td>'
					html += '<td>'+n.type+'</td>'
					html += '<td><a href="javascript:void(0);" onclick="deleteTran(\''+n.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>'
					html += '</tr>'
				})
				$("#tranShowBody").html(html)
			}
		})
	}

	function deleteTran(id){
		$("#removeTransactionModal").modal("show")
		$("#hidden-tranId").val(id);
		$("#deleteTranBtn").click(function () {
			$.ajax({
				url :"workbench/customer/user/deleteTran.do",
				data : {
					"id" : $("#hidden-tranId").val()
				},
				type :"post",
				dataType : "json",
				success : function(data){
					if(data){
						tranShow()
						$("#removeTransactionModal").modal("hide")
					}else{
						alert("删除失败")
					}
				}
			})
		})
	}

	function saveContact() {
		$.ajax({
			url :"workbench/customer/user/saveContact.do",
			data : {
				"owner" : $.trim($("#create-owner").val()),
				"source" : $.trim($("#create-source").val()),
				"customerId" : "${customer.id}",
				"fullname" : $.trim($("#create-fullname").val()),
				"appellation" : $.trim($("#create-appellation").val()),
				"email" : $.trim($("#create-email").val()),
				"mphone" : $.trim($("#create-mphone").val()),
				"job" : $.trim($("#create-job").val()),
				"birth" : $.trim($("#create-birth").val()),
				"description" : $.trim($("#create-description").val()),
				"contactSummary" : $.trim($("#create-contactSummary").val()),
				"nextContactTime" : $.trim($("#create-nextContactTime").val()),
				"address" : $.trim($("#create-address").val())
			},
			type :"post",
			dataType : "json",
			success : function(data){
				if(data){
					contactShow()
					$("#createContactsModal").modal("hide")
				}else{
					alert("创建失败")
				}
			}
		})
	}

	function deleteContact(id){
		$("#removeContactsModal").modal("show")
		$("#hidden-contactId").val(id);
		$("#deleteContactBtn").click(function () {
			$.ajax({
				url :"workbench/customer/user/deleteContact.do",
				data : {
					"id" : $("#hidden-contactId").val()
				},
				type :"post",
				dataType : "json",
				success : function(data){
					if(data){
						contactShow()
						$("#removeContactsModal").modal("hide")
					}else{
						alert("删除失败")
					}
				}
			})
		})
	}
	
</script>

</head>
<body>
	<input type="hidden" id="hidden-remarkId">
	<input type="hidden" id="hidden-tranId">
	<input type="hidden" id="hidden-contactId">
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 删除联系人的模态窗口 -->
	<div class="modal fade" id="removeContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">删除联系人</h4>
				</div>
				<div class="modal-body">
					<p>您确定要删除该联系人吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" id="deleteContactBtn">删除</button>
				</div>
			</div>
		</div>
	</div>

    <!-- 删除交易的模态窗口 -->
    <div class="modal fade" id="removeTransactionModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 30%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title">删除交易</h4>
                </div>
                <div class="modal-body">
                    <p>您确定要删除该交易吗？</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-danger" id="deleteTranBtn">删除</button>
                </div>
            </div>
        </div>
    </div>
	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
<%--								  <option>zhangsan</option>--%>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
								<c:forEach items="${source}" var="a">
									<option value="${a.value}">${a.text}</option>
								</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
									<c:forEach items="${appellation}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-birth">
							</div>
						</div>
						
<%--						<div class="form-group" style="position: relative;">--%>
<%--							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>--%>
<%--							<div class="col-sm-10" style="width: 300px;">--%>
<%--								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">--%>
<%--							</div>--%>
<%--						</div>--%>
						
						<div class="form-group" style="position: relative;">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="create-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
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
<%--                                    <option>zhangsan</option>--%>
<%--                                    <option>lisi</option>--%>
<%--                                    <option>wangwu</option>--%>
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
                                    <textarea class="form-control" rows="3" id="edit-contactSummary1"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime2" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="edit-nextContactTime1">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateCustomerBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${customer.name} <small><a href="http://www.bjpowernode.com" target="_blank">${customer.website}</a></small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editCustomerBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteCustomerBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.owner}&nbsp;&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.name}&nbsp;&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.website}&nbsp;&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.phone}&nbsp;&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${customer.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${customer.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${customer.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${customer.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 40px;">
            <div style="width: 300px; color: gray;">联系纪要</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${customer.contactSummary}&nbsp;&nbsp;
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 50px;">
            <div style="width: 300px; color: gray;">下次联系时间</div>
            <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.nextContactTime}&nbsp;&nbsp;</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
        </div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${customer.description}&nbsp;&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 70px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${customer.address}&nbsp;&nbsp;
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 10px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<div id="remarkShowBody">

		</div>
		
		<!-- 备注1 -->
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>哎呦！</h5>--%>
<%--				<font color="gray">联系人</font> <font color="gray">-</font> <b>李四先生-北京动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>

		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="addRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 交易 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>交易</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable2" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>金额</td>
							<td>阶段</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>类型</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="tranShowBody">
<%--						<tr>--%>
<%--							<td><a href="workbench/transaction/detail.jsp" style="text-decoration: none;">动力节点-交易01</a></td>--%>
<%--							<td>5,000</td>--%>
<%--							<td>谈判/复审</td>--%>
<%--							<td>90</td>--%>
<%--							<td>2017-02-07</td>--%>
<%--							<td>新业务</td>--%>
<%--							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeTransactionModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>--%>
<%--						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="workbench/transaction/user/addTran.do" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 联系人 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>联系人</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>邮箱</td>
							<td>手机</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="contactBody">
<%--						<tr>--%>
<%--							<td><a href="contacts/detail.html" style="text-decoration: none;">李四</a></td>--%>
<%--							<td>lisi@bjpowernode.com</td>--%>
<%--							<td>13543645364</td>--%>
<%--							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeContactsModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>--%>
<%--						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="addContactBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
			</div>
		</div>
	</div>
	
	<div style="height: 200px;"></div>
</body>
</html>