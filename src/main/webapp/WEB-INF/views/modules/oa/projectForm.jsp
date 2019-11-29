<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>科研项目登记管理</title>
<meta name="decorator" content="default" />
<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/vendor/jquery.ui.widget.js"></script>
<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/jquery.iframe-transport.js"></script>
<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/jquery.fileupload.js"></script>
<script src="${ctxStatic}/bootstrap/2.3.1/js/bootstrap.min.js"></script>
<link href="${ctxStatic}/bootstrap/2.3.1/css_default/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="${ctxStatic}/common/dropzone.css" type="text/css" rel="stylesheet" />
<script src="${ctxStatic}/common/myuploadfunction.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    $("#name").focus();
    $("#uploaded-files").hide();
    $("#inputForm").validate({
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
    $("#checkForm").validate({
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
        },
        rules: {
            creativity: {
                range: [0, 30]
            },
            advancement: {
                range: [0, 25]
            },
            scientificity: {
                range: [0, 20]
            },
            feasibility: {
                range: [0, 15]
            },
            practicability: {
                range: [0, 10]
            }
        },
        messages: {
            creativity: {
                range: "请输入0-30内的整数。"
            },
            advancement: {
                range: "请输入0-25内的整数。"
            },
            scientificity: {
                range: "请输入0-20内的整数。"
            },
            feasibility: {
                range: "请输入0-15内的整数。"
            },
            practicability: {
                range: "请输入0-10内的整数。"
            }
        }
    });
});

function reSubmit(reApply) {
    var taskId = $('#taskId').val();
    var projectId = $('#projectId').val();
    complete(taskId, [{
        key: 'reApply',
        value: reApply,
        type: 'B'
    },
    {
        key: 'projectName',
        value: $('#projectName').val(),
        type: 'S'
    },
    {
        key: 'author1',
        value: $('#author1Id').val(),
        type: 'S'
    },
    {
        key: 'author2',
        value: $('#author2Id').val(),
        type: 'S'
    },
    {
        key: 'author3',
        value: $('#author3Id').val(),
        type: 'S'
    },
    {
        key: 'weightBelong',
        value: $('#weightBelong').val(),
        type: 'S'
    },
    {
        key: 'officeName',
        value: $('#officeId').val(),
        type: 'S'
    },
    {
        key: 'profession',
        value: $('#profession').val(),
        type: 'S'
    },
    {
        key: 'level',
        value: $('#level').val(),
        type: 'S'
    },
    {
        key: 'file',
        value: $('#file').val(),
        type: 'S'
    },
    {
        key: 'remarks',
        value: $('#remarks').val(),
        type: 'S'
    }]);
}


function showDetails(dataId) {
	$.getJSON("${ctx}/oa/project/detail/" + dataId,
            function(data) {
                var html = Mustache.render($("#details").html(), data);
                top.$.jBox(html, {
                    title: "",
                    buttons: {
                        "取消": "cancel"
                    }
                })
	});
}

function reject() {
    var taskId = $('#taskId').val();
    complete(taskId, [{
        key: 'kjDeptFailed',
        value: false,
        type: 'B'
    },{
        key: 'kjDeptPass',
        value: false,
        type: 'B'
    }
    ]);
}

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

function pass(kjDeptPass) {
    var taskId = $('#taskId').val();
    var projectId = $('#projectId').val();
    saveAdditionalProperty(projectId, [{
        key: 'projectNo',
        value: $('#projectNo').val(),
        type: 'S'
    },
    {
        key: 'approvalOrg',
        value: $('#approvalOrg').val(),
        type: 'S'
    },
    {
        key: 'startDate',
        value: $('#startDate').val(),
        type: 'S'
    },
    {
        key: 'endDate',
        value:  $('#endDate').val(),
        type: 'S'
    },
    {
        key: 'pass',
        value: kjDeptPass,
        type: 'B'
    },
    {
        key: 'processStatus',
        value: $('#processStatus').val(),
        type: 'S'
    }], taskId, [{
        key: 'kjDeptPass',
        value: kjDeptPass,
        type: 'B'
    }]);
}
function deleteTr(nowTr){
    var fileNames ="";
    $(nowTr).parent().parent().remove();
    $.each($("#uploaded-files [name=fileName]"),function () {
        fileNames += $(this).text() + ",";
    })
    if(fileNames != ""){
        $("#file").val(fileNames.substring(0,fileNames.length-1));
    }
}
function save() {
    $("#checkForm").attr("action", "${ctx}/oa/project/saveProjectToUser");
    $("#checkForm").submit();
}

