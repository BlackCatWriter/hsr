<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>著作登记办理</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
$(document).ready(function() {
    $(".handle").click(function() {
        var obj = $(this);
        var taskId = obj.data("tid");
        var bookId = obj.data("id");
        var tkey = obj.data("tkey");
        //科室领导审批
        if (tkey == "deptLeaderAudit") {
            $.getJSON("${ctx}/oa/book/detail/" + bookId,
            function(data) {
                var html = Mustache.render($("#auditTemplate").html(), data);
                top.$.jBox(html, {
                    title: "流程办理[" + obj.data("tname") + "]",
                    buttons: {
                        "同意": "yes",
                        "驳回": "no",
                        "取消": "cancel"
                    },
                    submit: function(v, h, f) {
                        //同意
                        if (v == "yes") {
                        	 complete(taskId, [{
                                 key: 'kjDeptPass',
                                 value: true,
                                 type: 'B'
                               }]);
                            //驳回
                        } else if (v == "no") {
                            top.$.jBox("<div style='padding:10px;'><textarea id='kjDeptBackReason' style='width: 250px; height: 60px;'></textarea></div>", {
                                title: "请填写打回理由",
                                submit: function() {
                                    var kjDeptBackReason = top.$("#kjDeptBackReason").val();
                                    //必须填写驳回理由
                                    if ($.trim(kjDeptBackReason) == "") {
                                        top.$.jBox.error('请填写打回理由', '错误');
                                        return false;
                                    } else {
                                        complete(taskId, [{
                                            key: 'kjDeptPass',
                                            value: false,
                                            type: 'B'
                                        },
                                        {
                                            key: 'kjDeptBackReason',
                                            value: kjDeptBackReason,
                                            type: 'S'
                                        }]);
                                    }
                                }
                            });
                        }

                    }
                });
            });
        }
        
        if (tkey == "kjDeptAudit") {
            $.getJSON("${ctx}/oa/book/detail/" + bookId,
            function(data) {
                var html = Mustache.render($("#auditTemplate").html(), data);
                top.$.jBox(html, {
                    title: "流程办理[" + obj.data("tname") + "]",
                    buttons: {
                        "同意并追加信息": "yes",
                        "驳回": "no",
                        "取消": "cancel"
                    },
                    submit: function(v, h, f) {
                        //同意
                        if (v == "yes") {
                            top.$.jBox("<div style='padding:10px;'>" 
                            + "<div class='control-group'>" 
                            + "<label class='control-label'>奖励金额:</label>" 
                            + "<div class='controls'>" 
                            + "<input id='jl' name='jl' type='text' class='number'/>" 
                            + "</div>" 
                            + "</div>" 
                            + "<div class='control-group'>" 
                            + "<label class='control-label'>权重:</label>" 
                            + "<div class='controls'>" 
                            + "<input id='weight' name='weight' type='text' class='number'/>" 
                            + "</div>" 
                            + "</div>" 
                            + "<div class='control-group'>" 
                            + "<label class='control-label'>备注:</label>" 
                            + "<div class='controls'>" 
                            + "<textarea id='remarks' style='width: 250px; height: 60px;'></textarea>" 
                            + "</div>" 
                            + "</div></div>", {
                                title: "[追加信息]",
                                submit: function() {
                                    var jl = top.$("#jl").val();
                                    var weight = top.$("#weight").val();
                                    var remarks = top.$("#remarks").val();
                                    var decimal = /^[0-9]+([\.][0-9]{0,3})?$/;
                                    if (jl != '') {
                                        if (!decimal.test(jl)) {
                                            top.$.jBox.tip('请输入正确的奖励金额(格式:xx.xx)');
                                            return false;
                                        }
                                    }
                                    if (weight != '') {
                                        if (!decimal.test(weight)) {
                                            top.$.jBox.tip('请输入正确的权重(格式:xx.xx)');
                                            return false;
                                        }
                                    }
                                    saveAdditionalProperty(bookId, [{
                                        key: 'jl',
                                        value: jl,
                                        type: 'S'
                                    },
                                    {
                                        key: 'weight',
                                        value: weight,
                                        type: 'S'
                                    },
                                    {
                                        key: 'remarks',
                                        value: remarks,
                                        type: 'S'
                                    }], taskId, [{
                                        key: 'kjDeptPass',
                                        value: true,
                                        type: 'B'
                                    }]);
                                }
                            });
                            //驳回
                        } else if (v == "no") {
                            top.$.jBox("<div style='padding:10px;'><textarea id='kjDeptBackReason' style='width: 250px; height: 60px;'></textarea></div>", {
                                title: "请填写打回理由",
                                submit: function() {
                                    var kjDeptBackReason = top.$("#kjDeptBackReason").val();
                                    //必须填写驳回理由
                                    if ($.trim(kjDeptBackReason) == "") {
                                        top.$.jBox.error('请填写打回理由', '错误');
                                        return false;
                                    } else {
                                        complete(taskId, [{
                                            key: 'kjDeptPass',
                                            value: false,
                                            type: 'B'
                                        },
                                        {
                                            key: 'kjDeptBackReason',
                                            value: kjDeptBackReason,
                                            type: 'S'
                                        }]);
                                    }
                                }
                            });
                        }

                    }
                });
            });
        }
        //调整申请
        if (tkey == "modifyApply") {
            bookForm.action = "${ctx}/oa/book/formModify/" + bookId + "/" + taskId;
            bookForm.submit();
        }
    })
});

