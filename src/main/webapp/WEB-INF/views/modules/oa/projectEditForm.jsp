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
<style type="text/css">
	#level-controls label{display: inline-block;}
</style>
<script type="text/javascript">
$(document).ready(function() {
    $("#name").focus();
    $("#uploaded-files").hide();
    $("#level-controls input[type=checkbox]").change(function() {
        var sportSelect = document.getElementsByName('levelList' ),
            maxNums   = 3;
        for(var i in sportSelect){
            sportSelect[i]. onclick = function (){
                var _sportSelect = document.getElementsByName('levelList' ),
                    cNums = 0;
                for(var i in _sportSelect){
                    if(i == 'length') break ;
                    if(_sportSelect[i].checked){
                        cNums ++;
                    }
                }
                if(cNums > maxNums){
                    this.checked = false;
                    alert('最多只能选择三项');
                }
            }
        }
    });
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
function saveAndSubmitProject() {
    $("#inputForm").attr("action", "${ctx}/oa/project/saveAndSubmitProject");
    $("#inputForm").submit();
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
		<%--<li><a href="${ctx}/oa/project/form">科研项目登记</a></li>--%>
		<li class="active"><a href="${ctx}/oa/project/editform">项目编辑</a></li>
		<li><a href="${ctx}/oa/project/list">所有任务</a></li>
		<li><a href="${ctx}/oa/project/task">待办任务</a></li>
	</ul>
	<br />
	<form:form id="inputForm" modelAttribute="project" action="${ctx}/oa/project/edit" method="post"
		class="form-horizontal">
		<form:hidden path="id" id="projectId" />
		<input type="hidden" id="taskId" value="${taskId}" />
		<tags:message content="${message}" />
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
				<label class="control-label">权属：</label>
				<div class="controls">
					<input id="weightBelong" name="weightBelong" value="${project.weightBelong}" maxlength="200" class="input-large"
						type="hidden" />
					<form:input path="weightBelongDisplayName" maxlength="200" class="input-large" readonly="true"/>

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
				<div class="controls" id="level-controls">
					<%--<form:select path="level">
						<form:options items="${fns:getDictList('project_level')}" itemLabel="label" itemValue="value" htmlEscape="false" />
					</form:select>--%>
					<form:checkboxes path="levelList" items="${fns:getDictList('project_level')}" itemLabel="label" itemValue="value" class="required" htmlEscape="false"/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">附件上传:</label>
					<div class="controls">
						已上传文件：<a href="${ctx}/oa/project/get/${project.id}">${project.file}</a>
					</div>
				<div class="controls">
					<input id="file" name="file" type="hidden" value="${project.file}" /> <input id="fileupload" type="file"
						name="files[]" data-url="${ctx}/oa/project/upload/project">
				</div>
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
		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存" />&nbsp;
			<input id="btnSaveSubmit" class="btn btn-primary" onclick="saveAndSubmitProject()" type="submit" value="保存并提交" />&nbsp;
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)" />
		</div>
		</form:form>
	<form:form id="redirectForm" />
</body>
</html>
