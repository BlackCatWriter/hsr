<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>经费申请办理</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
$(document).ready(function() {
    $(".handle").click(function() {
        var obj = $(this);
        var taskId = obj.data("tid");
        var expenseId = obj.data("id");
        var tkey = obj.data("tkey");
        //科教科审批
        if (tkey == "kjDeptAudit") {
        	expenseForm.action = "${ctx}/oa/expense/audit/"
					+ expenseId+"/"+taskId;
        	expenseForm.submit();
        }

        //调整申请
        if (tkey == "modifyApply") {
            $.getJSON("${ctx}/oa/expense/detail-with-vars/" + expenseId + "/" + taskId,
            function(data) {
                var html = Mustache.render($("#modifyApplyTemplate").html(), data);
                top.$.jBox(html, {
                    title: "流程办理[" + obj.data("tname") + "]",
                    buttons: {
                        "重新申请": "yes",
                        "放弃申请": "no",
                        "取消": "cancel"
                    },
                    submit: function(v, h, f) {
                        //重新申请或者取消申请
                        var reApply = true;
                        if (v == "no") {
                            reApply = false;
                        }
                        if (v == "yes" || v == "no") {
                            complete(taskId, [{
                                key: 'reApply',
                                value: reApply,
                                type: 'B'
                            },
                            {
                                key: 'expenseType',
                                value: top.$('#modifyApplyContent #expenseType').val(),
                                type: 'S'
                            },
                            {
                                key: 'reason',
                                value: top.$('#modifyApplyContent #reason').val(),
                                type: 'S'
                            },
                            {
                                key: 'amount',
                                value: top.$('#modifyApplyContent #amount').val(),
                                type: 'S'
                            }]);
                        }
                    }
                });
                top.$("#expenseType").val(data.expenseType);
            });
        }
    })
});

/**
	 * 完成任务
	 * @param {Object} taskId
	 */
function complete(taskId, variables) {
    // 转换JSON为字符串
    var keys = "",
    values = "",
    types = "";
    if (variables) {
        $.each(variables,
        function() {
            if (keys != "") {
                keys += "|";
                values += "|";
                types += "|";
            }
            keys += this.key;
            if (this.value == "") {
                values += " ";
            } else {
                values += this.value;
            }
            types += this.type;
        });
    }
    // 发送任务完成请求
    $.post('${ctx}/oa/workflow/complete/' + taskId, {
        keys: keys,
        values: values,
        types: types
    },
    function(resp) {
        if (resp == 'success') {
            top.$.jBox.tip('任务完成');
            location.reload();
        } else {
            top.$.jBox.tip('操作失败!');
        }
    });
}

</script>

<script type="text/template" id="modifyApplyTemplate">
		<table class="table table-striped " id="modifyApplyContent">
			<tr>
				<td>科室领导意见：</td>
				<td>
					{{variables.kjDeptBackReason}}
				</td>
			</tr>
			<tr>
				<td>医院领导意见：</td>
				<td>
					{{variables.leaderBackReason}}
				</td>
			</tr>
			<tr>
				<td>财务处意见：</td>
				<td>
					{{variables.financeBackReason}}
				</td>
			</tr>
			<tr>
				<td>经费类型：</td>
				<td>
					<select id="expenseType" name="expenseType">
						<c:forEach items="${fns:getDictList('oa_expense_type')}" var="expenseType">
							<option value="${expenseType.value}">${expenseType.label}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td>申请事由：</td>
				<td><textarea id="reason" name="reason" class="required" rows="5">{{reason}}</textarea></td>
			</tr>
			<tr>
				<td>申请金额：</td>
				<td><input id="amount" name="amount" class="required" rows="5" value="{{amount}}"/></td>
			</tr>
		</table>
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/oa/expense/projectlist">项目管理</a></li>
		<shiro:hasPermission name="oa:expense:edit">
			<li><a href="${ctx}/oa/expense/form">经费申请</a></li>
		</shiro:hasPermission>
		<li><a href="${ctx}/oa/expense/list">所有任务</a></li>
		<li class="active"><a href="${ctx}/oa/expense/task">待办任务</a></li>
	</ul>
	<tags:message content="${message}" />
	<form:form id="expenseForm"></form:form>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<tr>
			<th>立项号</th>
			<th>项目名称</th>
			<th>申请人</th>
			<th>申请时间</th>
			<th>当前节点</th>
			<th>任务创建时间</th>
			<%--<th>流程状态</th>--%>
			<th>操作</th>
		</tr>
		<tbody>
			<c:forEach items="${expenses}" var="expense">
				<c:set var="task" value="${expense.task}" />
				<c:set var="pi" value="${expense.processInstance}" />
				<tr id="${expense.id}">
					<td>${expense.project.projectNo}</td>
					<td>${expense.project.projectName}</td>
					<td>${expense.user.name}</td>
					<td><fmt:formatDate value="${expense.createDate}" type="both" /></td>
					<td>${task.name}</td>
					<td><fmt:formatDate value="${task.createTime}" type="both" /></td>
					<%--<td>${pi.suspended ? "已挂起" : "正常" }；<b title='流程版本号'>V: ${expense.processDefinition.version}</b></td>--%>
					<td>
						<%-- 此处用tkey记录当前节点的名称 --%> <a class="handle" href="#" data-tkey="${task.taskDefinitionKey}"
						data-tname="${task.name}" data-id="${expense.id}" data-tid="${task.id}">办理</a>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
</html>
