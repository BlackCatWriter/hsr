<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>论文登记管理</title>
<meta name="decorator" content="default" />
<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/vendor/jquery.ui.widget.js"></script>
<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/jquery.iframe-transport.js"></script>
<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/jquery.fileupload.js"></script>
<script src="${ctxStatic}/bootstrap/2.3.1/js/bootstrap.min.js"></script>
<script src="${ctxStatic}/autocomplete/jquery.autocomplete.min.js"></script>
<link href="${ctxStatic}/autocomplete/jquery.autocomplete.css" type="text/css" rel="stylesheet" />
<link href="${ctxStatic}/common/dropzone.css" type="text/css" rel="stylesheet" />
<script src="${ctxStatic}/common/myuploadfunction.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    $("#uploaded-files").hide();
    $("#inputForm").validate({
        submitHandler: function(form) {
            cleanSuggestWords();
            loading('正在提交，请稍等...');
            form.submit();
        },
        errorContainer: "#messageBox",
        errorPlacement: function(error, element) {
            $("#messageBox").text("输入有误，请先更正。");
            if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append") || element.parent().is(".customerTag")) {
                error.appendTo(element.parent().parent());
            } else {
                error.insertAfter(element);
            }
        },
        rules: {
            title: {
                remote: {
                    url: "${ctx}/oa/thesis/checkTitle",
                    type: "post",
                    dataType: "json",
                    data: {
                        oldTitle: function() {
                            return $("#oldTitle").val();
                        }
                    }
                },
            }
        },
        messages: {
            title: {
                remote: "论文题目已存在!"
            }
        }
    });
    jQuery.validator.addMethod("annual_volume",
    function(value, element) {
        if (value == "") {
            return true;
        }
        var containsyear = /^.*[0-9]{4}.*$/;
        return (containsyear.test(value));
    },
    "年卷期必须包括年份信息");
    jQuery.validator.addMethod("ybm_fee",
    function(value, element) {
        if (value == "") {
            return true;
        }
        var decimal = /^[0-9]+([\.][0-9]{0,3})?$/;
        return (decimal.test(value));
    },
    "请输入正确的报销金额(格式:xx.xx)");
});
function cleanSuggestWords() {
    $("#co_authorkeyword").val('');
    $("#author1keyword").val('');
    $("#author2keyword").val('');
    $("#author3keyword").val('');
    $("#weightBelongkeyword").val('');
}

