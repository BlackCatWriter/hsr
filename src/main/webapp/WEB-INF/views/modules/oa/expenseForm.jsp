<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>经费管理</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/vendor/jquery.ui.widget.js"></script>
	<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/jquery.iframe-transport.js"></script>
	<script src="${ctxStatic}/jQuery-File-Upload-9.9.3/js/jquery.fileupload.js"></script>
	<script src="${ctxStatic}/bootstrap/2.3.1/js/bootstrap.min.js"></script>
	<link href="${ctxStatic}/bootstrap/2.3.1/css_default/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="${ctxStatic}/common/dropzone.css" type="text/css" rel="stylesheet" />
	<script src="${ctxStatic}/common/myuploadfunction.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#uploaded-files").hide();
			$("#name").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
		});
		
		function projectChange(projectId){
			location.href='${ctx}/oa/expense/form?id=' + projectId;
		}
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/oa/expense/projectlist">项目管理</a></li>
		<shiro:hasPermission name="oa:expense:edit"><li class="active"><a href="${ctx}/oa/expense/form">经费申请</a></li></shiro:hasPermission>
		<li><a href="${ctx}/oa/expense/list">所有任务</a></li>
		<li><a href="${ctx}/oa/expense/task">待办任务</a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="expense" action="${ctx}/oa/expense/save" method="post" class="form-horizontal">
		<tags:message content="${message}"/>
		<div class="control-group">
			<label class="control-label"><font color='red'>*</font>项目名：</label>
			<div class="controls">
				<form:select path="project.id" class="required"  onchange="projectChange(this.value);">
				<form:option value=""></form:option>
				<c:forEach items="${projectList}" var="project">
					<c:if test="${project.id eq selectedId}">
						<form:option value="${project.id}" selected="selected">${project.projectName }</form:option>
					</c:if>
					<c:if test="${project.id != selectedId}">
						<form:option value="${project.id}">${project.projectName}</form:option>
					</c:if>
				</c:forEach>
				</form:select>
			</div>
		</div>		
		<div class="control-group">
			<label class="control-label">项目总经费：</label>
			<div class="controls">
				<form:input id="wholeFee" path="" value="${expenseModel.wholeFee}" readonly="true" />
			</div>
		</div>		
		<div class="control-group">
			<label class="control-label">项目实到总经费：</label>
			<div class="controls">
				<form:input id="totalFee" path="" value="${expenseModel.totalFee}" readonly="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">项目已使用经费：</label>
			<div class="controls">
				<form:input id="usedFee"  path="" value="${expenseModel.usedFee}" readonly="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">项目剩余经费：</label>
			<div class="controls">
				<form:input  id="remaindFee"  path="" value="${expenseModel.remaindFee}" readonly="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">经费类型：</label>
			<div class="controls">
				<form:select path="expenseType" >
					<form:options items="${fns:getDictList('oa_expense_type')}" itemLabel="label" itemValue="value" htmlEscape="false" />
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><font color='red'>*</font>申请原因：</label>
			<div class="controls">
				<form:textarea path="reason" class="required" rows="5" maxlength="20"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">数额：</label>
			<div class="controls">
				<form:input path="amount" name="amount" class="required number"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">附件上传:</label>
			<c:if test="${not empty taskId }">
				<div class="controls">
						已上传文件：<a href="${ctx}/cms/project/get/${expense.id}">${expense.file}</a>
				</div>
			</c:if>
			<div class="controls">
				<input id="file" name="file" type="hidden" value="${expense.file}"/>
				<input id="fileupload" type="file" name="files[]" data-url="${ctx}/oa/expense/upload/expense">
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
		<div class="form-actions">
			<shiro:hasPermission name="oa:expense:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>
