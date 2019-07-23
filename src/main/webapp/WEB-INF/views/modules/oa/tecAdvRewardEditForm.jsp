<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>院重大实用领先技术奖登记管理</title>
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
            one: {
                range: [0, 30]
            },
            two: {
                range: [0, 20]
            },
            three: {
                range: [0, 20]
            },
            four: {
                range: [0, 15]
            },
            five: {
                range: [0, 15]
            }
        },
        messages: {
            one: {
                range: "请输入0-30内的整数。"
            },
            two: {
                range: "请输入0-20内的整数。"
            },
            three: {
                range: "请输入0-20内的整数。"
            },
            four: {
                range: "请输入0-15内的整数。"
            },
            five: {
                range: "请输入0-15内的整数。"
            }
        }
    });
});

function saveAdditionalProperty(rewardId, variables, taskId, taskVariables) {
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
    $.post('${ctx}/oa/tecAdvReward/complete/' + rewardId, {
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
function reSubmit(reApply) {
    var taskId = $('#taskId').val();
    var rewardId = $('#rewardId').val();
    complete(taskId, [{
        key: 'reApply',
        value: reApply,
        type: 'B'
    },
    {
        key: 'rewardName',
        value: $('#rewardName').val(),
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
        value: $('#weightBelongId').val(),
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
        key: 'grade',
        value: $('#grade').val(),
        type: 'S'
    },
    {
        key: 'level',
        value: $('#level').val(),
        type: 'S'
    },
    {
        key: 'year',
        value: $('#year').val(),
        type: 'S'
    },
    {
        key: 'caseCountFirst',
        value: $('#caseCountFirst').val(),
        type: 'S'
    },
    {
        key: 'caseCountSecond',
        value: $('#caseCountSecond').val(),
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
	$.getJSON("${ctx}/oa/tecAdvReward/detail/" + dataId,
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

function pass(kjDeptPass) {
    var taskId = $('#taskId').val();
    var rewardId = $('#rewardId').val();
    saveAdditionalProperty(rewardId, [{
        key: 'year',
        value: $('#year').val(),
        type: 'S'
    },
    {
        key: 'approvalOrg',
        value: $('#approvalOrg').val(),
        type: 'S'
    },
    {
        key: 'grade',
        value: $('#grade').val(),
        type: 'S'
    },
    {
        key: 'level',
        value: $('#level').val(),
        type: 'S'
    },
    {
        key: 'xb_fee',
        value: $('#xb_fee').val(),
        type: 'S'
    },
    {
        key: 'caseCountFirst',
        value: $('#caseCountFirst').val(),
        type: 'S'
    },
    {
        key: 'jlFirst',
        value: $('#jlFirst').val(),
        type: 'S'
    },
    {
        key: 'caseCountSecond',
        value: $('#caseCountSecond').val(),
        type: 'S'
    },
    {
        key: 'jlSecond',
        value: $('#jlSecond').val(),
        type: 'S'
    },
    {
        key: 'jlSecond',
        value: $('#jlSecond').val(),
        type: 'S'
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

function save() {
    $("#checkForm").attr("action", "${ctx}/oa/tecAdvReward/saveRewardToUser");
    $("#checkForm").submit();
}

function saveAndSubmit() {
    $("#checkForm").attr("action", "${ctx}/oa/tecAdvReward/submitRewardToUser");
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
            redirectForm.action = "${ctx}/oa/tecAdvReward";
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
				<td>先进性及复杂性：</td>
				<td>{{one}}</td>
			</tr>
			<tr>
				<td>先进性：</td>
				<td>{{two}}</td>
			</tr>
			<tr>
				<td>实用性：</td>
				<td>{{three}}</td>
			</tr>
			<tr>
				<td>经济效益：</td>
				<td>{{four}}</td>
			</tr>
			<tr>
				<td>社会效益：</td>
				<td>{{five}}</td>
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
			<li><a href="${ctx}/oa/tecAdvReward/form">院重大实用领先技术奖登记</a></li>
			<li class="active"><a href="${ctx}/oa/tecAdvReward/editform">院重大实用领先技术奖编辑</a></li>
		<li><a href="${ctx}/oa/tecAdvReward/list">所有任务</a></li>
		<li><a href="${ctx}/oa/tecAdvReward/task">待办任务</a></li>
	</ul>
	<br />
	<form:form id="inputForm" modelAttribute="reward" action="${ctx}/oa/tecAdvReward/edit" method="post"
		class="form-horizontal">
		<form:hidden path="id" id="rewardId" />
		<input type="hidden" id="taskId" value="${taskId}" />
		<tags:message content="${message}" />
			<div class="control-group">
				<label class="control-label"><font color='red'>*</font>院重大实用领先技术奖:</label>
				<div class="controls">
					<form:input path="rewardName" htmlEscape="false" maxlength="200" class="input-xxlarge required" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">第一完成人：</label>
				<div class="controls">
					<tags:nameSuggest value="${reward.author1}"
						labelValue="${reward.author1DisplayName}" name="author1" id="author1" url="${ctx}/sys/user/users/"></tags:nameSuggest>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">第二完成人：</label>
				<div class="controls">
					<tags:nameSuggest value="${reward.author2}" labelValue="${reward.author2DisplayName}" name="author2" id="author2"
						url="${ctx}/sys/user/users/"></tags:nameSuggest>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">第三完成人：</label>
				<div class="controls">
					<tags:nameSuggest value="${reward.author3}" labelValue="${reward.author3DisplayName}" name="author3" id="author3"
						url="${ctx}/sys/user/users/"></tags:nameSuggest>
				</div>
			</div>
			<div class='control-group'>
				<label class='control-label'>申请年份:</label>
				<div class='controls'>
					<form:input name="year" path="year" htmlEscape="false" maxlength="20"
					class="input-medium annual_volume" onclick="WdatePicker({dateFmt:'yyyy',isShowClear:false});"/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label"><font color='red'>*</font>权属：</label>
				<div class="controls">
					<tags:nameSuggest value="${reward.weightBelong}" cssClass="required" labelValue="${reward.weightBelongDisplayName}"
						name="weightBelong" id="weightBelong" url="${ctx}/sys/user/users/"></tags:nameSuggest>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label"><font color='red'>*</font>所属科室：</label>
				<div class="controls">
					<tags:treeselect id="office" name="office.id" value="${reward.office.id}" labelName="office.name"
						labelValue="${reward.office.name}" title="科室" url="/sys/office/treeData?type=2" cssClass="required"
						notAllowSelectParent="true" />
				</div>
			</div>
		<div class="control-group">
			<label class="control-label">关联项目：</label>
			<div class="controls">
				<form:select path="project.id">
					<form:option value=""></form:option>
					<c:forEach items="${projectList}" var="project">
						<c:if test="${project.id eq selectedId}">
							<form:option value="${project.id}" selected="selected">${project.projectName}</form:option>
						</c:if>
						<c:if test="${project.id != selectedId}">
							<form:option value="${project.id}">${project.projectName }</form:option>
						</c:if>
					</c:forEach>
				</form:select>
			</div>
		</div>
			<div class="control-group">
				<label class="control-label">专业：</label>
				<div class="controls">
					<form:input id="profession" path="profession" htmlEscape="false" maxlength="200" class="input-large" />
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">申请类别:</label>
				<div class="controls">
					<form:select path="grade" id="grade">
						<form:options items="${fns:getDictList('reward_gradetech')}" itemLabel="label" itemValue="value" htmlEscape="false" />
					</form:select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">申请等级:</label>
				<div class="controls">
					<form:select path="level" id="level">
						<form:options items="${fns:getDictList('reward_level')}" itemLabel="label" itemValue="value" htmlEscape="false" />
					</form:select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">附件上传:</label>
					<div class="controls">
						已上传文件：<a href="${ctx}/oa/tecAdvReward/get/${reward.id}">${reward.file}</a>
					</div>
				<div class="controls">
					<input id="file" name="file" type="hidden" value="${reward.file}" /> <input id="fileupload" type="file"
						name="files[]" data-url="${ctx}/oa/tecAdvReward/upload/reward">
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
				<label class="control-label">备注：</label>
				<div class="controls">
					<form:textarea path="remarks" rows="5" maxlength="20" />
				</div>
			</div>
			<div class="form-actions">
				<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存" />&nbsp;
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)" />
			</div>
		</form:form>
	<form:form id="redirectForm" method="post"></form:form>
</body>
</html>
