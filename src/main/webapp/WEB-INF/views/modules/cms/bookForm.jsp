<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>著作管理</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<form:form id="inputForm" modelAttribute="book" action="${ctx}/cms/book/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<tags:message content="${message}"/>
				<div class="control-group">
			<label class="control-label">所属科室:</label>
			<div class="controls">
				<form:input path="office.name" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">关联项目:</label>
			<div class="controls">
				<a href="${ctx}/cms/project/form?id=${book.project.id}">${book.projectNo}</a>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">著作题目:</label>
			<div class="controls">
				<form:input path="title" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">著作链接:</label>
			<div class="controls">
				<a href="${ctx}/cms/book/get/${book.id}">${book.file}</a>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">作者:</label>
			<div class="controls">
				<form:input path="author1DisplayName" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">专业:</label>
			<div class="controls">
				<form:input path="profession" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">权属:</label>
			<div class="controls">
				<form:input path="weightBelongDisplayName" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">权重:</label>
			<div class="controls">
				<form:input path="weight" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">年限:</label>
			<div class="controls">
				<form:input path="time" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">出版社:</label>
			<div class="controls">
				<form:input path="publisher" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>	
		<div class="control-group">
			<label class="control-label">书刊号:</label>
			<div class="controls">
				<form:input path="number" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>	
		<div class="control-group">
			<label class="control-label">担任角色:</label>
			<div class="controls">
				<form:input path="bookRole" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">承担部分字数:</label>
			<div class="controls">
				<form:input path="letters" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">奖励金额:</label>
			<div class="controls">
				<form:input path="jl" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="form-actions">
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>