<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>合同信息</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
            CKEDITOR.config.readOnly = true;
        });
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/oa/projectData/list">合同列表</a></li>
		<li><a href="${ctx}/oa/projectData/task">待办任务</a></li>
		<li class="active"><a href="javascript:void(0);">合同详情</a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="projectData" action="${ctx}/oa/projectData/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<tags:message content="${message}"/>
		<div class="control-group">
			<label class="control-label">备注:</label>
			<div class="controls">
				<form:input path="remarks" htmlEscape="false" maxlength="200" disabled="true" class="input-xxlarge"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">合同内容:</label>
			<div class="controls">
				<form:textarea id="contentContract" htmlEscape="true" path="contentContract" rows="4" maxlength="200" class="input-xxlarge"/>
				<tags:ckeditor replace="contentContract" uploadPath="/oa/projectData" />
			</div>
		</div>
	</form:form>
</body>
</html>