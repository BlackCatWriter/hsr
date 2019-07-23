<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>新技术引进奖内容</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<form:form id="inputForm" modelAttribute="reward" action="${ctx}/cms/newTecReward/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<tags:message content="${message}"/>
		<div class="control-group">
			<label class="control-label">新技术引进奖名称:</label>
			<div class="controls">
				<form:input path="rewardName" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">关联项目:</label>
			<div class="controls">
				<a href="${ctx}/cms/project/form?id=${reward.project.id}">${reward.projectNo}</a>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">第一责任人:</label>
			<div class="controls">
				<form:input path="author1DisplayName" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">第二责任人:</label>
			<div class="controls">
				<form:input path="author2DisplayName" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">第三责任人:</label>
			<div class="controls">
				<form:input path="author3DisplayName"  htmlEscape="false" maxlength="200" readonly="true"/>
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
			<label class="control-label">所属科室:</label>
			<div class="controls">
				<form:input path="office.name" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">专业:</label>
			<div class="controls">
				<form:input path="profession" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">附件链接:</label>
			<div class="controls">
				<a href="${ctx}/cms/newTecReward/get/${reward.id}">${reward.file}</a>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">奖励单位:</label>
			<div class="controls">
				<form:input value="${approvalOrg}" path="approvalOrg" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">新技术引进奖级别:</label>
			<div class="controls">
				<form:input value="${rewardGrade}" path="rewardGrade" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">新技术引进奖等级:</label>
			<div class="controls">
				<form:input value="${rewardLevel}" path="rewardLevel" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">获奖年限:</label>
			<div class="controls">
				<form:input value="${year}" path="year" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">奖励经费:</label>
			<div class="controls">
				<form:input value="${xb_fee}" path="xb_fee" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">配套经费:</label>
			<div class="controls">
				<form:input value="${pt_fee}" path="pt_fee" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="form-actions">
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>