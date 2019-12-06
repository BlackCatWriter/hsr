<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>合同管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#title").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					if (CKEDITOR.instances.content.getData()==""){
						top.$.jBox.tip('请填写正文','warning');
					}else{
						loading('正在提交，请稍等...');
						form.submit();
					}
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
        function rebookSubmit(reApply) {
            var taskId = $('#taskId').val();
            complete(taskId, [ {
                key : 'reApply',
                value : reApply,
                type : 'B'
            }, {
                key : 'remarks',
                value : $('#remarks').val(),
                type : 'S'
            }, {
                key : 'contentContract',
                value : $('#contentContract').val(),
                type : 'S'
            }]);
        }

        function complete(taskId, variables) {
            var keys = "", values = "", types = "";
            if (variables) {
                $.each(variables, function() {
                    if (keys != "") {
                        keys += "|";
                        values += "|";
                        types += "|";
                    }
                    keys += this.key;
                    values += this.value;
                    types += this.type;
                });
            }
            var jsonData = JSON.stringify(variables);
            $.post('${ctx}/oa/workflow/complete/' + taskId, {
                keys : keys,
                values : values,
                types : types
            }, function(resp) {
                if (resp == 'success') {
                    top.$.jBox.tip('任务完成');
                    inputForm.action = "${ctx}/oa/projectData";
                    inputForm.submit();
                } else {
                    top.$.jBox.tip('操作失败!');
                }
            });
        }
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
		<input type="hidden" id="taskId" value="${taskId}" />
		<input type="hidden" id="projectDataId" value="${projectDataId}" />
		<tags:message content="${message}"/>
		<div class="control-group">
			<label class="control-label">备注:</label>
			<div class="controls">
				<form:input path="remarks" htmlEscape="false" maxlength="200" class="input-xxlarge"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">合同内容:</label>
			<div class="controls">
				<form:textarea id="contentContract" htmlEscape="true" path="contentContract" rows="4" maxlength="200" class="input-xxlarge"/>
				<tags:ckeditor replace="contentContract" uploadPath="/oa/projectData" />
			</div>
		</div>
		<div class="form-actions">
			<c:if test="${empty taskId}">
				<input id="btnSubmit" class="btn btn-primary" type="submit" value="保存提交" />
			</c:if>
			<c:if test="${not empty taskId}">
				<input id="btnReSubmit" class="btn btn-primary" type="button" onclick="rebookSubmit(true)"
					   value="重新申请" />&nbsp;
				<input id="btnRefuseSubmit" class="btn btn-primary" type="button" onclick="rebookSubmit(false)" value="放弃申请" />&nbsp;
			</c:if>
			<a class="btn btn-primary" onclick="CKEDITOR.tools.callFunction(10, this); return false;">预 览</a>
			<a class="btn btn-primary" onclick="CKEDITOR.tools.callFunction(28, this); return false;">打 印</a>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>