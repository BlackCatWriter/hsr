<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>项目信息管理</title>
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
			location.href='${ctx}/oa/expense/form?id=' + projectId;
		}
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="project" action="${ctx}/oa/project/saveForFile" method="post" class="form-horizontal">
		<tags:message content="${message}"/>
		<form:input id="id" path="id" type="hidden"/>
		<input id="type" name="type" type="hidden" value="${type}"/>
		<div class="control-group">
			<label class="control-label">项目名：</label>
			<div class="controls">
				<form:input id="projectName" path="projectName" readonly="true" />
			</div>
		</div>
		<c:if test="${type =='mid' }">
		<div class="control-group">
			<label class="control-label">中期考核模板下载:</label>
			<div class="controls">
				<a href="${ctx}/cms/project/getMidTemplete/${project.id}">${project.midTermFileTemplete}</a>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">中期考核附件上传:</label>
			<div class="controls">
				<input id="file" name="midTermFile" type="hidden" value="${project.midTermFile}"/>
				<input id="fileupload" type="file" name="files[]" data-url="${ctx}/oa/project/upload/project">
			</div>
		</div>
		<div class="control-group">
			<div class="controls">
				<div id="progress" class="progress">
    				<div class="bar" style="width: 0%;"></div>
				</div>
			</div>
			<div class="controls">
			<table id="uploaded-files" class="table">
			<tr>
				<th>文件名称</th>
				<th>文件大小</th>
				<th>文件类型</th>
			</tr>
			</table>
			</div>
		</div>
		</c:if>
		
		<c:if test="${type =='midTemplete' }">
		<div class="control-group">
			<label class="control-label">中期考核模板下载:</label>
			<div class="controls">
				<a href="${ctx}/cms/project/getMidTemplete/${project.id}">${project.midTermFileTemplete}</a>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">中期考核模板附件上传:</label>
			<div class="controls">
				<input id="file" name="midTermFileTemplete" type="hidden" value="${project.midTermFileTemplete}"/>
				<input id="fileupload" type="file" name="files[]" data-url="${ctx}/oa/project/upload/project">
			</div>
		</div>
		<div class="control-group">
			<div class="controls">
				<div id="progress" class="progress">
    				<div class="bar" style="width: 0%;"></div>
				</div>
			</div>
			<div class="controls">
			<table id="uploaded-files" class="table">
			<tr>
			<th>文件名称</th>
			<th>文件大小</th>
			<th>文件类型</th>
			</tr>
			</table>
			</div>
		</div>
		</c:if>
		
		<c:if test="${type =='endTemplete' }">
		<div class="control-group">
			<label class="control-label">结题模板下载:</label>
			<div class="controls">
				<a href="${ctx}/cms/project/getEndTemplete/${project.id}">${project.endFileTemplete}</a>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">结题模板附件上传:</label>
			<div class="controls">
				<input id="file" name="endFileTemplete" type="hidden" value="${project.endFileTemplete}"/>
				<input id="fileupload" type="file" name="files[]" data-url="${ctx}/oa/project/upload/project">
			</div>
		</div>
		<div class="control-group">
			<div class="controls">
				<div id="progress" class="progress">
    				<div class="bar" style="width: 0%;"></div>
				</div>
			</div>
			<div class="controls">
			<table id="uploaded-files" class="table">
			<tr>
			<th>文件名称</th>
			<th>文件大小</th>
			<th>文件类型</th>
			</tr>
			</table>
			</div>
		</div>
		</c:if>
		<c:if test="${type == 'end' }">
		<div class="control-group">
			<label class="control-label">结题模板下载:</label>
			<div class="controls">
				<a href="${ctx}/cms/project/getEndTemplete/${project.id}">${project.endFileTemplete}</a>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">结题附件上传:</label>
			<div class="controls">
				<input id="file" name="endFile" type="hidden" value="${project.endFile}"/>
				<input id="fileupload" type="file" name="files[]" data-url="${ctx}/oa/project/upload/project">
			</div>
		</div>
		<div class="control-group">
			<div class="controls">
				<div id="progress" class="progress">
    				<div class="bar" style="width: 0%;"></div>
				</div>
			</div>
			<div class="controls">
			<table id="uploaded-files" class="table">
			<tr>
			<th>文件名称</th>
			<th>文件大小</th>
			<th>文件类型</th>
			</tr>
			</table>
			</div>
		</div>
		</c:if>
		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>
