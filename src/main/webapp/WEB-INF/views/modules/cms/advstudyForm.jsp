<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>进修管理</title>
	<meta name="decorator" content="default"/>
</head>
<body>
	<form:form id="inputForm" modelAttribute="advstudy" action="${ctx}/cms/advstudy/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<tags:message content="${message}"/>
				<div class="control-group">
			<label class="control-label">所属科室:</label>
			<div class="controls">
				<form:input path="office.name" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">申请人:</label>
			<div class="controls">
				<form:input path="user.name" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">职称：</label>
			<div class="controls">
				<form:input path="worktitle" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">进修方向:</label>
			<div class="controls">
				<form:input path="advstudyDirection" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">开始时间：</label>
			<div class="controls">
				<fmt:formatDate value="${advstudy.startDate}" pattern="yyyy-MM-dd" type="both"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">结束时间：</label>
			<div class="controls">
				<fmt:formatDate value="${advstudy.endDate}" pattern="yyyy-MM-dd" type="both"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">进修单位:</label>
			<div class="controls">
				<form:input path="hostUnit" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>	
		</div>
		<div class="control-group">
			<label class="control-label">报销金额:</label>
			<div class="controls">
				<form:input path="academiccost.bxFee" htmlEscape="false" maxlength="200" readonly="true"/>
			</div>
		</div>
		<div class="control-group">			
			<label class="control-label">已上传附件:</label>
			<div class="controls">
				<a href="${ctx}/cms/advstudy/get/${advstudy.id}">${advstudy.file}</a>
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