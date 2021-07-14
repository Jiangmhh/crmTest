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
		// 分页展示
		pageList(1,2)
		//注值
		$("#addBtn").click(function () {
			// 注值
			$.ajax({
				url :"workbench/clue/user/getUserList.do",
				data : {

				},
				type :"get",
				dataType : "json",
				success : function(data){
					var html = "<option></option>";
					$.each(data, function (i,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>"
					})
					$("#create-owner").html(html)
					// 当前选项框用户
					var id = "${user.id}"
					$("#create-owner").val(id)
					// 打开模态窗口
					$("#createClueModal").modal("show")
					$("#saveBtn").click(function (e) {
						if(!e.isPropagationStopped()){
							addClue();
						}
						e.stopPropagation()
					})
				}
			})

		})
		// 全选框 复选框
		$("#qx").click(function () {
			$("input[value=xz]").prop("checked", this.checked)
		})

		$("#clueBody").on("click",$("input[value=xz]"),function () {
			$("#qx").prop("checked",$("input[value=xz]").length==$("input[value=xz]:checked").length)
		})

		// 查询
        $("#searchBtn").click(function () {
			// 数据存入隐藏域
			$("#hidden-fullname").val($.trim($("#search-fullname").val()))
			$("#hidden-company").val($.trim($("#search-company").val()))
			$("#hidden-phone").val($.trim($("#search-phone").val()))
			$("#hidden-mphone").val($.trim($("#search-mphone").val()))
			$("#hidden-source").val($.trim($("#search-source").val()))
			$("#hidden-owner").val($.trim($("#search-owner").val()))
			$("#hidden-state").val($.trim($("#search-state").val()))
            pageList(1,2);
        })

		// 修改按钮
		$("#editBtn").click(function(){
			// 提示
			var length = $("input[value=xz]:checked").length;
			if(length == 0){
				alert("请选择要修改的线索")
				return
			}else if(length > 1){
				alert("请选择单条记录")
				return
			}
			// 获取选择框id
			var id = $("input[value=xz]:checked").attr("id")
			$("#hidden-editId").val(id)
			// 打开修改模糊窗口
			$("#editClueModal").modal("show")
			// 注值
			$.ajax({
				url :"workbench/clue/user/getUserListAndClue.do",
				data : {
					"id" : $("#hidden-editId").val()
				},
				type :"get",
				dataType : "json",
				success : function(data){
					// data : 所有者 + clue数据  {”userList“ : [], "clue" : {"fullname": "zs","" : "",....}}
					var html = "<option></option>";
					$.each(data.userList, function (i,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>"
					})
					$("#edit-owner").html(html)
					$("#edit-owner").val(data.clue.owner)

					$("#edit-fullname").val(data.clue.fullname)
					$("#edit-company").val(data.clue.company)
					$("#edit-job").val(data.clue.job)
					$("#edit-email").val(data.clue.email)
					$("#edit-phone").val(data.clue.phone)
					$("#edit-website").val(data.clue.website)
					$("#edit-mphone").val(data.clue.mphone)
					$("#edit-description").val(data.clue.description)
					$("#edit-nextContactTime").val(data.clue.nextContactTime)
					$("#edit-contactSummary").val(data.clue.contactSummary)
					$("#edit-address").val(data.clue.address)
					$("#edit-appellation").val(data.clue.appellation)
					$("#edit-state").val(data.clue.state)
					$("#edit-source").val(data.clue.source)

				}
			})

		})

		// 更新按钮
		$("#updateBtn").click(function () {
			updateClue();
		})
		// 删除按钮
		$("#deleteBtn").click(function () {
			deleteClue();
		})

	});

	// 删除方法
	function deleteClue() {
		var $xz = $("input[value=xz]:checked")
		var length = $xz.length
		if(length==0){
			alert("请选择需要删除的记录")
			return
		}
		var id = ""
		for(var i=0;i<$xz.length;i++){
			id += "id="+$($xz[i]).attr("id")
			if(i<length-1){
				id += "&"
			}
		}
		if(confirm("确认删除吗")){
			$.ajax({
				url :"workbench/clue/user/delete.do",
				data : id,
				type :"post",
				dataType : "json",
				success : function(data){
					if(data){
						pageList($("#cluePage").bs_pagination('getOption', 'currentPage')
								,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
					}else{
						alert("删除失败")
					}
				}
			})
		}
	}

	// 添加线索方法
	function addClue(){
			$.ajax({
				url :"workbench/clue/user/saveClue.do",
				data : {
					"fullname" : $.trim($("#create-fullname").val()),
					"appellation" : $.trim($("#create-appellation").val()),
					"owner" : $.trim($("#create-owner").val()),
					"company" : $.trim($("#create-company").val()),
					"job" : $.trim($("#create-job").val()),
					"email" : $.trim($("#create-email").val()),
					"phone" : $.trim($("#create-phone").val()),
					"website" : $.trim($("#create-website").val()),
					"mphone" : $.trim($("#create-mphone").val()),
					"state" : $.trim($("#create-state").val()),
					"source" : $.trim($("#create-source").val()),
					"createBy" : $.trim($("#create-createBy").val()),
					"createTime" : $.trim($("#create-createTime").val()),
					"description" : $.trim($("#create-description").val()),
					"contactSummary" : $.trim($("#create-contactSummary").val()),
					"nextContactTime" : $.trim($("#create-nextContactTime").val()),
					"address" : $.trim($("#create-address").val())
				},
				type :"post",
				dataType : "json",
				success : function(data){
					// data :true/false
					if(data){
						// 执行分页
						pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
						// 关闭模糊窗口
						$("#createClueModal").modal("hide")
						// 重置表单
						$("#createForm")[0].reset()
					}else{
						alert("添加失败")
					}
				}
			})

	}

	//修改方法
	function updateClue(id){
		var id = $("#hidden-editId").val()
		$.ajax({
			url :"workbench/clue/user/updateClue.do",
			data : {
				"id" : id,
				"fullname" : $.trim($("#edit-fullname").val()),
				"appellation" : $.trim($("#edit-appellation").val()),
				"owner" : $.trim($("#edit-owner").val()),
				"company" : $.trim($("#edit-company").val()),
				"job" : $.trim($("#edit-job").val()),
				"email" : $.trim($("#edit-email").val()),
				"phone" : $.trim($("#edit-phone").val()),
				"website" : $.trim($("#edit-website").val()),
				"mphone" : $.trim($("#edit-mphone").val()),
				"state" : $.trim($("#edit-state").val()),
				"source" : $.trim($("#edit-source").val()),
				"createBy" : $.trim($("#edit-createBy").val()),
				"createTime" : $.trim($("#edit-createTime").val()),
				"description" : $.trim($("#edit-description").val()),
				"contactSummary" : $.trim($("#edit-contactSummary").val()),
				"nextContactTime" : $.trim($("#edit-nextContactTime").val()),
				"address" : $.trim($("#edit-address").val())
			},
			type :"post",
			dataType : "json",
			success : function(data){
				// data :true/false
				if(data){
					// 执行分页
					pageList($("#cluePage").bs_pagination('getOption', 'currentPage'),$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
					// 关闭模糊窗口
					$("#editClueModal").modal("hide")
				}else{
					alert("添加失败")
				}
			}
		})
	}



	// 分页方法
	function pageList(pageNo, pageSize){
		// 取消全选
		$("#qx").prop("checked", false)
		$.ajax({
			url :"workbench/clue/user/pageList.do",
			data : {
				"pageNo" : pageNo,
				"pageSize" : pageSize,
				"fullname" : $("#hidden-fullname").val(),
				"company" : $("#hidden-company").val(),
				"phone" : $("#hidden-phone").val(),
				"mphone" : $("#hidden-mphone").val(),
				"source" : $("#hidden-source").val(),
				"owner" : $("#hidden-owner").val(),
				"state" : $("#hidden-state").val()
			},
			type :"get",
			dataType : "json",
			success : function(data){
				// data :  {"total":?, "dataList" : [{1},{2},.....]}
				// 1.total 总记录数  2.clueList
				var html = "";
				$.each(data.dataList, function (i,n) {

					html += '<tr class="active">'
					html += '<td><input type="checkbox" id="'+n.id+'" value="xz"/></td>'
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/user/detail.do?id='+n.id+'\';">'+n.fullname+''+n.appellation+'</a></td>'
					html += '<td>'+n.company+'</td>'
					html += '<td>'+n.phone+'</td>'
					html += '<td>'+n.mphone+'</td>'
					html += '<td>'+n.source+'</td>'
					html += '<td>'+n.owner+'</td>'
					html += '<td>'+n.state+'</td>'
					html += '</tr>'
				})
				$("#clueBody").html(html);

				// 分页组件
				var totalPages = data.total%pageSize==0 ?data.total/pageSize : parseInt(data.total/pageSize)+1
				$("#cluePage").bs_pagination({
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
	<%--查询隐藏域--%>
	<input type="hidden" id="hidden-fullname"/>
	<input type="hidden" id="hidden-company"/>
	<input type="hidden" id="hidden-phone"/>
	<input type="hidden" id="hidden-mphone"/>
	<input type="hidden" id="hidden-source"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-state"/>
	<input type="hidden" id="hidden-editId"/>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createForm">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
<%--								  <option>zhangsan</option>--%>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
								  <c:forEach items="${appellation}" var="a">
									  <option value="${a.value}">${a.text}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
<%--								  <option>试图联系</option>--%>
<%--								  <option>将来联系</option>--%>
<%--								  <option>已联系</option>--%>
<%--								  <option>虚假线索</option>--%>
<%--								  <option>丢失线索</option>--%>
<%--								  <option>未联系</option>--%>
<%--								  <option>需要条件</option>--%>
									<c:forEach items="${clueState}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
<%--								  <option>广告</option>--%>
<%--								  <option>推销电话</option>--%>
<%--								  <option>员工介绍</option>--%>
<%--								  <option>外部介绍</option>--%>
<%--								  <option>在线商场</option>--%>
<%--								  <option>合作伙伴</option>--%>
<%--								  <option>公开媒介</option>--%>
<%--								  <option>销售邮件</option>--%>
<%--								  <option>合作伙伴研讨会</option>--%>
<%--								  <option>内部研讨会</option>--%>
<%--								  <option>交易会</option>--%>
<%--								  <option>web下载</option>--%>
<%--								  <option>web调研</option>--%>
<%--								  <option>聊天</option>--%>
									<c:forEach items="${source}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
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
									<input type="text" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
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
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
<%--								  <option>zhangsan</option>--%>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="${clue.company}">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
								  <c:forEach items="${appellation}" var="a">
									  <option value="${a.value}">${a.text}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" value="${clue.fullname}">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="${clue.jop}">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="${clue.email}" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="${clue.phone}">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="${clue.website}">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="${clue.phone}">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
								  <option></option>
								  <c:forEach items="${clueState}" var="a">
									  <option value="${a.value}">${a.text}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${source}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">${clue.description}</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">${clue.contactSummary}</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="edit-nextContactTime" value="${clue.nextContactTime}">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">${clue.address}</textarea>
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
				<h3>线索列表</h3>
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
				      <input class="form-control" type="text" id="search-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="search-company">
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
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="search-source">
					  	  <option></option>
					  	  <c:forEach items="${source}" var="a">
							  <option value="${a.value}">${a.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="search-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="search-state">
					  	<option></option >
						  <c:forEach items="${clueState}" var="a">
							  <option value="${a.value}">${a.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn" data-target="#createClueModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn" data-target="#editClueModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueBody">

					</tbody>
				</table>
			</div>


			<div id="cluePage" style="position: relative;top: 50px;">

			</div>
		</div>
		
	</div>
</body>
</html>