function rethesisSubmit(reApply) {
    var taskId = $('#taskId').val();
    complete(taskId, [{
        key: 'reApply',
        value: reApply,
        type: 'B'
    },
    {
        key: 'title',
        value: $('#title').val(),
        type: 'S'
    },
    {
        key: 'co_author',
        value: $('#co_authorId').val(),
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
        key: 'mag_name',
        value: $('#mag_name').val(),
        type: 'S'
    },
    {
        key: 'annual_volume',
        value: $('#annual_volume').val(),
        type: 'S'
    },
    {
        key: 'level',
        value: $('#level').val(),
        type: 'S'
    },
    {
        key: 'category',
        value: $('#category').val(),
        type: 'S'
    },
    {
        key: 'ybm_fee',
        value: $('#ybm_fee').val(),
        type: 'S'
    },
    {
        key: 'officeName',
        value: $('#officeId').val(),
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
            inputForm.action = "${ctx}/oa/thesis";
            inputForm.submit();
        } else {
            top.$.jBox.tip('操作失败!');
        }
    });
}
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<shiro:hasPermission name="oa:thesis:edit">
			<li><a href="${ctx}/oa/thesis/form">论文登记</a></li>
		</shiro:hasPermission>
		<li class="active"><a href="${ctx}/oa/thesis/editform">论文编辑</a></li>
		<li><a href="${ctx}/oa/thesis/list">所有任务</a></li>
		<li><a href="${ctx}/oa/thesis/task">待办任务</a></li>
	</ul>
	<br />
	<form:form id="inputForm" modelAttribute="thesis" action="${ctx}/oa/thesis/edit" method="post" class="form-horizontal">
		<form:hidden path="id" />
		<input type="hidden" id="taskId" value="${taskId}" />
		<input type="hidden" id="thesisId" value="${thesisId}" />
		<tags:message content="${message}" />
		<div class="control-group">
			<label class="control-label"><font color='red'>*</font>所属科室：</label>
			<div class="controls">
				<tags:treeselect id="office" name="office.id" value="${thesis.office.id}" labelName="office.name"
					labelValue="${thesis.office.name}" title="科室" url="/sys/office/treeData?type=2" cssClass="required"
					notAllowSelectParent="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">通讯作者：</label>
			<div class="controls">
				<tags:namesSuggest labelValue="${thesis.co_authorDisplayName}" value="${thesis.co_author}" id="co_author"
					name="co_author" url="${ctx}/sys/user/users/"></tags:namesSuggest>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">第一作者：</label>
			<div class="controls">
				<tags:namesSuggest value="${thesis.author1}" labelValue="${thesis.author1DisplayName}" name="author1" id="author1"
					url="${ctx}/sys/user/users/"></tags:namesSuggest>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">第二作者：</label>
			<div class="controls">
				<tags:namesSuggest value="${thesis.author2}" labelValue="${thesis.author2DisplayName}" name="author2" id="author2"
					url="${ctx}/sys/user/users/"></tags:namesSuggest>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">第三作者：</label>
			<div class="controls">
				<tags:namesSuggest value="${thesis.author3}" labelValue="${thesis.author3DisplayName}" name="author3" id="author3"
					url="${ctx}/sys/user/users/"></tags:namesSuggest>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><font color='red'>*</font>权属：</label>
			<div class="controls">
				<tags:nameSuggest value="${thesis.weightBelong}" cssClass="required" labelValue="${thesis.weightBelongDisplayName}"
					name="weightBelong" id="weightBelong" url="${ctx}/sys/user/users/"></tags:nameSuggest>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">关联项目：</label>
			<div class="controls">
				<form:select path="project.id">
					<form:option value=""></form:option>
					<c:forEach items="${projectList}" var="project">
						<c:if test="${project.id eq selectedId}">
							<form:option value="${project.id}" selected="selected">${project.projectName }</form:option>
						</c:if>
						<c:if test="${project.id != selectedId}">
							<form:option value="${project.id}">${project.projectName }</form:option>
						</c:if>
					</c:forEach>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><font color='red'>*</font>论文题目：</label>
			<div class="controls">
				<input id="oldTitle" name="oldTitle" type="hidden" value="${thesis.title}">
				<form:input path="title" htmlEscape="false" maxlength="200" class="input-xxlarge required" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">杂志名称：</label>
			<div class="controls">
				<form:input path="mag_name" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">年卷期：</label>
			<div class="controls">
				<form:input id="annual_volume" name="annual_volume" path="annual_volume" htmlEscape="false" maxlength="200"
					class="input-medium annual_volume" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">论文级别：</label>
			<div class="controls">
				<form:select path="level">
					<form:options items="${fns:getDictList('thesis_level_type')}" itemLabel="label" itemValue="value"
						htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">论文类别：</label>
			<div class="controls">
				<form:select path="category">
					<form:options items="${fns:getDictList('thesis_category_type')}" itemLabel="label" itemValue="value"
						htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">版面费：</label>
			<div class="controls">
				<form:input path="ybm_fee" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>

		<div class="control-group">
			<label class="control-label">论文上传：</label>
			<div class="controls">
					已上传文件：<a href="${ctx}/oa/thesis/get/${thesis.id}">${thesis.file}</a>&nbsp;&nbsp;&nbsp;&nbsp;
				<input id="file" name="file" type="hidden" value="" /> <input id="fileupload" type="file" name="files[]"
					data-url="${ctx}/oa/thesis/upload/thesis">
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
		<c:if test="${not empty taskId }">
			<div class="control-group">
				<label class="control-label">科教处意见：</label>
				<div class="controls">
					<textarea rows="5" maxlength="20" readonly="readonly">${kjDeptBackReason}</textarea>
				</div>
			</div>
		</c:if>
		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存" />&nbsp;
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)" />
		</div>
	</form:form>
</body>
</html>
