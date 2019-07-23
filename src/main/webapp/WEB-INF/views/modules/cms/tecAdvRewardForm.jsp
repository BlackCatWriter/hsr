<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>院重大实用领先技术奖内容</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<form:form id="inputForm" modelAttribute="reward" action="${ctx}/cms/tecAdvReward/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<tags:message content="${message}"/>
		<div class="control-group">
			<label class="control-label">院重大实用领先技术奖:</label>
			<div class="controls">
				<form:input path="rewardName" htmlEscape="false" maxlength="200" readonly="true"/>
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
				<form:input path="author3DisplayName"  htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">关联项目:</label>
			<div class="controls">
				<a href="${ctx}/cms/project/form?id=${reward.project.id}">${reward.projectNo}</a>
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
				<a href="${ctx}/cms/tecAdvReward/get/${reward.id}">${reward.file}</a>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">获奖级别:</label>
			<div class="controls">
				<form:input value="${tecRewardGrade}" path="tecRewardGrade" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">获奖等级:</label>
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
			<label class="control-label">第一年病例数:</label>
			<div class="controls">
				<form:input value="${caseCountFirst}" path="caseCountFirst" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">奖励1:</label>
			<div class="controls">
				<form:input value="${jlFirst}" path="jlFirst" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">第二年病例数:</label>
			<div class="controls">
				<form:input value="${caseCountSecond}" path="caseCountSecond" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">奖励2:</label>
			<div class="controls">
				<form:input value="${jlSecond}" path="jlSecond" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="form-actions">
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>