function saveAndSubmit() {
    $("#checkForm").attr("action", "${ctx}/oa/project/submitProjectToUser");
    $("#checkForm").submit();
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
            redirectForm.action = "${ctx}/oa/project";
            redirectForm.submit();
        } else {
            top.$.jBox.tip('操作失败!');
        }
    });
}
</script>

<script type="text/template" id="details">
		<div style="overflow-y:auto; height:400px;">
		<table class="table table-striped ">
			<tr>
				<td width="100px;">评审人：</td>
				<td>{{user.name}}</td>
			</tr>
			<tr>
				<td>创新性：</td>
				<td>{{creativity}}</td>
			</tr>
			<tr>
				<td>先进性：</td>
				<td>{{advancement}}</td>
			</tr>
			<tr>
				<td>科学性：</td>
				<td>{{scientificity}}</td>
			</tr>
			<tr>
				<td>可行性：</td>
				<td>{{feasibility}}</td>
			</tr>
			<tr>
				<td>实用性：</td>
				<td>{{practicability}}</td>
			</tr>
			<tr>
				<td>评审意见：</td>
				<td>{{remarks}}</td>
			</tr>
		</table>
		</div>
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/oa/project/list">科研项目管理</a></li>
		<li><a href="${ctx}/oa/project/task">待办任务</a></li>
		<shiro:hasPermission name="oa:project:edit">
			<li class="active"><a href="${ctx}/oa/project/form">申报</a></li>
		</shiro:hasPermission>
	</ul>
	<br />
	<form:form id="inputForm" modelAttribute="project" action="${ctx}/oa/project/save" method="post"
		class="form-horizontal">
		<form:hidden path="id" id="projectId" />
		<input type="hidden" id="taskId" value="${taskId}" />
		<tags:message content="${message}" />
		<c:if test="${form or modify}">
			<div class="control-group">
				<label class="control-label"><font color='red'>*</font>科研项目名称:</label>
				<div class="controls">
					<form:input path="projectName" htmlEscape="false" maxlength="200" class="input-xxlarge required" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label"><font color='red'>*</font>第一责任人：</label>
				<div class="controls">
					<tags:nameSuggest bindId="weightBelongDisplayName" bindValueId="weightBelong" value="${project.author1}"
						labelValue="${project.author1DisplayName}" name="author1" id="author1" url="${ctx}/sys/user/users/" cssClass="required"></tags:nameSuggest>
				</div>
			</div>
			<div class='control-group'>
				<label class='control-label'>第一责任人年龄:</label>
				<div class='controls'>
					<input id='firstAge' type='text' readonly="readonly"/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">第二责任人：</label>
				<div class="controls">
					<tags:nameSuggest value="${project.author2}" labelValue="${project.author2DisplayName}" name="author2" id="author2"
						url="${ctx}/sys/user/users/"></tags:nameSuggest>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">第三责任人：</label>
				<div class="controls">
					<tags:nameSuggest value="${project.author3}" labelValue="${project.author3DisplayName}" name="author3" id="author3"
						url="${ctx}/sys/user/users/"></tags:nameSuggest>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label"><font color='red'>*</font>权属：</label>
				<div class="controls">
					<input id="weightBelong" name="weightBelong" value="${project.weightBelong}" maxlength="200" class="input-large required"
						type="hidden" />
					<form:input path="weightBelongDisplayName" maxlength="200" class="input-large required" readonly="true"/>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label"><font color='red'>*</font>所属科室：</label>
				<div class="controls">
					<tags:treeselect id="office" name="office.id" value="${project.office.id}" labelName="office.name"
						labelValue="${project.office.name}" title="科室" url="/sys/office/treeData?type=2" cssClass="required"
						notAllowSelectParent="true" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">专业：</label>
				<div class="controls">
					<form:input id="profession" path="profession" htmlEscape="false" maxlength="200" class="input-large" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">申请等级:</label>
				<div class="controls">
					<form:select path="level" >
						<form:options items="${fns:getDictList('project_level')}" itemLabel="label" itemValue="value" htmlEscape="false" />
					</form:select>

				</div>
			</div>
			<div class="control-group">
				<label class="control-label">附件上传:</label>
				<c:if test="${modify or audit or forAudit}">
					<div class="controls">
						已上传文件：<a href="${ctx}/oa/project/get/${project.id}">${project.file}</a>
					</div>
				</c:if>
				<div class="controls">
					<input id="file" name="file" type="hidden" value="${project.file}" /><font color="red">(*最多上传4个附件)</font> <input id="fileupload" type="file"
						name="files[]" multiple="multiple" data-url="${ctx}/oa/project/upload/project">
				</div>
				<>
			</div>
			<div class="control-group">
				<div class="controls">
					<div id="progress" class="progress">
						<div class="bar" style="width: 0%;"></div>
					</div>
				</div>
				<div class="controls">
					<table id="uploaded-files" class="table">
						<tr>
							<th>文件名称</th>
							<th>文件大小</th>
							<th>文件类型</th>
							<th>操作</th>
						</tr>
					</table>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">项目简介：</label>
				<div class="controls">
					<form:textarea path="introduce" rows="5" style="width:500px;" maxlength="800" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">备注：</label>
				<div class="controls">
					<form:textarea path="remarks" rows="5" style="width:500px;" maxlength="20" />
				</div>
			</div>
			<c:if test="${modify eq true}">
				<div class="control-group">
					<label class="control-label">科教处意见：</label>
					<div class="controls">
						<textarea rows="5" readonly="readonly" maxlength="20">${kjDeptBackReason}</textarea>
					</div>
				</div>
			</c:if>
		</c:if>

		<c:if test="${audit eq true}">
			<div class="control-group">
				<label class="control-label">科研项目名称:</label>
				<div class="controls">
					<form:input path="projectName" htmlEscape="false" maxlength="200" class="input-xxlarge required" readonly="true" />
				</div>
			</div>
			<c:if test="${project.assignCount ne 0}">
				<div class="controls">
					<table id="contentTable" class="table table-striped table-bordered table-condensed width:50%">
						<tr>
							<th>评审专家</th>
							<th>评审时间</th>
							<th>创新性</th>
							<th>先进性</th>
							<th>科学性</th>
							<th>可行性</th>
							<th>实用性</th>
							<th>评审意见</th>
						</tr>
						<tbody>
							<c:forEach items="${project.projectToUser}" var="projectToUser">
								<tr onClick="showDetails(${projectToUser.id})">
									<td>${projectToUser.user.name}</td>
									<td><c:if test="${projectToUser.finished}">
											<fmt:formatDate value="${projectToUser.updateDate}" type="date" />
										</c:if></td>
									<td><c:if test="${projectToUser.finished}">${projectToUser.creativity}</c:if></td>
									<td><c:if test="${projectToUser.finished}">${projectToUser.advancement}</c:if></td>
									<td><c:if test="${projectToUser.finished}">${projectToUser.scientificity}</c:if></td>
									<td><c:if test="${projectToUser.finished}">${projectToUser.feasibility}</c:if></td>
									<td><c:if test="${projectToUser.finished}">${projectToUser.practicability}</c:if></td>
									<td style="overflow: hidden; word-wrap: normal; -ms-text-overflow: ellipsis;-o-text-overflow: ellipsis; text-overflow: ellipsis;" >
										<c:if test="${projectToUser.finished}">${projectToUser.remarks}</c:if>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>

				<hr>
			</c:if>
			<div class='control-group'>
				<label class='control-label'>立项编号:</label>
				<div class='controls'>
					<input id='projectNo' name='projectNo' type='text' />
				</div>
			</div>
			<div class='control-group'>
				<label class='control-label'>院内项目编号:</label>
				<div class='controls'>
					<input id='projectHospitalNo' name='projectHospitalNo' type='text' />
				</div>
			</div>
			<div class='control-group'>
				<label class='control-label'>立项单位:</label>
				<div class='controls'>
					<form:input id='approvalOrg' path='approvalOrg' type='text' />
				</div>
			</div>
			<div class='control-group'>
				<label class='control-label'>开始时间:</label>
				<div class='controls'>
					<input id="startDate" name="startDate" type="text" maxlength="20" class="input-medium Wdate" value="${startDate}"
						onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
				</div>
			</div>
			<div class='control-group'>
				<label class='control-label'>结束时间:</label>
				<div class='controls'>
					<input id="endDate" name="endDate" type="text" maxlength="20" class="input-medium Wdate" value="${endDate}"
						onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
				</div>
			</div>
			<div class='control-group'>
				<label class='control-label'>项目追踪:</label>
				<div class='controls'>
					<form:input id='processStatus' path='processStatus' type='text' />
				</div>
			</div>
		</c:if>
		<c:if test="${forAudit ne true}">
			<div class="form-actions">
				<c:if test="${form eq true}">
					<shiro:hasPermission name="oa:project:edit">
						<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存" />&nbsp;</shiro:hasPermission>
				</c:if>
				<c:if test="${modify eq true}">
					<input id="btnReSubmit" class="btn btn-primary" type="button" onClick="reSubmit(true)" value="重新申请" />&nbsp;</c:if>
				<c:if test="${modify eq true}">
					<input id="btnRefuseSubmit" class="btn btn-primary" type="button" onClick="reSubmit(false)" value="放弃申请" />&nbsp;</c:if>
				<c:if test="${audit eq true}">
					<input id="btnPassSubmit" class="btn btn-primary" type="button" onClick="pass(true)" value="通过" />&nbsp;</c:if>
				<c:if test="${audit eq true}">
					<input id="btnNotPassSubmit" class="btn " type="button" onClick="pass(false)" value="驳回" />&nbsp;</c:if>
				<input id="btnCancel" class="btn" type="button" value="返 回" onClick="history.go(-1)" />
			</div>
		</c:if>
	</form:form>

	<c:if test="${forAudit eq true}">
		<form:form id="checkForm" modelAttribute="projectToUser" action="${ctx}/oa/project/saveProjectToUser" method="post"
			class="form-horizontal">
			<form:hidden path="id" id="projectToUserId" />
			<form:hidden path="project.id" />
			<form:hidden path="user.id" />
			<div class='control-group'>
				<label class='control-label'>项目标题:</label>
				<div class='controls'>
					<form:input id='projectName' path='project.projectName' type='text' readonly="true" />
				</div>
			</div>
			<%--<div class="control-group">
				<label class="control-label">第一责任人：</label>
				<div class="controls">
					<form:input id='author1DisplayName' path='project.author1DisplayName' type='text' readonly="true" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">第二责任人：</label>
				<div class="controls">
					<form:input id='author2DisplayName' path='project.author2DisplayName' type='text' readonly="true" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">第三责任人：</label>
				<div class="controls">
					<form:input id='author3DisplayName' path='project.author3DisplayName' type='text' readonly="true" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">权属：</label>
				<div class="controls">
					<form:input id='weightBelongDisplayName' path='project.weightBelongDisplayName' type='text' readonly="true" />
				</div>
			</div>--%>
			<div class="control-group">
				<label class="control-label">所属科室：</label>
				<div class="controls">
					<form:input id='officeName' path='project.office.name' type='text' readonly="true" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">专业：</label>
				<div class="controls">
					<form:input id='profession' path='project.profession' type='text' readonly="true" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">申请等级:</label>
				<div class="controls">
					<form:input id='label' path='project.level' type='text' readonly="true" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">附件:</label>
				<div class="controls">
					<a href="${ctx}/oa/project/get/${project.id}">${project.file}</a>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">备注：</label>
				<div class="controls">
					<form:textarea path="project.remarks" rows="5" maxlength="20" readonly="true" />
				</div>
			</div>
			<hr>
			<div class="control-group">
				<label class="control-label">创新性：</label>
				<div class="controls">
					<form:input path="creativity" class="required digits" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">先进性：</label>
				<div class="controls">
					<form:input path="advancement" class="required digits" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">科学性：</label>
				<div class="controls">
					<form:input path="scientificity" class="required digits" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">可行性：</label>
				<div class="controls">
					<form:input path="feasibility" class="required digits" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">实用性：</label>
				<div class="controls">
					<form:input path="practicability" class="required digits" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">评审意见：</label>
				<div class="controls">
					<form:textarea path="remarks" rows="5" />
				</div>
			</div>
			<div class="form-actions">
				<input id="btnForAuditSubmit" class="btn" type="submit" value="保存" />&nbsp; <input id="btnForAuditSubmit"
					class="btn btn-primary" type="button" onclick="saveAndSubmit()" value="保存并提交" />&nbsp; <input id="btnCancel"
					class="btn" type="button" value="返 回" onclick="history.go(-1)" />
			</div>
		</form:form>
	</c:if>
	<form:form id="redirectForm" />
</body>
</html>
