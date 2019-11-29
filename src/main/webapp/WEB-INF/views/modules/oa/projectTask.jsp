<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>科研项目登记办理</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
$(document).ready(function() {
    $("#projectForm").validate({
        submitHandler: function(form) {
            loading('正在提交，请稍等...');
            form.submit();
        },
        errorContainer: "#messageBox",
        errorPlacement: function(error, element) {
            $("#messageBox").text("输入有误，请先更正。");
            if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                error.appendTo(element.parent().parent());
            } else {
                error.insertAfter(element);
            }
        }
    });
    $("#assignForm").validate({
        submitHandler: function(form) {
            loading('正在提交，请稍等...');
            form.submit();
        },
        errorContainer: "#messageBox",
        errorPlacement: function(error, element) {
            $("#messageBox").text("输入有误，请先更正。");
            if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                error.appendTo(element.parent().parent());
            } else {
                error.insertAfter(element);
            }
        }
    });
    $("#lxForm").validate({
        submitHandler: function(form) {
            loading('正在提交，请稍等...');
            form.submit();
        },
        errorContainer: "#messageBox",
        errorPlacement: function(error, element) {
            $("#messageBox").text("输入有误，请先更正。");
            if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                error.appendTo(element.parent().parent());
            } else {
                error.insertAfter(element);
            }
        }
    });

    $(".handle").click(function() {
        var obj = $(this);
        var taskId = obj.data("tid");
        var projectId = obj.data("id");
        var tkey = obj.data("tkey");
        //科教科领导审批
        if (tkey == "deptLeaderAudit") {
            $.getJSON("${ctx}/oa/project/detail/" + projectId+"?time="+new Date().getTime(),
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
            $.getJSON("${ctx}/oa/project/detail/" + projectId+"?time="+new Date().getTime(),
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
                        	saveAdditionalProperty(projectId, [], taskId, [{
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
        if (tkey == "lxAudit") {
            $.getJSON("${ctx}/oa/project/detail/" + projectId+"?time="+new Date().getTime(),
            function(data) {
                var html = Mustache.render($("#lxAuditTemplate").html(), data);
                top.$.jBox(html, {
                    title: "流程办理[" + obj.data("tname") + "]",
                    buttons: {
                        "立项并追加信息": "yes",
                        "立项失败": "no",
                        "取消": "cancel"
                    },
                    submit: function(v, h, f) {
                        //同意
                        if (v == "yes") {
                            top.$.jBox("<div style='padding:10px;'>" + "<div>"+ "<div>" + "<label >立项编号:</label>"  + "<input id='projectNo' name='projectNo' type='text' />" + "</div>" + "</div>" 
                            +"<div >"  + "<div >" + "<label >立项单位:</label>" + "<input id='approvalOrg' name='approvalOrg' type='text' />" + "</div>" + "</div>"
                            +"<div >"  + "<div >" + "<label >开始时间:</label>" + "<input id=\"startDate\" name=\"startDate\" type=\"text\"\ maxlength=\"20\" class=\"input-medium Wdate\" value=\"${startDate}\" onclick=\"WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});\"/>" + "</div>" + "</div>" 
                            +"<div >"  + "<div >" + "<label >结束时间:</label>"  + "<input id=\"endDate\" name=\"endDate\" type=\"text\"\ maxlength=\"20\" class=\"input-medium Wdate\" value=\"${endDate}\" onclick=\"WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});\"/>" + "</div>" + "</div>" 
                            +"<div >"  + "<div >"+ "<label >绩效年份:</label>"  + "<input id=\"auditDate\" name=\"auditDate\" type=\"text\"\ maxlength=\"20\" class=\"input-medium Wdate\" value=\"${auditDate}\" onclick=\"WdatePicker({dateFmt:'yyyy',isShowClear:false});\"/>" + "</div>" + "</div>" 
                            + "<div class='control-group'>" + "<div class='controls'>"+ "<label class='control-label'>权重:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>"+  "<input id='weight' name='weight' type='text' class='number'/>"+ "</div>"+ "</div>" 
                            +"<div >"  + "<div >"+ "<label >下拨经费:</label>"  + "<input id='xb_fee' name='xb_fee' type='text' class='number'/>" + "</div>" + "</div>" 
                            + "<div >" + "<div >"+ "<label >配套经费:</label>"  + "<input id='pt_fee' name='pt_fee' type='text' class='number'/>" + "</div>" + "</div>" 
                            + "<div >"+ "<div >" + "<label >实到经费:</label>"  + "<input id='sd_fee' name='sd_fee' type='text' class='number'/>" + "</div>" + "</div>"
                            +"<div >" + "<div >"  + "<label >项目等级:</label>"+ "<select id='level' name='level'>" + "<c:forEach items='${fns:getDictList("project_level")}' var='level'>" + "<option value=\"${level.value}\">${level.label}</option>" + "</c:forEach>" + "</select>" + "</div>" + "</div>" + "<div >" + "<div >"+ "<label >备&nbsp;&nbsp;&nbsp;&nbsp;注&nbsp;&nbsp;:</label>"  + "<textarea id='remarks' style='width: 250px; height: 60px;'></textarea>" + "</div>" + "</div>" + "</div>", {
                                title: "[追加信息]",
                                submit: function() {
                                    var projectNo = top.$("#projectNo").val();
                                    var approvalOrg = top.$("#approvalOrg").val();
                                    var startDate = top.$("#startDate").val();
                                    var endDate = top.$("#endDate").val();
                                    var auditDate = top.$("#auditDate").val();
                                    var weight = $.trim(top.$("#weight").val());
                                    var xb_fee = $.trim(top.$("#xb_fee").val());
                                    var pt_fee = $.trim(top.$("#pt_fee").val());
                                    var sd_fee = $.trim(top.$("#sd_fee").val());
                                    var remarks = top.$("#remarks").val();
                                    var level = top.$("#level").val();
                                    var decimal = /^[0-9]+([\.][0-9]{0,3})?$/;
                                    if (xb_fee != '') {
                                        if (!decimal.test(xb_fee)) {
                                            top.$.jBox.tip('请输入正确的下拨金额');
                                            return false;
                                        }
                                    }
                                    if (sd_fee != '') {
                                        if (!decimal.test(sd_fee)) {
                                            top.$.jBox.tip('请输入正确的实到金额');
                                            return false;
                                        }
                                    }
                                    if (pt_fee != '') {
                                        if (!decimal.test(pt_fee)) {
                                            top.$.jBox.tip('请输入正确的配套金额');
                                            return false;
                                        }
                                    }
                                    if (weight != '') {
                                        if (!decimal.test(weight)) {
                                            top.$.jBox.tip('请输入数字');
                                            return false;
                                        }
                                    }
                                    saveAdditionalProperty(projectId, [{
                                        key: 'projectNo',
                                        value: projectNo,
                                        type: 'S'
                                    },
                                    {
                                        key: 'approvalOrg',
                                        value: approvalOrg,
                                        type: 'S'
                                    },
                                    {
                                        key: 'startDate',
                                        value: startDate,
                                        type: 'S'
                                    },
                                    {
                                        key: 'endDate',
                                        value: endDate,
                                        type: 'S'
                                    },
                                    {
                                        key: 'level',
                                        value: level,
                                        type: 'S'
                                    },
                                    {
                                        key: 'weight',
                                        value: weight,
                                        type: 'S'
                                    },
                                    {
                                        key: 'xb_fee',
                                        value: xb_fee,
                                        type: 'S'
                                    },
                                    {
                                        key: 'sd_fee',
                                        value: sd_fee,
                                        type: 'S'
                                    },
                                    {
                                        key: 'pt_fee',
                                        value: pt_fee,
                                        type: 'S'
                                    },
                                    {
                                        key: 'auditDate',
                                        value: auditDate,
                                        type: 'S'
                                    },
                                    {
                                        key: 'remarks',
                                        value: remarks,
                                        type: 'S'
                                    },
                                    {
                                        key: 'lxSuccess',
                                        value: true,
                                        type: 'B'
                                    }], taskId, [{
                                        key: 'kjDeptPass',
                                        value: true,
                                        type: 'B'
                                    }]);
                                }
                            });
                            top.$("#projectNo").val(data.projectNo);
                            top.$("#approvalOrg").val(data.approvalOrg);
                            top.$("#startDate").val(data.startDate);
                            top.$("#endDate").val(data.endDate);
                            top.$("#xb_fee").val(data.xb_fee);
                            top.$("#sd_fee").val(data.sd_fee);
                            top.$("#pt_fee").val(data.pt_fee);
                            top.$("#level").val(data.level);
                            top.$("#weight").val(data.weight);
                            //驳回
                        } else if (v == "no") {
                            top.$.jBox("<div style='padding:10px;'><textarea id='kjDeptBackReason' style='width: 250px; height: 60px;'></textarea></div>", {
                                title: "请填写立项失败的理由",
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
        	redirectForm.action = "${ctx}/oa/project/formModify/" + projectId + "/" + taskId;
        	redirectForm.submit();
        }
        //院内评审
        if (tkey == "hosAudit") {
        	redirectForm.action = "${ctx}/oa/project/formAudit/" + projectId + "/" + taskId;
        	redirectForm.submit();
        }
        //院内专家审核
        if (tkey == "assignCheck") {
        	redirectForm.action = "${ctx}/oa/project/forAudit/" + projectId;
        	redirectForm.submit();
        }
    });
});

function saveAdditionalProperty(projectId, variables, taskId, taskVariables) {
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
    $.post('${ctx}/oa/project/complete/' + projectId, {
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

function assign() {
    var Check = $("#assignForm table input[type=checkbox]:checked");
    if (Check.length > 0) {
        $("#assignForm").attr("action", "${ctx}/oa/project/assign");
        $("#assignForm").submit();
    } else {
        top.$.jBox.tip('请先勾选需要评审的项目!');
    }
}

function editStatus() {
    $("#lxForm").attr("action", "${ctx}/oa/project/editStatus");
    $("#lxForm").submit();
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
            if (this.value == "") {
                values += " ";
            } else {
                values += this.value;
            }
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
				<td>科研项目题目：</td>
				<td><a href="${ctx}/oa/project/get/{{id}}" target='_blank'>{{projectName}}</a></td>
			</tr>
			<tr>
				<td>第一责任人：</td>
				<td>{{author1DisplayName}}</td>
			</tr>
			<tr>
				<td>第二责任人：</td>
				<td>{{author2DisplayName}}</td>
			</tr>
			<tr>
				<td>第三责任人：</td>
				<td>{{author3DisplayName}}</td>
			</tr>
			<tr>
				<td>权属：</td>
				<td>{{weightBelongDisplayName}}</td>
			</tr>
			<tr>
				<td>所属科室：</td>
				<td>{{officeName}}</td>
			</tr>
			<tr>
				<td>申请等级：</td>
				<td>{{level}}</td>
			</tr>
			<tr>
				<td>备注：</td>
				<td>{{remarks}}</td>
			</tr>
		</table>
		</div>
</script>

<script type="text/template" id="lxAuditTemplate">
		<div style="overflow-y:auto; height:400px;">
		<table class="table table-striped ">
			<tr>
				<td width="100px;">申请人：</td>
				<td>{{user.name}}</td>
			</tr>
			<tr>
				<td>科研项目题目：</td>
				<td><a href="${ctx}/oa/project/get/{{id}}" target='_blank'>{{projectName}}</a></td>
			</tr>
			<tr>
				<td>第一责任人：</td>
				<td>{{author1DisplayName}}</td>
			</tr>
			<tr>
				<td>第二责任人：</td>
				<td>{{author2DisplayName}}</td>
			</tr>
			<tr>
				<td>第三责任人：</td>
				<td>{{author3DisplayName}}</td>
			</tr>
			<tr>
				<td>权属：</td>
				<td>{{weightBelongDisplayName}}</td>
			</tr>
			<tr>
				<td>所属科室：</td>
				<td>{{officeName}}</td>
			</tr>
			<tr>
				<td>立项单位：</td>
				<td>{{approvalOrg}}</td>
			</tr>
			<tr>
				<td>开始时间：</td>
				<td>{{startDate}}</td>
			</tr>
			<tr>
				<td>结束时间：</td>
				<td>{{endDate}}</td>
			</tr>
			<tr>
				<td>申请等级：</td>
				<td>{{level}}</td>
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
		<li><a href="${ctx}/oa/project/list">科研项目管理</a></li>
		<li class="active"><a href="${ctx}/oa/project/task">待办任务</a></li>
		<shiro:hasPermission name="oa:project:edit">
			<li><a href="${ctx}/oa/project/form">申报</a></li>
		</shiro:hasPermission>
	</ul>
	<tags:message content="${message}" />
	
		<c:if
			test="${!empty projectModel.kjkAuditProjects or (empty projectModel.hosAuditProjects and empty projectModel.lxAuditProjects) }">
			<form:form id="projectForm" modelAttribute="projectModel" action="" method="post" class="breadcrumb">
			<table id="contentTable"
				class="table table-striped table-bordered table-condensed">
				<tr>
					<th>申请人</th>
					<th>申请时间</th>
					<th>科研项目题目：</th>
					<th>当前节点</th>
					<th>任务创建时间</th>
					<%--<th>流程状态</th>--%>
					<th>操作</th>
				</tr>
				<tbody>
					<c:forEach items="${projectModel.kjkAuditProjects}" var="project">
						<c:set var="task" value="${project.task}" />
						<c:set var="pi" value="${project.processInstance}" />
						<tr id="${project.id }">
							<td>${project.user.name}</td>
							<td><fmt:formatDate value="${project.createDate}"
									type="both" /></td>
							<c:if test="${empty project.file}">
								<td>${project.projectName}</td>
							</c:if>
							<c:if test="${not empty project.file}">
								<td><a href="${ctx}/oa/project/get/${project.id}" target='_blank'>${project.projectName}</a></td>
							</c:if>
							<td>${task.name}</td>
							<td><fmt:formatDate value="${task.createTime}" type="both" /></td>
							<%--<td>${pi.suspended ? "已挂起" : "正常" }；<b title='流程版本号'>V:
									${project.processDefinition.version}</b></td>--%>
							<td><a class="handle" href="#"
								data-tkey="${task.taskDefinitionKey}" data-tname="${task.name}"
								data-id="${project.id}" data-tid="${task.id}">办理</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			</form:form>
		</c:if>
		<c:if test="${!empty projectModel.hosAuditProjects}">
		<form:form id="assignForm" modelAttribute="projectModel" action="" method="post" class="breadcrumb">
			<div class="control-group">
				<label class="control-label"><font color='red'>*</font>分发院内专家评审：</label>
				<div class="controls">
					<tags:namesSuggest value="${projectModel.users}"
						cssClass="required" name="users" id="users"
						url="${ctx}/sys/user/users/"></tags:namesSuggest>
					&nbsp;<input id="btnStatus" class="btn" type="button"
						onclick="assign()" value="分发" />
				</div>
			</div>


			<table id="contentTable"
				class="table table-striped table-bordered table-condensed">
				<tr>
					<th></th>
					<th>申请人</th>
					<th>申请时间</th>
					<th>科研项目题目：</th>
					<th>当前节点</th>
					<th>任务创建时间</th>
					<th>专家评审进度</th>
					<th>操作</th>
				</tr>
				<tbody>
					<c:forEach items="${projectModel.hosAuditProjects}" var="project">
						<c:set var="task" value="${project.task}" />
						<c:set var="pi" value="${project.processInstance}" />
						<tr id="${project.id }">
							<td><form:checkbox class="required" path="hosProjectIds" value="${project.id}" /></td>
							<td>${project.user.name}</td>
							<td><fmt:formatDate value="${project.createDate}"
									type="both" /></td>
							<c:if test="${empty project.file}">
								<td>${project.projectName}</td>
							</c:if>
							<c:if test="${not empty project.file}">
								<td><a href="${ctx}/oa/project/get/${project.id}" target='_blank'>${project.projectName}</a></td>
							</c:if>
							<td>${task.name}</td>
							<td><fmt:formatDate value="${task.createTime}" type="both" /></td>
							<td>${project.checkedCount}/${project.assignCount}</td>
							<td><a class="handle" href="#"
								data-tkey="${task.taskDefinitionKey}" data-tname="${task.name}"
								data-id="${project.id}" data-tid="${task.id}">办理</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			</form:form>
		</c:if>
	
		<c:if test="${!empty projectModel.lxAuditProjects}">
		<form:form id="lxForm" modelAttribute="projectModel" action=""
		method="post" class="breadcrumb">
			<div class="control-group">
				<label class="control-label"><font color='red'>*</font>项目追踪：</label>
				<div class="controls">
					<form:input path="projectStatus" htmlEscape="false" maxlength="200" class="required"/>
					&nbsp;<input id="btnStatus" class="btn" type="button"
						onclick="editStatus()" value="修改" />
				</div>
			</div>

			<table id="contentTable"
				class="table table-striped table-bordered table-condensed">
				<tr>
					<th></th>
					<th>申请人</th>
					<th>申请时间</th>
					<th>科研项目题目：</th>
					<th>当前节点</th>
					<th>任务创建时间</th>
					<th>项目进度追踪</th>
					<th>操作</th>
				</tr>
				<tbody>
					<c:forEach items="${projectModel.lxAuditProjects}" var="project">
						<c:set var="task" value="${project.task}" />
						<c:set var="pi" value="${project.processInstance}" />
						<tr id="${project.id }">
							<td><form:checkbox class="required" path="lxProjectIds"
									value="${project.id}" /></td>
							<td>${project.user.name}</td>
							<td><fmt:formatDate value="${project.createDate}"
									type="both" /></td>
							<c:if test="${empty project.file}">
								<td>${project.projectName}</td>
							</c:if>
							<c:if test="${not empty project.file}">
								<td><a href="${ctx}/oa/project/get/${project.id}" target='_blank'>${project.projectName}</a></td>
							</c:if>
							<td>${task.name}</td>
							<td><fmt:formatDate value="${task.createTime}" type="both" /></td>
							<td>${project.processStatus}</td>
							<td><a class="handle" href="#"
								data-tkey="${task.taskDefinitionKey}" data-tname="${task.name}"
								data-id="${project.id}" data-tid="${task.id}">办理</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			</form:form>
		</c:if>

		<c:if test="${!empty projectModel.assignedProject}">
			<div class="control-group">
				<label class="control-label">待评审项目：</label>
			</div>
			<table id="contentTable"
				class="table table-striped table-bordered table-condensed">
				<tr>
					<%--<th>申请人</th>--%>
					<th>申请时间</th>
					<th>科研项目题目：</th>
					<th>当前节点</th>
					<th>任务创建时间</th>
					<th>评审进度</th>
					<th>详细内容</th>
				</tr>
				<tbody>
					<c:forEach items="${projectModel.assignedProject}" var="project">
						<c:set var="task" value="${project.task}" />
						<c:set var="pi" value="${project.processInstance}" />
						<tr id="${project.id }">
							<%--<td>${project.user.name}</td>--%>
							<td><fmt:formatDate value="${project.createDate}"
									type="both" /></td>
							<c:if test="${empty project.file}">
								<td>${project.projectName}</td>
							</c:if>
							<c:if test="${not empty project.file}">
								<td><a href="${ctx}/oa/project/get/${project.id}" target='_blank'>${project.projectName}</a></td>
							</c:if>
							<td>${task.name}</td>
							<td><fmt:formatDate value="${task.createTime}" type="both" /></td>
							<td>${project.checkedCount}/${project.assignCount}</td>
							<td><a class="handle" href="#" data-tkey="assignCheck"
								data-tname="${task.name}" data-id="${project.id}"
								data-tid="${task.id}">审核</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
		<form:form id="redirectForm" />
</body>
</html>
