<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>专利管理</title>
<meta name="decorator" content="default" />
</head>
<body>
	<form:form id="inputForm" modelAttribute="patent" action="${ctx}/cms/patent/save" method="post" class="form-horizontal">
		<form:hidden path="id" />
		<tags:message content="${message}" />
		<div class="control-group">
			<label class="control-label">所属科室:</label>
			<div class="controls">
				<form:input path="office.name" htmlEscape="false" maxlength="200" readonly="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">专利题目:</label>
			<div class="controls">
				<form:input path="title" htmlEscape="false" maxlength="200" readonly="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">关联项目:</label>
			<div class="controls">
				<a href="${ctx}/cms/project/form?id=${patent.project.id}">${patent.projectNo}</a>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">专利链接:</label>
			<div class="controls">
				<a href="${ctx}/cms/patent/get/${patent.id}">${patent.file}</a>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">第一完成人:</label>
			<div class="controls">
				<form:input path="author1DisplayName" htmlEscape="false" maxlength="200" readonly="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">第二完成人:</label>
			<div class="controls">
				<form:input path="author2DisplayName" htmlEscape="false" maxlength="200" readonly="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">第三完成人:</label>
			<div class="controls">
				<form:input path="author3DisplayName" htmlEscape="false" maxlength="200" readonly="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">其他完成人:</label>
			<div class="controls">
				<form:input path="otherAuthorDisplayName" htmlEscape="false" maxlength="200" readonly="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">权属:</label>
			<div class="controls">
				<form:input path="weightBelongDisplayName" htmlEscape="false" maxlength="200" readonly="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">权重:</label>
			<div class="controls">
				<form:input path="weight" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">授权时间:</label>
			<div class="controls">
				<form:input path="time" htmlEscape="false" maxlength="200" readonly="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">专利号:</label>
			<div class="controls">
				<form:input path="number" htmlEscape="false" maxlength="200" readonly="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">专利类别:</label>
			<div class="controls">
				<form:input path="patentCategory" htmlEscape="false" maxlength="200" readonly="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">奖励金额:</label>
			<div class="controls">
				<form:input path="jl" htmlEscape="false" maxlength="200" readonly="true" />
			</div>
		</div>
		<div class="form-actions">
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)" />
		</div>
	</form:form>
</body>
</html>