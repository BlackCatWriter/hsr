<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>经费预算管理</title>
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
			$("#inputForm").validate({
				submitHandler: function(form){
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

	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/cms/account/expenseRatioForm">经费预算管理</a></li>
	</ul>
	<form:form id="inputForm" action="${ctx}/cms/account/ratioSave" method="post" class="breadcrumb form-search">
		<div class="control-group">
			<div class="controls">
				<label class="control-label" >项目名称：</label>
				<%--<form:select path="project.id">
					<option value="" label="" />
					<form:options items="${projectList}" itemLabel="projectName" itemValue="id" htmlEscape="false" />
				</form:select>&nbsp;--%>
				<select name="project_id" class="span2 required">
					<option value=""></option>
					<c:forEach items="${projectList}" var="project">
							<option value="${project.id}" >${project.projectName }</option>
					</c:forEach>
				</select>
			</div>
		</div>
		<div class="control-group">
			<c:forEach items="${fns:getDictList('oa_expense_type')}" var="dict">
				<input type="hidden" name="expenseTypes" value="${dict.value}"/>
				<div class="input-append">
					<span class="add-on">${dict.label}</span>
					<input class="span2" name="ratios" type="text"
						   onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"
						   onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}">
					<span class="add-on">%</span>
				</div>
			</c:forEach>
			&nbsp;&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>
		</div>
	</form:form>
	<div style="margin-top: 8px;"></div>
	<tags:message content="${message}" />
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
		<tr>
			<th>立项号</th>
			<th>项目名</th>
			<th>经费类型</th>
			<th>报销比例</th>
			<th>备注</th>
		</tr>
		</thead>
		<tbody>
		<c:forEach items="${ratioList.list}" var="ratio">
			<tr>
				<th>${ratio.projectNo}</th>
				<td>${ratio.project.projectName}</td>
				<td>${ratio.expense_name}</td>
				<td>${ratio.ratio}</td>
				<td>${ratio.remarks}</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${ratioList}</div>
</body>
</html>
