<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>经费管理</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<form:form id="inputForm" modelAttribute="expense" action="${ctx}/cms/expense/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<tags:message content="${message}"/>
		<div class="control-group">
			<label class="control-label">立项号:</label>
			<div class="controls">
				<a href="${ctx}/cms/project/form?id=${expense.project.id}">${expense.projectNo}</a>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">项目名:</label>
			<div class="controls">
				<form:input path="project.projectName" htmlEscape="false" maxlength="11" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">经费类型:</label>
			<div class="controls">
				<form:input path="dicExpenseType" htmlEscape="false" maxlength="100" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">申请人:</label>
			<div class="controls">
				<form:input path="createBy.name" htmlEscape="false" maxlength="100" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">申请时间:</label>
			<div class="controls">
				<form:input path="createDate" htmlEscape="false" maxlength="100" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">申请原因:</label>
			<div class="controls">
				<form:input path="reason" htmlEscape="false" maxlength="100" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">申请金额:</label>
			<div class="controls">
				<form:input path="amount" htmlEscape="false" maxlength="100" readonly="true"/>
			</div>
		</div>
		<div class="form-actions">
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>