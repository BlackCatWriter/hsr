<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>专利登记管理</title>
<meta name="decorator" content="default" />
<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/vendor/jquery.ui.widget.js"></script>
<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/jquery.iframe-transport.js"></script>
<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/jquery.fileupload.js"></script>
<script src="${ctxStatic}/bootstrap/2.3.1/js/bootstrap.min.js"></script>
<link href="${ctxStatic}/common/dropzone.css" type="text/css" rel="stylesheet" />
<script src="${ctxStatic}/common/myuploadfunction.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    $("#title").focus();
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
                    url: "${ctx}/oa/patent/checkTitle",
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
                remote: "专利题目已存在!"
            }
        }
    });
    jQuery.validator.addMethod("jl",
    function(value, element) {
        if (value == "") {
            return true;
        }
        var decimal = /^[0-9]+([\.][0-9]{0,3})?$/;
        return (decimal.test(value));
    },
    "请输入正确的奖励金额(格式:xx.xx)");
});
function cleanSuggestWords() {
    $("#otherAuthorkeyword").val('');
    $("#author1keyword").val('');
    $("#author2keyword").val('');
    $("#author3keyword").val('');
    $("#weightBelongkeyword").val('');
}

function repatentSubmit(reApply) {
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
        key: 'otherAuthor',
        value: $('#otherAuthorId').val(),
        type: 'S'
    },
    {
        key: 'officeName',
        value: $('#officeId').val(),
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
        key: 'time',
        value: $('#time').val(),
        type: 'S'
    },
    {
        key: 'number',
        value: $('#number').val(),
        type: 'S'
    },
    {
        key: 'profession',
        value: $('#profession').val(),
        type: 'S'
    },
    {
        key: 'category',
        value: $('#category').val(),
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
            inputForm.action = "${ctx}/oa/patent";
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
		<li class="active"><a href="${ctx}/oa/patent/form">专利登记</a></li>
		<li class="active"><a href="${ctx}/oa/patent/editform">专利编辑</a></li>
		<li><a href="${ctx}/oa/patent/list">所有任务</a></li>
		<li><a href="${ctx}/oa/patent/task">待办任务</a></li>
	</ul>
	<br />
	<form:form id="inputForm" modelAttribute="patent" action="${ctx}/oa/patent/edit" method="post" class="form-horizontal">
		<form:hidden path="id" />
		<input type="hidden" id="taskId" value="${taskId}" />
		<input type="hidden" id="patentId" value="${patentId}" />
		<tags:message content="${message}" />
		<div class="control-group">
			<label class="control-label"><font color='red'>*</font>所属科室：</label>
			<div class="controls">
				<tags:treeselect id="office" name="office.id" value="${patent.office.id}" labelName="office.name"
					labelValue="${patent.office.name}" title="科室" url="/sys/office/treeData?type=2" cssClass="required"
					notAllowSelectParent="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><font color='red'>*</font>第一完成人：</label>
			<div class="controls">
				<tags:nameSuggest value="${patent.author1}" labelValue="${patent.author1DisplayName}" cssClass="required"
					name="author1" id="author1" url="${ctx}/sys/user/users/"></tags:nameSuggest>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">第二完成人：</label>
			<div class="controls">
				<tags:nameSuggest value="${patent.author2}" labelValue="${patent.author2DisplayName}" name="author2" id="author2"
					url="${ctx}/sys/user/users/"></tags:nameSuggest>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">第三完成人：</label>
			<div class="controls">
				<tags:nameSuggest value="${patent.author3}" labelValue="${patent.author3DisplayName}" name="author3" id="author3"
					url="${ctx}/sys/user/users/"></tags:nameSuggest>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">其他完成人：</label>
			<div class="controls">
				<tags:namesSuggest labelValue="${patent.otherAuthorDisplayName}" value="${patent.otherAuthor}" id="otherAuthor"
					name="otherAuthor" url="${ctx}/sys/user/users/"></tags:namesSuggest>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><font color='red'>*</font>权属：</label>
			<div class="controls">
				<tags:nameSuggest value="${patent.weightBelong}" cssClass="required" labelValue="${patent.weightBelongDisplayName}"
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
			<label class="control-label"><font color='red'>*</font>专利题目：</label>
			<div class="controls">
				<input id="oldTitle" name="oldTitle" type="hidden" value="${patent.title}">
				<form:input id="title" path="title" htmlEscape="false" maxlength="200" class="input-xxlarge required" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><font color='red'>*</font>专利号：</label>
			<div class="controls">
				<form:input id="number" path="number" htmlEscape="false" maxlength="200" class="input-xxlarge required" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">授权时间：</label>
			<div class="controls">
				<form:input path="time"  type="text" readonly="readonly" maxlength="20" class="input-medium Wdate" style="width:163px;"
					onclick="WdatePicker({dateFmt:'yyyy'});"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">专业：</label>
			<div class="controls">
				<form:input id="profession" name="profession" path="profession" htmlEscape="false" maxlength="200"
					class="input-medium " />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">专利类别：</label>
			<div class="controls">
				<form:select id="category" path="category">
					<form:options items="${fns:getDictList('patent_category_type')}" itemLabel="label" itemValue="value"
						htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">专利上传：</label>
			<div class="controls">
					已上传文件：<a href="${ctx}/oa/patent/get/${patent.id}">${patent.file}</a>
				<input id="file" name="file" type="hidden" value="" /> <input id="fileupload" type="file" name="files[]"
					data-url="${ctx}/oa/patent/upload/patent">
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
</body>
</html>
