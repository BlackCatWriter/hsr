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
                    var _money=0;
				    $("#inputForm input[name=ratios]").each(function(){
                        //累加求和
                        _money+=Number($(this).val());
					});
                    if (_money > 100) {
                        top.$.jBox.tip('项目配置比例总和不得大于100！');
                        return false;
                    }
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
		<li><a href="${ctx}/cms/account/expenseRatioList">经费预算明细</a></li>
	</ul>
	<form:form id="inputForm" action="${ctx}/cms/account/ratioSave" method="post" class="form-horizontal">
		<tags:message content="${message}" />
		<div class="control-group">
			<label class="control-label"><font color='red'>*</font>项目名称：</label>
			<div class="controls">
				<select name="project_id" class="span2 required">
					<option value=""></option>
					<c:forEach items="${projectList}" var="project">
							<option value="${project.id}" >${project.projectName }</option>
					</c:forEach>
				</select>
			</div>
		</div>
		<c:forEach items="${fns:getDictList('oa_expense_type')}" var="dict">
			<div class="control-group">
				<input type="hidden" name="expenseTypes" value="${dict.value}"/>
				<label class="control-label">${dict.label}：</label>
				<div class="controls">
					<input class="span2" name="ratios" type="text"
						   onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"
						   onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}">
					<span class="add-on">%</span>
				</div>
			</div>
		</c:forEach>
		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>
		</div>
	</form:form>
	<div style="margin-top: 8px;"></div>
</body>
</html>