function saveAdditionalProperty(bookId, variables, taskId, taskVariables) {
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
    $.post('${ctx}/oa/book/complete/' + bookId, {
        keys: keys,
        values: values,
        types: types
    },
    function(resp) {
        if (resp == 'success') {
            complete(taskId, taskVariables);
        } else {
            top.$.jBox.tip('操作失败!');
        }
    });
}

function complete(taskId, variables) {
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
            values += this.value;
            types += this.type;
        });
    }
    var jsonData = JSON.stringify(variables);
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
<script type="text/template" id="auditTemplate">
		<div style="overflow-y:auto; height:400px;">
		<table class="table table-striped ">
			<tr>
				<td width="100px;">申请人：</td>
				<td>{{user.name}}</td>
			</tr>
			<tr>
				<td>所属科室：</td>
				<td>{{officeName}}</td>
			</tr>
			<tr>
				<td>著作题目：</td>
				<td><a href="${ctx}/oa/book/get/{{id}}" target='_blank'>{{title}}</a></td>
			</tr>
			<tr>
				<td>作者：</td>
				<td>{{author1DisplayName}}</td>
			</tr>
			<tr>
				<td>权属：</td>
				<td>{{weightBelongDisplayName}}</td>
			</tr>
			<tr>
				<td>出版社：</td>
				<td>{{publisher}}</td>
			</tr>
			<tr>
				<td>书刊号：</td>
				<td>{{number}}</td>
			</tr>
			<tr>
				<td>年限：</td>
				<td>{{time}}</td>
			</tr>
			<tr>
				<td>备注：</td>
				<td>{{remarks}}</td>
			</tr>
		</table>
		</div>
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/oa/book/form">著作登记</a></li>
		<li><a href="${ctx}/oa/book/list">所有任务</a></li>
		<li class="active"><a href="${ctx}/oa/book/task">待办任务</a></li>
	</ul>
	<form:form id="bookForm" modelAttribute="book" action="" method="post" class="breadcrumb form-search">
	</form:form>
	<tags:message content="${message}" />
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<tr>
			<th>著作题目</th>
			<th>申请人</th>
			<th>申请时间</th>
			<th>当前节点</th>
			<th>任务创建时间</th>
			<th>流程状态</th>
			<th>操作</th>
		</tr>
		<tbody>
			<c:forEach items="${book}" var="book">
				<c:set var="task" value="${book.task}" />
				<c:set var="pi" value="${book.processInstance}" />
				<tr id="${book.id }" tid="${task.id}">
					<td>${book.title}</td>
					<td>${book.user.name}</td>
					<td><fmt:formatDate value="${book.createDate}" type="both" /></td>
					<td>${task.name}</td>
					<td><fmt:formatDate value="${task.createTime}" type="both" /></td>
					<td>${pi.suspended ? "已挂起" : "正常" }；<b title='流程版本号'>V: ${book.processDefinition.version}</b></td>
					<td><a class="handle" href="#" data-tkey="${task.taskDefinitionKey}" data-tname="${task.name}"
						data-id="${book.id}" data-tid="${task.id}">办理</a></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
</html>
