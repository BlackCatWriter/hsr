<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>科研成果管理</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<form:form id="inputForm" modelAttribute="achievement" action="${ctx}/cms/achievement/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<tags:message content="${message}"/>
				<div class="control-group">
			<label class="control-label">所属科室:</label>
			<div class="controls">
				<form:input path="office.name" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">专业:</label>
			<div class="controls">
				<form:input path="major" htmlEscape="false" maxlength="200" class="input-xxlarge required"/>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">第一完成人:</label>
			<div class="controls">
				<form:input path="author1DisplayName" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">第二完成人:</label>
			<div class="controls">
				<form:input path="author2DisplayName" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">第三完成人:</label>
			<div class="controls">
				<form:input path="author3DisplayName" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">权属:</label>
			<div class="controls">
				<form:input path="weightBelongDisplayName" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">关联项目：</label>
			<div class="controls">
				<form:select path="project.id" class="required">
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
			<label class="control-label">项目名称:</label>
			<div class="controls">
				<form:input path="projectName" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">奖励级别:</label>
			<div class="controls">
				<form:input path="achievementAwardLevel" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>	
				<div class="control-group">
			<label class="control-label">奖励等级:</label>
			<div class="controls">
				<form:input path="achievementJlLevel" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">奖励金额:</label>
			<div class="controls">
				<form:input path="jl" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">院配套奖励金额:</label>
			<div class="controls">
				<form:input path="yjl" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注:</label>
			<div class="controls">
				<form:input path="remarks" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="form-actions">
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>