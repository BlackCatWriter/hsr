<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>论文管理</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<form:form id="inputForm" modelAttribute="thesis" action="${ctx}/cms/thesis/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<tags:message content="${message}"/>
				<div class="control-group">
			<label class="control-label">所属科室:</label>
			<div class="controls">
				<form:input path="office.name" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">论文题目:</label>
			<div class="controls">
				<form:input path="title" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">关联项目:</label>
			<div class="controls">
				<a href="${ctx}/cms/project/form?id=${thesis.project.id}">${thesis.projectNo}</a>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">论文链接:</label>
			<div class="controls">
				<a href="${ctx}/cms/thesis/get/${thesis.id}">${thesis.file}</a>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">通讯作者:</label>
			<div class="controls">
				<form:input path="co_authorDisplayName" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">作者1:</label>
			<div class="controls">
				<form:input path="author1DisplayName" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">作者2:</label>
			<div class="controls">
				<form:input path="author2DisplayName" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">作者3:</label>
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
			<label class="control-label">权重:</label>
			<div class="controls">
				<form:input path="weight" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">杂志名称:</label>
			<div class="controls">
				<form:input path="mag_name" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">发表年限:</label>
			<div class="controls">
				<form:input path="annual_volume" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">论文等级:</label>
			<div class="controls">
				<form:input path="thesisLevel" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>	
				<div class="control-group">
			<label class="control-label">论文类别:</label>
			<div class="controls">
				<form:input path="thesisCategory" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
				<div class="control-group">
			<label class="control-label">版面费:</label>
			<div class="controls">
				<form:input path="ybm_fee" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">报销金额:</label>
			<div class="controls">
				<form:input path="bx_fee" htmlEscape="false" maxlength="200" readonly="true"/>
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