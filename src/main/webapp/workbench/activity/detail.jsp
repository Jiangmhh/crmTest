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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
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

		// 页面加载完毕后展示备注
		getActivityRemark();

        $("#remarkBody").on("mouseover",".remarkDiv",function(){
            $(this).children("div").children("div").show();
        })
        $("#remarkBody").on("mouseout",".remarkDiv",function(){
            $(this).children("div").children("div").hide();
        })


        $("#saveRemarkBtn").click(function () {
            // 文本框不为空
            if($.trim($("#remark").val()) != ""){
                // 执行添加
                var aid = "${a.id}"
                saveRemark(aid);
            }else{
                alert("备注信息不能为空")
            }
        })

        // 更新市场活动
        // 点击编辑
        $("#editActivityBtn").click(function(){
            // 注值
            $.ajax({
                url : "workbench/activity/user/getUserListAndActivity.do",
                data : {
                    "id": "${a.id}"
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
            $("#editActivityModal").modal("show")
            // 执行更新操作
            $("#updateBtn").click(function (e) {
                // 修改操作
                if(!e.isPropagationStopped()){
                    $.ajax({
                        url : "workbench/activity/user/update.do",
                        data : {
                            "id" : "${a.id}",
                            "owner" : $.trim($("#edit-owner").val()),
                            "name" : $.trim($("#edit-name").val()),
                            "startDate" : $.trim($("#edit-startDate").val()),
                            "endDate" : $.trim($("#edit-endDate").val()),
                            "cost" : $.trim($("#edit-cost").val()),
                            "description" : $.trim($("#edit-description").val()),
                        },
                        type : "post",
                        dataType : "json",
                        success : function(data){
                            if(data){
                                alert("修改成功")
                                // 刷新页面
                                location.reload();
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

        })

        // 删除市场活动
        $("#deleteActivityBtn").click(function(){
            if(confirm("确认删除吗")){
                $.ajax({
                    url :"workbench/activity/user/delete.do",
                    data : {
                        "id" : "${a.id}"
                    },
                    type :"post",
                    dataType : "json",
                    success : function(data){
                        // true/false
                        if(data){
                            window.location.href="workbench/activity/index.jsp"
                        }else{
                            alert("市场活动删除失败")
                        }
                    }
                })
            }
        })

        // 修改备注
        $("#updateRemarkBtn").click(function (e) {
            if($.trim($("#noteContent").val()) != ""){
                if(!e.isPropagationStopped()){
                    $.ajax({
                        url :"workbench/activity/user/editRemark.do",
                        data : {
                            "id" : $("#hidden-remarkUpdateId").val(),
                            "noteContent": $.trim($("#noteContent").val()),
                        },
                        type :"post",
                        dataType : "json",
                        success : function(data){
                            // data : true/false
                            if(data){
                                getActivityRemark()
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

    });


	function getActivityRemark() {
		$.ajax({
			url :"workbench/activity/user/getActivityRemarkByAid.do",
			data : {
				"id" : "${a.id}"
			},
			type :"get",
			dataType : "json",
			success : function(data){
				// data :  [{备注1},{备注2},...]
				html = "";
				$.each(data,function(i,n){
                    html += '<div class="remarkDiv" id='+n.id+' style="height: 60px;">';
                    html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                    html += '<div style="position: relative; top: -40px; left: 40px;" >';
                    html += '<h5 id="e'+n.id+'">'+n.noteContent+'</h5>';
                    html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${a.name}</b> <small style="color: gray;">'+(n.editFlag == 0?n.createTime :n.editTime)+'由'+(n.editFlag == 0?n.createBy :n.editBy)+'</small>';
                    html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                    html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" onclick="editRemark(\''+n.id+'\')" style="font-size: 20px; color: #FF0000;"></span></a>';
                    html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                    html += '<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" onclick="deleteRemark(\''+n.id+'\')" style="font-size: 20px; color: #FF0000;"></span></a>';
                    html += '</div>';                                                               // 动态生成的元素必须套用在字符串当中
                    html += '</div>';
                    html += '</div>';
				})
				$("#remarkShow").html(html);
			}
		})
	}
	// 备注删除
	function deleteRemark(id){
	    if(confirm("确定删除所选备注吗")){
            $.ajax({
                url :"workbench/activity/user/deleteRemark.do",
                data : {
                    "id" : id
                },
                type :"post",
                dataType : "json",
                success : function(data){
                    if(data){
                        getActivityRemark();
                    }else{
                        alert("删除失败")
                    }
                }
            })
        }
    }
    // 备注添加方法
    function saveRemark(aid){
        $.ajax({
            url :"workbench/activity/user/saveRemark.do",
            data : {
                "activityId" : aid,
                "noteContent": $.trim($("#remark").val()),
            },
            type :"post",
            dataType : "json",
            success : function(data){
                // data : true/false
                if(data){
                    $("#remark").val("")
                    getActivityRemark()
                }else{
                    alert("添加失败")
                }
            }
        })
    }

    // 备注修改
    function editRemark(id){
	    $("#editRemarkModal").modal("show")
        $("#hidden-remarkUpdateId").val(id)
        // 注值
        var data = $("#e"+id).html()
        $("#noteContent").val(data)
    }


	
</script>

</head>
<body>
	<input type="hidden" id="hidden-remarkUpdateId">
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

    <!-- 修改市场活动的模态窗口 -->
    <div class="modal fade" id="editActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-owner">
<%--                                    <option>zhangsan</option>--%>
<%--                                    <option>lisi</option>--%>
<%--                                    <option>wangwu</option>--%>
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
                                <input type="text" class="form-control time" id="edit-startDate">
                            </div>
                            <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-endDate" value="2020-10-20">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-cost" value="5,000">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-description"></textarea>
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

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${a.name} <small>${a.startDate} ~ ${a.endDate}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
<%--			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>--%>
			<button type="button" class="btn btn-default" id="editActivityBtn" data-target="#editActivityModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${a.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${a.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${a.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${a.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${a.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

        <div id="remarkShow">

        </div>
		
		<!-- 备注1 -->
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>哎呦！</h5>--%>
<%--				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>
		
		<!-- 备注2 -->
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>呵呵！</h5>--%>
<%--				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
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
					<button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>