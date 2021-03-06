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
		pageList(1,2)

		function search(){
			$("#hidden-owner").val($.trim($("#search-owner").val()))
			$("#hidden-name").val($.trim($("#search-name").val()))
			$("#hidden-customerName").val($.trim($("#search-customerName").val()))
			$("#hidden-stage").val($.trim($("#search-stage").val()))
			$("#hidden-type").val($.trim($("#search-type").val()))
			$("#hidden-source").val($.trim($("#search-source").val()))
			$("#hidden-contactName").val($.trim($("#search-contactName").val()))
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
		
		
	});


	// ??????
	function pageList(pageNo, pageSize) {
		// ???????????????????????????
		$("#qx").prop("checked",false)
		$.ajax({
			url :"workbench/transaction/user/pageList.do",
			data : {
				"pageNo" : pageNo,
				"pageSize" : pageSize,
				"owner" : $("#hidden-owner").val(),
				"name" : $("#hidden-name").val(),
				"customerName" : $("#hidden-customerName").val(),
				"stage" : $("#hidden-stage").val(),
				"type" : $("#hidden-type").val(),
				"source" : $("#hidden-source").val(),
				"contactName" : $("#hidden-contactName").val(),
			},
			type :"get",
			dataType : "json",
			success : function(data){
				// data : 1.total  2.dataList
				var html = ""
				$.each(data.dataList, function (i,n) {
					html += '<tr>'
					html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>'
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/user/detail.do?id='+n.id+'\';">'+n.customerName+'-'+n.name+'</a></td>'
					html += '<td>'+n.customerName+'</td>'
					html += '<td>'+n.stage+'</td>'
					html += '<td>'+n.type+'</td>'
					html += '<td>'+n.owner+'</td>'
					html += '<td>'+n.source+'</td>'
					html += '<td>'+n.contactName+'</td>'
					html += '</tr>'
				})
				$("#tranShowBody").html(html)

				var totalPages = data.total%pageSize==0 ?data.total/pageSize :parseInt(data.total/pageSize)+1
				$("#tranPage").bs_pagination({
					currentPage: pageNo, // ??????
					rowsPerPage: pageSize, // ???????????????????????????
					maxRowsPerPage: 20, // ?????????????????????????????????
					totalPages: totalPages, // ?????????
					totalRows: data.total, // ???????????????

					visiblePageLinks: 3, // ??????????????????

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
    <input type="hidden" id="hidden-owner">
    <input type="hidden" id="hidden-name">
    <input type="hidden" id="hidden-customerName">
    <input type="hidden" id="hidden-stage">
    <input type="hidden" id="hidden-type">
    <input type="hidden" id="hidden-source">
    <input type="hidden" id="hidden-contactName">

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>????????????</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">?????????</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
				      <input class="form-control" type="text" id="seach-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">????????????</div>
				      <input class="form-control" type="text" id="search-customerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
					  <select class="form-control" id="search-stage">
					  	<option></option>
						  <c:forEach items="${stage}" var="a">
							  <option value="${a.value}">${a.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
					  <select class="form-control" id="search-type">
					  	<option></option>
					  	<c:forEach items="${transactionType}" var="a">
							<option value="${a.value}">${a.text}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">??????</div>
				      <select class="form-control" id="search-source">
						  <option></option>
						  <c:forEach items="${source}" var="a">
							  <option value="${a.value}">${a.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">???????????????</div>
				      <input class="form-control" type="text" id="contactName">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">??????</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/user/addTran.do';"><span class="glyphicon glyphicon-plus"></span> ??????</button>
				  <button type="button" class="btn btn-default" onclick="window.location.href='workbench/transaction/edit.jsp';"><span class="glyphicon glyphicon-pencil"></span> ??????</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> ??????</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>??????</td>
							<td>????????????</td>
							<td>??????</td>
							<td>??????</td>
							<td>?????????</td>
							<td>??????</td>
							<td>???????????????</td>
						</tr>
					</thead>
					<tbody id="tranShowBody">
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">????????????-??????01</a></td>--%>
<%--                            <td>????????????</td>--%>
<%--                            <td>??????/??????</td>--%>
<%--                            <td>?????????</td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>??????</td>--%>
<%--                            <td>??????</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
			</div>

			<div id="tranPage">

			</div>
			
		</div>
		
	</div>
</body>
</html>