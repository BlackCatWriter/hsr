<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>经费入账管理</title>
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
			location.href='${ctx}/cms/account/form?id=' + projectId;
		}
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/oa/account/form">经费填报</a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="account" action="${ctx}/cms/account/save" method="post" class="form-horizontal">
		<tags:message content="${message}"/>
		<div class="control-group">
			<label class="control-label"><font color='red'>*</font>项目名称：</label>
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
			<label class="control-label">拨款单位：</label>
			<div class="controls">
				<form:input path="approp_depart" htmlEscape="false" maxlength="200" />
			</div>
		</div>		
		<div class="control-group">
			<label class="control-label">拨款批次：</label>
			<div class="controls">
				<form:input path="approp_batch" htmlEscape="false" maxlength="200" class="required number"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">下拨经费：</label>
			<div class="controls">
				<form:input path="xb_fee" htmlEscape="false" maxlength="200" class="required number"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">配套经费：</label>
			<div class="controls">
				<form:input path="pt_fee" htmlEscape="false" maxlength="200" class="required number"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">实到经费：</label>
			<div class="controls">
				<form:input path="sd_fee" htmlEscape="false" maxlength="200" class="required number"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">拨款日期：</label>
			<div class="controls">
				<form:input id="approp_date" path="approp_date" type="text" readonly="readonly" maxlength="100" class="Wdate required"
							onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注：</label>
			<div class="controls">
				<form:textarea path="remarks" rows="5" maxlength="20" />
			</div>
		</div>
		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>
		</div>
	</form:form>
</body>
</html>
